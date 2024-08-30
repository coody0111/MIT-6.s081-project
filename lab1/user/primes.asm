
user/_primes:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <filter>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

void filter(int pipec[2])
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	0080                	addi	s0,sp,64
   a:	84aa                	mv	s1,a0
    int first;
    close(pipec[1]);
   c:	4148                	lw	a0,4(a0)
   e:	00000097          	auipc	ra,0x0
  12:	43a080e7          	jalr	1082(ra) # 448 <close>
    if (read(pipec[0], &first, sizeof(int)) != sizeof(int))
  16:	4611                	li	a2,4
  18:	fdc40593          	addi	a1,s0,-36
  1c:	4088                	lw	a0,0(s1)
  1e:	00000097          	auipc	ra,0x0
  22:	41a080e7          	jalr	1050(ra) # 438 <read>
  26:	4791                	li	a5,4
  28:	04f51763          	bne	a0,a5,76 <filter+0x76>
    {
        exit(0); // 如果不相等，等同於已經沒有值可以繼續讀了，所以可以直接離開
    }
    else
    {
        printf("prime: %d\n", first); // 還有值可以讀，每當走到這一步都要把第一個print 出來
  2c:	fdc42583          	lw	a1,-36(s0)
  30:	00001517          	auipc	a0,0x1
  34:	91050513          	addi	a0,a0,-1776 # 940 <malloc+0xea>
  38:	00000097          	auipc	ra,0x0
  3c:	760080e7          	jalr	1888(ra) # 798 <printf>
        int rpipe[2];
        pipe(rpipe);
  40:	fd040513          	addi	a0,s0,-48
  44:	00000097          	auipc	ra,0x0
  48:	3ec080e7          	jalr	1004(ra) # 430 <pipe>
        if (fork() == 0)
  4c:	00000097          	auipc	ra,0x0
  50:	3cc080e7          	jalr	972(ra) # 418 <fork>
  54:	e515                	bnez	a0,80 <filter+0x80>
        {
            // child process
            close(pipec[0]); // 不處理舊pipeline，只處理新的pipeline (也就是rpipe)的值
  56:	4088                	lw	a0,0(s1)
  58:	00000097          	auipc	ra,0x0
  5c:	3f0080e7          	jalr	1008(ra) # 448 <close>
            filter(rpipe);
  60:	fd040513          	addi	a0,s0,-48
  64:	00000097          	auipc	ra,0x0
  68:	f9c080e7          	jalr	-100(ra) # 0 <filter>
            close(rpipe[1]);
            wait(0);
            exit(0);
        }
    }
}
  6c:	70e2                	ld	ra,56(sp)
  6e:	7442                	ld	s0,48(sp)
  70:	74a2                	ld	s1,40(sp)
  72:	6121                	addi	sp,sp,64
  74:	8082                	ret
        exit(0); // 如果不相等，等同於已經沒有值可以繼續讀了，所以可以直接離開
  76:	4501                	li	a0,0
  78:	00000097          	auipc	ra,0x0
  7c:	3a8080e7          	jalr	936(ra) # 420 <exit>
            close(rpipe[0]); // 父行程關閉rpipe的讀端
  80:	fd042503          	lw	a0,-48(s0)
  84:	00000097          	auipc	ra,0x0
  88:	3c4080e7          	jalr	964(ra) # 448 <close>
            while (read(pipec[0], &data, sizeof(int)) == sizeof(int))
  8c:	4611                	li	a2,4
  8e:	fcc40593          	addi	a1,s0,-52
  92:	4088                	lw	a0,0(s1)
  94:	00000097          	auipc	ra,0x0
  98:	3a4080e7          	jalr	932(ra) # 438 <read>
  9c:	4791                	li	a5,4
  9e:	02f51363          	bne	a0,a5,c4 <filter+0xc4>
                if (data % first != 0)
  a2:	fcc42783          	lw	a5,-52(s0)
  a6:	fdc42703          	lw	a4,-36(s0)
  aa:	02e7e7bb          	remw	a5,a5,a4
  ae:	dff9                	beqz	a5,8c <filter+0x8c>
                    write(rpipe[1], &data, sizeof(int));
  b0:	4611                	li	a2,4
  b2:	fcc40593          	addi	a1,s0,-52
  b6:	fd442503          	lw	a0,-44(s0)
  ba:	00000097          	auipc	ra,0x0
  be:	386080e7          	jalr	902(ra) # 440 <write>
  c2:	b7e9                	j	8c <filter+0x8c>
            close(pipec[0]);
  c4:	4088                	lw	a0,0(s1)
  c6:	00000097          	auipc	ra,0x0
  ca:	382080e7          	jalr	898(ra) # 448 <close>
            close(rpipe[1]);
  ce:	fd442503          	lw	a0,-44(s0)
  d2:	00000097          	auipc	ra,0x0
  d6:	376080e7          	jalr	886(ra) # 448 <close>
            wait(0);
  da:	4501                	li	a0,0
  dc:	00000097          	auipc	ra,0x0
  e0:	34c080e7          	jalr	844(ra) # 428 <wait>
            exit(0);
  e4:	4501                	li	a0,0
  e6:	00000097          	auipc	ra,0x0
  ea:	33a080e7          	jalr	826(ra) # 420 <exit>

00000000000000ee <main>:

