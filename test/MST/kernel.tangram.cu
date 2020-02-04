#include "common.h"

__inline__ __device__ void
MST_71(unsigned int *outgoing_72, int SourceSize_94, int OffsetEnd_95,
       int ObjectSize_96, int Stride_97, unsigned int *ele2comp_p_73,
       int SourceSize_98, int OffsetEnd_99, unsigned int *ele2comp_74,
       unsigned int *eleminwts_75, unsigned int *minwtcomponent_76,
       unsigned int *partners_77, unsigned int *srcsrc_78,
       unsigned int *psrc_79, unsigned int *edgessrcdst_80,
       unsigned int *edgessrcwt_81, unsigned int *goaheadnodeofcomponent_82,
       unsigned int numNodes_83, unsigned int numEdges_84) {

  unsigned int tid_100 = threadIdx.x;
  for (int nn_85 = 0; (nn_85 < ObjectSize_96); nn_85 += Stride_97) {
    if ((nn_85 + threadIdx.x < SourceSize_98) &&
        (nn_85 + (blockIdx.x * SourceSize_98 + threadIdx.x) < OffsetEnd_99)) {
      unsigned int element_87 = (nn_85 + (blockIdx.x * SourceSize_98 + threadIdx.x)) ;
      while ((((atomicCAS(&ele2comp_74[element_87],element_87, element_87)) ==
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
                while ((((atomicCAS(&ele2comp_74[dst_element_93], dst_element_93,
                          dst_element_93)) == dst_element_93)) == false) {
                  dst_element_93 = ele2comp_74[dst_element_93];
                }
                ele2comp_74[dst_92] = dst_element_93;
                if ((dst_element_93 == partners_77[nn_85])) {
                  if (((atomicCAS(&goaheadnodeofcomponent_82[element_87], numNodes_83,
                        (nn_85 + (blockIdx.x * SourceSize_98 + threadIdx.x)) )) == numNodes_83)) {
                        
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
MST_48(unsigned int *outgoing_49, int ObjectSize_101, int ObjectSize_102,
       int SourceSize_103, unsigned int *ele2comp_p_50, int ObjectSize_104,
       int SourceSize_105, unsigned int *ele2comp_51,
       unsigned int *eleminwts_52, int ObjectSize_106,
       unsigned int *minwtcomponent_53, unsigned int *partners_54,
       int ObjectSize_107, unsigned int *srcsrc_55, int ObjectSize_108,
       unsigned int *psrc_56, unsigned int *edgessrcdst_57,
       unsigned int *edgessrcwt_58, unsigned int *goaheadnodeofcomponent_59,
       unsigned int numNodes_60, unsigned int numEdges_61) {

  unsigned int blockID_109 = blockIdx.x;
  int p_62 = blockDim.x;
  int x_size_63 = ObjectSize_102;
  int tile_64 = ((((x_size_63 + p_62) - 1)) / p_62);

  unsigned int *part_outgoing_66 = outgoing_49 + (blockIdx.x * ObjectSize_101);
  unsigned int *part_ele2comp_67 =
      ele2comp_p_50 + (blockIdx.x * ObjectSize_104);
  unsigned int *part_eleminwts_68 =
      eleminwts_52 + (blockIdx.x * ObjectSize_106);
  unsigned int *part_partners_69 = partners_54 + (blockIdx.x * ObjectSize_107);
  unsigned int *part_srcsrc_70 = srcsrc_55 + (blockIdx.x * ObjectSize_108);

  MST_71(part_outgoing_66 + (0 + (threadIdx.x * 1)), x_size_63, SourceSize_103,
         (p_62 * tile_64), p_62, part_ele2comp_67 + (0 + (threadIdx.x * 1)),
         x_size_63, SourceSize_105, ele2comp_51,
         part_eleminwts_68 + (0 + (threadIdx.x * 1)), minwtcomponent_53,
         part_partners_69 + (0 + (threadIdx.x * 1)),
         part_srcsrc_70 + (0 + (threadIdx.x * 1)), psrc_56, edgessrcdst_57,
         edgessrcwt_58, goaheadnodeofcomponent_59, numNodes_60, numEdges_61);

  __syncthreads();
}

template <unsigned int TGM_TEMPLATE_0, unsigned int TGM_TEMPLATE_1>
void MST_25(unsigned int *outgoing_26, int ObjectSize_110,
            unsigned int *ele2comp_p_27, unsigned int *ele2comp_28,
            unsigned int *eleminwts_29, unsigned int *minwtcomponent_30,
            unsigned int *partners_31, unsigned int *srcsrc_32,
            unsigned int *psrc_33, unsigned int *edgessrcdst_34,
            unsigned int *edgessrcwt_35,
            unsigned int *goaheadnodeofcomponent_36, unsigned int numNodes_37,
            unsigned int numEdges_38) {

  int p_39 = TGM_TEMPLATE_0;
  int x_size_40 = ObjectSize_110;
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

  MST_tangram<4, 1024>(cs.getEle2comp(), (unsigned int *)eleminwts,
                       (unsigned int *)minwtcomponent, partners,
                       graph.getNoutGoing(), graph.getSrcsrc(), graph.getPsrc(),
                       graph.getEdgessrcdst(), graph.getEdgessrcwt(),
                       goaheadnodeofcomponent, graph.getNnodes(),
                       graph.getNedges());
}


////////////////////////////////////////////////////////////////////////////////////


__global__ void verify_min_elem_child_cdp(Graph graph, ComponentSpace cs, unsigned minwt_node, foru minwt, /*foru *eleminwts,*/ unsigned *partners, bool *processinnextiteration, /*unsigned *goaheadnodeofcomponent, unsigned src,*/ unsigned id, /*unsigned srcboss,*/ unsigned degree) {
    //bool minwt_found = false;
    unsigned ii = blockIdx.x * blockDim.x + threadIdx.x;
    if (ii < degree){
        foru wt = graph.getWeight(minwt_node, ii);
        //printf("%d: looking at %d edge %d wt %d (%d)\n", id, minwt_node, ii, wt, minwt);

        if (wt == minwt) {
            //minwt_found = true;
            unsigned dst = graph.getDestination(minwt_node, ii);
            unsigned tempdstboss = cs.find(dst);
            if(tempdstboss == partners[minwt_node] && tempdstboss != id)
            {
                processinnextiteration[minwt_node] = true;
                //printf("%d okay!\n", id);
                return;
            }
        }
    }
    else return;
    //printf("component %d is wrong %d - %d - %d, %d\n", id, minwt_found, minwt, ii, degree); // Thread that would printf "okay" should set a verify[id] element. After child kernel finish, if verify[id]!=1, then printf this wrong message
}

__global__ void verify_min_elem_cdp(unsigned *mstwt, Graph graph, ComponentSpace cs, foru *eleminwts, foru *minwtcomponent, unsigned *partners, unsigned *phore, bool *processinnextiteration, unsigned *goaheadnodeofcomponent, unsigned inpid) {
    unsigned id = blockIdx.x * blockDim.x + threadIdx.x;
    if (inpid < graph.nnodes) id = inpid;


    if (id < graph.nnodes) {

        if(cs.isBoss(id)) {

            if(goaheadnodeofcomponent[id] != graph.nnodes) {
                unsigned minwt_node = goaheadnodeofcomponent[id];
                unsigned degree = graph.getOutDegree(minwt_node);
                foru minwt = minwtcomponent[id];

                if(minwt != MYINFINITY) {
                    verify_min_elem_child_cdp<<<(int)ceil((float)degree/BLOCK_DIM), BLOCK_DIM>>>(graph, cs, minwt_node, minwt, partners, processinnextiteration, /*goaheadnodeofcomponent, src,*/ id, /*srcboss,*/ degree);
                }
            }
        }
    }

}

void launch_verify_kernel(unsigned int nb, unsigned int nt, unsigned *mstwt, Graph graph, ComponentSpace cs, foru *eleminwts, foru *minwtcomponent, unsigned *partners, unsigned *phore, bool *processinnextiteration, unsigned *goaheadnodeofcomponent, unsigned inpid) {
    verify_min_elem_cdp<<<nb, nt>>>(mstwt, graph, cs, eleminwts, minwtcomponent, partners, phore, processinnextiteration, goaheadnodeofcomponent, inpid);
}


