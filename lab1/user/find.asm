
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "user/user.h"
#include "kernel/fs.h"

char *
fmtname(char *path) // 處你文件名
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	84aa                	mv	s1,a0
    static char buf[DIRSIZ + 1];
    char *p;

    // Find first character after last slash.
    for (p = path + strlen(path); p >= path && *p != '/'; p--)
  10:	00000097          	auipc	ra,0x0
  14:	350080e7          	jalr	848(ra) # 360 <strlen>
  18:	02051793          	slli	a5,a0,0x20
  1c:	9381                	srli	a5,a5,0x20
  1e:	97a6                	add	a5,a5,s1
  20:	02f00693          	li	a3,47
  24:	0097e963          	bltu	a5,s1,36 <fmtname+0x36>
  28:	0007c703          	lbu	a4,0(a5)
  2c:	00d70563          	beq	a4,a3,36 <fmtname+0x36>
  30:	17fd                	addi	a5,a5,-1
  32:	fe97fbe3          	bgeu	a5,s1,28 <fmtname+0x28>
        ;
    p++;
  36:	00178493          	addi	s1,a5,1

    // Return blank-padded name.
    if (strlen(p) >= DIRSIZ)
  3a:	8526                	mv	a0,s1
  3c:	00000097          	auipc	ra,0x0
  40:	324080e7          	jalr	804(ra) # 360 <strlen>
  44:	2501                	sext.w	a0,a0
  46:	47b5                	li	a5,13
  48:	00a7fa63          	bgeu	a5,a0,5c <fmtname+0x5c>
        return p;
    memmove(buf, p, strlen(p));
    memset(buf + strlen(p), 0, DIRSIZ - strlen(p));
    return buf;
}
  4c:	8526                	mv	a0,s1
  4e:	70a2                	ld	ra,40(sp)
  50:	7402                	ld	s0,32(sp)
  52:	64e2                	ld	s1,24(sp)
  54:	6942                	ld	s2,16(sp)
  56:	69a2                	ld	s3,8(sp)
  58:	6145                	addi	sp,sp,48
  5a:	8082                	ret
    memmove(buf, p, strlen(p));
  5c:	8526                	mv	a0,s1
  5e:	00000097          	auipc	ra,0x0
  62:	302080e7          	jalr	770(ra) # 360 <strlen>
  66:	00001997          	auipc	s3,0x1
  6a:	ada98993          	addi	s3,s3,-1318 # b40 <buf.1107>
  6e:	0005061b          	sext.w	a2,a0
  72:	85a6                	mv	a1,s1
  74:	854e                	mv	a0,s3
  76:	00000097          	auipc	ra,0x0
  7a:	462080e7          	jalr	1122(ra) # 4d8 <memmove>
    memset(buf + strlen(p), 0, DIRSIZ - strlen(p));
  7e:	8526                	mv	a0,s1
  80:	00000097          	auipc	ra,0x0
  84:	2e0080e7          	jalr	736(ra) # 360 <strlen>
  88:	0005091b          	sext.w	s2,a0
  8c:	8526                	mv	a0,s1
  8e:	00000097          	auipc	ra,0x0
  92:	2d2080e7          	jalr	722(ra) # 360 <strlen>
  96:	1902                	slli	s2,s2,0x20
  98:	02095913          	srli	s2,s2,0x20
  9c:	4639                	li	a2,14
  9e:	9e09                	subw	a2,a2,a0
  a0:	4581                	li	a1,0
  a2:	01298533          	add	a0,s3,s2
  a6:	00000097          	auipc	ra,0x0
  aa:	2e4080e7          	jalr	740(ra) # 38a <memset>
    return buf;
  ae:	84ce                	mv	s1,s3
  b0:	bf71                	j	4c <fmtname+0x4c>

00000000000000b2 <norecurse>:

int norecurse(char *path)
{
  b2:	1141                	addi	sp,sp,-16
  b4:	e406                	sd	ra,8(sp)
  b6:	e022                	sd	s0,0(sp)
  b8:	0800                	addi	s0,sp,16
    char *buf = fmtname(path);
  ba:	00000097          	auipc	ra,0x0
  be:	f46080e7          	jalr	-186(ra) # 0 <fmtname>
    if (buf[0] == '.' && buf[1] == 0)
  c2:	00054683          	lbu	a3,0(a0)
  c6:	02e00713          	li	a4,46
  ca:	00e68763          	beq	a3,a4,d8 <norecurse+0x26>
    }
    if (buf[0] == '.' && buf[1] == '.' && buf[2] == 0)
    {
        return 1;
    }
    return 0;
  ce:	4501                	li	a0,0
}
  d0:	60a2                	ld	ra,8(sp)
  d2:	6402                	ld	s0,0(sp)
  d4:	0141                	addi	sp,sp,16
  d6:	8082                	ret
  d8:	87aa                	mv	a5,a0
    if (buf[0] == '.' && buf[1] == 0)
  da:	00154703          	lbu	a4,1(a0)
        return 1;
  de:	4505                	li	a0,1
    if (buf[0] == '.' && buf[1] == 0)
  e0:	db65                	beqz	a4,d0 <norecurse+0x1e>
    if (buf[0] == '.' && buf[1] == '.' && buf[2] == 0)
  e2:	02e00693          	li	a3,46
    return 0;
  e6:	4501                	li	a0,0
    if (buf[0] == '.' && buf[1] == '.' && buf[2] == 0)
  e8:	fed714e3          	bne	a4,a3,d0 <norecurse+0x1e>
  ec:	0027c503          	lbu	a0,2(a5)
        return 1;
  f0:	00153513          	seqz	a0,a0
  f4:	bff1                	j	d0 <norecurse+0x1e>

00000000000000f6 <find>:

