#include <stdio.h>
// #include <cuda.h>

#include <iostream>
#include <random>
#include <chrono>

#define DIM 2048
#define N (DIM*DIM)
#define THREAD_PER_BLOCK 512

__global__ void add(int* a, int* b, int* c)
{
    int index = threadIdx.x + blockIdx.x * blockDim.x;
    c[index] = a[index] + b[index];
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

// nvcc -o bin/exo2 src/exo2.cu
int main(void)
{
    int *a, *b, *c;
    int *d_a, *d_b, *d_c;
    int size = N * sizeof(int);

    cudaMalloc((void**)&d_a, size);
    cudaMalloc((void**)&d_b, size);
    cudaMalloc((void**)&d_c, size);

    a = (int*)malloc(size);
    randomInts(a, N);
    b = (int*)malloc(size);
    randomInts(b, N);
    c = (int*)malloc(size);

    cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, size, cudaMemcpyHostToDevice);

    auto t1 = std::chrono::high_resolution_clock::now();

    add<<<N/THREAD_PER_BLOCK,THREAD_PER_BLOCK>>>(d_a, d_b, d_c);

    auto t2 = std::chrono::high_resolution_clock::now();

    cudaMemcpy(c, d_c, size, cudaMemcpyDeviceToHost);

    // j'affiche les 3 premières lignes/col de la mat1, mat2
    // et mat résultat
    printMatrix(a, DIM);
    printMatrix(b, DIM);
    printMatrix(c, DIM);

    auto int_us = std::chrono::duration_cast<std::chrono::microseconds>(t2 - t1);
    std::cout<<"done in "<<int_us.count()<<" μs"<<std::endl;

    free(a);
    free(b);
    free(c);
    cudaFree(d_a); 
    cudaFree(d_b); 
    cudaFree(d_c);

    return 0;
}