// FAIRE LA MEME CHOSE QUE EXO1,
// TOUT DANS UN TABLEAU UNIDIMENSIONNEL
// POUR QUE LES DONNES SOIENT CONTINGENTES DANS
// LA MEMOIRE (POUR LE MEMCOPY HOST<=>DEVICE
// https://www.nvidia.com/docs/IO/116711/sc11-cuda-c-basics.pdf

// #include <stdio.h>
// // #include <cuda.h>

// #include <iostream>
// #include <random>
// #include <chrono>

// #define DIM 2048

// __global__ void add(int** a, int** b, int** c)
// {
//     int& i = blockIdx.x;
//     int& j = threadIdx.x;
//     c[i][j] = a[i][j] + b[i][j];
// }

// void randomInts(int** a, int dim)
// {
//     std::random_device random;
//     for (int i = 0 ; i < dim ; ++i)
//         for (int j = 0 ; j < dim ; ++j)
//             a[i][j] = random() % 1000;
// }

// // nvcc -o bin/exo1 src/exo1.cu
// int main(void)
// {
//     int **a, **b, **c;
//     int **d_a, **d_b, **d_c;
//     int size = DIM * sizeof(int);

//     cudaMalloc((void**)&d_a, size);
//     for(int i = 0 ; i < DIM ; ++i)
//         cudaMalloc((void**)&d_a[i], size);

//     cudaMalloc((void**)&d_b, size);
//     for(int i = 0 ; i < DIM ; ++i)
//         cudaMalloc((void**)&d_b[i], size);

//     cudaMalloc((void**)&d_c, size);
//     for(int i = 0 ; i < DIM ; ++i)
//         cudaMalloc((void**)&d_c[i], size);

//     a = (int*)malloc(size);
//     for(int i = 0 ; i < DIM ; ++i)
//         a[i] = (int*)malloc(size);
//     randomInts(a, DIM);
//     b = (int*)malloc(size);
//     for(int i = 0 ; i < size ; ++i)
//         b[i] = (int*)malloc(size);
//     randomInts(b, DIM);
//     c = (int*)malloc(size);
//     for(int i = 0 ; i < DIM ; ++i)
//         c[i] = (int*)malloc(size);

//     cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice);
//     cudaMemcpy(d_b, b, size, cudaMemcpyHostToDevice);

//     auto t1 = std::chrono::high_resolution_clock::now();

//     add<<<N/THREAD_PER_BLOCK,THREAD_PER_BLOCK>>>(d_a, d_b, d_c);

//     auto t2 = std::chrono::high_resolution_clock::now();

//     cudaMemcpy(c, d_c, size, cudaMemcpyDeviceToHost);

//     // j'affiche que les 10 premieres pour verifier
//     for(int i = 0 ; i < 10 ; ++i)
//         printf("%d + %d = %d\n", a[i], b[i], c[i]);

//     auto int_us = std::chrono::duration_cast<std::chrono::microseconds>(t2 - t1);
//     std::cout<<"done in "<<int_us.count()<<" μs"<<std::endl;

//     free(a);
//     free(b);
//     free(c);
//     cudaFree(d_a); 
//     cudaFree(d_b); 
//     cudaFree(d_c);

//     return 0;
// }