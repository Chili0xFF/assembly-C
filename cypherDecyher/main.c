#include <stdio.h>
#include <string.h>

extern char encodeChar();
extern char decodeChar();
extern void encodeText(char[],char[],int,int);
extern void decodeText(char[],char[],int,int);

int main() {
    //printf("%c\n",encodeChar());
    //printf("%c\n",decodeChar());
    char text[]={"THSF"};
    char klucz[]="TEST";
    //printf("%d", strlen(text));
    //
    //encodeText( text,   klucz,    strlen(text),     strlen(klucz));
    decodeText(text,klucz,strlen(text),strlen(klucz));

    return 0;
}
