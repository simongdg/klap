#include "common.h"

__inline__ __device__ void
BFS_42(unsigned int *p_levels_43, int SourceSize_56, int OffsetEnd_57,
       int ObjectSize_58, int Stride_59, unsigned int *levels_44,
       unsigned int *edgeArray_45, unsigned int *edgeArrayAux_46,
       int SourceSize_60, int OffsetEnd_61, const unsigned int numVerts_47,
       int curr_48, int *flag_49) {

  unsigned int tid_62 = threadIdx.x;
  for (int i_51 = 0; (i_51 < ObjectSize_58); i_51 += Stride_59) {
    if ((i_51 + threadIdx.x < SourceSize_56) &&
        (i_51 + (blockIdx.x * SourceSize_56 + threadIdx.x) < OffsetEnd_57)) {
      if ((p_levels_43[i_51] == curr_48)) {
        unsigned int nbr_off_52 = edgeArray_45[i_51];
        unsigned int num_nbr_53 = (edgeArray_45[(i_51 + 1)] - nbr_off_52);
        for (int nbr_count_54 = 0; (nbr_count_54 < num_nbr_53);
             ++nbr_count_54) {
          int v_55 = edgeArrayAux_46[(nbr_count_54 + nbr_off_52)];
          if ((levels_44[v_55] == UINT_MAX)) {
            levels_44[v_55] = (curr_48 + 1);
            flag_49[0] = 1;
          }
        }
      }
    }
  }
}

__global__ void BFS_28(unsigned int *p_levels_29, int ObjectSize_63,
                       int SourceSize_64, unsigned int *levels_30,
                       int ObjectSize_65, unsigned int *edgeArray_31,
                       int ObjectSize_66, unsigned int *edgeArrayAux_32,
                       int SourceSize_67, int OffsetEnd_68,
                       const unsigned int numVerts_33, int curr_34,
                       int *flag_35) {

  unsigned int blockID_69 = blockIdx.x;
  int p_36 = blockDim.x;
  int x_size_37 = ObjectSize_65;
  int tile_38 = ((((x_size_37 + p_36) - 1)) / p_36);

  unsigned int *part_levels_40 = p_levels_29 + (blockIdx.x * ObjectSize_63);
  unsigned int *part_edgeArray_41 = edgeArray_31 + (blockIdx.x * ObjectSize_66);

//  __shared__ void *map_return_4;
//  if (threadIdx.x == 0) {
//    map_return_4 = new void[p_36];
//  }

//  __syncthreads();

  BFS_42(part_levels_40 + (0 + (threadIdx.x * 1)), x_size_37, SourceSize_64,
         (p_36 * tile_38), p_36, levels_30,
         part_edgeArray_41 + (0 + (threadIdx.x * 1)), edgeArrayAux_32,
         SourceSize_67, OffsetEnd_68, numVerts_33, curr_34, flag_35);

  __syncthreads();
}

template <unsigned int TGM_TEMPLATE_0, unsigned int TGM_TEMPLATE_1>
void BFS_14(unsigned int *p_levels_15, unsigned int *levels_16,
            int ObjectSize_70, int ObjectSize_71, unsigned int *edgeArray_17,
            unsigned int *edgeArrayAux_18, int SourceSize_72, int OffsetEnd_73,
            const unsigned int numVerts_19, int curr_20, int *flag_21) {

  int p_22 = TGM_TEMPLATE_0;
  int x_size_23 = ObjectSize_70;
  int tile_24 = ((((x_size_23 + p_22) - 1)) / p_22);

  unsigned int *part_levels_26 = p_levels_15;
  unsigned int *part_edgeArray_27 = edgeArray_17;

//  void *map_return_h_2 = new void[p_22];
//  void *map_return_1;
//  cudaMalloc((void **)&map_return_1, (p_22) * sizeof(void));
  dim3 dimBlock(TGM_TEMPLATE_1);
  dim3 dimGrid(p_22);
  BFS_28 << <dimGrid, dimBlock>>> (part_levels_26, tile_24, x_size_23,
                                   levels_16, ObjectSize_71, part_edgeArray_27,
                                   tile_24, edgeArrayAux_18, SourceSize_72,
                                   OffsetEnd_73, numVerts_19, curr_20, flag_21);

//  cudaMemcpy(map_return_h_2, map_return_1, (p_22) * sizeof(void),
//             cudaMemcpyDeviceToHost);
}

