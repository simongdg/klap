#include "common.h"

__inline__ __device__ void GC_61(int *boundaryListD_62, int SourceSize_71,
                                 int OffsetEnd_72, int ObjectSize_73,
                                 int Stride_74, int *conflictD_63,
                                 int SourceSize_75, int SourceSize_76,
                                 int OffsetEnd_77, int *adjacentListD_64,
                                 int SourceSize_78, int OffsetEnd_79,
                                 int *colors_65, const int maxDegree_66) {

  unsigned int tid_80 = threadIdx.x;
  int i_67;
  for (int idx_68 = 0; (idx_68 < ObjectSize_73); idx_68 += Stride_74) {
    if ((idx_68 + threadIdx.x < SourceSize_71) &&
        (idx_68 + (blockIdx.x * SourceSize_71 + threadIdx.x) < OffsetEnd_72)) {
      //if ((idx_68 + threadIdx.x < SourceSize_76) &&
      //    (idx_68 + (blockIdx.x * SourceSize_76 + threadIdx.x) <
      //     OffsetEnd_77)) {
        i_67 = boundaryListD_62[idx_68];
        conflictD_63[idx_68] = 0;
        for (int k_69 = 0; (k_69 < maxDegree_66); ++k_69) {
          int j_70 = adjacentListD_64[((i_67 * maxDegree_66) + k_69)];
          if (((j_70 < i_67) && ((colors_65[i_67] == colors_65[j_70])))) {
            if (blockIdx.x * blockDim.x + threadIdx.x < SourceSize_75) {
              conflictD_63[idx_68] = (i_67 + 1);
              colors_65[i_67] = 0;
            };
          }
        }
      //}
    }
  }
}

__global__ void GC_49(int *boundaryListD_50, int ObjectSize_81,
                                 int ObjectSize_82, int SourceSize_83,
                                 int *conflictD_51, int ObjectSize_84,
                                 int SourceSize_85, int *adjacentListD_52,
                                 int SourceSize_86, int OffsetEnd_87,
                                 int *colors_53, const int maxDegree_54) {

  unsigned int tid_88 = blockIdx.x;
  int p_55 = blockDim.x;
  int x_size_56 = ObjectSize_82;
  int tile_57 = ((((x_size_56 + p_55) - 1)) / p_55);

  int *part_boundaryList_59 = boundaryListD_50 + (blockIdx.x * ObjectSize_81);
  int *part_conflictD_60 = conflictD_51 + (blockIdx.x * ObjectSize_84);


  GC_61(part_boundaryList_59 + (0 + (threadIdx.x * 1)), x_size_56,
        SourceSize_83, (p_55 * tile_57), p_55,
        part_conflictD_60 + (0 + (threadIdx.x * 1)), x_size_56, x_size_56,
        SourceSize_85, adjacentListD_52, SourceSize_86, OffsetEnd_87, colors_53,
        maxDegree_54);

  __syncthreads();
}


__inline__ __device__ void GC_39(int *boundaryListD_40, int SourceSize_89,
                                 int OffsetEnd_90, int ObjectSize_91,
                                 int Stride_92, int *conflictD_41,
                                 int SourceSize_93, int SourceSize_94,
                                 int OffsetEnd_95, int *adjacentListD_42,
                                 int SourceSize_96, int OffsetEnd_97,
                                 int *colors_43, const int maxDegree_44) {

  unsigned int tid_98 = threadIdx.x;
  int i_45;
  for (int idx_46 = 0; (idx_46 < ObjectSize_91); idx_46 += Stride_92) {
    if ((idx_46 + threadIdx.x < SourceSize_89) &&
        (idx_46 + (blockIdx.x * SourceSize_89 + threadIdx.x) < OffsetEnd_90)) {
      //if ((idx_46 + threadIdx.x < SourceSize_94) &&
      //    (idx_46 + (blockIdx.x * SourceSize_94 + threadIdx.x) <
      //     OffsetEnd_95)) {
        i_45 = boundaryListD_40[idx_46];
        conflictD_41[idx_46] = 0;
        for (int k_47 = 0; (k_47 < maxDegree_44); ++k_47) {
          int j_48 = adjacentListD_42[((i_45 * maxDegree_44) + k_47)];
          if (((j_48 < i_45) && ((colors_43[i_45] == colors_43[j_48])))) {
            if (blockIdx.x * blockDim.x + threadIdx.x < SourceSize_93) {
              conflictD_41[idx_46] = (i_45 + 1);
              colors_43[i_45] = 0;
            }
          }
        }
      //}
    }
  }
}

