#include <stdio.h>
// #include <cuda.h>

#include <random>

#define N 512

__global__ void add(int* a, int* b, int* c)
{
    c[blockIdx.x] = a[blockIdx.x] + b[blockIdx.x];
}

void randomInts(int* a, int size)
{
    std::random_device random;
    for (int i = 0 ; i < size ; ++i)
        a[i] = random() % 1000;
}

// nvcc -o bin/exo1 src/exo1.cu
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

    add<<<N,1>>>(d_a, d_b, d_c);

    cudaMemcpy(c, d_c, size, cudaMemcpyDeviceToHost);

    for(int i = 0 ; i < N ; ++i)
        printf("%d + %d = %d\n", a[i], b[i], c[i]);

    free(a);
    free(b);
    free(c);
    cudaFree(d_a); 
    cudaFree(d_b); 
    cudaFree(d_c);

    return 0;
}