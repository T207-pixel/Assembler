#include <iostream>
#include <stdio.h>
#include <vector>

void print(const std::vector<char> &str){
    for (char sym: str)
        std::cout << sym;   //untill end of string works only for vector// sys call
}

bool readWord(FILE *file, std::vector<char> &buf, char symbol){
    char ch = fgetc(file);  
    buf.push_back(ch);
    bool flag = true;
    while (ch != '\n' && ch != ' '){
        ch = fgetc(file);   // sys call
        if (ch == EOF) {
            flag = false;
            break;
        }
        buf.push_back(ch);
    }
    if (buf[0] == symbol){
        print(buf);
    }
    return flag;
}

char symbol(FILE *file, std::vector<char> &buf){
    char symbol;
    symbol = fgetc(file);   // sys call
    return symbol;
}

char firstWord(FILE *file, std::vector<char> &buf){
    char ch;
    while (ch != '\n' && ch != ' ') {
        ch = fgetc(file);
        buf.push_back(ch);
    }
    print(buf);
    char symbol = buf[0];
    return symbol;
}

int main(){
    FILE *file;
    char symbol;
    file = fopen("/home/tim/C++/lab3/string", "r"); // sys call
    if (file == NULL)
        std::cout << "ERROR";                       // sys call
    std::vector<char> fW;
    symbol = firstWord(file, fW);
    bool flag = true;
    while (flag){
        std::vector<char> buf;
        flag = readWord(file, buf, symbol);
    }
    fclose(file);                                   // sys call
    return 0;
}

