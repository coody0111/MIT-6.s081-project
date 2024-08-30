
user/_pingpong:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#define Size 16
int main(int argc, char *argv[])
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	0080                	addi	s0,sp,64
   c:	84aa                	mv	s1,a0
    int p1[2], p2[2];
    pipe(p1); // 父 -> 子
   e:	fd840513          	addi	a0,s0,-40
  12:	00000097          	auipc	ra,0x0
  16:	3d0080e7          	jalr	976(ra) # 3e2 <pipe>
    pipe(p2); // 子 -> 父
  1a:	fd040513          	addi	a0,s0,-48
  1e:	00000097          	auipc	ra,0x0
  22:	3c4080e7          	jalr	964(ra) # 3e2 <pipe>
    char buf[Size] = {'0'};
  26:	03000793          	li	a5,48
  2a:	fcf43023          	sd	a5,-64(s0)
  2e:	fc043423          	sd	zero,-56(s0)
    int getpd = getpid(); // 用於print時的pidnumber
  32:	00000097          	auipc	ra,0x0
  36:	420080e7          	jalr	1056(ra) # 452 <getpid>
    if (argc != 1)
  3a:	4785                	li	a5,1
  3c:	00f48f63          	beq	s1,a5,5a <main+0x5a>
    {
        printf("error");
  40:	00001517          	auipc	a0,0x1
  44:	8b050513          	addi	a0,a0,-1872 # 8f0 <malloc+0xe8>
  48:	00000097          	auipc	ra,0x0
  4c:	702080e7          	jalr	1794(ra) # 74a <printf>
        exit(1);
  50:	4505                	li	a0,1
  52:	00000097          	auipc	ra,0x0
  56:	380080e7          	jalr	896(ra) # 3d2 <exit>
  5a:	892a                	mv	s2,a0
    // remind: p1 : parent -> child
    // remind: p2 : child -> parent
    // 1 write
    // 0 read

    if (fork() == 0) // 子行程
  5c:	00000097          	auipc	ra,0x0
  60:	36e080e7          	jalr	878(ra) # 3ca <fork>
  64:	e92d                	bnez	a0,d6 <main+0xd6>
    {

        close(p1[1]);        // 關閉p1的寫端，接受p1由父行程寫入
  66:	fdc42503          	lw	a0,-36(s0)
  6a:	00000097          	auipc	ra,0x0
  6e:	390080e7          	jalr	912(ra) # 3fa <close>
        close(p2[0]);        // 在p2當中，子行程會直接寫入給父行程
  72:	fd042503          	lw	a0,-48(s0)
  76:	00000097          	auipc	ra,0x0
  7a:	384080e7          	jalr	900(ra) # 3fa <close>
        read(p1[0], buf, 1); // 讀取父行程寫入的data
  7e:	4605                	li	a2,1
  80:	fc040593          	addi	a1,s0,-64
  84:	fd842503          	lw	a0,-40(s0)
  88:	00000097          	auipc	ra,0x0
  8c:	362080e7          	jalr	866(ra) # 3ea <read>
        printf("%d: received ping\n", getpd);
  90:	85ca                	mv	a1,s2
  92:	00001517          	auipc	a0,0x1
  96:	86650513          	addi	a0,a0,-1946 # 8f8 <malloc+0xf0>
  9a:	00000097          	auipc	ra,0x0
  9e:	6b0080e7          	jalr	1712(ra) # 74a <printf>
        write(p2[1], buf, 1);
  a2:	4605                	li	a2,1
  a4:	fc040593          	addi	a1,s0,-64
  a8:	fd442503          	lw	a0,-44(s0)
  ac:	00000097          	auipc	ra,0x0
  b0:	346080e7          	jalr	838(ra) # 3f2 <write>

        close(p1[0]);
  b4:	fd842503          	lw	a0,-40(s0)
  b8:	00000097          	auipc	ra,0x0
  bc:	342080e7          	jalr	834(ra) # 3fa <close>
        close(p2[1]);
  c0:	fd442503          	lw	a0,-44(s0)
  c4:	00000097          	auipc	ra,0x0
  c8:	336080e7          	jalr	822(ra) # 3fa <close>
        exit(0);
  cc:	4501                	li	a0,0
  ce:	00000097          	auipc	ra,0x0
  d2:	304080e7          	jalr	772(ra) # 3d2 <exit>
    }
    else // 父行程
    {

        close(p1[0]);
  d6:	fd842503          	lw	a0,-40(s0)
  da:	00000097          	auipc	ra,0x0
  de:	320080e7          	jalr	800(ra) # 3fa <close>
        close(p2[1]);
  e2:	fd442503          	lw	a0,-44(s0)
  e6:	00000097          	auipc	ra,0x0
  ea:	314080e7          	jalr	788(ra) # 3fa <close>
        write(p1[1], buf, 1);
  ee:	4605                	li	a2,1
  f0:	fc040593          	addi	a1,s0,-64
  f4:	fdc42503          	lw	a0,-36(s0)
  f8:	00000097          	auipc	ra,0x0
  fc:	2fa080e7          	jalr	762(ra) # 3f2 <write>
        close(p1[1]);
 100:	fdc42503          	lw	a0,-36(s0)
 104:	00000097          	auipc	ra,0x0
 108:	2f6080e7          	jalr	758(ra) # 3fa <close>
        wait(0);
 10c:	4501                	li	a0,0
 10e:	00000097          	auipc	ra,0x0
 112:	2cc080e7          	jalr	716(ra) # 3da <wait>
        printf("%d: received pong\n", getpd);
 116:	85ca                	mv	a1,s2
 118:	00000517          	auipc	a0,0x0
 11c:	7f850513          	addi	a0,a0,2040 # 910 <malloc+0x108>
 120:	00000097          	auipc	ra,0x0
 124:	62a080e7          	jalr	1578(ra) # 74a <printf>
        read(p2[0], buf, 1); // 讀子行程在p2寫給父的data
 128:	4605                	li	a2,1
 12a:	fc040593          	addi	a1,s0,-64
 12e:	fd042503          	lw	a0,-48(s0)
 132:	00000097          	auipc	ra,0x0
 136:	2b8080e7          	jalr	696(ra) # 3ea <read>
        close(p1[1]);
 13a:	fdc42503          	lw	a0,-36(s0)
 13e:	00000097          	auipc	ra,0x0
 142:	2bc080e7          	jalr	700(ra) # 3fa <close>
        close(p2[0]);
 146:	fd042503          	lw	a0,-48(s0)
 14a:	00000097          	auipc	ra,0x0
 14e:	2b0080e7          	jalr	688(ra) # 3fa <close>
        exit(0);
 152:	4501                	li	a0,0
 154:	00000097          	auipc	ra,0x0
 158:	27e080e7          	jalr	638(ra) # 3d2 <exit>

000000000000015c <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 15c:	1141                	addi	sp,sp,-16
 15e:	e422                	sd	s0,8(sp)
 160:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 162:	87aa                	mv	a5,a0
 164:	0585                	addi	a1,a1,1
 166:	0785                	addi	a5,a5,1
 168:	fff5c703          	lbu	a4,-1(a1)
 16c:	fee78fa3          	sb	a4,-1(a5)
 170:	fb75                	bnez	a4,164 <strcpy+0x8>
    ;
  return os;
}
 172:	6422                	ld	s0,8(sp)
 174:	0141                	addi	sp,sp,16
 176:	8082                	ret

0000000000000178 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 178:	1141                	addi	sp,sp,-16
 17a:	e422                	sd	s0,8(sp)
 17c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 17e:	00054783          	lbu	a5,0(a0)
 182:	cb91                	beqz	a5,196 <strcmp+0x1e>
 184:	0005c703          	lbu	a4,0(a1)
 188:	00f71763          	bne	a4,a5,196 <strcmp+0x1e>
    p++, q++;
 18c:	0505                	addi	a0,a0,1
 18e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 190:	00054783          	lbu	a5,0(a0)
 194:	fbe5                	bnez	a5,184 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 196:	0005c503          	lbu	a0,0(a1)
}
 19a:	40a7853b          	subw	a0,a5,a0
 19e:	6422                	ld	s0,8(sp)
 1a0:	0141                	addi	sp,sp,16
 1a2:	8082                	ret

