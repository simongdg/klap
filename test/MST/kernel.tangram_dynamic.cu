#include "common.h"

__inline__ __device__ void
MST_117(unsigned int *outgoing_118, int SourceSize_140, int OffsetEnd_141, int threadOffset,
        int ObjectSize_142, int Stride_143, unsigned int *ele2comp_p_119,
        int SourceSize_144, int OffsetEnd_145, unsigned int *ele2comp_120,
        unsigned int *eleminwts_121, unsigned int *minwtcomponent_122,
        unsigned int *partners_123, unsigned int *srcsrc_124,
        unsigned int *psrc_125, unsigned int *edgessrcdst_126,
        unsigned int *edgessrcwt_127, unsigned int *goaheadnodeofcomponent_128,
        unsigned int numNodes_129, unsigned int numEdges_130) {

  unsigned int tid_146 = threadIdx.x;
  for (int nn_131 = 0; (nn_131 < ObjectSize_142); nn_131 += Stride_143) {
    if ((nn_131 + threadIdx.x < SourceSize_144) &&
        (nn_131 + (blockIdx.x * SourceSize_144 + threadIdx.x) <
         OffsetEnd_145)) {
      unsigned int element_133 = threadOffset +
          (nn_131 + (blockIdx.x * SourceSize_144 + threadIdx.x));
      while ((((atomicCAS(&ele2comp_120[element_133], element_133,
                          element_133)) == element_133)) == false) {
        element_133 = ele2comp_120[element_133];
      }
      ele2comp_p_119[nn_131] = element_133;
      if (((((eleminwts_121[nn_131] == minwtcomponent_122[element_133])) &&
            ((element_133 != partners_123[nn_131]))) &&
           ((partners_123[nn_131] != numNodes_129)))) {
        unsigned int degree_134 = outgoing_118[nn_131];
        for (int ii_135 = 0; (ii_135 < degree_134); ++ii_135) {
          if ((srcsrc_124[nn_131] < numNodes_129)) {
            unsigned int edge_136 = (psrc_125[srcsrc_124[nn_131]] + ii_135);
            if ((edge_136 && (edge_136 < (numEdges_130 + 1)))) {
              unsigned int wt_137 = edgessrcwt_127[edge_136];
              if ((wt_137 == eleminwts_121[nn_131])) {
                unsigned int dst_138 = edgessrcdst_126[edge_136];
                unsigned int dst_element_139 = dst_138;
                while ((((atomicCAS(&ele2comp_120[dst_element_139],
                                    dst_element_139, dst_element_139)) ==
                         dst_element_139)) == false) {
                  dst_element_139 = ele2comp_120[dst_138];
                }
                ele2comp_120[dst_138] = dst_element_139;
                if ((dst_element_139 == partners_123[nn_131])) {
                  if (((atomicCAS(&goaheadnodeofcomponent_128[element_133],
                                  numNodes_129, threadOffset +
                                  (nn_131 + (blockIdx.x * SourceSize_144 +
                                             threadIdx.x)))) == numNodes_129)) {
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

__global__ void
MST_94(unsigned int *outgoing_95, int ObjectSize_147, int ObjectSize_148, int threadOffset,
       int SourceSize_149, unsigned int *ele2comp_p_96, int ObjectSize_150,
       int SourceSize_151, unsigned int *ele2comp_97,
       unsigned int *eleminwts_98, int ObjectSize_152,
       unsigned int *minwtcomponent_99, unsigned int *partners_100,
       int ObjectSize_153, unsigned int *srcsrc_101, int ObjectSize_154,
       unsigned int *psrc_102, unsigned int *edgessrcdst_103,
       unsigned int *edgessrcwt_104, unsigned int *goaheadnodeofcomponent_105,
       unsigned int numNodes_106, unsigned int numEdges_107) {

  unsigned int tid_155 = blockIdx.x;
  int p_108 = blockDim.x;
  int x_size_109 = ObjectSize_148;
  int tile_110 = ((((x_size_109 + p_108) - 1)) / p_108);

  unsigned int *part_outgoing_112 = outgoing_95 + (blockIdx.x * ObjectSize_147);
  unsigned int *part_ele2comp_113 =
      ele2comp_p_96 + (blockIdx.x * ObjectSize_150);
  unsigned int *part_eleminwts_114 =
      eleminwts_98 + (blockIdx.x * ObjectSize_152);
  unsigned int *part_partners_115 =
      partners_100 + (blockIdx.x * ObjectSize_153);
  unsigned int *part_srcsrc_116 = srcsrc_101 + (blockIdx.x * ObjectSize_154);

  MST_117(
      part_outgoing_112 + (0 + (threadIdx.x * 1)), x_size_109, SourceSize_149, threadOffset,
      (p_108 * tile_110), p_108, part_ele2comp_113 + (0 + (threadIdx.x * 1)),
      x_size_109, SourceSize_151, ele2comp_97,
      part_eleminwts_114 + (0 + (threadIdx.x * 1)), minwtcomponent_99,
      part_partners_115 + (0 + (threadIdx.x * 1)),
      part_srcsrc_116 + (0 + (threadIdx.x * 1)), psrc_102, edgessrcdst_103,
      edgessrcwt_104, goaheadnodeofcomponent_105, numNodes_106, numEdges_107);

  __syncthreads();
}

__inline__ __device__ void
MST_71(unsigned int *outgoing_72, int SourceSize_156, int OffsetEnd_157,
       int ObjectSize_158, int Stride_159, unsigned int *ele2comp_p_73,
       int SourceSize_160, int OffsetEnd_161, unsigned int *ele2comp_74,
       unsigned int *eleminwts_75, unsigned int *minwtcomponent_76,
       unsigned int *partners_77, unsigned int *srcsrc_78,
       unsigned int *psrc_79, unsigned int *edgessrcdst_80,
       unsigned int *edgessrcwt_81, unsigned int *goaheadnodeofcomponent_82,
       unsigned int numNodes_83, unsigned int numEdges_84) {

  unsigned int tid_162 = threadIdx.x;
  for (int nn_85 = 0; (nn_85 < ObjectSize_158); nn_85 += Stride_159) {
    if ((nn_85 + threadIdx.x < SourceSize_160) &&
        (nn_85 + (blockIdx.x * SourceSize_160 + threadIdx.x) < OffsetEnd_161)) {
      unsigned int element_87 =
          (nn_85 + (blockIdx.x * SourceSize_160 + threadIdx.x));
      while ((((atomicCAS(&ele2comp_74[element_87], element_87, element_87)) ==
               element_87)) == false) {
        element_87 = ele2comp_74[element_87];
      }
      ele2comp_p_73[nn_85] = element_87;
      if (((((eleminwts_75[nn_85] == minwtcomponent_76[element_87])) &&
            ((element_87 != partners_77[nn_85]))) &&
           ((partners_77[nn_85] != numNodes_83)))) {
        unsigned int degree_88 = outgoing_72[nn_85];
        for (int ii_89 = 0; (ii_89 < degree_88); ++ii_89) {
          if ((srcsrc_78[nn_85] < numNodes_83)) {
            unsigned int edge_90 = (psrc_79[srcsrc_78[nn_85]] + ii_89);
            if ((edge_90 && (edge_90 < (numEdges_84 + 1)))) {
              unsigned int wt_91 = edgessrcwt_81[edge_90];
              if ((wt_91 == eleminwts_75[nn_85])) {
                unsigned int dst_92 = edgessrcdst_80[edge_90];
                unsigned int dst_element_93 = dst_92;
                while ((((atomicCAS(&ele2comp_74[dst_element_93],
                                    dst_element_93, dst_element_93)) ==
                         dst_element_93)) == false) {
                  dst_element_93 = ele2comp_74[dst_92];
                }
                ele2comp_74[dst_92] = dst_element_93;
                if ((dst_element_93 == partners_77[nn_85])) {
                  if (((atomicCAS(&goaheadnodeofcomponent_82[element_87],
                                  numNodes_83,
                                  (nn_85 + (blockIdx.x * SourceSize_160 +
                                            threadIdx.x)))) == numNodes_83)) {
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

__global__ void
MST_48(unsigned int *outgoing_49, int ObjectSize_163, int ObjectSize_164,
       int SourceSize_165, unsigned int *ele2comp_p_50, int ObjectSize_166,
       int SourceSize_167, unsigned int *ele2comp_51,
       unsigned int *eleminwts_52, int ObjectSize_168,
       unsigned int *minwtcomponent_53, unsigned int *partners_54,
       int ObjectSize_169, unsigned int *srcsrc_55, int ObjectSize_170,
       unsigned int *psrc_56, unsigned int *edgessrcdst_57,
       unsigned int *edgessrcwt_58, unsigned int *goaheadnodeofcomponent_59,
       unsigned int numNodes_60, unsigned int numEdges_61) {

  unsigned int blockID_171 = blockIdx.x;
  int p_62 = blockDim.x;
  int x_size_63 = ObjectSize_164;
  int tile_64 = ((((x_size_63 + p_62) - 1)) / p_62);

  unsigned int *part_outgoing_66 = outgoing_49 + (blockIdx.x * ObjectSize_163);
  unsigned int *part_ele2comp_67 =
      ele2comp_p_50 + (blockIdx.x * ObjectSize_166);
  unsigned int *part_eleminwts_68 =
      eleminwts_52 + (blockIdx.x * ObjectSize_168);
  unsigned int *part_partners_69 = partners_54 + (blockIdx.x * ObjectSize_169);
  unsigned int *part_srcsrc_70 = srcsrc_55 + (blockIdx.x * ObjectSize_170);
  // if(blockIdx.x == 0 && threadIdx.x == 0)
  //  printf("tile = %d \n", tile_64);
  /*DYNAMIC*/
  if ((tile_64 > 1)) {

    int tile_dyn = ((((tile_64 + gridDim.x) - 1)) / gridDim.x);

    int blockBound = (blockIdx.x < (gridDim.x - 1))
                         ? x_size_63
                         : (SourceSize_165 - (blockIdx.x * x_size_63));

    int OffsetEnd = (threadIdx.x < (blockDim.x - 1))
                        ? tile_64
                        : (blockBound - (threadIdx.x * tile_64));

    int threadOffset = (blockIdx.x * x_size_63) + (threadIdx.x * tile_64);

    /*   MST_94(unsigned int *outgoing_95, int ObjectSize_147,
                int ObjectSize_148, int SourceSize_149,
                unsigned int *ele2comp_p_96, int ObjectSize_150,
                int SourceSize_151, unsigned int *ele2comp_97,
                unsigned int *eleminwts_98, int ObjectSize_152,
                unsigned int *minwtcomponent_99, unsigned int *partners_100,
                int ObjectSize_153, unsigned int *srcsrc_101,
                int ObjectSize_154, unsigned int *psrc_102,
                unsigned int *edgessrcdst_103, unsigned int *edgessrcwt_104,
                unsigned int *goaheadnodeofcomponent_105, unsigned int
       numNodes_106,
                unsigned int numEdges_107) {
    */

    MST_94 << <gridDim.x, blockDim.x>>>
        (part_outgoing_66 + (0 + (threadIdx.x * tile_64)),
         tile_dyn /*x_size_63*/, tile_dyn, threadOffset,
         OffsetEnd /*SourceSize_165, (p_62 * tile_64)*/, 
         part_ele2comp_67 + (0 + (threadIdx.x * tile_64)), tile_dyn, OffsetEnd,
         ele2comp_51, part_eleminwts_68 + (0 + (threadIdx.x * tile_64)),
         tile_dyn, minwtcomponent_53,
         part_partners_69 + (0 + (threadIdx.x * tile_64)), tile_dyn,
         part_srcsrc_70 + (0 + (threadIdx.x * tile_64)), tile_dyn, psrc_56,
         edgessrcdst_57, edgessrcwt_58, goaheadnodeofcomponent_59, numNodes_60,
         numEdges_61);

    cudaDeviceSynchronize();

  } else {

    MST_71(part_outgoing_66 + (0 + (threadIdx.x * 1)), x_size_63,
           SourceSize_165, (p_62 * tile_64), p_62,
           part_ele2comp_67 + (0 + (threadIdx.x * 1)), x_size_63,
           SourceSize_167, ele2comp_51,
           part_eleminwts_68 + (0 + (threadIdx.x * 1)), minwtcomponent_53,
           part_partners_69 + (0 + (threadIdx.x * 1)),
           part_srcsrc_70 + (0 + (threadIdx.x * 1)), psrc_56, edgessrcdst_57,
           edgessrcwt_58, goaheadnodeofcomponent_59, numNodes_60, numEdges_61);

    __syncthreads();
  }
}

template <unsigned int TGM_TEMPLATE_0, unsigned int TGM_TEMPLATE_1>
void MST_25(unsigned int *outgoing_26, int ObjectSize_172,
            unsigned int *ele2comp_p_27, unsigned int *ele2comp_28,
            unsigned int *eleminwts_29, unsigned int *minwtcomponent_30,
            unsigned int *partners_31, unsigned int *srcsrc_32,
            unsigned int *psrc_33, unsigned int *edgessrcdst_34,
            unsigned int *edgessrcwt_35,
            unsigned int *goaheadnodeofcomponent_36, unsigned int numNodes_37,
            unsigned int numEdges_38) {

  int p_39 = TGM_TEMPLATE_0;
  int x_size_40 = ObjectSize_172;
  int tile_41 = ((((x_size_40 + p_39) - 1)) / p_39);

  unsigned int *part_outgoing_43 = outgoing_26;
  unsigned int *part_ele2comp_44 = ele2comp_p_27;
  unsigned int *part_eleminwts_45 = eleminwts_29;
  unsigned int *part_partners_46 = partners_31;
  unsigned int *part_srcsrc_47 = srcsrc_32;

  dim3 dimBlock(TGM_TEMPLATE_1);
  dim3 dimGrid(p_39);
  MST_48 << <dimGrid, dimBlock>>>
      (part_outgoing_43, tile_41, tile_41, x_size_40, part_ele2comp_44, tile_41,
       x_size_40, ele2comp_28, part_eleminwts_45, tile_41, minwtcomponent_30,
       part_partners_46, tile_41, part_srcsrc_47, tile_41, psrc_33,
       edgessrcdst_34, edgessrcwt_35, goaheadnodeofcomponent_36, numNodes_37,
       numEdges_38);
}

template <unsigned int TGM_TEMPLATE_0, unsigned int TGM_TEMPLATE_1>
void MST_tangram(unsigned int *ele2comp_2, unsigned int *eleminwts_3,
                 unsigned int *minwtcomponen_4, unsigned int *partners_5,
                 unsigned int *outgoing_6, unsigned int *srcsrc_7,
                 unsigned int *psrc_8, unsigned int *edgessrcdst_9,
                 unsigned int *edgessrcwt_10,
                 unsigned int *goaheadnodeofcomponent_11,
                 unsigned int numNodes_12, unsigned int numEdges_13) {

  unsigned int *T_ele2comp_14 = ele2comp_2;
  unsigned int *T_ele2comp_p_15 = ele2comp_2;
  unsigned int *T_eleminwts_16 = eleminwts_3;
  unsigned int *T_minwtcomponen_17 = minwtcomponen_4;
  unsigned int *T_partners_18 = partners_5;
  unsigned int *T_outgoing_19 = outgoing_6;
  unsigned int *T_srcsrc_20 = srcsrc_7;
  unsigned int *T_psrc_21 = psrc_8;
  unsigned int *T_edgessrcdst_22 = edgessrcdst_9;
  unsigned int *T_edgessrcwt_23 = edgessrcwt_10;
  unsigned int *T_goaheadnodeofcomponent_24 = goaheadnodeofcomponent_11;

  MST_25<TGM_TEMPLATE_0, TGM_TEMPLATE_1>(
      T_outgoing_19, numNodes_12, T_ele2comp_p_15, T_ele2comp_14,
      T_eleminwts_16, T_minwtcomponen_17, T_partners_18, T_srcsrc_20, T_psrc_21,
      T_edgessrcdst_22, T_edgessrcwt_23, T_goaheadnodeofcomponent_24,
      numNodes_12, numEdges_13);
}

void launch_find_kernel(unsigned int nb, unsigned int nt, unsigned *mstwt,
                        Graph graph, ComponentSpace cs, foru *eleminwts,
                        foru *minwtcomponent, unsigned *partners,
                        unsigned *phore, bool *processinnextiteration,
                        unsigned *goaheadnodeofcomponent, unsigned inpid) {

  MST_tangram<4, 512>(cs.getEle2comp(), (unsigned int *)eleminwts,
                      (unsigned int *)minwtcomponent, partners,
                      graph.getNoutGoing(), graph.getSrcsrc(), graph.getPsrc(),
                      graph.getEdgessrcdst(), graph.getEdgessrcwt(),
                      goaheadnodeofcomponent, graph.getNnodes(),
                      graph.getNedges());
}

/////////////////////////////////////////////////////////////////////////////////////
__global__ void verify_min_elem_child_cdp(
    Graph graph, ComponentSpace cs, unsigned minwt_node, foru minwt,
    /*foru *eleminwts,*/ unsigned *partners, bool *processinnextiteration,
    /*unsigned *goaheadnodeofcomponent, unsigned src,*/ unsigned id,
    /*unsigned srcboss,*/ unsigned degree) {
  // bool minwt_found = false;
  unsigned ii = blockIdx.x * blockDim.x + threadIdx.x;
  if (ii < degree) {
    foru wt = graph.getWeight(minwt_node, ii);
    // printf("%d: looking at %d edge %d wt %d (%d)\n", id, minwt_node, ii, wt,
    // minwt);

    if (wt == minwt) {
      // minwt_found = true;
      unsigned dst = graph.getDestination(minwt_node, ii);
      unsigned tempdstboss = cs.find(dst);
      if (tempdstboss == partners[minwt_node] && tempdstboss != id) {
        processinnextiteration[minwt_node] = true;
        // printf("%d okay!\n", id);
        return;
      }
    }
  } else
    return;
  // printf("component %d is wrong %d - %d - %d, %d\n", id, minwt_found, minwt,
  // ii, degree); // Thread that would printf "okay" should set a verify[id]
  // element. After child kernel finish, if verify[id]!=1, then printf this
  // wrong message
}

__global__ void
verify_min_elem_cdp(unsigned *mstwt, Graph graph, ComponentSpace cs,
                    foru *eleminwts, foru *minwtcomponent, unsigned *partners,
                    unsigned *phore, bool *processinnextiteration,
                    unsigned *goaheadnodeofcomponent, unsigned inpid) {
  unsigned id = blockIdx.x * blockDim.x + threadIdx.x;
  if (inpid < graph.nnodes)
    id = inpid;

  if (id < graph.nnodes) {

    if (cs.isBoss(id)) {

      if (goaheadnodeofcomponent[id] != graph.nnodes) {
        unsigned minwt_node = goaheadnodeofcomponent[id];
        unsigned degree = graph.getOutDegree(minwt_node);
        foru minwt = minwtcomponent[id];

        if (minwt != MYINFINITY) {
          verify_min_elem_child_cdp
                  << <(int)ceil((float)degree / BLOCK_DIM), BLOCK_DIM>>>
              (graph, cs, minwt_node, minwt, partners, processinnextiteration,
               /*goaheadnodeofcomponent, src,*/ id, /*srcboss,*/ degree);
        }
      }
    }
  }
}

void launch_verify_kernel(unsigned int nb, unsigned int nt, unsigned *mstwt,
                          Graph graph, ComponentSpace cs, foru *eleminwts,
                          foru *minwtcomponent, unsigned *partners,
                          unsigned *phore, bool *processinnextiteration,
                          unsigned *goaheadnodeofcomponent, unsigned inpid) {
  verify_min_elem_cdp << <nb, nt>>>
      (mstwt, graph, cs, eleminwts, minwtcomponent, partners, phore,
       processinnextiteration, goaheadnodeofcomponent, inpid);
}
