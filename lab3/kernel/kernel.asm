
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
    80000016:	662050ef          	jal	ra,80005678 <start>

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
    8000005e:	018080e7          	jalr	24(ra) # 80006072 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	0b8080e7          	jalr	184(ra) # 80006126 <release>
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
    8000008e:	a9e080e7          	jalr	-1378(ra) # 80005b28 <panic>

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
    800000f8:	eee080e7          	jalr	-274(ra) # 80005fe2 <initlock>
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
    80000130:	f46080e7          	jalr	-186(ra) # 80006072 <acquire>
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
    80000148:	fe2080e7          	jalr	-30(ra) # 80006126 <release>

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
    80000172:	fb8080e7          	jalr	-72(ra) # 80006126 <release>
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
    80000332:	aea080e7          	jalr	-1302(ra) # 80000e18 <cpuid>
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
    8000034e:	ace080e7          	jalr	-1330(ra) # 80000e18 <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	816080e7          	jalr	-2026(ra) # 80005b72 <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00001097          	auipc	ra,0x1
    80000370:	724080e7          	jalr	1828(ra) # 80001a90 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	c8c080e7          	jalr	-884(ra) # 80005000 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	fd2080e7          	jalr	-46(ra) # 8000134e <scheduler>
    consoleinit();
    80000384:	00005097          	auipc	ra,0x5
    80000388:	6b6080e7          	jalr	1718(ra) # 80005a3a <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	9cc080e7          	jalr	-1588(ra) # 80005d58 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00005097          	auipc	ra,0x5
    800003a0:	7d6080e7          	jalr	2006(ra) # 80005b72 <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00005097          	auipc	ra,0x5
    800003b0:	7c6080e7          	jalr	1990(ra) # 80005b72 <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00005097          	auipc	ra,0x5
    800003c0:	7b6080e7          	jalr	1974(ra) # 80005b72 <printf>
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
    800003e0:	98e080e7          	jalr	-1650(ra) # 80000d6a <procinit>
    trapinit();      // trap vectors
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	684080e7          	jalr	1668(ra) # 80001a68 <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00001097          	auipc	ra,0x1
    800003f0:	6a4080e7          	jalr	1700(ra) # 80001a90 <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	bf6080e7          	jalr	-1034(ra) # 80004fea <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	c04080e7          	jalr	-1020(ra) # 80005000 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	ddc080e7          	jalr	-548(ra) # 800021e0 <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	46c080e7          	jalr	1132(ra) # 80002878 <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	416080e7          	jalr	1046(ra) # 8000382a <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	d06080e7          	jalr	-762(ra) # 80005122 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	cf8080e7          	jalr	-776(ra) # 8000111c <userinit>
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
  asm volatile("csrw satp, %0" : : "r" (x));
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
    80000492:	69a080e7          	jalr	1690(ra) # 80005b28 <panic>
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
    8000058a:	5a2080e7          	jalr	1442(ra) # 80005b28 <panic>
      panic("mappages: remap");
    8000058e:	00008517          	auipc	a0,0x8
    80000592:	ada50513          	addi	a0,a0,-1318 # 80008068 <etext+0x68>
    80000596:	00005097          	auipc	ra,0x5
    8000059a:	592080e7          	jalr	1426(ra) # 80005b28 <panic>
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
    80000614:	518080e7          	jalr	1304(ra) # 80005b28 <panic>

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
    80000760:	3cc080e7          	jalr	972(ra) # 80005b28 <panic>
      panic("uvmunmap: walk");
    80000764:	00008517          	auipc	a0,0x8
    80000768:	93450513          	addi	a0,a0,-1740 # 80008098 <etext+0x98>
    8000076c:	00005097          	auipc	ra,0x5
    80000770:	3bc080e7          	jalr	956(ra) # 80005b28 <panic>
      panic("uvmunmap: not mapped");
    80000774:	00008517          	auipc	a0,0x8
    80000778:	93450513          	addi	a0,a0,-1740 # 800080a8 <etext+0xa8>
    8000077c:	00005097          	auipc	ra,0x5
    80000780:	3ac080e7          	jalr	940(ra) # 80005b28 <panic>
      panic("uvmunmap: not a leaf");
    80000784:	00008517          	auipc	a0,0x8
    80000788:	93c50513          	addi	a0,a0,-1732 # 800080c0 <etext+0xc0>
    8000078c:	00005097          	auipc	ra,0x5
    80000790:	39c080e7          	jalr	924(ra) # 80005b28 <panic>
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
    8000086e:	2be080e7          	jalr	702(ra) # 80005b28 <panic>

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
    800009b0:	17c080e7          	jalr	380(ra) # 80005b28 <panic>
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
    80000a8c:	0a0080e7          	jalr	160(ra) # 80005b28 <panic>
      panic("uvmcopy: page not present");
    80000a90:	00007517          	auipc	a0,0x7
    80000a94:	69850513          	addi	a0,a0,1688 # 80008128 <etext+0x128>
    80000a98:	00005097          	auipc	ra,0x5
    80000a9c:	090080e7          	jalr	144(ra) # 80005b28 <panic>
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
    80000b06:	026080e7          	jalr	38(ra) # 80005b28 <panic>

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
void
proc_mapstacks(pagetable_t kpgtbl) {
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
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cec:	00008497          	auipc	s1,0x8
    80000cf0:	79448493          	addi	s1,s1,1940 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000cf4:	8b26                	mv	s6,s1
    80000cf6:	00007a97          	auipc	s5,0x7
    80000cfa:	30aa8a93          	addi	s5,s5,778 # 80008000 <etext>
    80000cfe:	01000937          	lui	s2,0x1000
    80000d02:	197d                	addi	s2,s2,-1
    80000d04:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d06:	0000ea17          	auipc	s4,0xe
    80000d0a:	17aa0a13          	addi	s4,s4,378 # 8000ee80 <tickslock>
    char *pa = kalloc();
    80000d0e:	fffff097          	auipc	ra,0xfffff
    80000d12:	40a080e7          	jalr	1034(ra) # 80000118 <kalloc>
    80000d16:	862a                	mv	a2,a0
    if(pa == 0)
    80000d18:	c129                	beqz	a0,80000d5a <proc_mapstacks+0x84>
    uint64 va = KSTACK((int) (p - proc));
    80000d1a:	416485b3          	sub	a1,s1,s6
    80000d1e:	858d                	srai	a1,a1,0x3
    80000d20:	000ab783          	ld	a5,0(s5)
    80000d24:	02f585b3          	mul	a1,a1,a5
    80000d28:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d2c:	4719                	li	a4,6
    80000d2e:	6685                	lui	a3,0x1
    80000d30:	40b905b3          	sub	a1,s2,a1
    80000d34:	854e                	mv	a0,s3
    80000d36:	00000097          	auipc	ra,0x0
    80000d3a:	8b2080e7          	jalr	-1870(ra) # 800005e8 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d3e:	16848493          	addi	s1,s1,360
    80000d42:	fd4496e3          	bne	s1,s4,80000d0e <proc_mapstacks+0x38>
  }
}
    80000d46:	70e2                	ld	ra,56(sp)
    80000d48:	7442                	ld	s0,48(sp)
    80000d4a:	74a2                	ld	s1,40(sp)
    80000d4c:	7902                	ld	s2,32(sp)
    80000d4e:	69e2                	ld	s3,24(sp)
    80000d50:	6a42                	ld	s4,16(sp)
    80000d52:	6aa2                	ld	s5,8(sp)
    80000d54:	6b02                	ld	s6,0(sp)
    80000d56:	6121                	addi	sp,sp,64
    80000d58:	8082                	ret
      panic("kalloc");
    80000d5a:	00007517          	auipc	a0,0x7
    80000d5e:	3fe50513          	addi	a0,a0,1022 # 80008158 <etext+0x158>
    80000d62:	00005097          	auipc	ra,0x5
    80000d66:	dc6080e7          	jalr	-570(ra) # 80005b28 <panic>

0000000080000d6a <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000d6a:	7139                	addi	sp,sp,-64
    80000d6c:	fc06                	sd	ra,56(sp)
    80000d6e:	f822                	sd	s0,48(sp)
    80000d70:	f426                	sd	s1,40(sp)
    80000d72:	f04a                	sd	s2,32(sp)
    80000d74:	ec4e                	sd	s3,24(sp)
    80000d76:	e852                	sd	s4,16(sp)
    80000d78:	e456                	sd	s5,8(sp)
    80000d7a:	e05a                	sd	s6,0(sp)
    80000d7c:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d7e:	00007597          	auipc	a1,0x7
    80000d82:	3e258593          	addi	a1,a1,994 # 80008160 <etext+0x160>
    80000d86:	00008517          	auipc	a0,0x8
    80000d8a:	2ca50513          	addi	a0,a0,714 # 80009050 <pid_lock>
    80000d8e:	00005097          	auipc	ra,0x5
    80000d92:	254080e7          	jalr	596(ra) # 80005fe2 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d96:	00007597          	auipc	a1,0x7
    80000d9a:	3d258593          	addi	a1,a1,978 # 80008168 <etext+0x168>
    80000d9e:	00008517          	auipc	a0,0x8
    80000da2:	2ca50513          	addi	a0,a0,714 # 80009068 <wait_lock>
    80000da6:	00005097          	auipc	ra,0x5
    80000daa:	23c080e7          	jalr	572(ra) # 80005fe2 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dae:	00008497          	auipc	s1,0x8
    80000db2:	6d248493          	addi	s1,s1,1746 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000db6:	00007b17          	auipc	s6,0x7
    80000dba:	3c2b0b13          	addi	s6,s6,962 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000dbe:	8aa6                	mv	s5,s1
    80000dc0:	00007a17          	auipc	s4,0x7
    80000dc4:	240a0a13          	addi	s4,s4,576 # 80008000 <etext>
    80000dc8:	01000937          	lui	s2,0x1000
    80000dcc:	197d                	addi	s2,s2,-1
    80000dce:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dd0:	0000e997          	auipc	s3,0xe
    80000dd4:	0b098993          	addi	s3,s3,176 # 8000ee80 <tickslock>
      initlock(&p->lock, "proc");
    80000dd8:	85da                	mv	a1,s6
    80000dda:	8526                	mv	a0,s1
    80000ddc:	00005097          	auipc	ra,0x5
    80000de0:	206080e7          	jalr	518(ra) # 80005fe2 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000de4:	415487b3          	sub	a5,s1,s5
    80000de8:	878d                	srai	a5,a5,0x3
    80000dea:	000a3703          	ld	a4,0(s4)
    80000dee:	02e787b3          	mul	a5,a5,a4
    80000df2:	00d7979b          	slliw	a5,a5,0xd
    80000df6:	40f907b3          	sub	a5,s2,a5
    80000dfa:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dfc:	16848493          	addi	s1,s1,360
    80000e00:	fd349ce3          	bne	s1,s3,80000dd8 <procinit+0x6e>
  }
}
    80000e04:	70e2                	ld	ra,56(sp)
    80000e06:	7442                	ld	s0,48(sp)
    80000e08:	74a2                	ld	s1,40(sp)
    80000e0a:	7902                	ld	s2,32(sp)
    80000e0c:	69e2                	ld	s3,24(sp)
    80000e0e:	6a42                	ld	s4,16(sp)
    80000e10:	6aa2                	ld	s5,8(sp)
    80000e12:	6b02                	ld	s6,0(sp)
    80000e14:	6121                	addi	sp,sp,64
    80000e16:	8082                	ret

0000000080000e18 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e18:	1141                	addi	sp,sp,-16
    80000e1a:	e422                	sd	s0,8(sp)
    80000e1c:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e1e:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e20:	2501                	sext.w	a0,a0
    80000e22:	6422                	ld	s0,8(sp)
    80000e24:	0141                	addi	sp,sp,16
    80000e26:	8082                	ret

0000000080000e28 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e28:	1141                	addi	sp,sp,-16
    80000e2a:	e422                	sd	s0,8(sp)
    80000e2c:	0800                	addi	s0,sp,16
    80000e2e:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e30:	2781                	sext.w	a5,a5
    80000e32:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e34:	00008517          	auipc	a0,0x8
    80000e38:	24c50513          	addi	a0,a0,588 # 80009080 <cpus>
    80000e3c:	953e                	add	a0,a0,a5
    80000e3e:	6422                	ld	s0,8(sp)
    80000e40:	0141                	addi	sp,sp,16
    80000e42:	8082                	ret

0000000080000e44 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e44:	1101                	addi	sp,sp,-32
    80000e46:	ec06                	sd	ra,24(sp)
    80000e48:	e822                	sd	s0,16(sp)
    80000e4a:	e426                	sd	s1,8(sp)
    80000e4c:	1000                	addi	s0,sp,32
  push_off();
    80000e4e:	00005097          	auipc	ra,0x5
    80000e52:	1d8080e7          	jalr	472(ra) # 80006026 <push_off>
    80000e56:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e58:	2781                	sext.w	a5,a5
    80000e5a:	079e                	slli	a5,a5,0x7
    80000e5c:	00008717          	auipc	a4,0x8
    80000e60:	1f470713          	addi	a4,a4,500 # 80009050 <pid_lock>
    80000e64:	97ba                	add	a5,a5,a4
    80000e66:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e68:	00005097          	auipc	ra,0x5
    80000e6c:	25e080e7          	jalr	606(ra) # 800060c6 <pop_off>
  return p;
}
    80000e70:	8526                	mv	a0,s1
    80000e72:	60e2                	ld	ra,24(sp)
    80000e74:	6442                	ld	s0,16(sp)
    80000e76:	64a2                	ld	s1,8(sp)
    80000e78:	6105                	addi	sp,sp,32
    80000e7a:	8082                	ret

0000000080000e7c <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e7c:	1141                	addi	sp,sp,-16
    80000e7e:	e406                	sd	ra,8(sp)
    80000e80:	e022                	sd	s0,0(sp)
    80000e82:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e84:	00000097          	auipc	ra,0x0
    80000e88:	fc0080e7          	jalr	-64(ra) # 80000e44 <myproc>
    80000e8c:	00005097          	auipc	ra,0x5
    80000e90:	29a080e7          	jalr	666(ra) # 80006126 <release>

  if (first) {
    80000e94:	00008797          	auipc	a5,0x8
    80000e98:	9cc7a783          	lw	a5,-1588(a5) # 80008860 <first.1674>
    80000e9c:	eb89                	bnez	a5,80000eae <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000e9e:	00001097          	auipc	ra,0x1
    80000ea2:	c0a080e7          	jalr	-1014(ra) # 80001aa8 <usertrapret>
}
    80000ea6:	60a2                	ld	ra,8(sp)
    80000ea8:	6402                	ld	s0,0(sp)
    80000eaa:	0141                	addi	sp,sp,16
    80000eac:	8082                	ret
    first = 0;
    80000eae:	00008797          	auipc	a5,0x8
    80000eb2:	9a07a923          	sw	zero,-1614(a5) # 80008860 <first.1674>
    fsinit(ROOTDEV);
    80000eb6:	4505                	li	a0,1
    80000eb8:	00002097          	auipc	ra,0x2
    80000ebc:	940080e7          	jalr	-1728(ra) # 800027f8 <fsinit>
    80000ec0:	bff9                	j	80000e9e <forkret+0x22>

0000000080000ec2 <allocpid>:
allocpid() {
    80000ec2:	1101                	addi	sp,sp,-32
    80000ec4:	ec06                	sd	ra,24(sp)
    80000ec6:	e822                	sd	s0,16(sp)
    80000ec8:	e426                	sd	s1,8(sp)
    80000eca:	e04a                	sd	s2,0(sp)
    80000ecc:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ece:	00008917          	auipc	s2,0x8
    80000ed2:	18290913          	addi	s2,s2,386 # 80009050 <pid_lock>
    80000ed6:	854a                	mv	a0,s2
    80000ed8:	00005097          	auipc	ra,0x5
    80000edc:	19a080e7          	jalr	410(ra) # 80006072 <acquire>
  pid = nextpid;
    80000ee0:	00008797          	auipc	a5,0x8
    80000ee4:	98478793          	addi	a5,a5,-1660 # 80008864 <nextpid>
    80000ee8:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000eea:	0014871b          	addiw	a4,s1,1
    80000eee:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000ef0:	854a                	mv	a0,s2
    80000ef2:	00005097          	auipc	ra,0x5
    80000ef6:	234080e7          	jalr	564(ra) # 80006126 <release>
}
    80000efa:	8526                	mv	a0,s1
    80000efc:	60e2                	ld	ra,24(sp)
    80000efe:	6442                	ld	s0,16(sp)
    80000f00:	64a2                	ld	s1,8(sp)
    80000f02:	6902                	ld	s2,0(sp)
    80000f04:	6105                	addi	sp,sp,32
    80000f06:	8082                	ret

0000000080000f08 <proc_pagetable>:
{
    80000f08:	1101                	addi	sp,sp,-32
    80000f0a:	ec06                	sd	ra,24(sp)
    80000f0c:	e822                	sd	s0,16(sp)
    80000f0e:	e426                	sd	s1,8(sp)
    80000f10:	e04a                	sd	s2,0(sp)
    80000f12:	1000                	addi	s0,sp,32
    80000f14:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f16:	00000097          	auipc	ra,0x0
    80000f1a:	8bc080e7          	jalr	-1860(ra) # 800007d2 <uvmcreate>
    80000f1e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f20:	c121                	beqz	a0,80000f60 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f22:	4729                	li	a4,10
    80000f24:	00006697          	auipc	a3,0x6
    80000f28:	0dc68693          	addi	a3,a3,220 # 80007000 <_trampoline>
    80000f2c:	6605                	lui	a2,0x1
    80000f2e:	040005b7          	lui	a1,0x4000
    80000f32:	15fd                	addi	a1,a1,-1
    80000f34:	05b2                	slli	a1,a1,0xc
    80000f36:	fffff097          	auipc	ra,0xfffff
    80000f3a:	612080e7          	jalr	1554(ra) # 80000548 <mappages>
    80000f3e:	02054863          	bltz	a0,80000f6e <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f42:	4719                	li	a4,6
    80000f44:	05893683          	ld	a3,88(s2)
    80000f48:	6605                	lui	a2,0x1
    80000f4a:	020005b7          	lui	a1,0x2000
    80000f4e:	15fd                	addi	a1,a1,-1
    80000f50:	05b6                	slli	a1,a1,0xd
    80000f52:	8526                	mv	a0,s1
    80000f54:	fffff097          	auipc	ra,0xfffff
    80000f58:	5f4080e7          	jalr	1524(ra) # 80000548 <mappages>
    80000f5c:	02054163          	bltz	a0,80000f7e <proc_pagetable+0x76>
}
    80000f60:	8526                	mv	a0,s1
    80000f62:	60e2                	ld	ra,24(sp)
    80000f64:	6442                	ld	s0,16(sp)
    80000f66:	64a2                	ld	s1,8(sp)
    80000f68:	6902                	ld	s2,0(sp)
    80000f6a:	6105                	addi	sp,sp,32
    80000f6c:	8082                	ret
    uvmfree(pagetable, 0);
    80000f6e:	4581                	li	a1,0
    80000f70:	8526                	mv	a0,s1
    80000f72:	00000097          	auipc	ra,0x0
    80000f76:	a5c080e7          	jalr	-1444(ra) # 800009ce <uvmfree>
    return 0;
    80000f7a:	4481                	li	s1,0
    80000f7c:	b7d5                	j	80000f60 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f7e:	4681                	li	a3,0
    80000f80:	4605                	li	a2,1
    80000f82:	040005b7          	lui	a1,0x4000
    80000f86:	15fd                	addi	a1,a1,-1
    80000f88:	05b2                	slli	a1,a1,0xc
    80000f8a:	8526                	mv	a0,s1
    80000f8c:	fffff097          	auipc	ra,0xfffff
    80000f90:	782080e7          	jalr	1922(ra) # 8000070e <uvmunmap>
    uvmfree(pagetable, 0);
    80000f94:	4581                	li	a1,0
    80000f96:	8526                	mv	a0,s1
    80000f98:	00000097          	auipc	ra,0x0
    80000f9c:	a36080e7          	jalr	-1482(ra) # 800009ce <uvmfree>
    return 0;
    80000fa0:	4481                	li	s1,0
    80000fa2:	bf7d                	j	80000f60 <proc_pagetable+0x58>

0000000080000fa4 <proc_freepagetable>:
{
    80000fa4:	1101                	addi	sp,sp,-32
    80000fa6:	ec06                	sd	ra,24(sp)
    80000fa8:	e822                	sd	s0,16(sp)
    80000faa:	e426                	sd	s1,8(sp)
    80000fac:	e04a                	sd	s2,0(sp)
    80000fae:	1000                	addi	s0,sp,32
    80000fb0:	84aa                	mv	s1,a0
    80000fb2:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fb4:	4681                	li	a3,0
    80000fb6:	4605                	li	a2,1
    80000fb8:	040005b7          	lui	a1,0x4000
    80000fbc:	15fd                	addi	a1,a1,-1
    80000fbe:	05b2                	slli	a1,a1,0xc
    80000fc0:	fffff097          	auipc	ra,0xfffff
    80000fc4:	74e080e7          	jalr	1870(ra) # 8000070e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fc8:	4681                	li	a3,0
    80000fca:	4605                	li	a2,1
    80000fcc:	020005b7          	lui	a1,0x2000
    80000fd0:	15fd                	addi	a1,a1,-1
    80000fd2:	05b6                	slli	a1,a1,0xd
    80000fd4:	8526                	mv	a0,s1
    80000fd6:	fffff097          	auipc	ra,0xfffff
    80000fda:	738080e7          	jalr	1848(ra) # 8000070e <uvmunmap>
  uvmfree(pagetable, sz);
    80000fde:	85ca                	mv	a1,s2
    80000fe0:	8526                	mv	a0,s1
    80000fe2:	00000097          	auipc	ra,0x0
    80000fe6:	9ec080e7          	jalr	-1556(ra) # 800009ce <uvmfree>
}
    80000fea:	60e2                	ld	ra,24(sp)
    80000fec:	6442                	ld	s0,16(sp)
    80000fee:	64a2                	ld	s1,8(sp)
    80000ff0:	6902                	ld	s2,0(sp)
    80000ff2:	6105                	addi	sp,sp,32
    80000ff4:	8082                	ret

0000000080000ff6 <freeproc>:
{
    80000ff6:	1101                	addi	sp,sp,-32
    80000ff8:	ec06                	sd	ra,24(sp)
    80000ffa:	e822                	sd	s0,16(sp)
    80000ffc:	e426                	sd	s1,8(sp)
    80000ffe:	1000                	addi	s0,sp,32
    80001000:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001002:	6d28                	ld	a0,88(a0)
    80001004:	c509                	beqz	a0,8000100e <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001006:	fffff097          	auipc	ra,0xfffff
    8000100a:	016080e7          	jalr	22(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000100e:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001012:	68a8                	ld	a0,80(s1)
    80001014:	c511                	beqz	a0,80001020 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001016:	64ac                	ld	a1,72(s1)
    80001018:	00000097          	auipc	ra,0x0
    8000101c:	f8c080e7          	jalr	-116(ra) # 80000fa4 <proc_freepagetable>
  p->pagetable = 0;
    80001020:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001024:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001028:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000102c:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001030:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001034:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001038:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000103c:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001040:	0004ac23          	sw	zero,24(s1)
}
    80001044:	60e2                	ld	ra,24(sp)
    80001046:	6442                	ld	s0,16(sp)
    80001048:	64a2                	ld	s1,8(sp)
    8000104a:	6105                	addi	sp,sp,32
    8000104c:	8082                	ret

000000008000104e <allocproc>:
{
    8000104e:	1101                	addi	sp,sp,-32
    80001050:	ec06                	sd	ra,24(sp)
    80001052:	e822                	sd	s0,16(sp)
    80001054:	e426                	sd	s1,8(sp)
    80001056:	e04a                	sd	s2,0(sp)
    80001058:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000105a:	00008497          	auipc	s1,0x8
    8000105e:	42648493          	addi	s1,s1,1062 # 80009480 <proc>
    80001062:	0000e917          	auipc	s2,0xe
    80001066:	e1e90913          	addi	s2,s2,-482 # 8000ee80 <tickslock>
    acquire(&p->lock);
    8000106a:	8526                	mv	a0,s1
    8000106c:	00005097          	auipc	ra,0x5
    80001070:	006080e7          	jalr	6(ra) # 80006072 <acquire>
    if(p->state == UNUSED) {
    80001074:	4c9c                	lw	a5,24(s1)
    80001076:	cf81                	beqz	a5,8000108e <allocproc+0x40>
      release(&p->lock);
    80001078:	8526                	mv	a0,s1
    8000107a:	00005097          	auipc	ra,0x5
    8000107e:	0ac080e7          	jalr	172(ra) # 80006126 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001082:	16848493          	addi	s1,s1,360
    80001086:	ff2492e3          	bne	s1,s2,8000106a <allocproc+0x1c>
  return 0;
    8000108a:	4481                	li	s1,0
    8000108c:	a889                	j	800010de <allocproc+0x90>
  p->pid = allocpid();
    8000108e:	00000097          	auipc	ra,0x0
    80001092:	e34080e7          	jalr	-460(ra) # 80000ec2 <allocpid>
    80001096:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001098:	4785                	li	a5,1
    8000109a:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    8000109c:	fffff097          	auipc	ra,0xfffff
    800010a0:	07c080e7          	jalr	124(ra) # 80000118 <kalloc>
    800010a4:	892a                	mv	s2,a0
    800010a6:	eca8                	sd	a0,88(s1)
    800010a8:	c131                	beqz	a0,800010ec <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010aa:	8526                	mv	a0,s1
    800010ac:	00000097          	auipc	ra,0x0
    800010b0:	e5c080e7          	jalr	-420(ra) # 80000f08 <proc_pagetable>
    800010b4:	892a                	mv	s2,a0
    800010b6:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010b8:	c531                	beqz	a0,80001104 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010ba:	07000613          	li	a2,112
    800010be:	4581                	li	a1,0
    800010c0:	06048513          	addi	a0,s1,96
    800010c4:	fffff097          	auipc	ra,0xfffff
    800010c8:	0b4080e7          	jalr	180(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    800010cc:	00000797          	auipc	a5,0x0
    800010d0:	db078793          	addi	a5,a5,-592 # 80000e7c <forkret>
    800010d4:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010d6:	60bc                	ld	a5,64(s1)
    800010d8:	6705                	lui	a4,0x1
    800010da:	97ba                	add	a5,a5,a4
    800010dc:	f4bc                	sd	a5,104(s1)
}
    800010de:	8526                	mv	a0,s1
    800010e0:	60e2                	ld	ra,24(sp)
    800010e2:	6442                	ld	s0,16(sp)
    800010e4:	64a2                	ld	s1,8(sp)
    800010e6:	6902                	ld	s2,0(sp)
    800010e8:	6105                	addi	sp,sp,32
    800010ea:	8082                	ret
    freeproc(p);
    800010ec:	8526                	mv	a0,s1
    800010ee:	00000097          	auipc	ra,0x0
    800010f2:	f08080e7          	jalr	-248(ra) # 80000ff6 <freeproc>
    release(&p->lock);
    800010f6:	8526                	mv	a0,s1
    800010f8:	00005097          	auipc	ra,0x5
    800010fc:	02e080e7          	jalr	46(ra) # 80006126 <release>
    return 0;
    80001100:	84ca                	mv	s1,s2
    80001102:	bff1                	j	800010de <allocproc+0x90>
    freeproc(p);
    80001104:	8526                	mv	a0,s1
    80001106:	00000097          	auipc	ra,0x0
    8000110a:	ef0080e7          	jalr	-272(ra) # 80000ff6 <freeproc>
    release(&p->lock);
    8000110e:	8526                	mv	a0,s1
    80001110:	00005097          	auipc	ra,0x5
    80001114:	016080e7          	jalr	22(ra) # 80006126 <release>
    return 0;
    80001118:	84ca                	mv	s1,s2
    8000111a:	b7d1                	j	800010de <allocproc+0x90>

000000008000111c <userinit>:
{
    8000111c:	1101                	addi	sp,sp,-32
    8000111e:	ec06                	sd	ra,24(sp)
    80001120:	e822                	sd	s0,16(sp)
    80001122:	e426                	sd	s1,8(sp)
    80001124:	1000                	addi	s0,sp,32
  p = allocproc();
    80001126:	00000097          	auipc	ra,0x0
    8000112a:	f28080e7          	jalr	-216(ra) # 8000104e <allocproc>
    8000112e:	84aa                	mv	s1,a0
  initproc = p;
    80001130:	00008797          	auipc	a5,0x8
    80001134:	eea7b023          	sd	a0,-288(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001138:	03400613          	li	a2,52
    8000113c:	00007597          	auipc	a1,0x7
    80001140:	73458593          	addi	a1,a1,1844 # 80008870 <initcode>
    80001144:	6928                	ld	a0,80(a0)
    80001146:	fffff097          	auipc	ra,0xfffff
    8000114a:	6ba080e7          	jalr	1722(ra) # 80000800 <uvminit>
  p->sz = PGSIZE;
    8000114e:	6785                	lui	a5,0x1
    80001150:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001152:	6cb8                	ld	a4,88(s1)
    80001154:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001158:	6cb8                	ld	a4,88(s1)
    8000115a:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000115c:	4641                	li	a2,16
    8000115e:	00007597          	auipc	a1,0x7
    80001162:	02258593          	addi	a1,a1,34 # 80008180 <etext+0x180>
    80001166:	15848513          	addi	a0,s1,344
    8000116a:	fffff097          	auipc	ra,0xfffff
    8000116e:	160080e7          	jalr	352(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    80001172:	00007517          	auipc	a0,0x7
    80001176:	01e50513          	addi	a0,a0,30 # 80008190 <etext+0x190>
    8000117a:	00002097          	auipc	ra,0x2
    8000117e:	0ac080e7          	jalr	172(ra) # 80003226 <namei>
    80001182:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001186:	478d                	li	a5,3
    80001188:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000118a:	8526                	mv	a0,s1
    8000118c:	00005097          	auipc	ra,0x5
    80001190:	f9a080e7          	jalr	-102(ra) # 80006126 <release>
}
    80001194:	60e2                	ld	ra,24(sp)
    80001196:	6442                	ld	s0,16(sp)
    80001198:	64a2                	ld	s1,8(sp)
    8000119a:	6105                	addi	sp,sp,32
    8000119c:	8082                	ret

000000008000119e <growproc>:
{
    8000119e:	1101                	addi	sp,sp,-32
    800011a0:	ec06                	sd	ra,24(sp)
    800011a2:	e822                	sd	s0,16(sp)
    800011a4:	e426                	sd	s1,8(sp)
    800011a6:	e04a                	sd	s2,0(sp)
    800011a8:	1000                	addi	s0,sp,32
    800011aa:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011ac:	00000097          	auipc	ra,0x0
    800011b0:	c98080e7          	jalr	-872(ra) # 80000e44 <myproc>
    800011b4:	892a                	mv	s2,a0
  sz = p->sz;
    800011b6:	652c                	ld	a1,72(a0)
    800011b8:	0005861b          	sext.w	a2,a1
  if(n > 0){
    800011bc:	00904f63          	bgtz	s1,800011da <growproc+0x3c>
  } else if(n < 0){
    800011c0:	0204cc63          	bltz	s1,800011f8 <growproc+0x5a>
  p->sz = sz;
    800011c4:	1602                	slli	a2,a2,0x20
    800011c6:	9201                	srli	a2,a2,0x20
    800011c8:	04c93423          	sd	a2,72(s2)
  return 0;
    800011cc:	4501                	li	a0,0
}
    800011ce:	60e2                	ld	ra,24(sp)
    800011d0:	6442                	ld	s0,16(sp)
    800011d2:	64a2                	ld	s1,8(sp)
    800011d4:	6902                	ld	s2,0(sp)
    800011d6:	6105                	addi	sp,sp,32
    800011d8:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800011da:	9e25                	addw	a2,a2,s1
    800011dc:	1602                	slli	a2,a2,0x20
    800011de:	9201                	srli	a2,a2,0x20
    800011e0:	1582                	slli	a1,a1,0x20
    800011e2:	9181                	srli	a1,a1,0x20
    800011e4:	6928                	ld	a0,80(a0)
    800011e6:	fffff097          	auipc	ra,0xfffff
    800011ea:	6d4080e7          	jalr	1748(ra) # 800008ba <uvmalloc>
    800011ee:	0005061b          	sext.w	a2,a0
    800011f2:	fa69                	bnez	a2,800011c4 <growproc+0x26>
      return -1;
    800011f4:	557d                	li	a0,-1
    800011f6:	bfe1                	j	800011ce <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800011f8:	9e25                	addw	a2,a2,s1
    800011fa:	1602                	slli	a2,a2,0x20
    800011fc:	9201                	srli	a2,a2,0x20
    800011fe:	1582                	slli	a1,a1,0x20
    80001200:	9181                	srli	a1,a1,0x20
    80001202:	6928                	ld	a0,80(a0)
    80001204:	fffff097          	auipc	ra,0xfffff
    80001208:	66e080e7          	jalr	1646(ra) # 80000872 <uvmdealloc>
    8000120c:	0005061b          	sext.w	a2,a0
    80001210:	bf55                	j	800011c4 <growproc+0x26>

0000000080001212 <fork>:
{
    80001212:	7179                	addi	sp,sp,-48
    80001214:	f406                	sd	ra,40(sp)
    80001216:	f022                	sd	s0,32(sp)
    80001218:	ec26                	sd	s1,24(sp)
    8000121a:	e84a                	sd	s2,16(sp)
    8000121c:	e44e                	sd	s3,8(sp)
    8000121e:	e052                	sd	s4,0(sp)
    80001220:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001222:	00000097          	auipc	ra,0x0
    80001226:	c22080e7          	jalr	-990(ra) # 80000e44 <myproc>
    8000122a:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    8000122c:	00000097          	auipc	ra,0x0
    80001230:	e22080e7          	jalr	-478(ra) # 8000104e <allocproc>
    80001234:	10050b63          	beqz	a0,8000134a <fork+0x138>
    80001238:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000123a:	04893603          	ld	a2,72(s2)
    8000123e:	692c                	ld	a1,80(a0)
    80001240:	05093503          	ld	a0,80(s2)
    80001244:	fffff097          	auipc	ra,0xfffff
    80001248:	7c2080e7          	jalr	1986(ra) # 80000a06 <uvmcopy>
    8000124c:	04054663          	bltz	a0,80001298 <fork+0x86>
  np->sz = p->sz;
    80001250:	04893783          	ld	a5,72(s2)
    80001254:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80001258:	05893683          	ld	a3,88(s2)
    8000125c:	87b6                	mv	a5,a3
    8000125e:	0589b703          	ld	a4,88(s3)
    80001262:	12068693          	addi	a3,a3,288
    80001266:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000126a:	6788                	ld	a0,8(a5)
    8000126c:	6b8c                	ld	a1,16(a5)
    8000126e:	6f90                	ld	a2,24(a5)
    80001270:	01073023          	sd	a6,0(a4)
    80001274:	e708                	sd	a0,8(a4)
    80001276:	eb0c                	sd	a1,16(a4)
    80001278:	ef10                	sd	a2,24(a4)
    8000127a:	02078793          	addi	a5,a5,32
    8000127e:	02070713          	addi	a4,a4,32
    80001282:	fed792e3          	bne	a5,a3,80001266 <fork+0x54>
  np->trapframe->a0 = 0;
    80001286:	0589b783          	ld	a5,88(s3)
    8000128a:	0607b823          	sd	zero,112(a5)
    8000128e:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    80001292:	15000a13          	li	s4,336
    80001296:	a03d                	j	800012c4 <fork+0xb2>
    freeproc(np);
    80001298:	854e                	mv	a0,s3
    8000129a:	00000097          	auipc	ra,0x0
    8000129e:	d5c080e7          	jalr	-676(ra) # 80000ff6 <freeproc>
    release(&np->lock);
    800012a2:	854e                	mv	a0,s3
    800012a4:	00005097          	auipc	ra,0x5
    800012a8:	e82080e7          	jalr	-382(ra) # 80006126 <release>
    return -1;
    800012ac:	5a7d                	li	s4,-1
    800012ae:	a069                	j	80001338 <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    800012b0:	00002097          	auipc	ra,0x2
    800012b4:	60c080e7          	jalr	1548(ra) # 800038bc <filedup>
    800012b8:	009987b3          	add	a5,s3,s1
    800012bc:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    800012be:	04a1                	addi	s1,s1,8
    800012c0:	01448763          	beq	s1,s4,800012ce <fork+0xbc>
    if(p->ofile[i])
    800012c4:	009907b3          	add	a5,s2,s1
    800012c8:	6388                	ld	a0,0(a5)
    800012ca:	f17d                	bnez	a0,800012b0 <fork+0x9e>
    800012cc:	bfcd                	j	800012be <fork+0xac>
  np->cwd = idup(p->cwd);
    800012ce:	15093503          	ld	a0,336(s2)
    800012d2:	00001097          	auipc	ra,0x1
    800012d6:	760080e7          	jalr	1888(ra) # 80002a32 <idup>
    800012da:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800012de:	4641                	li	a2,16
    800012e0:	15890593          	addi	a1,s2,344
    800012e4:	15898513          	addi	a0,s3,344
    800012e8:	fffff097          	auipc	ra,0xfffff
    800012ec:	fe2080e7          	jalr	-30(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    800012f0:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    800012f4:	854e                	mv	a0,s3
    800012f6:	00005097          	auipc	ra,0x5
    800012fa:	e30080e7          	jalr	-464(ra) # 80006126 <release>
  acquire(&wait_lock);
    800012fe:	00008497          	auipc	s1,0x8
    80001302:	d6a48493          	addi	s1,s1,-662 # 80009068 <wait_lock>
    80001306:	8526                	mv	a0,s1
    80001308:	00005097          	auipc	ra,0x5
    8000130c:	d6a080e7          	jalr	-662(ra) # 80006072 <acquire>
  np->parent = p;
    80001310:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    80001314:	8526                	mv	a0,s1
    80001316:	00005097          	auipc	ra,0x5
    8000131a:	e10080e7          	jalr	-496(ra) # 80006126 <release>
  acquire(&np->lock);
    8000131e:	854e                	mv	a0,s3
    80001320:	00005097          	auipc	ra,0x5
    80001324:	d52080e7          	jalr	-686(ra) # 80006072 <acquire>
  np->state = RUNNABLE;
    80001328:	478d                	li	a5,3
    8000132a:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    8000132e:	854e                	mv	a0,s3
    80001330:	00005097          	auipc	ra,0x5
    80001334:	df6080e7          	jalr	-522(ra) # 80006126 <release>
}
    80001338:	8552                	mv	a0,s4
    8000133a:	70a2                	ld	ra,40(sp)
    8000133c:	7402                	ld	s0,32(sp)
    8000133e:	64e2                	ld	s1,24(sp)
    80001340:	6942                	ld	s2,16(sp)
    80001342:	69a2                	ld	s3,8(sp)
    80001344:	6a02                	ld	s4,0(sp)
    80001346:	6145                	addi	sp,sp,48
    80001348:	8082                	ret
    return -1;
    8000134a:	5a7d                	li	s4,-1
    8000134c:	b7f5                	j	80001338 <fork+0x126>

000000008000134e <scheduler>:
{
    8000134e:	7139                	addi	sp,sp,-64
    80001350:	fc06                	sd	ra,56(sp)
    80001352:	f822                	sd	s0,48(sp)
    80001354:	f426                	sd	s1,40(sp)
    80001356:	f04a                	sd	s2,32(sp)
    80001358:	ec4e                	sd	s3,24(sp)
    8000135a:	e852                	sd	s4,16(sp)
    8000135c:	e456                	sd	s5,8(sp)
    8000135e:	e05a                	sd	s6,0(sp)
    80001360:	0080                	addi	s0,sp,64
    80001362:	8792                	mv	a5,tp
  int id = r_tp();
    80001364:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001366:	00779a93          	slli	s5,a5,0x7
    8000136a:	00008717          	auipc	a4,0x8
    8000136e:	ce670713          	addi	a4,a4,-794 # 80009050 <pid_lock>
    80001372:	9756                	add	a4,a4,s5
    80001374:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001378:	00008717          	auipc	a4,0x8
    8000137c:	d1070713          	addi	a4,a4,-752 # 80009088 <cpus+0x8>
    80001380:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001382:	498d                	li	s3,3
        p->state = RUNNING;
    80001384:	4b11                	li	s6,4
        c->proc = p;
    80001386:	079e                	slli	a5,a5,0x7
    80001388:	00008a17          	auipc	s4,0x8
    8000138c:	cc8a0a13          	addi	s4,s4,-824 # 80009050 <pid_lock>
    80001390:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001392:	0000e917          	auipc	s2,0xe
    80001396:	aee90913          	addi	s2,s2,-1298 # 8000ee80 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000139a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000139e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013a2:	10079073          	csrw	sstatus,a5
    800013a6:	00008497          	auipc	s1,0x8
    800013aa:	0da48493          	addi	s1,s1,218 # 80009480 <proc>
    800013ae:	a03d                	j	800013dc <scheduler+0x8e>
        p->state = RUNNING;
    800013b0:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800013b4:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013b8:	06048593          	addi	a1,s1,96
    800013bc:	8556                	mv	a0,s5
    800013be:	00000097          	auipc	ra,0x0
    800013c2:	640080e7          	jalr	1600(ra) # 800019fe <swtch>
        c->proc = 0;
    800013c6:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    800013ca:	8526                	mv	a0,s1
    800013cc:	00005097          	auipc	ra,0x5
    800013d0:	d5a080e7          	jalr	-678(ra) # 80006126 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013d4:	16848493          	addi	s1,s1,360
    800013d8:	fd2481e3          	beq	s1,s2,8000139a <scheduler+0x4c>
      acquire(&p->lock);
    800013dc:	8526                	mv	a0,s1
    800013de:	00005097          	auipc	ra,0x5
    800013e2:	c94080e7          	jalr	-876(ra) # 80006072 <acquire>
      if(p->state == RUNNABLE) {
    800013e6:	4c9c                	lw	a5,24(s1)
    800013e8:	ff3791e3          	bne	a5,s3,800013ca <scheduler+0x7c>
    800013ec:	b7d1                	j	800013b0 <scheduler+0x62>

00000000800013ee <sched>:
{
    800013ee:	7179                	addi	sp,sp,-48
    800013f0:	f406                	sd	ra,40(sp)
    800013f2:	f022                	sd	s0,32(sp)
    800013f4:	ec26                	sd	s1,24(sp)
    800013f6:	e84a                	sd	s2,16(sp)
    800013f8:	e44e                	sd	s3,8(sp)
    800013fa:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800013fc:	00000097          	auipc	ra,0x0
    80001400:	a48080e7          	jalr	-1464(ra) # 80000e44 <myproc>
    80001404:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001406:	00005097          	auipc	ra,0x5
    8000140a:	bf2080e7          	jalr	-1038(ra) # 80005ff8 <holding>
    8000140e:	c93d                	beqz	a0,80001484 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001410:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001412:	2781                	sext.w	a5,a5
    80001414:	079e                	slli	a5,a5,0x7
    80001416:	00008717          	auipc	a4,0x8
    8000141a:	c3a70713          	addi	a4,a4,-966 # 80009050 <pid_lock>
    8000141e:	97ba                	add	a5,a5,a4
    80001420:	0a87a703          	lw	a4,168(a5)
    80001424:	4785                	li	a5,1
    80001426:	06f71763          	bne	a4,a5,80001494 <sched+0xa6>
  if(p->state == RUNNING)
    8000142a:	4c98                	lw	a4,24(s1)
    8000142c:	4791                	li	a5,4
    8000142e:	06f70b63          	beq	a4,a5,800014a4 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001432:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001436:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001438:	efb5                	bnez	a5,800014b4 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000143a:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000143c:	00008917          	auipc	s2,0x8
    80001440:	c1490913          	addi	s2,s2,-1004 # 80009050 <pid_lock>
    80001444:	2781                	sext.w	a5,a5
    80001446:	079e                	slli	a5,a5,0x7
    80001448:	97ca                	add	a5,a5,s2
    8000144a:	0ac7a983          	lw	s3,172(a5)
    8000144e:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001450:	2781                	sext.w	a5,a5
    80001452:	079e                	slli	a5,a5,0x7
    80001454:	00008597          	auipc	a1,0x8
    80001458:	c3458593          	addi	a1,a1,-972 # 80009088 <cpus+0x8>
    8000145c:	95be                	add	a1,a1,a5
    8000145e:	06048513          	addi	a0,s1,96
    80001462:	00000097          	auipc	ra,0x0
    80001466:	59c080e7          	jalr	1436(ra) # 800019fe <swtch>
    8000146a:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000146c:	2781                	sext.w	a5,a5
    8000146e:	079e                	slli	a5,a5,0x7
    80001470:	97ca                	add	a5,a5,s2
    80001472:	0b37a623          	sw	s3,172(a5)
}
    80001476:	70a2                	ld	ra,40(sp)
    80001478:	7402                	ld	s0,32(sp)
    8000147a:	64e2                	ld	s1,24(sp)
    8000147c:	6942                	ld	s2,16(sp)
    8000147e:	69a2                	ld	s3,8(sp)
    80001480:	6145                	addi	sp,sp,48
    80001482:	8082                	ret
    panic("sched p->lock");
    80001484:	00007517          	auipc	a0,0x7
    80001488:	d1450513          	addi	a0,a0,-748 # 80008198 <etext+0x198>
    8000148c:	00004097          	auipc	ra,0x4
    80001490:	69c080e7          	jalr	1692(ra) # 80005b28 <panic>
    panic("sched locks");
    80001494:	00007517          	auipc	a0,0x7
    80001498:	d1450513          	addi	a0,a0,-748 # 800081a8 <etext+0x1a8>
    8000149c:	00004097          	auipc	ra,0x4
    800014a0:	68c080e7          	jalr	1676(ra) # 80005b28 <panic>
    panic("sched running");
    800014a4:	00007517          	auipc	a0,0x7
    800014a8:	d1450513          	addi	a0,a0,-748 # 800081b8 <etext+0x1b8>
    800014ac:	00004097          	auipc	ra,0x4
    800014b0:	67c080e7          	jalr	1660(ra) # 80005b28 <panic>
    panic("sched interruptible");
    800014b4:	00007517          	auipc	a0,0x7
    800014b8:	d1450513          	addi	a0,a0,-748 # 800081c8 <etext+0x1c8>
    800014bc:	00004097          	auipc	ra,0x4
    800014c0:	66c080e7          	jalr	1644(ra) # 80005b28 <panic>

00000000800014c4 <yield>:
{
    800014c4:	1101                	addi	sp,sp,-32
    800014c6:	ec06                	sd	ra,24(sp)
    800014c8:	e822                	sd	s0,16(sp)
    800014ca:	e426                	sd	s1,8(sp)
    800014cc:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800014ce:	00000097          	auipc	ra,0x0
    800014d2:	976080e7          	jalr	-1674(ra) # 80000e44 <myproc>
    800014d6:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800014d8:	00005097          	auipc	ra,0x5
    800014dc:	b9a080e7          	jalr	-1126(ra) # 80006072 <acquire>
  p->state = RUNNABLE;
    800014e0:	478d                	li	a5,3
    800014e2:	cc9c                	sw	a5,24(s1)
  sched();
    800014e4:	00000097          	auipc	ra,0x0
    800014e8:	f0a080e7          	jalr	-246(ra) # 800013ee <sched>
  release(&p->lock);
    800014ec:	8526                	mv	a0,s1
    800014ee:	00005097          	auipc	ra,0x5
    800014f2:	c38080e7          	jalr	-968(ra) # 80006126 <release>
}
    800014f6:	60e2                	ld	ra,24(sp)
    800014f8:	6442                	ld	s0,16(sp)
    800014fa:	64a2                	ld	s1,8(sp)
    800014fc:	6105                	addi	sp,sp,32
    800014fe:	8082                	ret

0000000080001500 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001500:	7179                	addi	sp,sp,-48
    80001502:	f406                	sd	ra,40(sp)
    80001504:	f022                	sd	s0,32(sp)
    80001506:	ec26                	sd	s1,24(sp)
    80001508:	e84a                	sd	s2,16(sp)
    8000150a:	e44e                	sd	s3,8(sp)
    8000150c:	1800                	addi	s0,sp,48
    8000150e:	89aa                	mv	s3,a0
    80001510:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001512:	00000097          	auipc	ra,0x0
    80001516:	932080e7          	jalr	-1742(ra) # 80000e44 <myproc>
    8000151a:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000151c:	00005097          	auipc	ra,0x5
    80001520:	b56080e7          	jalr	-1194(ra) # 80006072 <acquire>
  release(lk);
    80001524:	854a                	mv	a0,s2
    80001526:	00005097          	auipc	ra,0x5
    8000152a:	c00080e7          	jalr	-1024(ra) # 80006126 <release>

  // Go to sleep.
  p->chan = chan;
    8000152e:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001532:	4789                	li	a5,2
    80001534:	cc9c                	sw	a5,24(s1)

  sched();
    80001536:	00000097          	auipc	ra,0x0
    8000153a:	eb8080e7          	jalr	-328(ra) # 800013ee <sched>

  // Tidy up.
  p->chan = 0;
    8000153e:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001542:	8526                	mv	a0,s1
    80001544:	00005097          	auipc	ra,0x5
    80001548:	be2080e7          	jalr	-1054(ra) # 80006126 <release>
  acquire(lk);
    8000154c:	854a                	mv	a0,s2
    8000154e:	00005097          	auipc	ra,0x5
    80001552:	b24080e7          	jalr	-1244(ra) # 80006072 <acquire>
}
    80001556:	70a2                	ld	ra,40(sp)
    80001558:	7402                	ld	s0,32(sp)
    8000155a:	64e2                	ld	s1,24(sp)
    8000155c:	6942                	ld	s2,16(sp)
    8000155e:	69a2                	ld	s3,8(sp)
    80001560:	6145                	addi	sp,sp,48
    80001562:	8082                	ret

0000000080001564 <wait>:
{
    80001564:	715d                	addi	sp,sp,-80
    80001566:	e486                	sd	ra,72(sp)
    80001568:	e0a2                	sd	s0,64(sp)
    8000156a:	fc26                	sd	s1,56(sp)
    8000156c:	f84a                	sd	s2,48(sp)
    8000156e:	f44e                	sd	s3,40(sp)
    80001570:	f052                	sd	s4,32(sp)
    80001572:	ec56                	sd	s5,24(sp)
    80001574:	e85a                	sd	s6,16(sp)
    80001576:	e45e                	sd	s7,8(sp)
    80001578:	e062                	sd	s8,0(sp)
    8000157a:	0880                	addi	s0,sp,80
    8000157c:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000157e:	00000097          	auipc	ra,0x0
    80001582:	8c6080e7          	jalr	-1850(ra) # 80000e44 <myproc>
    80001586:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001588:	00008517          	auipc	a0,0x8
    8000158c:	ae050513          	addi	a0,a0,-1312 # 80009068 <wait_lock>
    80001590:	00005097          	auipc	ra,0x5
    80001594:	ae2080e7          	jalr	-1310(ra) # 80006072 <acquire>
    havekids = 0;
    80001598:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    8000159a:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    8000159c:	0000e997          	auipc	s3,0xe
    800015a0:	8e498993          	addi	s3,s3,-1820 # 8000ee80 <tickslock>
        havekids = 1;
    800015a4:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015a6:	00008c17          	auipc	s8,0x8
    800015aa:	ac2c0c13          	addi	s8,s8,-1342 # 80009068 <wait_lock>
    havekids = 0;
    800015ae:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800015b0:	00008497          	auipc	s1,0x8
    800015b4:	ed048493          	addi	s1,s1,-304 # 80009480 <proc>
    800015b8:	a0bd                	j	80001626 <wait+0xc2>
          pid = np->pid;
    800015ba:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800015be:	000b0e63          	beqz	s6,800015da <wait+0x76>
    800015c2:	4691                	li	a3,4
    800015c4:	02c48613          	addi	a2,s1,44
    800015c8:	85da                	mv	a1,s6
    800015ca:	05093503          	ld	a0,80(s2)
    800015ce:	fffff097          	auipc	ra,0xfffff
    800015d2:	53c080e7          	jalr	1340(ra) # 80000b0a <copyout>
    800015d6:	02054563          	bltz	a0,80001600 <wait+0x9c>
          freeproc(np);
    800015da:	8526                	mv	a0,s1
    800015dc:	00000097          	auipc	ra,0x0
    800015e0:	a1a080e7          	jalr	-1510(ra) # 80000ff6 <freeproc>
          release(&np->lock);
    800015e4:	8526                	mv	a0,s1
    800015e6:	00005097          	auipc	ra,0x5
    800015ea:	b40080e7          	jalr	-1216(ra) # 80006126 <release>
          release(&wait_lock);
    800015ee:	00008517          	auipc	a0,0x8
    800015f2:	a7a50513          	addi	a0,a0,-1414 # 80009068 <wait_lock>
    800015f6:	00005097          	auipc	ra,0x5
    800015fa:	b30080e7          	jalr	-1232(ra) # 80006126 <release>
          return pid;
    800015fe:	a09d                	j	80001664 <wait+0x100>
            release(&np->lock);
    80001600:	8526                	mv	a0,s1
    80001602:	00005097          	auipc	ra,0x5
    80001606:	b24080e7          	jalr	-1244(ra) # 80006126 <release>
            release(&wait_lock);
    8000160a:	00008517          	auipc	a0,0x8
    8000160e:	a5e50513          	addi	a0,a0,-1442 # 80009068 <wait_lock>
    80001612:	00005097          	auipc	ra,0x5
    80001616:	b14080e7          	jalr	-1260(ra) # 80006126 <release>
            return -1;
    8000161a:	59fd                	li	s3,-1
    8000161c:	a0a1                	j	80001664 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    8000161e:	16848493          	addi	s1,s1,360
    80001622:	03348463          	beq	s1,s3,8000164a <wait+0xe6>
      if(np->parent == p){
    80001626:	7c9c                	ld	a5,56(s1)
    80001628:	ff279be3          	bne	a5,s2,8000161e <wait+0xba>
        acquire(&np->lock);
    8000162c:	8526                	mv	a0,s1
    8000162e:	00005097          	auipc	ra,0x5
    80001632:	a44080e7          	jalr	-1468(ra) # 80006072 <acquire>
        if(np->state == ZOMBIE){
    80001636:	4c9c                	lw	a5,24(s1)
    80001638:	f94781e3          	beq	a5,s4,800015ba <wait+0x56>
        release(&np->lock);
    8000163c:	8526                	mv	a0,s1
    8000163e:	00005097          	auipc	ra,0x5
    80001642:	ae8080e7          	jalr	-1304(ra) # 80006126 <release>
        havekids = 1;
    80001646:	8756                	mv	a4,s5
    80001648:	bfd9                	j	8000161e <wait+0xba>
    if(!havekids || p->killed){
    8000164a:	c701                	beqz	a4,80001652 <wait+0xee>
    8000164c:	02892783          	lw	a5,40(s2)
    80001650:	c79d                	beqz	a5,8000167e <wait+0x11a>
      release(&wait_lock);
    80001652:	00008517          	auipc	a0,0x8
    80001656:	a1650513          	addi	a0,a0,-1514 # 80009068 <wait_lock>
    8000165a:	00005097          	auipc	ra,0x5
    8000165e:	acc080e7          	jalr	-1332(ra) # 80006126 <release>
      return -1;
    80001662:	59fd                	li	s3,-1
}
    80001664:	854e                	mv	a0,s3
    80001666:	60a6                	ld	ra,72(sp)
    80001668:	6406                	ld	s0,64(sp)
    8000166a:	74e2                	ld	s1,56(sp)
    8000166c:	7942                	ld	s2,48(sp)
    8000166e:	79a2                	ld	s3,40(sp)
    80001670:	7a02                	ld	s4,32(sp)
    80001672:	6ae2                	ld	s5,24(sp)
    80001674:	6b42                	ld	s6,16(sp)
    80001676:	6ba2                	ld	s7,8(sp)
    80001678:	6c02                	ld	s8,0(sp)
    8000167a:	6161                	addi	sp,sp,80
    8000167c:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000167e:	85e2                	mv	a1,s8
    80001680:	854a                	mv	a0,s2
    80001682:	00000097          	auipc	ra,0x0
    80001686:	e7e080e7          	jalr	-386(ra) # 80001500 <sleep>
    havekids = 0;
    8000168a:	b715                	j	800015ae <wait+0x4a>

000000008000168c <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000168c:	7139                	addi	sp,sp,-64
    8000168e:	fc06                	sd	ra,56(sp)
    80001690:	f822                	sd	s0,48(sp)
    80001692:	f426                	sd	s1,40(sp)
    80001694:	f04a                	sd	s2,32(sp)
    80001696:	ec4e                	sd	s3,24(sp)
    80001698:	e852                	sd	s4,16(sp)
    8000169a:	e456                	sd	s5,8(sp)
    8000169c:	0080                	addi	s0,sp,64
    8000169e:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016a0:	00008497          	auipc	s1,0x8
    800016a4:	de048493          	addi	s1,s1,-544 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016a8:	4989                	li	s3,2
        p->state = RUNNABLE;
    800016aa:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800016ac:	0000d917          	auipc	s2,0xd
    800016b0:	7d490913          	addi	s2,s2,2004 # 8000ee80 <tickslock>
    800016b4:	a821                	j	800016cc <wakeup+0x40>
        p->state = RUNNABLE;
    800016b6:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    800016ba:	8526                	mv	a0,s1
    800016bc:	00005097          	auipc	ra,0x5
    800016c0:	a6a080e7          	jalr	-1430(ra) # 80006126 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800016c4:	16848493          	addi	s1,s1,360
    800016c8:	03248463          	beq	s1,s2,800016f0 <wakeup+0x64>
    if(p != myproc()){
    800016cc:	fffff097          	auipc	ra,0xfffff
    800016d0:	778080e7          	jalr	1912(ra) # 80000e44 <myproc>
    800016d4:	fea488e3          	beq	s1,a0,800016c4 <wakeup+0x38>
      acquire(&p->lock);
    800016d8:	8526                	mv	a0,s1
    800016da:	00005097          	auipc	ra,0x5
    800016de:	998080e7          	jalr	-1640(ra) # 80006072 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800016e2:	4c9c                	lw	a5,24(s1)
    800016e4:	fd379be3          	bne	a5,s3,800016ba <wakeup+0x2e>
    800016e8:	709c                	ld	a5,32(s1)
    800016ea:	fd4798e3          	bne	a5,s4,800016ba <wakeup+0x2e>
    800016ee:	b7e1                	j	800016b6 <wakeup+0x2a>
    }
  }
}
    800016f0:	70e2                	ld	ra,56(sp)
    800016f2:	7442                	ld	s0,48(sp)
    800016f4:	74a2                	ld	s1,40(sp)
    800016f6:	7902                	ld	s2,32(sp)
    800016f8:	69e2                	ld	s3,24(sp)
    800016fa:	6a42                	ld	s4,16(sp)
    800016fc:	6aa2                	ld	s5,8(sp)
    800016fe:	6121                	addi	sp,sp,64
    80001700:	8082                	ret

0000000080001702 <reparent>:
{
    80001702:	7179                	addi	sp,sp,-48
    80001704:	f406                	sd	ra,40(sp)
    80001706:	f022                	sd	s0,32(sp)
    80001708:	ec26                	sd	s1,24(sp)
    8000170a:	e84a                	sd	s2,16(sp)
    8000170c:	e44e                	sd	s3,8(sp)
    8000170e:	e052                	sd	s4,0(sp)
    80001710:	1800                	addi	s0,sp,48
    80001712:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001714:	00008497          	auipc	s1,0x8
    80001718:	d6c48493          	addi	s1,s1,-660 # 80009480 <proc>
      pp->parent = initproc;
    8000171c:	00008a17          	auipc	s4,0x8
    80001720:	8f4a0a13          	addi	s4,s4,-1804 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001724:	0000d997          	auipc	s3,0xd
    80001728:	75c98993          	addi	s3,s3,1884 # 8000ee80 <tickslock>
    8000172c:	a029                	j	80001736 <reparent+0x34>
    8000172e:	16848493          	addi	s1,s1,360
    80001732:	01348d63          	beq	s1,s3,8000174c <reparent+0x4a>
    if(pp->parent == p){
    80001736:	7c9c                	ld	a5,56(s1)
    80001738:	ff279be3          	bne	a5,s2,8000172e <reparent+0x2c>
      pp->parent = initproc;
    8000173c:	000a3503          	ld	a0,0(s4)
    80001740:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001742:	00000097          	auipc	ra,0x0
    80001746:	f4a080e7          	jalr	-182(ra) # 8000168c <wakeup>
    8000174a:	b7d5                	j	8000172e <reparent+0x2c>
}
    8000174c:	70a2                	ld	ra,40(sp)
    8000174e:	7402                	ld	s0,32(sp)
    80001750:	64e2                	ld	s1,24(sp)
    80001752:	6942                	ld	s2,16(sp)
    80001754:	69a2                	ld	s3,8(sp)
    80001756:	6a02                	ld	s4,0(sp)
    80001758:	6145                	addi	sp,sp,48
    8000175a:	8082                	ret

000000008000175c <exit>:
{
    8000175c:	7179                	addi	sp,sp,-48
    8000175e:	f406                	sd	ra,40(sp)
    80001760:	f022                	sd	s0,32(sp)
    80001762:	ec26                	sd	s1,24(sp)
    80001764:	e84a                	sd	s2,16(sp)
    80001766:	e44e                	sd	s3,8(sp)
    80001768:	e052                	sd	s4,0(sp)
    8000176a:	1800                	addi	s0,sp,48
    8000176c:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000176e:	fffff097          	auipc	ra,0xfffff
    80001772:	6d6080e7          	jalr	1750(ra) # 80000e44 <myproc>
    80001776:	89aa                	mv	s3,a0
  if(p == initproc)
    80001778:	00008797          	auipc	a5,0x8
    8000177c:	8987b783          	ld	a5,-1896(a5) # 80009010 <initproc>
    80001780:	0d050493          	addi	s1,a0,208
    80001784:	15050913          	addi	s2,a0,336
    80001788:	02a79363          	bne	a5,a0,800017ae <exit+0x52>
    panic("init exiting");
    8000178c:	00007517          	auipc	a0,0x7
    80001790:	a5450513          	addi	a0,a0,-1452 # 800081e0 <etext+0x1e0>
    80001794:	00004097          	auipc	ra,0x4
    80001798:	394080e7          	jalr	916(ra) # 80005b28 <panic>
      fileclose(f);
    8000179c:	00002097          	auipc	ra,0x2
    800017a0:	172080e7          	jalr	370(ra) # 8000390e <fileclose>
      p->ofile[fd] = 0;
    800017a4:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800017a8:	04a1                	addi	s1,s1,8
    800017aa:	01248563          	beq	s1,s2,800017b4 <exit+0x58>
    if(p->ofile[fd]){
    800017ae:	6088                	ld	a0,0(s1)
    800017b0:	f575                	bnez	a0,8000179c <exit+0x40>
    800017b2:	bfdd                	j	800017a8 <exit+0x4c>
  begin_op();
    800017b4:	00002097          	auipc	ra,0x2
    800017b8:	c8e080e7          	jalr	-882(ra) # 80003442 <begin_op>
  iput(p->cwd);
    800017bc:	1509b503          	ld	a0,336(s3)
    800017c0:	00001097          	auipc	ra,0x1
    800017c4:	46a080e7          	jalr	1130(ra) # 80002c2a <iput>
  end_op();
    800017c8:	00002097          	auipc	ra,0x2
    800017cc:	cfa080e7          	jalr	-774(ra) # 800034c2 <end_op>
  p->cwd = 0;
    800017d0:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800017d4:	00008497          	auipc	s1,0x8
    800017d8:	89448493          	addi	s1,s1,-1900 # 80009068 <wait_lock>
    800017dc:	8526                	mv	a0,s1
    800017de:	00005097          	auipc	ra,0x5
    800017e2:	894080e7          	jalr	-1900(ra) # 80006072 <acquire>
  reparent(p);
    800017e6:	854e                	mv	a0,s3
    800017e8:	00000097          	auipc	ra,0x0
    800017ec:	f1a080e7          	jalr	-230(ra) # 80001702 <reparent>
  wakeup(p->parent);
    800017f0:	0389b503          	ld	a0,56(s3)
    800017f4:	00000097          	auipc	ra,0x0
    800017f8:	e98080e7          	jalr	-360(ra) # 8000168c <wakeup>
  acquire(&p->lock);
    800017fc:	854e                	mv	a0,s3
    800017fe:	00005097          	auipc	ra,0x5
    80001802:	874080e7          	jalr	-1932(ra) # 80006072 <acquire>
  p->xstate = status;
    80001806:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000180a:	4795                	li	a5,5
    8000180c:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001810:	8526                	mv	a0,s1
    80001812:	00005097          	auipc	ra,0x5
    80001816:	914080e7          	jalr	-1772(ra) # 80006126 <release>
  sched();
    8000181a:	00000097          	auipc	ra,0x0
    8000181e:	bd4080e7          	jalr	-1068(ra) # 800013ee <sched>
  panic("zombie exit");
    80001822:	00007517          	auipc	a0,0x7
    80001826:	9ce50513          	addi	a0,a0,-1586 # 800081f0 <etext+0x1f0>
    8000182a:	00004097          	auipc	ra,0x4
    8000182e:	2fe080e7          	jalr	766(ra) # 80005b28 <panic>

0000000080001832 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001832:	7179                	addi	sp,sp,-48
    80001834:	f406                	sd	ra,40(sp)
    80001836:	f022                	sd	s0,32(sp)
    80001838:	ec26                	sd	s1,24(sp)
    8000183a:	e84a                	sd	s2,16(sp)
    8000183c:	e44e                	sd	s3,8(sp)
    8000183e:	1800                	addi	s0,sp,48
    80001840:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001842:	00008497          	auipc	s1,0x8
    80001846:	c3e48493          	addi	s1,s1,-962 # 80009480 <proc>
    8000184a:	0000d997          	auipc	s3,0xd
    8000184e:	63698993          	addi	s3,s3,1590 # 8000ee80 <tickslock>
    acquire(&p->lock);
    80001852:	8526                	mv	a0,s1
    80001854:	00005097          	auipc	ra,0x5
    80001858:	81e080e7          	jalr	-2018(ra) # 80006072 <acquire>
    if(p->pid == pid){
    8000185c:	589c                	lw	a5,48(s1)
    8000185e:	01278d63          	beq	a5,s2,80001878 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001862:	8526                	mv	a0,s1
    80001864:	00005097          	auipc	ra,0x5
    80001868:	8c2080e7          	jalr	-1854(ra) # 80006126 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000186c:	16848493          	addi	s1,s1,360
    80001870:	ff3491e3          	bne	s1,s3,80001852 <kill+0x20>
  }
  return -1;
    80001874:	557d                	li	a0,-1
    80001876:	a829                	j	80001890 <kill+0x5e>
      p->killed = 1;
    80001878:	4785                	li	a5,1
    8000187a:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000187c:	4c98                	lw	a4,24(s1)
    8000187e:	4789                	li	a5,2
    80001880:	00f70f63          	beq	a4,a5,8000189e <kill+0x6c>
      release(&p->lock);
    80001884:	8526                	mv	a0,s1
    80001886:	00005097          	auipc	ra,0x5
    8000188a:	8a0080e7          	jalr	-1888(ra) # 80006126 <release>
      return 0;
    8000188e:	4501                	li	a0,0
}
    80001890:	70a2                	ld	ra,40(sp)
    80001892:	7402                	ld	s0,32(sp)
    80001894:	64e2                	ld	s1,24(sp)
    80001896:	6942                	ld	s2,16(sp)
    80001898:	69a2                	ld	s3,8(sp)
    8000189a:	6145                	addi	sp,sp,48
    8000189c:	8082                	ret
        p->state = RUNNABLE;
    8000189e:	478d                	li	a5,3
    800018a0:	cc9c                	sw	a5,24(s1)
    800018a2:	b7cd                	j	80001884 <kill+0x52>

00000000800018a4 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018a4:	7179                	addi	sp,sp,-48
    800018a6:	f406                	sd	ra,40(sp)
    800018a8:	f022                	sd	s0,32(sp)
    800018aa:	ec26                	sd	s1,24(sp)
    800018ac:	e84a                	sd	s2,16(sp)
    800018ae:	e44e                	sd	s3,8(sp)
    800018b0:	e052                	sd	s4,0(sp)
    800018b2:	1800                	addi	s0,sp,48
    800018b4:	84aa                	mv	s1,a0
    800018b6:	892e                	mv	s2,a1
    800018b8:	89b2                	mv	s3,a2
    800018ba:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800018bc:	fffff097          	auipc	ra,0xfffff
    800018c0:	588080e7          	jalr	1416(ra) # 80000e44 <myproc>
  if(user_dst){
    800018c4:	c08d                	beqz	s1,800018e6 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800018c6:	86d2                	mv	a3,s4
    800018c8:	864e                	mv	a2,s3
    800018ca:	85ca                	mv	a1,s2
    800018cc:	6928                	ld	a0,80(a0)
    800018ce:	fffff097          	auipc	ra,0xfffff
    800018d2:	23c080e7          	jalr	572(ra) # 80000b0a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800018d6:	70a2                	ld	ra,40(sp)
    800018d8:	7402                	ld	s0,32(sp)
    800018da:	64e2                	ld	s1,24(sp)
    800018dc:	6942                	ld	s2,16(sp)
    800018de:	69a2                	ld	s3,8(sp)
    800018e0:	6a02                	ld	s4,0(sp)
    800018e2:	6145                	addi	sp,sp,48
    800018e4:	8082                	ret
    memmove((char *)dst, src, len);
    800018e6:	000a061b          	sext.w	a2,s4
    800018ea:	85ce                	mv	a1,s3
    800018ec:	854a                	mv	a0,s2
    800018ee:	fffff097          	auipc	ra,0xfffff
    800018f2:	8ea080e7          	jalr	-1814(ra) # 800001d8 <memmove>
    return 0;
    800018f6:	8526                	mv	a0,s1
    800018f8:	bff9                	j	800018d6 <either_copyout+0x32>

00000000800018fa <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800018fa:	7179                	addi	sp,sp,-48
    800018fc:	f406                	sd	ra,40(sp)
    800018fe:	f022                	sd	s0,32(sp)
    80001900:	ec26                	sd	s1,24(sp)
    80001902:	e84a                	sd	s2,16(sp)
    80001904:	e44e                	sd	s3,8(sp)
    80001906:	e052                	sd	s4,0(sp)
    80001908:	1800                	addi	s0,sp,48
    8000190a:	892a                	mv	s2,a0
    8000190c:	84ae                	mv	s1,a1
    8000190e:	89b2                	mv	s3,a2
    80001910:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001912:	fffff097          	auipc	ra,0xfffff
    80001916:	532080e7          	jalr	1330(ra) # 80000e44 <myproc>
  if(user_src){
    8000191a:	c08d                	beqz	s1,8000193c <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000191c:	86d2                	mv	a3,s4
    8000191e:	864e                	mv	a2,s3
    80001920:	85ca                	mv	a1,s2
    80001922:	6928                	ld	a0,80(a0)
    80001924:	fffff097          	auipc	ra,0xfffff
    80001928:	272080e7          	jalr	626(ra) # 80000b96 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000192c:	70a2                	ld	ra,40(sp)
    8000192e:	7402                	ld	s0,32(sp)
    80001930:	64e2                	ld	s1,24(sp)
    80001932:	6942                	ld	s2,16(sp)
    80001934:	69a2                	ld	s3,8(sp)
    80001936:	6a02                	ld	s4,0(sp)
    80001938:	6145                	addi	sp,sp,48
    8000193a:	8082                	ret
    memmove(dst, (char*)src, len);
    8000193c:	000a061b          	sext.w	a2,s4
    80001940:	85ce                	mv	a1,s3
    80001942:	854a                	mv	a0,s2
    80001944:	fffff097          	auipc	ra,0xfffff
    80001948:	894080e7          	jalr	-1900(ra) # 800001d8 <memmove>
    return 0;
    8000194c:	8526                	mv	a0,s1
    8000194e:	bff9                	j	8000192c <either_copyin+0x32>

0000000080001950 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001950:	715d                	addi	sp,sp,-80
    80001952:	e486                	sd	ra,72(sp)
    80001954:	e0a2                	sd	s0,64(sp)
    80001956:	fc26                	sd	s1,56(sp)
    80001958:	f84a                	sd	s2,48(sp)
    8000195a:	f44e                	sd	s3,40(sp)
    8000195c:	f052                	sd	s4,32(sp)
    8000195e:	ec56                	sd	s5,24(sp)
    80001960:	e85a                	sd	s6,16(sp)
    80001962:	e45e                	sd	s7,8(sp)
    80001964:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001966:	00006517          	auipc	a0,0x6
    8000196a:	6e250513          	addi	a0,a0,1762 # 80008048 <etext+0x48>
    8000196e:	00004097          	auipc	ra,0x4
    80001972:	204080e7          	jalr	516(ra) # 80005b72 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001976:	00008497          	auipc	s1,0x8
    8000197a:	c6248493          	addi	s1,s1,-926 # 800095d8 <proc+0x158>
    8000197e:	0000d917          	auipc	s2,0xd
    80001982:	65a90913          	addi	s2,s2,1626 # 8000efd8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001986:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001988:	00007997          	auipc	s3,0x7
    8000198c:	87898993          	addi	s3,s3,-1928 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001990:	00007a97          	auipc	s5,0x7
    80001994:	878a8a93          	addi	s5,s5,-1928 # 80008208 <etext+0x208>
    printf("\n");
    80001998:	00006a17          	auipc	s4,0x6
    8000199c:	6b0a0a13          	addi	s4,s4,1712 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019a0:	00007b97          	auipc	s7,0x7
    800019a4:	8a0b8b93          	addi	s7,s7,-1888 # 80008240 <states.1711>
    800019a8:	a00d                	j	800019ca <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800019aa:	ed86a583          	lw	a1,-296(a3)
    800019ae:	8556                	mv	a0,s5
    800019b0:	00004097          	auipc	ra,0x4
    800019b4:	1c2080e7          	jalr	450(ra) # 80005b72 <printf>
    printf("\n");
    800019b8:	8552                	mv	a0,s4
    800019ba:	00004097          	auipc	ra,0x4
    800019be:	1b8080e7          	jalr	440(ra) # 80005b72 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019c2:	16848493          	addi	s1,s1,360
    800019c6:	03248163          	beq	s1,s2,800019e8 <procdump+0x98>
    if(p->state == UNUSED)
    800019ca:	86a6                	mv	a3,s1
    800019cc:	ec04a783          	lw	a5,-320(s1)
    800019d0:	dbed                	beqz	a5,800019c2 <procdump+0x72>
      state = "???";
    800019d2:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019d4:	fcfb6be3          	bltu	s6,a5,800019aa <procdump+0x5a>
    800019d8:	1782                	slli	a5,a5,0x20
    800019da:	9381                	srli	a5,a5,0x20
    800019dc:	078e                	slli	a5,a5,0x3
    800019de:	97de                	add	a5,a5,s7
    800019e0:	6390                	ld	a2,0(a5)
    800019e2:	f661                	bnez	a2,800019aa <procdump+0x5a>
      state = "???";
    800019e4:	864e                	mv	a2,s3
    800019e6:	b7d1                	j	800019aa <procdump+0x5a>
  }
}
    800019e8:	60a6                	ld	ra,72(sp)
    800019ea:	6406                	ld	s0,64(sp)
    800019ec:	74e2                	ld	s1,56(sp)
    800019ee:	7942                	ld	s2,48(sp)
    800019f0:	79a2                	ld	s3,40(sp)
    800019f2:	7a02                	ld	s4,32(sp)
    800019f4:	6ae2                	ld	s5,24(sp)
    800019f6:	6b42                	ld	s6,16(sp)
    800019f8:	6ba2                	ld	s7,8(sp)
    800019fa:	6161                	addi	sp,sp,80
    800019fc:	8082                	ret

00000000800019fe <swtch>:
    800019fe:	00153023          	sd	ra,0(a0)
    80001a02:	00253423          	sd	sp,8(a0)
    80001a06:	e900                	sd	s0,16(a0)
    80001a08:	ed04                	sd	s1,24(a0)
    80001a0a:	03253023          	sd	s2,32(a0)
    80001a0e:	03353423          	sd	s3,40(a0)
    80001a12:	03453823          	sd	s4,48(a0)
    80001a16:	03553c23          	sd	s5,56(a0)
    80001a1a:	05653023          	sd	s6,64(a0)
    80001a1e:	05753423          	sd	s7,72(a0)
    80001a22:	05853823          	sd	s8,80(a0)
    80001a26:	05953c23          	sd	s9,88(a0)
    80001a2a:	07a53023          	sd	s10,96(a0)
    80001a2e:	07b53423          	sd	s11,104(a0)
    80001a32:	0005b083          	ld	ra,0(a1)
    80001a36:	0085b103          	ld	sp,8(a1)
    80001a3a:	6980                	ld	s0,16(a1)
    80001a3c:	6d84                	ld	s1,24(a1)
    80001a3e:	0205b903          	ld	s2,32(a1)
    80001a42:	0285b983          	ld	s3,40(a1)
    80001a46:	0305ba03          	ld	s4,48(a1)
    80001a4a:	0385ba83          	ld	s5,56(a1)
    80001a4e:	0405bb03          	ld	s6,64(a1)
    80001a52:	0485bb83          	ld	s7,72(a1)
    80001a56:	0505bc03          	ld	s8,80(a1)
    80001a5a:	0585bc83          	ld	s9,88(a1)
    80001a5e:	0605bd03          	ld	s10,96(a1)
    80001a62:	0685bd83          	ld	s11,104(a1)
    80001a66:	8082                	ret

0000000080001a68 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001a68:	1141                	addi	sp,sp,-16
    80001a6a:	e406                	sd	ra,8(sp)
    80001a6c:	e022                	sd	s0,0(sp)
    80001a6e:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001a70:	00007597          	auipc	a1,0x7
    80001a74:	80058593          	addi	a1,a1,-2048 # 80008270 <states.1711+0x30>
    80001a78:	0000d517          	auipc	a0,0xd
    80001a7c:	40850513          	addi	a0,a0,1032 # 8000ee80 <tickslock>
    80001a80:	00004097          	auipc	ra,0x4
    80001a84:	562080e7          	jalr	1378(ra) # 80005fe2 <initlock>
}
    80001a88:	60a2                	ld	ra,8(sp)
    80001a8a:	6402                	ld	s0,0(sp)
    80001a8c:	0141                	addi	sp,sp,16
    80001a8e:	8082                	ret

0000000080001a90 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001a90:	1141                	addi	sp,sp,-16
    80001a92:	e422                	sd	s0,8(sp)
    80001a94:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001a96:	00003797          	auipc	a5,0x3
    80001a9a:	49a78793          	addi	a5,a5,1178 # 80004f30 <kernelvec>
    80001a9e:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001aa2:	6422                	ld	s0,8(sp)
    80001aa4:	0141                	addi	sp,sp,16
    80001aa6:	8082                	ret

0000000080001aa8 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001aa8:	1141                	addi	sp,sp,-16
    80001aaa:	e406                	sd	ra,8(sp)
    80001aac:	e022                	sd	s0,0(sp)
    80001aae:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001ab0:	fffff097          	auipc	ra,0xfffff
    80001ab4:	394080e7          	jalr	916(ra) # 80000e44 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ab8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001abc:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001abe:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001ac2:	00005617          	auipc	a2,0x5
    80001ac6:	53e60613          	addi	a2,a2,1342 # 80007000 <_trampoline>
    80001aca:	00005697          	auipc	a3,0x5
    80001ace:	53668693          	addi	a3,a3,1334 # 80007000 <_trampoline>
    80001ad2:	8e91                	sub	a3,a3,a2
    80001ad4:	040007b7          	lui	a5,0x4000
    80001ad8:	17fd                	addi	a5,a5,-1
    80001ada:	07b2                	slli	a5,a5,0xc
    80001adc:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ade:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001ae2:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001ae4:	180026f3          	csrr	a3,satp
    80001ae8:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001aea:	6d38                	ld	a4,88(a0)
    80001aec:	6134                	ld	a3,64(a0)
    80001aee:	6585                	lui	a1,0x1
    80001af0:	96ae                	add	a3,a3,a1
    80001af2:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001af4:	6d38                	ld	a4,88(a0)
    80001af6:	00000697          	auipc	a3,0x0
    80001afa:	13868693          	addi	a3,a3,312 # 80001c2e <usertrap>
    80001afe:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b00:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b02:	8692                	mv	a3,tp
    80001b04:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b06:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b0a:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b0e:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b12:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b16:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b18:	6f18                	ld	a4,24(a4)
    80001b1a:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b1e:	692c                	ld	a1,80(a0)
    80001b20:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001b22:	00005717          	auipc	a4,0x5
    80001b26:	56e70713          	addi	a4,a4,1390 # 80007090 <userret>
    80001b2a:	8f11                	sub	a4,a4,a2
    80001b2c:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001b2e:	577d                	li	a4,-1
    80001b30:	177e                	slli	a4,a4,0x3f
    80001b32:	8dd9                	or	a1,a1,a4
    80001b34:	02000537          	lui	a0,0x2000
    80001b38:	157d                	addi	a0,a0,-1
    80001b3a:	0536                	slli	a0,a0,0xd
    80001b3c:	9782                	jalr	a5
}
    80001b3e:	60a2                	ld	ra,8(sp)
    80001b40:	6402                	ld	s0,0(sp)
    80001b42:	0141                	addi	sp,sp,16
    80001b44:	8082                	ret

0000000080001b46 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001b46:	1101                	addi	sp,sp,-32
    80001b48:	ec06                	sd	ra,24(sp)
    80001b4a:	e822                	sd	s0,16(sp)
    80001b4c:	e426                	sd	s1,8(sp)
    80001b4e:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001b50:	0000d497          	auipc	s1,0xd
    80001b54:	33048493          	addi	s1,s1,816 # 8000ee80 <tickslock>
    80001b58:	8526                	mv	a0,s1
    80001b5a:	00004097          	auipc	ra,0x4
    80001b5e:	518080e7          	jalr	1304(ra) # 80006072 <acquire>
  ticks++;
    80001b62:	00007517          	auipc	a0,0x7
    80001b66:	4b650513          	addi	a0,a0,1206 # 80009018 <ticks>
    80001b6a:	411c                	lw	a5,0(a0)
    80001b6c:	2785                	addiw	a5,a5,1
    80001b6e:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001b70:	00000097          	auipc	ra,0x0
    80001b74:	b1c080e7          	jalr	-1252(ra) # 8000168c <wakeup>
  release(&tickslock);
    80001b78:	8526                	mv	a0,s1
    80001b7a:	00004097          	auipc	ra,0x4
    80001b7e:	5ac080e7          	jalr	1452(ra) # 80006126 <release>
}
    80001b82:	60e2                	ld	ra,24(sp)
    80001b84:	6442                	ld	s0,16(sp)
    80001b86:	64a2                	ld	s1,8(sp)
    80001b88:	6105                	addi	sp,sp,32
    80001b8a:	8082                	ret

0000000080001b8c <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001b8c:	1101                	addi	sp,sp,-32
    80001b8e:	ec06                	sd	ra,24(sp)
    80001b90:	e822                	sd	s0,16(sp)
    80001b92:	e426                	sd	s1,8(sp)
    80001b94:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b96:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001b9a:	00074d63          	bltz	a4,80001bb4 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001b9e:	57fd                	li	a5,-1
    80001ba0:	17fe                	slli	a5,a5,0x3f
    80001ba2:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001ba4:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001ba6:	06f70363          	beq	a4,a5,80001c0c <devintr+0x80>
  }
}
    80001baa:	60e2                	ld	ra,24(sp)
    80001bac:	6442                	ld	s0,16(sp)
    80001bae:	64a2                	ld	s1,8(sp)
    80001bb0:	6105                	addi	sp,sp,32
    80001bb2:	8082                	ret
     (scause & 0xff) == 9){
    80001bb4:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001bb8:	46a5                	li	a3,9
    80001bba:	fed792e3          	bne	a5,a3,80001b9e <devintr+0x12>
    int irq = plic_claim();
    80001bbe:	00003097          	auipc	ra,0x3
    80001bc2:	47a080e7          	jalr	1146(ra) # 80005038 <plic_claim>
    80001bc6:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001bc8:	47a9                	li	a5,10
    80001bca:	02f50763          	beq	a0,a5,80001bf8 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001bce:	4785                	li	a5,1
    80001bd0:	02f50963          	beq	a0,a5,80001c02 <devintr+0x76>
    return 1;
    80001bd4:	4505                	li	a0,1
    } else if(irq){
    80001bd6:	d8f1                	beqz	s1,80001baa <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001bd8:	85a6                	mv	a1,s1
    80001bda:	00006517          	auipc	a0,0x6
    80001bde:	69e50513          	addi	a0,a0,1694 # 80008278 <states.1711+0x38>
    80001be2:	00004097          	auipc	ra,0x4
    80001be6:	f90080e7          	jalr	-112(ra) # 80005b72 <printf>
      plic_complete(irq);
    80001bea:	8526                	mv	a0,s1
    80001bec:	00003097          	auipc	ra,0x3
    80001bf0:	470080e7          	jalr	1136(ra) # 8000505c <plic_complete>
    return 1;
    80001bf4:	4505                	li	a0,1
    80001bf6:	bf55                	j	80001baa <devintr+0x1e>
      uartintr();
    80001bf8:	00004097          	auipc	ra,0x4
    80001bfc:	39a080e7          	jalr	922(ra) # 80005f92 <uartintr>
    80001c00:	b7ed                	j	80001bea <devintr+0x5e>
      virtio_disk_intr();
    80001c02:	00004097          	auipc	ra,0x4
    80001c06:	93a080e7          	jalr	-1734(ra) # 8000553c <virtio_disk_intr>
    80001c0a:	b7c5                	j	80001bea <devintr+0x5e>
    if(cpuid() == 0){
    80001c0c:	fffff097          	auipc	ra,0xfffff
    80001c10:	20c080e7          	jalr	524(ra) # 80000e18 <cpuid>
    80001c14:	c901                	beqz	a0,80001c24 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c16:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c1a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c1c:	14479073          	csrw	sip,a5
    return 2;
    80001c20:	4509                	li	a0,2
    80001c22:	b761                	j	80001baa <devintr+0x1e>
      clockintr();
    80001c24:	00000097          	auipc	ra,0x0
    80001c28:	f22080e7          	jalr	-222(ra) # 80001b46 <clockintr>
    80001c2c:	b7ed                	j	80001c16 <devintr+0x8a>

0000000080001c2e <usertrap>:
{
    80001c2e:	1101                	addi	sp,sp,-32
    80001c30:	ec06                	sd	ra,24(sp)
    80001c32:	e822                	sd	s0,16(sp)
    80001c34:	e426                	sd	s1,8(sp)
    80001c36:	e04a                	sd	s2,0(sp)
    80001c38:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c3a:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c3e:	1007f793          	andi	a5,a5,256
    80001c42:	e3ad                	bnez	a5,80001ca4 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c44:	00003797          	auipc	a5,0x3
    80001c48:	2ec78793          	addi	a5,a5,748 # 80004f30 <kernelvec>
    80001c4c:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001c50:	fffff097          	auipc	ra,0xfffff
    80001c54:	1f4080e7          	jalr	500(ra) # 80000e44 <myproc>
    80001c58:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001c5a:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001c5c:	14102773          	csrr	a4,sepc
    80001c60:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c62:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001c66:	47a1                	li	a5,8
    80001c68:	04f71c63          	bne	a4,a5,80001cc0 <usertrap+0x92>
    if(p->killed)
    80001c6c:	551c                	lw	a5,40(a0)
    80001c6e:	e3b9                	bnez	a5,80001cb4 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001c70:	6cb8                	ld	a4,88(s1)
    80001c72:	6f1c                	ld	a5,24(a4)
    80001c74:	0791                	addi	a5,a5,4
    80001c76:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c78:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001c7c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c80:	10079073          	csrw	sstatus,a5
    syscall();
    80001c84:	00000097          	auipc	ra,0x0
    80001c88:	2e0080e7          	jalr	736(ra) # 80001f64 <syscall>
  if(p->killed)
    80001c8c:	549c                	lw	a5,40(s1)
    80001c8e:	ebc1                	bnez	a5,80001d1e <usertrap+0xf0>
  usertrapret();
    80001c90:	00000097          	auipc	ra,0x0
    80001c94:	e18080e7          	jalr	-488(ra) # 80001aa8 <usertrapret>
}
    80001c98:	60e2                	ld	ra,24(sp)
    80001c9a:	6442                	ld	s0,16(sp)
    80001c9c:	64a2                	ld	s1,8(sp)
    80001c9e:	6902                	ld	s2,0(sp)
    80001ca0:	6105                	addi	sp,sp,32
    80001ca2:	8082                	ret
    panic("usertrap: not from user mode");
    80001ca4:	00006517          	auipc	a0,0x6
    80001ca8:	5f450513          	addi	a0,a0,1524 # 80008298 <states.1711+0x58>
    80001cac:	00004097          	auipc	ra,0x4
    80001cb0:	e7c080e7          	jalr	-388(ra) # 80005b28 <panic>
      exit(-1);
    80001cb4:	557d                	li	a0,-1
    80001cb6:	00000097          	auipc	ra,0x0
    80001cba:	aa6080e7          	jalr	-1370(ra) # 8000175c <exit>
    80001cbe:	bf4d                	j	80001c70 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001cc0:	00000097          	auipc	ra,0x0
    80001cc4:	ecc080e7          	jalr	-308(ra) # 80001b8c <devintr>
    80001cc8:	892a                	mv	s2,a0
    80001cca:	c501                	beqz	a0,80001cd2 <usertrap+0xa4>
  if(p->killed)
    80001ccc:	549c                	lw	a5,40(s1)
    80001cce:	c3a1                	beqz	a5,80001d0e <usertrap+0xe0>
    80001cd0:	a815                	j	80001d04 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cd2:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001cd6:	5890                	lw	a2,48(s1)
    80001cd8:	00006517          	auipc	a0,0x6
    80001cdc:	5e050513          	addi	a0,a0,1504 # 800082b8 <states.1711+0x78>
    80001ce0:	00004097          	auipc	ra,0x4
    80001ce4:	e92080e7          	jalr	-366(ra) # 80005b72 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ce8:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001cec:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001cf0:	00006517          	auipc	a0,0x6
    80001cf4:	5f850513          	addi	a0,a0,1528 # 800082e8 <states.1711+0xa8>
    80001cf8:	00004097          	auipc	ra,0x4
    80001cfc:	e7a080e7          	jalr	-390(ra) # 80005b72 <printf>
    p->killed = 1;
    80001d00:	4785                	li	a5,1
    80001d02:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001d04:	557d                	li	a0,-1
    80001d06:	00000097          	auipc	ra,0x0
    80001d0a:	a56080e7          	jalr	-1450(ra) # 8000175c <exit>
  if(which_dev == 2)
    80001d0e:	4789                	li	a5,2
    80001d10:	f8f910e3          	bne	s2,a5,80001c90 <usertrap+0x62>
    yield();
    80001d14:	fffff097          	auipc	ra,0xfffff
    80001d18:	7b0080e7          	jalr	1968(ra) # 800014c4 <yield>
    80001d1c:	bf95                	j	80001c90 <usertrap+0x62>
  int which_dev = 0;
    80001d1e:	4901                	li	s2,0
    80001d20:	b7d5                	j	80001d04 <usertrap+0xd6>

0000000080001d22 <kerneltrap>:
{
    80001d22:	7179                	addi	sp,sp,-48
    80001d24:	f406                	sd	ra,40(sp)
    80001d26:	f022                	sd	s0,32(sp)
    80001d28:	ec26                	sd	s1,24(sp)
    80001d2a:	e84a                	sd	s2,16(sp)
    80001d2c:	e44e                	sd	s3,8(sp)
    80001d2e:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d30:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d34:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d38:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001d3c:	1004f793          	andi	a5,s1,256
    80001d40:	cb85                	beqz	a5,80001d70 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d42:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001d46:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001d48:	ef85                	bnez	a5,80001d80 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001d4a:	00000097          	auipc	ra,0x0
    80001d4e:	e42080e7          	jalr	-446(ra) # 80001b8c <devintr>
    80001d52:	cd1d                	beqz	a0,80001d90 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001d54:	4789                	li	a5,2
    80001d56:	06f50a63          	beq	a0,a5,80001dca <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d5a:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d5e:	10049073          	csrw	sstatus,s1
}
    80001d62:	70a2                	ld	ra,40(sp)
    80001d64:	7402                	ld	s0,32(sp)
    80001d66:	64e2                	ld	s1,24(sp)
    80001d68:	6942                	ld	s2,16(sp)
    80001d6a:	69a2                	ld	s3,8(sp)
    80001d6c:	6145                	addi	sp,sp,48
    80001d6e:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001d70:	00006517          	auipc	a0,0x6
    80001d74:	59850513          	addi	a0,a0,1432 # 80008308 <states.1711+0xc8>
    80001d78:	00004097          	auipc	ra,0x4
    80001d7c:	db0080e7          	jalr	-592(ra) # 80005b28 <panic>
    panic("kerneltrap: interrupts enabled");
    80001d80:	00006517          	auipc	a0,0x6
    80001d84:	5b050513          	addi	a0,a0,1456 # 80008330 <states.1711+0xf0>
    80001d88:	00004097          	auipc	ra,0x4
    80001d8c:	da0080e7          	jalr	-608(ra) # 80005b28 <panic>
    printf("scause %p\n", scause);
    80001d90:	85ce                	mv	a1,s3
    80001d92:	00006517          	auipc	a0,0x6
    80001d96:	5be50513          	addi	a0,a0,1470 # 80008350 <states.1711+0x110>
    80001d9a:	00004097          	auipc	ra,0x4
    80001d9e:	dd8080e7          	jalr	-552(ra) # 80005b72 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001da2:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001da6:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001daa:	00006517          	auipc	a0,0x6
    80001dae:	5b650513          	addi	a0,a0,1462 # 80008360 <states.1711+0x120>
    80001db2:	00004097          	auipc	ra,0x4
    80001db6:	dc0080e7          	jalr	-576(ra) # 80005b72 <printf>
    panic("kerneltrap");
    80001dba:	00006517          	auipc	a0,0x6
    80001dbe:	5be50513          	addi	a0,a0,1470 # 80008378 <states.1711+0x138>
    80001dc2:	00004097          	auipc	ra,0x4
    80001dc6:	d66080e7          	jalr	-666(ra) # 80005b28 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001dca:	fffff097          	auipc	ra,0xfffff
    80001dce:	07a080e7          	jalr	122(ra) # 80000e44 <myproc>
    80001dd2:	d541                	beqz	a0,80001d5a <kerneltrap+0x38>
    80001dd4:	fffff097          	auipc	ra,0xfffff
    80001dd8:	070080e7          	jalr	112(ra) # 80000e44 <myproc>
    80001ddc:	4d18                	lw	a4,24(a0)
    80001dde:	4791                	li	a5,4
    80001de0:	f6f71de3          	bne	a4,a5,80001d5a <kerneltrap+0x38>
    yield();
    80001de4:	fffff097          	auipc	ra,0xfffff
    80001de8:	6e0080e7          	jalr	1760(ra) # 800014c4 <yield>
    80001dec:	b7bd                	j	80001d5a <kerneltrap+0x38>

0000000080001dee <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001dee:	1101                	addi	sp,sp,-32
    80001df0:	ec06                	sd	ra,24(sp)
    80001df2:	e822                	sd	s0,16(sp)
    80001df4:	e426                	sd	s1,8(sp)
    80001df6:	1000                	addi	s0,sp,32
    80001df8:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001dfa:	fffff097          	auipc	ra,0xfffff
    80001dfe:	04a080e7          	jalr	74(ra) # 80000e44 <myproc>
  switch (n) {
    80001e02:	4795                	li	a5,5
    80001e04:	0497e163          	bltu	a5,s1,80001e46 <argraw+0x58>
    80001e08:	048a                	slli	s1,s1,0x2
    80001e0a:	00006717          	auipc	a4,0x6
    80001e0e:	5a670713          	addi	a4,a4,1446 # 800083b0 <states.1711+0x170>
    80001e12:	94ba                	add	s1,s1,a4
    80001e14:	409c                	lw	a5,0(s1)
    80001e16:	97ba                	add	a5,a5,a4
    80001e18:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001e1a:	6d3c                	ld	a5,88(a0)
    80001e1c:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001e1e:	60e2                	ld	ra,24(sp)
    80001e20:	6442                	ld	s0,16(sp)
    80001e22:	64a2                	ld	s1,8(sp)
    80001e24:	6105                	addi	sp,sp,32
    80001e26:	8082                	ret
    return p->trapframe->a1;
    80001e28:	6d3c                	ld	a5,88(a0)
    80001e2a:	7fa8                	ld	a0,120(a5)
    80001e2c:	bfcd                	j	80001e1e <argraw+0x30>
    return p->trapframe->a2;
    80001e2e:	6d3c                	ld	a5,88(a0)
    80001e30:	63c8                	ld	a0,128(a5)
    80001e32:	b7f5                	j	80001e1e <argraw+0x30>
    return p->trapframe->a3;
    80001e34:	6d3c                	ld	a5,88(a0)
    80001e36:	67c8                	ld	a0,136(a5)
    80001e38:	b7dd                	j	80001e1e <argraw+0x30>
    return p->trapframe->a4;
    80001e3a:	6d3c                	ld	a5,88(a0)
    80001e3c:	6bc8                	ld	a0,144(a5)
    80001e3e:	b7c5                	j	80001e1e <argraw+0x30>
    return p->trapframe->a5;
    80001e40:	6d3c                	ld	a5,88(a0)
    80001e42:	6fc8                	ld	a0,152(a5)
    80001e44:	bfe9                	j	80001e1e <argraw+0x30>
  panic("argraw");
    80001e46:	00006517          	auipc	a0,0x6
    80001e4a:	54250513          	addi	a0,a0,1346 # 80008388 <states.1711+0x148>
    80001e4e:	00004097          	auipc	ra,0x4
    80001e52:	cda080e7          	jalr	-806(ra) # 80005b28 <panic>

0000000080001e56 <fetchaddr>:
{
    80001e56:	1101                	addi	sp,sp,-32
    80001e58:	ec06                	sd	ra,24(sp)
    80001e5a:	e822                	sd	s0,16(sp)
    80001e5c:	e426                	sd	s1,8(sp)
    80001e5e:	e04a                	sd	s2,0(sp)
    80001e60:	1000                	addi	s0,sp,32
    80001e62:	84aa                	mv	s1,a0
    80001e64:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001e66:	fffff097          	auipc	ra,0xfffff
    80001e6a:	fde080e7          	jalr	-34(ra) # 80000e44 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001e6e:	653c                	ld	a5,72(a0)
    80001e70:	02f4f863          	bgeu	s1,a5,80001ea0 <fetchaddr+0x4a>
    80001e74:	00848713          	addi	a4,s1,8
    80001e78:	02e7e663          	bltu	a5,a4,80001ea4 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001e7c:	46a1                	li	a3,8
    80001e7e:	8626                	mv	a2,s1
    80001e80:	85ca                	mv	a1,s2
    80001e82:	6928                	ld	a0,80(a0)
    80001e84:	fffff097          	auipc	ra,0xfffff
    80001e88:	d12080e7          	jalr	-750(ra) # 80000b96 <copyin>
    80001e8c:	00a03533          	snez	a0,a0
    80001e90:	40a00533          	neg	a0,a0
}
    80001e94:	60e2                	ld	ra,24(sp)
    80001e96:	6442                	ld	s0,16(sp)
    80001e98:	64a2                	ld	s1,8(sp)
    80001e9a:	6902                	ld	s2,0(sp)
    80001e9c:	6105                	addi	sp,sp,32
    80001e9e:	8082                	ret
    return -1;
    80001ea0:	557d                	li	a0,-1
    80001ea2:	bfcd                	j	80001e94 <fetchaddr+0x3e>
    80001ea4:	557d                	li	a0,-1
    80001ea6:	b7fd                	j	80001e94 <fetchaddr+0x3e>

0000000080001ea8 <fetchstr>:
{
    80001ea8:	7179                	addi	sp,sp,-48
    80001eaa:	f406                	sd	ra,40(sp)
    80001eac:	f022                	sd	s0,32(sp)
    80001eae:	ec26                	sd	s1,24(sp)
    80001eb0:	e84a                	sd	s2,16(sp)
    80001eb2:	e44e                	sd	s3,8(sp)
    80001eb4:	1800                	addi	s0,sp,48
    80001eb6:	892a                	mv	s2,a0
    80001eb8:	84ae                	mv	s1,a1
    80001eba:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001ebc:	fffff097          	auipc	ra,0xfffff
    80001ec0:	f88080e7          	jalr	-120(ra) # 80000e44 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001ec4:	86ce                	mv	a3,s3
    80001ec6:	864a                	mv	a2,s2
    80001ec8:	85a6                	mv	a1,s1
    80001eca:	6928                	ld	a0,80(a0)
    80001ecc:	fffff097          	auipc	ra,0xfffff
    80001ed0:	d56080e7          	jalr	-682(ra) # 80000c22 <copyinstr>
  if(err < 0)
    80001ed4:	00054763          	bltz	a0,80001ee2 <fetchstr+0x3a>
  return strlen(buf);
    80001ed8:	8526                	mv	a0,s1
    80001eda:	ffffe097          	auipc	ra,0xffffe
    80001ede:	422080e7          	jalr	1058(ra) # 800002fc <strlen>
}
    80001ee2:	70a2                	ld	ra,40(sp)
    80001ee4:	7402                	ld	s0,32(sp)
    80001ee6:	64e2                	ld	s1,24(sp)
    80001ee8:	6942                	ld	s2,16(sp)
    80001eea:	69a2                	ld	s3,8(sp)
    80001eec:	6145                	addi	sp,sp,48
    80001eee:	8082                	ret

0000000080001ef0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001ef0:	1101                	addi	sp,sp,-32
    80001ef2:	ec06                	sd	ra,24(sp)
    80001ef4:	e822                	sd	s0,16(sp)
    80001ef6:	e426                	sd	s1,8(sp)
    80001ef8:	1000                	addi	s0,sp,32
    80001efa:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001efc:	00000097          	auipc	ra,0x0
    80001f00:	ef2080e7          	jalr	-270(ra) # 80001dee <argraw>
    80001f04:	c088                	sw	a0,0(s1)
  return 0;
}
    80001f06:	4501                	li	a0,0
    80001f08:	60e2                	ld	ra,24(sp)
    80001f0a:	6442                	ld	s0,16(sp)
    80001f0c:	64a2                	ld	s1,8(sp)
    80001f0e:	6105                	addi	sp,sp,32
    80001f10:	8082                	ret

0000000080001f12 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001f12:	1101                	addi	sp,sp,-32
    80001f14:	ec06                	sd	ra,24(sp)
    80001f16:	e822                	sd	s0,16(sp)
    80001f18:	e426                	sd	s1,8(sp)
    80001f1a:	1000                	addi	s0,sp,32
    80001f1c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f1e:	00000097          	auipc	ra,0x0
    80001f22:	ed0080e7          	jalr	-304(ra) # 80001dee <argraw>
    80001f26:	e088                	sd	a0,0(s1)
  return 0;
}
    80001f28:	4501                	li	a0,0
    80001f2a:	60e2                	ld	ra,24(sp)
    80001f2c:	6442                	ld	s0,16(sp)
    80001f2e:	64a2                	ld	s1,8(sp)
    80001f30:	6105                	addi	sp,sp,32
    80001f32:	8082                	ret

0000000080001f34 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001f34:	1101                	addi	sp,sp,-32
    80001f36:	ec06                	sd	ra,24(sp)
    80001f38:	e822                	sd	s0,16(sp)
    80001f3a:	e426                	sd	s1,8(sp)
    80001f3c:	e04a                	sd	s2,0(sp)
    80001f3e:	1000                	addi	s0,sp,32
    80001f40:	84ae                	mv	s1,a1
    80001f42:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001f44:	00000097          	auipc	ra,0x0
    80001f48:	eaa080e7          	jalr	-342(ra) # 80001dee <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001f4c:	864a                	mv	a2,s2
    80001f4e:	85a6                	mv	a1,s1
    80001f50:	00000097          	auipc	ra,0x0
    80001f54:	f58080e7          	jalr	-168(ra) # 80001ea8 <fetchstr>
}
    80001f58:	60e2                	ld	ra,24(sp)
    80001f5a:	6442                	ld	s0,16(sp)
    80001f5c:	64a2                	ld	s1,8(sp)
    80001f5e:	6902                	ld	s2,0(sp)
    80001f60:	6105                	addi	sp,sp,32
    80001f62:	8082                	ret

0000000080001f64 <syscall>:



void
syscall(void)
{
    80001f64:	1101                	addi	sp,sp,-32
    80001f66:	ec06                	sd	ra,24(sp)
    80001f68:	e822                	sd	s0,16(sp)
    80001f6a:	e426                	sd	s1,8(sp)
    80001f6c:	e04a                	sd	s2,0(sp)
    80001f6e:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001f70:	fffff097          	auipc	ra,0xfffff
    80001f74:	ed4080e7          	jalr	-300(ra) # 80000e44 <myproc>
    80001f78:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001f7a:	05853903          	ld	s2,88(a0)
    80001f7e:	0a893783          	ld	a5,168(s2)
    80001f82:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001f86:	37fd                	addiw	a5,a5,-1
    80001f88:	4775                	li	a4,29
    80001f8a:	00f76f63          	bltu	a4,a5,80001fa8 <syscall+0x44>
    80001f8e:	00369713          	slli	a4,a3,0x3
    80001f92:	00006797          	auipc	a5,0x6
    80001f96:	43678793          	addi	a5,a5,1078 # 800083c8 <syscalls>
    80001f9a:	97ba                	add	a5,a5,a4
    80001f9c:	639c                	ld	a5,0(a5)
    80001f9e:	c789                	beqz	a5,80001fa8 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80001fa0:	9782                	jalr	a5
    80001fa2:	06a93823          	sd	a0,112(s2)
    80001fa6:	a839                	j	80001fc4 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001fa8:	15848613          	addi	a2,s1,344
    80001fac:	588c                	lw	a1,48(s1)
    80001fae:	00006517          	auipc	a0,0x6
    80001fb2:	3e250513          	addi	a0,a0,994 # 80008390 <states.1711+0x150>
    80001fb6:	00004097          	auipc	ra,0x4
    80001fba:	bbc080e7          	jalr	-1092(ra) # 80005b72 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001fbe:	6cbc                	ld	a5,88(s1)
    80001fc0:	577d                	li	a4,-1
    80001fc2:	fbb8                	sd	a4,112(a5)
  }
}
    80001fc4:	60e2                	ld	ra,24(sp)
    80001fc6:	6442                	ld	s0,16(sp)
    80001fc8:	64a2                	ld	s1,8(sp)
    80001fca:	6902                	ld	s2,0(sp)
    80001fcc:	6105                	addi	sp,sp,32
    80001fce:	8082                	ret

0000000080001fd0 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80001fd0:	1101                	addi	sp,sp,-32
    80001fd2:	ec06                	sd	ra,24(sp)
    80001fd4:	e822                	sd	s0,16(sp)
    80001fd6:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80001fd8:	fec40593          	addi	a1,s0,-20
    80001fdc:	4501                	li	a0,0
    80001fde:	00000097          	auipc	ra,0x0
    80001fe2:	f12080e7          	jalr	-238(ra) # 80001ef0 <argint>
    return -1;
    80001fe6:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80001fe8:	00054963          	bltz	a0,80001ffa <sys_exit+0x2a>
  exit(n);
    80001fec:	fec42503          	lw	a0,-20(s0)
    80001ff0:	fffff097          	auipc	ra,0xfffff
    80001ff4:	76c080e7          	jalr	1900(ra) # 8000175c <exit>
  return 0;  // not reached
    80001ff8:	4781                	li	a5,0
}
    80001ffa:	853e                	mv	a0,a5
    80001ffc:	60e2                	ld	ra,24(sp)
    80001ffe:	6442                	ld	s0,16(sp)
    80002000:	6105                	addi	sp,sp,32
    80002002:	8082                	ret

0000000080002004 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002004:	1141                	addi	sp,sp,-16
    80002006:	e406                	sd	ra,8(sp)
    80002008:	e022                	sd	s0,0(sp)
    8000200a:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000200c:	fffff097          	auipc	ra,0xfffff
    80002010:	e38080e7          	jalr	-456(ra) # 80000e44 <myproc>
}
    80002014:	5908                	lw	a0,48(a0)
    80002016:	60a2                	ld	ra,8(sp)
    80002018:	6402                	ld	s0,0(sp)
    8000201a:	0141                	addi	sp,sp,16
    8000201c:	8082                	ret

000000008000201e <sys_fork>:

uint64
sys_fork(void)
{
    8000201e:	1141                	addi	sp,sp,-16
    80002020:	e406                	sd	ra,8(sp)
    80002022:	e022                	sd	s0,0(sp)
    80002024:	0800                	addi	s0,sp,16
  return fork();
    80002026:	fffff097          	auipc	ra,0xfffff
    8000202a:	1ec080e7          	jalr	492(ra) # 80001212 <fork>
}
    8000202e:	60a2                	ld	ra,8(sp)
    80002030:	6402                	ld	s0,0(sp)
    80002032:	0141                	addi	sp,sp,16
    80002034:	8082                	ret

0000000080002036 <sys_wait>:

uint64
sys_wait(void)
{
    80002036:	1101                	addi	sp,sp,-32
    80002038:	ec06                	sd	ra,24(sp)
    8000203a:	e822                	sd	s0,16(sp)
    8000203c:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    8000203e:	fe840593          	addi	a1,s0,-24
    80002042:	4501                	li	a0,0
    80002044:	00000097          	auipc	ra,0x0
    80002048:	ece080e7          	jalr	-306(ra) # 80001f12 <argaddr>
    8000204c:	87aa                	mv	a5,a0
    return -1;
    8000204e:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002050:	0007c863          	bltz	a5,80002060 <sys_wait+0x2a>
  return wait(p);
    80002054:	fe843503          	ld	a0,-24(s0)
    80002058:	fffff097          	auipc	ra,0xfffff
    8000205c:	50c080e7          	jalr	1292(ra) # 80001564 <wait>
}
    80002060:	60e2                	ld	ra,24(sp)
    80002062:	6442                	ld	s0,16(sp)
    80002064:	6105                	addi	sp,sp,32
    80002066:	8082                	ret

0000000080002068 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002068:	7179                	addi	sp,sp,-48
    8000206a:	f406                	sd	ra,40(sp)
    8000206c:	f022                	sd	s0,32(sp)
    8000206e:	ec26                	sd	s1,24(sp)
    80002070:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002072:	fdc40593          	addi	a1,s0,-36
    80002076:	4501                	li	a0,0
    80002078:	00000097          	auipc	ra,0x0
    8000207c:	e78080e7          	jalr	-392(ra) # 80001ef0 <argint>
    80002080:	87aa                	mv	a5,a0
    return -1;
    80002082:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002084:	0207c063          	bltz	a5,800020a4 <sys_sbrk+0x3c>
  
  addr = myproc()->sz;
    80002088:	fffff097          	auipc	ra,0xfffff
    8000208c:	dbc080e7          	jalr	-580(ra) # 80000e44 <myproc>
    80002090:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002092:	fdc42503          	lw	a0,-36(s0)
    80002096:	fffff097          	auipc	ra,0xfffff
    8000209a:	108080e7          	jalr	264(ra) # 8000119e <growproc>
    8000209e:	00054863          	bltz	a0,800020ae <sys_sbrk+0x46>
    return -1;
  return addr;
    800020a2:	8526                	mv	a0,s1
}
    800020a4:	70a2                	ld	ra,40(sp)
    800020a6:	7402                	ld	s0,32(sp)
    800020a8:	64e2                	ld	s1,24(sp)
    800020aa:	6145                	addi	sp,sp,48
    800020ac:	8082                	ret
    return -1;
    800020ae:	557d                	li	a0,-1
    800020b0:	bfd5                	j	800020a4 <sys_sbrk+0x3c>

00000000800020b2 <sys_sleep>:

uint64
sys_sleep(void)
{
    800020b2:	7139                	addi	sp,sp,-64
    800020b4:	fc06                	sd	ra,56(sp)
    800020b6:	f822                	sd	s0,48(sp)
    800020b8:	f426                	sd	s1,40(sp)
    800020ba:	f04a                	sd	s2,32(sp)
    800020bc:	ec4e                	sd	s3,24(sp)
    800020be:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  if(argint(0, &n) < 0)
    800020c0:	fcc40593          	addi	a1,s0,-52
    800020c4:	4501                	li	a0,0
    800020c6:	00000097          	auipc	ra,0x0
    800020ca:	e2a080e7          	jalr	-470(ra) # 80001ef0 <argint>
    return -1;
    800020ce:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800020d0:	06054563          	bltz	a0,8000213a <sys_sleep+0x88>
  acquire(&tickslock);
    800020d4:	0000d517          	auipc	a0,0xd
    800020d8:	dac50513          	addi	a0,a0,-596 # 8000ee80 <tickslock>
    800020dc:	00004097          	auipc	ra,0x4
    800020e0:	f96080e7          	jalr	-106(ra) # 80006072 <acquire>
  ticks0 = ticks;
    800020e4:	00007917          	auipc	s2,0x7
    800020e8:	f3492903          	lw	s2,-204(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800020ec:	fcc42783          	lw	a5,-52(s0)
    800020f0:	cf85                	beqz	a5,80002128 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800020f2:	0000d997          	auipc	s3,0xd
    800020f6:	d8e98993          	addi	s3,s3,-626 # 8000ee80 <tickslock>
    800020fa:	00007497          	auipc	s1,0x7
    800020fe:	f1e48493          	addi	s1,s1,-226 # 80009018 <ticks>
    if(myproc()->killed){
    80002102:	fffff097          	auipc	ra,0xfffff
    80002106:	d42080e7          	jalr	-702(ra) # 80000e44 <myproc>
    8000210a:	551c                	lw	a5,40(a0)
    8000210c:	ef9d                	bnez	a5,8000214a <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    8000210e:	85ce                	mv	a1,s3
    80002110:	8526                	mv	a0,s1
    80002112:	fffff097          	auipc	ra,0xfffff
    80002116:	3ee080e7          	jalr	1006(ra) # 80001500 <sleep>
  while(ticks - ticks0 < n){
    8000211a:	409c                	lw	a5,0(s1)
    8000211c:	412787bb          	subw	a5,a5,s2
    80002120:	fcc42703          	lw	a4,-52(s0)
    80002124:	fce7efe3          	bltu	a5,a4,80002102 <sys_sleep+0x50>
  }
  release(&tickslock);
    80002128:	0000d517          	auipc	a0,0xd
    8000212c:	d5850513          	addi	a0,a0,-680 # 8000ee80 <tickslock>
    80002130:	00004097          	auipc	ra,0x4
    80002134:	ff6080e7          	jalr	-10(ra) # 80006126 <release>
  return 0;
    80002138:	4781                	li	a5,0
}
    8000213a:	853e                	mv	a0,a5
    8000213c:	70e2                	ld	ra,56(sp)
    8000213e:	7442                	ld	s0,48(sp)
    80002140:	74a2                	ld	s1,40(sp)
    80002142:	7902                	ld	s2,32(sp)
    80002144:	69e2                	ld	s3,24(sp)
    80002146:	6121                	addi	sp,sp,64
    80002148:	8082                	ret
      release(&tickslock);
    8000214a:	0000d517          	auipc	a0,0xd
    8000214e:	d3650513          	addi	a0,a0,-714 # 8000ee80 <tickslock>
    80002152:	00004097          	auipc	ra,0x4
    80002156:	fd4080e7          	jalr	-44(ra) # 80006126 <release>
      return -1;
    8000215a:	57fd                	li	a5,-1
    8000215c:	bff9                	j	8000213a <sys_sleep+0x88>

000000008000215e <sys_pgaccess>:


#ifdef LAB_PGTBL
int
sys_pgaccess(void)
{
    8000215e:	1141                	addi	sp,sp,-16
    80002160:	e422                	sd	s0,8(sp)
    80002162:	0800                	addi	s0,sp,16
  // lab pgtbl: your code here.
  return 0;
}
    80002164:	4501                	li	a0,0
    80002166:	6422                	ld	s0,8(sp)
    80002168:	0141                	addi	sp,sp,16
    8000216a:	8082                	ret

000000008000216c <sys_kill>:
#endif

uint64
sys_kill(void)
{
    8000216c:	1101                	addi	sp,sp,-32
    8000216e:	ec06                	sd	ra,24(sp)
    80002170:	e822                	sd	s0,16(sp)
    80002172:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002174:	fec40593          	addi	a1,s0,-20
    80002178:	4501                	li	a0,0
    8000217a:	00000097          	auipc	ra,0x0
    8000217e:	d76080e7          	jalr	-650(ra) # 80001ef0 <argint>
    80002182:	87aa                	mv	a5,a0
    return -1;
    80002184:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002186:	0007c863          	bltz	a5,80002196 <sys_kill+0x2a>
  return kill(pid);
    8000218a:	fec42503          	lw	a0,-20(s0)
    8000218e:	fffff097          	auipc	ra,0xfffff
    80002192:	6a4080e7          	jalr	1700(ra) # 80001832 <kill>
}
    80002196:	60e2                	ld	ra,24(sp)
    80002198:	6442                	ld	s0,16(sp)
    8000219a:	6105                	addi	sp,sp,32
    8000219c:	8082                	ret

000000008000219e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000219e:	1101                	addi	sp,sp,-32
    800021a0:	ec06                	sd	ra,24(sp)
    800021a2:	e822                	sd	s0,16(sp)
    800021a4:	e426                	sd	s1,8(sp)
    800021a6:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800021a8:	0000d517          	auipc	a0,0xd
    800021ac:	cd850513          	addi	a0,a0,-808 # 8000ee80 <tickslock>
    800021b0:	00004097          	auipc	ra,0x4
    800021b4:	ec2080e7          	jalr	-318(ra) # 80006072 <acquire>
  xticks = ticks;
    800021b8:	00007497          	auipc	s1,0x7
    800021bc:	e604a483          	lw	s1,-416(s1) # 80009018 <ticks>
  release(&tickslock);
    800021c0:	0000d517          	auipc	a0,0xd
    800021c4:	cc050513          	addi	a0,a0,-832 # 8000ee80 <tickslock>
    800021c8:	00004097          	auipc	ra,0x4
    800021cc:	f5e080e7          	jalr	-162(ra) # 80006126 <release>
  return xticks;
}
    800021d0:	02049513          	slli	a0,s1,0x20
    800021d4:	9101                	srli	a0,a0,0x20
    800021d6:	60e2                	ld	ra,24(sp)
    800021d8:	6442                	ld	s0,16(sp)
    800021da:	64a2                	ld	s1,8(sp)
    800021dc:	6105                	addi	sp,sp,32
    800021de:	8082                	ret

00000000800021e0 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800021e0:	7179                	addi	sp,sp,-48
    800021e2:	f406                	sd	ra,40(sp)
    800021e4:	f022                	sd	s0,32(sp)
    800021e6:	ec26                	sd	s1,24(sp)
    800021e8:	e84a                	sd	s2,16(sp)
    800021ea:	e44e                	sd	s3,8(sp)
    800021ec:	e052                	sd	s4,0(sp)
    800021ee:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800021f0:	00006597          	auipc	a1,0x6
    800021f4:	2d058593          	addi	a1,a1,720 # 800084c0 <syscalls+0xf8>
    800021f8:	0000d517          	auipc	a0,0xd
    800021fc:	ca050513          	addi	a0,a0,-864 # 8000ee98 <bcache>
    80002200:	00004097          	auipc	ra,0x4
    80002204:	de2080e7          	jalr	-542(ra) # 80005fe2 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002208:	00015797          	auipc	a5,0x15
    8000220c:	c9078793          	addi	a5,a5,-880 # 80016e98 <bcache+0x8000>
    80002210:	00015717          	auipc	a4,0x15
    80002214:	ef070713          	addi	a4,a4,-272 # 80017100 <bcache+0x8268>
    80002218:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000221c:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002220:	0000d497          	auipc	s1,0xd
    80002224:	c9048493          	addi	s1,s1,-880 # 8000eeb0 <bcache+0x18>
    b->next = bcache.head.next;
    80002228:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000222a:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000222c:	00006a17          	auipc	s4,0x6
    80002230:	29ca0a13          	addi	s4,s4,668 # 800084c8 <syscalls+0x100>
    b->next = bcache.head.next;
    80002234:	2b893783          	ld	a5,696(s2)
    80002238:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000223a:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000223e:	85d2                	mv	a1,s4
    80002240:	01048513          	addi	a0,s1,16
    80002244:	00001097          	auipc	ra,0x1
    80002248:	4bc080e7          	jalr	1212(ra) # 80003700 <initsleeplock>
    bcache.head.next->prev = b;
    8000224c:	2b893783          	ld	a5,696(s2)
    80002250:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002252:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002256:	45848493          	addi	s1,s1,1112
    8000225a:	fd349de3          	bne	s1,s3,80002234 <binit+0x54>
  }
}
    8000225e:	70a2                	ld	ra,40(sp)
    80002260:	7402                	ld	s0,32(sp)
    80002262:	64e2                	ld	s1,24(sp)
    80002264:	6942                	ld	s2,16(sp)
    80002266:	69a2                	ld	s3,8(sp)
    80002268:	6a02                	ld	s4,0(sp)
    8000226a:	6145                	addi	sp,sp,48
    8000226c:	8082                	ret

000000008000226e <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000226e:	7179                	addi	sp,sp,-48
    80002270:	f406                	sd	ra,40(sp)
    80002272:	f022                	sd	s0,32(sp)
    80002274:	ec26                	sd	s1,24(sp)
    80002276:	e84a                	sd	s2,16(sp)
    80002278:	e44e                	sd	s3,8(sp)
    8000227a:	1800                	addi	s0,sp,48
    8000227c:	89aa                	mv	s3,a0
    8000227e:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002280:	0000d517          	auipc	a0,0xd
    80002284:	c1850513          	addi	a0,a0,-1000 # 8000ee98 <bcache>
    80002288:	00004097          	auipc	ra,0x4
    8000228c:	dea080e7          	jalr	-534(ra) # 80006072 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002290:	00015497          	auipc	s1,0x15
    80002294:	ec04b483          	ld	s1,-320(s1) # 80017150 <bcache+0x82b8>
    80002298:	00015797          	auipc	a5,0x15
    8000229c:	e6878793          	addi	a5,a5,-408 # 80017100 <bcache+0x8268>
    800022a0:	02f48f63          	beq	s1,a5,800022de <bread+0x70>
    800022a4:	873e                	mv	a4,a5
    800022a6:	a021                	j	800022ae <bread+0x40>
    800022a8:	68a4                	ld	s1,80(s1)
    800022aa:	02e48a63          	beq	s1,a4,800022de <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800022ae:	449c                	lw	a5,8(s1)
    800022b0:	ff379ce3          	bne	a5,s3,800022a8 <bread+0x3a>
    800022b4:	44dc                	lw	a5,12(s1)
    800022b6:	ff2799e3          	bne	a5,s2,800022a8 <bread+0x3a>
      b->refcnt++;
    800022ba:	40bc                	lw	a5,64(s1)
    800022bc:	2785                	addiw	a5,a5,1
    800022be:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800022c0:	0000d517          	auipc	a0,0xd
    800022c4:	bd850513          	addi	a0,a0,-1064 # 8000ee98 <bcache>
    800022c8:	00004097          	auipc	ra,0x4
    800022cc:	e5e080e7          	jalr	-418(ra) # 80006126 <release>
      acquiresleep(&b->lock);
    800022d0:	01048513          	addi	a0,s1,16
    800022d4:	00001097          	auipc	ra,0x1
    800022d8:	466080e7          	jalr	1126(ra) # 8000373a <acquiresleep>
      return b;
    800022dc:	a8b9                	j	8000233a <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800022de:	00015497          	auipc	s1,0x15
    800022e2:	e6a4b483          	ld	s1,-406(s1) # 80017148 <bcache+0x82b0>
    800022e6:	00015797          	auipc	a5,0x15
    800022ea:	e1a78793          	addi	a5,a5,-486 # 80017100 <bcache+0x8268>
    800022ee:	00f48863          	beq	s1,a5,800022fe <bread+0x90>
    800022f2:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800022f4:	40bc                	lw	a5,64(s1)
    800022f6:	cf81                	beqz	a5,8000230e <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800022f8:	64a4                	ld	s1,72(s1)
    800022fa:	fee49de3          	bne	s1,a4,800022f4 <bread+0x86>
  panic("bget: no buffers");
    800022fe:	00006517          	auipc	a0,0x6
    80002302:	1d250513          	addi	a0,a0,466 # 800084d0 <syscalls+0x108>
    80002306:	00004097          	auipc	ra,0x4
    8000230a:	822080e7          	jalr	-2014(ra) # 80005b28 <panic>
      b->dev = dev;
    8000230e:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002312:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002316:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000231a:	4785                	li	a5,1
    8000231c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000231e:	0000d517          	auipc	a0,0xd
    80002322:	b7a50513          	addi	a0,a0,-1158 # 8000ee98 <bcache>
    80002326:	00004097          	auipc	ra,0x4
    8000232a:	e00080e7          	jalr	-512(ra) # 80006126 <release>
      acquiresleep(&b->lock);
    8000232e:	01048513          	addi	a0,s1,16
    80002332:	00001097          	auipc	ra,0x1
    80002336:	408080e7          	jalr	1032(ra) # 8000373a <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000233a:	409c                	lw	a5,0(s1)
    8000233c:	cb89                	beqz	a5,8000234e <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000233e:	8526                	mv	a0,s1
    80002340:	70a2                	ld	ra,40(sp)
    80002342:	7402                	ld	s0,32(sp)
    80002344:	64e2                	ld	s1,24(sp)
    80002346:	6942                	ld	s2,16(sp)
    80002348:	69a2                	ld	s3,8(sp)
    8000234a:	6145                	addi	sp,sp,48
    8000234c:	8082                	ret
    virtio_disk_rw(b, 0);
    8000234e:	4581                	li	a1,0
    80002350:	8526                	mv	a0,s1
    80002352:	00003097          	auipc	ra,0x3
    80002356:	f14080e7          	jalr	-236(ra) # 80005266 <virtio_disk_rw>
    b->valid = 1;
    8000235a:	4785                	li	a5,1
    8000235c:	c09c                	sw	a5,0(s1)
  return b;
    8000235e:	b7c5                	j	8000233e <bread+0xd0>

0000000080002360 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002360:	1101                	addi	sp,sp,-32
    80002362:	ec06                	sd	ra,24(sp)
    80002364:	e822                	sd	s0,16(sp)
    80002366:	e426                	sd	s1,8(sp)
    80002368:	1000                	addi	s0,sp,32
    8000236a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000236c:	0541                	addi	a0,a0,16
    8000236e:	00001097          	auipc	ra,0x1
    80002372:	466080e7          	jalr	1126(ra) # 800037d4 <holdingsleep>
    80002376:	cd01                	beqz	a0,8000238e <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002378:	4585                	li	a1,1
    8000237a:	8526                	mv	a0,s1
    8000237c:	00003097          	auipc	ra,0x3
    80002380:	eea080e7          	jalr	-278(ra) # 80005266 <virtio_disk_rw>
}
    80002384:	60e2                	ld	ra,24(sp)
    80002386:	6442                	ld	s0,16(sp)
    80002388:	64a2                	ld	s1,8(sp)
    8000238a:	6105                	addi	sp,sp,32
    8000238c:	8082                	ret
    panic("bwrite");
    8000238e:	00006517          	auipc	a0,0x6
    80002392:	15a50513          	addi	a0,a0,346 # 800084e8 <syscalls+0x120>
    80002396:	00003097          	auipc	ra,0x3
    8000239a:	792080e7          	jalr	1938(ra) # 80005b28 <panic>

000000008000239e <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000239e:	1101                	addi	sp,sp,-32
    800023a0:	ec06                	sd	ra,24(sp)
    800023a2:	e822                	sd	s0,16(sp)
    800023a4:	e426                	sd	s1,8(sp)
    800023a6:	e04a                	sd	s2,0(sp)
    800023a8:	1000                	addi	s0,sp,32
    800023aa:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023ac:	01050913          	addi	s2,a0,16
    800023b0:	854a                	mv	a0,s2
    800023b2:	00001097          	auipc	ra,0x1
    800023b6:	422080e7          	jalr	1058(ra) # 800037d4 <holdingsleep>
    800023ba:	c92d                	beqz	a0,8000242c <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800023bc:	854a                	mv	a0,s2
    800023be:	00001097          	auipc	ra,0x1
    800023c2:	3d2080e7          	jalr	978(ra) # 80003790 <releasesleep>

  acquire(&bcache.lock);
    800023c6:	0000d517          	auipc	a0,0xd
    800023ca:	ad250513          	addi	a0,a0,-1326 # 8000ee98 <bcache>
    800023ce:	00004097          	auipc	ra,0x4
    800023d2:	ca4080e7          	jalr	-860(ra) # 80006072 <acquire>
  b->refcnt--;
    800023d6:	40bc                	lw	a5,64(s1)
    800023d8:	37fd                	addiw	a5,a5,-1
    800023da:	0007871b          	sext.w	a4,a5
    800023de:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800023e0:	eb05                	bnez	a4,80002410 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800023e2:	68bc                	ld	a5,80(s1)
    800023e4:	64b8                	ld	a4,72(s1)
    800023e6:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800023e8:	64bc                	ld	a5,72(s1)
    800023ea:	68b8                	ld	a4,80(s1)
    800023ec:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800023ee:	00015797          	auipc	a5,0x15
    800023f2:	aaa78793          	addi	a5,a5,-1366 # 80016e98 <bcache+0x8000>
    800023f6:	2b87b703          	ld	a4,696(a5)
    800023fa:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800023fc:	00015717          	auipc	a4,0x15
    80002400:	d0470713          	addi	a4,a4,-764 # 80017100 <bcache+0x8268>
    80002404:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002406:	2b87b703          	ld	a4,696(a5)
    8000240a:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000240c:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002410:	0000d517          	auipc	a0,0xd
    80002414:	a8850513          	addi	a0,a0,-1400 # 8000ee98 <bcache>
    80002418:	00004097          	auipc	ra,0x4
    8000241c:	d0e080e7          	jalr	-754(ra) # 80006126 <release>
}
    80002420:	60e2                	ld	ra,24(sp)
    80002422:	6442                	ld	s0,16(sp)
    80002424:	64a2                	ld	s1,8(sp)
    80002426:	6902                	ld	s2,0(sp)
    80002428:	6105                	addi	sp,sp,32
    8000242a:	8082                	ret
    panic("brelse");
    8000242c:	00006517          	auipc	a0,0x6
    80002430:	0c450513          	addi	a0,a0,196 # 800084f0 <syscalls+0x128>
    80002434:	00003097          	auipc	ra,0x3
    80002438:	6f4080e7          	jalr	1780(ra) # 80005b28 <panic>

000000008000243c <bpin>:

void
bpin(struct buf *b) {
    8000243c:	1101                	addi	sp,sp,-32
    8000243e:	ec06                	sd	ra,24(sp)
    80002440:	e822                	sd	s0,16(sp)
    80002442:	e426                	sd	s1,8(sp)
    80002444:	1000                	addi	s0,sp,32
    80002446:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002448:	0000d517          	auipc	a0,0xd
    8000244c:	a5050513          	addi	a0,a0,-1456 # 8000ee98 <bcache>
    80002450:	00004097          	auipc	ra,0x4
    80002454:	c22080e7          	jalr	-990(ra) # 80006072 <acquire>
  b->refcnt++;
    80002458:	40bc                	lw	a5,64(s1)
    8000245a:	2785                	addiw	a5,a5,1
    8000245c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000245e:	0000d517          	auipc	a0,0xd
    80002462:	a3a50513          	addi	a0,a0,-1478 # 8000ee98 <bcache>
    80002466:	00004097          	auipc	ra,0x4
    8000246a:	cc0080e7          	jalr	-832(ra) # 80006126 <release>
}
    8000246e:	60e2                	ld	ra,24(sp)
    80002470:	6442                	ld	s0,16(sp)
    80002472:	64a2                	ld	s1,8(sp)
    80002474:	6105                	addi	sp,sp,32
    80002476:	8082                	ret

0000000080002478 <bunpin>:

void
bunpin(struct buf *b) {
    80002478:	1101                	addi	sp,sp,-32
    8000247a:	ec06                	sd	ra,24(sp)
    8000247c:	e822                	sd	s0,16(sp)
    8000247e:	e426                	sd	s1,8(sp)
    80002480:	1000                	addi	s0,sp,32
    80002482:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002484:	0000d517          	auipc	a0,0xd
    80002488:	a1450513          	addi	a0,a0,-1516 # 8000ee98 <bcache>
    8000248c:	00004097          	auipc	ra,0x4
    80002490:	be6080e7          	jalr	-1050(ra) # 80006072 <acquire>
  b->refcnt--;
    80002494:	40bc                	lw	a5,64(s1)
    80002496:	37fd                	addiw	a5,a5,-1
    80002498:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000249a:	0000d517          	auipc	a0,0xd
    8000249e:	9fe50513          	addi	a0,a0,-1538 # 8000ee98 <bcache>
    800024a2:	00004097          	auipc	ra,0x4
    800024a6:	c84080e7          	jalr	-892(ra) # 80006126 <release>
}
    800024aa:	60e2                	ld	ra,24(sp)
    800024ac:	6442                	ld	s0,16(sp)
    800024ae:	64a2                	ld	s1,8(sp)
    800024b0:	6105                	addi	sp,sp,32
    800024b2:	8082                	ret

00000000800024b4 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800024b4:	1101                	addi	sp,sp,-32
    800024b6:	ec06                	sd	ra,24(sp)
    800024b8:	e822                	sd	s0,16(sp)
    800024ba:	e426                	sd	s1,8(sp)
    800024bc:	e04a                	sd	s2,0(sp)
    800024be:	1000                	addi	s0,sp,32
    800024c0:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800024c2:	00d5d59b          	srliw	a1,a1,0xd
    800024c6:	00015797          	auipc	a5,0x15
    800024ca:	0ae7a783          	lw	a5,174(a5) # 80017574 <sb+0x1c>
    800024ce:	9dbd                	addw	a1,a1,a5
    800024d0:	00000097          	auipc	ra,0x0
    800024d4:	d9e080e7          	jalr	-610(ra) # 8000226e <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800024d8:	0074f713          	andi	a4,s1,7
    800024dc:	4785                	li	a5,1
    800024de:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800024e2:	14ce                	slli	s1,s1,0x33
    800024e4:	90d9                	srli	s1,s1,0x36
    800024e6:	00950733          	add	a4,a0,s1
    800024ea:	05874703          	lbu	a4,88(a4)
    800024ee:	00e7f6b3          	and	a3,a5,a4
    800024f2:	c69d                	beqz	a3,80002520 <bfree+0x6c>
    800024f4:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800024f6:	94aa                	add	s1,s1,a0
    800024f8:	fff7c793          	not	a5,a5
    800024fc:	8ff9                	and	a5,a5,a4
    800024fe:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002502:	00001097          	auipc	ra,0x1
    80002506:	118080e7          	jalr	280(ra) # 8000361a <log_write>
  brelse(bp);
    8000250a:	854a                	mv	a0,s2
    8000250c:	00000097          	auipc	ra,0x0
    80002510:	e92080e7          	jalr	-366(ra) # 8000239e <brelse>
}
    80002514:	60e2                	ld	ra,24(sp)
    80002516:	6442                	ld	s0,16(sp)
    80002518:	64a2                	ld	s1,8(sp)
    8000251a:	6902                	ld	s2,0(sp)
    8000251c:	6105                	addi	sp,sp,32
    8000251e:	8082                	ret
    panic("freeing free block");
    80002520:	00006517          	auipc	a0,0x6
    80002524:	fd850513          	addi	a0,a0,-40 # 800084f8 <syscalls+0x130>
    80002528:	00003097          	auipc	ra,0x3
    8000252c:	600080e7          	jalr	1536(ra) # 80005b28 <panic>

0000000080002530 <balloc>:
{
    80002530:	711d                	addi	sp,sp,-96
    80002532:	ec86                	sd	ra,88(sp)
    80002534:	e8a2                	sd	s0,80(sp)
    80002536:	e4a6                	sd	s1,72(sp)
    80002538:	e0ca                	sd	s2,64(sp)
    8000253a:	fc4e                	sd	s3,56(sp)
    8000253c:	f852                	sd	s4,48(sp)
    8000253e:	f456                	sd	s5,40(sp)
    80002540:	f05a                	sd	s6,32(sp)
    80002542:	ec5e                	sd	s7,24(sp)
    80002544:	e862                	sd	s8,16(sp)
    80002546:	e466                	sd	s9,8(sp)
    80002548:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000254a:	00015797          	auipc	a5,0x15
    8000254e:	0127a783          	lw	a5,18(a5) # 8001755c <sb+0x4>
    80002552:	cbd1                	beqz	a5,800025e6 <balloc+0xb6>
    80002554:	8baa                	mv	s7,a0
    80002556:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002558:	00015b17          	auipc	s6,0x15
    8000255c:	000b0b13          	mv	s6,s6
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002560:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002562:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002564:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002566:	6c89                	lui	s9,0x2
    80002568:	a831                	j	80002584 <balloc+0x54>
    brelse(bp);
    8000256a:	854a                	mv	a0,s2
    8000256c:	00000097          	auipc	ra,0x0
    80002570:	e32080e7          	jalr	-462(ra) # 8000239e <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002574:	015c87bb          	addw	a5,s9,s5
    80002578:	00078a9b          	sext.w	s5,a5
    8000257c:	004b2703          	lw	a4,4(s6) # 8001755c <sb+0x4>
    80002580:	06eaf363          	bgeu	s5,a4,800025e6 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80002584:	41fad79b          	sraiw	a5,s5,0x1f
    80002588:	0137d79b          	srliw	a5,a5,0x13
    8000258c:	015787bb          	addw	a5,a5,s5
    80002590:	40d7d79b          	sraiw	a5,a5,0xd
    80002594:	01cb2583          	lw	a1,28(s6)
    80002598:	9dbd                	addw	a1,a1,a5
    8000259a:	855e                	mv	a0,s7
    8000259c:	00000097          	auipc	ra,0x0
    800025a0:	cd2080e7          	jalr	-814(ra) # 8000226e <bread>
    800025a4:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025a6:	004b2503          	lw	a0,4(s6)
    800025aa:	000a849b          	sext.w	s1,s5
    800025ae:	8662                	mv	a2,s8
    800025b0:	faa4fde3          	bgeu	s1,a0,8000256a <balloc+0x3a>
      m = 1 << (bi % 8);
    800025b4:	41f6579b          	sraiw	a5,a2,0x1f
    800025b8:	01d7d69b          	srliw	a3,a5,0x1d
    800025bc:	00c6873b          	addw	a4,a3,a2
    800025c0:	00777793          	andi	a5,a4,7
    800025c4:	9f95                	subw	a5,a5,a3
    800025c6:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800025ca:	4037571b          	sraiw	a4,a4,0x3
    800025ce:	00e906b3          	add	a3,s2,a4
    800025d2:	0586c683          	lbu	a3,88(a3)
    800025d6:	00d7f5b3          	and	a1,a5,a3
    800025da:	cd91                	beqz	a1,800025f6 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025dc:	2605                	addiw	a2,a2,1
    800025de:	2485                	addiw	s1,s1,1
    800025e0:	fd4618e3          	bne	a2,s4,800025b0 <balloc+0x80>
    800025e4:	b759                	j	8000256a <balloc+0x3a>
  panic("balloc: out of blocks");
    800025e6:	00006517          	auipc	a0,0x6
    800025ea:	f2a50513          	addi	a0,a0,-214 # 80008510 <syscalls+0x148>
    800025ee:	00003097          	auipc	ra,0x3
    800025f2:	53a080e7          	jalr	1338(ra) # 80005b28 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800025f6:	974a                	add	a4,a4,s2
    800025f8:	8fd5                	or	a5,a5,a3
    800025fa:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800025fe:	854a                	mv	a0,s2
    80002600:	00001097          	auipc	ra,0x1
    80002604:	01a080e7          	jalr	26(ra) # 8000361a <log_write>
        brelse(bp);
    80002608:	854a                	mv	a0,s2
    8000260a:	00000097          	auipc	ra,0x0
    8000260e:	d94080e7          	jalr	-620(ra) # 8000239e <brelse>
  bp = bread(dev, bno);
    80002612:	85a6                	mv	a1,s1
    80002614:	855e                	mv	a0,s7
    80002616:	00000097          	auipc	ra,0x0
    8000261a:	c58080e7          	jalr	-936(ra) # 8000226e <bread>
    8000261e:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002620:	40000613          	li	a2,1024
    80002624:	4581                	li	a1,0
    80002626:	05850513          	addi	a0,a0,88
    8000262a:	ffffe097          	auipc	ra,0xffffe
    8000262e:	b4e080e7          	jalr	-1202(ra) # 80000178 <memset>
  log_write(bp);
    80002632:	854a                	mv	a0,s2
    80002634:	00001097          	auipc	ra,0x1
    80002638:	fe6080e7          	jalr	-26(ra) # 8000361a <log_write>
  brelse(bp);
    8000263c:	854a                	mv	a0,s2
    8000263e:	00000097          	auipc	ra,0x0
    80002642:	d60080e7          	jalr	-672(ra) # 8000239e <brelse>
}
    80002646:	8526                	mv	a0,s1
    80002648:	60e6                	ld	ra,88(sp)
    8000264a:	6446                	ld	s0,80(sp)
    8000264c:	64a6                	ld	s1,72(sp)
    8000264e:	6906                	ld	s2,64(sp)
    80002650:	79e2                	ld	s3,56(sp)
    80002652:	7a42                	ld	s4,48(sp)
    80002654:	7aa2                	ld	s5,40(sp)
    80002656:	7b02                	ld	s6,32(sp)
    80002658:	6be2                	ld	s7,24(sp)
    8000265a:	6c42                	ld	s8,16(sp)
    8000265c:	6ca2                	ld	s9,8(sp)
    8000265e:	6125                	addi	sp,sp,96
    80002660:	8082                	ret

0000000080002662 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002662:	7179                	addi	sp,sp,-48
    80002664:	f406                	sd	ra,40(sp)
    80002666:	f022                	sd	s0,32(sp)
    80002668:	ec26                	sd	s1,24(sp)
    8000266a:	e84a                	sd	s2,16(sp)
    8000266c:	e44e                	sd	s3,8(sp)
    8000266e:	e052                	sd	s4,0(sp)
    80002670:	1800                	addi	s0,sp,48
    80002672:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002674:	47ad                	li	a5,11
    80002676:	04b7fe63          	bgeu	a5,a1,800026d2 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    8000267a:	ff45849b          	addiw	s1,a1,-12
    8000267e:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002682:	0ff00793          	li	a5,255
    80002686:	0ae7e363          	bltu	a5,a4,8000272c <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    8000268a:	08052583          	lw	a1,128(a0)
    8000268e:	c5ad                	beqz	a1,800026f8 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002690:	00092503          	lw	a0,0(s2)
    80002694:	00000097          	auipc	ra,0x0
    80002698:	bda080e7          	jalr	-1062(ra) # 8000226e <bread>
    8000269c:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000269e:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800026a2:	02049593          	slli	a1,s1,0x20
    800026a6:	9181                	srli	a1,a1,0x20
    800026a8:	058a                	slli	a1,a1,0x2
    800026aa:	00b784b3          	add	s1,a5,a1
    800026ae:	0004a983          	lw	s3,0(s1)
    800026b2:	04098d63          	beqz	s3,8000270c <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800026b6:	8552                	mv	a0,s4
    800026b8:	00000097          	auipc	ra,0x0
    800026bc:	ce6080e7          	jalr	-794(ra) # 8000239e <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800026c0:	854e                	mv	a0,s3
    800026c2:	70a2                	ld	ra,40(sp)
    800026c4:	7402                	ld	s0,32(sp)
    800026c6:	64e2                	ld	s1,24(sp)
    800026c8:	6942                	ld	s2,16(sp)
    800026ca:	69a2                	ld	s3,8(sp)
    800026cc:	6a02                	ld	s4,0(sp)
    800026ce:	6145                	addi	sp,sp,48
    800026d0:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800026d2:	02059493          	slli	s1,a1,0x20
    800026d6:	9081                	srli	s1,s1,0x20
    800026d8:	048a                	slli	s1,s1,0x2
    800026da:	94aa                	add	s1,s1,a0
    800026dc:	0504a983          	lw	s3,80(s1)
    800026e0:	fe0990e3          	bnez	s3,800026c0 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800026e4:	4108                	lw	a0,0(a0)
    800026e6:	00000097          	auipc	ra,0x0
    800026ea:	e4a080e7          	jalr	-438(ra) # 80002530 <balloc>
    800026ee:	0005099b          	sext.w	s3,a0
    800026f2:	0534a823          	sw	s3,80(s1)
    800026f6:	b7e9                	j	800026c0 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800026f8:	4108                	lw	a0,0(a0)
    800026fa:	00000097          	auipc	ra,0x0
    800026fe:	e36080e7          	jalr	-458(ra) # 80002530 <balloc>
    80002702:	0005059b          	sext.w	a1,a0
    80002706:	08b92023          	sw	a1,128(s2)
    8000270a:	b759                	j	80002690 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    8000270c:	00092503          	lw	a0,0(s2)
    80002710:	00000097          	auipc	ra,0x0
    80002714:	e20080e7          	jalr	-480(ra) # 80002530 <balloc>
    80002718:	0005099b          	sext.w	s3,a0
    8000271c:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002720:	8552                	mv	a0,s4
    80002722:	00001097          	auipc	ra,0x1
    80002726:	ef8080e7          	jalr	-264(ra) # 8000361a <log_write>
    8000272a:	b771                	j	800026b6 <bmap+0x54>
  panic("bmap: out of range");
    8000272c:	00006517          	auipc	a0,0x6
    80002730:	dfc50513          	addi	a0,a0,-516 # 80008528 <syscalls+0x160>
    80002734:	00003097          	auipc	ra,0x3
    80002738:	3f4080e7          	jalr	1012(ra) # 80005b28 <panic>

000000008000273c <iget>:
{
    8000273c:	7179                	addi	sp,sp,-48
    8000273e:	f406                	sd	ra,40(sp)
    80002740:	f022                	sd	s0,32(sp)
    80002742:	ec26                	sd	s1,24(sp)
    80002744:	e84a                	sd	s2,16(sp)
    80002746:	e44e                	sd	s3,8(sp)
    80002748:	e052                	sd	s4,0(sp)
    8000274a:	1800                	addi	s0,sp,48
    8000274c:	89aa                	mv	s3,a0
    8000274e:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002750:	00015517          	auipc	a0,0x15
    80002754:	e2850513          	addi	a0,a0,-472 # 80017578 <itable>
    80002758:	00004097          	auipc	ra,0x4
    8000275c:	91a080e7          	jalr	-1766(ra) # 80006072 <acquire>
  empty = 0;
    80002760:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002762:	00015497          	auipc	s1,0x15
    80002766:	e2e48493          	addi	s1,s1,-466 # 80017590 <itable+0x18>
    8000276a:	00017697          	auipc	a3,0x17
    8000276e:	8b668693          	addi	a3,a3,-1866 # 80019020 <log>
    80002772:	a039                	j	80002780 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002774:	02090b63          	beqz	s2,800027aa <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002778:	08848493          	addi	s1,s1,136
    8000277c:	02d48a63          	beq	s1,a3,800027b0 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002780:	449c                	lw	a5,8(s1)
    80002782:	fef059e3          	blez	a5,80002774 <iget+0x38>
    80002786:	4098                	lw	a4,0(s1)
    80002788:	ff3716e3          	bne	a4,s3,80002774 <iget+0x38>
    8000278c:	40d8                	lw	a4,4(s1)
    8000278e:	ff4713e3          	bne	a4,s4,80002774 <iget+0x38>
      ip->ref++;
    80002792:	2785                	addiw	a5,a5,1
    80002794:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002796:	00015517          	auipc	a0,0x15
    8000279a:	de250513          	addi	a0,a0,-542 # 80017578 <itable>
    8000279e:	00004097          	auipc	ra,0x4
    800027a2:	988080e7          	jalr	-1656(ra) # 80006126 <release>
      return ip;
    800027a6:	8926                	mv	s2,s1
    800027a8:	a03d                	j	800027d6 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800027aa:	f7f9                	bnez	a5,80002778 <iget+0x3c>
    800027ac:	8926                	mv	s2,s1
    800027ae:	b7e9                	j	80002778 <iget+0x3c>
  if(empty == 0)
    800027b0:	02090c63          	beqz	s2,800027e8 <iget+0xac>
  ip->dev = dev;
    800027b4:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800027b8:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800027bc:	4785                	li	a5,1
    800027be:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800027c2:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800027c6:	00015517          	auipc	a0,0x15
    800027ca:	db250513          	addi	a0,a0,-590 # 80017578 <itable>
    800027ce:	00004097          	auipc	ra,0x4
    800027d2:	958080e7          	jalr	-1704(ra) # 80006126 <release>
}
    800027d6:	854a                	mv	a0,s2
    800027d8:	70a2                	ld	ra,40(sp)
    800027da:	7402                	ld	s0,32(sp)
    800027dc:	64e2                	ld	s1,24(sp)
    800027de:	6942                	ld	s2,16(sp)
    800027e0:	69a2                	ld	s3,8(sp)
    800027e2:	6a02                	ld	s4,0(sp)
    800027e4:	6145                	addi	sp,sp,48
    800027e6:	8082                	ret
    panic("iget: no inodes");
    800027e8:	00006517          	auipc	a0,0x6
    800027ec:	d5850513          	addi	a0,a0,-680 # 80008540 <syscalls+0x178>
    800027f0:	00003097          	auipc	ra,0x3
    800027f4:	338080e7          	jalr	824(ra) # 80005b28 <panic>

00000000800027f8 <fsinit>:
fsinit(int dev) {
    800027f8:	7179                	addi	sp,sp,-48
    800027fa:	f406                	sd	ra,40(sp)
    800027fc:	f022                	sd	s0,32(sp)
    800027fe:	ec26                	sd	s1,24(sp)
    80002800:	e84a                	sd	s2,16(sp)
    80002802:	e44e                	sd	s3,8(sp)
    80002804:	1800                	addi	s0,sp,48
    80002806:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002808:	4585                	li	a1,1
    8000280a:	00000097          	auipc	ra,0x0
    8000280e:	a64080e7          	jalr	-1436(ra) # 8000226e <bread>
    80002812:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002814:	00015997          	auipc	s3,0x15
    80002818:	d4498993          	addi	s3,s3,-700 # 80017558 <sb>
    8000281c:	02000613          	li	a2,32
    80002820:	05850593          	addi	a1,a0,88
    80002824:	854e                	mv	a0,s3
    80002826:	ffffe097          	auipc	ra,0xffffe
    8000282a:	9b2080e7          	jalr	-1614(ra) # 800001d8 <memmove>
  brelse(bp);
    8000282e:	8526                	mv	a0,s1
    80002830:	00000097          	auipc	ra,0x0
    80002834:	b6e080e7          	jalr	-1170(ra) # 8000239e <brelse>
  if(sb.magic != FSMAGIC)
    80002838:	0009a703          	lw	a4,0(s3)
    8000283c:	102037b7          	lui	a5,0x10203
    80002840:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002844:	02f71263          	bne	a4,a5,80002868 <fsinit+0x70>
  initlog(dev, &sb);
    80002848:	00015597          	auipc	a1,0x15
    8000284c:	d1058593          	addi	a1,a1,-752 # 80017558 <sb>
    80002850:	854a                	mv	a0,s2
    80002852:	00001097          	auipc	ra,0x1
    80002856:	b4c080e7          	jalr	-1204(ra) # 8000339e <initlog>
}
    8000285a:	70a2                	ld	ra,40(sp)
    8000285c:	7402                	ld	s0,32(sp)
    8000285e:	64e2                	ld	s1,24(sp)
    80002860:	6942                	ld	s2,16(sp)
    80002862:	69a2                	ld	s3,8(sp)
    80002864:	6145                	addi	sp,sp,48
    80002866:	8082                	ret
    panic("invalid file system");
    80002868:	00006517          	auipc	a0,0x6
    8000286c:	ce850513          	addi	a0,a0,-792 # 80008550 <syscalls+0x188>
    80002870:	00003097          	auipc	ra,0x3
    80002874:	2b8080e7          	jalr	696(ra) # 80005b28 <panic>

0000000080002878 <iinit>:
{
    80002878:	7179                	addi	sp,sp,-48
    8000287a:	f406                	sd	ra,40(sp)
    8000287c:	f022                	sd	s0,32(sp)
    8000287e:	ec26                	sd	s1,24(sp)
    80002880:	e84a                	sd	s2,16(sp)
    80002882:	e44e                	sd	s3,8(sp)
    80002884:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002886:	00006597          	auipc	a1,0x6
    8000288a:	ce258593          	addi	a1,a1,-798 # 80008568 <syscalls+0x1a0>
    8000288e:	00015517          	auipc	a0,0x15
    80002892:	cea50513          	addi	a0,a0,-790 # 80017578 <itable>
    80002896:	00003097          	auipc	ra,0x3
    8000289a:	74c080e7          	jalr	1868(ra) # 80005fe2 <initlock>
  for(i = 0; i < NINODE; i++) {
    8000289e:	00015497          	auipc	s1,0x15
    800028a2:	d0248493          	addi	s1,s1,-766 # 800175a0 <itable+0x28>
    800028a6:	00016997          	auipc	s3,0x16
    800028aa:	78a98993          	addi	s3,s3,1930 # 80019030 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800028ae:	00006917          	auipc	s2,0x6
    800028b2:	cc290913          	addi	s2,s2,-830 # 80008570 <syscalls+0x1a8>
    800028b6:	85ca                	mv	a1,s2
    800028b8:	8526                	mv	a0,s1
    800028ba:	00001097          	auipc	ra,0x1
    800028be:	e46080e7          	jalr	-442(ra) # 80003700 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800028c2:	08848493          	addi	s1,s1,136
    800028c6:	ff3498e3          	bne	s1,s3,800028b6 <iinit+0x3e>
}
    800028ca:	70a2                	ld	ra,40(sp)
    800028cc:	7402                	ld	s0,32(sp)
    800028ce:	64e2                	ld	s1,24(sp)
    800028d0:	6942                	ld	s2,16(sp)
    800028d2:	69a2                	ld	s3,8(sp)
    800028d4:	6145                	addi	sp,sp,48
    800028d6:	8082                	ret

00000000800028d8 <ialloc>:
{
    800028d8:	715d                	addi	sp,sp,-80
    800028da:	e486                	sd	ra,72(sp)
    800028dc:	e0a2                	sd	s0,64(sp)
    800028de:	fc26                	sd	s1,56(sp)
    800028e0:	f84a                	sd	s2,48(sp)
    800028e2:	f44e                	sd	s3,40(sp)
    800028e4:	f052                	sd	s4,32(sp)
    800028e6:	ec56                	sd	s5,24(sp)
    800028e8:	e85a                	sd	s6,16(sp)
    800028ea:	e45e                	sd	s7,8(sp)
    800028ec:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    800028ee:	00015717          	auipc	a4,0x15
    800028f2:	c7672703          	lw	a4,-906(a4) # 80017564 <sb+0xc>
    800028f6:	4785                	li	a5,1
    800028f8:	04e7fa63          	bgeu	a5,a4,8000294c <ialloc+0x74>
    800028fc:	8aaa                	mv	s5,a0
    800028fe:	8bae                	mv	s7,a1
    80002900:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002902:	00015a17          	auipc	s4,0x15
    80002906:	c56a0a13          	addi	s4,s4,-938 # 80017558 <sb>
    8000290a:	00048b1b          	sext.w	s6,s1
    8000290e:	0044d593          	srli	a1,s1,0x4
    80002912:	018a2783          	lw	a5,24(s4)
    80002916:	9dbd                	addw	a1,a1,a5
    80002918:	8556                	mv	a0,s5
    8000291a:	00000097          	auipc	ra,0x0
    8000291e:	954080e7          	jalr	-1708(ra) # 8000226e <bread>
    80002922:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002924:	05850993          	addi	s3,a0,88
    80002928:	00f4f793          	andi	a5,s1,15
    8000292c:	079a                	slli	a5,a5,0x6
    8000292e:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002930:	00099783          	lh	a5,0(s3)
    80002934:	c785                	beqz	a5,8000295c <ialloc+0x84>
    brelse(bp);
    80002936:	00000097          	auipc	ra,0x0
    8000293a:	a68080e7          	jalr	-1432(ra) # 8000239e <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000293e:	0485                	addi	s1,s1,1
    80002940:	00ca2703          	lw	a4,12(s4)
    80002944:	0004879b          	sext.w	a5,s1
    80002948:	fce7e1e3          	bltu	a5,a4,8000290a <ialloc+0x32>
  panic("ialloc: no inodes");
    8000294c:	00006517          	auipc	a0,0x6
    80002950:	c2c50513          	addi	a0,a0,-980 # 80008578 <syscalls+0x1b0>
    80002954:	00003097          	auipc	ra,0x3
    80002958:	1d4080e7          	jalr	468(ra) # 80005b28 <panic>
      memset(dip, 0, sizeof(*dip));
    8000295c:	04000613          	li	a2,64
    80002960:	4581                	li	a1,0
    80002962:	854e                	mv	a0,s3
    80002964:	ffffe097          	auipc	ra,0xffffe
    80002968:	814080e7          	jalr	-2028(ra) # 80000178 <memset>
      dip->type = type;
    8000296c:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002970:	854a                	mv	a0,s2
    80002972:	00001097          	auipc	ra,0x1
    80002976:	ca8080e7          	jalr	-856(ra) # 8000361a <log_write>
      brelse(bp);
    8000297a:	854a                	mv	a0,s2
    8000297c:	00000097          	auipc	ra,0x0
    80002980:	a22080e7          	jalr	-1502(ra) # 8000239e <brelse>
      return iget(dev, inum);
    80002984:	85da                	mv	a1,s6
    80002986:	8556                	mv	a0,s5
    80002988:	00000097          	auipc	ra,0x0
    8000298c:	db4080e7          	jalr	-588(ra) # 8000273c <iget>
}
    80002990:	60a6                	ld	ra,72(sp)
    80002992:	6406                	ld	s0,64(sp)
    80002994:	74e2                	ld	s1,56(sp)
    80002996:	7942                	ld	s2,48(sp)
    80002998:	79a2                	ld	s3,40(sp)
    8000299a:	7a02                	ld	s4,32(sp)
    8000299c:	6ae2                	ld	s5,24(sp)
    8000299e:	6b42                	ld	s6,16(sp)
    800029a0:	6ba2                	ld	s7,8(sp)
    800029a2:	6161                	addi	sp,sp,80
    800029a4:	8082                	ret

00000000800029a6 <iupdate>:
{
    800029a6:	1101                	addi	sp,sp,-32
    800029a8:	ec06                	sd	ra,24(sp)
    800029aa:	e822                	sd	s0,16(sp)
    800029ac:	e426                	sd	s1,8(sp)
    800029ae:	e04a                	sd	s2,0(sp)
    800029b0:	1000                	addi	s0,sp,32
    800029b2:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800029b4:	415c                	lw	a5,4(a0)
    800029b6:	0047d79b          	srliw	a5,a5,0x4
    800029ba:	00015597          	auipc	a1,0x15
    800029be:	bb65a583          	lw	a1,-1098(a1) # 80017570 <sb+0x18>
    800029c2:	9dbd                	addw	a1,a1,a5
    800029c4:	4108                	lw	a0,0(a0)
    800029c6:	00000097          	auipc	ra,0x0
    800029ca:	8a8080e7          	jalr	-1880(ra) # 8000226e <bread>
    800029ce:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800029d0:	05850793          	addi	a5,a0,88
    800029d4:	40c8                	lw	a0,4(s1)
    800029d6:	893d                	andi	a0,a0,15
    800029d8:	051a                	slli	a0,a0,0x6
    800029da:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    800029dc:	04449703          	lh	a4,68(s1)
    800029e0:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    800029e4:	04649703          	lh	a4,70(s1)
    800029e8:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    800029ec:	04849703          	lh	a4,72(s1)
    800029f0:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    800029f4:	04a49703          	lh	a4,74(s1)
    800029f8:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    800029fc:	44f8                	lw	a4,76(s1)
    800029fe:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002a00:	03400613          	li	a2,52
    80002a04:	05048593          	addi	a1,s1,80
    80002a08:	0531                	addi	a0,a0,12
    80002a0a:	ffffd097          	auipc	ra,0xffffd
    80002a0e:	7ce080e7          	jalr	1998(ra) # 800001d8 <memmove>
  log_write(bp);
    80002a12:	854a                	mv	a0,s2
    80002a14:	00001097          	auipc	ra,0x1
    80002a18:	c06080e7          	jalr	-1018(ra) # 8000361a <log_write>
  brelse(bp);
    80002a1c:	854a                	mv	a0,s2
    80002a1e:	00000097          	auipc	ra,0x0
    80002a22:	980080e7          	jalr	-1664(ra) # 8000239e <brelse>
}
    80002a26:	60e2                	ld	ra,24(sp)
    80002a28:	6442                	ld	s0,16(sp)
    80002a2a:	64a2                	ld	s1,8(sp)
    80002a2c:	6902                	ld	s2,0(sp)
    80002a2e:	6105                	addi	sp,sp,32
    80002a30:	8082                	ret

0000000080002a32 <idup>:
{
    80002a32:	1101                	addi	sp,sp,-32
    80002a34:	ec06                	sd	ra,24(sp)
    80002a36:	e822                	sd	s0,16(sp)
    80002a38:	e426                	sd	s1,8(sp)
    80002a3a:	1000                	addi	s0,sp,32
    80002a3c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002a3e:	00015517          	auipc	a0,0x15
    80002a42:	b3a50513          	addi	a0,a0,-1222 # 80017578 <itable>
    80002a46:	00003097          	auipc	ra,0x3
    80002a4a:	62c080e7          	jalr	1580(ra) # 80006072 <acquire>
  ip->ref++;
    80002a4e:	449c                	lw	a5,8(s1)
    80002a50:	2785                	addiw	a5,a5,1
    80002a52:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002a54:	00015517          	auipc	a0,0x15
    80002a58:	b2450513          	addi	a0,a0,-1244 # 80017578 <itable>
    80002a5c:	00003097          	auipc	ra,0x3
    80002a60:	6ca080e7          	jalr	1738(ra) # 80006126 <release>
}
    80002a64:	8526                	mv	a0,s1
    80002a66:	60e2                	ld	ra,24(sp)
    80002a68:	6442                	ld	s0,16(sp)
    80002a6a:	64a2                	ld	s1,8(sp)
    80002a6c:	6105                	addi	sp,sp,32
    80002a6e:	8082                	ret

0000000080002a70 <ilock>:
{
    80002a70:	1101                	addi	sp,sp,-32
    80002a72:	ec06                	sd	ra,24(sp)
    80002a74:	e822                	sd	s0,16(sp)
    80002a76:	e426                	sd	s1,8(sp)
    80002a78:	e04a                	sd	s2,0(sp)
    80002a7a:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002a7c:	c115                	beqz	a0,80002aa0 <ilock+0x30>
    80002a7e:	84aa                	mv	s1,a0
    80002a80:	451c                	lw	a5,8(a0)
    80002a82:	00f05f63          	blez	a5,80002aa0 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002a86:	0541                	addi	a0,a0,16
    80002a88:	00001097          	auipc	ra,0x1
    80002a8c:	cb2080e7          	jalr	-846(ra) # 8000373a <acquiresleep>
  if(ip->valid == 0){
    80002a90:	40bc                	lw	a5,64(s1)
    80002a92:	cf99                	beqz	a5,80002ab0 <ilock+0x40>
}
    80002a94:	60e2                	ld	ra,24(sp)
    80002a96:	6442                	ld	s0,16(sp)
    80002a98:	64a2                	ld	s1,8(sp)
    80002a9a:	6902                	ld	s2,0(sp)
    80002a9c:	6105                	addi	sp,sp,32
    80002a9e:	8082                	ret
    panic("ilock");
    80002aa0:	00006517          	auipc	a0,0x6
    80002aa4:	af050513          	addi	a0,a0,-1296 # 80008590 <syscalls+0x1c8>
    80002aa8:	00003097          	auipc	ra,0x3
    80002aac:	080080e7          	jalr	128(ra) # 80005b28 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002ab0:	40dc                	lw	a5,4(s1)
    80002ab2:	0047d79b          	srliw	a5,a5,0x4
    80002ab6:	00015597          	auipc	a1,0x15
    80002aba:	aba5a583          	lw	a1,-1350(a1) # 80017570 <sb+0x18>
    80002abe:	9dbd                	addw	a1,a1,a5
    80002ac0:	4088                	lw	a0,0(s1)
    80002ac2:	fffff097          	auipc	ra,0xfffff
    80002ac6:	7ac080e7          	jalr	1964(ra) # 8000226e <bread>
    80002aca:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002acc:	05850593          	addi	a1,a0,88
    80002ad0:	40dc                	lw	a5,4(s1)
    80002ad2:	8bbd                	andi	a5,a5,15
    80002ad4:	079a                	slli	a5,a5,0x6
    80002ad6:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002ad8:	00059783          	lh	a5,0(a1)
    80002adc:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002ae0:	00259783          	lh	a5,2(a1)
    80002ae4:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002ae8:	00459783          	lh	a5,4(a1)
    80002aec:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002af0:	00659783          	lh	a5,6(a1)
    80002af4:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002af8:	459c                	lw	a5,8(a1)
    80002afa:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002afc:	03400613          	li	a2,52
    80002b00:	05b1                	addi	a1,a1,12
    80002b02:	05048513          	addi	a0,s1,80
    80002b06:	ffffd097          	auipc	ra,0xffffd
    80002b0a:	6d2080e7          	jalr	1746(ra) # 800001d8 <memmove>
    brelse(bp);
    80002b0e:	854a                	mv	a0,s2
    80002b10:	00000097          	auipc	ra,0x0
    80002b14:	88e080e7          	jalr	-1906(ra) # 8000239e <brelse>
    ip->valid = 1;
    80002b18:	4785                	li	a5,1
    80002b1a:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002b1c:	04449783          	lh	a5,68(s1)
    80002b20:	fbb5                	bnez	a5,80002a94 <ilock+0x24>
      panic("ilock: no type");
    80002b22:	00006517          	auipc	a0,0x6
    80002b26:	a7650513          	addi	a0,a0,-1418 # 80008598 <syscalls+0x1d0>
    80002b2a:	00003097          	auipc	ra,0x3
    80002b2e:	ffe080e7          	jalr	-2(ra) # 80005b28 <panic>

0000000080002b32 <iunlock>:
{
    80002b32:	1101                	addi	sp,sp,-32
    80002b34:	ec06                	sd	ra,24(sp)
    80002b36:	e822                	sd	s0,16(sp)
    80002b38:	e426                	sd	s1,8(sp)
    80002b3a:	e04a                	sd	s2,0(sp)
    80002b3c:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002b3e:	c905                	beqz	a0,80002b6e <iunlock+0x3c>
    80002b40:	84aa                	mv	s1,a0
    80002b42:	01050913          	addi	s2,a0,16
    80002b46:	854a                	mv	a0,s2
    80002b48:	00001097          	auipc	ra,0x1
    80002b4c:	c8c080e7          	jalr	-884(ra) # 800037d4 <holdingsleep>
    80002b50:	cd19                	beqz	a0,80002b6e <iunlock+0x3c>
    80002b52:	449c                	lw	a5,8(s1)
    80002b54:	00f05d63          	blez	a5,80002b6e <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002b58:	854a                	mv	a0,s2
    80002b5a:	00001097          	auipc	ra,0x1
    80002b5e:	c36080e7          	jalr	-970(ra) # 80003790 <releasesleep>
}
    80002b62:	60e2                	ld	ra,24(sp)
    80002b64:	6442                	ld	s0,16(sp)
    80002b66:	64a2                	ld	s1,8(sp)
    80002b68:	6902                	ld	s2,0(sp)
    80002b6a:	6105                	addi	sp,sp,32
    80002b6c:	8082                	ret
    panic("iunlock");
    80002b6e:	00006517          	auipc	a0,0x6
    80002b72:	a3a50513          	addi	a0,a0,-1478 # 800085a8 <syscalls+0x1e0>
    80002b76:	00003097          	auipc	ra,0x3
    80002b7a:	fb2080e7          	jalr	-78(ra) # 80005b28 <panic>

0000000080002b7e <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002b7e:	7179                	addi	sp,sp,-48
    80002b80:	f406                	sd	ra,40(sp)
    80002b82:	f022                	sd	s0,32(sp)
    80002b84:	ec26                	sd	s1,24(sp)
    80002b86:	e84a                	sd	s2,16(sp)
    80002b88:	e44e                	sd	s3,8(sp)
    80002b8a:	e052                	sd	s4,0(sp)
    80002b8c:	1800                	addi	s0,sp,48
    80002b8e:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002b90:	05050493          	addi	s1,a0,80
    80002b94:	08050913          	addi	s2,a0,128
    80002b98:	a021                	j	80002ba0 <itrunc+0x22>
    80002b9a:	0491                	addi	s1,s1,4
    80002b9c:	01248d63          	beq	s1,s2,80002bb6 <itrunc+0x38>
    if(ip->addrs[i]){
    80002ba0:	408c                	lw	a1,0(s1)
    80002ba2:	dde5                	beqz	a1,80002b9a <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002ba4:	0009a503          	lw	a0,0(s3)
    80002ba8:	00000097          	auipc	ra,0x0
    80002bac:	90c080e7          	jalr	-1780(ra) # 800024b4 <bfree>
      ip->addrs[i] = 0;
    80002bb0:	0004a023          	sw	zero,0(s1)
    80002bb4:	b7dd                	j	80002b9a <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002bb6:	0809a583          	lw	a1,128(s3)
    80002bba:	e185                	bnez	a1,80002bda <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002bbc:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002bc0:	854e                	mv	a0,s3
    80002bc2:	00000097          	auipc	ra,0x0
    80002bc6:	de4080e7          	jalr	-540(ra) # 800029a6 <iupdate>
}
    80002bca:	70a2                	ld	ra,40(sp)
    80002bcc:	7402                	ld	s0,32(sp)
    80002bce:	64e2                	ld	s1,24(sp)
    80002bd0:	6942                	ld	s2,16(sp)
    80002bd2:	69a2                	ld	s3,8(sp)
    80002bd4:	6a02                	ld	s4,0(sp)
    80002bd6:	6145                	addi	sp,sp,48
    80002bd8:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002bda:	0009a503          	lw	a0,0(s3)
    80002bde:	fffff097          	auipc	ra,0xfffff
    80002be2:	690080e7          	jalr	1680(ra) # 8000226e <bread>
    80002be6:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002be8:	05850493          	addi	s1,a0,88
    80002bec:	45850913          	addi	s2,a0,1112
    80002bf0:	a811                	j	80002c04 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002bf2:	0009a503          	lw	a0,0(s3)
    80002bf6:	00000097          	auipc	ra,0x0
    80002bfa:	8be080e7          	jalr	-1858(ra) # 800024b4 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002bfe:	0491                	addi	s1,s1,4
    80002c00:	01248563          	beq	s1,s2,80002c0a <itrunc+0x8c>
      if(a[j])
    80002c04:	408c                	lw	a1,0(s1)
    80002c06:	dde5                	beqz	a1,80002bfe <itrunc+0x80>
    80002c08:	b7ed                	j	80002bf2 <itrunc+0x74>
    brelse(bp);
    80002c0a:	8552                	mv	a0,s4
    80002c0c:	fffff097          	auipc	ra,0xfffff
    80002c10:	792080e7          	jalr	1938(ra) # 8000239e <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002c14:	0809a583          	lw	a1,128(s3)
    80002c18:	0009a503          	lw	a0,0(s3)
    80002c1c:	00000097          	auipc	ra,0x0
    80002c20:	898080e7          	jalr	-1896(ra) # 800024b4 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002c24:	0809a023          	sw	zero,128(s3)
    80002c28:	bf51                	j	80002bbc <itrunc+0x3e>

0000000080002c2a <iput>:
{
    80002c2a:	1101                	addi	sp,sp,-32
    80002c2c:	ec06                	sd	ra,24(sp)
    80002c2e:	e822                	sd	s0,16(sp)
    80002c30:	e426                	sd	s1,8(sp)
    80002c32:	e04a                	sd	s2,0(sp)
    80002c34:	1000                	addi	s0,sp,32
    80002c36:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c38:	00015517          	auipc	a0,0x15
    80002c3c:	94050513          	addi	a0,a0,-1728 # 80017578 <itable>
    80002c40:	00003097          	auipc	ra,0x3
    80002c44:	432080e7          	jalr	1074(ra) # 80006072 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002c48:	4498                	lw	a4,8(s1)
    80002c4a:	4785                	li	a5,1
    80002c4c:	02f70363          	beq	a4,a5,80002c72 <iput+0x48>
  ip->ref--;
    80002c50:	449c                	lw	a5,8(s1)
    80002c52:	37fd                	addiw	a5,a5,-1
    80002c54:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c56:	00015517          	auipc	a0,0x15
    80002c5a:	92250513          	addi	a0,a0,-1758 # 80017578 <itable>
    80002c5e:	00003097          	auipc	ra,0x3
    80002c62:	4c8080e7          	jalr	1224(ra) # 80006126 <release>
}
    80002c66:	60e2                	ld	ra,24(sp)
    80002c68:	6442                	ld	s0,16(sp)
    80002c6a:	64a2                	ld	s1,8(sp)
    80002c6c:	6902                	ld	s2,0(sp)
    80002c6e:	6105                	addi	sp,sp,32
    80002c70:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002c72:	40bc                	lw	a5,64(s1)
    80002c74:	dff1                	beqz	a5,80002c50 <iput+0x26>
    80002c76:	04a49783          	lh	a5,74(s1)
    80002c7a:	fbf9                	bnez	a5,80002c50 <iput+0x26>
    acquiresleep(&ip->lock);
    80002c7c:	01048913          	addi	s2,s1,16
    80002c80:	854a                	mv	a0,s2
    80002c82:	00001097          	auipc	ra,0x1
    80002c86:	ab8080e7          	jalr	-1352(ra) # 8000373a <acquiresleep>
    release(&itable.lock);
    80002c8a:	00015517          	auipc	a0,0x15
    80002c8e:	8ee50513          	addi	a0,a0,-1810 # 80017578 <itable>
    80002c92:	00003097          	auipc	ra,0x3
    80002c96:	494080e7          	jalr	1172(ra) # 80006126 <release>
    itrunc(ip);
    80002c9a:	8526                	mv	a0,s1
    80002c9c:	00000097          	auipc	ra,0x0
    80002ca0:	ee2080e7          	jalr	-286(ra) # 80002b7e <itrunc>
    ip->type = 0;
    80002ca4:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002ca8:	8526                	mv	a0,s1
    80002caa:	00000097          	auipc	ra,0x0
    80002cae:	cfc080e7          	jalr	-772(ra) # 800029a6 <iupdate>
    ip->valid = 0;
    80002cb2:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002cb6:	854a                	mv	a0,s2
    80002cb8:	00001097          	auipc	ra,0x1
    80002cbc:	ad8080e7          	jalr	-1320(ra) # 80003790 <releasesleep>
    acquire(&itable.lock);
    80002cc0:	00015517          	auipc	a0,0x15
    80002cc4:	8b850513          	addi	a0,a0,-1864 # 80017578 <itable>
    80002cc8:	00003097          	auipc	ra,0x3
    80002ccc:	3aa080e7          	jalr	938(ra) # 80006072 <acquire>
    80002cd0:	b741                	j	80002c50 <iput+0x26>

0000000080002cd2 <iunlockput>:
{
    80002cd2:	1101                	addi	sp,sp,-32
    80002cd4:	ec06                	sd	ra,24(sp)
    80002cd6:	e822                	sd	s0,16(sp)
    80002cd8:	e426                	sd	s1,8(sp)
    80002cda:	1000                	addi	s0,sp,32
    80002cdc:	84aa                	mv	s1,a0
  iunlock(ip);
    80002cde:	00000097          	auipc	ra,0x0
    80002ce2:	e54080e7          	jalr	-428(ra) # 80002b32 <iunlock>
  iput(ip);
    80002ce6:	8526                	mv	a0,s1
    80002ce8:	00000097          	auipc	ra,0x0
    80002cec:	f42080e7          	jalr	-190(ra) # 80002c2a <iput>
}
    80002cf0:	60e2                	ld	ra,24(sp)
    80002cf2:	6442                	ld	s0,16(sp)
    80002cf4:	64a2                	ld	s1,8(sp)
    80002cf6:	6105                	addi	sp,sp,32
    80002cf8:	8082                	ret

0000000080002cfa <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002cfa:	1141                	addi	sp,sp,-16
    80002cfc:	e422                	sd	s0,8(sp)
    80002cfe:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002d00:	411c                	lw	a5,0(a0)
    80002d02:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002d04:	415c                	lw	a5,4(a0)
    80002d06:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002d08:	04451783          	lh	a5,68(a0)
    80002d0c:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002d10:	04a51783          	lh	a5,74(a0)
    80002d14:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002d18:	04c56783          	lwu	a5,76(a0)
    80002d1c:	e99c                	sd	a5,16(a1)
}
    80002d1e:	6422                	ld	s0,8(sp)
    80002d20:	0141                	addi	sp,sp,16
    80002d22:	8082                	ret

0000000080002d24 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002d24:	457c                	lw	a5,76(a0)
    80002d26:	0ed7e963          	bltu	a5,a3,80002e18 <readi+0xf4>
{
    80002d2a:	7159                	addi	sp,sp,-112
    80002d2c:	f486                	sd	ra,104(sp)
    80002d2e:	f0a2                	sd	s0,96(sp)
    80002d30:	eca6                	sd	s1,88(sp)
    80002d32:	e8ca                	sd	s2,80(sp)
    80002d34:	e4ce                	sd	s3,72(sp)
    80002d36:	e0d2                	sd	s4,64(sp)
    80002d38:	fc56                	sd	s5,56(sp)
    80002d3a:	f85a                	sd	s6,48(sp)
    80002d3c:	f45e                	sd	s7,40(sp)
    80002d3e:	f062                	sd	s8,32(sp)
    80002d40:	ec66                	sd	s9,24(sp)
    80002d42:	e86a                	sd	s10,16(sp)
    80002d44:	e46e                	sd	s11,8(sp)
    80002d46:	1880                	addi	s0,sp,112
    80002d48:	8baa                	mv	s7,a0
    80002d4a:	8c2e                	mv	s8,a1
    80002d4c:	8ab2                	mv	s5,a2
    80002d4e:	84b6                	mv	s1,a3
    80002d50:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002d52:	9f35                	addw	a4,a4,a3
    return 0;
    80002d54:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002d56:	0ad76063          	bltu	a4,a3,80002df6 <readi+0xd2>
  if(off + n > ip->size)
    80002d5a:	00e7f463          	bgeu	a5,a4,80002d62 <readi+0x3e>
    n = ip->size - off;
    80002d5e:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002d62:	0a0b0963          	beqz	s6,80002e14 <readi+0xf0>
    80002d66:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002d68:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002d6c:	5cfd                	li	s9,-1
    80002d6e:	a82d                	j	80002da8 <readi+0x84>
    80002d70:	020a1d93          	slli	s11,s4,0x20
    80002d74:	020ddd93          	srli	s11,s11,0x20
    80002d78:	05890613          	addi	a2,s2,88
    80002d7c:	86ee                	mv	a3,s11
    80002d7e:	963a                	add	a2,a2,a4
    80002d80:	85d6                	mv	a1,s5
    80002d82:	8562                	mv	a0,s8
    80002d84:	fffff097          	auipc	ra,0xfffff
    80002d88:	b20080e7          	jalr	-1248(ra) # 800018a4 <either_copyout>
    80002d8c:	05950d63          	beq	a0,s9,80002de6 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002d90:	854a                	mv	a0,s2
    80002d92:	fffff097          	auipc	ra,0xfffff
    80002d96:	60c080e7          	jalr	1548(ra) # 8000239e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002d9a:	013a09bb          	addw	s3,s4,s3
    80002d9e:	009a04bb          	addw	s1,s4,s1
    80002da2:	9aee                	add	s5,s5,s11
    80002da4:	0569f763          	bgeu	s3,s6,80002df2 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002da8:	000ba903          	lw	s2,0(s7)
    80002dac:	00a4d59b          	srliw	a1,s1,0xa
    80002db0:	855e                	mv	a0,s7
    80002db2:	00000097          	auipc	ra,0x0
    80002db6:	8b0080e7          	jalr	-1872(ra) # 80002662 <bmap>
    80002dba:	0005059b          	sext.w	a1,a0
    80002dbe:	854a                	mv	a0,s2
    80002dc0:	fffff097          	auipc	ra,0xfffff
    80002dc4:	4ae080e7          	jalr	1198(ra) # 8000226e <bread>
    80002dc8:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002dca:	3ff4f713          	andi	a4,s1,1023
    80002dce:	40ed07bb          	subw	a5,s10,a4
    80002dd2:	413b06bb          	subw	a3,s6,s3
    80002dd6:	8a3e                	mv	s4,a5
    80002dd8:	2781                	sext.w	a5,a5
    80002dda:	0006861b          	sext.w	a2,a3
    80002dde:	f8f679e3          	bgeu	a2,a5,80002d70 <readi+0x4c>
    80002de2:	8a36                	mv	s4,a3
    80002de4:	b771                	j	80002d70 <readi+0x4c>
      brelse(bp);
    80002de6:	854a                	mv	a0,s2
    80002de8:	fffff097          	auipc	ra,0xfffff
    80002dec:	5b6080e7          	jalr	1462(ra) # 8000239e <brelse>
      tot = -1;
    80002df0:	59fd                	li	s3,-1
  }
  return tot;
    80002df2:	0009851b          	sext.w	a0,s3
}
    80002df6:	70a6                	ld	ra,104(sp)
    80002df8:	7406                	ld	s0,96(sp)
    80002dfa:	64e6                	ld	s1,88(sp)
    80002dfc:	6946                	ld	s2,80(sp)
    80002dfe:	69a6                	ld	s3,72(sp)
    80002e00:	6a06                	ld	s4,64(sp)
    80002e02:	7ae2                	ld	s5,56(sp)
    80002e04:	7b42                	ld	s6,48(sp)
    80002e06:	7ba2                	ld	s7,40(sp)
    80002e08:	7c02                	ld	s8,32(sp)
    80002e0a:	6ce2                	ld	s9,24(sp)
    80002e0c:	6d42                	ld	s10,16(sp)
    80002e0e:	6da2                	ld	s11,8(sp)
    80002e10:	6165                	addi	sp,sp,112
    80002e12:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e14:	89da                	mv	s3,s6
    80002e16:	bff1                	j	80002df2 <readi+0xce>
    return 0;
    80002e18:	4501                	li	a0,0
}
    80002e1a:	8082                	ret

0000000080002e1c <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e1c:	457c                	lw	a5,76(a0)
    80002e1e:	10d7e863          	bltu	a5,a3,80002f2e <writei+0x112>
{
    80002e22:	7159                	addi	sp,sp,-112
    80002e24:	f486                	sd	ra,104(sp)
    80002e26:	f0a2                	sd	s0,96(sp)
    80002e28:	eca6                	sd	s1,88(sp)
    80002e2a:	e8ca                	sd	s2,80(sp)
    80002e2c:	e4ce                	sd	s3,72(sp)
    80002e2e:	e0d2                	sd	s4,64(sp)
    80002e30:	fc56                	sd	s5,56(sp)
    80002e32:	f85a                	sd	s6,48(sp)
    80002e34:	f45e                	sd	s7,40(sp)
    80002e36:	f062                	sd	s8,32(sp)
    80002e38:	ec66                	sd	s9,24(sp)
    80002e3a:	e86a                	sd	s10,16(sp)
    80002e3c:	e46e                	sd	s11,8(sp)
    80002e3e:	1880                	addi	s0,sp,112
    80002e40:	8b2a                	mv	s6,a0
    80002e42:	8c2e                	mv	s8,a1
    80002e44:	8ab2                	mv	s5,a2
    80002e46:	8936                	mv	s2,a3
    80002e48:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002e4a:	00e687bb          	addw	a5,a3,a4
    80002e4e:	0ed7e263          	bltu	a5,a3,80002f32 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002e52:	00043737          	lui	a4,0x43
    80002e56:	0ef76063          	bltu	a4,a5,80002f36 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002e5a:	0c0b8863          	beqz	s7,80002f2a <writei+0x10e>
    80002e5e:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e60:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002e64:	5cfd                	li	s9,-1
    80002e66:	a091                	j	80002eaa <writei+0x8e>
    80002e68:	02099d93          	slli	s11,s3,0x20
    80002e6c:	020ddd93          	srli	s11,s11,0x20
    80002e70:	05848513          	addi	a0,s1,88
    80002e74:	86ee                	mv	a3,s11
    80002e76:	8656                	mv	a2,s5
    80002e78:	85e2                	mv	a1,s8
    80002e7a:	953a                	add	a0,a0,a4
    80002e7c:	fffff097          	auipc	ra,0xfffff
    80002e80:	a7e080e7          	jalr	-1410(ra) # 800018fa <either_copyin>
    80002e84:	07950263          	beq	a0,s9,80002ee8 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002e88:	8526                	mv	a0,s1
    80002e8a:	00000097          	auipc	ra,0x0
    80002e8e:	790080e7          	jalr	1936(ra) # 8000361a <log_write>
    brelse(bp);
    80002e92:	8526                	mv	a0,s1
    80002e94:	fffff097          	auipc	ra,0xfffff
    80002e98:	50a080e7          	jalr	1290(ra) # 8000239e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002e9c:	01498a3b          	addw	s4,s3,s4
    80002ea0:	0129893b          	addw	s2,s3,s2
    80002ea4:	9aee                	add	s5,s5,s11
    80002ea6:	057a7663          	bgeu	s4,s7,80002ef2 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002eaa:	000b2483          	lw	s1,0(s6)
    80002eae:	00a9559b          	srliw	a1,s2,0xa
    80002eb2:	855a                	mv	a0,s6
    80002eb4:	fffff097          	auipc	ra,0xfffff
    80002eb8:	7ae080e7          	jalr	1966(ra) # 80002662 <bmap>
    80002ebc:	0005059b          	sext.w	a1,a0
    80002ec0:	8526                	mv	a0,s1
    80002ec2:	fffff097          	auipc	ra,0xfffff
    80002ec6:	3ac080e7          	jalr	940(ra) # 8000226e <bread>
    80002eca:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ecc:	3ff97713          	andi	a4,s2,1023
    80002ed0:	40ed07bb          	subw	a5,s10,a4
    80002ed4:	414b86bb          	subw	a3,s7,s4
    80002ed8:	89be                	mv	s3,a5
    80002eda:	2781                	sext.w	a5,a5
    80002edc:	0006861b          	sext.w	a2,a3
    80002ee0:	f8f674e3          	bgeu	a2,a5,80002e68 <writei+0x4c>
    80002ee4:	89b6                	mv	s3,a3
    80002ee6:	b749                	j	80002e68 <writei+0x4c>
      brelse(bp);
    80002ee8:	8526                	mv	a0,s1
    80002eea:	fffff097          	auipc	ra,0xfffff
    80002eee:	4b4080e7          	jalr	1204(ra) # 8000239e <brelse>
  }

  if(off > ip->size)
    80002ef2:	04cb2783          	lw	a5,76(s6)
    80002ef6:	0127f463          	bgeu	a5,s2,80002efe <writei+0xe2>
    ip->size = off;
    80002efa:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002efe:	855a                	mv	a0,s6
    80002f00:	00000097          	auipc	ra,0x0
    80002f04:	aa6080e7          	jalr	-1370(ra) # 800029a6 <iupdate>

  return tot;
    80002f08:	000a051b          	sext.w	a0,s4
}
    80002f0c:	70a6                	ld	ra,104(sp)
    80002f0e:	7406                	ld	s0,96(sp)
    80002f10:	64e6                	ld	s1,88(sp)
    80002f12:	6946                	ld	s2,80(sp)
    80002f14:	69a6                	ld	s3,72(sp)
    80002f16:	6a06                	ld	s4,64(sp)
    80002f18:	7ae2                	ld	s5,56(sp)
    80002f1a:	7b42                	ld	s6,48(sp)
    80002f1c:	7ba2                	ld	s7,40(sp)
    80002f1e:	7c02                	ld	s8,32(sp)
    80002f20:	6ce2                	ld	s9,24(sp)
    80002f22:	6d42                	ld	s10,16(sp)
    80002f24:	6da2                	ld	s11,8(sp)
    80002f26:	6165                	addi	sp,sp,112
    80002f28:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f2a:	8a5e                	mv	s4,s7
    80002f2c:	bfc9                	j	80002efe <writei+0xe2>
    return -1;
    80002f2e:	557d                	li	a0,-1
}
    80002f30:	8082                	ret
    return -1;
    80002f32:	557d                	li	a0,-1
    80002f34:	bfe1                	j	80002f0c <writei+0xf0>
    return -1;
    80002f36:	557d                	li	a0,-1
    80002f38:	bfd1                	j	80002f0c <writei+0xf0>

0000000080002f3a <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002f3a:	1141                	addi	sp,sp,-16
    80002f3c:	e406                	sd	ra,8(sp)
    80002f3e:	e022                	sd	s0,0(sp)
    80002f40:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002f42:	4639                	li	a2,14
    80002f44:	ffffd097          	auipc	ra,0xffffd
    80002f48:	30c080e7          	jalr	780(ra) # 80000250 <strncmp>
}
    80002f4c:	60a2                	ld	ra,8(sp)
    80002f4e:	6402                	ld	s0,0(sp)
    80002f50:	0141                	addi	sp,sp,16
    80002f52:	8082                	ret

0000000080002f54 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002f54:	7139                	addi	sp,sp,-64
    80002f56:	fc06                	sd	ra,56(sp)
    80002f58:	f822                	sd	s0,48(sp)
    80002f5a:	f426                	sd	s1,40(sp)
    80002f5c:	f04a                	sd	s2,32(sp)
    80002f5e:	ec4e                	sd	s3,24(sp)
    80002f60:	e852                	sd	s4,16(sp)
    80002f62:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002f64:	04451703          	lh	a4,68(a0)
    80002f68:	4785                	li	a5,1
    80002f6a:	00f71a63          	bne	a4,a5,80002f7e <dirlookup+0x2a>
    80002f6e:	892a                	mv	s2,a0
    80002f70:	89ae                	mv	s3,a1
    80002f72:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002f74:	457c                	lw	a5,76(a0)
    80002f76:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002f78:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002f7a:	e79d                	bnez	a5,80002fa8 <dirlookup+0x54>
    80002f7c:	a8a5                	j	80002ff4 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80002f7e:	00005517          	auipc	a0,0x5
    80002f82:	63250513          	addi	a0,a0,1586 # 800085b0 <syscalls+0x1e8>
    80002f86:	00003097          	auipc	ra,0x3
    80002f8a:	ba2080e7          	jalr	-1118(ra) # 80005b28 <panic>
      panic("dirlookup read");
    80002f8e:	00005517          	auipc	a0,0x5
    80002f92:	63a50513          	addi	a0,a0,1594 # 800085c8 <syscalls+0x200>
    80002f96:	00003097          	auipc	ra,0x3
    80002f9a:	b92080e7          	jalr	-1134(ra) # 80005b28 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002f9e:	24c1                	addiw	s1,s1,16
    80002fa0:	04c92783          	lw	a5,76(s2)
    80002fa4:	04f4f763          	bgeu	s1,a5,80002ff2 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002fa8:	4741                	li	a4,16
    80002faa:	86a6                	mv	a3,s1
    80002fac:	fc040613          	addi	a2,s0,-64
    80002fb0:	4581                	li	a1,0
    80002fb2:	854a                	mv	a0,s2
    80002fb4:	00000097          	auipc	ra,0x0
    80002fb8:	d70080e7          	jalr	-656(ra) # 80002d24 <readi>
    80002fbc:	47c1                	li	a5,16
    80002fbe:	fcf518e3          	bne	a0,a5,80002f8e <dirlookup+0x3a>
    if(de.inum == 0)
    80002fc2:	fc045783          	lhu	a5,-64(s0)
    80002fc6:	dfe1                	beqz	a5,80002f9e <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80002fc8:	fc240593          	addi	a1,s0,-62
    80002fcc:	854e                	mv	a0,s3
    80002fce:	00000097          	auipc	ra,0x0
    80002fd2:	f6c080e7          	jalr	-148(ra) # 80002f3a <namecmp>
    80002fd6:	f561                	bnez	a0,80002f9e <dirlookup+0x4a>
      if(poff)
    80002fd8:	000a0463          	beqz	s4,80002fe0 <dirlookup+0x8c>
        *poff = off;
    80002fdc:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80002fe0:	fc045583          	lhu	a1,-64(s0)
    80002fe4:	00092503          	lw	a0,0(s2)
    80002fe8:	fffff097          	auipc	ra,0xfffff
    80002fec:	754080e7          	jalr	1876(ra) # 8000273c <iget>
    80002ff0:	a011                	j	80002ff4 <dirlookup+0xa0>
  return 0;
    80002ff2:	4501                	li	a0,0
}
    80002ff4:	70e2                	ld	ra,56(sp)
    80002ff6:	7442                	ld	s0,48(sp)
    80002ff8:	74a2                	ld	s1,40(sp)
    80002ffa:	7902                	ld	s2,32(sp)
    80002ffc:	69e2                	ld	s3,24(sp)
    80002ffe:	6a42                	ld	s4,16(sp)
    80003000:	6121                	addi	sp,sp,64
    80003002:	8082                	ret

0000000080003004 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003004:	711d                	addi	sp,sp,-96
    80003006:	ec86                	sd	ra,88(sp)
    80003008:	e8a2                	sd	s0,80(sp)
    8000300a:	e4a6                	sd	s1,72(sp)
    8000300c:	e0ca                	sd	s2,64(sp)
    8000300e:	fc4e                	sd	s3,56(sp)
    80003010:	f852                	sd	s4,48(sp)
    80003012:	f456                	sd	s5,40(sp)
    80003014:	f05a                	sd	s6,32(sp)
    80003016:	ec5e                	sd	s7,24(sp)
    80003018:	e862                	sd	s8,16(sp)
    8000301a:	e466                	sd	s9,8(sp)
    8000301c:	1080                	addi	s0,sp,96
    8000301e:	84aa                	mv	s1,a0
    80003020:	8b2e                	mv	s6,a1
    80003022:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003024:	00054703          	lbu	a4,0(a0)
    80003028:	02f00793          	li	a5,47
    8000302c:	02f70363          	beq	a4,a5,80003052 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003030:	ffffe097          	auipc	ra,0xffffe
    80003034:	e14080e7          	jalr	-492(ra) # 80000e44 <myproc>
    80003038:	15053503          	ld	a0,336(a0)
    8000303c:	00000097          	auipc	ra,0x0
    80003040:	9f6080e7          	jalr	-1546(ra) # 80002a32 <idup>
    80003044:	89aa                	mv	s3,a0
  while(*path == '/')
    80003046:	02f00913          	li	s2,47
  len = path - s;
    8000304a:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    8000304c:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000304e:	4c05                	li	s8,1
    80003050:	a865                	j	80003108 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003052:	4585                	li	a1,1
    80003054:	4505                	li	a0,1
    80003056:	fffff097          	auipc	ra,0xfffff
    8000305a:	6e6080e7          	jalr	1766(ra) # 8000273c <iget>
    8000305e:	89aa                	mv	s3,a0
    80003060:	b7dd                	j	80003046 <namex+0x42>
      iunlockput(ip);
    80003062:	854e                	mv	a0,s3
    80003064:	00000097          	auipc	ra,0x0
    80003068:	c6e080e7          	jalr	-914(ra) # 80002cd2 <iunlockput>
      return 0;
    8000306c:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000306e:	854e                	mv	a0,s3
    80003070:	60e6                	ld	ra,88(sp)
    80003072:	6446                	ld	s0,80(sp)
    80003074:	64a6                	ld	s1,72(sp)
    80003076:	6906                	ld	s2,64(sp)
    80003078:	79e2                	ld	s3,56(sp)
    8000307a:	7a42                	ld	s4,48(sp)
    8000307c:	7aa2                	ld	s5,40(sp)
    8000307e:	7b02                	ld	s6,32(sp)
    80003080:	6be2                	ld	s7,24(sp)
    80003082:	6c42                	ld	s8,16(sp)
    80003084:	6ca2                	ld	s9,8(sp)
    80003086:	6125                	addi	sp,sp,96
    80003088:	8082                	ret
      iunlock(ip);
    8000308a:	854e                	mv	a0,s3
    8000308c:	00000097          	auipc	ra,0x0
    80003090:	aa6080e7          	jalr	-1370(ra) # 80002b32 <iunlock>
      return ip;
    80003094:	bfe9                	j	8000306e <namex+0x6a>
      iunlockput(ip);
    80003096:	854e                	mv	a0,s3
    80003098:	00000097          	auipc	ra,0x0
    8000309c:	c3a080e7          	jalr	-966(ra) # 80002cd2 <iunlockput>
      return 0;
    800030a0:	89d2                	mv	s3,s4
    800030a2:	b7f1                	j	8000306e <namex+0x6a>
  len = path - s;
    800030a4:	40b48633          	sub	a2,s1,a1
    800030a8:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    800030ac:	094cd463          	bge	s9,s4,80003134 <namex+0x130>
    memmove(name, s, DIRSIZ);
    800030b0:	4639                	li	a2,14
    800030b2:	8556                	mv	a0,s5
    800030b4:	ffffd097          	auipc	ra,0xffffd
    800030b8:	124080e7          	jalr	292(ra) # 800001d8 <memmove>
  while(*path == '/')
    800030bc:	0004c783          	lbu	a5,0(s1)
    800030c0:	01279763          	bne	a5,s2,800030ce <namex+0xca>
    path++;
    800030c4:	0485                	addi	s1,s1,1
  while(*path == '/')
    800030c6:	0004c783          	lbu	a5,0(s1)
    800030ca:	ff278de3          	beq	a5,s2,800030c4 <namex+0xc0>
    ilock(ip);
    800030ce:	854e                	mv	a0,s3
    800030d0:	00000097          	auipc	ra,0x0
    800030d4:	9a0080e7          	jalr	-1632(ra) # 80002a70 <ilock>
    if(ip->type != T_DIR){
    800030d8:	04499783          	lh	a5,68(s3)
    800030dc:	f98793e3          	bne	a5,s8,80003062 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800030e0:	000b0563          	beqz	s6,800030ea <namex+0xe6>
    800030e4:	0004c783          	lbu	a5,0(s1)
    800030e8:	d3cd                	beqz	a5,8000308a <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800030ea:	865e                	mv	a2,s7
    800030ec:	85d6                	mv	a1,s5
    800030ee:	854e                	mv	a0,s3
    800030f0:	00000097          	auipc	ra,0x0
    800030f4:	e64080e7          	jalr	-412(ra) # 80002f54 <dirlookup>
    800030f8:	8a2a                	mv	s4,a0
    800030fa:	dd51                	beqz	a0,80003096 <namex+0x92>
    iunlockput(ip);
    800030fc:	854e                	mv	a0,s3
    800030fe:	00000097          	auipc	ra,0x0
    80003102:	bd4080e7          	jalr	-1068(ra) # 80002cd2 <iunlockput>
    ip = next;
    80003106:	89d2                	mv	s3,s4
  while(*path == '/')
    80003108:	0004c783          	lbu	a5,0(s1)
    8000310c:	05279763          	bne	a5,s2,8000315a <namex+0x156>
    path++;
    80003110:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003112:	0004c783          	lbu	a5,0(s1)
    80003116:	ff278de3          	beq	a5,s2,80003110 <namex+0x10c>
  if(*path == 0)
    8000311a:	c79d                	beqz	a5,80003148 <namex+0x144>
    path++;
    8000311c:	85a6                	mv	a1,s1
  len = path - s;
    8000311e:	8a5e                	mv	s4,s7
    80003120:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003122:	01278963          	beq	a5,s2,80003134 <namex+0x130>
    80003126:	dfbd                	beqz	a5,800030a4 <namex+0xa0>
    path++;
    80003128:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    8000312a:	0004c783          	lbu	a5,0(s1)
    8000312e:	ff279ce3          	bne	a5,s2,80003126 <namex+0x122>
    80003132:	bf8d                	j	800030a4 <namex+0xa0>
    memmove(name, s, len);
    80003134:	2601                	sext.w	a2,a2
    80003136:	8556                	mv	a0,s5
    80003138:	ffffd097          	auipc	ra,0xffffd
    8000313c:	0a0080e7          	jalr	160(ra) # 800001d8 <memmove>
    name[len] = 0;
    80003140:	9a56                	add	s4,s4,s5
    80003142:	000a0023          	sb	zero,0(s4)
    80003146:	bf9d                	j	800030bc <namex+0xb8>
  if(nameiparent){
    80003148:	f20b03e3          	beqz	s6,8000306e <namex+0x6a>
    iput(ip);
    8000314c:	854e                	mv	a0,s3
    8000314e:	00000097          	auipc	ra,0x0
    80003152:	adc080e7          	jalr	-1316(ra) # 80002c2a <iput>
    return 0;
    80003156:	4981                	li	s3,0
    80003158:	bf19                	j	8000306e <namex+0x6a>
  if(*path == 0)
    8000315a:	d7fd                	beqz	a5,80003148 <namex+0x144>
  while(*path != '/' && *path != 0)
    8000315c:	0004c783          	lbu	a5,0(s1)
    80003160:	85a6                	mv	a1,s1
    80003162:	b7d1                	j	80003126 <namex+0x122>

0000000080003164 <dirlink>:
{
    80003164:	7139                	addi	sp,sp,-64
    80003166:	fc06                	sd	ra,56(sp)
    80003168:	f822                	sd	s0,48(sp)
    8000316a:	f426                	sd	s1,40(sp)
    8000316c:	f04a                	sd	s2,32(sp)
    8000316e:	ec4e                	sd	s3,24(sp)
    80003170:	e852                	sd	s4,16(sp)
    80003172:	0080                	addi	s0,sp,64
    80003174:	892a                	mv	s2,a0
    80003176:	8a2e                	mv	s4,a1
    80003178:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000317a:	4601                	li	a2,0
    8000317c:	00000097          	auipc	ra,0x0
    80003180:	dd8080e7          	jalr	-552(ra) # 80002f54 <dirlookup>
    80003184:	e93d                	bnez	a0,800031fa <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003186:	04c92483          	lw	s1,76(s2)
    8000318a:	c49d                	beqz	s1,800031b8 <dirlink+0x54>
    8000318c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000318e:	4741                	li	a4,16
    80003190:	86a6                	mv	a3,s1
    80003192:	fc040613          	addi	a2,s0,-64
    80003196:	4581                	li	a1,0
    80003198:	854a                	mv	a0,s2
    8000319a:	00000097          	auipc	ra,0x0
    8000319e:	b8a080e7          	jalr	-1142(ra) # 80002d24 <readi>
    800031a2:	47c1                	li	a5,16
    800031a4:	06f51163          	bne	a0,a5,80003206 <dirlink+0xa2>
    if(de.inum == 0)
    800031a8:	fc045783          	lhu	a5,-64(s0)
    800031ac:	c791                	beqz	a5,800031b8 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031ae:	24c1                	addiw	s1,s1,16
    800031b0:	04c92783          	lw	a5,76(s2)
    800031b4:	fcf4ede3          	bltu	s1,a5,8000318e <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800031b8:	4639                	li	a2,14
    800031ba:	85d2                	mv	a1,s4
    800031bc:	fc240513          	addi	a0,s0,-62
    800031c0:	ffffd097          	auipc	ra,0xffffd
    800031c4:	0cc080e7          	jalr	204(ra) # 8000028c <strncpy>
  de.inum = inum;
    800031c8:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031cc:	4741                	li	a4,16
    800031ce:	86a6                	mv	a3,s1
    800031d0:	fc040613          	addi	a2,s0,-64
    800031d4:	4581                	li	a1,0
    800031d6:	854a                	mv	a0,s2
    800031d8:	00000097          	auipc	ra,0x0
    800031dc:	c44080e7          	jalr	-956(ra) # 80002e1c <writei>
    800031e0:	872a                	mv	a4,a0
    800031e2:	47c1                	li	a5,16
  return 0;
    800031e4:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031e6:	02f71863          	bne	a4,a5,80003216 <dirlink+0xb2>
}
    800031ea:	70e2                	ld	ra,56(sp)
    800031ec:	7442                	ld	s0,48(sp)
    800031ee:	74a2                	ld	s1,40(sp)
    800031f0:	7902                	ld	s2,32(sp)
    800031f2:	69e2                	ld	s3,24(sp)
    800031f4:	6a42                	ld	s4,16(sp)
    800031f6:	6121                	addi	sp,sp,64
    800031f8:	8082                	ret
    iput(ip);
    800031fa:	00000097          	auipc	ra,0x0
    800031fe:	a30080e7          	jalr	-1488(ra) # 80002c2a <iput>
    return -1;
    80003202:	557d                	li	a0,-1
    80003204:	b7dd                	j	800031ea <dirlink+0x86>
      panic("dirlink read");
    80003206:	00005517          	auipc	a0,0x5
    8000320a:	3d250513          	addi	a0,a0,978 # 800085d8 <syscalls+0x210>
    8000320e:	00003097          	auipc	ra,0x3
    80003212:	91a080e7          	jalr	-1766(ra) # 80005b28 <panic>
    panic("dirlink");
    80003216:	00005517          	auipc	a0,0x5
    8000321a:	4d250513          	addi	a0,a0,1234 # 800086e8 <syscalls+0x320>
    8000321e:	00003097          	auipc	ra,0x3
    80003222:	90a080e7          	jalr	-1782(ra) # 80005b28 <panic>

0000000080003226 <namei>:

struct inode*
namei(char *path)
{
    80003226:	1101                	addi	sp,sp,-32
    80003228:	ec06                	sd	ra,24(sp)
    8000322a:	e822                	sd	s0,16(sp)
    8000322c:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000322e:	fe040613          	addi	a2,s0,-32
    80003232:	4581                	li	a1,0
    80003234:	00000097          	auipc	ra,0x0
    80003238:	dd0080e7          	jalr	-560(ra) # 80003004 <namex>
}
    8000323c:	60e2                	ld	ra,24(sp)
    8000323e:	6442                	ld	s0,16(sp)
    80003240:	6105                	addi	sp,sp,32
    80003242:	8082                	ret

0000000080003244 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003244:	1141                	addi	sp,sp,-16
    80003246:	e406                	sd	ra,8(sp)
    80003248:	e022                	sd	s0,0(sp)
    8000324a:	0800                	addi	s0,sp,16
    8000324c:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000324e:	4585                	li	a1,1
    80003250:	00000097          	auipc	ra,0x0
    80003254:	db4080e7          	jalr	-588(ra) # 80003004 <namex>
}
    80003258:	60a2                	ld	ra,8(sp)
    8000325a:	6402                	ld	s0,0(sp)
    8000325c:	0141                	addi	sp,sp,16
    8000325e:	8082                	ret

0000000080003260 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003260:	1101                	addi	sp,sp,-32
    80003262:	ec06                	sd	ra,24(sp)
    80003264:	e822                	sd	s0,16(sp)
    80003266:	e426                	sd	s1,8(sp)
    80003268:	e04a                	sd	s2,0(sp)
    8000326a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000326c:	00016917          	auipc	s2,0x16
    80003270:	db490913          	addi	s2,s2,-588 # 80019020 <log>
    80003274:	01892583          	lw	a1,24(s2)
    80003278:	02892503          	lw	a0,40(s2)
    8000327c:	fffff097          	auipc	ra,0xfffff
    80003280:	ff2080e7          	jalr	-14(ra) # 8000226e <bread>
    80003284:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003286:	02c92683          	lw	a3,44(s2)
    8000328a:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000328c:	02d05763          	blez	a3,800032ba <write_head+0x5a>
    80003290:	00016797          	auipc	a5,0x16
    80003294:	dc078793          	addi	a5,a5,-576 # 80019050 <log+0x30>
    80003298:	05c50713          	addi	a4,a0,92
    8000329c:	36fd                	addiw	a3,a3,-1
    8000329e:	1682                	slli	a3,a3,0x20
    800032a0:	9281                	srli	a3,a3,0x20
    800032a2:	068a                	slli	a3,a3,0x2
    800032a4:	00016617          	auipc	a2,0x16
    800032a8:	db060613          	addi	a2,a2,-592 # 80019054 <log+0x34>
    800032ac:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800032ae:	4390                	lw	a2,0(a5)
    800032b0:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800032b2:	0791                	addi	a5,a5,4
    800032b4:	0711                	addi	a4,a4,4
    800032b6:	fed79ce3          	bne	a5,a3,800032ae <write_head+0x4e>
  }
  bwrite(buf);
    800032ba:	8526                	mv	a0,s1
    800032bc:	fffff097          	auipc	ra,0xfffff
    800032c0:	0a4080e7          	jalr	164(ra) # 80002360 <bwrite>
  brelse(buf);
    800032c4:	8526                	mv	a0,s1
    800032c6:	fffff097          	auipc	ra,0xfffff
    800032ca:	0d8080e7          	jalr	216(ra) # 8000239e <brelse>
}
    800032ce:	60e2                	ld	ra,24(sp)
    800032d0:	6442                	ld	s0,16(sp)
    800032d2:	64a2                	ld	s1,8(sp)
    800032d4:	6902                	ld	s2,0(sp)
    800032d6:	6105                	addi	sp,sp,32
    800032d8:	8082                	ret

00000000800032da <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800032da:	00016797          	auipc	a5,0x16
    800032de:	d727a783          	lw	a5,-654(a5) # 8001904c <log+0x2c>
    800032e2:	0af05d63          	blez	a5,8000339c <install_trans+0xc2>
{
    800032e6:	7139                	addi	sp,sp,-64
    800032e8:	fc06                	sd	ra,56(sp)
    800032ea:	f822                	sd	s0,48(sp)
    800032ec:	f426                	sd	s1,40(sp)
    800032ee:	f04a                	sd	s2,32(sp)
    800032f0:	ec4e                	sd	s3,24(sp)
    800032f2:	e852                	sd	s4,16(sp)
    800032f4:	e456                	sd	s5,8(sp)
    800032f6:	e05a                	sd	s6,0(sp)
    800032f8:	0080                	addi	s0,sp,64
    800032fa:	8b2a                	mv	s6,a0
    800032fc:	00016a97          	auipc	s5,0x16
    80003300:	d54a8a93          	addi	s5,s5,-684 # 80019050 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003304:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003306:	00016997          	auipc	s3,0x16
    8000330a:	d1a98993          	addi	s3,s3,-742 # 80019020 <log>
    8000330e:	a035                	j	8000333a <install_trans+0x60>
      bunpin(dbuf);
    80003310:	8526                	mv	a0,s1
    80003312:	fffff097          	auipc	ra,0xfffff
    80003316:	166080e7          	jalr	358(ra) # 80002478 <bunpin>
    brelse(lbuf);
    8000331a:	854a                	mv	a0,s2
    8000331c:	fffff097          	auipc	ra,0xfffff
    80003320:	082080e7          	jalr	130(ra) # 8000239e <brelse>
    brelse(dbuf);
    80003324:	8526                	mv	a0,s1
    80003326:	fffff097          	auipc	ra,0xfffff
    8000332a:	078080e7          	jalr	120(ra) # 8000239e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000332e:	2a05                	addiw	s4,s4,1
    80003330:	0a91                	addi	s5,s5,4
    80003332:	02c9a783          	lw	a5,44(s3)
    80003336:	04fa5963          	bge	s4,a5,80003388 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000333a:	0189a583          	lw	a1,24(s3)
    8000333e:	014585bb          	addw	a1,a1,s4
    80003342:	2585                	addiw	a1,a1,1
    80003344:	0289a503          	lw	a0,40(s3)
    80003348:	fffff097          	auipc	ra,0xfffff
    8000334c:	f26080e7          	jalr	-218(ra) # 8000226e <bread>
    80003350:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003352:	000aa583          	lw	a1,0(s5)
    80003356:	0289a503          	lw	a0,40(s3)
    8000335a:	fffff097          	auipc	ra,0xfffff
    8000335e:	f14080e7          	jalr	-236(ra) # 8000226e <bread>
    80003362:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003364:	40000613          	li	a2,1024
    80003368:	05890593          	addi	a1,s2,88
    8000336c:	05850513          	addi	a0,a0,88
    80003370:	ffffd097          	auipc	ra,0xffffd
    80003374:	e68080e7          	jalr	-408(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003378:	8526                	mv	a0,s1
    8000337a:	fffff097          	auipc	ra,0xfffff
    8000337e:	fe6080e7          	jalr	-26(ra) # 80002360 <bwrite>
    if(recovering == 0)
    80003382:	f80b1ce3          	bnez	s6,8000331a <install_trans+0x40>
    80003386:	b769                	j	80003310 <install_trans+0x36>
}
    80003388:	70e2                	ld	ra,56(sp)
    8000338a:	7442                	ld	s0,48(sp)
    8000338c:	74a2                	ld	s1,40(sp)
    8000338e:	7902                	ld	s2,32(sp)
    80003390:	69e2                	ld	s3,24(sp)
    80003392:	6a42                	ld	s4,16(sp)
    80003394:	6aa2                	ld	s5,8(sp)
    80003396:	6b02                	ld	s6,0(sp)
    80003398:	6121                	addi	sp,sp,64
    8000339a:	8082                	ret
    8000339c:	8082                	ret

000000008000339e <initlog>:
{
    8000339e:	7179                	addi	sp,sp,-48
    800033a0:	f406                	sd	ra,40(sp)
    800033a2:	f022                	sd	s0,32(sp)
    800033a4:	ec26                	sd	s1,24(sp)
    800033a6:	e84a                	sd	s2,16(sp)
    800033a8:	e44e                	sd	s3,8(sp)
    800033aa:	1800                	addi	s0,sp,48
    800033ac:	892a                	mv	s2,a0
    800033ae:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800033b0:	00016497          	auipc	s1,0x16
    800033b4:	c7048493          	addi	s1,s1,-912 # 80019020 <log>
    800033b8:	00005597          	auipc	a1,0x5
    800033bc:	23058593          	addi	a1,a1,560 # 800085e8 <syscalls+0x220>
    800033c0:	8526                	mv	a0,s1
    800033c2:	00003097          	auipc	ra,0x3
    800033c6:	c20080e7          	jalr	-992(ra) # 80005fe2 <initlock>
  log.start = sb->logstart;
    800033ca:	0149a583          	lw	a1,20(s3)
    800033ce:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800033d0:	0109a783          	lw	a5,16(s3)
    800033d4:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800033d6:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800033da:	854a                	mv	a0,s2
    800033dc:	fffff097          	auipc	ra,0xfffff
    800033e0:	e92080e7          	jalr	-366(ra) # 8000226e <bread>
  log.lh.n = lh->n;
    800033e4:	4d3c                	lw	a5,88(a0)
    800033e6:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800033e8:	02f05563          	blez	a5,80003412 <initlog+0x74>
    800033ec:	05c50713          	addi	a4,a0,92
    800033f0:	00016697          	auipc	a3,0x16
    800033f4:	c6068693          	addi	a3,a3,-928 # 80019050 <log+0x30>
    800033f8:	37fd                	addiw	a5,a5,-1
    800033fa:	1782                	slli	a5,a5,0x20
    800033fc:	9381                	srli	a5,a5,0x20
    800033fe:	078a                	slli	a5,a5,0x2
    80003400:	06050613          	addi	a2,a0,96
    80003404:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003406:	4310                	lw	a2,0(a4)
    80003408:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    8000340a:	0711                	addi	a4,a4,4
    8000340c:	0691                	addi	a3,a3,4
    8000340e:	fef71ce3          	bne	a4,a5,80003406 <initlog+0x68>
  brelse(buf);
    80003412:	fffff097          	auipc	ra,0xfffff
    80003416:	f8c080e7          	jalr	-116(ra) # 8000239e <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000341a:	4505                	li	a0,1
    8000341c:	00000097          	auipc	ra,0x0
    80003420:	ebe080e7          	jalr	-322(ra) # 800032da <install_trans>
  log.lh.n = 0;
    80003424:	00016797          	auipc	a5,0x16
    80003428:	c207a423          	sw	zero,-984(a5) # 8001904c <log+0x2c>
  write_head(); // clear the log
    8000342c:	00000097          	auipc	ra,0x0
    80003430:	e34080e7          	jalr	-460(ra) # 80003260 <write_head>
}
    80003434:	70a2                	ld	ra,40(sp)
    80003436:	7402                	ld	s0,32(sp)
    80003438:	64e2                	ld	s1,24(sp)
    8000343a:	6942                	ld	s2,16(sp)
    8000343c:	69a2                	ld	s3,8(sp)
    8000343e:	6145                	addi	sp,sp,48
    80003440:	8082                	ret

0000000080003442 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003442:	1101                	addi	sp,sp,-32
    80003444:	ec06                	sd	ra,24(sp)
    80003446:	e822                	sd	s0,16(sp)
    80003448:	e426                	sd	s1,8(sp)
    8000344a:	e04a                	sd	s2,0(sp)
    8000344c:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000344e:	00016517          	auipc	a0,0x16
    80003452:	bd250513          	addi	a0,a0,-1070 # 80019020 <log>
    80003456:	00003097          	auipc	ra,0x3
    8000345a:	c1c080e7          	jalr	-996(ra) # 80006072 <acquire>
  while(1){
    if(log.committing){
    8000345e:	00016497          	auipc	s1,0x16
    80003462:	bc248493          	addi	s1,s1,-1086 # 80019020 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003466:	4979                	li	s2,30
    80003468:	a039                	j	80003476 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000346a:	85a6                	mv	a1,s1
    8000346c:	8526                	mv	a0,s1
    8000346e:	ffffe097          	auipc	ra,0xffffe
    80003472:	092080e7          	jalr	146(ra) # 80001500 <sleep>
    if(log.committing){
    80003476:	50dc                	lw	a5,36(s1)
    80003478:	fbed                	bnez	a5,8000346a <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000347a:	509c                	lw	a5,32(s1)
    8000347c:	0017871b          	addiw	a4,a5,1
    80003480:	0007069b          	sext.w	a3,a4
    80003484:	0027179b          	slliw	a5,a4,0x2
    80003488:	9fb9                	addw	a5,a5,a4
    8000348a:	0017979b          	slliw	a5,a5,0x1
    8000348e:	54d8                	lw	a4,44(s1)
    80003490:	9fb9                	addw	a5,a5,a4
    80003492:	00f95963          	bge	s2,a5,800034a4 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003496:	85a6                	mv	a1,s1
    80003498:	8526                	mv	a0,s1
    8000349a:	ffffe097          	auipc	ra,0xffffe
    8000349e:	066080e7          	jalr	102(ra) # 80001500 <sleep>
    800034a2:	bfd1                	j	80003476 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800034a4:	00016517          	auipc	a0,0x16
    800034a8:	b7c50513          	addi	a0,a0,-1156 # 80019020 <log>
    800034ac:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800034ae:	00003097          	auipc	ra,0x3
    800034b2:	c78080e7          	jalr	-904(ra) # 80006126 <release>
      break;
    }
  }
}
    800034b6:	60e2                	ld	ra,24(sp)
    800034b8:	6442                	ld	s0,16(sp)
    800034ba:	64a2                	ld	s1,8(sp)
    800034bc:	6902                	ld	s2,0(sp)
    800034be:	6105                	addi	sp,sp,32
    800034c0:	8082                	ret

00000000800034c2 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800034c2:	7139                	addi	sp,sp,-64
    800034c4:	fc06                	sd	ra,56(sp)
    800034c6:	f822                	sd	s0,48(sp)
    800034c8:	f426                	sd	s1,40(sp)
    800034ca:	f04a                	sd	s2,32(sp)
    800034cc:	ec4e                	sd	s3,24(sp)
    800034ce:	e852                	sd	s4,16(sp)
    800034d0:	e456                	sd	s5,8(sp)
    800034d2:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800034d4:	00016497          	auipc	s1,0x16
    800034d8:	b4c48493          	addi	s1,s1,-1204 # 80019020 <log>
    800034dc:	8526                	mv	a0,s1
    800034de:	00003097          	auipc	ra,0x3
    800034e2:	b94080e7          	jalr	-1132(ra) # 80006072 <acquire>
  log.outstanding -= 1;
    800034e6:	509c                	lw	a5,32(s1)
    800034e8:	37fd                	addiw	a5,a5,-1
    800034ea:	0007891b          	sext.w	s2,a5
    800034ee:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800034f0:	50dc                	lw	a5,36(s1)
    800034f2:	efb9                	bnez	a5,80003550 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    800034f4:	06091663          	bnez	s2,80003560 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    800034f8:	00016497          	auipc	s1,0x16
    800034fc:	b2848493          	addi	s1,s1,-1240 # 80019020 <log>
    80003500:	4785                	li	a5,1
    80003502:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003504:	8526                	mv	a0,s1
    80003506:	00003097          	auipc	ra,0x3
    8000350a:	c20080e7          	jalr	-992(ra) # 80006126 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000350e:	54dc                	lw	a5,44(s1)
    80003510:	06f04763          	bgtz	a5,8000357e <end_op+0xbc>
    acquire(&log.lock);
    80003514:	00016497          	auipc	s1,0x16
    80003518:	b0c48493          	addi	s1,s1,-1268 # 80019020 <log>
    8000351c:	8526                	mv	a0,s1
    8000351e:	00003097          	auipc	ra,0x3
    80003522:	b54080e7          	jalr	-1196(ra) # 80006072 <acquire>
    log.committing = 0;
    80003526:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000352a:	8526                	mv	a0,s1
    8000352c:	ffffe097          	auipc	ra,0xffffe
    80003530:	160080e7          	jalr	352(ra) # 8000168c <wakeup>
    release(&log.lock);
    80003534:	8526                	mv	a0,s1
    80003536:	00003097          	auipc	ra,0x3
    8000353a:	bf0080e7          	jalr	-1040(ra) # 80006126 <release>
}
    8000353e:	70e2                	ld	ra,56(sp)
    80003540:	7442                	ld	s0,48(sp)
    80003542:	74a2                	ld	s1,40(sp)
    80003544:	7902                	ld	s2,32(sp)
    80003546:	69e2                	ld	s3,24(sp)
    80003548:	6a42                	ld	s4,16(sp)
    8000354a:	6aa2                	ld	s5,8(sp)
    8000354c:	6121                	addi	sp,sp,64
    8000354e:	8082                	ret
    panic("log.committing");
    80003550:	00005517          	auipc	a0,0x5
    80003554:	0a050513          	addi	a0,a0,160 # 800085f0 <syscalls+0x228>
    80003558:	00002097          	auipc	ra,0x2
    8000355c:	5d0080e7          	jalr	1488(ra) # 80005b28 <panic>
    wakeup(&log);
    80003560:	00016497          	auipc	s1,0x16
    80003564:	ac048493          	addi	s1,s1,-1344 # 80019020 <log>
    80003568:	8526                	mv	a0,s1
    8000356a:	ffffe097          	auipc	ra,0xffffe
    8000356e:	122080e7          	jalr	290(ra) # 8000168c <wakeup>
  release(&log.lock);
    80003572:	8526                	mv	a0,s1
    80003574:	00003097          	auipc	ra,0x3
    80003578:	bb2080e7          	jalr	-1102(ra) # 80006126 <release>
  if(do_commit){
    8000357c:	b7c9                	j	8000353e <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000357e:	00016a97          	auipc	s5,0x16
    80003582:	ad2a8a93          	addi	s5,s5,-1326 # 80019050 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003586:	00016a17          	auipc	s4,0x16
    8000358a:	a9aa0a13          	addi	s4,s4,-1382 # 80019020 <log>
    8000358e:	018a2583          	lw	a1,24(s4)
    80003592:	012585bb          	addw	a1,a1,s2
    80003596:	2585                	addiw	a1,a1,1
    80003598:	028a2503          	lw	a0,40(s4)
    8000359c:	fffff097          	auipc	ra,0xfffff
    800035a0:	cd2080e7          	jalr	-814(ra) # 8000226e <bread>
    800035a4:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800035a6:	000aa583          	lw	a1,0(s5)
    800035aa:	028a2503          	lw	a0,40(s4)
    800035ae:	fffff097          	auipc	ra,0xfffff
    800035b2:	cc0080e7          	jalr	-832(ra) # 8000226e <bread>
    800035b6:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800035b8:	40000613          	li	a2,1024
    800035bc:	05850593          	addi	a1,a0,88
    800035c0:	05848513          	addi	a0,s1,88
    800035c4:	ffffd097          	auipc	ra,0xffffd
    800035c8:	c14080e7          	jalr	-1004(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    800035cc:	8526                	mv	a0,s1
    800035ce:	fffff097          	auipc	ra,0xfffff
    800035d2:	d92080e7          	jalr	-622(ra) # 80002360 <bwrite>
    brelse(from);
    800035d6:	854e                	mv	a0,s3
    800035d8:	fffff097          	auipc	ra,0xfffff
    800035dc:	dc6080e7          	jalr	-570(ra) # 8000239e <brelse>
    brelse(to);
    800035e0:	8526                	mv	a0,s1
    800035e2:	fffff097          	auipc	ra,0xfffff
    800035e6:	dbc080e7          	jalr	-580(ra) # 8000239e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035ea:	2905                	addiw	s2,s2,1
    800035ec:	0a91                	addi	s5,s5,4
    800035ee:	02ca2783          	lw	a5,44(s4)
    800035f2:	f8f94ee3          	blt	s2,a5,8000358e <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800035f6:	00000097          	auipc	ra,0x0
    800035fa:	c6a080e7          	jalr	-918(ra) # 80003260 <write_head>
    install_trans(0); // Now install writes to home locations
    800035fe:	4501                	li	a0,0
    80003600:	00000097          	auipc	ra,0x0
    80003604:	cda080e7          	jalr	-806(ra) # 800032da <install_trans>
    log.lh.n = 0;
    80003608:	00016797          	auipc	a5,0x16
    8000360c:	a407a223          	sw	zero,-1468(a5) # 8001904c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003610:	00000097          	auipc	ra,0x0
    80003614:	c50080e7          	jalr	-944(ra) # 80003260 <write_head>
    80003618:	bdf5                	j	80003514 <end_op+0x52>

000000008000361a <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000361a:	1101                	addi	sp,sp,-32
    8000361c:	ec06                	sd	ra,24(sp)
    8000361e:	e822                	sd	s0,16(sp)
    80003620:	e426                	sd	s1,8(sp)
    80003622:	e04a                	sd	s2,0(sp)
    80003624:	1000                	addi	s0,sp,32
    80003626:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003628:	00016917          	auipc	s2,0x16
    8000362c:	9f890913          	addi	s2,s2,-1544 # 80019020 <log>
    80003630:	854a                	mv	a0,s2
    80003632:	00003097          	auipc	ra,0x3
    80003636:	a40080e7          	jalr	-1472(ra) # 80006072 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000363a:	02c92603          	lw	a2,44(s2)
    8000363e:	47f5                	li	a5,29
    80003640:	06c7c563          	blt	a5,a2,800036aa <log_write+0x90>
    80003644:	00016797          	auipc	a5,0x16
    80003648:	9f87a783          	lw	a5,-1544(a5) # 8001903c <log+0x1c>
    8000364c:	37fd                	addiw	a5,a5,-1
    8000364e:	04f65e63          	bge	a2,a5,800036aa <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003652:	00016797          	auipc	a5,0x16
    80003656:	9ee7a783          	lw	a5,-1554(a5) # 80019040 <log+0x20>
    8000365a:	06f05063          	blez	a5,800036ba <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000365e:	4781                	li	a5,0
    80003660:	06c05563          	blez	a2,800036ca <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003664:	44cc                	lw	a1,12(s1)
    80003666:	00016717          	auipc	a4,0x16
    8000366a:	9ea70713          	addi	a4,a4,-1558 # 80019050 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000366e:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003670:	4314                	lw	a3,0(a4)
    80003672:	04b68c63          	beq	a3,a1,800036ca <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003676:	2785                	addiw	a5,a5,1
    80003678:	0711                	addi	a4,a4,4
    8000367a:	fef61be3          	bne	a2,a5,80003670 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000367e:	0621                	addi	a2,a2,8
    80003680:	060a                	slli	a2,a2,0x2
    80003682:	00016797          	auipc	a5,0x16
    80003686:	99e78793          	addi	a5,a5,-1634 # 80019020 <log>
    8000368a:	963e                	add	a2,a2,a5
    8000368c:	44dc                	lw	a5,12(s1)
    8000368e:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003690:	8526                	mv	a0,s1
    80003692:	fffff097          	auipc	ra,0xfffff
    80003696:	daa080e7          	jalr	-598(ra) # 8000243c <bpin>
    log.lh.n++;
    8000369a:	00016717          	auipc	a4,0x16
    8000369e:	98670713          	addi	a4,a4,-1658 # 80019020 <log>
    800036a2:	575c                	lw	a5,44(a4)
    800036a4:	2785                	addiw	a5,a5,1
    800036a6:	d75c                	sw	a5,44(a4)
    800036a8:	a835                	j	800036e4 <log_write+0xca>
    panic("too big a transaction");
    800036aa:	00005517          	auipc	a0,0x5
    800036ae:	f5650513          	addi	a0,a0,-170 # 80008600 <syscalls+0x238>
    800036b2:	00002097          	auipc	ra,0x2
    800036b6:	476080e7          	jalr	1142(ra) # 80005b28 <panic>
    panic("log_write outside of trans");
    800036ba:	00005517          	auipc	a0,0x5
    800036be:	f5e50513          	addi	a0,a0,-162 # 80008618 <syscalls+0x250>
    800036c2:	00002097          	auipc	ra,0x2
    800036c6:	466080e7          	jalr	1126(ra) # 80005b28 <panic>
  log.lh.block[i] = b->blockno;
    800036ca:	00878713          	addi	a4,a5,8
    800036ce:	00271693          	slli	a3,a4,0x2
    800036d2:	00016717          	auipc	a4,0x16
    800036d6:	94e70713          	addi	a4,a4,-1714 # 80019020 <log>
    800036da:	9736                	add	a4,a4,a3
    800036dc:	44d4                	lw	a3,12(s1)
    800036de:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800036e0:	faf608e3          	beq	a2,a5,80003690 <log_write+0x76>
  }
  release(&log.lock);
    800036e4:	00016517          	auipc	a0,0x16
    800036e8:	93c50513          	addi	a0,a0,-1732 # 80019020 <log>
    800036ec:	00003097          	auipc	ra,0x3
    800036f0:	a3a080e7          	jalr	-1478(ra) # 80006126 <release>
}
    800036f4:	60e2                	ld	ra,24(sp)
    800036f6:	6442                	ld	s0,16(sp)
    800036f8:	64a2                	ld	s1,8(sp)
    800036fa:	6902                	ld	s2,0(sp)
    800036fc:	6105                	addi	sp,sp,32
    800036fe:	8082                	ret

0000000080003700 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003700:	1101                	addi	sp,sp,-32
    80003702:	ec06                	sd	ra,24(sp)
    80003704:	e822                	sd	s0,16(sp)
    80003706:	e426                	sd	s1,8(sp)
    80003708:	e04a                	sd	s2,0(sp)
    8000370a:	1000                	addi	s0,sp,32
    8000370c:	84aa                	mv	s1,a0
    8000370e:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003710:	00005597          	auipc	a1,0x5
    80003714:	f2858593          	addi	a1,a1,-216 # 80008638 <syscalls+0x270>
    80003718:	0521                	addi	a0,a0,8
    8000371a:	00003097          	auipc	ra,0x3
    8000371e:	8c8080e7          	jalr	-1848(ra) # 80005fe2 <initlock>
  lk->name = name;
    80003722:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003726:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000372a:	0204a423          	sw	zero,40(s1)
}
    8000372e:	60e2                	ld	ra,24(sp)
    80003730:	6442                	ld	s0,16(sp)
    80003732:	64a2                	ld	s1,8(sp)
    80003734:	6902                	ld	s2,0(sp)
    80003736:	6105                	addi	sp,sp,32
    80003738:	8082                	ret

000000008000373a <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000373a:	1101                	addi	sp,sp,-32
    8000373c:	ec06                	sd	ra,24(sp)
    8000373e:	e822                	sd	s0,16(sp)
    80003740:	e426                	sd	s1,8(sp)
    80003742:	e04a                	sd	s2,0(sp)
    80003744:	1000                	addi	s0,sp,32
    80003746:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003748:	00850913          	addi	s2,a0,8
    8000374c:	854a                	mv	a0,s2
    8000374e:	00003097          	auipc	ra,0x3
    80003752:	924080e7          	jalr	-1756(ra) # 80006072 <acquire>
  while (lk->locked) {
    80003756:	409c                	lw	a5,0(s1)
    80003758:	cb89                	beqz	a5,8000376a <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000375a:	85ca                	mv	a1,s2
    8000375c:	8526                	mv	a0,s1
    8000375e:	ffffe097          	auipc	ra,0xffffe
    80003762:	da2080e7          	jalr	-606(ra) # 80001500 <sleep>
  while (lk->locked) {
    80003766:	409c                	lw	a5,0(s1)
    80003768:	fbed                	bnez	a5,8000375a <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000376a:	4785                	li	a5,1
    8000376c:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000376e:	ffffd097          	auipc	ra,0xffffd
    80003772:	6d6080e7          	jalr	1750(ra) # 80000e44 <myproc>
    80003776:	591c                	lw	a5,48(a0)
    80003778:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000377a:	854a                	mv	a0,s2
    8000377c:	00003097          	auipc	ra,0x3
    80003780:	9aa080e7          	jalr	-1622(ra) # 80006126 <release>
}
    80003784:	60e2                	ld	ra,24(sp)
    80003786:	6442                	ld	s0,16(sp)
    80003788:	64a2                	ld	s1,8(sp)
    8000378a:	6902                	ld	s2,0(sp)
    8000378c:	6105                	addi	sp,sp,32
    8000378e:	8082                	ret

0000000080003790 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003790:	1101                	addi	sp,sp,-32
    80003792:	ec06                	sd	ra,24(sp)
    80003794:	e822                	sd	s0,16(sp)
    80003796:	e426                	sd	s1,8(sp)
    80003798:	e04a                	sd	s2,0(sp)
    8000379a:	1000                	addi	s0,sp,32
    8000379c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000379e:	00850913          	addi	s2,a0,8
    800037a2:	854a                	mv	a0,s2
    800037a4:	00003097          	auipc	ra,0x3
    800037a8:	8ce080e7          	jalr	-1842(ra) # 80006072 <acquire>
  lk->locked = 0;
    800037ac:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800037b0:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800037b4:	8526                	mv	a0,s1
    800037b6:	ffffe097          	auipc	ra,0xffffe
    800037ba:	ed6080e7          	jalr	-298(ra) # 8000168c <wakeup>
  release(&lk->lk);
    800037be:	854a                	mv	a0,s2
    800037c0:	00003097          	auipc	ra,0x3
    800037c4:	966080e7          	jalr	-1690(ra) # 80006126 <release>
}
    800037c8:	60e2                	ld	ra,24(sp)
    800037ca:	6442                	ld	s0,16(sp)
    800037cc:	64a2                	ld	s1,8(sp)
    800037ce:	6902                	ld	s2,0(sp)
    800037d0:	6105                	addi	sp,sp,32
    800037d2:	8082                	ret

00000000800037d4 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800037d4:	7179                	addi	sp,sp,-48
    800037d6:	f406                	sd	ra,40(sp)
    800037d8:	f022                	sd	s0,32(sp)
    800037da:	ec26                	sd	s1,24(sp)
    800037dc:	e84a                	sd	s2,16(sp)
    800037de:	e44e                	sd	s3,8(sp)
    800037e0:	1800                	addi	s0,sp,48
    800037e2:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800037e4:	00850913          	addi	s2,a0,8
    800037e8:	854a                	mv	a0,s2
    800037ea:	00003097          	auipc	ra,0x3
    800037ee:	888080e7          	jalr	-1912(ra) # 80006072 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800037f2:	409c                	lw	a5,0(s1)
    800037f4:	ef99                	bnez	a5,80003812 <holdingsleep+0x3e>
    800037f6:	4481                	li	s1,0
  release(&lk->lk);
    800037f8:	854a                	mv	a0,s2
    800037fa:	00003097          	auipc	ra,0x3
    800037fe:	92c080e7          	jalr	-1748(ra) # 80006126 <release>
  return r;
}
    80003802:	8526                	mv	a0,s1
    80003804:	70a2                	ld	ra,40(sp)
    80003806:	7402                	ld	s0,32(sp)
    80003808:	64e2                	ld	s1,24(sp)
    8000380a:	6942                	ld	s2,16(sp)
    8000380c:	69a2                	ld	s3,8(sp)
    8000380e:	6145                	addi	sp,sp,48
    80003810:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003812:	0284a983          	lw	s3,40(s1)
    80003816:	ffffd097          	auipc	ra,0xffffd
    8000381a:	62e080e7          	jalr	1582(ra) # 80000e44 <myproc>
    8000381e:	5904                	lw	s1,48(a0)
    80003820:	413484b3          	sub	s1,s1,s3
    80003824:	0014b493          	seqz	s1,s1
    80003828:	bfc1                	j	800037f8 <holdingsleep+0x24>

000000008000382a <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000382a:	1141                	addi	sp,sp,-16
    8000382c:	e406                	sd	ra,8(sp)
    8000382e:	e022                	sd	s0,0(sp)
    80003830:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003832:	00005597          	auipc	a1,0x5
    80003836:	e1658593          	addi	a1,a1,-490 # 80008648 <syscalls+0x280>
    8000383a:	00016517          	auipc	a0,0x16
    8000383e:	92e50513          	addi	a0,a0,-1746 # 80019168 <ftable>
    80003842:	00002097          	auipc	ra,0x2
    80003846:	7a0080e7          	jalr	1952(ra) # 80005fe2 <initlock>
}
    8000384a:	60a2                	ld	ra,8(sp)
    8000384c:	6402                	ld	s0,0(sp)
    8000384e:	0141                	addi	sp,sp,16
    80003850:	8082                	ret

0000000080003852 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003852:	1101                	addi	sp,sp,-32
    80003854:	ec06                	sd	ra,24(sp)
    80003856:	e822                	sd	s0,16(sp)
    80003858:	e426                	sd	s1,8(sp)
    8000385a:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000385c:	00016517          	auipc	a0,0x16
    80003860:	90c50513          	addi	a0,a0,-1780 # 80019168 <ftable>
    80003864:	00003097          	auipc	ra,0x3
    80003868:	80e080e7          	jalr	-2034(ra) # 80006072 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000386c:	00016497          	auipc	s1,0x16
    80003870:	91448493          	addi	s1,s1,-1772 # 80019180 <ftable+0x18>
    80003874:	00017717          	auipc	a4,0x17
    80003878:	8ac70713          	addi	a4,a4,-1876 # 8001a120 <ftable+0xfb8>
    if(f->ref == 0){
    8000387c:	40dc                	lw	a5,4(s1)
    8000387e:	cf99                	beqz	a5,8000389c <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003880:	02848493          	addi	s1,s1,40
    80003884:	fee49ce3          	bne	s1,a4,8000387c <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003888:	00016517          	auipc	a0,0x16
    8000388c:	8e050513          	addi	a0,a0,-1824 # 80019168 <ftable>
    80003890:	00003097          	auipc	ra,0x3
    80003894:	896080e7          	jalr	-1898(ra) # 80006126 <release>
  return 0;
    80003898:	4481                	li	s1,0
    8000389a:	a819                	j	800038b0 <filealloc+0x5e>
      f->ref = 1;
    8000389c:	4785                	li	a5,1
    8000389e:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800038a0:	00016517          	auipc	a0,0x16
    800038a4:	8c850513          	addi	a0,a0,-1848 # 80019168 <ftable>
    800038a8:	00003097          	auipc	ra,0x3
    800038ac:	87e080e7          	jalr	-1922(ra) # 80006126 <release>
}
    800038b0:	8526                	mv	a0,s1
    800038b2:	60e2                	ld	ra,24(sp)
    800038b4:	6442                	ld	s0,16(sp)
    800038b6:	64a2                	ld	s1,8(sp)
    800038b8:	6105                	addi	sp,sp,32
    800038ba:	8082                	ret

00000000800038bc <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800038bc:	1101                	addi	sp,sp,-32
    800038be:	ec06                	sd	ra,24(sp)
    800038c0:	e822                	sd	s0,16(sp)
    800038c2:	e426                	sd	s1,8(sp)
    800038c4:	1000                	addi	s0,sp,32
    800038c6:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800038c8:	00016517          	auipc	a0,0x16
    800038cc:	8a050513          	addi	a0,a0,-1888 # 80019168 <ftable>
    800038d0:	00002097          	auipc	ra,0x2
    800038d4:	7a2080e7          	jalr	1954(ra) # 80006072 <acquire>
  if(f->ref < 1)
    800038d8:	40dc                	lw	a5,4(s1)
    800038da:	02f05263          	blez	a5,800038fe <filedup+0x42>
    panic("filedup");
  f->ref++;
    800038de:	2785                	addiw	a5,a5,1
    800038e0:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800038e2:	00016517          	auipc	a0,0x16
    800038e6:	88650513          	addi	a0,a0,-1914 # 80019168 <ftable>
    800038ea:	00003097          	auipc	ra,0x3
    800038ee:	83c080e7          	jalr	-1988(ra) # 80006126 <release>
  return f;
}
    800038f2:	8526                	mv	a0,s1
    800038f4:	60e2                	ld	ra,24(sp)
    800038f6:	6442                	ld	s0,16(sp)
    800038f8:	64a2                	ld	s1,8(sp)
    800038fa:	6105                	addi	sp,sp,32
    800038fc:	8082                	ret
    panic("filedup");
    800038fe:	00005517          	auipc	a0,0x5
    80003902:	d5250513          	addi	a0,a0,-686 # 80008650 <syscalls+0x288>
    80003906:	00002097          	auipc	ra,0x2
    8000390a:	222080e7          	jalr	546(ra) # 80005b28 <panic>

000000008000390e <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000390e:	7139                	addi	sp,sp,-64
    80003910:	fc06                	sd	ra,56(sp)
    80003912:	f822                	sd	s0,48(sp)
    80003914:	f426                	sd	s1,40(sp)
    80003916:	f04a                	sd	s2,32(sp)
    80003918:	ec4e                	sd	s3,24(sp)
    8000391a:	e852                	sd	s4,16(sp)
    8000391c:	e456                	sd	s5,8(sp)
    8000391e:	0080                	addi	s0,sp,64
    80003920:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003922:	00016517          	auipc	a0,0x16
    80003926:	84650513          	addi	a0,a0,-1978 # 80019168 <ftable>
    8000392a:	00002097          	auipc	ra,0x2
    8000392e:	748080e7          	jalr	1864(ra) # 80006072 <acquire>
  if(f->ref < 1)
    80003932:	40dc                	lw	a5,4(s1)
    80003934:	06f05163          	blez	a5,80003996 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003938:	37fd                	addiw	a5,a5,-1
    8000393a:	0007871b          	sext.w	a4,a5
    8000393e:	c0dc                	sw	a5,4(s1)
    80003940:	06e04363          	bgtz	a4,800039a6 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003944:	0004a903          	lw	s2,0(s1)
    80003948:	0094ca83          	lbu	s5,9(s1)
    8000394c:	0104ba03          	ld	s4,16(s1)
    80003950:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003954:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003958:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000395c:	00016517          	auipc	a0,0x16
    80003960:	80c50513          	addi	a0,a0,-2036 # 80019168 <ftable>
    80003964:	00002097          	auipc	ra,0x2
    80003968:	7c2080e7          	jalr	1986(ra) # 80006126 <release>

  if(ff.type == FD_PIPE){
    8000396c:	4785                	li	a5,1
    8000396e:	04f90d63          	beq	s2,a5,800039c8 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003972:	3979                	addiw	s2,s2,-2
    80003974:	4785                	li	a5,1
    80003976:	0527e063          	bltu	a5,s2,800039b6 <fileclose+0xa8>
    begin_op();
    8000397a:	00000097          	auipc	ra,0x0
    8000397e:	ac8080e7          	jalr	-1336(ra) # 80003442 <begin_op>
    iput(ff.ip);
    80003982:	854e                	mv	a0,s3
    80003984:	fffff097          	auipc	ra,0xfffff
    80003988:	2a6080e7          	jalr	678(ra) # 80002c2a <iput>
    end_op();
    8000398c:	00000097          	auipc	ra,0x0
    80003990:	b36080e7          	jalr	-1226(ra) # 800034c2 <end_op>
    80003994:	a00d                	j	800039b6 <fileclose+0xa8>
    panic("fileclose");
    80003996:	00005517          	auipc	a0,0x5
    8000399a:	cc250513          	addi	a0,a0,-830 # 80008658 <syscalls+0x290>
    8000399e:	00002097          	auipc	ra,0x2
    800039a2:	18a080e7          	jalr	394(ra) # 80005b28 <panic>
    release(&ftable.lock);
    800039a6:	00015517          	auipc	a0,0x15
    800039aa:	7c250513          	addi	a0,a0,1986 # 80019168 <ftable>
    800039ae:	00002097          	auipc	ra,0x2
    800039b2:	778080e7          	jalr	1912(ra) # 80006126 <release>
  }
}
    800039b6:	70e2                	ld	ra,56(sp)
    800039b8:	7442                	ld	s0,48(sp)
    800039ba:	74a2                	ld	s1,40(sp)
    800039bc:	7902                	ld	s2,32(sp)
    800039be:	69e2                	ld	s3,24(sp)
    800039c0:	6a42                	ld	s4,16(sp)
    800039c2:	6aa2                	ld	s5,8(sp)
    800039c4:	6121                	addi	sp,sp,64
    800039c6:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800039c8:	85d6                	mv	a1,s5
    800039ca:	8552                	mv	a0,s4
    800039cc:	00000097          	auipc	ra,0x0
    800039d0:	34c080e7          	jalr	844(ra) # 80003d18 <pipeclose>
    800039d4:	b7cd                	j	800039b6 <fileclose+0xa8>

00000000800039d6 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800039d6:	715d                	addi	sp,sp,-80
    800039d8:	e486                	sd	ra,72(sp)
    800039da:	e0a2                	sd	s0,64(sp)
    800039dc:	fc26                	sd	s1,56(sp)
    800039de:	f84a                	sd	s2,48(sp)
    800039e0:	f44e                	sd	s3,40(sp)
    800039e2:	0880                	addi	s0,sp,80
    800039e4:	84aa                	mv	s1,a0
    800039e6:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800039e8:	ffffd097          	auipc	ra,0xffffd
    800039ec:	45c080e7          	jalr	1116(ra) # 80000e44 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800039f0:	409c                	lw	a5,0(s1)
    800039f2:	37f9                	addiw	a5,a5,-2
    800039f4:	4705                	li	a4,1
    800039f6:	04f76763          	bltu	a4,a5,80003a44 <filestat+0x6e>
    800039fa:	892a                	mv	s2,a0
    ilock(f->ip);
    800039fc:	6c88                	ld	a0,24(s1)
    800039fe:	fffff097          	auipc	ra,0xfffff
    80003a02:	072080e7          	jalr	114(ra) # 80002a70 <ilock>
    stati(f->ip, &st);
    80003a06:	fb840593          	addi	a1,s0,-72
    80003a0a:	6c88                	ld	a0,24(s1)
    80003a0c:	fffff097          	auipc	ra,0xfffff
    80003a10:	2ee080e7          	jalr	750(ra) # 80002cfa <stati>
    iunlock(f->ip);
    80003a14:	6c88                	ld	a0,24(s1)
    80003a16:	fffff097          	auipc	ra,0xfffff
    80003a1a:	11c080e7          	jalr	284(ra) # 80002b32 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003a1e:	46e1                	li	a3,24
    80003a20:	fb840613          	addi	a2,s0,-72
    80003a24:	85ce                	mv	a1,s3
    80003a26:	05093503          	ld	a0,80(s2)
    80003a2a:	ffffd097          	auipc	ra,0xffffd
    80003a2e:	0e0080e7          	jalr	224(ra) # 80000b0a <copyout>
    80003a32:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003a36:	60a6                	ld	ra,72(sp)
    80003a38:	6406                	ld	s0,64(sp)
    80003a3a:	74e2                	ld	s1,56(sp)
    80003a3c:	7942                	ld	s2,48(sp)
    80003a3e:	79a2                	ld	s3,40(sp)
    80003a40:	6161                	addi	sp,sp,80
    80003a42:	8082                	ret
  return -1;
    80003a44:	557d                	li	a0,-1
    80003a46:	bfc5                	j	80003a36 <filestat+0x60>

0000000080003a48 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003a48:	7179                	addi	sp,sp,-48
    80003a4a:	f406                	sd	ra,40(sp)
    80003a4c:	f022                	sd	s0,32(sp)
    80003a4e:	ec26                	sd	s1,24(sp)
    80003a50:	e84a                	sd	s2,16(sp)
    80003a52:	e44e                	sd	s3,8(sp)
    80003a54:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003a56:	00854783          	lbu	a5,8(a0)
    80003a5a:	c3d5                	beqz	a5,80003afe <fileread+0xb6>
    80003a5c:	84aa                	mv	s1,a0
    80003a5e:	89ae                	mv	s3,a1
    80003a60:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003a62:	411c                	lw	a5,0(a0)
    80003a64:	4705                	li	a4,1
    80003a66:	04e78963          	beq	a5,a4,80003ab8 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003a6a:	470d                	li	a4,3
    80003a6c:	04e78d63          	beq	a5,a4,80003ac6 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003a70:	4709                	li	a4,2
    80003a72:	06e79e63          	bne	a5,a4,80003aee <fileread+0xa6>
    ilock(f->ip);
    80003a76:	6d08                	ld	a0,24(a0)
    80003a78:	fffff097          	auipc	ra,0xfffff
    80003a7c:	ff8080e7          	jalr	-8(ra) # 80002a70 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003a80:	874a                	mv	a4,s2
    80003a82:	5094                	lw	a3,32(s1)
    80003a84:	864e                	mv	a2,s3
    80003a86:	4585                	li	a1,1
    80003a88:	6c88                	ld	a0,24(s1)
    80003a8a:	fffff097          	auipc	ra,0xfffff
    80003a8e:	29a080e7          	jalr	666(ra) # 80002d24 <readi>
    80003a92:	892a                	mv	s2,a0
    80003a94:	00a05563          	blez	a0,80003a9e <fileread+0x56>
      f->off += r;
    80003a98:	509c                	lw	a5,32(s1)
    80003a9a:	9fa9                	addw	a5,a5,a0
    80003a9c:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003a9e:	6c88                	ld	a0,24(s1)
    80003aa0:	fffff097          	auipc	ra,0xfffff
    80003aa4:	092080e7          	jalr	146(ra) # 80002b32 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003aa8:	854a                	mv	a0,s2
    80003aaa:	70a2                	ld	ra,40(sp)
    80003aac:	7402                	ld	s0,32(sp)
    80003aae:	64e2                	ld	s1,24(sp)
    80003ab0:	6942                	ld	s2,16(sp)
    80003ab2:	69a2                	ld	s3,8(sp)
    80003ab4:	6145                	addi	sp,sp,48
    80003ab6:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003ab8:	6908                	ld	a0,16(a0)
    80003aba:	00000097          	auipc	ra,0x0
    80003abe:	3c8080e7          	jalr	968(ra) # 80003e82 <piperead>
    80003ac2:	892a                	mv	s2,a0
    80003ac4:	b7d5                	j	80003aa8 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003ac6:	02451783          	lh	a5,36(a0)
    80003aca:	03079693          	slli	a3,a5,0x30
    80003ace:	92c1                	srli	a3,a3,0x30
    80003ad0:	4725                	li	a4,9
    80003ad2:	02d76863          	bltu	a4,a3,80003b02 <fileread+0xba>
    80003ad6:	0792                	slli	a5,a5,0x4
    80003ad8:	00015717          	auipc	a4,0x15
    80003adc:	5f070713          	addi	a4,a4,1520 # 800190c8 <devsw>
    80003ae0:	97ba                	add	a5,a5,a4
    80003ae2:	639c                	ld	a5,0(a5)
    80003ae4:	c38d                	beqz	a5,80003b06 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003ae6:	4505                	li	a0,1
    80003ae8:	9782                	jalr	a5
    80003aea:	892a                	mv	s2,a0
    80003aec:	bf75                	j	80003aa8 <fileread+0x60>
    panic("fileread");
    80003aee:	00005517          	auipc	a0,0x5
    80003af2:	b7a50513          	addi	a0,a0,-1158 # 80008668 <syscalls+0x2a0>
    80003af6:	00002097          	auipc	ra,0x2
    80003afa:	032080e7          	jalr	50(ra) # 80005b28 <panic>
    return -1;
    80003afe:	597d                	li	s2,-1
    80003b00:	b765                	j	80003aa8 <fileread+0x60>
      return -1;
    80003b02:	597d                	li	s2,-1
    80003b04:	b755                	j	80003aa8 <fileread+0x60>
    80003b06:	597d                	li	s2,-1
    80003b08:	b745                	j	80003aa8 <fileread+0x60>

0000000080003b0a <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003b0a:	715d                	addi	sp,sp,-80
    80003b0c:	e486                	sd	ra,72(sp)
    80003b0e:	e0a2                	sd	s0,64(sp)
    80003b10:	fc26                	sd	s1,56(sp)
    80003b12:	f84a                	sd	s2,48(sp)
    80003b14:	f44e                	sd	s3,40(sp)
    80003b16:	f052                	sd	s4,32(sp)
    80003b18:	ec56                	sd	s5,24(sp)
    80003b1a:	e85a                	sd	s6,16(sp)
    80003b1c:	e45e                	sd	s7,8(sp)
    80003b1e:	e062                	sd	s8,0(sp)
    80003b20:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003b22:	00954783          	lbu	a5,9(a0)
    80003b26:	10078663          	beqz	a5,80003c32 <filewrite+0x128>
    80003b2a:	892a                	mv	s2,a0
    80003b2c:	8aae                	mv	s5,a1
    80003b2e:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b30:	411c                	lw	a5,0(a0)
    80003b32:	4705                	li	a4,1
    80003b34:	02e78263          	beq	a5,a4,80003b58 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b38:	470d                	li	a4,3
    80003b3a:	02e78663          	beq	a5,a4,80003b66 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003b3e:	4709                	li	a4,2
    80003b40:	0ee79163          	bne	a5,a4,80003c22 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003b44:	0ac05d63          	blez	a2,80003bfe <filewrite+0xf4>
    int i = 0;
    80003b48:	4981                	li	s3,0
    80003b4a:	6b05                	lui	s6,0x1
    80003b4c:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003b50:	6b85                	lui	s7,0x1
    80003b52:	c00b8b9b          	addiw	s7,s7,-1024
    80003b56:	a861                	j	80003bee <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003b58:	6908                	ld	a0,16(a0)
    80003b5a:	00000097          	auipc	ra,0x0
    80003b5e:	22e080e7          	jalr	558(ra) # 80003d88 <pipewrite>
    80003b62:	8a2a                	mv	s4,a0
    80003b64:	a045                	j	80003c04 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003b66:	02451783          	lh	a5,36(a0)
    80003b6a:	03079693          	slli	a3,a5,0x30
    80003b6e:	92c1                	srli	a3,a3,0x30
    80003b70:	4725                	li	a4,9
    80003b72:	0cd76263          	bltu	a4,a3,80003c36 <filewrite+0x12c>
    80003b76:	0792                	slli	a5,a5,0x4
    80003b78:	00015717          	auipc	a4,0x15
    80003b7c:	55070713          	addi	a4,a4,1360 # 800190c8 <devsw>
    80003b80:	97ba                	add	a5,a5,a4
    80003b82:	679c                	ld	a5,8(a5)
    80003b84:	cbdd                	beqz	a5,80003c3a <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003b86:	4505                	li	a0,1
    80003b88:	9782                	jalr	a5
    80003b8a:	8a2a                	mv	s4,a0
    80003b8c:	a8a5                	j	80003c04 <filewrite+0xfa>
    80003b8e:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003b92:	00000097          	auipc	ra,0x0
    80003b96:	8b0080e7          	jalr	-1872(ra) # 80003442 <begin_op>
      ilock(f->ip);
    80003b9a:	01893503          	ld	a0,24(s2)
    80003b9e:	fffff097          	auipc	ra,0xfffff
    80003ba2:	ed2080e7          	jalr	-302(ra) # 80002a70 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003ba6:	8762                	mv	a4,s8
    80003ba8:	02092683          	lw	a3,32(s2)
    80003bac:	01598633          	add	a2,s3,s5
    80003bb0:	4585                	li	a1,1
    80003bb2:	01893503          	ld	a0,24(s2)
    80003bb6:	fffff097          	auipc	ra,0xfffff
    80003bba:	266080e7          	jalr	614(ra) # 80002e1c <writei>
    80003bbe:	84aa                	mv	s1,a0
    80003bc0:	00a05763          	blez	a0,80003bce <filewrite+0xc4>
        f->off += r;
    80003bc4:	02092783          	lw	a5,32(s2)
    80003bc8:	9fa9                	addw	a5,a5,a0
    80003bca:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003bce:	01893503          	ld	a0,24(s2)
    80003bd2:	fffff097          	auipc	ra,0xfffff
    80003bd6:	f60080e7          	jalr	-160(ra) # 80002b32 <iunlock>
      end_op();
    80003bda:	00000097          	auipc	ra,0x0
    80003bde:	8e8080e7          	jalr	-1816(ra) # 800034c2 <end_op>

      if(r != n1){
    80003be2:	009c1f63          	bne	s8,s1,80003c00 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003be6:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003bea:	0149db63          	bge	s3,s4,80003c00 <filewrite+0xf6>
      int n1 = n - i;
    80003bee:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003bf2:	84be                	mv	s1,a5
    80003bf4:	2781                	sext.w	a5,a5
    80003bf6:	f8fb5ce3          	bge	s6,a5,80003b8e <filewrite+0x84>
    80003bfa:	84de                	mv	s1,s7
    80003bfc:	bf49                	j	80003b8e <filewrite+0x84>
    int i = 0;
    80003bfe:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003c00:	013a1f63          	bne	s4,s3,80003c1e <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003c04:	8552                	mv	a0,s4
    80003c06:	60a6                	ld	ra,72(sp)
    80003c08:	6406                	ld	s0,64(sp)
    80003c0a:	74e2                	ld	s1,56(sp)
    80003c0c:	7942                	ld	s2,48(sp)
    80003c0e:	79a2                	ld	s3,40(sp)
    80003c10:	7a02                	ld	s4,32(sp)
    80003c12:	6ae2                	ld	s5,24(sp)
    80003c14:	6b42                	ld	s6,16(sp)
    80003c16:	6ba2                	ld	s7,8(sp)
    80003c18:	6c02                	ld	s8,0(sp)
    80003c1a:	6161                	addi	sp,sp,80
    80003c1c:	8082                	ret
    ret = (i == n ? n : -1);
    80003c1e:	5a7d                	li	s4,-1
    80003c20:	b7d5                	j	80003c04 <filewrite+0xfa>
    panic("filewrite");
    80003c22:	00005517          	auipc	a0,0x5
    80003c26:	a5650513          	addi	a0,a0,-1450 # 80008678 <syscalls+0x2b0>
    80003c2a:	00002097          	auipc	ra,0x2
    80003c2e:	efe080e7          	jalr	-258(ra) # 80005b28 <panic>
    return -1;
    80003c32:	5a7d                	li	s4,-1
    80003c34:	bfc1                	j	80003c04 <filewrite+0xfa>
      return -1;
    80003c36:	5a7d                	li	s4,-1
    80003c38:	b7f1                	j	80003c04 <filewrite+0xfa>
    80003c3a:	5a7d                	li	s4,-1
    80003c3c:	b7e1                	j	80003c04 <filewrite+0xfa>

0000000080003c3e <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003c3e:	7179                	addi	sp,sp,-48
    80003c40:	f406                	sd	ra,40(sp)
    80003c42:	f022                	sd	s0,32(sp)
    80003c44:	ec26                	sd	s1,24(sp)
    80003c46:	e84a                	sd	s2,16(sp)
    80003c48:	e44e                	sd	s3,8(sp)
    80003c4a:	e052                	sd	s4,0(sp)
    80003c4c:	1800                	addi	s0,sp,48
    80003c4e:	84aa                	mv	s1,a0
    80003c50:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003c52:	0005b023          	sd	zero,0(a1)
    80003c56:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003c5a:	00000097          	auipc	ra,0x0
    80003c5e:	bf8080e7          	jalr	-1032(ra) # 80003852 <filealloc>
    80003c62:	e088                	sd	a0,0(s1)
    80003c64:	c551                	beqz	a0,80003cf0 <pipealloc+0xb2>
    80003c66:	00000097          	auipc	ra,0x0
    80003c6a:	bec080e7          	jalr	-1044(ra) # 80003852 <filealloc>
    80003c6e:	00aa3023          	sd	a0,0(s4)
    80003c72:	c92d                	beqz	a0,80003ce4 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003c74:	ffffc097          	auipc	ra,0xffffc
    80003c78:	4a4080e7          	jalr	1188(ra) # 80000118 <kalloc>
    80003c7c:	892a                	mv	s2,a0
    80003c7e:	c125                	beqz	a0,80003cde <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003c80:	4985                	li	s3,1
    80003c82:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003c86:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003c8a:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003c8e:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003c92:	00005597          	auipc	a1,0x5
    80003c96:	9f658593          	addi	a1,a1,-1546 # 80008688 <syscalls+0x2c0>
    80003c9a:	00002097          	auipc	ra,0x2
    80003c9e:	348080e7          	jalr	840(ra) # 80005fe2 <initlock>
  (*f0)->type = FD_PIPE;
    80003ca2:	609c                	ld	a5,0(s1)
    80003ca4:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003ca8:	609c                	ld	a5,0(s1)
    80003caa:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003cae:	609c                	ld	a5,0(s1)
    80003cb0:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003cb4:	609c                	ld	a5,0(s1)
    80003cb6:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003cba:	000a3783          	ld	a5,0(s4)
    80003cbe:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003cc2:	000a3783          	ld	a5,0(s4)
    80003cc6:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003cca:	000a3783          	ld	a5,0(s4)
    80003cce:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003cd2:	000a3783          	ld	a5,0(s4)
    80003cd6:	0127b823          	sd	s2,16(a5)
  return 0;
    80003cda:	4501                	li	a0,0
    80003cdc:	a025                	j	80003d04 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003cde:	6088                	ld	a0,0(s1)
    80003ce0:	e501                	bnez	a0,80003ce8 <pipealloc+0xaa>
    80003ce2:	a039                	j	80003cf0 <pipealloc+0xb2>
    80003ce4:	6088                	ld	a0,0(s1)
    80003ce6:	c51d                	beqz	a0,80003d14 <pipealloc+0xd6>
    fileclose(*f0);
    80003ce8:	00000097          	auipc	ra,0x0
    80003cec:	c26080e7          	jalr	-986(ra) # 8000390e <fileclose>
  if(*f1)
    80003cf0:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003cf4:	557d                	li	a0,-1
  if(*f1)
    80003cf6:	c799                	beqz	a5,80003d04 <pipealloc+0xc6>
    fileclose(*f1);
    80003cf8:	853e                	mv	a0,a5
    80003cfa:	00000097          	auipc	ra,0x0
    80003cfe:	c14080e7          	jalr	-1004(ra) # 8000390e <fileclose>
  return -1;
    80003d02:	557d                	li	a0,-1
}
    80003d04:	70a2                	ld	ra,40(sp)
    80003d06:	7402                	ld	s0,32(sp)
    80003d08:	64e2                	ld	s1,24(sp)
    80003d0a:	6942                	ld	s2,16(sp)
    80003d0c:	69a2                	ld	s3,8(sp)
    80003d0e:	6a02                	ld	s4,0(sp)
    80003d10:	6145                	addi	sp,sp,48
    80003d12:	8082                	ret
  return -1;
    80003d14:	557d                	li	a0,-1
    80003d16:	b7fd                	j	80003d04 <pipealloc+0xc6>

0000000080003d18 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003d18:	1101                	addi	sp,sp,-32
    80003d1a:	ec06                	sd	ra,24(sp)
    80003d1c:	e822                	sd	s0,16(sp)
    80003d1e:	e426                	sd	s1,8(sp)
    80003d20:	e04a                	sd	s2,0(sp)
    80003d22:	1000                	addi	s0,sp,32
    80003d24:	84aa                	mv	s1,a0
    80003d26:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003d28:	00002097          	auipc	ra,0x2
    80003d2c:	34a080e7          	jalr	842(ra) # 80006072 <acquire>
  if(writable){
    80003d30:	02090d63          	beqz	s2,80003d6a <pipeclose+0x52>
    pi->writeopen = 0;
    80003d34:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003d38:	21848513          	addi	a0,s1,536
    80003d3c:	ffffe097          	auipc	ra,0xffffe
    80003d40:	950080e7          	jalr	-1712(ra) # 8000168c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003d44:	2204b783          	ld	a5,544(s1)
    80003d48:	eb95                	bnez	a5,80003d7c <pipeclose+0x64>
    release(&pi->lock);
    80003d4a:	8526                	mv	a0,s1
    80003d4c:	00002097          	auipc	ra,0x2
    80003d50:	3da080e7          	jalr	986(ra) # 80006126 <release>
    kfree((char*)pi);
    80003d54:	8526                	mv	a0,s1
    80003d56:	ffffc097          	auipc	ra,0xffffc
    80003d5a:	2c6080e7          	jalr	710(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003d5e:	60e2                	ld	ra,24(sp)
    80003d60:	6442                	ld	s0,16(sp)
    80003d62:	64a2                	ld	s1,8(sp)
    80003d64:	6902                	ld	s2,0(sp)
    80003d66:	6105                	addi	sp,sp,32
    80003d68:	8082                	ret
    pi->readopen = 0;
    80003d6a:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003d6e:	21c48513          	addi	a0,s1,540
    80003d72:	ffffe097          	auipc	ra,0xffffe
    80003d76:	91a080e7          	jalr	-1766(ra) # 8000168c <wakeup>
    80003d7a:	b7e9                	j	80003d44 <pipeclose+0x2c>
    release(&pi->lock);
    80003d7c:	8526                	mv	a0,s1
    80003d7e:	00002097          	auipc	ra,0x2
    80003d82:	3a8080e7          	jalr	936(ra) # 80006126 <release>
}
    80003d86:	bfe1                	j	80003d5e <pipeclose+0x46>

0000000080003d88 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003d88:	7159                	addi	sp,sp,-112
    80003d8a:	f486                	sd	ra,104(sp)
    80003d8c:	f0a2                	sd	s0,96(sp)
    80003d8e:	eca6                	sd	s1,88(sp)
    80003d90:	e8ca                	sd	s2,80(sp)
    80003d92:	e4ce                	sd	s3,72(sp)
    80003d94:	e0d2                	sd	s4,64(sp)
    80003d96:	fc56                	sd	s5,56(sp)
    80003d98:	f85a                	sd	s6,48(sp)
    80003d9a:	f45e                	sd	s7,40(sp)
    80003d9c:	f062                	sd	s8,32(sp)
    80003d9e:	ec66                	sd	s9,24(sp)
    80003da0:	1880                	addi	s0,sp,112
    80003da2:	84aa                	mv	s1,a0
    80003da4:	8aae                	mv	s5,a1
    80003da6:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003da8:	ffffd097          	auipc	ra,0xffffd
    80003dac:	09c080e7          	jalr	156(ra) # 80000e44 <myproc>
    80003db0:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003db2:	8526                	mv	a0,s1
    80003db4:	00002097          	auipc	ra,0x2
    80003db8:	2be080e7          	jalr	702(ra) # 80006072 <acquire>
  while(i < n){
    80003dbc:	0d405163          	blez	s4,80003e7e <pipewrite+0xf6>
    80003dc0:	8ba6                	mv	s7,s1
  int i = 0;
    80003dc2:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003dc4:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003dc6:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003dca:	21c48c13          	addi	s8,s1,540
    80003dce:	a08d                	j	80003e30 <pipewrite+0xa8>
      release(&pi->lock);
    80003dd0:	8526                	mv	a0,s1
    80003dd2:	00002097          	auipc	ra,0x2
    80003dd6:	354080e7          	jalr	852(ra) # 80006126 <release>
      return -1;
    80003dda:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003ddc:	854a                	mv	a0,s2
    80003dde:	70a6                	ld	ra,104(sp)
    80003de0:	7406                	ld	s0,96(sp)
    80003de2:	64e6                	ld	s1,88(sp)
    80003de4:	6946                	ld	s2,80(sp)
    80003de6:	69a6                	ld	s3,72(sp)
    80003de8:	6a06                	ld	s4,64(sp)
    80003dea:	7ae2                	ld	s5,56(sp)
    80003dec:	7b42                	ld	s6,48(sp)
    80003dee:	7ba2                	ld	s7,40(sp)
    80003df0:	7c02                	ld	s8,32(sp)
    80003df2:	6ce2                	ld	s9,24(sp)
    80003df4:	6165                	addi	sp,sp,112
    80003df6:	8082                	ret
      wakeup(&pi->nread);
    80003df8:	8566                	mv	a0,s9
    80003dfa:	ffffe097          	auipc	ra,0xffffe
    80003dfe:	892080e7          	jalr	-1902(ra) # 8000168c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003e02:	85de                	mv	a1,s7
    80003e04:	8562                	mv	a0,s8
    80003e06:	ffffd097          	auipc	ra,0xffffd
    80003e0a:	6fa080e7          	jalr	1786(ra) # 80001500 <sleep>
    80003e0e:	a839                	j	80003e2c <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003e10:	21c4a783          	lw	a5,540(s1)
    80003e14:	0017871b          	addiw	a4,a5,1
    80003e18:	20e4ae23          	sw	a4,540(s1)
    80003e1c:	1ff7f793          	andi	a5,a5,511
    80003e20:	97a6                	add	a5,a5,s1
    80003e22:	f9f44703          	lbu	a4,-97(s0)
    80003e26:	00e78c23          	sb	a4,24(a5)
      i++;
    80003e2a:	2905                	addiw	s2,s2,1
  while(i < n){
    80003e2c:	03495d63          	bge	s2,s4,80003e66 <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    80003e30:	2204a783          	lw	a5,544(s1)
    80003e34:	dfd1                	beqz	a5,80003dd0 <pipewrite+0x48>
    80003e36:	0289a783          	lw	a5,40(s3)
    80003e3a:	fbd9                	bnez	a5,80003dd0 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003e3c:	2184a783          	lw	a5,536(s1)
    80003e40:	21c4a703          	lw	a4,540(s1)
    80003e44:	2007879b          	addiw	a5,a5,512
    80003e48:	faf708e3          	beq	a4,a5,80003df8 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003e4c:	4685                	li	a3,1
    80003e4e:	01590633          	add	a2,s2,s5
    80003e52:	f9f40593          	addi	a1,s0,-97
    80003e56:	0509b503          	ld	a0,80(s3)
    80003e5a:	ffffd097          	auipc	ra,0xffffd
    80003e5e:	d3c080e7          	jalr	-708(ra) # 80000b96 <copyin>
    80003e62:	fb6517e3          	bne	a0,s6,80003e10 <pipewrite+0x88>
  wakeup(&pi->nread);
    80003e66:	21848513          	addi	a0,s1,536
    80003e6a:	ffffe097          	auipc	ra,0xffffe
    80003e6e:	822080e7          	jalr	-2014(ra) # 8000168c <wakeup>
  release(&pi->lock);
    80003e72:	8526                	mv	a0,s1
    80003e74:	00002097          	auipc	ra,0x2
    80003e78:	2b2080e7          	jalr	690(ra) # 80006126 <release>
  return i;
    80003e7c:	b785                	j	80003ddc <pipewrite+0x54>
  int i = 0;
    80003e7e:	4901                	li	s2,0
    80003e80:	b7dd                	j	80003e66 <pipewrite+0xde>

0000000080003e82 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003e82:	715d                	addi	sp,sp,-80
    80003e84:	e486                	sd	ra,72(sp)
    80003e86:	e0a2                	sd	s0,64(sp)
    80003e88:	fc26                	sd	s1,56(sp)
    80003e8a:	f84a                	sd	s2,48(sp)
    80003e8c:	f44e                	sd	s3,40(sp)
    80003e8e:	f052                	sd	s4,32(sp)
    80003e90:	ec56                	sd	s5,24(sp)
    80003e92:	e85a                	sd	s6,16(sp)
    80003e94:	0880                	addi	s0,sp,80
    80003e96:	84aa                	mv	s1,a0
    80003e98:	892e                	mv	s2,a1
    80003e9a:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003e9c:	ffffd097          	auipc	ra,0xffffd
    80003ea0:	fa8080e7          	jalr	-88(ra) # 80000e44 <myproc>
    80003ea4:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003ea6:	8b26                	mv	s6,s1
    80003ea8:	8526                	mv	a0,s1
    80003eaa:	00002097          	auipc	ra,0x2
    80003eae:	1c8080e7          	jalr	456(ra) # 80006072 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003eb2:	2184a703          	lw	a4,536(s1)
    80003eb6:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003eba:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003ebe:	02f71463          	bne	a4,a5,80003ee6 <piperead+0x64>
    80003ec2:	2244a783          	lw	a5,548(s1)
    80003ec6:	c385                	beqz	a5,80003ee6 <piperead+0x64>
    if(pr->killed){
    80003ec8:	028a2783          	lw	a5,40(s4)
    80003ecc:	ebc1                	bnez	a5,80003f5c <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003ece:	85da                	mv	a1,s6
    80003ed0:	854e                	mv	a0,s3
    80003ed2:	ffffd097          	auipc	ra,0xffffd
    80003ed6:	62e080e7          	jalr	1582(ra) # 80001500 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003eda:	2184a703          	lw	a4,536(s1)
    80003ede:	21c4a783          	lw	a5,540(s1)
    80003ee2:	fef700e3          	beq	a4,a5,80003ec2 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003ee6:	09505263          	blez	s5,80003f6a <piperead+0xe8>
    80003eea:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003eec:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80003eee:	2184a783          	lw	a5,536(s1)
    80003ef2:	21c4a703          	lw	a4,540(s1)
    80003ef6:	02f70d63          	beq	a4,a5,80003f30 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003efa:	0017871b          	addiw	a4,a5,1
    80003efe:	20e4ac23          	sw	a4,536(s1)
    80003f02:	1ff7f793          	andi	a5,a5,511
    80003f06:	97a6                	add	a5,a5,s1
    80003f08:	0187c783          	lbu	a5,24(a5)
    80003f0c:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003f10:	4685                	li	a3,1
    80003f12:	fbf40613          	addi	a2,s0,-65
    80003f16:	85ca                	mv	a1,s2
    80003f18:	050a3503          	ld	a0,80(s4)
    80003f1c:	ffffd097          	auipc	ra,0xffffd
    80003f20:	bee080e7          	jalr	-1042(ra) # 80000b0a <copyout>
    80003f24:	01650663          	beq	a0,s6,80003f30 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f28:	2985                	addiw	s3,s3,1
    80003f2a:	0905                	addi	s2,s2,1
    80003f2c:	fd3a91e3          	bne	s5,s3,80003eee <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003f30:	21c48513          	addi	a0,s1,540
    80003f34:	ffffd097          	auipc	ra,0xffffd
    80003f38:	758080e7          	jalr	1880(ra) # 8000168c <wakeup>
  release(&pi->lock);
    80003f3c:	8526                	mv	a0,s1
    80003f3e:	00002097          	auipc	ra,0x2
    80003f42:	1e8080e7          	jalr	488(ra) # 80006126 <release>
  return i;
}
    80003f46:	854e                	mv	a0,s3
    80003f48:	60a6                	ld	ra,72(sp)
    80003f4a:	6406                	ld	s0,64(sp)
    80003f4c:	74e2                	ld	s1,56(sp)
    80003f4e:	7942                	ld	s2,48(sp)
    80003f50:	79a2                	ld	s3,40(sp)
    80003f52:	7a02                	ld	s4,32(sp)
    80003f54:	6ae2                	ld	s5,24(sp)
    80003f56:	6b42                	ld	s6,16(sp)
    80003f58:	6161                	addi	sp,sp,80
    80003f5a:	8082                	ret
      release(&pi->lock);
    80003f5c:	8526                	mv	a0,s1
    80003f5e:	00002097          	auipc	ra,0x2
    80003f62:	1c8080e7          	jalr	456(ra) # 80006126 <release>
      return -1;
    80003f66:	59fd                	li	s3,-1
    80003f68:	bff9                	j	80003f46 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f6a:	4981                	li	s3,0
    80003f6c:	b7d1                	j	80003f30 <piperead+0xae>

0000000080003f6e <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80003f6e:	df010113          	addi	sp,sp,-528
    80003f72:	20113423          	sd	ra,520(sp)
    80003f76:	20813023          	sd	s0,512(sp)
    80003f7a:	ffa6                	sd	s1,504(sp)
    80003f7c:	fbca                	sd	s2,496(sp)
    80003f7e:	f7ce                	sd	s3,488(sp)
    80003f80:	f3d2                	sd	s4,480(sp)
    80003f82:	efd6                	sd	s5,472(sp)
    80003f84:	ebda                	sd	s6,464(sp)
    80003f86:	e7de                	sd	s7,456(sp)
    80003f88:	e3e2                	sd	s8,448(sp)
    80003f8a:	ff66                	sd	s9,440(sp)
    80003f8c:	fb6a                	sd	s10,432(sp)
    80003f8e:	f76e                	sd	s11,424(sp)
    80003f90:	0c00                	addi	s0,sp,528
    80003f92:	84aa                	mv	s1,a0
    80003f94:	dea43c23          	sd	a0,-520(s0)
    80003f98:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003f9c:	ffffd097          	auipc	ra,0xffffd
    80003fa0:	ea8080e7          	jalr	-344(ra) # 80000e44 <myproc>
    80003fa4:	892a                	mv	s2,a0

  begin_op();
    80003fa6:	fffff097          	auipc	ra,0xfffff
    80003faa:	49c080e7          	jalr	1180(ra) # 80003442 <begin_op>

  if((ip = namei(path)) == 0){
    80003fae:	8526                	mv	a0,s1
    80003fb0:	fffff097          	auipc	ra,0xfffff
    80003fb4:	276080e7          	jalr	630(ra) # 80003226 <namei>
    80003fb8:	c92d                	beqz	a0,8000402a <exec+0xbc>
    80003fba:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003fbc:	fffff097          	auipc	ra,0xfffff
    80003fc0:	ab4080e7          	jalr	-1356(ra) # 80002a70 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003fc4:	04000713          	li	a4,64
    80003fc8:	4681                	li	a3,0
    80003fca:	e5040613          	addi	a2,s0,-432
    80003fce:	4581                	li	a1,0
    80003fd0:	8526                	mv	a0,s1
    80003fd2:	fffff097          	auipc	ra,0xfffff
    80003fd6:	d52080e7          	jalr	-686(ra) # 80002d24 <readi>
    80003fda:	04000793          	li	a5,64
    80003fde:	00f51a63          	bne	a0,a5,80003ff2 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80003fe2:	e5042703          	lw	a4,-432(s0)
    80003fe6:	464c47b7          	lui	a5,0x464c4
    80003fea:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003fee:	04f70463          	beq	a4,a5,80004036 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003ff2:	8526                	mv	a0,s1
    80003ff4:	fffff097          	auipc	ra,0xfffff
    80003ff8:	cde080e7          	jalr	-802(ra) # 80002cd2 <iunlockput>
    end_op();
    80003ffc:	fffff097          	auipc	ra,0xfffff
    80004000:	4c6080e7          	jalr	1222(ra) # 800034c2 <end_op>
  }
  return -1;
    80004004:	557d                	li	a0,-1
}
    80004006:	20813083          	ld	ra,520(sp)
    8000400a:	20013403          	ld	s0,512(sp)
    8000400e:	74fe                	ld	s1,504(sp)
    80004010:	795e                	ld	s2,496(sp)
    80004012:	79be                	ld	s3,488(sp)
    80004014:	7a1e                	ld	s4,480(sp)
    80004016:	6afe                	ld	s5,472(sp)
    80004018:	6b5e                	ld	s6,464(sp)
    8000401a:	6bbe                	ld	s7,456(sp)
    8000401c:	6c1e                	ld	s8,448(sp)
    8000401e:	7cfa                	ld	s9,440(sp)
    80004020:	7d5a                	ld	s10,432(sp)
    80004022:	7dba                	ld	s11,424(sp)
    80004024:	21010113          	addi	sp,sp,528
    80004028:	8082                	ret
    end_op();
    8000402a:	fffff097          	auipc	ra,0xfffff
    8000402e:	498080e7          	jalr	1176(ra) # 800034c2 <end_op>
    return -1;
    80004032:	557d                	li	a0,-1
    80004034:	bfc9                	j	80004006 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004036:	854a                	mv	a0,s2
    80004038:	ffffd097          	auipc	ra,0xffffd
    8000403c:	ed0080e7          	jalr	-304(ra) # 80000f08 <proc_pagetable>
    80004040:	8baa                	mv	s7,a0
    80004042:	d945                	beqz	a0,80003ff2 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004044:	e7042983          	lw	s3,-400(s0)
    80004048:	e8845783          	lhu	a5,-376(s0)
    8000404c:	c7ad                	beqz	a5,800040b6 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000404e:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004050:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    80004052:	6c85                	lui	s9,0x1
    80004054:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004058:	def43823          	sd	a5,-528(s0)
    8000405c:	a42d                	j	80004286 <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    8000405e:	00004517          	auipc	a0,0x4
    80004062:	63250513          	addi	a0,a0,1586 # 80008690 <syscalls+0x2c8>
    80004066:	00002097          	auipc	ra,0x2
    8000406a:	ac2080e7          	jalr	-1342(ra) # 80005b28 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000406e:	8756                	mv	a4,s5
    80004070:	012d86bb          	addw	a3,s11,s2
    80004074:	4581                	li	a1,0
    80004076:	8526                	mv	a0,s1
    80004078:	fffff097          	auipc	ra,0xfffff
    8000407c:	cac080e7          	jalr	-852(ra) # 80002d24 <readi>
    80004080:	2501                	sext.w	a0,a0
    80004082:	1aaa9963          	bne	s5,a0,80004234 <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    80004086:	6785                	lui	a5,0x1
    80004088:	0127893b          	addw	s2,a5,s2
    8000408c:	77fd                	lui	a5,0xfffff
    8000408e:	01478a3b          	addw	s4,a5,s4
    80004092:	1f897163          	bgeu	s2,s8,80004274 <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    80004096:	02091593          	slli	a1,s2,0x20
    8000409a:	9181                	srli	a1,a1,0x20
    8000409c:	95ea                	add	a1,a1,s10
    8000409e:	855e                	mv	a0,s7
    800040a0:	ffffc097          	auipc	ra,0xffffc
    800040a4:	466080e7          	jalr	1126(ra) # 80000506 <walkaddr>
    800040a8:	862a                	mv	a2,a0
    if(pa == 0)
    800040aa:	d955                	beqz	a0,8000405e <exec+0xf0>
      n = PGSIZE;
    800040ac:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    800040ae:	fd9a70e3          	bgeu	s4,s9,8000406e <exec+0x100>
      n = sz - i;
    800040b2:	8ad2                	mv	s5,s4
    800040b4:	bf6d                	j	8000406e <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800040b6:	4901                	li	s2,0
  iunlockput(ip);
    800040b8:	8526                	mv	a0,s1
    800040ba:	fffff097          	auipc	ra,0xfffff
    800040be:	c18080e7          	jalr	-1000(ra) # 80002cd2 <iunlockput>
  end_op();
    800040c2:	fffff097          	auipc	ra,0xfffff
    800040c6:	400080e7          	jalr	1024(ra) # 800034c2 <end_op>
  p = myproc();
    800040ca:	ffffd097          	auipc	ra,0xffffd
    800040ce:	d7a080e7          	jalr	-646(ra) # 80000e44 <myproc>
    800040d2:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800040d4:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800040d8:	6785                	lui	a5,0x1
    800040da:	17fd                	addi	a5,a5,-1
    800040dc:	993e                	add	s2,s2,a5
    800040de:	757d                	lui	a0,0xfffff
    800040e0:	00a977b3          	and	a5,s2,a0
    800040e4:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800040e8:	6609                	lui	a2,0x2
    800040ea:	963e                	add	a2,a2,a5
    800040ec:	85be                	mv	a1,a5
    800040ee:	855e                	mv	a0,s7
    800040f0:	ffffc097          	auipc	ra,0xffffc
    800040f4:	7ca080e7          	jalr	1994(ra) # 800008ba <uvmalloc>
    800040f8:	8b2a                	mv	s6,a0
  ip = 0;
    800040fa:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800040fc:	12050c63          	beqz	a0,80004234 <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004100:	75f9                	lui	a1,0xffffe
    80004102:	95aa                	add	a1,a1,a0
    80004104:	855e                	mv	a0,s7
    80004106:	ffffd097          	auipc	ra,0xffffd
    8000410a:	9d2080e7          	jalr	-1582(ra) # 80000ad8 <uvmclear>
  stackbase = sp - PGSIZE;
    8000410e:	7c7d                	lui	s8,0xfffff
    80004110:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004112:	e0043783          	ld	a5,-512(s0)
    80004116:	6388                	ld	a0,0(a5)
    80004118:	c535                	beqz	a0,80004184 <exec+0x216>
    8000411a:	e9040993          	addi	s3,s0,-368
    8000411e:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004122:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004124:	ffffc097          	auipc	ra,0xffffc
    80004128:	1d8080e7          	jalr	472(ra) # 800002fc <strlen>
    8000412c:	2505                	addiw	a0,a0,1
    8000412e:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004132:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004136:	13896363          	bltu	s2,s8,8000425c <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000413a:	e0043d83          	ld	s11,-512(s0)
    8000413e:	000dba03          	ld	s4,0(s11)
    80004142:	8552                	mv	a0,s4
    80004144:	ffffc097          	auipc	ra,0xffffc
    80004148:	1b8080e7          	jalr	440(ra) # 800002fc <strlen>
    8000414c:	0015069b          	addiw	a3,a0,1
    80004150:	8652                	mv	a2,s4
    80004152:	85ca                	mv	a1,s2
    80004154:	855e                	mv	a0,s7
    80004156:	ffffd097          	auipc	ra,0xffffd
    8000415a:	9b4080e7          	jalr	-1612(ra) # 80000b0a <copyout>
    8000415e:	10054363          	bltz	a0,80004264 <exec+0x2f6>
    ustack[argc] = sp;
    80004162:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004166:	0485                	addi	s1,s1,1
    80004168:	008d8793          	addi	a5,s11,8
    8000416c:	e0f43023          	sd	a5,-512(s0)
    80004170:	008db503          	ld	a0,8(s11)
    80004174:	c911                	beqz	a0,80004188 <exec+0x21a>
    if(argc >= MAXARG)
    80004176:	09a1                	addi	s3,s3,8
    80004178:	fb3c96e3          	bne	s9,s3,80004124 <exec+0x1b6>
  sz = sz1;
    8000417c:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004180:	4481                	li	s1,0
    80004182:	a84d                	j	80004234 <exec+0x2c6>
  sp = sz;
    80004184:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004186:	4481                	li	s1,0
  ustack[argc] = 0;
    80004188:	00349793          	slli	a5,s1,0x3
    8000418c:	f9040713          	addi	a4,s0,-112
    80004190:	97ba                	add	a5,a5,a4
    80004192:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    80004196:	00148693          	addi	a3,s1,1
    8000419a:	068e                	slli	a3,a3,0x3
    8000419c:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800041a0:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800041a4:	01897663          	bgeu	s2,s8,800041b0 <exec+0x242>
  sz = sz1;
    800041a8:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800041ac:	4481                	li	s1,0
    800041ae:	a059                	j	80004234 <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800041b0:	e9040613          	addi	a2,s0,-368
    800041b4:	85ca                	mv	a1,s2
    800041b6:	855e                	mv	a0,s7
    800041b8:	ffffd097          	auipc	ra,0xffffd
    800041bc:	952080e7          	jalr	-1710(ra) # 80000b0a <copyout>
    800041c0:	0a054663          	bltz	a0,8000426c <exec+0x2fe>
  p->trapframe->a1 = sp;
    800041c4:	058ab783          	ld	a5,88(s5)
    800041c8:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800041cc:	df843783          	ld	a5,-520(s0)
    800041d0:	0007c703          	lbu	a4,0(a5)
    800041d4:	cf11                	beqz	a4,800041f0 <exec+0x282>
    800041d6:	0785                	addi	a5,a5,1
    if(*s == '/')
    800041d8:	02f00693          	li	a3,47
    800041dc:	a039                	j	800041ea <exec+0x27c>
      last = s+1;
    800041de:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800041e2:	0785                	addi	a5,a5,1
    800041e4:	fff7c703          	lbu	a4,-1(a5)
    800041e8:	c701                	beqz	a4,800041f0 <exec+0x282>
    if(*s == '/')
    800041ea:	fed71ce3          	bne	a4,a3,800041e2 <exec+0x274>
    800041ee:	bfc5                	j	800041de <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    800041f0:	4641                	li	a2,16
    800041f2:	df843583          	ld	a1,-520(s0)
    800041f6:	158a8513          	addi	a0,s5,344
    800041fa:	ffffc097          	auipc	ra,0xffffc
    800041fe:	0d0080e7          	jalr	208(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    80004202:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004206:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    8000420a:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000420e:	058ab783          	ld	a5,88(s5)
    80004212:	e6843703          	ld	a4,-408(s0)
    80004216:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004218:	058ab783          	ld	a5,88(s5)
    8000421c:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004220:	85ea                	mv	a1,s10
    80004222:	ffffd097          	auipc	ra,0xffffd
    80004226:	d82080e7          	jalr	-638(ra) # 80000fa4 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000422a:	0004851b          	sext.w	a0,s1
    8000422e:	bbe1                	j	80004006 <exec+0x98>
    80004230:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004234:	e0843583          	ld	a1,-504(s0)
    80004238:	855e                	mv	a0,s7
    8000423a:	ffffd097          	auipc	ra,0xffffd
    8000423e:	d6a080e7          	jalr	-662(ra) # 80000fa4 <proc_freepagetable>
  if(ip){
    80004242:	da0498e3          	bnez	s1,80003ff2 <exec+0x84>
  return -1;
    80004246:	557d                	li	a0,-1
    80004248:	bb7d                	j	80004006 <exec+0x98>
    8000424a:	e1243423          	sd	s2,-504(s0)
    8000424e:	b7dd                	j	80004234 <exec+0x2c6>
    80004250:	e1243423          	sd	s2,-504(s0)
    80004254:	b7c5                	j	80004234 <exec+0x2c6>
    80004256:	e1243423          	sd	s2,-504(s0)
    8000425a:	bfe9                	j	80004234 <exec+0x2c6>
  sz = sz1;
    8000425c:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004260:	4481                	li	s1,0
    80004262:	bfc9                	j	80004234 <exec+0x2c6>
  sz = sz1;
    80004264:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004268:	4481                	li	s1,0
    8000426a:	b7e9                	j	80004234 <exec+0x2c6>
  sz = sz1;
    8000426c:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004270:	4481                	li	s1,0
    80004272:	b7c9                	j	80004234 <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004274:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004278:	2b05                	addiw	s6,s6,1
    8000427a:	0389899b          	addiw	s3,s3,56
    8000427e:	e8845783          	lhu	a5,-376(s0)
    80004282:	e2fb5be3          	bge	s6,a5,800040b8 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004286:	2981                	sext.w	s3,s3
    80004288:	03800713          	li	a4,56
    8000428c:	86ce                	mv	a3,s3
    8000428e:	e1840613          	addi	a2,s0,-488
    80004292:	4581                	li	a1,0
    80004294:	8526                	mv	a0,s1
    80004296:	fffff097          	auipc	ra,0xfffff
    8000429a:	a8e080e7          	jalr	-1394(ra) # 80002d24 <readi>
    8000429e:	03800793          	li	a5,56
    800042a2:	f8f517e3          	bne	a0,a5,80004230 <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    800042a6:	e1842783          	lw	a5,-488(s0)
    800042aa:	4705                	li	a4,1
    800042ac:	fce796e3          	bne	a5,a4,80004278 <exec+0x30a>
    if(ph.memsz < ph.filesz)
    800042b0:	e4043603          	ld	a2,-448(s0)
    800042b4:	e3843783          	ld	a5,-456(s0)
    800042b8:	f8f669e3          	bltu	a2,a5,8000424a <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800042bc:	e2843783          	ld	a5,-472(s0)
    800042c0:	963e                	add	a2,a2,a5
    800042c2:	f8f667e3          	bltu	a2,a5,80004250 <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800042c6:	85ca                	mv	a1,s2
    800042c8:	855e                	mv	a0,s7
    800042ca:	ffffc097          	auipc	ra,0xffffc
    800042ce:	5f0080e7          	jalr	1520(ra) # 800008ba <uvmalloc>
    800042d2:	e0a43423          	sd	a0,-504(s0)
    800042d6:	d141                	beqz	a0,80004256 <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    800042d8:	e2843d03          	ld	s10,-472(s0)
    800042dc:	df043783          	ld	a5,-528(s0)
    800042e0:	00fd77b3          	and	a5,s10,a5
    800042e4:	fba1                	bnez	a5,80004234 <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800042e6:	e2042d83          	lw	s11,-480(s0)
    800042ea:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800042ee:	f80c03e3          	beqz	s8,80004274 <exec+0x306>
    800042f2:	8a62                	mv	s4,s8
    800042f4:	4901                	li	s2,0
    800042f6:	b345                	j	80004096 <exec+0x128>

00000000800042f8 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800042f8:	7179                	addi	sp,sp,-48
    800042fa:	f406                	sd	ra,40(sp)
    800042fc:	f022                	sd	s0,32(sp)
    800042fe:	ec26                	sd	s1,24(sp)
    80004300:	e84a                	sd	s2,16(sp)
    80004302:	1800                	addi	s0,sp,48
    80004304:	892e                	mv	s2,a1
    80004306:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004308:	fdc40593          	addi	a1,s0,-36
    8000430c:	ffffe097          	auipc	ra,0xffffe
    80004310:	be4080e7          	jalr	-1052(ra) # 80001ef0 <argint>
    80004314:	04054063          	bltz	a0,80004354 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004318:	fdc42703          	lw	a4,-36(s0)
    8000431c:	47bd                	li	a5,15
    8000431e:	02e7ed63          	bltu	a5,a4,80004358 <argfd+0x60>
    80004322:	ffffd097          	auipc	ra,0xffffd
    80004326:	b22080e7          	jalr	-1246(ra) # 80000e44 <myproc>
    8000432a:	fdc42703          	lw	a4,-36(s0)
    8000432e:	01a70793          	addi	a5,a4,26
    80004332:	078e                	slli	a5,a5,0x3
    80004334:	953e                	add	a0,a0,a5
    80004336:	611c                	ld	a5,0(a0)
    80004338:	c395                	beqz	a5,8000435c <argfd+0x64>
    return -1;
  if(pfd)
    8000433a:	00090463          	beqz	s2,80004342 <argfd+0x4a>
    *pfd = fd;
    8000433e:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004342:	4501                	li	a0,0
  if(pf)
    80004344:	c091                	beqz	s1,80004348 <argfd+0x50>
    *pf = f;
    80004346:	e09c                	sd	a5,0(s1)
}
    80004348:	70a2                	ld	ra,40(sp)
    8000434a:	7402                	ld	s0,32(sp)
    8000434c:	64e2                	ld	s1,24(sp)
    8000434e:	6942                	ld	s2,16(sp)
    80004350:	6145                	addi	sp,sp,48
    80004352:	8082                	ret
    return -1;
    80004354:	557d                	li	a0,-1
    80004356:	bfcd                	j	80004348 <argfd+0x50>
    return -1;
    80004358:	557d                	li	a0,-1
    8000435a:	b7fd                	j	80004348 <argfd+0x50>
    8000435c:	557d                	li	a0,-1
    8000435e:	b7ed                	j	80004348 <argfd+0x50>

0000000080004360 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004360:	1101                	addi	sp,sp,-32
    80004362:	ec06                	sd	ra,24(sp)
    80004364:	e822                	sd	s0,16(sp)
    80004366:	e426                	sd	s1,8(sp)
    80004368:	1000                	addi	s0,sp,32
    8000436a:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000436c:	ffffd097          	auipc	ra,0xffffd
    80004370:	ad8080e7          	jalr	-1320(ra) # 80000e44 <myproc>
    80004374:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004376:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffd8e90>
    8000437a:	4501                	li	a0,0
    8000437c:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000437e:	6398                	ld	a4,0(a5)
    80004380:	cb19                	beqz	a4,80004396 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004382:	2505                	addiw	a0,a0,1
    80004384:	07a1                	addi	a5,a5,8
    80004386:	fed51ce3          	bne	a0,a3,8000437e <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000438a:	557d                	li	a0,-1
}
    8000438c:	60e2                	ld	ra,24(sp)
    8000438e:	6442                	ld	s0,16(sp)
    80004390:	64a2                	ld	s1,8(sp)
    80004392:	6105                	addi	sp,sp,32
    80004394:	8082                	ret
      p->ofile[fd] = f;
    80004396:	01a50793          	addi	a5,a0,26
    8000439a:	078e                	slli	a5,a5,0x3
    8000439c:	963e                	add	a2,a2,a5
    8000439e:	e204                	sd	s1,0(a2)
      return fd;
    800043a0:	b7f5                	j	8000438c <fdalloc+0x2c>

00000000800043a2 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800043a2:	715d                	addi	sp,sp,-80
    800043a4:	e486                	sd	ra,72(sp)
    800043a6:	e0a2                	sd	s0,64(sp)
    800043a8:	fc26                	sd	s1,56(sp)
    800043aa:	f84a                	sd	s2,48(sp)
    800043ac:	f44e                	sd	s3,40(sp)
    800043ae:	f052                	sd	s4,32(sp)
    800043b0:	ec56                	sd	s5,24(sp)
    800043b2:	0880                	addi	s0,sp,80
    800043b4:	89ae                	mv	s3,a1
    800043b6:	8ab2                	mv	s5,a2
    800043b8:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800043ba:	fb040593          	addi	a1,s0,-80
    800043be:	fffff097          	auipc	ra,0xfffff
    800043c2:	e86080e7          	jalr	-378(ra) # 80003244 <nameiparent>
    800043c6:	892a                	mv	s2,a0
    800043c8:	12050f63          	beqz	a0,80004506 <create+0x164>
    return 0;

  ilock(dp);
    800043cc:	ffffe097          	auipc	ra,0xffffe
    800043d0:	6a4080e7          	jalr	1700(ra) # 80002a70 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800043d4:	4601                	li	a2,0
    800043d6:	fb040593          	addi	a1,s0,-80
    800043da:	854a                	mv	a0,s2
    800043dc:	fffff097          	auipc	ra,0xfffff
    800043e0:	b78080e7          	jalr	-1160(ra) # 80002f54 <dirlookup>
    800043e4:	84aa                	mv	s1,a0
    800043e6:	c921                	beqz	a0,80004436 <create+0x94>
    iunlockput(dp);
    800043e8:	854a                	mv	a0,s2
    800043ea:	fffff097          	auipc	ra,0xfffff
    800043ee:	8e8080e7          	jalr	-1816(ra) # 80002cd2 <iunlockput>
    ilock(ip);
    800043f2:	8526                	mv	a0,s1
    800043f4:	ffffe097          	auipc	ra,0xffffe
    800043f8:	67c080e7          	jalr	1660(ra) # 80002a70 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800043fc:	2981                	sext.w	s3,s3
    800043fe:	4789                	li	a5,2
    80004400:	02f99463          	bne	s3,a5,80004428 <create+0x86>
    80004404:	0444d783          	lhu	a5,68(s1)
    80004408:	37f9                	addiw	a5,a5,-2
    8000440a:	17c2                	slli	a5,a5,0x30
    8000440c:	93c1                	srli	a5,a5,0x30
    8000440e:	4705                	li	a4,1
    80004410:	00f76c63          	bltu	a4,a5,80004428 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004414:	8526                	mv	a0,s1
    80004416:	60a6                	ld	ra,72(sp)
    80004418:	6406                	ld	s0,64(sp)
    8000441a:	74e2                	ld	s1,56(sp)
    8000441c:	7942                	ld	s2,48(sp)
    8000441e:	79a2                	ld	s3,40(sp)
    80004420:	7a02                	ld	s4,32(sp)
    80004422:	6ae2                	ld	s5,24(sp)
    80004424:	6161                	addi	sp,sp,80
    80004426:	8082                	ret
    iunlockput(ip);
    80004428:	8526                	mv	a0,s1
    8000442a:	fffff097          	auipc	ra,0xfffff
    8000442e:	8a8080e7          	jalr	-1880(ra) # 80002cd2 <iunlockput>
    return 0;
    80004432:	4481                	li	s1,0
    80004434:	b7c5                	j	80004414 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004436:	85ce                	mv	a1,s3
    80004438:	00092503          	lw	a0,0(s2)
    8000443c:	ffffe097          	auipc	ra,0xffffe
    80004440:	49c080e7          	jalr	1180(ra) # 800028d8 <ialloc>
    80004444:	84aa                	mv	s1,a0
    80004446:	c529                	beqz	a0,80004490 <create+0xee>
  ilock(ip);
    80004448:	ffffe097          	auipc	ra,0xffffe
    8000444c:	628080e7          	jalr	1576(ra) # 80002a70 <ilock>
  ip->major = major;
    80004450:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80004454:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80004458:	4785                	li	a5,1
    8000445a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000445e:	8526                	mv	a0,s1
    80004460:	ffffe097          	auipc	ra,0xffffe
    80004464:	546080e7          	jalr	1350(ra) # 800029a6 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004468:	2981                	sext.w	s3,s3
    8000446a:	4785                	li	a5,1
    8000446c:	02f98a63          	beq	s3,a5,800044a0 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80004470:	40d0                	lw	a2,4(s1)
    80004472:	fb040593          	addi	a1,s0,-80
    80004476:	854a                	mv	a0,s2
    80004478:	fffff097          	auipc	ra,0xfffff
    8000447c:	cec080e7          	jalr	-788(ra) # 80003164 <dirlink>
    80004480:	06054b63          	bltz	a0,800044f6 <create+0x154>
  iunlockput(dp);
    80004484:	854a                	mv	a0,s2
    80004486:	fffff097          	auipc	ra,0xfffff
    8000448a:	84c080e7          	jalr	-1972(ra) # 80002cd2 <iunlockput>
  return ip;
    8000448e:	b759                	j	80004414 <create+0x72>
    panic("create: ialloc");
    80004490:	00004517          	auipc	a0,0x4
    80004494:	22050513          	addi	a0,a0,544 # 800086b0 <syscalls+0x2e8>
    80004498:	00001097          	auipc	ra,0x1
    8000449c:	690080e7          	jalr	1680(ra) # 80005b28 <panic>
    dp->nlink++;  // for ".."
    800044a0:	04a95783          	lhu	a5,74(s2)
    800044a4:	2785                	addiw	a5,a5,1
    800044a6:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800044aa:	854a                	mv	a0,s2
    800044ac:	ffffe097          	auipc	ra,0xffffe
    800044b0:	4fa080e7          	jalr	1274(ra) # 800029a6 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800044b4:	40d0                	lw	a2,4(s1)
    800044b6:	00004597          	auipc	a1,0x4
    800044ba:	20a58593          	addi	a1,a1,522 # 800086c0 <syscalls+0x2f8>
    800044be:	8526                	mv	a0,s1
    800044c0:	fffff097          	auipc	ra,0xfffff
    800044c4:	ca4080e7          	jalr	-860(ra) # 80003164 <dirlink>
    800044c8:	00054f63          	bltz	a0,800044e6 <create+0x144>
    800044cc:	00492603          	lw	a2,4(s2)
    800044d0:	00004597          	auipc	a1,0x4
    800044d4:	1f858593          	addi	a1,a1,504 # 800086c8 <syscalls+0x300>
    800044d8:	8526                	mv	a0,s1
    800044da:	fffff097          	auipc	ra,0xfffff
    800044de:	c8a080e7          	jalr	-886(ra) # 80003164 <dirlink>
    800044e2:	f80557e3          	bgez	a0,80004470 <create+0xce>
      panic("create dots");
    800044e6:	00004517          	auipc	a0,0x4
    800044ea:	1ea50513          	addi	a0,a0,490 # 800086d0 <syscalls+0x308>
    800044ee:	00001097          	auipc	ra,0x1
    800044f2:	63a080e7          	jalr	1594(ra) # 80005b28 <panic>
    panic("create: dirlink");
    800044f6:	00004517          	auipc	a0,0x4
    800044fa:	1ea50513          	addi	a0,a0,490 # 800086e0 <syscalls+0x318>
    800044fe:	00001097          	auipc	ra,0x1
    80004502:	62a080e7          	jalr	1578(ra) # 80005b28 <panic>
    return 0;
    80004506:	84aa                	mv	s1,a0
    80004508:	b731                	j	80004414 <create+0x72>

000000008000450a <sys_dup>:
{
    8000450a:	7179                	addi	sp,sp,-48
    8000450c:	f406                	sd	ra,40(sp)
    8000450e:	f022                	sd	s0,32(sp)
    80004510:	ec26                	sd	s1,24(sp)
    80004512:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004514:	fd840613          	addi	a2,s0,-40
    80004518:	4581                	li	a1,0
    8000451a:	4501                	li	a0,0
    8000451c:	00000097          	auipc	ra,0x0
    80004520:	ddc080e7          	jalr	-548(ra) # 800042f8 <argfd>
    return -1;
    80004524:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004526:	02054363          	bltz	a0,8000454c <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    8000452a:	fd843503          	ld	a0,-40(s0)
    8000452e:	00000097          	auipc	ra,0x0
    80004532:	e32080e7          	jalr	-462(ra) # 80004360 <fdalloc>
    80004536:	84aa                	mv	s1,a0
    return -1;
    80004538:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000453a:	00054963          	bltz	a0,8000454c <sys_dup+0x42>
  filedup(f);
    8000453e:	fd843503          	ld	a0,-40(s0)
    80004542:	fffff097          	auipc	ra,0xfffff
    80004546:	37a080e7          	jalr	890(ra) # 800038bc <filedup>
  return fd;
    8000454a:	87a6                	mv	a5,s1
}
    8000454c:	853e                	mv	a0,a5
    8000454e:	70a2                	ld	ra,40(sp)
    80004550:	7402                	ld	s0,32(sp)
    80004552:	64e2                	ld	s1,24(sp)
    80004554:	6145                	addi	sp,sp,48
    80004556:	8082                	ret

0000000080004558 <sys_read>:
{
    80004558:	7179                	addi	sp,sp,-48
    8000455a:	f406                	sd	ra,40(sp)
    8000455c:	f022                	sd	s0,32(sp)
    8000455e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004560:	fe840613          	addi	a2,s0,-24
    80004564:	4581                	li	a1,0
    80004566:	4501                	li	a0,0
    80004568:	00000097          	auipc	ra,0x0
    8000456c:	d90080e7          	jalr	-624(ra) # 800042f8 <argfd>
    return -1;
    80004570:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004572:	04054163          	bltz	a0,800045b4 <sys_read+0x5c>
    80004576:	fe440593          	addi	a1,s0,-28
    8000457a:	4509                	li	a0,2
    8000457c:	ffffe097          	auipc	ra,0xffffe
    80004580:	974080e7          	jalr	-1676(ra) # 80001ef0 <argint>
    return -1;
    80004584:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004586:	02054763          	bltz	a0,800045b4 <sys_read+0x5c>
    8000458a:	fd840593          	addi	a1,s0,-40
    8000458e:	4505                	li	a0,1
    80004590:	ffffe097          	auipc	ra,0xffffe
    80004594:	982080e7          	jalr	-1662(ra) # 80001f12 <argaddr>
    return -1;
    80004598:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000459a:	00054d63          	bltz	a0,800045b4 <sys_read+0x5c>
  return fileread(f, p, n);
    8000459e:	fe442603          	lw	a2,-28(s0)
    800045a2:	fd843583          	ld	a1,-40(s0)
    800045a6:	fe843503          	ld	a0,-24(s0)
    800045aa:	fffff097          	auipc	ra,0xfffff
    800045ae:	49e080e7          	jalr	1182(ra) # 80003a48 <fileread>
    800045b2:	87aa                	mv	a5,a0
}
    800045b4:	853e                	mv	a0,a5
    800045b6:	70a2                	ld	ra,40(sp)
    800045b8:	7402                	ld	s0,32(sp)
    800045ba:	6145                	addi	sp,sp,48
    800045bc:	8082                	ret

00000000800045be <sys_write>:
{
    800045be:	7179                	addi	sp,sp,-48
    800045c0:	f406                	sd	ra,40(sp)
    800045c2:	f022                	sd	s0,32(sp)
    800045c4:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800045c6:	fe840613          	addi	a2,s0,-24
    800045ca:	4581                	li	a1,0
    800045cc:	4501                	li	a0,0
    800045ce:	00000097          	auipc	ra,0x0
    800045d2:	d2a080e7          	jalr	-726(ra) # 800042f8 <argfd>
    return -1;
    800045d6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800045d8:	04054163          	bltz	a0,8000461a <sys_write+0x5c>
    800045dc:	fe440593          	addi	a1,s0,-28
    800045e0:	4509                	li	a0,2
    800045e2:	ffffe097          	auipc	ra,0xffffe
    800045e6:	90e080e7          	jalr	-1778(ra) # 80001ef0 <argint>
    return -1;
    800045ea:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800045ec:	02054763          	bltz	a0,8000461a <sys_write+0x5c>
    800045f0:	fd840593          	addi	a1,s0,-40
    800045f4:	4505                	li	a0,1
    800045f6:	ffffe097          	auipc	ra,0xffffe
    800045fa:	91c080e7          	jalr	-1764(ra) # 80001f12 <argaddr>
    return -1;
    800045fe:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004600:	00054d63          	bltz	a0,8000461a <sys_write+0x5c>
  return filewrite(f, p, n);
    80004604:	fe442603          	lw	a2,-28(s0)
    80004608:	fd843583          	ld	a1,-40(s0)
    8000460c:	fe843503          	ld	a0,-24(s0)
    80004610:	fffff097          	auipc	ra,0xfffff
    80004614:	4fa080e7          	jalr	1274(ra) # 80003b0a <filewrite>
    80004618:	87aa                	mv	a5,a0
}
    8000461a:	853e                	mv	a0,a5
    8000461c:	70a2                	ld	ra,40(sp)
    8000461e:	7402                	ld	s0,32(sp)
    80004620:	6145                	addi	sp,sp,48
    80004622:	8082                	ret

0000000080004624 <sys_close>:
{
    80004624:	1101                	addi	sp,sp,-32
    80004626:	ec06                	sd	ra,24(sp)
    80004628:	e822                	sd	s0,16(sp)
    8000462a:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000462c:	fe040613          	addi	a2,s0,-32
    80004630:	fec40593          	addi	a1,s0,-20
    80004634:	4501                	li	a0,0
    80004636:	00000097          	auipc	ra,0x0
    8000463a:	cc2080e7          	jalr	-830(ra) # 800042f8 <argfd>
    return -1;
    8000463e:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004640:	02054463          	bltz	a0,80004668 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004644:	ffffd097          	auipc	ra,0xffffd
    80004648:	800080e7          	jalr	-2048(ra) # 80000e44 <myproc>
    8000464c:	fec42783          	lw	a5,-20(s0)
    80004650:	07e9                	addi	a5,a5,26
    80004652:	078e                	slli	a5,a5,0x3
    80004654:	97aa                	add	a5,a5,a0
    80004656:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    8000465a:	fe043503          	ld	a0,-32(s0)
    8000465e:	fffff097          	auipc	ra,0xfffff
    80004662:	2b0080e7          	jalr	688(ra) # 8000390e <fileclose>
  return 0;
    80004666:	4781                	li	a5,0
}
    80004668:	853e                	mv	a0,a5
    8000466a:	60e2                	ld	ra,24(sp)
    8000466c:	6442                	ld	s0,16(sp)
    8000466e:	6105                	addi	sp,sp,32
    80004670:	8082                	ret

0000000080004672 <sys_fstat>:
{
    80004672:	1101                	addi	sp,sp,-32
    80004674:	ec06                	sd	ra,24(sp)
    80004676:	e822                	sd	s0,16(sp)
    80004678:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000467a:	fe840613          	addi	a2,s0,-24
    8000467e:	4581                	li	a1,0
    80004680:	4501                	li	a0,0
    80004682:	00000097          	auipc	ra,0x0
    80004686:	c76080e7          	jalr	-906(ra) # 800042f8 <argfd>
    return -1;
    8000468a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000468c:	02054563          	bltz	a0,800046b6 <sys_fstat+0x44>
    80004690:	fe040593          	addi	a1,s0,-32
    80004694:	4505                	li	a0,1
    80004696:	ffffe097          	auipc	ra,0xffffe
    8000469a:	87c080e7          	jalr	-1924(ra) # 80001f12 <argaddr>
    return -1;
    8000469e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800046a0:	00054b63          	bltz	a0,800046b6 <sys_fstat+0x44>
  return filestat(f, st);
    800046a4:	fe043583          	ld	a1,-32(s0)
    800046a8:	fe843503          	ld	a0,-24(s0)
    800046ac:	fffff097          	auipc	ra,0xfffff
    800046b0:	32a080e7          	jalr	810(ra) # 800039d6 <filestat>
    800046b4:	87aa                	mv	a5,a0
}
    800046b6:	853e                	mv	a0,a5
    800046b8:	60e2                	ld	ra,24(sp)
    800046ba:	6442                	ld	s0,16(sp)
    800046bc:	6105                	addi	sp,sp,32
    800046be:	8082                	ret

00000000800046c0 <sys_link>:
{
    800046c0:	7169                	addi	sp,sp,-304
    800046c2:	f606                	sd	ra,296(sp)
    800046c4:	f222                	sd	s0,288(sp)
    800046c6:	ee26                	sd	s1,280(sp)
    800046c8:	ea4a                	sd	s2,272(sp)
    800046ca:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800046cc:	08000613          	li	a2,128
    800046d0:	ed040593          	addi	a1,s0,-304
    800046d4:	4501                	li	a0,0
    800046d6:	ffffe097          	auipc	ra,0xffffe
    800046da:	85e080e7          	jalr	-1954(ra) # 80001f34 <argstr>
    return -1;
    800046de:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800046e0:	10054e63          	bltz	a0,800047fc <sys_link+0x13c>
    800046e4:	08000613          	li	a2,128
    800046e8:	f5040593          	addi	a1,s0,-176
    800046ec:	4505                	li	a0,1
    800046ee:	ffffe097          	auipc	ra,0xffffe
    800046f2:	846080e7          	jalr	-1978(ra) # 80001f34 <argstr>
    return -1;
    800046f6:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800046f8:	10054263          	bltz	a0,800047fc <sys_link+0x13c>
  begin_op();
    800046fc:	fffff097          	auipc	ra,0xfffff
    80004700:	d46080e7          	jalr	-698(ra) # 80003442 <begin_op>
  if((ip = namei(old)) == 0){
    80004704:	ed040513          	addi	a0,s0,-304
    80004708:	fffff097          	auipc	ra,0xfffff
    8000470c:	b1e080e7          	jalr	-1250(ra) # 80003226 <namei>
    80004710:	84aa                	mv	s1,a0
    80004712:	c551                	beqz	a0,8000479e <sys_link+0xde>
  ilock(ip);
    80004714:	ffffe097          	auipc	ra,0xffffe
    80004718:	35c080e7          	jalr	860(ra) # 80002a70 <ilock>
  if(ip->type == T_DIR){
    8000471c:	04449703          	lh	a4,68(s1)
    80004720:	4785                	li	a5,1
    80004722:	08f70463          	beq	a4,a5,800047aa <sys_link+0xea>
  ip->nlink++;
    80004726:	04a4d783          	lhu	a5,74(s1)
    8000472a:	2785                	addiw	a5,a5,1
    8000472c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004730:	8526                	mv	a0,s1
    80004732:	ffffe097          	auipc	ra,0xffffe
    80004736:	274080e7          	jalr	628(ra) # 800029a6 <iupdate>
  iunlock(ip);
    8000473a:	8526                	mv	a0,s1
    8000473c:	ffffe097          	auipc	ra,0xffffe
    80004740:	3f6080e7          	jalr	1014(ra) # 80002b32 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004744:	fd040593          	addi	a1,s0,-48
    80004748:	f5040513          	addi	a0,s0,-176
    8000474c:	fffff097          	auipc	ra,0xfffff
    80004750:	af8080e7          	jalr	-1288(ra) # 80003244 <nameiparent>
    80004754:	892a                	mv	s2,a0
    80004756:	c935                	beqz	a0,800047ca <sys_link+0x10a>
  ilock(dp);
    80004758:	ffffe097          	auipc	ra,0xffffe
    8000475c:	318080e7          	jalr	792(ra) # 80002a70 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004760:	00092703          	lw	a4,0(s2)
    80004764:	409c                	lw	a5,0(s1)
    80004766:	04f71d63          	bne	a4,a5,800047c0 <sys_link+0x100>
    8000476a:	40d0                	lw	a2,4(s1)
    8000476c:	fd040593          	addi	a1,s0,-48
    80004770:	854a                	mv	a0,s2
    80004772:	fffff097          	auipc	ra,0xfffff
    80004776:	9f2080e7          	jalr	-1550(ra) # 80003164 <dirlink>
    8000477a:	04054363          	bltz	a0,800047c0 <sys_link+0x100>
  iunlockput(dp);
    8000477e:	854a                	mv	a0,s2
    80004780:	ffffe097          	auipc	ra,0xffffe
    80004784:	552080e7          	jalr	1362(ra) # 80002cd2 <iunlockput>
  iput(ip);
    80004788:	8526                	mv	a0,s1
    8000478a:	ffffe097          	auipc	ra,0xffffe
    8000478e:	4a0080e7          	jalr	1184(ra) # 80002c2a <iput>
  end_op();
    80004792:	fffff097          	auipc	ra,0xfffff
    80004796:	d30080e7          	jalr	-720(ra) # 800034c2 <end_op>
  return 0;
    8000479a:	4781                	li	a5,0
    8000479c:	a085                	j	800047fc <sys_link+0x13c>
    end_op();
    8000479e:	fffff097          	auipc	ra,0xfffff
    800047a2:	d24080e7          	jalr	-732(ra) # 800034c2 <end_op>
    return -1;
    800047a6:	57fd                	li	a5,-1
    800047a8:	a891                	j	800047fc <sys_link+0x13c>
    iunlockput(ip);
    800047aa:	8526                	mv	a0,s1
    800047ac:	ffffe097          	auipc	ra,0xffffe
    800047b0:	526080e7          	jalr	1318(ra) # 80002cd2 <iunlockput>
    end_op();
    800047b4:	fffff097          	auipc	ra,0xfffff
    800047b8:	d0e080e7          	jalr	-754(ra) # 800034c2 <end_op>
    return -1;
    800047bc:	57fd                	li	a5,-1
    800047be:	a83d                	j	800047fc <sys_link+0x13c>
    iunlockput(dp);
    800047c0:	854a                	mv	a0,s2
    800047c2:	ffffe097          	auipc	ra,0xffffe
    800047c6:	510080e7          	jalr	1296(ra) # 80002cd2 <iunlockput>
  ilock(ip);
    800047ca:	8526                	mv	a0,s1
    800047cc:	ffffe097          	auipc	ra,0xffffe
    800047d0:	2a4080e7          	jalr	676(ra) # 80002a70 <ilock>
  ip->nlink--;
    800047d4:	04a4d783          	lhu	a5,74(s1)
    800047d8:	37fd                	addiw	a5,a5,-1
    800047da:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800047de:	8526                	mv	a0,s1
    800047e0:	ffffe097          	auipc	ra,0xffffe
    800047e4:	1c6080e7          	jalr	454(ra) # 800029a6 <iupdate>
  iunlockput(ip);
    800047e8:	8526                	mv	a0,s1
    800047ea:	ffffe097          	auipc	ra,0xffffe
    800047ee:	4e8080e7          	jalr	1256(ra) # 80002cd2 <iunlockput>
  end_op();
    800047f2:	fffff097          	auipc	ra,0xfffff
    800047f6:	cd0080e7          	jalr	-816(ra) # 800034c2 <end_op>
  return -1;
    800047fa:	57fd                	li	a5,-1
}
    800047fc:	853e                	mv	a0,a5
    800047fe:	70b2                	ld	ra,296(sp)
    80004800:	7412                	ld	s0,288(sp)
    80004802:	64f2                	ld	s1,280(sp)
    80004804:	6952                	ld	s2,272(sp)
    80004806:	6155                	addi	sp,sp,304
    80004808:	8082                	ret

000000008000480a <sys_unlink>:
{
    8000480a:	7151                	addi	sp,sp,-240
    8000480c:	f586                	sd	ra,232(sp)
    8000480e:	f1a2                	sd	s0,224(sp)
    80004810:	eda6                	sd	s1,216(sp)
    80004812:	e9ca                	sd	s2,208(sp)
    80004814:	e5ce                	sd	s3,200(sp)
    80004816:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004818:	08000613          	li	a2,128
    8000481c:	f3040593          	addi	a1,s0,-208
    80004820:	4501                	li	a0,0
    80004822:	ffffd097          	auipc	ra,0xffffd
    80004826:	712080e7          	jalr	1810(ra) # 80001f34 <argstr>
    8000482a:	18054163          	bltz	a0,800049ac <sys_unlink+0x1a2>
  begin_op();
    8000482e:	fffff097          	auipc	ra,0xfffff
    80004832:	c14080e7          	jalr	-1004(ra) # 80003442 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004836:	fb040593          	addi	a1,s0,-80
    8000483a:	f3040513          	addi	a0,s0,-208
    8000483e:	fffff097          	auipc	ra,0xfffff
    80004842:	a06080e7          	jalr	-1530(ra) # 80003244 <nameiparent>
    80004846:	84aa                	mv	s1,a0
    80004848:	c979                	beqz	a0,8000491e <sys_unlink+0x114>
  ilock(dp);
    8000484a:	ffffe097          	auipc	ra,0xffffe
    8000484e:	226080e7          	jalr	550(ra) # 80002a70 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004852:	00004597          	auipc	a1,0x4
    80004856:	e6e58593          	addi	a1,a1,-402 # 800086c0 <syscalls+0x2f8>
    8000485a:	fb040513          	addi	a0,s0,-80
    8000485e:	ffffe097          	auipc	ra,0xffffe
    80004862:	6dc080e7          	jalr	1756(ra) # 80002f3a <namecmp>
    80004866:	14050a63          	beqz	a0,800049ba <sys_unlink+0x1b0>
    8000486a:	00004597          	auipc	a1,0x4
    8000486e:	e5e58593          	addi	a1,a1,-418 # 800086c8 <syscalls+0x300>
    80004872:	fb040513          	addi	a0,s0,-80
    80004876:	ffffe097          	auipc	ra,0xffffe
    8000487a:	6c4080e7          	jalr	1732(ra) # 80002f3a <namecmp>
    8000487e:	12050e63          	beqz	a0,800049ba <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004882:	f2c40613          	addi	a2,s0,-212
    80004886:	fb040593          	addi	a1,s0,-80
    8000488a:	8526                	mv	a0,s1
    8000488c:	ffffe097          	auipc	ra,0xffffe
    80004890:	6c8080e7          	jalr	1736(ra) # 80002f54 <dirlookup>
    80004894:	892a                	mv	s2,a0
    80004896:	12050263          	beqz	a0,800049ba <sys_unlink+0x1b0>
  ilock(ip);
    8000489a:	ffffe097          	auipc	ra,0xffffe
    8000489e:	1d6080e7          	jalr	470(ra) # 80002a70 <ilock>
  if(ip->nlink < 1)
    800048a2:	04a91783          	lh	a5,74(s2)
    800048a6:	08f05263          	blez	a5,8000492a <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800048aa:	04491703          	lh	a4,68(s2)
    800048ae:	4785                	li	a5,1
    800048b0:	08f70563          	beq	a4,a5,8000493a <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800048b4:	4641                	li	a2,16
    800048b6:	4581                	li	a1,0
    800048b8:	fc040513          	addi	a0,s0,-64
    800048bc:	ffffc097          	auipc	ra,0xffffc
    800048c0:	8bc080e7          	jalr	-1860(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800048c4:	4741                	li	a4,16
    800048c6:	f2c42683          	lw	a3,-212(s0)
    800048ca:	fc040613          	addi	a2,s0,-64
    800048ce:	4581                	li	a1,0
    800048d0:	8526                	mv	a0,s1
    800048d2:	ffffe097          	auipc	ra,0xffffe
    800048d6:	54a080e7          	jalr	1354(ra) # 80002e1c <writei>
    800048da:	47c1                	li	a5,16
    800048dc:	0af51563          	bne	a0,a5,80004986 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    800048e0:	04491703          	lh	a4,68(s2)
    800048e4:	4785                	li	a5,1
    800048e6:	0af70863          	beq	a4,a5,80004996 <sys_unlink+0x18c>
  iunlockput(dp);
    800048ea:	8526                	mv	a0,s1
    800048ec:	ffffe097          	auipc	ra,0xffffe
    800048f0:	3e6080e7          	jalr	998(ra) # 80002cd2 <iunlockput>
  ip->nlink--;
    800048f4:	04a95783          	lhu	a5,74(s2)
    800048f8:	37fd                	addiw	a5,a5,-1
    800048fa:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800048fe:	854a                	mv	a0,s2
    80004900:	ffffe097          	auipc	ra,0xffffe
    80004904:	0a6080e7          	jalr	166(ra) # 800029a6 <iupdate>
  iunlockput(ip);
    80004908:	854a                	mv	a0,s2
    8000490a:	ffffe097          	auipc	ra,0xffffe
    8000490e:	3c8080e7          	jalr	968(ra) # 80002cd2 <iunlockput>
  end_op();
    80004912:	fffff097          	auipc	ra,0xfffff
    80004916:	bb0080e7          	jalr	-1104(ra) # 800034c2 <end_op>
  return 0;
    8000491a:	4501                	li	a0,0
    8000491c:	a84d                	j	800049ce <sys_unlink+0x1c4>
    end_op();
    8000491e:	fffff097          	auipc	ra,0xfffff
    80004922:	ba4080e7          	jalr	-1116(ra) # 800034c2 <end_op>
    return -1;
    80004926:	557d                	li	a0,-1
    80004928:	a05d                	j	800049ce <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    8000492a:	00004517          	auipc	a0,0x4
    8000492e:	dc650513          	addi	a0,a0,-570 # 800086f0 <syscalls+0x328>
    80004932:	00001097          	auipc	ra,0x1
    80004936:	1f6080e7          	jalr	502(ra) # 80005b28 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000493a:	04c92703          	lw	a4,76(s2)
    8000493e:	02000793          	li	a5,32
    80004942:	f6e7f9e3          	bgeu	a5,a4,800048b4 <sys_unlink+0xaa>
    80004946:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000494a:	4741                	li	a4,16
    8000494c:	86ce                	mv	a3,s3
    8000494e:	f1840613          	addi	a2,s0,-232
    80004952:	4581                	li	a1,0
    80004954:	854a                	mv	a0,s2
    80004956:	ffffe097          	auipc	ra,0xffffe
    8000495a:	3ce080e7          	jalr	974(ra) # 80002d24 <readi>
    8000495e:	47c1                	li	a5,16
    80004960:	00f51b63          	bne	a0,a5,80004976 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004964:	f1845783          	lhu	a5,-232(s0)
    80004968:	e7a1                	bnez	a5,800049b0 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000496a:	29c1                	addiw	s3,s3,16
    8000496c:	04c92783          	lw	a5,76(s2)
    80004970:	fcf9ede3          	bltu	s3,a5,8000494a <sys_unlink+0x140>
    80004974:	b781                	j	800048b4 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004976:	00004517          	auipc	a0,0x4
    8000497a:	d9250513          	addi	a0,a0,-622 # 80008708 <syscalls+0x340>
    8000497e:	00001097          	auipc	ra,0x1
    80004982:	1aa080e7          	jalr	426(ra) # 80005b28 <panic>
    panic("unlink: writei");
    80004986:	00004517          	auipc	a0,0x4
    8000498a:	d9a50513          	addi	a0,a0,-614 # 80008720 <syscalls+0x358>
    8000498e:	00001097          	auipc	ra,0x1
    80004992:	19a080e7          	jalr	410(ra) # 80005b28 <panic>
    dp->nlink--;
    80004996:	04a4d783          	lhu	a5,74(s1)
    8000499a:	37fd                	addiw	a5,a5,-1
    8000499c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800049a0:	8526                	mv	a0,s1
    800049a2:	ffffe097          	auipc	ra,0xffffe
    800049a6:	004080e7          	jalr	4(ra) # 800029a6 <iupdate>
    800049aa:	b781                	j	800048ea <sys_unlink+0xe0>
    return -1;
    800049ac:	557d                	li	a0,-1
    800049ae:	a005                	j	800049ce <sys_unlink+0x1c4>
    iunlockput(ip);
    800049b0:	854a                	mv	a0,s2
    800049b2:	ffffe097          	auipc	ra,0xffffe
    800049b6:	320080e7          	jalr	800(ra) # 80002cd2 <iunlockput>
  iunlockput(dp);
    800049ba:	8526                	mv	a0,s1
    800049bc:	ffffe097          	auipc	ra,0xffffe
    800049c0:	316080e7          	jalr	790(ra) # 80002cd2 <iunlockput>
  end_op();
    800049c4:	fffff097          	auipc	ra,0xfffff
    800049c8:	afe080e7          	jalr	-1282(ra) # 800034c2 <end_op>
  return -1;
    800049cc:	557d                	li	a0,-1
}
    800049ce:	70ae                	ld	ra,232(sp)
    800049d0:	740e                	ld	s0,224(sp)
    800049d2:	64ee                	ld	s1,216(sp)
    800049d4:	694e                	ld	s2,208(sp)
    800049d6:	69ae                	ld	s3,200(sp)
    800049d8:	616d                	addi	sp,sp,240
    800049da:	8082                	ret

00000000800049dc <sys_open>:

uint64
sys_open(void)
{
    800049dc:	7131                	addi	sp,sp,-192
    800049de:	fd06                	sd	ra,184(sp)
    800049e0:	f922                	sd	s0,176(sp)
    800049e2:	f526                	sd	s1,168(sp)
    800049e4:	f14a                	sd	s2,160(sp)
    800049e6:	ed4e                	sd	s3,152(sp)
    800049e8:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    800049ea:	08000613          	li	a2,128
    800049ee:	f5040593          	addi	a1,s0,-176
    800049f2:	4501                	li	a0,0
    800049f4:	ffffd097          	auipc	ra,0xffffd
    800049f8:	540080e7          	jalr	1344(ra) # 80001f34 <argstr>
    return -1;
    800049fc:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    800049fe:	0c054163          	bltz	a0,80004ac0 <sys_open+0xe4>
    80004a02:	f4c40593          	addi	a1,s0,-180
    80004a06:	4505                	li	a0,1
    80004a08:	ffffd097          	auipc	ra,0xffffd
    80004a0c:	4e8080e7          	jalr	1256(ra) # 80001ef0 <argint>
    80004a10:	0a054863          	bltz	a0,80004ac0 <sys_open+0xe4>

  begin_op();
    80004a14:	fffff097          	auipc	ra,0xfffff
    80004a18:	a2e080e7          	jalr	-1490(ra) # 80003442 <begin_op>

  if(omode & O_CREATE){
    80004a1c:	f4c42783          	lw	a5,-180(s0)
    80004a20:	2007f793          	andi	a5,a5,512
    80004a24:	cbdd                	beqz	a5,80004ada <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004a26:	4681                	li	a3,0
    80004a28:	4601                	li	a2,0
    80004a2a:	4589                	li	a1,2
    80004a2c:	f5040513          	addi	a0,s0,-176
    80004a30:	00000097          	auipc	ra,0x0
    80004a34:	972080e7          	jalr	-1678(ra) # 800043a2 <create>
    80004a38:	892a                	mv	s2,a0
    if(ip == 0){
    80004a3a:	c959                	beqz	a0,80004ad0 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004a3c:	04491703          	lh	a4,68(s2)
    80004a40:	478d                	li	a5,3
    80004a42:	00f71763          	bne	a4,a5,80004a50 <sys_open+0x74>
    80004a46:	04695703          	lhu	a4,70(s2)
    80004a4a:	47a5                	li	a5,9
    80004a4c:	0ce7ec63          	bltu	a5,a4,80004b24 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004a50:	fffff097          	auipc	ra,0xfffff
    80004a54:	e02080e7          	jalr	-510(ra) # 80003852 <filealloc>
    80004a58:	89aa                	mv	s3,a0
    80004a5a:	10050263          	beqz	a0,80004b5e <sys_open+0x182>
    80004a5e:	00000097          	auipc	ra,0x0
    80004a62:	902080e7          	jalr	-1790(ra) # 80004360 <fdalloc>
    80004a66:	84aa                	mv	s1,a0
    80004a68:	0e054663          	bltz	a0,80004b54 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004a6c:	04491703          	lh	a4,68(s2)
    80004a70:	478d                	li	a5,3
    80004a72:	0cf70463          	beq	a4,a5,80004b3a <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004a76:	4789                	li	a5,2
    80004a78:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004a7c:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004a80:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004a84:	f4c42783          	lw	a5,-180(s0)
    80004a88:	0017c713          	xori	a4,a5,1
    80004a8c:	8b05                	andi	a4,a4,1
    80004a8e:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004a92:	0037f713          	andi	a4,a5,3
    80004a96:	00e03733          	snez	a4,a4
    80004a9a:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004a9e:	4007f793          	andi	a5,a5,1024
    80004aa2:	c791                	beqz	a5,80004aae <sys_open+0xd2>
    80004aa4:	04491703          	lh	a4,68(s2)
    80004aa8:	4789                	li	a5,2
    80004aaa:	08f70f63          	beq	a4,a5,80004b48 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004aae:	854a                	mv	a0,s2
    80004ab0:	ffffe097          	auipc	ra,0xffffe
    80004ab4:	082080e7          	jalr	130(ra) # 80002b32 <iunlock>
  end_op();
    80004ab8:	fffff097          	auipc	ra,0xfffff
    80004abc:	a0a080e7          	jalr	-1526(ra) # 800034c2 <end_op>

  return fd;
}
    80004ac0:	8526                	mv	a0,s1
    80004ac2:	70ea                	ld	ra,184(sp)
    80004ac4:	744a                	ld	s0,176(sp)
    80004ac6:	74aa                	ld	s1,168(sp)
    80004ac8:	790a                	ld	s2,160(sp)
    80004aca:	69ea                	ld	s3,152(sp)
    80004acc:	6129                	addi	sp,sp,192
    80004ace:	8082                	ret
      end_op();
    80004ad0:	fffff097          	auipc	ra,0xfffff
    80004ad4:	9f2080e7          	jalr	-1550(ra) # 800034c2 <end_op>
      return -1;
    80004ad8:	b7e5                	j	80004ac0 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004ada:	f5040513          	addi	a0,s0,-176
    80004ade:	ffffe097          	auipc	ra,0xffffe
    80004ae2:	748080e7          	jalr	1864(ra) # 80003226 <namei>
    80004ae6:	892a                	mv	s2,a0
    80004ae8:	c905                	beqz	a0,80004b18 <sys_open+0x13c>
    ilock(ip);
    80004aea:	ffffe097          	auipc	ra,0xffffe
    80004aee:	f86080e7          	jalr	-122(ra) # 80002a70 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004af2:	04491703          	lh	a4,68(s2)
    80004af6:	4785                	li	a5,1
    80004af8:	f4f712e3          	bne	a4,a5,80004a3c <sys_open+0x60>
    80004afc:	f4c42783          	lw	a5,-180(s0)
    80004b00:	dba1                	beqz	a5,80004a50 <sys_open+0x74>
      iunlockput(ip);
    80004b02:	854a                	mv	a0,s2
    80004b04:	ffffe097          	auipc	ra,0xffffe
    80004b08:	1ce080e7          	jalr	462(ra) # 80002cd2 <iunlockput>
      end_op();
    80004b0c:	fffff097          	auipc	ra,0xfffff
    80004b10:	9b6080e7          	jalr	-1610(ra) # 800034c2 <end_op>
      return -1;
    80004b14:	54fd                	li	s1,-1
    80004b16:	b76d                	j	80004ac0 <sys_open+0xe4>
      end_op();
    80004b18:	fffff097          	auipc	ra,0xfffff
    80004b1c:	9aa080e7          	jalr	-1622(ra) # 800034c2 <end_op>
      return -1;
    80004b20:	54fd                	li	s1,-1
    80004b22:	bf79                	j	80004ac0 <sys_open+0xe4>
    iunlockput(ip);
    80004b24:	854a                	mv	a0,s2
    80004b26:	ffffe097          	auipc	ra,0xffffe
    80004b2a:	1ac080e7          	jalr	428(ra) # 80002cd2 <iunlockput>
    end_op();
    80004b2e:	fffff097          	auipc	ra,0xfffff
    80004b32:	994080e7          	jalr	-1644(ra) # 800034c2 <end_op>
    return -1;
    80004b36:	54fd                	li	s1,-1
    80004b38:	b761                	j	80004ac0 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004b3a:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004b3e:	04691783          	lh	a5,70(s2)
    80004b42:	02f99223          	sh	a5,36(s3)
    80004b46:	bf2d                	j	80004a80 <sys_open+0xa4>
    itrunc(ip);
    80004b48:	854a                	mv	a0,s2
    80004b4a:	ffffe097          	auipc	ra,0xffffe
    80004b4e:	034080e7          	jalr	52(ra) # 80002b7e <itrunc>
    80004b52:	bfb1                	j	80004aae <sys_open+0xd2>
      fileclose(f);
    80004b54:	854e                	mv	a0,s3
    80004b56:	fffff097          	auipc	ra,0xfffff
    80004b5a:	db8080e7          	jalr	-584(ra) # 8000390e <fileclose>
    iunlockput(ip);
    80004b5e:	854a                	mv	a0,s2
    80004b60:	ffffe097          	auipc	ra,0xffffe
    80004b64:	172080e7          	jalr	370(ra) # 80002cd2 <iunlockput>
    end_op();
    80004b68:	fffff097          	auipc	ra,0xfffff
    80004b6c:	95a080e7          	jalr	-1702(ra) # 800034c2 <end_op>
    return -1;
    80004b70:	54fd                	li	s1,-1
    80004b72:	b7b9                	j	80004ac0 <sys_open+0xe4>

0000000080004b74 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004b74:	7175                	addi	sp,sp,-144
    80004b76:	e506                	sd	ra,136(sp)
    80004b78:	e122                	sd	s0,128(sp)
    80004b7a:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004b7c:	fffff097          	auipc	ra,0xfffff
    80004b80:	8c6080e7          	jalr	-1850(ra) # 80003442 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004b84:	08000613          	li	a2,128
    80004b88:	f7040593          	addi	a1,s0,-144
    80004b8c:	4501                	li	a0,0
    80004b8e:	ffffd097          	auipc	ra,0xffffd
    80004b92:	3a6080e7          	jalr	934(ra) # 80001f34 <argstr>
    80004b96:	02054963          	bltz	a0,80004bc8 <sys_mkdir+0x54>
    80004b9a:	4681                	li	a3,0
    80004b9c:	4601                	li	a2,0
    80004b9e:	4585                	li	a1,1
    80004ba0:	f7040513          	addi	a0,s0,-144
    80004ba4:	fffff097          	auipc	ra,0xfffff
    80004ba8:	7fe080e7          	jalr	2046(ra) # 800043a2 <create>
    80004bac:	cd11                	beqz	a0,80004bc8 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004bae:	ffffe097          	auipc	ra,0xffffe
    80004bb2:	124080e7          	jalr	292(ra) # 80002cd2 <iunlockput>
  end_op();
    80004bb6:	fffff097          	auipc	ra,0xfffff
    80004bba:	90c080e7          	jalr	-1780(ra) # 800034c2 <end_op>
  return 0;
    80004bbe:	4501                	li	a0,0
}
    80004bc0:	60aa                	ld	ra,136(sp)
    80004bc2:	640a                	ld	s0,128(sp)
    80004bc4:	6149                	addi	sp,sp,144
    80004bc6:	8082                	ret
    end_op();
    80004bc8:	fffff097          	auipc	ra,0xfffff
    80004bcc:	8fa080e7          	jalr	-1798(ra) # 800034c2 <end_op>
    return -1;
    80004bd0:	557d                	li	a0,-1
    80004bd2:	b7fd                	j	80004bc0 <sys_mkdir+0x4c>

0000000080004bd4 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004bd4:	7135                	addi	sp,sp,-160
    80004bd6:	ed06                	sd	ra,152(sp)
    80004bd8:	e922                	sd	s0,144(sp)
    80004bda:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004bdc:	fffff097          	auipc	ra,0xfffff
    80004be0:	866080e7          	jalr	-1946(ra) # 80003442 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004be4:	08000613          	li	a2,128
    80004be8:	f7040593          	addi	a1,s0,-144
    80004bec:	4501                	li	a0,0
    80004bee:	ffffd097          	auipc	ra,0xffffd
    80004bf2:	346080e7          	jalr	838(ra) # 80001f34 <argstr>
    80004bf6:	04054a63          	bltz	a0,80004c4a <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004bfa:	f6c40593          	addi	a1,s0,-148
    80004bfe:	4505                	li	a0,1
    80004c00:	ffffd097          	auipc	ra,0xffffd
    80004c04:	2f0080e7          	jalr	752(ra) # 80001ef0 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004c08:	04054163          	bltz	a0,80004c4a <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004c0c:	f6840593          	addi	a1,s0,-152
    80004c10:	4509                	li	a0,2
    80004c12:	ffffd097          	auipc	ra,0xffffd
    80004c16:	2de080e7          	jalr	734(ra) # 80001ef0 <argint>
     argint(1, &major) < 0 ||
    80004c1a:	02054863          	bltz	a0,80004c4a <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004c1e:	f6841683          	lh	a3,-152(s0)
    80004c22:	f6c41603          	lh	a2,-148(s0)
    80004c26:	458d                	li	a1,3
    80004c28:	f7040513          	addi	a0,s0,-144
    80004c2c:	fffff097          	auipc	ra,0xfffff
    80004c30:	776080e7          	jalr	1910(ra) # 800043a2 <create>
     argint(2, &minor) < 0 ||
    80004c34:	c919                	beqz	a0,80004c4a <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004c36:	ffffe097          	auipc	ra,0xffffe
    80004c3a:	09c080e7          	jalr	156(ra) # 80002cd2 <iunlockput>
  end_op();
    80004c3e:	fffff097          	auipc	ra,0xfffff
    80004c42:	884080e7          	jalr	-1916(ra) # 800034c2 <end_op>
  return 0;
    80004c46:	4501                	li	a0,0
    80004c48:	a031                	j	80004c54 <sys_mknod+0x80>
    end_op();
    80004c4a:	fffff097          	auipc	ra,0xfffff
    80004c4e:	878080e7          	jalr	-1928(ra) # 800034c2 <end_op>
    return -1;
    80004c52:	557d                	li	a0,-1
}
    80004c54:	60ea                	ld	ra,152(sp)
    80004c56:	644a                	ld	s0,144(sp)
    80004c58:	610d                	addi	sp,sp,160
    80004c5a:	8082                	ret

0000000080004c5c <sys_chdir>:

uint64
sys_chdir(void)
{
    80004c5c:	7135                	addi	sp,sp,-160
    80004c5e:	ed06                	sd	ra,152(sp)
    80004c60:	e922                	sd	s0,144(sp)
    80004c62:	e526                	sd	s1,136(sp)
    80004c64:	e14a                	sd	s2,128(sp)
    80004c66:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004c68:	ffffc097          	auipc	ra,0xffffc
    80004c6c:	1dc080e7          	jalr	476(ra) # 80000e44 <myproc>
    80004c70:	892a                	mv	s2,a0
  
  begin_op();
    80004c72:	ffffe097          	auipc	ra,0xffffe
    80004c76:	7d0080e7          	jalr	2000(ra) # 80003442 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004c7a:	08000613          	li	a2,128
    80004c7e:	f6040593          	addi	a1,s0,-160
    80004c82:	4501                	li	a0,0
    80004c84:	ffffd097          	auipc	ra,0xffffd
    80004c88:	2b0080e7          	jalr	688(ra) # 80001f34 <argstr>
    80004c8c:	04054b63          	bltz	a0,80004ce2 <sys_chdir+0x86>
    80004c90:	f6040513          	addi	a0,s0,-160
    80004c94:	ffffe097          	auipc	ra,0xffffe
    80004c98:	592080e7          	jalr	1426(ra) # 80003226 <namei>
    80004c9c:	84aa                	mv	s1,a0
    80004c9e:	c131                	beqz	a0,80004ce2 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004ca0:	ffffe097          	auipc	ra,0xffffe
    80004ca4:	dd0080e7          	jalr	-560(ra) # 80002a70 <ilock>
  if(ip->type != T_DIR){
    80004ca8:	04449703          	lh	a4,68(s1)
    80004cac:	4785                	li	a5,1
    80004cae:	04f71063          	bne	a4,a5,80004cee <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004cb2:	8526                	mv	a0,s1
    80004cb4:	ffffe097          	auipc	ra,0xffffe
    80004cb8:	e7e080e7          	jalr	-386(ra) # 80002b32 <iunlock>
  iput(p->cwd);
    80004cbc:	15093503          	ld	a0,336(s2)
    80004cc0:	ffffe097          	auipc	ra,0xffffe
    80004cc4:	f6a080e7          	jalr	-150(ra) # 80002c2a <iput>
  end_op();
    80004cc8:	ffffe097          	auipc	ra,0xffffe
    80004ccc:	7fa080e7          	jalr	2042(ra) # 800034c2 <end_op>
  p->cwd = ip;
    80004cd0:	14993823          	sd	s1,336(s2)
  return 0;
    80004cd4:	4501                	li	a0,0
}
    80004cd6:	60ea                	ld	ra,152(sp)
    80004cd8:	644a                	ld	s0,144(sp)
    80004cda:	64aa                	ld	s1,136(sp)
    80004cdc:	690a                	ld	s2,128(sp)
    80004cde:	610d                	addi	sp,sp,160
    80004ce0:	8082                	ret
    end_op();
    80004ce2:	ffffe097          	auipc	ra,0xffffe
    80004ce6:	7e0080e7          	jalr	2016(ra) # 800034c2 <end_op>
    return -1;
    80004cea:	557d                	li	a0,-1
    80004cec:	b7ed                	j	80004cd6 <sys_chdir+0x7a>
    iunlockput(ip);
    80004cee:	8526                	mv	a0,s1
    80004cf0:	ffffe097          	auipc	ra,0xffffe
    80004cf4:	fe2080e7          	jalr	-30(ra) # 80002cd2 <iunlockput>
    end_op();
    80004cf8:	ffffe097          	auipc	ra,0xffffe
    80004cfc:	7ca080e7          	jalr	1994(ra) # 800034c2 <end_op>
    return -1;
    80004d00:	557d                	li	a0,-1
    80004d02:	bfd1                	j	80004cd6 <sys_chdir+0x7a>

0000000080004d04 <sys_exec>:

uint64
sys_exec(void)
{
    80004d04:	7145                	addi	sp,sp,-464
    80004d06:	e786                	sd	ra,456(sp)
    80004d08:	e3a2                	sd	s0,448(sp)
    80004d0a:	ff26                	sd	s1,440(sp)
    80004d0c:	fb4a                	sd	s2,432(sp)
    80004d0e:	f74e                	sd	s3,424(sp)
    80004d10:	f352                	sd	s4,416(sp)
    80004d12:	ef56                	sd	s5,408(sp)
    80004d14:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004d16:	08000613          	li	a2,128
    80004d1a:	f4040593          	addi	a1,s0,-192
    80004d1e:	4501                	li	a0,0
    80004d20:	ffffd097          	auipc	ra,0xffffd
    80004d24:	214080e7          	jalr	532(ra) # 80001f34 <argstr>
    return -1;
    80004d28:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004d2a:	0c054a63          	bltz	a0,80004dfe <sys_exec+0xfa>
    80004d2e:	e3840593          	addi	a1,s0,-456
    80004d32:	4505                	li	a0,1
    80004d34:	ffffd097          	auipc	ra,0xffffd
    80004d38:	1de080e7          	jalr	478(ra) # 80001f12 <argaddr>
    80004d3c:	0c054163          	bltz	a0,80004dfe <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004d40:	10000613          	li	a2,256
    80004d44:	4581                	li	a1,0
    80004d46:	e4040513          	addi	a0,s0,-448
    80004d4a:	ffffb097          	auipc	ra,0xffffb
    80004d4e:	42e080e7          	jalr	1070(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004d52:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004d56:	89a6                	mv	s3,s1
    80004d58:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004d5a:	02000a13          	li	s4,32
    80004d5e:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004d62:	00391513          	slli	a0,s2,0x3
    80004d66:	e3040593          	addi	a1,s0,-464
    80004d6a:	e3843783          	ld	a5,-456(s0)
    80004d6e:	953e                	add	a0,a0,a5
    80004d70:	ffffd097          	auipc	ra,0xffffd
    80004d74:	0e6080e7          	jalr	230(ra) # 80001e56 <fetchaddr>
    80004d78:	02054a63          	bltz	a0,80004dac <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004d7c:	e3043783          	ld	a5,-464(s0)
    80004d80:	c3b9                	beqz	a5,80004dc6 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004d82:	ffffb097          	auipc	ra,0xffffb
    80004d86:	396080e7          	jalr	918(ra) # 80000118 <kalloc>
    80004d8a:	85aa                	mv	a1,a0
    80004d8c:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004d90:	cd11                	beqz	a0,80004dac <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004d92:	6605                	lui	a2,0x1
    80004d94:	e3043503          	ld	a0,-464(s0)
    80004d98:	ffffd097          	auipc	ra,0xffffd
    80004d9c:	110080e7          	jalr	272(ra) # 80001ea8 <fetchstr>
    80004da0:	00054663          	bltz	a0,80004dac <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004da4:	0905                	addi	s2,s2,1
    80004da6:	09a1                	addi	s3,s3,8
    80004da8:	fb491be3          	bne	s2,s4,80004d5e <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004dac:	10048913          	addi	s2,s1,256
    80004db0:	6088                	ld	a0,0(s1)
    80004db2:	c529                	beqz	a0,80004dfc <sys_exec+0xf8>
    kfree(argv[i]);
    80004db4:	ffffb097          	auipc	ra,0xffffb
    80004db8:	268080e7          	jalr	616(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004dbc:	04a1                	addi	s1,s1,8
    80004dbe:	ff2499e3          	bne	s1,s2,80004db0 <sys_exec+0xac>
  return -1;
    80004dc2:	597d                	li	s2,-1
    80004dc4:	a82d                	j	80004dfe <sys_exec+0xfa>
      argv[i] = 0;
    80004dc6:	0a8e                	slli	s5,s5,0x3
    80004dc8:	fc040793          	addi	a5,s0,-64
    80004dcc:	9abe                	add	s5,s5,a5
    80004dce:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004dd2:	e4040593          	addi	a1,s0,-448
    80004dd6:	f4040513          	addi	a0,s0,-192
    80004dda:	fffff097          	auipc	ra,0xfffff
    80004dde:	194080e7          	jalr	404(ra) # 80003f6e <exec>
    80004de2:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004de4:	10048993          	addi	s3,s1,256
    80004de8:	6088                	ld	a0,0(s1)
    80004dea:	c911                	beqz	a0,80004dfe <sys_exec+0xfa>
    kfree(argv[i]);
    80004dec:	ffffb097          	auipc	ra,0xffffb
    80004df0:	230080e7          	jalr	560(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004df4:	04a1                	addi	s1,s1,8
    80004df6:	ff3499e3          	bne	s1,s3,80004de8 <sys_exec+0xe4>
    80004dfa:	a011                	j	80004dfe <sys_exec+0xfa>
  return -1;
    80004dfc:	597d                	li	s2,-1
}
    80004dfe:	854a                	mv	a0,s2
    80004e00:	60be                	ld	ra,456(sp)
    80004e02:	641e                	ld	s0,448(sp)
    80004e04:	74fa                	ld	s1,440(sp)
    80004e06:	795a                	ld	s2,432(sp)
    80004e08:	79ba                	ld	s3,424(sp)
    80004e0a:	7a1a                	ld	s4,416(sp)
    80004e0c:	6afa                	ld	s5,408(sp)
    80004e0e:	6179                	addi	sp,sp,464
    80004e10:	8082                	ret

0000000080004e12 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004e12:	7139                	addi	sp,sp,-64
    80004e14:	fc06                	sd	ra,56(sp)
    80004e16:	f822                	sd	s0,48(sp)
    80004e18:	f426                	sd	s1,40(sp)
    80004e1a:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004e1c:	ffffc097          	auipc	ra,0xffffc
    80004e20:	028080e7          	jalr	40(ra) # 80000e44 <myproc>
    80004e24:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004e26:	fd840593          	addi	a1,s0,-40
    80004e2a:	4501                	li	a0,0
    80004e2c:	ffffd097          	auipc	ra,0xffffd
    80004e30:	0e6080e7          	jalr	230(ra) # 80001f12 <argaddr>
    return -1;
    80004e34:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004e36:	0e054063          	bltz	a0,80004f16 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004e3a:	fc840593          	addi	a1,s0,-56
    80004e3e:	fd040513          	addi	a0,s0,-48
    80004e42:	fffff097          	auipc	ra,0xfffff
    80004e46:	dfc080e7          	jalr	-516(ra) # 80003c3e <pipealloc>
    return -1;
    80004e4a:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004e4c:	0c054563          	bltz	a0,80004f16 <sys_pipe+0x104>
  fd0 = -1;
    80004e50:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004e54:	fd043503          	ld	a0,-48(s0)
    80004e58:	fffff097          	auipc	ra,0xfffff
    80004e5c:	508080e7          	jalr	1288(ra) # 80004360 <fdalloc>
    80004e60:	fca42223          	sw	a0,-60(s0)
    80004e64:	08054c63          	bltz	a0,80004efc <sys_pipe+0xea>
    80004e68:	fc843503          	ld	a0,-56(s0)
    80004e6c:	fffff097          	auipc	ra,0xfffff
    80004e70:	4f4080e7          	jalr	1268(ra) # 80004360 <fdalloc>
    80004e74:	fca42023          	sw	a0,-64(s0)
    80004e78:	06054863          	bltz	a0,80004ee8 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004e7c:	4691                	li	a3,4
    80004e7e:	fc440613          	addi	a2,s0,-60
    80004e82:	fd843583          	ld	a1,-40(s0)
    80004e86:	68a8                	ld	a0,80(s1)
    80004e88:	ffffc097          	auipc	ra,0xffffc
    80004e8c:	c82080e7          	jalr	-894(ra) # 80000b0a <copyout>
    80004e90:	02054063          	bltz	a0,80004eb0 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004e94:	4691                	li	a3,4
    80004e96:	fc040613          	addi	a2,s0,-64
    80004e9a:	fd843583          	ld	a1,-40(s0)
    80004e9e:	0591                	addi	a1,a1,4
    80004ea0:	68a8                	ld	a0,80(s1)
    80004ea2:	ffffc097          	auipc	ra,0xffffc
    80004ea6:	c68080e7          	jalr	-920(ra) # 80000b0a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004eaa:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004eac:	06055563          	bgez	a0,80004f16 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80004eb0:	fc442783          	lw	a5,-60(s0)
    80004eb4:	07e9                	addi	a5,a5,26
    80004eb6:	078e                	slli	a5,a5,0x3
    80004eb8:	97a6                	add	a5,a5,s1
    80004eba:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004ebe:	fc042503          	lw	a0,-64(s0)
    80004ec2:	0569                	addi	a0,a0,26
    80004ec4:	050e                	slli	a0,a0,0x3
    80004ec6:	9526                	add	a0,a0,s1
    80004ec8:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80004ecc:	fd043503          	ld	a0,-48(s0)
    80004ed0:	fffff097          	auipc	ra,0xfffff
    80004ed4:	a3e080e7          	jalr	-1474(ra) # 8000390e <fileclose>
    fileclose(wf);
    80004ed8:	fc843503          	ld	a0,-56(s0)
    80004edc:	fffff097          	auipc	ra,0xfffff
    80004ee0:	a32080e7          	jalr	-1486(ra) # 8000390e <fileclose>
    return -1;
    80004ee4:	57fd                	li	a5,-1
    80004ee6:	a805                	j	80004f16 <sys_pipe+0x104>
    if(fd0 >= 0)
    80004ee8:	fc442783          	lw	a5,-60(s0)
    80004eec:	0007c863          	bltz	a5,80004efc <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80004ef0:	01a78513          	addi	a0,a5,26
    80004ef4:	050e                	slli	a0,a0,0x3
    80004ef6:	9526                	add	a0,a0,s1
    80004ef8:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80004efc:	fd043503          	ld	a0,-48(s0)
    80004f00:	fffff097          	auipc	ra,0xfffff
    80004f04:	a0e080e7          	jalr	-1522(ra) # 8000390e <fileclose>
    fileclose(wf);
    80004f08:	fc843503          	ld	a0,-56(s0)
    80004f0c:	fffff097          	auipc	ra,0xfffff
    80004f10:	a02080e7          	jalr	-1534(ra) # 8000390e <fileclose>
    return -1;
    80004f14:	57fd                	li	a5,-1
}
    80004f16:	853e                	mv	a0,a5
    80004f18:	70e2                	ld	ra,56(sp)
    80004f1a:	7442                	ld	s0,48(sp)
    80004f1c:	74a2                	ld	s1,40(sp)
    80004f1e:	6121                	addi	sp,sp,64
    80004f20:	8082                	ret
	...

0000000080004f30 <kernelvec>:
    80004f30:	7111                	addi	sp,sp,-256
    80004f32:	e006                	sd	ra,0(sp)
    80004f34:	e40a                	sd	sp,8(sp)
    80004f36:	e80e                	sd	gp,16(sp)
    80004f38:	ec12                	sd	tp,24(sp)
    80004f3a:	f016                	sd	t0,32(sp)
    80004f3c:	f41a                	sd	t1,40(sp)
    80004f3e:	f81e                	sd	t2,48(sp)
    80004f40:	fc22                	sd	s0,56(sp)
    80004f42:	e0a6                	sd	s1,64(sp)
    80004f44:	e4aa                	sd	a0,72(sp)
    80004f46:	e8ae                	sd	a1,80(sp)
    80004f48:	ecb2                	sd	a2,88(sp)
    80004f4a:	f0b6                	sd	a3,96(sp)
    80004f4c:	f4ba                	sd	a4,104(sp)
    80004f4e:	f8be                	sd	a5,112(sp)
    80004f50:	fcc2                	sd	a6,120(sp)
    80004f52:	e146                	sd	a7,128(sp)
    80004f54:	e54a                	sd	s2,136(sp)
    80004f56:	e94e                	sd	s3,144(sp)
    80004f58:	ed52                	sd	s4,152(sp)
    80004f5a:	f156                	sd	s5,160(sp)
    80004f5c:	f55a                	sd	s6,168(sp)
    80004f5e:	f95e                	sd	s7,176(sp)
    80004f60:	fd62                	sd	s8,184(sp)
    80004f62:	e1e6                	sd	s9,192(sp)
    80004f64:	e5ea                	sd	s10,200(sp)
    80004f66:	e9ee                	sd	s11,208(sp)
    80004f68:	edf2                	sd	t3,216(sp)
    80004f6a:	f1f6                	sd	t4,224(sp)
    80004f6c:	f5fa                	sd	t5,232(sp)
    80004f6e:	f9fe                	sd	t6,240(sp)
    80004f70:	db3fc0ef          	jal	ra,80001d22 <kerneltrap>
    80004f74:	6082                	ld	ra,0(sp)
    80004f76:	6122                	ld	sp,8(sp)
    80004f78:	61c2                	ld	gp,16(sp)
    80004f7a:	7282                	ld	t0,32(sp)
    80004f7c:	7322                	ld	t1,40(sp)
    80004f7e:	73c2                	ld	t2,48(sp)
    80004f80:	7462                	ld	s0,56(sp)
    80004f82:	6486                	ld	s1,64(sp)
    80004f84:	6526                	ld	a0,72(sp)
    80004f86:	65c6                	ld	a1,80(sp)
    80004f88:	6666                	ld	a2,88(sp)
    80004f8a:	7686                	ld	a3,96(sp)
    80004f8c:	7726                	ld	a4,104(sp)
    80004f8e:	77c6                	ld	a5,112(sp)
    80004f90:	7866                	ld	a6,120(sp)
    80004f92:	688a                	ld	a7,128(sp)
    80004f94:	692a                	ld	s2,136(sp)
    80004f96:	69ca                	ld	s3,144(sp)
    80004f98:	6a6a                	ld	s4,152(sp)
    80004f9a:	7a8a                	ld	s5,160(sp)
    80004f9c:	7b2a                	ld	s6,168(sp)
    80004f9e:	7bca                	ld	s7,176(sp)
    80004fa0:	7c6a                	ld	s8,184(sp)
    80004fa2:	6c8e                	ld	s9,192(sp)
    80004fa4:	6d2e                	ld	s10,200(sp)
    80004fa6:	6dce                	ld	s11,208(sp)
    80004fa8:	6e6e                	ld	t3,216(sp)
    80004faa:	7e8e                	ld	t4,224(sp)
    80004fac:	7f2e                	ld	t5,232(sp)
    80004fae:	7fce                	ld	t6,240(sp)
    80004fb0:	6111                	addi	sp,sp,256
    80004fb2:	10200073          	sret
    80004fb6:	00000013          	nop
    80004fba:	00000013          	nop
    80004fbe:	0001                	nop

0000000080004fc0 <timervec>:
    80004fc0:	34051573          	csrrw	a0,mscratch,a0
    80004fc4:	e10c                	sd	a1,0(a0)
    80004fc6:	e510                	sd	a2,8(a0)
    80004fc8:	e914                	sd	a3,16(a0)
    80004fca:	6d0c                	ld	a1,24(a0)
    80004fcc:	7110                	ld	a2,32(a0)
    80004fce:	6194                	ld	a3,0(a1)
    80004fd0:	96b2                	add	a3,a3,a2
    80004fd2:	e194                	sd	a3,0(a1)
    80004fd4:	4589                	li	a1,2
    80004fd6:	14459073          	csrw	sip,a1
    80004fda:	6914                	ld	a3,16(a0)
    80004fdc:	6510                	ld	a2,8(a0)
    80004fde:	610c                	ld	a1,0(a0)
    80004fe0:	34051573          	csrrw	a0,mscratch,a0
    80004fe4:	30200073          	mret
	...

0000000080004fea <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80004fea:	1141                	addi	sp,sp,-16
    80004fec:	e422                	sd	s0,8(sp)
    80004fee:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80004ff0:	0c0007b7          	lui	a5,0xc000
    80004ff4:	4705                	li	a4,1
    80004ff6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80004ff8:	c3d8                	sw	a4,4(a5)
}
    80004ffa:	6422                	ld	s0,8(sp)
    80004ffc:	0141                	addi	sp,sp,16
    80004ffe:	8082                	ret

0000000080005000 <plicinithart>:

void
plicinithart(void)
{
    80005000:	1141                	addi	sp,sp,-16
    80005002:	e406                	sd	ra,8(sp)
    80005004:	e022                	sd	s0,0(sp)
    80005006:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005008:	ffffc097          	auipc	ra,0xffffc
    8000500c:	e10080e7          	jalr	-496(ra) # 80000e18 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005010:	0085171b          	slliw	a4,a0,0x8
    80005014:	0c0027b7          	lui	a5,0xc002
    80005018:	97ba                	add	a5,a5,a4
    8000501a:	40200713          	li	a4,1026
    8000501e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005022:	00d5151b          	slliw	a0,a0,0xd
    80005026:	0c2017b7          	lui	a5,0xc201
    8000502a:	953e                	add	a0,a0,a5
    8000502c:	00052023          	sw	zero,0(a0)
}
    80005030:	60a2                	ld	ra,8(sp)
    80005032:	6402                	ld	s0,0(sp)
    80005034:	0141                	addi	sp,sp,16
    80005036:	8082                	ret

0000000080005038 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005038:	1141                	addi	sp,sp,-16
    8000503a:	e406                	sd	ra,8(sp)
    8000503c:	e022                	sd	s0,0(sp)
    8000503e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005040:	ffffc097          	auipc	ra,0xffffc
    80005044:	dd8080e7          	jalr	-552(ra) # 80000e18 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005048:	00d5179b          	slliw	a5,a0,0xd
    8000504c:	0c201537          	lui	a0,0xc201
    80005050:	953e                	add	a0,a0,a5
  return irq;
}
    80005052:	4148                	lw	a0,4(a0)
    80005054:	60a2                	ld	ra,8(sp)
    80005056:	6402                	ld	s0,0(sp)
    80005058:	0141                	addi	sp,sp,16
    8000505a:	8082                	ret

000000008000505c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000505c:	1101                	addi	sp,sp,-32
    8000505e:	ec06                	sd	ra,24(sp)
    80005060:	e822                	sd	s0,16(sp)
    80005062:	e426                	sd	s1,8(sp)
    80005064:	1000                	addi	s0,sp,32
    80005066:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005068:	ffffc097          	auipc	ra,0xffffc
    8000506c:	db0080e7          	jalr	-592(ra) # 80000e18 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005070:	00d5151b          	slliw	a0,a0,0xd
    80005074:	0c2017b7          	lui	a5,0xc201
    80005078:	97aa                	add	a5,a5,a0
    8000507a:	c3c4                	sw	s1,4(a5)
}
    8000507c:	60e2                	ld	ra,24(sp)
    8000507e:	6442                	ld	s0,16(sp)
    80005080:	64a2                	ld	s1,8(sp)
    80005082:	6105                	addi	sp,sp,32
    80005084:	8082                	ret

0000000080005086 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005086:	1141                	addi	sp,sp,-16
    80005088:	e406                	sd	ra,8(sp)
    8000508a:	e022                	sd	s0,0(sp)
    8000508c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000508e:	479d                	li	a5,7
    80005090:	06a7c963          	blt	a5,a0,80005102 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80005094:	00016797          	auipc	a5,0x16
    80005098:	f6c78793          	addi	a5,a5,-148 # 8001b000 <disk>
    8000509c:	00a78733          	add	a4,a5,a0
    800050a0:	6789                	lui	a5,0x2
    800050a2:	97ba                	add	a5,a5,a4
    800050a4:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800050a8:	e7ad                	bnez	a5,80005112 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800050aa:	00451793          	slli	a5,a0,0x4
    800050ae:	00018717          	auipc	a4,0x18
    800050b2:	f5270713          	addi	a4,a4,-174 # 8001d000 <disk+0x2000>
    800050b6:	6314                	ld	a3,0(a4)
    800050b8:	96be                	add	a3,a3,a5
    800050ba:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800050be:	6314                	ld	a3,0(a4)
    800050c0:	96be                	add	a3,a3,a5
    800050c2:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800050c6:	6314                	ld	a3,0(a4)
    800050c8:	96be                	add	a3,a3,a5
    800050ca:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800050ce:	6318                	ld	a4,0(a4)
    800050d0:	97ba                	add	a5,a5,a4
    800050d2:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800050d6:	00016797          	auipc	a5,0x16
    800050da:	f2a78793          	addi	a5,a5,-214 # 8001b000 <disk>
    800050de:	97aa                	add	a5,a5,a0
    800050e0:	6509                	lui	a0,0x2
    800050e2:	953e                	add	a0,a0,a5
    800050e4:	4785                	li	a5,1
    800050e6:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800050ea:	00018517          	auipc	a0,0x18
    800050ee:	f2e50513          	addi	a0,a0,-210 # 8001d018 <disk+0x2018>
    800050f2:	ffffc097          	auipc	ra,0xffffc
    800050f6:	59a080e7          	jalr	1434(ra) # 8000168c <wakeup>
}
    800050fa:	60a2                	ld	ra,8(sp)
    800050fc:	6402                	ld	s0,0(sp)
    800050fe:	0141                	addi	sp,sp,16
    80005100:	8082                	ret
    panic("free_desc 1");
    80005102:	00003517          	auipc	a0,0x3
    80005106:	62e50513          	addi	a0,a0,1582 # 80008730 <syscalls+0x368>
    8000510a:	00001097          	auipc	ra,0x1
    8000510e:	a1e080e7          	jalr	-1506(ra) # 80005b28 <panic>
    panic("free_desc 2");
    80005112:	00003517          	auipc	a0,0x3
    80005116:	62e50513          	addi	a0,a0,1582 # 80008740 <syscalls+0x378>
    8000511a:	00001097          	auipc	ra,0x1
    8000511e:	a0e080e7          	jalr	-1522(ra) # 80005b28 <panic>

0000000080005122 <virtio_disk_init>:
{
    80005122:	1101                	addi	sp,sp,-32
    80005124:	ec06                	sd	ra,24(sp)
    80005126:	e822                	sd	s0,16(sp)
    80005128:	e426                	sd	s1,8(sp)
    8000512a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000512c:	00003597          	auipc	a1,0x3
    80005130:	62458593          	addi	a1,a1,1572 # 80008750 <syscalls+0x388>
    80005134:	00018517          	auipc	a0,0x18
    80005138:	ff450513          	addi	a0,a0,-12 # 8001d128 <disk+0x2128>
    8000513c:	00001097          	auipc	ra,0x1
    80005140:	ea6080e7          	jalr	-346(ra) # 80005fe2 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005144:	100017b7          	lui	a5,0x10001
    80005148:	4398                	lw	a4,0(a5)
    8000514a:	2701                	sext.w	a4,a4
    8000514c:	747277b7          	lui	a5,0x74727
    80005150:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005154:	0ef71163          	bne	a4,a5,80005236 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005158:	100017b7          	lui	a5,0x10001
    8000515c:	43dc                	lw	a5,4(a5)
    8000515e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005160:	4705                	li	a4,1
    80005162:	0ce79a63          	bne	a5,a4,80005236 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005166:	100017b7          	lui	a5,0x10001
    8000516a:	479c                	lw	a5,8(a5)
    8000516c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000516e:	4709                	li	a4,2
    80005170:	0ce79363          	bne	a5,a4,80005236 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005174:	100017b7          	lui	a5,0x10001
    80005178:	47d8                	lw	a4,12(a5)
    8000517a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000517c:	554d47b7          	lui	a5,0x554d4
    80005180:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005184:	0af71963          	bne	a4,a5,80005236 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005188:	100017b7          	lui	a5,0x10001
    8000518c:	4705                	li	a4,1
    8000518e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005190:	470d                	li	a4,3
    80005192:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005194:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005196:	c7ffe737          	lui	a4,0xc7ffe
    8000519a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    8000519e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800051a0:	2701                	sext.w	a4,a4
    800051a2:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800051a4:	472d                	li	a4,11
    800051a6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800051a8:	473d                	li	a4,15
    800051aa:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800051ac:	6705                	lui	a4,0x1
    800051ae:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800051b0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800051b4:	5bdc                	lw	a5,52(a5)
    800051b6:	2781                	sext.w	a5,a5
  if(max == 0)
    800051b8:	c7d9                	beqz	a5,80005246 <virtio_disk_init+0x124>
  if(max < NUM)
    800051ba:	471d                	li	a4,7
    800051bc:	08f77d63          	bgeu	a4,a5,80005256 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800051c0:	100014b7          	lui	s1,0x10001
    800051c4:	47a1                	li	a5,8
    800051c6:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800051c8:	6609                	lui	a2,0x2
    800051ca:	4581                	li	a1,0
    800051cc:	00016517          	auipc	a0,0x16
    800051d0:	e3450513          	addi	a0,a0,-460 # 8001b000 <disk>
    800051d4:	ffffb097          	auipc	ra,0xffffb
    800051d8:	fa4080e7          	jalr	-92(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800051dc:	00016717          	auipc	a4,0x16
    800051e0:	e2470713          	addi	a4,a4,-476 # 8001b000 <disk>
    800051e4:	00c75793          	srli	a5,a4,0xc
    800051e8:	2781                	sext.w	a5,a5
    800051ea:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    800051ec:	00018797          	auipc	a5,0x18
    800051f0:	e1478793          	addi	a5,a5,-492 # 8001d000 <disk+0x2000>
    800051f4:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    800051f6:	00016717          	auipc	a4,0x16
    800051fa:	e8a70713          	addi	a4,a4,-374 # 8001b080 <disk+0x80>
    800051fe:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005200:	00017717          	auipc	a4,0x17
    80005204:	e0070713          	addi	a4,a4,-512 # 8001c000 <disk+0x1000>
    80005208:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000520a:	4705                	li	a4,1
    8000520c:	00e78c23          	sb	a4,24(a5)
    80005210:	00e78ca3          	sb	a4,25(a5)
    80005214:	00e78d23          	sb	a4,26(a5)
    80005218:	00e78da3          	sb	a4,27(a5)
    8000521c:	00e78e23          	sb	a4,28(a5)
    80005220:	00e78ea3          	sb	a4,29(a5)
    80005224:	00e78f23          	sb	a4,30(a5)
    80005228:	00e78fa3          	sb	a4,31(a5)
}
    8000522c:	60e2                	ld	ra,24(sp)
    8000522e:	6442                	ld	s0,16(sp)
    80005230:	64a2                	ld	s1,8(sp)
    80005232:	6105                	addi	sp,sp,32
    80005234:	8082                	ret
    panic("could not find virtio disk");
    80005236:	00003517          	auipc	a0,0x3
    8000523a:	52a50513          	addi	a0,a0,1322 # 80008760 <syscalls+0x398>
    8000523e:	00001097          	auipc	ra,0x1
    80005242:	8ea080e7          	jalr	-1814(ra) # 80005b28 <panic>
    panic("virtio disk has no queue 0");
    80005246:	00003517          	auipc	a0,0x3
    8000524a:	53a50513          	addi	a0,a0,1338 # 80008780 <syscalls+0x3b8>
    8000524e:	00001097          	auipc	ra,0x1
    80005252:	8da080e7          	jalr	-1830(ra) # 80005b28 <panic>
    panic("virtio disk max queue too short");
    80005256:	00003517          	auipc	a0,0x3
    8000525a:	54a50513          	addi	a0,a0,1354 # 800087a0 <syscalls+0x3d8>
    8000525e:	00001097          	auipc	ra,0x1
    80005262:	8ca080e7          	jalr	-1846(ra) # 80005b28 <panic>

0000000080005266 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005266:	7159                	addi	sp,sp,-112
    80005268:	f486                	sd	ra,104(sp)
    8000526a:	f0a2                	sd	s0,96(sp)
    8000526c:	eca6                	sd	s1,88(sp)
    8000526e:	e8ca                	sd	s2,80(sp)
    80005270:	e4ce                	sd	s3,72(sp)
    80005272:	e0d2                	sd	s4,64(sp)
    80005274:	fc56                	sd	s5,56(sp)
    80005276:	f85a                	sd	s6,48(sp)
    80005278:	f45e                	sd	s7,40(sp)
    8000527a:	f062                	sd	s8,32(sp)
    8000527c:	ec66                	sd	s9,24(sp)
    8000527e:	e86a                	sd	s10,16(sp)
    80005280:	1880                	addi	s0,sp,112
    80005282:	892a                	mv	s2,a0
    80005284:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005286:	00c52c83          	lw	s9,12(a0)
    8000528a:	001c9c9b          	slliw	s9,s9,0x1
    8000528e:	1c82                	slli	s9,s9,0x20
    80005290:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005294:	00018517          	auipc	a0,0x18
    80005298:	e9450513          	addi	a0,a0,-364 # 8001d128 <disk+0x2128>
    8000529c:	00001097          	auipc	ra,0x1
    800052a0:	dd6080e7          	jalr	-554(ra) # 80006072 <acquire>
  for(int i = 0; i < 3; i++){
    800052a4:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800052a6:	4c21                	li	s8,8
      disk.free[i] = 0;
    800052a8:	00016b97          	auipc	s7,0x16
    800052ac:	d58b8b93          	addi	s7,s7,-680 # 8001b000 <disk>
    800052b0:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    800052b2:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    800052b4:	8a4e                	mv	s4,s3
    800052b6:	a051                	j	8000533a <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    800052b8:	00fb86b3          	add	a3,s7,a5
    800052bc:	96da                	add	a3,a3,s6
    800052be:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    800052c2:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800052c4:	0207c563          	bltz	a5,800052ee <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800052c8:	2485                	addiw	s1,s1,1
    800052ca:	0711                	addi	a4,a4,4
    800052cc:	25548063          	beq	s1,s5,8000550c <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    800052d0:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    800052d2:	00018697          	auipc	a3,0x18
    800052d6:	d4668693          	addi	a3,a3,-698 # 8001d018 <disk+0x2018>
    800052da:	87d2                	mv	a5,s4
    if(disk.free[i]){
    800052dc:	0006c583          	lbu	a1,0(a3)
    800052e0:	fde1                	bnez	a1,800052b8 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800052e2:	2785                	addiw	a5,a5,1
    800052e4:	0685                	addi	a3,a3,1
    800052e6:	ff879be3          	bne	a5,s8,800052dc <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800052ea:	57fd                	li	a5,-1
    800052ec:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    800052ee:	02905a63          	blez	s1,80005322 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800052f2:	f9042503          	lw	a0,-112(s0)
    800052f6:	00000097          	auipc	ra,0x0
    800052fa:	d90080e7          	jalr	-624(ra) # 80005086 <free_desc>
      for(int j = 0; j < i; j++)
    800052fe:	4785                	li	a5,1
    80005300:	0297d163          	bge	a5,s1,80005322 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005304:	f9442503          	lw	a0,-108(s0)
    80005308:	00000097          	auipc	ra,0x0
    8000530c:	d7e080e7          	jalr	-642(ra) # 80005086 <free_desc>
      for(int j = 0; j < i; j++)
    80005310:	4789                	li	a5,2
    80005312:	0097d863          	bge	a5,s1,80005322 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005316:	f9842503          	lw	a0,-104(s0)
    8000531a:	00000097          	auipc	ra,0x0
    8000531e:	d6c080e7          	jalr	-660(ra) # 80005086 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005322:	00018597          	auipc	a1,0x18
    80005326:	e0658593          	addi	a1,a1,-506 # 8001d128 <disk+0x2128>
    8000532a:	00018517          	auipc	a0,0x18
    8000532e:	cee50513          	addi	a0,a0,-786 # 8001d018 <disk+0x2018>
    80005332:	ffffc097          	auipc	ra,0xffffc
    80005336:	1ce080e7          	jalr	462(ra) # 80001500 <sleep>
  for(int i = 0; i < 3; i++){
    8000533a:	f9040713          	addi	a4,s0,-112
    8000533e:	84ce                	mv	s1,s3
    80005340:	bf41                	j	800052d0 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005342:	20058713          	addi	a4,a1,512
    80005346:	00471693          	slli	a3,a4,0x4
    8000534a:	00016717          	auipc	a4,0x16
    8000534e:	cb670713          	addi	a4,a4,-842 # 8001b000 <disk>
    80005352:	9736                	add	a4,a4,a3
    80005354:	4685                	li	a3,1
    80005356:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000535a:	20058713          	addi	a4,a1,512
    8000535e:	00471693          	slli	a3,a4,0x4
    80005362:	00016717          	auipc	a4,0x16
    80005366:	c9e70713          	addi	a4,a4,-866 # 8001b000 <disk>
    8000536a:	9736                	add	a4,a4,a3
    8000536c:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005370:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005374:	7679                	lui	a2,0xffffe
    80005376:	963e                	add	a2,a2,a5
    80005378:	00018697          	auipc	a3,0x18
    8000537c:	c8868693          	addi	a3,a3,-888 # 8001d000 <disk+0x2000>
    80005380:	6298                	ld	a4,0(a3)
    80005382:	9732                	add	a4,a4,a2
    80005384:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005386:	6298                	ld	a4,0(a3)
    80005388:	9732                	add	a4,a4,a2
    8000538a:	4541                	li	a0,16
    8000538c:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000538e:	6298                	ld	a4,0(a3)
    80005390:	9732                	add	a4,a4,a2
    80005392:	4505                	li	a0,1
    80005394:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005398:	f9442703          	lw	a4,-108(s0)
    8000539c:	6288                	ld	a0,0(a3)
    8000539e:	962a                	add	a2,a2,a0
    800053a0:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    800053a4:	0712                	slli	a4,a4,0x4
    800053a6:	6290                	ld	a2,0(a3)
    800053a8:	963a                	add	a2,a2,a4
    800053aa:	05890513          	addi	a0,s2,88
    800053ae:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800053b0:	6294                	ld	a3,0(a3)
    800053b2:	96ba                	add	a3,a3,a4
    800053b4:	40000613          	li	a2,1024
    800053b8:	c690                	sw	a2,8(a3)
  if(write)
    800053ba:	140d0063          	beqz	s10,800054fa <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800053be:	00018697          	auipc	a3,0x18
    800053c2:	c426b683          	ld	a3,-958(a3) # 8001d000 <disk+0x2000>
    800053c6:	96ba                	add	a3,a3,a4
    800053c8:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800053cc:	00016817          	auipc	a6,0x16
    800053d0:	c3480813          	addi	a6,a6,-972 # 8001b000 <disk>
    800053d4:	00018517          	auipc	a0,0x18
    800053d8:	c2c50513          	addi	a0,a0,-980 # 8001d000 <disk+0x2000>
    800053dc:	6114                	ld	a3,0(a0)
    800053de:	96ba                	add	a3,a3,a4
    800053e0:	00c6d603          	lhu	a2,12(a3)
    800053e4:	00166613          	ori	a2,a2,1
    800053e8:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800053ec:	f9842683          	lw	a3,-104(s0)
    800053f0:	6110                	ld	a2,0(a0)
    800053f2:	9732                	add	a4,a4,a2
    800053f4:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800053f8:	20058613          	addi	a2,a1,512
    800053fc:	0612                	slli	a2,a2,0x4
    800053fe:	9642                	add	a2,a2,a6
    80005400:	577d                	li	a4,-1
    80005402:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005406:	00469713          	slli	a4,a3,0x4
    8000540a:	6114                	ld	a3,0(a0)
    8000540c:	96ba                	add	a3,a3,a4
    8000540e:	03078793          	addi	a5,a5,48
    80005412:	97c2                	add	a5,a5,a6
    80005414:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005416:	611c                	ld	a5,0(a0)
    80005418:	97ba                	add	a5,a5,a4
    8000541a:	4685                	li	a3,1
    8000541c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000541e:	611c                	ld	a5,0(a0)
    80005420:	97ba                	add	a5,a5,a4
    80005422:	4809                	li	a6,2
    80005424:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005428:	611c                	ld	a5,0(a0)
    8000542a:	973e                	add	a4,a4,a5
    8000542c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005430:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80005434:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005438:	6518                	ld	a4,8(a0)
    8000543a:	00275783          	lhu	a5,2(a4)
    8000543e:	8b9d                	andi	a5,a5,7
    80005440:	0786                	slli	a5,a5,0x1
    80005442:	97ba                	add	a5,a5,a4
    80005444:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005448:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000544c:	6518                	ld	a4,8(a0)
    8000544e:	00275783          	lhu	a5,2(a4)
    80005452:	2785                	addiw	a5,a5,1
    80005454:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005458:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000545c:	100017b7          	lui	a5,0x10001
    80005460:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005464:	00492703          	lw	a4,4(s2)
    80005468:	4785                	li	a5,1
    8000546a:	02f71163          	bne	a4,a5,8000548c <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    8000546e:	00018997          	auipc	s3,0x18
    80005472:	cba98993          	addi	s3,s3,-838 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    80005476:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005478:	85ce                	mv	a1,s3
    8000547a:	854a                	mv	a0,s2
    8000547c:	ffffc097          	auipc	ra,0xffffc
    80005480:	084080e7          	jalr	132(ra) # 80001500 <sleep>
  while(b->disk == 1) {
    80005484:	00492783          	lw	a5,4(s2)
    80005488:	fe9788e3          	beq	a5,s1,80005478 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    8000548c:	f9042903          	lw	s2,-112(s0)
    80005490:	20090793          	addi	a5,s2,512
    80005494:	00479713          	slli	a4,a5,0x4
    80005498:	00016797          	auipc	a5,0x16
    8000549c:	b6878793          	addi	a5,a5,-1176 # 8001b000 <disk>
    800054a0:	97ba                	add	a5,a5,a4
    800054a2:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800054a6:	00018997          	auipc	s3,0x18
    800054aa:	b5a98993          	addi	s3,s3,-1190 # 8001d000 <disk+0x2000>
    800054ae:	00491713          	slli	a4,s2,0x4
    800054b2:	0009b783          	ld	a5,0(s3)
    800054b6:	97ba                	add	a5,a5,a4
    800054b8:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800054bc:	854a                	mv	a0,s2
    800054be:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800054c2:	00000097          	auipc	ra,0x0
    800054c6:	bc4080e7          	jalr	-1084(ra) # 80005086 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800054ca:	8885                	andi	s1,s1,1
    800054cc:	f0ed                	bnez	s1,800054ae <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800054ce:	00018517          	auipc	a0,0x18
    800054d2:	c5a50513          	addi	a0,a0,-934 # 8001d128 <disk+0x2128>
    800054d6:	00001097          	auipc	ra,0x1
    800054da:	c50080e7          	jalr	-944(ra) # 80006126 <release>
}
    800054de:	70a6                	ld	ra,104(sp)
    800054e0:	7406                	ld	s0,96(sp)
    800054e2:	64e6                	ld	s1,88(sp)
    800054e4:	6946                	ld	s2,80(sp)
    800054e6:	69a6                	ld	s3,72(sp)
    800054e8:	6a06                	ld	s4,64(sp)
    800054ea:	7ae2                	ld	s5,56(sp)
    800054ec:	7b42                	ld	s6,48(sp)
    800054ee:	7ba2                	ld	s7,40(sp)
    800054f0:	7c02                	ld	s8,32(sp)
    800054f2:	6ce2                	ld	s9,24(sp)
    800054f4:	6d42                	ld	s10,16(sp)
    800054f6:	6165                	addi	sp,sp,112
    800054f8:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800054fa:	00018697          	auipc	a3,0x18
    800054fe:	b066b683          	ld	a3,-1274(a3) # 8001d000 <disk+0x2000>
    80005502:	96ba                	add	a3,a3,a4
    80005504:	4609                	li	a2,2
    80005506:	00c69623          	sh	a2,12(a3)
    8000550a:	b5c9                	j	800053cc <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000550c:	f9042583          	lw	a1,-112(s0)
    80005510:	20058793          	addi	a5,a1,512
    80005514:	0792                	slli	a5,a5,0x4
    80005516:	00016517          	auipc	a0,0x16
    8000551a:	b9250513          	addi	a0,a0,-1134 # 8001b0a8 <disk+0xa8>
    8000551e:	953e                	add	a0,a0,a5
  if(write)
    80005520:	e20d11e3          	bnez	s10,80005342 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005524:	20058713          	addi	a4,a1,512
    80005528:	00471693          	slli	a3,a4,0x4
    8000552c:	00016717          	auipc	a4,0x16
    80005530:	ad470713          	addi	a4,a4,-1324 # 8001b000 <disk>
    80005534:	9736                	add	a4,a4,a3
    80005536:	0a072423          	sw	zero,168(a4)
    8000553a:	b505                	j	8000535a <virtio_disk_rw+0xf4>

000000008000553c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000553c:	1101                	addi	sp,sp,-32
    8000553e:	ec06                	sd	ra,24(sp)
    80005540:	e822                	sd	s0,16(sp)
    80005542:	e426                	sd	s1,8(sp)
    80005544:	e04a                	sd	s2,0(sp)
    80005546:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005548:	00018517          	auipc	a0,0x18
    8000554c:	be050513          	addi	a0,a0,-1056 # 8001d128 <disk+0x2128>
    80005550:	00001097          	auipc	ra,0x1
    80005554:	b22080e7          	jalr	-1246(ra) # 80006072 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005558:	10001737          	lui	a4,0x10001
    8000555c:	533c                	lw	a5,96(a4)
    8000555e:	8b8d                	andi	a5,a5,3
    80005560:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005562:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005566:	00018797          	auipc	a5,0x18
    8000556a:	a9a78793          	addi	a5,a5,-1382 # 8001d000 <disk+0x2000>
    8000556e:	6b94                	ld	a3,16(a5)
    80005570:	0207d703          	lhu	a4,32(a5)
    80005574:	0026d783          	lhu	a5,2(a3)
    80005578:	06f70163          	beq	a4,a5,800055da <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000557c:	00016917          	auipc	s2,0x16
    80005580:	a8490913          	addi	s2,s2,-1404 # 8001b000 <disk>
    80005584:	00018497          	auipc	s1,0x18
    80005588:	a7c48493          	addi	s1,s1,-1412 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    8000558c:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005590:	6898                	ld	a4,16(s1)
    80005592:	0204d783          	lhu	a5,32(s1)
    80005596:	8b9d                	andi	a5,a5,7
    80005598:	078e                	slli	a5,a5,0x3
    8000559a:	97ba                	add	a5,a5,a4
    8000559c:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000559e:	20078713          	addi	a4,a5,512
    800055a2:	0712                	slli	a4,a4,0x4
    800055a4:	974a                	add	a4,a4,s2
    800055a6:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800055aa:	e731                	bnez	a4,800055f6 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800055ac:	20078793          	addi	a5,a5,512
    800055b0:	0792                	slli	a5,a5,0x4
    800055b2:	97ca                	add	a5,a5,s2
    800055b4:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800055b6:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800055ba:	ffffc097          	auipc	ra,0xffffc
    800055be:	0d2080e7          	jalr	210(ra) # 8000168c <wakeup>

    disk.used_idx += 1;
    800055c2:	0204d783          	lhu	a5,32(s1)
    800055c6:	2785                	addiw	a5,a5,1
    800055c8:	17c2                	slli	a5,a5,0x30
    800055ca:	93c1                	srli	a5,a5,0x30
    800055cc:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800055d0:	6898                	ld	a4,16(s1)
    800055d2:	00275703          	lhu	a4,2(a4)
    800055d6:	faf71be3          	bne	a4,a5,8000558c <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    800055da:	00018517          	auipc	a0,0x18
    800055de:	b4e50513          	addi	a0,a0,-1202 # 8001d128 <disk+0x2128>
    800055e2:	00001097          	auipc	ra,0x1
    800055e6:	b44080e7          	jalr	-1212(ra) # 80006126 <release>
}
    800055ea:	60e2                	ld	ra,24(sp)
    800055ec:	6442                	ld	s0,16(sp)
    800055ee:	64a2                	ld	s1,8(sp)
    800055f0:	6902                	ld	s2,0(sp)
    800055f2:	6105                	addi	sp,sp,32
    800055f4:	8082                	ret
      panic("virtio_disk_intr status");
    800055f6:	00003517          	auipc	a0,0x3
    800055fa:	1ca50513          	addi	a0,a0,458 # 800087c0 <syscalls+0x3f8>
    800055fe:	00000097          	auipc	ra,0x0
    80005602:	52a080e7          	jalr	1322(ra) # 80005b28 <panic>

0000000080005606 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005606:	1141                	addi	sp,sp,-16
    80005608:	e422                	sd	s0,8(sp)
    8000560a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000560c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005610:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005614:	0037979b          	slliw	a5,a5,0x3
    80005618:	02004737          	lui	a4,0x2004
    8000561c:	97ba                	add	a5,a5,a4
    8000561e:	0200c737          	lui	a4,0x200c
    80005622:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005626:	000f4637          	lui	a2,0xf4
    8000562a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000562e:	95b2                	add	a1,a1,a2
    80005630:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005632:	00269713          	slli	a4,a3,0x2
    80005636:	9736                	add	a4,a4,a3
    80005638:	00371693          	slli	a3,a4,0x3
    8000563c:	00019717          	auipc	a4,0x19
    80005640:	9c470713          	addi	a4,a4,-1596 # 8001e000 <timer_scratch>
    80005644:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005646:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005648:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000564a:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000564e:	00000797          	auipc	a5,0x0
    80005652:	97278793          	addi	a5,a5,-1678 # 80004fc0 <timervec>
    80005656:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000565a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000565e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005662:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005666:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000566a:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000566e:	30479073          	csrw	mie,a5
}
    80005672:	6422                	ld	s0,8(sp)
    80005674:	0141                	addi	sp,sp,16
    80005676:	8082                	ret

0000000080005678 <start>:
{
    80005678:	1141                	addi	sp,sp,-16
    8000567a:	e406                	sd	ra,8(sp)
    8000567c:	e022                	sd	s0,0(sp)
    8000567e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005680:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005684:	7779                	lui	a4,0xffffe
    80005686:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    8000568a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000568c:	6705                	lui	a4,0x1
    8000568e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005692:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005694:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005698:	ffffb797          	auipc	a5,0xffffb
    8000569c:	c8e78793          	addi	a5,a5,-882 # 80000326 <main>
    800056a0:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800056a4:	4781                	li	a5,0
    800056a6:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800056aa:	67c1                	lui	a5,0x10
    800056ac:	17fd                	addi	a5,a5,-1
    800056ae:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800056b2:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800056b6:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800056ba:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800056be:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800056c2:	57fd                	li	a5,-1
    800056c4:	83a9                	srli	a5,a5,0xa
    800056c6:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800056ca:	47bd                	li	a5,15
    800056cc:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800056d0:	00000097          	auipc	ra,0x0
    800056d4:	f36080e7          	jalr	-202(ra) # 80005606 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800056d8:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800056dc:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800056de:	823e                	mv	tp,a5
  asm volatile("mret");
    800056e0:	30200073          	mret
}
    800056e4:	60a2                	ld	ra,8(sp)
    800056e6:	6402                	ld	s0,0(sp)
    800056e8:	0141                	addi	sp,sp,16
    800056ea:	8082                	ret

00000000800056ec <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800056ec:	715d                	addi	sp,sp,-80
    800056ee:	e486                	sd	ra,72(sp)
    800056f0:	e0a2                	sd	s0,64(sp)
    800056f2:	fc26                	sd	s1,56(sp)
    800056f4:	f84a                	sd	s2,48(sp)
    800056f6:	f44e                	sd	s3,40(sp)
    800056f8:	f052                	sd	s4,32(sp)
    800056fa:	ec56                	sd	s5,24(sp)
    800056fc:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800056fe:	04c05663          	blez	a2,8000574a <consolewrite+0x5e>
    80005702:	8a2a                	mv	s4,a0
    80005704:	84ae                	mv	s1,a1
    80005706:	89b2                	mv	s3,a2
    80005708:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000570a:	5afd                	li	s5,-1
    8000570c:	4685                	li	a3,1
    8000570e:	8626                	mv	a2,s1
    80005710:	85d2                	mv	a1,s4
    80005712:	fbf40513          	addi	a0,s0,-65
    80005716:	ffffc097          	auipc	ra,0xffffc
    8000571a:	1e4080e7          	jalr	484(ra) # 800018fa <either_copyin>
    8000571e:	01550c63          	beq	a0,s5,80005736 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005722:	fbf44503          	lbu	a0,-65(s0)
    80005726:	00000097          	auipc	ra,0x0
    8000572a:	78e080e7          	jalr	1934(ra) # 80005eb4 <uartputc>
  for(i = 0; i < n; i++){
    8000572e:	2905                	addiw	s2,s2,1
    80005730:	0485                	addi	s1,s1,1
    80005732:	fd299de3          	bne	s3,s2,8000570c <consolewrite+0x20>
  }

  return i;
}
    80005736:	854a                	mv	a0,s2
    80005738:	60a6                	ld	ra,72(sp)
    8000573a:	6406                	ld	s0,64(sp)
    8000573c:	74e2                	ld	s1,56(sp)
    8000573e:	7942                	ld	s2,48(sp)
    80005740:	79a2                	ld	s3,40(sp)
    80005742:	7a02                	ld	s4,32(sp)
    80005744:	6ae2                	ld	s5,24(sp)
    80005746:	6161                	addi	sp,sp,80
    80005748:	8082                	ret
  for(i = 0; i < n; i++){
    8000574a:	4901                	li	s2,0
    8000574c:	b7ed                	j	80005736 <consolewrite+0x4a>

000000008000574e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000574e:	7119                	addi	sp,sp,-128
    80005750:	fc86                	sd	ra,120(sp)
    80005752:	f8a2                	sd	s0,112(sp)
    80005754:	f4a6                	sd	s1,104(sp)
    80005756:	f0ca                	sd	s2,96(sp)
    80005758:	ecce                	sd	s3,88(sp)
    8000575a:	e8d2                	sd	s4,80(sp)
    8000575c:	e4d6                	sd	s5,72(sp)
    8000575e:	e0da                	sd	s6,64(sp)
    80005760:	fc5e                	sd	s7,56(sp)
    80005762:	f862                	sd	s8,48(sp)
    80005764:	f466                	sd	s9,40(sp)
    80005766:	f06a                	sd	s10,32(sp)
    80005768:	ec6e                	sd	s11,24(sp)
    8000576a:	0100                	addi	s0,sp,128
    8000576c:	8b2a                	mv	s6,a0
    8000576e:	8aae                	mv	s5,a1
    80005770:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005772:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005776:	00021517          	auipc	a0,0x21
    8000577a:	9ca50513          	addi	a0,a0,-1590 # 80026140 <cons>
    8000577e:	00001097          	auipc	ra,0x1
    80005782:	8f4080e7          	jalr	-1804(ra) # 80006072 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005786:	00021497          	auipc	s1,0x21
    8000578a:	9ba48493          	addi	s1,s1,-1606 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000578e:	89a6                	mv	s3,s1
    80005790:	00021917          	auipc	s2,0x21
    80005794:	a4890913          	addi	s2,s2,-1464 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005798:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000579a:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    8000579c:	4da9                	li	s11,10
  while(n > 0){
    8000579e:	07405863          	blez	s4,8000580e <consoleread+0xc0>
    while(cons.r == cons.w){
    800057a2:	0984a783          	lw	a5,152(s1)
    800057a6:	09c4a703          	lw	a4,156(s1)
    800057aa:	02f71463          	bne	a4,a5,800057d2 <consoleread+0x84>
      if(myproc()->killed){
    800057ae:	ffffb097          	auipc	ra,0xffffb
    800057b2:	696080e7          	jalr	1686(ra) # 80000e44 <myproc>
    800057b6:	551c                	lw	a5,40(a0)
    800057b8:	e7b5                	bnez	a5,80005824 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    800057ba:	85ce                	mv	a1,s3
    800057bc:	854a                	mv	a0,s2
    800057be:	ffffc097          	auipc	ra,0xffffc
    800057c2:	d42080e7          	jalr	-702(ra) # 80001500 <sleep>
    while(cons.r == cons.w){
    800057c6:	0984a783          	lw	a5,152(s1)
    800057ca:	09c4a703          	lw	a4,156(s1)
    800057ce:	fef700e3          	beq	a4,a5,800057ae <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800057d2:	0017871b          	addiw	a4,a5,1
    800057d6:	08e4ac23          	sw	a4,152(s1)
    800057da:	07f7f713          	andi	a4,a5,127
    800057de:	9726                	add	a4,a4,s1
    800057e0:	01874703          	lbu	a4,24(a4)
    800057e4:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    800057e8:	079c0663          	beq	s8,s9,80005854 <consoleread+0x106>
    cbuf = c;
    800057ec:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800057f0:	4685                	li	a3,1
    800057f2:	f8f40613          	addi	a2,s0,-113
    800057f6:	85d6                	mv	a1,s5
    800057f8:	855a                	mv	a0,s6
    800057fa:	ffffc097          	auipc	ra,0xffffc
    800057fe:	0aa080e7          	jalr	170(ra) # 800018a4 <either_copyout>
    80005802:	01a50663          	beq	a0,s10,8000580e <consoleread+0xc0>
    dst++;
    80005806:	0a85                	addi	s5,s5,1
    --n;
    80005808:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    8000580a:	f9bc1ae3          	bne	s8,s11,8000579e <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    8000580e:	00021517          	auipc	a0,0x21
    80005812:	93250513          	addi	a0,a0,-1742 # 80026140 <cons>
    80005816:	00001097          	auipc	ra,0x1
    8000581a:	910080e7          	jalr	-1776(ra) # 80006126 <release>

  return target - n;
    8000581e:	414b853b          	subw	a0,s7,s4
    80005822:	a811                	j	80005836 <consoleread+0xe8>
        release(&cons.lock);
    80005824:	00021517          	auipc	a0,0x21
    80005828:	91c50513          	addi	a0,a0,-1764 # 80026140 <cons>
    8000582c:	00001097          	auipc	ra,0x1
    80005830:	8fa080e7          	jalr	-1798(ra) # 80006126 <release>
        return -1;
    80005834:	557d                	li	a0,-1
}
    80005836:	70e6                	ld	ra,120(sp)
    80005838:	7446                	ld	s0,112(sp)
    8000583a:	74a6                	ld	s1,104(sp)
    8000583c:	7906                	ld	s2,96(sp)
    8000583e:	69e6                	ld	s3,88(sp)
    80005840:	6a46                	ld	s4,80(sp)
    80005842:	6aa6                	ld	s5,72(sp)
    80005844:	6b06                	ld	s6,64(sp)
    80005846:	7be2                	ld	s7,56(sp)
    80005848:	7c42                	ld	s8,48(sp)
    8000584a:	7ca2                	ld	s9,40(sp)
    8000584c:	7d02                	ld	s10,32(sp)
    8000584e:	6de2                	ld	s11,24(sp)
    80005850:	6109                	addi	sp,sp,128
    80005852:	8082                	ret
      if(n < target){
    80005854:	000a071b          	sext.w	a4,s4
    80005858:	fb777be3          	bgeu	a4,s7,8000580e <consoleread+0xc0>
        cons.r--;
    8000585c:	00021717          	auipc	a4,0x21
    80005860:	96f72e23          	sw	a5,-1668(a4) # 800261d8 <cons+0x98>
    80005864:	b76d                	j	8000580e <consoleread+0xc0>

0000000080005866 <consputc>:
{
    80005866:	1141                	addi	sp,sp,-16
    80005868:	e406                	sd	ra,8(sp)
    8000586a:	e022                	sd	s0,0(sp)
    8000586c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000586e:	10000793          	li	a5,256
    80005872:	00f50a63          	beq	a0,a5,80005886 <consputc+0x20>
    uartputc_sync(c);
    80005876:	00000097          	auipc	ra,0x0
    8000587a:	564080e7          	jalr	1380(ra) # 80005dda <uartputc_sync>
}
    8000587e:	60a2                	ld	ra,8(sp)
    80005880:	6402                	ld	s0,0(sp)
    80005882:	0141                	addi	sp,sp,16
    80005884:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005886:	4521                	li	a0,8
    80005888:	00000097          	auipc	ra,0x0
    8000588c:	552080e7          	jalr	1362(ra) # 80005dda <uartputc_sync>
    80005890:	02000513          	li	a0,32
    80005894:	00000097          	auipc	ra,0x0
    80005898:	546080e7          	jalr	1350(ra) # 80005dda <uartputc_sync>
    8000589c:	4521                	li	a0,8
    8000589e:	00000097          	auipc	ra,0x0
    800058a2:	53c080e7          	jalr	1340(ra) # 80005dda <uartputc_sync>
    800058a6:	bfe1                	j	8000587e <consputc+0x18>

00000000800058a8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800058a8:	1101                	addi	sp,sp,-32
    800058aa:	ec06                	sd	ra,24(sp)
    800058ac:	e822                	sd	s0,16(sp)
    800058ae:	e426                	sd	s1,8(sp)
    800058b0:	e04a                	sd	s2,0(sp)
    800058b2:	1000                	addi	s0,sp,32
    800058b4:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800058b6:	00021517          	auipc	a0,0x21
    800058ba:	88a50513          	addi	a0,a0,-1910 # 80026140 <cons>
    800058be:	00000097          	auipc	ra,0x0
    800058c2:	7b4080e7          	jalr	1972(ra) # 80006072 <acquire>

  switch(c){
    800058c6:	47d5                	li	a5,21
    800058c8:	0af48663          	beq	s1,a5,80005974 <consoleintr+0xcc>
    800058cc:	0297ca63          	blt	a5,s1,80005900 <consoleintr+0x58>
    800058d0:	47a1                	li	a5,8
    800058d2:	0ef48763          	beq	s1,a5,800059c0 <consoleintr+0x118>
    800058d6:	47c1                	li	a5,16
    800058d8:	10f49a63          	bne	s1,a5,800059ec <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800058dc:	ffffc097          	auipc	ra,0xffffc
    800058e0:	074080e7          	jalr	116(ra) # 80001950 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800058e4:	00021517          	auipc	a0,0x21
    800058e8:	85c50513          	addi	a0,a0,-1956 # 80026140 <cons>
    800058ec:	00001097          	auipc	ra,0x1
    800058f0:	83a080e7          	jalr	-1990(ra) # 80006126 <release>
}
    800058f4:	60e2                	ld	ra,24(sp)
    800058f6:	6442                	ld	s0,16(sp)
    800058f8:	64a2                	ld	s1,8(sp)
    800058fa:	6902                	ld	s2,0(sp)
    800058fc:	6105                	addi	sp,sp,32
    800058fe:	8082                	ret
  switch(c){
    80005900:	07f00793          	li	a5,127
    80005904:	0af48e63          	beq	s1,a5,800059c0 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005908:	00021717          	auipc	a4,0x21
    8000590c:	83870713          	addi	a4,a4,-1992 # 80026140 <cons>
    80005910:	0a072783          	lw	a5,160(a4)
    80005914:	09872703          	lw	a4,152(a4)
    80005918:	9f99                	subw	a5,a5,a4
    8000591a:	07f00713          	li	a4,127
    8000591e:	fcf763e3          	bltu	a4,a5,800058e4 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005922:	47b5                	li	a5,13
    80005924:	0cf48763          	beq	s1,a5,800059f2 <consoleintr+0x14a>
      consputc(c);
    80005928:	8526                	mv	a0,s1
    8000592a:	00000097          	auipc	ra,0x0
    8000592e:	f3c080e7          	jalr	-196(ra) # 80005866 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005932:	00021797          	auipc	a5,0x21
    80005936:	80e78793          	addi	a5,a5,-2034 # 80026140 <cons>
    8000593a:	0a07a703          	lw	a4,160(a5)
    8000593e:	0017069b          	addiw	a3,a4,1
    80005942:	0006861b          	sext.w	a2,a3
    80005946:	0ad7a023          	sw	a3,160(a5)
    8000594a:	07f77713          	andi	a4,a4,127
    8000594e:	97ba                	add	a5,a5,a4
    80005950:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005954:	47a9                	li	a5,10
    80005956:	0cf48563          	beq	s1,a5,80005a20 <consoleintr+0x178>
    8000595a:	4791                	li	a5,4
    8000595c:	0cf48263          	beq	s1,a5,80005a20 <consoleintr+0x178>
    80005960:	00021797          	auipc	a5,0x21
    80005964:	8787a783          	lw	a5,-1928(a5) # 800261d8 <cons+0x98>
    80005968:	0807879b          	addiw	a5,a5,128
    8000596c:	f6f61ce3          	bne	a2,a5,800058e4 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005970:	863e                	mv	a2,a5
    80005972:	a07d                	j	80005a20 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005974:	00020717          	auipc	a4,0x20
    80005978:	7cc70713          	addi	a4,a4,1996 # 80026140 <cons>
    8000597c:	0a072783          	lw	a5,160(a4)
    80005980:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005984:	00020497          	auipc	s1,0x20
    80005988:	7bc48493          	addi	s1,s1,1980 # 80026140 <cons>
    while(cons.e != cons.w &&
    8000598c:	4929                	li	s2,10
    8000598e:	f4f70be3          	beq	a4,a5,800058e4 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005992:	37fd                	addiw	a5,a5,-1
    80005994:	07f7f713          	andi	a4,a5,127
    80005998:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    8000599a:	01874703          	lbu	a4,24(a4)
    8000599e:	f52703e3          	beq	a4,s2,800058e4 <consoleintr+0x3c>
      cons.e--;
    800059a2:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800059a6:	10000513          	li	a0,256
    800059aa:	00000097          	auipc	ra,0x0
    800059ae:	ebc080e7          	jalr	-324(ra) # 80005866 <consputc>
    while(cons.e != cons.w &&
    800059b2:	0a04a783          	lw	a5,160(s1)
    800059b6:	09c4a703          	lw	a4,156(s1)
    800059ba:	fcf71ce3          	bne	a4,a5,80005992 <consoleintr+0xea>
    800059be:	b71d                	j	800058e4 <consoleintr+0x3c>
    if(cons.e != cons.w){
    800059c0:	00020717          	auipc	a4,0x20
    800059c4:	78070713          	addi	a4,a4,1920 # 80026140 <cons>
    800059c8:	0a072783          	lw	a5,160(a4)
    800059cc:	09c72703          	lw	a4,156(a4)
    800059d0:	f0f70ae3          	beq	a4,a5,800058e4 <consoleintr+0x3c>
      cons.e--;
    800059d4:	37fd                	addiw	a5,a5,-1
    800059d6:	00021717          	auipc	a4,0x21
    800059da:	80f72523          	sw	a5,-2038(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    800059de:	10000513          	li	a0,256
    800059e2:	00000097          	auipc	ra,0x0
    800059e6:	e84080e7          	jalr	-380(ra) # 80005866 <consputc>
    800059ea:	bded                	j	800058e4 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    800059ec:	ee048ce3          	beqz	s1,800058e4 <consoleintr+0x3c>
    800059f0:	bf21                	j	80005908 <consoleintr+0x60>
      consputc(c);
    800059f2:	4529                	li	a0,10
    800059f4:	00000097          	auipc	ra,0x0
    800059f8:	e72080e7          	jalr	-398(ra) # 80005866 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    800059fc:	00020797          	auipc	a5,0x20
    80005a00:	74478793          	addi	a5,a5,1860 # 80026140 <cons>
    80005a04:	0a07a703          	lw	a4,160(a5)
    80005a08:	0017069b          	addiw	a3,a4,1
    80005a0c:	0006861b          	sext.w	a2,a3
    80005a10:	0ad7a023          	sw	a3,160(a5)
    80005a14:	07f77713          	andi	a4,a4,127
    80005a18:	97ba                	add	a5,a5,a4
    80005a1a:	4729                	li	a4,10
    80005a1c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005a20:	00020797          	auipc	a5,0x20
    80005a24:	7ac7ae23          	sw	a2,1980(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005a28:	00020517          	auipc	a0,0x20
    80005a2c:	7b050513          	addi	a0,a0,1968 # 800261d8 <cons+0x98>
    80005a30:	ffffc097          	auipc	ra,0xffffc
    80005a34:	c5c080e7          	jalr	-932(ra) # 8000168c <wakeup>
    80005a38:	b575                	j	800058e4 <consoleintr+0x3c>

0000000080005a3a <consoleinit>:

void
consoleinit(void)
{
    80005a3a:	1141                	addi	sp,sp,-16
    80005a3c:	e406                	sd	ra,8(sp)
    80005a3e:	e022                	sd	s0,0(sp)
    80005a40:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005a42:	00003597          	auipc	a1,0x3
    80005a46:	d9658593          	addi	a1,a1,-618 # 800087d8 <syscalls+0x410>
    80005a4a:	00020517          	auipc	a0,0x20
    80005a4e:	6f650513          	addi	a0,a0,1782 # 80026140 <cons>
    80005a52:	00000097          	auipc	ra,0x0
    80005a56:	590080e7          	jalr	1424(ra) # 80005fe2 <initlock>

  uartinit();
    80005a5a:	00000097          	auipc	ra,0x0
    80005a5e:	330080e7          	jalr	816(ra) # 80005d8a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005a62:	00013797          	auipc	a5,0x13
    80005a66:	66678793          	addi	a5,a5,1638 # 800190c8 <devsw>
    80005a6a:	00000717          	auipc	a4,0x0
    80005a6e:	ce470713          	addi	a4,a4,-796 # 8000574e <consoleread>
    80005a72:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005a74:	00000717          	auipc	a4,0x0
    80005a78:	c7870713          	addi	a4,a4,-904 # 800056ec <consolewrite>
    80005a7c:	ef98                	sd	a4,24(a5)
}
    80005a7e:	60a2                	ld	ra,8(sp)
    80005a80:	6402                	ld	s0,0(sp)
    80005a82:	0141                	addi	sp,sp,16
    80005a84:	8082                	ret

0000000080005a86 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005a86:	7179                	addi	sp,sp,-48
    80005a88:	f406                	sd	ra,40(sp)
    80005a8a:	f022                	sd	s0,32(sp)
    80005a8c:	ec26                	sd	s1,24(sp)
    80005a8e:	e84a                	sd	s2,16(sp)
    80005a90:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005a92:	c219                	beqz	a2,80005a98 <printint+0x12>
    80005a94:	08054663          	bltz	a0,80005b20 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005a98:	2501                	sext.w	a0,a0
    80005a9a:	4881                	li	a7,0
    80005a9c:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005aa0:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005aa2:	2581                	sext.w	a1,a1
    80005aa4:	00003617          	auipc	a2,0x3
    80005aa8:	d6460613          	addi	a2,a2,-668 # 80008808 <digits>
    80005aac:	883a                	mv	a6,a4
    80005aae:	2705                	addiw	a4,a4,1
    80005ab0:	02b577bb          	remuw	a5,a0,a1
    80005ab4:	1782                	slli	a5,a5,0x20
    80005ab6:	9381                	srli	a5,a5,0x20
    80005ab8:	97b2                	add	a5,a5,a2
    80005aba:	0007c783          	lbu	a5,0(a5)
    80005abe:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005ac2:	0005079b          	sext.w	a5,a0
    80005ac6:	02b5553b          	divuw	a0,a0,a1
    80005aca:	0685                	addi	a3,a3,1
    80005acc:	feb7f0e3          	bgeu	a5,a1,80005aac <printint+0x26>

  if(sign)
    80005ad0:	00088b63          	beqz	a7,80005ae6 <printint+0x60>
    buf[i++] = '-';
    80005ad4:	fe040793          	addi	a5,s0,-32
    80005ad8:	973e                	add	a4,a4,a5
    80005ada:	02d00793          	li	a5,45
    80005ade:	fef70823          	sb	a5,-16(a4)
    80005ae2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005ae6:	02e05763          	blez	a4,80005b14 <printint+0x8e>
    80005aea:	fd040793          	addi	a5,s0,-48
    80005aee:	00e784b3          	add	s1,a5,a4
    80005af2:	fff78913          	addi	s2,a5,-1
    80005af6:	993a                	add	s2,s2,a4
    80005af8:	377d                	addiw	a4,a4,-1
    80005afa:	1702                	slli	a4,a4,0x20
    80005afc:	9301                	srli	a4,a4,0x20
    80005afe:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005b02:	fff4c503          	lbu	a0,-1(s1)
    80005b06:	00000097          	auipc	ra,0x0
    80005b0a:	d60080e7          	jalr	-672(ra) # 80005866 <consputc>
  while(--i >= 0)
    80005b0e:	14fd                	addi	s1,s1,-1
    80005b10:	ff2499e3          	bne	s1,s2,80005b02 <printint+0x7c>
}
    80005b14:	70a2                	ld	ra,40(sp)
    80005b16:	7402                	ld	s0,32(sp)
    80005b18:	64e2                	ld	s1,24(sp)
    80005b1a:	6942                	ld	s2,16(sp)
    80005b1c:	6145                	addi	sp,sp,48
    80005b1e:	8082                	ret
    x = -xx;
    80005b20:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005b24:	4885                	li	a7,1
    x = -xx;
    80005b26:	bf9d                	j	80005a9c <printint+0x16>

0000000080005b28 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005b28:	1101                	addi	sp,sp,-32
    80005b2a:	ec06                	sd	ra,24(sp)
    80005b2c:	e822                	sd	s0,16(sp)
    80005b2e:	e426                	sd	s1,8(sp)
    80005b30:	1000                	addi	s0,sp,32
    80005b32:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005b34:	00020797          	auipc	a5,0x20
    80005b38:	6c07a623          	sw	zero,1740(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005b3c:	00003517          	auipc	a0,0x3
    80005b40:	ca450513          	addi	a0,a0,-860 # 800087e0 <syscalls+0x418>
    80005b44:	00000097          	auipc	ra,0x0
    80005b48:	02e080e7          	jalr	46(ra) # 80005b72 <printf>
  printf(s);
    80005b4c:	8526                	mv	a0,s1
    80005b4e:	00000097          	auipc	ra,0x0
    80005b52:	024080e7          	jalr	36(ra) # 80005b72 <printf>
  printf("\n");
    80005b56:	00002517          	auipc	a0,0x2
    80005b5a:	4f250513          	addi	a0,a0,1266 # 80008048 <etext+0x48>
    80005b5e:	00000097          	auipc	ra,0x0
    80005b62:	014080e7          	jalr	20(ra) # 80005b72 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005b66:	4785                	li	a5,1
    80005b68:	00003717          	auipc	a4,0x3
    80005b6c:	4af72a23          	sw	a5,1204(a4) # 8000901c <panicked>
  for(;;)
    80005b70:	a001                	j	80005b70 <panic+0x48>

0000000080005b72 <printf>:
{
    80005b72:	7131                	addi	sp,sp,-192
    80005b74:	fc86                	sd	ra,120(sp)
    80005b76:	f8a2                	sd	s0,112(sp)
    80005b78:	f4a6                	sd	s1,104(sp)
    80005b7a:	f0ca                	sd	s2,96(sp)
    80005b7c:	ecce                	sd	s3,88(sp)
    80005b7e:	e8d2                	sd	s4,80(sp)
    80005b80:	e4d6                	sd	s5,72(sp)
    80005b82:	e0da                	sd	s6,64(sp)
    80005b84:	fc5e                	sd	s7,56(sp)
    80005b86:	f862                	sd	s8,48(sp)
    80005b88:	f466                	sd	s9,40(sp)
    80005b8a:	f06a                	sd	s10,32(sp)
    80005b8c:	ec6e                	sd	s11,24(sp)
    80005b8e:	0100                	addi	s0,sp,128
    80005b90:	8a2a                	mv	s4,a0
    80005b92:	e40c                	sd	a1,8(s0)
    80005b94:	e810                	sd	a2,16(s0)
    80005b96:	ec14                	sd	a3,24(s0)
    80005b98:	f018                	sd	a4,32(s0)
    80005b9a:	f41c                	sd	a5,40(s0)
    80005b9c:	03043823          	sd	a6,48(s0)
    80005ba0:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005ba4:	00020d97          	auipc	s11,0x20
    80005ba8:	65cdad83          	lw	s11,1628(s11) # 80026200 <pr+0x18>
  if(locking)
    80005bac:	020d9b63          	bnez	s11,80005be2 <printf+0x70>
  if (fmt == 0)
    80005bb0:	040a0263          	beqz	s4,80005bf4 <printf+0x82>
  va_start(ap, fmt);
    80005bb4:	00840793          	addi	a5,s0,8
    80005bb8:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005bbc:	000a4503          	lbu	a0,0(s4)
    80005bc0:	16050263          	beqz	a0,80005d24 <printf+0x1b2>
    80005bc4:	4481                	li	s1,0
    if(c != '%'){
    80005bc6:	02500a93          	li	s5,37
    switch(c){
    80005bca:	07000b13          	li	s6,112
  consputc('x');
    80005bce:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005bd0:	00003b97          	auipc	s7,0x3
    80005bd4:	c38b8b93          	addi	s7,s7,-968 # 80008808 <digits>
    switch(c){
    80005bd8:	07300c93          	li	s9,115
    80005bdc:	06400c13          	li	s8,100
    80005be0:	a82d                	j	80005c1a <printf+0xa8>
    acquire(&pr.lock);
    80005be2:	00020517          	auipc	a0,0x20
    80005be6:	60650513          	addi	a0,a0,1542 # 800261e8 <pr>
    80005bea:	00000097          	auipc	ra,0x0
    80005bee:	488080e7          	jalr	1160(ra) # 80006072 <acquire>
    80005bf2:	bf7d                	j	80005bb0 <printf+0x3e>
    panic("null fmt");
    80005bf4:	00003517          	auipc	a0,0x3
    80005bf8:	bfc50513          	addi	a0,a0,-1028 # 800087f0 <syscalls+0x428>
    80005bfc:	00000097          	auipc	ra,0x0
    80005c00:	f2c080e7          	jalr	-212(ra) # 80005b28 <panic>
      consputc(c);
    80005c04:	00000097          	auipc	ra,0x0
    80005c08:	c62080e7          	jalr	-926(ra) # 80005866 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005c0c:	2485                	addiw	s1,s1,1
    80005c0e:	009a07b3          	add	a5,s4,s1
    80005c12:	0007c503          	lbu	a0,0(a5)
    80005c16:	10050763          	beqz	a0,80005d24 <printf+0x1b2>
    if(c != '%'){
    80005c1a:	ff5515e3          	bne	a0,s5,80005c04 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005c1e:	2485                	addiw	s1,s1,1
    80005c20:	009a07b3          	add	a5,s4,s1
    80005c24:	0007c783          	lbu	a5,0(a5)
    80005c28:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005c2c:	cfe5                	beqz	a5,80005d24 <printf+0x1b2>
    switch(c){
    80005c2e:	05678a63          	beq	a5,s6,80005c82 <printf+0x110>
    80005c32:	02fb7663          	bgeu	s6,a5,80005c5e <printf+0xec>
    80005c36:	09978963          	beq	a5,s9,80005cc8 <printf+0x156>
    80005c3a:	07800713          	li	a4,120
    80005c3e:	0ce79863          	bne	a5,a4,80005d0e <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005c42:	f8843783          	ld	a5,-120(s0)
    80005c46:	00878713          	addi	a4,a5,8
    80005c4a:	f8e43423          	sd	a4,-120(s0)
    80005c4e:	4605                	li	a2,1
    80005c50:	85ea                	mv	a1,s10
    80005c52:	4388                	lw	a0,0(a5)
    80005c54:	00000097          	auipc	ra,0x0
    80005c58:	e32080e7          	jalr	-462(ra) # 80005a86 <printint>
      break;
    80005c5c:	bf45                	j	80005c0c <printf+0x9a>
    switch(c){
    80005c5e:	0b578263          	beq	a5,s5,80005d02 <printf+0x190>
    80005c62:	0b879663          	bne	a5,s8,80005d0e <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005c66:	f8843783          	ld	a5,-120(s0)
    80005c6a:	00878713          	addi	a4,a5,8
    80005c6e:	f8e43423          	sd	a4,-120(s0)
    80005c72:	4605                	li	a2,1
    80005c74:	45a9                	li	a1,10
    80005c76:	4388                	lw	a0,0(a5)
    80005c78:	00000097          	auipc	ra,0x0
    80005c7c:	e0e080e7          	jalr	-498(ra) # 80005a86 <printint>
      break;
    80005c80:	b771                	j	80005c0c <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005c82:	f8843783          	ld	a5,-120(s0)
    80005c86:	00878713          	addi	a4,a5,8
    80005c8a:	f8e43423          	sd	a4,-120(s0)
    80005c8e:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005c92:	03000513          	li	a0,48
    80005c96:	00000097          	auipc	ra,0x0
    80005c9a:	bd0080e7          	jalr	-1072(ra) # 80005866 <consputc>
  consputc('x');
    80005c9e:	07800513          	li	a0,120
    80005ca2:	00000097          	auipc	ra,0x0
    80005ca6:	bc4080e7          	jalr	-1084(ra) # 80005866 <consputc>
    80005caa:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005cac:	03c9d793          	srli	a5,s3,0x3c
    80005cb0:	97de                	add	a5,a5,s7
    80005cb2:	0007c503          	lbu	a0,0(a5)
    80005cb6:	00000097          	auipc	ra,0x0
    80005cba:	bb0080e7          	jalr	-1104(ra) # 80005866 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005cbe:	0992                	slli	s3,s3,0x4
    80005cc0:	397d                	addiw	s2,s2,-1
    80005cc2:	fe0915e3          	bnez	s2,80005cac <printf+0x13a>
    80005cc6:	b799                	j	80005c0c <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005cc8:	f8843783          	ld	a5,-120(s0)
    80005ccc:	00878713          	addi	a4,a5,8
    80005cd0:	f8e43423          	sd	a4,-120(s0)
    80005cd4:	0007b903          	ld	s2,0(a5)
    80005cd8:	00090e63          	beqz	s2,80005cf4 <printf+0x182>
      for(; *s; s++)
    80005cdc:	00094503          	lbu	a0,0(s2)
    80005ce0:	d515                	beqz	a0,80005c0c <printf+0x9a>
        consputc(*s);
    80005ce2:	00000097          	auipc	ra,0x0
    80005ce6:	b84080e7          	jalr	-1148(ra) # 80005866 <consputc>
      for(; *s; s++)
    80005cea:	0905                	addi	s2,s2,1
    80005cec:	00094503          	lbu	a0,0(s2)
    80005cf0:	f96d                	bnez	a0,80005ce2 <printf+0x170>
    80005cf2:	bf29                	j	80005c0c <printf+0x9a>
        s = "(null)";
    80005cf4:	00003917          	auipc	s2,0x3
    80005cf8:	af490913          	addi	s2,s2,-1292 # 800087e8 <syscalls+0x420>
      for(; *s; s++)
    80005cfc:	02800513          	li	a0,40
    80005d00:	b7cd                	j	80005ce2 <printf+0x170>
      consputc('%');
    80005d02:	8556                	mv	a0,s5
    80005d04:	00000097          	auipc	ra,0x0
    80005d08:	b62080e7          	jalr	-1182(ra) # 80005866 <consputc>
      break;
    80005d0c:	b701                	j	80005c0c <printf+0x9a>
      consputc('%');
    80005d0e:	8556                	mv	a0,s5
    80005d10:	00000097          	auipc	ra,0x0
    80005d14:	b56080e7          	jalr	-1194(ra) # 80005866 <consputc>
      consputc(c);
    80005d18:	854a                	mv	a0,s2
    80005d1a:	00000097          	auipc	ra,0x0
    80005d1e:	b4c080e7          	jalr	-1204(ra) # 80005866 <consputc>
      break;
    80005d22:	b5ed                	j	80005c0c <printf+0x9a>
  if(locking)
    80005d24:	020d9163          	bnez	s11,80005d46 <printf+0x1d4>
}
    80005d28:	70e6                	ld	ra,120(sp)
    80005d2a:	7446                	ld	s0,112(sp)
    80005d2c:	74a6                	ld	s1,104(sp)
    80005d2e:	7906                	ld	s2,96(sp)
    80005d30:	69e6                	ld	s3,88(sp)
    80005d32:	6a46                	ld	s4,80(sp)
    80005d34:	6aa6                	ld	s5,72(sp)
    80005d36:	6b06                	ld	s6,64(sp)
    80005d38:	7be2                	ld	s7,56(sp)
    80005d3a:	7c42                	ld	s8,48(sp)
    80005d3c:	7ca2                	ld	s9,40(sp)
    80005d3e:	7d02                	ld	s10,32(sp)
    80005d40:	6de2                	ld	s11,24(sp)
    80005d42:	6129                	addi	sp,sp,192
    80005d44:	8082                	ret
    release(&pr.lock);
    80005d46:	00020517          	auipc	a0,0x20
    80005d4a:	4a250513          	addi	a0,a0,1186 # 800261e8 <pr>
    80005d4e:	00000097          	auipc	ra,0x0
    80005d52:	3d8080e7          	jalr	984(ra) # 80006126 <release>
}
    80005d56:	bfc9                	j	80005d28 <printf+0x1b6>

0000000080005d58 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005d58:	1101                	addi	sp,sp,-32
    80005d5a:	ec06                	sd	ra,24(sp)
    80005d5c:	e822                	sd	s0,16(sp)
    80005d5e:	e426                	sd	s1,8(sp)
    80005d60:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005d62:	00020497          	auipc	s1,0x20
    80005d66:	48648493          	addi	s1,s1,1158 # 800261e8 <pr>
    80005d6a:	00003597          	auipc	a1,0x3
    80005d6e:	a9658593          	addi	a1,a1,-1386 # 80008800 <syscalls+0x438>
    80005d72:	8526                	mv	a0,s1
    80005d74:	00000097          	auipc	ra,0x0
    80005d78:	26e080e7          	jalr	622(ra) # 80005fe2 <initlock>
  pr.locking = 1;
    80005d7c:	4785                	li	a5,1
    80005d7e:	cc9c                	sw	a5,24(s1)
}
    80005d80:	60e2                	ld	ra,24(sp)
    80005d82:	6442                	ld	s0,16(sp)
    80005d84:	64a2                	ld	s1,8(sp)
    80005d86:	6105                	addi	sp,sp,32
    80005d88:	8082                	ret

0000000080005d8a <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005d8a:	1141                	addi	sp,sp,-16
    80005d8c:	e406                	sd	ra,8(sp)
    80005d8e:	e022                	sd	s0,0(sp)
    80005d90:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005d92:	100007b7          	lui	a5,0x10000
    80005d96:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005d9a:	f8000713          	li	a4,-128
    80005d9e:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005da2:	470d                	li	a4,3
    80005da4:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005da8:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005dac:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005db0:	469d                	li	a3,7
    80005db2:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005db6:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005dba:	00003597          	auipc	a1,0x3
    80005dbe:	a6658593          	addi	a1,a1,-1434 # 80008820 <digits+0x18>
    80005dc2:	00020517          	auipc	a0,0x20
    80005dc6:	44650513          	addi	a0,a0,1094 # 80026208 <uart_tx_lock>
    80005dca:	00000097          	auipc	ra,0x0
    80005dce:	218080e7          	jalr	536(ra) # 80005fe2 <initlock>
}
    80005dd2:	60a2                	ld	ra,8(sp)
    80005dd4:	6402                	ld	s0,0(sp)
    80005dd6:	0141                	addi	sp,sp,16
    80005dd8:	8082                	ret

0000000080005dda <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005dda:	1101                	addi	sp,sp,-32
    80005ddc:	ec06                	sd	ra,24(sp)
    80005dde:	e822                	sd	s0,16(sp)
    80005de0:	e426                	sd	s1,8(sp)
    80005de2:	1000                	addi	s0,sp,32
    80005de4:	84aa                	mv	s1,a0
  push_off();
    80005de6:	00000097          	auipc	ra,0x0
    80005dea:	240080e7          	jalr	576(ra) # 80006026 <push_off>

  if(panicked){
    80005dee:	00003797          	auipc	a5,0x3
    80005df2:	22e7a783          	lw	a5,558(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005df6:	10000737          	lui	a4,0x10000
  if(panicked){
    80005dfa:	c391                	beqz	a5,80005dfe <uartputc_sync+0x24>
    for(;;)
    80005dfc:	a001                	j	80005dfc <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005dfe:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005e02:	0ff7f793          	andi	a5,a5,255
    80005e06:	0207f793          	andi	a5,a5,32
    80005e0a:	dbf5                	beqz	a5,80005dfe <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005e0c:	0ff4f793          	andi	a5,s1,255
    80005e10:	10000737          	lui	a4,0x10000
    80005e14:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80005e18:	00000097          	auipc	ra,0x0
    80005e1c:	2ae080e7          	jalr	686(ra) # 800060c6 <pop_off>
}
    80005e20:	60e2                	ld	ra,24(sp)
    80005e22:	6442                	ld	s0,16(sp)
    80005e24:	64a2                	ld	s1,8(sp)
    80005e26:	6105                	addi	sp,sp,32
    80005e28:	8082                	ret

0000000080005e2a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005e2a:	00003717          	auipc	a4,0x3
    80005e2e:	1f673703          	ld	a4,502(a4) # 80009020 <uart_tx_r>
    80005e32:	00003797          	auipc	a5,0x3
    80005e36:	1f67b783          	ld	a5,502(a5) # 80009028 <uart_tx_w>
    80005e3a:	06e78c63          	beq	a5,a4,80005eb2 <uartstart+0x88>
{
    80005e3e:	7139                	addi	sp,sp,-64
    80005e40:	fc06                	sd	ra,56(sp)
    80005e42:	f822                	sd	s0,48(sp)
    80005e44:	f426                	sd	s1,40(sp)
    80005e46:	f04a                	sd	s2,32(sp)
    80005e48:	ec4e                	sd	s3,24(sp)
    80005e4a:	e852                	sd	s4,16(sp)
    80005e4c:	e456                	sd	s5,8(sp)
    80005e4e:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005e50:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005e54:	00020a17          	auipc	s4,0x20
    80005e58:	3b4a0a13          	addi	s4,s4,948 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    80005e5c:	00003497          	auipc	s1,0x3
    80005e60:	1c448493          	addi	s1,s1,452 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005e64:	00003997          	auipc	s3,0x3
    80005e68:	1c498993          	addi	s3,s3,452 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005e6c:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005e70:	0ff7f793          	andi	a5,a5,255
    80005e74:	0207f793          	andi	a5,a5,32
    80005e78:	c785                	beqz	a5,80005ea0 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005e7a:	01f77793          	andi	a5,a4,31
    80005e7e:	97d2                	add	a5,a5,s4
    80005e80:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80005e84:	0705                	addi	a4,a4,1
    80005e86:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005e88:	8526                	mv	a0,s1
    80005e8a:	ffffc097          	auipc	ra,0xffffc
    80005e8e:	802080e7          	jalr	-2046(ra) # 8000168c <wakeup>
    
    WriteReg(THR, c);
    80005e92:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005e96:	6098                	ld	a4,0(s1)
    80005e98:	0009b783          	ld	a5,0(s3)
    80005e9c:	fce798e3          	bne	a5,a4,80005e6c <uartstart+0x42>
  }
}
    80005ea0:	70e2                	ld	ra,56(sp)
    80005ea2:	7442                	ld	s0,48(sp)
    80005ea4:	74a2                	ld	s1,40(sp)
    80005ea6:	7902                	ld	s2,32(sp)
    80005ea8:	69e2                	ld	s3,24(sp)
    80005eaa:	6a42                	ld	s4,16(sp)
    80005eac:	6aa2                	ld	s5,8(sp)
    80005eae:	6121                	addi	sp,sp,64
    80005eb0:	8082                	ret
    80005eb2:	8082                	ret

0000000080005eb4 <uartputc>:
{
    80005eb4:	7179                	addi	sp,sp,-48
    80005eb6:	f406                	sd	ra,40(sp)
    80005eb8:	f022                	sd	s0,32(sp)
    80005eba:	ec26                	sd	s1,24(sp)
    80005ebc:	e84a                	sd	s2,16(sp)
    80005ebe:	e44e                	sd	s3,8(sp)
    80005ec0:	e052                	sd	s4,0(sp)
    80005ec2:	1800                	addi	s0,sp,48
    80005ec4:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80005ec6:	00020517          	auipc	a0,0x20
    80005eca:	34250513          	addi	a0,a0,834 # 80026208 <uart_tx_lock>
    80005ece:	00000097          	auipc	ra,0x0
    80005ed2:	1a4080e7          	jalr	420(ra) # 80006072 <acquire>
  if(panicked){
    80005ed6:	00003797          	auipc	a5,0x3
    80005eda:	1467a783          	lw	a5,326(a5) # 8000901c <panicked>
    80005ede:	c391                	beqz	a5,80005ee2 <uartputc+0x2e>
    for(;;)
    80005ee0:	a001                	j	80005ee0 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005ee2:	00003797          	auipc	a5,0x3
    80005ee6:	1467b783          	ld	a5,326(a5) # 80009028 <uart_tx_w>
    80005eea:	00003717          	auipc	a4,0x3
    80005eee:	13673703          	ld	a4,310(a4) # 80009020 <uart_tx_r>
    80005ef2:	02070713          	addi	a4,a4,32
    80005ef6:	02f71b63          	bne	a4,a5,80005f2c <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    80005efa:	00020a17          	auipc	s4,0x20
    80005efe:	30ea0a13          	addi	s4,s4,782 # 80026208 <uart_tx_lock>
    80005f02:	00003497          	auipc	s1,0x3
    80005f06:	11e48493          	addi	s1,s1,286 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005f0a:	00003917          	auipc	s2,0x3
    80005f0e:	11e90913          	addi	s2,s2,286 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80005f12:	85d2                	mv	a1,s4
    80005f14:	8526                	mv	a0,s1
    80005f16:	ffffb097          	auipc	ra,0xffffb
    80005f1a:	5ea080e7          	jalr	1514(ra) # 80001500 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005f1e:	00093783          	ld	a5,0(s2)
    80005f22:	6098                	ld	a4,0(s1)
    80005f24:	02070713          	addi	a4,a4,32
    80005f28:	fef705e3          	beq	a4,a5,80005f12 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80005f2c:	00020497          	auipc	s1,0x20
    80005f30:	2dc48493          	addi	s1,s1,732 # 80026208 <uart_tx_lock>
    80005f34:	01f7f713          	andi	a4,a5,31
    80005f38:	9726                	add	a4,a4,s1
    80005f3a:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    80005f3e:	0785                	addi	a5,a5,1
    80005f40:	00003717          	auipc	a4,0x3
    80005f44:	0ef73423          	sd	a5,232(a4) # 80009028 <uart_tx_w>
      uartstart();
    80005f48:	00000097          	auipc	ra,0x0
    80005f4c:	ee2080e7          	jalr	-286(ra) # 80005e2a <uartstart>
      release(&uart_tx_lock);
    80005f50:	8526                	mv	a0,s1
    80005f52:	00000097          	auipc	ra,0x0
    80005f56:	1d4080e7          	jalr	468(ra) # 80006126 <release>
}
    80005f5a:	70a2                	ld	ra,40(sp)
    80005f5c:	7402                	ld	s0,32(sp)
    80005f5e:	64e2                	ld	s1,24(sp)
    80005f60:	6942                	ld	s2,16(sp)
    80005f62:	69a2                	ld	s3,8(sp)
    80005f64:	6a02                	ld	s4,0(sp)
    80005f66:	6145                	addi	sp,sp,48
    80005f68:	8082                	ret

0000000080005f6a <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80005f6a:	1141                	addi	sp,sp,-16
    80005f6c:	e422                	sd	s0,8(sp)
    80005f6e:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80005f70:	100007b7          	lui	a5,0x10000
    80005f74:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80005f78:	8b85                	andi	a5,a5,1
    80005f7a:	cb91                	beqz	a5,80005f8e <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80005f7c:	100007b7          	lui	a5,0x10000
    80005f80:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80005f84:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80005f88:	6422                	ld	s0,8(sp)
    80005f8a:	0141                	addi	sp,sp,16
    80005f8c:	8082                	ret
    return -1;
    80005f8e:	557d                	li	a0,-1
    80005f90:	bfe5                	j	80005f88 <uartgetc+0x1e>

0000000080005f92 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80005f92:	1101                	addi	sp,sp,-32
    80005f94:	ec06                	sd	ra,24(sp)
    80005f96:	e822                	sd	s0,16(sp)
    80005f98:	e426                	sd	s1,8(sp)
    80005f9a:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80005f9c:	54fd                	li	s1,-1
    int c = uartgetc();
    80005f9e:	00000097          	auipc	ra,0x0
    80005fa2:	fcc080e7          	jalr	-52(ra) # 80005f6a <uartgetc>
    if(c == -1)
    80005fa6:	00950763          	beq	a0,s1,80005fb4 <uartintr+0x22>
      break;
    consoleintr(c);
    80005faa:	00000097          	auipc	ra,0x0
    80005fae:	8fe080e7          	jalr	-1794(ra) # 800058a8 <consoleintr>
  while(1){
    80005fb2:	b7f5                	j	80005f9e <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80005fb4:	00020497          	auipc	s1,0x20
    80005fb8:	25448493          	addi	s1,s1,596 # 80026208 <uart_tx_lock>
    80005fbc:	8526                	mv	a0,s1
    80005fbe:	00000097          	auipc	ra,0x0
    80005fc2:	0b4080e7          	jalr	180(ra) # 80006072 <acquire>
  uartstart();
    80005fc6:	00000097          	auipc	ra,0x0
    80005fca:	e64080e7          	jalr	-412(ra) # 80005e2a <uartstart>
  release(&uart_tx_lock);
    80005fce:	8526                	mv	a0,s1
    80005fd0:	00000097          	auipc	ra,0x0
    80005fd4:	156080e7          	jalr	342(ra) # 80006126 <release>
}
    80005fd8:	60e2                	ld	ra,24(sp)
    80005fda:	6442                	ld	s0,16(sp)
    80005fdc:	64a2                	ld	s1,8(sp)
    80005fde:	6105                	addi	sp,sp,32
    80005fe0:	8082                	ret

0000000080005fe2 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80005fe2:	1141                	addi	sp,sp,-16
    80005fe4:	e422                	sd	s0,8(sp)
    80005fe6:	0800                	addi	s0,sp,16
  lk->name = name;
    80005fe8:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005fea:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80005fee:	00053823          	sd	zero,16(a0)
}
    80005ff2:	6422                	ld	s0,8(sp)
    80005ff4:	0141                	addi	sp,sp,16
    80005ff6:	8082                	ret

0000000080005ff8 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80005ff8:	411c                	lw	a5,0(a0)
    80005ffa:	e399                	bnez	a5,80006000 <holding+0x8>
    80005ffc:	4501                	li	a0,0
  return r;
}
    80005ffe:	8082                	ret
{
    80006000:	1101                	addi	sp,sp,-32
    80006002:	ec06                	sd	ra,24(sp)
    80006004:	e822                	sd	s0,16(sp)
    80006006:	e426                	sd	s1,8(sp)
    80006008:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000600a:	6904                	ld	s1,16(a0)
    8000600c:	ffffb097          	auipc	ra,0xffffb
    80006010:	e1c080e7          	jalr	-484(ra) # 80000e28 <mycpu>
    80006014:	40a48533          	sub	a0,s1,a0
    80006018:	00153513          	seqz	a0,a0
}
    8000601c:	60e2                	ld	ra,24(sp)
    8000601e:	6442                	ld	s0,16(sp)
    80006020:	64a2                	ld	s1,8(sp)
    80006022:	6105                	addi	sp,sp,32
    80006024:	8082                	ret

0000000080006026 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006026:	1101                	addi	sp,sp,-32
    80006028:	ec06                	sd	ra,24(sp)
    8000602a:	e822                	sd	s0,16(sp)
    8000602c:	e426                	sd	s1,8(sp)
    8000602e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006030:	100024f3          	csrr	s1,sstatus
    80006034:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006038:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000603a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000603e:	ffffb097          	auipc	ra,0xffffb
    80006042:	dea080e7          	jalr	-534(ra) # 80000e28 <mycpu>
    80006046:	5d3c                	lw	a5,120(a0)
    80006048:	cf89                	beqz	a5,80006062 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000604a:	ffffb097          	auipc	ra,0xffffb
    8000604e:	dde080e7          	jalr	-546(ra) # 80000e28 <mycpu>
    80006052:	5d3c                	lw	a5,120(a0)
    80006054:	2785                	addiw	a5,a5,1
    80006056:	dd3c                	sw	a5,120(a0)
}
    80006058:	60e2                	ld	ra,24(sp)
    8000605a:	6442                	ld	s0,16(sp)
    8000605c:	64a2                	ld	s1,8(sp)
    8000605e:	6105                	addi	sp,sp,32
    80006060:	8082                	ret
    mycpu()->intena = old;
    80006062:	ffffb097          	auipc	ra,0xffffb
    80006066:	dc6080e7          	jalr	-570(ra) # 80000e28 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000606a:	8085                	srli	s1,s1,0x1
    8000606c:	8885                	andi	s1,s1,1
    8000606e:	dd64                	sw	s1,124(a0)
    80006070:	bfe9                	j	8000604a <push_off+0x24>

0000000080006072 <acquire>:
{
    80006072:	1101                	addi	sp,sp,-32
    80006074:	ec06                	sd	ra,24(sp)
    80006076:	e822                	sd	s0,16(sp)
    80006078:	e426                	sd	s1,8(sp)
    8000607a:	1000                	addi	s0,sp,32
    8000607c:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000607e:	00000097          	auipc	ra,0x0
    80006082:	fa8080e7          	jalr	-88(ra) # 80006026 <push_off>
  if(holding(lk))
    80006086:	8526                	mv	a0,s1
    80006088:	00000097          	auipc	ra,0x0
    8000608c:	f70080e7          	jalr	-144(ra) # 80005ff8 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006090:	4705                	li	a4,1
  if(holding(lk))
    80006092:	e115                	bnez	a0,800060b6 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006094:	87ba                	mv	a5,a4
    80006096:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000609a:	2781                	sext.w	a5,a5
    8000609c:	ffe5                	bnez	a5,80006094 <acquire+0x22>
  __sync_synchronize();
    8000609e:	0ff0000f          	fence
  lk->cpu = mycpu();
    800060a2:	ffffb097          	auipc	ra,0xffffb
    800060a6:	d86080e7          	jalr	-634(ra) # 80000e28 <mycpu>
    800060aa:	e888                	sd	a0,16(s1)
}
    800060ac:	60e2                	ld	ra,24(sp)
    800060ae:	6442                	ld	s0,16(sp)
    800060b0:	64a2                	ld	s1,8(sp)
    800060b2:	6105                	addi	sp,sp,32
    800060b4:	8082                	ret
    panic("acquire");
    800060b6:	00002517          	auipc	a0,0x2
    800060ba:	77250513          	addi	a0,a0,1906 # 80008828 <digits+0x20>
    800060be:	00000097          	auipc	ra,0x0
    800060c2:	a6a080e7          	jalr	-1430(ra) # 80005b28 <panic>

00000000800060c6 <pop_off>:

void
pop_off(void)
{
    800060c6:	1141                	addi	sp,sp,-16
    800060c8:	e406                	sd	ra,8(sp)
    800060ca:	e022                	sd	s0,0(sp)
    800060cc:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800060ce:	ffffb097          	auipc	ra,0xffffb
    800060d2:	d5a080e7          	jalr	-678(ra) # 80000e28 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800060d6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800060da:	8b89                	andi	a5,a5,2
  if(intr_get())
    800060dc:	e78d                	bnez	a5,80006106 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800060de:	5d3c                	lw	a5,120(a0)
    800060e0:	02f05b63          	blez	a5,80006116 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800060e4:	37fd                	addiw	a5,a5,-1
    800060e6:	0007871b          	sext.w	a4,a5
    800060ea:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800060ec:	eb09                	bnez	a4,800060fe <pop_off+0x38>
    800060ee:	5d7c                	lw	a5,124(a0)
    800060f0:	c799                	beqz	a5,800060fe <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800060f2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800060f6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800060fa:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800060fe:	60a2                	ld	ra,8(sp)
    80006100:	6402                	ld	s0,0(sp)
    80006102:	0141                	addi	sp,sp,16
    80006104:	8082                	ret
    panic("pop_off - interruptible");
    80006106:	00002517          	auipc	a0,0x2
    8000610a:	72a50513          	addi	a0,a0,1834 # 80008830 <digits+0x28>
    8000610e:	00000097          	auipc	ra,0x0
    80006112:	a1a080e7          	jalr	-1510(ra) # 80005b28 <panic>
    panic("pop_off");
    80006116:	00002517          	auipc	a0,0x2
    8000611a:	73250513          	addi	a0,a0,1842 # 80008848 <digits+0x40>
    8000611e:	00000097          	auipc	ra,0x0
    80006122:	a0a080e7          	jalr	-1526(ra) # 80005b28 <panic>

0000000080006126 <release>:
{
    80006126:	1101                	addi	sp,sp,-32
    80006128:	ec06                	sd	ra,24(sp)
    8000612a:	e822                	sd	s0,16(sp)
    8000612c:	e426                	sd	s1,8(sp)
    8000612e:	1000                	addi	s0,sp,32
    80006130:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006132:	00000097          	auipc	ra,0x0
    80006136:	ec6080e7          	jalr	-314(ra) # 80005ff8 <holding>
    8000613a:	c115                	beqz	a0,8000615e <release+0x38>
  lk->cpu = 0;
    8000613c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006140:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006144:	0f50000f          	fence	iorw,ow
    80006148:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000614c:	00000097          	auipc	ra,0x0
    80006150:	f7a080e7          	jalr	-134(ra) # 800060c6 <pop_off>
}
    80006154:	60e2                	ld	ra,24(sp)
    80006156:	6442                	ld	s0,16(sp)
    80006158:	64a2                	ld	s1,8(sp)
    8000615a:	6105                	addi	sp,sp,32
    8000615c:	8082                	ret
    panic("release");
    8000615e:	00002517          	auipc	a0,0x2
    80006162:	6f250513          	addi	a0,a0,1778 # 80008850 <digits+0x48>
    80006166:	00000097          	auipc	ra,0x0
    8000616a:	9c2080e7          	jalr	-1598(ra) # 80005b28 <panic>
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