00000000000001a4 <strlen>:

uint
strlen(const char *s)
{
 1a4:	1141                	addi	sp,sp,-16
 1a6:	e422                	sd	s0,8(sp)
 1a8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1aa:	00054783          	lbu	a5,0(a0)
 1ae:	cf91                	beqz	a5,1ca <strlen+0x26>
 1b0:	0505                	addi	a0,a0,1
 1b2:	87aa                	mv	a5,a0
 1b4:	4685                	li	a3,1
 1b6:	9e89                	subw	a3,a3,a0
 1b8:	00f6853b          	addw	a0,a3,a5
 1bc:	0785                	addi	a5,a5,1
 1be:	fff7c703          	lbu	a4,-1(a5)
 1c2:	fb7d                	bnez	a4,1b8 <strlen+0x14>
    ;
  return n;
}
 1c4:	6422                	ld	s0,8(sp)
 1c6:	0141                	addi	sp,sp,16
 1c8:	8082                	ret
  for(n = 0; s[n]; n++)
 1ca:	4501                	li	a0,0
 1cc:	bfe5                	j	1c4 <strlen+0x20>

00000000000001ce <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ce:	1141                	addi	sp,sp,-16
 1d0:	e422                	sd	s0,8(sp)
 1d2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1d4:	ce09                	beqz	a2,1ee <memset+0x20>
 1d6:	87aa                	mv	a5,a0
 1d8:	fff6071b          	addiw	a4,a2,-1
 1dc:	1702                	slli	a4,a4,0x20
 1de:	9301                	srli	a4,a4,0x20
 1e0:	0705                	addi	a4,a4,1
 1e2:	972a                	add	a4,a4,a0
    cdst[i] = c;
 1e4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1e8:	0785                	addi	a5,a5,1
 1ea:	fee79de3          	bne	a5,a4,1e4 <memset+0x16>
  }
  return dst;
}
 1ee:	6422                	ld	s0,8(sp)
 1f0:	0141                	addi	sp,sp,16
 1f2:	8082                	ret

00000000000001f4 <strchr>:

char*
strchr(const char *s, char c)
{
 1f4:	1141                	addi	sp,sp,-16
 1f6:	e422                	sd	s0,8(sp)
 1f8:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1fa:	00054783          	lbu	a5,0(a0)
 1fe:	cb99                	beqz	a5,214 <strchr+0x20>
    if(*s == c)
 200:	00f58763          	beq	a1,a5,20e <strchr+0x1a>
  for(; *s; s++)
 204:	0505                	addi	a0,a0,1
 206:	00054783          	lbu	a5,0(a0)
 20a:	fbfd                	bnez	a5,200 <strchr+0xc>
      return (char*)s;
  return 0;
 20c:	4501                	li	a0,0
}
 20e:	6422                	ld	s0,8(sp)
 210:	0141                	addi	sp,sp,16
 212:	8082                	ret
  return 0;
 214:	4501                	li	a0,0
 216:	bfe5                	j	20e <strchr+0x1a>

