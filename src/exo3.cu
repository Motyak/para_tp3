#include <stdio.h>
// #include <cuda.h>

#include <iostream>
#include <random>
#include <chrono>

#define NB_OF_ELEM 16777216
#define DIM 4096
#define MAX_NB_THREADS 1024
//nb de mesures pour le calcul du temps moyen d'execution
#define SAMPLE_SIZE 10

__global__ void multiply(int* a, int* b, int* c)
{
    // // je calcule le nombre de threads dans la grid,
    // // sa racine carré correspond a la dim des matrices
    // int dim = sqrtf(gridDim.x * blockDim.x);

    int index_c = threadIdx.x + blockIdx.x * blockDim.x;
    int index_a = ((int)(index_c / DIM)) * DIM;
    int index_b = index_c % DIM;

    c[index_c] = 0;
    for(int i = 0 ; i < DIM ; ++i)
    {
        c[index_c] += a[index_a] * b[index_b];
        ++index_a;      //pas de 1
        index_b += DIM; //pas de dim
    }
}

void randomInts(int* a, int size)
{
    std::random_device random;
    for (int i = 0 ; i < size ; ++i)
        a[i] = random() % 1000;
}

void printMatrix(int* m, int dim)
{
    printf("matrix %p :\n", m);
    for(int i = 0 ; i < 3 ; ++i)
    {
        for(int j = 0 ; j < 2 ; ++j)
            printf("%d\t", m[i+j*dim]);
        printf("%d...\n", m[i+2*dim]);
    }
    printf("...\n\n");
}

void resultTest()
{
    printf("DEBUT TEST RESULTAT\n");

    int *a, *b, *c;
    int *d_a, *d_b, *d_c;
    int size = NB_OF_ELEM * sizeof(int);

    cudaMalloc((void**)&d_a, size);
    cudaMalloc((void**)&d_b, size);
    cudaMalloc((void**)&d_c, size);

    a = (int*)malloc(size); randomInts(a, NB_OF_ELEM);
    b = (int*)malloc(size); randomInts(b, NB_OF_ELEM);
    c = (int*)malloc(size);

    cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, size, cudaMemcpyHostToDevice);

    multiply<<<NB_OF_ELEM/MAX_NB_THREADS,MAX_NB_THREADS>>>(d_a, d_b, d_c);

    cudaMemcpy(c, d_c, size, cudaMemcpyDeviceToHost);

    // j'affiche les 3 premières lignes/col de la mat1, mat2
    // et mat résultat
    printMatrix(a, DIM);    printMatrix(b, DIM);    printMatrix(c, DIM);

    free(a);        free(b);        free(c);
    cudaFree(d_a);  cudaFree(d_b);  cudaFree(d_c);

    printf("FIN TEST RESULTAT\n\n");
}

void speedTest(int nbOfBlocks, int nbThreadsPerBlock)
{
    printf("%d BLOCS ET %d THREADS/BLOC\n", nbOfBlocks, nbThreadsPerBlock);

    int *a, *b, *c;
    int *d_a, *d_b, *d_c;
    int size = NB_OF_ELEM * sizeof(int);

    cudaMalloc((void**)&d_a, size);
    cudaMalloc((void**)&d_b, size);
    cudaMalloc((void**)&d_c, size);

    a = (int*)malloc(size); 
    b = (int*)malloc(size); 
    c = (int*)malloc(size);

    int t_ns = 0;

    for(int i = 1 ; i <= SAMPLE_SIZE ; ++i)
    {
        randomInts(a, NB_OF_ELEM);
        randomInts(b, NB_OF_ELEM);
        cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice);
        cudaMemcpy(d_b, b, size, cudaMemcpyHostToDevice);
        auto t1 = std::chrono::high_resolution_clock::now();
        multiply<<<nbOfBlocks,nbThreadsPerBlock>>>(d_a, d_b, d_c);
        auto t2 = std::chrono::high_resolution_clock::now();
        std::cout<<std::chrono::duration_cast<std::chrono::nanoseconds>(t2 - t1).count()<<std::endl;
        t_ns += std::chrono::duration_cast<std::chrono::nanoseconds>(t2 - t1).count();
    }

    std::cout<<"done in "<<t_ns / SAMPLE_SIZE <<" ns (in average)"<<std::endl<<std::endl;

    free(a);        free(b);        free(c);
    cudaFree(d_a);  cudaFree(d_b);  cudaFree(d_c);
}

// nvcc -o bin/exo3 src/exo3.cu
int main(void)
{
    resultTest();

    printf("DEBUT TESTS DE VITESSE\n");
    speedTest(NB_OF_ELEM, 1);
    speedTest(524288, 32);
    speedTest(NB_OF_ELEM/MAX_NB_THREADS, MAX_NB_THREADS);
    printf("FIN TESTS DE VITESSE\n");

    return 0;
}