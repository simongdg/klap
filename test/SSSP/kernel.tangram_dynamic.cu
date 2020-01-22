#include "common.h"

__inline__ __device__ void
SSSP_93(unsigned int *outgoing_94, int SourceSize_114, int OffsetEnd_115,
        int ObjectSize_116, int Stride_117, unsigned int *dist_p_95,
        unsigned int *dist_96, unsigned int *srcsrc_97, int SourceSize_118,
        int OffsetEnd_119, unsigned int *psrc_98, unsigned int *edgessrcdst_99,
        unsigned int *edgessrcwt_100, bool *changed_101,
        unsigned int numNodes_102, unsigned int numEdges_103) {

  unsigned int tid_120 = threadIdx.x;
  for (int nn_104 = 0; (nn_104 < ObjectSize_116); nn_104 += Stride_117) {
    if ((nn_104 + threadIdx.x < SourceSize_118) &&
        (nn_104 + (blockIdx.x * SourceSize_118 + threadIdx.x) <
         OffsetEnd_119)) {
      unsigned int neighborsize_105 = outgoing_94[nn_104];
      bool local_change_106 = false;
      for (unsigned int ii_107 = 0; (ii_107 < neighborsize_105); ++ii_107) {
        bool ll_change_108 = false;
        if ((srcsrc_97[nn_104] < numNodes_102)) {
          unsigned int edge_109 = (psrc_98[srcsrc_97[nn_104]] + ii_107);
          if ((edge_109 && (edge_109 < (numEdges_103 + 1)))) {
            unsigned int dst_110 = edgessrcdst_99[edge_109];
            unsigned int wt_111 = edgessrcwt_100[edge_109];
            if (((dst_110 >= numNodes_102) || (wt_111 >= 1000000000))) {
              ll_change_108 = false;
            } else {
              unsigned int altdist_112 = (dist_p_95[nn_104] + wt_111);
              if ((altdist_112 < dist_96[dst_110])) {
                unsigned int olddist_113 =
                    atomicMin(&dist_96[dst_110], altdist_112);
                if ((altdist_112 < olddist_113)) {
                  ll_change_108 = true;
                }
              } else {
                ll_change_108 = false;
              }
            }
          }
        }
        if ((ll_change_108)) {
          local_change_106 = true;
        }
      }
      if ((local_change_106)) {
        *changed_101 = true;
      }
    }
  }
}

__global__ void SSSP_75(unsigned int *outgoing_76, int ObjectSize_121,
                        int ObjectSize_122, int SourceSize_123,
                        unsigned int *dist_p_77, int ObjectSize_124,
                        unsigned int *dist_78, unsigned int *srcsrc_79,
                        int ObjectSize_125, int SourceSize_126,
                        unsigned int *psrc_80, unsigned int *edgessrcdst_81,
                        unsigned int *edgessrcwt_82, bool *changed_83,
                        unsigned int numNodes_84, unsigned int numEdges_85) {

  unsigned int tid_127 = blockIdx.x;
  int p_86 = blockDim.x;
  int x_size_87 = ObjectSize_122;
  int tile_88 = ((((x_size_87 + p_86) - 1)) / p_86);

  unsigned int *part_outgoing_90 = outgoing_76 + (blockIdx.x * ObjectSize_121);
  unsigned int *part_dist_91 = dist_p_77 + (blockIdx.x * ObjectSize_124);
  unsigned int *part_srcsrc_92 = srcsrc_79 + (blockIdx.x * ObjectSize_125);

  SSSP_93(part_outgoing_90 + (0 + (threadIdx.x * 1)), x_size_87, SourceSize_123,
          (p_86 * tile_88), p_86, part_dist_91 + (0 + (threadIdx.x * 1)),
          dist_78, part_srcsrc_92 + (0 + (threadIdx.x * 1)), x_size_87,
          SourceSize_126, psrc_80, edgessrcdst_81, edgessrcwt_82, changed_83,
          numNodes_84, numEdges_85);

  __syncthreads();
}

__inline__ __device__ void
SSSP_54(unsigned int *outgoing_55, int SourceSize_128, int OffsetEnd_129,
        int ObjectSize_130, int Stride_131, unsigned int *dist_p_56,
        unsigned int *dist_57, unsigned int *srcsrc_58, int SourceSize_132,
        int OffsetEnd_133, unsigned int *psrc_59, unsigned int *edgessrcdst_60,
        unsigned int *edgessrcwt_61, bool *changed_62, unsigned int numNodes_63,
        unsigned int numEdges_64) {

  unsigned int tid_134 = threadIdx.x;
  for (int nn_65 = 0; (nn_65 < ObjectSize_130); nn_65 += Stride_131) {
    if ((nn_65 + threadIdx.x < SourceSize_132) &&
        (nn_65 + (blockIdx.x * SourceSize_132 + threadIdx.x) < OffsetEnd_133)) {
      unsigned int neighborsize_66 = outgoing_55[nn_65];
      bool local_change_67 = false;
      for (unsigned int ii_68 = 0; (ii_68 < neighborsize_66); ++ii_68) {
        bool ll_change_69 = false;
        if ((srcsrc_58[nn_65] < numNodes_63)) {
          unsigned int edge_70 = (psrc_59[srcsrc_58[nn_65]] + ii_68);
          if ((edge_70 && (edge_70 < (numEdges_64 + 1)))) {
            unsigned int dst_71 = edgessrcdst_60[edge_70];
            unsigned int wt_72 = edgessrcwt_61[edge_70];
            if (((dst_71 >= numNodes_63) || (wt_72 >= 1000000000))) {
              ll_change_69 = false;
            } else {
              unsigned int altdist_73 = (dist_p_56[nn_65] + wt_72);
              if ((altdist_73 < dist_57[dst_71])) {
                unsigned int olddist_74 =
                    atomicMin(&dist_57[dst_71], altdist_73);
                if ((altdist_73 < olddist_74)) {
                  ll_change_69 = true;
                }
              } else {
                ll_change_69 = false;
              }
            }
          }
        }
        if ((ll_change_69)) {
          local_change_67 = true;
        }
      }
      if ((local_change_67)) {
        *changed_62 = true;
      }
    }
  }
}