0000000000000218 <gets>:

char*
gets(char *buf, int max)
{
 218:	711d                	addi	sp,sp,-96
 21a:	ec86                	sd	ra,88(sp)
 21c:	e8a2                	sd	s0,80(sp)
 21e:	e4a6                	sd	s1,72(sp)
 220:	e0ca                	sd	s2,64(sp)
 222:	fc4e                	sd	s3,56(sp)
 224:	f852                	sd	s4,48(sp)
 226:	f456                	sd	s5,40(sp)
 228:	f05a                	sd	s6,32(sp)
 22a:	ec5e                	sd	s7,24(sp)
 22c:	1080                	addi	s0,sp,96
 22e:	8baa                	mv	s7,a0
 230:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 232:	892a                	mv	s2,a0
 234:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 236:	4aa9                	li	s5,10
 238:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 23a:	89a6                	mv	s3,s1
 23c:	2485                	addiw	s1,s1,1
 23e:	0344d863          	bge	s1,s4,26e <gets+0x56>
    cc = read(0, &c, 1);
 242:	4605                	li	a2,1
 244:	faf40593          	addi	a1,s0,-81
 248:	4501                	li	a0,0
 24a:	00000097          	auipc	ra,0x0
 24e:	1a0080e7          	jalr	416(ra) # 3ea <read>
    if(cc < 1)
 252:	00a05e63          	blez	a0,26e <gets+0x56>
    buf[i++] = c;
 256:	faf44783          	lbu	a5,-81(s0)
 25a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 25e:	01578763          	beq	a5,s5,26c <gets+0x54>
 262:	0905                	addi	s2,s2,1
 264:	fd679be3          	bne	a5,s6,23a <gets+0x22>
  for(i=0; i+1 < max; ){
 268:	89a6                	mv	s3,s1
 26a:	a011                	j	26e <gets+0x56>
 26c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 26e:	99de                	add	s3,s3,s7
 270:	00098023          	sb	zero,0(s3)
  return buf;
}
 274:	855e                	mv	a0,s7
 276:	60e6                	ld	ra,88(sp)
 278:	6446                	ld	s0,80(sp)
 27a:	64a6                	ld	s1,72(sp)
 27c:	6906                	ld	s2,64(sp)
 27e:	79e2                	ld	s3,56(sp)
 280:	7a42                	ld	s4,48(sp)
 282:	7aa2                	ld	s5,40(sp)
 284:	7b02                	ld	s6,32(sp)
 286:	6be2                	ld	s7,24(sp)
 288:	6125                	addi	sp,sp,96
 28a:	8082                	ret

000000000000028c <stat>:

int
stat(const char *n, struct stat *st)
{
 28c:	1101                	addi	sp,sp,-32
 28e:	ec06                	sd	ra,24(sp)
 290:	e822                	sd	s0,16(sp)
 292:	e426                	sd	s1,8(sp)
 294:	e04a                	sd	s2,0(sp)
 296:	1000                	addi	s0,sp,32
 298:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 29a:	4581                	li	a1,0
 29c:	00000097          	auipc	ra,0x0
 2a0:	176080e7          	jalr	374(ra) # 412 <open>
  if(fd < 0)
 2a4:	02054563          	bltz	a0,2ce <stat+0x42>
 2a8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2aa:	85ca                	mv	a1,s2
 2ac:	00000097          	auipc	ra,0x0
 2b0:	17e080e7          	jalr	382(ra) # 42a <fstat>
 2b4:	892a                	mv	s2,a0
  close(fd);
 2b6:	8526                	mv	a0,s1
 2b8:	00000097          	auipc	ra,0x0
 2bc:	142080e7          	jalr	322(ra) # 3fa <close>
  return r;
}
 2c0:	854a                	mv	a0,s2
 2c2:	60e2                	ld	ra,24(sp)
 2c4:	6442                	ld	s0,16(sp)
 2c6:	64a2                	ld	s1,8(sp)
 2c8:	6902                	ld	s2,0(sp)
 2ca:	6105                	addi	sp,sp,32
 2cc:	8082                	ret
    return -1;
 2ce:	597d                	li	s2,-1
 2d0:	bfc5                	j	2c0 <stat+0x34>

00000000000002d2 <atoi>:

int
atoi(const char *s)
{
 2d2:	1141                	addi	sp,sp,-16
 2d4:	e422                	sd	s0,8(sp)
 2d6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2d8:	00054603          	lbu	a2,0(a0)
 2dc:	fd06079b          	addiw	a5,a2,-48
 2e0:	0ff7f793          	andi	a5,a5,255
 2e4:	4725                	li	a4,9
 2e6:	02f76963          	bltu	a4,a5,318 <atoi+0x46>
 2ea:	86aa                	mv	a3,a0
  n = 0;
 2ec:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 2ee:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 2f0:	0685                	addi	a3,a3,1
 2f2:	0025179b          	slliw	a5,a0,0x2
 2f6:	9fa9                	addw	a5,a5,a0
 2f8:	0017979b          	slliw	a5,a5,0x1
 2fc:	9fb1                	addw	a5,a5,a2
 2fe:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 302:	0006c603          	lbu	a2,0(a3)
 306:	fd06071b          	addiw	a4,a2,-48
 30a:	0ff77713          	andi	a4,a4,255
 30e:	fee5f1e3          	bgeu	a1,a4,2f0 <atoi+0x1e>
  return n;
}
 312:	6422                	ld	s0,8(sp)
 314:	0141                	addi	sp,sp,16
 316:	8082                	ret
  n = 0;
 318:	4501                	li	a0,0
 31a:	bfe5                	j	312 <atoi+0x40>

000000000000031c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 31c:	1141                	addi	sp,sp,-16
 31e:	e422                	sd	s0,8(sp)
 320:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 322:	02b57663          	bgeu	a0,a1,34e <memmove+0x32>
    while(n-- > 0)
 326:	02c05163          	blez	a2,348 <memmove+0x2c>
 32a:	fff6079b          	addiw	a5,a2,-1
 32e:	1782                	slli	a5,a5,0x20
 330:	9381                	srli	a5,a5,0x20
 332:	0785                	addi	a5,a5,1
 334:	97aa                	add	a5,a5,a0
  dst = vdst;
 336:	872a                	mv	a4,a0
      *dst++ = *src++;
 338:	0585                	addi	a1,a1,1
 33a:	0705                	addi	a4,a4,1
 33c:	fff5c683          	lbu	a3,-1(a1)
 340:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 344:	fee79ae3          	bne	a5,a4,338 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 348:	6422                	ld	s0,8(sp)
 34a:	0141                	addi	sp,sp,16
 34c:	8082                	ret
    dst += n;
 34e:	00c50733          	add	a4,a0,a2
    src += n;
 352:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 354:	fec05ae3          	blez	a2,348 <memmove+0x2c>
 358:	fff6079b          	addiw	a5,a2,-1
 35c:	1782                	slli	a5,a5,0x20
 35e:	9381                	srli	a5,a5,0x20
 360:	fff7c793          	not	a5,a5
 364:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 366:	15fd                	addi	a1,a1,-1
 368:	177d                	addi	a4,a4,-1
 36a:	0005c683          	lbu	a3,0(a1)
 36e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 372:	fee79ae3          	bne	a5,a4,366 <memmove+0x4a>
 376:	bfc9                	j	348 <memmove+0x2c>

0000000000000378 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 378:	1141                	addi	sp,sp,-16
 37a:	e422                	sd	s0,8(sp)
 37c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 37e:	ca05                	beqz	a2,3ae <memcmp+0x36>
 380:	fff6069b          	addiw	a3,a2,-1
 384:	1682                	slli	a3,a3,0x20
 386:	9281                	srli	a3,a3,0x20
 388:	0685                	addi	a3,a3,1
 38a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 38c:	00054783          	lbu	a5,0(a0)
 390:	0005c703          	lbu	a4,0(a1)
 394:	00e79863          	bne	a5,a4,3a4 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 398:	0505                	addi	a0,a0,1
    p2++;
 39a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 39c:	fed518e3          	bne	a0,a3,38c <memcmp+0x14>
  }
  return 0;
 3a0:	4501                	li	a0,0
 3a2:	a019                	j	3a8 <memcmp+0x30>
      return *p1 - *p2;
 3a4:	40e7853b          	subw	a0,a5,a4
}
 3a8:	6422                	ld	s0,8(sp)
 3aa:	0141                	addi	sp,sp,16
 3ac:	8082                	ret
  return 0;
 3ae:	4501                	li	a0,0
 3b0:	bfe5                	j	3a8 <memcmp+0x30>

