#include "common.h"

__inline__ __device__ void
SSSP_54(unsigned int *outgoing_55, int SourceSize_73, int OffsetEnd_74,
        int ObjectSize_75, int Stride_76, unsigned int *dist_p_56,
        unsigned int *dist_57, unsigned int *srcsrc_58, int SourceSize_77,
        int OffsetEnd_78, unsigned int *psrc_59, unsigned int *edgessrcdst_60,
        unsigned int *edgessrcwt_61, bool *changed_62, unsigned int numNodes_63,
        unsigned int numEdges_64) {

  unsigned int tid_79 = threadIdx.x;
  for (int nn_65 = 0; (nn_65 < ObjectSize_75); nn_65 += Stride_76) {
    if ((nn_65 + threadIdx.x < SourceSize_77) &&
        (nn_65 + (blockIdx.x * SourceSize_77 + threadIdx.x) < OffsetEnd_78)) {
      unsigned int neighborsize_66 = outgoing_55[nn_65];
      bool local_change = false;
      for (unsigned int ii_67 = 0; (ii_67 < neighborsize_66); ++ii_67) {
        bool ll_change = false;
        if ((srcsrc_58[nn_65] < numNodes_63)) {
          unsigned int edge_68 = (psrc_59[srcsrc_58[nn_65]] + ii_67);
          if ((edge_68 && (edge_68 < (numEdges_64 + 1)))) {
            unsigned int dst_69 = edgessrcdst_60[edge_68];
            unsigned int wt_70 = edgessrcwt_61[edge_68];
            if (((dst_69 >= numNodes_63) || (wt_70 >= 1000000000))) {
              ll_change = false;
            } else {
              unsigned int altdist_71 = (dist_p_56[nn_65] + wt_70);
              if ((altdist_71 < dist_57[dst_69])) {
                unsigned int olddist_72 =
                    atomicMin(&dist_57[dst_69], altdist_71);
                if ((altdist_71 < olddist_72)) {
                  ll_change = true;
                }
              } else {
                ll_change = false;
              }
            }
          }
        }
        if (ll_change) {
          local_change = true;
        }
      }
      if (local_change) {
        *changed_62 = true;
      }
    }
  }
}

__global__ void /*SSSP_36*/ drelax(
    unsigned int *outgoing_37, int ObjectSize_80, int ObjectSize_81,
    int SourceSize_82, unsigned int *dist_p_38, int ObjectSize_83,
    unsigned int *dist_39, unsigned int *srcsrc_40, int ObjectSize_84,
    int SourceSize_85, unsigned int *psrc_41, unsigned int *edgessrcdst_42,
    unsigned int *edgessrcwt_43, bool *changed_44, unsigned int numNodes_45,
    unsigned int numEdges_46) {

  unsigned int blockID_86 = blockIdx.x;
  int p_47 = blockDim.x;
  int x_size_48 = ObjectSize_81;
  int tile_49 = ((((x_size_48 + p_47) - 1)) / p_47);

  unsigned int *part_outgoing_51 = outgoing_37 + (blockIdx.x * ObjectSize_80);
  unsigned int *part_dist_52 = dist_p_38 + (blockIdx.x * ObjectSize_83);
  unsigned int *part_srcsrc_53 = srcsrc_40 + (blockIdx.x * ObjectSize_84);

  SSSP_54(part_outgoing_51 + (0 + (threadIdx.x * 1)), x_size_48, SourceSize_82,
          (p_47 * tile_49), p_47, part_dist_52 + (0 + (threadIdx.x * 1)),
          dist_39, part_srcsrc_53 + (0 + (threadIdx.x * 1)), x_size_48,
          SourceSize_85, psrc_41, edgessrcdst_42, edgessrcwt_43, changed_44,
          numNodes_45, numEdges_46);

  __syncthreads();
}

template <unsigned int TGM_TEMPLATE_0, unsigned int TGM_TEMPLATE_1>
void SSSP_18(unsigned int *outgoing_19, int ObjectSize_87,
             unsigned int *dist_p_20, unsigned int *dist_21,
             unsigned int *srcsrc_22, unsigned int *psrc_23,
             unsigned int *edgessrcdst_24, unsigned int *edgessrcwt_25,
             bool *changed_26, unsigned int numNodes_27,
             unsigned int numEdges_28) {

  int p_29 = TGM_TEMPLATE_0;
  int x_size_30 = ObjectSize_87;
  int tile_31 = ((((x_size_30 + p_29) - 1)) / p_29);

  unsigned int *part_outgoing_33 = outgoing_19;
  unsigned int *part_dist_34 = dist_p_20;
  unsigned int *part_srcsrc_35 = srcsrc_22;

  dim3 dimBlock(TGM_TEMPLATE_1);
  dim3 dimGrid(p_29);

  /*SSSP_36*/ drelax << <dimGrid, dimBlock>>>
      (part_outgoing_33, tile_31, tile_31, x_size_30, part_dist_34, tile_31,
       dist_21, part_srcsrc_35, tile_31, x_size_30, psrc_23, edgessrcdst_24,
       edgessrcwt_25, changed_26, numNodes_27, numEdges_28);
}

template <unsigned int TGM_TEMPLATE_0, unsigned int TGM_TEMPLATE_1>
void SSSP_tangram(unsigned int *dist_2, unsigned int *outgoing_3,
                  unsigned int *srcsrc_4, unsigned int *psrc_5,
                  unsigned int *edgessrcdst_6, unsigned int *edgessrcwt_7,
                  bool *changed_8, unsigned int numNodes_9,
                  unsigned int numEdges_10) {

  unsigned int *T_dist_11 = dist_2;
  unsigned int *T_dist_p_12 = dist_2;
  unsigned int *T_outgoing_13 = outgoing_3;
  unsigned int *T_srcsrc_14 = srcsrc_4;
  unsigned int *T_psrc_15 = psrc_5;
  unsigned int *T_edgessrcdst_16 = edgessrcdst_6;
  unsigned int *T_edgessrcwt_17 = edgessrcwt_7;

  SSSP_18<TGM_TEMPLATE_0, TGM_TEMPLATE_1>(
      T_outgoing_13, numNodes_9, T_dist_p_12, T_dist_11, T_srcsrc_14, T_psrc_15,
      T_edgessrcdst_16, T_edgessrcwt_17, changed_8, numNodes_9, numEdges_10);
}

void launch_kernel(unsigned int nb, unsigned int nt, foru *dist, Graph graph,
                   bool *changed) {
  SSSP_tangram<32, 128>((unsigned int *)dist, graph.getNoutGoing(),
                        graph.getSrcsrc(), graph.getPsrc(),
                        graph.getEdgessrcdst(), graph.getEdgessrcwt(), changed,
                        graph.getNnodes(), graph.getNedges());
}
