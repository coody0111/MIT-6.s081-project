#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int 
main(int argc, char *argv[]){
    if(argc < 2){
        printf("error");
        exit(1); // 異常退出
    }
    // argv = {program(sleep), "3"};
    int convert= atoi(argv[1]);
    sleep(convert);

    exit(0); //完成結束
}


