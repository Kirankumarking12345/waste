#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <sys/time.h>
#include <time.h>

int timer_flag = 0;
struct timeval start_time, end_time;
double elapsed_time;

#define wi 1920
#define h 1200
#define BUFFER_SIZE wi *h

typedef struct
{
  uint8_t r;
  uint8_t g;
  uint8_t b;
} rgb;

/********************LUT Colorspce*************************/
uint8_t lookup_table[256][3] =
    {
        {48, 18, 59},
        {49, 21, 66},
        {50, 24, 74},
        {52, 27, 81},
        {53, 30, 88},
        {54, 33, 95},
        {55, 35, 101},
        {56, 38, 108},
        {57, 41, 114},
        {58, 44, 121},
        {59, 47, 127},
        {60, 50, 133},
        {60, 53, 139},
        {61, 55, 145},
        {62, 58, 150},
        {63, 61, 156},
        {64, 64, 161},
        {64, 67, 166},
        {65, 69, 171},
        {65, 72, 176},
        {66, 75, 181},
        {67, 78, 186},
        {67, 80, 190},
        {67, 83, 194},
        {68, 86, 199},
        {68, 88, 203},
        {69, 91, 206},
        {69, 94, 210},
        {69, 96, 214},
        {69, 99, 217},
        {70, 102, 221},
        {70, 104, 224},
        {70, 107, 227},
        {70, 109, 230},
        {70, 112, 232},
        {70, 115, 235},
        {70, 117, 237},
        {70, 120, 240},
        {70, 122, 242},
        {70, 125, 244},
        {70, 127, 246},
        {70, 130, 248},
        {69, 132, 249},
        {69, 135, 251},
        {69, 137, 252},
        {68, 140, 253},
        {67, 142, 253},
        {66, 145, 254},
        {65, 147, 254},
        {64, 150, 254},
        {63, 152, 254},
        {62, 155, 254},
        {60, 157, 253},
        {59, 160, 252},
        {57, 162, 252},
        {56, 165, 251},
        {54, 168, 249},
        {52, 170, 248},
        {51, 172, 246},
        {49, 175, 245},
        {47, 177, 243},
        {45, 180, 241},
        {43, 182, 239},
        {42, 185, 237},
        {40, 187, 235},
        {38, 189, 233},
        {37, 192, 230},
        {35, 194, 228},
        {33, 196, 225},
        {32, 198, 223},
        {30, 201, 220},
        {29, 203, 218},
        {28, 205, 215},
        {27, 207, 212},
        {26, 209, 210},
        {25, 211, 207},
        {24, 213, 204},
        {24, 215, 202},
        {23, 217, 199},
        {23, 218, 196},
        {23, 220, 194},
        {23, 222, 191},
        {24, 224, 189},
        {24, 225, 186},
        {25, 227, 184},
        {26, 228, 182},
        {27, 229, 180},
        {29, 231, 177},
        {30, 232, 175},
        {32, 233, 172},
        {34, 235, 169},
        {36, 236, 166},
        {39, 237, 163},
        {41, 238, 160},
        {44, 239, 157},
        {47, 240, 154},
        {50, 241, 151},
        {53, 243, 148},
        {56, 244, 145},
        {59, 244, 141},
        {63, 245, 138},
        {66, 246, 135},
        {70, 247, 131},
        {74, 248, 128},
        {77, 249, 124},
        {81, 249, 121},
        {85, 250, 118},
        {89, 251, 114},
        {93, 251, 111},
        {97, 252, 108},
        {101, 252, 104},
        {105, 253, 101},
        {109, 253, 98},
        {113, 253, 95},
        {116, 254, 92},
        {120, 254, 89},
        {124, 254, 86},
        {128, 254, 83},
        {132, 254, 80},
        {135, 254, 77},
        {139, 254, 75},
        {142, 254, 72},
        {146, 254, 70},
        {149, 254, 68},
        {152, 254, 66},
        {155, 253, 64},
        {158, 253, 62},
        {161, 252, 61},
        {164, 252, 59},
        {166, 251, 58},
        {169, 251, 57},
        {172, 250, 55},
        {174, 249, 55},
        {177, 248, 54},
        {179, 248, 53},
        {182, 247, 53},
        {185, 245, 52},
        {187, 244, 52},
        {190, 243, 52},
        {192, 242, 51},
        {195, 241, 51},
        {197, 239, 51},
        {200, 238, 51},
        {202, 237, 51},
        {205, 235, 52},
        {207, 234, 52},
        {209, 232, 52},
        {212, 231, 53},
        {214, 229, 53},
        {216, 227, 53},
        {218, 226, 54},
        {221, 224, 54},
        {223, 222, 54},
        {225, 220, 55},
        {227, 218, 55},
        {229, 216, 56},
        {231, 215, 56},
        {232, 213, 56},
        {234, 211, 57},
        {236, 209, 57},
        {237, 207, 57},
        {239, 205, 57},
        {240, 203, 58},
        {242, 200, 58},
        {243, 198, 58},
        {244, 196, 58},
        {246, 194, 58},
        {247, 192, 57},
        {248, 190, 57},
        {249, 188, 57},
        {249, 186, 56},
        {250, 183, 55},
        {251, 181, 55},
        {251, 179, 54},
        {252, 176, 53},
        {252, 174, 52},
        {253, 171, 51},
        {253, 169, 50},
        {253, 166, 49},
        {253, 163, 48},
        {254, 161, 47},
        {254, 158, 46},
        {254, 155, 45},
        {254, 152, 44},
        {253, 149, 43},
        {253, 146, 41},
        {253, 143, 40},
        {253, 140, 39},
        {252, 137, 38},
        {252, 134, 36},
        {251, 131, 35},
        {251, 128, 34},
        {250, 125, 32},
        {250, 122, 31},
        {249, 119, 30},
        {248, 116, 28},
        {247, 113, 27},
        {247, 110, 26},
        {246, 107, 24},
        {245, 104, 23},
        {244, 101, 22},
        {243, 99, 21},
        {242, 96, 20},
        {241, 93, 19},
        {239, 90, 17},
        {238, 88, 16},
        {237, 85, 15},
        {236, 82, 14},
        {234, 80, 13},
        {233, 77, 13},
        {232, 75, 12},
        {230, 73, 11},
        {229, 70, 10},
        {227, 68, 10},
        {226, 66, 9},
        {224, 64, 8},
        {222, 62, 8},
        {221, 60, 7},
        {219, 58, 7},
        {217, 56, 6},
        {215, 54, 6},
        {214, 52, 5},
        {212, 50, 5},
        {210, 48, 5},
        {208, 47, 4},
        {206, 45, 4},
        {203, 43, 3},
        {201, 41, 3},
        {199, 40, 3},
        {197, 38, 2},
        {195, 36, 2},
        {192, 35, 2},
        {190, 33, 2},
        {187, 31, 1},
        {185, 30, 1},
        {182, 28, 1},
        {180, 27, 1},
        {177, 25, 1},
        {174, 24, 1},
        {172, 22, 1},
        {169, 21, 1},
        {166, 20, 1},
        {163, 18, 1},
        {160, 17, 1},
        {157, 16, 1},
        {154, 14, 1},
        {151, 13, 1},
        {148, 12, 1},
        {145, 11, 1},
        {142, 10, 1},
        {139, 9, 1},
        {135, 8, 1},
        {132, 7, 1},
        {129, 6, 2},
        {125, 5, 2},
        {122, 4, 2}};