int main(int argc, char *argv[])
{
  ee:	7179                	addi	sp,sp,-48
  f0:	f406                	sd	ra,40(sp)
  f2:	f022                	sd	s0,32(sp)
  f4:	ec26                	sd	s1,24(sp)
  f6:	1800                	addi	s0,sp,48
    int lp[2];
    pipe(lp);
  f8:	fd840513          	addi	a0,s0,-40
  fc:	00000097          	auipc	ra,0x0
 100:	334080e7          	jalr	820(ra) # 430 <pipe>
    int pid = fork();
 104:	00000097          	auipc	ra,0x0
 108:	314080e7          	jalr	788(ra) # 418 <fork>
    if (pid == -1)
 10c:	57fd                	li	a5,-1
 10e:	02f50463          	beq	a0,a5,136 <main+0x48>
    {
        printf("This is error, please check pipeline\n");
        exit(1);
    }
    else if (pid == 0)
 112:	ed1d                	bnez	a0,150 <main+0x62>
    {
        close(lp[1]);
 114:	fdc42503          	lw	a0,-36(s0)
 118:	00000097          	auipc	ra,0x0
 11c:	330080e7          	jalr	816(ra) # 448 <close>
        filter(lp);
 120:	fd840513          	addi	a0,s0,-40
 124:	00000097          	auipc	ra,0x0
 128:	edc080e7          	jalr	-292(ra) # 0 <filter>
        exit(0);
 12c:	4501                	li	a0,0
 12e:	00000097          	auipc	ra,0x0
 132:	2f2080e7          	jalr	754(ra) # 420 <exit>
        printf("This is error, please check pipeline\n");
 136:	00001517          	auipc	a0,0x1
 13a:	81a50513          	addi	a0,a0,-2022 # 950 <malloc+0xfa>
 13e:	00000097          	auipc	ra,0x0
 142:	65a080e7          	jalr	1626(ra) # 798 <printf>
        exit(1);
 146:	4505                	li	a0,1
 148:	00000097          	auipc	ra,0x0
 14c:	2d8080e7          	jalr	728(ra) # 420 <exit>
    }
    else
    {
        close(lp[0]);                 // 關閉父行程讀端
 150:	fd842503          	lw	a0,-40(s0)
 154:	00000097          	auipc	ra,0x0
 158:	2f4080e7          	jalr	756(ra) # 448 <close>
        for (int i = 2; i <= 35; ++i) // 從2開始寫入數字到管道
 15c:	4789                	li	a5,2
 15e:	fcf42a23          	sw	a5,-44(s0)
 162:	02300493          	li	s1,35
        {
            write(lp[1], &i, sizeof(int));
 166:	4611                	li	a2,4
 168:	fd440593          	addi	a1,s0,-44
 16c:	fdc42503          	lw	a0,-36(s0)
 170:	00000097          	auipc	ra,0x0
 174:	2d0080e7          	jalr	720(ra) # 440 <write>
        for (int i = 2; i <= 35; ++i) // 從2開始寫入數字到管道
 178:	fd442783          	lw	a5,-44(s0)
 17c:	2785                	addiw	a5,a5,1
 17e:	0007871b          	sext.w	a4,a5
 182:	fcf42a23          	sw	a5,-44(s0)
 186:	fee4d0e3          	bge	s1,a4,166 <main+0x78>
        }
        close(lp[1]); // 關閉父行程寫端
 18a:	fdc42503          	lw	a0,-36(s0)
 18e:	00000097          	auipc	ra,0x0
 192:	2ba080e7          	jalr	698(ra) # 448 <close>
        wait(0);
 196:	4501                	li	a0,0
 198:	00000097          	auipc	ra,0x0
 19c:	290080e7          	jalr	656(ra) # 428 <wait>
    }
    exit(0);
 1a0:	4501                	li	a0,0
 1a2:	00000097          	auipc	ra,0x0
 1a6:	27e080e7          	jalr	638(ra) # 420 <exit>

00000000000001aa <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 1aa:	1141                	addi	sp,sp,-16
 1ac:	e422                	sd	s0,8(sp)
 1ae:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1b0:	87aa                	mv	a5,a0
 1b2:	0585                	addi	a1,a1,1
 1b4:	0785                	addi	a5,a5,1
 1b6:	fff5c703          	lbu	a4,-1(a1)
 1ba:	fee78fa3          	sb	a4,-1(a5)
 1be:	fb75                	bnez	a4,1b2 <strcpy+0x8>
    ;
  return os;
}
 1c0:	6422                	ld	s0,8(sp)
 1c2:	0141                	addi	sp,sp,16
 1c4:	8082                	ret

00000000000001c6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1c6:	1141                	addi	sp,sp,-16
 1c8:	e422                	sd	s0,8(sp)
 1ca:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1cc:	00054783          	lbu	a5,0(a0)
 1d0:	cb91                	beqz	a5,1e4 <strcmp+0x1e>
 1d2:	0005c703          	lbu	a4,0(a1)
 1d6:	00f71763          	bne	a4,a5,1e4 <strcmp+0x1e>
    p++, q++;
 1da:	0505                	addi	a0,a0,1
 1dc:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1de:	00054783          	lbu	a5,0(a0)
 1e2:	fbe5                	bnez	a5,1d2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1e4:	0005c503          	lbu	a0,0(a1)
}
 1e8:	40a7853b          	subw	a0,a5,a0
 1ec:	6422                	ld	s0,8(sp)
 1ee:	0141                	addi	sp,sp,16
 1f0:	8082                	ret

00000000000001f2 <strlen>:

uint
strlen(const char *s)
{
 1f2:	1141                	addi	sp,sp,-16
 1f4:	e422                	sd	s0,8(sp)
 1f6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1f8:	00054783          	lbu	a5,0(a0)
 1fc:	cf91                	beqz	a5,218 <strlen+0x26>
 1fe:	0505                	addi	a0,a0,1
 200:	87aa                	mv	a5,a0
 202:	4685                	li	a3,1
 204:	9e89                	subw	a3,a3,a0
 206:	00f6853b          	addw	a0,a3,a5
 20a:	0785                	addi	a5,a5,1
 20c:	fff7c703          	lbu	a4,-1(a5)
 210:	fb7d                	bnez	a4,206 <strlen+0x14>
    ;
  return n;
}
 212:	6422                	ld	s0,8(sp)
 214:	0141                	addi	sp,sp,16
 216:	8082                	ret
  for(n = 0; s[n]; n++)
 218:	4501                	li	a0,0
 21a:	bfe5                	j	212 <strlen+0x20>

