#include "common.h"


__inline__ __device__ void GC_39(int *boundaryListD_40, int SourceSize_49,
                                 int OffsetEnd_50, int ObjectSize_51,
                                 int Stride_52, int *conflictD_41,
                                 int SourceSize_53, int SourceSize_54,
                                 int OffsetEnd_55, int *adjacentListD_42,
                                 int SourceSize_56, int OffsetEnd_57,
                                 int *colors_43, const int maxDegree_44) {

  unsigned int tid_58 = threadIdx.x;
  int i_45;
  for (int idx_46 = 0; (idx_46 < ObjectSize_51); idx_46 += Stride_52) {
    if ((idx_46 + threadIdx.x < SourceSize_49) &&
        (idx_46 + (blockIdx.x * SourceSize_49 + threadIdx.x) < OffsetEnd_50)) {
      //if ((idx_46 + threadIdx.x < SourceSize_54) &&
      //    (idx_46 + (blockIdx.x * SourceSize_54 + threadIdx.x) <
      //     OffsetEnd_55)) {
        i_45 = boundaryListD_40[idx_46];
        conflictD_41[idx_46] = 0;
        for (int k_47 = 0; (k_47 < maxDegree_44); ++k_47) {
          int j_48 = adjacentListD_42[((i_45 * maxDegree_44) + k_47)];
          if (((j_48 < i_45) && ((colors_43[i_45] == colors_43[j_48])))) {
            if (blockIdx.x * blockDim.x + threadIdx.x < SourceSize_53) {
              atomicMax(&conflictD_41[idx_46], (i_45 + 1));
              colors_43[i_45] = 0;
            }
          }
        }
      //} 
    }
  }
}

__global__ void GC_27(int *boundaryListD_28, int ObjectSize_59,
                      int ObjectSize_60, int SourceSize_61, int *conflictD_29,
                      int ObjectSize_62, int SourceSize_63,
                      int *adjacentListD_30, int SourceSize_64,
                      int OffsetEnd_65, int *colors_31,
                      const int maxDegree_32) {

  unsigned int blockID_66 = blockIdx.x;
  int p_33 = blockDim.x;
  int x_size_34 = ObjectSize_60;
  int tile_35 = ((((x_size_34 + p_33) - 1)) / p_33);

  int *part_boundaryList_37 = boundaryListD_28 + (blockIdx.x * ObjectSize_59);
  int *part_conflictD_38 = conflictD_29 + (blockIdx.x * ObjectSize_62);


  GC_39(part_boundaryList_37 + (0 + (threadIdx.x * 1)), x_size_34,
        SourceSize_61, (p_33 * tile_35), p_33,
        part_conflictD_38 + (0 + (threadIdx.x * 1)), x_size_34, x_size_34,
        SourceSize_63, adjacentListD_30, SourceSize_64, OffsetEnd_65, colors_31,
        maxDegree_32);

  __syncthreads();
}

template <unsigned int TGM_TEMPLATE_0, unsigned int TGM_TEMPLATE_1>
void GC_15(int *boundaryListD_16, int ObjectSize_67, int *conflictD_17,
           int *adjacentListD_18, int SourceSize_68, int OffsetEnd_69,
           int *colors_19, const int maxDegree_20) {

  int p_21 = TGM_TEMPLATE_0;
  int x_size_22 = ObjectSize_67;
  int tile_23 = ((((x_size_22 + p_21) - 1)) / p_21);

  int *part_boundaryList_25 = boundaryListD_16;
  int *part_conflictD_26 = conflictD_17;

  dim3 dimBlock(TGM_TEMPLATE_1);
  dim3 dimGrid(p_21);

  GC_27 << <dimGrid, dimBlock>>> (part_boundaryList_25, tile_23, tile_23,
                                  x_size_22, part_conflictD_26, tile_23,
                                  x_size_22, adjacentListD_18, SourceSize_68,
                                  OffsetEnd_69, colors_19, maxDegree_20);
}

template <unsigned int TGM_TEMPLATE_0, unsigned int TGM_TEMPLATE_1>
void GC_tangram(
               int *adjacentListD_4, int *boundaryListD_5, int *colors_6,
               int *conflictD_7, long size_8, int boundarySize_9,
               int maxDegree_10) {

  int *Adjacent_List_11;
  cudaMalloc((void **)&Adjacent_List_11,
             ((size_8 * maxDegree_10)) * sizeof(int));
  cudaMemcpy(Adjacent_List_11, adjacentListD_4,
             ((size_8 * maxDegree_10)) * sizeof(int), cudaMemcpyHostToDevice);
  int *Boundary_List_12;
  cudaMalloc((void **)&Boundary_List_12, (boundarySize_9) * sizeof(int));
  cudaMemcpy(Boundary_List_12, boundaryListD_5, (boundarySize_9) * sizeof(int),
             cudaMemcpyHostToDevice);
  int *Colors_13;
  cudaMalloc((void **)&Colors_13, (size_8) * sizeof(int));
  cudaMemcpy(Colors_13, colors_6, (size_8) * sizeof(int),
             cudaMemcpyHostToDevice);
  int *ConflictD_14;
  cudaMalloc((void **)&ConflictD_14, (boundarySize_9) * sizeof(int));
  cudaMemcpy(ConflictD_14, conflictD_7, (boundarySize_9) * sizeof(int),
             cudaMemcpyHostToDevice);

  GC_15<TGM_TEMPLATE_0, TGM_TEMPLATE_1>(
      Boundary_List_12, boundarySize_9, ConflictD_14, Adjacent_List_11,
      (size_8 * maxDegree_10), (size_8 * maxDegree_10), Colors_13,
      maxDegree_10);

  cudaFree(Adjacent_List_11);
  cudaFree(Boundary_List_12);
  cudaFree(Colors_13);
  cudaFree(ConflictD_14);
}

void launch_kernel(unsigned int dimGrid_confl, unsigned int dimBlock_confl, int *adjacentListD, int *boundaryListD, int *colors, int *conflictD, long size, int boundarySize, int maxDegree) {
    GC_tangram<GRID_DIM, BLOCK_DIM>(adjacentListD, boundaryListD, colors, conflictD, size, boundarySize, maxDegree);
}

