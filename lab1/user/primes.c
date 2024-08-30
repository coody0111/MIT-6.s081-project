#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

void filter(int pipec[2])
{
    int first;
    close(pipec[1]);
    if (read(pipec[0], &first, sizeof(int)) != sizeof(int))
    {
        exit(0); // 如果不相等，等同於已經沒有值可以繼續讀了，所以可以直接離開
    }
    else
    {
        printf("prime: %d\n", first); // 還有值可以讀，每當走到這一步都要把第一個print 出來
        int rpipe[2];
        pipe(rpipe);
        if (fork() == 0)
        {
            // child process
            close(pipec[0]); // 不處理舊pipeline，只處理新的pipeline (也就是rpipe)的值
            filter(rpipe);
        }
        else
        {
            int data;
            close(rpipe[0]); // 父行程關閉rpipe的讀端
            while (read(pipec[0], &data, sizeof(int)) == sizeof(int))
            {
                if (data % first != 0)
                {
                    write(rpipe[1], &data, sizeof(int));
                }
            }
            close(pipec[0]);
            close(rpipe[1]);
            wait(0);
            exit(0);
        }
    }
}

int main(int argc, char *argv[])
{
    int lp[2];
    pipe(lp);
    int pid = fork();
    if (pid == -1)
    {
        printf("This is error, please check pipeline\n");
        exit(1);
    }
    else if (pid == 0)
    {
        close(lp[1]);
        filter(lp);
        exit(0);
    }
    else
    {
        close(lp[0]);                 // 關閉父行程讀端
        for (int i = 2; i <= 35; ++i) // 從2開始寫入數字到管道
        {
            write(lp[1], &i, sizeof(int));
        }
        close(lp[1]); // 關閉父行程寫端
        wait(0);
    }
    exit(0);
}
