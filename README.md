# TO BUILD
```console
foo@bar:<...>/para_tp3$ make
nvcc -o bin/exo1 src/exo1.cu
nvcc -o bin/exo2 src/exo2.cu
nvcc -o bin/exo3 src/exo3.cu
```

# Benchmarks

|            Performance difference            | ADDITION  2^24 blocs 1 thread/bloc | ADDITION  2^19 blocs 2^5 threads/bloc | ADDITION  2^14 blocs 2^10 threads/bloc | MULTIPLICATION  2^24 blocs 1 thread/bloc | MULTIPLICATION  2^19 blocs 2^5 threads/bloc | MULTIPLICATION  2^14 blocs 2^10 threads/bloc |
|:--------------------------------------------:|:----------------------------------:|:-------------------------------------:|:--------------------------------------:|:----------------------------------------:|:-------------------------------------------:|:--------------------------------------------:|
|      ADDITION  2^24 blocs 1 thread/bloc      |                 +0%                |                +34.77%                |                 +47.57%                |                  +1.41%                  |                   +45.53%                   |                    +48.37%                   |
|     ADDITION  2^19 blocs 2^5 threads/bloc    |               -34.77%              |                  +0%                  |                 +13.35%                |                  -33.41%                 |                   +11.20%                   |                    +14.19%                   |
|    ADDITION  2^14 blocs 2^10 threads/bloc    |               -47.57%              |                -13.35%                |                   +0%                  |                  -46.24%                 |                    -2.15%                   |                    +0.85%                    |
|   MULTIPLICATION  2^24 blocs 1 thread/bloc   |               -1.41%               |                +33.41%                |                 +46.24%                |                    +0%                   |                   +44.20%                   |                    +47.04%                   |
|  MULTIPLICATION  2^19 blocs 2^5 threads/bloc |               -45.53%              |                -11.20%                |                 +2.15%                 |                  -44.20%                 |                     +0%                     |                    +3.00%                    |
| MULTIPLICATION  2^14 blocs 2^10 threads/bloc |               -48.37%              |                -14.19%                |                 -0.85%                 |                  -47.04%                 |                    -3.00%                   |                      +0%                     |