__global__ void GC_27(int *boundaryListD_28, int ObjectSize_99,
                      int ObjectSize_100, int SourceSize_101, int *conflictD_29,
                      int ObjectSize_102, int SourceSize_103,
                      int *adjacentListD_30, int SourceSize_104,
                      int OffsetEnd_105, int SourceSize_106, int OffsetEnd_107,
                      int *colors_31, const int maxDegree_32) {

  unsigned int blockID_108 = blockIdx.x;
  int p_33 = blockDim.x;
  int x_size_34 = ObjectSize_100;
  int tile_35 = ((((x_size_34 + p_33) - 1)) / p_33);

  int *part_boundaryList_37 = boundaryListD_28 + (blockIdx.x * ObjectSize_99);
  int *part_conflictD_38 = conflictD_29 + (blockIdx.x * ObjectSize_102);
  /*DYNAMIC*/
  //if(threadIdx.x == 0 && blockIdx.x == 0)
  //  printf("tile = %d \n", tile_35);
  if ((tile_35 > 31)) {

   int tile_dyn = ((((tile_35 + gridDim.x) - 1)) / gridDim.x);

    int blockBound = (blockIdx.x < (gridDim.x - 1))
                         ? x_size_34
                         : (SourceSize_101 - (blockIdx.x * x_size_34));

    int OffsetEnd = (threadIdx.x < (blockDim.x - 1))
                        ? tile_35
                        : (blockBound - (threadIdx.x * tile_35));

/*   GC_49(int *boundaryListD_50, int ObjectSize_81,
         int ObjectSize_82, int SourceSize_83,
         int *conflictD_51, int ObjectSize_84,
         int SourceSize_85, int *adjacentListD_52,
         int SourceSize_86, int OffsetEnd_87,
         int *colors_53, const int maxDegree_54) {
*/

   GC_49 << <gridDim.x, blockDim.x>>> 
          (part_boundaryList_37 + (0 + (threadIdx.x * tile_35)), tile_dyn, 
          tile_dyn /*x_size_34*/, OffsetEnd /*(p_33 * tile_35)*/, /*p_33,*/
          part_conflictD_38 + (0 + (threadIdx.x * tile_35)), tile_dyn /*x_size_34*/, 
          OffsetEnd /*SourceSize_103*/, adjacentListD_30, 
          SourceSize_104, OffsetEnd_105, 
          colors_31, maxDegree_32);



   /* GC_49 << <dimGrid, dimBlock>>>
        (part_boundaryList_37, x_size_34, SourceSize_101, (p_33 * tile_35),
         p_33, part_conflictD_38, x_size_34, x_size_34, SourceSize_103,
         adjacentListD_30, SourceSize_104, OffsetEnd_105, colors_31,
         maxDegree_32);
    */
    cudaDeviceSynchronize();

  } else {


    GC_39(part_boundaryList_37 + (0 + (threadIdx.x * 1)), x_size_34,
          SourceSize_101, (p_33 * tile_35), p_33,
          part_conflictD_38 + (0 + (threadIdx.x * 1)), x_size_34, x_size_34,
          SourceSize_103, adjacentListD_30, SourceSize_104, OffsetEnd_105,
          colors_31, maxDegree_32);

    __syncthreads();
  }

}

template <unsigned int TGM_TEMPLATE_0, unsigned int TGM_TEMPLATE_1>
void GC_15(int *boundaryListD_16, int ObjectSize_109, int *conflictD_17,
           int *adjacentListD_18, int SourceSize_110, int OffsetEnd_111,
           int SourceSize_112, int OffsetEnd_113, int *colors_19,
           const int maxDegree_20) {

  int p_21 = TGM_TEMPLATE_0;
  int x_size_22 = ObjectSize_109;
  int tile_23 = ((((x_size_22 + p_21) - 1)) / p_21);

  int *part_boundaryList_25 = boundaryListD_16;
  int *part_conflictD_26 = conflictD_17;

  dim3 dimBlock(TGM_TEMPLATE_1);
  dim3 dimGrid(p_21);
  GC_27 << <dimGrid, dimBlock>>>
      (part_boundaryList_25, tile_23, tile_23, x_size_22, part_conflictD_26,
       tile_23, x_size_22, adjacentListD_18, SourceSize_110, OffsetEnd_111,
       SourceSize_112, OffsetEnd_113, colors_19, maxDegree_20);
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
      (size_8 * maxDegree_10), (size_8 * maxDegree_10), (size_8 * maxDegree_10),
      (size_8 * maxDegree_10), Colors_13, maxDegree_10);

  cudaMemcpy(boundaryListD_5, Boundary_List_12, (boundarySize_9) * sizeof(int),
             cudaMemcpyDeviceToHost);

  cudaFree(Adjacent_List_11);
  cudaFree(Boundary_List_12);
  cudaFree(Colors_13);
  cudaFree(ConflictD_14);
}

void launch_kernel(unsigned int dimGrid_confl, unsigned int dimBlock_confl, int *adjacentListD, int *boundaryListD, int *colors, int *conflictD, long size, int boundarySize, int maxDegree) {
    GC_tangram<2, 32>(adjacentListD, boundaryListD, colors, conflictD, size, boundarySize, maxDegree);
}

