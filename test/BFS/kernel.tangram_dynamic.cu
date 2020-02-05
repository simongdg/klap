#include "common.h"

__inline__ __device__ void
BFS_74(unsigned int *p_levels_75, int SourceSize_88, int OffsetEnd_89,
       int ObjectSize_90, int Stride_91, unsigned int *levels_76,
       unsigned int *edgeArray_77, unsigned int *edgeArrayAux_78,
       int SourceSize_92, int OffsetEnd_93, const unsigned int numVerts_79,
       int curr_80, int *flag_81) {

  unsigned int tid_94 = threadIdx.x;
  for (int i_83 = 0; (i_83 < ObjectSize_90); i_83 += Stride_91) {
    if ((i_83 + threadIdx.x < SourceSize_88) &&
        (i_83 + (blockIdx.x * SourceSize_88 + threadIdx.x) < OffsetEnd_89)) {
      if ((p_levels_75[i_83] == curr_80)) {
        unsigned int nbr_off_84 = edgeArray_77[i_83];
        unsigned int num_nbr_85 = (edgeArray_77[(i_83 + 1)] - nbr_off_84);
        for (int nbr_count_86 = 0; (nbr_count_86 < num_nbr_85);
             ++nbr_count_86) {
          int v_87 = edgeArrayAux_78[(nbr_count_86 + nbr_off_84)];
          if ((levels_76[v_87] == UINT_MAX)) {
            levels_76[v_87] = (curr_80 + 1);
            flag_81[0] = 1;
          }
        }
      }
    }
  }
}

__global__ void
BFS_58(unsigned int *p_levels_59, int ObjectSize_95, int SourceSize_96,
       unsigned int *levels_60, int ObjectSize_97, unsigned int *edgeArray_61,
       int ObjectSize_98, unsigned int *edgeArrayAux_62, int SourceSize_99,
       int OffsetEnd_100, const unsigned int numVerts_63, int curr_64,
       int *flag_65) {

  unsigned int tid_101 = blockIdx.x;
  int p_68 = blockDim.x;
  int x_size_69 = ObjectSize_97;
  int tile_70 = ((((x_size_69 + p_68) - 1)) / p_68);

  unsigned int *part_levels_72 = p_levels_59 + (blockIdx.x * ObjectSize_95);
  unsigned int *part_edgeArray_73 = edgeArray_61 + (blockIdx.x * ObjectSize_98);


  BFS_74(part_levels_72 + (0 + (threadIdx.x * 1)), x_size_69, SourceSize_96,
         (p_68 * tile_70), p_68, levels_60,
         part_edgeArray_73 + (0 + (threadIdx.x * 1)), edgeArrayAux_62,
         SourceSize_99, OffsetEnd_100, numVerts_63, curr_64, flag_65);

  __syncthreads();
}

__inline__ __device__ void
BFS_44(unsigned int *p_levels_45, int SourceSize_102, int OffsetEnd_103,
       int ObjectSize_104, int Stride_105, unsigned int *levels_46,
       unsigned int *edgeArray_47, unsigned int *edgeArrayAux_48,
       int SourceSize_106, int OffsetEnd_107, const unsigned int numVerts_49,
       int curr_50, int *flag_51) {

  unsigned int tid_108 = threadIdx.x;
  for (int i_53 = 0; (i_53 < ObjectSize_104); i_53 += Stride_105) {
    if ((i_53 + threadIdx.x < SourceSize_102) &&
        (i_53 + (blockIdx.x * SourceSize_102 + threadIdx.x) < OffsetEnd_103)) {
      //      p_levels_45[i_53] = curr_50;
      if ((p_levels_45[i_53] == curr_50)) {
        unsigned int nbr_off_54 = edgeArray_47[i_53];
        unsigned int num_nbr_55 = (edgeArray_47[(i_53 + 1)] - nbr_off_54);
        for (int nbr_count_56 = 0; (nbr_count_56 < num_nbr_55);
             ++nbr_count_56) {
          int v_57 = edgeArrayAux_48[(nbr_count_56 + nbr_off_54)];
          if ((levels_46[v_57] == UINT_MAX)) {
            levels_46[v_57] = (curr_50 + 1);
            flag_51[0] = 1;
          }
        }
      }
    }
  }
}