000000000000021c <memset>:

void*
memset(void *dst, int c, uint n)
{
 21c:	1141                	addi	sp,sp,-16
 21e:	e422                	sd	s0,8(sp)
 220:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 222:	ce09                	beqz	a2,23c <memset+0x20>
 224:	87aa                	mv	a5,a0
 226:	fff6071b          	addiw	a4,a2,-1
 22a:	1702                	slli	a4,a4,0x20
 22c:	9301                	srli	a4,a4,0x20
 22e:	0705                	addi	a4,a4,1
 230:	972a                	add	a4,a4,a0
    cdst[i] = c;
 232:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 236:	0785                	addi	a5,a5,1
 238:	fee79de3          	bne	a5,a4,232 <memset+0x16>
  }
  return dst;
}
 23c:	6422                	ld	s0,8(sp)
 23e:	0141                	addi	sp,sp,16
 240:	8082                	ret

0000000000000242 <strchr>:

char*
strchr(const char *s, char c)
{
 242:	1141                	addi	sp,sp,-16
 244:	e422                	sd	s0,8(sp)
 246:	0800                	addi	s0,sp,16
  for(; *s; s++)
 248:	00054783          	lbu	a5,0(a0)
 24c:	cb99                	beqz	a5,262 <strchr+0x20>
    if(*s == c)
 24e:	00f58763          	beq	a1,a5,25c <strchr+0x1a>
  for(; *s; s++)
 252:	0505                	addi	a0,a0,1
 254:	00054783          	lbu	a5,0(a0)
 258:	fbfd                	bnez	a5,24e <strchr+0xc>
      return (char*)s;
  return 0;
 25a:	4501                	li	a0,0
}
 25c:	6422                	ld	s0,8(sp)
 25e:	0141                	addi	sp,sp,16
 260:	8082                	ret
  return 0;
 262:	4501                	li	a0,0
 264:	bfe5                	j	25c <strchr+0x1a>

0000000000000266 <gets>:

char*
gets(char *buf, int max)
{
 266:	711d                	addi	sp,sp,-96
 268:	ec86                	sd	ra,88(sp)
 26a:	e8a2                	sd	s0,80(sp)
 26c:	e4a6                	sd	s1,72(sp)
 26e:	e0ca                	sd	s2,64(sp)
 270:	fc4e                	sd	s3,56(sp)
 272:	f852                	sd	s4,48(sp)
 274:	f456                	sd	s5,40(sp)
 276:	f05a                	sd	s6,32(sp)
 278:	ec5e                	sd	s7,24(sp)
 27a:	1080                	addi	s0,sp,96
 27c:	8baa                	mv	s7,a0
 27e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 280:	892a                	mv	s2,a0
 282:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 284:	4aa9                	li	s5,10
 286:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 288:	89a6                	mv	s3,s1
 28a:	2485                	addiw	s1,s1,1
 28c:	0344d863          	bge	s1,s4,2bc <gets+0x56>
    cc = read(0, &c, 1);
 290:	4605                	li	a2,1
 292:	faf40593          	addi	a1,s0,-81
 296:	4501                	li	a0,0
 298:	00000097          	auipc	ra,0x0
 29c:	1a0080e7          	jalr	416(ra) # 438 <read>
    if(cc < 1)
 2a0:	00a05e63          	blez	a0,2bc <gets+0x56>
    buf[i++] = c;
 2a4:	faf44783          	lbu	a5,-81(s0)
 2a8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2ac:	01578763          	beq	a5,s5,2ba <gets+0x54>
 2b0:	0905                	addi	s2,s2,1
 2b2:	fd679be3          	bne	a5,s6,288 <gets+0x22>
  for(i=0; i+1 < max; ){
 2b6:	89a6                	mv	s3,s1
 2b8:	a011                	j	2bc <gets+0x56>
 2ba:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2bc:	99de                	add	s3,s3,s7
 2be:	00098023          	sb	zero,0(s3)
  return buf;
}
 2c2:	855e                	mv	a0,s7
 2c4:	60e6                	ld	ra,88(sp)
 2c6:	6446                	ld	s0,80(sp)
 2c8:	64a6                	ld	s1,72(sp)
 2ca:	6906                	ld	s2,64(sp)
 2cc:	79e2                	ld	s3,56(sp)
 2ce:	7a42                	ld	s4,48(sp)
 2d0:	7aa2                	ld	s5,40(sp)
 2d2:	7b02                	ld	s6,32(sp)
 2d4:	6be2                	ld	s7,24(sp)
 2d6:	6125                	addi	sp,sp,96
 2d8:	8082                	ret

00000000000002da <stat>:

int
stat(const char *n, struct stat *st)
{
 2da:	1101                	addi	sp,sp,-32
 2dc:	ec06                	sd	ra,24(sp)
 2de:	e822                	sd	s0,16(sp)
 2e0:	e426                	sd	s1,8(sp)
 2e2:	e04a                	sd	s2,0(sp)
 2e4:	1000                	addi	s0,sp,32
 2e6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2e8:	4581                	li	a1,0
 2ea:	00000097          	auipc	ra,0x0
 2ee:	176080e7          	jalr	374(ra) # 460 <open>
  if(fd < 0)
 2f2:	02054563          	bltz	a0,31c <stat+0x42>
 2f6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2f8:	85ca                	mv	a1,s2
 2fa:	00000097          	auipc	ra,0x0
 2fe:	17e080e7          	jalr	382(ra) # 478 <fstat>
 302:	892a                	mv	s2,a0
  close(fd);
 304:	8526                	mv	a0,s1
 306:	00000097          	auipc	ra,0x0
 30a:	142080e7          	jalr	322(ra) # 448 <close>
  return r;
}
 30e:	854a                	mv	a0,s2
 310:	60e2                	ld	ra,24(sp)
 312:	6442                	ld	s0,16(sp)
 314:	64a2                	ld	s1,8(sp)
 316:	6902                	ld	s2,0(sp)
 318:	6105                	addi	sp,sp,32
 31a:	8082                	ret
    return -1;
 31c:	597d                	li	s2,-1
 31e:	bfc5                	j	30e <stat+0x34>

0000000000000320 <atoi>:

int
atoi(const char *s)
{
 320:	1141                	addi	sp,sp,-16
 322:	e422                	sd	s0,8(sp)
 324:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 326:	00054603          	lbu	a2,0(a0)
 32a:	fd06079b          	addiw	a5,a2,-48
 32e:	0ff7f793          	andi	a5,a5,255
 332:	4725                	li	a4,9
 334:	02f76963          	bltu	a4,a5,366 <atoi+0x46>
 338:	86aa                	mv	a3,a0
  n = 0;
 33a:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 33c:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 33e:	0685                	addi	a3,a3,1
 340:	0025179b          	slliw	a5,a0,0x2
 344:	9fa9                	addw	a5,a5,a0
 346:	0017979b          	slliw	a5,a5,0x1
 34a:	9fb1                	addw	a5,a5,a2
 34c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 350:	0006c603          	lbu	a2,0(a3)
 354:	fd06071b          	addiw	a4,a2,-48
 358:	0ff77713          	andi	a4,a4,255
 35c:	fee5f1e3          	bgeu	a1,a4,33e <atoi+0x1e>
  return n;
}
 360:	6422                	ld	s0,8(sp)
 362:	0141                	addi	sp,sp,16
 364:	8082                	ret
  n = 0;
 366:	4501                	li	a0,0
 368:	bfe5                	j	360 <atoi+0x40>

000000000000036a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 36a:	1141                	addi	sp,sp,-16
 36c:	e422                	sd	s0,8(sp)
 36e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 370:	02b57663          	bgeu	a0,a1,39c <memmove+0x32>
    while(n-- > 0)
 374:	02c05163          	blez	a2,396 <memmove+0x2c>
 378:	fff6079b          	addiw	a5,a2,-1
 37c:	1782                	slli	a5,a5,0x20
 37e:	9381                	srli	a5,a5,0x20
 380:	0785                	addi	a5,a5,1
 382:	97aa                	add	a5,a5,a0
  dst = vdst;
 384:	872a                	mv	a4,a0
      *dst++ = *src++;
 386:	0585                	addi	a1,a1,1
 388:	0705                	addi	a4,a4,1
 38a:	fff5c683          	lbu	a3,-1(a1)
 38e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 392:	fee79ae3          	bne	a5,a4,386 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 396:	6422                	ld	s0,8(sp)
 398:	0141                	addi	sp,sp,16
 39a:	8082                	ret
    dst += n;
 39c:	00c50733          	add	a4,a0,a2
    src += n;
 3a0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3a2:	fec05ae3          	blez	a2,396 <memmove+0x2c>
 3a6:	fff6079b          	addiw	a5,a2,-1
 3aa:	1782                	slli	a5,a5,0x20
 3ac:	9381                	srli	a5,a5,0x20
 3ae:	fff7c793          	not	a5,a5
 3b2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3b4:	15fd                	addi	a1,a1,-1
 3b6:	177d                	addi	a4,a4,-1
 3b8:	0005c683          	lbu	a3,0(a1)
 3bc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3c0:	fee79ae3          	bne	a5,a4,3b4 <memmove+0x4a>
 3c4:	bfc9                	j	396 <memmove+0x2c>

00000000000003c6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3c6:	1141                	addi	sp,sp,-16
 3c8:	e422                	sd	s0,8(sp)
 3ca:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3cc:	ca05                	beqz	a2,3fc <memcmp+0x36>
 3ce:	fff6069b          	addiw	a3,a2,-1
 3d2:	1682                	slli	a3,a3,0x20
 3d4:	9281                	srli	a3,a3,0x20
 3d6:	0685                	addi	a3,a3,1
 3d8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3da:	00054783          	lbu	a5,0(a0)
 3de:	0005c703          	lbu	a4,0(a1)
 3e2:	00e79863          	bne	a5,a4,3f2 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3e6:	0505                	addi	a0,a0,1
    p2++;
 3e8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3ea:	fed518e3          	bne	a0,a3,3da <memcmp+0x14>
  }
  return 0;
 3ee:	4501                	li	a0,0
 3f0:	a019                	j	3f6 <memcmp+0x30>
      return *p1 - *p2;
 3f2:	40e7853b          	subw	a0,a5,a4
}
 3f6:	6422                	ld	s0,8(sp)
 3f8:	0141                	addi	sp,sp,16
 3fa:	8082                	ret
  return 0;
 3fc:	4501                	li	a0,0
 3fe:	bfe5                	j	3f6 <memcmp+0x30>

0000000000000400 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 400:	1141                	addi	sp,sp,-16
 402:	e406                	sd	ra,8(sp)
 404:	e022                	sd	s0,0(sp)
 406:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 408:	00000097          	auipc	ra,0x0
 40c:	f62080e7          	jalr	-158(ra) # 36a <memmove>
}
 410:	60a2                	ld	ra,8(sp)
 412:	6402                	ld	s0,0(sp)
 414:	0141                	addi	sp,sp,16
 416:	8082                	ret