void find(char *path, char *target_file)
{
  f6:	d9010113          	addi	sp,sp,-624
  fa:	26113423          	sd	ra,616(sp)
  fe:	26813023          	sd	s0,608(sp)
 102:	24913c23          	sd	s1,600(sp)
 106:	25213823          	sd	s2,592(sp)
 10a:	25313423          	sd	s3,584(sp)
 10e:	25413023          	sd	s4,576(sp)
 112:	23513c23          	sd	s5,568(sp)
 116:	1c80                	addi	s0,sp,624
 118:	892a                	mv	s2,a0
 11a:	89ae                	mv	s3,a1
    char buf[512], *p;
    int fd;
    struct dirent de;
    struct stat st;

    if ((fd = open(path, 0)) < 0)
 11c:	4581                	li	a1,0
 11e:	00000097          	auipc	ra,0x0
 122:	4b0080e7          	jalr	1200(ra) # 5ce <open>
 126:	06054163          	bltz	a0,188 <find+0x92>
 12a:	84aa                	mv	s1,a0
    {
        fprintf(2, "ls: cannot open %s\n", path);
        return;
    }

    if (fstat(fd, &st) < 0)
 12c:	d9840593          	addi	a1,s0,-616
 130:	00000097          	auipc	ra,0x0
 134:	4b6080e7          	jalr	1206(ra) # 5e6 <fstat>
 138:	06054363          	bltz	a0,19e <find+0xa8>
    }
    // if (strcmp(fmtname(path), target_file) == 0)
    // {
    //     printf("%s\n", path);
    // }
    if (strcmp(fmtname(path), target_file) == 0)
 13c:	854a                	mv	a0,s2
 13e:	00000097          	auipc	ra,0x0
 142:	ec2080e7          	jalr	-318(ra) # 0 <fmtname>
 146:	85ce                	mv	a1,s3
 148:	00000097          	auipc	ra,0x0
 14c:	1ec080e7          	jalr	492(ra) # 334 <strcmp>
 150:	c53d                	beqz	a0,1be <find+0xc8>
    {
        printf("%s\n", path);
    }

    switch (st.type)
 152:	da041703          	lh	a4,-608(s0)
 156:	4785                	li	a5,1
 158:	06f70d63          	beq	a4,a5,1d2 <find+0xdc>
                find(buf, target_file);
            }
        }
        break;
    }
    close(fd);
 15c:	8526                	mv	a0,s1
 15e:	00000097          	auipc	ra,0x0
 162:	458080e7          	jalr	1112(ra) # 5b6 <close>
}
 166:	26813083          	ld	ra,616(sp)
 16a:	26013403          	ld	s0,608(sp)
 16e:	25813483          	ld	s1,600(sp)
 172:	25013903          	ld	s2,592(sp)
 176:	24813983          	ld	s3,584(sp)
 17a:	24013a03          	ld	s4,576(sp)
 17e:	23813a83          	ld	s5,568(sp)
 182:	27010113          	addi	sp,sp,624
 186:	8082                	ret
        fprintf(2, "ls: cannot open %s\n", path);
 188:	864a                	mv	a2,s2
 18a:	00001597          	auipc	a1,0x1
 18e:	91e58593          	addi	a1,a1,-1762 # aa8 <malloc+0xe4>
 192:	4509                	li	a0,2
 194:	00000097          	auipc	ra,0x0
 198:	744080e7          	jalr	1860(ra) # 8d8 <fprintf>
        return;
 19c:	b7e9                	j	166 <find+0x70>
        fprintf(2, "ls: cannot stat %s\n", path);
 19e:	864a                	mv	a2,s2
 1a0:	00001597          	auipc	a1,0x1
 1a4:	92058593          	addi	a1,a1,-1760 # ac0 <malloc+0xfc>
 1a8:	4509                	li	a0,2
 1aa:	00000097          	auipc	ra,0x0
 1ae:	72e080e7          	jalr	1838(ra) # 8d8 <fprintf>
        close(fd);
 1b2:	8526                	mv	a0,s1
 1b4:	00000097          	auipc	ra,0x0
 1b8:	402080e7          	jalr	1026(ra) # 5b6 <close>
        return;
 1bc:	b76d                	j	166 <find+0x70>
        printf("%s\n", path);
 1be:	85ca                	mv	a1,s2
 1c0:	00001517          	auipc	a0,0x1
 1c4:	8f850513          	addi	a0,a0,-1800 # ab8 <malloc+0xf4>
 1c8:	00000097          	auipc	ra,0x0
 1cc:	73e080e7          	jalr	1854(ra) # 906 <printf>
 1d0:	b749                	j	152 <find+0x5c>
        if (strlen(path) + 1 + DIRSIZ + 1 > sizeof buf)
 1d2:	854a                	mv	a0,s2
 1d4:	00000097          	auipc	ra,0x0
 1d8:	18c080e7          	jalr	396(ra) # 360 <strlen>
 1dc:	2541                	addiw	a0,a0,16
 1de:	20000793          	li	a5,512
 1e2:	00a7fb63          	bgeu	a5,a0,1f8 <find+0x102>
            printf("ls: path too long\n");
 1e6:	00001517          	auipc	a0,0x1
 1ea:	8f250513          	addi	a0,a0,-1806 # ad8 <malloc+0x114>
 1ee:	00000097          	auipc	ra,0x0
 1f2:	718080e7          	jalr	1816(ra) # 906 <printf>
            break;
 1f6:	b79d                	j	15c <find+0x66>
        strcpy(buf, path);
 1f8:	85ca                	mv	a1,s2
 1fa:	dc040513          	addi	a0,s0,-576
 1fe:	00000097          	auipc	ra,0x0
 202:	11a080e7          	jalr	282(ra) # 318 <strcpy>
        p = buf + strlen(buf);
 206:	dc040513          	addi	a0,s0,-576
 20a:	00000097          	auipc	ra,0x0
 20e:	156080e7          	jalr	342(ra) # 360 <strlen>
 212:	02051913          	slli	s2,a0,0x20
 216:	02095913          	srli	s2,s2,0x20
 21a:	dc040793          	addi	a5,s0,-576
 21e:	993e                	add	s2,s2,a5
        *p++ = '/';
 220:	00190a13          	addi	s4,s2,1
 224:	02f00793          	li	a5,47
 228:	00f90023          	sb	a5,0(s2)
                printf("ls: cannot stat %s\n", buf);
 22c:	00001a97          	auipc	s5,0x1
 230:	894a8a93          	addi	s5,s5,-1900 # ac0 <malloc+0xfc>
        while (read(fd, &de, sizeof(de)) == sizeof(de))
 234:	4641                	li	a2,16
 236:	db040593          	addi	a1,s0,-592
 23a:	8526                	mv	a0,s1
 23c:	00000097          	auipc	ra,0x0
 240:	36a080e7          	jalr	874(ra) # 5a6 <read>
 244:	47c1                	li	a5,16
 246:	f0f51be3          	bne	a0,a5,15c <find+0x66>
            if (de.inum == 0)
 24a:	db045783          	lhu	a5,-592(s0)
 24e:	d3fd                	beqz	a5,234 <find+0x13e>
            memmove(p, de.name, DIRSIZ);
 250:	4639                	li	a2,14
 252:	db240593          	addi	a1,s0,-590
 256:	8552                	mv	a0,s4
 258:	00000097          	auipc	ra,0x0
 25c:	280080e7          	jalr	640(ra) # 4d8 <memmove>
            p[DIRSIZ] = 0;
 260:	000907a3          	sb	zero,15(s2)
            if (stat(buf, &st) < 0)
 264:	d9840593          	addi	a1,s0,-616
 268:	dc040513          	addi	a0,s0,-576
 26c:	00000097          	auipc	ra,0x0
 270:	1dc080e7          	jalr	476(ra) # 448 <stat>
 274:	02054163          	bltz	a0,296 <find+0x1a0>
            if (norecurse(buf) == 0)
 278:	dc040513          	addi	a0,s0,-576
 27c:	00000097          	auipc	ra,0x0
 280:	e36080e7          	jalr	-458(ra) # b2 <norecurse>
 284:	f945                	bnez	a0,234 <find+0x13e>
                find(buf, target_file);
 286:	85ce                	mv	a1,s3
 288:	dc040513          	addi	a0,s0,-576
 28c:	00000097          	auipc	ra,0x0
 290:	e6a080e7          	jalr	-406(ra) # f6 <find>
 294:	b745                	j	234 <find+0x13e>
                printf("ls: cannot stat %s\n", buf);
 296:	dc040593          	addi	a1,s0,-576
 29a:	8556                	mv	a0,s5
 29c:	00000097          	auipc	ra,0x0
 2a0:	66a080e7          	jalr	1642(ra) # 906 <printf>
                continue;
 2a4:	bf41                	j	234 <find+0x13e>

