//  Formula: cos(x)=П(1-(4x^2)/((2n-1)^2(П^2))
#include <iostream>
#include <cmath>
#include <cstdio>
#define Pi 3.14159265358979

double myAbs(double a){
    if (a < 0)
        a = a*(-1);
    return a;
}

double myPow(double base, double myExp){
    double res = 1;
    int counter = 0;
    for (int i = 0; i < myExp; i++){
        if (counter != myExp){
            counter++;
            res = res*base;
        }
    }
    return res;
}

int main() {
    std::cout << "Input X-> ";
    int x = 0;
    std::cin >> x;
    std::cout << "Enter accuracy-> ";
    double accuracy = 0;
    std::cin >> accuracy;
    double realCos = cos(x);
    double myCos = 1.0;
    int i = 1;
    std::cout << "Delta: "<< myAbs(realCos - myCos) << std::endl;
    while (myAbs(realCos - myCos) > accuracy){
        double current = 0;
        current = (1 - (4*pow(x,2))/(pow((2*i-1),2)*pow(Pi,2)));
        myCos = myCos * current;
        i++;
    }
    printf("Math.h cos: %.10f\n", realCos);
    printf("My cos: %.10f", myCos);
    return 0;
}