00000000000003b2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3b2:	1141                	addi	sp,sp,-16
 3b4:	e406                	sd	ra,8(sp)
 3b6:	e022                	sd	s0,0(sp)
 3b8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3ba:	00000097          	auipc	ra,0x0
 3be:	f62080e7          	jalr	-158(ra) # 31c <memmove>
}
 3c2:	60a2                	ld	ra,8(sp)
 3c4:	6402                	ld	s0,0(sp)
 3c6:	0141                	addi	sp,sp,16
 3c8:	8082                	ret

00000000000003ca <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3ca:	4885                	li	a7,1
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3d2:	4889                	li	a7,2
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <wait>:
.global wait
wait:
 li a7, SYS_wait
 3da:	488d                	li	a7,3
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3e2:	4891                	li	a7,4
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <read>:
.global read
read:
 li a7, SYS_read
 3ea:	4895                	li	a7,5
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <write>:
.global write
write:
 li a7, SYS_write
 3f2:	48c1                	li	a7,16
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <close>:
.global close
close:
 li a7, SYS_close
 3fa:	48d5                	li	a7,21
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <kill>:
.global kill
kill:
 li a7, SYS_kill
 402:	4899                	li	a7,6
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <exec>:
.global exec
exec:
 li a7, SYS_exec
 40a:	489d                	li	a7,7
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <open>:
.global open
open:
 li a7, SYS_open
 412:	48bd                	li	a7,15
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 41a:	48c5                	li	a7,17
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 422:	48c9                	li	a7,18
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 42a:	48a1                	li	a7,8
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <link>:
.global link
link:
 li a7, SYS_link
 432:	48cd                	li	a7,19
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 43a:	48d1                	li	a7,20
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 442:	48a5                	li	a7,9
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <dup>:
.global dup
dup:
 li a7, SYS_dup
 44a:	48a9                	li	a7,10
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 452:	48ad                	li	a7,11
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 45a:	48b1                	li	a7,12
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 462:	48b5                	li	a7,13
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 46a:	48b9                	li	a7,14
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 472:	1101                	addi	sp,sp,-32
 474:	ec06                	sd	ra,24(sp)
 476:	e822                	sd	s0,16(sp)
 478:	1000                	addi	s0,sp,32
 47a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 47e:	4605                	li	a2,1
 480:	fef40593          	addi	a1,s0,-17
 484:	00000097          	auipc	ra,0x0
 488:	f6e080e7          	jalr	-146(ra) # 3f2 <write>
}
 48c:	60e2                	ld	ra,24(sp)
 48e:	6442                	ld	s0,16(sp)
 490:	6105                	addi	sp,sp,32
 492:	8082                	ret

