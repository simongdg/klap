
NAME = gc

NVCC = nvcc
KLAP = klap

ARCH = -gencode arch=compute_60,code=sm_60 -gencode arch=compute_60,code=sm_60
FLAGS = -Xcompiler '-fPIC' -dc -m64 --default-stream per-thread

INCLUDE  = -I. -I../../include

SRC = main.cu graphColoring.cu
OBJ = $(SRC:.cu=.o)
BIN = $(NAME).tangram_dynamic $(NAME).tangram $(NAME).base $(NAME).aw $(NAME).ab $(NAME).ag

base: $(NAME).base
tangram: $(NAME).tangram
tangram_dynamic: $(NAME).tangram_dynamic

all: $(BIN)

.SECONDARY:

kernel.a%.cu: kernel.de.cu
	$(KLAP) $< -t `echo $@ | cut -d '.' -f2` -o $@ -- --cuda-device-only $(INCLUDE) --no-cuda-version-check -nocudalib

kernel.de.cu: kernel.base.cu
	$(KLAP) $< -t de -o $@ -- --cuda-device-only $(INCLUDE) --no-cuda-version-check -nocudalib

%.o: %.cu
	$(NVCC) $(ARCH) $(FLAGS) $(INCLUDE) -o $@ -c $<

$(NAME).%: kernel.%.o $(OBJ)
	$(NVCC) $(ARCH) -o $@ $+ -lcudadevrt 

clean:
	rm -f *.o *.csv $(BIN) kernel.a?.cu kernel.de.cu outputs/*

test:
	./test.sh

test-all: all
	./test.sh

