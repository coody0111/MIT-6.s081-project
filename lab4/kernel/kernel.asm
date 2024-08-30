
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0001e117          	auipc	sp,0x1e
    80000004:	14010113          	addi	sp,sp,320 # 8001e140 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	792050ef          	jal	ra,800057a8 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00026797          	auipc	a5,0x26
    80000034:	21078793          	addi	a5,a5,528 # 80026240 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	130080e7          	jalr	304(ra) # 80000178 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	19e080e7          	jalr	414(ra) # 800061f8 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	23e080e7          	jalr	574(ra) # 800062ac <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	bce080e7          	jalr	-1074(ra) # 80005c58 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	94aa                	add	s1,s1,a0
    800000aa:	757d                	lui	a0,0xfffff
    800000ac:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ae:	94be                	add	s1,s1,a5
    800000b0:	0095ee63          	bltu	a1,s1,800000cc <freerange+0x3a>
    800000b4:	892e                	mv	s2,a1
    kfree(p);
    800000b6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b8:	6985                	lui	s3,0x1
    kfree(p);
    800000ba:	01448533          	add	a0,s1,s4
    800000be:	00000097          	auipc	ra,0x0
    800000c2:	f5e080e7          	jalr	-162(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c6:	94ce                	add	s1,s1,s3
    800000c8:	fe9979e3          	bgeu	s2,s1,800000ba <freerange+0x28>
}
    800000cc:	70a2                	ld	ra,40(sp)
    800000ce:	7402                	ld	s0,32(sp)
    800000d0:	64e2                	ld	s1,24(sp)
    800000d2:	6942                	ld	s2,16(sp)
    800000d4:	69a2                	ld	s3,8(sp)
    800000d6:	6a02                	ld	s4,0(sp)
    800000d8:	6145                	addi	sp,sp,48
    800000da:	8082                	ret

00000000800000dc <kinit>:
{
    800000dc:	1141                	addi	sp,sp,-16
    800000de:	e406                	sd	ra,8(sp)
    800000e0:	e022                	sd	s0,0(sp)
    800000e2:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e4:	00008597          	auipc	a1,0x8
    800000e8:	f3458593          	addi	a1,a1,-204 # 80008018 <etext+0x18>
    800000ec:	00009517          	auipc	a0,0x9
    800000f0:	f4450513          	addi	a0,a0,-188 # 80009030 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	074080e7          	jalr	116(ra) # 80006168 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00026517          	auipc	a0,0x26
    80000104:	14050513          	addi	a0,a0,320 # 80026240 <end>
    80000108:	00000097          	auipc	ra,0x0
    8000010c:	f8a080e7          	jalr	-118(ra) # 80000092 <freerange>
}
    80000110:	60a2                	ld	ra,8(sp)
    80000112:	6402                	ld	s0,0(sp)
    80000114:	0141                	addi	sp,sp,16
    80000116:	8082                	ret

0000000080000118 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000118:	1101                	addi	sp,sp,-32
    8000011a:	ec06                	sd	ra,24(sp)
    8000011c:	e822                	sd	s0,16(sp)
    8000011e:	e426                	sd	s1,8(sp)
    80000120:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000122:	00009497          	auipc	s1,0x9
    80000126:	f0e48493          	addi	s1,s1,-242 # 80009030 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	0cc080e7          	jalr	204(ra) # 800061f8 <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	ef650513          	addi	a0,a0,-266 # 80009030 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	168080e7          	jalr	360(ra) # 800062ac <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	026080e7          	jalr	38(ra) # 80000178 <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	00009517          	auipc	a0,0x9
    8000016a:	eca50513          	addi	a0,a0,-310 # 80009030 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	13e080e7          	jalr	318(ra) # 800062ac <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000178:	1141                	addi	sp,sp,-16
    8000017a:	e422                	sd	s0,8(sp)
    8000017c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000017e:	ce09                	beqz	a2,80000198 <memset+0x20>
    80000180:	87aa                	mv	a5,a0
    80000182:	fff6071b          	addiw	a4,a2,-1
    80000186:	1702                	slli	a4,a4,0x20
    80000188:	9301                	srli	a4,a4,0x20
    8000018a:	0705                	addi	a4,a4,1
    8000018c:	972a                	add	a4,a4,a0
    cdst[i] = c;
    8000018e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000192:	0785                	addi	a5,a5,1
    80000194:	fee79de3          	bne	a5,a4,8000018e <memset+0x16>
  }
  return dst;
}
    80000198:	6422                	ld	s0,8(sp)
    8000019a:	0141                	addi	sp,sp,16
    8000019c:	8082                	ret

000000008000019e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019e:	1141                	addi	sp,sp,-16
    800001a0:	e422                	sd	s0,8(sp)
    800001a2:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a4:	ca05                	beqz	a2,800001d4 <memcmp+0x36>
    800001a6:	fff6069b          	addiw	a3,a2,-1
    800001aa:	1682                	slli	a3,a3,0x20
    800001ac:	9281                	srli	a3,a3,0x20
    800001ae:	0685                	addi	a3,a3,1
    800001b0:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b2:	00054783          	lbu	a5,0(a0)
    800001b6:	0005c703          	lbu	a4,0(a1)
    800001ba:	00e79863          	bne	a5,a4,800001ca <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001be:	0505                	addi	a0,a0,1
    800001c0:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c2:	fed518e3          	bne	a0,a3,800001b2 <memcmp+0x14>
  }

  return 0;
    800001c6:	4501                	li	a0,0
    800001c8:	a019                	j	800001ce <memcmp+0x30>
      return *s1 - *s2;
    800001ca:	40e7853b          	subw	a0,a5,a4
}
    800001ce:	6422                	ld	s0,8(sp)
    800001d0:	0141                	addi	sp,sp,16
    800001d2:	8082                	ret
  return 0;
    800001d4:	4501                	li	a0,0
    800001d6:	bfe5                	j	800001ce <memcmp+0x30>

00000000800001d8 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d8:	1141                	addi	sp,sp,-16
    800001da:	e422                	sd	s0,8(sp)
    800001dc:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001de:	ca0d                	beqz	a2,80000210 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001e0:	00a5f963          	bgeu	a1,a0,800001f2 <memmove+0x1a>
    800001e4:	02061693          	slli	a3,a2,0x20
    800001e8:	9281                	srli	a3,a3,0x20
    800001ea:	00d58733          	add	a4,a1,a3
    800001ee:	02e56463          	bltu	a0,a4,80000216 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001f2:	fff6079b          	addiw	a5,a2,-1
    800001f6:	1782                	slli	a5,a5,0x20
    800001f8:	9381                	srli	a5,a5,0x20
    800001fa:	0785                	addi	a5,a5,1
    800001fc:	97ae                	add	a5,a5,a1
    800001fe:	872a                	mv	a4,a0
      *d++ = *s++;
    80000200:	0585                	addi	a1,a1,1
    80000202:	0705                	addi	a4,a4,1
    80000204:	fff5c683          	lbu	a3,-1(a1)
    80000208:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000020c:	fef59ae3          	bne	a1,a5,80000200 <memmove+0x28>

  return dst;
}
    80000210:	6422                	ld	s0,8(sp)
    80000212:	0141                	addi	sp,sp,16
    80000214:	8082                	ret
    d += n;
    80000216:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000218:	fff6079b          	addiw	a5,a2,-1
    8000021c:	1782                	slli	a5,a5,0x20
    8000021e:	9381                	srli	a5,a5,0x20
    80000220:	fff7c793          	not	a5,a5
    80000224:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000226:	177d                	addi	a4,a4,-1
    80000228:	16fd                	addi	a3,a3,-1
    8000022a:	00074603          	lbu	a2,0(a4)
    8000022e:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000232:	fef71ae3          	bne	a4,a5,80000226 <memmove+0x4e>
    80000236:	bfe9                	j	80000210 <memmove+0x38>

0000000080000238 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000238:	1141                	addi	sp,sp,-16
    8000023a:	e406                	sd	ra,8(sp)
    8000023c:	e022                	sd	s0,0(sp)
    8000023e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000240:	00000097          	auipc	ra,0x0
    80000244:	f98080e7          	jalr	-104(ra) # 800001d8 <memmove>
}
    80000248:	60a2                	ld	ra,8(sp)
    8000024a:	6402                	ld	s0,0(sp)
    8000024c:	0141                	addi	sp,sp,16
    8000024e:	8082                	ret

0000000080000250 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000250:	1141                	addi	sp,sp,-16
    80000252:	e422                	sd	s0,8(sp)
    80000254:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000256:	ce11                	beqz	a2,80000272 <strncmp+0x22>
    80000258:	00054783          	lbu	a5,0(a0)
    8000025c:	cf89                	beqz	a5,80000276 <strncmp+0x26>
    8000025e:	0005c703          	lbu	a4,0(a1)
    80000262:	00f71a63          	bne	a4,a5,80000276 <strncmp+0x26>
    n--, p++, q++;
    80000266:	367d                	addiw	a2,a2,-1
    80000268:	0505                	addi	a0,a0,1
    8000026a:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000026c:	f675                	bnez	a2,80000258 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000026e:	4501                	li	a0,0
    80000270:	a809                	j	80000282 <strncmp+0x32>
    80000272:	4501                	li	a0,0
    80000274:	a039                	j	80000282 <strncmp+0x32>
  if(n == 0)
    80000276:	ca09                	beqz	a2,80000288 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000278:	00054503          	lbu	a0,0(a0)
    8000027c:	0005c783          	lbu	a5,0(a1)
    80000280:	9d1d                	subw	a0,a0,a5
}
    80000282:	6422                	ld	s0,8(sp)
    80000284:	0141                	addi	sp,sp,16
    80000286:	8082                	ret
    return 0;
    80000288:	4501                	li	a0,0
    8000028a:	bfe5                	j	80000282 <strncmp+0x32>

000000008000028c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000028c:	1141                	addi	sp,sp,-16
    8000028e:	e422                	sd	s0,8(sp)
    80000290:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000292:	872a                	mv	a4,a0
    80000294:	8832                	mv	a6,a2
    80000296:	367d                	addiw	a2,a2,-1
    80000298:	01005963          	blez	a6,800002aa <strncpy+0x1e>
    8000029c:	0705                	addi	a4,a4,1
    8000029e:	0005c783          	lbu	a5,0(a1)
    800002a2:	fef70fa3          	sb	a5,-1(a4)
    800002a6:	0585                	addi	a1,a1,1
    800002a8:	f7f5                	bnez	a5,80000294 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002aa:	00c05d63          	blez	a2,800002c4 <strncpy+0x38>
    800002ae:	86ba                	mv	a3,a4
    *s++ = 0;
    800002b0:	0685                	addi	a3,a3,1
    800002b2:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002b6:	fff6c793          	not	a5,a3
    800002ba:	9fb9                	addw	a5,a5,a4
    800002bc:	010787bb          	addw	a5,a5,a6
    800002c0:	fef048e3          	bgtz	a5,800002b0 <strncpy+0x24>
  return os;
}
    800002c4:	6422                	ld	s0,8(sp)
    800002c6:	0141                	addi	sp,sp,16
    800002c8:	8082                	ret

00000000800002ca <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002ca:	1141                	addi	sp,sp,-16
    800002cc:	e422                	sd	s0,8(sp)
    800002ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002d0:	02c05363          	blez	a2,800002f6 <safestrcpy+0x2c>
    800002d4:	fff6069b          	addiw	a3,a2,-1
    800002d8:	1682                	slli	a3,a3,0x20
    800002da:	9281                	srli	a3,a3,0x20
    800002dc:	96ae                	add	a3,a3,a1
    800002de:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002e0:	00d58963          	beq	a1,a3,800002f2 <safestrcpy+0x28>
    800002e4:	0585                	addi	a1,a1,1
    800002e6:	0785                	addi	a5,a5,1
    800002e8:	fff5c703          	lbu	a4,-1(a1)
    800002ec:	fee78fa3          	sb	a4,-1(a5)
    800002f0:	fb65                	bnez	a4,800002e0 <safestrcpy+0x16>
    ;
  *s = 0;
    800002f2:	00078023          	sb	zero,0(a5)
  return os;
}
    800002f6:	6422                	ld	s0,8(sp)
    800002f8:	0141                	addi	sp,sp,16
    800002fa:	8082                	ret

00000000800002fc <strlen>:

int
strlen(const char *s)
{
    800002fc:	1141                	addi	sp,sp,-16
    800002fe:	e422                	sd	s0,8(sp)
    80000300:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000302:	00054783          	lbu	a5,0(a0)
    80000306:	cf91                	beqz	a5,80000322 <strlen+0x26>
    80000308:	0505                	addi	a0,a0,1
    8000030a:	87aa                	mv	a5,a0
    8000030c:	4685                	li	a3,1
    8000030e:	9e89                	subw	a3,a3,a0
    80000310:	00f6853b          	addw	a0,a3,a5
    80000314:	0785                	addi	a5,a5,1
    80000316:	fff7c703          	lbu	a4,-1(a5)
    8000031a:	fb7d                	bnez	a4,80000310 <strlen+0x14>
    ;
  return n;
}
    8000031c:	6422                	ld	s0,8(sp)
    8000031e:	0141                	addi	sp,sp,16
    80000320:	8082                	ret
  for(n = 0; s[n]; n++)
    80000322:	4501                	li	a0,0
    80000324:	bfe5                	j	8000031c <strlen+0x20>

0000000080000326 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000326:	1141                	addi	sp,sp,-16
    80000328:	e406                	sd	ra,8(sp)
    8000032a:	e022                	sd	s0,0(sp)
    8000032c:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000032e:	00001097          	auipc	ra,0x1
    80000332:	aee080e7          	jalr	-1298(ra) # 80000e1c <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000336:	00009717          	auipc	a4,0x9
    8000033a:	cca70713          	addi	a4,a4,-822 # 80009000 <started>
  if(cpuid() == 0){
    8000033e:	c139                	beqz	a0,80000384 <main+0x5e>
    while(started == 0)
    80000340:	431c                	lw	a5,0(a4)
    80000342:	2781                	sext.w	a5,a5
    80000344:	dff5                	beqz	a5,80000340 <main+0x1a>
      ;
    __sync_synchronize();
    80000346:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000034a:	00001097          	auipc	ra,0x1
    8000034e:	ad2080e7          	jalr	-1326(ra) # 80000e1c <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	946080e7          	jalr	-1722(ra) # 80005ca2 <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00001097          	auipc	ra,0x1
    80000370:	764080e7          	jalr	1892(ra) # 80001ad0 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	dbc080e7          	jalr	-580(ra) # 80005130 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	012080e7          	jalr	18(ra) # 8000138e <scheduler>
    consoleinit();
    80000384:	00005097          	auipc	ra,0x5
    80000388:	7e6080e7          	jalr	2022(ra) # 80005b6a <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	afc080e7          	jalr	-1284(ra) # 80005e88 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	906080e7          	jalr	-1786(ra) # 80005ca2 <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	8f6080e7          	jalr	-1802(ra) # 80005ca2 <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	8e6080e7          	jalr	-1818(ra) # 80005ca2 <printf>
    kinit();         // physical page allocator
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	d18080e7          	jalr	-744(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	322080e7          	jalr	802(ra) # 800006ee <kvminit>
    kvminithart();   // turn on paging
    800003d4:	00000097          	auipc	ra,0x0
    800003d8:	068080e7          	jalr	104(ra) # 8000043c <kvminithart>
    procinit();      // process table
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	990080e7          	jalr	-1648(ra) # 80000d6c <procinit>
    trapinit();      // trap vectors
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	6c4080e7          	jalr	1732(ra) # 80001aa8 <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00001097          	auipc	ra,0x1
    800003f0:	6e4080e7          	jalr	1764(ra) # 80001ad0 <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	d26080e7          	jalr	-730(ra) # 8000511a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	d34080e7          	jalr	-716(ra) # 80005130 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	f0c080e7          	jalr	-244(ra) # 80002310 <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	59c080e7          	jalr	1436(ra) # 800029a8 <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	546080e7          	jalr	1350(ra) # 8000395a <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	e36080e7          	jalr	-458(ra) # 80005252 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	d38080e7          	jalr	-712(ra) # 8000115c <userinit>
    __sync_synchronize();
    8000042c:	0ff0000f          	fence
    started = 1;
    80000430:	4785                	li	a5,1
    80000432:	00009717          	auipc	a4,0x9
    80000436:	bcf72723          	sw	a5,-1074(a4) # 80009000 <started>
    8000043a:	b789                	j	8000037c <main+0x56>

000000008000043c <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000043c:	1141                	addi	sp,sp,-16
    8000043e:	e422                	sd	s0,8(sp)
    80000440:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000442:	00009797          	auipc	a5,0x9
    80000446:	bc67b783          	ld	a5,-1082(a5) # 80009008 <kernel_pagetable>
    8000044a:	83b1                	srli	a5,a5,0xc
    8000044c:	577d                	li	a4,-1
    8000044e:	177e                	slli	a4,a4,0x3f
    80000450:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r"(x));
    80000452:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000456:	12000073          	sfence.vma
  sfence_vma();
}
    8000045a:	6422                	ld	s0,8(sp)
    8000045c:	0141                	addi	sp,sp,16
    8000045e:	8082                	ret

0000000080000460 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000460:	7139                	addi	sp,sp,-64
    80000462:	fc06                	sd	ra,56(sp)
    80000464:	f822                	sd	s0,48(sp)
    80000466:	f426                	sd	s1,40(sp)
    80000468:	f04a                	sd	s2,32(sp)
    8000046a:	ec4e                	sd	s3,24(sp)
    8000046c:	e852                	sd	s4,16(sp)
    8000046e:	e456                	sd	s5,8(sp)
    80000470:	e05a                	sd	s6,0(sp)
    80000472:	0080                	addi	s0,sp,64
    80000474:	84aa                	mv	s1,a0
    80000476:	89ae                	mv	s3,a1
    80000478:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000047a:	57fd                	li	a5,-1
    8000047c:	83e9                	srli	a5,a5,0x1a
    8000047e:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000480:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000482:	04b7f263          	bgeu	a5,a1,800004c6 <walk+0x66>
    panic("walk");
    80000486:	00008517          	auipc	a0,0x8
    8000048a:	bca50513          	addi	a0,a0,-1078 # 80008050 <etext+0x50>
    8000048e:	00005097          	auipc	ra,0x5
    80000492:	7ca080e7          	jalr	1994(ra) # 80005c58 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000496:	060a8663          	beqz	s5,80000502 <walk+0xa2>
    8000049a:	00000097          	auipc	ra,0x0
    8000049e:	c7e080e7          	jalr	-898(ra) # 80000118 <kalloc>
    800004a2:	84aa                	mv	s1,a0
    800004a4:	c529                	beqz	a0,800004ee <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004a6:	6605                	lui	a2,0x1
    800004a8:	4581                	li	a1,0
    800004aa:	00000097          	auipc	ra,0x0
    800004ae:	cce080e7          	jalr	-818(ra) # 80000178 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004b2:	00c4d793          	srli	a5,s1,0xc
    800004b6:	07aa                	slli	a5,a5,0xa
    800004b8:	0017e793          	ori	a5,a5,1
    800004bc:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004c0:	3a5d                	addiw	s4,s4,-9
    800004c2:	036a0063          	beq	s4,s6,800004e2 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c6:	0149d933          	srl	s2,s3,s4
    800004ca:	1ff97913          	andi	s2,s2,511
    800004ce:	090e                	slli	s2,s2,0x3
    800004d0:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004d2:	00093483          	ld	s1,0(s2)
    800004d6:	0014f793          	andi	a5,s1,1
    800004da:	dfd5                	beqz	a5,80000496 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004dc:	80a9                	srli	s1,s1,0xa
    800004de:	04b2                	slli	s1,s1,0xc
    800004e0:	b7c5                	j	800004c0 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004e2:	00c9d513          	srli	a0,s3,0xc
    800004e6:	1ff57513          	andi	a0,a0,511
    800004ea:	050e                	slli	a0,a0,0x3
    800004ec:	9526                	add	a0,a0,s1
}
    800004ee:	70e2                	ld	ra,56(sp)
    800004f0:	7442                	ld	s0,48(sp)
    800004f2:	74a2                	ld	s1,40(sp)
    800004f4:	7902                	ld	s2,32(sp)
    800004f6:	69e2                	ld	s3,24(sp)
    800004f8:	6a42                	ld	s4,16(sp)
    800004fa:	6aa2                	ld	s5,8(sp)
    800004fc:	6b02                	ld	s6,0(sp)
    800004fe:	6121                	addi	sp,sp,64
    80000500:	8082                	ret
        return 0;
    80000502:	4501                	li	a0,0
    80000504:	b7ed                	j	800004ee <walk+0x8e>

0000000080000506 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000506:	57fd                	li	a5,-1
    80000508:	83e9                	srli	a5,a5,0x1a
    8000050a:	00b7f463          	bgeu	a5,a1,80000512 <walkaddr+0xc>
    return 0;
    8000050e:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000510:	8082                	ret
{
    80000512:	1141                	addi	sp,sp,-16
    80000514:	e406                	sd	ra,8(sp)
    80000516:	e022                	sd	s0,0(sp)
    80000518:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000051a:	4601                	li	a2,0
    8000051c:	00000097          	auipc	ra,0x0
    80000520:	f44080e7          	jalr	-188(ra) # 80000460 <walk>
  if(pte == 0)
    80000524:	c105                	beqz	a0,80000544 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000526:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000528:	0117f693          	andi	a3,a5,17
    8000052c:	4745                	li	a4,17
    return 0;
    8000052e:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000530:	00e68663          	beq	a3,a4,8000053c <walkaddr+0x36>
}
    80000534:	60a2                	ld	ra,8(sp)
    80000536:	6402                	ld	s0,0(sp)
    80000538:	0141                	addi	sp,sp,16
    8000053a:	8082                	ret
  pa = PTE2PA(*pte);
    8000053c:	00a7d513          	srli	a0,a5,0xa
    80000540:	0532                	slli	a0,a0,0xc
  return pa;
    80000542:	bfcd                	j	80000534 <walkaddr+0x2e>
    return 0;
    80000544:	4501                	li	a0,0
    80000546:	b7fd                	j	80000534 <walkaddr+0x2e>

0000000080000548 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000548:	715d                	addi	sp,sp,-80
    8000054a:	e486                	sd	ra,72(sp)
    8000054c:	e0a2                	sd	s0,64(sp)
    8000054e:	fc26                	sd	s1,56(sp)
    80000550:	f84a                	sd	s2,48(sp)
    80000552:	f44e                	sd	s3,40(sp)
    80000554:	f052                	sd	s4,32(sp)
    80000556:	ec56                	sd	s5,24(sp)
    80000558:	e85a                	sd	s6,16(sp)
    8000055a:	e45e                	sd	s7,8(sp)
    8000055c:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000055e:	c205                	beqz	a2,8000057e <mappages+0x36>
    80000560:	8aaa                	mv	s5,a0
    80000562:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000564:	77fd                	lui	a5,0xfffff
    80000566:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    8000056a:	15fd                	addi	a1,a1,-1
    8000056c:	00c589b3          	add	s3,a1,a2
    80000570:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    80000574:	8952                	mv	s2,s4
    80000576:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000057a:	6b85                	lui	s7,0x1
    8000057c:	a015                	j	800005a0 <mappages+0x58>
    panic("mappages: size");
    8000057e:	00008517          	auipc	a0,0x8
    80000582:	ada50513          	addi	a0,a0,-1318 # 80008058 <etext+0x58>
    80000586:	00005097          	auipc	ra,0x5
    8000058a:	6d2080e7          	jalr	1746(ra) # 80005c58 <panic>
      panic("mappages: remap");
    8000058e:	00008517          	auipc	a0,0x8
    80000592:	ada50513          	addi	a0,a0,-1318 # 80008068 <etext+0x68>
    80000596:	00005097          	auipc	ra,0x5
    8000059a:	6c2080e7          	jalr	1730(ra) # 80005c58 <panic>
    a += PGSIZE;
    8000059e:	995e                	add	s2,s2,s7
  for(;;){
    800005a0:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a4:	4605                	li	a2,1
    800005a6:	85ca                	mv	a1,s2
    800005a8:	8556                	mv	a0,s5
    800005aa:	00000097          	auipc	ra,0x0
    800005ae:	eb6080e7          	jalr	-330(ra) # 80000460 <walk>
    800005b2:	cd19                	beqz	a0,800005d0 <mappages+0x88>
    if(*pte & PTE_V)
    800005b4:	611c                	ld	a5,0(a0)
    800005b6:	8b85                	andi	a5,a5,1
    800005b8:	fbf9                	bnez	a5,8000058e <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005ba:	80b1                	srli	s1,s1,0xc
    800005bc:	04aa                	slli	s1,s1,0xa
    800005be:	0164e4b3          	or	s1,s1,s6
    800005c2:	0014e493          	ori	s1,s1,1
    800005c6:	e104                	sd	s1,0(a0)
    if(a == last)
    800005c8:	fd391be3          	bne	s2,s3,8000059e <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    800005cc:	4501                	li	a0,0
    800005ce:	a011                	j	800005d2 <mappages+0x8a>
      return -1;
    800005d0:	557d                	li	a0,-1
}
    800005d2:	60a6                	ld	ra,72(sp)
    800005d4:	6406                	ld	s0,64(sp)
    800005d6:	74e2                	ld	s1,56(sp)
    800005d8:	7942                	ld	s2,48(sp)
    800005da:	79a2                	ld	s3,40(sp)
    800005dc:	7a02                	ld	s4,32(sp)
    800005de:	6ae2                	ld	s5,24(sp)
    800005e0:	6b42                	ld	s6,16(sp)
    800005e2:	6ba2                	ld	s7,8(sp)
    800005e4:	6161                	addi	sp,sp,80
    800005e6:	8082                	ret

00000000800005e8 <kvmmap>:
{
    800005e8:	1141                	addi	sp,sp,-16
    800005ea:	e406                	sd	ra,8(sp)
    800005ec:	e022                	sd	s0,0(sp)
    800005ee:	0800                	addi	s0,sp,16
    800005f0:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005f2:	86b2                	mv	a3,a2
    800005f4:	863e                	mv	a2,a5
    800005f6:	00000097          	auipc	ra,0x0
    800005fa:	f52080e7          	jalr	-174(ra) # 80000548 <mappages>
    800005fe:	e509                	bnez	a0,80000608 <kvmmap+0x20>
}
    80000600:	60a2                	ld	ra,8(sp)
    80000602:	6402                	ld	s0,0(sp)
    80000604:	0141                	addi	sp,sp,16
    80000606:	8082                	ret
    panic("kvmmap");
    80000608:	00008517          	auipc	a0,0x8
    8000060c:	a7050513          	addi	a0,a0,-1424 # 80008078 <etext+0x78>
    80000610:	00005097          	auipc	ra,0x5
    80000614:	648080e7          	jalr	1608(ra) # 80005c58 <panic>

0000000080000618 <kvmmake>:
{
    80000618:	1101                	addi	sp,sp,-32
    8000061a:	ec06                	sd	ra,24(sp)
    8000061c:	e822                	sd	s0,16(sp)
    8000061e:	e426                	sd	s1,8(sp)
    80000620:	e04a                	sd	s2,0(sp)
    80000622:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000624:	00000097          	auipc	ra,0x0
    80000628:	af4080e7          	jalr	-1292(ra) # 80000118 <kalloc>
    8000062c:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000062e:	6605                	lui	a2,0x1
    80000630:	4581                	li	a1,0
    80000632:	00000097          	auipc	ra,0x0
    80000636:	b46080e7          	jalr	-1210(ra) # 80000178 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000063a:	4719                	li	a4,6
    8000063c:	6685                	lui	a3,0x1
    8000063e:	10000637          	lui	a2,0x10000
    80000642:	100005b7          	lui	a1,0x10000
    80000646:	8526                	mv	a0,s1
    80000648:	00000097          	auipc	ra,0x0
    8000064c:	fa0080e7          	jalr	-96(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000650:	4719                	li	a4,6
    80000652:	6685                	lui	a3,0x1
    80000654:	10001637          	lui	a2,0x10001
    80000658:	100015b7          	lui	a1,0x10001
    8000065c:	8526                	mv	a0,s1
    8000065e:	00000097          	auipc	ra,0x0
    80000662:	f8a080e7          	jalr	-118(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000666:	4719                	li	a4,6
    80000668:	004006b7          	lui	a3,0x400
    8000066c:	0c000637          	lui	a2,0xc000
    80000670:	0c0005b7          	lui	a1,0xc000
    80000674:	8526                	mv	a0,s1
    80000676:	00000097          	auipc	ra,0x0
    8000067a:	f72080e7          	jalr	-142(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000067e:	00008917          	auipc	s2,0x8
    80000682:	98290913          	addi	s2,s2,-1662 # 80008000 <etext>
    80000686:	4729                	li	a4,10
    80000688:	80008697          	auipc	a3,0x80008
    8000068c:	97868693          	addi	a3,a3,-1672 # 8000 <_entry-0x7fff8000>
    80000690:	4605                	li	a2,1
    80000692:	067e                	slli	a2,a2,0x1f
    80000694:	85b2                	mv	a1,a2
    80000696:	8526                	mv	a0,s1
    80000698:	00000097          	auipc	ra,0x0
    8000069c:	f50080e7          	jalr	-176(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006a0:	4719                	li	a4,6
    800006a2:	46c5                	li	a3,17
    800006a4:	06ee                	slli	a3,a3,0x1b
    800006a6:	412686b3          	sub	a3,a3,s2
    800006aa:	864a                	mv	a2,s2
    800006ac:	85ca                	mv	a1,s2
    800006ae:	8526                	mv	a0,s1
    800006b0:	00000097          	auipc	ra,0x0
    800006b4:	f38080e7          	jalr	-200(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b8:	4729                	li	a4,10
    800006ba:	6685                	lui	a3,0x1
    800006bc:	00007617          	auipc	a2,0x7
    800006c0:	94460613          	addi	a2,a2,-1724 # 80007000 <_trampoline>
    800006c4:	040005b7          	lui	a1,0x4000
    800006c8:	15fd                	addi	a1,a1,-1
    800006ca:	05b2                	slli	a1,a1,0xc
    800006cc:	8526                	mv	a0,s1
    800006ce:	00000097          	auipc	ra,0x0
    800006d2:	f1a080e7          	jalr	-230(ra) # 800005e8 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006d6:	8526                	mv	a0,s1
    800006d8:	00000097          	auipc	ra,0x0
    800006dc:	5fe080e7          	jalr	1534(ra) # 80000cd6 <proc_mapstacks>
}
    800006e0:	8526                	mv	a0,s1
    800006e2:	60e2                	ld	ra,24(sp)
    800006e4:	6442                	ld	s0,16(sp)
    800006e6:	64a2                	ld	s1,8(sp)
    800006e8:	6902                	ld	s2,0(sp)
    800006ea:	6105                	addi	sp,sp,32
    800006ec:	8082                	ret

00000000800006ee <kvminit>:
{
    800006ee:	1141                	addi	sp,sp,-16
    800006f0:	e406                	sd	ra,8(sp)
    800006f2:	e022                	sd	s0,0(sp)
    800006f4:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006f6:	00000097          	auipc	ra,0x0
    800006fa:	f22080e7          	jalr	-222(ra) # 80000618 <kvmmake>
    800006fe:	00009797          	auipc	a5,0x9
    80000702:	90a7b523          	sd	a0,-1782(a5) # 80009008 <kernel_pagetable>
}
    80000706:	60a2                	ld	ra,8(sp)
    80000708:	6402                	ld	s0,0(sp)
    8000070a:	0141                	addi	sp,sp,16
    8000070c:	8082                	ret

000000008000070e <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000070e:	715d                	addi	sp,sp,-80
    80000710:	e486                	sd	ra,72(sp)
    80000712:	e0a2                	sd	s0,64(sp)
    80000714:	fc26                	sd	s1,56(sp)
    80000716:	f84a                	sd	s2,48(sp)
    80000718:	f44e                	sd	s3,40(sp)
    8000071a:	f052                	sd	s4,32(sp)
    8000071c:	ec56                	sd	s5,24(sp)
    8000071e:	e85a                	sd	s6,16(sp)
    80000720:	e45e                	sd	s7,8(sp)
    80000722:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000724:	03459793          	slli	a5,a1,0x34
    80000728:	e795                	bnez	a5,80000754 <uvmunmap+0x46>
    8000072a:	8a2a                	mv	s4,a0
    8000072c:	892e                	mv	s2,a1
    8000072e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000730:	0632                	slli	a2,a2,0xc
    80000732:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000736:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000738:	6b05                	lui	s6,0x1
    8000073a:	0735e863          	bltu	a1,s3,800007aa <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000073e:	60a6                	ld	ra,72(sp)
    80000740:	6406                	ld	s0,64(sp)
    80000742:	74e2                	ld	s1,56(sp)
    80000744:	7942                	ld	s2,48(sp)
    80000746:	79a2                	ld	s3,40(sp)
    80000748:	7a02                	ld	s4,32(sp)
    8000074a:	6ae2                	ld	s5,24(sp)
    8000074c:	6b42                	ld	s6,16(sp)
    8000074e:	6ba2                	ld	s7,8(sp)
    80000750:	6161                	addi	sp,sp,80
    80000752:	8082                	ret
    panic("uvmunmap: not aligned");
    80000754:	00008517          	auipc	a0,0x8
    80000758:	92c50513          	addi	a0,a0,-1748 # 80008080 <etext+0x80>
    8000075c:	00005097          	auipc	ra,0x5
    80000760:	4fc080e7          	jalr	1276(ra) # 80005c58 <panic>
      panic("uvmunmap: walk");
    80000764:	00008517          	auipc	a0,0x8
    80000768:	93450513          	addi	a0,a0,-1740 # 80008098 <etext+0x98>
    8000076c:	00005097          	auipc	ra,0x5
    80000770:	4ec080e7          	jalr	1260(ra) # 80005c58 <panic>
      panic("uvmunmap: not mapped");
    80000774:	00008517          	auipc	a0,0x8
    80000778:	93450513          	addi	a0,a0,-1740 # 800080a8 <etext+0xa8>
    8000077c:	00005097          	auipc	ra,0x5
    80000780:	4dc080e7          	jalr	1244(ra) # 80005c58 <panic>
      panic("uvmunmap: not a leaf");
    80000784:	00008517          	auipc	a0,0x8
    80000788:	93c50513          	addi	a0,a0,-1732 # 800080c0 <etext+0xc0>
    8000078c:	00005097          	auipc	ra,0x5
    80000790:	4cc080e7          	jalr	1228(ra) # 80005c58 <panic>
      uint64 pa = PTE2PA(*pte);
    80000794:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80000796:	0532                	slli	a0,a0,0xc
    80000798:	00000097          	auipc	ra,0x0
    8000079c:	884080e7          	jalr	-1916(ra) # 8000001c <kfree>
    *pte = 0;
    800007a0:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007a4:	995a                	add	s2,s2,s6
    800007a6:	f9397ce3          	bgeu	s2,s3,8000073e <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007aa:	4601                	li	a2,0
    800007ac:	85ca                	mv	a1,s2
    800007ae:	8552                	mv	a0,s4
    800007b0:	00000097          	auipc	ra,0x0
    800007b4:	cb0080e7          	jalr	-848(ra) # 80000460 <walk>
    800007b8:	84aa                	mv	s1,a0
    800007ba:	d54d                	beqz	a0,80000764 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007bc:	6108                	ld	a0,0(a0)
    800007be:	00157793          	andi	a5,a0,1
    800007c2:	dbcd                	beqz	a5,80000774 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007c4:	3ff57793          	andi	a5,a0,1023
    800007c8:	fb778ee3          	beq	a5,s7,80000784 <uvmunmap+0x76>
    if(do_free){
    800007cc:	fc0a8ae3          	beqz	s5,800007a0 <uvmunmap+0x92>
    800007d0:	b7d1                	j	80000794 <uvmunmap+0x86>

00000000800007d2 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007d2:	1101                	addi	sp,sp,-32
    800007d4:	ec06                	sd	ra,24(sp)
    800007d6:	e822                	sd	s0,16(sp)
    800007d8:	e426                	sd	s1,8(sp)
    800007da:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007dc:	00000097          	auipc	ra,0x0
    800007e0:	93c080e7          	jalr	-1732(ra) # 80000118 <kalloc>
    800007e4:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007e6:	c519                	beqz	a0,800007f4 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007e8:	6605                	lui	a2,0x1
    800007ea:	4581                	li	a1,0
    800007ec:	00000097          	auipc	ra,0x0
    800007f0:	98c080e7          	jalr	-1652(ra) # 80000178 <memset>
  return pagetable;
}
    800007f4:	8526                	mv	a0,s1
    800007f6:	60e2                	ld	ra,24(sp)
    800007f8:	6442                	ld	s0,16(sp)
    800007fa:	64a2                	ld	s1,8(sp)
    800007fc:	6105                	addi	sp,sp,32
    800007fe:	8082                	ret

0000000080000800 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80000800:	7179                	addi	sp,sp,-48
    80000802:	f406                	sd	ra,40(sp)
    80000804:	f022                	sd	s0,32(sp)
    80000806:	ec26                	sd	s1,24(sp)
    80000808:	e84a                	sd	s2,16(sp)
    8000080a:	e44e                	sd	s3,8(sp)
    8000080c:	e052                	sd	s4,0(sp)
    8000080e:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000810:	6785                	lui	a5,0x1
    80000812:	04f67863          	bgeu	a2,a5,80000862 <uvminit+0x62>
    80000816:	8a2a                	mv	s4,a0
    80000818:	89ae                	mv	s3,a1
    8000081a:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000081c:	00000097          	auipc	ra,0x0
    80000820:	8fc080e7          	jalr	-1796(ra) # 80000118 <kalloc>
    80000824:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000826:	6605                	lui	a2,0x1
    80000828:	4581                	li	a1,0
    8000082a:	00000097          	auipc	ra,0x0
    8000082e:	94e080e7          	jalr	-1714(ra) # 80000178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000832:	4779                	li	a4,30
    80000834:	86ca                	mv	a3,s2
    80000836:	6605                	lui	a2,0x1
    80000838:	4581                	li	a1,0
    8000083a:	8552                	mv	a0,s4
    8000083c:	00000097          	auipc	ra,0x0
    80000840:	d0c080e7          	jalr	-756(ra) # 80000548 <mappages>
  memmove(mem, src, sz);
    80000844:	8626                	mv	a2,s1
    80000846:	85ce                	mv	a1,s3
    80000848:	854a                	mv	a0,s2
    8000084a:	00000097          	auipc	ra,0x0
    8000084e:	98e080e7          	jalr	-1650(ra) # 800001d8 <memmove>
}
    80000852:	70a2                	ld	ra,40(sp)
    80000854:	7402                	ld	s0,32(sp)
    80000856:	64e2                	ld	s1,24(sp)
    80000858:	6942                	ld	s2,16(sp)
    8000085a:	69a2                	ld	s3,8(sp)
    8000085c:	6a02                	ld	s4,0(sp)
    8000085e:	6145                	addi	sp,sp,48
    80000860:	8082                	ret
    panic("inituvm: more than a page");
    80000862:	00008517          	auipc	a0,0x8
    80000866:	87650513          	addi	a0,a0,-1930 # 800080d8 <etext+0xd8>
    8000086a:	00005097          	auipc	ra,0x5
    8000086e:	3ee080e7          	jalr	1006(ra) # 80005c58 <panic>

0000000080000872 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000872:	1101                	addi	sp,sp,-32
    80000874:	ec06                	sd	ra,24(sp)
    80000876:	e822                	sd	s0,16(sp)
    80000878:	e426                	sd	s1,8(sp)
    8000087a:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000087c:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000087e:	00b67d63          	bgeu	a2,a1,80000898 <uvmdealloc+0x26>
    80000882:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000884:	6785                	lui	a5,0x1
    80000886:	17fd                	addi	a5,a5,-1
    80000888:	00f60733          	add	a4,a2,a5
    8000088c:	767d                	lui	a2,0xfffff
    8000088e:	8f71                	and	a4,a4,a2
    80000890:	97ae                	add	a5,a5,a1
    80000892:	8ff1                	and	a5,a5,a2
    80000894:	00f76863          	bltu	a4,a5,800008a4 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000898:	8526                	mv	a0,s1
    8000089a:	60e2                	ld	ra,24(sp)
    8000089c:	6442                	ld	s0,16(sp)
    8000089e:	64a2                	ld	s1,8(sp)
    800008a0:	6105                	addi	sp,sp,32
    800008a2:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008a4:	8f99                	sub	a5,a5,a4
    800008a6:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008a8:	4685                	li	a3,1
    800008aa:	0007861b          	sext.w	a2,a5
    800008ae:	85ba                	mv	a1,a4
    800008b0:	00000097          	auipc	ra,0x0
    800008b4:	e5e080e7          	jalr	-418(ra) # 8000070e <uvmunmap>
    800008b8:	b7c5                	j	80000898 <uvmdealloc+0x26>

00000000800008ba <uvmalloc>:
  if(newsz < oldsz)
    800008ba:	0ab66163          	bltu	a2,a1,8000095c <uvmalloc+0xa2>
{
    800008be:	7139                	addi	sp,sp,-64
    800008c0:	fc06                	sd	ra,56(sp)
    800008c2:	f822                	sd	s0,48(sp)
    800008c4:	f426                	sd	s1,40(sp)
    800008c6:	f04a                	sd	s2,32(sp)
    800008c8:	ec4e                	sd	s3,24(sp)
    800008ca:	e852                	sd	s4,16(sp)
    800008cc:	e456                	sd	s5,8(sp)
    800008ce:	0080                	addi	s0,sp,64
    800008d0:	8aaa                	mv	s5,a0
    800008d2:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008d4:	6985                	lui	s3,0x1
    800008d6:	19fd                	addi	s3,s3,-1
    800008d8:	95ce                	add	a1,a1,s3
    800008da:	79fd                	lui	s3,0xfffff
    800008dc:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008e0:	08c9f063          	bgeu	s3,a2,80000960 <uvmalloc+0xa6>
    800008e4:	894e                	mv	s2,s3
    mem = kalloc();
    800008e6:	00000097          	auipc	ra,0x0
    800008ea:	832080e7          	jalr	-1998(ra) # 80000118 <kalloc>
    800008ee:	84aa                	mv	s1,a0
    if(mem == 0){
    800008f0:	c51d                	beqz	a0,8000091e <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800008f2:	6605                	lui	a2,0x1
    800008f4:	4581                	li	a1,0
    800008f6:	00000097          	auipc	ra,0x0
    800008fa:	882080e7          	jalr	-1918(ra) # 80000178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800008fe:	4779                	li	a4,30
    80000900:	86a6                	mv	a3,s1
    80000902:	6605                	lui	a2,0x1
    80000904:	85ca                	mv	a1,s2
    80000906:	8556                	mv	a0,s5
    80000908:	00000097          	auipc	ra,0x0
    8000090c:	c40080e7          	jalr	-960(ra) # 80000548 <mappages>
    80000910:	e905                	bnez	a0,80000940 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000912:	6785                	lui	a5,0x1
    80000914:	993e                	add	s2,s2,a5
    80000916:	fd4968e3          	bltu	s2,s4,800008e6 <uvmalloc+0x2c>
  return newsz;
    8000091a:	8552                	mv	a0,s4
    8000091c:	a809                	j	8000092e <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    8000091e:	864e                	mv	a2,s3
    80000920:	85ca                	mv	a1,s2
    80000922:	8556                	mv	a0,s5
    80000924:	00000097          	auipc	ra,0x0
    80000928:	f4e080e7          	jalr	-178(ra) # 80000872 <uvmdealloc>
      return 0;
    8000092c:	4501                	li	a0,0
}
    8000092e:	70e2                	ld	ra,56(sp)
    80000930:	7442                	ld	s0,48(sp)
    80000932:	74a2                	ld	s1,40(sp)
    80000934:	7902                	ld	s2,32(sp)
    80000936:	69e2                	ld	s3,24(sp)
    80000938:	6a42                	ld	s4,16(sp)
    8000093a:	6aa2                	ld	s5,8(sp)
    8000093c:	6121                	addi	sp,sp,64
    8000093e:	8082                	ret
      kfree(mem);
    80000940:	8526                	mv	a0,s1
    80000942:	fffff097          	auipc	ra,0xfffff
    80000946:	6da080e7          	jalr	1754(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000094a:	864e                	mv	a2,s3
    8000094c:	85ca                	mv	a1,s2
    8000094e:	8556                	mv	a0,s5
    80000950:	00000097          	auipc	ra,0x0
    80000954:	f22080e7          	jalr	-222(ra) # 80000872 <uvmdealloc>
      return 0;
    80000958:	4501                	li	a0,0
    8000095a:	bfd1                	j	8000092e <uvmalloc+0x74>
    return oldsz;
    8000095c:	852e                	mv	a0,a1
}
    8000095e:	8082                	ret
  return newsz;
    80000960:	8532                	mv	a0,a2
    80000962:	b7f1                	j	8000092e <uvmalloc+0x74>

0000000080000964 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000964:	7179                	addi	sp,sp,-48
    80000966:	f406                	sd	ra,40(sp)
    80000968:	f022                	sd	s0,32(sp)
    8000096a:	ec26                	sd	s1,24(sp)
    8000096c:	e84a                	sd	s2,16(sp)
    8000096e:	e44e                	sd	s3,8(sp)
    80000970:	e052                	sd	s4,0(sp)
    80000972:	1800                	addi	s0,sp,48
    80000974:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000976:	84aa                	mv	s1,a0
    80000978:	6905                	lui	s2,0x1
    8000097a:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000097c:	4985                	li	s3,1
    8000097e:	a821                	j	80000996 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000980:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000982:	0532                	slli	a0,a0,0xc
    80000984:	00000097          	auipc	ra,0x0
    80000988:	fe0080e7          	jalr	-32(ra) # 80000964 <freewalk>
      pagetable[i] = 0;
    8000098c:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000990:	04a1                	addi	s1,s1,8
    80000992:	03248163          	beq	s1,s2,800009b4 <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000996:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000998:	00f57793          	andi	a5,a0,15
    8000099c:	ff3782e3          	beq	a5,s3,80000980 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009a0:	8905                	andi	a0,a0,1
    800009a2:	d57d                	beqz	a0,80000990 <freewalk+0x2c>
      panic("freewalk: leaf");
    800009a4:	00007517          	auipc	a0,0x7
    800009a8:	75450513          	addi	a0,a0,1876 # 800080f8 <etext+0xf8>
    800009ac:	00005097          	auipc	ra,0x5
    800009b0:	2ac080e7          	jalr	684(ra) # 80005c58 <panic>
    }
  }
  kfree((void*)pagetable);
    800009b4:	8552                	mv	a0,s4
    800009b6:	fffff097          	auipc	ra,0xfffff
    800009ba:	666080e7          	jalr	1638(ra) # 8000001c <kfree>
}
    800009be:	70a2                	ld	ra,40(sp)
    800009c0:	7402                	ld	s0,32(sp)
    800009c2:	64e2                	ld	s1,24(sp)
    800009c4:	6942                	ld	s2,16(sp)
    800009c6:	69a2                	ld	s3,8(sp)
    800009c8:	6a02                	ld	s4,0(sp)
    800009ca:	6145                	addi	sp,sp,48
    800009cc:	8082                	ret

00000000800009ce <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009ce:	1101                	addi	sp,sp,-32
    800009d0:	ec06                	sd	ra,24(sp)
    800009d2:	e822                	sd	s0,16(sp)
    800009d4:	e426                	sd	s1,8(sp)
    800009d6:	1000                	addi	s0,sp,32
    800009d8:	84aa                	mv	s1,a0
  if(sz > 0)
    800009da:	e999                	bnez	a1,800009f0 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009dc:	8526                	mv	a0,s1
    800009de:	00000097          	auipc	ra,0x0
    800009e2:	f86080e7          	jalr	-122(ra) # 80000964 <freewalk>
}
    800009e6:	60e2                	ld	ra,24(sp)
    800009e8:	6442                	ld	s0,16(sp)
    800009ea:	64a2                	ld	s1,8(sp)
    800009ec:	6105                	addi	sp,sp,32
    800009ee:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009f0:	6605                	lui	a2,0x1
    800009f2:	167d                	addi	a2,a2,-1
    800009f4:	962e                	add	a2,a2,a1
    800009f6:	4685                	li	a3,1
    800009f8:	8231                	srli	a2,a2,0xc
    800009fa:	4581                	li	a1,0
    800009fc:	00000097          	auipc	ra,0x0
    80000a00:	d12080e7          	jalr	-750(ra) # 8000070e <uvmunmap>
    80000a04:	bfe1                	j	800009dc <uvmfree+0xe>

0000000080000a06 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a06:	c679                	beqz	a2,80000ad4 <uvmcopy+0xce>
{
    80000a08:	715d                	addi	sp,sp,-80
    80000a0a:	e486                	sd	ra,72(sp)
    80000a0c:	e0a2                	sd	s0,64(sp)
    80000a0e:	fc26                	sd	s1,56(sp)
    80000a10:	f84a                	sd	s2,48(sp)
    80000a12:	f44e                	sd	s3,40(sp)
    80000a14:	f052                	sd	s4,32(sp)
    80000a16:	ec56                	sd	s5,24(sp)
    80000a18:	e85a                	sd	s6,16(sp)
    80000a1a:	e45e                	sd	s7,8(sp)
    80000a1c:	0880                	addi	s0,sp,80
    80000a1e:	8b2a                	mv	s6,a0
    80000a20:	8aae                	mv	s5,a1
    80000a22:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a24:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a26:	4601                	li	a2,0
    80000a28:	85ce                	mv	a1,s3
    80000a2a:	855a                	mv	a0,s6
    80000a2c:	00000097          	auipc	ra,0x0
    80000a30:	a34080e7          	jalr	-1484(ra) # 80000460 <walk>
    80000a34:	c531                	beqz	a0,80000a80 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a36:	6118                	ld	a4,0(a0)
    80000a38:	00177793          	andi	a5,a4,1
    80000a3c:	cbb1                	beqz	a5,80000a90 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a3e:	00a75593          	srli	a1,a4,0xa
    80000a42:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a46:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a4a:	fffff097          	auipc	ra,0xfffff
    80000a4e:	6ce080e7          	jalr	1742(ra) # 80000118 <kalloc>
    80000a52:	892a                	mv	s2,a0
    80000a54:	c939                	beqz	a0,80000aaa <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a56:	6605                	lui	a2,0x1
    80000a58:	85de                	mv	a1,s7
    80000a5a:	fffff097          	auipc	ra,0xfffff
    80000a5e:	77e080e7          	jalr	1918(ra) # 800001d8 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a62:	8726                	mv	a4,s1
    80000a64:	86ca                	mv	a3,s2
    80000a66:	6605                	lui	a2,0x1
    80000a68:	85ce                	mv	a1,s3
    80000a6a:	8556                	mv	a0,s5
    80000a6c:	00000097          	auipc	ra,0x0
    80000a70:	adc080e7          	jalr	-1316(ra) # 80000548 <mappages>
    80000a74:	e515                	bnez	a0,80000aa0 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a76:	6785                	lui	a5,0x1
    80000a78:	99be                	add	s3,s3,a5
    80000a7a:	fb49e6e3          	bltu	s3,s4,80000a26 <uvmcopy+0x20>
    80000a7e:	a081                	j	80000abe <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a80:	00007517          	auipc	a0,0x7
    80000a84:	68850513          	addi	a0,a0,1672 # 80008108 <etext+0x108>
    80000a88:	00005097          	auipc	ra,0x5
    80000a8c:	1d0080e7          	jalr	464(ra) # 80005c58 <panic>
      panic("uvmcopy: page not present");
    80000a90:	00007517          	auipc	a0,0x7
    80000a94:	69850513          	addi	a0,a0,1688 # 80008128 <etext+0x128>
    80000a98:	00005097          	auipc	ra,0x5
    80000a9c:	1c0080e7          	jalr	448(ra) # 80005c58 <panic>
      kfree(mem);
    80000aa0:	854a                	mv	a0,s2
    80000aa2:	fffff097          	auipc	ra,0xfffff
    80000aa6:	57a080e7          	jalr	1402(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000aaa:	4685                	li	a3,1
    80000aac:	00c9d613          	srli	a2,s3,0xc
    80000ab0:	4581                	li	a1,0
    80000ab2:	8556                	mv	a0,s5
    80000ab4:	00000097          	auipc	ra,0x0
    80000ab8:	c5a080e7          	jalr	-934(ra) # 8000070e <uvmunmap>
  return -1;
    80000abc:	557d                	li	a0,-1
}
    80000abe:	60a6                	ld	ra,72(sp)
    80000ac0:	6406                	ld	s0,64(sp)
    80000ac2:	74e2                	ld	s1,56(sp)
    80000ac4:	7942                	ld	s2,48(sp)
    80000ac6:	79a2                	ld	s3,40(sp)
    80000ac8:	7a02                	ld	s4,32(sp)
    80000aca:	6ae2                	ld	s5,24(sp)
    80000acc:	6b42                	ld	s6,16(sp)
    80000ace:	6ba2                	ld	s7,8(sp)
    80000ad0:	6161                	addi	sp,sp,80
    80000ad2:	8082                	ret
  return 0;
    80000ad4:	4501                	li	a0,0
}
    80000ad6:	8082                	ret

0000000080000ad8 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ad8:	1141                	addi	sp,sp,-16
    80000ada:	e406                	sd	ra,8(sp)
    80000adc:	e022                	sd	s0,0(sp)
    80000ade:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ae0:	4601                	li	a2,0
    80000ae2:	00000097          	auipc	ra,0x0
    80000ae6:	97e080e7          	jalr	-1666(ra) # 80000460 <walk>
  if(pte == 0)
    80000aea:	c901                	beqz	a0,80000afa <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000aec:	611c                	ld	a5,0(a0)
    80000aee:	9bbd                	andi	a5,a5,-17
    80000af0:	e11c                	sd	a5,0(a0)
}
    80000af2:	60a2                	ld	ra,8(sp)
    80000af4:	6402                	ld	s0,0(sp)
    80000af6:	0141                	addi	sp,sp,16
    80000af8:	8082                	ret
    panic("uvmclear");
    80000afa:	00007517          	auipc	a0,0x7
    80000afe:	64e50513          	addi	a0,a0,1614 # 80008148 <etext+0x148>
    80000b02:	00005097          	auipc	ra,0x5
    80000b06:	156080e7          	jalr	342(ra) # 80005c58 <panic>

0000000080000b0a <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b0a:	c6bd                	beqz	a3,80000b78 <copyout+0x6e>
{
    80000b0c:	715d                	addi	sp,sp,-80
    80000b0e:	e486                	sd	ra,72(sp)
    80000b10:	e0a2                	sd	s0,64(sp)
    80000b12:	fc26                	sd	s1,56(sp)
    80000b14:	f84a                	sd	s2,48(sp)
    80000b16:	f44e                	sd	s3,40(sp)
    80000b18:	f052                	sd	s4,32(sp)
    80000b1a:	ec56                	sd	s5,24(sp)
    80000b1c:	e85a                	sd	s6,16(sp)
    80000b1e:	e45e                	sd	s7,8(sp)
    80000b20:	e062                	sd	s8,0(sp)
    80000b22:	0880                	addi	s0,sp,80
    80000b24:	8b2a                	mv	s6,a0
    80000b26:	8c2e                	mv	s8,a1
    80000b28:	8a32                	mv	s4,a2
    80000b2a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b2c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b2e:	6a85                	lui	s5,0x1
    80000b30:	a015                	j	80000b54 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b32:	9562                	add	a0,a0,s8
    80000b34:	0004861b          	sext.w	a2,s1
    80000b38:	85d2                	mv	a1,s4
    80000b3a:	41250533          	sub	a0,a0,s2
    80000b3e:	fffff097          	auipc	ra,0xfffff
    80000b42:	69a080e7          	jalr	1690(ra) # 800001d8 <memmove>

    len -= n;
    80000b46:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b4a:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b4c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b50:	02098263          	beqz	s3,80000b74 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b54:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b58:	85ca                	mv	a1,s2
    80000b5a:	855a                	mv	a0,s6
    80000b5c:	00000097          	auipc	ra,0x0
    80000b60:	9aa080e7          	jalr	-1622(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000b64:	cd01                	beqz	a0,80000b7c <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b66:	418904b3          	sub	s1,s2,s8
    80000b6a:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b6c:	fc99f3e3          	bgeu	s3,s1,80000b32 <copyout+0x28>
    80000b70:	84ce                	mv	s1,s3
    80000b72:	b7c1                	j	80000b32 <copyout+0x28>
  }
  return 0;
    80000b74:	4501                	li	a0,0
    80000b76:	a021                	j	80000b7e <copyout+0x74>
    80000b78:	4501                	li	a0,0
}
    80000b7a:	8082                	ret
      return -1;
    80000b7c:	557d                	li	a0,-1
}
    80000b7e:	60a6                	ld	ra,72(sp)
    80000b80:	6406                	ld	s0,64(sp)
    80000b82:	74e2                	ld	s1,56(sp)
    80000b84:	7942                	ld	s2,48(sp)
    80000b86:	79a2                	ld	s3,40(sp)
    80000b88:	7a02                	ld	s4,32(sp)
    80000b8a:	6ae2                	ld	s5,24(sp)
    80000b8c:	6b42                	ld	s6,16(sp)
    80000b8e:	6ba2                	ld	s7,8(sp)
    80000b90:	6c02                	ld	s8,0(sp)
    80000b92:	6161                	addi	sp,sp,80
    80000b94:	8082                	ret

0000000080000b96 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b96:	c6bd                	beqz	a3,80000c04 <copyin+0x6e>
{
    80000b98:	715d                	addi	sp,sp,-80
    80000b9a:	e486                	sd	ra,72(sp)
    80000b9c:	e0a2                	sd	s0,64(sp)
    80000b9e:	fc26                	sd	s1,56(sp)
    80000ba0:	f84a                	sd	s2,48(sp)
    80000ba2:	f44e                	sd	s3,40(sp)
    80000ba4:	f052                	sd	s4,32(sp)
    80000ba6:	ec56                	sd	s5,24(sp)
    80000ba8:	e85a                	sd	s6,16(sp)
    80000baa:	e45e                	sd	s7,8(sp)
    80000bac:	e062                	sd	s8,0(sp)
    80000bae:	0880                	addi	s0,sp,80
    80000bb0:	8b2a                	mv	s6,a0
    80000bb2:	8a2e                	mv	s4,a1
    80000bb4:	8c32                	mv	s8,a2
    80000bb6:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bb8:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bba:	6a85                	lui	s5,0x1
    80000bbc:	a015                	j	80000be0 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bbe:	9562                	add	a0,a0,s8
    80000bc0:	0004861b          	sext.w	a2,s1
    80000bc4:	412505b3          	sub	a1,a0,s2
    80000bc8:	8552                	mv	a0,s4
    80000bca:	fffff097          	auipc	ra,0xfffff
    80000bce:	60e080e7          	jalr	1550(ra) # 800001d8 <memmove>

    len -= n;
    80000bd2:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bd6:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bd8:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bdc:	02098263          	beqz	s3,80000c00 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000be0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000be4:	85ca                	mv	a1,s2
    80000be6:	855a                	mv	a0,s6
    80000be8:	00000097          	auipc	ra,0x0
    80000bec:	91e080e7          	jalr	-1762(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000bf0:	cd01                	beqz	a0,80000c08 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000bf2:	418904b3          	sub	s1,s2,s8
    80000bf6:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bf8:	fc99f3e3          	bgeu	s3,s1,80000bbe <copyin+0x28>
    80000bfc:	84ce                	mv	s1,s3
    80000bfe:	b7c1                	j	80000bbe <copyin+0x28>
  }
  return 0;
    80000c00:	4501                	li	a0,0
    80000c02:	a021                	j	80000c0a <copyin+0x74>
    80000c04:	4501                	li	a0,0
}
    80000c06:	8082                	ret
      return -1;
    80000c08:	557d                	li	a0,-1
}
    80000c0a:	60a6                	ld	ra,72(sp)
    80000c0c:	6406                	ld	s0,64(sp)
    80000c0e:	74e2                	ld	s1,56(sp)
    80000c10:	7942                	ld	s2,48(sp)
    80000c12:	79a2                	ld	s3,40(sp)
    80000c14:	7a02                	ld	s4,32(sp)
    80000c16:	6ae2                	ld	s5,24(sp)
    80000c18:	6b42                	ld	s6,16(sp)
    80000c1a:	6ba2                	ld	s7,8(sp)
    80000c1c:	6c02                	ld	s8,0(sp)
    80000c1e:	6161                	addi	sp,sp,80
    80000c20:	8082                	ret

0000000080000c22 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c22:	c6c5                	beqz	a3,80000cca <copyinstr+0xa8>
{
    80000c24:	715d                	addi	sp,sp,-80
    80000c26:	e486                	sd	ra,72(sp)
    80000c28:	e0a2                	sd	s0,64(sp)
    80000c2a:	fc26                	sd	s1,56(sp)
    80000c2c:	f84a                	sd	s2,48(sp)
    80000c2e:	f44e                	sd	s3,40(sp)
    80000c30:	f052                	sd	s4,32(sp)
    80000c32:	ec56                	sd	s5,24(sp)
    80000c34:	e85a                	sd	s6,16(sp)
    80000c36:	e45e                	sd	s7,8(sp)
    80000c38:	0880                	addi	s0,sp,80
    80000c3a:	8a2a                	mv	s4,a0
    80000c3c:	8b2e                	mv	s6,a1
    80000c3e:	8bb2                	mv	s7,a2
    80000c40:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c42:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c44:	6985                	lui	s3,0x1
    80000c46:	a035                	j	80000c72 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c48:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c4c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c4e:	0017b793          	seqz	a5,a5
    80000c52:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c56:	60a6                	ld	ra,72(sp)
    80000c58:	6406                	ld	s0,64(sp)
    80000c5a:	74e2                	ld	s1,56(sp)
    80000c5c:	7942                	ld	s2,48(sp)
    80000c5e:	79a2                	ld	s3,40(sp)
    80000c60:	7a02                	ld	s4,32(sp)
    80000c62:	6ae2                	ld	s5,24(sp)
    80000c64:	6b42                	ld	s6,16(sp)
    80000c66:	6ba2                	ld	s7,8(sp)
    80000c68:	6161                	addi	sp,sp,80
    80000c6a:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c6c:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c70:	c8a9                	beqz	s1,80000cc2 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000c72:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c76:	85ca                	mv	a1,s2
    80000c78:	8552                	mv	a0,s4
    80000c7a:	00000097          	auipc	ra,0x0
    80000c7e:	88c080e7          	jalr	-1908(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000c82:	c131                	beqz	a0,80000cc6 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000c84:	41790833          	sub	a6,s2,s7
    80000c88:	984e                	add	a6,a6,s3
    if(n > max)
    80000c8a:	0104f363          	bgeu	s1,a6,80000c90 <copyinstr+0x6e>
    80000c8e:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c90:	955e                	add	a0,a0,s7
    80000c92:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c96:	fc080be3          	beqz	a6,80000c6c <copyinstr+0x4a>
    80000c9a:	985a                	add	a6,a6,s6
    80000c9c:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000c9e:	41650633          	sub	a2,a0,s6
    80000ca2:	14fd                	addi	s1,s1,-1
    80000ca4:	9b26                	add	s6,s6,s1
    80000ca6:	00f60733          	add	a4,a2,a5
    80000caa:	00074703          	lbu	a4,0(a4)
    80000cae:	df49                	beqz	a4,80000c48 <copyinstr+0x26>
        *dst = *p;
    80000cb0:	00e78023          	sb	a4,0(a5)
      --max;
    80000cb4:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000cb8:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cba:	ff0796e3          	bne	a5,a6,80000ca6 <copyinstr+0x84>
      dst++;
    80000cbe:	8b42                	mv	s6,a6
    80000cc0:	b775                	j	80000c6c <copyinstr+0x4a>
    80000cc2:	4781                	li	a5,0
    80000cc4:	b769                	j	80000c4e <copyinstr+0x2c>
      return -1;
    80000cc6:	557d                	li	a0,-1
    80000cc8:	b779                	j	80000c56 <copyinstr+0x34>
  int got_null = 0;
    80000cca:	4781                	li	a5,0
  if(got_null){
    80000ccc:	0017b793          	seqz	a5,a5
    80000cd0:	40f00533          	neg	a0,a5
}
    80000cd4:	8082                	ret

0000000080000cd6 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl)
{
    80000cd6:	7139                	addi	sp,sp,-64
    80000cd8:	fc06                	sd	ra,56(sp)
    80000cda:	f822                	sd	s0,48(sp)
    80000cdc:	f426                	sd	s1,40(sp)
    80000cde:	f04a                	sd	s2,32(sp)
    80000ce0:	ec4e                	sd	s3,24(sp)
    80000ce2:	e852                	sd	s4,16(sp)
    80000ce4:	e456                	sd	s5,8(sp)
    80000ce6:	e05a                	sd	s6,0(sp)
    80000ce8:	0080                	addi	s0,sp,64
    80000cea:	89aa                	mv	s3,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    80000cec:	00008497          	auipc	s1,0x8
    80000cf0:	79448493          	addi	s1,s1,1940 # 80009480 <proc>
  {
    char *pa = kalloc();
    if (pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    80000cf4:	8b26                	mv	s6,s1
    80000cf6:	00007a97          	auipc	s5,0x7
    80000cfa:	30aa8a93          	addi	s5,s5,778 # 80008000 <etext>
    80000cfe:	04000937          	lui	s2,0x4000
    80000d02:	197d                	addi	s2,s2,-1
    80000d04:	0932                	slli	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++)
    80000d06:	0000fa17          	auipc	s4,0xf
    80000d0a:	f7aa0a13          	addi	s4,s4,-134 # 8000fc80 <tickslock>
    char *pa = kalloc();
    80000d0e:	fffff097          	auipc	ra,0xfffff
    80000d12:	40a080e7          	jalr	1034(ra) # 80000118 <kalloc>
    80000d16:	862a                	mv	a2,a0
    if (pa == 0)
    80000d18:	c131                	beqz	a0,80000d5c <proc_mapstacks+0x86>
    uint64 va = KSTACK((int)(p - proc));
    80000d1a:	416485b3          	sub	a1,s1,s6
    80000d1e:	8595                	srai	a1,a1,0x5
    80000d20:	000ab783          	ld	a5,0(s5)
    80000d24:	02f585b3          	mul	a1,a1,a5
    80000d28:	2585                	addiw	a1,a1,1
    80000d2a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d2e:	4719                	li	a4,6
    80000d30:	6685                	lui	a3,0x1
    80000d32:	40b905b3          	sub	a1,s2,a1
    80000d36:	854e                	mv	a0,s3
    80000d38:	00000097          	auipc	ra,0x0
    80000d3c:	8b0080e7          	jalr	-1872(ra) # 800005e8 <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++)
    80000d40:	1a048493          	addi	s1,s1,416
    80000d44:	fd4495e3          	bne	s1,s4,80000d0e <proc_mapstacks+0x38>
  }
}
    80000d48:	70e2                	ld	ra,56(sp)
    80000d4a:	7442                	ld	s0,48(sp)
    80000d4c:	74a2                	ld	s1,40(sp)
    80000d4e:	7902                	ld	s2,32(sp)
    80000d50:	69e2                	ld	s3,24(sp)
    80000d52:	6a42                	ld	s4,16(sp)
    80000d54:	6aa2                	ld	s5,8(sp)
    80000d56:	6b02                	ld	s6,0(sp)
    80000d58:	6121                	addi	sp,sp,64
    80000d5a:	8082                	ret
      panic("kalloc");
    80000d5c:	00007517          	auipc	a0,0x7
    80000d60:	3fc50513          	addi	a0,a0,1020 # 80008158 <etext+0x158>
    80000d64:	00005097          	auipc	ra,0x5
    80000d68:	ef4080e7          	jalr	-268(ra) # 80005c58 <panic>

0000000080000d6c <procinit>:

// initialize the proc table at boot time.
void procinit(void)
{
    80000d6c:	7139                	addi	sp,sp,-64
    80000d6e:	fc06                	sd	ra,56(sp)
    80000d70:	f822                	sd	s0,48(sp)
    80000d72:	f426                	sd	s1,40(sp)
    80000d74:	f04a                	sd	s2,32(sp)
    80000d76:	ec4e                	sd	s3,24(sp)
    80000d78:	e852                	sd	s4,16(sp)
    80000d7a:	e456                	sd	s5,8(sp)
    80000d7c:	e05a                	sd	s6,0(sp)
    80000d7e:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    80000d80:	00007597          	auipc	a1,0x7
    80000d84:	3e058593          	addi	a1,a1,992 # 80008160 <etext+0x160>
    80000d88:	00008517          	auipc	a0,0x8
    80000d8c:	2c850513          	addi	a0,a0,712 # 80009050 <pid_lock>
    80000d90:	00005097          	auipc	ra,0x5
    80000d94:	3d8080e7          	jalr	984(ra) # 80006168 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d98:	00007597          	auipc	a1,0x7
    80000d9c:	3d058593          	addi	a1,a1,976 # 80008168 <etext+0x168>
    80000da0:	00008517          	auipc	a0,0x8
    80000da4:	2c850513          	addi	a0,a0,712 # 80009068 <wait_lock>
    80000da8:	00005097          	auipc	ra,0x5
    80000dac:	3c0080e7          	jalr	960(ra) # 80006168 <initlock>
  for (p = proc; p < &proc[NPROC]; p++)
    80000db0:	00008497          	auipc	s1,0x8
    80000db4:	6d048493          	addi	s1,s1,1744 # 80009480 <proc>
  {
    initlock(&p->lock, "proc");
    80000db8:	00007b17          	auipc	s6,0x7
    80000dbc:	3c0b0b13          	addi	s6,s6,960 # 80008178 <etext+0x178>
    p->kstack = KSTACK((int)(p - proc));
    80000dc0:	8aa6                	mv	s5,s1
    80000dc2:	00007a17          	auipc	s4,0x7
    80000dc6:	23ea0a13          	addi	s4,s4,574 # 80008000 <etext>
    80000dca:	04000937          	lui	s2,0x4000
    80000dce:	197d                	addi	s2,s2,-1
    80000dd0:	0932                	slli	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++)
    80000dd2:	0000f997          	auipc	s3,0xf
    80000dd6:	eae98993          	addi	s3,s3,-338 # 8000fc80 <tickslock>
    initlock(&p->lock, "proc");
    80000dda:	85da                	mv	a1,s6
    80000ddc:	8526                	mv	a0,s1
    80000dde:	00005097          	auipc	ra,0x5
    80000de2:	38a080e7          	jalr	906(ra) # 80006168 <initlock>
    p->kstack = KSTACK((int)(p - proc));
    80000de6:	415487b3          	sub	a5,s1,s5
    80000dea:	8795                	srai	a5,a5,0x5
    80000dec:	000a3703          	ld	a4,0(s4)
    80000df0:	02e787b3          	mul	a5,a5,a4
    80000df4:	2785                	addiw	a5,a5,1
    80000df6:	00d7979b          	slliw	a5,a5,0xd
    80000dfa:	40f907b3          	sub	a5,s2,a5
    80000dfe:	f4bc                	sd	a5,104(s1)
  for (p = proc; p < &proc[NPROC]; p++)
    80000e00:	1a048493          	addi	s1,s1,416
    80000e04:	fd349be3          	bne	s1,s3,80000dda <procinit+0x6e>
  }
}
    80000e08:	70e2                	ld	ra,56(sp)
    80000e0a:	7442                	ld	s0,48(sp)
    80000e0c:	74a2                	ld	s1,40(sp)
    80000e0e:	7902                	ld	s2,32(sp)
    80000e10:	69e2                	ld	s3,24(sp)
    80000e12:	6a42                	ld	s4,16(sp)
    80000e14:	6aa2                	ld	s5,8(sp)
    80000e16:	6b02                	ld	s6,0(sp)
    80000e18:	6121                	addi	sp,sp,64
    80000e1a:	8082                	ret

0000000080000e1c <cpuid>:

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid()
{
    80000e1c:	1141                	addi	sp,sp,-16
    80000e1e:	e422                	sd	s0,8(sp)
    80000e20:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r"(x));
    80000e22:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e24:	2501                	sext.w	a0,a0
    80000e26:	6422                	ld	s0,8(sp)
    80000e28:	0141                	addi	sp,sp,16
    80000e2a:	8082                	ret

0000000080000e2c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *
mycpu(void)
{
    80000e2c:	1141                	addi	sp,sp,-16
    80000e2e:	e422                	sd	s0,8(sp)
    80000e30:	0800                	addi	s0,sp,16
    80000e32:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e34:	2781                	sext.w	a5,a5
    80000e36:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e38:	00008517          	auipc	a0,0x8
    80000e3c:	24850513          	addi	a0,a0,584 # 80009080 <cpus>
    80000e40:	953e                	add	a0,a0,a5
    80000e42:	6422                	ld	s0,8(sp)
    80000e44:	0141                	addi	sp,sp,16
    80000e46:	8082                	ret

0000000080000e48 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *
myproc(void)
{
    80000e48:	1101                	addi	sp,sp,-32
    80000e4a:	ec06                	sd	ra,24(sp)
    80000e4c:	e822                	sd	s0,16(sp)
    80000e4e:	e426                	sd	s1,8(sp)
    80000e50:	1000                	addi	s0,sp,32
  push_off();
    80000e52:	00005097          	auipc	ra,0x5
    80000e56:	35a080e7          	jalr	858(ra) # 800061ac <push_off>
    80000e5a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e5c:	2781                	sext.w	a5,a5
    80000e5e:	079e                	slli	a5,a5,0x7
    80000e60:	00008717          	auipc	a4,0x8
    80000e64:	1f070713          	addi	a4,a4,496 # 80009050 <pid_lock>
    80000e68:	97ba                	add	a5,a5,a4
    80000e6a:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e6c:	00005097          	auipc	ra,0x5
    80000e70:	3e0080e7          	jalr	992(ra) # 8000624c <pop_off>
  return p;
}
    80000e74:	8526                	mv	a0,s1
    80000e76:	60e2                	ld	ra,24(sp)
    80000e78:	6442                	ld	s0,16(sp)
    80000e7a:	64a2                	ld	s1,8(sp)
    80000e7c:	6105                	addi	sp,sp,32
    80000e7e:	8082                	ret

0000000080000e80 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80000e80:	1141                	addi	sp,sp,-16
    80000e82:	e406                	sd	ra,8(sp)
    80000e84:	e022                	sd	s0,0(sp)
    80000e86:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e88:	00000097          	auipc	ra,0x0
    80000e8c:	fc0080e7          	jalr	-64(ra) # 80000e48 <myproc>
    80000e90:	00005097          	auipc	ra,0x5
    80000e94:	41c080e7          	jalr	1052(ra) # 800062ac <release>

  if (first)
    80000e98:	00008797          	auipc	a5,0x8
    80000e9c:	9a87a783          	lw	a5,-1624(a5) # 80008840 <first.1684>
    80000ea0:	eb89                	bnez	a5,80000eb2 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ea2:	00001097          	auipc	ra,0x1
    80000ea6:	c46080e7          	jalr	-954(ra) # 80001ae8 <usertrapret>
}
    80000eaa:	60a2                	ld	ra,8(sp)
    80000eac:	6402                	ld	s0,0(sp)
    80000eae:	0141                	addi	sp,sp,16
    80000eb0:	8082                	ret
    first = 0;
    80000eb2:	00008797          	auipc	a5,0x8
    80000eb6:	9807a723          	sw	zero,-1650(a5) # 80008840 <first.1684>
    fsinit(ROOTDEV);
    80000eba:	4505                	li	a0,1
    80000ebc:	00002097          	auipc	ra,0x2
    80000ec0:	a6c080e7          	jalr	-1428(ra) # 80002928 <fsinit>
    80000ec4:	bff9                	j	80000ea2 <forkret+0x22>

0000000080000ec6 <allocpid>:
{
    80000ec6:	1101                	addi	sp,sp,-32
    80000ec8:	ec06                	sd	ra,24(sp)
    80000eca:	e822                	sd	s0,16(sp)
    80000ecc:	e426                	sd	s1,8(sp)
    80000ece:	e04a                	sd	s2,0(sp)
    80000ed0:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ed2:	00008917          	auipc	s2,0x8
    80000ed6:	17e90913          	addi	s2,s2,382 # 80009050 <pid_lock>
    80000eda:	854a                	mv	a0,s2
    80000edc:	00005097          	auipc	ra,0x5
    80000ee0:	31c080e7          	jalr	796(ra) # 800061f8 <acquire>
  pid = nextpid;
    80000ee4:	00008797          	auipc	a5,0x8
    80000ee8:	96078793          	addi	a5,a5,-1696 # 80008844 <nextpid>
    80000eec:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000eee:	0014871b          	addiw	a4,s1,1
    80000ef2:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000ef4:	854a                	mv	a0,s2
    80000ef6:	00005097          	auipc	ra,0x5
    80000efa:	3b6080e7          	jalr	950(ra) # 800062ac <release>
}
    80000efe:	8526                	mv	a0,s1
    80000f00:	60e2                	ld	ra,24(sp)
    80000f02:	6442                	ld	s0,16(sp)
    80000f04:	64a2                	ld	s1,8(sp)
    80000f06:	6902                	ld	s2,0(sp)
    80000f08:	6105                	addi	sp,sp,32
    80000f0a:	8082                	ret

0000000080000f0c <proc_pagetable>:
{
    80000f0c:	1101                	addi	sp,sp,-32
    80000f0e:	ec06                	sd	ra,24(sp)
    80000f10:	e822                	sd	s0,16(sp)
    80000f12:	e426                	sd	s1,8(sp)
    80000f14:	e04a                	sd	s2,0(sp)
    80000f16:	1000                	addi	s0,sp,32
    80000f18:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f1a:	00000097          	auipc	ra,0x0
    80000f1e:	8b8080e7          	jalr	-1864(ra) # 800007d2 <uvmcreate>
    80000f22:	84aa                	mv	s1,a0
  if (pagetable == 0)
    80000f24:	c121                	beqz	a0,80000f64 <proc_pagetable+0x58>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f26:	4729                	li	a4,10
    80000f28:	00006697          	auipc	a3,0x6
    80000f2c:	0d868693          	addi	a3,a3,216 # 80007000 <_trampoline>
    80000f30:	6605                	lui	a2,0x1
    80000f32:	040005b7          	lui	a1,0x4000
    80000f36:	15fd                	addi	a1,a1,-1
    80000f38:	05b2                	slli	a1,a1,0xc
    80000f3a:	fffff097          	auipc	ra,0xfffff
    80000f3e:	60e080e7          	jalr	1550(ra) # 80000548 <mappages>
    80000f42:	02054863          	bltz	a0,80000f72 <proc_pagetable+0x66>
  if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f46:	4719                	li	a4,6
    80000f48:	08093683          	ld	a3,128(s2)
    80000f4c:	6605                	lui	a2,0x1
    80000f4e:	020005b7          	lui	a1,0x2000
    80000f52:	15fd                	addi	a1,a1,-1
    80000f54:	05b6                	slli	a1,a1,0xd
    80000f56:	8526                	mv	a0,s1
    80000f58:	fffff097          	auipc	ra,0xfffff
    80000f5c:	5f0080e7          	jalr	1520(ra) # 80000548 <mappages>
    80000f60:	02054163          	bltz	a0,80000f82 <proc_pagetable+0x76>
}
    80000f64:	8526                	mv	a0,s1
    80000f66:	60e2                	ld	ra,24(sp)
    80000f68:	6442                	ld	s0,16(sp)
    80000f6a:	64a2                	ld	s1,8(sp)
    80000f6c:	6902                	ld	s2,0(sp)
    80000f6e:	6105                	addi	sp,sp,32
    80000f70:	8082                	ret
    uvmfree(pagetable, 0);
    80000f72:	4581                	li	a1,0
    80000f74:	8526                	mv	a0,s1
    80000f76:	00000097          	auipc	ra,0x0
    80000f7a:	a58080e7          	jalr	-1448(ra) # 800009ce <uvmfree>
    return 0;
    80000f7e:	4481                	li	s1,0
    80000f80:	b7d5                	j	80000f64 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f82:	4681                	li	a3,0
    80000f84:	4605                	li	a2,1
    80000f86:	040005b7          	lui	a1,0x4000
    80000f8a:	15fd                	addi	a1,a1,-1
    80000f8c:	05b2                	slli	a1,a1,0xc
    80000f8e:	8526                	mv	a0,s1
    80000f90:	fffff097          	auipc	ra,0xfffff
    80000f94:	77e080e7          	jalr	1918(ra) # 8000070e <uvmunmap>
    uvmfree(pagetable, 0);
    80000f98:	4581                	li	a1,0
    80000f9a:	8526                	mv	a0,s1
    80000f9c:	00000097          	auipc	ra,0x0
    80000fa0:	a32080e7          	jalr	-1486(ra) # 800009ce <uvmfree>
    return 0;
    80000fa4:	4481                	li	s1,0
    80000fa6:	bf7d                	j	80000f64 <proc_pagetable+0x58>

0000000080000fa8 <proc_freepagetable>:
{
    80000fa8:	1101                	addi	sp,sp,-32
    80000faa:	ec06                	sd	ra,24(sp)
    80000fac:	e822                	sd	s0,16(sp)
    80000fae:	e426                	sd	s1,8(sp)
    80000fb0:	e04a                	sd	s2,0(sp)
    80000fb2:	1000                	addi	s0,sp,32
    80000fb4:	84aa                	mv	s1,a0
    80000fb6:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fb8:	4681                	li	a3,0
    80000fba:	4605                	li	a2,1
    80000fbc:	040005b7          	lui	a1,0x4000
    80000fc0:	15fd                	addi	a1,a1,-1
    80000fc2:	05b2                	slli	a1,a1,0xc
    80000fc4:	fffff097          	auipc	ra,0xfffff
    80000fc8:	74a080e7          	jalr	1866(ra) # 8000070e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fcc:	4681                	li	a3,0
    80000fce:	4605                	li	a2,1
    80000fd0:	020005b7          	lui	a1,0x2000
    80000fd4:	15fd                	addi	a1,a1,-1
    80000fd6:	05b6                	slli	a1,a1,0xd
    80000fd8:	8526                	mv	a0,s1
    80000fda:	fffff097          	auipc	ra,0xfffff
    80000fde:	734080e7          	jalr	1844(ra) # 8000070e <uvmunmap>
  uvmfree(pagetable, sz);
    80000fe2:	85ca                	mv	a1,s2
    80000fe4:	8526                	mv	a0,s1
    80000fe6:	00000097          	auipc	ra,0x0
    80000fea:	9e8080e7          	jalr	-1560(ra) # 800009ce <uvmfree>
}
    80000fee:	60e2                	ld	ra,24(sp)
    80000ff0:	6442                	ld	s0,16(sp)
    80000ff2:	64a2                	ld	s1,8(sp)
    80000ff4:	6902                	ld	s2,0(sp)
    80000ff6:	6105                	addi	sp,sp,32
    80000ff8:	8082                	ret

0000000080000ffa <freeproc>:
{
    80000ffa:	1101                	addi	sp,sp,-32
    80000ffc:	ec06                	sd	ra,24(sp)
    80000ffe:	e822                	sd	s0,16(sp)
    80001000:	e426                	sd	s1,8(sp)
    80001002:	1000                	addi	s0,sp,32
    80001004:	84aa                	mv	s1,a0
  if (p->trapframe)
    80001006:	6148                	ld	a0,128(a0)
    80001008:	c509                	beqz	a0,80001012 <freeproc+0x18>
    kfree((void *)p->trapframe);
    8000100a:	fffff097          	auipc	ra,0xfffff
    8000100e:	012080e7          	jalr	18(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001012:	0804b023          	sd	zero,128(s1)
  if (p->alarm_trapframe)
    80001016:	70a8                	ld	a0,96(s1)
    80001018:	c509                	beqz	a0,80001022 <freeproc+0x28>
    kfree((void *)p->alarm_trapframe);
    8000101a:	fffff097          	auipc	ra,0xfffff
    8000101e:	002080e7          	jalr	2(ra) # 8000001c <kfree>
  p->alarm_trapframe = 0;
    80001022:	0604b023          	sd	zero,96(s1)
  if (p->pagetable)
    80001026:	7ca8                	ld	a0,120(s1)
    80001028:	c511                	beqz	a0,80001034 <freeproc+0x3a>
    proc_freepagetable(p->pagetable, p->sz);
    8000102a:	78ac                	ld	a1,112(s1)
    8000102c:	00000097          	auipc	ra,0x0
    80001030:	f7c080e7          	jalr	-132(ra) # 80000fa8 <proc_freepagetable>
  p->pagetable = 0;
    80001034:	0604bc23          	sd	zero,120(s1)
  p->sz = 0;
    80001038:	0604b823          	sd	zero,112(s1)
  p->pid = 0;
    8000103c:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001040:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001044:	18048023          	sb	zero,384(s1)
  p->chan = 0;
    80001048:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000104c:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001050:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001054:	0004ac23          	sw	zero,24(s1)
  p->alarm_inteval = 0;
    80001058:	0404a023          	sw	zero,64(s1)
  p->handler = 0;
    8000105c:	0404b423          	sd	zero,72(s1)
  p->ticks = 0;
    80001060:	0404b823          	sd	zero,80(s1)
  p->alarm_on = 0;
    80001064:	0404ac23          	sw	zero,88(s1)
}
    80001068:	60e2                	ld	ra,24(sp)
    8000106a:	6442                	ld	s0,16(sp)
    8000106c:	64a2                	ld	s1,8(sp)
    8000106e:	6105                	addi	sp,sp,32
    80001070:	8082                	ret

0000000080001072 <allocproc>:
{
    80001072:	1101                	addi	sp,sp,-32
    80001074:	ec06                	sd	ra,24(sp)
    80001076:	e822                	sd	s0,16(sp)
    80001078:	e426                	sd	s1,8(sp)
    8000107a:	e04a                	sd	s2,0(sp)
    8000107c:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++)
    8000107e:	00008497          	auipc	s1,0x8
    80001082:	40248493          	addi	s1,s1,1026 # 80009480 <proc>
    80001086:	0000f917          	auipc	s2,0xf
    8000108a:	bfa90913          	addi	s2,s2,-1030 # 8000fc80 <tickslock>
    acquire(&p->lock);
    8000108e:	8526                	mv	a0,s1
    80001090:	00005097          	auipc	ra,0x5
    80001094:	168080e7          	jalr	360(ra) # 800061f8 <acquire>
    if (p->state == UNUSED)
    80001098:	4c9c                	lw	a5,24(s1)
    8000109a:	cb95                	beqz	a5,800010ce <allocproc+0x5c>
      release(&p->lock);
    8000109c:	8526                	mv	a0,s1
    8000109e:	00005097          	auipc	ra,0x5
    800010a2:	20e080e7          	jalr	526(ra) # 800062ac <release>
  for (p = proc; p < &proc[NPROC]; p++)
    800010a6:	1a048493          	addi	s1,s1,416
    800010aa:	ff2492e3          	bne	s1,s2,8000108e <allocproc+0x1c>
  p->alarm_inteval = 0;
    800010ae:	0000f797          	auipc	a5,0xf
    800010b2:	3d278793          	addi	a5,a5,978 # 80010480 <bcache+0x7e8>
    800010b6:	8407a023          	sw	zero,-1984(a5)
  p->handler = 0;
    800010ba:	8407b423          	sd	zero,-1976(a5)
  p->ticks = 0;
    800010be:	8407b823          	sd	zero,-1968(a5)
  p->alarm_on = 0;
    800010c2:	8407ac23          	sw	zero,-1960(a5)
  p->alarm_trapframe = 0;
    800010c6:	8607b023          	sd	zero,-1952(a5)
  return 0;
    800010ca:	4481                	li	s1,0
    800010cc:	a889                	j	8000111e <allocproc+0xac>
  p->pid = allocpid();
    800010ce:	00000097          	auipc	ra,0x0
    800010d2:	df8080e7          	jalr	-520(ra) # 80000ec6 <allocpid>
    800010d6:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010d8:	4785                	li	a5,1
    800010da:	cc9c                	sw	a5,24(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    800010dc:	fffff097          	auipc	ra,0xfffff
    800010e0:	03c080e7          	jalr	60(ra) # 80000118 <kalloc>
    800010e4:	892a                	mv	s2,a0
    800010e6:	e0c8                	sd	a0,128(s1)
    800010e8:	c131                	beqz	a0,8000112c <allocproc+0xba>
  p->pagetable = proc_pagetable(p);
    800010ea:	8526                	mv	a0,s1
    800010ec:	00000097          	auipc	ra,0x0
    800010f0:	e20080e7          	jalr	-480(ra) # 80000f0c <proc_pagetable>
    800010f4:	892a                	mv	s2,a0
    800010f6:	fca8                	sd	a0,120(s1)
  if (p->pagetable == 0)
    800010f8:	c531                	beqz	a0,80001144 <allocproc+0xd2>
  memset(&p->context, 0, sizeof(p->context));
    800010fa:	07000613          	li	a2,112
    800010fe:	4581                	li	a1,0
    80001100:	08848513          	addi	a0,s1,136
    80001104:	fffff097          	auipc	ra,0xfffff
    80001108:	074080e7          	jalr	116(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    8000110c:	00000797          	auipc	a5,0x0
    80001110:	d7478793          	addi	a5,a5,-652 # 80000e80 <forkret>
    80001114:	e4dc                	sd	a5,136(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001116:	74bc                	ld	a5,104(s1)
    80001118:	6705                	lui	a4,0x1
    8000111a:	97ba                	add	a5,a5,a4
    8000111c:	e8dc                	sd	a5,144(s1)
}
    8000111e:	8526                	mv	a0,s1
    80001120:	60e2                	ld	ra,24(sp)
    80001122:	6442                	ld	s0,16(sp)
    80001124:	64a2                	ld	s1,8(sp)
    80001126:	6902                	ld	s2,0(sp)
    80001128:	6105                	addi	sp,sp,32
    8000112a:	8082                	ret
    freeproc(p);
    8000112c:	8526                	mv	a0,s1
    8000112e:	00000097          	auipc	ra,0x0
    80001132:	ecc080e7          	jalr	-308(ra) # 80000ffa <freeproc>
    release(&p->lock);
    80001136:	8526                	mv	a0,s1
    80001138:	00005097          	auipc	ra,0x5
    8000113c:	174080e7          	jalr	372(ra) # 800062ac <release>
    return 0;
    80001140:	84ca                	mv	s1,s2
    80001142:	bff1                	j	8000111e <allocproc+0xac>
    freeproc(p);
    80001144:	8526                	mv	a0,s1
    80001146:	00000097          	auipc	ra,0x0
    8000114a:	eb4080e7          	jalr	-332(ra) # 80000ffa <freeproc>
    release(&p->lock);
    8000114e:	8526                	mv	a0,s1
    80001150:	00005097          	auipc	ra,0x5
    80001154:	15c080e7          	jalr	348(ra) # 800062ac <release>
    return 0;
    80001158:	84ca                	mv	s1,s2
    8000115a:	b7d1                	j	8000111e <allocproc+0xac>

000000008000115c <userinit>:
{
    8000115c:	1101                	addi	sp,sp,-32
    8000115e:	ec06                	sd	ra,24(sp)
    80001160:	e822                	sd	s0,16(sp)
    80001162:	e426                	sd	s1,8(sp)
    80001164:	1000                	addi	s0,sp,32
  p = allocproc();
    80001166:	00000097          	auipc	ra,0x0
    8000116a:	f0c080e7          	jalr	-244(ra) # 80001072 <allocproc>
    8000116e:	84aa                	mv	s1,a0
  initproc = p;
    80001170:	00008797          	auipc	a5,0x8
    80001174:	eaa7b023          	sd	a0,-352(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001178:	03400613          	li	a2,52
    8000117c:	00007597          	auipc	a1,0x7
    80001180:	6d458593          	addi	a1,a1,1748 # 80008850 <initcode>
    80001184:	7d28                	ld	a0,120(a0)
    80001186:	fffff097          	auipc	ra,0xfffff
    8000118a:	67a080e7          	jalr	1658(ra) # 80000800 <uvminit>
  p->sz = PGSIZE;
    8000118e:	6785                	lui	a5,0x1
    80001190:	f8bc                	sd	a5,112(s1)
  p->trapframe->epc = 0;     // user program counter
    80001192:	60d8                	ld	a4,128(s1)
    80001194:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE; // user stack pointer
    80001198:	60d8                	ld	a4,128(s1)
    8000119a:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000119c:	4641                	li	a2,16
    8000119e:	00007597          	auipc	a1,0x7
    800011a2:	fe258593          	addi	a1,a1,-30 # 80008180 <etext+0x180>
    800011a6:	18048513          	addi	a0,s1,384
    800011aa:	fffff097          	auipc	ra,0xfffff
    800011ae:	120080e7          	jalr	288(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    800011b2:	00007517          	auipc	a0,0x7
    800011b6:	fde50513          	addi	a0,a0,-34 # 80008190 <etext+0x190>
    800011ba:	00002097          	auipc	ra,0x2
    800011be:	19c080e7          	jalr	412(ra) # 80003356 <namei>
    800011c2:	16a4bc23          	sd	a0,376(s1)
  p->state = RUNNABLE;
    800011c6:	478d                	li	a5,3
    800011c8:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011ca:	8526                	mv	a0,s1
    800011cc:	00005097          	auipc	ra,0x5
    800011d0:	0e0080e7          	jalr	224(ra) # 800062ac <release>
}
    800011d4:	60e2                	ld	ra,24(sp)
    800011d6:	6442                	ld	s0,16(sp)
    800011d8:	64a2                	ld	s1,8(sp)
    800011da:	6105                	addi	sp,sp,32
    800011dc:	8082                	ret

00000000800011de <growproc>:
{
    800011de:	1101                	addi	sp,sp,-32
    800011e0:	ec06                	sd	ra,24(sp)
    800011e2:	e822                	sd	s0,16(sp)
    800011e4:	e426                	sd	s1,8(sp)
    800011e6:	e04a                	sd	s2,0(sp)
    800011e8:	1000                	addi	s0,sp,32
    800011ea:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011ec:	00000097          	auipc	ra,0x0
    800011f0:	c5c080e7          	jalr	-932(ra) # 80000e48 <myproc>
    800011f4:	892a                	mv	s2,a0
  sz = p->sz;
    800011f6:	792c                	ld	a1,112(a0)
    800011f8:	0005861b          	sext.w	a2,a1
  if (n > 0)
    800011fc:	00904f63          	bgtz	s1,8000121a <growproc+0x3c>
  else if (n < 0)
    80001200:	0204cc63          	bltz	s1,80001238 <growproc+0x5a>
  p->sz = sz;
    80001204:	1602                	slli	a2,a2,0x20
    80001206:	9201                	srli	a2,a2,0x20
    80001208:	06c93823          	sd	a2,112(s2)
  return 0;
    8000120c:	4501                	li	a0,0
}
    8000120e:	60e2                	ld	ra,24(sp)
    80001210:	6442                	ld	s0,16(sp)
    80001212:	64a2                	ld	s1,8(sp)
    80001214:	6902                	ld	s2,0(sp)
    80001216:	6105                	addi	sp,sp,32
    80001218:	8082                	ret
    if ((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0)
    8000121a:	9e25                	addw	a2,a2,s1
    8000121c:	1602                	slli	a2,a2,0x20
    8000121e:	9201                	srli	a2,a2,0x20
    80001220:	1582                	slli	a1,a1,0x20
    80001222:	9181                	srli	a1,a1,0x20
    80001224:	7d28                	ld	a0,120(a0)
    80001226:	fffff097          	auipc	ra,0xfffff
    8000122a:	694080e7          	jalr	1684(ra) # 800008ba <uvmalloc>
    8000122e:	0005061b          	sext.w	a2,a0
    80001232:	fa69                	bnez	a2,80001204 <growproc+0x26>
      return -1;
    80001234:	557d                	li	a0,-1
    80001236:	bfe1                	j	8000120e <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001238:	9e25                	addw	a2,a2,s1
    8000123a:	1602                	slli	a2,a2,0x20
    8000123c:	9201                	srli	a2,a2,0x20
    8000123e:	1582                	slli	a1,a1,0x20
    80001240:	9181                	srli	a1,a1,0x20
    80001242:	7d28                	ld	a0,120(a0)
    80001244:	fffff097          	auipc	ra,0xfffff
    80001248:	62e080e7          	jalr	1582(ra) # 80000872 <uvmdealloc>
    8000124c:	0005061b          	sext.w	a2,a0
    80001250:	bf55                	j	80001204 <growproc+0x26>

0000000080001252 <fork>:
{
    80001252:	7179                	addi	sp,sp,-48
    80001254:	f406                	sd	ra,40(sp)
    80001256:	f022                	sd	s0,32(sp)
    80001258:	ec26                	sd	s1,24(sp)
    8000125a:	e84a                	sd	s2,16(sp)
    8000125c:	e44e                	sd	s3,8(sp)
    8000125e:	e052                	sd	s4,0(sp)
    80001260:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001262:	00000097          	auipc	ra,0x0
    80001266:	be6080e7          	jalr	-1050(ra) # 80000e48 <myproc>
    8000126a:	892a                	mv	s2,a0
  if ((np = allocproc()) == 0)
    8000126c:	00000097          	auipc	ra,0x0
    80001270:	e06080e7          	jalr	-506(ra) # 80001072 <allocproc>
    80001274:	10050b63          	beqz	a0,8000138a <fork+0x138>
    80001278:	89aa                	mv	s3,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    8000127a:	07093603          	ld	a2,112(s2)
    8000127e:	7d2c                	ld	a1,120(a0)
    80001280:	07893503          	ld	a0,120(s2)
    80001284:	fffff097          	auipc	ra,0xfffff
    80001288:	782080e7          	jalr	1922(ra) # 80000a06 <uvmcopy>
    8000128c:	04054663          	bltz	a0,800012d8 <fork+0x86>
  np->sz = p->sz;
    80001290:	07093783          	ld	a5,112(s2)
    80001294:	06f9b823          	sd	a5,112(s3)
  *(np->trapframe) = *(p->trapframe);
    80001298:	08093683          	ld	a3,128(s2)
    8000129c:	87b6                	mv	a5,a3
    8000129e:	0809b703          	ld	a4,128(s3)
    800012a2:	12068693          	addi	a3,a3,288
    800012a6:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012aa:	6788                	ld	a0,8(a5)
    800012ac:	6b8c                	ld	a1,16(a5)
    800012ae:	6f90                	ld	a2,24(a5)
    800012b0:	01073023          	sd	a6,0(a4)
    800012b4:	e708                	sd	a0,8(a4)
    800012b6:	eb0c                	sd	a1,16(a4)
    800012b8:	ef10                	sd	a2,24(a4)
    800012ba:	02078793          	addi	a5,a5,32
    800012be:	02070713          	addi	a4,a4,32
    800012c2:	fed792e3          	bne	a5,a3,800012a6 <fork+0x54>
  np->trapframe->a0 = 0;
    800012c6:	0809b783          	ld	a5,128(s3)
    800012ca:	0607b823          	sd	zero,112(a5)
    800012ce:	0f800493          	li	s1,248
  for (i = 0; i < NOFILE; i++)
    800012d2:	17800a13          	li	s4,376
    800012d6:	a03d                	j	80001304 <fork+0xb2>
    freeproc(np);
    800012d8:	854e                	mv	a0,s3
    800012da:	00000097          	auipc	ra,0x0
    800012de:	d20080e7          	jalr	-736(ra) # 80000ffa <freeproc>
    release(&np->lock);
    800012e2:	854e                	mv	a0,s3
    800012e4:	00005097          	auipc	ra,0x5
    800012e8:	fc8080e7          	jalr	-56(ra) # 800062ac <release>
    return -1;
    800012ec:	5a7d                	li	s4,-1
    800012ee:	a069                	j	80001378 <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    800012f0:	00002097          	auipc	ra,0x2
    800012f4:	6fc080e7          	jalr	1788(ra) # 800039ec <filedup>
    800012f8:	009987b3          	add	a5,s3,s1
    800012fc:	e388                	sd	a0,0(a5)
  for (i = 0; i < NOFILE; i++)
    800012fe:	04a1                	addi	s1,s1,8
    80001300:	01448763          	beq	s1,s4,8000130e <fork+0xbc>
    if (p->ofile[i])
    80001304:	009907b3          	add	a5,s2,s1
    80001308:	6388                	ld	a0,0(a5)
    8000130a:	f17d                	bnez	a0,800012f0 <fork+0x9e>
    8000130c:	bfcd                	j	800012fe <fork+0xac>
  np->cwd = idup(p->cwd);
    8000130e:	17893503          	ld	a0,376(s2)
    80001312:	00002097          	auipc	ra,0x2
    80001316:	850080e7          	jalr	-1968(ra) # 80002b62 <idup>
    8000131a:	16a9bc23          	sd	a0,376(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000131e:	4641                	li	a2,16
    80001320:	18090593          	addi	a1,s2,384
    80001324:	18098513          	addi	a0,s3,384
    80001328:	fffff097          	auipc	ra,0xfffff
    8000132c:	fa2080e7          	jalr	-94(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    80001330:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    80001334:	854e                	mv	a0,s3
    80001336:	00005097          	auipc	ra,0x5
    8000133a:	f76080e7          	jalr	-138(ra) # 800062ac <release>
  acquire(&wait_lock);
    8000133e:	00008497          	auipc	s1,0x8
    80001342:	d2a48493          	addi	s1,s1,-726 # 80009068 <wait_lock>
    80001346:	8526                	mv	a0,s1
    80001348:	00005097          	auipc	ra,0x5
    8000134c:	eb0080e7          	jalr	-336(ra) # 800061f8 <acquire>
  np->parent = p;
    80001350:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    80001354:	8526                	mv	a0,s1
    80001356:	00005097          	auipc	ra,0x5
    8000135a:	f56080e7          	jalr	-170(ra) # 800062ac <release>
  acquire(&np->lock);
    8000135e:	854e                	mv	a0,s3
    80001360:	00005097          	auipc	ra,0x5
    80001364:	e98080e7          	jalr	-360(ra) # 800061f8 <acquire>
  np->state = RUNNABLE;
    80001368:	478d                	li	a5,3
    8000136a:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    8000136e:	854e                	mv	a0,s3
    80001370:	00005097          	auipc	ra,0x5
    80001374:	f3c080e7          	jalr	-196(ra) # 800062ac <release>
}
    80001378:	8552                	mv	a0,s4
    8000137a:	70a2                	ld	ra,40(sp)
    8000137c:	7402                	ld	s0,32(sp)
    8000137e:	64e2                	ld	s1,24(sp)
    80001380:	6942                	ld	s2,16(sp)
    80001382:	69a2                	ld	s3,8(sp)
    80001384:	6a02                	ld	s4,0(sp)
    80001386:	6145                	addi	sp,sp,48
    80001388:	8082                	ret
    return -1;
    8000138a:	5a7d                	li	s4,-1
    8000138c:	b7f5                	j	80001378 <fork+0x126>

000000008000138e <scheduler>:
{
    8000138e:	7139                	addi	sp,sp,-64
    80001390:	fc06                	sd	ra,56(sp)
    80001392:	f822                	sd	s0,48(sp)
    80001394:	f426                	sd	s1,40(sp)
    80001396:	f04a                	sd	s2,32(sp)
    80001398:	ec4e                	sd	s3,24(sp)
    8000139a:	e852                	sd	s4,16(sp)
    8000139c:	e456                	sd	s5,8(sp)
    8000139e:	e05a                	sd	s6,0(sp)
    800013a0:	0080                	addi	s0,sp,64
    800013a2:	8792                	mv	a5,tp
  int id = r_tp();
    800013a4:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013a6:	00779a93          	slli	s5,a5,0x7
    800013aa:	00008717          	auipc	a4,0x8
    800013ae:	ca670713          	addi	a4,a4,-858 # 80009050 <pid_lock>
    800013b2:	9756                	add	a4,a4,s5
    800013b4:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013b8:	00008717          	auipc	a4,0x8
    800013bc:	cd070713          	addi	a4,a4,-816 # 80009088 <cpus+0x8>
    800013c0:	9aba                	add	s5,s5,a4
      if (p->state == RUNNABLE)
    800013c2:	498d                	li	s3,3
        p->state = RUNNING;
    800013c4:	4b11                	li	s6,4
        c->proc = p;
    800013c6:	079e                	slli	a5,a5,0x7
    800013c8:	00008a17          	auipc	s4,0x8
    800013cc:	c88a0a13          	addi	s4,s4,-888 # 80009050 <pid_lock>
    800013d0:	9a3e                	add	s4,s4,a5
    for (p = proc; p < &proc[NPROC]; p++)
    800013d2:	0000f917          	auipc	s2,0xf
    800013d6:	8ae90913          	addi	s2,s2,-1874 # 8000fc80 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800013da:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013de:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    800013e2:	10079073          	csrw	sstatus,a5
    800013e6:	00008497          	auipc	s1,0x8
    800013ea:	09a48493          	addi	s1,s1,154 # 80009480 <proc>
    800013ee:	a03d                	j	8000141c <scheduler+0x8e>
        p->state = RUNNING;
    800013f0:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800013f4:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013f8:	08848593          	addi	a1,s1,136
    800013fc:	8556                	mv	a0,s5
    800013fe:	00000097          	auipc	ra,0x0
    80001402:	640080e7          	jalr	1600(ra) # 80001a3e <swtch>
        c->proc = 0;
    80001406:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    8000140a:	8526                	mv	a0,s1
    8000140c:	00005097          	auipc	ra,0x5
    80001410:	ea0080e7          	jalr	-352(ra) # 800062ac <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80001414:	1a048493          	addi	s1,s1,416
    80001418:	fd2481e3          	beq	s1,s2,800013da <scheduler+0x4c>
      acquire(&p->lock);
    8000141c:	8526                	mv	a0,s1
    8000141e:	00005097          	auipc	ra,0x5
    80001422:	dda080e7          	jalr	-550(ra) # 800061f8 <acquire>
      if (p->state == RUNNABLE)
    80001426:	4c9c                	lw	a5,24(s1)
    80001428:	ff3791e3          	bne	a5,s3,8000140a <scheduler+0x7c>
    8000142c:	b7d1                	j	800013f0 <scheduler+0x62>

000000008000142e <sched>:
{
    8000142e:	7179                	addi	sp,sp,-48
    80001430:	f406                	sd	ra,40(sp)
    80001432:	f022                	sd	s0,32(sp)
    80001434:	ec26                	sd	s1,24(sp)
    80001436:	e84a                	sd	s2,16(sp)
    80001438:	e44e                	sd	s3,8(sp)
    8000143a:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000143c:	00000097          	auipc	ra,0x0
    80001440:	a0c080e7          	jalr	-1524(ra) # 80000e48 <myproc>
    80001444:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    80001446:	00005097          	auipc	ra,0x5
    8000144a:	d38080e7          	jalr	-712(ra) # 8000617e <holding>
    8000144e:	c93d                	beqz	a0,800014c4 <sched+0x96>
  asm volatile("mv %0, tp" : "=r"(x));
    80001450:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    80001452:	2781                	sext.w	a5,a5
    80001454:	079e                	slli	a5,a5,0x7
    80001456:	00008717          	auipc	a4,0x8
    8000145a:	bfa70713          	addi	a4,a4,-1030 # 80009050 <pid_lock>
    8000145e:	97ba                	add	a5,a5,a4
    80001460:	0a87a703          	lw	a4,168(a5)
    80001464:	4785                	li	a5,1
    80001466:	06f71763          	bne	a4,a5,800014d4 <sched+0xa6>
  if (p->state == RUNNING)
    8000146a:	4c98                	lw	a4,24(s1)
    8000146c:	4791                	li	a5,4
    8000146e:	06f70b63          	beq	a4,a5,800014e4 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001472:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001476:	8b89                	andi	a5,a5,2
  if (intr_get())
    80001478:	efb5                	bnez	a5,800014f4 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r"(x));
    8000147a:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000147c:	00008917          	auipc	s2,0x8
    80001480:	bd490913          	addi	s2,s2,-1068 # 80009050 <pid_lock>
    80001484:	2781                	sext.w	a5,a5
    80001486:	079e                	slli	a5,a5,0x7
    80001488:	97ca                	add	a5,a5,s2
    8000148a:	0ac7a983          	lw	s3,172(a5)
    8000148e:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001490:	2781                	sext.w	a5,a5
    80001492:	079e                	slli	a5,a5,0x7
    80001494:	00008597          	auipc	a1,0x8
    80001498:	bf458593          	addi	a1,a1,-1036 # 80009088 <cpus+0x8>
    8000149c:	95be                	add	a1,a1,a5
    8000149e:	08848513          	addi	a0,s1,136
    800014a2:	00000097          	auipc	ra,0x0
    800014a6:	59c080e7          	jalr	1436(ra) # 80001a3e <swtch>
    800014aa:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014ac:	2781                	sext.w	a5,a5
    800014ae:	079e                	slli	a5,a5,0x7
    800014b0:	97ca                	add	a5,a5,s2
    800014b2:	0b37a623          	sw	s3,172(a5)
}
    800014b6:	70a2                	ld	ra,40(sp)
    800014b8:	7402                	ld	s0,32(sp)
    800014ba:	64e2                	ld	s1,24(sp)
    800014bc:	6942                	ld	s2,16(sp)
    800014be:	69a2                	ld	s3,8(sp)
    800014c0:	6145                	addi	sp,sp,48
    800014c2:	8082                	ret
    panic("sched p->lock");
    800014c4:	00007517          	auipc	a0,0x7
    800014c8:	cd450513          	addi	a0,a0,-812 # 80008198 <etext+0x198>
    800014cc:	00004097          	auipc	ra,0x4
    800014d0:	78c080e7          	jalr	1932(ra) # 80005c58 <panic>
    panic("sched locks");
    800014d4:	00007517          	auipc	a0,0x7
    800014d8:	cd450513          	addi	a0,a0,-812 # 800081a8 <etext+0x1a8>
    800014dc:	00004097          	auipc	ra,0x4
    800014e0:	77c080e7          	jalr	1916(ra) # 80005c58 <panic>
    panic("sched running");
    800014e4:	00007517          	auipc	a0,0x7
    800014e8:	cd450513          	addi	a0,a0,-812 # 800081b8 <etext+0x1b8>
    800014ec:	00004097          	auipc	ra,0x4
    800014f0:	76c080e7          	jalr	1900(ra) # 80005c58 <panic>
    panic("sched interruptible");
    800014f4:	00007517          	auipc	a0,0x7
    800014f8:	cd450513          	addi	a0,a0,-812 # 800081c8 <etext+0x1c8>
    800014fc:	00004097          	auipc	ra,0x4
    80001500:	75c080e7          	jalr	1884(ra) # 80005c58 <panic>

0000000080001504 <yield>:
{
    80001504:	1101                	addi	sp,sp,-32
    80001506:	ec06                	sd	ra,24(sp)
    80001508:	e822                	sd	s0,16(sp)
    8000150a:	e426                	sd	s1,8(sp)
    8000150c:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000150e:	00000097          	auipc	ra,0x0
    80001512:	93a080e7          	jalr	-1734(ra) # 80000e48 <myproc>
    80001516:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001518:	00005097          	auipc	ra,0x5
    8000151c:	ce0080e7          	jalr	-800(ra) # 800061f8 <acquire>
  p->state = RUNNABLE;
    80001520:	478d                	li	a5,3
    80001522:	cc9c                	sw	a5,24(s1)
  sched();
    80001524:	00000097          	auipc	ra,0x0
    80001528:	f0a080e7          	jalr	-246(ra) # 8000142e <sched>
  release(&p->lock);
    8000152c:	8526                	mv	a0,s1
    8000152e:	00005097          	auipc	ra,0x5
    80001532:	d7e080e7          	jalr	-642(ra) # 800062ac <release>
}
    80001536:	60e2                	ld	ra,24(sp)
    80001538:	6442                	ld	s0,16(sp)
    8000153a:	64a2                	ld	s1,8(sp)
    8000153c:	6105                	addi	sp,sp,32
    8000153e:	8082                	ret

0000000080001540 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    80001540:	7179                	addi	sp,sp,-48
    80001542:	f406                	sd	ra,40(sp)
    80001544:	f022                	sd	s0,32(sp)
    80001546:	ec26                	sd	s1,24(sp)
    80001548:	e84a                	sd	s2,16(sp)
    8000154a:	e44e                	sd	s3,8(sp)
    8000154c:	1800                	addi	s0,sp,48
    8000154e:	89aa                	mv	s3,a0
    80001550:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001552:	00000097          	auipc	ra,0x0
    80001556:	8f6080e7          	jalr	-1802(ra) # 80000e48 <myproc>
    8000155a:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock); // DOC: sleeplock1
    8000155c:	00005097          	auipc	ra,0x5
    80001560:	c9c080e7          	jalr	-868(ra) # 800061f8 <acquire>
  release(lk);
    80001564:	854a                	mv	a0,s2
    80001566:	00005097          	auipc	ra,0x5
    8000156a:	d46080e7          	jalr	-698(ra) # 800062ac <release>

  // Go to sleep.
  p->chan = chan;
    8000156e:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001572:	4789                	li	a5,2
    80001574:	cc9c                	sw	a5,24(s1)

  sched();
    80001576:	00000097          	auipc	ra,0x0
    8000157a:	eb8080e7          	jalr	-328(ra) # 8000142e <sched>

  // Tidy up.
  p->chan = 0;
    8000157e:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001582:	8526                	mv	a0,s1
    80001584:	00005097          	auipc	ra,0x5
    80001588:	d28080e7          	jalr	-728(ra) # 800062ac <release>
  acquire(lk);
    8000158c:	854a                	mv	a0,s2
    8000158e:	00005097          	auipc	ra,0x5
    80001592:	c6a080e7          	jalr	-918(ra) # 800061f8 <acquire>
}
    80001596:	70a2                	ld	ra,40(sp)
    80001598:	7402                	ld	s0,32(sp)
    8000159a:	64e2                	ld	s1,24(sp)
    8000159c:	6942                	ld	s2,16(sp)
    8000159e:	69a2                	ld	s3,8(sp)
    800015a0:	6145                	addi	sp,sp,48
    800015a2:	8082                	ret

00000000800015a4 <wait>:
{
    800015a4:	715d                	addi	sp,sp,-80
    800015a6:	e486                	sd	ra,72(sp)
    800015a8:	e0a2                	sd	s0,64(sp)
    800015aa:	fc26                	sd	s1,56(sp)
    800015ac:	f84a                	sd	s2,48(sp)
    800015ae:	f44e                	sd	s3,40(sp)
    800015b0:	f052                	sd	s4,32(sp)
    800015b2:	ec56                	sd	s5,24(sp)
    800015b4:	e85a                	sd	s6,16(sp)
    800015b6:	e45e                	sd	s7,8(sp)
    800015b8:	e062                	sd	s8,0(sp)
    800015ba:	0880                	addi	s0,sp,80
    800015bc:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015be:	00000097          	auipc	ra,0x0
    800015c2:	88a080e7          	jalr	-1910(ra) # 80000e48 <myproc>
    800015c6:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015c8:	00008517          	auipc	a0,0x8
    800015cc:	aa050513          	addi	a0,a0,-1376 # 80009068 <wait_lock>
    800015d0:	00005097          	auipc	ra,0x5
    800015d4:	c28080e7          	jalr	-984(ra) # 800061f8 <acquire>
    havekids = 0;
    800015d8:	4b81                	li	s7,0
        if (np->state == ZOMBIE)
    800015da:	4a15                	li	s4,5
    for (np = proc; np < &proc[NPROC]; np++)
    800015dc:	0000e997          	auipc	s3,0xe
    800015e0:	6a498993          	addi	s3,s3,1700 # 8000fc80 <tickslock>
        havekids = 1;
    800015e4:	4a85                	li	s5,1
    sleep(p, &wait_lock); // DOC: wait-sleep
    800015e6:	00008c17          	auipc	s8,0x8
    800015ea:	a82c0c13          	addi	s8,s8,-1406 # 80009068 <wait_lock>
    havekids = 0;
    800015ee:	875e                	mv	a4,s7
    for (np = proc; np < &proc[NPROC]; np++)
    800015f0:	00008497          	auipc	s1,0x8
    800015f4:	e9048493          	addi	s1,s1,-368 # 80009480 <proc>
    800015f8:	a0bd                	j	80001666 <wait+0xc2>
          pid = np->pid;
    800015fa:	0304a983          	lw	s3,48(s1)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800015fe:	000b0e63          	beqz	s6,8000161a <wait+0x76>
    80001602:	4691                	li	a3,4
    80001604:	02c48613          	addi	a2,s1,44
    80001608:	85da                	mv	a1,s6
    8000160a:	07893503          	ld	a0,120(s2)
    8000160e:	fffff097          	auipc	ra,0xfffff
    80001612:	4fc080e7          	jalr	1276(ra) # 80000b0a <copyout>
    80001616:	02054563          	bltz	a0,80001640 <wait+0x9c>
          freeproc(np);
    8000161a:	8526                	mv	a0,s1
    8000161c:	00000097          	auipc	ra,0x0
    80001620:	9de080e7          	jalr	-1570(ra) # 80000ffa <freeproc>
          release(&np->lock);
    80001624:	8526                	mv	a0,s1
    80001626:	00005097          	auipc	ra,0x5
    8000162a:	c86080e7          	jalr	-890(ra) # 800062ac <release>
          release(&wait_lock);
    8000162e:	00008517          	auipc	a0,0x8
    80001632:	a3a50513          	addi	a0,a0,-1478 # 80009068 <wait_lock>
    80001636:	00005097          	auipc	ra,0x5
    8000163a:	c76080e7          	jalr	-906(ra) # 800062ac <release>
          return pid;
    8000163e:	a09d                	j	800016a4 <wait+0x100>
            release(&np->lock);
    80001640:	8526                	mv	a0,s1
    80001642:	00005097          	auipc	ra,0x5
    80001646:	c6a080e7          	jalr	-918(ra) # 800062ac <release>
            release(&wait_lock);
    8000164a:	00008517          	auipc	a0,0x8
    8000164e:	a1e50513          	addi	a0,a0,-1506 # 80009068 <wait_lock>
    80001652:	00005097          	auipc	ra,0x5
    80001656:	c5a080e7          	jalr	-934(ra) # 800062ac <release>
            return -1;
    8000165a:	59fd                	li	s3,-1
    8000165c:	a0a1                	j	800016a4 <wait+0x100>
    for (np = proc; np < &proc[NPROC]; np++)
    8000165e:	1a048493          	addi	s1,s1,416
    80001662:	03348463          	beq	s1,s3,8000168a <wait+0xe6>
      if (np->parent == p)
    80001666:	7c9c                	ld	a5,56(s1)
    80001668:	ff279be3          	bne	a5,s2,8000165e <wait+0xba>
        acquire(&np->lock);
    8000166c:	8526                	mv	a0,s1
    8000166e:	00005097          	auipc	ra,0x5
    80001672:	b8a080e7          	jalr	-1142(ra) # 800061f8 <acquire>
        if (np->state == ZOMBIE)
    80001676:	4c9c                	lw	a5,24(s1)
    80001678:	f94781e3          	beq	a5,s4,800015fa <wait+0x56>
        release(&np->lock);
    8000167c:	8526                	mv	a0,s1
    8000167e:	00005097          	auipc	ra,0x5
    80001682:	c2e080e7          	jalr	-978(ra) # 800062ac <release>
        havekids = 1;
    80001686:	8756                	mv	a4,s5
    80001688:	bfd9                	j	8000165e <wait+0xba>
    if (!havekids || p->killed)
    8000168a:	c701                	beqz	a4,80001692 <wait+0xee>
    8000168c:	02892783          	lw	a5,40(s2)
    80001690:	c79d                	beqz	a5,800016be <wait+0x11a>
      release(&wait_lock);
    80001692:	00008517          	auipc	a0,0x8
    80001696:	9d650513          	addi	a0,a0,-1578 # 80009068 <wait_lock>
    8000169a:	00005097          	auipc	ra,0x5
    8000169e:	c12080e7          	jalr	-1006(ra) # 800062ac <release>
      return -1;
    800016a2:	59fd                	li	s3,-1
}
    800016a4:	854e                	mv	a0,s3
    800016a6:	60a6                	ld	ra,72(sp)
    800016a8:	6406                	ld	s0,64(sp)
    800016aa:	74e2                	ld	s1,56(sp)
    800016ac:	7942                	ld	s2,48(sp)
    800016ae:	79a2                	ld	s3,40(sp)
    800016b0:	7a02                	ld	s4,32(sp)
    800016b2:	6ae2                	ld	s5,24(sp)
    800016b4:	6b42                	ld	s6,16(sp)
    800016b6:	6ba2                	ld	s7,8(sp)
    800016b8:	6c02                	ld	s8,0(sp)
    800016ba:	6161                	addi	sp,sp,80
    800016bc:	8082                	ret
    sleep(p, &wait_lock); // DOC: wait-sleep
    800016be:	85e2                	mv	a1,s8
    800016c0:	854a                	mv	a0,s2
    800016c2:	00000097          	auipc	ra,0x0
    800016c6:	e7e080e7          	jalr	-386(ra) # 80001540 <sleep>
    havekids = 0;
    800016ca:	b715                	j	800015ee <wait+0x4a>

00000000800016cc <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    800016cc:	7139                	addi	sp,sp,-64
    800016ce:	fc06                	sd	ra,56(sp)
    800016d0:	f822                	sd	s0,48(sp)
    800016d2:	f426                	sd	s1,40(sp)
    800016d4:	f04a                	sd	s2,32(sp)
    800016d6:	ec4e                	sd	s3,24(sp)
    800016d8:	e852                	sd	s4,16(sp)
    800016da:	e456                	sd	s5,8(sp)
    800016dc:	0080                	addi	s0,sp,64
    800016de:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    800016e0:	00008497          	auipc	s1,0x8
    800016e4:	da048493          	addi	s1,s1,-608 # 80009480 <proc>
  {
    if (p != myproc())
    {
      acquire(&p->lock);
      if (p->state == SLEEPING && p->chan == chan)
    800016e8:	4989                	li	s3,2
      {
        p->state = RUNNABLE;
    800016ea:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++)
    800016ec:	0000e917          	auipc	s2,0xe
    800016f0:	59490913          	addi	s2,s2,1428 # 8000fc80 <tickslock>
    800016f4:	a821                	j	8000170c <wakeup+0x40>
        p->state = RUNNABLE;
    800016f6:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    800016fa:	8526                	mv	a0,s1
    800016fc:	00005097          	auipc	ra,0x5
    80001700:	bb0080e7          	jalr	-1104(ra) # 800062ac <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80001704:	1a048493          	addi	s1,s1,416
    80001708:	03248463          	beq	s1,s2,80001730 <wakeup+0x64>
    if (p != myproc())
    8000170c:	fffff097          	auipc	ra,0xfffff
    80001710:	73c080e7          	jalr	1852(ra) # 80000e48 <myproc>
    80001714:	fea488e3          	beq	s1,a0,80001704 <wakeup+0x38>
      acquire(&p->lock);
    80001718:	8526                	mv	a0,s1
    8000171a:	00005097          	auipc	ra,0x5
    8000171e:	ade080e7          	jalr	-1314(ra) # 800061f8 <acquire>
      if (p->state == SLEEPING && p->chan == chan)
    80001722:	4c9c                	lw	a5,24(s1)
    80001724:	fd379be3          	bne	a5,s3,800016fa <wakeup+0x2e>
    80001728:	709c                	ld	a5,32(s1)
    8000172a:	fd4798e3          	bne	a5,s4,800016fa <wakeup+0x2e>
    8000172e:	b7e1                	j	800016f6 <wakeup+0x2a>
    }
  }
}
    80001730:	70e2                	ld	ra,56(sp)
    80001732:	7442                	ld	s0,48(sp)
    80001734:	74a2                	ld	s1,40(sp)
    80001736:	7902                	ld	s2,32(sp)
    80001738:	69e2                	ld	s3,24(sp)
    8000173a:	6a42                	ld	s4,16(sp)
    8000173c:	6aa2                	ld	s5,8(sp)
    8000173e:	6121                	addi	sp,sp,64
    80001740:	8082                	ret

0000000080001742 <reparent>:
{
    80001742:	7179                	addi	sp,sp,-48
    80001744:	f406                	sd	ra,40(sp)
    80001746:	f022                	sd	s0,32(sp)
    80001748:	ec26                	sd	s1,24(sp)
    8000174a:	e84a                	sd	s2,16(sp)
    8000174c:	e44e                	sd	s3,8(sp)
    8000174e:	e052                	sd	s4,0(sp)
    80001750:	1800                	addi	s0,sp,48
    80001752:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++)
    80001754:	00008497          	auipc	s1,0x8
    80001758:	d2c48493          	addi	s1,s1,-724 # 80009480 <proc>
      pp->parent = initproc;
    8000175c:	00008a17          	auipc	s4,0x8
    80001760:	8b4a0a13          	addi	s4,s4,-1868 # 80009010 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++)
    80001764:	0000e997          	auipc	s3,0xe
    80001768:	51c98993          	addi	s3,s3,1308 # 8000fc80 <tickslock>
    8000176c:	a029                	j	80001776 <reparent+0x34>
    8000176e:	1a048493          	addi	s1,s1,416
    80001772:	01348d63          	beq	s1,s3,8000178c <reparent+0x4a>
    if (pp->parent == p)
    80001776:	7c9c                	ld	a5,56(s1)
    80001778:	ff279be3          	bne	a5,s2,8000176e <reparent+0x2c>
      pp->parent = initproc;
    8000177c:	000a3503          	ld	a0,0(s4)
    80001780:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001782:	00000097          	auipc	ra,0x0
    80001786:	f4a080e7          	jalr	-182(ra) # 800016cc <wakeup>
    8000178a:	b7d5                	j	8000176e <reparent+0x2c>
}
    8000178c:	70a2                	ld	ra,40(sp)
    8000178e:	7402                	ld	s0,32(sp)
    80001790:	64e2                	ld	s1,24(sp)
    80001792:	6942                	ld	s2,16(sp)
    80001794:	69a2                	ld	s3,8(sp)
    80001796:	6a02                	ld	s4,0(sp)
    80001798:	6145                	addi	sp,sp,48
    8000179a:	8082                	ret

000000008000179c <exit>:
{
    8000179c:	7179                	addi	sp,sp,-48
    8000179e:	f406                	sd	ra,40(sp)
    800017a0:	f022                	sd	s0,32(sp)
    800017a2:	ec26                	sd	s1,24(sp)
    800017a4:	e84a                	sd	s2,16(sp)
    800017a6:	e44e                	sd	s3,8(sp)
    800017a8:	e052                	sd	s4,0(sp)
    800017aa:	1800                	addi	s0,sp,48
    800017ac:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017ae:	fffff097          	auipc	ra,0xfffff
    800017b2:	69a080e7          	jalr	1690(ra) # 80000e48 <myproc>
    800017b6:	89aa                	mv	s3,a0
  if (p == initproc)
    800017b8:	00008797          	auipc	a5,0x8
    800017bc:	8587b783          	ld	a5,-1960(a5) # 80009010 <initproc>
    800017c0:	0f850493          	addi	s1,a0,248
    800017c4:	17850913          	addi	s2,a0,376
    800017c8:	02a79363          	bne	a5,a0,800017ee <exit+0x52>
    panic("init exiting");
    800017cc:	00007517          	auipc	a0,0x7
    800017d0:	a1450513          	addi	a0,a0,-1516 # 800081e0 <etext+0x1e0>
    800017d4:	00004097          	auipc	ra,0x4
    800017d8:	484080e7          	jalr	1156(ra) # 80005c58 <panic>
      fileclose(f);
    800017dc:	00002097          	auipc	ra,0x2
    800017e0:	262080e7          	jalr	610(ra) # 80003a3e <fileclose>
      p->ofile[fd] = 0;
    800017e4:	0004b023          	sd	zero,0(s1)
  for (int fd = 0; fd < NOFILE; fd++)
    800017e8:	04a1                	addi	s1,s1,8
    800017ea:	01248563          	beq	s1,s2,800017f4 <exit+0x58>
    if (p->ofile[fd])
    800017ee:	6088                	ld	a0,0(s1)
    800017f0:	f575                	bnez	a0,800017dc <exit+0x40>
    800017f2:	bfdd                	j	800017e8 <exit+0x4c>
  begin_op();
    800017f4:	00002097          	auipc	ra,0x2
    800017f8:	d7e080e7          	jalr	-642(ra) # 80003572 <begin_op>
  iput(p->cwd);
    800017fc:	1789b503          	ld	a0,376(s3)
    80001800:	00001097          	auipc	ra,0x1
    80001804:	55a080e7          	jalr	1370(ra) # 80002d5a <iput>
  end_op();
    80001808:	00002097          	auipc	ra,0x2
    8000180c:	dea080e7          	jalr	-534(ra) # 800035f2 <end_op>
  p->cwd = 0;
    80001810:	1609bc23          	sd	zero,376(s3)
  acquire(&wait_lock);
    80001814:	00008497          	auipc	s1,0x8
    80001818:	85448493          	addi	s1,s1,-1964 # 80009068 <wait_lock>
    8000181c:	8526                	mv	a0,s1
    8000181e:	00005097          	auipc	ra,0x5
    80001822:	9da080e7          	jalr	-1574(ra) # 800061f8 <acquire>
  reparent(p);
    80001826:	854e                	mv	a0,s3
    80001828:	00000097          	auipc	ra,0x0
    8000182c:	f1a080e7          	jalr	-230(ra) # 80001742 <reparent>
  wakeup(p->parent);
    80001830:	0389b503          	ld	a0,56(s3)
    80001834:	00000097          	auipc	ra,0x0
    80001838:	e98080e7          	jalr	-360(ra) # 800016cc <wakeup>
  acquire(&p->lock);
    8000183c:	854e                	mv	a0,s3
    8000183e:	00005097          	auipc	ra,0x5
    80001842:	9ba080e7          	jalr	-1606(ra) # 800061f8 <acquire>
  p->xstate = status;
    80001846:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000184a:	4795                	li	a5,5
    8000184c:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001850:	8526                	mv	a0,s1
    80001852:	00005097          	auipc	ra,0x5
    80001856:	a5a080e7          	jalr	-1446(ra) # 800062ac <release>
  sched();
    8000185a:	00000097          	auipc	ra,0x0
    8000185e:	bd4080e7          	jalr	-1068(ra) # 8000142e <sched>
  panic("zombie exit");
    80001862:	00007517          	auipc	a0,0x7
    80001866:	98e50513          	addi	a0,a0,-1650 # 800081f0 <etext+0x1f0>
    8000186a:	00004097          	auipc	ra,0x4
    8000186e:	3ee080e7          	jalr	1006(ra) # 80005c58 <panic>

0000000080001872 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    80001872:	7179                	addi	sp,sp,-48
    80001874:	f406                	sd	ra,40(sp)
    80001876:	f022                	sd	s0,32(sp)
    80001878:	ec26                	sd	s1,24(sp)
    8000187a:	e84a                	sd	s2,16(sp)
    8000187c:	e44e                	sd	s3,8(sp)
    8000187e:	1800                	addi	s0,sp,48
    80001880:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    80001882:	00008497          	auipc	s1,0x8
    80001886:	bfe48493          	addi	s1,s1,-1026 # 80009480 <proc>
    8000188a:	0000e997          	auipc	s3,0xe
    8000188e:	3f698993          	addi	s3,s3,1014 # 8000fc80 <tickslock>
  {
    acquire(&p->lock);
    80001892:	8526                	mv	a0,s1
    80001894:	00005097          	auipc	ra,0x5
    80001898:	964080e7          	jalr	-1692(ra) # 800061f8 <acquire>
    if (p->pid == pid)
    8000189c:	589c                	lw	a5,48(s1)
    8000189e:	01278d63          	beq	a5,s2,800018b8 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018a2:	8526                	mv	a0,s1
    800018a4:	00005097          	auipc	ra,0x5
    800018a8:	a08080e7          	jalr	-1528(ra) # 800062ac <release>
  for (p = proc; p < &proc[NPROC]; p++)
    800018ac:	1a048493          	addi	s1,s1,416
    800018b0:	ff3491e3          	bne	s1,s3,80001892 <kill+0x20>
  }
  return -1;
    800018b4:	557d                	li	a0,-1
    800018b6:	a829                	j	800018d0 <kill+0x5e>
      p->killed = 1;
    800018b8:	4785                	li	a5,1
    800018ba:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING)
    800018bc:	4c98                	lw	a4,24(s1)
    800018be:	4789                	li	a5,2
    800018c0:	00f70f63          	beq	a4,a5,800018de <kill+0x6c>
      release(&p->lock);
    800018c4:	8526                	mv	a0,s1
    800018c6:	00005097          	auipc	ra,0x5
    800018ca:	9e6080e7          	jalr	-1562(ra) # 800062ac <release>
      return 0;
    800018ce:	4501                	li	a0,0
}
    800018d0:	70a2                	ld	ra,40(sp)
    800018d2:	7402                	ld	s0,32(sp)
    800018d4:	64e2                	ld	s1,24(sp)
    800018d6:	6942                	ld	s2,16(sp)
    800018d8:	69a2                	ld	s3,8(sp)
    800018da:	6145                	addi	sp,sp,48
    800018dc:	8082                	ret
        p->state = RUNNABLE;
    800018de:	478d                	li	a5,3
    800018e0:	cc9c                	sw	a5,24(s1)
    800018e2:	b7cd                	j	800018c4 <kill+0x52>

00000000800018e4 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018e4:	7179                	addi	sp,sp,-48
    800018e6:	f406                	sd	ra,40(sp)
    800018e8:	f022                	sd	s0,32(sp)
    800018ea:	ec26                	sd	s1,24(sp)
    800018ec:	e84a                	sd	s2,16(sp)
    800018ee:	e44e                	sd	s3,8(sp)
    800018f0:	e052                	sd	s4,0(sp)
    800018f2:	1800                	addi	s0,sp,48
    800018f4:	84aa                	mv	s1,a0
    800018f6:	892e                	mv	s2,a1
    800018f8:	89b2                	mv	s3,a2
    800018fa:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800018fc:	fffff097          	auipc	ra,0xfffff
    80001900:	54c080e7          	jalr	1356(ra) # 80000e48 <myproc>
  if (user_dst)
    80001904:	c08d                	beqz	s1,80001926 <either_copyout+0x42>
  {
    return copyout(p->pagetable, dst, src, len);
    80001906:	86d2                	mv	a3,s4
    80001908:	864e                	mv	a2,s3
    8000190a:	85ca                	mv	a1,s2
    8000190c:	7d28                	ld	a0,120(a0)
    8000190e:	fffff097          	auipc	ra,0xfffff
    80001912:	1fc080e7          	jalr	508(ra) # 80000b0a <copyout>
  else
  {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001916:	70a2                	ld	ra,40(sp)
    80001918:	7402                	ld	s0,32(sp)
    8000191a:	64e2                	ld	s1,24(sp)
    8000191c:	6942                	ld	s2,16(sp)
    8000191e:	69a2                	ld	s3,8(sp)
    80001920:	6a02                	ld	s4,0(sp)
    80001922:	6145                	addi	sp,sp,48
    80001924:	8082                	ret
    memmove((char *)dst, src, len);
    80001926:	000a061b          	sext.w	a2,s4
    8000192a:	85ce                	mv	a1,s3
    8000192c:	854a                	mv	a0,s2
    8000192e:	fffff097          	auipc	ra,0xfffff
    80001932:	8aa080e7          	jalr	-1878(ra) # 800001d8 <memmove>
    return 0;
    80001936:	8526                	mv	a0,s1
    80001938:	bff9                	j	80001916 <either_copyout+0x32>

000000008000193a <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000193a:	7179                	addi	sp,sp,-48
    8000193c:	f406                	sd	ra,40(sp)
    8000193e:	f022                	sd	s0,32(sp)
    80001940:	ec26                	sd	s1,24(sp)
    80001942:	e84a                	sd	s2,16(sp)
    80001944:	e44e                	sd	s3,8(sp)
    80001946:	e052                	sd	s4,0(sp)
    80001948:	1800                	addi	s0,sp,48
    8000194a:	892a                	mv	s2,a0
    8000194c:	84ae                	mv	s1,a1
    8000194e:	89b2                	mv	s3,a2
    80001950:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001952:	fffff097          	auipc	ra,0xfffff
    80001956:	4f6080e7          	jalr	1270(ra) # 80000e48 <myproc>
  if (user_src)
    8000195a:	c08d                	beqz	s1,8000197c <either_copyin+0x42>
  {
    return copyin(p->pagetable, dst, src, len);
    8000195c:	86d2                	mv	a3,s4
    8000195e:	864e                	mv	a2,s3
    80001960:	85ca                	mv	a1,s2
    80001962:	7d28                	ld	a0,120(a0)
    80001964:	fffff097          	auipc	ra,0xfffff
    80001968:	232080e7          	jalr	562(ra) # 80000b96 <copyin>
  else
  {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    8000196c:	70a2                	ld	ra,40(sp)
    8000196e:	7402                	ld	s0,32(sp)
    80001970:	64e2                	ld	s1,24(sp)
    80001972:	6942                	ld	s2,16(sp)
    80001974:	69a2                	ld	s3,8(sp)
    80001976:	6a02                	ld	s4,0(sp)
    80001978:	6145                	addi	sp,sp,48
    8000197a:	8082                	ret
    memmove(dst, (char *)src, len);
    8000197c:	000a061b          	sext.w	a2,s4
    80001980:	85ce                	mv	a1,s3
    80001982:	854a                	mv	a0,s2
    80001984:	fffff097          	auipc	ra,0xfffff
    80001988:	854080e7          	jalr	-1964(ra) # 800001d8 <memmove>
    return 0;
    8000198c:	8526                	mv	a0,s1
    8000198e:	bff9                	j	8000196c <either_copyin+0x32>

0000000080001990 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    80001990:	715d                	addi	sp,sp,-80
    80001992:	e486                	sd	ra,72(sp)
    80001994:	e0a2                	sd	s0,64(sp)
    80001996:	fc26                	sd	s1,56(sp)
    80001998:	f84a                	sd	s2,48(sp)
    8000199a:	f44e                	sd	s3,40(sp)
    8000199c:	f052                	sd	s4,32(sp)
    8000199e:	ec56                	sd	s5,24(sp)
    800019a0:	e85a                	sd	s6,16(sp)
    800019a2:	e45e                	sd	s7,8(sp)
    800019a4:	0880                	addi	s0,sp,80
      [RUNNING] "run   ",
      [ZOMBIE] "zombie"};
  struct proc *p;
  char *state;

  printf("\n");
    800019a6:	00006517          	auipc	a0,0x6
    800019aa:	6a250513          	addi	a0,a0,1698 # 80008048 <etext+0x48>
    800019ae:	00004097          	auipc	ra,0x4
    800019b2:	2f4080e7          	jalr	756(ra) # 80005ca2 <printf>
  for (p = proc; p < &proc[NPROC]; p++)
    800019b6:	00008497          	auipc	s1,0x8
    800019ba:	c4a48493          	addi	s1,s1,-950 # 80009600 <proc+0x180>
    800019be:	0000e917          	auipc	s2,0xe
    800019c2:	44290913          	addi	s2,s2,1090 # 8000fe00 <bcache+0x168>
  {
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019c6:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019c8:	00007997          	auipc	s3,0x7
    800019cc:	83898993          	addi	s3,s3,-1992 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019d0:	00007a97          	auipc	s5,0x7
    800019d4:	838a8a93          	addi	s5,s5,-1992 # 80008208 <etext+0x208>
    printf("\n");
    800019d8:	00006a17          	auipc	s4,0x6
    800019dc:	670a0a13          	addi	s4,s4,1648 # 80008048 <etext+0x48>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019e0:	00007b97          	auipc	s7,0x7
    800019e4:	860b8b93          	addi	s7,s7,-1952 # 80008240 <states.1721>
    800019e8:	a00d                	j	80001a0a <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800019ea:	eb06a583          	lw	a1,-336(a3)
    800019ee:	8556                	mv	a0,s5
    800019f0:	00004097          	auipc	ra,0x4
    800019f4:	2b2080e7          	jalr	690(ra) # 80005ca2 <printf>
    printf("\n");
    800019f8:	8552                	mv	a0,s4
    800019fa:	00004097          	auipc	ra,0x4
    800019fe:	2a8080e7          	jalr	680(ra) # 80005ca2 <printf>
  for (p = proc; p < &proc[NPROC]; p++)
    80001a02:	1a048493          	addi	s1,s1,416
    80001a06:	03248163          	beq	s1,s2,80001a28 <procdump+0x98>
    if (p->state == UNUSED)
    80001a0a:	86a6                	mv	a3,s1
    80001a0c:	e984a783          	lw	a5,-360(s1)
    80001a10:	dbed                	beqz	a5,80001a02 <procdump+0x72>
      state = "???";
    80001a12:	864e                	mv	a2,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a14:	fcfb6be3          	bltu	s6,a5,800019ea <procdump+0x5a>
    80001a18:	1782                	slli	a5,a5,0x20
    80001a1a:	9381                	srli	a5,a5,0x20
    80001a1c:	078e                	slli	a5,a5,0x3
    80001a1e:	97de                	add	a5,a5,s7
    80001a20:	6390                	ld	a2,0(a5)
    80001a22:	f661                	bnez	a2,800019ea <procdump+0x5a>
      state = "???";
    80001a24:	864e                	mv	a2,s3
    80001a26:	b7d1                	j	800019ea <procdump+0x5a>
  }
}
    80001a28:	60a6                	ld	ra,72(sp)
    80001a2a:	6406                	ld	s0,64(sp)
    80001a2c:	74e2                	ld	s1,56(sp)
    80001a2e:	7942                	ld	s2,48(sp)
    80001a30:	79a2                	ld	s3,40(sp)
    80001a32:	7a02                	ld	s4,32(sp)
    80001a34:	6ae2                	ld	s5,24(sp)
    80001a36:	6b42                	ld	s6,16(sp)
    80001a38:	6ba2                	ld	s7,8(sp)
    80001a3a:	6161                	addi	sp,sp,80
    80001a3c:	8082                	ret

0000000080001a3e <swtch>:
    80001a3e:	00153023          	sd	ra,0(a0)
    80001a42:	00253423          	sd	sp,8(a0)
    80001a46:	e900                	sd	s0,16(a0)
    80001a48:	ed04                	sd	s1,24(a0)
    80001a4a:	03253023          	sd	s2,32(a0)
    80001a4e:	03353423          	sd	s3,40(a0)
    80001a52:	03453823          	sd	s4,48(a0)
    80001a56:	03553c23          	sd	s5,56(a0)
    80001a5a:	05653023          	sd	s6,64(a0)
    80001a5e:	05753423          	sd	s7,72(a0)
    80001a62:	05853823          	sd	s8,80(a0)
    80001a66:	05953c23          	sd	s9,88(a0)
    80001a6a:	07a53023          	sd	s10,96(a0)
    80001a6e:	07b53423          	sd	s11,104(a0)
    80001a72:	0005b083          	ld	ra,0(a1)
    80001a76:	0085b103          	ld	sp,8(a1)
    80001a7a:	6980                	ld	s0,16(a1)
    80001a7c:	6d84                	ld	s1,24(a1)
    80001a7e:	0205b903          	ld	s2,32(a1)
    80001a82:	0285b983          	ld	s3,40(a1)
    80001a86:	0305ba03          	ld	s4,48(a1)
    80001a8a:	0385ba83          	ld	s5,56(a1)
    80001a8e:	0405bb03          	ld	s6,64(a1)
    80001a92:	0485bb83          	ld	s7,72(a1)
    80001a96:	0505bc03          	ld	s8,80(a1)
    80001a9a:	0585bc83          	ld	s9,88(a1)
    80001a9e:	0605bd03          	ld	s10,96(a1)
    80001aa2:	0685bd83          	ld	s11,104(a1)
    80001aa6:	8082                	ret

0000000080001aa8 <trapinit>:
void kernelvec();

extern int devintr();

void trapinit(void)
{
    80001aa8:	1141                	addi	sp,sp,-16
    80001aaa:	e406                	sd	ra,8(sp)
    80001aac:	e022                	sd	s0,0(sp)
    80001aae:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001ab0:	00006597          	auipc	a1,0x6
    80001ab4:	7c058593          	addi	a1,a1,1984 # 80008270 <states.1721+0x30>
    80001ab8:	0000e517          	auipc	a0,0xe
    80001abc:	1c850513          	addi	a0,a0,456 # 8000fc80 <tickslock>
    80001ac0:	00004097          	auipc	ra,0x4
    80001ac4:	6a8080e7          	jalr	1704(ra) # 80006168 <initlock>
}
    80001ac8:	60a2                	ld	ra,8(sp)
    80001aca:	6402                	ld	s0,0(sp)
    80001acc:	0141                	addi	sp,sp,16
    80001ace:	8082                	ret

0000000080001ad0 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    80001ad0:	1141                	addi	sp,sp,-16
    80001ad2:	e422                	sd	s0,8(sp)
    80001ad4:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r"(x));
    80001ad6:	00003797          	auipc	a5,0x3
    80001ada:	58a78793          	addi	a5,a5,1418 # 80005060 <kernelvec>
    80001ade:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001ae2:	6422                	ld	s0,8(sp)
    80001ae4:	0141                	addi	sp,sp,16
    80001ae6:	8082                	ret

0000000080001ae8 <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    80001ae8:	1141                	addi	sp,sp,-16
    80001aea:	e406                	sd	ra,8(sp)
    80001aec:	e022                	sd	s0,0(sp)
    80001aee:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001af0:	fffff097          	auipc	ra,0xfffff
    80001af4:	358080e7          	jalr	856(ra) # 80000e48 <myproc>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001af8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001afc:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001afe:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001b02:	00005617          	auipc	a2,0x5
    80001b06:	4fe60613          	addi	a2,a2,1278 # 80007000 <_trampoline>
    80001b0a:	00005697          	auipc	a3,0x5
    80001b0e:	4f668693          	addi	a3,a3,1270 # 80007000 <_trampoline>
    80001b12:	8e91                	sub	a3,a3,a2
    80001b14:	040007b7          	lui	a5,0x4000
    80001b18:	17fd                	addi	a5,a5,-1
    80001b1a:	07b2                	slli	a5,a5,0xc
    80001b1c:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r"(x));
    80001b1e:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b22:	6158                	ld	a4,128(a0)
  asm volatile("csrr %0, satp" : "=r"(x));
    80001b24:	180026f3          	csrr	a3,satp
    80001b28:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b2a:	6158                	ld	a4,128(a0)
    80001b2c:	7534                	ld	a3,104(a0)
    80001b2e:	6585                	lui	a1,0x1
    80001b30:	96ae                	add	a3,a3,a1
    80001b32:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b34:	6158                	ld	a4,128(a0)
    80001b36:	00000697          	auipc	a3,0x0
    80001b3a:	13868693          	addi	a3,a3,312 # 80001c6e <usertrap>
    80001b3e:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80001b40:	6158                	ld	a4,128(a0)
  asm volatile("mv %0, tp" : "=r"(x));
    80001b42:	8692                	mv	a3,tp
    80001b44:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001b46:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b4a:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b4e:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001b52:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b56:	6158                	ld	a4,128(a0)
  asm volatile("csrw sepc, %0" : : "r"(x));
    80001b58:	6f18                	ld	a4,24(a4)
    80001b5a:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b5e:	7d2c                	ld	a1,120(a0)
    80001b60:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001b62:	00005717          	auipc	a4,0x5
    80001b66:	52e70713          	addi	a4,a4,1326 # 80007090 <userret>
    80001b6a:	8f11                	sub	a4,a4,a2
    80001b6c:	97ba                	add	a5,a5,a4
  ((void (*)(uint64, uint64))fn)(TRAPFRAME, satp);
    80001b6e:	577d                	li	a4,-1
    80001b70:	177e                	slli	a4,a4,0x3f
    80001b72:	8dd9                	or	a1,a1,a4
    80001b74:	02000537          	lui	a0,0x2000
    80001b78:	157d                	addi	a0,a0,-1
    80001b7a:	0536                	slli	a0,a0,0xd
    80001b7c:	9782                	jalr	a5
}
    80001b7e:	60a2                	ld	ra,8(sp)
    80001b80:	6402                	ld	s0,0(sp)
    80001b82:	0141                	addi	sp,sp,16
    80001b84:	8082                	ret

0000000080001b86 <clockintr>:
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr()
{
    80001b86:	1101                	addi	sp,sp,-32
    80001b88:	ec06                	sd	ra,24(sp)
    80001b8a:	e822                	sd	s0,16(sp)
    80001b8c:	e426                	sd	s1,8(sp)
    80001b8e:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001b90:	0000e497          	auipc	s1,0xe
    80001b94:	0f048493          	addi	s1,s1,240 # 8000fc80 <tickslock>
    80001b98:	8526                	mv	a0,s1
    80001b9a:	00004097          	auipc	ra,0x4
    80001b9e:	65e080e7          	jalr	1630(ra) # 800061f8 <acquire>
  ticks++;
    80001ba2:	00007517          	auipc	a0,0x7
    80001ba6:	47650513          	addi	a0,a0,1142 # 80009018 <ticks>
    80001baa:	411c                	lw	a5,0(a0)
    80001bac:	2785                	addiw	a5,a5,1
    80001bae:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001bb0:	00000097          	auipc	ra,0x0
    80001bb4:	b1c080e7          	jalr	-1252(ra) # 800016cc <wakeup>
  release(&tickslock);
    80001bb8:	8526                	mv	a0,s1
    80001bba:	00004097          	auipc	ra,0x4
    80001bbe:	6f2080e7          	jalr	1778(ra) # 800062ac <release>
}
    80001bc2:	60e2                	ld	ra,24(sp)
    80001bc4:	6442                	ld	s0,16(sp)
    80001bc6:	64a2                	ld	s1,8(sp)
    80001bc8:	6105                	addi	sp,sp,32
    80001bca:	8082                	ret

0000000080001bcc <devintr>:
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int devintr()
{
    80001bcc:	1101                	addi	sp,sp,-32
    80001bce:	ec06                	sd	ra,24(sp)
    80001bd0:	e822                	sd	s0,16(sp)
    80001bd2:	e426                	sd	s1,8(sp)
    80001bd4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r"(x));
    80001bd6:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if ((scause & 0x8000000000000000L) &&
    80001bda:	00074d63          	bltz	a4,80001bf4 <devintr+0x28>
    if (irq)
      plic_complete(irq);

    return 1;
  }
  else if (scause == 0x8000000000000001L)
    80001bde:	57fd                	li	a5,-1
    80001be0:	17fe                	slli	a5,a5,0x3f
    80001be2:	0785                	addi	a5,a5,1

    return 2;
  }
  else
  {
    return 0;
    80001be4:	4501                	li	a0,0
  else if (scause == 0x8000000000000001L)
    80001be6:	06f70363          	beq	a4,a5,80001c4c <devintr+0x80>
  }
}
    80001bea:	60e2                	ld	ra,24(sp)
    80001bec:	6442                	ld	s0,16(sp)
    80001bee:	64a2                	ld	s1,8(sp)
    80001bf0:	6105                	addi	sp,sp,32
    80001bf2:	8082                	ret
      (scause & 0xff) == 9)
    80001bf4:	0ff77793          	andi	a5,a4,255
  if ((scause & 0x8000000000000000L) &&
    80001bf8:	46a5                	li	a3,9
    80001bfa:	fed792e3          	bne	a5,a3,80001bde <devintr+0x12>
    int irq = plic_claim();
    80001bfe:	00003097          	auipc	ra,0x3
    80001c02:	56a080e7          	jalr	1386(ra) # 80005168 <plic_claim>
    80001c06:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ)
    80001c08:	47a9                	li	a5,10
    80001c0a:	02f50763          	beq	a0,a5,80001c38 <devintr+0x6c>
    else if (irq == VIRTIO0_IRQ)
    80001c0e:	4785                	li	a5,1
    80001c10:	02f50963          	beq	a0,a5,80001c42 <devintr+0x76>
    return 1;
    80001c14:	4505                	li	a0,1
    else if (irq)
    80001c16:	d8f1                	beqz	s1,80001bea <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c18:	85a6                	mv	a1,s1
    80001c1a:	00006517          	auipc	a0,0x6
    80001c1e:	65e50513          	addi	a0,a0,1630 # 80008278 <states.1721+0x38>
    80001c22:	00004097          	auipc	ra,0x4
    80001c26:	080080e7          	jalr	128(ra) # 80005ca2 <printf>
      plic_complete(irq);
    80001c2a:	8526                	mv	a0,s1
    80001c2c:	00003097          	auipc	ra,0x3
    80001c30:	560080e7          	jalr	1376(ra) # 8000518c <plic_complete>
    return 1;
    80001c34:	4505                	li	a0,1
    80001c36:	bf55                	j	80001bea <devintr+0x1e>
      uartintr();
    80001c38:	00004097          	auipc	ra,0x4
    80001c3c:	4e0080e7          	jalr	1248(ra) # 80006118 <uartintr>
    80001c40:	b7ed                	j	80001c2a <devintr+0x5e>
      virtio_disk_intr();
    80001c42:	00004097          	auipc	ra,0x4
    80001c46:	a2a080e7          	jalr	-1494(ra) # 8000566c <virtio_disk_intr>
    80001c4a:	b7c5                	j	80001c2a <devintr+0x5e>
    if (cpuid() == 0)
    80001c4c:	fffff097          	auipc	ra,0xfffff
    80001c50:	1d0080e7          	jalr	464(ra) # 80000e1c <cpuid>
    80001c54:	c901                	beqz	a0,80001c64 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r"(x));
    80001c56:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c5a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r"(x));
    80001c5c:	14479073          	csrw	sip,a5
    return 2;
    80001c60:	4509                	li	a0,2
    80001c62:	b761                	j	80001bea <devintr+0x1e>
      clockintr();
    80001c64:	00000097          	auipc	ra,0x0
    80001c68:	f22080e7          	jalr	-222(ra) # 80001b86 <clockintr>
    80001c6c:	b7ed                	j	80001c56 <devintr+0x8a>

0000000080001c6e <usertrap>:
{
    80001c6e:	1101                	addi	sp,sp,-32
    80001c70:	ec06                	sd	ra,24(sp)
    80001c72:	e822                	sd	s0,16(sp)
    80001c74:	e426                	sd	s1,8(sp)
    80001c76:	e04a                	sd	s2,0(sp)
    80001c78:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001c7a:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    80001c7e:	1007f793          	andi	a5,a5,256
    80001c82:	efa5                	bnez	a5,80001cfa <usertrap+0x8c>
  asm volatile("csrw stvec, %0" : : "r"(x));
    80001c84:	00003797          	auipc	a5,0x3
    80001c88:	3dc78793          	addi	a5,a5,988 # 80005060 <kernelvec>
    80001c8c:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001c90:	fffff097          	auipc	ra,0xfffff
    80001c94:	1b8080e7          	jalr	440(ra) # 80000e48 <myproc>
    80001c98:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001c9a:	615c                	ld	a5,128(a0)
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001c9c:	14102773          	csrr	a4,sepc
    80001ca0:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r"(x));
    80001ca2:	14202773          	csrr	a4,scause
  if (r_scause() == 8)
    80001ca6:	47a1                	li	a5,8
    80001ca8:	06f71763          	bne	a4,a5,80001d16 <usertrap+0xa8>
    if (p->killed)
    80001cac:	551c                	lw	a5,40(a0)
    80001cae:	efb1                	bnez	a5,80001d0a <usertrap+0x9c>
    p->trapframe->epc += 4;
    80001cb0:	60d8                	ld	a4,128(s1)
    80001cb2:	6f1c                	ld	a5,24(a4)
    80001cb4:	0791                	addi	a5,a5,4
    80001cb6:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001cb8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001cbc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001cc0:	10079073          	csrw	sstatus,a5
    syscall();
    80001cc4:	00000097          	auipc	ra,0x0
    80001cc8:	32a080e7          	jalr	810(ra) # 80001fee <syscall>
  int which_dev = 0;
    80001ccc:	4901                	li	s2,0
  if (p->killed)
    80001cce:	549c                	lw	a5,40(s1)
    80001cd0:	e3d1                	bnez	a5,80001d54 <usertrap+0xe6>
  if ((which_dev == devintr()) != 0)
    80001cd2:	00000097          	auipc	ra,0x0
    80001cd6:	efa080e7          	jalr	-262(ra) # 80001bcc <devintr>
    80001cda:	09250363          	beq	a0,s2,80001d60 <usertrap+0xf2>
  yield();
    80001cde:	00000097          	auipc	ra,0x0
    80001ce2:	826080e7          	jalr	-2010(ra) # 80001504 <yield>
  usertrapret();
    80001ce6:	00000097          	auipc	ra,0x0
    80001cea:	e02080e7          	jalr	-510(ra) # 80001ae8 <usertrapret>
}
    80001cee:	60e2                	ld	ra,24(sp)
    80001cf0:	6442                	ld	s0,16(sp)
    80001cf2:	64a2                	ld	s1,8(sp)
    80001cf4:	6902                	ld	s2,0(sp)
    80001cf6:	6105                	addi	sp,sp,32
    80001cf8:	8082                	ret
    panic("usertrap: not from user mode");
    80001cfa:	00006517          	auipc	a0,0x6
    80001cfe:	59e50513          	addi	a0,a0,1438 # 80008298 <states.1721+0x58>
    80001d02:	00004097          	auipc	ra,0x4
    80001d06:	f56080e7          	jalr	-170(ra) # 80005c58 <panic>
      exit(-1);
    80001d0a:	557d                	li	a0,-1
    80001d0c:	00000097          	auipc	ra,0x0
    80001d10:	a90080e7          	jalr	-1392(ra) # 8000179c <exit>
    80001d14:	bf71                	j	80001cb0 <usertrap+0x42>
  else if ((which_dev = devintr()) != 0)
    80001d16:	00000097          	auipc	ra,0x0
    80001d1a:	eb6080e7          	jalr	-330(ra) # 80001bcc <devintr>
    80001d1e:	892a                	mv	s2,a0
    80001d20:	f55d                	bnez	a0,80001cce <usertrap+0x60>
  asm volatile("csrr %0, scause" : "=r"(x));
    80001d22:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d26:	5890                	lw	a2,48(s1)
    80001d28:	00006517          	auipc	a0,0x6
    80001d2c:	59050513          	addi	a0,a0,1424 # 800082b8 <states.1721+0x78>
    80001d30:	00004097          	auipc	ra,0x4
    80001d34:	f72080e7          	jalr	-142(ra) # 80005ca2 <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001d38:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80001d3c:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d40:	00006517          	auipc	a0,0x6
    80001d44:	5a850513          	addi	a0,a0,1448 # 800082e8 <states.1721+0xa8>
    80001d48:	00004097          	auipc	ra,0x4
    80001d4c:	f5a080e7          	jalr	-166(ra) # 80005ca2 <printf>
    p->killed = 1;
    80001d50:	4785                	li	a5,1
    80001d52:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001d54:	557d                	li	a0,-1
    80001d56:	00000097          	auipc	ra,0x0
    80001d5a:	a46080e7          	jalr	-1466(ra) # 8000179c <exit>
    80001d5e:	bf95                	j	80001cd2 <usertrap+0x64>
    if (which_dev == 2)
    80001d60:	4789                	li	a5,2
    80001d62:	f6f91ee3          	bne	s2,a5,80001cde <usertrap+0x70>
      struct proc *p = myproc();
    80001d66:	fffff097          	auipc	ra,0xfffff
    80001d6a:	0e2080e7          	jalr	226(ra) # 80000e48 <myproc>
    80001d6e:	84aa                	mv	s1,a0
      if (p->alarm_on)
    80001d70:	4d3c                	lw	a5,88(a0)
    80001d72:	d7b5                	beqz	a5,80001cde <usertrap+0x70>
        p->ticks++;
    80001d74:	693c                	ld	a5,80(a0)
    80001d76:	0785                	addi	a5,a5,1
    80001d78:	e93c                	sd	a5,80(a0)
        if (p->ticks >= p->alarm_inteval)
    80001d7a:	4138                	lw	a4,64(a0)
    80001d7c:	f6e7e1e3          	bltu	a5,a4,80001cde <usertrap+0x70>
          p->ticks = 0;
    80001d80:	04053823          	sd	zero,80(a0)
          if (p->alarm_trapframe == 0)
    80001d84:	7128                	ld	a0,96(a0)
    80001d86:	cd01                	beqz	a0,80001d9e <usertrap+0x130>
            memmove(p->alarm_trapframe, p->trapframe, sizeof(struct trapframe));
    80001d88:	12000613          	li	a2,288
    80001d8c:	60cc                	ld	a1,128(s1)
    80001d8e:	ffffe097          	auipc	ra,0xffffe
    80001d92:	44a080e7          	jalr	1098(ra) # 800001d8 <memmove>
            p->trapframe->epc = p->handler;
    80001d96:	60dc                	ld	a5,128(s1)
    80001d98:	64b8                	ld	a4,72(s1)
    80001d9a:	ef98                	sd	a4,24(a5)
    80001d9c:	b789                	j	80001cde <usertrap+0x70>
            p->alarm_trapframe = kalloc();
    80001d9e:	ffffe097          	auipc	ra,0xffffe
    80001da2:	37a080e7          	jalr	890(ra) # 80000118 <kalloc>
    80001da6:	f0a8                	sd	a0,96(s1)
          if (p->alarm_trapframe)
    80001da8:	d91d                	beqz	a0,80001cde <usertrap+0x70>
    80001daa:	bff9                	j	80001d88 <usertrap+0x11a>

0000000080001dac <kerneltrap>:
{
    80001dac:	7179                	addi	sp,sp,-48
    80001dae:	f406                	sd	ra,40(sp)
    80001db0:	f022                	sd	s0,32(sp)
    80001db2:	ec26                	sd	s1,24(sp)
    80001db4:	e84a                	sd	s2,16(sp)
    80001db6:	e44e                	sd	s3,8(sp)
    80001db8:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001dba:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001dbe:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r"(x));
    80001dc2:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    80001dc6:	1004f793          	andi	a5,s1,256
    80001dca:	cb85                	beqz	a5,80001dfa <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001dcc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001dd0:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    80001dd2:	ef85                	bnez	a5,80001e0a <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0)
    80001dd4:	00000097          	auipc	ra,0x0
    80001dd8:	df8080e7          	jalr	-520(ra) # 80001bcc <devintr>
    80001ddc:	cd1d                	beqz	a0,80001e1a <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001dde:	4789                	li	a5,2
    80001de0:	06f50a63          	beq	a0,a5,80001e54 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r"(x));
    80001de4:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001de8:	10049073          	csrw	sstatus,s1
}
    80001dec:	70a2                	ld	ra,40(sp)
    80001dee:	7402                	ld	s0,32(sp)
    80001df0:	64e2                	ld	s1,24(sp)
    80001df2:	6942                	ld	s2,16(sp)
    80001df4:	69a2                	ld	s3,8(sp)
    80001df6:	6145                	addi	sp,sp,48
    80001df8:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001dfa:	00006517          	auipc	a0,0x6
    80001dfe:	50e50513          	addi	a0,a0,1294 # 80008308 <states.1721+0xc8>
    80001e02:	00004097          	auipc	ra,0x4
    80001e06:	e56080e7          	jalr	-426(ra) # 80005c58 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e0a:	00006517          	auipc	a0,0x6
    80001e0e:	52650513          	addi	a0,a0,1318 # 80008330 <states.1721+0xf0>
    80001e12:	00004097          	auipc	ra,0x4
    80001e16:	e46080e7          	jalr	-442(ra) # 80005c58 <panic>
    printf("scause %p\n", scause);
    80001e1a:	85ce                	mv	a1,s3
    80001e1c:	00006517          	auipc	a0,0x6
    80001e20:	53450513          	addi	a0,a0,1332 # 80008350 <states.1721+0x110>
    80001e24:	00004097          	auipc	ra,0x4
    80001e28:	e7e080e7          	jalr	-386(ra) # 80005ca2 <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001e2c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80001e30:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e34:	00006517          	auipc	a0,0x6
    80001e38:	52c50513          	addi	a0,a0,1324 # 80008360 <states.1721+0x120>
    80001e3c:	00004097          	auipc	ra,0x4
    80001e40:	e66080e7          	jalr	-410(ra) # 80005ca2 <printf>
    panic("kerneltrap");
    80001e44:	00006517          	auipc	a0,0x6
    80001e48:	53450513          	addi	a0,a0,1332 # 80008378 <states.1721+0x138>
    80001e4c:	00004097          	auipc	ra,0x4
    80001e50:	e0c080e7          	jalr	-500(ra) # 80005c58 <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e54:	fffff097          	auipc	ra,0xfffff
    80001e58:	ff4080e7          	jalr	-12(ra) # 80000e48 <myproc>
    80001e5c:	d541                	beqz	a0,80001de4 <kerneltrap+0x38>
    80001e5e:	fffff097          	auipc	ra,0xfffff
    80001e62:	fea080e7          	jalr	-22(ra) # 80000e48 <myproc>
    80001e66:	4d18                	lw	a4,24(a0)
    80001e68:	4791                	li	a5,4
    80001e6a:	f6f71de3          	bne	a4,a5,80001de4 <kerneltrap+0x38>
    yield();
    80001e6e:	fffff097          	auipc	ra,0xfffff
    80001e72:	696080e7          	jalr	1686(ra) # 80001504 <yield>
    80001e76:	b7bd                	j	80001de4 <kerneltrap+0x38>

0000000080001e78 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e78:	1101                	addi	sp,sp,-32
    80001e7a:	ec06                	sd	ra,24(sp)
    80001e7c:	e822                	sd	s0,16(sp)
    80001e7e:	e426                	sd	s1,8(sp)
    80001e80:	1000                	addi	s0,sp,32
    80001e82:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e84:	fffff097          	auipc	ra,0xfffff
    80001e88:	fc4080e7          	jalr	-60(ra) # 80000e48 <myproc>
  switch (n)
    80001e8c:	4795                	li	a5,5
    80001e8e:	0497e163          	bltu	a5,s1,80001ed0 <argraw+0x58>
    80001e92:	048a                	slli	s1,s1,0x2
    80001e94:	00006717          	auipc	a4,0x6
    80001e98:	51c70713          	addi	a4,a4,1308 # 800083b0 <states.1721+0x170>
    80001e9c:	94ba                	add	s1,s1,a4
    80001e9e:	409c                	lw	a5,0(s1)
    80001ea0:	97ba                	add	a5,a5,a4
    80001ea2:	8782                	jr	a5
  {
  case 0:
    return p->trapframe->a0;
    80001ea4:	615c                	ld	a5,128(a0)
    80001ea6:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001ea8:	60e2                	ld	ra,24(sp)
    80001eaa:	6442                	ld	s0,16(sp)
    80001eac:	64a2                	ld	s1,8(sp)
    80001eae:	6105                	addi	sp,sp,32
    80001eb0:	8082                	ret
    return p->trapframe->a1;
    80001eb2:	615c                	ld	a5,128(a0)
    80001eb4:	7fa8                	ld	a0,120(a5)
    80001eb6:	bfcd                	j	80001ea8 <argraw+0x30>
    return p->trapframe->a2;
    80001eb8:	615c                	ld	a5,128(a0)
    80001eba:	63c8                	ld	a0,128(a5)
    80001ebc:	b7f5                	j	80001ea8 <argraw+0x30>
    return p->trapframe->a3;
    80001ebe:	615c                	ld	a5,128(a0)
    80001ec0:	67c8                	ld	a0,136(a5)
    80001ec2:	b7dd                	j	80001ea8 <argraw+0x30>
    return p->trapframe->a4;
    80001ec4:	615c                	ld	a5,128(a0)
    80001ec6:	6bc8                	ld	a0,144(a5)
    80001ec8:	b7c5                	j	80001ea8 <argraw+0x30>
    return p->trapframe->a5;
    80001eca:	615c                	ld	a5,128(a0)
    80001ecc:	6fc8                	ld	a0,152(a5)
    80001ece:	bfe9                	j	80001ea8 <argraw+0x30>
  panic("argraw");
    80001ed0:	00006517          	auipc	a0,0x6
    80001ed4:	4b850513          	addi	a0,a0,1208 # 80008388 <states.1721+0x148>
    80001ed8:	00004097          	auipc	ra,0x4
    80001edc:	d80080e7          	jalr	-640(ra) # 80005c58 <panic>

0000000080001ee0 <fetchaddr>:
{
    80001ee0:	1101                	addi	sp,sp,-32
    80001ee2:	ec06                	sd	ra,24(sp)
    80001ee4:	e822                	sd	s0,16(sp)
    80001ee6:	e426                	sd	s1,8(sp)
    80001ee8:	e04a                	sd	s2,0(sp)
    80001eea:	1000                	addi	s0,sp,32
    80001eec:	84aa                	mv	s1,a0
    80001eee:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001ef0:	fffff097          	auipc	ra,0xfffff
    80001ef4:	f58080e7          	jalr	-168(ra) # 80000e48 <myproc>
  if (addr >= p->sz || addr + sizeof(uint64) > p->sz)
    80001ef8:	793c                	ld	a5,112(a0)
    80001efa:	02f4f863          	bgeu	s1,a5,80001f2a <fetchaddr+0x4a>
    80001efe:	00848713          	addi	a4,s1,8
    80001f02:	02e7e663          	bltu	a5,a4,80001f2e <fetchaddr+0x4e>
  if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f06:	46a1                	li	a3,8
    80001f08:	8626                	mv	a2,s1
    80001f0a:	85ca                	mv	a1,s2
    80001f0c:	7d28                	ld	a0,120(a0)
    80001f0e:	fffff097          	auipc	ra,0xfffff
    80001f12:	c88080e7          	jalr	-888(ra) # 80000b96 <copyin>
    80001f16:	00a03533          	snez	a0,a0
    80001f1a:	40a00533          	neg	a0,a0
}
    80001f1e:	60e2                	ld	ra,24(sp)
    80001f20:	6442                	ld	s0,16(sp)
    80001f22:	64a2                	ld	s1,8(sp)
    80001f24:	6902                	ld	s2,0(sp)
    80001f26:	6105                	addi	sp,sp,32
    80001f28:	8082                	ret
    return -1;
    80001f2a:	557d                	li	a0,-1
    80001f2c:	bfcd                	j	80001f1e <fetchaddr+0x3e>
    80001f2e:	557d                	li	a0,-1
    80001f30:	b7fd                	j	80001f1e <fetchaddr+0x3e>

0000000080001f32 <fetchstr>:
{
    80001f32:	7179                	addi	sp,sp,-48
    80001f34:	f406                	sd	ra,40(sp)
    80001f36:	f022                	sd	s0,32(sp)
    80001f38:	ec26                	sd	s1,24(sp)
    80001f3a:	e84a                	sd	s2,16(sp)
    80001f3c:	e44e                	sd	s3,8(sp)
    80001f3e:	1800                	addi	s0,sp,48
    80001f40:	892a                	mv	s2,a0
    80001f42:	84ae                	mv	s1,a1
    80001f44:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f46:	fffff097          	auipc	ra,0xfffff
    80001f4a:	f02080e7          	jalr	-254(ra) # 80000e48 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001f4e:	86ce                	mv	a3,s3
    80001f50:	864a                	mv	a2,s2
    80001f52:	85a6                	mv	a1,s1
    80001f54:	7d28                	ld	a0,120(a0)
    80001f56:	fffff097          	auipc	ra,0xfffff
    80001f5a:	ccc080e7          	jalr	-820(ra) # 80000c22 <copyinstr>
  if (err < 0)
    80001f5e:	00054763          	bltz	a0,80001f6c <fetchstr+0x3a>
  return strlen(buf);
    80001f62:	8526                	mv	a0,s1
    80001f64:	ffffe097          	auipc	ra,0xffffe
    80001f68:	398080e7          	jalr	920(ra) # 800002fc <strlen>
}
    80001f6c:	70a2                	ld	ra,40(sp)
    80001f6e:	7402                	ld	s0,32(sp)
    80001f70:	64e2                	ld	s1,24(sp)
    80001f72:	6942                	ld	s2,16(sp)
    80001f74:	69a2                	ld	s3,8(sp)
    80001f76:	6145                	addi	sp,sp,48
    80001f78:	8082                	ret

0000000080001f7a <argint>:

// Fetch the nth 32-bit system call argument.
int argint(int n, int *ip)
{
    80001f7a:	1101                	addi	sp,sp,-32
    80001f7c:	ec06                	sd	ra,24(sp)
    80001f7e:	e822                	sd	s0,16(sp)
    80001f80:	e426                	sd	s1,8(sp)
    80001f82:	1000                	addi	s0,sp,32
    80001f84:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f86:	00000097          	auipc	ra,0x0
    80001f8a:	ef2080e7          	jalr	-270(ra) # 80001e78 <argraw>
    80001f8e:	c088                	sw	a0,0(s1)
  return 0;
}
    80001f90:	4501                	li	a0,0
    80001f92:	60e2                	ld	ra,24(sp)
    80001f94:	6442                	ld	s0,16(sp)
    80001f96:	64a2                	ld	s1,8(sp)
    80001f98:	6105                	addi	sp,sp,32
    80001f9a:	8082                	ret

0000000080001f9c <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int argaddr(int n, uint64 *ip)
{
    80001f9c:	1101                	addi	sp,sp,-32
    80001f9e:	ec06                	sd	ra,24(sp)
    80001fa0:	e822                	sd	s0,16(sp)
    80001fa2:	e426                	sd	s1,8(sp)
    80001fa4:	1000                	addi	s0,sp,32
    80001fa6:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fa8:	00000097          	auipc	ra,0x0
    80001fac:	ed0080e7          	jalr	-304(ra) # 80001e78 <argraw>
    80001fb0:	e088                	sd	a0,0(s1)
  return 0;
}
    80001fb2:	4501                	li	a0,0
    80001fb4:	60e2                	ld	ra,24(sp)
    80001fb6:	6442                	ld	s0,16(sp)
    80001fb8:	64a2                	ld	s1,8(sp)
    80001fba:	6105                	addi	sp,sp,32
    80001fbc:	8082                	ret

0000000080001fbe <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max)
{
    80001fbe:	1101                	addi	sp,sp,-32
    80001fc0:	ec06                	sd	ra,24(sp)
    80001fc2:	e822                	sd	s0,16(sp)
    80001fc4:	e426                	sd	s1,8(sp)
    80001fc6:	e04a                	sd	s2,0(sp)
    80001fc8:	1000                	addi	s0,sp,32
    80001fca:	84ae                	mv	s1,a1
    80001fcc:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001fce:	00000097          	auipc	ra,0x0
    80001fd2:	eaa080e7          	jalr	-342(ra) # 80001e78 <argraw>
  uint64 addr;
  if (argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001fd6:	864a                	mv	a2,s2
    80001fd8:	85a6                	mv	a1,s1
    80001fda:	00000097          	auipc	ra,0x0
    80001fde:	f58080e7          	jalr	-168(ra) # 80001f32 <fetchstr>
}
    80001fe2:	60e2                	ld	ra,24(sp)
    80001fe4:	6442                	ld	s0,16(sp)
    80001fe6:	64a2                	ld	s1,8(sp)
    80001fe8:	6902                	ld	s2,0(sp)
    80001fea:	6105                	addi	sp,sp,32
    80001fec:	8082                	ret

0000000080001fee <syscall>:
    [SYS_sigalarm] sys_sigalarm,
    [SYS_sigreturn] sys_sigreturn,
};

void syscall(void)
{
    80001fee:	1101                	addi	sp,sp,-32
    80001ff0:	ec06                	sd	ra,24(sp)
    80001ff2:	e822                	sd	s0,16(sp)
    80001ff4:	e426                	sd	s1,8(sp)
    80001ff6:	e04a                	sd	s2,0(sp)
    80001ff8:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001ffa:	fffff097          	auipc	ra,0xfffff
    80001ffe:	e4e080e7          	jalr	-434(ra) # 80000e48 <myproc>
    80002002:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002004:	08053903          	ld	s2,128(a0)
    80002008:	0a893783          	ld	a5,168(s2)
    8000200c:	0007869b          	sext.w	a3,a5
  if (num > 0 && num < NELEM(syscalls) && syscalls[num])
    80002010:	37fd                	addiw	a5,a5,-1
    80002012:	4759                	li	a4,22
    80002014:	00f76f63          	bltu	a4,a5,80002032 <syscall+0x44>
    80002018:	00369713          	slli	a4,a3,0x3
    8000201c:	00006797          	auipc	a5,0x6
    80002020:	3ac78793          	addi	a5,a5,940 # 800083c8 <syscalls>
    80002024:	97ba                	add	a5,a5,a4
    80002026:	639c                	ld	a5,0(a5)
    80002028:	c789                	beqz	a5,80002032 <syscall+0x44>
  {
    p->trapframe->a0 = syscalls[num]();
    8000202a:	9782                	jalr	a5
    8000202c:	06a93823          	sd	a0,112(s2)
    80002030:	a839                	j	8000204e <syscall+0x60>
  }
  else
  {
    printf("%d %s: unknown sys call %d\n",
    80002032:	18048613          	addi	a2,s1,384
    80002036:	588c                	lw	a1,48(s1)
    80002038:	00006517          	auipc	a0,0x6
    8000203c:	35850513          	addi	a0,a0,856 # 80008390 <states.1721+0x150>
    80002040:	00004097          	auipc	ra,0x4
    80002044:	c62080e7          	jalr	-926(ra) # 80005ca2 <printf>
           p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002048:	60dc                	ld	a5,128(s1)
    8000204a:	577d                	li	a4,-1
    8000204c:	fbb8                	sd	a4,112(a5)
  }
}
    8000204e:	60e2                	ld	ra,24(sp)
    80002050:	6442                	ld	s0,16(sp)
    80002052:	64a2                	ld	s1,8(sp)
    80002054:	6902                	ld	s2,0(sp)
    80002056:	6105                	addi	sp,sp,32
    80002058:	8082                	ret

000000008000205a <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000205a:	1101                	addi	sp,sp,-32
    8000205c:	ec06                	sd	ra,24(sp)
    8000205e:	e822                	sd	s0,16(sp)
    80002060:	1000                	addi	s0,sp,32
  int n;
  if (argint(0, &n) < 0)
    80002062:	fec40593          	addi	a1,s0,-20
    80002066:	4501                	li	a0,0
    80002068:	00000097          	auipc	ra,0x0
    8000206c:	f12080e7          	jalr	-238(ra) # 80001f7a <argint>
    return -1;
    80002070:	57fd                	li	a5,-1
  if (argint(0, &n) < 0)
    80002072:	00054963          	bltz	a0,80002084 <sys_exit+0x2a>
  exit(n);
    80002076:	fec42503          	lw	a0,-20(s0)
    8000207a:	fffff097          	auipc	ra,0xfffff
    8000207e:	722080e7          	jalr	1826(ra) # 8000179c <exit>
  return 0; // not reached
    80002082:	4781                	li	a5,0
}
    80002084:	853e                	mv	a0,a5
    80002086:	60e2                	ld	ra,24(sp)
    80002088:	6442                	ld	s0,16(sp)
    8000208a:	6105                	addi	sp,sp,32
    8000208c:	8082                	ret

000000008000208e <sys_getpid>:

uint64
sys_getpid(void)
{
    8000208e:	1141                	addi	sp,sp,-16
    80002090:	e406                	sd	ra,8(sp)
    80002092:	e022                	sd	s0,0(sp)
    80002094:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002096:	fffff097          	auipc	ra,0xfffff
    8000209a:	db2080e7          	jalr	-590(ra) # 80000e48 <myproc>
}
    8000209e:	5908                	lw	a0,48(a0)
    800020a0:	60a2                	ld	ra,8(sp)
    800020a2:	6402                	ld	s0,0(sp)
    800020a4:	0141                	addi	sp,sp,16
    800020a6:	8082                	ret

00000000800020a8 <sys_fork>:

uint64
sys_fork(void)
{
    800020a8:	1141                	addi	sp,sp,-16
    800020aa:	e406                	sd	ra,8(sp)
    800020ac:	e022                	sd	s0,0(sp)
    800020ae:	0800                	addi	s0,sp,16
  return fork();
    800020b0:	fffff097          	auipc	ra,0xfffff
    800020b4:	1a2080e7          	jalr	418(ra) # 80001252 <fork>
}
    800020b8:	60a2                	ld	ra,8(sp)
    800020ba:	6402                	ld	s0,0(sp)
    800020bc:	0141                	addi	sp,sp,16
    800020be:	8082                	ret

00000000800020c0 <sys_wait>:

uint64
sys_wait(void)
{
    800020c0:	1101                	addi	sp,sp,-32
    800020c2:	ec06                	sd	ra,24(sp)
    800020c4:	e822                	sd	s0,16(sp)
    800020c6:	1000                	addi	s0,sp,32
  uint64 p;
  if (argaddr(0, &p) < 0)
    800020c8:	fe840593          	addi	a1,s0,-24
    800020cc:	4501                	li	a0,0
    800020ce:	00000097          	auipc	ra,0x0
    800020d2:	ece080e7          	jalr	-306(ra) # 80001f9c <argaddr>
    800020d6:	87aa                	mv	a5,a0
    return -1;
    800020d8:	557d                	li	a0,-1
  if (argaddr(0, &p) < 0)
    800020da:	0007c863          	bltz	a5,800020ea <sys_wait+0x2a>
  return wait(p);
    800020de:	fe843503          	ld	a0,-24(s0)
    800020e2:	fffff097          	auipc	ra,0xfffff
    800020e6:	4c2080e7          	jalr	1218(ra) # 800015a4 <wait>
}
    800020ea:	60e2                	ld	ra,24(sp)
    800020ec:	6442                	ld	s0,16(sp)
    800020ee:	6105                	addi	sp,sp,32
    800020f0:	8082                	ret

00000000800020f2 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800020f2:	7179                	addi	sp,sp,-48
    800020f4:	f406                	sd	ra,40(sp)
    800020f6:	f022                	sd	s0,32(sp)
    800020f8:	ec26                	sd	s1,24(sp)
    800020fa:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if (argint(0, &n) < 0)
    800020fc:	fdc40593          	addi	a1,s0,-36
    80002100:	4501                	li	a0,0
    80002102:	00000097          	auipc	ra,0x0
    80002106:	e78080e7          	jalr	-392(ra) # 80001f7a <argint>
    8000210a:	87aa                	mv	a5,a0
    return -1;
    8000210c:	557d                	li	a0,-1
  if (argint(0, &n) < 0)
    8000210e:	0207c063          	bltz	a5,8000212e <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002112:	fffff097          	auipc	ra,0xfffff
    80002116:	d36080e7          	jalr	-714(ra) # 80000e48 <myproc>
    8000211a:	5924                	lw	s1,112(a0)
  if (growproc(n) < 0)
    8000211c:	fdc42503          	lw	a0,-36(s0)
    80002120:	fffff097          	auipc	ra,0xfffff
    80002124:	0be080e7          	jalr	190(ra) # 800011de <growproc>
    80002128:	00054863          	bltz	a0,80002138 <sys_sbrk+0x46>
    return -1;
  return addr;
    8000212c:	8526                	mv	a0,s1
}
    8000212e:	70a2                	ld	ra,40(sp)
    80002130:	7402                	ld	s0,32(sp)
    80002132:	64e2                	ld	s1,24(sp)
    80002134:	6145                	addi	sp,sp,48
    80002136:	8082                	ret
    return -1;
    80002138:	557d                	li	a0,-1
    8000213a:	bfd5                	j	8000212e <sys_sbrk+0x3c>

000000008000213c <sys_sleep>:

uint64
sys_sleep(void)
{
    8000213c:	7139                	addi	sp,sp,-64
    8000213e:	fc06                	sd	ra,56(sp)
    80002140:	f822                	sd	s0,48(sp)
    80002142:	f426                	sd	s1,40(sp)
    80002144:	f04a                	sd	s2,32(sp)
    80002146:	ec4e                	sd	s3,24(sp)
    80002148:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;
  backtrace();
    8000214a:	00004097          	auipc	ra,0x4
    8000214e:	d70080e7          	jalr	-656(ra) # 80005eba <backtrace>
  if (argint(0, &n) < 0)
    80002152:	fcc40593          	addi	a1,s0,-52
    80002156:	4501                	li	a0,0
    80002158:	00000097          	auipc	ra,0x0
    8000215c:	e22080e7          	jalr	-478(ra) # 80001f7a <argint>
    return -1;
    80002160:	57fd                	li	a5,-1
  if (argint(0, &n) < 0)
    80002162:	06054563          	bltz	a0,800021cc <sys_sleep+0x90>
  acquire(&tickslock);
    80002166:	0000e517          	auipc	a0,0xe
    8000216a:	b1a50513          	addi	a0,a0,-1254 # 8000fc80 <tickslock>
    8000216e:	00004097          	auipc	ra,0x4
    80002172:	08a080e7          	jalr	138(ra) # 800061f8 <acquire>
  ticks0 = ticks;
    80002176:	00007917          	auipc	s2,0x7
    8000217a:	ea292903          	lw	s2,-350(s2) # 80009018 <ticks>
  while (ticks - ticks0 < n)
    8000217e:	fcc42783          	lw	a5,-52(s0)
    80002182:	cf85                	beqz	a5,800021ba <sys_sleep+0x7e>
    if (myproc()->killed)
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002184:	0000e997          	auipc	s3,0xe
    80002188:	afc98993          	addi	s3,s3,-1284 # 8000fc80 <tickslock>
    8000218c:	00007497          	auipc	s1,0x7
    80002190:	e8c48493          	addi	s1,s1,-372 # 80009018 <ticks>
    if (myproc()->killed)
    80002194:	fffff097          	auipc	ra,0xfffff
    80002198:	cb4080e7          	jalr	-844(ra) # 80000e48 <myproc>
    8000219c:	551c                	lw	a5,40(a0)
    8000219e:	ef9d                	bnez	a5,800021dc <sys_sleep+0xa0>
    sleep(&ticks, &tickslock);
    800021a0:	85ce                	mv	a1,s3
    800021a2:	8526                	mv	a0,s1
    800021a4:	fffff097          	auipc	ra,0xfffff
    800021a8:	39c080e7          	jalr	924(ra) # 80001540 <sleep>
  while (ticks - ticks0 < n)
    800021ac:	409c                	lw	a5,0(s1)
    800021ae:	412787bb          	subw	a5,a5,s2
    800021b2:	fcc42703          	lw	a4,-52(s0)
    800021b6:	fce7efe3          	bltu	a5,a4,80002194 <sys_sleep+0x58>
  }
  release(&tickslock);
    800021ba:	0000e517          	auipc	a0,0xe
    800021be:	ac650513          	addi	a0,a0,-1338 # 8000fc80 <tickslock>
    800021c2:	00004097          	auipc	ra,0x4
    800021c6:	0ea080e7          	jalr	234(ra) # 800062ac <release>

  return 0;
    800021ca:	4781                	li	a5,0
}
    800021cc:	853e                	mv	a0,a5
    800021ce:	70e2                	ld	ra,56(sp)
    800021d0:	7442                	ld	s0,48(sp)
    800021d2:	74a2                	ld	s1,40(sp)
    800021d4:	7902                	ld	s2,32(sp)
    800021d6:	69e2                	ld	s3,24(sp)
    800021d8:	6121                	addi	sp,sp,64
    800021da:	8082                	ret
      release(&tickslock);
    800021dc:	0000e517          	auipc	a0,0xe
    800021e0:	aa450513          	addi	a0,a0,-1372 # 8000fc80 <tickslock>
    800021e4:	00004097          	auipc	ra,0x4
    800021e8:	0c8080e7          	jalr	200(ra) # 800062ac <release>
      return -1;
    800021ec:	57fd                	li	a5,-1
    800021ee:	bff9                	j	800021cc <sys_sleep+0x90>

00000000800021f0 <sys_kill>:

uint64
sys_kill(void)
{
    800021f0:	1101                	addi	sp,sp,-32
    800021f2:	ec06                	sd	ra,24(sp)
    800021f4:	e822                	sd	s0,16(sp)
    800021f6:	1000                	addi	s0,sp,32
  int pid;

  if (argint(0, &pid) < 0)
    800021f8:	fec40593          	addi	a1,s0,-20
    800021fc:	4501                	li	a0,0
    800021fe:	00000097          	auipc	ra,0x0
    80002202:	d7c080e7          	jalr	-644(ra) # 80001f7a <argint>
    80002206:	87aa                	mv	a5,a0
    return -1;
    80002208:	557d                	li	a0,-1
  if (argint(0, &pid) < 0)
    8000220a:	0007c863          	bltz	a5,8000221a <sys_kill+0x2a>
  return kill(pid);
    8000220e:	fec42503          	lw	a0,-20(s0)
    80002212:	fffff097          	auipc	ra,0xfffff
    80002216:	660080e7          	jalr	1632(ra) # 80001872 <kill>
}
    8000221a:	60e2                	ld	ra,24(sp)
    8000221c:	6442                	ld	s0,16(sp)
    8000221e:	6105                	addi	sp,sp,32
    80002220:	8082                	ret

0000000080002222 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002222:	1101                	addi	sp,sp,-32
    80002224:	ec06                	sd	ra,24(sp)
    80002226:	e822                	sd	s0,16(sp)
    80002228:	e426                	sd	s1,8(sp)
    8000222a:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000222c:	0000e517          	auipc	a0,0xe
    80002230:	a5450513          	addi	a0,a0,-1452 # 8000fc80 <tickslock>
    80002234:	00004097          	auipc	ra,0x4
    80002238:	fc4080e7          	jalr	-60(ra) # 800061f8 <acquire>
  xticks = ticks;
    8000223c:	00007497          	auipc	s1,0x7
    80002240:	ddc4a483          	lw	s1,-548(s1) # 80009018 <ticks>
  release(&tickslock);
    80002244:	0000e517          	auipc	a0,0xe
    80002248:	a3c50513          	addi	a0,a0,-1476 # 8000fc80 <tickslock>
    8000224c:	00004097          	auipc	ra,0x4
    80002250:	060080e7          	jalr	96(ra) # 800062ac <release>
  return xticks;
}
    80002254:	02049513          	slli	a0,s1,0x20
    80002258:	9101                	srli	a0,a0,0x20
    8000225a:	60e2                	ld	ra,24(sp)
    8000225c:	6442                	ld	s0,16(sp)
    8000225e:	64a2                	ld	s1,8(sp)
    80002260:	6105                	addi	sp,sp,32
    80002262:	8082                	ret

0000000080002264 <sys_sigalarm>:

uint64
sys_sigalarm(void)
{
    80002264:	1101                	addi	sp,sp,-32
    80002266:	ec06                	sd	ra,24(sp)
    80002268:	e822                	sd	s0,16(sp)
    8000226a:	1000                	addi	s0,sp,32
  int internal;
  uint64 alarm_handler;
  if (argint(0, &internal) < 0)
    8000226c:	fec40593          	addi	a1,s0,-20
    80002270:	4501                	li	a0,0
    80002272:	00000097          	auipc	ra,0x0
    80002276:	d08080e7          	jalr	-760(ra) # 80001f7a <argint>
    return -1;
    8000227a:	57fd                	li	a5,-1
  if (argint(0, &internal) < 0)
    8000227c:	02054f63          	bltz	a0,800022ba <sys_sigalarm+0x56>

  if (argaddr(0, &alarm_handler) < 0)
    80002280:	fe040593          	addi	a1,s0,-32
    80002284:	4501                	li	a0,0
    80002286:	00000097          	auipc	ra,0x0
    8000228a:	d16080e7          	jalr	-746(ra) # 80001f9c <argaddr>
    return -1;
    8000228e:	57fd                	li	a5,-1
  if (argaddr(0, &alarm_handler) < 0)
    80002290:	02054563          	bltz	a0,800022ba <sys_sigalarm+0x56>

  struct proc *p = myproc();
    80002294:	fffff097          	auipc	ra,0xfffff
    80002298:	bb4080e7          	jalr	-1100(ra) # 80000e48 <myproc>

  p->alarm_inteval = internal;
    8000229c:	fec42783          	lw	a5,-20(s0)
    800022a0:	c13c                	sw	a5,64(a0)
  p->handler = alarm_handler;
    800022a2:	fe043703          	ld	a4,-32(s0)
    800022a6:	e538                	sd	a4,72(a0)
  p->ticks = ticks;
    800022a8:	00007717          	auipc	a4,0x7
    800022ac:	d7076703          	lwu	a4,-656(a4) # 80009018 <ticks>
    800022b0:	e938                	sd	a4,80(a0)
  p->alarm_on = (internal != 0);
    800022b2:	00f037b3          	snez	a5,a5
    800022b6:	cd3c                	sw	a5,88(a0)
  return 0;
    800022b8:	4781                	li	a5,0
}
    800022ba:	853e                	mv	a0,a5
    800022bc:	60e2                	ld	ra,24(sp)
    800022be:	6442                	ld	s0,16(sp)
    800022c0:	6105                	addi	sp,sp,32
    800022c2:	8082                	ret

00000000800022c4 <sys_sigreturn>:

uint64
sys_sigreturn(void)
{
    800022c4:	1101                	addi	sp,sp,-32
    800022c6:	ec06                	sd	ra,24(sp)
    800022c8:	e822                	sd	s0,16(sp)
    800022ca:	e426                	sd	s1,8(sp)
    800022cc:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800022ce:	fffff097          	auipc	ra,0xfffff
    800022d2:	b7a080e7          	jalr	-1158(ra) # 80000e48 <myproc>
  if (p->alarm_trapframe != 0)
    800022d6:	712c                	ld	a1,96(a0)
    800022d8:	c995                	beqz	a1,8000230c <sys_sigreturn+0x48>
    800022da:	84aa                	mv	s1,a0
  {
    memmove(p->trapframe, p->alarm_trapframe, 512);
    800022dc:	20000613          	li	a2,512
    800022e0:	6148                	ld	a0,128(a0)
    800022e2:	ffffe097          	auipc	ra,0xffffe
    800022e6:	ef6080e7          	jalr	-266(ra) # 800001d8 <memmove>
    kfree(p->alarm_trapframe);
    800022ea:	70a8                	ld	a0,96(s1)
    800022ec:	ffffe097          	auipc	ra,0xffffe
    800022f0:	d30080e7          	jalr	-720(ra) # 8000001c <kfree>
    p->alarm_trapframe = 0;
    800022f4:	0604b023          	sd	zero,96(s1)
    p->alarm_on = 0;
    800022f8:	0404ac23          	sw	zero,88(s1)
    p->ticks = 0;
    800022fc:	0404b823          	sd	zero,80(s1)
  }
  else
    return -1;
  return 0;
    80002300:	4501                	li	a0,0
    80002302:	60e2                	ld	ra,24(sp)
    80002304:	6442                	ld	s0,16(sp)
    80002306:	64a2                	ld	s1,8(sp)
    80002308:	6105                	addi	sp,sp,32
    8000230a:	8082                	ret
    return -1;
    8000230c:	557d                	li	a0,-1
    8000230e:	bfd5                	j	80002302 <sys_sigreturn+0x3e>

0000000080002310 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002310:	7179                	addi	sp,sp,-48
    80002312:	f406                	sd	ra,40(sp)
    80002314:	f022                	sd	s0,32(sp)
    80002316:	ec26                	sd	s1,24(sp)
    80002318:	e84a                	sd	s2,16(sp)
    8000231a:	e44e                	sd	s3,8(sp)
    8000231c:	e052                	sd	s4,0(sp)
    8000231e:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002320:	00006597          	auipc	a1,0x6
    80002324:	16858593          	addi	a1,a1,360 # 80008488 <syscalls+0xc0>
    80002328:	0000e517          	auipc	a0,0xe
    8000232c:	97050513          	addi	a0,a0,-1680 # 8000fc98 <bcache>
    80002330:	00004097          	auipc	ra,0x4
    80002334:	e38080e7          	jalr	-456(ra) # 80006168 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002338:	00016797          	auipc	a5,0x16
    8000233c:	96078793          	addi	a5,a5,-1696 # 80017c98 <bcache+0x8000>
    80002340:	00016717          	auipc	a4,0x16
    80002344:	bc070713          	addi	a4,a4,-1088 # 80017f00 <bcache+0x8268>
    80002348:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000234c:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002350:	0000e497          	auipc	s1,0xe
    80002354:	96048493          	addi	s1,s1,-1696 # 8000fcb0 <bcache+0x18>
    b->next = bcache.head.next;
    80002358:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000235a:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000235c:	00006a17          	auipc	s4,0x6
    80002360:	134a0a13          	addi	s4,s4,308 # 80008490 <syscalls+0xc8>
    b->next = bcache.head.next;
    80002364:	2b893783          	ld	a5,696(s2)
    80002368:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000236a:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000236e:	85d2                	mv	a1,s4
    80002370:	01048513          	addi	a0,s1,16
    80002374:	00001097          	auipc	ra,0x1
    80002378:	4bc080e7          	jalr	1212(ra) # 80003830 <initsleeplock>
    bcache.head.next->prev = b;
    8000237c:	2b893783          	ld	a5,696(s2)
    80002380:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002382:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002386:	45848493          	addi	s1,s1,1112
    8000238a:	fd349de3          	bne	s1,s3,80002364 <binit+0x54>
  }
}
    8000238e:	70a2                	ld	ra,40(sp)
    80002390:	7402                	ld	s0,32(sp)
    80002392:	64e2                	ld	s1,24(sp)
    80002394:	6942                	ld	s2,16(sp)
    80002396:	69a2                	ld	s3,8(sp)
    80002398:	6a02                	ld	s4,0(sp)
    8000239a:	6145                	addi	sp,sp,48
    8000239c:	8082                	ret

000000008000239e <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000239e:	7179                	addi	sp,sp,-48
    800023a0:	f406                	sd	ra,40(sp)
    800023a2:	f022                	sd	s0,32(sp)
    800023a4:	ec26                	sd	s1,24(sp)
    800023a6:	e84a                	sd	s2,16(sp)
    800023a8:	e44e                	sd	s3,8(sp)
    800023aa:	1800                	addi	s0,sp,48
    800023ac:	89aa                	mv	s3,a0
    800023ae:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    800023b0:	0000e517          	auipc	a0,0xe
    800023b4:	8e850513          	addi	a0,a0,-1816 # 8000fc98 <bcache>
    800023b8:	00004097          	auipc	ra,0x4
    800023bc:	e40080e7          	jalr	-448(ra) # 800061f8 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800023c0:	00016497          	auipc	s1,0x16
    800023c4:	b904b483          	ld	s1,-1136(s1) # 80017f50 <bcache+0x82b8>
    800023c8:	00016797          	auipc	a5,0x16
    800023cc:	b3878793          	addi	a5,a5,-1224 # 80017f00 <bcache+0x8268>
    800023d0:	02f48f63          	beq	s1,a5,8000240e <bread+0x70>
    800023d4:	873e                	mv	a4,a5
    800023d6:	a021                	j	800023de <bread+0x40>
    800023d8:	68a4                	ld	s1,80(s1)
    800023da:	02e48a63          	beq	s1,a4,8000240e <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800023de:	449c                	lw	a5,8(s1)
    800023e0:	ff379ce3          	bne	a5,s3,800023d8 <bread+0x3a>
    800023e4:	44dc                	lw	a5,12(s1)
    800023e6:	ff2799e3          	bne	a5,s2,800023d8 <bread+0x3a>
      b->refcnt++;
    800023ea:	40bc                	lw	a5,64(s1)
    800023ec:	2785                	addiw	a5,a5,1
    800023ee:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800023f0:	0000e517          	auipc	a0,0xe
    800023f4:	8a850513          	addi	a0,a0,-1880 # 8000fc98 <bcache>
    800023f8:	00004097          	auipc	ra,0x4
    800023fc:	eb4080e7          	jalr	-332(ra) # 800062ac <release>
      acquiresleep(&b->lock);
    80002400:	01048513          	addi	a0,s1,16
    80002404:	00001097          	auipc	ra,0x1
    80002408:	466080e7          	jalr	1126(ra) # 8000386a <acquiresleep>
      return b;
    8000240c:	a8b9                	j	8000246a <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000240e:	00016497          	auipc	s1,0x16
    80002412:	b3a4b483          	ld	s1,-1222(s1) # 80017f48 <bcache+0x82b0>
    80002416:	00016797          	auipc	a5,0x16
    8000241a:	aea78793          	addi	a5,a5,-1302 # 80017f00 <bcache+0x8268>
    8000241e:	00f48863          	beq	s1,a5,8000242e <bread+0x90>
    80002422:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002424:	40bc                	lw	a5,64(s1)
    80002426:	cf81                	beqz	a5,8000243e <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002428:	64a4                	ld	s1,72(s1)
    8000242a:	fee49de3          	bne	s1,a4,80002424 <bread+0x86>
  panic("bget: no buffers");
    8000242e:	00006517          	auipc	a0,0x6
    80002432:	06a50513          	addi	a0,a0,106 # 80008498 <syscalls+0xd0>
    80002436:	00004097          	auipc	ra,0x4
    8000243a:	822080e7          	jalr	-2014(ra) # 80005c58 <panic>
      b->dev = dev;
    8000243e:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002442:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002446:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000244a:	4785                	li	a5,1
    8000244c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000244e:	0000e517          	auipc	a0,0xe
    80002452:	84a50513          	addi	a0,a0,-1974 # 8000fc98 <bcache>
    80002456:	00004097          	auipc	ra,0x4
    8000245a:	e56080e7          	jalr	-426(ra) # 800062ac <release>
      acquiresleep(&b->lock);
    8000245e:	01048513          	addi	a0,s1,16
    80002462:	00001097          	auipc	ra,0x1
    80002466:	408080e7          	jalr	1032(ra) # 8000386a <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000246a:	409c                	lw	a5,0(s1)
    8000246c:	cb89                	beqz	a5,8000247e <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000246e:	8526                	mv	a0,s1
    80002470:	70a2                	ld	ra,40(sp)
    80002472:	7402                	ld	s0,32(sp)
    80002474:	64e2                	ld	s1,24(sp)
    80002476:	6942                	ld	s2,16(sp)
    80002478:	69a2                	ld	s3,8(sp)
    8000247a:	6145                	addi	sp,sp,48
    8000247c:	8082                	ret
    virtio_disk_rw(b, 0);
    8000247e:	4581                	li	a1,0
    80002480:	8526                	mv	a0,s1
    80002482:	00003097          	auipc	ra,0x3
    80002486:	f14080e7          	jalr	-236(ra) # 80005396 <virtio_disk_rw>
    b->valid = 1;
    8000248a:	4785                	li	a5,1
    8000248c:	c09c                	sw	a5,0(s1)
  return b;
    8000248e:	b7c5                	j	8000246e <bread+0xd0>

0000000080002490 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002490:	1101                	addi	sp,sp,-32
    80002492:	ec06                	sd	ra,24(sp)
    80002494:	e822                	sd	s0,16(sp)
    80002496:	e426                	sd	s1,8(sp)
    80002498:	1000                	addi	s0,sp,32
    8000249a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000249c:	0541                	addi	a0,a0,16
    8000249e:	00001097          	auipc	ra,0x1
    800024a2:	466080e7          	jalr	1126(ra) # 80003904 <holdingsleep>
    800024a6:	cd01                	beqz	a0,800024be <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800024a8:	4585                	li	a1,1
    800024aa:	8526                	mv	a0,s1
    800024ac:	00003097          	auipc	ra,0x3
    800024b0:	eea080e7          	jalr	-278(ra) # 80005396 <virtio_disk_rw>
}
    800024b4:	60e2                	ld	ra,24(sp)
    800024b6:	6442                	ld	s0,16(sp)
    800024b8:	64a2                	ld	s1,8(sp)
    800024ba:	6105                	addi	sp,sp,32
    800024bc:	8082                	ret
    panic("bwrite");
    800024be:	00006517          	auipc	a0,0x6
    800024c2:	ff250513          	addi	a0,a0,-14 # 800084b0 <syscalls+0xe8>
    800024c6:	00003097          	auipc	ra,0x3
    800024ca:	792080e7          	jalr	1938(ra) # 80005c58 <panic>

00000000800024ce <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800024ce:	1101                	addi	sp,sp,-32
    800024d0:	ec06                	sd	ra,24(sp)
    800024d2:	e822                	sd	s0,16(sp)
    800024d4:	e426                	sd	s1,8(sp)
    800024d6:	e04a                	sd	s2,0(sp)
    800024d8:	1000                	addi	s0,sp,32
    800024da:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024dc:	01050913          	addi	s2,a0,16
    800024e0:	854a                	mv	a0,s2
    800024e2:	00001097          	auipc	ra,0x1
    800024e6:	422080e7          	jalr	1058(ra) # 80003904 <holdingsleep>
    800024ea:	c92d                	beqz	a0,8000255c <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800024ec:	854a                	mv	a0,s2
    800024ee:	00001097          	auipc	ra,0x1
    800024f2:	3d2080e7          	jalr	978(ra) # 800038c0 <releasesleep>

  acquire(&bcache.lock);
    800024f6:	0000d517          	auipc	a0,0xd
    800024fa:	7a250513          	addi	a0,a0,1954 # 8000fc98 <bcache>
    800024fe:	00004097          	auipc	ra,0x4
    80002502:	cfa080e7          	jalr	-774(ra) # 800061f8 <acquire>
  b->refcnt--;
    80002506:	40bc                	lw	a5,64(s1)
    80002508:	37fd                	addiw	a5,a5,-1
    8000250a:	0007871b          	sext.w	a4,a5
    8000250e:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002510:	eb05                	bnez	a4,80002540 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002512:	68bc                	ld	a5,80(s1)
    80002514:	64b8                	ld	a4,72(s1)
    80002516:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002518:	64bc                	ld	a5,72(s1)
    8000251a:	68b8                	ld	a4,80(s1)
    8000251c:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000251e:	00015797          	auipc	a5,0x15
    80002522:	77a78793          	addi	a5,a5,1914 # 80017c98 <bcache+0x8000>
    80002526:	2b87b703          	ld	a4,696(a5)
    8000252a:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000252c:	00016717          	auipc	a4,0x16
    80002530:	9d470713          	addi	a4,a4,-1580 # 80017f00 <bcache+0x8268>
    80002534:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002536:	2b87b703          	ld	a4,696(a5)
    8000253a:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000253c:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002540:	0000d517          	auipc	a0,0xd
    80002544:	75850513          	addi	a0,a0,1880 # 8000fc98 <bcache>
    80002548:	00004097          	auipc	ra,0x4
    8000254c:	d64080e7          	jalr	-668(ra) # 800062ac <release>
}
    80002550:	60e2                	ld	ra,24(sp)
    80002552:	6442                	ld	s0,16(sp)
    80002554:	64a2                	ld	s1,8(sp)
    80002556:	6902                	ld	s2,0(sp)
    80002558:	6105                	addi	sp,sp,32
    8000255a:	8082                	ret
    panic("brelse");
    8000255c:	00006517          	auipc	a0,0x6
    80002560:	f5c50513          	addi	a0,a0,-164 # 800084b8 <syscalls+0xf0>
    80002564:	00003097          	auipc	ra,0x3
    80002568:	6f4080e7          	jalr	1780(ra) # 80005c58 <panic>

000000008000256c <bpin>:

void
bpin(struct buf *b) {
    8000256c:	1101                	addi	sp,sp,-32
    8000256e:	ec06                	sd	ra,24(sp)
    80002570:	e822                	sd	s0,16(sp)
    80002572:	e426                	sd	s1,8(sp)
    80002574:	1000                	addi	s0,sp,32
    80002576:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002578:	0000d517          	auipc	a0,0xd
    8000257c:	72050513          	addi	a0,a0,1824 # 8000fc98 <bcache>
    80002580:	00004097          	auipc	ra,0x4
    80002584:	c78080e7          	jalr	-904(ra) # 800061f8 <acquire>
  b->refcnt++;
    80002588:	40bc                	lw	a5,64(s1)
    8000258a:	2785                	addiw	a5,a5,1
    8000258c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000258e:	0000d517          	auipc	a0,0xd
    80002592:	70a50513          	addi	a0,a0,1802 # 8000fc98 <bcache>
    80002596:	00004097          	auipc	ra,0x4
    8000259a:	d16080e7          	jalr	-746(ra) # 800062ac <release>
}
    8000259e:	60e2                	ld	ra,24(sp)
    800025a0:	6442                	ld	s0,16(sp)
    800025a2:	64a2                	ld	s1,8(sp)
    800025a4:	6105                	addi	sp,sp,32
    800025a6:	8082                	ret

00000000800025a8 <bunpin>:

void
bunpin(struct buf *b) {
    800025a8:	1101                	addi	sp,sp,-32
    800025aa:	ec06                	sd	ra,24(sp)
    800025ac:	e822                	sd	s0,16(sp)
    800025ae:	e426                	sd	s1,8(sp)
    800025b0:	1000                	addi	s0,sp,32
    800025b2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025b4:	0000d517          	auipc	a0,0xd
    800025b8:	6e450513          	addi	a0,a0,1764 # 8000fc98 <bcache>
    800025bc:	00004097          	auipc	ra,0x4
    800025c0:	c3c080e7          	jalr	-964(ra) # 800061f8 <acquire>
  b->refcnt--;
    800025c4:	40bc                	lw	a5,64(s1)
    800025c6:	37fd                	addiw	a5,a5,-1
    800025c8:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025ca:	0000d517          	auipc	a0,0xd
    800025ce:	6ce50513          	addi	a0,a0,1742 # 8000fc98 <bcache>
    800025d2:	00004097          	auipc	ra,0x4
    800025d6:	cda080e7          	jalr	-806(ra) # 800062ac <release>
}
    800025da:	60e2                	ld	ra,24(sp)
    800025dc:	6442                	ld	s0,16(sp)
    800025de:	64a2                	ld	s1,8(sp)
    800025e0:	6105                	addi	sp,sp,32
    800025e2:	8082                	ret

00000000800025e4 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800025e4:	1101                	addi	sp,sp,-32
    800025e6:	ec06                	sd	ra,24(sp)
    800025e8:	e822                	sd	s0,16(sp)
    800025ea:	e426                	sd	s1,8(sp)
    800025ec:	e04a                	sd	s2,0(sp)
    800025ee:	1000                	addi	s0,sp,32
    800025f0:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800025f2:	00d5d59b          	srliw	a1,a1,0xd
    800025f6:	00016797          	auipc	a5,0x16
    800025fa:	d7e7a783          	lw	a5,-642(a5) # 80018374 <sb+0x1c>
    800025fe:	9dbd                	addw	a1,a1,a5
    80002600:	00000097          	auipc	ra,0x0
    80002604:	d9e080e7          	jalr	-610(ra) # 8000239e <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002608:	0074f713          	andi	a4,s1,7
    8000260c:	4785                	li	a5,1
    8000260e:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002612:	14ce                	slli	s1,s1,0x33
    80002614:	90d9                	srli	s1,s1,0x36
    80002616:	00950733          	add	a4,a0,s1
    8000261a:	05874703          	lbu	a4,88(a4)
    8000261e:	00e7f6b3          	and	a3,a5,a4
    80002622:	c69d                	beqz	a3,80002650 <bfree+0x6c>
    80002624:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002626:	94aa                	add	s1,s1,a0
    80002628:	fff7c793          	not	a5,a5
    8000262c:	8ff9                	and	a5,a5,a4
    8000262e:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002632:	00001097          	auipc	ra,0x1
    80002636:	118080e7          	jalr	280(ra) # 8000374a <log_write>
  brelse(bp);
    8000263a:	854a                	mv	a0,s2
    8000263c:	00000097          	auipc	ra,0x0
    80002640:	e92080e7          	jalr	-366(ra) # 800024ce <brelse>
}
    80002644:	60e2                	ld	ra,24(sp)
    80002646:	6442                	ld	s0,16(sp)
    80002648:	64a2                	ld	s1,8(sp)
    8000264a:	6902                	ld	s2,0(sp)
    8000264c:	6105                	addi	sp,sp,32
    8000264e:	8082                	ret
    panic("freeing free block");
    80002650:	00006517          	auipc	a0,0x6
    80002654:	e7050513          	addi	a0,a0,-400 # 800084c0 <syscalls+0xf8>
    80002658:	00003097          	auipc	ra,0x3
    8000265c:	600080e7          	jalr	1536(ra) # 80005c58 <panic>

0000000080002660 <balloc>:
{
    80002660:	711d                	addi	sp,sp,-96
    80002662:	ec86                	sd	ra,88(sp)
    80002664:	e8a2                	sd	s0,80(sp)
    80002666:	e4a6                	sd	s1,72(sp)
    80002668:	e0ca                	sd	s2,64(sp)
    8000266a:	fc4e                	sd	s3,56(sp)
    8000266c:	f852                	sd	s4,48(sp)
    8000266e:	f456                	sd	s5,40(sp)
    80002670:	f05a                	sd	s6,32(sp)
    80002672:	ec5e                	sd	s7,24(sp)
    80002674:	e862                	sd	s8,16(sp)
    80002676:	e466                	sd	s9,8(sp)
    80002678:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000267a:	00016797          	auipc	a5,0x16
    8000267e:	ce27a783          	lw	a5,-798(a5) # 8001835c <sb+0x4>
    80002682:	cbd1                	beqz	a5,80002716 <balloc+0xb6>
    80002684:	8baa                	mv	s7,a0
    80002686:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002688:	00016b17          	auipc	s6,0x16
    8000268c:	cd0b0b13          	addi	s6,s6,-816 # 80018358 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002690:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002692:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002694:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002696:	6c89                	lui	s9,0x2
    80002698:	a831                	j	800026b4 <balloc+0x54>
    brelse(bp);
    8000269a:	854a                	mv	a0,s2
    8000269c:	00000097          	auipc	ra,0x0
    800026a0:	e32080e7          	jalr	-462(ra) # 800024ce <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800026a4:	015c87bb          	addw	a5,s9,s5
    800026a8:	00078a9b          	sext.w	s5,a5
    800026ac:	004b2703          	lw	a4,4(s6)
    800026b0:	06eaf363          	bgeu	s5,a4,80002716 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800026b4:	41fad79b          	sraiw	a5,s5,0x1f
    800026b8:	0137d79b          	srliw	a5,a5,0x13
    800026bc:	015787bb          	addw	a5,a5,s5
    800026c0:	40d7d79b          	sraiw	a5,a5,0xd
    800026c4:	01cb2583          	lw	a1,28(s6)
    800026c8:	9dbd                	addw	a1,a1,a5
    800026ca:	855e                	mv	a0,s7
    800026cc:	00000097          	auipc	ra,0x0
    800026d0:	cd2080e7          	jalr	-814(ra) # 8000239e <bread>
    800026d4:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026d6:	004b2503          	lw	a0,4(s6)
    800026da:	000a849b          	sext.w	s1,s5
    800026de:	8662                	mv	a2,s8
    800026e0:	faa4fde3          	bgeu	s1,a0,8000269a <balloc+0x3a>
      m = 1 << (bi % 8);
    800026e4:	41f6579b          	sraiw	a5,a2,0x1f
    800026e8:	01d7d69b          	srliw	a3,a5,0x1d
    800026ec:	00c6873b          	addw	a4,a3,a2
    800026f0:	00777793          	andi	a5,a4,7
    800026f4:	9f95                	subw	a5,a5,a3
    800026f6:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800026fa:	4037571b          	sraiw	a4,a4,0x3
    800026fe:	00e906b3          	add	a3,s2,a4
    80002702:	0586c683          	lbu	a3,88(a3)
    80002706:	00d7f5b3          	and	a1,a5,a3
    8000270a:	cd91                	beqz	a1,80002726 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000270c:	2605                	addiw	a2,a2,1
    8000270e:	2485                	addiw	s1,s1,1
    80002710:	fd4618e3          	bne	a2,s4,800026e0 <balloc+0x80>
    80002714:	b759                	j	8000269a <balloc+0x3a>
  panic("balloc: out of blocks");
    80002716:	00006517          	auipc	a0,0x6
    8000271a:	dc250513          	addi	a0,a0,-574 # 800084d8 <syscalls+0x110>
    8000271e:	00003097          	auipc	ra,0x3
    80002722:	53a080e7          	jalr	1338(ra) # 80005c58 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002726:	974a                	add	a4,a4,s2
    80002728:	8fd5                	or	a5,a5,a3
    8000272a:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    8000272e:	854a                	mv	a0,s2
    80002730:	00001097          	auipc	ra,0x1
    80002734:	01a080e7          	jalr	26(ra) # 8000374a <log_write>
        brelse(bp);
    80002738:	854a                	mv	a0,s2
    8000273a:	00000097          	auipc	ra,0x0
    8000273e:	d94080e7          	jalr	-620(ra) # 800024ce <brelse>
  bp = bread(dev, bno);
    80002742:	85a6                	mv	a1,s1
    80002744:	855e                	mv	a0,s7
    80002746:	00000097          	auipc	ra,0x0
    8000274a:	c58080e7          	jalr	-936(ra) # 8000239e <bread>
    8000274e:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002750:	40000613          	li	a2,1024
    80002754:	4581                	li	a1,0
    80002756:	05850513          	addi	a0,a0,88
    8000275a:	ffffe097          	auipc	ra,0xffffe
    8000275e:	a1e080e7          	jalr	-1506(ra) # 80000178 <memset>
  log_write(bp);
    80002762:	854a                	mv	a0,s2
    80002764:	00001097          	auipc	ra,0x1
    80002768:	fe6080e7          	jalr	-26(ra) # 8000374a <log_write>
  brelse(bp);
    8000276c:	854a                	mv	a0,s2
    8000276e:	00000097          	auipc	ra,0x0
    80002772:	d60080e7          	jalr	-672(ra) # 800024ce <brelse>
}
    80002776:	8526                	mv	a0,s1
    80002778:	60e6                	ld	ra,88(sp)
    8000277a:	6446                	ld	s0,80(sp)
    8000277c:	64a6                	ld	s1,72(sp)
    8000277e:	6906                	ld	s2,64(sp)
    80002780:	79e2                	ld	s3,56(sp)
    80002782:	7a42                	ld	s4,48(sp)
    80002784:	7aa2                	ld	s5,40(sp)
    80002786:	7b02                	ld	s6,32(sp)
    80002788:	6be2                	ld	s7,24(sp)
    8000278a:	6c42                	ld	s8,16(sp)
    8000278c:	6ca2                	ld	s9,8(sp)
    8000278e:	6125                	addi	sp,sp,96
    80002790:	8082                	ret

0000000080002792 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002792:	7179                	addi	sp,sp,-48
    80002794:	f406                	sd	ra,40(sp)
    80002796:	f022                	sd	s0,32(sp)
    80002798:	ec26                	sd	s1,24(sp)
    8000279a:	e84a                	sd	s2,16(sp)
    8000279c:	e44e                	sd	s3,8(sp)
    8000279e:	e052                	sd	s4,0(sp)
    800027a0:	1800                	addi	s0,sp,48
    800027a2:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800027a4:	47ad                	li	a5,11
    800027a6:	04b7fe63          	bgeu	a5,a1,80002802 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800027aa:	ff45849b          	addiw	s1,a1,-12
    800027ae:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800027b2:	0ff00793          	li	a5,255
    800027b6:	0ae7e363          	bltu	a5,a4,8000285c <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800027ba:	08052583          	lw	a1,128(a0)
    800027be:	c5ad                	beqz	a1,80002828 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800027c0:	00092503          	lw	a0,0(s2)
    800027c4:	00000097          	auipc	ra,0x0
    800027c8:	bda080e7          	jalr	-1062(ra) # 8000239e <bread>
    800027cc:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800027ce:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800027d2:	02049593          	slli	a1,s1,0x20
    800027d6:	9181                	srli	a1,a1,0x20
    800027d8:	058a                	slli	a1,a1,0x2
    800027da:	00b784b3          	add	s1,a5,a1
    800027de:	0004a983          	lw	s3,0(s1)
    800027e2:	04098d63          	beqz	s3,8000283c <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800027e6:	8552                	mv	a0,s4
    800027e8:	00000097          	auipc	ra,0x0
    800027ec:	ce6080e7          	jalr	-794(ra) # 800024ce <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800027f0:	854e                	mv	a0,s3
    800027f2:	70a2                	ld	ra,40(sp)
    800027f4:	7402                	ld	s0,32(sp)
    800027f6:	64e2                	ld	s1,24(sp)
    800027f8:	6942                	ld	s2,16(sp)
    800027fa:	69a2                	ld	s3,8(sp)
    800027fc:	6a02                	ld	s4,0(sp)
    800027fe:	6145                	addi	sp,sp,48
    80002800:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002802:	02059493          	slli	s1,a1,0x20
    80002806:	9081                	srli	s1,s1,0x20
    80002808:	048a                	slli	s1,s1,0x2
    8000280a:	94aa                	add	s1,s1,a0
    8000280c:	0504a983          	lw	s3,80(s1)
    80002810:	fe0990e3          	bnez	s3,800027f0 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002814:	4108                	lw	a0,0(a0)
    80002816:	00000097          	auipc	ra,0x0
    8000281a:	e4a080e7          	jalr	-438(ra) # 80002660 <balloc>
    8000281e:	0005099b          	sext.w	s3,a0
    80002822:	0534a823          	sw	s3,80(s1)
    80002826:	b7e9                	j	800027f0 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002828:	4108                	lw	a0,0(a0)
    8000282a:	00000097          	auipc	ra,0x0
    8000282e:	e36080e7          	jalr	-458(ra) # 80002660 <balloc>
    80002832:	0005059b          	sext.w	a1,a0
    80002836:	08b92023          	sw	a1,128(s2)
    8000283a:	b759                	j	800027c0 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    8000283c:	00092503          	lw	a0,0(s2)
    80002840:	00000097          	auipc	ra,0x0
    80002844:	e20080e7          	jalr	-480(ra) # 80002660 <balloc>
    80002848:	0005099b          	sext.w	s3,a0
    8000284c:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002850:	8552                	mv	a0,s4
    80002852:	00001097          	auipc	ra,0x1
    80002856:	ef8080e7          	jalr	-264(ra) # 8000374a <log_write>
    8000285a:	b771                	j	800027e6 <bmap+0x54>
  panic("bmap: out of range");
    8000285c:	00006517          	auipc	a0,0x6
    80002860:	c9450513          	addi	a0,a0,-876 # 800084f0 <syscalls+0x128>
    80002864:	00003097          	auipc	ra,0x3
    80002868:	3f4080e7          	jalr	1012(ra) # 80005c58 <panic>

000000008000286c <iget>:
{
    8000286c:	7179                	addi	sp,sp,-48
    8000286e:	f406                	sd	ra,40(sp)
    80002870:	f022                	sd	s0,32(sp)
    80002872:	ec26                	sd	s1,24(sp)
    80002874:	e84a                	sd	s2,16(sp)
    80002876:	e44e                	sd	s3,8(sp)
    80002878:	e052                	sd	s4,0(sp)
    8000287a:	1800                	addi	s0,sp,48
    8000287c:	89aa                	mv	s3,a0
    8000287e:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002880:	00016517          	auipc	a0,0x16
    80002884:	af850513          	addi	a0,a0,-1288 # 80018378 <itable>
    80002888:	00004097          	auipc	ra,0x4
    8000288c:	970080e7          	jalr	-1680(ra) # 800061f8 <acquire>
  empty = 0;
    80002890:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002892:	00016497          	auipc	s1,0x16
    80002896:	afe48493          	addi	s1,s1,-1282 # 80018390 <itable+0x18>
    8000289a:	00017697          	auipc	a3,0x17
    8000289e:	58668693          	addi	a3,a3,1414 # 80019e20 <log>
    800028a2:	a039                	j	800028b0 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028a4:	02090b63          	beqz	s2,800028da <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028a8:	08848493          	addi	s1,s1,136
    800028ac:	02d48a63          	beq	s1,a3,800028e0 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800028b0:	449c                	lw	a5,8(s1)
    800028b2:	fef059e3          	blez	a5,800028a4 <iget+0x38>
    800028b6:	4098                	lw	a4,0(s1)
    800028b8:	ff3716e3          	bne	a4,s3,800028a4 <iget+0x38>
    800028bc:	40d8                	lw	a4,4(s1)
    800028be:	ff4713e3          	bne	a4,s4,800028a4 <iget+0x38>
      ip->ref++;
    800028c2:	2785                	addiw	a5,a5,1
    800028c4:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800028c6:	00016517          	auipc	a0,0x16
    800028ca:	ab250513          	addi	a0,a0,-1358 # 80018378 <itable>
    800028ce:	00004097          	auipc	ra,0x4
    800028d2:	9de080e7          	jalr	-1570(ra) # 800062ac <release>
      return ip;
    800028d6:	8926                	mv	s2,s1
    800028d8:	a03d                	j	80002906 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028da:	f7f9                	bnez	a5,800028a8 <iget+0x3c>
    800028dc:	8926                	mv	s2,s1
    800028de:	b7e9                	j	800028a8 <iget+0x3c>
  if(empty == 0)
    800028e0:	02090c63          	beqz	s2,80002918 <iget+0xac>
  ip->dev = dev;
    800028e4:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800028e8:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800028ec:	4785                	li	a5,1
    800028ee:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800028f2:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800028f6:	00016517          	auipc	a0,0x16
    800028fa:	a8250513          	addi	a0,a0,-1406 # 80018378 <itable>
    800028fe:	00004097          	auipc	ra,0x4
    80002902:	9ae080e7          	jalr	-1618(ra) # 800062ac <release>
}
    80002906:	854a                	mv	a0,s2
    80002908:	70a2                	ld	ra,40(sp)
    8000290a:	7402                	ld	s0,32(sp)
    8000290c:	64e2                	ld	s1,24(sp)
    8000290e:	6942                	ld	s2,16(sp)
    80002910:	69a2                	ld	s3,8(sp)
    80002912:	6a02                	ld	s4,0(sp)
    80002914:	6145                	addi	sp,sp,48
    80002916:	8082                	ret
    panic("iget: no inodes");
    80002918:	00006517          	auipc	a0,0x6
    8000291c:	bf050513          	addi	a0,a0,-1040 # 80008508 <syscalls+0x140>
    80002920:	00003097          	auipc	ra,0x3
    80002924:	338080e7          	jalr	824(ra) # 80005c58 <panic>

0000000080002928 <fsinit>:
fsinit(int dev) {
    80002928:	7179                	addi	sp,sp,-48
    8000292a:	f406                	sd	ra,40(sp)
    8000292c:	f022                	sd	s0,32(sp)
    8000292e:	ec26                	sd	s1,24(sp)
    80002930:	e84a                	sd	s2,16(sp)
    80002932:	e44e                	sd	s3,8(sp)
    80002934:	1800                	addi	s0,sp,48
    80002936:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002938:	4585                	li	a1,1
    8000293a:	00000097          	auipc	ra,0x0
    8000293e:	a64080e7          	jalr	-1436(ra) # 8000239e <bread>
    80002942:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002944:	00016997          	auipc	s3,0x16
    80002948:	a1498993          	addi	s3,s3,-1516 # 80018358 <sb>
    8000294c:	02000613          	li	a2,32
    80002950:	05850593          	addi	a1,a0,88
    80002954:	854e                	mv	a0,s3
    80002956:	ffffe097          	auipc	ra,0xffffe
    8000295a:	882080e7          	jalr	-1918(ra) # 800001d8 <memmove>
  brelse(bp);
    8000295e:	8526                	mv	a0,s1
    80002960:	00000097          	auipc	ra,0x0
    80002964:	b6e080e7          	jalr	-1170(ra) # 800024ce <brelse>
  if(sb.magic != FSMAGIC)
    80002968:	0009a703          	lw	a4,0(s3)
    8000296c:	102037b7          	lui	a5,0x10203
    80002970:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002974:	02f71263          	bne	a4,a5,80002998 <fsinit+0x70>
  initlog(dev, &sb);
    80002978:	00016597          	auipc	a1,0x16
    8000297c:	9e058593          	addi	a1,a1,-1568 # 80018358 <sb>
    80002980:	854a                	mv	a0,s2
    80002982:	00001097          	auipc	ra,0x1
    80002986:	b4c080e7          	jalr	-1204(ra) # 800034ce <initlog>
}
    8000298a:	70a2                	ld	ra,40(sp)
    8000298c:	7402                	ld	s0,32(sp)
    8000298e:	64e2                	ld	s1,24(sp)
    80002990:	6942                	ld	s2,16(sp)
    80002992:	69a2                	ld	s3,8(sp)
    80002994:	6145                	addi	sp,sp,48
    80002996:	8082                	ret
    panic("invalid file system");
    80002998:	00006517          	auipc	a0,0x6
    8000299c:	b8050513          	addi	a0,a0,-1152 # 80008518 <syscalls+0x150>
    800029a0:	00003097          	auipc	ra,0x3
    800029a4:	2b8080e7          	jalr	696(ra) # 80005c58 <panic>

00000000800029a8 <iinit>:
{
    800029a8:	7179                	addi	sp,sp,-48
    800029aa:	f406                	sd	ra,40(sp)
    800029ac:	f022                	sd	s0,32(sp)
    800029ae:	ec26                	sd	s1,24(sp)
    800029b0:	e84a                	sd	s2,16(sp)
    800029b2:	e44e                	sd	s3,8(sp)
    800029b4:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800029b6:	00006597          	auipc	a1,0x6
    800029ba:	b7a58593          	addi	a1,a1,-1158 # 80008530 <syscalls+0x168>
    800029be:	00016517          	auipc	a0,0x16
    800029c2:	9ba50513          	addi	a0,a0,-1606 # 80018378 <itable>
    800029c6:	00003097          	auipc	ra,0x3
    800029ca:	7a2080e7          	jalr	1954(ra) # 80006168 <initlock>
  for(i = 0; i < NINODE; i++) {
    800029ce:	00016497          	auipc	s1,0x16
    800029d2:	9d248493          	addi	s1,s1,-1582 # 800183a0 <itable+0x28>
    800029d6:	00017997          	auipc	s3,0x17
    800029da:	45a98993          	addi	s3,s3,1114 # 80019e30 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800029de:	00006917          	auipc	s2,0x6
    800029e2:	b5a90913          	addi	s2,s2,-1190 # 80008538 <syscalls+0x170>
    800029e6:	85ca                	mv	a1,s2
    800029e8:	8526                	mv	a0,s1
    800029ea:	00001097          	auipc	ra,0x1
    800029ee:	e46080e7          	jalr	-442(ra) # 80003830 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800029f2:	08848493          	addi	s1,s1,136
    800029f6:	ff3498e3          	bne	s1,s3,800029e6 <iinit+0x3e>
}
    800029fa:	70a2                	ld	ra,40(sp)
    800029fc:	7402                	ld	s0,32(sp)
    800029fe:	64e2                	ld	s1,24(sp)
    80002a00:	6942                	ld	s2,16(sp)
    80002a02:	69a2                	ld	s3,8(sp)
    80002a04:	6145                	addi	sp,sp,48
    80002a06:	8082                	ret

0000000080002a08 <ialloc>:
{
    80002a08:	715d                	addi	sp,sp,-80
    80002a0a:	e486                	sd	ra,72(sp)
    80002a0c:	e0a2                	sd	s0,64(sp)
    80002a0e:	fc26                	sd	s1,56(sp)
    80002a10:	f84a                	sd	s2,48(sp)
    80002a12:	f44e                	sd	s3,40(sp)
    80002a14:	f052                	sd	s4,32(sp)
    80002a16:	ec56                	sd	s5,24(sp)
    80002a18:	e85a                	sd	s6,16(sp)
    80002a1a:	e45e                	sd	s7,8(sp)
    80002a1c:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a1e:	00016717          	auipc	a4,0x16
    80002a22:	94672703          	lw	a4,-1722(a4) # 80018364 <sb+0xc>
    80002a26:	4785                	li	a5,1
    80002a28:	04e7fa63          	bgeu	a5,a4,80002a7c <ialloc+0x74>
    80002a2c:	8aaa                	mv	s5,a0
    80002a2e:	8bae                	mv	s7,a1
    80002a30:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a32:	00016a17          	auipc	s4,0x16
    80002a36:	926a0a13          	addi	s4,s4,-1754 # 80018358 <sb>
    80002a3a:	00048b1b          	sext.w	s6,s1
    80002a3e:	0044d593          	srli	a1,s1,0x4
    80002a42:	018a2783          	lw	a5,24(s4)
    80002a46:	9dbd                	addw	a1,a1,a5
    80002a48:	8556                	mv	a0,s5
    80002a4a:	00000097          	auipc	ra,0x0
    80002a4e:	954080e7          	jalr	-1708(ra) # 8000239e <bread>
    80002a52:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002a54:	05850993          	addi	s3,a0,88
    80002a58:	00f4f793          	andi	a5,s1,15
    80002a5c:	079a                	slli	a5,a5,0x6
    80002a5e:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002a60:	00099783          	lh	a5,0(s3)
    80002a64:	c785                	beqz	a5,80002a8c <ialloc+0x84>
    brelse(bp);
    80002a66:	00000097          	auipc	ra,0x0
    80002a6a:	a68080e7          	jalr	-1432(ra) # 800024ce <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a6e:	0485                	addi	s1,s1,1
    80002a70:	00ca2703          	lw	a4,12(s4)
    80002a74:	0004879b          	sext.w	a5,s1
    80002a78:	fce7e1e3          	bltu	a5,a4,80002a3a <ialloc+0x32>
  panic("ialloc: no inodes");
    80002a7c:	00006517          	auipc	a0,0x6
    80002a80:	ac450513          	addi	a0,a0,-1340 # 80008540 <syscalls+0x178>
    80002a84:	00003097          	auipc	ra,0x3
    80002a88:	1d4080e7          	jalr	468(ra) # 80005c58 <panic>
      memset(dip, 0, sizeof(*dip));
    80002a8c:	04000613          	li	a2,64
    80002a90:	4581                	li	a1,0
    80002a92:	854e                	mv	a0,s3
    80002a94:	ffffd097          	auipc	ra,0xffffd
    80002a98:	6e4080e7          	jalr	1764(ra) # 80000178 <memset>
      dip->type = type;
    80002a9c:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002aa0:	854a                	mv	a0,s2
    80002aa2:	00001097          	auipc	ra,0x1
    80002aa6:	ca8080e7          	jalr	-856(ra) # 8000374a <log_write>
      brelse(bp);
    80002aaa:	854a                	mv	a0,s2
    80002aac:	00000097          	auipc	ra,0x0
    80002ab0:	a22080e7          	jalr	-1502(ra) # 800024ce <brelse>
      return iget(dev, inum);
    80002ab4:	85da                	mv	a1,s6
    80002ab6:	8556                	mv	a0,s5
    80002ab8:	00000097          	auipc	ra,0x0
    80002abc:	db4080e7          	jalr	-588(ra) # 8000286c <iget>
}
    80002ac0:	60a6                	ld	ra,72(sp)
    80002ac2:	6406                	ld	s0,64(sp)
    80002ac4:	74e2                	ld	s1,56(sp)
    80002ac6:	7942                	ld	s2,48(sp)
    80002ac8:	79a2                	ld	s3,40(sp)
    80002aca:	7a02                	ld	s4,32(sp)
    80002acc:	6ae2                	ld	s5,24(sp)
    80002ace:	6b42                	ld	s6,16(sp)
    80002ad0:	6ba2                	ld	s7,8(sp)
    80002ad2:	6161                	addi	sp,sp,80
    80002ad4:	8082                	ret

0000000080002ad6 <iupdate>:
{
    80002ad6:	1101                	addi	sp,sp,-32
    80002ad8:	ec06                	sd	ra,24(sp)
    80002ada:	e822                	sd	s0,16(sp)
    80002adc:	e426                	sd	s1,8(sp)
    80002ade:	e04a                	sd	s2,0(sp)
    80002ae0:	1000                	addi	s0,sp,32
    80002ae2:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002ae4:	415c                	lw	a5,4(a0)
    80002ae6:	0047d79b          	srliw	a5,a5,0x4
    80002aea:	00016597          	auipc	a1,0x16
    80002aee:	8865a583          	lw	a1,-1914(a1) # 80018370 <sb+0x18>
    80002af2:	9dbd                	addw	a1,a1,a5
    80002af4:	4108                	lw	a0,0(a0)
    80002af6:	00000097          	auipc	ra,0x0
    80002afa:	8a8080e7          	jalr	-1880(ra) # 8000239e <bread>
    80002afe:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b00:	05850793          	addi	a5,a0,88
    80002b04:	40c8                	lw	a0,4(s1)
    80002b06:	893d                	andi	a0,a0,15
    80002b08:	051a                	slli	a0,a0,0x6
    80002b0a:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002b0c:	04449703          	lh	a4,68(s1)
    80002b10:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002b14:	04649703          	lh	a4,70(s1)
    80002b18:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002b1c:	04849703          	lh	a4,72(s1)
    80002b20:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002b24:	04a49703          	lh	a4,74(s1)
    80002b28:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002b2c:	44f8                	lw	a4,76(s1)
    80002b2e:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b30:	03400613          	li	a2,52
    80002b34:	05048593          	addi	a1,s1,80
    80002b38:	0531                	addi	a0,a0,12
    80002b3a:	ffffd097          	auipc	ra,0xffffd
    80002b3e:	69e080e7          	jalr	1694(ra) # 800001d8 <memmove>
  log_write(bp);
    80002b42:	854a                	mv	a0,s2
    80002b44:	00001097          	auipc	ra,0x1
    80002b48:	c06080e7          	jalr	-1018(ra) # 8000374a <log_write>
  brelse(bp);
    80002b4c:	854a                	mv	a0,s2
    80002b4e:	00000097          	auipc	ra,0x0
    80002b52:	980080e7          	jalr	-1664(ra) # 800024ce <brelse>
}
    80002b56:	60e2                	ld	ra,24(sp)
    80002b58:	6442                	ld	s0,16(sp)
    80002b5a:	64a2                	ld	s1,8(sp)
    80002b5c:	6902                	ld	s2,0(sp)
    80002b5e:	6105                	addi	sp,sp,32
    80002b60:	8082                	ret

0000000080002b62 <idup>:
{
    80002b62:	1101                	addi	sp,sp,-32
    80002b64:	ec06                	sd	ra,24(sp)
    80002b66:	e822                	sd	s0,16(sp)
    80002b68:	e426                	sd	s1,8(sp)
    80002b6a:	1000                	addi	s0,sp,32
    80002b6c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b6e:	00016517          	auipc	a0,0x16
    80002b72:	80a50513          	addi	a0,a0,-2038 # 80018378 <itable>
    80002b76:	00003097          	auipc	ra,0x3
    80002b7a:	682080e7          	jalr	1666(ra) # 800061f8 <acquire>
  ip->ref++;
    80002b7e:	449c                	lw	a5,8(s1)
    80002b80:	2785                	addiw	a5,a5,1
    80002b82:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b84:	00015517          	auipc	a0,0x15
    80002b88:	7f450513          	addi	a0,a0,2036 # 80018378 <itable>
    80002b8c:	00003097          	auipc	ra,0x3
    80002b90:	720080e7          	jalr	1824(ra) # 800062ac <release>
}
    80002b94:	8526                	mv	a0,s1
    80002b96:	60e2                	ld	ra,24(sp)
    80002b98:	6442                	ld	s0,16(sp)
    80002b9a:	64a2                	ld	s1,8(sp)
    80002b9c:	6105                	addi	sp,sp,32
    80002b9e:	8082                	ret

0000000080002ba0 <ilock>:
{
    80002ba0:	1101                	addi	sp,sp,-32
    80002ba2:	ec06                	sd	ra,24(sp)
    80002ba4:	e822                	sd	s0,16(sp)
    80002ba6:	e426                	sd	s1,8(sp)
    80002ba8:	e04a                	sd	s2,0(sp)
    80002baa:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002bac:	c115                	beqz	a0,80002bd0 <ilock+0x30>
    80002bae:	84aa                	mv	s1,a0
    80002bb0:	451c                	lw	a5,8(a0)
    80002bb2:	00f05f63          	blez	a5,80002bd0 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002bb6:	0541                	addi	a0,a0,16
    80002bb8:	00001097          	auipc	ra,0x1
    80002bbc:	cb2080e7          	jalr	-846(ra) # 8000386a <acquiresleep>
  if(ip->valid == 0){
    80002bc0:	40bc                	lw	a5,64(s1)
    80002bc2:	cf99                	beqz	a5,80002be0 <ilock+0x40>
}
    80002bc4:	60e2                	ld	ra,24(sp)
    80002bc6:	6442                	ld	s0,16(sp)
    80002bc8:	64a2                	ld	s1,8(sp)
    80002bca:	6902                	ld	s2,0(sp)
    80002bcc:	6105                	addi	sp,sp,32
    80002bce:	8082                	ret
    panic("ilock");
    80002bd0:	00006517          	auipc	a0,0x6
    80002bd4:	98850513          	addi	a0,a0,-1656 # 80008558 <syscalls+0x190>
    80002bd8:	00003097          	auipc	ra,0x3
    80002bdc:	080080e7          	jalr	128(ra) # 80005c58 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002be0:	40dc                	lw	a5,4(s1)
    80002be2:	0047d79b          	srliw	a5,a5,0x4
    80002be6:	00015597          	auipc	a1,0x15
    80002bea:	78a5a583          	lw	a1,1930(a1) # 80018370 <sb+0x18>
    80002bee:	9dbd                	addw	a1,a1,a5
    80002bf0:	4088                	lw	a0,0(s1)
    80002bf2:	fffff097          	auipc	ra,0xfffff
    80002bf6:	7ac080e7          	jalr	1964(ra) # 8000239e <bread>
    80002bfa:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002bfc:	05850593          	addi	a1,a0,88
    80002c00:	40dc                	lw	a5,4(s1)
    80002c02:	8bbd                	andi	a5,a5,15
    80002c04:	079a                	slli	a5,a5,0x6
    80002c06:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c08:	00059783          	lh	a5,0(a1)
    80002c0c:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c10:	00259783          	lh	a5,2(a1)
    80002c14:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c18:	00459783          	lh	a5,4(a1)
    80002c1c:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c20:	00659783          	lh	a5,6(a1)
    80002c24:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c28:	459c                	lw	a5,8(a1)
    80002c2a:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c2c:	03400613          	li	a2,52
    80002c30:	05b1                	addi	a1,a1,12
    80002c32:	05048513          	addi	a0,s1,80
    80002c36:	ffffd097          	auipc	ra,0xffffd
    80002c3a:	5a2080e7          	jalr	1442(ra) # 800001d8 <memmove>
    brelse(bp);
    80002c3e:	854a                	mv	a0,s2
    80002c40:	00000097          	auipc	ra,0x0
    80002c44:	88e080e7          	jalr	-1906(ra) # 800024ce <brelse>
    ip->valid = 1;
    80002c48:	4785                	li	a5,1
    80002c4a:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002c4c:	04449783          	lh	a5,68(s1)
    80002c50:	fbb5                	bnez	a5,80002bc4 <ilock+0x24>
      panic("ilock: no type");
    80002c52:	00006517          	auipc	a0,0x6
    80002c56:	90e50513          	addi	a0,a0,-1778 # 80008560 <syscalls+0x198>
    80002c5a:	00003097          	auipc	ra,0x3
    80002c5e:	ffe080e7          	jalr	-2(ra) # 80005c58 <panic>

0000000080002c62 <iunlock>:
{
    80002c62:	1101                	addi	sp,sp,-32
    80002c64:	ec06                	sd	ra,24(sp)
    80002c66:	e822                	sd	s0,16(sp)
    80002c68:	e426                	sd	s1,8(sp)
    80002c6a:	e04a                	sd	s2,0(sp)
    80002c6c:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c6e:	c905                	beqz	a0,80002c9e <iunlock+0x3c>
    80002c70:	84aa                	mv	s1,a0
    80002c72:	01050913          	addi	s2,a0,16
    80002c76:	854a                	mv	a0,s2
    80002c78:	00001097          	auipc	ra,0x1
    80002c7c:	c8c080e7          	jalr	-884(ra) # 80003904 <holdingsleep>
    80002c80:	cd19                	beqz	a0,80002c9e <iunlock+0x3c>
    80002c82:	449c                	lw	a5,8(s1)
    80002c84:	00f05d63          	blez	a5,80002c9e <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002c88:	854a                	mv	a0,s2
    80002c8a:	00001097          	auipc	ra,0x1
    80002c8e:	c36080e7          	jalr	-970(ra) # 800038c0 <releasesleep>
}
    80002c92:	60e2                	ld	ra,24(sp)
    80002c94:	6442                	ld	s0,16(sp)
    80002c96:	64a2                	ld	s1,8(sp)
    80002c98:	6902                	ld	s2,0(sp)
    80002c9a:	6105                	addi	sp,sp,32
    80002c9c:	8082                	ret
    panic("iunlock");
    80002c9e:	00006517          	auipc	a0,0x6
    80002ca2:	8d250513          	addi	a0,a0,-1838 # 80008570 <syscalls+0x1a8>
    80002ca6:	00003097          	auipc	ra,0x3
    80002caa:	fb2080e7          	jalr	-78(ra) # 80005c58 <panic>

0000000080002cae <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002cae:	7179                	addi	sp,sp,-48
    80002cb0:	f406                	sd	ra,40(sp)
    80002cb2:	f022                	sd	s0,32(sp)
    80002cb4:	ec26                	sd	s1,24(sp)
    80002cb6:	e84a                	sd	s2,16(sp)
    80002cb8:	e44e                	sd	s3,8(sp)
    80002cba:	e052                	sd	s4,0(sp)
    80002cbc:	1800                	addi	s0,sp,48
    80002cbe:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002cc0:	05050493          	addi	s1,a0,80
    80002cc4:	08050913          	addi	s2,a0,128
    80002cc8:	a021                	j	80002cd0 <itrunc+0x22>
    80002cca:	0491                	addi	s1,s1,4
    80002ccc:	01248d63          	beq	s1,s2,80002ce6 <itrunc+0x38>
    if(ip->addrs[i]){
    80002cd0:	408c                	lw	a1,0(s1)
    80002cd2:	dde5                	beqz	a1,80002cca <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002cd4:	0009a503          	lw	a0,0(s3)
    80002cd8:	00000097          	auipc	ra,0x0
    80002cdc:	90c080e7          	jalr	-1780(ra) # 800025e4 <bfree>
      ip->addrs[i] = 0;
    80002ce0:	0004a023          	sw	zero,0(s1)
    80002ce4:	b7dd                	j	80002cca <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002ce6:	0809a583          	lw	a1,128(s3)
    80002cea:	e185                	bnez	a1,80002d0a <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002cec:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002cf0:	854e                	mv	a0,s3
    80002cf2:	00000097          	auipc	ra,0x0
    80002cf6:	de4080e7          	jalr	-540(ra) # 80002ad6 <iupdate>
}
    80002cfa:	70a2                	ld	ra,40(sp)
    80002cfc:	7402                	ld	s0,32(sp)
    80002cfe:	64e2                	ld	s1,24(sp)
    80002d00:	6942                	ld	s2,16(sp)
    80002d02:	69a2                	ld	s3,8(sp)
    80002d04:	6a02                	ld	s4,0(sp)
    80002d06:	6145                	addi	sp,sp,48
    80002d08:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d0a:	0009a503          	lw	a0,0(s3)
    80002d0e:	fffff097          	auipc	ra,0xfffff
    80002d12:	690080e7          	jalr	1680(ra) # 8000239e <bread>
    80002d16:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d18:	05850493          	addi	s1,a0,88
    80002d1c:	45850913          	addi	s2,a0,1112
    80002d20:	a811                	j	80002d34 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002d22:	0009a503          	lw	a0,0(s3)
    80002d26:	00000097          	auipc	ra,0x0
    80002d2a:	8be080e7          	jalr	-1858(ra) # 800025e4 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002d2e:	0491                	addi	s1,s1,4
    80002d30:	01248563          	beq	s1,s2,80002d3a <itrunc+0x8c>
      if(a[j])
    80002d34:	408c                	lw	a1,0(s1)
    80002d36:	dde5                	beqz	a1,80002d2e <itrunc+0x80>
    80002d38:	b7ed                	j	80002d22 <itrunc+0x74>
    brelse(bp);
    80002d3a:	8552                	mv	a0,s4
    80002d3c:	fffff097          	auipc	ra,0xfffff
    80002d40:	792080e7          	jalr	1938(ra) # 800024ce <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d44:	0809a583          	lw	a1,128(s3)
    80002d48:	0009a503          	lw	a0,0(s3)
    80002d4c:	00000097          	auipc	ra,0x0
    80002d50:	898080e7          	jalr	-1896(ra) # 800025e4 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d54:	0809a023          	sw	zero,128(s3)
    80002d58:	bf51                	j	80002cec <itrunc+0x3e>

0000000080002d5a <iput>:
{
    80002d5a:	1101                	addi	sp,sp,-32
    80002d5c:	ec06                	sd	ra,24(sp)
    80002d5e:	e822                	sd	s0,16(sp)
    80002d60:	e426                	sd	s1,8(sp)
    80002d62:	e04a                	sd	s2,0(sp)
    80002d64:	1000                	addi	s0,sp,32
    80002d66:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d68:	00015517          	auipc	a0,0x15
    80002d6c:	61050513          	addi	a0,a0,1552 # 80018378 <itable>
    80002d70:	00003097          	auipc	ra,0x3
    80002d74:	488080e7          	jalr	1160(ra) # 800061f8 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d78:	4498                	lw	a4,8(s1)
    80002d7a:	4785                	li	a5,1
    80002d7c:	02f70363          	beq	a4,a5,80002da2 <iput+0x48>
  ip->ref--;
    80002d80:	449c                	lw	a5,8(s1)
    80002d82:	37fd                	addiw	a5,a5,-1
    80002d84:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d86:	00015517          	auipc	a0,0x15
    80002d8a:	5f250513          	addi	a0,a0,1522 # 80018378 <itable>
    80002d8e:	00003097          	auipc	ra,0x3
    80002d92:	51e080e7          	jalr	1310(ra) # 800062ac <release>
}
    80002d96:	60e2                	ld	ra,24(sp)
    80002d98:	6442                	ld	s0,16(sp)
    80002d9a:	64a2                	ld	s1,8(sp)
    80002d9c:	6902                	ld	s2,0(sp)
    80002d9e:	6105                	addi	sp,sp,32
    80002da0:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002da2:	40bc                	lw	a5,64(s1)
    80002da4:	dff1                	beqz	a5,80002d80 <iput+0x26>
    80002da6:	04a49783          	lh	a5,74(s1)
    80002daa:	fbf9                	bnez	a5,80002d80 <iput+0x26>
    acquiresleep(&ip->lock);
    80002dac:	01048913          	addi	s2,s1,16
    80002db0:	854a                	mv	a0,s2
    80002db2:	00001097          	auipc	ra,0x1
    80002db6:	ab8080e7          	jalr	-1352(ra) # 8000386a <acquiresleep>
    release(&itable.lock);
    80002dba:	00015517          	auipc	a0,0x15
    80002dbe:	5be50513          	addi	a0,a0,1470 # 80018378 <itable>
    80002dc2:	00003097          	auipc	ra,0x3
    80002dc6:	4ea080e7          	jalr	1258(ra) # 800062ac <release>
    itrunc(ip);
    80002dca:	8526                	mv	a0,s1
    80002dcc:	00000097          	auipc	ra,0x0
    80002dd0:	ee2080e7          	jalr	-286(ra) # 80002cae <itrunc>
    ip->type = 0;
    80002dd4:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002dd8:	8526                	mv	a0,s1
    80002dda:	00000097          	auipc	ra,0x0
    80002dde:	cfc080e7          	jalr	-772(ra) # 80002ad6 <iupdate>
    ip->valid = 0;
    80002de2:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002de6:	854a                	mv	a0,s2
    80002de8:	00001097          	auipc	ra,0x1
    80002dec:	ad8080e7          	jalr	-1320(ra) # 800038c0 <releasesleep>
    acquire(&itable.lock);
    80002df0:	00015517          	auipc	a0,0x15
    80002df4:	58850513          	addi	a0,a0,1416 # 80018378 <itable>
    80002df8:	00003097          	auipc	ra,0x3
    80002dfc:	400080e7          	jalr	1024(ra) # 800061f8 <acquire>
    80002e00:	b741                	j	80002d80 <iput+0x26>

0000000080002e02 <iunlockput>:
{
    80002e02:	1101                	addi	sp,sp,-32
    80002e04:	ec06                	sd	ra,24(sp)
    80002e06:	e822                	sd	s0,16(sp)
    80002e08:	e426                	sd	s1,8(sp)
    80002e0a:	1000                	addi	s0,sp,32
    80002e0c:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e0e:	00000097          	auipc	ra,0x0
    80002e12:	e54080e7          	jalr	-428(ra) # 80002c62 <iunlock>
  iput(ip);
    80002e16:	8526                	mv	a0,s1
    80002e18:	00000097          	auipc	ra,0x0
    80002e1c:	f42080e7          	jalr	-190(ra) # 80002d5a <iput>
}
    80002e20:	60e2                	ld	ra,24(sp)
    80002e22:	6442                	ld	s0,16(sp)
    80002e24:	64a2                	ld	s1,8(sp)
    80002e26:	6105                	addi	sp,sp,32
    80002e28:	8082                	ret

0000000080002e2a <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e2a:	1141                	addi	sp,sp,-16
    80002e2c:	e422                	sd	s0,8(sp)
    80002e2e:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e30:	411c                	lw	a5,0(a0)
    80002e32:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e34:	415c                	lw	a5,4(a0)
    80002e36:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e38:	04451783          	lh	a5,68(a0)
    80002e3c:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e40:	04a51783          	lh	a5,74(a0)
    80002e44:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e48:	04c56783          	lwu	a5,76(a0)
    80002e4c:	e99c                	sd	a5,16(a1)
}
    80002e4e:	6422                	ld	s0,8(sp)
    80002e50:	0141                	addi	sp,sp,16
    80002e52:	8082                	ret

0000000080002e54 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e54:	457c                	lw	a5,76(a0)
    80002e56:	0ed7e963          	bltu	a5,a3,80002f48 <readi+0xf4>
{
    80002e5a:	7159                	addi	sp,sp,-112
    80002e5c:	f486                	sd	ra,104(sp)
    80002e5e:	f0a2                	sd	s0,96(sp)
    80002e60:	eca6                	sd	s1,88(sp)
    80002e62:	e8ca                	sd	s2,80(sp)
    80002e64:	e4ce                	sd	s3,72(sp)
    80002e66:	e0d2                	sd	s4,64(sp)
    80002e68:	fc56                	sd	s5,56(sp)
    80002e6a:	f85a                	sd	s6,48(sp)
    80002e6c:	f45e                	sd	s7,40(sp)
    80002e6e:	f062                	sd	s8,32(sp)
    80002e70:	ec66                	sd	s9,24(sp)
    80002e72:	e86a                	sd	s10,16(sp)
    80002e74:	e46e                	sd	s11,8(sp)
    80002e76:	1880                	addi	s0,sp,112
    80002e78:	8baa                	mv	s7,a0
    80002e7a:	8c2e                	mv	s8,a1
    80002e7c:	8ab2                	mv	s5,a2
    80002e7e:	84b6                	mv	s1,a3
    80002e80:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002e82:	9f35                	addw	a4,a4,a3
    return 0;
    80002e84:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002e86:	0ad76063          	bltu	a4,a3,80002f26 <readi+0xd2>
  if(off + n > ip->size)
    80002e8a:	00e7f463          	bgeu	a5,a4,80002e92 <readi+0x3e>
    n = ip->size - off;
    80002e8e:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e92:	0a0b0963          	beqz	s6,80002f44 <readi+0xf0>
    80002e96:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e98:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002e9c:	5cfd                	li	s9,-1
    80002e9e:	a82d                	j	80002ed8 <readi+0x84>
    80002ea0:	020a1d93          	slli	s11,s4,0x20
    80002ea4:	020ddd93          	srli	s11,s11,0x20
    80002ea8:	05890613          	addi	a2,s2,88
    80002eac:	86ee                	mv	a3,s11
    80002eae:	963a                	add	a2,a2,a4
    80002eb0:	85d6                	mv	a1,s5
    80002eb2:	8562                	mv	a0,s8
    80002eb4:	fffff097          	auipc	ra,0xfffff
    80002eb8:	a30080e7          	jalr	-1488(ra) # 800018e4 <either_copyout>
    80002ebc:	05950d63          	beq	a0,s9,80002f16 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002ec0:	854a                	mv	a0,s2
    80002ec2:	fffff097          	auipc	ra,0xfffff
    80002ec6:	60c080e7          	jalr	1548(ra) # 800024ce <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002eca:	013a09bb          	addw	s3,s4,s3
    80002ece:	009a04bb          	addw	s1,s4,s1
    80002ed2:	9aee                	add	s5,s5,s11
    80002ed4:	0569f763          	bgeu	s3,s6,80002f22 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002ed8:	000ba903          	lw	s2,0(s7)
    80002edc:	00a4d59b          	srliw	a1,s1,0xa
    80002ee0:	855e                	mv	a0,s7
    80002ee2:	00000097          	auipc	ra,0x0
    80002ee6:	8b0080e7          	jalr	-1872(ra) # 80002792 <bmap>
    80002eea:	0005059b          	sext.w	a1,a0
    80002eee:	854a                	mv	a0,s2
    80002ef0:	fffff097          	auipc	ra,0xfffff
    80002ef4:	4ae080e7          	jalr	1198(ra) # 8000239e <bread>
    80002ef8:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002efa:	3ff4f713          	andi	a4,s1,1023
    80002efe:	40ed07bb          	subw	a5,s10,a4
    80002f02:	413b06bb          	subw	a3,s6,s3
    80002f06:	8a3e                	mv	s4,a5
    80002f08:	2781                	sext.w	a5,a5
    80002f0a:	0006861b          	sext.w	a2,a3
    80002f0e:	f8f679e3          	bgeu	a2,a5,80002ea0 <readi+0x4c>
    80002f12:	8a36                	mv	s4,a3
    80002f14:	b771                	j	80002ea0 <readi+0x4c>
      brelse(bp);
    80002f16:	854a                	mv	a0,s2
    80002f18:	fffff097          	auipc	ra,0xfffff
    80002f1c:	5b6080e7          	jalr	1462(ra) # 800024ce <brelse>
      tot = -1;
    80002f20:	59fd                	li	s3,-1
  }
  return tot;
    80002f22:	0009851b          	sext.w	a0,s3
}
    80002f26:	70a6                	ld	ra,104(sp)
    80002f28:	7406                	ld	s0,96(sp)
    80002f2a:	64e6                	ld	s1,88(sp)
    80002f2c:	6946                	ld	s2,80(sp)
    80002f2e:	69a6                	ld	s3,72(sp)
    80002f30:	6a06                	ld	s4,64(sp)
    80002f32:	7ae2                	ld	s5,56(sp)
    80002f34:	7b42                	ld	s6,48(sp)
    80002f36:	7ba2                	ld	s7,40(sp)
    80002f38:	7c02                	ld	s8,32(sp)
    80002f3a:	6ce2                	ld	s9,24(sp)
    80002f3c:	6d42                	ld	s10,16(sp)
    80002f3e:	6da2                	ld	s11,8(sp)
    80002f40:	6165                	addi	sp,sp,112
    80002f42:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f44:	89da                	mv	s3,s6
    80002f46:	bff1                	j	80002f22 <readi+0xce>
    return 0;
    80002f48:	4501                	li	a0,0
}
    80002f4a:	8082                	ret

0000000080002f4c <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f4c:	457c                	lw	a5,76(a0)
    80002f4e:	10d7e863          	bltu	a5,a3,8000305e <writei+0x112>
{
    80002f52:	7159                	addi	sp,sp,-112
    80002f54:	f486                	sd	ra,104(sp)
    80002f56:	f0a2                	sd	s0,96(sp)
    80002f58:	eca6                	sd	s1,88(sp)
    80002f5a:	e8ca                	sd	s2,80(sp)
    80002f5c:	e4ce                	sd	s3,72(sp)
    80002f5e:	e0d2                	sd	s4,64(sp)
    80002f60:	fc56                	sd	s5,56(sp)
    80002f62:	f85a                	sd	s6,48(sp)
    80002f64:	f45e                	sd	s7,40(sp)
    80002f66:	f062                	sd	s8,32(sp)
    80002f68:	ec66                	sd	s9,24(sp)
    80002f6a:	e86a                	sd	s10,16(sp)
    80002f6c:	e46e                	sd	s11,8(sp)
    80002f6e:	1880                	addi	s0,sp,112
    80002f70:	8b2a                	mv	s6,a0
    80002f72:	8c2e                	mv	s8,a1
    80002f74:	8ab2                	mv	s5,a2
    80002f76:	8936                	mv	s2,a3
    80002f78:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002f7a:	00e687bb          	addw	a5,a3,a4
    80002f7e:	0ed7e263          	bltu	a5,a3,80003062 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002f82:	00043737          	lui	a4,0x43
    80002f86:	0ef76063          	bltu	a4,a5,80003066 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f8a:	0c0b8863          	beqz	s7,8000305a <writei+0x10e>
    80002f8e:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f90:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002f94:	5cfd                	li	s9,-1
    80002f96:	a091                	j	80002fda <writei+0x8e>
    80002f98:	02099d93          	slli	s11,s3,0x20
    80002f9c:	020ddd93          	srli	s11,s11,0x20
    80002fa0:	05848513          	addi	a0,s1,88
    80002fa4:	86ee                	mv	a3,s11
    80002fa6:	8656                	mv	a2,s5
    80002fa8:	85e2                	mv	a1,s8
    80002faa:	953a                	add	a0,a0,a4
    80002fac:	fffff097          	auipc	ra,0xfffff
    80002fb0:	98e080e7          	jalr	-1650(ra) # 8000193a <either_copyin>
    80002fb4:	07950263          	beq	a0,s9,80003018 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002fb8:	8526                	mv	a0,s1
    80002fba:	00000097          	auipc	ra,0x0
    80002fbe:	790080e7          	jalr	1936(ra) # 8000374a <log_write>
    brelse(bp);
    80002fc2:	8526                	mv	a0,s1
    80002fc4:	fffff097          	auipc	ra,0xfffff
    80002fc8:	50a080e7          	jalr	1290(ra) # 800024ce <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fcc:	01498a3b          	addw	s4,s3,s4
    80002fd0:	0129893b          	addw	s2,s3,s2
    80002fd4:	9aee                	add	s5,s5,s11
    80002fd6:	057a7663          	bgeu	s4,s7,80003022 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002fda:	000b2483          	lw	s1,0(s6)
    80002fde:	00a9559b          	srliw	a1,s2,0xa
    80002fe2:	855a                	mv	a0,s6
    80002fe4:	fffff097          	auipc	ra,0xfffff
    80002fe8:	7ae080e7          	jalr	1966(ra) # 80002792 <bmap>
    80002fec:	0005059b          	sext.w	a1,a0
    80002ff0:	8526                	mv	a0,s1
    80002ff2:	fffff097          	auipc	ra,0xfffff
    80002ff6:	3ac080e7          	jalr	940(ra) # 8000239e <bread>
    80002ffa:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ffc:	3ff97713          	andi	a4,s2,1023
    80003000:	40ed07bb          	subw	a5,s10,a4
    80003004:	414b86bb          	subw	a3,s7,s4
    80003008:	89be                	mv	s3,a5
    8000300a:	2781                	sext.w	a5,a5
    8000300c:	0006861b          	sext.w	a2,a3
    80003010:	f8f674e3          	bgeu	a2,a5,80002f98 <writei+0x4c>
    80003014:	89b6                	mv	s3,a3
    80003016:	b749                	j	80002f98 <writei+0x4c>
      brelse(bp);
    80003018:	8526                	mv	a0,s1
    8000301a:	fffff097          	auipc	ra,0xfffff
    8000301e:	4b4080e7          	jalr	1204(ra) # 800024ce <brelse>
  }

  if(off > ip->size)
    80003022:	04cb2783          	lw	a5,76(s6)
    80003026:	0127f463          	bgeu	a5,s2,8000302e <writei+0xe2>
    ip->size = off;
    8000302a:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000302e:	855a                	mv	a0,s6
    80003030:	00000097          	auipc	ra,0x0
    80003034:	aa6080e7          	jalr	-1370(ra) # 80002ad6 <iupdate>

  return tot;
    80003038:	000a051b          	sext.w	a0,s4
}
    8000303c:	70a6                	ld	ra,104(sp)
    8000303e:	7406                	ld	s0,96(sp)
    80003040:	64e6                	ld	s1,88(sp)
    80003042:	6946                	ld	s2,80(sp)
    80003044:	69a6                	ld	s3,72(sp)
    80003046:	6a06                	ld	s4,64(sp)
    80003048:	7ae2                	ld	s5,56(sp)
    8000304a:	7b42                	ld	s6,48(sp)
    8000304c:	7ba2                	ld	s7,40(sp)
    8000304e:	7c02                	ld	s8,32(sp)
    80003050:	6ce2                	ld	s9,24(sp)
    80003052:	6d42                	ld	s10,16(sp)
    80003054:	6da2                	ld	s11,8(sp)
    80003056:	6165                	addi	sp,sp,112
    80003058:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000305a:	8a5e                	mv	s4,s7
    8000305c:	bfc9                	j	8000302e <writei+0xe2>
    return -1;
    8000305e:	557d                	li	a0,-1
}
    80003060:	8082                	ret
    return -1;
    80003062:	557d                	li	a0,-1
    80003064:	bfe1                	j	8000303c <writei+0xf0>
    return -1;
    80003066:	557d                	li	a0,-1
    80003068:	bfd1                	j	8000303c <writei+0xf0>

000000008000306a <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000306a:	1141                	addi	sp,sp,-16
    8000306c:	e406                	sd	ra,8(sp)
    8000306e:	e022                	sd	s0,0(sp)
    80003070:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003072:	4639                	li	a2,14
    80003074:	ffffd097          	auipc	ra,0xffffd
    80003078:	1dc080e7          	jalr	476(ra) # 80000250 <strncmp>
}
    8000307c:	60a2                	ld	ra,8(sp)
    8000307e:	6402                	ld	s0,0(sp)
    80003080:	0141                	addi	sp,sp,16
    80003082:	8082                	ret

0000000080003084 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003084:	7139                	addi	sp,sp,-64
    80003086:	fc06                	sd	ra,56(sp)
    80003088:	f822                	sd	s0,48(sp)
    8000308a:	f426                	sd	s1,40(sp)
    8000308c:	f04a                	sd	s2,32(sp)
    8000308e:	ec4e                	sd	s3,24(sp)
    80003090:	e852                	sd	s4,16(sp)
    80003092:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003094:	04451703          	lh	a4,68(a0)
    80003098:	4785                	li	a5,1
    8000309a:	00f71a63          	bne	a4,a5,800030ae <dirlookup+0x2a>
    8000309e:	892a                	mv	s2,a0
    800030a0:	89ae                	mv	s3,a1
    800030a2:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800030a4:	457c                	lw	a5,76(a0)
    800030a6:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800030a8:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030aa:	e79d                	bnez	a5,800030d8 <dirlookup+0x54>
    800030ac:	a8a5                	j	80003124 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800030ae:	00005517          	auipc	a0,0x5
    800030b2:	4ca50513          	addi	a0,a0,1226 # 80008578 <syscalls+0x1b0>
    800030b6:	00003097          	auipc	ra,0x3
    800030ba:	ba2080e7          	jalr	-1118(ra) # 80005c58 <panic>
      panic("dirlookup read");
    800030be:	00005517          	auipc	a0,0x5
    800030c2:	4d250513          	addi	a0,a0,1234 # 80008590 <syscalls+0x1c8>
    800030c6:	00003097          	auipc	ra,0x3
    800030ca:	b92080e7          	jalr	-1134(ra) # 80005c58 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030ce:	24c1                	addiw	s1,s1,16
    800030d0:	04c92783          	lw	a5,76(s2)
    800030d4:	04f4f763          	bgeu	s1,a5,80003122 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800030d8:	4741                	li	a4,16
    800030da:	86a6                	mv	a3,s1
    800030dc:	fc040613          	addi	a2,s0,-64
    800030e0:	4581                	li	a1,0
    800030e2:	854a                	mv	a0,s2
    800030e4:	00000097          	auipc	ra,0x0
    800030e8:	d70080e7          	jalr	-656(ra) # 80002e54 <readi>
    800030ec:	47c1                	li	a5,16
    800030ee:	fcf518e3          	bne	a0,a5,800030be <dirlookup+0x3a>
    if(de.inum == 0)
    800030f2:	fc045783          	lhu	a5,-64(s0)
    800030f6:	dfe1                	beqz	a5,800030ce <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800030f8:	fc240593          	addi	a1,s0,-62
    800030fc:	854e                	mv	a0,s3
    800030fe:	00000097          	auipc	ra,0x0
    80003102:	f6c080e7          	jalr	-148(ra) # 8000306a <namecmp>
    80003106:	f561                	bnez	a0,800030ce <dirlookup+0x4a>
      if(poff)
    80003108:	000a0463          	beqz	s4,80003110 <dirlookup+0x8c>
        *poff = off;
    8000310c:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003110:	fc045583          	lhu	a1,-64(s0)
    80003114:	00092503          	lw	a0,0(s2)
    80003118:	fffff097          	auipc	ra,0xfffff
    8000311c:	754080e7          	jalr	1876(ra) # 8000286c <iget>
    80003120:	a011                	j	80003124 <dirlookup+0xa0>
  return 0;
    80003122:	4501                	li	a0,0
}
    80003124:	70e2                	ld	ra,56(sp)
    80003126:	7442                	ld	s0,48(sp)
    80003128:	74a2                	ld	s1,40(sp)
    8000312a:	7902                	ld	s2,32(sp)
    8000312c:	69e2                	ld	s3,24(sp)
    8000312e:	6a42                	ld	s4,16(sp)
    80003130:	6121                	addi	sp,sp,64
    80003132:	8082                	ret

0000000080003134 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003134:	711d                	addi	sp,sp,-96
    80003136:	ec86                	sd	ra,88(sp)
    80003138:	e8a2                	sd	s0,80(sp)
    8000313a:	e4a6                	sd	s1,72(sp)
    8000313c:	e0ca                	sd	s2,64(sp)
    8000313e:	fc4e                	sd	s3,56(sp)
    80003140:	f852                	sd	s4,48(sp)
    80003142:	f456                	sd	s5,40(sp)
    80003144:	f05a                	sd	s6,32(sp)
    80003146:	ec5e                	sd	s7,24(sp)
    80003148:	e862                	sd	s8,16(sp)
    8000314a:	e466                	sd	s9,8(sp)
    8000314c:	1080                	addi	s0,sp,96
    8000314e:	84aa                	mv	s1,a0
    80003150:	8b2e                	mv	s6,a1
    80003152:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003154:	00054703          	lbu	a4,0(a0)
    80003158:	02f00793          	li	a5,47
    8000315c:	02f70363          	beq	a4,a5,80003182 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003160:	ffffe097          	auipc	ra,0xffffe
    80003164:	ce8080e7          	jalr	-792(ra) # 80000e48 <myproc>
    80003168:	17853503          	ld	a0,376(a0)
    8000316c:	00000097          	auipc	ra,0x0
    80003170:	9f6080e7          	jalr	-1546(ra) # 80002b62 <idup>
    80003174:	89aa                	mv	s3,a0
  while(*path == '/')
    80003176:	02f00913          	li	s2,47
  len = path - s;
    8000317a:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    8000317c:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000317e:	4c05                	li	s8,1
    80003180:	a865                	j	80003238 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003182:	4585                	li	a1,1
    80003184:	4505                	li	a0,1
    80003186:	fffff097          	auipc	ra,0xfffff
    8000318a:	6e6080e7          	jalr	1766(ra) # 8000286c <iget>
    8000318e:	89aa                	mv	s3,a0
    80003190:	b7dd                	j	80003176 <namex+0x42>
      iunlockput(ip);
    80003192:	854e                	mv	a0,s3
    80003194:	00000097          	auipc	ra,0x0
    80003198:	c6e080e7          	jalr	-914(ra) # 80002e02 <iunlockput>
      return 0;
    8000319c:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000319e:	854e                	mv	a0,s3
    800031a0:	60e6                	ld	ra,88(sp)
    800031a2:	6446                	ld	s0,80(sp)
    800031a4:	64a6                	ld	s1,72(sp)
    800031a6:	6906                	ld	s2,64(sp)
    800031a8:	79e2                	ld	s3,56(sp)
    800031aa:	7a42                	ld	s4,48(sp)
    800031ac:	7aa2                	ld	s5,40(sp)
    800031ae:	7b02                	ld	s6,32(sp)
    800031b0:	6be2                	ld	s7,24(sp)
    800031b2:	6c42                	ld	s8,16(sp)
    800031b4:	6ca2                	ld	s9,8(sp)
    800031b6:	6125                	addi	sp,sp,96
    800031b8:	8082                	ret
      iunlock(ip);
    800031ba:	854e                	mv	a0,s3
    800031bc:	00000097          	auipc	ra,0x0
    800031c0:	aa6080e7          	jalr	-1370(ra) # 80002c62 <iunlock>
      return ip;
    800031c4:	bfe9                	j	8000319e <namex+0x6a>
      iunlockput(ip);
    800031c6:	854e                	mv	a0,s3
    800031c8:	00000097          	auipc	ra,0x0
    800031cc:	c3a080e7          	jalr	-966(ra) # 80002e02 <iunlockput>
      return 0;
    800031d0:	89d2                	mv	s3,s4
    800031d2:	b7f1                	j	8000319e <namex+0x6a>
  len = path - s;
    800031d4:	40b48633          	sub	a2,s1,a1
    800031d8:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    800031dc:	094cd463          	bge	s9,s4,80003264 <namex+0x130>
    memmove(name, s, DIRSIZ);
    800031e0:	4639                	li	a2,14
    800031e2:	8556                	mv	a0,s5
    800031e4:	ffffd097          	auipc	ra,0xffffd
    800031e8:	ff4080e7          	jalr	-12(ra) # 800001d8 <memmove>
  while(*path == '/')
    800031ec:	0004c783          	lbu	a5,0(s1)
    800031f0:	01279763          	bne	a5,s2,800031fe <namex+0xca>
    path++;
    800031f4:	0485                	addi	s1,s1,1
  while(*path == '/')
    800031f6:	0004c783          	lbu	a5,0(s1)
    800031fa:	ff278de3          	beq	a5,s2,800031f4 <namex+0xc0>
    ilock(ip);
    800031fe:	854e                	mv	a0,s3
    80003200:	00000097          	auipc	ra,0x0
    80003204:	9a0080e7          	jalr	-1632(ra) # 80002ba0 <ilock>
    if(ip->type != T_DIR){
    80003208:	04499783          	lh	a5,68(s3)
    8000320c:	f98793e3          	bne	a5,s8,80003192 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003210:	000b0563          	beqz	s6,8000321a <namex+0xe6>
    80003214:	0004c783          	lbu	a5,0(s1)
    80003218:	d3cd                	beqz	a5,800031ba <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000321a:	865e                	mv	a2,s7
    8000321c:	85d6                	mv	a1,s5
    8000321e:	854e                	mv	a0,s3
    80003220:	00000097          	auipc	ra,0x0
    80003224:	e64080e7          	jalr	-412(ra) # 80003084 <dirlookup>
    80003228:	8a2a                	mv	s4,a0
    8000322a:	dd51                	beqz	a0,800031c6 <namex+0x92>
    iunlockput(ip);
    8000322c:	854e                	mv	a0,s3
    8000322e:	00000097          	auipc	ra,0x0
    80003232:	bd4080e7          	jalr	-1068(ra) # 80002e02 <iunlockput>
    ip = next;
    80003236:	89d2                	mv	s3,s4
  while(*path == '/')
    80003238:	0004c783          	lbu	a5,0(s1)
    8000323c:	05279763          	bne	a5,s2,8000328a <namex+0x156>
    path++;
    80003240:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003242:	0004c783          	lbu	a5,0(s1)
    80003246:	ff278de3          	beq	a5,s2,80003240 <namex+0x10c>
  if(*path == 0)
    8000324a:	c79d                	beqz	a5,80003278 <namex+0x144>
    path++;
    8000324c:	85a6                	mv	a1,s1
  len = path - s;
    8000324e:	8a5e                	mv	s4,s7
    80003250:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003252:	01278963          	beq	a5,s2,80003264 <namex+0x130>
    80003256:	dfbd                	beqz	a5,800031d4 <namex+0xa0>
    path++;
    80003258:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    8000325a:	0004c783          	lbu	a5,0(s1)
    8000325e:	ff279ce3          	bne	a5,s2,80003256 <namex+0x122>
    80003262:	bf8d                	j	800031d4 <namex+0xa0>
    memmove(name, s, len);
    80003264:	2601                	sext.w	a2,a2
    80003266:	8556                	mv	a0,s5
    80003268:	ffffd097          	auipc	ra,0xffffd
    8000326c:	f70080e7          	jalr	-144(ra) # 800001d8 <memmove>
    name[len] = 0;
    80003270:	9a56                	add	s4,s4,s5
    80003272:	000a0023          	sb	zero,0(s4)
    80003276:	bf9d                	j	800031ec <namex+0xb8>
  if(nameiparent){
    80003278:	f20b03e3          	beqz	s6,8000319e <namex+0x6a>
    iput(ip);
    8000327c:	854e                	mv	a0,s3
    8000327e:	00000097          	auipc	ra,0x0
    80003282:	adc080e7          	jalr	-1316(ra) # 80002d5a <iput>
    return 0;
    80003286:	4981                	li	s3,0
    80003288:	bf19                	j	8000319e <namex+0x6a>
  if(*path == 0)
    8000328a:	d7fd                	beqz	a5,80003278 <namex+0x144>
  while(*path != '/' && *path != 0)
    8000328c:	0004c783          	lbu	a5,0(s1)
    80003290:	85a6                	mv	a1,s1
    80003292:	b7d1                	j	80003256 <namex+0x122>

0000000080003294 <dirlink>:
{
    80003294:	7139                	addi	sp,sp,-64
    80003296:	fc06                	sd	ra,56(sp)
    80003298:	f822                	sd	s0,48(sp)
    8000329a:	f426                	sd	s1,40(sp)
    8000329c:	f04a                	sd	s2,32(sp)
    8000329e:	ec4e                	sd	s3,24(sp)
    800032a0:	e852                	sd	s4,16(sp)
    800032a2:	0080                	addi	s0,sp,64
    800032a4:	892a                	mv	s2,a0
    800032a6:	8a2e                	mv	s4,a1
    800032a8:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800032aa:	4601                	li	a2,0
    800032ac:	00000097          	auipc	ra,0x0
    800032b0:	dd8080e7          	jalr	-552(ra) # 80003084 <dirlookup>
    800032b4:	e93d                	bnez	a0,8000332a <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032b6:	04c92483          	lw	s1,76(s2)
    800032ba:	c49d                	beqz	s1,800032e8 <dirlink+0x54>
    800032bc:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032be:	4741                	li	a4,16
    800032c0:	86a6                	mv	a3,s1
    800032c2:	fc040613          	addi	a2,s0,-64
    800032c6:	4581                	li	a1,0
    800032c8:	854a                	mv	a0,s2
    800032ca:	00000097          	auipc	ra,0x0
    800032ce:	b8a080e7          	jalr	-1142(ra) # 80002e54 <readi>
    800032d2:	47c1                	li	a5,16
    800032d4:	06f51163          	bne	a0,a5,80003336 <dirlink+0xa2>
    if(de.inum == 0)
    800032d8:	fc045783          	lhu	a5,-64(s0)
    800032dc:	c791                	beqz	a5,800032e8 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032de:	24c1                	addiw	s1,s1,16
    800032e0:	04c92783          	lw	a5,76(s2)
    800032e4:	fcf4ede3          	bltu	s1,a5,800032be <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800032e8:	4639                	li	a2,14
    800032ea:	85d2                	mv	a1,s4
    800032ec:	fc240513          	addi	a0,s0,-62
    800032f0:	ffffd097          	auipc	ra,0xffffd
    800032f4:	f9c080e7          	jalr	-100(ra) # 8000028c <strncpy>
  de.inum = inum;
    800032f8:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032fc:	4741                	li	a4,16
    800032fe:	86a6                	mv	a3,s1
    80003300:	fc040613          	addi	a2,s0,-64
    80003304:	4581                	li	a1,0
    80003306:	854a                	mv	a0,s2
    80003308:	00000097          	auipc	ra,0x0
    8000330c:	c44080e7          	jalr	-956(ra) # 80002f4c <writei>
    80003310:	872a                	mv	a4,a0
    80003312:	47c1                	li	a5,16
  return 0;
    80003314:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003316:	02f71863          	bne	a4,a5,80003346 <dirlink+0xb2>
}
    8000331a:	70e2                	ld	ra,56(sp)
    8000331c:	7442                	ld	s0,48(sp)
    8000331e:	74a2                	ld	s1,40(sp)
    80003320:	7902                	ld	s2,32(sp)
    80003322:	69e2                	ld	s3,24(sp)
    80003324:	6a42                	ld	s4,16(sp)
    80003326:	6121                	addi	sp,sp,64
    80003328:	8082                	ret
    iput(ip);
    8000332a:	00000097          	auipc	ra,0x0
    8000332e:	a30080e7          	jalr	-1488(ra) # 80002d5a <iput>
    return -1;
    80003332:	557d                	li	a0,-1
    80003334:	b7dd                	j	8000331a <dirlink+0x86>
      panic("dirlink read");
    80003336:	00005517          	auipc	a0,0x5
    8000333a:	26a50513          	addi	a0,a0,618 # 800085a0 <syscalls+0x1d8>
    8000333e:	00003097          	auipc	ra,0x3
    80003342:	91a080e7          	jalr	-1766(ra) # 80005c58 <panic>
    panic("dirlink");
    80003346:	00005517          	auipc	a0,0x5
    8000334a:	36a50513          	addi	a0,a0,874 # 800086b0 <syscalls+0x2e8>
    8000334e:	00003097          	auipc	ra,0x3
    80003352:	90a080e7          	jalr	-1782(ra) # 80005c58 <panic>

0000000080003356 <namei>:

struct inode*
namei(char *path)
{
    80003356:	1101                	addi	sp,sp,-32
    80003358:	ec06                	sd	ra,24(sp)
    8000335a:	e822                	sd	s0,16(sp)
    8000335c:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000335e:	fe040613          	addi	a2,s0,-32
    80003362:	4581                	li	a1,0
    80003364:	00000097          	auipc	ra,0x0
    80003368:	dd0080e7          	jalr	-560(ra) # 80003134 <namex>
}
    8000336c:	60e2                	ld	ra,24(sp)
    8000336e:	6442                	ld	s0,16(sp)
    80003370:	6105                	addi	sp,sp,32
    80003372:	8082                	ret

0000000080003374 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003374:	1141                	addi	sp,sp,-16
    80003376:	e406                	sd	ra,8(sp)
    80003378:	e022                	sd	s0,0(sp)
    8000337a:	0800                	addi	s0,sp,16
    8000337c:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000337e:	4585                	li	a1,1
    80003380:	00000097          	auipc	ra,0x0
    80003384:	db4080e7          	jalr	-588(ra) # 80003134 <namex>
}
    80003388:	60a2                	ld	ra,8(sp)
    8000338a:	6402                	ld	s0,0(sp)
    8000338c:	0141                	addi	sp,sp,16
    8000338e:	8082                	ret

0000000080003390 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003390:	1101                	addi	sp,sp,-32
    80003392:	ec06                	sd	ra,24(sp)
    80003394:	e822                	sd	s0,16(sp)
    80003396:	e426                	sd	s1,8(sp)
    80003398:	e04a                	sd	s2,0(sp)
    8000339a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000339c:	00017917          	auipc	s2,0x17
    800033a0:	a8490913          	addi	s2,s2,-1404 # 80019e20 <log>
    800033a4:	01892583          	lw	a1,24(s2)
    800033a8:	02892503          	lw	a0,40(s2)
    800033ac:	fffff097          	auipc	ra,0xfffff
    800033b0:	ff2080e7          	jalr	-14(ra) # 8000239e <bread>
    800033b4:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800033b6:	02c92683          	lw	a3,44(s2)
    800033ba:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800033bc:	02d05763          	blez	a3,800033ea <write_head+0x5a>
    800033c0:	00017797          	auipc	a5,0x17
    800033c4:	a9078793          	addi	a5,a5,-1392 # 80019e50 <log+0x30>
    800033c8:	05c50713          	addi	a4,a0,92
    800033cc:	36fd                	addiw	a3,a3,-1
    800033ce:	1682                	slli	a3,a3,0x20
    800033d0:	9281                	srli	a3,a3,0x20
    800033d2:	068a                	slli	a3,a3,0x2
    800033d4:	00017617          	auipc	a2,0x17
    800033d8:	a8060613          	addi	a2,a2,-1408 # 80019e54 <log+0x34>
    800033dc:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800033de:	4390                	lw	a2,0(a5)
    800033e0:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800033e2:	0791                	addi	a5,a5,4
    800033e4:	0711                	addi	a4,a4,4
    800033e6:	fed79ce3          	bne	a5,a3,800033de <write_head+0x4e>
  }
  bwrite(buf);
    800033ea:	8526                	mv	a0,s1
    800033ec:	fffff097          	auipc	ra,0xfffff
    800033f0:	0a4080e7          	jalr	164(ra) # 80002490 <bwrite>
  brelse(buf);
    800033f4:	8526                	mv	a0,s1
    800033f6:	fffff097          	auipc	ra,0xfffff
    800033fa:	0d8080e7          	jalr	216(ra) # 800024ce <brelse>
}
    800033fe:	60e2                	ld	ra,24(sp)
    80003400:	6442                	ld	s0,16(sp)
    80003402:	64a2                	ld	s1,8(sp)
    80003404:	6902                	ld	s2,0(sp)
    80003406:	6105                	addi	sp,sp,32
    80003408:	8082                	ret

000000008000340a <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000340a:	00017797          	auipc	a5,0x17
    8000340e:	a427a783          	lw	a5,-1470(a5) # 80019e4c <log+0x2c>
    80003412:	0af05d63          	blez	a5,800034cc <install_trans+0xc2>
{
    80003416:	7139                	addi	sp,sp,-64
    80003418:	fc06                	sd	ra,56(sp)
    8000341a:	f822                	sd	s0,48(sp)
    8000341c:	f426                	sd	s1,40(sp)
    8000341e:	f04a                	sd	s2,32(sp)
    80003420:	ec4e                	sd	s3,24(sp)
    80003422:	e852                	sd	s4,16(sp)
    80003424:	e456                	sd	s5,8(sp)
    80003426:	e05a                	sd	s6,0(sp)
    80003428:	0080                	addi	s0,sp,64
    8000342a:	8b2a                	mv	s6,a0
    8000342c:	00017a97          	auipc	s5,0x17
    80003430:	a24a8a93          	addi	s5,s5,-1500 # 80019e50 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003434:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003436:	00017997          	auipc	s3,0x17
    8000343a:	9ea98993          	addi	s3,s3,-1558 # 80019e20 <log>
    8000343e:	a035                	j	8000346a <install_trans+0x60>
      bunpin(dbuf);
    80003440:	8526                	mv	a0,s1
    80003442:	fffff097          	auipc	ra,0xfffff
    80003446:	166080e7          	jalr	358(ra) # 800025a8 <bunpin>
    brelse(lbuf);
    8000344a:	854a                	mv	a0,s2
    8000344c:	fffff097          	auipc	ra,0xfffff
    80003450:	082080e7          	jalr	130(ra) # 800024ce <brelse>
    brelse(dbuf);
    80003454:	8526                	mv	a0,s1
    80003456:	fffff097          	auipc	ra,0xfffff
    8000345a:	078080e7          	jalr	120(ra) # 800024ce <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000345e:	2a05                	addiw	s4,s4,1
    80003460:	0a91                	addi	s5,s5,4
    80003462:	02c9a783          	lw	a5,44(s3)
    80003466:	04fa5963          	bge	s4,a5,800034b8 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000346a:	0189a583          	lw	a1,24(s3)
    8000346e:	014585bb          	addw	a1,a1,s4
    80003472:	2585                	addiw	a1,a1,1
    80003474:	0289a503          	lw	a0,40(s3)
    80003478:	fffff097          	auipc	ra,0xfffff
    8000347c:	f26080e7          	jalr	-218(ra) # 8000239e <bread>
    80003480:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003482:	000aa583          	lw	a1,0(s5)
    80003486:	0289a503          	lw	a0,40(s3)
    8000348a:	fffff097          	auipc	ra,0xfffff
    8000348e:	f14080e7          	jalr	-236(ra) # 8000239e <bread>
    80003492:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003494:	40000613          	li	a2,1024
    80003498:	05890593          	addi	a1,s2,88
    8000349c:	05850513          	addi	a0,a0,88
    800034a0:	ffffd097          	auipc	ra,0xffffd
    800034a4:	d38080e7          	jalr	-712(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    800034a8:	8526                	mv	a0,s1
    800034aa:	fffff097          	auipc	ra,0xfffff
    800034ae:	fe6080e7          	jalr	-26(ra) # 80002490 <bwrite>
    if(recovering == 0)
    800034b2:	f80b1ce3          	bnez	s6,8000344a <install_trans+0x40>
    800034b6:	b769                	j	80003440 <install_trans+0x36>
}
    800034b8:	70e2                	ld	ra,56(sp)
    800034ba:	7442                	ld	s0,48(sp)
    800034bc:	74a2                	ld	s1,40(sp)
    800034be:	7902                	ld	s2,32(sp)
    800034c0:	69e2                	ld	s3,24(sp)
    800034c2:	6a42                	ld	s4,16(sp)
    800034c4:	6aa2                	ld	s5,8(sp)
    800034c6:	6b02                	ld	s6,0(sp)
    800034c8:	6121                	addi	sp,sp,64
    800034ca:	8082                	ret
    800034cc:	8082                	ret

00000000800034ce <initlog>:
{
    800034ce:	7179                	addi	sp,sp,-48
    800034d0:	f406                	sd	ra,40(sp)
    800034d2:	f022                	sd	s0,32(sp)
    800034d4:	ec26                	sd	s1,24(sp)
    800034d6:	e84a                	sd	s2,16(sp)
    800034d8:	e44e                	sd	s3,8(sp)
    800034da:	1800                	addi	s0,sp,48
    800034dc:	892a                	mv	s2,a0
    800034de:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800034e0:	00017497          	auipc	s1,0x17
    800034e4:	94048493          	addi	s1,s1,-1728 # 80019e20 <log>
    800034e8:	00005597          	auipc	a1,0x5
    800034ec:	0c858593          	addi	a1,a1,200 # 800085b0 <syscalls+0x1e8>
    800034f0:	8526                	mv	a0,s1
    800034f2:	00003097          	auipc	ra,0x3
    800034f6:	c76080e7          	jalr	-906(ra) # 80006168 <initlock>
  log.start = sb->logstart;
    800034fa:	0149a583          	lw	a1,20(s3)
    800034fe:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003500:	0109a783          	lw	a5,16(s3)
    80003504:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003506:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000350a:	854a                	mv	a0,s2
    8000350c:	fffff097          	auipc	ra,0xfffff
    80003510:	e92080e7          	jalr	-366(ra) # 8000239e <bread>
  log.lh.n = lh->n;
    80003514:	4d3c                	lw	a5,88(a0)
    80003516:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003518:	02f05563          	blez	a5,80003542 <initlog+0x74>
    8000351c:	05c50713          	addi	a4,a0,92
    80003520:	00017697          	auipc	a3,0x17
    80003524:	93068693          	addi	a3,a3,-1744 # 80019e50 <log+0x30>
    80003528:	37fd                	addiw	a5,a5,-1
    8000352a:	1782                	slli	a5,a5,0x20
    8000352c:	9381                	srli	a5,a5,0x20
    8000352e:	078a                	slli	a5,a5,0x2
    80003530:	06050613          	addi	a2,a0,96
    80003534:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003536:	4310                	lw	a2,0(a4)
    80003538:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    8000353a:	0711                	addi	a4,a4,4
    8000353c:	0691                	addi	a3,a3,4
    8000353e:	fef71ce3          	bne	a4,a5,80003536 <initlog+0x68>
  brelse(buf);
    80003542:	fffff097          	auipc	ra,0xfffff
    80003546:	f8c080e7          	jalr	-116(ra) # 800024ce <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000354a:	4505                	li	a0,1
    8000354c:	00000097          	auipc	ra,0x0
    80003550:	ebe080e7          	jalr	-322(ra) # 8000340a <install_trans>
  log.lh.n = 0;
    80003554:	00017797          	auipc	a5,0x17
    80003558:	8e07ac23          	sw	zero,-1800(a5) # 80019e4c <log+0x2c>
  write_head(); // clear the log
    8000355c:	00000097          	auipc	ra,0x0
    80003560:	e34080e7          	jalr	-460(ra) # 80003390 <write_head>
}
    80003564:	70a2                	ld	ra,40(sp)
    80003566:	7402                	ld	s0,32(sp)
    80003568:	64e2                	ld	s1,24(sp)
    8000356a:	6942                	ld	s2,16(sp)
    8000356c:	69a2                	ld	s3,8(sp)
    8000356e:	6145                	addi	sp,sp,48
    80003570:	8082                	ret

0000000080003572 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003572:	1101                	addi	sp,sp,-32
    80003574:	ec06                	sd	ra,24(sp)
    80003576:	e822                	sd	s0,16(sp)
    80003578:	e426                	sd	s1,8(sp)
    8000357a:	e04a                	sd	s2,0(sp)
    8000357c:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000357e:	00017517          	auipc	a0,0x17
    80003582:	8a250513          	addi	a0,a0,-1886 # 80019e20 <log>
    80003586:	00003097          	auipc	ra,0x3
    8000358a:	c72080e7          	jalr	-910(ra) # 800061f8 <acquire>
  while(1){
    if(log.committing){
    8000358e:	00017497          	auipc	s1,0x17
    80003592:	89248493          	addi	s1,s1,-1902 # 80019e20 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003596:	4979                	li	s2,30
    80003598:	a039                	j	800035a6 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000359a:	85a6                	mv	a1,s1
    8000359c:	8526                	mv	a0,s1
    8000359e:	ffffe097          	auipc	ra,0xffffe
    800035a2:	fa2080e7          	jalr	-94(ra) # 80001540 <sleep>
    if(log.committing){
    800035a6:	50dc                	lw	a5,36(s1)
    800035a8:	fbed                	bnez	a5,8000359a <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035aa:	509c                	lw	a5,32(s1)
    800035ac:	0017871b          	addiw	a4,a5,1
    800035b0:	0007069b          	sext.w	a3,a4
    800035b4:	0027179b          	slliw	a5,a4,0x2
    800035b8:	9fb9                	addw	a5,a5,a4
    800035ba:	0017979b          	slliw	a5,a5,0x1
    800035be:	54d8                	lw	a4,44(s1)
    800035c0:	9fb9                	addw	a5,a5,a4
    800035c2:	00f95963          	bge	s2,a5,800035d4 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800035c6:	85a6                	mv	a1,s1
    800035c8:	8526                	mv	a0,s1
    800035ca:	ffffe097          	auipc	ra,0xffffe
    800035ce:	f76080e7          	jalr	-138(ra) # 80001540 <sleep>
    800035d2:	bfd1                	j	800035a6 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800035d4:	00017517          	auipc	a0,0x17
    800035d8:	84c50513          	addi	a0,a0,-1972 # 80019e20 <log>
    800035dc:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800035de:	00003097          	auipc	ra,0x3
    800035e2:	cce080e7          	jalr	-818(ra) # 800062ac <release>
      break;
    }
  }
}
    800035e6:	60e2                	ld	ra,24(sp)
    800035e8:	6442                	ld	s0,16(sp)
    800035ea:	64a2                	ld	s1,8(sp)
    800035ec:	6902                	ld	s2,0(sp)
    800035ee:	6105                	addi	sp,sp,32
    800035f0:	8082                	ret

00000000800035f2 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800035f2:	7139                	addi	sp,sp,-64
    800035f4:	fc06                	sd	ra,56(sp)
    800035f6:	f822                	sd	s0,48(sp)
    800035f8:	f426                	sd	s1,40(sp)
    800035fa:	f04a                	sd	s2,32(sp)
    800035fc:	ec4e                	sd	s3,24(sp)
    800035fe:	e852                	sd	s4,16(sp)
    80003600:	e456                	sd	s5,8(sp)
    80003602:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003604:	00017497          	auipc	s1,0x17
    80003608:	81c48493          	addi	s1,s1,-2020 # 80019e20 <log>
    8000360c:	8526                	mv	a0,s1
    8000360e:	00003097          	auipc	ra,0x3
    80003612:	bea080e7          	jalr	-1046(ra) # 800061f8 <acquire>
  log.outstanding -= 1;
    80003616:	509c                	lw	a5,32(s1)
    80003618:	37fd                	addiw	a5,a5,-1
    8000361a:	0007891b          	sext.w	s2,a5
    8000361e:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003620:	50dc                	lw	a5,36(s1)
    80003622:	efb9                	bnez	a5,80003680 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003624:	06091663          	bnez	s2,80003690 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80003628:	00016497          	auipc	s1,0x16
    8000362c:	7f848493          	addi	s1,s1,2040 # 80019e20 <log>
    80003630:	4785                	li	a5,1
    80003632:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003634:	8526                	mv	a0,s1
    80003636:	00003097          	auipc	ra,0x3
    8000363a:	c76080e7          	jalr	-906(ra) # 800062ac <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000363e:	54dc                	lw	a5,44(s1)
    80003640:	06f04763          	bgtz	a5,800036ae <end_op+0xbc>
    acquire(&log.lock);
    80003644:	00016497          	auipc	s1,0x16
    80003648:	7dc48493          	addi	s1,s1,2012 # 80019e20 <log>
    8000364c:	8526                	mv	a0,s1
    8000364e:	00003097          	auipc	ra,0x3
    80003652:	baa080e7          	jalr	-1110(ra) # 800061f8 <acquire>
    log.committing = 0;
    80003656:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000365a:	8526                	mv	a0,s1
    8000365c:	ffffe097          	auipc	ra,0xffffe
    80003660:	070080e7          	jalr	112(ra) # 800016cc <wakeup>
    release(&log.lock);
    80003664:	8526                	mv	a0,s1
    80003666:	00003097          	auipc	ra,0x3
    8000366a:	c46080e7          	jalr	-954(ra) # 800062ac <release>
}
    8000366e:	70e2                	ld	ra,56(sp)
    80003670:	7442                	ld	s0,48(sp)
    80003672:	74a2                	ld	s1,40(sp)
    80003674:	7902                	ld	s2,32(sp)
    80003676:	69e2                	ld	s3,24(sp)
    80003678:	6a42                	ld	s4,16(sp)
    8000367a:	6aa2                	ld	s5,8(sp)
    8000367c:	6121                	addi	sp,sp,64
    8000367e:	8082                	ret
    panic("log.committing");
    80003680:	00005517          	auipc	a0,0x5
    80003684:	f3850513          	addi	a0,a0,-200 # 800085b8 <syscalls+0x1f0>
    80003688:	00002097          	auipc	ra,0x2
    8000368c:	5d0080e7          	jalr	1488(ra) # 80005c58 <panic>
    wakeup(&log);
    80003690:	00016497          	auipc	s1,0x16
    80003694:	79048493          	addi	s1,s1,1936 # 80019e20 <log>
    80003698:	8526                	mv	a0,s1
    8000369a:	ffffe097          	auipc	ra,0xffffe
    8000369e:	032080e7          	jalr	50(ra) # 800016cc <wakeup>
  release(&log.lock);
    800036a2:	8526                	mv	a0,s1
    800036a4:	00003097          	auipc	ra,0x3
    800036a8:	c08080e7          	jalr	-1016(ra) # 800062ac <release>
  if(do_commit){
    800036ac:	b7c9                	j	8000366e <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036ae:	00016a97          	auipc	s5,0x16
    800036b2:	7a2a8a93          	addi	s5,s5,1954 # 80019e50 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800036b6:	00016a17          	auipc	s4,0x16
    800036ba:	76aa0a13          	addi	s4,s4,1898 # 80019e20 <log>
    800036be:	018a2583          	lw	a1,24(s4)
    800036c2:	012585bb          	addw	a1,a1,s2
    800036c6:	2585                	addiw	a1,a1,1
    800036c8:	028a2503          	lw	a0,40(s4)
    800036cc:	fffff097          	auipc	ra,0xfffff
    800036d0:	cd2080e7          	jalr	-814(ra) # 8000239e <bread>
    800036d4:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800036d6:	000aa583          	lw	a1,0(s5)
    800036da:	028a2503          	lw	a0,40(s4)
    800036de:	fffff097          	auipc	ra,0xfffff
    800036e2:	cc0080e7          	jalr	-832(ra) # 8000239e <bread>
    800036e6:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800036e8:	40000613          	li	a2,1024
    800036ec:	05850593          	addi	a1,a0,88
    800036f0:	05848513          	addi	a0,s1,88
    800036f4:	ffffd097          	auipc	ra,0xffffd
    800036f8:	ae4080e7          	jalr	-1308(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    800036fc:	8526                	mv	a0,s1
    800036fe:	fffff097          	auipc	ra,0xfffff
    80003702:	d92080e7          	jalr	-622(ra) # 80002490 <bwrite>
    brelse(from);
    80003706:	854e                	mv	a0,s3
    80003708:	fffff097          	auipc	ra,0xfffff
    8000370c:	dc6080e7          	jalr	-570(ra) # 800024ce <brelse>
    brelse(to);
    80003710:	8526                	mv	a0,s1
    80003712:	fffff097          	auipc	ra,0xfffff
    80003716:	dbc080e7          	jalr	-580(ra) # 800024ce <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000371a:	2905                	addiw	s2,s2,1
    8000371c:	0a91                	addi	s5,s5,4
    8000371e:	02ca2783          	lw	a5,44(s4)
    80003722:	f8f94ee3          	blt	s2,a5,800036be <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003726:	00000097          	auipc	ra,0x0
    8000372a:	c6a080e7          	jalr	-918(ra) # 80003390 <write_head>
    install_trans(0); // Now install writes to home locations
    8000372e:	4501                	li	a0,0
    80003730:	00000097          	auipc	ra,0x0
    80003734:	cda080e7          	jalr	-806(ra) # 8000340a <install_trans>
    log.lh.n = 0;
    80003738:	00016797          	auipc	a5,0x16
    8000373c:	7007aa23          	sw	zero,1812(a5) # 80019e4c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003740:	00000097          	auipc	ra,0x0
    80003744:	c50080e7          	jalr	-944(ra) # 80003390 <write_head>
    80003748:	bdf5                	j	80003644 <end_op+0x52>

000000008000374a <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000374a:	1101                	addi	sp,sp,-32
    8000374c:	ec06                	sd	ra,24(sp)
    8000374e:	e822                	sd	s0,16(sp)
    80003750:	e426                	sd	s1,8(sp)
    80003752:	e04a                	sd	s2,0(sp)
    80003754:	1000                	addi	s0,sp,32
    80003756:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003758:	00016917          	auipc	s2,0x16
    8000375c:	6c890913          	addi	s2,s2,1736 # 80019e20 <log>
    80003760:	854a                	mv	a0,s2
    80003762:	00003097          	auipc	ra,0x3
    80003766:	a96080e7          	jalr	-1386(ra) # 800061f8 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000376a:	02c92603          	lw	a2,44(s2)
    8000376e:	47f5                	li	a5,29
    80003770:	06c7c563          	blt	a5,a2,800037da <log_write+0x90>
    80003774:	00016797          	auipc	a5,0x16
    80003778:	6c87a783          	lw	a5,1736(a5) # 80019e3c <log+0x1c>
    8000377c:	37fd                	addiw	a5,a5,-1
    8000377e:	04f65e63          	bge	a2,a5,800037da <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003782:	00016797          	auipc	a5,0x16
    80003786:	6be7a783          	lw	a5,1726(a5) # 80019e40 <log+0x20>
    8000378a:	06f05063          	blez	a5,800037ea <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000378e:	4781                	li	a5,0
    80003790:	06c05563          	blez	a2,800037fa <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003794:	44cc                	lw	a1,12(s1)
    80003796:	00016717          	auipc	a4,0x16
    8000379a:	6ba70713          	addi	a4,a4,1722 # 80019e50 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000379e:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037a0:	4314                	lw	a3,0(a4)
    800037a2:	04b68c63          	beq	a3,a1,800037fa <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800037a6:	2785                	addiw	a5,a5,1
    800037a8:	0711                	addi	a4,a4,4
    800037aa:	fef61be3          	bne	a2,a5,800037a0 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800037ae:	0621                	addi	a2,a2,8
    800037b0:	060a                	slli	a2,a2,0x2
    800037b2:	00016797          	auipc	a5,0x16
    800037b6:	66e78793          	addi	a5,a5,1646 # 80019e20 <log>
    800037ba:	963e                	add	a2,a2,a5
    800037bc:	44dc                	lw	a5,12(s1)
    800037be:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800037c0:	8526                	mv	a0,s1
    800037c2:	fffff097          	auipc	ra,0xfffff
    800037c6:	daa080e7          	jalr	-598(ra) # 8000256c <bpin>
    log.lh.n++;
    800037ca:	00016717          	auipc	a4,0x16
    800037ce:	65670713          	addi	a4,a4,1622 # 80019e20 <log>
    800037d2:	575c                	lw	a5,44(a4)
    800037d4:	2785                	addiw	a5,a5,1
    800037d6:	d75c                	sw	a5,44(a4)
    800037d8:	a835                	j	80003814 <log_write+0xca>
    panic("too big a transaction");
    800037da:	00005517          	auipc	a0,0x5
    800037de:	dee50513          	addi	a0,a0,-530 # 800085c8 <syscalls+0x200>
    800037e2:	00002097          	auipc	ra,0x2
    800037e6:	476080e7          	jalr	1142(ra) # 80005c58 <panic>
    panic("log_write outside of trans");
    800037ea:	00005517          	auipc	a0,0x5
    800037ee:	df650513          	addi	a0,a0,-522 # 800085e0 <syscalls+0x218>
    800037f2:	00002097          	auipc	ra,0x2
    800037f6:	466080e7          	jalr	1126(ra) # 80005c58 <panic>
  log.lh.block[i] = b->blockno;
    800037fa:	00878713          	addi	a4,a5,8
    800037fe:	00271693          	slli	a3,a4,0x2
    80003802:	00016717          	auipc	a4,0x16
    80003806:	61e70713          	addi	a4,a4,1566 # 80019e20 <log>
    8000380a:	9736                	add	a4,a4,a3
    8000380c:	44d4                	lw	a3,12(s1)
    8000380e:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003810:	faf608e3          	beq	a2,a5,800037c0 <log_write+0x76>
  }
  release(&log.lock);
    80003814:	00016517          	auipc	a0,0x16
    80003818:	60c50513          	addi	a0,a0,1548 # 80019e20 <log>
    8000381c:	00003097          	auipc	ra,0x3
    80003820:	a90080e7          	jalr	-1392(ra) # 800062ac <release>
}
    80003824:	60e2                	ld	ra,24(sp)
    80003826:	6442                	ld	s0,16(sp)
    80003828:	64a2                	ld	s1,8(sp)
    8000382a:	6902                	ld	s2,0(sp)
    8000382c:	6105                	addi	sp,sp,32
    8000382e:	8082                	ret

0000000080003830 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003830:	1101                	addi	sp,sp,-32
    80003832:	ec06                	sd	ra,24(sp)
    80003834:	e822                	sd	s0,16(sp)
    80003836:	e426                	sd	s1,8(sp)
    80003838:	e04a                	sd	s2,0(sp)
    8000383a:	1000                	addi	s0,sp,32
    8000383c:	84aa                	mv	s1,a0
    8000383e:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003840:	00005597          	auipc	a1,0x5
    80003844:	dc058593          	addi	a1,a1,-576 # 80008600 <syscalls+0x238>
    80003848:	0521                	addi	a0,a0,8
    8000384a:	00003097          	auipc	ra,0x3
    8000384e:	91e080e7          	jalr	-1762(ra) # 80006168 <initlock>
  lk->name = name;
    80003852:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003856:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000385a:	0204a423          	sw	zero,40(s1)
}
    8000385e:	60e2                	ld	ra,24(sp)
    80003860:	6442                	ld	s0,16(sp)
    80003862:	64a2                	ld	s1,8(sp)
    80003864:	6902                	ld	s2,0(sp)
    80003866:	6105                	addi	sp,sp,32
    80003868:	8082                	ret

000000008000386a <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000386a:	1101                	addi	sp,sp,-32
    8000386c:	ec06                	sd	ra,24(sp)
    8000386e:	e822                	sd	s0,16(sp)
    80003870:	e426                	sd	s1,8(sp)
    80003872:	e04a                	sd	s2,0(sp)
    80003874:	1000                	addi	s0,sp,32
    80003876:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003878:	00850913          	addi	s2,a0,8
    8000387c:	854a                	mv	a0,s2
    8000387e:	00003097          	auipc	ra,0x3
    80003882:	97a080e7          	jalr	-1670(ra) # 800061f8 <acquire>
  while (lk->locked) {
    80003886:	409c                	lw	a5,0(s1)
    80003888:	cb89                	beqz	a5,8000389a <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000388a:	85ca                	mv	a1,s2
    8000388c:	8526                	mv	a0,s1
    8000388e:	ffffe097          	auipc	ra,0xffffe
    80003892:	cb2080e7          	jalr	-846(ra) # 80001540 <sleep>
  while (lk->locked) {
    80003896:	409c                	lw	a5,0(s1)
    80003898:	fbed                	bnez	a5,8000388a <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000389a:	4785                	li	a5,1
    8000389c:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000389e:	ffffd097          	auipc	ra,0xffffd
    800038a2:	5aa080e7          	jalr	1450(ra) # 80000e48 <myproc>
    800038a6:	591c                	lw	a5,48(a0)
    800038a8:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800038aa:	854a                	mv	a0,s2
    800038ac:	00003097          	auipc	ra,0x3
    800038b0:	a00080e7          	jalr	-1536(ra) # 800062ac <release>
}
    800038b4:	60e2                	ld	ra,24(sp)
    800038b6:	6442                	ld	s0,16(sp)
    800038b8:	64a2                	ld	s1,8(sp)
    800038ba:	6902                	ld	s2,0(sp)
    800038bc:	6105                	addi	sp,sp,32
    800038be:	8082                	ret

00000000800038c0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800038c0:	1101                	addi	sp,sp,-32
    800038c2:	ec06                	sd	ra,24(sp)
    800038c4:	e822                	sd	s0,16(sp)
    800038c6:	e426                	sd	s1,8(sp)
    800038c8:	e04a                	sd	s2,0(sp)
    800038ca:	1000                	addi	s0,sp,32
    800038cc:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038ce:	00850913          	addi	s2,a0,8
    800038d2:	854a                	mv	a0,s2
    800038d4:	00003097          	auipc	ra,0x3
    800038d8:	924080e7          	jalr	-1756(ra) # 800061f8 <acquire>
  lk->locked = 0;
    800038dc:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038e0:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800038e4:	8526                	mv	a0,s1
    800038e6:	ffffe097          	auipc	ra,0xffffe
    800038ea:	de6080e7          	jalr	-538(ra) # 800016cc <wakeup>
  release(&lk->lk);
    800038ee:	854a                	mv	a0,s2
    800038f0:	00003097          	auipc	ra,0x3
    800038f4:	9bc080e7          	jalr	-1604(ra) # 800062ac <release>
}
    800038f8:	60e2                	ld	ra,24(sp)
    800038fa:	6442                	ld	s0,16(sp)
    800038fc:	64a2                	ld	s1,8(sp)
    800038fe:	6902                	ld	s2,0(sp)
    80003900:	6105                	addi	sp,sp,32
    80003902:	8082                	ret

0000000080003904 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003904:	7179                	addi	sp,sp,-48
    80003906:	f406                	sd	ra,40(sp)
    80003908:	f022                	sd	s0,32(sp)
    8000390a:	ec26                	sd	s1,24(sp)
    8000390c:	e84a                	sd	s2,16(sp)
    8000390e:	e44e                	sd	s3,8(sp)
    80003910:	1800                	addi	s0,sp,48
    80003912:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003914:	00850913          	addi	s2,a0,8
    80003918:	854a                	mv	a0,s2
    8000391a:	00003097          	auipc	ra,0x3
    8000391e:	8de080e7          	jalr	-1826(ra) # 800061f8 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003922:	409c                	lw	a5,0(s1)
    80003924:	ef99                	bnez	a5,80003942 <holdingsleep+0x3e>
    80003926:	4481                	li	s1,0
  release(&lk->lk);
    80003928:	854a                	mv	a0,s2
    8000392a:	00003097          	auipc	ra,0x3
    8000392e:	982080e7          	jalr	-1662(ra) # 800062ac <release>
  return r;
}
    80003932:	8526                	mv	a0,s1
    80003934:	70a2                	ld	ra,40(sp)
    80003936:	7402                	ld	s0,32(sp)
    80003938:	64e2                	ld	s1,24(sp)
    8000393a:	6942                	ld	s2,16(sp)
    8000393c:	69a2                	ld	s3,8(sp)
    8000393e:	6145                	addi	sp,sp,48
    80003940:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003942:	0284a983          	lw	s3,40(s1)
    80003946:	ffffd097          	auipc	ra,0xffffd
    8000394a:	502080e7          	jalr	1282(ra) # 80000e48 <myproc>
    8000394e:	5904                	lw	s1,48(a0)
    80003950:	413484b3          	sub	s1,s1,s3
    80003954:	0014b493          	seqz	s1,s1
    80003958:	bfc1                	j	80003928 <holdingsleep+0x24>

000000008000395a <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000395a:	1141                	addi	sp,sp,-16
    8000395c:	e406                	sd	ra,8(sp)
    8000395e:	e022                	sd	s0,0(sp)
    80003960:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003962:	00005597          	auipc	a1,0x5
    80003966:	cae58593          	addi	a1,a1,-850 # 80008610 <syscalls+0x248>
    8000396a:	00016517          	auipc	a0,0x16
    8000396e:	5fe50513          	addi	a0,a0,1534 # 80019f68 <ftable>
    80003972:	00002097          	auipc	ra,0x2
    80003976:	7f6080e7          	jalr	2038(ra) # 80006168 <initlock>
}
    8000397a:	60a2                	ld	ra,8(sp)
    8000397c:	6402                	ld	s0,0(sp)
    8000397e:	0141                	addi	sp,sp,16
    80003980:	8082                	ret

0000000080003982 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003982:	1101                	addi	sp,sp,-32
    80003984:	ec06                	sd	ra,24(sp)
    80003986:	e822                	sd	s0,16(sp)
    80003988:	e426                	sd	s1,8(sp)
    8000398a:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000398c:	00016517          	auipc	a0,0x16
    80003990:	5dc50513          	addi	a0,a0,1500 # 80019f68 <ftable>
    80003994:	00003097          	auipc	ra,0x3
    80003998:	864080e7          	jalr	-1948(ra) # 800061f8 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000399c:	00016497          	auipc	s1,0x16
    800039a0:	5e448493          	addi	s1,s1,1508 # 80019f80 <ftable+0x18>
    800039a4:	00017717          	auipc	a4,0x17
    800039a8:	57c70713          	addi	a4,a4,1404 # 8001af20 <ftable+0xfb8>
    if(f->ref == 0){
    800039ac:	40dc                	lw	a5,4(s1)
    800039ae:	cf99                	beqz	a5,800039cc <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039b0:	02848493          	addi	s1,s1,40
    800039b4:	fee49ce3          	bne	s1,a4,800039ac <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800039b8:	00016517          	auipc	a0,0x16
    800039bc:	5b050513          	addi	a0,a0,1456 # 80019f68 <ftable>
    800039c0:	00003097          	auipc	ra,0x3
    800039c4:	8ec080e7          	jalr	-1812(ra) # 800062ac <release>
  return 0;
    800039c8:	4481                	li	s1,0
    800039ca:	a819                	j	800039e0 <filealloc+0x5e>
      f->ref = 1;
    800039cc:	4785                	li	a5,1
    800039ce:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800039d0:	00016517          	auipc	a0,0x16
    800039d4:	59850513          	addi	a0,a0,1432 # 80019f68 <ftable>
    800039d8:	00003097          	auipc	ra,0x3
    800039dc:	8d4080e7          	jalr	-1836(ra) # 800062ac <release>
}
    800039e0:	8526                	mv	a0,s1
    800039e2:	60e2                	ld	ra,24(sp)
    800039e4:	6442                	ld	s0,16(sp)
    800039e6:	64a2                	ld	s1,8(sp)
    800039e8:	6105                	addi	sp,sp,32
    800039ea:	8082                	ret

00000000800039ec <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800039ec:	1101                	addi	sp,sp,-32
    800039ee:	ec06                	sd	ra,24(sp)
    800039f0:	e822                	sd	s0,16(sp)
    800039f2:	e426                	sd	s1,8(sp)
    800039f4:	1000                	addi	s0,sp,32
    800039f6:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800039f8:	00016517          	auipc	a0,0x16
    800039fc:	57050513          	addi	a0,a0,1392 # 80019f68 <ftable>
    80003a00:	00002097          	auipc	ra,0x2
    80003a04:	7f8080e7          	jalr	2040(ra) # 800061f8 <acquire>
  if(f->ref < 1)
    80003a08:	40dc                	lw	a5,4(s1)
    80003a0a:	02f05263          	blez	a5,80003a2e <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a0e:	2785                	addiw	a5,a5,1
    80003a10:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a12:	00016517          	auipc	a0,0x16
    80003a16:	55650513          	addi	a0,a0,1366 # 80019f68 <ftable>
    80003a1a:	00003097          	auipc	ra,0x3
    80003a1e:	892080e7          	jalr	-1902(ra) # 800062ac <release>
  return f;
}
    80003a22:	8526                	mv	a0,s1
    80003a24:	60e2                	ld	ra,24(sp)
    80003a26:	6442                	ld	s0,16(sp)
    80003a28:	64a2                	ld	s1,8(sp)
    80003a2a:	6105                	addi	sp,sp,32
    80003a2c:	8082                	ret
    panic("filedup");
    80003a2e:	00005517          	auipc	a0,0x5
    80003a32:	bea50513          	addi	a0,a0,-1046 # 80008618 <syscalls+0x250>
    80003a36:	00002097          	auipc	ra,0x2
    80003a3a:	222080e7          	jalr	546(ra) # 80005c58 <panic>

0000000080003a3e <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a3e:	7139                	addi	sp,sp,-64
    80003a40:	fc06                	sd	ra,56(sp)
    80003a42:	f822                	sd	s0,48(sp)
    80003a44:	f426                	sd	s1,40(sp)
    80003a46:	f04a                	sd	s2,32(sp)
    80003a48:	ec4e                	sd	s3,24(sp)
    80003a4a:	e852                	sd	s4,16(sp)
    80003a4c:	e456                	sd	s5,8(sp)
    80003a4e:	0080                	addi	s0,sp,64
    80003a50:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a52:	00016517          	auipc	a0,0x16
    80003a56:	51650513          	addi	a0,a0,1302 # 80019f68 <ftable>
    80003a5a:	00002097          	auipc	ra,0x2
    80003a5e:	79e080e7          	jalr	1950(ra) # 800061f8 <acquire>
  if(f->ref < 1)
    80003a62:	40dc                	lw	a5,4(s1)
    80003a64:	06f05163          	blez	a5,80003ac6 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003a68:	37fd                	addiw	a5,a5,-1
    80003a6a:	0007871b          	sext.w	a4,a5
    80003a6e:	c0dc                	sw	a5,4(s1)
    80003a70:	06e04363          	bgtz	a4,80003ad6 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003a74:	0004a903          	lw	s2,0(s1)
    80003a78:	0094ca83          	lbu	s5,9(s1)
    80003a7c:	0104ba03          	ld	s4,16(s1)
    80003a80:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003a84:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003a88:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003a8c:	00016517          	auipc	a0,0x16
    80003a90:	4dc50513          	addi	a0,a0,1244 # 80019f68 <ftable>
    80003a94:	00003097          	auipc	ra,0x3
    80003a98:	818080e7          	jalr	-2024(ra) # 800062ac <release>

  if(ff.type == FD_PIPE){
    80003a9c:	4785                	li	a5,1
    80003a9e:	04f90d63          	beq	s2,a5,80003af8 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003aa2:	3979                	addiw	s2,s2,-2
    80003aa4:	4785                	li	a5,1
    80003aa6:	0527e063          	bltu	a5,s2,80003ae6 <fileclose+0xa8>
    begin_op();
    80003aaa:	00000097          	auipc	ra,0x0
    80003aae:	ac8080e7          	jalr	-1336(ra) # 80003572 <begin_op>
    iput(ff.ip);
    80003ab2:	854e                	mv	a0,s3
    80003ab4:	fffff097          	auipc	ra,0xfffff
    80003ab8:	2a6080e7          	jalr	678(ra) # 80002d5a <iput>
    end_op();
    80003abc:	00000097          	auipc	ra,0x0
    80003ac0:	b36080e7          	jalr	-1226(ra) # 800035f2 <end_op>
    80003ac4:	a00d                	j	80003ae6 <fileclose+0xa8>
    panic("fileclose");
    80003ac6:	00005517          	auipc	a0,0x5
    80003aca:	b5a50513          	addi	a0,a0,-1190 # 80008620 <syscalls+0x258>
    80003ace:	00002097          	auipc	ra,0x2
    80003ad2:	18a080e7          	jalr	394(ra) # 80005c58 <panic>
    release(&ftable.lock);
    80003ad6:	00016517          	auipc	a0,0x16
    80003ada:	49250513          	addi	a0,a0,1170 # 80019f68 <ftable>
    80003ade:	00002097          	auipc	ra,0x2
    80003ae2:	7ce080e7          	jalr	1998(ra) # 800062ac <release>
  }
}
    80003ae6:	70e2                	ld	ra,56(sp)
    80003ae8:	7442                	ld	s0,48(sp)
    80003aea:	74a2                	ld	s1,40(sp)
    80003aec:	7902                	ld	s2,32(sp)
    80003aee:	69e2                	ld	s3,24(sp)
    80003af0:	6a42                	ld	s4,16(sp)
    80003af2:	6aa2                	ld	s5,8(sp)
    80003af4:	6121                	addi	sp,sp,64
    80003af6:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003af8:	85d6                	mv	a1,s5
    80003afa:	8552                	mv	a0,s4
    80003afc:	00000097          	auipc	ra,0x0
    80003b00:	34c080e7          	jalr	844(ra) # 80003e48 <pipeclose>
    80003b04:	b7cd                	j	80003ae6 <fileclose+0xa8>

0000000080003b06 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b06:	715d                	addi	sp,sp,-80
    80003b08:	e486                	sd	ra,72(sp)
    80003b0a:	e0a2                	sd	s0,64(sp)
    80003b0c:	fc26                	sd	s1,56(sp)
    80003b0e:	f84a                	sd	s2,48(sp)
    80003b10:	f44e                	sd	s3,40(sp)
    80003b12:	0880                	addi	s0,sp,80
    80003b14:	84aa                	mv	s1,a0
    80003b16:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b18:	ffffd097          	auipc	ra,0xffffd
    80003b1c:	330080e7          	jalr	816(ra) # 80000e48 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b20:	409c                	lw	a5,0(s1)
    80003b22:	37f9                	addiw	a5,a5,-2
    80003b24:	4705                	li	a4,1
    80003b26:	04f76763          	bltu	a4,a5,80003b74 <filestat+0x6e>
    80003b2a:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b2c:	6c88                	ld	a0,24(s1)
    80003b2e:	fffff097          	auipc	ra,0xfffff
    80003b32:	072080e7          	jalr	114(ra) # 80002ba0 <ilock>
    stati(f->ip, &st);
    80003b36:	fb840593          	addi	a1,s0,-72
    80003b3a:	6c88                	ld	a0,24(s1)
    80003b3c:	fffff097          	auipc	ra,0xfffff
    80003b40:	2ee080e7          	jalr	750(ra) # 80002e2a <stati>
    iunlock(f->ip);
    80003b44:	6c88                	ld	a0,24(s1)
    80003b46:	fffff097          	auipc	ra,0xfffff
    80003b4a:	11c080e7          	jalr	284(ra) # 80002c62 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b4e:	46e1                	li	a3,24
    80003b50:	fb840613          	addi	a2,s0,-72
    80003b54:	85ce                	mv	a1,s3
    80003b56:	07893503          	ld	a0,120(s2)
    80003b5a:	ffffd097          	auipc	ra,0xffffd
    80003b5e:	fb0080e7          	jalr	-80(ra) # 80000b0a <copyout>
    80003b62:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003b66:	60a6                	ld	ra,72(sp)
    80003b68:	6406                	ld	s0,64(sp)
    80003b6a:	74e2                	ld	s1,56(sp)
    80003b6c:	7942                	ld	s2,48(sp)
    80003b6e:	79a2                	ld	s3,40(sp)
    80003b70:	6161                	addi	sp,sp,80
    80003b72:	8082                	ret
  return -1;
    80003b74:	557d                	li	a0,-1
    80003b76:	bfc5                	j	80003b66 <filestat+0x60>

0000000080003b78 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003b78:	7179                	addi	sp,sp,-48
    80003b7a:	f406                	sd	ra,40(sp)
    80003b7c:	f022                	sd	s0,32(sp)
    80003b7e:	ec26                	sd	s1,24(sp)
    80003b80:	e84a                	sd	s2,16(sp)
    80003b82:	e44e                	sd	s3,8(sp)
    80003b84:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003b86:	00854783          	lbu	a5,8(a0)
    80003b8a:	c3d5                	beqz	a5,80003c2e <fileread+0xb6>
    80003b8c:	84aa                	mv	s1,a0
    80003b8e:	89ae                	mv	s3,a1
    80003b90:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b92:	411c                	lw	a5,0(a0)
    80003b94:	4705                	li	a4,1
    80003b96:	04e78963          	beq	a5,a4,80003be8 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b9a:	470d                	li	a4,3
    80003b9c:	04e78d63          	beq	a5,a4,80003bf6 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003ba0:	4709                	li	a4,2
    80003ba2:	06e79e63          	bne	a5,a4,80003c1e <fileread+0xa6>
    ilock(f->ip);
    80003ba6:	6d08                	ld	a0,24(a0)
    80003ba8:	fffff097          	auipc	ra,0xfffff
    80003bac:	ff8080e7          	jalr	-8(ra) # 80002ba0 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003bb0:	874a                	mv	a4,s2
    80003bb2:	5094                	lw	a3,32(s1)
    80003bb4:	864e                	mv	a2,s3
    80003bb6:	4585                	li	a1,1
    80003bb8:	6c88                	ld	a0,24(s1)
    80003bba:	fffff097          	auipc	ra,0xfffff
    80003bbe:	29a080e7          	jalr	666(ra) # 80002e54 <readi>
    80003bc2:	892a                	mv	s2,a0
    80003bc4:	00a05563          	blez	a0,80003bce <fileread+0x56>
      f->off += r;
    80003bc8:	509c                	lw	a5,32(s1)
    80003bca:	9fa9                	addw	a5,a5,a0
    80003bcc:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003bce:	6c88                	ld	a0,24(s1)
    80003bd0:	fffff097          	auipc	ra,0xfffff
    80003bd4:	092080e7          	jalr	146(ra) # 80002c62 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003bd8:	854a                	mv	a0,s2
    80003bda:	70a2                	ld	ra,40(sp)
    80003bdc:	7402                	ld	s0,32(sp)
    80003bde:	64e2                	ld	s1,24(sp)
    80003be0:	6942                	ld	s2,16(sp)
    80003be2:	69a2                	ld	s3,8(sp)
    80003be4:	6145                	addi	sp,sp,48
    80003be6:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003be8:	6908                	ld	a0,16(a0)
    80003bea:	00000097          	auipc	ra,0x0
    80003bee:	3c8080e7          	jalr	968(ra) # 80003fb2 <piperead>
    80003bf2:	892a                	mv	s2,a0
    80003bf4:	b7d5                	j	80003bd8 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003bf6:	02451783          	lh	a5,36(a0)
    80003bfa:	03079693          	slli	a3,a5,0x30
    80003bfe:	92c1                	srli	a3,a3,0x30
    80003c00:	4725                	li	a4,9
    80003c02:	02d76863          	bltu	a4,a3,80003c32 <fileread+0xba>
    80003c06:	0792                	slli	a5,a5,0x4
    80003c08:	00016717          	auipc	a4,0x16
    80003c0c:	2c070713          	addi	a4,a4,704 # 80019ec8 <devsw>
    80003c10:	97ba                	add	a5,a5,a4
    80003c12:	639c                	ld	a5,0(a5)
    80003c14:	c38d                	beqz	a5,80003c36 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c16:	4505                	li	a0,1
    80003c18:	9782                	jalr	a5
    80003c1a:	892a                	mv	s2,a0
    80003c1c:	bf75                	j	80003bd8 <fileread+0x60>
    panic("fileread");
    80003c1e:	00005517          	auipc	a0,0x5
    80003c22:	a1250513          	addi	a0,a0,-1518 # 80008630 <syscalls+0x268>
    80003c26:	00002097          	auipc	ra,0x2
    80003c2a:	032080e7          	jalr	50(ra) # 80005c58 <panic>
    return -1;
    80003c2e:	597d                	li	s2,-1
    80003c30:	b765                	j	80003bd8 <fileread+0x60>
      return -1;
    80003c32:	597d                	li	s2,-1
    80003c34:	b755                	j	80003bd8 <fileread+0x60>
    80003c36:	597d                	li	s2,-1
    80003c38:	b745                	j	80003bd8 <fileread+0x60>

0000000080003c3a <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003c3a:	715d                	addi	sp,sp,-80
    80003c3c:	e486                	sd	ra,72(sp)
    80003c3e:	e0a2                	sd	s0,64(sp)
    80003c40:	fc26                	sd	s1,56(sp)
    80003c42:	f84a                	sd	s2,48(sp)
    80003c44:	f44e                	sd	s3,40(sp)
    80003c46:	f052                	sd	s4,32(sp)
    80003c48:	ec56                	sd	s5,24(sp)
    80003c4a:	e85a                	sd	s6,16(sp)
    80003c4c:	e45e                	sd	s7,8(sp)
    80003c4e:	e062                	sd	s8,0(sp)
    80003c50:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003c52:	00954783          	lbu	a5,9(a0)
    80003c56:	10078663          	beqz	a5,80003d62 <filewrite+0x128>
    80003c5a:	892a                	mv	s2,a0
    80003c5c:	8aae                	mv	s5,a1
    80003c5e:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c60:	411c                	lw	a5,0(a0)
    80003c62:	4705                	li	a4,1
    80003c64:	02e78263          	beq	a5,a4,80003c88 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c68:	470d                	li	a4,3
    80003c6a:	02e78663          	beq	a5,a4,80003c96 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c6e:	4709                	li	a4,2
    80003c70:	0ee79163          	bne	a5,a4,80003d52 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003c74:	0ac05d63          	blez	a2,80003d2e <filewrite+0xf4>
    int i = 0;
    80003c78:	4981                	li	s3,0
    80003c7a:	6b05                	lui	s6,0x1
    80003c7c:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003c80:	6b85                	lui	s7,0x1
    80003c82:	c00b8b9b          	addiw	s7,s7,-1024
    80003c86:	a861                	j	80003d1e <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003c88:	6908                	ld	a0,16(a0)
    80003c8a:	00000097          	auipc	ra,0x0
    80003c8e:	22e080e7          	jalr	558(ra) # 80003eb8 <pipewrite>
    80003c92:	8a2a                	mv	s4,a0
    80003c94:	a045                	j	80003d34 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003c96:	02451783          	lh	a5,36(a0)
    80003c9a:	03079693          	slli	a3,a5,0x30
    80003c9e:	92c1                	srli	a3,a3,0x30
    80003ca0:	4725                	li	a4,9
    80003ca2:	0cd76263          	bltu	a4,a3,80003d66 <filewrite+0x12c>
    80003ca6:	0792                	slli	a5,a5,0x4
    80003ca8:	00016717          	auipc	a4,0x16
    80003cac:	22070713          	addi	a4,a4,544 # 80019ec8 <devsw>
    80003cb0:	97ba                	add	a5,a5,a4
    80003cb2:	679c                	ld	a5,8(a5)
    80003cb4:	cbdd                	beqz	a5,80003d6a <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003cb6:	4505                	li	a0,1
    80003cb8:	9782                	jalr	a5
    80003cba:	8a2a                	mv	s4,a0
    80003cbc:	a8a5                	j	80003d34 <filewrite+0xfa>
    80003cbe:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003cc2:	00000097          	auipc	ra,0x0
    80003cc6:	8b0080e7          	jalr	-1872(ra) # 80003572 <begin_op>
      ilock(f->ip);
    80003cca:	01893503          	ld	a0,24(s2)
    80003cce:	fffff097          	auipc	ra,0xfffff
    80003cd2:	ed2080e7          	jalr	-302(ra) # 80002ba0 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003cd6:	8762                	mv	a4,s8
    80003cd8:	02092683          	lw	a3,32(s2)
    80003cdc:	01598633          	add	a2,s3,s5
    80003ce0:	4585                	li	a1,1
    80003ce2:	01893503          	ld	a0,24(s2)
    80003ce6:	fffff097          	auipc	ra,0xfffff
    80003cea:	266080e7          	jalr	614(ra) # 80002f4c <writei>
    80003cee:	84aa                	mv	s1,a0
    80003cf0:	00a05763          	blez	a0,80003cfe <filewrite+0xc4>
        f->off += r;
    80003cf4:	02092783          	lw	a5,32(s2)
    80003cf8:	9fa9                	addw	a5,a5,a0
    80003cfa:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003cfe:	01893503          	ld	a0,24(s2)
    80003d02:	fffff097          	auipc	ra,0xfffff
    80003d06:	f60080e7          	jalr	-160(ra) # 80002c62 <iunlock>
      end_op();
    80003d0a:	00000097          	auipc	ra,0x0
    80003d0e:	8e8080e7          	jalr	-1816(ra) # 800035f2 <end_op>

      if(r != n1){
    80003d12:	009c1f63          	bne	s8,s1,80003d30 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003d16:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d1a:	0149db63          	bge	s3,s4,80003d30 <filewrite+0xf6>
      int n1 = n - i;
    80003d1e:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003d22:	84be                	mv	s1,a5
    80003d24:	2781                	sext.w	a5,a5
    80003d26:	f8fb5ce3          	bge	s6,a5,80003cbe <filewrite+0x84>
    80003d2a:	84de                	mv	s1,s7
    80003d2c:	bf49                	j	80003cbe <filewrite+0x84>
    int i = 0;
    80003d2e:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d30:	013a1f63          	bne	s4,s3,80003d4e <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d34:	8552                	mv	a0,s4
    80003d36:	60a6                	ld	ra,72(sp)
    80003d38:	6406                	ld	s0,64(sp)
    80003d3a:	74e2                	ld	s1,56(sp)
    80003d3c:	7942                	ld	s2,48(sp)
    80003d3e:	79a2                	ld	s3,40(sp)
    80003d40:	7a02                	ld	s4,32(sp)
    80003d42:	6ae2                	ld	s5,24(sp)
    80003d44:	6b42                	ld	s6,16(sp)
    80003d46:	6ba2                	ld	s7,8(sp)
    80003d48:	6c02                	ld	s8,0(sp)
    80003d4a:	6161                	addi	sp,sp,80
    80003d4c:	8082                	ret
    ret = (i == n ? n : -1);
    80003d4e:	5a7d                	li	s4,-1
    80003d50:	b7d5                	j	80003d34 <filewrite+0xfa>
    panic("filewrite");
    80003d52:	00005517          	auipc	a0,0x5
    80003d56:	8ee50513          	addi	a0,a0,-1810 # 80008640 <syscalls+0x278>
    80003d5a:	00002097          	auipc	ra,0x2
    80003d5e:	efe080e7          	jalr	-258(ra) # 80005c58 <panic>
    return -1;
    80003d62:	5a7d                	li	s4,-1
    80003d64:	bfc1                	j	80003d34 <filewrite+0xfa>
      return -1;
    80003d66:	5a7d                	li	s4,-1
    80003d68:	b7f1                	j	80003d34 <filewrite+0xfa>
    80003d6a:	5a7d                	li	s4,-1
    80003d6c:	b7e1                	j	80003d34 <filewrite+0xfa>

0000000080003d6e <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003d6e:	7179                	addi	sp,sp,-48
    80003d70:	f406                	sd	ra,40(sp)
    80003d72:	f022                	sd	s0,32(sp)
    80003d74:	ec26                	sd	s1,24(sp)
    80003d76:	e84a                	sd	s2,16(sp)
    80003d78:	e44e                	sd	s3,8(sp)
    80003d7a:	e052                	sd	s4,0(sp)
    80003d7c:	1800                	addi	s0,sp,48
    80003d7e:	84aa                	mv	s1,a0
    80003d80:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003d82:	0005b023          	sd	zero,0(a1)
    80003d86:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003d8a:	00000097          	auipc	ra,0x0
    80003d8e:	bf8080e7          	jalr	-1032(ra) # 80003982 <filealloc>
    80003d92:	e088                	sd	a0,0(s1)
    80003d94:	c551                	beqz	a0,80003e20 <pipealloc+0xb2>
    80003d96:	00000097          	auipc	ra,0x0
    80003d9a:	bec080e7          	jalr	-1044(ra) # 80003982 <filealloc>
    80003d9e:	00aa3023          	sd	a0,0(s4)
    80003da2:	c92d                	beqz	a0,80003e14 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003da4:	ffffc097          	auipc	ra,0xffffc
    80003da8:	374080e7          	jalr	884(ra) # 80000118 <kalloc>
    80003dac:	892a                	mv	s2,a0
    80003dae:	c125                	beqz	a0,80003e0e <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003db0:	4985                	li	s3,1
    80003db2:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003db6:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003dba:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003dbe:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003dc2:	00005597          	auipc	a1,0x5
    80003dc6:	88e58593          	addi	a1,a1,-1906 # 80008650 <syscalls+0x288>
    80003dca:	00002097          	auipc	ra,0x2
    80003dce:	39e080e7          	jalr	926(ra) # 80006168 <initlock>
  (*f0)->type = FD_PIPE;
    80003dd2:	609c                	ld	a5,0(s1)
    80003dd4:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003dd8:	609c                	ld	a5,0(s1)
    80003dda:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003dde:	609c                	ld	a5,0(s1)
    80003de0:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003de4:	609c                	ld	a5,0(s1)
    80003de6:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003dea:	000a3783          	ld	a5,0(s4)
    80003dee:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003df2:	000a3783          	ld	a5,0(s4)
    80003df6:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003dfa:	000a3783          	ld	a5,0(s4)
    80003dfe:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e02:	000a3783          	ld	a5,0(s4)
    80003e06:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e0a:	4501                	li	a0,0
    80003e0c:	a025                	j	80003e34 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e0e:	6088                	ld	a0,0(s1)
    80003e10:	e501                	bnez	a0,80003e18 <pipealloc+0xaa>
    80003e12:	a039                	j	80003e20 <pipealloc+0xb2>
    80003e14:	6088                	ld	a0,0(s1)
    80003e16:	c51d                	beqz	a0,80003e44 <pipealloc+0xd6>
    fileclose(*f0);
    80003e18:	00000097          	auipc	ra,0x0
    80003e1c:	c26080e7          	jalr	-986(ra) # 80003a3e <fileclose>
  if(*f1)
    80003e20:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e24:	557d                	li	a0,-1
  if(*f1)
    80003e26:	c799                	beqz	a5,80003e34 <pipealloc+0xc6>
    fileclose(*f1);
    80003e28:	853e                	mv	a0,a5
    80003e2a:	00000097          	auipc	ra,0x0
    80003e2e:	c14080e7          	jalr	-1004(ra) # 80003a3e <fileclose>
  return -1;
    80003e32:	557d                	li	a0,-1
}
    80003e34:	70a2                	ld	ra,40(sp)
    80003e36:	7402                	ld	s0,32(sp)
    80003e38:	64e2                	ld	s1,24(sp)
    80003e3a:	6942                	ld	s2,16(sp)
    80003e3c:	69a2                	ld	s3,8(sp)
    80003e3e:	6a02                	ld	s4,0(sp)
    80003e40:	6145                	addi	sp,sp,48
    80003e42:	8082                	ret
  return -1;
    80003e44:	557d                	li	a0,-1
    80003e46:	b7fd                	j	80003e34 <pipealloc+0xc6>

0000000080003e48 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e48:	1101                	addi	sp,sp,-32
    80003e4a:	ec06                	sd	ra,24(sp)
    80003e4c:	e822                	sd	s0,16(sp)
    80003e4e:	e426                	sd	s1,8(sp)
    80003e50:	e04a                	sd	s2,0(sp)
    80003e52:	1000                	addi	s0,sp,32
    80003e54:	84aa                	mv	s1,a0
    80003e56:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e58:	00002097          	auipc	ra,0x2
    80003e5c:	3a0080e7          	jalr	928(ra) # 800061f8 <acquire>
  if(writable){
    80003e60:	02090d63          	beqz	s2,80003e9a <pipeclose+0x52>
    pi->writeopen = 0;
    80003e64:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003e68:	21848513          	addi	a0,s1,536
    80003e6c:	ffffe097          	auipc	ra,0xffffe
    80003e70:	860080e7          	jalr	-1952(ra) # 800016cc <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003e74:	2204b783          	ld	a5,544(s1)
    80003e78:	eb95                	bnez	a5,80003eac <pipeclose+0x64>
    release(&pi->lock);
    80003e7a:	8526                	mv	a0,s1
    80003e7c:	00002097          	auipc	ra,0x2
    80003e80:	430080e7          	jalr	1072(ra) # 800062ac <release>
    kfree((char*)pi);
    80003e84:	8526                	mv	a0,s1
    80003e86:	ffffc097          	auipc	ra,0xffffc
    80003e8a:	196080e7          	jalr	406(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003e8e:	60e2                	ld	ra,24(sp)
    80003e90:	6442                	ld	s0,16(sp)
    80003e92:	64a2                	ld	s1,8(sp)
    80003e94:	6902                	ld	s2,0(sp)
    80003e96:	6105                	addi	sp,sp,32
    80003e98:	8082                	ret
    pi->readopen = 0;
    80003e9a:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003e9e:	21c48513          	addi	a0,s1,540
    80003ea2:	ffffe097          	auipc	ra,0xffffe
    80003ea6:	82a080e7          	jalr	-2006(ra) # 800016cc <wakeup>
    80003eaa:	b7e9                	j	80003e74 <pipeclose+0x2c>
    release(&pi->lock);
    80003eac:	8526                	mv	a0,s1
    80003eae:	00002097          	auipc	ra,0x2
    80003eb2:	3fe080e7          	jalr	1022(ra) # 800062ac <release>
}
    80003eb6:	bfe1                	j	80003e8e <pipeclose+0x46>

0000000080003eb8 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003eb8:	7159                	addi	sp,sp,-112
    80003eba:	f486                	sd	ra,104(sp)
    80003ebc:	f0a2                	sd	s0,96(sp)
    80003ebe:	eca6                	sd	s1,88(sp)
    80003ec0:	e8ca                	sd	s2,80(sp)
    80003ec2:	e4ce                	sd	s3,72(sp)
    80003ec4:	e0d2                	sd	s4,64(sp)
    80003ec6:	fc56                	sd	s5,56(sp)
    80003ec8:	f85a                	sd	s6,48(sp)
    80003eca:	f45e                	sd	s7,40(sp)
    80003ecc:	f062                	sd	s8,32(sp)
    80003ece:	ec66                	sd	s9,24(sp)
    80003ed0:	1880                	addi	s0,sp,112
    80003ed2:	84aa                	mv	s1,a0
    80003ed4:	8aae                	mv	s5,a1
    80003ed6:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003ed8:	ffffd097          	auipc	ra,0xffffd
    80003edc:	f70080e7          	jalr	-144(ra) # 80000e48 <myproc>
    80003ee0:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003ee2:	8526                	mv	a0,s1
    80003ee4:	00002097          	auipc	ra,0x2
    80003ee8:	314080e7          	jalr	788(ra) # 800061f8 <acquire>
  while(i < n){
    80003eec:	0d405163          	blez	s4,80003fae <pipewrite+0xf6>
    80003ef0:	8ba6                	mv	s7,s1
  int i = 0;
    80003ef2:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003ef4:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003ef6:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003efa:	21c48c13          	addi	s8,s1,540
    80003efe:	a08d                	j	80003f60 <pipewrite+0xa8>
      release(&pi->lock);
    80003f00:	8526                	mv	a0,s1
    80003f02:	00002097          	auipc	ra,0x2
    80003f06:	3aa080e7          	jalr	938(ra) # 800062ac <release>
      return -1;
    80003f0a:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f0c:	854a                	mv	a0,s2
    80003f0e:	70a6                	ld	ra,104(sp)
    80003f10:	7406                	ld	s0,96(sp)
    80003f12:	64e6                	ld	s1,88(sp)
    80003f14:	6946                	ld	s2,80(sp)
    80003f16:	69a6                	ld	s3,72(sp)
    80003f18:	6a06                	ld	s4,64(sp)
    80003f1a:	7ae2                	ld	s5,56(sp)
    80003f1c:	7b42                	ld	s6,48(sp)
    80003f1e:	7ba2                	ld	s7,40(sp)
    80003f20:	7c02                	ld	s8,32(sp)
    80003f22:	6ce2                	ld	s9,24(sp)
    80003f24:	6165                	addi	sp,sp,112
    80003f26:	8082                	ret
      wakeup(&pi->nread);
    80003f28:	8566                	mv	a0,s9
    80003f2a:	ffffd097          	auipc	ra,0xffffd
    80003f2e:	7a2080e7          	jalr	1954(ra) # 800016cc <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f32:	85de                	mv	a1,s7
    80003f34:	8562                	mv	a0,s8
    80003f36:	ffffd097          	auipc	ra,0xffffd
    80003f3a:	60a080e7          	jalr	1546(ra) # 80001540 <sleep>
    80003f3e:	a839                	j	80003f5c <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f40:	21c4a783          	lw	a5,540(s1)
    80003f44:	0017871b          	addiw	a4,a5,1
    80003f48:	20e4ae23          	sw	a4,540(s1)
    80003f4c:	1ff7f793          	andi	a5,a5,511
    80003f50:	97a6                	add	a5,a5,s1
    80003f52:	f9f44703          	lbu	a4,-97(s0)
    80003f56:	00e78c23          	sb	a4,24(a5)
      i++;
    80003f5a:	2905                	addiw	s2,s2,1
  while(i < n){
    80003f5c:	03495d63          	bge	s2,s4,80003f96 <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    80003f60:	2204a783          	lw	a5,544(s1)
    80003f64:	dfd1                	beqz	a5,80003f00 <pipewrite+0x48>
    80003f66:	0289a783          	lw	a5,40(s3)
    80003f6a:	fbd9                	bnez	a5,80003f00 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f6c:	2184a783          	lw	a5,536(s1)
    80003f70:	21c4a703          	lw	a4,540(s1)
    80003f74:	2007879b          	addiw	a5,a5,512
    80003f78:	faf708e3          	beq	a4,a5,80003f28 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f7c:	4685                	li	a3,1
    80003f7e:	01590633          	add	a2,s2,s5
    80003f82:	f9f40593          	addi	a1,s0,-97
    80003f86:	0789b503          	ld	a0,120(s3)
    80003f8a:	ffffd097          	auipc	ra,0xffffd
    80003f8e:	c0c080e7          	jalr	-1012(ra) # 80000b96 <copyin>
    80003f92:	fb6517e3          	bne	a0,s6,80003f40 <pipewrite+0x88>
  wakeup(&pi->nread);
    80003f96:	21848513          	addi	a0,s1,536
    80003f9a:	ffffd097          	auipc	ra,0xffffd
    80003f9e:	732080e7          	jalr	1842(ra) # 800016cc <wakeup>
  release(&pi->lock);
    80003fa2:	8526                	mv	a0,s1
    80003fa4:	00002097          	auipc	ra,0x2
    80003fa8:	308080e7          	jalr	776(ra) # 800062ac <release>
  return i;
    80003fac:	b785                	j	80003f0c <pipewrite+0x54>
  int i = 0;
    80003fae:	4901                	li	s2,0
    80003fb0:	b7dd                	j	80003f96 <pipewrite+0xde>

0000000080003fb2 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003fb2:	715d                	addi	sp,sp,-80
    80003fb4:	e486                	sd	ra,72(sp)
    80003fb6:	e0a2                	sd	s0,64(sp)
    80003fb8:	fc26                	sd	s1,56(sp)
    80003fba:	f84a                	sd	s2,48(sp)
    80003fbc:	f44e                	sd	s3,40(sp)
    80003fbe:	f052                	sd	s4,32(sp)
    80003fc0:	ec56                	sd	s5,24(sp)
    80003fc2:	e85a                	sd	s6,16(sp)
    80003fc4:	0880                	addi	s0,sp,80
    80003fc6:	84aa                	mv	s1,a0
    80003fc8:	892e                	mv	s2,a1
    80003fca:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003fcc:	ffffd097          	auipc	ra,0xffffd
    80003fd0:	e7c080e7          	jalr	-388(ra) # 80000e48 <myproc>
    80003fd4:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003fd6:	8b26                	mv	s6,s1
    80003fd8:	8526                	mv	a0,s1
    80003fda:	00002097          	auipc	ra,0x2
    80003fde:	21e080e7          	jalr	542(ra) # 800061f8 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fe2:	2184a703          	lw	a4,536(s1)
    80003fe6:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003fea:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fee:	02f71463          	bne	a4,a5,80004016 <piperead+0x64>
    80003ff2:	2244a783          	lw	a5,548(s1)
    80003ff6:	c385                	beqz	a5,80004016 <piperead+0x64>
    if(pr->killed){
    80003ff8:	028a2783          	lw	a5,40(s4)
    80003ffc:	ebc1                	bnez	a5,8000408c <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003ffe:	85da                	mv	a1,s6
    80004000:	854e                	mv	a0,s3
    80004002:	ffffd097          	auipc	ra,0xffffd
    80004006:	53e080e7          	jalr	1342(ra) # 80001540 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000400a:	2184a703          	lw	a4,536(s1)
    8000400e:	21c4a783          	lw	a5,540(s1)
    80004012:	fef700e3          	beq	a4,a5,80003ff2 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004016:	09505263          	blez	s5,8000409a <piperead+0xe8>
    8000401a:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000401c:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    8000401e:	2184a783          	lw	a5,536(s1)
    80004022:	21c4a703          	lw	a4,540(s1)
    80004026:	02f70d63          	beq	a4,a5,80004060 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000402a:	0017871b          	addiw	a4,a5,1
    8000402e:	20e4ac23          	sw	a4,536(s1)
    80004032:	1ff7f793          	andi	a5,a5,511
    80004036:	97a6                	add	a5,a5,s1
    80004038:	0187c783          	lbu	a5,24(a5)
    8000403c:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004040:	4685                	li	a3,1
    80004042:	fbf40613          	addi	a2,s0,-65
    80004046:	85ca                	mv	a1,s2
    80004048:	078a3503          	ld	a0,120(s4)
    8000404c:	ffffd097          	auipc	ra,0xffffd
    80004050:	abe080e7          	jalr	-1346(ra) # 80000b0a <copyout>
    80004054:	01650663          	beq	a0,s6,80004060 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004058:	2985                	addiw	s3,s3,1
    8000405a:	0905                	addi	s2,s2,1
    8000405c:	fd3a91e3          	bne	s5,s3,8000401e <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004060:	21c48513          	addi	a0,s1,540
    80004064:	ffffd097          	auipc	ra,0xffffd
    80004068:	668080e7          	jalr	1640(ra) # 800016cc <wakeup>
  release(&pi->lock);
    8000406c:	8526                	mv	a0,s1
    8000406e:	00002097          	auipc	ra,0x2
    80004072:	23e080e7          	jalr	574(ra) # 800062ac <release>
  return i;
}
    80004076:	854e                	mv	a0,s3
    80004078:	60a6                	ld	ra,72(sp)
    8000407a:	6406                	ld	s0,64(sp)
    8000407c:	74e2                	ld	s1,56(sp)
    8000407e:	7942                	ld	s2,48(sp)
    80004080:	79a2                	ld	s3,40(sp)
    80004082:	7a02                	ld	s4,32(sp)
    80004084:	6ae2                	ld	s5,24(sp)
    80004086:	6b42                	ld	s6,16(sp)
    80004088:	6161                	addi	sp,sp,80
    8000408a:	8082                	ret
      release(&pi->lock);
    8000408c:	8526                	mv	a0,s1
    8000408e:	00002097          	auipc	ra,0x2
    80004092:	21e080e7          	jalr	542(ra) # 800062ac <release>
      return -1;
    80004096:	59fd                	li	s3,-1
    80004098:	bff9                	j	80004076 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000409a:	4981                	li	s3,0
    8000409c:	b7d1                	j	80004060 <piperead+0xae>

000000008000409e <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    8000409e:	df010113          	addi	sp,sp,-528
    800040a2:	20113423          	sd	ra,520(sp)
    800040a6:	20813023          	sd	s0,512(sp)
    800040aa:	ffa6                	sd	s1,504(sp)
    800040ac:	fbca                	sd	s2,496(sp)
    800040ae:	f7ce                	sd	s3,488(sp)
    800040b0:	f3d2                	sd	s4,480(sp)
    800040b2:	efd6                	sd	s5,472(sp)
    800040b4:	ebda                	sd	s6,464(sp)
    800040b6:	e7de                	sd	s7,456(sp)
    800040b8:	e3e2                	sd	s8,448(sp)
    800040ba:	ff66                	sd	s9,440(sp)
    800040bc:	fb6a                	sd	s10,432(sp)
    800040be:	f76e                	sd	s11,424(sp)
    800040c0:	0c00                	addi	s0,sp,528
    800040c2:	84aa                	mv	s1,a0
    800040c4:	dea43c23          	sd	a0,-520(s0)
    800040c8:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800040cc:	ffffd097          	auipc	ra,0xffffd
    800040d0:	d7c080e7          	jalr	-644(ra) # 80000e48 <myproc>
    800040d4:	892a                	mv	s2,a0

  begin_op();
    800040d6:	fffff097          	auipc	ra,0xfffff
    800040da:	49c080e7          	jalr	1180(ra) # 80003572 <begin_op>

  if((ip = namei(path)) == 0){
    800040de:	8526                	mv	a0,s1
    800040e0:	fffff097          	auipc	ra,0xfffff
    800040e4:	276080e7          	jalr	630(ra) # 80003356 <namei>
    800040e8:	c92d                	beqz	a0,8000415a <exec+0xbc>
    800040ea:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800040ec:	fffff097          	auipc	ra,0xfffff
    800040f0:	ab4080e7          	jalr	-1356(ra) # 80002ba0 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800040f4:	04000713          	li	a4,64
    800040f8:	4681                	li	a3,0
    800040fa:	e5040613          	addi	a2,s0,-432
    800040fe:	4581                	li	a1,0
    80004100:	8526                	mv	a0,s1
    80004102:	fffff097          	auipc	ra,0xfffff
    80004106:	d52080e7          	jalr	-686(ra) # 80002e54 <readi>
    8000410a:	04000793          	li	a5,64
    8000410e:	00f51a63          	bne	a0,a5,80004122 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004112:	e5042703          	lw	a4,-432(s0)
    80004116:	464c47b7          	lui	a5,0x464c4
    8000411a:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000411e:	04f70463          	beq	a4,a5,80004166 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004122:	8526                	mv	a0,s1
    80004124:	fffff097          	auipc	ra,0xfffff
    80004128:	cde080e7          	jalr	-802(ra) # 80002e02 <iunlockput>
    end_op();
    8000412c:	fffff097          	auipc	ra,0xfffff
    80004130:	4c6080e7          	jalr	1222(ra) # 800035f2 <end_op>
  }
  return -1;
    80004134:	557d                	li	a0,-1
}
    80004136:	20813083          	ld	ra,520(sp)
    8000413a:	20013403          	ld	s0,512(sp)
    8000413e:	74fe                	ld	s1,504(sp)
    80004140:	795e                	ld	s2,496(sp)
    80004142:	79be                	ld	s3,488(sp)
    80004144:	7a1e                	ld	s4,480(sp)
    80004146:	6afe                	ld	s5,472(sp)
    80004148:	6b5e                	ld	s6,464(sp)
    8000414a:	6bbe                	ld	s7,456(sp)
    8000414c:	6c1e                	ld	s8,448(sp)
    8000414e:	7cfa                	ld	s9,440(sp)
    80004150:	7d5a                	ld	s10,432(sp)
    80004152:	7dba                	ld	s11,424(sp)
    80004154:	21010113          	addi	sp,sp,528
    80004158:	8082                	ret
    end_op();
    8000415a:	fffff097          	auipc	ra,0xfffff
    8000415e:	498080e7          	jalr	1176(ra) # 800035f2 <end_op>
    return -1;
    80004162:	557d                	li	a0,-1
    80004164:	bfc9                	j	80004136 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004166:	854a                	mv	a0,s2
    80004168:	ffffd097          	auipc	ra,0xffffd
    8000416c:	da4080e7          	jalr	-604(ra) # 80000f0c <proc_pagetable>
    80004170:	8baa                	mv	s7,a0
    80004172:	d945                	beqz	a0,80004122 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004174:	e7042983          	lw	s3,-400(s0)
    80004178:	e8845783          	lhu	a5,-376(s0)
    8000417c:	c7ad                	beqz	a5,800041e6 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000417e:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004180:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    80004182:	6c85                	lui	s9,0x1
    80004184:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004188:	def43823          	sd	a5,-528(s0)
    8000418c:	a42d                	j	800043b6 <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    8000418e:	00004517          	auipc	a0,0x4
    80004192:	4ca50513          	addi	a0,a0,1226 # 80008658 <syscalls+0x290>
    80004196:	00002097          	auipc	ra,0x2
    8000419a:	ac2080e7          	jalr	-1342(ra) # 80005c58 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000419e:	8756                	mv	a4,s5
    800041a0:	012d86bb          	addw	a3,s11,s2
    800041a4:	4581                	li	a1,0
    800041a6:	8526                	mv	a0,s1
    800041a8:	fffff097          	auipc	ra,0xfffff
    800041ac:	cac080e7          	jalr	-852(ra) # 80002e54 <readi>
    800041b0:	2501                	sext.w	a0,a0
    800041b2:	1aaa9963          	bne	s5,a0,80004364 <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    800041b6:	6785                	lui	a5,0x1
    800041b8:	0127893b          	addw	s2,a5,s2
    800041bc:	77fd                	lui	a5,0xfffff
    800041be:	01478a3b          	addw	s4,a5,s4
    800041c2:	1f897163          	bgeu	s2,s8,800043a4 <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    800041c6:	02091593          	slli	a1,s2,0x20
    800041ca:	9181                	srli	a1,a1,0x20
    800041cc:	95ea                	add	a1,a1,s10
    800041ce:	855e                	mv	a0,s7
    800041d0:	ffffc097          	auipc	ra,0xffffc
    800041d4:	336080e7          	jalr	822(ra) # 80000506 <walkaddr>
    800041d8:	862a                	mv	a2,a0
    if(pa == 0)
    800041da:	d955                	beqz	a0,8000418e <exec+0xf0>
      n = PGSIZE;
    800041dc:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    800041de:	fd9a70e3          	bgeu	s4,s9,8000419e <exec+0x100>
      n = sz - i;
    800041e2:	8ad2                	mv	s5,s4
    800041e4:	bf6d                	j	8000419e <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041e6:	4901                	li	s2,0
  iunlockput(ip);
    800041e8:	8526                	mv	a0,s1
    800041ea:	fffff097          	auipc	ra,0xfffff
    800041ee:	c18080e7          	jalr	-1000(ra) # 80002e02 <iunlockput>
  end_op();
    800041f2:	fffff097          	auipc	ra,0xfffff
    800041f6:	400080e7          	jalr	1024(ra) # 800035f2 <end_op>
  p = myproc();
    800041fa:	ffffd097          	auipc	ra,0xffffd
    800041fe:	c4e080e7          	jalr	-946(ra) # 80000e48 <myproc>
    80004202:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004204:	07053d03          	ld	s10,112(a0)
  sz = PGROUNDUP(sz);
    80004208:	6785                	lui	a5,0x1
    8000420a:	17fd                	addi	a5,a5,-1
    8000420c:	993e                	add	s2,s2,a5
    8000420e:	757d                	lui	a0,0xfffff
    80004210:	00a977b3          	and	a5,s2,a0
    80004214:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004218:	6609                	lui	a2,0x2
    8000421a:	963e                	add	a2,a2,a5
    8000421c:	85be                	mv	a1,a5
    8000421e:	855e                	mv	a0,s7
    80004220:	ffffc097          	auipc	ra,0xffffc
    80004224:	69a080e7          	jalr	1690(ra) # 800008ba <uvmalloc>
    80004228:	8b2a                	mv	s6,a0
  ip = 0;
    8000422a:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000422c:	12050c63          	beqz	a0,80004364 <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004230:	75f9                	lui	a1,0xffffe
    80004232:	95aa                	add	a1,a1,a0
    80004234:	855e                	mv	a0,s7
    80004236:	ffffd097          	auipc	ra,0xffffd
    8000423a:	8a2080e7          	jalr	-1886(ra) # 80000ad8 <uvmclear>
  stackbase = sp - PGSIZE;
    8000423e:	7c7d                	lui	s8,0xfffff
    80004240:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004242:	e0043783          	ld	a5,-512(s0)
    80004246:	6388                	ld	a0,0(a5)
    80004248:	c535                	beqz	a0,800042b4 <exec+0x216>
    8000424a:	e9040993          	addi	s3,s0,-368
    8000424e:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004252:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004254:	ffffc097          	auipc	ra,0xffffc
    80004258:	0a8080e7          	jalr	168(ra) # 800002fc <strlen>
    8000425c:	2505                	addiw	a0,a0,1
    8000425e:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004262:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004266:	13896363          	bltu	s2,s8,8000438c <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000426a:	e0043d83          	ld	s11,-512(s0)
    8000426e:	000dba03          	ld	s4,0(s11)
    80004272:	8552                	mv	a0,s4
    80004274:	ffffc097          	auipc	ra,0xffffc
    80004278:	088080e7          	jalr	136(ra) # 800002fc <strlen>
    8000427c:	0015069b          	addiw	a3,a0,1
    80004280:	8652                	mv	a2,s4
    80004282:	85ca                	mv	a1,s2
    80004284:	855e                	mv	a0,s7
    80004286:	ffffd097          	auipc	ra,0xffffd
    8000428a:	884080e7          	jalr	-1916(ra) # 80000b0a <copyout>
    8000428e:	10054363          	bltz	a0,80004394 <exec+0x2f6>
    ustack[argc] = sp;
    80004292:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004296:	0485                	addi	s1,s1,1
    80004298:	008d8793          	addi	a5,s11,8
    8000429c:	e0f43023          	sd	a5,-512(s0)
    800042a0:	008db503          	ld	a0,8(s11)
    800042a4:	c911                	beqz	a0,800042b8 <exec+0x21a>
    if(argc >= MAXARG)
    800042a6:	09a1                	addi	s3,s3,8
    800042a8:	fb3c96e3          	bne	s9,s3,80004254 <exec+0x1b6>
  sz = sz1;
    800042ac:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800042b0:	4481                	li	s1,0
    800042b2:	a84d                	j	80004364 <exec+0x2c6>
  sp = sz;
    800042b4:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    800042b6:	4481                	li	s1,0
  ustack[argc] = 0;
    800042b8:	00349793          	slli	a5,s1,0x3
    800042bc:	f9040713          	addi	a4,s0,-112
    800042c0:	97ba                	add	a5,a5,a4
    800042c2:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    800042c6:	00148693          	addi	a3,s1,1
    800042ca:	068e                	slli	a3,a3,0x3
    800042cc:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800042d0:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800042d4:	01897663          	bgeu	s2,s8,800042e0 <exec+0x242>
  sz = sz1;
    800042d8:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800042dc:	4481                	li	s1,0
    800042de:	a059                	j	80004364 <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800042e0:	e9040613          	addi	a2,s0,-368
    800042e4:	85ca                	mv	a1,s2
    800042e6:	855e                	mv	a0,s7
    800042e8:	ffffd097          	auipc	ra,0xffffd
    800042ec:	822080e7          	jalr	-2014(ra) # 80000b0a <copyout>
    800042f0:	0a054663          	bltz	a0,8000439c <exec+0x2fe>
  p->trapframe->a1 = sp;
    800042f4:	080ab783          	ld	a5,128(s5)
    800042f8:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800042fc:	df843783          	ld	a5,-520(s0)
    80004300:	0007c703          	lbu	a4,0(a5)
    80004304:	cf11                	beqz	a4,80004320 <exec+0x282>
    80004306:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004308:	02f00693          	li	a3,47
    8000430c:	a039                	j	8000431a <exec+0x27c>
      last = s+1;
    8000430e:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004312:	0785                	addi	a5,a5,1
    80004314:	fff7c703          	lbu	a4,-1(a5)
    80004318:	c701                	beqz	a4,80004320 <exec+0x282>
    if(*s == '/')
    8000431a:	fed71ce3          	bne	a4,a3,80004312 <exec+0x274>
    8000431e:	bfc5                	j	8000430e <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    80004320:	4641                	li	a2,16
    80004322:	df843583          	ld	a1,-520(s0)
    80004326:	180a8513          	addi	a0,s5,384
    8000432a:	ffffc097          	auipc	ra,0xffffc
    8000432e:	fa0080e7          	jalr	-96(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    80004332:	078ab503          	ld	a0,120(s5)
  p->pagetable = pagetable;
    80004336:	077abc23          	sd	s7,120(s5)
  p->sz = sz;
    8000433a:	076ab823          	sd	s6,112(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000433e:	080ab783          	ld	a5,128(s5)
    80004342:	e6843703          	ld	a4,-408(s0)
    80004346:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004348:	080ab783          	ld	a5,128(s5)
    8000434c:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004350:	85ea                	mv	a1,s10
    80004352:	ffffd097          	auipc	ra,0xffffd
    80004356:	c56080e7          	jalr	-938(ra) # 80000fa8 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000435a:	0004851b          	sext.w	a0,s1
    8000435e:	bbe1                	j	80004136 <exec+0x98>
    80004360:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004364:	e0843583          	ld	a1,-504(s0)
    80004368:	855e                	mv	a0,s7
    8000436a:	ffffd097          	auipc	ra,0xffffd
    8000436e:	c3e080e7          	jalr	-962(ra) # 80000fa8 <proc_freepagetable>
  if(ip){
    80004372:	da0498e3          	bnez	s1,80004122 <exec+0x84>
  return -1;
    80004376:	557d                	li	a0,-1
    80004378:	bb7d                	j	80004136 <exec+0x98>
    8000437a:	e1243423          	sd	s2,-504(s0)
    8000437e:	b7dd                	j	80004364 <exec+0x2c6>
    80004380:	e1243423          	sd	s2,-504(s0)
    80004384:	b7c5                	j	80004364 <exec+0x2c6>
    80004386:	e1243423          	sd	s2,-504(s0)
    8000438a:	bfe9                	j	80004364 <exec+0x2c6>
  sz = sz1;
    8000438c:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004390:	4481                	li	s1,0
    80004392:	bfc9                	j	80004364 <exec+0x2c6>
  sz = sz1;
    80004394:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004398:	4481                	li	s1,0
    8000439a:	b7e9                	j	80004364 <exec+0x2c6>
  sz = sz1;
    8000439c:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043a0:	4481                	li	s1,0
    800043a2:	b7c9                	j	80004364 <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800043a4:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043a8:	2b05                	addiw	s6,s6,1
    800043aa:	0389899b          	addiw	s3,s3,56
    800043ae:	e8845783          	lhu	a5,-376(s0)
    800043b2:	e2fb5be3          	bge	s6,a5,800041e8 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800043b6:	2981                	sext.w	s3,s3
    800043b8:	03800713          	li	a4,56
    800043bc:	86ce                	mv	a3,s3
    800043be:	e1840613          	addi	a2,s0,-488
    800043c2:	4581                	li	a1,0
    800043c4:	8526                	mv	a0,s1
    800043c6:	fffff097          	auipc	ra,0xfffff
    800043ca:	a8e080e7          	jalr	-1394(ra) # 80002e54 <readi>
    800043ce:	03800793          	li	a5,56
    800043d2:	f8f517e3          	bne	a0,a5,80004360 <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    800043d6:	e1842783          	lw	a5,-488(s0)
    800043da:	4705                	li	a4,1
    800043dc:	fce796e3          	bne	a5,a4,800043a8 <exec+0x30a>
    if(ph.memsz < ph.filesz)
    800043e0:	e4043603          	ld	a2,-448(s0)
    800043e4:	e3843783          	ld	a5,-456(s0)
    800043e8:	f8f669e3          	bltu	a2,a5,8000437a <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800043ec:	e2843783          	ld	a5,-472(s0)
    800043f0:	963e                	add	a2,a2,a5
    800043f2:	f8f667e3          	bltu	a2,a5,80004380 <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800043f6:	85ca                	mv	a1,s2
    800043f8:	855e                	mv	a0,s7
    800043fa:	ffffc097          	auipc	ra,0xffffc
    800043fe:	4c0080e7          	jalr	1216(ra) # 800008ba <uvmalloc>
    80004402:	e0a43423          	sd	a0,-504(s0)
    80004406:	d141                	beqz	a0,80004386 <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    80004408:	e2843d03          	ld	s10,-472(s0)
    8000440c:	df043783          	ld	a5,-528(s0)
    80004410:	00fd77b3          	and	a5,s10,a5
    80004414:	fba1                	bnez	a5,80004364 <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004416:	e2042d83          	lw	s11,-480(s0)
    8000441a:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000441e:	f80c03e3          	beqz	s8,800043a4 <exec+0x306>
    80004422:	8a62                	mv	s4,s8
    80004424:	4901                	li	s2,0
    80004426:	b345                	j	800041c6 <exec+0x128>

0000000080004428 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004428:	7179                	addi	sp,sp,-48
    8000442a:	f406                	sd	ra,40(sp)
    8000442c:	f022                	sd	s0,32(sp)
    8000442e:	ec26                	sd	s1,24(sp)
    80004430:	e84a                	sd	s2,16(sp)
    80004432:	1800                	addi	s0,sp,48
    80004434:	892e                	mv	s2,a1
    80004436:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if (argint(n, &fd) < 0)
    80004438:	fdc40593          	addi	a1,s0,-36
    8000443c:	ffffe097          	auipc	ra,0xffffe
    80004440:	b3e080e7          	jalr	-1218(ra) # 80001f7a <argint>
    80004444:	04054063          	bltz	a0,80004484 <argfd+0x5c>
    return -1;
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
    80004448:	fdc42703          	lw	a4,-36(s0)
    8000444c:	47bd                	li	a5,15
    8000444e:	02e7ed63          	bltu	a5,a4,80004488 <argfd+0x60>
    80004452:	ffffd097          	auipc	ra,0xffffd
    80004456:	9f6080e7          	jalr	-1546(ra) # 80000e48 <myproc>
    8000445a:	fdc42703          	lw	a4,-36(s0)
    8000445e:	01e70793          	addi	a5,a4,30
    80004462:	078e                	slli	a5,a5,0x3
    80004464:	953e                	add	a0,a0,a5
    80004466:	651c                	ld	a5,8(a0)
    80004468:	c395                	beqz	a5,8000448c <argfd+0x64>
    return -1;
  if (pfd)
    8000446a:	00090463          	beqz	s2,80004472 <argfd+0x4a>
    *pfd = fd;
    8000446e:	00e92023          	sw	a4,0(s2)
  if (pf)
    *pf = f;
  return 0;
    80004472:	4501                	li	a0,0
  if (pf)
    80004474:	c091                	beqz	s1,80004478 <argfd+0x50>
    *pf = f;
    80004476:	e09c                	sd	a5,0(s1)
}
    80004478:	70a2                	ld	ra,40(sp)
    8000447a:	7402                	ld	s0,32(sp)
    8000447c:	64e2                	ld	s1,24(sp)
    8000447e:	6942                	ld	s2,16(sp)
    80004480:	6145                	addi	sp,sp,48
    80004482:	8082                	ret
    return -1;
    80004484:	557d                	li	a0,-1
    80004486:	bfcd                	j	80004478 <argfd+0x50>
    return -1;
    80004488:	557d                	li	a0,-1
    8000448a:	b7fd                	j	80004478 <argfd+0x50>
    8000448c:	557d                	li	a0,-1
    8000448e:	b7ed                	j	80004478 <argfd+0x50>

0000000080004490 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004490:	1101                	addi	sp,sp,-32
    80004492:	ec06                	sd	ra,24(sp)
    80004494:	e822                	sd	s0,16(sp)
    80004496:	e426                	sd	s1,8(sp)
    80004498:	1000                	addi	s0,sp,32
    8000449a:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000449c:	ffffd097          	auipc	ra,0xffffd
    800044a0:	9ac080e7          	jalr	-1620(ra) # 80000e48 <myproc>
    800044a4:	862a                	mv	a2,a0

  for (fd = 0; fd < NOFILE; fd++)
    800044a6:	0f850793          	addi	a5,a0,248 # fffffffffffff0f8 <end+0xffffffff7ffd8eb8>
    800044aa:	4501                	li	a0,0
    800044ac:	46c1                	li	a3,16
  {
    if (p->ofile[fd] == 0)
    800044ae:	6398                	ld	a4,0(a5)
    800044b0:	cb19                	beqz	a4,800044c6 <fdalloc+0x36>
  for (fd = 0; fd < NOFILE; fd++)
    800044b2:	2505                	addiw	a0,a0,1
    800044b4:	07a1                	addi	a5,a5,8
    800044b6:	fed51ce3          	bne	a0,a3,800044ae <fdalloc+0x1e>
    {
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800044ba:	557d                	li	a0,-1
}
    800044bc:	60e2                	ld	ra,24(sp)
    800044be:	6442                	ld	s0,16(sp)
    800044c0:	64a2                	ld	s1,8(sp)
    800044c2:	6105                	addi	sp,sp,32
    800044c4:	8082                	ret
      p->ofile[fd] = f;
    800044c6:	01e50793          	addi	a5,a0,30
    800044ca:	078e                	slli	a5,a5,0x3
    800044cc:	963e                	add	a2,a2,a5
    800044ce:	e604                	sd	s1,8(a2)
      return fd;
    800044d0:	b7f5                	j	800044bc <fdalloc+0x2c>

00000000800044d2 <create>:
  return -1;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
    800044d2:	715d                	addi	sp,sp,-80
    800044d4:	e486                	sd	ra,72(sp)
    800044d6:	e0a2                	sd	s0,64(sp)
    800044d8:	fc26                	sd	s1,56(sp)
    800044da:	f84a                	sd	s2,48(sp)
    800044dc:	f44e                	sd	s3,40(sp)
    800044de:	f052                	sd	s4,32(sp)
    800044e0:	ec56                	sd	s5,24(sp)
    800044e2:	0880                	addi	s0,sp,80
    800044e4:	89ae                	mv	s3,a1
    800044e6:	8ab2                	mv	s5,a2
    800044e8:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
    800044ea:	fb040593          	addi	a1,s0,-80
    800044ee:	fffff097          	auipc	ra,0xfffff
    800044f2:	e86080e7          	jalr	-378(ra) # 80003374 <nameiparent>
    800044f6:	892a                	mv	s2,a0
    800044f8:	12050f63          	beqz	a0,80004636 <create+0x164>
    return 0;

  ilock(dp);
    800044fc:	ffffe097          	auipc	ra,0xffffe
    80004500:	6a4080e7          	jalr	1700(ra) # 80002ba0 <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0)
    80004504:	4601                	li	a2,0
    80004506:	fb040593          	addi	a1,s0,-80
    8000450a:	854a                	mv	a0,s2
    8000450c:	fffff097          	auipc	ra,0xfffff
    80004510:	b78080e7          	jalr	-1160(ra) # 80003084 <dirlookup>
    80004514:	84aa                	mv	s1,a0
    80004516:	c921                	beqz	a0,80004566 <create+0x94>
  {
    iunlockput(dp);
    80004518:	854a                	mv	a0,s2
    8000451a:	fffff097          	auipc	ra,0xfffff
    8000451e:	8e8080e7          	jalr	-1816(ra) # 80002e02 <iunlockput>
    ilock(ip);
    80004522:	8526                	mv	a0,s1
    80004524:	ffffe097          	auipc	ra,0xffffe
    80004528:	67c080e7          	jalr	1660(ra) # 80002ba0 <ilock>
    if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000452c:	2981                	sext.w	s3,s3
    8000452e:	4789                	li	a5,2
    80004530:	02f99463          	bne	s3,a5,80004558 <create+0x86>
    80004534:	0444d783          	lhu	a5,68(s1)
    80004538:	37f9                	addiw	a5,a5,-2
    8000453a:	17c2                	slli	a5,a5,0x30
    8000453c:	93c1                	srli	a5,a5,0x30
    8000453e:	4705                	li	a4,1
    80004540:	00f76c63          	bltu	a4,a5,80004558 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004544:	8526                	mv	a0,s1
    80004546:	60a6                	ld	ra,72(sp)
    80004548:	6406                	ld	s0,64(sp)
    8000454a:	74e2                	ld	s1,56(sp)
    8000454c:	7942                	ld	s2,48(sp)
    8000454e:	79a2                	ld	s3,40(sp)
    80004550:	7a02                	ld	s4,32(sp)
    80004552:	6ae2                	ld	s5,24(sp)
    80004554:	6161                	addi	sp,sp,80
    80004556:	8082                	ret
    iunlockput(ip);
    80004558:	8526                	mv	a0,s1
    8000455a:	fffff097          	auipc	ra,0xfffff
    8000455e:	8a8080e7          	jalr	-1880(ra) # 80002e02 <iunlockput>
    return 0;
    80004562:	4481                	li	s1,0
    80004564:	b7c5                	j	80004544 <create+0x72>
  if ((ip = ialloc(dp->dev, type)) == 0)
    80004566:	85ce                	mv	a1,s3
    80004568:	00092503          	lw	a0,0(s2)
    8000456c:	ffffe097          	auipc	ra,0xffffe
    80004570:	49c080e7          	jalr	1180(ra) # 80002a08 <ialloc>
    80004574:	84aa                	mv	s1,a0
    80004576:	c529                	beqz	a0,800045c0 <create+0xee>
  ilock(ip);
    80004578:	ffffe097          	auipc	ra,0xffffe
    8000457c:	628080e7          	jalr	1576(ra) # 80002ba0 <ilock>
  ip->major = major;
    80004580:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80004584:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80004588:	4785                	li	a5,1
    8000458a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000458e:	8526                	mv	a0,s1
    80004590:	ffffe097          	auipc	ra,0xffffe
    80004594:	546080e7          	jalr	1350(ra) # 80002ad6 <iupdate>
  if (type == T_DIR)
    80004598:	2981                	sext.w	s3,s3
    8000459a:	4785                	li	a5,1
    8000459c:	02f98a63          	beq	s3,a5,800045d0 <create+0xfe>
  if (dirlink(dp, name, ip->inum) < 0)
    800045a0:	40d0                	lw	a2,4(s1)
    800045a2:	fb040593          	addi	a1,s0,-80
    800045a6:	854a                	mv	a0,s2
    800045a8:	fffff097          	auipc	ra,0xfffff
    800045ac:	cec080e7          	jalr	-788(ra) # 80003294 <dirlink>
    800045b0:	06054b63          	bltz	a0,80004626 <create+0x154>
  iunlockput(dp);
    800045b4:	854a                	mv	a0,s2
    800045b6:	fffff097          	auipc	ra,0xfffff
    800045ba:	84c080e7          	jalr	-1972(ra) # 80002e02 <iunlockput>
  return ip;
    800045be:	b759                	j	80004544 <create+0x72>
    panic("create: ialloc");
    800045c0:	00004517          	auipc	a0,0x4
    800045c4:	0b850513          	addi	a0,a0,184 # 80008678 <syscalls+0x2b0>
    800045c8:	00001097          	auipc	ra,0x1
    800045cc:	690080e7          	jalr	1680(ra) # 80005c58 <panic>
    dp->nlink++; // for ".."
    800045d0:	04a95783          	lhu	a5,74(s2)
    800045d4:	2785                	addiw	a5,a5,1
    800045d6:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800045da:	854a                	mv	a0,s2
    800045dc:	ffffe097          	auipc	ra,0xffffe
    800045e0:	4fa080e7          	jalr	1274(ra) # 80002ad6 <iupdate>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800045e4:	40d0                	lw	a2,4(s1)
    800045e6:	00004597          	auipc	a1,0x4
    800045ea:	0a258593          	addi	a1,a1,162 # 80008688 <syscalls+0x2c0>
    800045ee:	8526                	mv	a0,s1
    800045f0:	fffff097          	auipc	ra,0xfffff
    800045f4:	ca4080e7          	jalr	-860(ra) # 80003294 <dirlink>
    800045f8:	00054f63          	bltz	a0,80004616 <create+0x144>
    800045fc:	00492603          	lw	a2,4(s2)
    80004600:	00004597          	auipc	a1,0x4
    80004604:	09058593          	addi	a1,a1,144 # 80008690 <syscalls+0x2c8>
    80004608:	8526                	mv	a0,s1
    8000460a:	fffff097          	auipc	ra,0xfffff
    8000460e:	c8a080e7          	jalr	-886(ra) # 80003294 <dirlink>
    80004612:	f80557e3          	bgez	a0,800045a0 <create+0xce>
      panic("create dots");
    80004616:	00004517          	auipc	a0,0x4
    8000461a:	08250513          	addi	a0,a0,130 # 80008698 <syscalls+0x2d0>
    8000461e:	00001097          	auipc	ra,0x1
    80004622:	63a080e7          	jalr	1594(ra) # 80005c58 <panic>
    panic("create: dirlink");
    80004626:	00004517          	auipc	a0,0x4
    8000462a:	08250513          	addi	a0,a0,130 # 800086a8 <syscalls+0x2e0>
    8000462e:	00001097          	auipc	ra,0x1
    80004632:	62a080e7          	jalr	1578(ra) # 80005c58 <panic>
    return 0;
    80004636:	84aa                	mv	s1,a0
    80004638:	b731                	j	80004544 <create+0x72>

000000008000463a <sys_dup>:
{
    8000463a:	7179                	addi	sp,sp,-48
    8000463c:	f406                	sd	ra,40(sp)
    8000463e:	f022                	sd	s0,32(sp)
    80004640:	ec26                	sd	s1,24(sp)
    80004642:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0)
    80004644:	fd840613          	addi	a2,s0,-40
    80004648:	4581                	li	a1,0
    8000464a:	4501                	li	a0,0
    8000464c:	00000097          	auipc	ra,0x0
    80004650:	ddc080e7          	jalr	-548(ra) # 80004428 <argfd>
    return -1;
    80004654:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0)
    80004656:	02054363          	bltz	a0,8000467c <sys_dup+0x42>
  if ((fd = fdalloc(f)) < 0)
    8000465a:	fd843503          	ld	a0,-40(s0)
    8000465e:	00000097          	auipc	ra,0x0
    80004662:	e32080e7          	jalr	-462(ra) # 80004490 <fdalloc>
    80004666:	84aa                	mv	s1,a0
    return -1;
    80004668:	57fd                	li	a5,-1
  if ((fd = fdalloc(f)) < 0)
    8000466a:	00054963          	bltz	a0,8000467c <sys_dup+0x42>
  filedup(f);
    8000466e:	fd843503          	ld	a0,-40(s0)
    80004672:	fffff097          	auipc	ra,0xfffff
    80004676:	37a080e7          	jalr	890(ra) # 800039ec <filedup>
  return fd;
    8000467a:	87a6                	mv	a5,s1
}
    8000467c:	853e                	mv	a0,a5
    8000467e:	70a2                	ld	ra,40(sp)
    80004680:	7402                	ld	s0,32(sp)
    80004682:	64e2                	ld	s1,24(sp)
    80004684:	6145                	addi	sp,sp,48
    80004686:	8082                	ret

0000000080004688 <sys_read>:
{
    80004688:	7179                	addi	sp,sp,-48
    8000468a:	f406                	sd	ra,40(sp)
    8000468c:	f022                	sd	s0,32(sp)
    8000468e:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004690:	fe840613          	addi	a2,s0,-24
    80004694:	4581                	li	a1,0
    80004696:	4501                	li	a0,0
    80004698:	00000097          	auipc	ra,0x0
    8000469c:	d90080e7          	jalr	-624(ra) # 80004428 <argfd>
    return -1;
    800046a0:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046a2:	04054163          	bltz	a0,800046e4 <sys_read+0x5c>
    800046a6:	fe440593          	addi	a1,s0,-28
    800046aa:	4509                	li	a0,2
    800046ac:	ffffe097          	auipc	ra,0xffffe
    800046b0:	8ce080e7          	jalr	-1842(ra) # 80001f7a <argint>
    return -1;
    800046b4:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046b6:	02054763          	bltz	a0,800046e4 <sys_read+0x5c>
    800046ba:	fd840593          	addi	a1,s0,-40
    800046be:	4505                	li	a0,1
    800046c0:	ffffe097          	auipc	ra,0xffffe
    800046c4:	8dc080e7          	jalr	-1828(ra) # 80001f9c <argaddr>
    return -1;
    800046c8:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046ca:	00054d63          	bltz	a0,800046e4 <sys_read+0x5c>
  return fileread(f, p, n);
    800046ce:	fe442603          	lw	a2,-28(s0)
    800046d2:	fd843583          	ld	a1,-40(s0)
    800046d6:	fe843503          	ld	a0,-24(s0)
    800046da:	fffff097          	auipc	ra,0xfffff
    800046de:	49e080e7          	jalr	1182(ra) # 80003b78 <fileread>
    800046e2:	87aa                	mv	a5,a0
}
    800046e4:	853e                	mv	a0,a5
    800046e6:	70a2                	ld	ra,40(sp)
    800046e8:	7402                	ld	s0,32(sp)
    800046ea:	6145                	addi	sp,sp,48
    800046ec:	8082                	ret

00000000800046ee <sys_write>:
{
    800046ee:	7179                	addi	sp,sp,-48
    800046f0:	f406                	sd	ra,40(sp)
    800046f2:	f022                	sd	s0,32(sp)
    800046f4:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046f6:	fe840613          	addi	a2,s0,-24
    800046fa:	4581                	li	a1,0
    800046fc:	4501                	li	a0,0
    800046fe:	00000097          	auipc	ra,0x0
    80004702:	d2a080e7          	jalr	-726(ra) # 80004428 <argfd>
    return -1;
    80004706:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004708:	04054163          	bltz	a0,8000474a <sys_write+0x5c>
    8000470c:	fe440593          	addi	a1,s0,-28
    80004710:	4509                	li	a0,2
    80004712:	ffffe097          	auipc	ra,0xffffe
    80004716:	868080e7          	jalr	-1944(ra) # 80001f7a <argint>
    return -1;
    8000471a:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000471c:	02054763          	bltz	a0,8000474a <sys_write+0x5c>
    80004720:	fd840593          	addi	a1,s0,-40
    80004724:	4505                	li	a0,1
    80004726:	ffffe097          	auipc	ra,0xffffe
    8000472a:	876080e7          	jalr	-1930(ra) # 80001f9c <argaddr>
    return -1;
    8000472e:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004730:	00054d63          	bltz	a0,8000474a <sys_write+0x5c>
  return filewrite(f, p, n);
    80004734:	fe442603          	lw	a2,-28(s0)
    80004738:	fd843583          	ld	a1,-40(s0)
    8000473c:	fe843503          	ld	a0,-24(s0)
    80004740:	fffff097          	auipc	ra,0xfffff
    80004744:	4fa080e7          	jalr	1274(ra) # 80003c3a <filewrite>
    80004748:	87aa                	mv	a5,a0
}
    8000474a:	853e                	mv	a0,a5
    8000474c:	70a2                	ld	ra,40(sp)
    8000474e:	7402                	ld	s0,32(sp)
    80004750:	6145                	addi	sp,sp,48
    80004752:	8082                	ret

0000000080004754 <sys_close>:
{
    80004754:	1101                	addi	sp,sp,-32
    80004756:	ec06                	sd	ra,24(sp)
    80004758:	e822                	sd	s0,16(sp)
    8000475a:	1000                	addi	s0,sp,32
  if (argfd(0, &fd, &f) < 0)
    8000475c:	fe040613          	addi	a2,s0,-32
    80004760:	fec40593          	addi	a1,s0,-20
    80004764:	4501                	li	a0,0
    80004766:	00000097          	auipc	ra,0x0
    8000476a:	cc2080e7          	jalr	-830(ra) # 80004428 <argfd>
    return -1;
    8000476e:	57fd                	li	a5,-1
  if (argfd(0, &fd, &f) < 0)
    80004770:	02054463          	bltz	a0,80004798 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004774:	ffffc097          	auipc	ra,0xffffc
    80004778:	6d4080e7          	jalr	1748(ra) # 80000e48 <myproc>
    8000477c:	fec42783          	lw	a5,-20(s0)
    80004780:	07f9                	addi	a5,a5,30
    80004782:	078e                	slli	a5,a5,0x3
    80004784:	97aa                	add	a5,a5,a0
    80004786:	0007b423          	sd	zero,8(a5)
  fileclose(f);
    8000478a:	fe043503          	ld	a0,-32(s0)
    8000478e:	fffff097          	auipc	ra,0xfffff
    80004792:	2b0080e7          	jalr	688(ra) # 80003a3e <fileclose>
  return 0;
    80004796:	4781                	li	a5,0
}
    80004798:	853e                	mv	a0,a5
    8000479a:	60e2                	ld	ra,24(sp)
    8000479c:	6442                	ld	s0,16(sp)
    8000479e:	6105                	addi	sp,sp,32
    800047a0:	8082                	ret

00000000800047a2 <sys_fstat>:
{
    800047a2:	1101                	addi	sp,sp,-32
    800047a4:	ec06                	sd	ra,24(sp)
    800047a6:	e822                	sd	s0,16(sp)
    800047a8:	1000                	addi	s0,sp,32
  if (argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047aa:	fe840613          	addi	a2,s0,-24
    800047ae:	4581                	li	a1,0
    800047b0:	4501                	li	a0,0
    800047b2:	00000097          	auipc	ra,0x0
    800047b6:	c76080e7          	jalr	-906(ra) # 80004428 <argfd>
    return -1;
    800047ba:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047bc:	02054563          	bltz	a0,800047e6 <sys_fstat+0x44>
    800047c0:	fe040593          	addi	a1,s0,-32
    800047c4:	4505                	li	a0,1
    800047c6:	ffffd097          	auipc	ra,0xffffd
    800047ca:	7d6080e7          	jalr	2006(ra) # 80001f9c <argaddr>
    return -1;
    800047ce:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047d0:	00054b63          	bltz	a0,800047e6 <sys_fstat+0x44>
  return filestat(f, st);
    800047d4:	fe043583          	ld	a1,-32(s0)
    800047d8:	fe843503          	ld	a0,-24(s0)
    800047dc:	fffff097          	auipc	ra,0xfffff
    800047e0:	32a080e7          	jalr	810(ra) # 80003b06 <filestat>
    800047e4:	87aa                	mv	a5,a0
}
    800047e6:	853e                	mv	a0,a5
    800047e8:	60e2                	ld	ra,24(sp)
    800047ea:	6442                	ld	s0,16(sp)
    800047ec:	6105                	addi	sp,sp,32
    800047ee:	8082                	ret

00000000800047f0 <sys_link>:
{
    800047f0:	7169                	addi	sp,sp,-304
    800047f2:	f606                	sd	ra,296(sp)
    800047f4:	f222                	sd	s0,288(sp)
    800047f6:	ee26                	sd	s1,280(sp)
    800047f8:	ea4a                	sd	s2,272(sp)
    800047fa:	1a00                	addi	s0,sp,304
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047fc:	08000613          	li	a2,128
    80004800:	ed040593          	addi	a1,s0,-304
    80004804:	4501                	li	a0,0
    80004806:	ffffd097          	auipc	ra,0xffffd
    8000480a:	7b8080e7          	jalr	1976(ra) # 80001fbe <argstr>
    return -1;
    8000480e:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004810:	10054e63          	bltz	a0,8000492c <sys_link+0x13c>
    80004814:	08000613          	li	a2,128
    80004818:	f5040593          	addi	a1,s0,-176
    8000481c:	4505                	li	a0,1
    8000481e:	ffffd097          	auipc	ra,0xffffd
    80004822:	7a0080e7          	jalr	1952(ra) # 80001fbe <argstr>
    return -1;
    80004826:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004828:	10054263          	bltz	a0,8000492c <sys_link+0x13c>
  begin_op();
    8000482c:	fffff097          	auipc	ra,0xfffff
    80004830:	d46080e7          	jalr	-698(ra) # 80003572 <begin_op>
  if ((ip = namei(old)) == 0)
    80004834:	ed040513          	addi	a0,s0,-304
    80004838:	fffff097          	auipc	ra,0xfffff
    8000483c:	b1e080e7          	jalr	-1250(ra) # 80003356 <namei>
    80004840:	84aa                	mv	s1,a0
    80004842:	c551                	beqz	a0,800048ce <sys_link+0xde>
  ilock(ip);
    80004844:	ffffe097          	auipc	ra,0xffffe
    80004848:	35c080e7          	jalr	860(ra) # 80002ba0 <ilock>
  if (ip->type == T_DIR)
    8000484c:	04449703          	lh	a4,68(s1)
    80004850:	4785                	li	a5,1
    80004852:	08f70463          	beq	a4,a5,800048da <sys_link+0xea>
  ip->nlink++;
    80004856:	04a4d783          	lhu	a5,74(s1)
    8000485a:	2785                	addiw	a5,a5,1
    8000485c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004860:	8526                	mv	a0,s1
    80004862:	ffffe097          	auipc	ra,0xffffe
    80004866:	274080e7          	jalr	628(ra) # 80002ad6 <iupdate>
  iunlock(ip);
    8000486a:	8526                	mv	a0,s1
    8000486c:	ffffe097          	auipc	ra,0xffffe
    80004870:	3f6080e7          	jalr	1014(ra) # 80002c62 <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
    80004874:	fd040593          	addi	a1,s0,-48
    80004878:	f5040513          	addi	a0,s0,-176
    8000487c:	fffff097          	auipc	ra,0xfffff
    80004880:	af8080e7          	jalr	-1288(ra) # 80003374 <nameiparent>
    80004884:	892a                	mv	s2,a0
    80004886:	c935                	beqz	a0,800048fa <sys_link+0x10a>
  ilock(dp);
    80004888:	ffffe097          	auipc	ra,0xffffe
    8000488c:	318080e7          	jalr	792(ra) # 80002ba0 <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
    80004890:	00092703          	lw	a4,0(s2)
    80004894:	409c                	lw	a5,0(s1)
    80004896:	04f71d63          	bne	a4,a5,800048f0 <sys_link+0x100>
    8000489a:	40d0                	lw	a2,4(s1)
    8000489c:	fd040593          	addi	a1,s0,-48
    800048a0:	854a                	mv	a0,s2
    800048a2:	fffff097          	auipc	ra,0xfffff
    800048a6:	9f2080e7          	jalr	-1550(ra) # 80003294 <dirlink>
    800048aa:	04054363          	bltz	a0,800048f0 <sys_link+0x100>
  iunlockput(dp);
    800048ae:	854a                	mv	a0,s2
    800048b0:	ffffe097          	auipc	ra,0xffffe
    800048b4:	552080e7          	jalr	1362(ra) # 80002e02 <iunlockput>
  iput(ip);
    800048b8:	8526                	mv	a0,s1
    800048ba:	ffffe097          	auipc	ra,0xffffe
    800048be:	4a0080e7          	jalr	1184(ra) # 80002d5a <iput>
  end_op();
    800048c2:	fffff097          	auipc	ra,0xfffff
    800048c6:	d30080e7          	jalr	-720(ra) # 800035f2 <end_op>
  return 0;
    800048ca:	4781                	li	a5,0
    800048cc:	a085                	j	8000492c <sys_link+0x13c>
    end_op();
    800048ce:	fffff097          	auipc	ra,0xfffff
    800048d2:	d24080e7          	jalr	-732(ra) # 800035f2 <end_op>
    return -1;
    800048d6:	57fd                	li	a5,-1
    800048d8:	a891                	j	8000492c <sys_link+0x13c>
    iunlockput(ip);
    800048da:	8526                	mv	a0,s1
    800048dc:	ffffe097          	auipc	ra,0xffffe
    800048e0:	526080e7          	jalr	1318(ra) # 80002e02 <iunlockput>
    end_op();
    800048e4:	fffff097          	auipc	ra,0xfffff
    800048e8:	d0e080e7          	jalr	-754(ra) # 800035f2 <end_op>
    return -1;
    800048ec:	57fd                	li	a5,-1
    800048ee:	a83d                	j	8000492c <sys_link+0x13c>
    iunlockput(dp);
    800048f0:	854a                	mv	a0,s2
    800048f2:	ffffe097          	auipc	ra,0xffffe
    800048f6:	510080e7          	jalr	1296(ra) # 80002e02 <iunlockput>
  ilock(ip);
    800048fa:	8526                	mv	a0,s1
    800048fc:	ffffe097          	auipc	ra,0xffffe
    80004900:	2a4080e7          	jalr	676(ra) # 80002ba0 <ilock>
  ip->nlink--;
    80004904:	04a4d783          	lhu	a5,74(s1)
    80004908:	37fd                	addiw	a5,a5,-1
    8000490a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000490e:	8526                	mv	a0,s1
    80004910:	ffffe097          	auipc	ra,0xffffe
    80004914:	1c6080e7          	jalr	454(ra) # 80002ad6 <iupdate>
  iunlockput(ip);
    80004918:	8526                	mv	a0,s1
    8000491a:	ffffe097          	auipc	ra,0xffffe
    8000491e:	4e8080e7          	jalr	1256(ra) # 80002e02 <iunlockput>
  end_op();
    80004922:	fffff097          	auipc	ra,0xfffff
    80004926:	cd0080e7          	jalr	-816(ra) # 800035f2 <end_op>
  return -1;
    8000492a:	57fd                	li	a5,-1
}
    8000492c:	853e                	mv	a0,a5
    8000492e:	70b2                	ld	ra,296(sp)
    80004930:	7412                	ld	s0,288(sp)
    80004932:	64f2                	ld	s1,280(sp)
    80004934:	6952                	ld	s2,272(sp)
    80004936:	6155                	addi	sp,sp,304
    80004938:	8082                	ret

000000008000493a <sys_unlink>:
{
    8000493a:	7151                	addi	sp,sp,-240
    8000493c:	f586                	sd	ra,232(sp)
    8000493e:	f1a2                	sd	s0,224(sp)
    80004940:	eda6                	sd	s1,216(sp)
    80004942:	e9ca                	sd	s2,208(sp)
    80004944:	e5ce                	sd	s3,200(sp)
    80004946:	1980                	addi	s0,sp,240
  if (argstr(0, path, MAXPATH) < 0)
    80004948:	08000613          	li	a2,128
    8000494c:	f3040593          	addi	a1,s0,-208
    80004950:	4501                	li	a0,0
    80004952:	ffffd097          	auipc	ra,0xffffd
    80004956:	66c080e7          	jalr	1644(ra) # 80001fbe <argstr>
    8000495a:	18054163          	bltz	a0,80004adc <sys_unlink+0x1a2>
  begin_op();
    8000495e:	fffff097          	auipc	ra,0xfffff
    80004962:	c14080e7          	jalr	-1004(ra) # 80003572 <begin_op>
  if ((dp = nameiparent(path, name)) == 0)
    80004966:	fb040593          	addi	a1,s0,-80
    8000496a:	f3040513          	addi	a0,s0,-208
    8000496e:	fffff097          	auipc	ra,0xfffff
    80004972:	a06080e7          	jalr	-1530(ra) # 80003374 <nameiparent>
    80004976:	84aa                	mv	s1,a0
    80004978:	c979                	beqz	a0,80004a4e <sys_unlink+0x114>
  ilock(dp);
    8000497a:	ffffe097          	auipc	ra,0xffffe
    8000497e:	226080e7          	jalr	550(ra) # 80002ba0 <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004982:	00004597          	auipc	a1,0x4
    80004986:	d0658593          	addi	a1,a1,-762 # 80008688 <syscalls+0x2c0>
    8000498a:	fb040513          	addi	a0,s0,-80
    8000498e:	ffffe097          	auipc	ra,0xffffe
    80004992:	6dc080e7          	jalr	1756(ra) # 8000306a <namecmp>
    80004996:	14050a63          	beqz	a0,80004aea <sys_unlink+0x1b0>
    8000499a:	00004597          	auipc	a1,0x4
    8000499e:	cf658593          	addi	a1,a1,-778 # 80008690 <syscalls+0x2c8>
    800049a2:	fb040513          	addi	a0,s0,-80
    800049a6:	ffffe097          	auipc	ra,0xffffe
    800049aa:	6c4080e7          	jalr	1732(ra) # 8000306a <namecmp>
    800049ae:	12050e63          	beqz	a0,80004aea <sys_unlink+0x1b0>
  if ((ip = dirlookup(dp, name, &off)) == 0)
    800049b2:	f2c40613          	addi	a2,s0,-212
    800049b6:	fb040593          	addi	a1,s0,-80
    800049ba:	8526                	mv	a0,s1
    800049bc:	ffffe097          	auipc	ra,0xffffe
    800049c0:	6c8080e7          	jalr	1736(ra) # 80003084 <dirlookup>
    800049c4:	892a                	mv	s2,a0
    800049c6:	12050263          	beqz	a0,80004aea <sys_unlink+0x1b0>
  ilock(ip);
    800049ca:	ffffe097          	auipc	ra,0xffffe
    800049ce:	1d6080e7          	jalr	470(ra) # 80002ba0 <ilock>
  if (ip->nlink < 1)
    800049d2:	04a91783          	lh	a5,74(s2)
    800049d6:	08f05263          	blez	a5,80004a5a <sys_unlink+0x120>
  if (ip->type == T_DIR && !isdirempty(ip))
    800049da:	04491703          	lh	a4,68(s2)
    800049de:	4785                	li	a5,1
    800049e0:	08f70563          	beq	a4,a5,80004a6a <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800049e4:	4641                	li	a2,16
    800049e6:	4581                	li	a1,0
    800049e8:	fc040513          	addi	a0,s0,-64
    800049ec:	ffffb097          	auipc	ra,0xffffb
    800049f0:	78c080e7          	jalr	1932(ra) # 80000178 <memset>
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800049f4:	4741                	li	a4,16
    800049f6:	f2c42683          	lw	a3,-212(s0)
    800049fa:	fc040613          	addi	a2,s0,-64
    800049fe:	4581                	li	a1,0
    80004a00:	8526                	mv	a0,s1
    80004a02:	ffffe097          	auipc	ra,0xffffe
    80004a06:	54a080e7          	jalr	1354(ra) # 80002f4c <writei>
    80004a0a:	47c1                	li	a5,16
    80004a0c:	0af51563          	bne	a0,a5,80004ab6 <sys_unlink+0x17c>
  if (ip->type == T_DIR)
    80004a10:	04491703          	lh	a4,68(s2)
    80004a14:	4785                	li	a5,1
    80004a16:	0af70863          	beq	a4,a5,80004ac6 <sys_unlink+0x18c>
  iunlockput(dp);
    80004a1a:	8526                	mv	a0,s1
    80004a1c:	ffffe097          	auipc	ra,0xffffe
    80004a20:	3e6080e7          	jalr	998(ra) # 80002e02 <iunlockput>
  ip->nlink--;
    80004a24:	04a95783          	lhu	a5,74(s2)
    80004a28:	37fd                	addiw	a5,a5,-1
    80004a2a:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a2e:	854a                	mv	a0,s2
    80004a30:	ffffe097          	auipc	ra,0xffffe
    80004a34:	0a6080e7          	jalr	166(ra) # 80002ad6 <iupdate>
  iunlockput(ip);
    80004a38:	854a                	mv	a0,s2
    80004a3a:	ffffe097          	auipc	ra,0xffffe
    80004a3e:	3c8080e7          	jalr	968(ra) # 80002e02 <iunlockput>
  end_op();
    80004a42:	fffff097          	auipc	ra,0xfffff
    80004a46:	bb0080e7          	jalr	-1104(ra) # 800035f2 <end_op>
  return 0;
    80004a4a:	4501                	li	a0,0
    80004a4c:	a84d                	j	80004afe <sys_unlink+0x1c4>
    end_op();
    80004a4e:	fffff097          	auipc	ra,0xfffff
    80004a52:	ba4080e7          	jalr	-1116(ra) # 800035f2 <end_op>
    return -1;
    80004a56:	557d                	li	a0,-1
    80004a58:	a05d                	j	80004afe <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004a5a:	00004517          	auipc	a0,0x4
    80004a5e:	c5e50513          	addi	a0,a0,-930 # 800086b8 <syscalls+0x2f0>
    80004a62:	00001097          	auipc	ra,0x1
    80004a66:	1f6080e7          	jalr	502(ra) # 80005c58 <panic>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
    80004a6a:	04c92703          	lw	a4,76(s2)
    80004a6e:	02000793          	li	a5,32
    80004a72:	f6e7f9e3          	bgeu	a5,a4,800049e4 <sys_unlink+0xaa>
    80004a76:	02000993          	li	s3,32
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a7a:	4741                	li	a4,16
    80004a7c:	86ce                	mv	a3,s3
    80004a7e:	f1840613          	addi	a2,s0,-232
    80004a82:	4581                	li	a1,0
    80004a84:	854a                	mv	a0,s2
    80004a86:	ffffe097          	auipc	ra,0xffffe
    80004a8a:	3ce080e7          	jalr	974(ra) # 80002e54 <readi>
    80004a8e:	47c1                	li	a5,16
    80004a90:	00f51b63          	bne	a0,a5,80004aa6 <sys_unlink+0x16c>
    if (de.inum != 0)
    80004a94:	f1845783          	lhu	a5,-232(s0)
    80004a98:	e7a1                	bnez	a5,80004ae0 <sys_unlink+0x1a6>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
    80004a9a:	29c1                	addiw	s3,s3,16
    80004a9c:	04c92783          	lw	a5,76(s2)
    80004aa0:	fcf9ede3          	bltu	s3,a5,80004a7a <sys_unlink+0x140>
    80004aa4:	b781                	j	800049e4 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004aa6:	00004517          	auipc	a0,0x4
    80004aaa:	c2a50513          	addi	a0,a0,-982 # 800086d0 <syscalls+0x308>
    80004aae:	00001097          	auipc	ra,0x1
    80004ab2:	1aa080e7          	jalr	426(ra) # 80005c58 <panic>
    panic("unlink: writei");
    80004ab6:	00004517          	auipc	a0,0x4
    80004aba:	c3250513          	addi	a0,a0,-974 # 800086e8 <syscalls+0x320>
    80004abe:	00001097          	auipc	ra,0x1
    80004ac2:	19a080e7          	jalr	410(ra) # 80005c58 <panic>
    dp->nlink--;
    80004ac6:	04a4d783          	lhu	a5,74(s1)
    80004aca:	37fd                	addiw	a5,a5,-1
    80004acc:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004ad0:	8526                	mv	a0,s1
    80004ad2:	ffffe097          	auipc	ra,0xffffe
    80004ad6:	004080e7          	jalr	4(ra) # 80002ad6 <iupdate>
    80004ada:	b781                	j	80004a1a <sys_unlink+0xe0>
    return -1;
    80004adc:	557d                	li	a0,-1
    80004ade:	a005                	j	80004afe <sys_unlink+0x1c4>
    iunlockput(ip);
    80004ae0:	854a                	mv	a0,s2
    80004ae2:	ffffe097          	auipc	ra,0xffffe
    80004ae6:	320080e7          	jalr	800(ra) # 80002e02 <iunlockput>
  iunlockput(dp);
    80004aea:	8526                	mv	a0,s1
    80004aec:	ffffe097          	auipc	ra,0xffffe
    80004af0:	316080e7          	jalr	790(ra) # 80002e02 <iunlockput>
  end_op();
    80004af4:	fffff097          	auipc	ra,0xfffff
    80004af8:	afe080e7          	jalr	-1282(ra) # 800035f2 <end_op>
  return -1;
    80004afc:	557d                	li	a0,-1
}
    80004afe:	70ae                	ld	ra,232(sp)
    80004b00:	740e                	ld	s0,224(sp)
    80004b02:	64ee                	ld	s1,216(sp)
    80004b04:	694e                	ld	s2,208(sp)
    80004b06:	69ae                	ld	s3,200(sp)
    80004b08:	616d                	addi	sp,sp,240
    80004b0a:	8082                	ret

0000000080004b0c <sys_open>:

uint64
sys_open(void)
{
    80004b0c:	7131                	addi	sp,sp,-192
    80004b0e:	fd06                	sd	ra,184(sp)
    80004b10:	f922                	sd	s0,176(sp)
    80004b12:	f526                	sd	s1,168(sp)
    80004b14:	f14a                	sd	s2,160(sp)
    80004b16:	ed4e                	sd	s3,152(sp)
    80004b18:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if ((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b1a:	08000613          	li	a2,128
    80004b1e:	f5040593          	addi	a1,s0,-176
    80004b22:	4501                	li	a0,0
    80004b24:	ffffd097          	auipc	ra,0xffffd
    80004b28:	49a080e7          	jalr	1178(ra) # 80001fbe <argstr>
    return -1;
    80004b2c:	54fd                	li	s1,-1
  if ((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b2e:	0c054163          	bltz	a0,80004bf0 <sys_open+0xe4>
    80004b32:	f4c40593          	addi	a1,s0,-180
    80004b36:	4505                	li	a0,1
    80004b38:	ffffd097          	auipc	ra,0xffffd
    80004b3c:	442080e7          	jalr	1090(ra) # 80001f7a <argint>
    80004b40:	0a054863          	bltz	a0,80004bf0 <sys_open+0xe4>

  begin_op();
    80004b44:	fffff097          	auipc	ra,0xfffff
    80004b48:	a2e080e7          	jalr	-1490(ra) # 80003572 <begin_op>

  if (omode & O_CREATE)
    80004b4c:	f4c42783          	lw	a5,-180(s0)
    80004b50:	2007f793          	andi	a5,a5,512
    80004b54:	cbdd                	beqz	a5,80004c0a <sys_open+0xfe>
  {
    ip = create(path, T_FILE, 0, 0);
    80004b56:	4681                	li	a3,0
    80004b58:	4601                	li	a2,0
    80004b5a:	4589                	li	a1,2
    80004b5c:	f5040513          	addi	a0,s0,-176
    80004b60:	00000097          	auipc	ra,0x0
    80004b64:	972080e7          	jalr	-1678(ra) # 800044d2 <create>
    80004b68:	892a                	mv	s2,a0
    if (ip == 0)
    80004b6a:	c959                	beqz	a0,80004c00 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV))
    80004b6c:	04491703          	lh	a4,68(s2)
    80004b70:	478d                	li	a5,3
    80004b72:	00f71763          	bne	a4,a5,80004b80 <sys_open+0x74>
    80004b76:	04695703          	lhu	a4,70(s2)
    80004b7a:	47a5                	li	a5,9
    80004b7c:	0ce7ec63          	bltu	a5,a4,80004c54 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
    80004b80:	fffff097          	auipc	ra,0xfffff
    80004b84:	e02080e7          	jalr	-510(ra) # 80003982 <filealloc>
    80004b88:	89aa                	mv	s3,a0
    80004b8a:	10050263          	beqz	a0,80004c8e <sys_open+0x182>
    80004b8e:	00000097          	auipc	ra,0x0
    80004b92:	902080e7          	jalr	-1790(ra) # 80004490 <fdalloc>
    80004b96:	84aa                	mv	s1,a0
    80004b98:	0e054663          	bltz	a0,80004c84 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if (ip->type == T_DEVICE)
    80004b9c:	04491703          	lh	a4,68(s2)
    80004ba0:	478d                	li	a5,3
    80004ba2:	0cf70463          	beq	a4,a5,80004c6a <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  }
  else
  {
    f->type = FD_INODE;
    80004ba6:	4789                	li	a5,2
    80004ba8:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004bac:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004bb0:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004bb4:	f4c42783          	lw	a5,-180(s0)
    80004bb8:	0017c713          	xori	a4,a5,1
    80004bbc:	8b05                	andi	a4,a4,1
    80004bbe:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004bc2:	0037f713          	andi	a4,a5,3
    80004bc6:	00e03733          	snez	a4,a4
    80004bca:	00e984a3          	sb	a4,9(s3)

  if ((omode & O_TRUNC) && ip->type == T_FILE)
    80004bce:	4007f793          	andi	a5,a5,1024
    80004bd2:	c791                	beqz	a5,80004bde <sys_open+0xd2>
    80004bd4:	04491703          	lh	a4,68(s2)
    80004bd8:	4789                	li	a5,2
    80004bda:	08f70f63          	beq	a4,a5,80004c78 <sys_open+0x16c>
  {
    itrunc(ip);
  }

  iunlock(ip);
    80004bde:	854a                	mv	a0,s2
    80004be0:	ffffe097          	auipc	ra,0xffffe
    80004be4:	082080e7          	jalr	130(ra) # 80002c62 <iunlock>
  end_op();
    80004be8:	fffff097          	auipc	ra,0xfffff
    80004bec:	a0a080e7          	jalr	-1526(ra) # 800035f2 <end_op>

  return fd;
}
    80004bf0:	8526                	mv	a0,s1
    80004bf2:	70ea                	ld	ra,184(sp)
    80004bf4:	744a                	ld	s0,176(sp)
    80004bf6:	74aa                	ld	s1,168(sp)
    80004bf8:	790a                	ld	s2,160(sp)
    80004bfa:	69ea                	ld	s3,152(sp)
    80004bfc:	6129                	addi	sp,sp,192
    80004bfe:	8082                	ret
      end_op();
    80004c00:	fffff097          	auipc	ra,0xfffff
    80004c04:	9f2080e7          	jalr	-1550(ra) # 800035f2 <end_op>
      return -1;
    80004c08:	b7e5                	j	80004bf0 <sys_open+0xe4>
    if ((ip = namei(path)) == 0)
    80004c0a:	f5040513          	addi	a0,s0,-176
    80004c0e:	ffffe097          	auipc	ra,0xffffe
    80004c12:	748080e7          	jalr	1864(ra) # 80003356 <namei>
    80004c16:	892a                	mv	s2,a0
    80004c18:	c905                	beqz	a0,80004c48 <sys_open+0x13c>
    ilock(ip);
    80004c1a:	ffffe097          	auipc	ra,0xffffe
    80004c1e:	f86080e7          	jalr	-122(ra) # 80002ba0 <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY)
    80004c22:	04491703          	lh	a4,68(s2)
    80004c26:	4785                	li	a5,1
    80004c28:	f4f712e3          	bne	a4,a5,80004b6c <sys_open+0x60>
    80004c2c:	f4c42783          	lw	a5,-180(s0)
    80004c30:	dba1                	beqz	a5,80004b80 <sys_open+0x74>
      iunlockput(ip);
    80004c32:	854a                	mv	a0,s2
    80004c34:	ffffe097          	auipc	ra,0xffffe
    80004c38:	1ce080e7          	jalr	462(ra) # 80002e02 <iunlockput>
      end_op();
    80004c3c:	fffff097          	auipc	ra,0xfffff
    80004c40:	9b6080e7          	jalr	-1610(ra) # 800035f2 <end_op>
      return -1;
    80004c44:	54fd                	li	s1,-1
    80004c46:	b76d                	j	80004bf0 <sys_open+0xe4>
      end_op();
    80004c48:	fffff097          	auipc	ra,0xfffff
    80004c4c:	9aa080e7          	jalr	-1622(ra) # 800035f2 <end_op>
      return -1;
    80004c50:	54fd                	li	s1,-1
    80004c52:	bf79                	j	80004bf0 <sys_open+0xe4>
    iunlockput(ip);
    80004c54:	854a                	mv	a0,s2
    80004c56:	ffffe097          	auipc	ra,0xffffe
    80004c5a:	1ac080e7          	jalr	428(ra) # 80002e02 <iunlockput>
    end_op();
    80004c5e:	fffff097          	auipc	ra,0xfffff
    80004c62:	994080e7          	jalr	-1644(ra) # 800035f2 <end_op>
    return -1;
    80004c66:	54fd                	li	s1,-1
    80004c68:	b761                	j	80004bf0 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004c6a:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004c6e:	04691783          	lh	a5,70(s2)
    80004c72:	02f99223          	sh	a5,36(s3)
    80004c76:	bf2d                	j	80004bb0 <sys_open+0xa4>
    itrunc(ip);
    80004c78:	854a                	mv	a0,s2
    80004c7a:	ffffe097          	auipc	ra,0xffffe
    80004c7e:	034080e7          	jalr	52(ra) # 80002cae <itrunc>
    80004c82:	bfb1                	j	80004bde <sys_open+0xd2>
      fileclose(f);
    80004c84:	854e                	mv	a0,s3
    80004c86:	fffff097          	auipc	ra,0xfffff
    80004c8a:	db8080e7          	jalr	-584(ra) # 80003a3e <fileclose>
    iunlockput(ip);
    80004c8e:	854a                	mv	a0,s2
    80004c90:	ffffe097          	auipc	ra,0xffffe
    80004c94:	172080e7          	jalr	370(ra) # 80002e02 <iunlockput>
    end_op();
    80004c98:	fffff097          	auipc	ra,0xfffff
    80004c9c:	95a080e7          	jalr	-1702(ra) # 800035f2 <end_op>
    return -1;
    80004ca0:	54fd                	li	s1,-1
    80004ca2:	b7b9                	j	80004bf0 <sys_open+0xe4>

0000000080004ca4 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004ca4:	7175                	addi	sp,sp,-144
    80004ca6:	e506                	sd	ra,136(sp)
    80004ca8:	e122                	sd	s0,128(sp)
    80004caa:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004cac:	fffff097          	auipc	ra,0xfffff
    80004cb0:	8c6080e7          	jalr	-1850(ra) # 80003572 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
    80004cb4:	08000613          	li	a2,128
    80004cb8:	f7040593          	addi	a1,s0,-144
    80004cbc:	4501                	li	a0,0
    80004cbe:	ffffd097          	auipc	ra,0xffffd
    80004cc2:	300080e7          	jalr	768(ra) # 80001fbe <argstr>
    80004cc6:	02054963          	bltz	a0,80004cf8 <sys_mkdir+0x54>
    80004cca:	4681                	li	a3,0
    80004ccc:	4601                	li	a2,0
    80004cce:	4585                	li	a1,1
    80004cd0:	f7040513          	addi	a0,s0,-144
    80004cd4:	fffff097          	auipc	ra,0xfffff
    80004cd8:	7fe080e7          	jalr	2046(ra) # 800044d2 <create>
    80004cdc:	cd11                	beqz	a0,80004cf8 <sys_mkdir+0x54>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004cde:	ffffe097          	auipc	ra,0xffffe
    80004ce2:	124080e7          	jalr	292(ra) # 80002e02 <iunlockput>
  end_op();
    80004ce6:	fffff097          	auipc	ra,0xfffff
    80004cea:	90c080e7          	jalr	-1780(ra) # 800035f2 <end_op>
  return 0;
    80004cee:	4501                	li	a0,0
}
    80004cf0:	60aa                	ld	ra,136(sp)
    80004cf2:	640a                	ld	s0,128(sp)
    80004cf4:	6149                	addi	sp,sp,144
    80004cf6:	8082                	ret
    end_op();
    80004cf8:	fffff097          	auipc	ra,0xfffff
    80004cfc:	8fa080e7          	jalr	-1798(ra) # 800035f2 <end_op>
    return -1;
    80004d00:	557d                	li	a0,-1
    80004d02:	b7fd                	j	80004cf0 <sys_mkdir+0x4c>

0000000080004d04 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d04:	7135                	addi	sp,sp,-160
    80004d06:	ed06                	sd	ra,152(sp)
    80004d08:	e922                	sd	s0,144(sp)
    80004d0a:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d0c:	fffff097          	auipc	ra,0xfffff
    80004d10:	866080e7          	jalr	-1946(ra) # 80003572 <begin_op>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80004d14:	08000613          	li	a2,128
    80004d18:	f7040593          	addi	a1,s0,-144
    80004d1c:	4501                	li	a0,0
    80004d1e:	ffffd097          	auipc	ra,0xffffd
    80004d22:	2a0080e7          	jalr	672(ra) # 80001fbe <argstr>
    80004d26:	04054a63          	bltz	a0,80004d7a <sys_mknod+0x76>
      argint(1, &major) < 0 ||
    80004d2a:	f6c40593          	addi	a1,s0,-148
    80004d2e:	4505                	li	a0,1
    80004d30:	ffffd097          	auipc	ra,0xffffd
    80004d34:	24a080e7          	jalr	586(ra) # 80001f7a <argint>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80004d38:	04054163          	bltz	a0,80004d7a <sys_mknod+0x76>
      argint(2, &minor) < 0 ||
    80004d3c:	f6840593          	addi	a1,s0,-152
    80004d40:	4509                	li	a0,2
    80004d42:	ffffd097          	auipc	ra,0xffffd
    80004d46:	238080e7          	jalr	568(ra) # 80001f7a <argint>
      argint(1, &major) < 0 ||
    80004d4a:	02054863          	bltz	a0,80004d7a <sys_mknod+0x76>
      (ip = create(path, T_DEVICE, major, minor)) == 0)
    80004d4e:	f6841683          	lh	a3,-152(s0)
    80004d52:	f6c41603          	lh	a2,-148(s0)
    80004d56:	458d                	li	a1,3
    80004d58:	f7040513          	addi	a0,s0,-144
    80004d5c:	fffff097          	auipc	ra,0xfffff
    80004d60:	776080e7          	jalr	1910(ra) # 800044d2 <create>
      argint(2, &minor) < 0 ||
    80004d64:	c919                	beqz	a0,80004d7a <sys_mknod+0x76>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d66:	ffffe097          	auipc	ra,0xffffe
    80004d6a:	09c080e7          	jalr	156(ra) # 80002e02 <iunlockput>
  end_op();
    80004d6e:	fffff097          	auipc	ra,0xfffff
    80004d72:	884080e7          	jalr	-1916(ra) # 800035f2 <end_op>
  return 0;
    80004d76:	4501                	li	a0,0
    80004d78:	a031                	j	80004d84 <sys_mknod+0x80>
    end_op();
    80004d7a:	fffff097          	auipc	ra,0xfffff
    80004d7e:	878080e7          	jalr	-1928(ra) # 800035f2 <end_op>
    return -1;
    80004d82:	557d                	li	a0,-1
}
    80004d84:	60ea                	ld	ra,152(sp)
    80004d86:	644a                	ld	s0,144(sp)
    80004d88:	610d                	addi	sp,sp,160
    80004d8a:	8082                	ret

0000000080004d8c <sys_chdir>:

uint64
sys_chdir(void)
{
    80004d8c:	7135                	addi	sp,sp,-160
    80004d8e:	ed06                	sd	ra,152(sp)
    80004d90:	e922                	sd	s0,144(sp)
    80004d92:	e526                	sd	s1,136(sp)
    80004d94:	e14a                	sd	s2,128(sp)
    80004d96:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004d98:	ffffc097          	auipc	ra,0xffffc
    80004d9c:	0b0080e7          	jalr	176(ra) # 80000e48 <myproc>
    80004da0:	892a                	mv	s2,a0

  begin_op();
    80004da2:	ffffe097          	auipc	ra,0xffffe
    80004da6:	7d0080e7          	jalr	2000(ra) # 80003572 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0)
    80004daa:	08000613          	li	a2,128
    80004dae:	f6040593          	addi	a1,s0,-160
    80004db2:	4501                	li	a0,0
    80004db4:	ffffd097          	auipc	ra,0xffffd
    80004db8:	20a080e7          	jalr	522(ra) # 80001fbe <argstr>
    80004dbc:	04054b63          	bltz	a0,80004e12 <sys_chdir+0x86>
    80004dc0:	f6040513          	addi	a0,s0,-160
    80004dc4:	ffffe097          	auipc	ra,0xffffe
    80004dc8:	592080e7          	jalr	1426(ra) # 80003356 <namei>
    80004dcc:	84aa                	mv	s1,a0
    80004dce:	c131                	beqz	a0,80004e12 <sys_chdir+0x86>
  {
    end_op();
    return -1;
  }
  ilock(ip);
    80004dd0:	ffffe097          	auipc	ra,0xffffe
    80004dd4:	dd0080e7          	jalr	-560(ra) # 80002ba0 <ilock>
  if (ip->type != T_DIR)
    80004dd8:	04449703          	lh	a4,68(s1)
    80004ddc:	4785                	li	a5,1
    80004dde:	04f71063          	bne	a4,a5,80004e1e <sys_chdir+0x92>
  {
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004de2:	8526                	mv	a0,s1
    80004de4:	ffffe097          	auipc	ra,0xffffe
    80004de8:	e7e080e7          	jalr	-386(ra) # 80002c62 <iunlock>
  iput(p->cwd);
    80004dec:	17893503          	ld	a0,376(s2)
    80004df0:	ffffe097          	auipc	ra,0xffffe
    80004df4:	f6a080e7          	jalr	-150(ra) # 80002d5a <iput>
  end_op();
    80004df8:	ffffe097          	auipc	ra,0xffffe
    80004dfc:	7fa080e7          	jalr	2042(ra) # 800035f2 <end_op>
  p->cwd = ip;
    80004e00:	16993c23          	sd	s1,376(s2)
  return 0;
    80004e04:	4501                	li	a0,0
}
    80004e06:	60ea                	ld	ra,152(sp)
    80004e08:	644a                	ld	s0,144(sp)
    80004e0a:	64aa                	ld	s1,136(sp)
    80004e0c:	690a                	ld	s2,128(sp)
    80004e0e:	610d                	addi	sp,sp,160
    80004e10:	8082                	ret
    end_op();
    80004e12:	ffffe097          	auipc	ra,0xffffe
    80004e16:	7e0080e7          	jalr	2016(ra) # 800035f2 <end_op>
    return -1;
    80004e1a:	557d                	li	a0,-1
    80004e1c:	b7ed                	j	80004e06 <sys_chdir+0x7a>
    iunlockput(ip);
    80004e1e:	8526                	mv	a0,s1
    80004e20:	ffffe097          	auipc	ra,0xffffe
    80004e24:	fe2080e7          	jalr	-30(ra) # 80002e02 <iunlockput>
    end_op();
    80004e28:	ffffe097          	auipc	ra,0xffffe
    80004e2c:	7ca080e7          	jalr	1994(ra) # 800035f2 <end_op>
    return -1;
    80004e30:	557d                	li	a0,-1
    80004e32:	bfd1                	j	80004e06 <sys_chdir+0x7a>

0000000080004e34 <sys_exec>:

uint64
sys_exec(void)
{
    80004e34:	7145                	addi	sp,sp,-464
    80004e36:	e786                	sd	ra,456(sp)
    80004e38:	e3a2                	sd	s0,448(sp)
    80004e3a:	ff26                	sd	s1,440(sp)
    80004e3c:	fb4a                	sd	s2,432(sp)
    80004e3e:	f74e                	sd	s3,424(sp)
    80004e40:	f352                	sd	s4,416(sp)
    80004e42:	ef56                	sd	s5,408(sp)
    80004e44:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if (argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0)
    80004e46:	08000613          	li	a2,128
    80004e4a:	f4040593          	addi	a1,s0,-192
    80004e4e:	4501                	li	a0,0
    80004e50:	ffffd097          	auipc	ra,0xffffd
    80004e54:	16e080e7          	jalr	366(ra) # 80001fbe <argstr>
  {
    return -1;
    80004e58:	597d                	li	s2,-1
  if (argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0)
    80004e5a:	0c054a63          	bltz	a0,80004f2e <sys_exec+0xfa>
    80004e5e:	e3840593          	addi	a1,s0,-456
    80004e62:	4505                	li	a0,1
    80004e64:	ffffd097          	auipc	ra,0xffffd
    80004e68:	138080e7          	jalr	312(ra) # 80001f9c <argaddr>
    80004e6c:	0c054163          	bltz	a0,80004f2e <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004e70:	10000613          	li	a2,256
    80004e74:	4581                	li	a1,0
    80004e76:	e4040513          	addi	a0,s0,-448
    80004e7a:	ffffb097          	auipc	ra,0xffffb
    80004e7e:	2fe080e7          	jalr	766(ra) # 80000178 <memset>
  for (i = 0;; i++)
  {
    if (i >= NELEM(argv))
    80004e82:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004e86:	89a6                	mv	s3,s1
    80004e88:	4901                	li	s2,0
    if (i >= NELEM(argv))
    80004e8a:	02000a13          	li	s4,32
    80004e8e:	00090a9b          	sext.w	s5,s2
    {
      goto bad;
    }
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0)
    80004e92:	00391513          	slli	a0,s2,0x3
    80004e96:	e3040593          	addi	a1,s0,-464
    80004e9a:	e3843783          	ld	a5,-456(s0)
    80004e9e:	953e                	add	a0,a0,a5
    80004ea0:	ffffd097          	auipc	ra,0xffffd
    80004ea4:	040080e7          	jalr	64(ra) # 80001ee0 <fetchaddr>
    80004ea8:	02054a63          	bltz	a0,80004edc <sys_exec+0xa8>
    {
      goto bad;
    }
    if (uarg == 0)
    80004eac:	e3043783          	ld	a5,-464(s0)
    80004eb0:	c3b9                	beqz	a5,80004ef6 <sys_exec+0xc2>
    {
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004eb2:	ffffb097          	auipc	ra,0xffffb
    80004eb6:	266080e7          	jalr	614(ra) # 80000118 <kalloc>
    80004eba:	85aa                	mv	a1,a0
    80004ebc:	00a9b023          	sd	a0,0(s3)
    if (argv[i] == 0)
    80004ec0:	cd11                	beqz	a0,80004edc <sys_exec+0xa8>
      goto bad;
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004ec2:	6605                	lui	a2,0x1
    80004ec4:	e3043503          	ld	a0,-464(s0)
    80004ec8:	ffffd097          	auipc	ra,0xffffd
    80004ecc:	06a080e7          	jalr	106(ra) # 80001f32 <fetchstr>
    80004ed0:	00054663          	bltz	a0,80004edc <sys_exec+0xa8>
    if (i >= NELEM(argv))
    80004ed4:	0905                	addi	s2,s2,1
    80004ed6:	09a1                	addi	s3,s3,8
    80004ed8:	fb491be3          	bne	s2,s4,80004e8e <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

bad:
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004edc:	10048913          	addi	s2,s1,256
    80004ee0:	6088                	ld	a0,0(s1)
    80004ee2:	c529                	beqz	a0,80004f2c <sys_exec+0xf8>
    kfree(argv[i]);
    80004ee4:	ffffb097          	auipc	ra,0xffffb
    80004ee8:	138080e7          	jalr	312(ra) # 8000001c <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004eec:	04a1                	addi	s1,s1,8
    80004eee:	ff2499e3          	bne	s1,s2,80004ee0 <sys_exec+0xac>
  return -1;
    80004ef2:	597d                	li	s2,-1
    80004ef4:	a82d                	j	80004f2e <sys_exec+0xfa>
      argv[i] = 0;
    80004ef6:	0a8e                	slli	s5,s5,0x3
    80004ef8:	fc040793          	addi	a5,s0,-64
    80004efc:	9abe                	add	s5,s5,a5
    80004efe:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004f02:	e4040593          	addi	a1,s0,-448
    80004f06:	f4040513          	addi	a0,s0,-192
    80004f0a:	fffff097          	auipc	ra,0xfffff
    80004f0e:	194080e7          	jalr	404(ra) # 8000409e <exec>
    80004f12:	892a                	mv	s2,a0
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f14:	10048993          	addi	s3,s1,256
    80004f18:	6088                	ld	a0,0(s1)
    80004f1a:	c911                	beqz	a0,80004f2e <sys_exec+0xfa>
    kfree(argv[i]);
    80004f1c:	ffffb097          	auipc	ra,0xffffb
    80004f20:	100080e7          	jalr	256(ra) # 8000001c <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f24:	04a1                	addi	s1,s1,8
    80004f26:	ff3499e3          	bne	s1,s3,80004f18 <sys_exec+0xe4>
    80004f2a:	a011                	j	80004f2e <sys_exec+0xfa>
  return -1;
    80004f2c:	597d                	li	s2,-1
}
    80004f2e:	854a                	mv	a0,s2
    80004f30:	60be                	ld	ra,456(sp)
    80004f32:	641e                	ld	s0,448(sp)
    80004f34:	74fa                	ld	s1,440(sp)
    80004f36:	795a                	ld	s2,432(sp)
    80004f38:	79ba                	ld	s3,424(sp)
    80004f3a:	7a1a                	ld	s4,416(sp)
    80004f3c:	6afa                	ld	s5,408(sp)
    80004f3e:	6179                	addi	sp,sp,464
    80004f40:	8082                	ret

0000000080004f42 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f42:	7139                	addi	sp,sp,-64
    80004f44:	fc06                	sd	ra,56(sp)
    80004f46:	f822                	sd	s0,48(sp)
    80004f48:	f426                	sd	s1,40(sp)
    80004f4a:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f4c:	ffffc097          	auipc	ra,0xffffc
    80004f50:	efc080e7          	jalr	-260(ra) # 80000e48 <myproc>
    80004f54:	84aa                	mv	s1,a0

  if (argaddr(0, &fdarray) < 0)
    80004f56:	fd840593          	addi	a1,s0,-40
    80004f5a:	4501                	li	a0,0
    80004f5c:	ffffd097          	auipc	ra,0xffffd
    80004f60:	040080e7          	jalr	64(ra) # 80001f9c <argaddr>
    return -1;
    80004f64:	57fd                	li	a5,-1
  if (argaddr(0, &fdarray) < 0)
    80004f66:	0e054063          	bltz	a0,80005046 <sys_pipe+0x104>
  if (pipealloc(&rf, &wf) < 0)
    80004f6a:	fc840593          	addi	a1,s0,-56
    80004f6e:	fd040513          	addi	a0,s0,-48
    80004f72:	fffff097          	auipc	ra,0xfffff
    80004f76:	dfc080e7          	jalr	-516(ra) # 80003d6e <pipealloc>
    return -1;
    80004f7a:	57fd                	li	a5,-1
  if (pipealloc(&rf, &wf) < 0)
    80004f7c:	0c054563          	bltz	a0,80005046 <sys_pipe+0x104>
  fd0 = -1;
    80004f80:	fcf42223          	sw	a5,-60(s0)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
    80004f84:	fd043503          	ld	a0,-48(s0)
    80004f88:	fffff097          	auipc	ra,0xfffff
    80004f8c:	508080e7          	jalr	1288(ra) # 80004490 <fdalloc>
    80004f90:	fca42223          	sw	a0,-60(s0)
    80004f94:	08054c63          	bltz	a0,8000502c <sys_pipe+0xea>
    80004f98:	fc843503          	ld	a0,-56(s0)
    80004f9c:	fffff097          	auipc	ra,0xfffff
    80004fa0:	4f4080e7          	jalr	1268(ra) # 80004490 <fdalloc>
    80004fa4:	fca42023          	sw	a0,-64(s0)
    80004fa8:	06054863          	bltz	a0,80005018 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80004fac:	4691                	li	a3,4
    80004fae:	fc440613          	addi	a2,s0,-60
    80004fb2:	fd843583          	ld	a1,-40(s0)
    80004fb6:	7ca8                	ld	a0,120(s1)
    80004fb8:	ffffc097          	auipc	ra,0xffffc
    80004fbc:	b52080e7          	jalr	-1198(ra) # 80000b0a <copyout>
    80004fc0:	02054063          	bltz	a0,80004fe0 <sys_pipe+0x9e>
      copyout(p->pagetable, fdarray + sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0)
    80004fc4:	4691                	li	a3,4
    80004fc6:	fc040613          	addi	a2,s0,-64
    80004fca:	fd843583          	ld	a1,-40(s0)
    80004fce:	0591                	addi	a1,a1,4
    80004fd0:	7ca8                	ld	a0,120(s1)
    80004fd2:	ffffc097          	auipc	ra,0xffffc
    80004fd6:	b38080e7          	jalr	-1224(ra) # 80000b0a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004fda:	4781                	li	a5,0
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80004fdc:	06055563          	bgez	a0,80005046 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80004fe0:	fc442783          	lw	a5,-60(s0)
    80004fe4:	07f9                	addi	a5,a5,30
    80004fe6:	078e                	slli	a5,a5,0x3
    80004fe8:	97a6                	add	a5,a5,s1
    80004fea:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80004fee:	fc042503          	lw	a0,-64(s0)
    80004ff2:	0579                	addi	a0,a0,30
    80004ff4:	050e                	slli	a0,a0,0x3
    80004ff6:	9526                	add	a0,a0,s1
    80004ff8:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    80004ffc:	fd043503          	ld	a0,-48(s0)
    80005000:	fffff097          	auipc	ra,0xfffff
    80005004:	a3e080e7          	jalr	-1474(ra) # 80003a3e <fileclose>
    fileclose(wf);
    80005008:	fc843503          	ld	a0,-56(s0)
    8000500c:	fffff097          	auipc	ra,0xfffff
    80005010:	a32080e7          	jalr	-1486(ra) # 80003a3e <fileclose>
    return -1;
    80005014:	57fd                	li	a5,-1
    80005016:	a805                	j	80005046 <sys_pipe+0x104>
    if (fd0 >= 0)
    80005018:	fc442783          	lw	a5,-60(s0)
    8000501c:	0007c863          	bltz	a5,8000502c <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005020:	01e78513          	addi	a0,a5,30
    80005024:	050e                	slli	a0,a0,0x3
    80005026:	9526                	add	a0,a0,s1
    80005028:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    8000502c:	fd043503          	ld	a0,-48(s0)
    80005030:	fffff097          	auipc	ra,0xfffff
    80005034:	a0e080e7          	jalr	-1522(ra) # 80003a3e <fileclose>
    fileclose(wf);
    80005038:	fc843503          	ld	a0,-56(s0)
    8000503c:	fffff097          	auipc	ra,0xfffff
    80005040:	a02080e7          	jalr	-1534(ra) # 80003a3e <fileclose>
    return -1;
    80005044:	57fd                	li	a5,-1
}
    80005046:	853e                	mv	a0,a5
    80005048:	70e2                	ld	ra,56(sp)
    8000504a:	7442                	ld	s0,48(sp)
    8000504c:	74a2                	ld	s1,40(sp)
    8000504e:	6121                	addi	sp,sp,64
    80005050:	8082                	ret
	...

0000000080005060 <kernelvec>:
    80005060:	7111                	addi	sp,sp,-256
    80005062:	e006                	sd	ra,0(sp)
    80005064:	e40a                	sd	sp,8(sp)
    80005066:	e80e                	sd	gp,16(sp)
    80005068:	ec12                	sd	tp,24(sp)
    8000506a:	f016                	sd	t0,32(sp)
    8000506c:	f41a                	sd	t1,40(sp)
    8000506e:	f81e                	sd	t2,48(sp)
    80005070:	fc22                	sd	s0,56(sp)
    80005072:	e0a6                	sd	s1,64(sp)
    80005074:	e4aa                	sd	a0,72(sp)
    80005076:	e8ae                	sd	a1,80(sp)
    80005078:	ecb2                	sd	a2,88(sp)
    8000507a:	f0b6                	sd	a3,96(sp)
    8000507c:	f4ba                	sd	a4,104(sp)
    8000507e:	f8be                	sd	a5,112(sp)
    80005080:	fcc2                	sd	a6,120(sp)
    80005082:	e146                	sd	a7,128(sp)
    80005084:	e54a                	sd	s2,136(sp)
    80005086:	e94e                	sd	s3,144(sp)
    80005088:	ed52                	sd	s4,152(sp)
    8000508a:	f156                	sd	s5,160(sp)
    8000508c:	f55a                	sd	s6,168(sp)
    8000508e:	f95e                	sd	s7,176(sp)
    80005090:	fd62                	sd	s8,184(sp)
    80005092:	e1e6                	sd	s9,192(sp)
    80005094:	e5ea                	sd	s10,200(sp)
    80005096:	e9ee                	sd	s11,208(sp)
    80005098:	edf2                	sd	t3,216(sp)
    8000509a:	f1f6                	sd	t4,224(sp)
    8000509c:	f5fa                	sd	t5,232(sp)
    8000509e:	f9fe                	sd	t6,240(sp)
    800050a0:	d0dfc0ef          	jal	ra,80001dac <kerneltrap>
    800050a4:	6082                	ld	ra,0(sp)
    800050a6:	6122                	ld	sp,8(sp)
    800050a8:	61c2                	ld	gp,16(sp)
    800050aa:	7282                	ld	t0,32(sp)
    800050ac:	7322                	ld	t1,40(sp)
    800050ae:	73c2                	ld	t2,48(sp)
    800050b0:	7462                	ld	s0,56(sp)
    800050b2:	6486                	ld	s1,64(sp)
    800050b4:	6526                	ld	a0,72(sp)
    800050b6:	65c6                	ld	a1,80(sp)
    800050b8:	6666                	ld	a2,88(sp)
    800050ba:	7686                	ld	a3,96(sp)
    800050bc:	7726                	ld	a4,104(sp)
    800050be:	77c6                	ld	a5,112(sp)
    800050c0:	7866                	ld	a6,120(sp)
    800050c2:	688a                	ld	a7,128(sp)
    800050c4:	692a                	ld	s2,136(sp)
    800050c6:	69ca                	ld	s3,144(sp)
    800050c8:	6a6a                	ld	s4,152(sp)
    800050ca:	7a8a                	ld	s5,160(sp)
    800050cc:	7b2a                	ld	s6,168(sp)
    800050ce:	7bca                	ld	s7,176(sp)
    800050d0:	7c6a                	ld	s8,184(sp)
    800050d2:	6c8e                	ld	s9,192(sp)
    800050d4:	6d2e                	ld	s10,200(sp)
    800050d6:	6dce                	ld	s11,208(sp)
    800050d8:	6e6e                	ld	t3,216(sp)
    800050da:	7e8e                	ld	t4,224(sp)
    800050dc:	7f2e                	ld	t5,232(sp)
    800050de:	7fce                	ld	t6,240(sp)
    800050e0:	6111                	addi	sp,sp,256
    800050e2:	10200073          	sret
    800050e6:	00000013          	nop
    800050ea:	00000013          	nop
    800050ee:	0001                	nop

00000000800050f0 <timervec>:
    800050f0:	34051573          	csrrw	a0,mscratch,a0
    800050f4:	e10c                	sd	a1,0(a0)
    800050f6:	e510                	sd	a2,8(a0)
    800050f8:	e914                	sd	a3,16(a0)
    800050fa:	6d0c                	ld	a1,24(a0)
    800050fc:	7110                	ld	a2,32(a0)
    800050fe:	6194                	ld	a3,0(a1)
    80005100:	96b2                	add	a3,a3,a2
    80005102:	e194                	sd	a3,0(a1)
    80005104:	4589                	li	a1,2
    80005106:	14459073          	csrw	sip,a1
    8000510a:	6914                	ld	a3,16(a0)
    8000510c:	6510                	ld	a2,8(a0)
    8000510e:	610c                	ld	a1,0(a0)
    80005110:	34051573          	csrrw	a0,mscratch,a0
    80005114:	30200073          	mret
	...

000000008000511a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000511a:	1141                	addi	sp,sp,-16
    8000511c:	e422                	sd	s0,8(sp)
    8000511e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005120:	0c0007b7          	lui	a5,0xc000
    80005124:	4705                	li	a4,1
    80005126:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005128:	c3d8                	sw	a4,4(a5)
}
    8000512a:	6422                	ld	s0,8(sp)
    8000512c:	0141                	addi	sp,sp,16
    8000512e:	8082                	ret

0000000080005130 <plicinithart>:

void
plicinithart(void)
{
    80005130:	1141                	addi	sp,sp,-16
    80005132:	e406                	sd	ra,8(sp)
    80005134:	e022                	sd	s0,0(sp)
    80005136:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005138:	ffffc097          	auipc	ra,0xffffc
    8000513c:	ce4080e7          	jalr	-796(ra) # 80000e1c <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005140:	0085171b          	slliw	a4,a0,0x8
    80005144:	0c0027b7          	lui	a5,0xc002
    80005148:	97ba                	add	a5,a5,a4
    8000514a:	40200713          	li	a4,1026
    8000514e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005152:	00d5151b          	slliw	a0,a0,0xd
    80005156:	0c2017b7          	lui	a5,0xc201
    8000515a:	953e                	add	a0,a0,a5
    8000515c:	00052023          	sw	zero,0(a0)
}
    80005160:	60a2                	ld	ra,8(sp)
    80005162:	6402                	ld	s0,0(sp)
    80005164:	0141                	addi	sp,sp,16
    80005166:	8082                	ret

0000000080005168 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005168:	1141                	addi	sp,sp,-16
    8000516a:	e406                	sd	ra,8(sp)
    8000516c:	e022                	sd	s0,0(sp)
    8000516e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005170:	ffffc097          	auipc	ra,0xffffc
    80005174:	cac080e7          	jalr	-852(ra) # 80000e1c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005178:	00d5179b          	slliw	a5,a0,0xd
    8000517c:	0c201537          	lui	a0,0xc201
    80005180:	953e                	add	a0,a0,a5
  return irq;
}
    80005182:	4148                	lw	a0,4(a0)
    80005184:	60a2                	ld	ra,8(sp)
    80005186:	6402                	ld	s0,0(sp)
    80005188:	0141                	addi	sp,sp,16
    8000518a:	8082                	ret

000000008000518c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000518c:	1101                	addi	sp,sp,-32
    8000518e:	ec06                	sd	ra,24(sp)
    80005190:	e822                	sd	s0,16(sp)
    80005192:	e426                	sd	s1,8(sp)
    80005194:	1000                	addi	s0,sp,32
    80005196:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005198:	ffffc097          	auipc	ra,0xffffc
    8000519c:	c84080e7          	jalr	-892(ra) # 80000e1c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800051a0:	00d5151b          	slliw	a0,a0,0xd
    800051a4:	0c2017b7          	lui	a5,0xc201
    800051a8:	97aa                	add	a5,a5,a0
    800051aa:	c3c4                	sw	s1,4(a5)
}
    800051ac:	60e2                	ld	ra,24(sp)
    800051ae:	6442                	ld	s0,16(sp)
    800051b0:	64a2                	ld	s1,8(sp)
    800051b2:	6105                	addi	sp,sp,32
    800051b4:	8082                	ret

00000000800051b6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800051b6:	1141                	addi	sp,sp,-16
    800051b8:	e406                	sd	ra,8(sp)
    800051ba:	e022                	sd	s0,0(sp)
    800051bc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800051be:	479d                	li	a5,7
    800051c0:	06a7c963          	blt	a5,a0,80005232 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    800051c4:	00016797          	auipc	a5,0x16
    800051c8:	e3c78793          	addi	a5,a5,-452 # 8001b000 <disk>
    800051cc:	00a78733          	add	a4,a5,a0
    800051d0:	6789                	lui	a5,0x2
    800051d2:	97ba                	add	a5,a5,a4
    800051d4:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800051d8:	e7ad                	bnez	a5,80005242 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800051da:	00451793          	slli	a5,a0,0x4
    800051de:	00018717          	auipc	a4,0x18
    800051e2:	e2270713          	addi	a4,a4,-478 # 8001d000 <disk+0x2000>
    800051e6:	6314                	ld	a3,0(a4)
    800051e8:	96be                	add	a3,a3,a5
    800051ea:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800051ee:	6314                	ld	a3,0(a4)
    800051f0:	96be                	add	a3,a3,a5
    800051f2:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800051f6:	6314                	ld	a3,0(a4)
    800051f8:	96be                	add	a3,a3,a5
    800051fa:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800051fe:	6318                	ld	a4,0(a4)
    80005200:	97ba                	add	a5,a5,a4
    80005202:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005206:	00016797          	auipc	a5,0x16
    8000520a:	dfa78793          	addi	a5,a5,-518 # 8001b000 <disk>
    8000520e:	97aa                	add	a5,a5,a0
    80005210:	6509                	lui	a0,0x2
    80005212:	953e                	add	a0,a0,a5
    80005214:	4785                	li	a5,1
    80005216:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000521a:	00018517          	auipc	a0,0x18
    8000521e:	dfe50513          	addi	a0,a0,-514 # 8001d018 <disk+0x2018>
    80005222:	ffffc097          	auipc	ra,0xffffc
    80005226:	4aa080e7          	jalr	1194(ra) # 800016cc <wakeup>
}
    8000522a:	60a2                	ld	ra,8(sp)
    8000522c:	6402                	ld	s0,0(sp)
    8000522e:	0141                	addi	sp,sp,16
    80005230:	8082                	ret
    panic("free_desc 1");
    80005232:	00003517          	auipc	a0,0x3
    80005236:	4c650513          	addi	a0,a0,1222 # 800086f8 <syscalls+0x330>
    8000523a:	00001097          	auipc	ra,0x1
    8000523e:	a1e080e7          	jalr	-1506(ra) # 80005c58 <panic>
    panic("free_desc 2");
    80005242:	00003517          	auipc	a0,0x3
    80005246:	4c650513          	addi	a0,a0,1222 # 80008708 <syscalls+0x340>
    8000524a:	00001097          	auipc	ra,0x1
    8000524e:	a0e080e7          	jalr	-1522(ra) # 80005c58 <panic>

0000000080005252 <virtio_disk_init>:
{
    80005252:	1101                	addi	sp,sp,-32
    80005254:	ec06                	sd	ra,24(sp)
    80005256:	e822                	sd	s0,16(sp)
    80005258:	e426                	sd	s1,8(sp)
    8000525a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000525c:	00003597          	auipc	a1,0x3
    80005260:	4bc58593          	addi	a1,a1,1212 # 80008718 <syscalls+0x350>
    80005264:	00018517          	auipc	a0,0x18
    80005268:	ec450513          	addi	a0,a0,-316 # 8001d128 <disk+0x2128>
    8000526c:	00001097          	auipc	ra,0x1
    80005270:	efc080e7          	jalr	-260(ra) # 80006168 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005274:	100017b7          	lui	a5,0x10001
    80005278:	4398                	lw	a4,0(a5)
    8000527a:	2701                	sext.w	a4,a4
    8000527c:	747277b7          	lui	a5,0x74727
    80005280:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005284:	0ef71163          	bne	a4,a5,80005366 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005288:	100017b7          	lui	a5,0x10001
    8000528c:	43dc                	lw	a5,4(a5)
    8000528e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005290:	4705                	li	a4,1
    80005292:	0ce79a63          	bne	a5,a4,80005366 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005296:	100017b7          	lui	a5,0x10001
    8000529a:	479c                	lw	a5,8(a5)
    8000529c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000529e:	4709                	li	a4,2
    800052a0:	0ce79363          	bne	a5,a4,80005366 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800052a4:	100017b7          	lui	a5,0x10001
    800052a8:	47d8                	lw	a4,12(a5)
    800052aa:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052ac:	554d47b7          	lui	a5,0x554d4
    800052b0:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800052b4:	0af71963          	bne	a4,a5,80005366 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052b8:	100017b7          	lui	a5,0x10001
    800052bc:	4705                	li	a4,1
    800052be:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052c0:	470d                	li	a4,3
    800052c2:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800052c4:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800052c6:	c7ffe737          	lui	a4,0xc7ffe
    800052ca:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    800052ce:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800052d0:	2701                	sext.w	a4,a4
    800052d2:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052d4:	472d                	li	a4,11
    800052d6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052d8:	473d                	li	a4,15
    800052da:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800052dc:	6705                	lui	a4,0x1
    800052de:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800052e0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800052e4:	5bdc                	lw	a5,52(a5)
    800052e6:	2781                	sext.w	a5,a5
  if(max == 0)
    800052e8:	c7d9                	beqz	a5,80005376 <virtio_disk_init+0x124>
  if(max < NUM)
    800052ea:	471d                	li	a4,7
    800052ec:	08f77d63          	bgeu	a4,a5,80005386 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800052f0:	100014b7          	lui	s1,0x10001
    800052f4:	47a1                	li	a5,8
    800052f6:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800052f8:	6609                	lui	a2,0x2
    800052fa:	4581                	li	a1,0
    800052fc:	00016517          	auipc	a0,0x16
    80005300:	d0450513          	addi	a0,a0,-764 # 8001b000 <disk>
    80005304:	ffffb097          	auipc	ra,0xffffb
    80005308:	e74080e7          	jalr	-396(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000530c:	00016717          	auipc	a4,0x16
    80005310:	cf470713          	addi	a4,a4,-780 # 8001b000 <disk>
    80005314:	00c75793          	srli	a5,a4,0xc
    80005318:	2781                	sext.w	a5,a5
    8000531a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000531c:	00018797          	auipc	a5,0x18
    80005320:	ce478793          	addi	a5,a5,-796 # 8001d000 <disk+0x2000>
    80005324:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005326:	00016717          	auipc	a4,0x16
    8000532a:	d5a70713          	addi	a4,a4,-678 # 8001b080 <disk+0x80>
    8000532e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005330:	00017717          	auipc	a4,0x17
    80005334:	cd070713          	addi	a4,a4,-816 # 8001c000 <disk+0x1000>
    80005338:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000533a:	4705                	li	a4,1
    8000533c:	00e78c23          	sb	a4,24(a5)
    80005340:	00e78ca3          	sb	a4,25(a5)
    80005344:	00e78d23          	sb	a4,26(a5)
    80005348:	00e78da3          	sb	a4,27(a5)
    8000534c:	00e78e23          	sb	a4,28(a5)
    80005350:	00e78ea3          	sb	a4,29(a5)
    80005354:	00e78f23          	sb	a4,30(a5)
    80005358:	00e78fa3          	sb	a4,31(a5)
}
    8000535c:	60e2                	ld	ra,24(sp)
    8000535e:	6442                	ld	s0,16(sp)
    80005360:	64a2                	ld	s1,8(sp)
    80005362:	6105                	addi	sp,sp,32
    80005364:	8082                	ret
    panic("could not find virtio disk");
    80005366:	00003517          	auipc	a0,0x3
    8000536a:	3c250513          	addi	a0,a0,962 # 80008728 <syscalls+0x360>
    8000536e:	00001097          	auipc	ra,0x1
    80005372:	8ea080e7          	jalr	-1814(ra) # 80005c58 <panic>
    panic("virtio disk has no queue 0");
    80005376:	00003517          	auipc	a0,0x3
    8000537a:	3d250513          	addi	a0,a0,978 # 80008748 <syscalls+0x380>
    8000537e:	00001097          	auipc	ra,0x1
    80005382:	8da080e7          	jalr	-1830(ra) # 80005c58 <panic>
    panic("virtio disk max queue too short");
    80005386:	00003517          	auipc	a0,0x3
    8000538a:	3e250513          	addi	a0,a0,994 # 80008768 <syscalls+0x3a0>
    8000538e:	00001097          	auipc	ra,0x1
    80005392:	8ca080e7          	jalr	-1846(ra) # 80005c58 <panic>

0000000080005396 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005396:	7159                	addi	sp,sp,-112
    80005398:	f486                	sd	ra,104(sp)
    8000539a:	f0a2                	sd	s0,96(sp)
    8000539c:	eca6                	sd	s1,88(sp)
    8000539e:	e8ca                	sd	s2,80(sp)
    800053a0:	e4ce                	sd	s3,72(sp)
    800053a2:	e0d2                	sd	s4,64(sp)
    800053a4:	fc56                	sd	s5,56(sp)
    800053a6:	f85a                	sd	s6,48(sp)
    800053a8:	f45e                	sd	s7,40(sp)
    800053aa:	f062                	sd	s8,32(sp)
    800053ac:	ec66                	sd	s9,24(sp)
    800053ae:	e86a                	sd	s10,16(sp)
    800053b0:	1880                	addi	s0,sp,112
    800053b2:	892a                	mv	s2,a0
    800053b4:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800053b6:	00c52c83          	lw	s9,12(a0)
    800053ba:	001c9c9b          	slliw	s9,s9,0x1
    800053be:	1c82                	slli	s9,s9,0x20
    800053c0:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800053c4:	00018517          	auipc	a0,0x18
    800053c8:	d6450513          	addi	a0,a0,-668 # 8001d128 <disk+0x2128>
    800053cc:	00001097          	auipc	ra,0x1
    800053d0:	e2c080e7          	jalr	-468(ra) # 800061f8 <acquire>
  for(int i = 0; i < 3; i++){
    800053d4:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800053d6:	4c21                	li	s8,8
      disk.free[i] = 0;
    800053d8:	00016b97          	auipc	s7,0x16
    800053dc:	c28b8b93          	addi	s7,s7,-984 # 8001b000 <disk>
    800053e0:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    800053e2:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    800053e4:	8a4e                	mv	s4,s3
    800053e6:	a051                	j	8000546a <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    800053e8:	00fb86b3          	add	a3,s7,a5
    800053ec:	96da                	add	a3,a3,s6
    800053ee:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    800053f2:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800053f4:	0207c563          	bltz	a5,8000541e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800053f8:	2485                	addiw	s1,s1,1
    800053fa:	0711                	addi	a4,a4,4
    800053fc:	25548063          	beq	s1,s5,8000563c <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    80005400:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005402:	00018697          	auipc	a3,0x18
    80005406:	c1668693          	addi	a3,a3,-1002 # 8001d018 <disk+0x2018>
    8000540a:	87d2                	mv	a5,s4
    if(disk.free[i]){
    8000540c:	0006c583          	lbu	a1,0(a3)
    80005410:	fde1                	bnez	a1,800053e8 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005412:	2785                	addiw	a5,a5,1
    80005414:	0685                	addi	a3,a3,1
    80005416:	ff879be3          	bne	a5,s8,8000540c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000541a:	57fd                	li	a5,-1
    8000541c:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    8000541e:	02905a63          	blez	s1,80005452 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005422:	f9042503          	lw	a0,-112(s0)
    80005426:	00000097          	auipc	ra,0x0
    8000542a:	d90080e7          	jalr	-624(ra) # 800051b6 <free_desc>
      for(int j = 0; j < i; j++)
    8000542e:	4785                	li	a5,1
    80005430:	0297d163          	bge	a5,s1,80005452 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005434:	f9442503          	lw	a0,-108(s0)
    80005438:	00000097          	auipc	ra,0x0
    8000543c:	d7e080e7          	jalr	-642(ra) # 800051b6 <free_desc>
      for(int j = 0; j < i; j++)
    80005440:	4789                	li	a5,2
    80005442:	0097d863          	bge	a5,s1,80005452 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005446:	f9842503          	lw	a0,-104(s0)
    8000544a:	00000097          	auipc	ra,0x0
    8000544e:	d6c080e7          	jalr	-660(ra) # 800051b6 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005452:	00018597          	auipc	a1,0x18
    80005456:	cd658593          	addi	a1,a1,-810 # 8001d128 <disk+0x2128>
    8000545a:	00018517          	auipc	a0,0x18
    8000545e:	bbe50513          	addi	a0,a0,-1090 # 8001d018 <disk+0x2018>
    80005462:	ffffc097          	auipc	ra,0xffffc
    80005466:	0de080e7          	jalr	222(ra) # 80001540 <sleep>
  for(int i = 0; i < 3; i++){
    8000546a:	f9040713          	addi	a4,s0,-112
    8000546e:	84ce                	mv	s1,s3
    80005470:	bf41                	j	80005400 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005472:	20058713          	addi	a4,a1,512
    80005476:	00471693          	slli	a3,a4,0x4
    8000547a:	00016717          	auipc	a4,0x16
    8000547e:	b8670713          	addi	a4,a4,-1146 # 8001b000 <disk>
    80005482:	9736                	add	a4,a4,a3
    80005484:	4685                	li	a3,1
    80005486:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000548a:	20058713          	addi	a4,a1,512
    8000548e:	00471693          	slli	a3,a4,0x4
    80005492:	00016717          	auipc	a4,0x16
    80005496:	b6e70713          	addi	a4,a4,-1170 # 8001b000 <disk>
    8000549a:	9736                	add	a4,a4,a3
    8000549c:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800054a0:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800054a4:	7679                	lui	a2,0xffffe
    800054a6:	963e                	add	a2,a2,a5
    800054a8:	00018697          	auipc	a3,0x18
    800054ac:	b5868693          	addi	a3,a3,-1192 # 8001d000 <disk+0x2000>
    800054b0:	6298                	ld	a4,0(a3)
    800054b2:	9732                	add	a4,a4,a2
    800054b4:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800054b6:	6298                	ld	a4,0(a3)
    800054b8:	9732                	add	a4,a4,a2
    800054ba:	4541                	li	a0,16
    800054bc:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800054be:	6298                	ld	a4,0(a3)
    800054c0:	9732                	add	a4,a4,a2
    800054c2:	4505                	li	a0,1
    800054c4:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800054c8:	f9442703          	lw	a4,-108(s0)
    800054cc:	6288                	ld	a0,0(a3)
    800054ce:	962a                	add	a2,a2,a0
    800054d0:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    800054d4:	0712                	slli	a4,a4,0x4
    800054d6:	6290                	ld	a2,0(a3)
    800054d8:	963a                	add	a2,a2,a4
    800054da:	05890513          	addi	a0,s2,88
    800054de:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800054e0:	6294                	ld	a3,0(a3)
    800054e2:	96ba                	add	a3,a3,a4
    800054e4:	40000613          	li	a2,1024
    800054e8:	c690                	sw	a2,8(a3)
  if(write)
    800054ea:	140d0063          	beqz	s10,8000562a <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800054ee:	00018697          	auipc	a3,0x18
    800054f2:	b126b683          	ld	a3,-1262(a3) # 8001d000 <disk+0x2000>
    800054f6:	96ba                	add	a3,a3,a4
    800054f8:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800054fc:	00016817          	auipc	a6,0x16
    80005500:	b0480813          	addi	a6,a6,-1276 # 8001b000 <disk>
    80005504:	00018517          	auipc	a0,0x18
    80005508:	afc50513          	addi	a0,a0,-1284 # 8001d000 <disk+0x2000>
    8000550c:	6114                	ld	a3,0(a0)
    8000550e:	96ba                	add	a3,a3,a4
    80005510:	00c6d603          	lhu	a2,12(a3)
    80005514:	00166613          	ori	a2,a2,1
    80005518:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000551c:	f9842683          	lw	a3,-104(s0)
    80005520:	6110                	ld	a2,0(a0)
    80005522:	9732                	add	a4,a4,a2
    80005524:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005528:	20058613          	addi	a2,a1,512
    8000552c:	0612                	slli	a2,a2,0x4
    8000552e:	9642                	add	a2,a2,a6
    80005530:	577d                	li	a4,-1
    80005532:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005536:	00469713          	slli	a4,a3,0x4
    8000553a:	6114                	ld	a3,0(a0)
    8000553c:	96ba                	add	a3,a3,a4
    8000553e:	03078793          	addi	a5,a5,48
    80005542:	97c2                	add	a5,a5,a6
    80005544:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005546:	611c                	ld	a5,0(a0)
    80005548:	97ba                	add	a5,a5,a4
    8000554a:	4685                	li	a3,1
    8000554c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000554e:	611c                	ld	a5,0(a0)
    80005550:	97ba                	add	a5,a5,a4
    80005552:	4809                	li	a6,2
    80005554:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005558:	611c                	ld	a5,0(a0)
    8000555a:	973e                	add	a4,a4,a5
    8000555c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005560:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80005564:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005568:	6518                	ld	a4,8(a0)
    8000556a:	00275783          	lhu	a5,2(a4)
    8000556e:	8b9d                	andi	a5,a5,7
    80005570:	0786                	slli	a5,a5,0x1
    80005572:	97ba                	add	a5,a5,a4
    80005574:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005578:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000557c:	6518                	ld	a4,8(a0)
    8000557e:	00275783          	lhu	a5,2(a4)
    80005582:	2785                	addiw	a5,a5,1
    80005584:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005588:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000558c:	100017b7          	lui	a5,0x10001
    80005590:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005594:	00492703          	lw	a4,4(s2)
    80005598:	4785                	li	a5,1
    8000559a:	02f71163          	bne	a4,a5,800055bc <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    8000559e:	00018997          	auipc	s3,0x18
    800055a2:	b8a98993          	addi	s3,s3,-1142 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    800055a6:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800055a8:	85ce                	mv	a1,s3
    800055aa:	854a                	mv	a0,s2
    800055ac:	ffffc097          	auipc	ra,0xffffc
    800055b0:	f94080e7          	jalr	-108(ra) # 80001540 <sleep>
  while(b->disk == 1) {
    800055b4:	00492783          	lw	a5,4(s2)
    800055b8:	fe9788e3          	beq	a5,s1,800055a8 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    800055bc:	f9042903          	lw	s2,-112(s0)
    800055c0:	20090793          	addi	a5,s2,512
    800055c4:	00479713          	slli	a4,a5,0x4
    800055c8:	00016797          	auipc	a5,0x16
    800055cc:	a3878793          	addi	a5,a5,-1480 # 8001b000 <disk>
    800055d0:	97ba                	add	a5,a5,a4
    800055d2:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800055d6:	00018997          	auipc	s3,0x18
    800055da:	a2a98993          	addi	s3,s3,-1494 # 8001d000 <disk+0x2000>
    800055de:	00491713          	slli	a4,s2,0x4
    800055e2:	0009b783          	ld	a5,0(s3)
    800055e6:	97ba                	add	a5,a5,a4
    800055e8:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800055ec:	854a                	mv	a0,s2
    800055ee:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800055f2:	00000097          	auipc	ra,0x0
    800055f6:	bc4080e7          	jalr	-1084(ra) # 800051b6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800055fa:	8885                	andi	s1,s1,1
    800055fc:	f0ed                	bnez	s1,800055de <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800055fe:	00018517          	auipc	a0,0x18
    80005602:	b2a50513          	addi	a0,a0,-1238 # 8001d128 <disk+0x2128>
    80005606:	00001097          	auipc	ra,0x1
    8000560a:	ca6080e7          	jalr	-858(ra) # 800062ac <release>
}
    8000560e:	70a6                	ld	ra,104(sp)
    80005610:	7406                	ld	s0,96(sp)
    80005612:	64e6                	ld	s1,88(sp)
    80005614:	6946                	ld	s2,80(sp)
    80005616:	69a6                	ld	s3,72(sp)
    80005618:	6a06                	ld	s4,64(sp)
    8000561a:	7ae2                	ld	s5,56(sp)
    8000561c:	7b42                	ld	s6,48(sp)
    8000561e:	7ba2                	ld	s7,40(sp)
    80005620:	7c02                	ld	s8,32(sp)
    80005622:	6ce2                	ld	s9,24(sp)
    80005624:	6d42                	ld	s10,16(sp)
    80005626:	6165                	addi	sp,sp,112
    80005628:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000562a:	00018697          	auipc	a3,0x18
    8000562e:	9d66b683          	ld	a3,-1578(a3) # 8001d000 <disk+0x2000>
    80005632:	96ba                	add	a3,a3,a4
    80005634:	4609                	li	a2,2
    80005636:	00c69623          	sh	a2,12(a3)
    8000563a:	b5c9                	j	800054fc <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000563c:	f9042583          	lw	a1,-112(s0)
    80005640:	20058793          	addi	a5,a1,512
    80005644:	0792                	slli	a5,a5,0x4
    80005646:	00016517          	auipc	a0,0x16
    8000564a:	a6250513          	addi	a0,a0,-1438 # 8001b0a8 <disk+0xa8>
    8000564e:	953e                	add	a0,a0,a5
  if(write)
    80005650:	e20d11e3          	bnez	s10,80005472 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005654:	20058713          	addi	a4,a1,512
    80005658:	00471693          	slli	a3,a4,0x4
    8000565c:	00016717          	auipc	a4,0x16
    80005660:	9a470713          	addi	a4,a4,-1628 # 8001b000 <disk>
    80005664:	9736                	add	a4,a4,a3
    80005666:	0a072423          	sw	zero,168(a4)
    8000566a:	b505                	j	8000548a <virtio_disk_rw+0xf4>

000000008000566c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000566c:	1101                	addi	sp,sp,-32
    8000566e:	ec06                	sd	ra,24(sp)
    80005670:	e822                	sd	s0,16(sp)
    80005672:	e426                	sd	s1,8(sp)
    80005674:	e04a                	sd	s2,0(sp)
    80005676:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005678:	00018517          	auipc	a0,0x18
    8000567c:	ab050513          	addi	a0,a0,-1360 # 8001d128 <disk+0x2128>
    80005680:	00001097          	auipc	ra,0x1
    80005684:	b78080e7          	jalr	-1160(ra) # 800061f8 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005688:	10001737          	lui	a4,0x10001
    8000568c:	533c                	lw	a5,96(a4)
    8000568e:	8b8d                	andi	a5,a5,3
    80005690:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005692:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005696:	00018797          	auipc	a5,0x18
    8000569a:	96a78793          	addi	a5,a5,-1686 # 8001d000 <disk+0x2000>
    8000569e:	6b94                	ld	a3,16(a5)
    800056a0:	0207d703          	lhu	a4,32(a5)
    800056a4:	0026d783          	lhu	a5,2(a3)
    800056a8:	06f70163          	beq	a4,a5,8000570a <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056ac:	00016917          	auipc	s2,0x16
    800056b0:	95490913          	addi	s2,s2,-1708 # 8001b000 <disk>
    800056b4:	00018497          	auipc	s1,0x18
    800056b8:	94c48493          	addi	s1,s1,-1716 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    800056bc:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056c0:	6898                	ld	a4,16(s1)
    800056c2:	0204d783          	lhu	a5,32(s1)
    800056c6:	8b9d                	andi	a5,a5,7
    800056c8:	078e                	slli	a5,a5,0x3
    800056ca:	97ba                	add	a5,a5,a4
    800056cc:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800056ce:	20078713          	addi	a4,a5,512
    800056d2:	0712                	slli	a4,a4,0x4
    800056d4:	974a                	add	a4,a4,s2
    800056d6:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800056da:	e731                	bnez	a4,80005726 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800056dc:	20078793          	addi	a5,a5,512
    800056e0:	0792                	slli	a5,a5,0x4
    800056e2:	97ca                	add	a5,a5,s2
    800056e4:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800056e6:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800056ea:	ffffc097          	auipc	ra,0xffffc
    800056ee:	fe2080e7          	jalr	-30(ra) # 800016cc <wakeup>

    disk.used_idx += 1;
    800056f2:	0204d783          	lhu	a5,32(s1)
    800056f6:	2785                	addiw	a5,a5,1
    800056f8:	17c2                	slli	a5,a5,0x30
    800056fa:	93c1                	srli	a5,a5,0x30
    800056fc:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005700:	6898                	ld	a4,16(s1)
    80005702:	00275703          	lhu	a4,2(a4)
    80005706:	faf71be3          	bne	a4,a5,800056bc <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000570a:	00018517          	auipc	a0,0x18
    8000570e:	a1e50513          	addi	a0,a0,-1506 # 8001d128 <disk+0x2128>
    80005712:	00001097          	auipc	ra,0x1
    80005716:	b9a080e7          	jalr	-1126(ra) # 800062ac <release>
}
    8000571a:	60e2                	ld	ra,24(sp)
    8000571c:	6442                	ld	s0,16(sp)
    8000571e:	64a2                	ld	s1,8(sp)
    80005720:	6902                	ld	s2,0(sp)
    80005722:	6105                	addi	sp,sp,32
    80005724:	8082                	ret
      panic("virtio_disk_intr status");
    80005726:	00003517          	auipc	a0,0x3
    8000572a:	06250513          	addi	a0,a0,98 # 80008788 <syscalls+0x3c0>
    8000572e:	00000097          	auipc	ra,0x0
    80005732:	52a080e7          	jalr	1322(ra) # 80005c58 <panic>

0000000080005736 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005736:	1141                	addi	sp,sp,-16
    80005738:	e422                	sd	s0,8(sp)
    8000573a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r"(x));
    8000573c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005740:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005744:	0037979b          	slliw	a5,a5,0x3
    80005748:	02004737          	lui	a4,0x2004
    8000574c:	97ba                	add	a5,a5,a4
    8000574e:	0200c737          	lui	a4,0x200c
    80005752:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005756:	000f4637          	lui	a2,0xf4
    8000575a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000575e:	95b2                	add	a1,a1,a2
    80005760:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005762:	00269713          	slli	a4,a3,0x2
    80005766:	9736                	add	a4,a4,a3
    80005768:	00371693          	slli	a3,a4,0x3
    8000576c:	00019717          	auipc	a4,0x19
    80005770:	89470713          	addi	a4,a4,-1900 # 8001e000 <timer_scratch>
    80005774:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005776:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005778:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r"(x));
    8000577a:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r"(x));
    8000577e:	00000797          	auipc	a5,0x0
    80005782:	97278793          	addi	a5,a5,-1678 # 800050f0 <timervec>
    80005786:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r"(x));
    8000578a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000578e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r"(x));
    80005792:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r"(x));
    80005796:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000579a:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r"(x));
    8000579e:	30479073          	csrw	mie,a5
}
    800057a2:	6422                	ld	s0,8(sp)
    800057a4:	0141                	addi	sp,sp,16
    800057a6:	8082                	ret

00000000800057a8 <start>:
{
    800057a8:	1141                	addi	sp,sp,-16
    800057aa:	e406                	sd	ra,8(sp)
    800057ac:	e022                	sd	s0,0(sp)
    800057ae:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r"(x));
    800057b0:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800057b4:	7779                	lui	a4,0xffffe
    800057b6:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    800057ba:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800057bc:	6705                	lui	a4,0x1
    800057be:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800057c2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r"(x));
    800057c4:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r"(x));
    800057c8:	ffffb797          	auipc	a5,0xffffb
    800057cc:	b5e78793          	addi	a5,a5,-1186 # 80000326 <main>
    800057d0:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r"(x));
    800057d4:	4781                	li	a5,0
    800057d6:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r"(x));
    800057da:	67c1                	lui	a5,0x10
    800057dc:	17fd                	addi	a5,a5,-1
    800057de:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r"(x));
    800057e2:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r"(x));
    800057e6:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800057ea:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r"(x));
    800057ee:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r"(x));
    800057f2:	57fd                	li	a5,-1
    800057f4:	83a9                	srli	a5,a5,0xa
    800057f6:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r"(x));
    800057fa:	47bd                	li	a5,15
    800057fc:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005800:	00000097          	auipc	ra,0x0
    80005804:	f36080e7          	jalr	-202(ra) # 80005736 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r"(x));
    80005808:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000580c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r"(x));
    8000580e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005810:	30200073          	mret
}
    80005814:	60a2                	ld	ra,8(sp)
    80005816:	6402                	ld	s0,0(sp)
    80005818:	0141                	addi	sp,sp,16
    8000581a:	8082                	ret

000000008000581c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000581c:	715d                	addi	sp,sp,-80
    8000581e:	e486                	sd	ra,72(sp)
    80005820:	e0a2                	sd	s0,64(sp)
    80005822:	fc26                	sd	s1,56(sp)
    80005824:	f84a                	sd	s2,48(sp)
    80005826:	f44e                	sd	s3,40(sp)
    80005828:	f052                	sd	s4,32(sp)
    8000582a:	ec56                	sd	s5,24(sp)
    8000582c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000582e:	04c05663          	blez	a2,8000587a <consolewrite+0x5e>
    80005832:	8a2a                	mv	s4,a0
    80005834:	84ae                	mv	s1,a1
    80005836:	89b2                	mv	s3,a2
    80005838:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000583a:	5afd                	li	s5,-1
    8000583c:	4685                	li	a3,1
    8000583e:	8626                	mv	a2,s1
    80005840:	85d2                	mv	a1,s4
    80005842:	fbf40513          	addi	a0,s0,-65
    80005846:	ffffc097          	auipc	ra,0xffffc
    8000584a:	0f4080e7          	jalr	244(ra) # 8000193a <either_copyin>
    8000584e:	01550c63          	beq	a0,s5,80005866 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005852:	fbf44503          	lbu	a0,-65(s0)
    80005856:	00000097          	auipc	ra,0x0
    8000585a:	7e4080e7          	jalr	2020(ra) # 8000603a <uartputc>
  for(i = 0; i < n; i++){
    8000585e:	2905                	addiw	s2,s2,1
    80005860:	0485                	addi	s1,s1,1
    80005862:	fd299de3          	bne	s3,s2,8000583c <consolewrite+0x20>
  }

  return i;
}
    80005866:	854a                	mv	a0,s2
    80005868:	60a6                	ld	ra,72(sp)
    8000586a:	6406                	ld	s0,64(sp)
    8000586c:	74e2                	ld	s1,56(sp)
    8000586e:	7942                	ld	s2,48(sp)
    80005870:	79a2                	ld	s3,40(sp)
    80005872:	7a02                	ld	s4,32(sp)
    80005874:	6ae2                	ld	s5,24(sp)
    80005876:	6161                	addi	sp,sp,80
    80005878:	8082                	ret
  for(i = 0; i < n; i++){
    8000587a:	4901                	li	s2,0
    8000587c:	b7ed                	j	80005866 <consolewrite+0x4a>

000000008000587e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000587e:	7119                	addi	sp,sp,-128
    80005880:	fc86                	sd	ra,120(sp)
    80005882:	f8a2                	sd	s0,112(sp)
    80005884:	f4a6                	sd	s1,104(sp)
    80005886:	f0ca                	sd	s2,96(sp)
    80005888:	ecce                	sd	s3,88(sp)
    8000588a:	e8d2                	sd	s4,80(sp)
    8000588c:	e4d6                	sd	s5,72(sp)
    8000588e:	e0da                	sd	s6,64(sp)
    80005890:	fc5e                	sd	s7,56(sp)
    80005892:	f862                	sd	s8,48(sp)
    80005894:	f466                	sd	s9,40(sp)
    80005896:	f06a                	sd	s10,32(sp)
    80005898:	ec6e                	sd	s11,24(sp)
    8000589a:	0100                	addi	s0,sp,128
    8000589c:	8b2a                	mv	s6,a0
    8000589e:	8aae                	mv	s5,a1
    800058a0:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800058a2:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    800058a6:	00021517          	auipc	a0,0x21
    800058aa:	89a50513          	addi	a0,a0,-1894 # 80026140 <cons>
    800058ae:	00001097          	auipc	ra,0x1
    800058b2:	94a080e7          	jalr	-1718(ra) # 800061f8 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800058b6:	00021497          	auipc	s1,0x21
    800058ba:	88a48493          	addi	s1,s1,-1910 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800058be:	89a6                	mv	s3,s1
    800058c0:	00021917          	auipc	s2,0x21
    800058c4:	91890913          	addi	s2,s2,-1768 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800058c8:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800058ca:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800058cc:	4da9                	li	s11,10
  while(n > 0){
    800058ce:	07405863          	blez	s4,8000593e <consoleread+0xc0>
    while(cons.r == cons.w){
    800058d2:	0984a783          	lw	a5,152(s1)
    800058d6:	09c4a703          	lw	a4,156(s1)
    800058da:	02f71463          	bne	a4,a5,80005902 <consoleread+0x84>
      if(myproc()->killed){
    800058de:	ffffb097          	auipc	ra,0xffffb
    800058e2:	56a080e7          	jalr	1386(ra) # 80000e48 <myproc>
    800058e6:	551c                	lw	a5,40(a0)
    800058e8:	e7b5                	bnez	a5,80005954 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    800058ea:	85ce                	mv	a1,s3
    800058ec:	854a                	mv	a0,s2
    800058ee:	ffffc097          	auipc	ra,0xffffc
    800058f2:	c52080e7          	jalr	-942(ra) # 80001540 <sleep>
    while(cons.r == cons.w){
    800058f6:	0984a783          	lw	a5,152(s1)
    800058fa:	09c4a703          	lw	a4,156(s1)
    800058fe:	fef700e3          	beq	a4,a5,800058de <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005902:	0017871b          	addiw	a4,a5,1
    80005906:	08e4ac23          	sw	a4,152(s1)
    8000590a:	07f7f713          	andi	a4,a5,127
    8000590e:	9726                	add	a4,a4,s1
    80005910:	01874703          	lbu	a4,24(a4)
    80005914:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005918:	079c0663          	beq	s8,s9,80005984 <consoleread+0x106>
    cbuf = c;
    8000591c:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005920:	4685                	li	a3,1
    80005922:	f8f40613          	addi	a2,s0,-113
    80005926:	85d6                	mv	a1,s5
    80005928:	855a                	mv	a0,s6
    8000592a:	ffffc097          	auipc	ra,0xffffc
    8000592e:	fba080e7          	jalr	-70(ra) # 800018e4 <either_copyout>
    80005932:	01a50663          	beq	a0,s10,8000593e <consoleread+0xc0>
    dst++;
    80005936:	0a85                	addi	s5,s5,1
    --n;
    80005938:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    8000593a:	f9bc1ae3          	bne	s8,s11,800058ce <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    8000593e:	00021517          	auipc	a0,0x21
    80005942:	80250513          	addi	a0,a0,-2046 # 80026140 <cons>
    80005946:	00001097          	auipc	ra,0x1
    8000594a:	966080e7          	jalr	-1690(ra) # 800062ac <release>

  return target - n;
    8000594e:	414b853b          	subw	a0,s7,s4
    80005952:	a811                	j	80005966 <consoleread+0xe8>
        release(&cons.lock);
    80005954:	00020517          	auipc	a0,0x20
    80005958:	7ec50513          	addi	a0,a0,2028 # 80026140 <cons>
    8000595c:	00001097          	auipc	ra,0x1
    80005960:	950080e7          	jalr	-1712(ra) # 800062ac <release>
        return -1;
    80005964:	557d                	li	a0,-1
}
    80005966:	70e6                	ld	ra,120(sp)
    80005968:	7446                	ld	s0,112(sp)
    8000596a:	74a6                	ld	s1,104(sp)
    8000596c:	7906                	ld	s2,96(sp)
    8000596e:	69e6                	ld	s3,88(sp)
    80005970:	6a46                	ld	s4,80(sp)
    80005972:	6aa6                	ld	s5,72(sp)
    80005974:	6b06                	ld	s6,64(sp)
    80005976:	7be2                	ld	s7,56(sp)
    80005978:	7c42                	ld	s8,48(sp)
    8000597a:	7ca2                	ld	s9,40(sp)
    8000597c:	7d02                	ld	s10,32(sp)
    8000597e:	6de2                	ld	s11,24(sp)
    80005980:	6109                	addi	sp,sp,128
    80005982:	8082                	ret
      if(n < target){
    80005984:	000a071b          	sext.w	a4,s4
    80005988:	fb777be3          	bgeu	a4,s7,8000593e <consoleread+0xc0>
        cons.r--;
    8000598c:	00021717          	auipc	a4,0x21
    80005990:	84f72623          	sw	a5,-1972(a4) # 800261d8 <cons+0x98>
    80005994:	b76d                	j	8000593e <consoleread+0xc0>

0000000080005996 <consputc>:
{
    80005996:	1141                	addi	sp,sp,-16
    80005998:	e406                	sd	ra,8(sp)
    8000599a:	e022                	sd	s0,0(sp)
    8000599c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000599e:	10000793          	li	a5,256
    800059a2:	00f50a63          	beq	a0,a5,800059b6 <consputc+0x20>
    uartputc_sync(c);
    800059a6:	00000097          	auipc	ra,0x0
    800059aa:	5ba080e7          	jalr	1466(ra) # 80005f60 <uartputc_sync>
}
    800059ae:	60a2                	ld	ra,8(sp)
    800059b0:	6402                	ld	s0,0(sp)
    800059b2:	0141                	addi	sp,sp,16
    800059b4:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800059b6:	4521                	li	a0,8
    800059b8:	00000097          	auipc	ra,0x0
    800059bc:	5a8080e7          	jalr	1448(ra) # 80005f60 <uartputc_sync>
    800059c0:	02000513          	li	a0,32
    800059c4:	00000097          	auipc	ra,0x0
    800059c8:	59c080e7          	jalr	1436(ra) # 80005f60 <uartputc_sync>
    800059cc:	4521                	li	a0,8
    800059ce:	00000097          	auipc	ra,0x0
    800059d2:	592080e7          	jalr	1426(ra) # 80005f60 <uartputc_sync>
    800059d6:	bfe1                	j	800059ae <consputc+0x18>

00000000800059d8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800059d8:	1101                	addi	sp,sp,-32
    800059da:	ec06                	sd	ra,24(sp)
    800059dc:	e822                	sd	s0,16(sp)
    800059de:	e426                	sd	s1,8(sp)
    800059e0:	e04a                	sd	s2,0(sp)
    800059e2:	1000                	addi	s0,sp,32
    800059e4:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800059e6:	00020517          	auipc	a0,0x20
    800059ea:	75a50513          	addi	a0,a0,1882 # 80026140 <cons>
    800059ee:	00001097          	auipc	ra,0x1
    800059f2:	80a080e7          	jalr	-2038(ra) # 800061f8 <acquire>

  switch(c){
    800059f6:	47d5                	li	a5,21
    800059f8:	0af48663          	beq	s1,a5,80005aa4 <consoleintr+0xcc>
    800059fc:	0297ca63          	blt	a5,s1,80005a30 <consoleintr+0x58>
    80005a00:	47a1                	li	a5,8
    80005a02:	0ef48763          	beq	s1,a5,80005af0 <consoleintr+0x118>
    80005a06:	47c1                	li	a5,16
    80005a08:	10f49a63          	bne	s1,a5,80005b1c <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005a0c:	ffffc097          	auipc	ra,0xffffc
    80005a10:	f84080e7          	jalr	-124(ra) # 80001990 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005a14:	00020517          	auipc	a0,0x20
    80005a18:	72c50513          	addi	a0,a0,1836 # 80026140 <cons>
    80005a1c:	00001097          	auipc	ra,0x1
    80005a20:	890080e7          	jalr	-1904(ra) # 800062ac <release>
}
    80005a24:	60e2                	ld	ra,24(sp)
    80005a26:	6442                	ld	s0,16(sp)
    80005a28:	64a2                	ld	s1,8(sp)
    80005a2a:	6902                	ld	s2,0(sp)
    80005a2c:	6105                	addi	sp,sp,32
    80005a2e:	8082                	ret
  switch(c){
    80005a30:	07f00793          	li	a5,127
    80005a34:	0af48e63          	beq	s1,a5,80005af0 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005a38:	00020717          	auipc	a4,0x20
    80005a3c:	70870713          	addi	a4,a4,1800 # 80026140 <cons>
    80005a40:	0a072783          	lw	a5,160(a4)
    80005a44:	09872703          	lw	a4,152(a4)
    80005a48:	9f99                	subw	a5,a5,a4
    80005a4a:	07f00713          	li	a4,127
    80005a4e:	fcf763e3          	bltu	a4,a5,80005a14 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005a52:	47b5                	li	a5,13
    80005a54:	0cf48763          	beq	s1,a5,80005b22 <consoleintr+0x14a>
      consputc(c);
    80005a58:	8526                	mv	a0,s1
    80005a5a:	00000097          	auipc	ra,0x0
    80005a5e:	f3c080e7          	jalr	-196(ra) # 80005996 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005a62:	00020797          	auipc	a5,0x20
    80005a66:	6de78793          	addi	a5,a5,1758 # 80026140 <cons>
    80005a6a:	0a07a703          	lw	a4,160(a5)
    80005a6e:	0017069b          	addiw	a3,a4,1
    80005a72:	0006861b          	sext.w	a2,a3
    80005a76:	0ad7a023          	sw	a3,160(a5)
    80005a7a:	07f77713          	andi	a4,a4,127
    80005a7e:	97ba                	add	a5,a5,a4
    80005a80:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005a84:	47a9                	li	a5,10
    80005a86:	0cf48563          	beq	s1,a5,80005b50 <consoleintr+0x178>
    80005a8a:	4791                	li	a5,4
    80005a8c:	0cf48263          	beq	s1,a5,80005b50 <consoleintr+0x178>
    80005a90:	00020797          	auipc	a5,0x20
    80005a94:	7487a783          	lw	a5,1864(a5) # 800261d8 <cons+0x98>
    80005a98:	0807879b          	addiw	a5,a5,128
    80005a9c:	f6f61ce3          	bne	a2,a5,80005a14 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005aa0:	863e                	mv	a2,a5
    80005aa2:	a07d                	j	80005b50 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005aa4:	00020717          	auipc	a4,0x20
    80005aa8:	69c70713          	addi	a4,a4,1692 # 80026140 <cons>
    80005aac:	0a072783          	lw	a5,160(a4)
    80005ab0:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005ab4:	00020497          	auipc	s1,0x20
    80005ab8:	68c48493          	addi	s1,s1,1676 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005abc:	4929                	li	s2,10
    80005abe:	f4f70be3          	beq	a4,a5,80005a14 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005ac2:	37fd                	addiw	a5,a5,-1
    80005ac4:	07f7f713          	andi	a4,a5,127
    80005ac8:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005aca:	01874703          	lbu	a4,24(a4)
    80005ace:	f52703e3          	beq	a4,s2,80005a14 <consoleintr+0x3c>
      cons.e--;
    80005ad2:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005ad6:	10000513          	li	a0,256
    80005ada:	00000097          	auipc	ra,0x0
    80005ade:	ebc080e7          	jalr	-324(ra) # 80005996 <consputc>
    while(cons.e != cons.w &&
    80005ae2:	0a04a783          	lw	a5,160(s1)
    80005ae6:	09c4a703          	lw	a4,156(s1)
    80005aea:	fcf71ce3          	bne	a4,a5,80005ac2 <consoleintr+0xea>
    80005aee:	b71d                	j	80005a14 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005af0:	00020717          	auipc	a4,0x20
    80005af4:	65070713          	addi	a4,a4,1616 # 80026140 <cons>
    80005af8:	0a072783          	lw	a5,160(a4)
    80005afc:	09c72703          	lw	a4,156(a4)
    80005b00:	f0f70ae3          	beq	a4,a5,80005a14 <consoleintr+0x3c>
      cons.e--;
    80005b04:	37fd                	addiw	a5,a5,-1
    80005b06:	00020717          	auipc	a4,0x20
    80005b0a:	6cf72d23          	sw	a5,1754(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005b0e:	10000513          	li	a0,256
    80005b12:	00000097          	auipc	ra,0x0
    80005b16:	e84080e7          	jalr	-380(ra) # 80005996 <consputc>
    80005b1a:	bded                	j	80005a14 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b1c:	ee048ce3          	beqz	s1,80005a14 <consoleintr+0x3c>
    80005b20:	bf21                	j	80005a38 <consoleintr+0x60>
      consputc(c);
    80005b22:	4529                	li	a0,10
    80005b24:	00000097          	auipc	ra,0x0
    80005b28:	e72080e7          	jalr	-398(ra) # 80005996 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b2c:	00020797          	auipc	a5,0x20
    80005b30:	61478793          	addi	a5,a5,1556 # 80026140 <cons>
    80005b34:	0a07a703          	lw	a4,160(a5)
    80005b38:	0017069b          	addiw	a3,a4,1
    80005b3c:	0006861b          	sext.w	a2,a3
    80005b40:	0ad7a023          	sw	a3,160(a5)
    80005b44:	07f77713          	andi	a4,a4,127
    80005b48:	97ba                	add	a5,a5,a4
    80005b4a:	4729                	li	a4,10
    80005b4c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005b50:	00020797          	auipc	a5,0x20
    80005b54:	68c7a623          	sw	a2,1676(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005b58:	00020517          	auipc	a0,0x20
    80005b5c:	68050513          	addi	a0,a0,1664 # 800261d8 <cons+0x98>
    80005b60:	ffffc097          	auipc	ra,0xffffc
    80005b64:	b6c080e7          	jalr	-1172(ra) # 800016cc <wakeup>
    80005b68:	b575                	j	80005a14 <consoleintr+0x3c>

0000000080005b6a <consoleinit>:

void
consoleinit(void)
{
    80005b6a:	1141                	addi	sp,sp,-16
    80005b6c:	e406                	sd	ra,8(sp)
    80005b6e:	e022                	sd	s0,0(sp)
    80005b70:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005b72:	00003597          	auipc	a1,0x3
    80005b76:	c2e58593          	addi	a1,a1,-978 # 800087a0 <syscalls+0x3d8>
    80005b7a:	00020517          	auipc	a0,0x20
    80005b7e:	5c650513          	addi	a0,a0,1478 # 80026140 <cons>
    80005b82:	00000097          	auipc	ra,0x0
    80005b86:	5e6080e7          	jalr	1510(ra) # 80006168 <initlock>

  uartinit();
    80005b8a:	00000097          	auipc	ra,0x0
    80005b8e:	386080e7          	jalr	902(ra) # 80005f10 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005b92:	00014797          	auipc	a5,0x14
    80005b96:	33678793          	addi	a5,a5,822 # 80019ec8 <devsw>
    80005b9a:	00000717          	auipc	a4,0x0
    80005b9e:	ce470713          	addi	a4,a4,-796 # 8000587e <consoleread>
    80005ba2:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005ba4:	00000717          	auipc	a4,0x0
    80005ba8:	c7870713          	addi	a4,a4,-904 # 8000581c <consolewrite>
    80005bac:	ef98                	sd	a4,24(a5)
}
    80005bae:	60a2                	ld	ra,8(sp)
    80005bb0:	6402                	ld	s0,0(sp)
    80005bb2:	0141                	addi	sp,sp,16
    80005bb4:	8082                	ret

0000000080005bb6 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005bb6:	7179                	addi	sp,sp,-48
    80005bb8:	f406                	sd	ra,40(sp)
    80005bba:	f022                	sd	s0,32(sp)
    80005bbc:	ec26                	sd	s1,24(sp)
    80005bbe:	e84a                	sd	s2,16(sp)
    80005bc0:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if (sign && (sign = xx < 0))
    80005bc2:	c219                	beqz	a2,80005bc8 <printint+0x12>
    80005bc4:	08054663          	bltz	a0,80005c50 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005bc8:	2501                	sext.w	a0,a0
    80005bca:	4881                	li	a7,0
    80005bcc:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005bd0:	4701                	li	a4,0
  do
  {
    buf[i++] = digits[x % base];
    80005bd2:	2581                	sext.w	a1,a1
    80005bd4:	00003617          	auipc	a2,0x3
    80005bd8:	c1460613          	addi	a2,a2,-1004 # 800087e8 <digits>
    80005bdc:	883a                	mv	a6,a4
    80005bde:	2705                	addiw	a4,a4,1
    80005be0:	02b577bb          	remuw	a5,a0,a1
    80005be4:	1782                	slli	a5,a5,0x20
    80005be6:	9381                	srli	a5,a5,0x20
    80005be8:	97b2                	add	a5,a5,a2
    80005bea:	0007c783          	lbu	a5,0(a5)
    80005bee:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
    80005bf2:	0005079b          	sext.w	a5,a0
    80005bf6:	02b5553b          	divuw	a0,a0,a1
    80005bfa:	0685                	addi	a3,a3,1
    80005bfc:	feb7f0e3          	bgeu	a5,a1,80005bdc <printint+0x26>

  if (sign)
    80005c00:	00088b63          	beqz	a7,80005c16 <printint+0x60>
    buf[i++] = '-';
    80005c04:	fe040793          	addi	a5,s0,-32
    80005c08:	973e                	add	a4,a4,a5
    80005c0a:	02d00793          	li	a5,45
    80005c0e:	fef70823          	sb	a5,-16(a4)
    80005c12:	0028071b          	addiw	a4,a6,2

  while (--i >= 0)
    80005c16:	02e05763          	blez	a4,80005c44 <printint+0x8e>
    80005c1a:	fd040793          	addi	a5,s0,-48
    80005c1e:	00e784b3          	add	s1,a5,a4
    80005c22:	fff78913          	addi	s2,a5,-1
    80005c26:	993a                	add	s2,s2,a4
    80005c28:	377d                	addiw	a4,a4,-1
    80005c2a:	1702                	slli	a4,a4,0x20
    80005c2c:	9301                	srli	a4,a4,0x20
    80005c2e:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005c32:	fff4c503          	lbu	a0,-1(s1)
    80005c36:	00000097          	auipc	ra,0x0
    80005c3a:	d60080e7          	jalr	-672(ra) # 80005996 <consputc>
  while (--i >= 0)
    80005c3e:	14fd                	addi	s1,s1,-1
    80005c40:	ff2499e3          	bne	s1,s2,80005c32 <printint+0x7c>
}
    80005c44:	70a2                	ld	ra,40(sp)
    80005c46:	7402                	ld	s0,32(sp)
    80005c48:	64e2                	ld	s1,24(sp)
    80005c4a:	6942                	ld	s2,16(sp)
    80005c4c:	6145                	addi	sp,sp,48
    80005c4e:	8082                	ret
    x = -xx;
    80005c50:	40a0053b          	negw	a0,a0
  if (sign && (sign = xx < 0))
    80005c54:	4885                	li	a7,1
    x = -xx;
    80005c56:	bf9d                	j	80005bcc <printint+0x16>

0000000080005c58 <panic>:
  if (locking)
    release(&pr.lock);
}

void panic(char *s)
{
    80005c58:	1101                	addi	sp,sp,-32
    80005c5a:	ec06                	sd	ra,24(sp)
    80005c5c:	e822                	sd	s0,16(sp)
    80005c5e:	e426                	sd	s1,8(sp)
    80005c60:	1000                	addi	s0,sp,32
    80005c62:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005c64:	00020797          	auipc	a5,0x20
    80005c68:	5807ae23          	sw	zero,1436(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005c6c:	00003517          	auipc	a0,0x3
    80005c70:	b3c50513          	addi	a0,a0,-1220 # 800087a8 <syscalls+0x3e0>
    80005c74:	00000097          	auipc	ra,0x0
    80005c78:	02e080e7          	jalr	46(ra) # 80005ca2 <printf>
  printf(s);
    80005c7c:	8526                	mv	a0,s1
    80005c7e:	00000097          	auipc	ra,0x0
    80005c82:	024080e7          	jalr	36(ra) # 80005ca2 <printf>
  printf("\n");
    80005c86:	00002517          	auipc	a0,0x2
    80005c8a:	3c250513          	addi	a0,a0,962 # 80008048 <etext+0x48>
    80005c8e:	00000097          	auipc	ra,0x0
    80005c92:	014080e7          	jalr	20(ra) # 80005ca2 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005c96:	4785                	li	a5,1
    80005c98:	00003717          	auipc	a4,0x3
    80005c9c:	38f72223          	sw	a5,900(a4) # 8000901c <panicked>
  for (;;)
    80005ca0:	a001                	j	80005ca0 <panic+0x48>

0000000080005ca2 <printf>:
{
    80005ca2:	7131                	addi	sp,sp,-192
    80005ca4:	fc86                	sd	ra,120(sp)
    80005ca6:	f8a2                	sd	s0,112(sp)
    80005ca8:	f4a6                	sd	s1,104(sp)
    80005caa:	f0ca                	sd	s2,96(sp)
    80005cac:	ecce                	sd	s3,88(sp)
    80005cae:	e8d2                	sd	s4,80(sp)
    80005cb0:	e4d6                	sd	s5,72(sp)
    80005cb2:	e0da                	sd	s6,64(sp)
    80005cb4:	fc5e                	sd	s7,56(sp)
    80005cb6:	f862                	sd	s8,48(sp)
    80005cb8:	f466                	sd	s9,40(sp)
    80005cba:	f06a                	sd	s10,32(sp)
    80005cbc:	ec6e                	sd	s11,24(sp)
    80005cbe:	0100                	addi	s0,sp,128
    80005cc0:	8a2a                	mv	s4,a0
    80005cc2:	e40c                	sd	a1,8(s0)
    80005cc4:	e810                	sd	a2,16(s0)
    80005cc6:	ec14                	sd	a3,24(s0)
    80005cc8:	f018                	sd	a4,32(s0)
    80005cca:	f41c                	sd	a5,40(s0)
    80005ccc:	03043823          	sd	a6,48(s0)
    80005cd0:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005cd4:	00020d97          	auipc	s11,0x20
    80005cd8:	52cdad83          	lw	s11,1324(s11) # 80026200 <pr+0x18>
  if (locking)
    80005cdc:	020d9b63          	bnez	s11,80005d12 <printf+0x70>
  if (fmt == 0)
    80005ce0:	040a0263          	beqz	s4,80005d24 <printf+0x82>
  va_start(ap, fmt);
    80005ce4:	00840793          	addi	a5,s0,8
    80005ce8:	f8f43423          	sd	a5,-120(s0)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
    80005cec:	000a4503          	lbu	a0,0(s4)
    80005cf0:	16050263          	beqz	a0,80005e54 <printf+0x1b2>
    80005cf4:	4481                	li	s1,0
    if (c != '%')
    80005cf6:	02500a93          	li	s5,37
    switch (c)
    80005cfa:	07000b13          	li	s6,112
  consputc('x');
    80005cfe:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d00:	00003b97          	auipc	s7,0x3
    80005d04:	ae8b8b93          	addi	s7,s7,-1304 # 800087e8 <digits>
    switch (c)
    80005d08:	07300c93          	li	s9,115
    80005d0c:	06400c13          	li	s8,100
    80005d10:	a82d                	j	80005d4a <printf+0xa8>
    acquire(&pr.lock);
    80005d12:	00020517          	auipc	a0,0x20
    80005d16:	4d650513          	addi	a0,a0,1238 # 800261e8 <pr>
    80005d1a:	00000097          	auipc	ra,0x0
    80005d1e:	4de080e7          	jalr	1246(ra) # 800061f8 <acquire>
    80005d22:	bf7d                	j	80005ce0 <printf+0x3e>
    panic("null fmt");
    80005d24:	00003517          	auipc	a0,0x3
    80005d28:	a9450513          	addi	a0,a0,-1388 # 800087b8 <syscalls+0x3f0>
    80005d2c:	00000097          	auipc	ra,0x0
    80005d30:	f2c080e7          	jalr	-212(ra) # 80005c58 <panic>
      consputc(c);
    80005d34:	00000097          	auipc	ra,0x0
    80005d38:	c62080e7          	jalr	-926(ra) # 80005996 <consputc>
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
    80005d3c:	2485                	addiw	s1,s1,1
    80005d3e:	009a07b3          	add	a5,s4,s1
    80005d42:	0007c503          	lbu	a0,0(a5)
    80005d46:	10050763          	beqz	a0,80005e54 <printf+0x1b2>
    if (c != '%')
    80005d4a:	ff5515e3          	bne	a0,s5,80005d34 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005d4e:	2485                	addiw	s1,s1,1
    80005d50:	009a07b3          	add	a5,s4,s1
    80005d54:	0007c783          	lbu	a5,0(a5)
    80005d58:	0007891b          	sext.w	s2,a5
    if (c == 0)
    80005d5c:	cfe5                	beqz	a5,80005e54 <printf+0x1b2>
    switch (c)
    80005d5e:	05678a63          	beq	a5,s6,80005db2 <printf+0x110>
    80005d62:	02fb7663          	bgeu	s6,a5,80005d8e <printf+0xec>
    80005d66:	09978963          	beq	a5,s9,80005df8 <printf+0x156>
    80005d6a:	07800713          	li	a4,120
    80005d6e:	0ce79863          	bne	a5,a4,80005e3e <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005d72:	f8843783          	ld	a5,-120(s0)
    80005d76:	00878713          	addi	a4,a5,8
    80005d7a:	f8e43423          	sd	a4,-120(s0)
    80005d7e:	4605                	li	a2,1
    80005d80:	85ea                	mv	a1,s10
    80005d82:	4388                	lw	a0,0(a5)
    80005d84:	00000097          	auipc	ra,0x0
    80005d88:	e32080e7          	jalr	-462(ra) # 80005bb6 <printint>
      break;
    80005d8c:	bf45                	j	80005d3c <printf+0x9a>
    switch (c)
    80005d8e:	0b578263          	beq	a5,s5,80005e32 <printf+0x190>
    80005d92:	0b879663          	bne	a5,s8,80005e3e <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005d96:	f8843783          	ld	a5,-120(s0)
    80005d9a:	00878713          	addi	a4,a5,8
    80005d9e:	f8e43423          	sd	a4,-120(s0)
    80005da2:	4605                	li	a2,1
    80005da4:	45a9                	li	a1,10
    80005da6:	4388                	lw	a0,0(a5)
    80005da8:	00000097          	auipc	ra,0x0
    80005dac:	e0e080e7          	jalr	-498(ra) # 80005bb6 <printint>
      break;
    80005db0:	b771                	j	80005d3c <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005db2:	f8843783          	ld	a5,-120(s0)
    80005db6:	00878713          	addi	a4,a5,8
    80005dba:	f8e43423          	sd	a4,-120(s0)
    80005dbe:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005dc2:	03000513          	li	a0,48
    80005dc6:	00000097          	auipc	ra,0x0
    80005dca:	bd0080e7          	jalr	-1072(ra) # 80005996 <consputc>
  consputc('x');
    80005dce:	07800513          	li	a0,120
    80005dd2:	00000097          	auipc	ra,0x0
    80005dd6:	bc4080e7          	jalr	-1084(ra) # 80005996 <consputc>
    80005dda:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005ddc:	03c9d793          	srli	a5,s3,0x3c
    80005de0:	97de                	add	a5,a5,s7
    80005de2:	0007c503          	lbu	a0,0(a5)
    80005de6:	00000097          	auipc	ra,0x0
    80005dea:	bb0080e7          	jalr	-1104(ra) # 80005996 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005dee:	0992                	slli	s3,s3,0x4
    80005df0:	397d                	addiw	s2,s2,-1
    80005df2:	fe0915e3          	bnez	s2,80005ddc <printf+0x13a>
    80005df6:	b799                	j	80005d3c <printf+0x9a>
      if ((s = va_arg(ap, char *)) == 0)
    80005df8:	f8843783          	ld	a5,-120(s0)
    80005dfc:	00878713          	addi	a4,a5,8
    80005e00:	f8e43423          	sd	a4,-120(s0)
    80005e04:	0007b903          	ld	s2,0(a5)
    80005e08:	00090e63          	beqz	s2,80005e24 <printf+0x182>
      for (; *s; s++)
    80005e0c:	00094503          	lbu	a0,0(s2)
    80005e10:	d515                	beqz	a0,80005d3c <printf+0x9a>
        consputc(*s);
    80005e12:	00000097          	auipc	ra,0x0
    80005e16:	b84080e7          	jalr	-1148(ra) # 80005996 <consputc>
      for (; *s; s++)
    80005e1a:	0905                	addi	s2,s2,1
    80005e1c:	00094503          	lbu	a0,0(s2)
    80005e20:	f96d                	bnez	a0,80005e12 <printf+0x170>
    80005e22:	bf29                	j	80005d3c <printf+0x9a>
        s = "(null)";
    80005e24:	00003917          	auipc	s2,0x3
    80005e28:	98c90913          	addi	s2,s2,-1652 # 800087b0 <syscalls+0x3e8>
      for (; *s; s++)
    80005e2c:	02800513          	li	a0,40
    80005e30:	b7cd                	j	80005e12 <printf+0x170>
      consputc('%');
    80005e32:	8556                	mv	a0,s5
    80005e34:	00000097          	auipc	ra,0x0
    80005e38:	b62080e7          	jalr	-1182(ra) # 80005996 <consputc>
      break;
    80005e3c:	b701                	j	80005d3c <printf+0x9a>
      consputc('%');
    80005e3e:	8556                	mv	a0,s5
    80005e40:	00000097          	auipc	ra,0x0
    80005e44:	b56080e7          	jalr	-1194(ra) # 80005996 <consputc>
      consputc(c);
    80005e48:	854a                	mv	a0,s2
    80005e4a:	00000097          	auipc	ra,0x0
    80005e4e:	b4c080e7          	jalr	-1204(ra) # 80005996 <consputc>
      break;
    80005e52:	b5ed                	j	80005d3c <printf+0x9a>
  if (locking)
    80005e54:	020d9163          	bnez	s11,80005e76 <printf+0x1d4>
}
    80005e58:	70e6                	ld	ra,120(sp)
    80005e5a:	7446                	ld	s0,112(sp)
    80005e5c:	74a6                	ld	s1,104(sp)
    80005e5e:	7906                	ld	s2,96(sp)
    80005e60:	69e6                	ld	s3,88(sp)
    80005e62:	6a46                	ld	s4,80(sp)
    80005e64:	6aa6                	ld	s5,72(sp)
    80005e66:	6b06                	ld	s6,64(sp)
    80005e68:	7be2                	ld	s7,56(sp)
    80005e6a:	7c42                	ld	s8,48(sp)
    80005e6c:	7ca2                	ld	s9,40(sp)
    80005e6e:	7d02                	ld	s10,32(sp)
    80005e70:	6de2                	ld	s11,24(sp)
    80005e72:	6129                	addi	sp,sp,192
    80005e74:	8082                	ret
    release(&pr.lock);
    80005e76:	00020517          	auipc	a0,0x20
    80005e7a:	37250513          	addi	a0,a0,882 # 800261e8 <pr>
    80005e7e:	00000097          	auipc	ra,0x0
    80005e82:	42e080e7          	jalr	1070(ra) # 800062ac <release>
}
    80005e86:	bfc9                	j	80005e58 <printf+0x1b6>

0000000080005e88 <printfinit>:
    ;
}

void printfinit(void)
{
    80005e88:	1101                	addi	sp,sp,-32
    80005e8a:	ec06                	sd	ra,24(sp)
    80005e8c:	e822                	sd	s0,16(sp)
    80005e8e:	e426                	sd	s1,8(sp)
    80005e90:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005e92:	00020497          	auipc	s1,0x20
    80005e96:	35648493          	addi	s1,s1,854 # 800261e8 <pr>
    80005e9a:	00003597          	auipc	a1,0x3
    80005e9e:	92e58593          	addi	a1,a1,-1746 # 800087c8 <syscalls+0x400>
    80005ea2:	8526                	mv	a0,s1
    80005ea4:	00000097          	auipc	ra,0x0
    80005ea8:	2c4080e7          	jalr	708(ra) # 80006168 <initlock>
  pr.locking = 1;
    80005eac:	4785                	li	a5,1
    80005eae:	cc9c                	sw	a5,24(s1)
}
    80005eb0:	60e2                	ld	ra,24(sp)
    80005eb2:	6442                	ld	s0,16(sp)
    80005eb4:	64a2                	ld	s1,8(sp)
    80005eb6:	6105                	addi	sp,sp,32
    80005eb8:	8082                	ret

0000000080005eba <backtrace>:

void backtrace(void)
{
    80005eba:	7179                	addi	sp,sp,-48
    80005ebc:	f406                	sd	ra,40(sp)
    80005ebe:	f022                	sd	s0,32(sp)
    80005ec0:	ec26                	sd	s1,24(sp)
    80005ec2:	e84a                	sd	s2,16(sp)
    80005ec4:	e44e                	sd	s3,8(sp)
    80005ec6:	1800                	addi	s0,sp,48

static inline uint64
r_fp()
{
  uint64 x;
  asm volatile("mv %0, s0" : "=r"(x));
    80005ec8:	84a2                	mv	s1,s0
  uint64 fp = r_fp();
  printf("backtrace:\n");
    80005eca:	00003517          	auipc	a0,0x3
    80005ece:	90650513          	addi	a0,a0,-1786 # 800087d0 <syscalls+0x408>
    80005ed2:	00000097          	auipc	ra,0x0
    80005ed6:	dd0080e7          	jalr	-560(ra) # 80005ca2 <printf>
  while (1)
  {
    uint64 ra = *(uint64 *)(fp - 8);
    printf("%p\n", ra);
    80005eda:	00003917          	auipc	s2,0x3
    80005ede:	90690913          	addi	s2,s2,-1786 # 800087e0 <syscalls+0x418>
    uint64 old_fp = fp;

    fp = *(uint64 *)(fp - 16);
    if (fp == 0 || PGROUNDDOWN(old_fp) != PGROUNDDOWN(fp))
    80005ee2:	79fd                	lui	s3,0xfffff
    printf("%p\n", ra);
    80005ee4:	ff84b583          	ld	a1,-8(s1)
    80005ee8:	854a                	mv	a0,s2
    80005eea:	00000097          	auipc	ra,0x0
    80005eee:	db8080e7          	jalr	-584(ra) # 80005ca2 <printf>
    fp = *(uint64 *)(fp - 16);
    80005ef2:	87a6                	mv	a5,s1
    80005ef4:	ff04b483          	ld	s1,-16(s1)
    if (fp == 0 || PGROUNDDOWN(old_fp) != PGROUNDDOWN(fp))
    80005ef8:	c489                	beqz	s1,80005f02 <backtrace+0x48>
    80005efa:	8fa5                	xor	a5,a5,s1
    80005efc:	0137f7b3          	and	a5,a5,s3
    80005f00:	d3f5                	beqz	a5,80005ee4 <backtrace+0x2a>
    {
      break;
    }
  }
}
    80005f02:	70a2                	ld	ra,40(sp)
    80005f04:	7402                	ld	s0,32(sp)
    80005f06:	64e2                	ld	s1,24(sp)
    80005f08:	6942                	ld	s2,16(sp)
    80005f0a:	69a2                	ld	s3,8(sp)
    80005f0c:	6145                	addi	sp,sp,48
    80005f0e:	8082                	ret

0000000080005f10 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005f10:	1141                	addi	sp,sp,-16
    80005f12:	e406                	sd	ra,8(sp)
    80005f14:	e022                	sd	s0,0(sp)
    80005f16:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005f18:	100007b7          	lui	a5,0x10000
    80005f1c:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005f20:	f8000713          	li	a4,-128
    80005f24:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005f28:	470d                	li	a4,3
    80005f2a:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005f2e:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005f32:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005f36:	469d                	li	a3,7
    80005f38:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005f3c:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005f40:	00003597          	auipc	a1,0x3
    80005f44:	8c058593          	addi	a1,a1,-1856 # 80008800 <digits+0x18>
    80005f48:	00020517          	auipc	a0,0x20
    80005f4c:	2c050513          	addi	a0,a0,704 # 80026208 <uart_tx_lock>
    80005f50:	00000097          	auipc	ra,0x0
    80005f54:	218080e7          	jalr	536(ra) # 80006168 <initlock>
}
    80005f58:	60a2                	ld	ra,8(sp)
    80005f5a:	6402                	ld	s0,0(sp)
    80005f5c:	0141                	addi	sp,sp,16
    80005f5e:	8082                	ret

0000000080005f60 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005f60:	1101                	addi	sp,sp,-32
    80005f62:	ec06                	sd	ra,24(sp)
    80005f64:	e822                	sd	s0,16(sp)
    80005f66:	e426                	sd	s1,8(sp)
    80005f68:	1000                	addi	s0,sp,32
    80005f6a:	84aa                	mv	s1,a0
  push_off();
    80005f6c:	00000097          	auipc	ra,0x0
    80005f70:	240080e7          	jalr	576(ra) # 800061ac <push_off>

  if(panicked){
    80005f74:	00003797          	auipc	a5,0x3
    80005f78:	0a87a783          	lw	a5,168(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f7c:	10000737          	lui	a4,0x10000
  if(panicked){
    80005f80:	c391                	beqz	a5,80005f84 <uartputc_sync+0x24>
    for(;;)
    80005f82:	a001                	j	80005f82 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f84:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005f88:	0ff7f793          	andi	a5,a5,255
    80005f8c:	0207f793          	andi	a5,a5,32
    80005f90:	dbf5                	beqz	a5,80005f84 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005f92:	0ff4f793          	andi	a5,s1,255
    80005f96:	10000737          	lui	a4,0x10000
    80005f9a:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80005f9e:	00000097          	auipc	ra,0x0
    80005fa2:	2ae080e7          	jalr	686(ra) # 8000624c <pop_off>
}
    80005fa6:	60e2                	ld	ra,24(sp)
    80005fa8:	6442                	ld	s0,16(sp)
    80005faa:	64a2                	ld	s1,8(sp)
    80005fac:	6105                	addi	sp,sp,32
    80005fae:	8082                	ret

0000000080005fb0 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005fb0:	00003717          	auipc	a4,0x3
    80005fb4:	07073703          	ld	a4,112(a4) # 80009020 <uart_tx_r>
    80005fb8:	00003797          	auipc	a5,0x3
    80005fbc:	0707b783          	ld	a5,112(a5) # 80009028 <uart_tx_w>
    80005fc0:	06e78c63          	beq	a5,a4,80006038 <uartstart+0x88>
{
    80005fc4:	7139                	addi	sp,sp,-64
    80005fc6:	fc06                	sd	ra,56(sp)
    80005fc8:	f822                	sd	s0,48(sp)
    80005fca:	f426                	sd	s1,40(sp)
    80005fcc:	f04a                	sd	s2,32(sp)
    80005fce:	ec4e                	sd	s3,24(sp)
    80005fd0:	e852                	sd	s4,16(sp)
    80005fd2:	e456                	sd	s5,8(sp)
    80005fd4:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fd6:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005fda:	00020a17          	auipc	s4,0x20
    80005fde:	22ea0a13          	addi	s4,s4,558 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    80005fe2:	00003497          	auipc	s1,0x3
    80005fe6:	03e48493          	addi	s1,s1,62 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005fea:	00003997          	auipc	s3,0x3
    80005fee:	03e98993          	addi	s3,s3,62 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005ff2:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005ff6:	0ff7f793          	andi	a5,a5,255
    80005ffa:	0207f793          	andi	a5,a5,32
    80005ffe:	c785                	beqz	a5,80006026 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006000:	01f77793          	andi	a5,a4,31
    80006004:	97d2                	add	a5,a5,s4
    80006006:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    8000600a:	0705                	addi	a4,a4,1
    8000600c:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    8000600e:	8526                	mv	a0,s1
    80006010:	ffffb097          	auipc	ra,0xffffb
    80006014:	6bc080e7          	jalr	1724(ra) # 800016cc <wakeup>
    
    WriteReg(THR, c);
    80006018:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    8000601c:	6098                	ld	a4,0(s1)
    8000601e:	0009b783          	ld	a5,0(s3)
    80006022:	fce798e3          	bne	a5,a4,80005ff2 <uartstart+0x42>
  }
}
    80006026:	70e2                	ld	ra,56(sp)
    80006028:	7442                	ld	s0,48(sp)
    8000602a:	74a2                	ld	s1,40(sp)
    8000602c:	7902                	ld	s2,32(sp)
    8000602e:	69e2                	ld	s3,24(sp)
    80006030:	6a42                	ld	s4,16(sp)
    80006032:	6aa2                	ld	s5,8(sp)
    80006034:	6121                	addi	sp,sp,64
    80006036:	8082                	ret
    80006038:	8082                	ret

000000008000603a <uartputc>:
{
    8000603a:	7179                	addi	sp,sp,-48
    8000603c:	f406                	sd	ra,40(sp)
    8000603e:	f022                	sd	s0,32(sp)
    80006040:	ec26                	sd	s1,24(sp)
    80006042:	e84a                	sd	s2,16(sp)
    80006044:	e44e                	sd	s3,8(sp)
    80006046:	e052                	sd	s4,0(sp)
    80006048:	1800                	addi	s0,sp,48
    8000604a:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    8000604c:	00020517          	auipc	a0,0x20
    80006050:	1bc50513          	addi	a0,a0,444 # 80026208 <uart_tx_lock>
    80006054:	00000097          	auipc	ra,0x0
    80006058:	1a4080e7          	jalr	420(ra) # 800061f8 <acquire>
  if(panicked){
    8000605c:	00003797          	auipc	a5,0x3
    80006060:	fc07a783          	lw	a5,-64(a5) # 8000901c <panicked>
    80006064:	c391                	beqz	a5,80006068 <uartputc+0x2e>
    for(;;)
    80006066:	a001                	j	80006066 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006068:	00003797          	auipc	a5,0x3
    8000606c:	fc07b783          	ld	a5,-64(a5) # 80009028 <uart_tx_w>
    80006070:	00003717          	auipc	a4,0x3
    80006074:	fb073703          	ld	a4,-80(a4) # 80009020 <uart_tx_r>
    80006078:	02070713          	addi	a4,a4,32
    8000607c:	02f71b63          	bne	a4,a5,800060b2 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006080:	00020a17          	auipc	s4,0x20
    80006084:	188a0a13          	addi	s4,s4,392 # 80026208 <uart_tx_lock>
    80006088:	00003497          	auipc	s1,0x3
    8000608c:	f9848493          	addi	s1,s1,-104 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006090:	00003917          	auipc	s2,0x3
    80006094:	f9890913          	addi	s2,s2,-104 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006098:	85d2                	mv	a1,s4
    8000609a:	8526                	mv	a0,s1
    8000609c:	ffffb097          	auipc	ra,0xffffb
    800060a0:	4a4080e7          	jalr	1188(ra) # 80001540 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800060a4:	00093783          	ld	a5,0(s2)
    800060a8:	6098                	ld	a4,0(s1)
    800060aa:	02070713          	addi	a4,a4,32
    800060ae:	fef705e3          	beq	a4,a5,80006098 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800060b2:	00020497          	auipc	s1,0x20
    800060b6:	15648493          	addi	s1,s1,342 # 80026208 <uart_tx_lock>
    800060ba:	01f7f713          	andi	a4,a5,31
    800060be:	9726                	add	a4,a4,s1
    800060c0:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    800060c4:	0785                	addi	a5,a5,1
    800060c6:	00003717          	auipc	a4,0x3
    800060ca:	f6f73123          	sd	a5,-158(a4) # 80009028 <uart_tx_w>
      uartstart();
    800060ce:	00000097          	auipc	ra,0x0
    800060d2:	ee2080e7          	jalr	-286(ra) # 80005fb0 <uartstart>
      release(&uart_tx_lock);
    800060d6:	8526                	mv	a0,s1
    800060d8:	00000097          	auipc	ra,0x0
    800060dc:	1d4080e7          	jalr	468(ra) # 800062ac <release>
}
    800060e0:	70a2                	ld	ra,40(sp)
    800060e2:	7402                	ld	s0,32(sp)
    800060e4:	64e2                	ld	s1,24(sp)
    800060e6:	6942                	ld	s2,16(sp)
    800060e8:	69a2                	ld	s3,8(sp)
    800060ea:	6a02                	ld	s4,0(sp)
    800060ec:	6145                	addi	sp,sp,48
    800060ee:	8082                	ret

00000000800060f0 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800060f0:	1141                	addi	sp,sp,-16
    800060f2:	e422                	sd	s0,8(sp)
    800060f4:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800060f6:	100007b7          	lui	a5,0x10000
    800060fa:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800060fe:	8b85                	andi	a5,a5,1
    80006100:	cb91                	beqz	a5,80006114 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80006102:	100007b7          	lui	a5,0x10000
    80006106:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000610a:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    8000610e:	6422                	ld	s0,8(sp)
    80006110:	0141                	addi	sp,sp,16
    80006112:	8082                	ret
    return -1;
    80006114:	557d                	li	a0,-1
    80006116:	bfe5                	j	8000610e <uartgetc+0x1e>

0000000080006118 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006118:	1101                	addi	sp,sp,-32
    8000611a:	ec06                	sd	ra,24(sp)
    8000611c:	e822                	sd	s0,16(sp)
    8000611e:	e426                	sd	s1,8(sp)
    80006120:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006122:	54fd                	li	s1,-1
    int c = uartgetc();
    80006124:	00000097          	auipc	ra,0x0
    80006128:	fcc080e7          	jalr	-52(ra) # 800060f0 <uartgetc>
    if(c == -1)
    8000612c:	00950763          	beq	a0,s1,8000613a <uartintr+0x22>
      break;
    consoleintr(c);
    80006130:	00000097          	auipc	ra,0x0
    80006134:	8a8080e7          	jalr	-1880(ra) # 800059d8 <consoleintr>
  while(1){
    80006138:	b7f5                	j	80006124 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000613a:	00020497          	auipc	s1,0x20
    8000613e:	0ce48493          	addi	s1,s1,206 # 80026208 <uart_tx_lock>
    80006142:	8526                	mv	a0,s1
    80006144:	00000097          	auipc	ra,0x0
    80006148:	0b4080e7          	jalr	180(ra) # 800061f8 <acquire>
  uartstart();
    8000614c:	00000097          	auipc	ra,0x0
    80006150:	e64080e7          	jalr	-412(ra) # 80005fb0 <uartstart>
  release(&uart_tx_lock);
    80006154:	8526                	mv	a0,s1
    80006156:	00000097          	auipc	ra,0x0
    8000615a:	156080e7          	jalr	342(ra) # 800062ac <release>
}
    8000615e:	60e2                	ld	ra,24(sp)
    80006160:	6442                	ld	s0,16(sp)
    80006162:	64a2                	ld	s1,8(sp)
    80006164:	6105                	addi	sp,sp,32
    80006166:	8082                	ret

0000000080006168 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006168:	1141                	addi	sp,sp,-16
    8000616a:	e422                	sd	s0,8(sp)
    8000616c:	0800                	addi	s0,sp,16
  lk->name = name;
    8000616e:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006170:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006174:	00053823          	sd	zero,16(a0)
}
    80006178:	6422                	ld	s0,8(sp)
    8000617a:	0141                	addi	sp,sp,16
    8000617c:	8082                	ret

000000008000617e <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000617e:	411c                	lw	a5,0(a0)
    80006180:	e399                	bnez	a5,80006186 <holding+0x8>
    80006182:	4501                	li	a0,0
  return r;
}
    80006184:	8082                	ret
{
    80006186:	1101                	addi	sp,sp,-32
    80006188:	ec06                	sd	ra,24(sp)
    8000618a:	e822                	sd	s0,16(sp)
    8000618c:	e426                	sd	s1,8(sp)
    8000618e:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006190:	6904                	ld	s1,16(a0)
    80006192:	ffffb097          	auipc	ra,0xffffb
    80006196:	c9a080e7          	jalr	-870(ra) # 80000e2c <mycpu>
    8000619a:	40a48533          	sub	a0,s1,a0
    8000619e:	00153513          	seqz	a0,a0
}
    800061a2:	60e2                	ld	ra,24(sp)
    800061a4:	6442                	ld	s0,16(sp)
    800061a6:	64a2                	ld	s1,8(sp)
    800061a8:	6105                	addi	sp,sp,32
    800061aa:	8082                	ret

00000000800061ac <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800061ac:	1101                	addi	sp,sp,-32
    800061ae:	ec06                	sd	ra,24(sp)
    800061b0:	e822                	sd	s0,16(sp)
    800061b2:	e426                	sd	s1,8(sp)
    800061b4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800061b6:	100024f3          	csrr	s1,sstatus
    800061ba:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800061be:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r"(x));
    800061c0:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800061c4:	ffffb097          	auipc	ra,0xffffb
    800061c8:	c68080e7          	jalr	-920(ra) # 80000e2c <mycpu>
    800061cc:	5d3c                	lw	a5,120(a0)
    800061ce:	cf89                	beqz	a5,800061e8 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800061d0:	ffffb097          	auipc	ra,0xffffb
    800061d4:	c5c080e7          	jalr	-932(ra) # 80000e2c <mycpu>
    800061d8:	5d3c                	lw	a5,120(a0)
    800061da:	2785                	addiw	a5,a5,1
    800061dc:	dd3c                	sw	a5,120(a0)
}
    800061de:	60e2                	ld	ra,24(sp)
    800061e0:	6442                	ld	s0,16(sp)
    800061e2:	64a2                	ld	s1,8(sp)
    800061e4:	6105                	addi	sp,sp,32
    800061e6:	8082                	ret
    mycpu()->intena = old;
    800061e8:	ffffb097          	auipc	ra,0xffffb
    800061ec:	c44080e7          	jalr	-956(ra) # 80000e2c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800061f0:	8085                	srli	s1,s1,0x1
    800061f2:	8885                	andi	s1,s1,1
    800061f4:	dd64                	sw	s1,124(a0)
    800061f6:	bfe9                	j	800061d0 <push_off+0x24>

00000000800061f8 <acquire>:
{
    800061f8:	1101                	addi	sp,sp,-32
    800061fa:	ec06                	sd	ra,24(sp)
    800061fc:	e822                	sd	s0,16(sp)
    800061fe:	e426                	sd	s1,8(sp)
    80006200:	1000                	addi	s0,sp,32
    80006202:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006204:	00000097          	auipc	ra,0x0
    80006208:	fa8080e7          	jalr	-88(ra) # 800061ac <push_off>
  if(holding(lk))
    8000620c:	8526                	mv	a0,s1
    8000620e:	00000097          	auipc	ra,0x0
    80006212:	f70080e7          	jalr	-144(ra) # 8000617e <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006216:	4705                	li	a4,1
  if(holding(lk))
    80006218:	e115                	bnez	a0,8000623c <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000621a:	87ba                	mv	a5,a4
    8000621c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006220:	2781                	sext.w	a5,a5
    80006222:	ffe5                	bnez	a5,8000621a <acquire+0x22>
  __sync_synchronize();
    80006224:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006228:	ffffb097          	auipc	ra,0xffffb
    8000622c:	c04080e7          	jalr	-1020(ra) # 80000e2c <mycpu>
    80006230:	e888                	sd	a0,16(s1)
}
    80006232:	60e2                	ld	ra,24(sp)
    80006234:	6442                	ld	s0,16(sp)
    80006236:	64a2                	ld	s1,8(sp)
    80006238:	6105                	addi	sp,sp,32
    8000623a:	8082                	ret
    panic("acquire");
    8000623c:	00002517          	auipc	a0,0x2
    80006240:	5cc50513          	addi	a0,a0,1484 # 80008808 <digits+0x20>
    80006244:	00000097          	auipc	ra,0x0
    80006248:	a14080e7          	jalr	-1516(ra) # 80005c58 <panic>

000000008000624c <pop_off>:

void
pop_off(void)
{
    8000624c:	1141                	addi	sp,sp,-16
    8000624e:	e406                	sd	ra,8(sp)
    80006250:	e022                	sd	s0,0(sp)
    80006252:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006254:	ffffb097          	auipc	ra,0xffffb
    80006258:	bd8080e7          	jalr	-1064(ra) # 80000e2c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    8000625c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006260:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006262:	e78d                	bnez	a5,8000628c <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006264:	5d3c                	lw	a5,120(a0)
    80006266:	02f05b63          	blez	a5,8000629c <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000626a:	37fd                	addiw	a5,a5,-1
    8000626c:	0007871b          	sext.w	a4,a5
    80006270:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006272:	eb09                	bnez	a4,80006284 <pop_off+0x38>
    80006274:	5d7c                	lw	a5,124(a0)
    80006276:	c799                	beqz	a5,80006284 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80006278:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000627c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80006280:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006284:	60a2                	ld	ra,8(sp)
    80006286:	6402                	ld	s0,0(sp)
    80006288:	0141                	addi	sp,sp,16
    8000628a:	8082                	ret
    panic("pop_off - interruptible");
    8000628c:	00002517          	auipc	a0,0x2
    80006290:	58450513          	addi	a0,a0,1412 # 80008810 <digits+0x28>
    80006294:	00000097          	auipc	ra,0x0
    80006298:	9c4080e7          	jalr	-1596(ra) # 80005c58 <panic>
    panic("pop_off");
    8000629c:	00002517          	auipc	a0,0x2
    800062a0:	58c50513          	addi	a0,a0,1420 # 80008828 <digits+0x40>
    800062a4:	00000097          	auipc	ra,0x0
    800062a8:	9b4080e7          	jalr	-1612(ra) # 80005c58 <panic>

00000000800062ac <release>:
{
    800062ac:	1101                	addi	sp,sp,-32
    800062ae:	ec06                	sd	ra,24(sp)
    800062b0:	e822                	sd	s0,16(sp)
    800062b2:	e426                	sd	s1,8(sp)
    800062b4:	1000                	addi	s0,sp,32
    800062b6:	84aa                	mv	s1,a0
  if(!holding(lk))
    800062b8:	00000097          	auipc	ra,0x0
    800062bc:	ec6080e7          	jalr	-314(ra) # 8000617e <holding>
    800062c0:	c115                	beqz	a0,800062e4 <release+0x38>
  lk->cpu = 0;
    800062c2:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800062c6:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800062ca:	0f50000f          	fence	iorw,ow
    800062ce:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800062d2:	00000097          	auipc	ra,0x0
    800062d6:	f7a080e7          	jalr	-134(ra) # 8000624c <pop_off>
}
    800062da:	60e2                	ld	ra,24(sp)
    800062dc:	6442                	ld	s0,16(sp)
    800062de:	64a2                	ld	s1,8(sp)
    800062e0:	6105                	addi	sp,sp,32
    800062e2:	8082                	ret
    panic("release");
    800062e4:	00002517          	auipc	a0,0x2
    800062e8:	54c50513          	addi	a0,a0,1356 # 80008830 <digits+0x48>
    800062ec:	00000097          	auipc	ra,0x0
    800062f0:	96c080e7          	jalr	-1684(ra) # 80005c58 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