0000000000000494 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 494:	7139                	addi	sp,sp,-64
 496:	fc06                	sd	ra,56(sp)
 498:	f822                	sd	s0,48(sp)
 49a:	f426                	sd	s1,40(sp)
 49c:	f04a                	sd	s2,32(sp)
 49e:	ec4e                	sd	s3,24(sp)
 4a0:	0080                	addi	s0,sp,64
 4a2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4a4:	c299                	beqz	a3,4aa <printint+0x16>
 4a6:	0805c863          	bltz	a1,536 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4aa:	2581                	sext.w	a1,a1
  neg = 0;
 4ac:	4881                	li	a7,0
 4ae:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4b2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4b4:	2601                	sext.w	a2,a2
 4b6:	00000517          	auipc	a0,0x0
 4ba:	47a50513          	addi	a0,a0,1146 # 930 <digits>
 4be:	883a                	mv	a6,a4
 4c0:	2705                	addiw	a4,a4,1
 4c2:	02c5f7bb          	remuw	a5,a1,a2
 4c6:	1782                	slli	a5,a5,0x20
 4c8:	9381                	srli	a5,a5,0x20
 4ca:	97aa                	add	a5,a5,a0
 4cc:	0007c783          	lbu	a5,0(a5)
 4d0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4d4:	0005879b          	sext.w	a5,a1
 4d8:	02c5d5bb          	divuw	a1,a1,a2
 4dc:	0685                	addi	a3,a3,1
 4de:	fec7f0e3          	bgeu	a5,a2,4be <printint+0x2a>
  if(neg)
 4e2:	00088b63          	beqz	a7,4f8 <printint+0x64>
    buf[i++] = '-';
 4e6:	fd040793          	addi	a5,s0,-48
 4ea:	973e                	add	a4,a4,a5
 4ec:	02d00793          	li	a5,45
 4f0:	fef70823          	sb	a5,-16(a4)
 4f4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4f8:	02e05863          	blez	a4,528 <printint+0x94>
 4fc:	fc040793          	addi	a5,s0,-64
 500:	00e78933          	add	s2,a5,a4
 504:	fff78993          	addi	s3,a5,-1
 508:	99ba                	add	s3,s3,a4
 50a:	377d                	addiw	a4,a4,-1
 50c:	1702                	slli	a4,a4,0x20
 50e:	9301                	srli	a4,a4,0x20
 510:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 514:	fff94583          	lbu	a1,-1(s2)
 518:	8526                	mv	a0,s1
 51a:	00000097          	auipc	ra,0x0
 51e:	f58080e7          	jalr	-168(ra) # 472 <putc>
  while(--i >= 0)
 522:	197d                	addi	s2,s2,-1
 524:	ff3918e3          	bne	s2,s3,514 <printint+0x80>
}
 528:	70e2                	ld	ra,56(sp)
 52a:	7442                	ld	s0,48(sp)
 52c:	74a2                	ld	s1,40(sp)
 52e:	7902                	ld	s2,32(sp)
 530:	69e2                	ld	s3,24(sp)
 532:	6121                	addi	sp,sp,64
 534:	8082                	ret
    x = -xx;
 536:	40b005bb          	negw	a1,a1
    neg = 1;
 53a:	4885                	li	a7,1
    x = -xx;
 53c:	bf8d                	j	4ae <printint+0x1a>