0000000000000418 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 418:	4885                	li	a7,1
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <exit>:
.global exit
exit:
 li a7, SYS_exit
 420:	4889                	li	a7,2
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <wait>:
.global wait
wait:
 li a7, SYS_wait
 428:	488d                	li	a7,3
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 430:	4891                	li	a7,4
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <read>:
.global read
read:
 li a7, SYS_read
 438:	4895                	li	a7,5
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <write>:
.global write
write:
 li a7, SYS_write
 440:	48c1                	li	a7,16
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <close>:
.global close
close:
 li a7, SYS_close
 448:	48d5                	li	a7,21
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <kill>:
.global kill
kill:
 li a7, SYS_kill
 450:	4899                	li	a7,6
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <exec>:
.global exec
exec:
 li a7, SYS_exec
 458:	489d                	li	a7,7
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <open>:
.global open
open:
 li a7, SYS_open
 460:	48bd                	li	a7,15
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 468:	48c5                	li	a7,17
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 470:	48c9                	li	a7,18
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 478:	48a1                	li	a7,8
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <link>:
.global link
link:
 li a7, SYS_link
 480:	48cd                	li	a7,19
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 488:	48d1                	li	a7,20
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 490:	48a5                	li	a7,9
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <dup>:
.global dup
dup:
 li a7, SYS_dup
 498:	48a9                	li	a7,10
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4a0:	48ad                	li	a7,11
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4a8:	48b1                	li	a7,12
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4b0:	48b5                	li	a7,13
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4b8:	48b9                	li	a7,14
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4c0:	1101                	addi	sp,sp,-32
 4c2:	ec06                	sd	ra,24(sp)
 4c4:	e822                	sd	s0,16(sp)
 4c6:	1000                	addi	s0,sp,32
 4c8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4cc:	4605                	li	a2,1
 4ce:	fef40593          	addi	a1,s0,-17
 4d2:	00000097          	auipc	ra,0x0
 4d6:	f6e080e7          	jalr	-146(ra) # 440 <write>
}
 4da:	60e2                	ld	ra,24(sp)
 4dc:	6442                	ld	s0,16(sp)
 4de:	6105                	addi	sp,sp,32
 4e0:	8082                	ret

00000000000004e2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4e2:	7139                	addi	sp,sp,-64
 4e4:	fc06                	sd	ra,56(sp)
 4e6:	f822                	sd	s0,48(sp)
 4e8:	f426                	sd	s1,40(sp)
 4ea:	f04a                	sd	s2,32(sp)
 4ec:	ec4e                	sd	s3,24(sp)
 4ee:	0080                	addi	s0,sp,64
 4f0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4f2:	c299                	beqz	a3,4f8 <printint+0x16>
 4f4:	0805c863          	bltz	a1,584 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4f8:	2581                	sext.w	a1,a1
  neg = 0;
 4fa:	4881                	li	a7,0
 4fc:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 500:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 502:	2601                	sext.w	a2,a2
 504:	00000517          	auipc	a0,0x0
 508:	47c50513          	addi	a0,a0,1148 # 980 <digits>
 50c:	883a                	mv	a6,a4
 50e:	2705                	addiw	a4,a4,1
 510:	02c5f7bb          	remuw	a5,a1,a2
 514:	1782                	slli	a5,a5,0x20
 516:	9381                	srli	a5,a5,0x20
 518:	97aa                	add	a5,a5,a0
 51a:	0007c783          	lbu	a5,0(a5)
 51e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 522:	0005879b          	sext.w	a5,a1
 526:	02c5d5bb          	divuw	a1,a1,a2
 52a:	0685                	addi	a3,a3,1
 52c:	fec7f0e3          	bgeu	a5,a2,50c <printint+0x2a>
  if(neg)
 530:	00088b63          	beqz	a7,546 <printint+0x64>
    buf[i++] = '-';
 534:	fd040793          	addi	a5,s0,-48
 538:	973e                	add	a4,a4,a5
 53a:	02d00793          	li	a5,45
 53e:	fef70823          	sb	a5,-16(a4)
 542:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 546:	02e05863          	blez	a4,576 <printint+0x94>
 54a:	fc040793          	addi	a5,s0,-64
 54e:	00e78933          	add	s2,a5,a4
 552:	fff78993          	addi	s3,a5,-1
 556:	99ba                	add	s3,s3,a4
 558:	377d                	addiw	a4,a4,-1
 55a:	1702                	slli	a4,a4,0x20
 55c:	9301                	srli	a4,a4,0x20
 55e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 562:	fff94583          	lbu	a1,-1(s2)
 566:	8526                	mv	a0,s1
 568:	00000097          	auipc	ra,0x0
 56c:	f58080e7          	jalr	-168(ra) # 4c0 <putc>
  while(--i >= 0)
 570:	197d                	addi	s2,s2,-1
 572:	ff3918e3          	bne	s2,s3,562 <printint+0x80>
}
 576:	70e2                	ld	ra,56(sp)
 578:	7442                	ld	s0,48(sp)
 57a:	74a2                	ld	s1,40(sp)
 57c:	7902                	ld	s2,32(sp)
 57e:	69e2                	ld	s3,24(sp)
 580:	6121                	addi	sp,sp,64
 582:	8082                	ret
    x = -xx;
 584:	40b005bb          	negw	a1,a1
    neg = 1;
 588:	4885                	li	a7,1
    x = -xx;
 58a:	bf8d                	j	4fc <printint+0x1a>