/*********************************************************/
/*

__global__ void fillZeroPaddedArray(uint16_t *buffer, float *zimg, int w)
{
  // int half_w = floor(w / 2);
  int i = blockIdx.x * blockDim.x + threadIdx.x;
  // printf("%d vale i\n",i);
  int j = blockIdx.y * blockDim.y + threadIdx.y;

  if (i < h + 4 && j < wi + 4)
  {
    if ((i > 1 && j > 1) && (i < h + 2 && j < wi + 2))
    {
      zimg[i * (wi + 4) + j] = (float)buffer[(i - 2) * wi + (j - 2)];
    }
    else
    {
      zimg[i * (wi + 4) + j] = (float)255;
    }
  }
}
*/
__global__ void lsci_kernel(uint16_t *buffer, float *zimg, float *Z, float *maxVal)
{
  float s = 0;
  float m = 0.0;
  float sd = 0.0;
  float SD = 0.0;
  float x = 0;
  int w = 5;
  
  int i = blockIdx.x * blockDim.x + threadIdx.x;
  // printf("%d vale i\n",i);
  int j = blockIdx.y * blockDim.y + threadIdx.y;

  if (i < h + 4 && j < wi + 4)
  {
    if ((i > 1 && j > 1) && (i < h + 2 && j < wi + 2))
    {
      zimg[i * (wi + 4) + j] = (float)buffer[(i - 2) * wi + (j - 2)];
    }
    else
    {
      zimg[i * (wi + 4) + j] = (float)255;
    }
  }
  
  //int i = blockIdx.x * blockDim.x + threadIdx.x;
  //int j = blockIdx.y * blockDim.y + threadIdx.y;

  if ((i >= 2 && i < h + 2) && (j >= 2 && j < wi + 2))
  {
    // printf("hello");
    s = 0;

    s = zimg[(i - 2) * (wi + 4) + (j - 2)] + zimg[(i - 2) * (wi + 4) + (j - 1)] + zimg[(i - 2) * (wi + 4) + j] + zimg[(i - 2) * (wi + 4) + (j + 1)] + zimg[(i - 2) * (wi + 4) + (j + 2)] +
        zimg[(i - 1) * (wi + 4) + (j - 2)] + zimg[(i - 1) * (wi + 4) + (j - 1)] + zimg[(i - 1) * (wi + 4) + j] + zimg[(i - 1) * (wi + 4) + (j + 1)] + zimg[(i - 1) * (wi + 4) + (j + 2)] +
        zimg[i * (wi + 4) + (j - 2)] + zimg[i * (wi + 4) + (j - 1)] + zimg[i * (wi + 4) + j] + zimg[i * (wi + 4) + (j + 1)] + zimg[i * (wi + 4) + (j + 2)] +
        zimg[(i + 1) * (wi + 4) + (j - 2)] + zimg[(i + 1) * (wi + 4) + (j - 1)] + zimg[(i + 1) * (wi + 4) + j] + zimg[(i + 1) * (wi + 4) + (j + 1)] + zimg[(i + 1) * (wi + 4) + (j + 2)] +
        zimg[(i + 2) * (wi + 4) + (j - 2)] + zimg[(i + 2) * (wi + 4) + (j - 1)] + zimg[(i + 2) * (wi + 4) + j] + zimg[(i + 2) * (wi + 4) + (j + 1)] + zimg[(i + 2) * (wi + 4) + (j + 2)];

    m = s / 25;
    SD = 0;

    SD =  (zimg[(i - 2) * (wi + 4) + (j - 2)] - m) * (zimg[(i - 2) * (wi + 4) + (j - 2)] - m)
        + (zimg[(i - 2) * (wi + 4) + (j - 1)] - m) * (zimg[(i - 2) * (wi + 4) + (j - 1)] - m)
        + (zimg[(i - 2) * (wi + 4) + j] - m) * (zimg[(i - 2) * (wi + 4) + j] - m)
        + (zimg[(i - 2) * (wi + 4) + (j + 1)] - m) * (zimg[(i - 2) * (wi + 4) + (j + 1)] - m)
        + (zimg[(i - 2) * (wi + 4) + (j + 2)] - m) * (zimg[(i - 2) * (wi + 4) + (j + 2)] - m)

        + (zimg[(i - 1) * (wi + 4) + (j - 2)] - m) * (zimg[(i - 1) * (wi + 4) + (j - 2)] - m)
        + (zimg[(i - 1) * (wi + 4) + (j - 1)] - m) * (zimg[(i - 1) * (wi + 4) + (j - 1)] - m)
        + (zimg[(i - 1) * (wi + 4) + j] - m) * (zimg[(i - 1) * (wi + 4) + j] - m)
        + (zimg[(i - 1) * (wi + 4) + (j + 1)] - m) * (zimg[(i - 1) * (wi + 4) + (j + 1)] - m)
        + (zimg[(i - 1) * (wi + 4) + (j + 2)] - m) * (zimg[(i - 1) * (wi + 4) + (j + 2)] - m)

        + (zimg[i * (wi + 4) + (j - 2)] - m) * (zimg[i * (wi + 4) + (j - 2)] - m)
        + (zimg[i * (wi + 4) + (j - 1)] - m) * (zimg[i * (wi + 4) + (j - 1)] - m)
        + (zimg[i * (wi + 4) + j] - m) * (zimg[i * (wi + 4) + j] - m)
        + (zimg[i * (wi + 4) + (j + 1)] - m) * (zimg[i * (wi + 4) + (j + 1)] - m)
        + (zimg[i * (wi + 4) + (j + 2)] - m) * (zimg[i * (wi + 4) + (j + 2)] - m)

        + (zimg[(i + 1) * (wi + 4) + (j - 2)] - m) * (zimg[(i + 1) * (wi + 4) + (j - 2)] - m)
        + (zimg[(i + 1) * (wi + 4) + (j - 1)] - m) * (zimg[(i + 1) * (wi + 4) + (j - 1)] - m)
        + (zimg[(i + 1) * (wi + 4) + j] - m) * (zimg[(i + 1) * (wi + 4) + j] - m)
        + (zimg[(i + 1) * (wi + 4) + (j + 1)] - m) * (zimg[(i + 1) * (wi + 4) + (j + 1)] - m)
        + (zimg[(i + 1) * (wi + 4) + (j + 2)] - m) * (zimg[(i + 1) * (wi + 4) + (j + 2)] - m)

        + (zimg[(i + 2) * (wi + 4) + (j - 2)] - m) * (zimg[(i + 2) * (wi + 4) + (j - 2)] - m)
        + (zimg[(i + 2) * (wi + 4) + (j - 1)] - m) * (zimg[(i + 2) * (wi + 4) + (j - 1)] - m)
        + (zimg[(i + 2) * (wi + 4) + j] - m) * (zimg[(i + 2) * (wi + 4) + j] - m)
        + (zimg[(i + 2) * (wi + 4) + (j + 1)] - m) * (zimg[(i + 2) * (wi + 4) + (j + 1)] - m)
        + (zimg[(i + 2) * (wi + 4) + (j + 2)] - m) *  (zimg[(i + 2) * (wi + 4) + (j + 2)] - m) ;

        
     /*   
    for (int k = i - 2; k < i + w - 2; k++)
    {
      for (int l = j - 2; l < j + w - 2; l++)
      {
        x = (zimg[k * (wi + 4) + l] > m) ? zimg[k * (wi + 4) + l] - m : m - zimg[k * (wi + 4) + l];
        SD = SD + x * x;
      }
    }
    */
    sd = SD / (w * w);

    sd = sqrt(sd);

    Z[(i - 2) * (wi) + (j - 2)] = sd / m;

    // atomicMax(maxVal, Z[(i - 2) * (wi) + (j - 2)]);

    // printf("%f ", *maxVal);

    /*
    if (Z[(i - 2) * (wi ) + (j - 2)] > *maxVal)
    {
        *maxVal = Z[(i - 2) * (wi) + (j - 2)];
    }
    printf("%f ", *maxVal);
    */
  }
}