000000000000053e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 53e:	7119                	addi	sp,sp,-128
 540:	fc86                	sd	ra,120(sp)
 542:	f8a2                	sd	s0,112(sp)
 544:	f4a6                	sd	s1,104(sp)
 546:	f0ca                	sd	s2,96(sp)
 548:	ecce                	sd	s3,88(sp)
 54a:	e8d2                	sd	s4,80(sp)
 54c:	e4d6                	sd	s5,72(sp)
 54e:	e0da                	sd	s6,64(sp)
 550:	fc5e                	sd	s7,56(sp)
 552:	f862                	sd	s8,48(sp)
 554:	f466                	sd	s9,40(sp)
 556:	f06a                	sd	s10,32(sp)
 558:	ec6e                	sd	s11,24(sp)
 55a:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 55c:	0005c903          	lbu	s2,0(a1)
 560:	18090f63          	beqz	s2,6fe <vprintf+0x1c0>
 564:	8aaa                	mv	s5,a0
 566:	8b32                	mv	s6,a2
 568:	00158493          	addi	s1,a1,1
  state = 0;
 56c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 56e:	02500a13          	li	s4,37
      if(c == 'd'){
 572:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 576:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 57a:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 57e:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 582:	00000b97          	auipc	s7,0x0
 586:	3aeb8b93          	addi	s7,s7,942 # 930 <digits>
 58a:	a839                	j	5a8 <vprintf+0x6a>
        putc(fd, c);
 58c:	85ca                	mv	a1,s2
 58e:	8556                	mv	a0,s5
 590:	00000097          	auipc	ra,0x0
 594:	ee2080e7          	jalr	-286(ra) # 472 <putc>
 598:	a019                	j	59e <vprintf+0x60>
    } else if(state == '%'){
 59a:	01498f63          	beq	s3,s4,5b8 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 59e:	0485                	addi	s1,s1,1
 5a0:	fff4c903          	lbu	s2,-1(s1)
 5a4:	14090d63          	beqz	s2,6fe <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 5a8:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5ac:	fe0997e3          	bnez	s3,59a <vprintf+0x5c>
      if(c == '%'){
 5b0:	fd479ee3          	bne	a5,s4,58c <vprintf+0x4e>
        state = '%';
 5b4:	89be                	mv	s3,a5
 5b6:	b7e5                	j	59e <vprintf+0x60>
      if(c == 'd'){
 5b8:	05878063          	beq	a5,s8,5f8 <vprintf+0xba>
      } else if(c == 'l') {
 5bc:	05978c63          	beq	a5,s9,614 <vprintf+0xd6>
      } else if(c == 'x') {
 5c0:	07a78863          	beq	a5,s10,630 <vprintf+0xf2>
      } else if(c == 'p') {
 5c4:	09b78463          	beq	a5,s11,64c <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 5c8:	07300713          	li	a4,115
 5cc:	0ce78663          	beq	a5,a4,698 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5d0:	06300713          	li	a4,99
 5d4:	0ee78e63          	beq	a5,a4,6d0 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 5d8:	11478863          	beq	a5,s4,6e8 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5dc:	85d2                	mv	a1,s4
 5de:	8556                	mv	a0,s5
 5e0:	00000097          	auipc	ra,0x0
 5e4:	e92080e7          	jalr	-366(ra) # 472 <putc>
        putc(fd, c);
 5e8:	85ca                	mv	a1,s2
 5ea:	8556                	mv	a0,s5
 5ec:	00000097          	auipc	ra,0x0
 5f0:	e86080e7          	jalr	-378(ra) # 472 <putc>
      }
      state = 0;
 5f4:	4981                	li	s3,0
 5f6:	b765                	j	59e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 5f8:	008b0913          	addi	s2,s6,8
 5fc:	4685                	li	a3,1
 5fe:	4629                	li	a2,10
 600:	000b2583          	lw	a1,0(s6)
 604:	8556                	mv	a0,s5
 606:	00000097          	auipc	ra,0x0
 60a:	e8e080e7          	jalr	-370(ra) # 494 <printint>
 60e:	8b4a                	mv	s6,s2
      state = 0;
 610:	4981                	li	s3,0
 612:	b771                	j	59e <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 614:	008b0913          	addi	s2,s6,8
 618:	4681                	li	a3,0
 61a:	4629                	li	a2,10
 61c:	000b2583          	lw	a1,0(s6)
 620:	8556                	mv	a0,s5
 622:	00000097          	auipc	ra,0x0
 626:	e72080e7          	jalr	-398(ra) # 494 <printint>
 62a:	8b4a                	mv	s6,s2
      state = 0;
 62c:	4981                	li	s3,0
 62e:	bf85                	j	59e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 630:	008b0913          	addi	s2,s6,8
 634:	4681                	li	a3,0
 636:	4641                	li	a2,16
 638:	000b2583          	lw	a1,0(s6)
 63c:	8556                	mv	a0,s5
 63e:	00000097          	auipc	ra,0x0
 642:	e56080e7          	jalr	-426(ra) # 494 <printint>
 646:	8b4a                	mv	s6,s2
      state = 0;
 648:	4981                	li	s3,0
 64a:	bf91                	j	59e <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 64c:	008b0793          	addi	a5,s6,8
 650:	f8f43423          	sd	a5,-120(s0)
 654:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 658:	03000593          	li	a1,48
 65c:	8556                	mv	a0,s5
 65e:	00000097          	auipc	ra,0x0
 662:	e14080e7          	jalr	-492(ra) # 472 <putc>
  putc(fd, 'x');
 666:	85ea                	mv	a1,s10
 668:	8556                	mv	a0,s5
 66a:	00000097          	auipc	ra,0x0
 66e:	e08080e7          	jalr	-504(ra) # 472 <putc>
 672:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 674:	03c9d793          	srli	a5,s3,0x3c
 678:	97de                	add	a5,a5,s7
 67a:	0007c583          	lbu	a1,0(a5)
 67e:	8556                	mv	a0,s5
 680:	00000097          	auipc	ra,0x0
 684:	df2080e7          	jalr	-526(ra) # 472 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 688:	0992                	slli	s3,s3,0x4
 68a:	397d                	addiw	s2,s2,-1
 68c:	fe0914e3          	bnez	s2,674 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 690:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 694:	4981                	li	s3,0
 696:	b721                	j	59e <vprintf+0x60>
        s = va_arg(ap, char*);
 698:	008b0993          	addi	s3,s6,8
 69c:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 6a0:	02090163          	beqz	s2,6c2 <vprintf+0x184>
        while(*s != 0){
 6a4:	00094583          	lbu	a1,0(s2)
 6a8:	c9a1                	beqz	a1,6f8 <vprintf+0x1ba>
          putc(fd, *s);
 6aa:	8556                	mv	a0,s5
 6ac:	00000097          	auipc	ra,0x0
 6b0:	dc6080e7          	jalr	-570(ra) # 472 <putc>
          s++;
 6b4:	0905                	addi	s2,s2,1
        while(*s != 0){
 6b6:	00094583          	lbu	a1,0(s2)
 6ba:	f9e5                	bnez	a1,6aa <vprintf+0x16c>
        s = va_arg(ap, char*);
 6bc:	8b4e                	mv	s6,s3
      state = 0;
 6be:	4981                	li	s3,0
 6c0:	bdf9                	j	59e <vprintf+0x60>
          s = "(null)";
 6c2:	00000917          	auipc	s2,0x0
 6c6:	26690913          	addi	s2,s2,614 # 928 <malloc+0x120>
        while(*s != 0){
 6ca:	02800593          	li	a1,40
 6ce:	bff1                	j	6aa <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 6d0:	008b0913          	addi	s2,s6,8
 6d4:	000b4583          	lbu	a1,0(s6)
 6d8:	8556                	mv	a0,s5
 6da:	00000097          	auipc	ra,0x0
 6de:	d98080e7          	jalr	-616(ra) # 472 <putc>
 6e2:	8b4a                	mv	s6,s2
      state = 0;
 6e4:	4981                	li	s3,0
 6e6:	bd65                	j	59e <vprintf+0x60>
        putc(fd, c);
 6e8:	85d2                	mv	a1,s4
 6ea:	8556                	mv	a0,s5
 6ec:	00000097          	auipc	ra,0x0
 6f0:	d86080e7          	jalr	-634(ra) # 472 <putc>
      state = 0;
 6f4:	4981                	li	s3,0
 6f6:	b565                	j	59e <vprintf+0x60>
        s = va_arg(ap, char*);
 6f8:	8b4e                	mv	s6,s3
      state = 0;
 6fa:	4981                	li	s3,0
 6fc:	b54d                	j	59e <vprintf+0x60>
    }
  }
}
 6fe:	70e6                	ld	ra,120(sp)
 700:	7446                	ld	s0,112(sp)
 702:	74a6                	ld	s1,104(sp)
 704:	7906                	ld	s2,96(sp)
 706:	69e6                	ld	s3,88(sp)
 708:	6a46                	ld	s4,80(sp)
 70a:	6aa6                	ld	s5,72(sp)
 70c:	6b06                	ld	s6,64(sp)
 70e:	7be2                	ld	s7,56(sp)
 710:	7c42                	ld	s8,48(sp)
 712:	7ca2                	ld	s9,40(sp)
 714:	7d02                	ld	s10,32(sp)
 716:	6de2                	ld	s11,24(sp)
 718:	6109                	addi	sp,sp,128
 71a:	8082                	ret

000000000000071c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 71c:	715d                	addi	sp,sp,-80
 71e:	ec06                	sd	ra,24(sp)
 720:	e822                	sd	s0,16(sp)
 722:	1000                	addi	s0,sp,32
 724:	e010                	sd	a2,0(s0)
 726:	e414                	sd	a3,8(s0)
 728:	e818                	sd	a4,16(s0)
 72a:	ec1c                	sd	a5,24(s0)
 72c:	03043023          	sd	a6,32(s0)
 730:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 734:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 738:	8622                	mv	a2,s0
 73a:	00000097          	auipc	ra,0x0
 73e:	e04080e7          	jalr	-508(ra) # 53e <vprintf>
}
 742:	60e2                	ld	ra,24(sp)
 744:	6442                	ld	s0,16(sp)
 746:	6161                	addi	sp,sp,80
 748:	8082                	ret

000000000000074a <printf>:

void
printf(const char *fmt, ...)
{
 74a:	711d                	addi	sp,sp,-96
 74c:	ec06                	sd	ra,24(sp)
 74e:	e822                	sd	s0,16(sp)
 750:	1000                	addi	s0,sp,32
 752:	e40c                	sd	a1,8(s0)
 754:	e810                	sd	a2,16(s0)
 756:	ec14                	sd	a3,24(s0)
 758:	f018                	sd	a4,32(s0)
 75a:	f41c                	sd	a5,40(s0)
 75c:	03043823          	sd	a6,48(s0)
 760:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 764:	00840613          	addi	a2,s0,8
 768:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 76c:	85aa                	mv	a1,a0
 76e:	4505                	li	a0,1
 770:	00000097          	auipc	ra,0x0
 774:	dce080e7          	jalr	-562(ra) # 53e <vprintf>
}
 778:	60e2                	ld	ra,24(sp)
 77a:	6442                	ld	s0,16(sp)
 77c:	6125                	addi	sp,sp,96
 77e:	8082                	ret

0000000000000780 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 780:	1141                	addi	sp,sp,-16
 782:	e422                	sd	s0,8(sp)
 784:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 786:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 78a:	00000797          	auipc	a5,0x0
 78e:	1be7b783          	ld	a5,446(a5) # 948 <freep>
 792:	a805                	j	7c2 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 794:	4618                	lw	a4,8(a2)
 796:	9db9                	addw	a1,a1,a4
 798:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 79c:	6398                	ld	a4,0(a5)
 79e:	6318                	ld	a4,0(a4)
 7a0:	fee53823          	sd	a4,-16(a0)
 7a4:	a091                	j	7e8 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7a6:	ff852703          	lw	a4,-8(a0)
 7aa:	9e39                	addw	a2,a2,a4
 7ac:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 7ae:	ff053703          	ld	a4,-16(a0)
 7b2:	e398                	sd	a4,0(a5)
 7b4:	a099                	j	7fa <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b6:	6398                	ld	a4,0(a5)
 7b8:	00e7e463          	bltu	a5,a4,7c0 <free+0x40>
 7bc:	00e6ea63          	bltu	a3,a4,7d0 <free+0x50>
{
 7c0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c2:	fed7fae3          	bgeu	a5,a3,7b6 <free+0x36>
 7c6:	6398                	ld	a4,0(a5)
 7c8:	00e6e463          	bltu	a3,a4,7d0 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7cc:	fee7eae3          	bltu	a5,a4,7c0 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 7d0:	ff852583          	lw	a1,-8(a0)
 7d4:	6390                	ld	a2,0(a5)
 7d6:	02059713          	slli	a4,a1,0x20
 7da:	9301                	srli	a4,a4,0x20
 7dc:	0712                	slli	a4,a4,0x4
 7de:	9736                	add	a4,a4,a3
 7e0:	fae60ae3          	beq	a2,a4,794 <free+0x14>
    bp->s.ptr = p->s.ptr;
 7e4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7e8:	4790                	lw	a2,8(a5)
 7ea:	02061713          	slli	a4,a2,0x20
 7ee:	9301                	srli	a4,a4,0x20
 7f0:	0712                	slli	a4,a4,0x4
 7f2:	973e                	add	a4,a4,a5
 7f4:	fae689e3          	beq	a3,a4,7a6 <free+0x26>
  } else
    p->s.ptr = bp;
 7f8:	e394                	sd	a3,0(a5)
  freep = p;
 7fa:	00000717          	auipc	a4,0x0
 7fe:	14f73723          	sd	a5,334(a4) # 948 <freep>
}
 802:	6422                	ld	s0,8(sp)
 804:	0141                	addi	sp,sp,16
 806:	8082                	ret

