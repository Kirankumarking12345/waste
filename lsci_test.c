#include <stdio.h>
#include <stdint.h>  //get uint16_t
#include <math.h>    //floor function
#include <stdlib.h>  //rand function
#include <gtk/gtk.h> // for developing ui
#include <gdk-pixbuf/gdk-pixbuf.h>
#include <time.h>
#include <omp.h>
#include <sys/time.h>

#define save
GError *error;
clock_t start, end;
double cpu_time_used;

int timer_flag = 0;
struct timeval start_time, end_time;
double elapsed_time;

#define wi 1920
#define h 1200
int laser = 7;
#define size wi *h
uint16_t *a[h];
float *Z[h];
int *dis[h];
float *zimg[h + 4]; // Zero Padded Array

#ifdef save
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
#endif
// main function
int main()
{
//  start = clock();
  gettimeofday(&start_time, NULL);
  // a is image
  int tempp, k;
  // unsigned char a[wi][h];
  /******      image dimensions      ******/

#pragma omp parallel for
  for (int i = 0; i < h; i++)
  {
    a[i] = (uint16_t *)malloc((wi) * sizeof(uint16_t));
    Z[i] = (float *)malloc((wi) * sizeof(float));
    dis[i] = (int *)malloc((wi) * sizeof(int));
  }

// Create Zero padded array
#pragma omp parallel for
  for (int i = 0; i < h + 4; i++)
    zimg[i] = (float *)malloc((wi + 4) * sizeof(float));
uint16_t buffer[size];
int img;
float mean, mean_data[100];
char name[50];



/********	for multiple images change the number		*********************/
#pragma omp parallel for private(mean)
for (img=283; img<=283; img++)
{
	//int id = omp_get_thread_num();
    //printf("thread %d, iteration %d mean : %f\n", id, img,mean);
  
  FILE *ptr;
  sprintf(name,"/home/ayati/Desktop/lsci/data/RemoveBG_%d.bin",img);
//sprintf(name,"mono8.bin");
  ptr = fopen(name, "rb");
  fread(buffer, sizeof(buffer), 1, ptr);
  if (!ptr)
  {
    printf("Unable to open file!");
    //return 1;
  }
  #pragma omp parallel for 
  for (int i = 0; i < h; i++)
  {
    #pragma omp parallel for 
    for (int j = 0; j < wi; j++)
    {
      // if((int)buffer[k]==0) buffer[k] = 1;
      //a[i][j] = (int)(buffer[k]);
      a[i][j] = ((int)buffer[i * wi + j] != 0) ? (int)(buffer[i * wi + j]) : 1;
    }
    // printf("\n\n");
  }
  //printf("%d\n",k);
  fclose(ptr);
  

  //printf("read done\n");

  /************************************************
   *
   * 				LSCI
   *
   * *********************************************/
  //--printf ("LSCI Started\n");

  // get the window and half window
  int w = 5;
  int half_w = floor(w / 2);

// Fill Zero Padded Array
#pragma omp parallel for
  for (int i = 0; i < h + 4; i++)
  {
#pragma omp parallel for
    for (int j = 0; j < wi + 4; j++)
    {
      if ((i > 1 && j > 1) && (i < h + 2 && j < wi + 2)) // if inside the 4 corners add the image values
      {
        zimg[i][j] = a[i - 2][j - 2];
        // printf("value = %f\n", zimg[i][j]);
      }
      else // if outside add zero padding
      {
        zimg[i][j] = 0;
      }
    }
  }
/*
  FILE *f;
  f = fopen("kiran.pgm", "wb");
  if (!f) {
    printf("Unable to create file.\n");
    return 1;
  }

  fprintf(f, "P5\n%d %d\n255\n", wi+4, h+4);

  for (int i = 0; i < h+4; i++) // h-2
  {
    for (int j = 0; j < wi+4; j++)
    {
       // Normalise & invert the image
      fputc(zimg[i][j],f);
      //fputc(a[i * wi + j], f);
    }
  }
  fclose(f);
*/
  float s = 0;    // sum = 0
  float m = 0.0;  // mean = 0
  float sd = 0.0; // sd = 0
  float SD = 0.0; // sd power sum =0
  // float Z[row][col]; //get file here

  float x = 0; // temporary variable
  // find max of Z for normalization
  float max = 0;

  int i;
#pragma omp parallel for
  for (i = 2; i < h + 2; i++) // h -2
  {
#pragma omp parallel for private(s, m, SD, x, sd)
    for (int j = 2; j < wi + 2; j++) // wi -2
    {
      s = 0; // sum =0
      s = zimg[i - 2][j - 2] + zimg[i - 2][j - 1] + zimg[i - 2][j] + zimg[i - 2][j + 1] + zimg[i - 2][j + 2] +
          zimg[i - 1][j - 2] + zimg[i - 1][j - 1] + zimg[i - 1][j] + zimg[i - 1][j + 1] + zimg[i - 1][j + 2] +
          zimg[i][j - 2] + zimg[i][j - 1] + zimg[i][j] + zimg[i][j + 1] + zimg[i][j + 2] +
          zimg[i + 1][j - 2] + zimg[i + 1][j - 1] + zimg[i + 1][j] + zimg[i + 1][j + 1] + zimg[i + 1][j + 2] +
          zimg[i + 2][j - 2] + zimg[i + 2][j - 1] + zimg[i + 2][j] + zimg[i + 2][j + 1] + zimg[i + 2][j + 2];

      m = s / 25; // get mean s/(w*w)
      // printf("value = %f\n", m);
      SD = 0; // set SD to 0

      // get SD of the specific window
      for (int k = i - 2; k < i + w - 2; k++)
      {
        for (int l = j - 2; l < j + w - 2; l++)
        {
          x = (zimg[k][l] > m) ? zimg[k][l] - m : m - zimg[k][l];
          // SD += pow(x, 2); //This statement is slow
          SD = SD + x * x;
        }
      } // standard deviation

      sd = SD / (w * w); // get standard deviation
      // printf("value = %f\n", sd);
      sd = sqrt(sd);
      // printf("value = %f\n", sd);
      Z[i - 2][j - 2] = sd / m; // get temporary LSCI array
      // printf("value = %f\n", Z[i-2][j-2]);

      if (Z[i - 2][j - 2] > max)
      {
        max = Z[i - 2][j - 2];
      }
    }
  }
  printf("max value : %f \n",max);

int pix=0;
mean = 0;
#pragma omp parallel for
  for (int i = 0; i < h; i++) // h-2
  {
#pragma omp parallel for
    for (int j = 0; j < wi; j++)
    {
    //if(Z[i][j]>1)
    //	Z[i][j]=1;
    
    
      Z[i][j] = (Z[i][j] / max); // Normalise & invert the image
      if(i == j)
      {
        mean = mean+Z[i][j];
        pix++;
      }

      // dis[i][j] = (Z[i][j] < 0.75) ? 0 : floor( (Z[i][j]- 0.75) * (4*255) ) ;  ////get values between 0.75-1 & //maximum value to be 255. For Ex. max. value is 0.25 then 0.25*4*255 = 255
    }
  }
  mean_data[img-1] = mean /pix;
  
}




      

      gettimeofday(&end_time, NULL);
      elapsed_time = (end_time.tv_sec - start_time.tv_sec) +
                     (end_time.tv_usec - start_time.tv_usec) / 1000000.0;
                     
      printf("The time elapsed is :%f", elapsed_time);
/*
  end = clock();
  printf("%d Its done....\n",img);
  cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;
  printf("Its done....\nmean: %f\nTime taken:%f Seconds\n",mean_data[img-2],cpu_time_used);
  */
#ifdef save
  float range_min = 0.86;
  float range_max = 0.93;
  float range = range_max - range_min;
  float rangeinv = 1 / range;
  // Put greyscale image data from the camera into the RGB buffer.
  rgb *buffer_rgb = (rgb *)malloc(1920 * 1200 * sizeof(rgb));
#pragma omp parallel for
  for (int x = 0; x < 1200; x++)
  {
#pragma omp parallel for
    for (int y = 0; y < 1920; y++)
    {
      // Convert 1 byte greyscale in 3 byte RGB:
      uint8_t grey = (Z[x][y] > range_min) ? ((Z[x][y] < range_max) ? ((Z[x][y] - range_min) * rangeinv * 255) : 255) : 0;
      buffer_rgb[1920 * x + y].b = lookup_table[grey][2]; //(grey > range_max) ? 255 : ((grey > range_min) ? floor((grey - range_min) * (rangeinv) *255) : 0) ;
      buffer_rgb[1920 * x + y].g = lookup_table[grey][1];
      buffer_rgb[1920 * x + y].r = lookup_table[grey][0]; //(grey < range_min) ? 255 : ((grey < range_max) ? floor((range_max - grey) * (rangeinv) *255) : 0);
    }
  }

  

  GdkPixbuf *pixbuf = gdk_pixbuf_new_from_data((guchar *)buffer_rgb, GDK_COLORSPACE_RGB, FALSE, 8, 1920, 1200, 1920 * sizeof(rgb), NULL, NULL);


  /***************      Perfusion       *********************/
  float perfusion_sum = 0;

  // save image
  char color[50];

  if (!gdk_pixbuf_save(pixbuf, "colormap.png", "png", &error, NULL))
  {
    g_printerr("Error saving image: %s\n", error->message);
    g_error_free(error);
  }

  // printf("textview = %s\n", gtk_text_buffer_get_text(textbuffer, &start, &end, FALSE));
  // sprintf(reportname, "%s/contrast_%s.pgm", dirbase, gtk_text_buffer_get_text(textbuffer, &start, &end, FALSE));

  FILE *pgmimg;
  pgmimg = fopen("lsci_img.pgm", "wb");
  //fprintf(pgmimg, "P5\n");

  // Writing Width and Height
  //fprintf(pgmimg, "%d %d\n", wi, h);
float maxx=0;
  // Writing the maximum gray value
  //fprintf(pgmimg, "255\n");
  fprintf(pgmimg, "P5\n%d %d\n255\n", wi, h);
  int count = 255;
  // printf("\n%d %d",wi,h);
  for (int i = 0; i < 1200; i++)
  {
    for (int j = 0; j < 1920; j++)
    {
      // Writing the gray values in the 2D array to the file
      fputc(Z[i][j] * 255, pgmimg);
      if(Z[i][j]>maxx)
      	maxx= Z[i][j];
//      fprintf(pgmimg, "%d ", (uint8_t)floor(Z[i][j] * 255));
    }
    //fprintf(pgmimg, "\n");
  }
  printf("MAx :%f\n",maxx);
  fclose(pgmimg);
  printf("\nContrast imaging saved successfully...\n");

#endif
}