000000000000058c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 58c:	7119                	addi	sp,sp,-128
 58e:	fc86                	sd	ra,120(sp)
 590:	f8a2                	sd	s0,112(sp)
 592:	f4a6                	sd	s1,104(sp)
 594:	f0ca                	sd	s2,96(sp)
 596:	ecce                	sd	s3,88(sp)
 598:	e8d2                	sd	s4,80(sp)
 59a:	e4d6                	sd	s5,72(sp)
 59c:	e0da                	sd	s6,64(sp)
 59e:	fc5e                	sd	s7,56(sp)
 5a0:	f862                	sd	s8,48(sp)
 5a2:	f466                	sd	s9,40(sp)
 5a4:	f06a                	sd	s10,32(sp)
 5a6:	ec6e                	sd	s11,24(sp)
 5a8:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5aa:	0005c903          	lbu	s2,0(a1)
 5ae:	18090f63          	beqz	s2,74c <vprintf+0x1c0>
 5b2:	8aaa                	mv	s5,a0
 5b4:	8b32                	mv	s6,a2
 5b6:	00158493          	addi	s1,a1,1
  state = 0;
 5ba:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5bc:	02500a13          	li	s4,37
      if(c == 'd'){
 5c0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 5c4:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 5c8:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 5cc:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5d0:	00000b97          	auipc	s7,0x0
 5d4:	3b0b8b93          	addi	s7,s7,944 # 980 <digits>
 5d8:	a839                	j	5f6 <vprintf+0x6a>
        putc(fd, c);
 5da:	85ca                	mv	a1,s2
 5dc:	8556                	mv	a0,s5
 5de:	00000097          	auipc	ra,0x0
 5e2:	ee2080e7          	jalr	-286(ra) # 4c0 <putc>
 5e6:	a019                	j	5ec <vprintf+0x60>
    } else if(state == '%'){
 5e8:	01498f63          	beq	s3,s4,606 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 5ec:	0485                	addi	s1,s1,1
 5ee:	fff4c903          	lbu	s2,-1(s1)
 5f2:	14090d63          	beqz	s2,74c <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 5f6:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5fa:	fe0997e3          	bnez	s3,5e8 <vprintf+0x5c>
      if(c == '%'){
 5fe:	fd479ee3          	bne	a5,s4,5da <vprintf+0x4e>
        state = '%';
 602:	89be                	mv	s3,a5
 604:	b7e5                	j	5ec <vprintf+0x60>
      if(c == 'd'){
 606:	05878063          	beq	a5,s8,646 <vprintf+0xba>
      } else if(c == 'l') {
 60a:	05978c63          	beq	a5,s9,662 <vprintf+0xd6>
      } else if(c == 'x') {
 60e:	07a78863          	beq	a5,s10,67e <vprintf+0xf2>
      } else if(c == 'p') {
 612:	09b78463          	beq	a5,s11,69a <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 616:	07300713          	li	a4,115
 61a:	0ce78663          	beq	a5,a4,6e6 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 61e:	06300713          	li	a4,99
 622:	0ee78e63          	beq	a5,a4,71e <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 626:	11478863          	beq	a5,s4,736 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 62a:	85d2                	mv	a1,s4
 62c:	8556                	mv	a0,s5
 62e:	00000097          	auipc	ra,0x0
 632:	e92080e7          	jalr	-366(ra) # 4c0 <putc>
        putc(fd, c);
 636:	85ca                	mv	a1,s2
 638:	8556                	mv	a0,s5
 63a:	00000097          	auipc	ra,0x0
 63e:	e86080e7          	jalr	-378(ra) # 4c0 <putc>
      }
      state = 0;
 642:	4981                	li	s3,0
 644:	b765                	j	5ec <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 646:	008b0913          	addi	s2,s6,8
 64a:	4685                	li	a3,1
 64c:	4629                	li	a2,10
 64e:	000b2583          	lw	a1,0(s6)
 652:	8556                	mv	a0,s5
 654:	00000097          	auipc	ra,0x0
 658:	e8e080e7          	jalr	-370(ra) # 4e2 <printint>
 65c:	8b4a                	mv	s6,s2
      state = 0;
 65e:	4981                	li	s3,0
 660:	b771                	j	5ec <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 662:	008b0913          	addi	s2,s6,8
 666:	4681                	li	a3,0
 668:	4629                	li	a2,10
 66a:	000b2583          	lw	a1,0(s6)
 66e:	8556                	mv	a0,s5
 670:	00000097          	auipc	ra,0x0
 674:	e72080e7          	jalr	-398(ra) # 4e2 <printint>
 678:	8b4a                	mv	s6,s2
      state = 0;
 67a:	4981                	li	s3,0
 67c:	bf85                	j	5ec <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 67e:	008b0913          	addi	s2,s6,8
 682:	4681                	li	a3,0
 684:	4641                	li	a2,16
 686:	000b2583          	lw	a1,0(s6)
 68a:	8556                	mv	a0,s5
 68c:	00000097          	auipc	ra,0x0
 690:	e56080e7          	jalr	-426(ra) # 4e2 <printint>
 694:	8b4a                	mv	s6,s2
      state = 0;
 696:	4981                	li	s3,0
 698:	bf91                	j	5ec <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 69a:	008b0793          	addi	a5,s6,8
 69e:	f8f43423          	sd	a5,-120(s0)
 6a2:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6a6:	03000593          	li	a1,48
 6aa:	8556                	mv	a0,s5
 6ac:	00000097          	auipc	ra,0x0
 6b0:	e14080e7          	jalr	-492(ra) # 4c0 <putc>
  putc(fd, 'x');
 6b4:	85ea                	mv	a1,s10
 6b6:	8556                	mv	a0,s5
 6b8:	00000097          	auipc	ra,0x0
 6bc:	e08080e7          	jalr	-504(ra) # 4c0 <putc>
 6c0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6c2:	03c9d793          	srli	a5,s3,0x3c
 6c6:	97de                	add	a5,a5,s7
 6c8:	0007c583          	lbu	a1,0(a5)
 6cc:	8556                	mv	a0,s5
 6ce:	00000097          	auipc	ra,0x0
 6d2:	df2080e7          	jalr	-526(ra) # 4c0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6d6:	0992                	slli	s3,s3,0x4
 6d8:	397d                	addiw	s2,s2,-1
 6da:	fe0914e3          	bnez	s2,6c2 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 6de:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 6e2:	4981                	li	s3,0
 6e4:	b721                	j	5ec <vprintf+0x60>
        s = va_arg(ap, char*);
 6e6:	008b0993          	addi	s3,s6,8
 6ea:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 6ee:	02090163          	beqz	s2,710 <vprintf+0x184>
        while(*s != 0){
 6f2:	00094583          	lbu	a1,0(s2)
 6f6:	c9a1                	beqz	a1,746 <vprintf+0x1ba>
          putc(fd, *s);
 6f8:	8556                	mv	a0,s5
 6fa:	00000097          	auipc	ra,0x0
 6fe:	dc6080e7          	jalr	-570(ra) # 4c0 <putc>
          s++;
 702:	0905                	addi	s2,s2,1
        while(*s != 0){
 704:	00094583          	lbu	a1,0(s2)
 708:	f9e5                	bnez	a1,6f8 <vprintf+0x16c>
        s = va_arg(ap, char*);
 70a:	8b4e                	mv	s6,s3
      state = 0;
 70c:	4981                	li	s3,0
 70e:	bdf9                	j	5ec <vprintf+0x60>
          s = "(null)";
 710:	00000917          	auipc	s2,0x0
 714:	26890913          	addi	s2,s2,616 # 978 <malloc+0x122>
        while(*s != 0){
 718:	02800593          	li	a1,40
 71c:	bff1                	j	6f8 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 71e:	008b0913          	addi	s2,s6,8
 722:	000b4583          	lbu	a1,0(s6)
 726:	8556                	mv	a0,s5
 728:	00000097          	auipc	ra,0x0
 72c:	d98080e7          	jalr	-616(ra) # 4c0 <putc>
 730:	8b4a                	mv	s6,s2
      state = 0;
 732:	4981                	li	s3,0
 734:	bd65                	j	5ec <vprintf+0x60>
        putc(fd, c);
 736:	85d2                	mv	a1,s4
 738:	8556                	mv	a0,s5
 73a:	00000097          	auipc	ra,0x0
 73e:	d86080e7          	jalr	-634(ra) # 4c0 <putc>
      state = 0;
 742:	4981                	li	s3,0
 744:	b565                	j	5ec <vprintf+0x60>
        s = va_arg(ap, char*);
 746:	8b4e                	mv	s6,s3
      state = 0;
 748:	4981                	li	s3,0
 74a:	b54d                	j	5ec <vprintf+0x60>
    }
  }
}
 74c:	70e6                	ld	ra,120(sp)
 74e:	7446                	ld	s0,112(sp)
 750:	74a6                	ld	s1,104(sp)
 752:	7906                	ld	s2,96(sp)
 754:	69e6                	ld	s3,88(sp)
 756:	6a46                	ld	s4,80(sp)
 758:	6aa6                	ld	s5,72(sp)
 75a:	6b06                	ld	s6,64(sp)
 75c:	7be2                	ld	s7,56(sp)
 75e:	7c42                	ld	s8,48(sp)
 760:	7ca2                	ld	s9,40(sp)
 762:	7d02                	ld	s10,32(sp)
 764:	6de2                	ld	s11,24(sp)
 766:	6109                	addi	sp,sp,128
 768:	8082                	ret

000000000000076a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 76a:	715d                	addi	sp,sp,-80
 76c:	ec06                	sd	ra,24(sp)
 76e:	e822                	sd	s0,16(sp)
 770:	1000                	addi	s0,sp,32
 772:	e010                	sd	a2,0(s0)
 774:	e414                	sd	a3,8(s0)
 776:	e818                	sd	a4,16(s0)
 778:	ec1c                	sd	a5,24(s0)
 77a:	03043023          	sd	a6,32(s0)
 77e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 782:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 786:	8622                	mv	a2,s0
 788:	00000097          	auipc	ra,0x0
 78c:	e04080e7          	jalr	-508(ra) # 58c <vprintf>
}
 790:	60e2                	ld	ra,24(sp)
 792:	6442                	ld	s0,16(sp)
 794:	6161                	addi	sp,sp,80
 796:	8082                	ret

0000000000000798 <printf>:

void
printf(const char *fmt, ...)
{
 798:	711d                	addi	sp,sp,-96
 79a:	ec06                	sd	ra,24(sp)
 79c:	e822                	sd	s0,16(sp)
 79e:	1000                	addi	s0,sp,32
 7a0:	e40c                	sd	a1,8(s0)
 7a2:	e810                	sd	a2,16(s0)
 7a4:	ec14                	sd	a3,24(s0)
 7a6:	f018                	sd	a4,32(s0)
 7a8:	f41c                	sd	a5,40(s0)
 7aa:	03043823          	sd	a6,48(s0)
 7ae:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7b2:	00840613          	addi	a2,s0,8
 7b6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7ba:	85aa                	mv	a1,a0
 7bc:	4505                	li	a0,1
 7be:	00000097          	auipc	ra,0x0
 7c2:	dce080e7          	jalr	-562(ra) # 58c <vprintf>
}
 7c6:	60e2                	ld	ra,24(sp)
 7c8:	6442                	ld	s0,16(sp)
 7ca:	6125                	addi	sp,sp,96
 7cc:	8082                	ret

00000000000007ce <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7ce:	1141                	addi	sp,sp,-16
 7d0:	e422                	sd	s0,8(sp)
 7d2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7d4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d8:	00000797          	auipc	a5,0x0
 7dc:	1c07b783          	ld	a5,448(a5) # 998 <freep>
 7e0:	a805                	j	810 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7e2:	4618                	lw	a4,8(a2)
 7e4:	9db9                	addw	a1,a1,a4
 7e6:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7ea:	6398                	ld	a4,0(a5)
 7ec:	6318                	ld	a4,0(a4)
 7ee:	fee53823          	sd	a4,-16(a0)
 7f2:	a091                	j	836 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7f4:	ff852703          	lw	a4,-8(a0)
 7f8:	9e39                	addw	a2,a2,a4
 7fa:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 7fc:	ff053703          	ld	a4,-16(a0)
 800:	e398                	sd	a4,0(a5)
 802:	a099                	j	848 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 804:	6398                	ld	a4,0(a5)
 806:	00e7e463          	bltu	a5,a4,80e <free+0x40>
 80a:	00e6ea63          	bltu	a3,a4,81e <free+0x50>
{
 80e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 810:	fed7fae3          	bgeu	a5,a3,804 <free+0x36>
 814:	6398                	ld	a4,0(a5)
 816:	00e6e463          	bltu	a3,a4,81e <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 81a:	fee7eae3          	bltu	a5,a4,80e <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 81e:	ff852583          	lw	a1,-8(a0)
 822:	6390                	ld	a2,0(a5)
 824:	02059713          	slli	a4,a1,0x20
 828:	9301                	srli	a4,a4,0x20
 82a:	0712                	slli	a4,a4,0x4
 82c:	9736                	add	a4,a4,a3
 82e:	fae60ae3          	beq	a2,a4,7e2 <free+0x14>
    bp->s.ptr = p->s.ptr;
 832:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 836:	4790                	lw	a2,8(a5)
 838:	02061713          	slli	a4,a2,0x20
 83c:	9301                	srli	a4,a4,0x20
 83e:	0712                	slli	a4,a4,0x4
 840:	973e                	add	a4,a4,a5
 842:	fae689e3          	beq	a3,a4,7f4 <free+0x26>
  } else
    p->s.ptr = bp;
 846:	e394                	sd	a3,0(a5)
  freep = p;
 848:	00000717          	auipc	a4,0x0
 84c:	14f73823          	sd	a5,336(a4) # 998 <freep>
}
 850:	6422                	ld	s0,8(sp)
 852:	0141                	addi	sp,sp,16
 854:	8082                	ret

