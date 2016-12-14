#ifndef KERNEL_H
#define KERNEL_H

struct uchar4;
struct float2;

void kernelLauncher(uchar4 *d_out, int w, int h, float2 pos1, float2 pos2, float2 pos3, float size3);

#endif