00000000000002a6 <main>:

int main(int argc, char *argv[])
{
 2a6:	1141                	addi	sp,sp,-16
 2a8:	e406                	sd	ra,8(sp)
 2aa:	e022                	sd	s0,0(sp)
 2ac:	0800                	addi	s0,sp,16

    if (argc < 2)
 2ae:	4705                	li	a4,1
 2b0:	00a75e63          	bge	a4,a0,2cc <main+0x26>
 2b4:	87ae                	mv	a5,a1
    {
        printf("usage: find [path] [file_name]\n");
        exit(1);
    }
    if (argc == 2)
 2b6:	4709                	li	a4,2
 2b8:	02e50763          	beq	a0,a4,2e6 <main+0x40>
    {
        find(".", argv[1]);
        exit(0);
    }
    if (argc == 3)
 2bc:	470d                	li	a4,3
 2be:	04e50263          	beq	a0,a4,302 <main+0x5c>
    {
        find(argv[1], argv[2]);
        exit(0);
    }
    exit(0);
 2c2:	4501                	li	a0,0
 2c4:	00000097          	auipc	ra,0x0
 2c8:	2ca080e7          	jalr	714(ra) # 58e <exit>
        printf("usage: find [path] [file_name]\n");
 2cc:	00001517          	auipc	a0,0x1
 2d0:	82450513          	addi	a0,a0,-2012 # af0 <malloc+0x12c>
 2d4:	00000097          	auipc	ra,0x0
 2d8:	632080e7          	jalr	1586(ra) # 906 <printf>
        exit(1);
 2dc:	4505                	li	a0,1
 2de:	00000097          	auipc	ra,0x0
 2e2:	2b0080e7          	jalr	688(ra) # 58e <exit>
        find(".", argv[1]);
 2e6:	658c                	ld	a1,8(a1)
 2e8:	00001517          	auipc	a0,0x1
 2ec:	82850513          	addi	a0,a0,-2008 # b10 <malloc+0x14c>
 2f0:	00000097          	auipc	ra,0x0
 2f4:	e06080e7          	jalr	-506(ra) # f6 <find>
        exit(0);
 2f8:	4501                	li	a0,0
 2fa:	00000097          	auipc	ra,0x0
 2fe:	294080e7          	jalr	660(ra) # 58e <exit>
        find(argv[1], argv[2]);
 302:	698c                	ld	a1,16(a1)
 304:	6788                	ld	a0,8(a5)
 306:	00000097          	auipc	ra,0x0
 30a:	df0080e7          	jalr	-528(ra) # f6 <find>
        exit(0);
 30e:	4501                	li	a0,0
 310:	00000097          	auipc	ra,0x0
 314:	27e080e7          	jalr	638(ra) # 58e <exit>

0000000000000318 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 318:	1141                	addi	sp,sp,-16
 31a:	e422                	sd	s0,8(sp)
 31c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 31e:	87aa                	mv	a5,a0
 320:	0585                	addi	a1,a1,1
 322:	0785                	addi	a5,a5,1
 324:	fff5c703          	lbu	a4,-1(a1)
 328:	fee78fa3          	sb	a4,-1(a5)
 32c:	fb75                	bnez	a4,320 <strcpy+0x8>
    ;
  return os;
}
 32e:	6422                	ld	s0,8(sp)
 330:	0141                	addi	sp,sp,16
 332:	8082                	ret

0000000000000334 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 334:	1141                	addi	sp,sp,-16
 336:	e422                	sd	s0,8(sp)
 338:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 33a:	00054783          	lbu	a5,0(a0)
 33e:	cb91                	beqz	a5,352 <strcmp+0x1e>
 340:	0005c703          	lbu	a4,0(a1)
 344:	00f71763          	bne	a4,a5,352 <strcmp+0x1e>
    p++, q++;
 348:	0505                	addi	a0,a0,1
 34a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 34c:	00054783          	lbu	a5,0(a0)
 350:	fbe5                	bnez	a5,340 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 352:	0005c503          	lbu	a0,0(a1)
}
 356:	40a7853b          	subw	a0,a5,a0
 35a:	6422                	ld	s0,8(sp)
 35c:	0141                	addi	sp,sp,16
 35e:	8082                	ret

0000000000000360 <strlen>:

uint
strlen(const char *s)
{
 360:	1141                	addi	sp,sp,-16
 362:	e422                	sd	s0,8(sp)
 364:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 366:	00054783          	lbu	a5,0(a0)
 36a:	cf91                	beqz	a5,386 <strlen+0x26>
 36c:	0505                	addi	a0,a0,1
 36e:	87aa                	mv	a5,a0
 370:	4685                	li	a3,1
 372:	9e89                	subw	a3,a3,a0
 374:	00f6853b          	addw	a0,a3,a5
 378:	0785                	addi	a5,a5,1
 37a:	fff7c703          	lbu	a4,-1(a5)
 37e:	fb7d                	bnez	a4,374 <strlen+0x14>
    ;
  return n;
}
 380:	6422                	ld	s0,8(sp)
 382:	0141                	addi	sp,sp,16
 384:	8082                	ret
  for(n = 0; s[n]; n++)
 386:	4501                	li	a0,0
 388:	bfe5                	j	380 <strlen+0x20>

000000000000038a <memset>:

void*
memset(void *dst, int c, uint n)
{
 38a:	1141                	addi	sp,sp,-16
 38c:	e422                	sd	s0,8(sp)
 38e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 390:	ce09                	beqz	a2,3aa <memset+0x20>
 392:	87aa                	mv	a5,a0
 394:	fff6071b          	addiw	a4,a2,-1
 398:	1702                	slli	a4,a4,0x20
 39a:	9301                	srli	a4,a4,0x20
 39c:	0705                	addi	a4,a4,1
 39e:	972a                	add	a4,a4,a0
    cdst[i] = c;
 3a0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 3a4:	0785                	addi	a5,a5,1
 3a6:	fee79de3          	bne	a5,a4,3a0 <memset+0x16>
  }
  return dst;
}
 3aa:	6422                	ld	s0,8(sp)
 3ac:	0141                	addi	sp,sp,16
 3ae:	8082                	ret

00000000000003b0 <strchr>:

char*
strchr(const char *s, char c)
{
 3b0:	1141                	addi	sp,sp,-16
 3b2:	e422                	sd	s0,8(sp)
 3b4:	0800                	addi	s0,sp,16
  for(; *s; s++)
 3b6:	00054783          	lbu	a5,0(a0)
 3ba:	cb99                	beqz	a5,3d0 <strchr+0x20>
    if(*s == c)
 3bc:	00f58763          	beq	a1,a5,3ca <strchr+0x1a>
  for(; *s; s++)
 3c0:	0505                	addi	a0,a0,1
 3c2:	00054783          	lbu	a5,0(a0)
 3c6:	fbfd                	bnez	a5,3bc <strchr+0xc>
      return (char*)s;
  return 0;
 3c8:	4501                	li	a0,0
}
 3ca:	6422                	ld	s0,8(sp)
 3cc:	0141                	addi	sp,sp,16
 3ce:	8082                	ret
  return 0;
 3d0:	4501                	li	a0,0
 3d2:	bfe5                	j	3ca <strchr+0x1a>

00000000000003d4 <gets>:

char*
gets(char *buf, int max)
{
 3d4:	711d                	addi	sp,sp,-96
 3d6:	ec86                	sd	ra,88(sp)
 3d8:	e8a2                	sd	s0,80(sp)
 3da:	e4a6                	sd	s1,72(sp)
 3dc:	e0ca                	sd	s2,64(sp)
 3de:	fc4e                	sd	s3,56(sp)
 3e0:	f852                	sd	s4,48(sp)
 3e2:	f456                	sd	s5,40(sp)
 3e4:	f05a                	sd	s6,32(sp)
 3e6:	ec5e                	sd	s7,24(sp)
 3e8:	1080                	addi	s0,sp,96
 3ea:	8baa                	mv	s7,a0
 3ec:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3ee:	892a                	mv	s2,a0
 3f0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3f2:	4aa9                	li	s5,10
 3f4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3f6:	89a6                	mv	s3,s1
 3f8:	2485                	addiw	s1,s1,1
 3fa:	0344d863          	bge	s1,s4,42a <gets+0x56>
    cc = read(0, &c, 1);
 3fe:	4605                	li	a2,1
 400:	faf40593          	addi	a1,s0,-81
 404:	4501                	li	a0,0
 406:	00000097          	auipc	ra,0x0
 40a:	1a0080e7          	jalr	416(ra) # 5a6 <read>
    if(cc < 1)
 40e:	00a05e63          	blez	a0,42a <gets+0x56>
    buf[i++] = c;
 412:	faf44783          	lbu	a5,-81(s0)
 416:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 41a:	01578763          	beq	a5,s5,428 <gets+0x54>
 41e:	0905                	addi	s2,s2,1
 420:	fd679be3          	bne	a5,s6,3f6 <gets+0x22>
  for(i=0; i+1 < max; ){
 424:	89a6                	mv	s3,s1
 426:	a011                	j	42a <gets+0x56>
 428:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 42a:	99de                	add	s3,s3,s7
 42c:	00098023          	sb	zero,0(s3)
  return buf;
}
 430:	855e                	mv	a0,s7
 432:	60e6                	ld	ra,88(sp)
 434:	6446                	ld	s0,80(sp)
 436:	64a6                	ld	s1,72(sp)
 438:	6906                	ld	s2,64(sp)
 43a:	79e2                	ld	s3,56(sp)
 43c:	7a42                	ld	s4,48(sp)
 43e:	7aa2                	ld	s5,40(sp)
 440:	7b02                	ld	s6,32(sp)
 442:	6be2                	ld	s7,24(sp)
 444:	6125                	addi	sp,sp,96
 446:	8082                	ret

0000000000000448 <stat>:

int
stat(const char *n, struct stat *st)
{
 448:	1101                	addi	sp,sp,-32
 44a:	ec06                	sd	ra,24(sp)
 44c:	e822                	sd	s0,16(sp)
 44e:	e426                	sd	s1,8(sp)
 450:	e04a                	sd	s2,0(sp)
 452:	1000                	addi	s0,sp,32
 454:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 456:	4581                	li	a1,0
 458:	00000097          	auipc	ra,0x0
 45c:	176080e7          	jalr	374(ra) # 5ce <open>
  if(fd < 0)
 460:	02054563          	bltz	a0,48a <stat+0x42>
 464:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 466:	85ca                	mv	a1,s2
 468:	00000097          	auipc	ra,0x0
 46c:	17e080e7          	jalr	382(ra) # 5e6 <fstat>
 470:	892a                	mv	s2,a0
  close(fd);
 472:	8526                	mv	a0,s1
 474:	00000097          	auipc	ra,0x0
 478:	142080e7          	jalr	322(ra) # 5b6 <close>
  return r;
}
 47c:	854a                	mv	a0,s2
 47e:	60e2                	ld	ra,24(sp)
 480:	6442                	ld	s0,16(sp)
 482:	64a2                	ld	s1,8(sp)
 484:	6902                	ld	s2,0(sp)
 486:	6105                	addi	sp,sp,32
 488:	8082                	ret
    return -1;
 48a:	597d                	li	s2,-1
 48c:	bfc5                	j	47c <stat+0x34>

000000000000048e <atoi>:

int
atoi(const char *s)
{
 48e:	1141                	addi	sp,sp,-16
 490:	e422                	sd	s0,8(sp)
 492:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 494:	00054603          	lbu	a2,0(a0)
 498:	fd06079b          	addiw	a5,a2,-48
 49c:	0ff7f793          	andi	a5,a5,255
 4a0:	4725                	li	a4,9
 4a2:	02f76963          	bltu	a4,a5,4d4 <atoi+0x46>
 4a6:	86aa                	mv	a3,a0
  n = 0;
 4a8:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 4aa:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 4ac:	0685                	addi	a3,a3,1
 4ae:	0025179b          	slliw	a5,a0,0x2
 4b2:	9fa9                	addw	a5,a5,a0
 4b4:	0017979b          	slliw	a5,a5,0x1
 4b8:	9fb1                	addw	a5,a5,a2
 4ba:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 4be:	0006c603          	lbu	a2,0(a3)
 4c2:	fd06071b          	addiw	a4,a2,-48
 4c6:	0ff77713          	andi	a4,a4,255
 4ca:	fee5f1e3          	bgeu	a1,a4,4ac <atoi+0x1e>
  return n;
}
 4ce:	6422                	ld	s0,8(sp)
 4d0:	0141                	addi	sp,sp,16
 4d2:	8082                	ret
  n = 0;
 4d4:	4501                	li	a0,0
 4d6:	bfe5                	j	4ce <atoi+0x40>

00000000000004d8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4d8:	1141                	addi	sp,sp,-16
 4da:	e422                	sd	s0,8(sp)
 4dc:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4de:	02b57663          	bgeu	a0,a1,50a <memmove+0x32>
    while(n-- > 0)
 4e2:	02c05163          	blez	a2,504 <memmove+0x2c>
 4e6:	fff6079b          	addiw	a5,a2,-1
 4ea:	1782                	slli	a5,a5,0x20
 4ec:	9381                	srli	a5,a5,0x20
 4ee:	0785                	addi	a5,a5,1
 4f0:	97aa                	add	a5,a5,a0
  dst = vdst;
 4f2:	872a                	mv	a4,a0
      *dst++ = *src++;
 4f4:	0585                	addi	a1,a1,1
 4f6:	0705                	addi	a4,a4,1
 4f8:	fff5c683          	lbu	a3,-1(a1)
 4fc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 500:	fee79ae3          	bne	a5,a4,4f4 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 504:	6422                	ld	s0,8(sp)
 506:	0141                	addi	sp,sp,16
 508:	8082                	ret
    dst += n;
 50a:	00c50733          	add	a4,a0,a2
    src += n;
 50e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 510:	fec05ae3          	blez	a2,504 <memmove+0x2c>
 514:	fff6079b          	addiw	a5,a2,-1
 518:	1782                	slli	a5,a5,0x20
 51a:	9381                	srli	a5,a5,0x20
 51c:	fff7c793          	not	a5,a5
 520:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 522:	15fd                	addi	a1,a1,-1
 524:	177d                	addi	a4,a4,-1
 526:	0005c683          	lbu	a3,0(a1)
 52a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 52e:	fee79ae3          	bne	a5,a4,522 <memmove+0x4a>
 532:	bfc9                	j	504 <memmove+0x2c>

0000000000000534 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 534:	1141                	addi	sp,sp,-16
 536:	e422                	sd	s0,8(sp)
 538:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 53a:	ca05                	beqz	a2,56a <memcmp+0x36>
 53c:	fff6069b          	addiw	a3,a2,-1
 540:	1682                	slli	a3,a3,0x20
 542:	9281                	srli	a3,a3,0x20
 544:	0685                	addi	a3,a3,1
 546:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 548:	00054783          	lbu	a5,0(a0)
 54c:	0005c703          	lbu	a4,0(a1)
 550:	00e79863          	bne	a5,a4,560 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 554:	0505                	addi	a0,a0,1
    p2++;
 556:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 558:	fed518e3          	bne	a0,a3,548 <memcmp+0x14>
  }
  return 0;
 55c:	4501                	li	a0,0
 55e:	a019                	j	564 <memcmp+0x30>
      return *p1 - *p2;
 560:	40e7853b          	subw	a0,a5,a4
}
 564:	6422                	ld	s0,8(sp)
 566:	0141                	addi	sp,sp,16
 568:	8082                	ret
  return 0;
 56a:	4501                	li	a0,0
 56c:	bfe5                	j	564 <memcmp+0x30>

