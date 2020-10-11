#include <stdio.h>
// #include <cuda.h>

#include <iostream>
#include <random>
#include <chrono>

#define NB_OF_ELEM 16777216
#define MAX_NB_THREADS 1024
//nb de mesures pour le calcul du temps moyen d'execution
#define SAMPLE_SIZE 10

__global__ void add(int* a, int* b, int* c)
{
    int index = threadIdx.x + blockIdx.x * blockDim.x;
    c[index] = a[index] + b[index];
}

void randomInts(int* a, int nbOfElem)
{
    std::random_device random;
    for (int i = 0 ; i < nbOfElem ; ++i)
        a[i] = random() % 1000;
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

    add<<<NB_OF_ELEM/MAX_NB_THREADS,MAX_NB_THREADS>>>(d_a, d_b, d_c);

    cudaMemcpy(c, d_c, size, cudaMemcpyDeviceToHost);

    // j'affiche que les 10 premieres pour verifier
    for(int i = 0 ; i < 10 ; ++i)
        printf("%d + %d = %d\n", a[i], b[i], c[i]);

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
        add<<<nbOfBlocks,nbThreadsPerBlock>>>(d_a, d_b, d_c);
        auto t2 = std::chrono::high_resolution_clock::now();
        std::cout<<std::chrono::duration_cast<std::chrono::nanoseconds>(t2 - t1).count()<<std::endl;
        t_ns += std::chrono::duration_cast<std::chrono::nanoseconds>(t2 - t1).count();
    }

    std::cout<<"done in "<<t_ns / SAMPLE_SIZE <<" ns (in average)"<<std::endl<<std::endl;

    free(a);        free(b);        free(c);
    cudaFree(d_a);  cudaFree(d_b);  cudaFree(d_c);
}

// nvcc -o bin/exo1 src/exo1.cu
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