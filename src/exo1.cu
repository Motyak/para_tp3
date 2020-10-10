#include <stdio.h>
// #include <cuda.h>

#include <iostream>
#include <random>
#include <chrono>

#define NB_OF_ELEM 16777216
#define MAX_NB_THREADS 1024

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

// nvcc -o bin/exo1 src/exo1.cu
int main(void)
{
    int *a, *b, *c;
    int *d_a, *d_b, *d_c;
    int size = NB_OF_ELEM * sizeof(int);

    cudaMalloc((void**)&d_a, size);
    cudaMalloc((void**)&d_b, size);
    cudaMalloc((void**)&d_c, size);

    a = (int*)malloc(size);
    randomInts(a, NB_OF_ELEM);
    b = (int*)malloc(size);
    randomInts(b, NB_OF_ELEM);
    c = (int*)malloc(size);

    cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, size, cudaMemcpyHostToDevice);

    auto t1 = std::chrono::high_resolution_clock::now();

    add<<<16384,1024>>>(d_a, d_b, d_c);

    auto t2 = std::chrono::high_resolution_clock::now();

    cudaMemcpy(c, d_c, size, cudaMemcpyDeviceToHost);

    // j'affiche que les 10 premieres pour verifier
    for(int i = 0 ; i < 10 ; ++i)
        printf("%d + %d = %d\n", a[i], b[i], c[i]);

    auto int_ns = std::chrono::duration_cast<std::chrono::nanoseconds>(t2 - t1);
    std::cout<<"done in "<<int_ns.count()<<" ns"<<std::endl;

    free(a);
    free(b);
    free(c);
    cudaFree(d_a); 
    cudaFree(d_b); 
    cudaFree(d_c);

    return 0;
}