__global__ void BFS_28(unsigned int *p_levels_29, int ObjectSize_109,
                       int SourceSize_110, unsigned int *levels_30,
                       int ObjectSize_111, int ObjectSize_112,
                       unsigned int *edgeArray_31, int ObjectSize_113,
                       unsigned int *edgeArrayAux_32, int SourceSize_114,
                       int OffsetEnd_115, int SourceSize_116, int OffsetEnd_117,
                       const unsigned int numVerts_33, int curr_34,
                       int *flag_35) {

  unsigned int blockID_118 = blockIdx.x;
  /*Vector*/;
  unsigned int num_nbr_37 =
      (edgeArray_31[(blockIdx.x * blockDim.x + threadIdx.x + 1)] -
       edgeArray_31[blockIdx.x * blockDim.x + threadIdx.x]);
  int p_38 = blockDim.x;
  int x_size_39 = ObjectSize_111;
  int tile_40 = ((((x_size_39 + p_38) - 1)) / p_38);

  unsigned int *part_levels_42 = p_levels_29 + (blockIdx.x * ObjectSize_109);
  unsigned int *part_edgeArray_43 =
      edgeArray_31 + (blockIdx.x * ObjectSize_113);
  /*DYNAMIC*/
  if (((tile_40 > 1) && (num_nbr_37 > 10))) {
    //printf("Dyamic \n");
    int tile_dyn = ((((tile_40 + gridDim.x) - 1)) / gridDim.x);

    int blockBound = (blockIdx.x < (gridDim.x - 1))
                         ? x_size_39
                         : (SourceSize_110 - (blockIdx.x * x_size_39));

    int OffsetEnd = (threadIdx.x < (blockDim.x - 1))
                        ? tile_40
                        : (blockBound - (threadIdx.x * tile_40));

    BFS_58 << <gridDim.x, blockDim.x>>>
        (part_levels_42 + (threadIdx.x*tile_40), tile_dyn /*x_size_39*/,
         OffsetEnd /*(p_38 * tile_40)*/, /*p_38,*/
         levels_30, tile_dyn, part_edgeArray_43 + (threadIdx.x*tile_40), tile_dyn, edgeArrayAux_32, SourceSize_114,
         OffsetEnd_115, numVerts_33, curr_34, flag_35);

    cudaDeviceSynchronize(); // could remove

  } else {

    BFS_44(part_levels_42 + (0 + (threadIdx.x * 1)), x_size_39, SourceSize_110,
           (p_38 * tile_40), p_38, levels_30,
           part_edgeArray_43 + (0 + (threadIdx.x * 1)), edgeArrayAux_32,
           SourceSize_114, OffsetEnd_115, numVerts_33, curr_34, flag_35);

    __syncthreads(); // could remove
  }
}

template <unsigned int TGM_TEMPLATE_0, unsigned int TGM_TEMPLATE_1>
void BFS_14(unsigned int *p_levels_15, unsigned int *levels_16,
            int ObjectSize_119, int ObjectSize_120, int ObjectSize_121,
            unsigned int *edgeArray_17, unsigned int *edgeArrayAux_18,
            int SourceSize_122, int OffsetEnd_123, int SourceSize_124,
            int OffsetEnd_125, const unsigned int numVerts_19, int curr_20,
            int *flag_21) {

  int p_22 = TGM_TEMPLATE_0;
  int x_size_23 = ObjectSize_119;
  int tile_24 = ((((x_size_23 + p_22) - 1)) / p_22);

  unsigned int *part_levels_26 = p_levels_15;
  unsigned int *part_edgeArray_27 = edgeArray_17;

  dim3 dimBlock(TGM_TEMPLATE_1/*(((x_size_23 - 1) / p_22) + 1)*/);
  dim3 dimGrid(p_22);

  BFS_28 << <dimGrid, dimBlock>>>
      (part_levels_26, tile_24, x_size_23, levels_16, ObjectSize_120,
       ObjectSize_121, part_edgeArray_27, tile_24, edgeArrayAux_18,
       SourceSize_122, OffsetEnd_123, SourceSize_124, OffsetEnd_125,
       numVerts_19, curr_20, flag_21);
}

template <unsigned int TGM_TEMPLATE_0, unsigned int TGM_TEMPLATE_1>
void BFS_tangram(unsigned int *d_costArray_2, unsigned int *d_edgeArray_3,
                unsigned int *d_edgeArrayAux_4, unsigned int numVerts_5,
                unsigned int adj_list_length_6, int iters_7, int *flag_8) {

  BFS_14<TGM_TEMPLATE_0, TGM_TEMPLATE_1>(
      d_costArray_2, d_costArray_2, numVerts_5, numVerts_5, numVerts_5,
      d_edgeArray_3, d_edgeArrayAux_4, adj_list_length_6, adj_list_length_6,
      adj_list_length_6, adj_list_length_6, numVerts_5, iters_7, flag_8);

}

void launch_kernel(unsigned int *d_costArray, unsigned int *d_edgeArray,
                   unsigned int *d_edgeArrayAux, unsigned int numVerts,
                   int iters, int *d_flag) {
  //unsigned int numBlocks = (numVerts - 1) / PARENT_BLOCK_SIZE + 1;
  BFS_tangram<GRID_DIM, BLOCK_DIM>(d_costArray, d_edgeArray, d_edgeArrayAux, numVerts, 1,
                      iters, d_flag);
}
