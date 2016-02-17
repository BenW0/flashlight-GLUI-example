#include "kernel.h"
#define TX 32
#define TY 32

__device__
unsigned char clip(int n) { return n > 255 ? 255 : (n < 0 ? 0 : n); }

__global__
void distanceKernel(uchar4 *d_out, int w, int h, float2 pos1, float2 pos2, float2 pos3, float size3) {
  // pixel/thread mapping
  const int c = blockIdx.x*blockDim.x + threadIdx.x;
  const int r = blockIdx.y*blockDim.y + threadIdx.y;

  if ((c >= w) || (r >= h)) return; // Check if within image bounds

  const int i = c + r*w; // 1D indexing
  const int dist1 = sqrtf((c - pos1.x)*(c - pos1.x) + 
	  (r - pos1.y)*(r - pos1.y));
  const int dist2 = sqrtf((c - pos2.x)*(c - pos2.x) +
	  (r - pos2.y)*(r - pos2.y));
  const int dist3 = sqrtf((c - pos3.x)*(c - pos3.x) +
	  (r - pos3.y)*(r - pos3.y)) * size3;

  d_out[i].x = clip(255 - dist1);
  d_out[i].y = clip(255 - dist2);
  d_out[i].z = clip(255 - dist3);
  d_out[i].w = 255;
}

void kernelLauncher(uchar4 *d_out, int w, int h, float2 pos1, float2 pos2, float2 pos3, float size3) {
  const dim3 blockSize(TX, TY);
  const dim3 gridSize = dim3((w + TX - 1)/TX, (h + TY - 1)/TY);
  distanceKernel<<<gridSize, blockSize>>>(d_out, w, h, pos1, pos2, pos3, size3);
}