__global__ void /*SSSP_36*/ drelax(
    unsigned int *outgoing_37, int ObjectSize_135, int ObjectSize_136,
    int SourceSize_137, unsigned int *dist_p_38, int ObjectSize_138,
    unsigned int *dist_39, unsigned int *srcsrc_40, int ObjectSize_139,
    int SourceSize_140, unsigned int *psrc_41, unsigned int *edgessrcdst_42,
    unsigned int *edgessrcwt_43, bool *changed_44, unsigned int numNodes_45,
    unsigned int numEdges_46) {

  unsigned int blockID_141 = blockIdx.x;
  int p_47 = blockDim.x;
  int x_size_48 = ObjectSize_136;
  int tile_49 = ((((x_size_48 + p_47) - 1)) / p_47);

  unsigned int *part_outgoing_51 = outgoing_37 + (blockIdx.x * ObjectSize_135);
  unsigned int *part_dist_52 = dist_p_38 + (blockIdx.x * ObjectSize_138);
  unsigned int *part_srcsrc_53 = srcsrc_40 + (blockIdx.x * ObjectSize_139);
  /*DYNAMIC*/
  //if(threadIdx.x == 0 && blockIdx.x == 0)
  //  printf("tile = %d \n", tile_49);
  if ((tile_49 > 1023)) {
    //printf("Dynamic\n");
    int tile_dyn = ((((tile_49 + gridDim.x) - 1)) / gridDim.x);

    int blockBound = (blockIdx.x < (gridDim.x - 1))
                         ? x_size_48
                         : (SourceSize_137 - (blockIdx.x * x_size_48));

    int OffsetEnd = (threadIdx.x < (blockDim.x - 1))
                        ? tile_49
                        : (blockBound - (threadIdx.x * tile_49));

    /*
       SSSP_75(unsigned int *outgoing_76, int ObjectSize_121,
               int ObjectSize_122, int SourceSize_123,
               unsigned int *dist_p_77, int ObjectSize_124,
               unsigned int *dist_78, unsigned int *srcsrc_79,
               int ObjectSize_125, int SourceSize_126,
               unsigned int *psrc_80, unsigned int *edgessrcdst_81,
               unsigned int *edgessrcwt_82, bool *changed_83,
               unsigned int numNodes_84, unsigned int numEdges_85) {
    */

    SSSP_75 << <gridDim.x, blockDim.x>>>
        (part_outgoing_51 + (0 + (threadIdx.x * tile_49)),
         tile_dyn /*x_size_48*/, tile_dyn,
         OffsetEnd /*SourceSize_137, (p_47 * tile_49)*/,
         part_dist_52 + (0 + (threadIdx.x * tile_49)), tile_dyn, dist_39,
         part_srcsrc_53 + (0 + (threadIdx.x * tile_49)), tile_dyn /*x_size_48*/,
         OffsetEnd, psrc_41, edgessrcdst_42, edgessrcwt_43, changed_44,
         numNodes_45, numEdges_46);

    cudaDeviceSynchronize();

  } else {

    SSSP_54(part_outgoing_51 + (0 + (threadIdx.x * 1)), x_size_48,
            SourceSize_137, (p_47 * tile_49), p_47,
            part_dist_52 + (0 + (threadIdx.x * 1)), dist_39,
            part_srcsrc_53 + (0 + (threadIdx.x * 1)), x_size_48, SourceSize_140,
            psrc_41, edgessrcdst_42, edgessrcwt_43, changed_44, numNodes_45,
            numEdges_46);

    __syncthreads();
  }
}

template <unsigned int TGM_TEMPLATE_0, unsigned int TGM_TEMPLATE_1>
void SSSP_18(unsigned int *outgoing_19, int ObjectSize_142,
             unsigned int *dist_p_20, unsigned int *dist_21,
             unsigned int *srcsrc_22, unsigned int *psrc_23,
             unsigned int *edgessrcdst_24, unsigned int *edgessrcwt_25,
             bool *changed_26, unsigned int numNodes_27,
             unsigned int numEdges_28) {

  int p_29 = TGM_TEMPLATE_0;
  int x_size_30 = ObjectSize_142;
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
  SSSP_tangram<2, 2>((unsigned int *)dist, graph.getNoutGoing(),
                       graph.getSrcsrc(), graph.getPsrc(),
                       graph.getEdgessrcdst(), graph.getEdgessrcwt(), changed,
                       graph.getNnodes(), graph.getNedges());
}