template <unsigned int TGM_TEMPLATE_0, unsigned int TGM_TEMPLATE_1>
void BFS_tangram(unsigned int *d_costArray_2, unsigned int *d_edgeArray_3,
                unsigned int *d_edgeArrayAux_4, unsigned int numVerts_5,
                unsigned int adj_list_length_6, int iters_7, int *flag_8) {
/*  unsigned int *COST_ARRAY_P_9;
  cudaMalloc((void **)&COST_ARRAY_P_9, (numVerts_5) * sizeof(unsigned int));
  cudaMemcpy(COST_ARRAY_P_9, h_costArray_2, (numVerts_5) * sizeof(unsigned int),
             cudaMemcpyHostToDevice);
  unsigned int *COST_ARRAY_10;
  cudaMalloc((void **)&COST_ARRAY_10, (numVerts_5) * sizeof(unsigned int));
  cudaMemcpy(COST_ARRAY_10, h_costArray_2, (numVerts_5) * sizeof(unsigned int),
             cudaMemcpyHostToDevice);
  unsigned int *EDGE_ARRAY_11;
  cudaMalloc((void **)&EDGE_ARRAY_11,
             ((numVerts_5 + 1)) * sizeof(unsigned int));
  cudaMemcpy(EDGE_ARRAY_11, h_edgeArray_3,
             ((numVerts_5 + 1)) * sizeof(unsigned int), cudaMemcpyHostToDevice);
  unsigned int *EDGE_ARRAY_AUX_12;
  cudaMalloc((void **)&EDGE_ARRAY_AUX_12,
             (adj_list_length_6) * sizeof(unsigned int));
  cudaMemcpy(EDGE_ARRAY_AUX_12, h_edgeArrayAux_4,
             (adj_list_length_6) * sizeof(unsigned int),
             cudaMemcpyHostToDevice);
  int *FLAG_13;
  cudaMalloc((void **)&FLAG_13, (1) * sizeof(int));
  cudaMemcpy(FLAG_13, flag_8, (1) * sizeof(int), cudaMemcpyHostToDevice);
*/
  BFS_14<TGM_TEMPLATE_0, TGM_TEMPLATE_1>(
      d_costArray_2, d_costArray_2, numVerts_5, numVerts_5, d_edgeArray_3,
      d_edgeArrayAux_4, adj_list_length_6, adj_list_length_6, numVerts_5,
      iters_7, flag_8);

//  cudaMemcpy(h_costArray_2, COST_ARRAY_P_9, (numVerts_5) * sizeof(unsigned int),
//             cudaMemcpyDeviceToHost);

//  cudaFree(COST_ARRAY_P_9);
//  cudaFree(COST_ARRAY_10);
//  cudaFree(EDGE_ARRAY_11);
//  cudaFree(EDGE_ARRAY_AUX_12);
//  cudaFree(FLAG_13);
}

void launch_kernel(unsigned int *d_costArray, unsigned int *d_edgeArray,
                   unsigned int *d_edgeArrayAux, unsigned int numVerts,
                   int iters, int *d_flag) {
  unsigned int numBlocks = (numVerts - 1) / PARENT_BLOCK_SIZE + 1;
  //printf("numBlocks = %d\n", numBlocks);
  //std::cout<<"numBlocks = " << numBlocks <<", PARENT_BLOCK_SIZE = " << PARENT_BLOCK_SIZE + 1 <<std::endl;
  BFS_tangram<GRID_DIM, BLOCK_DIM>(d_costArray, d_edgeArray, d_edgeArrayAux, numVerts, 1,
                      iters, d_flag);
}
