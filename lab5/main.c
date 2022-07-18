#define STB_IMAGE_IMPLEMENTATION
#include "libs/stb_image.h"

#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "libs/stb_image_write.h"

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>

const char filename[] = "/home/tim/C++/lab5/girl.jpg";
const char resFilename1[] = "/home/tim/C++/lab5/result1.jpg";
const char resFilename2[] = "/home/tim/C++/lab5/result2.jpg";

void imageProcAsm(unsigned char* data,  unsigned char* newData, int x, int y, double angle);

void imageProcC(unsigned char* data, unsigned char* newData, int x, int y, double angle){
    // FORMULA: (x,y) = (x * cos(angle) - y * sin(angle), x * sin(angle)+y * cos(angle))
    // INDEX IN NEW ARRAY: ind = 3 * y * width + 3 * x
    // Go by pixels in new array
    for (int i = 0; i < x; i++){
        for (int j = 0; j < y; j++){
         // Counting index in  one-dimensional array
         int ind1 = 3 * ( j * x + i);
         int newX = round(i * cos(angle) - j * sin(angle));
         int newY = round(i * sin(angle) + j * cos(angle));
         if (newX < 0 || newY < 0)
             continue;
         int ind2 = 3 * (newY * x + newX);
         if (ind2 >= x * y * 3)     // out of array size
             continue;
         for (int k = 0; k < 3; k++)
             newData[ind1 + k] = data[ind2 + k];
        }
    }
}

int main() {
    clock_t t1;
    // Open image file
    int x, y, n;    //x = width, y = height, n = #8-bit components per pixel
    unsigned char* data = stbi_load(filename, &x, &y, &n, 3);
    unsigned char* newData1 = calloc(x * y * 3, sizeof(char));
    unsigned char* newData2 = calloc(x * y * 3, sizeof(char));
    // Processing image in C
    t1 = clock();
    imageProcC(data, newData1, x, y, M_PI / 10);  //works with small angles
    printf("C language time:    %lf\n", ((double)(clock() - t1)) / CLOCKS_PER_SEC);
    // Processing image in ASM
    t1 = clock();
    imageProcAsm(data, newData2, x, y, M_PI / 10);
    printf("ASM language time:    %lf\n", ((double)(clock() - t1)) / CLOCKS_PER_SEC);
    // Save new image
    stbi_write_jpg(resFilename1, x, y, 3, newData1, 100);
    stbi_write_png(resFilename2, x, y, 3, newData2, 100);
    free(newData1);
    free(newData2);
    return 0;
}