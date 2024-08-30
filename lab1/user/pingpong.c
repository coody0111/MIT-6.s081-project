#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#define Size 16
int main(int argc, char *argv[])
{
    int p1[2], p2[2];
    pipe(p1); // 父 -> 子
    pipe(p2); // 子 -> 父
    char buf[Size] = {'0'};
    int getpd = getpid(); // 用於print時的pidnumber
    if (argc != 1)
    {
        printf("error");
        exit(1);
    }
    // read(fd, buf, n)
    // write(fd, buf, n)
    // remind: p1 : parent -> child
    // remind: p2 : child -> parent
    // 1 write
    // 0 read

    if (fork() == 0) // 子行程
    {

        close(p1[1]);        // 關閉p1的寫端，接受p1由父行程寫入
        close(p2[0]);        // 在p2當中，子行程會直接寫入給父行程
        read(p1[0], buf, 1); // 讀取父行程寫入的data
        printf("%d: received ping\n", getpd);
        write(p2[1], buf, 1);

        close(p1[0]);
        close(p2[1]);
        exit(0);
    }
    else // 父行程
    {

        close(p1[0]);
        close(p2[1]);
        write(p1[1], buf, 1);
        close(p1[1]);
        wait(0);
        printf("%d: received pong\n", getpd);
        read(p2[0], buf, 1); // 讀子行程在p2寫給父的data
        close(p1[1]);
        close(p2[0]);
        exit(0);
    }

    exit(0);
}