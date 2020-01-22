
#ifndef _COMMON_H_
#define _COMMON_H_

#include "lonestargpu/lonestargpu.h"
#include "lonestargpu/cutil_subset.h"

#define SSSP_VARIANT "lonestar"
#define BLOCK_DIM 128

#define TANGRAM 1

inline __device__
bool processedge(foru *dist, Graph &graph, unsigned src, unsigned ii, unsigned &dst) {
	//unsigned id = blockIdx.x * blockDim.x + threadIdx.x;
	dst = graph.getDestination(src, ii);
	if (dst >= graph.nnodes) return 0;

	foru wt = graph.getWeight(src, ii);
	if (wt >= MYINFINITY) return 0;

	foru altdist = dist[src] + wt;
	if (altdist < dist[dst]) {
	 	foru olddist = atomicMin(&dist[dst], altdist);
		if (altdist < olddist) {
			return true;
		} 
		// someone else updated distance to a lower value.
	}
	return false;
}

inline __device__
bool processnode(foru *dist, Graph &graph, unsigned work) {
	//unsigned id = blockIdx.x * blockDim.x + threadIdx.x;
	unsigned nn = work;
	if (nn >= graph.nnodes) return 0;
	bool changed = false;
	
	unsigned neighborsize = graph.getOutDegree(nn);
	for (unsigned ii = 0; ii < neighborsize; ++ii) {
		unsigned dst = graph.nnodes;
		foru olddist = processedge(dist, graph, nn, ii, dst);
		if (olddist) {
			changed = true;
		}
	}
	return changed;
}

#if TANGRAM
__global__ void drelax(unsigned int *outgoing_37, int ObjectSize_80,
                        int ObjectSize_81, int SourceSize_82,
                        unsigned int *dist_p_38, int ObjectSize_83,
                        unsigned int *dist_39, unsigned int *srcsrc_40,
                        int ObjectSize_84, int SourceSize_85,
                        unsigned int *psrc_41, unsigned int *edgessrcdst_42,
                        unsigned int *edgessrcwt_43, bool *changed_44,
                        unsigned int numNodes_45, unsigned int numEdges_46);


#else
__global__ void drelax(foru *dist, Graph graph, bool *changed);
#endif
void launch_kernel(unsigned int nb, unsigned int nt, foru *dist, Graph graph, bool *changed);

#endif