__global__ void normalize_invert(float *Z, float max)
{
  int i = blockIdx.x * blockDim.x + threadIdx.x;
  int j = blockIdx.y * blockDim.y + threadIdx.y;

  if (i < h && j < wi)
  {
    Z[i * wi + j] = 1 - (Z[i * wi + j] / max); // Normalize & invert the image
  }
}


__global__ void grayscale_to_rgb_kernel(float *Z, uint8_t *lookup_table, rgb *buffer_rgb) {
    float range_min = 0.86;
  float range_max = 0.93;
  float range = range_max - range_min;
  float rangeinv = 1 / range;
    
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    int idy = blockIdx.y * blockDim.y + threadIdx.y;
    if (idx < 1200 && idy < 1920) {
        float grey = (Z[idx * 1920 + idy] > range_min) ? ((Z[idx * 1920 + idy] < range_max) ? ((Z[idx * 1920 + idy] - range_min) * rangeinv * 255) : 255) : 0;
        buffer_rgb[idx * 1920 + idy].b = lookup_table[(int)grey * 3 + 2];
        buffer_rgb[idx * 1920 + idy].g = lookup_table[(int)grey * 3 + 1];
        buffer_rgb[idx * 1920 + idy].r = lookup_table[(int)grey * 3];
    }
}