0000000000000856 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 856:	7139                	addi	sp,sp,-64
 858:	fc06                	sd	ra,56(sp)
 85a:	f822                	sd	s0,48(sp)
 85c:	f426                	sd	s1,40(sp)
 85e:	f04a                	sd	s2,32(sp)
 860:	ec4e                	sd	s3,24(sp)
 862:	e852                	sd	s4,16(sp)
 864:	e456                	sd	s5,8(sp)
 866:	e05a                	sd	s6,0(sp)
 868:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 86a:	02051493          	slli	s1,a0,0x20
 86e:	9081                	srli	s1,s1,0x20
 870:	04bd                	addi	s1,s1,15
 872:	8091                	srli	s1,s1,0x4
 874:	0014899b          	addiw	s3,s1,1
 878:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 87a:	00000517          	auipc	a0,0x0
 87e:	11e53503          	ld	a0,286(a0) # 998 <freep>
 882:	c515                	beqz	a0,8ae <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 884:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 886:	4798                	lw	a4,8(a5)
 888:	02977f63          	bgeu	a4,s1,8c6 <malloc+0x70>
 88c:	8a4e                	mv	s4,s3
 88e:	0009871b          	sext.w	a4,s3
 892:	6685                	lui	a3,0x1
 894:	00d77363          	bgeu	a4,a3,89a <malloc+0x44>
 898:	6a05                	lui	s4,0x1
 89a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 89e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8a2:	00000917          	auipc	s2,0x0
 8a6:	0f690913          	addi	s2,s2,246 # 998 <freep>
  if(p == (char*)-1)
 8aa:	5afd                	li	s5,-1
 8ac:	a88d                	j	91e <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 8ae:	00000797          	auipc	a5,0x0
 8b2:	0f278793          	addi	a5,a5,242 # 9a0 <base>
 8b6:	00000717          	auipc	a4,0x0
 8ba:	0ef73123          	sd	a5,226(a4) # 998 <freep>
 8be:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8c0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8c4:	b7e1                	j	88c <malloc+0x36>
      if(p->s.size == nunits)
 8c6:	02e48b63          	beq	s1,a4,8fc <malloc+0xa6>
        p->s.size -= nunits;
 8ca:	4137073b          	subw	a4,a4,s3
 8ce:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8d0:	1702                	slli	a4,a4,0x20
 8d2:	9301                	srli	a4,a4,0x20
 8d4:	0712                	slli	a4,a4,0x4
 8d6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8d8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8dc:	00000717          	auipc	a4,0x0
 8e0:	0aa73e23          	sd	a0,188(a4) # 998 <freep>
      return (void*)(p + 1);
 8e4:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8e8:	70e2                	ld	ra,56(sp)
 8ea:	7442                	ld	s0,48(sp)
 8ec:	74a2                	ld	s1,40(sp)
 8ee:	7902                	ld	s2,32(sp)
 8f0:	69e2                	ld	s3,24(sp)
 8f2:	6a42                	ld	s4,16(sp)
 8f4:	6aa2                	ld	s5,8(sp)
 8f6:	6b02                	ld	s6,0(sp)
 8f8:	6121                	addi	sp,sp,64
 8fa:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8fc:	6398                	ld	a4,0(a5)
 8fe:	e118                	sd	a4,0(a0)
 900:	bff1                	j	8dc <malloc+0x86>
  hp->s.size = nu;
 902:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 906:	0541                	addi	a0,a0,16
 908:	00000097          	auipc	ra,0x0
 90c:	ec6080e7          	jalr	-314(ra) # 7ce <free>
  return freep;
 910:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 914:	d971                	beqz	a0,8e8 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 916:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 918:	4798                	lw	a4,8(a5)
 91a:	fa9776e3          	bgeu	a4,s1,8c6 <malloc+0x70>
    if(p == freep)
 91e:	00093703          	ld	a4,0(s2)
 922:	853e                	mv	a0,a5
 924:	fef719e3          	bne	a4,a5,916 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 928:	8552                	mv	a0,s4
 92a:	00000097          	auipc	ra,0x0
 92e:	b7e080e7          	jalr	-1154(ra) # 4a8 <sbrk>
  if(p == (char*)-1)
 932:	fd5518e3          	bne	a0,s5,902 <malloc+0xac>
        return 0;
 936:	4501                	li	a0,0
 938:	bf45                	j	8e8 <malloc+0x92>
