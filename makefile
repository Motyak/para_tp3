CC=nvcc
EXEC=bin/exo1 bin/exo2 bin/exo3
DIRS=bin

all: $(EXEC)

bin/exo1: src/exo1.cu
	$(CC) -o bin/exo1 src/exo1.cu

bin/exo2: src/exo2.cu
	$(CC) -o bin/exo2 src/exo2.cu

bin/exo3: src/exo3.cu
	$(CC) -o bin/exo3 src/exo3.cu

clean:
	rm -rf bin

# will create all necessary directories after the Makefile is parsed
$(shell mkdir -p $(DIRS))