000000000000056e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 56e:	1141                	addi	sp,sp,-16
 570:	e406                	sd	ra,8(sp)
 572:	e022                	sd	s0,0(sp)
 574:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 576:	00000097          	auipc	ra,0x0
 57a:	f62080e7          	jalr	-158(ra) # 4d8 <memmove>
}
 57e:	60a2                	ld	ra,8(sp)
 580:	6402                	ld	s0,0(sp)
 582:	0141                	addi	sp,sp,16
 584:	8082                	ret

0000000000000586 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 586:	4885                	li	a7,1
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <exit>:
.global exit
exit:
 li a7, SYS_exit
 58e:	4889                	li	a7,2
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <wait>:
.global wait
wait:
 li a7, SYS_wait
 596:	488d                	li	a7,3
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 59e:	4891                	li	a7,4
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <read>:
.global read
read:
 li a7, SYS_read
 5a6:	4895                	li	a7,5
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <write>:
.global write
write:
 li a7, SYS_write
 5ae:	48c1                	li	a7,16
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <close>:
.global close
close:
 li a7, SYS_close
 5b6:	48d5                	li	a7,21
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <kill>:
.global kill
kill:
 li a7, SYS_kill
 5be:	4899                	li	a7,6
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5c6:	489d                	li	a7,7
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	8082                	ret

00000000000005ce <open>:
.global open
open:
 li a7, SYS_open
 5ce:	48bd                	li	a7,15
 ecall
 5d0:	00000073          	ecall
 ret
 5d4:	8082                	ret

00000000000005d6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5d6:	48c5                	li	a7,17
 ecall
 5d8:	00000073          	ecall
 ret
 5dc:	8082                	ret

00000000000005de <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5de:	48c9                	li	a7,18
 ecall
 5e0:	00000073          	ecall
 ret
 5e4:	8082                	ret

00000000000005e6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5e6:	48a1                	li	a7,8
 ecall
 5e8:	00000073          	ecall
 ret
 5ec:	8082                	ret

00000000000005ee <link>:
.global link
link:
 li a7, SYS_link
 5ee:	48cd                	li	a7,19
 ecall
 5f0:	00000073          	ecall
 ret
 5f4:	8082                	ret

00000000000005f6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5f6:	48d1                	li	a7,20
 ecall
 5f8:	00000073          	ecall
 ret
 5fc:	8082                	ret

00000000000005fe <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5fe:	48a5                	li	a7,9
 ecall
 600:	00000073          	ecall
 ret
 604:	8082                	ret

0000000000000606 <dup>:
.global dup
dup:
 li a7, SYS_dup
 606:	48a9                	li	a7,10
 ecall
 608:	00000073          	ecall
 ret
 60c:	8082                	ret

000000000000060e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 60e:	48ad                	li	a7,11
 ecall
 610:	00000073          	ecall
 ret
 614:	8082                	ret

0000000000000616 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 616:	48b1                	li	a7,12
 ecall
 618:	00000073          	ecall
 ret
 61c:	8082                	ret

000000000000061e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 61e:	48b5                	li	a7,13
 ecall
 620:	00000073          	ecall
 ret
 624:	8082                	ret

0000000000000626 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 626:	48b9                	li	a7,14
 ecall
 628:	00000073          	ecall
 ret
 62c:	8082                	ret

000000000000062e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 62e:	1101                	addi	sp,sp,-32
 630:	ec06                	sd	ra,24(sp)
 632:	e822                	sd	s0,16(sp)
 634:	1000                	addi	s0,sp,32
 636:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 63a:	4605                	li	a2,1
 63c:	fef40593          	addi	a1,s0,-17
 640:	00000097          	auipc	ra,0x0
 644:	f6e080e7          	jalr	-146(ra) # 5ae <write>
}
 648:	60e2                	ld	ra,24(sp)
 64a:	6442                	ld	s0,16(sp)
 64c:	6105                	addi	sp,sp,32
 64e:	8082                	ret