int img = 0;
char name[50];
int main(int argc, char **argv)
{
  gettimeofday(&start_time, NULL);
  uint16_t buffer[BUFFER_SIZE];

  uint16_t *a;
  float *zimg;
  float *Z;

  // buffer = (uint16_t *)malloc(BUFFER_SIZE* sizeof(uint16_t));
  a = (uint16_t *)malloc(h * wi * sizeof(uint16_t));
  Z = (float *)malloc((wi) * (h) * sizeof(float));
  zimg = (float *)malloc((wi + 4) * (h + 4) * sizeof(float));

  for (img = 1; img <= 1; img++)
  {
    FILE *ptr;
    sprintf(name, "/home/ayati/Desktop/lsci/data/RemoveBG_%d.bin", img);
    // printf("%s\n", name);
    ptr = fopen(name, "rb");
    if (!ptr)
    {
      printf("Unable to open file!");
      // return 1;
    }
    fread(buffer, sizeof(buffer), 1, ptr);
    fclose(ptr);

    int w = 5;
    int half_w = floor(w / 2);

    uint16_t *dev_buffer;
    float *dev_zimg;
    
    cudaMalloc((void **)&dev_buffer, sizeof(uint16_t) * h * wi);
    cudaMemcpy(dev_buffer, buffer, sizeof(uint16_t) * h * wi, cudaMemcpyHostToDevice);
    /*cudaMalloc((void **)&dev_zimg, sizeof(float) * (h + 4) * (wi + 4));

    // Copy input array from host to device
    cudaMemcpy(dev_buffer, buffer, sizeof(uint16_t) * h * wi, cudaMemcpyHostToDevice);

    // Define number of threads and blocks for the kernel
    dim3 threadsPerBlock(5, 5);
    dim3 numBlocks((h + 4 + threadsPerBlock.x - 1) / threadsPerBlock.x, (wi + 4 + threadsPerBlock.y - 1) / threadsPerBlock.y);

    // Call kernel function
    fillZeroPaddedArray<<<numBlocks, threadsPerBlock>>>(dev_buffer, dev_zimg, w);

    // Wait for kernel to finish
    cudaDeviceSynchronize();

    // Copy zero-padded array from device to host
    cudaMemcpy(zimg, dev_zimg, sizeof(float) * (h + 4) * (wi + 4), cudaMemcpyDeviceToHost);

    // Free memory on the GPU
    cudaFree(dev_buffer);
    cudaFree(dev_zimg);
*/
    /*
           FILE *f;
      f = fopen("kiran.pgm", "wb");
      if (!f) {
        printf("Unable to create file.\n");
        return;
      }

      fprintf(f, "P5\n%d %d\n255\n", wi+4, h+4);

      for (int i = 0; i < h+4; i++) // h-2
      {
        for (int j = 0; j < wi+4; j++)
        {
           // Normalise & invert the image
          fputc(zimg[i * (wi+4) + j],f);
          //fputc(a[i * wi + j], f);
        }
      }
      fclose(f);
      */

    float *d_zimg, *d_Z;
    float *d_maxVal;
    float maxVal = 0;
    cudaMalloc((void **)&d_zimg, sizeof(float) * (h + 4) * (wi + 4));
    cudaMalloc((void **)&d_Z, sizeof(float) * (h + 4) * (wi + 4));

    cudaMemcpy(d_maxVal, &maxVal, sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(d_zimg, zimg, sizeof(float) * (h + 4) * (wi + 4), cudaMemcpyHostToDevice);

    dim3 threadsBlock(5, 5);
    dim3 num_Blocks((h + threadsBlock.x - 1) / threadsBlock.x, (wi + threadsBlock.y - 1) / threadsBlock.y);

    lsci_kernel<<<num_Blocks, threadsBlock>>>(dev_buffer,d_zimg, d_Z, d_maxVal);

    cudaMemcpy(Z, d_Z, sizeof(float) * (h + 4) * (wi + 4), cudaMemcpyDeviceToHost);
    cudaMemcpy(&maxVal, d_maxVal, sizeof(float), cudaMemcpyDeviceToHost);

    cudaFree(d_zimg);
    cudaFree(d_Z);

    /*finding max*/
    float max = 0;
    for (int i = 0; i < h; i++) // h-2
    {
      for (int j = 0; j < wi; j++)
      {
        // if(Z[(i) * (wi) + (j)] > 1)printf("%f ", Z[(i) * (wi) + (j)]);
        if (Z[(i) * (wi) + (j)] > max)
          max = Z[(i) * (wi) + (j)]; 
      }
    }

     //printf("%f ", max);
//max = 1.5;
    cudaMalloc(&d_Z, h * wi * sizeof(float));

    // Copy input data from host to device
    cudaMemcpy(d_Z, Z, h * wi * sizeof(float), cudaMemcpyHostToDevice);

    // Launch kernel with appropriate grid and block size
    dim3 blockDim(5, 5);
    dim3 gridDim((h + blockDim.x - 1) / blockDim.x, (wi + blockDim.y - 1) / blockDim.y);
    normalize_invert<<<gridDim, blockDim>>>(d_Z, max);

    // Copy output data from device to host
    cudaMemcpy(Z, d_Z, h * wi * sizeof(float), cudaMemcpyDeviceToHost);

    // Free memory on device
    cudaFree(d_Z);

uint8_t *d_lookup_table;
rgb *d_buffer_rgb;

rgb *buffer_rgb = (rgb *)malloc(1920 * 1200 * sizeof(rgb));
  cudaMalloc(&d_Z, 1200 * 1920 * sizeof(float));
  cudaMalloc(&d_lookup_table, 256 * 3 * sizeof(uint8_t));
  cudaMalloc(&d_buffer_rgb, 1200 * 1920 * sizeof(rgb));

  cudaMemcpy(d_Z, Z, 1200 * 1920 * sizeof(float), cudaMemcpyHostToDevice);
  cudaMemcpy(d_lookup_table, lookup_table, 256 * 3 * sizeof(uint8_t), cudaMemcpyHostToDevice);

  dim3 block_size(32, 32);
  dim3 grid_size((1200 + block_size.x - 1) / block_size.x, (1920 + block_size.y - 1) / block_size.y);
  grayscale_to_rgb_kernel<<<grid_size, block_size>>>(d_Z, d_lookup_table, d_buffer_rgb);

  cudaMemcpy(buffer_rgb, d_buffer_rgb, 1200 * 1920 * sizeof(rgb), cudaMemcpyDeviceToHost);

  // Use buffer_rgb here

  cudaFree(d_Z);
  cudaFree(d_lookup_table);
  cudaFree(d_buffer_rgb);

  FILE *fp = fopen("color_output.ppm", "wb");
  fprintf(fp, "P3\n");
  fprintf(fp, "1920 1200\n");
  fprintf(fp, "255\n");
  for (int i = 0; i < 1920 * 1200; i++) {
    fprintf(fp, "%d %d %d ", buffer_rgb[i].r, buffer_rgb[i].g, buffer_rgb[i].b);
  }
  fclose(fp);

   }

    gettimeofday(&end_time, NULL);
          elapsed_time = (end_time.tv_sec - start_time.tv_sec) +
                         (end_time.tv_usec - start_time.tv_usec) / 1000000.0;

          printf("The time elapsed is :%f", elapsed_time);
    FILE *f;
    f = fopen("kiran.pgm", "wb");
    if (!f)
    {
      printf("Unable to create file.\n");
      return;
    }

    fprintf(f, "P5\n%d %d\n255\n", wi, h);

    for (int i = 0; i < h; i++) // h-2
    {
      for (int j = 0; j < wi; j++)
      {
        // Normalise & invert the image
        fputc(Z[i * (wi) + j] * 255, f);
        // fputc(a[i * wi + j], f);
      }
    }
    fclose(f);

   
   #ifdef solve 
  cudaDeviceReset();
#endif
  return 0;
}