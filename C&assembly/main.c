#include <stdio.h>

extern unsigned int test();
extern unsigned int test2();
extern unsigned int test3(int);
extern unsigned int test4(int [], unsigned int);

int main() {
    test();
    int index = test2();
    printf("Index: %d\n",index);
    printf("Pierwsza: %d\n",test3(3)); //pierwsza
    printf("Nie pierwsza: %d\n",test3(24));    //nie pierwsza
    int input4[]={1,2,3,4,5,6,7};
    //printf("%d",sizeof(input4)/sizeof(input4[0]));
    test4(input4,sizeof(input4)/sizeof(input4[0]));
    for (int i = 0; i < sizeof(input4)/sizeof(input4[0]); ++i) {
        printf("%d: %d\n",i+1,input4[i]);
    }
    return 0;
}