0000000000000650 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 650:	7139                	addi	sp,sp,-64
 652:	fc06                	sd	ra,56(sp)
 654:	f822                	sd	s0,48(sp)
 656:	f426                	sd	s1,40(sp)
 658:	f04a                	sd	s2,32(sp)
 65a:	ec4e                	sd	s3,24(sp)
 65c:	0080                	addi	s0,sp,64
 65e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 660:	c299                	beqz	a3,666 <printint+0x16>
 662:	0805c863          	bltz	a1,6f2 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 666:	2581                	sext.w	a1,a1
  neg = 0;
 668:	4881                	li	a7,0
 66a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 66e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 670:	2601                	sext.w	a2,a2
 672:	00000517          	auipc	a0,0x0
 676:	4ae50513          	addi	a0,a0,1198 # b20 <digits>
 67a:	883a                	mv	a6,a4
 67c:	2705                	addiw	a4,a4,1
 67e:	02c5f7bb          	remuw	a5,a1,a2
 682:	1782                	slli	a5,a5,0x20
 684:	9381                	srli	a5,a5,0x20
 686:	97aa                	add	a5,a5,a0
 688:	0007c783          	lbu	a5,0(a5)
 68c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 690:	0005879b          	sext.w	a5,a1
 694:	02c5d5bb          	divuw	a1,a1,a2
 698:	0685                	addi	a3,a3,1
 69a:	fec7f0e3          	bgeu	a5,a2,67a <printint+0x2a>
  if(neg)
 69e:	00088b63          	beqz	a7,6b4 <printint+0x64>
    buf[i++] = '-';
 6a2:	fd040793          	addi	a5,s0,-48
 6a6:	973e                	add	a4,a4,a5
 6a8:	02d00793          	li	a5,45
 6ac:	fef70823          	sb	a5,-16(a4)
 6b0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 6b4:	02e05863          	blez	a4,6e4 <printint+0x94>
 6b8:	fc040793          	addi	a5,s0,-64
 6bc:	00e78933          	add	s2,a5,a4
 6c0:	fff78993          	addi	s3,a5,-1
 6c4:	99ba                	add	s3,s3,a4
 6c6:	377d                	addiw	a4,a4,-1
 6c8:	1702                	slli	a4,a4,0x20
 6ca:	9301                	srli	a4,a4,0x20
 6cc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6d0:	fff94583          	lbu	a1,-1(s2)
 6d4:	8526                	mv	a0,s1
 6d6:	00000097          	auipc	ra,0x0
 6da:	f58080e7          	jalr	-168(ra) # 62e <putc>
  while(--i >= 0)
 6de:	197d                	addi	s2,s2,-1
 6e0:	ff3918e3          	bne	s2,s3,6d0 <printint+0x80>
}
 6e4:	70e2                	ld	ra,56(sp)
 6e6:	7442                	ld	s0,48(sp)
 6e8:	74a2                	ld	s1,40(sp)
 6ea:	7902                	ld	s2,32(sp)
 6ec:	69e2                	ld	s3,24(sp)
 6ee:	6121                	addi	sp,sp,64
 6f0:	8082                	ret
    x = -xx;
 6f2:	40b005bb          	negw	a1,a1
    neg = 1;
 6f6:	4885                	li	a7,1
    x = -xx;
 6f8:	bf8d                	j	66a <printint+0x1a>

