#include <iostream>

void swap(int &a, int &b){
    int buf1 = a;
    a = b;
    b = buf1;
}

void swapColumnsIndex(int *arr, int firstIndex, int secondIndex, int length, int size){   
    for (int i = 0; i < size; i += length){
        int buf = arr[firstIndex + i];
        arr[firstIndex + i] = arr[secondIndex + i];
        arr[secondIndex + i] = buf;
    }
}

void swapColumnsArithmetic(int *arr, int firstIndex, int secondIndex, int length, int hight){
    int *p1 = arr + firstIndex;
    int *p2 = arr + secondIndex;
    for (int i = 0; i < hight; i++){
        int buf = *p2;
        *p2 = *p1;
        *p1 = buf;
        p1 += length;
        p2 += length;
    }
}

int SearchBinary(int *arr, int left, int right, int key){
    int midd = 0;
    while (1){
        midd = (left + right) / 2;
        if (key < arr[midd])            
            right = midd - 1;           
        else if (key > arr[midd])       
            left = midd + 1;            
        else                           
            return midd;                

        if (left > right)                
            return -1;
    }
}

int* insertSortBinarySearch(int *arrMax, int *arrMatrix, int length, int size, int hight){      // int hight 
     for (int i = 1; i < length; i++){
        int j = i -1;
        if (arrMax[i] < arrMax[j]){
        int k = SearchBinary(arrMax, 0, j, arrMax[i]);
        for (int m = j; m > k; --m){ 
            if (arrMax[i] < arrMax[j]) {                              
                swap(arrMax[m], arrMax[m + 1]);                                     
                swapColumnsArithmetic(arrMatrix, m, m + 1, length, hight);
                i--;
                j--;
                }
            }
        }
    }
    return arrMatrix;
}



void maxInColumns(int *arr, int *resArr,  int length, int hight){
    for (int j = 0; j < length; j++){
        int max = *(arr + j);
        for (int i = j; i < j + length*(hight - 1); i += length){
            if (max < *(arr + i)){
                max = *(arr + i);
            }
        }
        resArr[j] = max;
    }
}

void printMatr(int *arr, int size, int length){ 
    int counter = 0;
    for (int i = 1; i < size + 1; i++){
        std::cout << arr[i - 1] <<" ";
        if (i%5 == 0){
            std::cout << "\n";
        }
    }
}

void printArr(int *arr, int length){
    for (int i = 0; i < length; i++)
        std::cout << arr[i] << " ";
    std::cout << "\n";
}

int main(){
    //data
    static const int size = 20;
    static const int miniSize = 5;
    int resArr[miniSize] = {0};
    int matrix[size] = {1, 2, 3, 4, 5,
                        9, 8, 7, 6, 5,         
                        1, 2, 3, 4, 5,
                        1, 2, 3, 4, 5};
    int length = 5;
    int hight = 4;
    
    std::cout << "Entered matrix:\n";
    printMatr(matrix, size, length);
    std::cout << "\n";
    std::cout << "Max in columns:\n";
    
    maxInColumns(matrix, resArr, length, hight); 
    
    printArr(resArr, length);
    std::cout << "\n";
    
    int *newArr = insertSortBinarySearch(resArr, matrix, length, size, hight);
    
    std::cout << "New matrix:\n";
    printMatr(newArr, size, length);
    std::cout << "\n";
    std::cout << "Sorted max elements:\n";
    printArr(resArr, length);
    return 0;
}