0000000000000808 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 808:	7139                	addi	sp,sp,-64
 80a:	fc06                	sd	ra,56(sp)
 80c:	f822                	sd	s0,48(sp)
 80e:	f426                	sd	s1,40(sp)
 810:	f04a                	sd	s2,32(sp)
 812:	ec4e                	sd	s3,24(sp)
 814:	e852                	sd	s4,16(sp)
 816:	e456                	sd	s5,8(sp)
 818:	e05a                	sd	s6,0(sp)
 81a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 81c:	02051493          	slli	s1,a0,0x20
 820:	9081                	srli	s1,s1,0x20
 822:	04bd                	addi	s1,s1,15
 824:	8091                	srli	s1,s1,0x4
 826:	0014899b          	addiw	s3,s1,1
 82a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 82c:	00000517          	auipc	a0,0x0
 830:	11c53503          	ld	a0,284(a0) # 948 <freep>
 834:	c515                	beqz	a0,860 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 836:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 838:	4798                	lw	a4,8(a5)
 83a:	02977f63          	bgeu	a4,s1,878 <malloc+0x70>
 83e:	8a4e                	mv	s4,s3
 840:	0009871b          	sext.w	a4,s3
 844:	6685                	lui	a3,0x1
 846:	00d77363          	bgeu	a4,a3,84c <malloc+0x44>
 84a:	6a05                	lui	s4,0x1
 84c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 850:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 854:	00000917          	auipc	s2,0x0
 858:	0f490913          	addi	s2,s2,244 # 948 <freep>
  if(p == (char*)-1)
 85c:	5afd                	li	s5,-1
 85e:	a88d                	j	8d0 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 860:	00000797          	auipc	a5,0x0
 864:	0f078793          	addi	a5,a5,240 # 950 <base>
 868:	00000717          	auipc	a4,0x0
 86c:	0ef73023          	sd	a5,224(a4) # 948 <freep>
 870:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 872:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 876:	b7e1                	j	83e <malloc+0x36>
      if(p->s.size == nunits)
 878:	02e48b63          	beq	s1,a4,8ae <malloc+0xa6>
        p->s.size -= nunits;
 87c:	4137073b          	subw	a4,a4,s3
 880:	c798                	sw	a4,8(a5)
        p += p->s.size;
 882:	1702                	slli	a4,a4,0x20
 884:	9301                	srli	a4,a4,0x20
 886:	0712                	slli	a4,a4,0x4
 888:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 88a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 88e:	00000717          	auipc	a4,0x0
 892:	0aa73d23          	sd	a0,186(a4) # 948 <freep>
      return (void*)(p + 1);
 896:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 89a:	70e2                	ld	ra,56(sp)
 89c:	7442                	ld	s0,48(sp)
 89e:	74a2                	ld	s1,40(sp)
 8a0:	7902                	ld	s2,32(sp)
 8a2:	69e2                	ld	s3,24(sp)
 8a4:	6a42                	ld	s4,16(sp)
 8a6:	6aa2                	ld	s5,8(sp)
 8a8:	6b02                	ld	s6,0(sp)
 8aa:	6121                	addi	sp,sp,64
 8ac:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8ae:	6398                	ld	a4,0(a5)
 8b0:	e118                	sd	a4,0(a0)
 8b2:	bff1                	j	88e <malloc+0x86>
  hp->s.size = nu;
 8b4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8b8:	0541                	addi	a0,a0,16
 8ba:	00000097          	auipc	ra,0x0
 8be:	ec6080e7          	jalr	-314(ra) # 780 <free>
  return freep;
 8c2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8c6:	d971                	beqz	a0,89a <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8ca:	4798                	lw	a4,8(a5)
 8cc:	fa9776e3          	bgeu	a4,s1,878 <malloc+0x70>
    if(p == freep)
 8d0:	00093703          	ld	a4,0(s2)
 8d4:	853e                	mv	a0,a5
 8d6:	fef719e3          	bne	a4,a5,8c8 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 8da:	8552                	mv	a0,s4
 8dc:	00000097          	auipc	ra,0x0
 8e0:	b7e080e7          	jalr	-1154(ra) # 45a <sbrk>
  if(p == (char*)-1)
 8e4:	fd5518e3          	bne	a0,s5,8b4 <malloc+0xac>
        return 0;
 8e8:	4501                	li	a0,0
 8ea:	bf45                	j	89a <malloc+0x92>