00000000000006fa <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6fa:	7119                	addi	sp,sp,-128
 6fc:	fc86                	sd	ra,120(sp)
 6fe:	f8a2                	sd	s0,112(sp)
 700:	f4a6                	sd	s1,104(sp)
 702:	f0ca                	sd	s2,96(sp)
 704:	ecce                	sd	s3,88(sp)
 706:	e8d2                	sd	s4,80(sp)
 708:	e4d6                	sd	s5,72(sp)
 70a:	e0da                	sd	s6,64(sp)
 70c:	fc5e                	sd	s7,56(sp)
 70e:	f862                	sd	s8,48(sp)
 710:	f466                	sd	s9,40(sp)
 712:	f06a                	sd	s10,32(sp)
 714:	ec6e                	sd	s11,24(sp)
 716:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 718:	0005c903          	lbu	s2,0(a1)
 71c:	18090f63          	beqz	s2,8ba <vprintf+0x1c0>
 720:	8aaa                	mv	s5,a0
 722:	8b32                	mv	s6,a2
 724:	00158493          	addi	s1,a1,1
  state = 0;
 728:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 72a:	02500a13          	li	s4,37
      if(c == 'd'){
 72e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 732:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 736:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 73a:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 73e:	00000b97          	auipc	s7,0x0
 742:	3e2b8b93          	addi	s7,s7,994 # b20 <digits>
 746:	a839                	j	764 <vprintf+0x6a>
        putc(fd, c);
 748:	85ca                	mv	a1,s2
 74a:	8556                	mv	a0,s5
 74c:	00000097          	auipc	ra,0x0
 750:	ee2080e7          	jalr	-286(ra) # 62e <putc>
 754:	a019                	j	75a <vprintf+0x60>
    } else if(state == '%'){
 756:	01498f63          	beq	s3,s4,774 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 75a:	0485                	addi	s1,s1,1
 75c:	fff4c903          	lbu	s2,-1(s1)
 760:	14090d63          	beqz	s2,8ba <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 764:	0009079b          	sext.w	a5,s2
    if(state == 0){
 768:	fe0997e3          	bnez	s3,756 <vprintf+0x5c>
      if(c == '%'){
 76c:	fd479ee3          	bne	a5,s4,748 <vprintf+0x4e>
        state = '%';
 770:	89be                	mv	s3,a5
 772:	b7e5                	j	75a <vprintf+0x60>
      if(c == 'd'){
 774:	05878063          	beq	a5,s8,7b4 <vprintf+0xba>
      } else if(c == 'l') {
 778:	05978c63          	beq	a5,s9,7d0 <vprintf+0xd6>
      } else if(c == 'x') {
 77c:	07a78863          	beq	a5,s10,7ec <vprintf+0xf2>
      } else if(c == 'p') {
 780:	09b78463          	beq	a5,s11,808 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 784:	07300713          	li	a4,115
 788:	0ce78663          	beq	a5,a4,854 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 78c:	06300713          	li	a4,99
 790:	0ee78e63          	beq	a5,a4,88c <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 794:	11478863          	beq	a5,s4,8a4 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 798:	85d2                	mv	a1,s4
 79a:	8556                	mv	a0,s5
 79c:	00000097          	auipc	ra,0x0
 7a0:	e92080e7          	jalr	-366(ra) # 62e <putc>
        putc(fd, c);
 7a4:	85ca                	mv	a1,s2
 7a6:	8556                	mv	a0,s5
 7a8:	00000097          	auipc	ra,0x0
 7ac:	e86080e7          	jalr	-378(ra) # 62e <putc>
      }
      state = 0;
 7b0:	4981                	li	s3,0
 7b2:	b765                	j	75a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 7b4:	008b0913          	addi	s2,s6,8
 7b8:	4685                	li	a3,1
 7ba:	4629                	li	a2,10
 7bc:	000b2583          	lw	a1,0(s6)
 7c0:	8556                	mv	a0,s5
 7c2:	00000097          	auipc	ra,0x0
 7c6:	e8e080e7          	jalr	-370(ra) # 650 <printint>
 7ca:	8b4a                	mv	s6,s2
      state = 0;
 7cc:	4981                	li	s3,0
 7ce:	b771                	j	75a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7d0:	008b0913          	addi	s2,s6,8
 7d4:	4681                	li	a3,0
 7d6:	4629                	li	a2,10
 7d8:	000b2583          	lw	a1,0(s6)
 7dc:	8556                	mv	a0,s5
 7de:	00000097          	auipc	ra,0x0
 7e2:	e72080e7          	jalr	-398(ra) # 650 <printint>
 7e6:	8b4a                	mv	s6,s2
      state = 0;
 7e8:	4981                	li	s3,0
 7ea:	bf85                	j	75a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 7ec:	008b0913          	addi	s2,s6,8
 7f0:	4681                	li	a3,0
 7f2:	4641                	li	a2,16
 7f4:	000b2583          	lw	a1,0(s6)
 7f8:	8556                	mv	a0,s5
 7fa:	00000097          	auipc	ra,0x0
 7fe:	e56080e7          	jalr	-426(ra) # 650 <printint>
 802:	8b4a                	mv	s6,s2
      state = 0;
 804:	4981                	li	s3,0
 806:	bf91                	j	75a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 808:	008b0793          	addi	a5,s6,8
 80c:	f8f43423          	sd	a5,-120(s0)
 810:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 814:	03000593          	li	a1,48
 818:	8556                	mv	a0,s5
 81a:	00000097          	auipc	ra,0x0
 81e:	e14080e7          	jalr	-492(ra) # 62e <putc>
  putc(fd, 'x');
 822:	85ea                	mv	a1,s10
 824:	8556                	mv	a0,s5
 826:	00000097          	auipc	ra,0x0
 82a:	e08080e7          	jalr	-504(ra) # 62e <putc>
 82e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 830:	03c9d793          	srli	a5,s3,0x3c
 834:	97de                	add	a5,a5,s7
 836:	0007c583          	lbu	a1,0(a5)
 83a:	8556                	mv	a0,s5
 83c:	00000097          	auipc	ra,0x0
 840:	df2080e7          	jalr	-526(ra) # 62e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 844:	0992                	slli	s3,s3,0x4
 846:	397d                	addiw	s2,s2,-1
 848:	fe0914e3          	bnez	s2,830 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 84c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 850:	4981                	li	s3,0
 852:	b721                	j	75a <vprintf+0x60>
        s = va_arg(ap, char*);
 854:	008b0993          	addi	s3,s6,8
 858:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 85c:	02090163          	beqz	s2,87e <vprintf+0x184>
        while(*s != 0){
 860:	00094583          	lbu	a1,0(s2)
 864:	c9a1                	beqz	a1,8b4 <vprintf+0x1ba>
          putc(fd, *s);
 866:	8556                	mv	a0,s5
 868:	00000097          	auipc	ra,0x0
 86c:	dc6080e7          	jalr	-570(ra) # 62e <putc>
          s++;
 870:	0905                	addi	s2,s2,1
        while(*s != 0){
 872:	00094583          	lbu	a1,0(s2)
 876:	f9e5                	bnez	a1,866 <vprintf+0x16c>
        s = va_arg(ap, char*);
 878:	8b4e                	mv	s6,s3
      state = 0;
 87a:	4981                	li	s3,0
 87c:	bdf9                	j	75a <vprintf+0x60>
          s = "(null)";
 87e:	00000917          	auipc	s2,0x0
 882:	29a90913          	addi	s2,s2,666 # b18 <malloc+0x154>
        while(*s != 0){
 886:	02800593          	li	a1,40
 88a:	bff1                	j	866 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 88c:	008b0913          	addi	s2,s6,8
 890:	000b4583          	lbu	a1,0(s6)
 894:	8556                	mv	a0,s5
 896:	00000097          	auipc	ra,0x0
 89a:	d98080e7          	jalr	-616(ra) # 62e <putc>
 89e:	8b4a                	mv	s6,s2
      state = 0;
 8a0:	4981                	li	s3,0
 8a2:	bd65                	j	75a <vprintf+0x60>
        putc(fd, c);
 8a4:	85d2                	mv	a1,s4
 8a6:	8556                	mv	a0,s5
 8a8:	00000097          	auipc	ra,0x0
 8ac:	d86080e7          	jalr	-634(ra) # 62e <putc>
      state = 0;
 8b0:	4981                	li	s3,0
 8b2:	b565                	j	75a <vprintf+0x60>
        s = va_arg(ap, char*);
 8b4:	8b4e                	mv	s6,s3
      state = 0;
 8b6:	4981                	li	s3,0
 8b8:	b54d                	j	75a <vprintf+0x60>
    }
  }
}
 8ba:	70e6                	ld	ra,120(sp)
 8bc:	7446                	ld	s0,112(sp)
 8be:	74a6                	ld	s1,104(sp)
 8c0:	7906                	ld	s2,96(sp)
 8c2:	69e6                	ld	s3,88(sp)
 8c4:	6a46                	ld	s4,80(sp)
 8c6:	6aa6                	ld	s5,72(sp)
 8c8:	6b06                	ld	s6,64(sp)
 8ca:	7be2                	ld	s7,56(sp)
 8cc:	7c42                	ld	s8,48(sp)
 8ce:	7ca2                	ld	s9,40(sp)
 8d0:	7d02                	ld	s10,32(sp)
 8d2:	6de2                	ld	s11,24(sp)
 8d4:	6109                	addi	sp,sp,128
 8d6:	8082                	ret

00000000000008d8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8d8:	715d                	addi	sp,sp,-80
 8da:	ec06                	sd	ra,24(sp)
 8dc:	e822                	sd	s0,16(sp)
 8de:	1000                	addi	s0,sp,32
 8e0:	e010                	sd	a2,0(s0)
 8e2:	e414                	sd	a3,8(s0)
 8e4:	e818                	sd	a4,16(s0)
 8e6:	ec1c                	sd	a5,24(s0)
 8e8:	03043023          	sd	a6,32(s0)
 8ec:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8f0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8f4:	8622                	mv	a2,s0
 8f6:	00000097          	auipc	ra,0x0
 8fa:	e04080e7          	jalr	-508(ra) # 6fa <vprintf>
}
 8fe:	60e2                	ld	ra,24(sp)
 900:	6442                	ld	s0,16(sp)
 902:	6161                	addi	sp,sp,80
 904:	8082                	ret

0000000000000906 <printf>:

void
printf(const char *fmt, ...)
{
 906:	711d                	addi	sp,sp,-96
 908:	ec06                	sd	ra,24(sp)
 90a:	e822                	sd	s0,16(sp)
 90c:	1000                	addi	s0,sp,32
 90e:	e40c                	sd	a1,8(s0)
 910:	e810                	sd	a2,16(s0)
 912:	ec14                	sd	a3,24(s0)
 914:	f018                	sd	a4,32(s0)
 916:	f41c                	sd	a5,40(s0)
 918:	03043823          	sd	a6,48(s0)
 91c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 920:	00840613          	addi	a2,s0,8
 924:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 928:	85aa                	mv	a1,a0
 92a:	4505                	li	a0,1
 92c:	00000097          	auipc	ra,0x0
 930:	dce080e7          	jalr	-562(ra) # 6fa <vprintf>
}
 934:	60e2                	ld	ra,24(sp)
 936:	6442                	ld	s0,16(sp)
 938:	6125                	addi	sp,sp,96
 93a:	8082                	ret

000000000000093c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 93c:	1141                	addi	sp,sp,-16
 93e:	e422                	sd	s0,8(sp)
 940:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 942:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 946:	00000797          	auipc	a5,0x0
 94a:	1f27b783          	ld	a5,498(a5) # b38 <freep>
 94e:	a805                	j	97e <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 950:	4618                	lw	a4,8(a2)
 952:	9db9                	addw	a1,a1,a4
 954:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 958:	6398                	ld	a4,0(a5)
 95a:	6318                	ld	a4,0(a4)
 95c:	fee53823          	sd	a4,-16(a0)
 960:	a091                	j	9a4 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 962:	ff852703          	lw	a4,-8(a0)
 966:	9e39                	addw	a2,a2,a4
 968:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 96a:	ff053703          	ld	a4,-16(a0)
 96e:	e398                	sd	a4,0(a5)
 970:	a099                	j	9b6 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 972:	6398                	ld	a4,0(a5)
 974:	00e7e463          	bltu	a5,a4,97c <free+0x40>
 978:	00e6ea63          	bltu	a3,a4,98c <free+0x50>
{
 97c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 97e:	fed7fae3          	bgeu	a5,a3,972 <free+0x36>
 982:	6398                	ld	a4,0(a5)
 984:	00e6e463          	bltu	a3,a4,98c <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 988:	fee7eae3          	bltu	a5,a4,97c <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 98c:	ff852583          	lw	a1,-8(a0)
 990:	6390                	ld	a2,0(a5)
 992:	02059713          	slli	a4,a1,0x20
 996:	9301                	srli	a4,a4,0x20
 998:	0712                	slli	a4,a4,0x4
 99a:	9736                	add	a4,a4,a3
 99c:	fae60ae3          	beq	a2,a4,950 <free+0x14>
    bp->s.ptr = p->s.ptr;
 9a0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9a4:	4790                	lw	a2,8(a5)
 9a6:	02061713          	slli	a4,a2,0x20
 9aa:	9301                	srli	a4,a4,0x20
 9ac:	0712                	slli	a4,a4,0x4
 9ae:	973e                	add	a4,a4,a5
 9b0:	fae689e3          	beq	a3,a4,962 <free+0x26>
  } else
    p->s.ptr = bp;
 9b4:	e394                	sd	a3,0(a5)
  freep = p;
 9b6:	00000717          	auipc	a4,0x0
 9ba:	18f73123          	sd	a5,386(a4) # b38 <freep>
}
 9be:	6422                	ld	s0,8(sp)
 9c0:	0141                	addi	sp,sp,16
 9c2:	8082                	ret

00000000000009c4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9c4:	7139                	addi	sp,sp,-64
 9c6:	fc06                	sd	ra,56(sp)
 9c8:	f822                	sd	s0,48(sp)
 9ca:	f426                	sd	s1,40(sp)
 9cc:	f04a                	sd	s2,32(sp)
 9ce:	ec4e                	sd	s3,24(sp)
 9d0:	e852                	sd	s4,16(sp)
 9d2:	e456                	sd	s5,8(sp)
 9d4:	e05a                	sd	s6,0(sp)
 9d6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9d8:	02051493          	slli	s1,a0,0x20
 9dc:	9081                	srli	s1,s1,0x20
 9de:	04bd                	addi	s1,s1,15
 9e0:	8091                	srli	s1,s1,0x4
 9e2:	0014899b          	addiw	s3,s1,1
 9e6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9e8:	00000517          	auipc	a0,0x0
 9ec:	15053503          	ld	a0,336(a0) # b38 <freep>
 9f0:	c515                	beqz	a0,a1c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9f2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9f4:	4798                	lw	a4,8(a5)
 9f6:	02977f63          	bgeu	a4,s1,a34 <malloc+0x70>
 9fa:	8a4e                	mv	s4,s3
 9fc:	0009871b          	sext.w	a4,s3
 a00:	6685                	lui	a3,0x1
 a02:	00d77363          	bgeu	a4,a3,a08 <malloc+0x44>
 a06:	6a05                	lui	s4,0x1
 a08:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a0c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a10:	00000917          	auipc	s2,0x0
 a14:	12890913          	addi	s2,s2,296 # b38 <freep>
  if(p == (char*)-1)
 a18:	5afd                	li	s5,-1
 a1a:	a88d                	j	a8c <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 a1c:	00000797          	auipc	a5,0x0
 a20:	13478793          	addi	a5,a5,308 # b50 <base>
 a24:	00000717          	auipc	a4,0x0
 a28:	10f73a23          	sd	a5,276(a4) # b38 <freep>
 a2c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a2e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a32:	b7e1                	j	9fa <malloc+0x36>
      if(p->s.size == nunits)
 a34:	02e48b63          	beq	s1,a4,a6a <malloc+0xa6>
        p->s.size -= nunits;
 a38:	4137073b          	subw	a4,a4,s3
 a3c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a3e:	1702                	slli	a4,a4,0x20
 a40:	9301                	srli	a4,a4,0x20
 a42:	0712                	slli	a4,a4,0x4
 a44:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a46:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a4a:	00000717          	auipc	a4,0x0
 a4e:	0ea73723          	sd	a0,238(a4) # b38 <freep>
      return (void*)(p + 1);
 a52:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a56:	70e2                	ld	ra,56(sp)
 a58:	7442                	ld	s0,48(sp)
 a5a:	74a2                	ld	s1,40(sp)
 a5c:	7902                	ld	s2,32(sp)
 a5e:	69e2                	ld	s3,24(sp)
 a60:	6a42                	ld	s4,16(sp)
 a62:	6aa2                	ld	s5,8(sp)
 a64:	6b02                	ld	s6,0(sp)
 a66:	6121                	addi	sp,sp,64
 a68:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a6a:	6398                	ld	a4,0(a5)
 a6c:	e118                	sd	a4,0(a0)
 a6e:	bff1                	j	a4a <malloc+0x86>
  hp->s.size = nu;
 a70:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a74:	0541                	addi	a0,a0,16
 a76:	00000097          	auipc	ra,0x0
 a7a:	ec6080e7          	jalr	-314(ra) # 93c <free>
  return freep;
 a7e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a82:	d971                	beqz	a0,a56 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a84:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a86:	4798                	lw	a4,8(a5)
 a88:	fa9776e3          	bgeu	a4,s1,a34 <malloc+0x70>
    if(p == freep)
 a8c:	00093703          	ld	a4,0(s2)
 a90:	853e                	mv	a0,a5
 a92:	fef719e3          	bne	a4,a5,a84 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 a96:	8552                	mv	a0,s4
 a98:	00000097          	auipc	ra,0x0
 a9c:	b7e080e7          	jalr	-1154(ra) # 616 <sbrk>
  if(p == (char*)-1)
 aa0:	fd5518e3          	bne	a0,s5,a70 <malloc+0xac>
        return 0;
 aa4:	4501                	li	a0,0
 aa6:	bf45                	j	a56 <malloc+0x92>
