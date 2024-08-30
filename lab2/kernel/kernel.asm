
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
    80000016:	7a2050ef          	jal	ra,800057b8 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
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
    8000004c:	17a080e7          	jalr	378(ra) # 800001c2 <memset>

  r = (struct run *)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	158080e7          	jalr	344(ra) # 800061b2 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	1f8080e7          	jalr	504(ra) # 80006266 <release>
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
    8000008e:	bde080e7          	jalr	-1058(ra) # 80005c68 <panic>

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
  p = (char *)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	94aa                	add	s1,s1,a0
    800000aa:	757d                	lui	a0,0xfffff
    800000ac:	8ce9                	and	s1,s1,a0
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    800000ae:	94be                	add	s1,s1,a5
    800000b0:	0095ee63          	bltu	a1,s1,800000cc <freerange+0x3a>
    800000b4:	892e                	mv	s2,a1
    kfree(p);
    800000b6:	7a7d                	lui	s4,0xfffff
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    800000b8:	6985                	lui	s3,0x1
    kfree(p);
    800000ba:	01448533          	add	a0,s1,s4
    800000be:	00000097          	auipc	ra,0x0
    800000c2:	f5e080e7          	jalr	-162(ra) # 8000001c <kfree>
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
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
    800000f8:	02e080e7          	jalr	46(ra) # 80006122 <initlock>
  freerange(end, (void *)PHYSTOP);
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
    80000130:	086080e7          	jalr	134(ra) # 800061b2 <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if (r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	ef650513          	addi	a0,a0,-266 # 80009030 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	122080e7          	jalr	290(ra) # 80006266 <release>

  if (r)
    memset((char *)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	070080e7          	jalr	112(ra) # 800001c2 <memset>
  return (void *)r;
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
    80000172:	0f8080e7          	jalr	248(ra) # 80006266 <release>
  if (r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <getfreememory>:

uint64 getfreememory(void)
{
    80000178:	1101                	addi	sp,sp,-32
    8000017a:	ec06                	sd	ra,24(sp)
    8000017c:	e822                	sd	s0,16(sp)
    8000017e:	e426                	sd	s1,8(sp)
    80000180:	1000                	addi	s0,sp,32
  uint64 totalsize = 0;

  struct run *p;
  acquire(&kmem.lock);
    80000182:	00009497          	auipc	s1,0x9
    80000186:	eae48493          	addi	s1,s1,-338 # 80009030 <kmem>
    8000018a:	8526                	mv	a0,s1
    8000018c:	00006097          	auipc	ra,0x6
    80000190:	026080e7          	jalr	38(ra) # 800061b2 <acquire>
  for (p = kmem.freelist; p != 0; p = p->next)
    80000194:	6c9c                	ld	a5,24(s1)
    80000196:	c785                	beqz	a5,800001be <getfreememory+0x46>
  uint64 totalsize = 0;
    80000198:	4481                	li	s1,0
  {
    totalsize += (uint64)PGSIZE;
    8000019a:	6705                	lui	a4,0x1
    8000019c:	94ba                	add	s1,s1,a4
  for (p = kmem.freelist; p != 0; p = p->next)
    8000019e:	639c                	ld	a5,0(a5)
    800001a0:	fff5                	bnez	a5,8000019c <getfreememory+0x24>
  }
  // printf("Debug: Free memory: %d\n", totalsize);
  release(&kmem.lock);
    800001a2:	00009517          	auipc	a0,0x9
    800001a6:	e8e50513          	addi	a0,a0,-370 # 80009030 <kmem>
    800001aa:	00006097          	auipc	ra,0x6
    800001ae:	0bc080e7          	jalr	188(ra) # 80006266 <release>
  return totalsize;
}
    800001b2:	8526                	mv	a0,s1
    800001b4:	60e2                	ld	ra,24(sp)
    800001b6:	6442                	ld	s0,16(sp)
    800001b8:	64a2                	ld	s1,8(sp)
    800001ba:	6105                	addi	sp,sp,32
    800001bc:	8082                	ret
  uint64 totalsize = 0;
    800001be:	4481                	li	s1,0
    800001c0:	b7cd                	j	800001a2 <getfreememory+0x2a>

00000000800001c2 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800001c2:	1141                	addi	sp,sp,-16
    800001c4:	e422                	sd	s0,8(sp)
    800001c6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800001c8:	ce09                	beqz	a2,800001e2 <memset+0x20>
    800001ca:	87aa                	mv	a5,a0
    800001cc:	fff6071b          	addiw	a4,a2,-1
    800001d0:	1702                	slli	a4,a4,0x20
    800001d2:	9301                	srli	a4,a4,0x20
    800001d4:	0705                	addi	a4,a4,1
    800001d6:	972a                	add	a4,a4,a0
    cdst[i] = c;
    800001d8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800001dc:	0785                	addi	a5,a5,1
    800001de:	fee79de3          	bne	a5,a4,800001d8 <memset+0x16>
  }
  return dst;
}
    800001e2:	6422                	ld	s0,8(sp)
    800001e4:	0141                	addi	sp,sp,16
    800001e6:	8082                	ret

00000000800001e8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800001e8:	1141                	addi	sp,sp,-16
    800001ea:	e422                	sd	s0,8(sp)
    800001ec:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001ee:	ca05                	beqz	a2,8000021e <memcmp+0x36>
    800001f0:	fff6069b          	addiw	a3,a2,-1
    800001f4:	1682                	slli	a3,a3,0x20
    800001f6:	9281                	srli	a3,a3,0x20
    800001f8:	0685                	addi	a3,a3,1
    800001fa:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001fc:	00054783          	lbu	a5,0(a0)
    80000200:	0005c703          	lbu	a4,0(a1)
    80000204:	00e79863          	bne	a5,a4,80000214 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000208:	0505                	addi	a0,a0,1
    8000020a:	0585                	addi	a1,a1,1
  while(n-- > 0){
    8000020c:	fed518e3          	bne	a0,a3,800001fc <memcmp+0x14>
  }

  return 0;
    80000210:	4501                	li	a0,0
    80000212:	a019                	j	80000218 <memcmp+0x30>
      return *s1 - *s2;
    80000214:	40e7853b          	subw	a0,a5,a4
}
    80000218:	6422                	ld	s0,8(sp)
    8000021a:	0141                	addi	sp,sp,16
    8000021c:	8082                	ret
  return 0;
    8000021e:	4501                	li	a0,0
    80000220:	bfe5                	j	80000218 <memcmp+0x30>

0000000080000222 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000222:	1141                	addi	sp,sp,-16
    80000224:	e422                	sd	s0,8(sp)
    80000226:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000228:	ca0d                	beqz	a2,8000025a <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    8000022a:	00a5f963          	bgeu	a1,a0,8000023c <memmove+0x1a>
    8000022e:	02061693          	slli	a3,a2,0x20
    80000232:	9281                	srli	a3,a3,0x20
    80000234:	00d58733          	add	a4,a1,a3
    80000238:	02e56463          	bltu	a0,a4,80000260 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    8000023c:	fff6079b          	addiw	a5,a2,-1
    80000240:	1782                	slli	a5,a5,0x20
    80000242:	9381                	srli	a5,a5,0x20
    80000244:	0785                	addi	a5,a5,1
    80000246:	97ae                	add	a5,a5,a1
    80000248:	872a                	mv	a4,a0
      *d++ = *s++;
    8000024a:	0585                	addi	a1,a1,1
    8000024c:	0705                	addi	a4,a4,1
    8000024e:	fff5c683          	lbu	a3,-1(a1)
    80000252:	fed70fa3          	sb	a3,-1(a4) # fff <_entry-0x7ffff001>
    while(n-- > 0)
    80000256:	fef59ae3          	bne	a1,a5,8000024a <memmove+0x28>

  return dst;
}
    8000025a:	6422                	ld	s0,8(sp)
    8000025c:	0141                	addi	sp,sp,16
    8000025e:	8082                	ret
    d += n;
    80000260:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000262:	fff6079b          	addiw	a5,a2,-1
    80000266:	1782                	slli	a5,a5,0x20
    80000268:	9381                	srli	a5,a5,0x20
    8000026a:	fff7c793          	not	a5,a5
    8000026e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000270:	177d                	addi	a4,a4,-1
    80000272:	16fd                	addi	a3,a3,-1
    80000274:	00074603          	lbu	a2,0(a4)
    80000278:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000027c:	fef71ae3          	bne	a4,a5,80000270 <memmove+0x4e>
    80000280:	bfe9                	j	8000025a <memmove+0x38>

0000000080000282 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000282:	1141                	addi	sp,sp,-16
    80000284:	e406                	sd	ra,8(sp)
    80000286:	e022                	sd	s0,0(sp)
    80000288:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000028a:	00000097          	auipc	ra,0x0
    8000028e:	f98080e7          	jalr	-104(ra) # 80000222 <memmove>
}
    80000292:	60a2                	ld	ra,8(sp)
    80000294:	6402                	ld	s0,0(sp)
    80000296:	0141                	addi	sp,sp,16
    80000298:	8082                	ret

000000008000029a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000029a:	1141                	addi	sp,sp,-16
    8000029c:	e422                	sd	s0,8(sp)
    8000029e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    800002a0:	ce11                	beqz	a2,800002bc <strncmp+0x22>
    800002a2:	00054783          	lbu	a5,0(a0)
    800002a6:	cf89                	beqz	a5,800002c0 <strncmp+0x26>
    800002a8:	0005c703          	lbu	a4,0(a1)
    800002ac:	00f71a63          	bne	a4,a5,800002c0 <strncmp+0x26>
    n--, p++, q++;
    800002b0:	367d                	addiw	a2,a2,-1
    800002b2:	0505                	addi	a0,a0,1
    800002b4:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800002b6:	f675                	bnez	a2,800002a2 <strncmp+0x8>
  if(n == 0)
    return 0;
    800002b8:	4501                	li	a0,0
    800002ba:	a809                	j	800002cc <strncmp+0x32>
    800002bc:	4501                	li	a0,0
    800002be:	a039                	j	800002cc <strncmp+0x32>
  if(n == 0)
    800002c0:	ca09                	beqz	a2,800002d2 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    800002c2:	00054503          	lbu	a0,0(a0)
    800002c6:	0005c783          	lbu	a5,0(a1)
    800002ca:	9d1d                	subw	a0,a0,a5
}
    800002cc:	6422                	ld	s0,8(sp)
    800002ce:	0141                	addi	sp,sp,16
    800002d0:	8082                	ret
    return 0;
    800002d2:	4501                	li	a0,0
    800002d4:	bfe5                	j	800002cc <strncmp+0x32>

00000000800002d6 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800002d6:	1141                	addi	sp,sp,-16
    800002d8:	e422                	sd	s0,8(sp)
    800002da:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800002dc:	872a                	mv	a4,a0
    800002de:	8832                	mv	a6,a2
    800002e0:	367d                	addiw	a2,a2,-1
    800002e2:	01005963          	blez	a6,800002f4 <strncpy+0x1e>
    800002e6:	0705                	addi	a4,a4,1
    800002e8:	0005c783          	lbu	a5,0(a1)
    800002ec:	fef70fa3          	sb	a5,-1(a4)
    800002f0:	0585                	addi	a1,a1,1
    800002f2:	f7f5                	bnez	a5,800002de <strncpy+0x8>
    ;
  while(n-- > 0)
    800002f4:	00c05d63          	blez	a2,8000030e <strncpy+0x38>
    800002f8:	86ba                	mv	a3,a4
    *s++ = 0;
    800002fa:	0685                	addi	a3,a3,1
    800002fc:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000300:	fff6c793          	not	a5,a3
    80000304:	9fb9                	addw	a5,a5,a4
    80000306:	010787bb          	addw	a5,a5,a6
    8000030a:	fef048e3          	bgtz	a5,800002fa <strncpy+0x24>
  return os;
}
    8000030e:	6422                	ld	s0,8(sp)
    80000310:	0141                	addi	sp,sp,16
    80000312:	8082                	ret

0000000080000314 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000314:	1141                	addi	sp,sp,-16
    80000316:	e422                	sd	s0,8(sp)
    80000318:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    8000031a:	02c05363          	blez	a2,80000340 <safestrcpy+0x2c>
    8000031e:	fff6069b          	addiw	a3,a2,-1
    80000322:	1682                	slli	a3,a3,0x20
    80000324:	9281                	srli	a3,a3,0x20
    80000326:	96ae                	add	a3,a3,a1
    80000328:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    8000032a:	00d58963          	beq	a1,a3,8000033c <safestrcpy+0x28>
    8000032e:	0585                	addi	a1,a1,1
    80000330:	0785                	addi	a5,a5,1
    80000332:	fff5c703          	lbu	a4,-1(a1)
    80000336:	fee78fa3          	sb	a4,-1(a5)
    8000033a:	fb65                	bnez	a4,8000032a <safestrcpy+0x16>
    ;
  *s = 0;
    8000033c:	00078023          	sb	zero,0(a5)
  return os;
}
    80000340:	6422                	ld	s0,8(sp)
    80000342:	0141                	addi	sp,sp,16
    80000344:	8082                	ret

0000000080000346 <strlen>:

int
strlen(const char *s)
{
    80000346:	1141                	addi	sp,sp,-16
    80000348:	e422                	sd	s0,8(sp)
    8000034a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    8000034c:	00054783          	lbu	a5,0(a0)
    80000350:	cf91                	beqz	a5,8000036c <strlen+0x26>
    80000352:	0505                	addi	a0,a0,1
    80000354:	87aa                	mv	a5,a0
    80000356:	4685                	li	a3,1
    80000358:	9e89                	subw	a3,a3,a0
    8000035a:	00f6853b          	addw	a0,a3,a5
    8000035e:	0785                	addi	a5,a5,1
    80000360:	fff7c703          	lbu	a4,-1(a5)
    80000364:	fb7d                	bnez	a4,8000035a <strlen+0x14>
    ;
  return n;
}
    80000366:	6422                	ld	s0,8(sp)
    80000368:	0141                	addi	sp,sp,16
    8000036a:	8082                	ret
  for(n = 0; s[n]; n++)
    8000036c:	4501                	li	a0,0
    8000036e:	bfe5                	j	80000366 <strlen+0x20>

0000000080000370 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000370:	1141                	addi	sp,sp,-16
    80000372:	e406                	sd	ra,8(sp)
    80000374:	e022                	sd	s0,0(sp)
    80000376:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000378:	00001097          	auipc	ra,0x1
    8000037c:	aee080e7          	jalr	-1298(ra) # 80000e66 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000380:	00009717          	auipc	a4,0x9
    80000384:	c8070713          	addi	a4,a4,-896 # 80009000 <started>
  if(cpuid() == 0){
    80000388:	c139                	beqz	a0,800003ce <main+0x5e>
    while(started == 0)
    8000038a:	431c                	lw	a5,0(a4)
    8000038c:	2781                	sext.w	a5,a5
    8000038e:	dff5                	beqz	a5,8000038a <main+0x1a>
      ;
    __sync_synchronize();
    80000390:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000394:	00001097          	auipc	ra,0x1
    80000398:	ad2080e7          	jalr	-1326(ra) # 80000e66 <cpuid>
    8000039c:	85aa                	mv	a1,a0
    8000039e:	00008517          	auipc	a0,0x8
    800003a2:	c9a50513          	addi	a0,a0,-870 # 80008038 <etext+0x38>
    800003a6:	00006097          	auipc	ra,0x6
    800003aa:	90c080e7          	jalr	-1780(ra) # 80005cb2 <printf>
    kvminithart();    // turn on paging
    800003ae:	00000097          	auipc	ra,0x0
    800003b2:	0d8080e7          	jalr	216(ra) # 80000486 <kvminithart>
    trapinithart();   // install kernel trap vector
    800003b6:	00001097          	auipc	ra,0x1
    800003ba:	76e080e7          	jalr	1902(ra) # 80001b24 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800003be:	00005097          	auipc	ra,0x5
    800003c2:	d82080e7          	jalr	-638(ra) # 80005140 <plicinithart>
  }

  scheduler();        
    800003c6:	00001097          	auipc	ra,0x1
    800003ca:	fec080e7          	jalr	-20(ra) # 800013b2 <scheduler>
    consoleinit();
    800003ce:	00005097          	auipc	ra,0x5
    800003d2:	7ac080e7          	jalr	1964(ra) # 80005b7a <consoleinit>
    printfinit();
    800003d6:	00006097          	auipc	ra,0x6
    800003da:	ac2080e7          	jalr	-1342(ra) # 80005e98 <printfinit>
    printf("\n");
    800003de:	00008517          	auipc	a0,0x8
    800003e2:	c6a50513          	addi	a0,a0,-918 # 80008048 <etext+0x48>
    800003e6:	00006097          	auipc	ra,0x6
    800003ea:	8cc080e7          	jalr	-1844(ra) # 80005cb2 <printf>
    printf("xv6 kernel is booting\n");
    800003ee:	00008517          	auipc	a0,0x8
    800003f2:	c3250513          	addi	a0,a0,-974 # 80008020 <etext+0x20>
    800003f6:	00006097          	auipc	ra,0x6
    800003fa:	8bc080e7          	jalr	-1860(ra) # 80005cb2 <printf>
    printf("\n");
    800003fe:	00008517          	auipc	a0,0x8
    80000402:	c4a50513          	addi	a0,a0,-950 # 80008048 <etext+0x48>
    80000406:	00006097          	auipc	ra,0x6
    8000040a:	8ac080e7          	jalr	-1876(ra) # 80005cb2 <printf>
    kinit();         // physical page allocator
    8000040e:	00000097          	auipc	ra,0x0
    80000412:	cce080e7          	jalr	-818(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    80000416:	00000097          	auipc	ra,0x0
    8000041a:	322080e7          	jalr	802(ra) # 80000738 <kvminit>
    kvminithart();   // turn on paging
    8000041e:	00000097          	auipc	ra,0x0
    80000422:	068080e7          	jalr	104(ra) # 80000486 <kvminithart>
    procinit();      // process table
    80000426:	00001097          	auipc	ra,0x1
    8000042a:	990080e7          	jalr	-1648(ra) # 80000db6 <procinit>
    trapinit();      // trap vectors
    8000042e:	00001097          	auipc	ra,0x1
    80000432:	6ce080e7          	jalr	1742(ra) # 80001afc <trapinit>
    trapinithart();  // install kernel trap vector
    80000436:	00001097          	auipc	ra,0x1
    8000043a:	6ee080e7          	jalr	1774(ra) # 80001b24 <trapinithart>
    plicinit();      // set up interrupt controller
    8000043e:	00005097          	auipc	ra,0x5
    80000442:	cec080e7          	jalr	-788(ra) # 8000512a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000446:	00005097          	auipc	ra,0x5
    8000044a:	cfa080e7          	jalr	-774(ra) # 80005140 <plicinithart>
    binit();         // buffer cache
    8000044e:	00002097          	auipc	ra,0x2
    80000452:	ed2080e7          	jalr	-302(ra) # 80002320 <binit>
    iinit();         // inode table
    80000456:	00002097          	auipc	ra,0x2
    8000045a:	562080e7          	jalr	1378(ra) # 800029b8 <iinit>
    fileinit();      // file table
    8000045e:	00003097          	auipc	ra,0x3
    80000462:	50c080e7          	jalr	1292(ra) # 8000396a <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000466:	00005097          	auipc	ra,0x5
    8000046a:	dfc080e7          	jalr	-516(ra) # 80005262 <virtio_disk_init>
    userinit();      // first user process
    8000046e:	00001097          	auipc	ra,0x1
    80000472:	cfc080e7          	jalr	-772(ra) # 8000116a <userinit>
    __sync_synchronize();
    80000476:	0ff0000f          	fence
    started = 1;
    8000047a:	4785                	li	a5,1
    8000047c:	00009717          	auipc	a4,0x9
    80000480:	b8f72223          	sw	a5,-1148(a4) # 80009000 <started>
    80000484:	b789                	j	800003c6 <main+0x56>

0000000080000486 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000486:	1141                	addi	sp,sp,-16
    80000488:	e422                	sd	s0,8(sp)
    8000048a:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000048c:	00009797          	auipc	a5,0x9
    80000490:	b7c7b783          	ld	a5,-1156(a5) # 80009008 <kernel_pagetable>
    80000494:	83b1                	srli	a5,a5,0xc
    80000496:	577d                	li	a4,-1
    80000498:	177e                	slli	a4,a4,0x3f
    8000049a:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r"(x));
    8000049c:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800004a0:	12000073          	sfence.vma
  sfence_vma();
}
    800004a4:	6422                	ld	s0,8(sp)
    800004a6:	0141                	addi	sp,sp,16
    800004a8:	8082                	ret

00000000800004aa <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800004aa:	7139                	addi	sp,sp,-64
    800004ac:	fc06                	sd	ra,56(sp)
    800004ae:	f822                	sd	s0,48(sp)
    800004b0:	f426                	sd	s1,40(sp)
    800004b2:	f04a                	sd	s2,32(sp)
    800004b4:	ec4e                	sd	s3,24(sp)
    800004b6:	e852                	sd	s4,16(sp)
    800004b8:	e456                	sd	s5,8(sp)
    800004ba:	e05a                	sd	s6,0(sp)
    800004bc:	0080                	addi	s0,sp,64
    800004be:	84aa                	mv	s1,a0
    800004c0:	89ae                	mv	s3,a1
    800004c2:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800004c4:	57fd                	li	a5,-1
    800004c6:	83e9                	srli	a5,a5,0x1a
    800004c8:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800004ca:	4b31                	li	s6,12
  if(va >= MAXVA)
    800004cc:	04b7f263          	bgeu	a5,a1,80000510 <walk+0x66>
    panic("walk");
    800004d0:	00008517          	auipc	a0,0x8
    800004d4:	b8050513          	addi	a0,a0,-1152 # 80008050 <etext+0x50>
    800004d8:	00005097          	auipc	ra,0x5
    800004dc:	790080e7          	jalr	1936(ra) # 80005c68 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004e0:	060a8663          	beqz	s5,8000054c <walk+0xa2>
    800004e4:	00000097          	auipc	ra,0x0
    800004e8:	c34080e7          	jalr	-972(ra) # 80000118 <kalloc>
    800004ec:	84aa                	mv	s1,a0
    800004ee:	c529                	beqz	a0,80000538 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004f0:	6605                	lui	a2,0x1
    800004f2:	4581                	li	a1,0
    800004f4:	00000097          	auipc	ra,0x0
    800004f8:	cce080e7          	jalr	-818(ra) # 800001c2 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004fc:	00c4d793          	srli	a5,s1,0xc
    80000500:	07aa                	slli	a5,a5,0xa
    80000502:	0017e793          	ori	a5,a5,1
    80000506:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    8000050a:	3a5d                	addiw	s4,s4,-9
    8000050c:	036a0063          	beq	s4,s6,8000052c <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000510:	0149d933          	srl	s2,s3,s4
    80000514:	1ff97913          	andi	s2,s2,511
    80000518:	090e                	slli	s2,s2,0x3
    8000051a:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000051c:	00093483          	ld	s1,0(s2)
    80000520:	0014f793          	andi	a5,s1,1
    80000524:	dfd5                	beqz	a5,800004e0 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000526:	80a9                	srli	s1,s1,0xa
    80000528:	04b2                	slli	s1,s1,0xc
    8000052a:	b7c5                	j	8000050a <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    8000052c:	00c9d513          	srli	a0,s3,0xc
    80000530:	1ff57513          	andi	a0,a0,511
    80000534:	050e                	slli	a0,a0,0x3
    80000536:	9526                	add	a0,a0,s1
}
    80000538:	70e2                	ld	ra,56(sp)
    8000053a:	7442                	ld	s0,48(sp)
    8000053c:	74a2                	ld	s1,40(sp)
    8000053e:	7902                	ld	s2,32(sp)
    80000540:	69e2                	ld	s3,24(sp)
    80000542:	6a42                	ld	s4,16(sp)
    80000544:	6aa2                	ld	s5,8(sp)
    80000546:	6b02                	ld	s6,0(sp)
    80000548:	6121                	addi	sp,sp,64
    8000054a:	8082                	ret
        return 0;
    8000054c:	4501                	li	a0,0
    8000054e:	b7ed                	j	80000538 <walk+0x8e>

0000000080000550 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000550:	57fd                	li	a5,-1
    80000552:	83e9                	srli	a5,a5,0x1a
    80000554:	00b7f463          	bgeu	a5,a1,8000055c <walkaddr+0xc>
    return 0;
    80000558:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000055a:	8082                	ret
{
    8000055c:	1141                	addi	sp,sp,-16
    8000055e:	e406                	sd	ra,8(sp)
    80000560:	e022                	sd	s0,0(sp)
    80000562:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000564:	4601                	li	a2,0
    80000566:	00000097          	auipc	ra,0x0
    8000056a:	f44080e7          	jalr	-188(ra) # 800004aa <walk>
  if(pte == 0)
    8000056e:	c105                	beqz	a0,8000058e <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000570:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000572:	0117f693          	andi	a3,a5,17
    80000576:	4745                	li	a4,17
    return 0;
    80000578:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000057a:	00e68663          	beq	a3,a4,80000586 <walkaddr+0x36>
}
    8000057e:	60a2                	ld	ra,8(sp)
    80000580:	6402                	ld	s0,0(sp)
    80000582:	0141                	addi	sp,sp,16
    80000584:	8082                	ret
  pa = PTE2PA(*pte);
    80000586:	00a7d513          	srli	a0,a5,0xa
    8000058a:	0532                	slli	a0,a0,0xc
  return pa;
    8000058c:	bfcd                	j	8000057e <walkaddr+0x2e>
    return 0;
    8000058e:	4501                	li	a0,0
    80000590:	b7fd                	j	8000057e <walkaddr+0x2e>

0000000080000592 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000592:	715d                	addi	sp,sp,-80
    80000594:	e486                	sd	ra,72(sp)
    80000596:	e0a2                	sd	s0,64(sp)
    80000598:	fc26                	sd	s1,56(sp)
    8000059a:	f84a                	sd	s2,48(sp)
    8000059c:	f44e                	sd	s3,40(sp)
    8000059e:	f052                	sd	s4,32(sp)
    800005a0:	ec56                	sd	s5,24(sp)
    800005a2:	e85a                	sd	s6,16(sp)
    800005a4:	e45e                	sd	s7,8(sp)
    800005a6:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800005a8:	c205                	beqz	a2,800005c8 <mappages+0x36>
    800005aa:	8aaa                	mv	s5,a0
    800005ac:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800005ae:	77fd                	lui	a5,0xfffff
    800005b0:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    800005b4:	15fd                	addi	a1,a1,-1
    800005b6:	00c589b3          	add	s3,a1,a2
    800005ba:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    800005be:	8952                	mv	s2,s4
    800005c0:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800005c4:	6b85                	lui	s7,0x1
    800005c6:	a015                	j	800005ea <mappages+0x58>
    panic("mappages: size");
    800005c8:	00008517          	auipc	a0,0x8
    800005cc:	a9050513          	addi	a0,a0,-1392 # 80008058 <etext+0x58>
    800005d0:	00005097          	auipc	ra,0x5
    800005d4:	698080e7          	jalr	1688(ra) # 80005c68 <panic>
      panic("mappages: remap");
    800005d8:	00008517          	auipc	a0,0x8
    800005dc:	a9050513          	addi	a0,a0,-1392 # 80008068 <etext+0x68>
    800005e0:	00005097          	auipc	ra,0x5
    800005e4:	688080e7          	jalr	1672(ra) # 80005c68 <panic>
    a += PGSIZE;
    800005e8:	995e                	add	s2,s2,s7
  for(;;){
    800005ea:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005ee:	4605                	li	a2,1
    800005f0:	85ca                	mv	a1,s2
    800005f2:	8556                	mv	a0,s5
    800005f4:	00000097          	auipc	ra,0x0
    800005f8:	eb6080e7          	jalr	-330(ra) # 800004aa <walk>
    800005fc:	cd19                	beqz	a0,8000061a <mappages+0x88>
    if(*pte & PTE_V)
    800005fe:	611c                	ld	a5,0(a0)
    80000600:	8b85                	andi	a5,a5,1
    80000602:	fbf9                	bnez	a5,800005d8 <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000604:	80b1                	srli	s1,s1,0xc
    80000606:	04aa                	slli	s1,s1,0xa
    80000608:	0164e4b3          	or	s1,s1,s6
    8000060c:	0014e493          	ori	s1,s1,1
    80000610:	e104                	sd	s1,0(a0)
    if(a == last)
    80000612:	fd391be3          	bne	s2,s3,800005e8 <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    80000616:	4501                	li	a0,0
    80000618:	a011                	j	8000061c <mappages+0x8a>
      return -1;
    8000061a:	557d                	li	a0,-1
}
    8000061c:	60a6                	ld	ra,72(sp)
    8000061e:	6406                	ld	s0,64(sp)
    80000620:	74e2                	ld	s1,56(sp)
    80000622:	7942                	ld	s2,48(sp)
    80000624:	79a2                	ld	s3,40(sp)
    80000626:	7a02                	ld	s4,32(sp)
    80000628:	6ae2                	ld	s5,24(sp)
    8000062a:	6b42                	ld	s6,16(sp)
    8000062c:	6ba2                	ld	s7,8(sp)
    8000062e:	6161                	addi	sp,sp,80
    80000630:	8082                	ret

0000000080000632 <kvmmap>:
{
    80000632:	1141                	addi	sp,sp,-16
    80000634:	e406                	sd	ra,8(sp)
    80000636:	e022                	sd	s0,0(sp)
    80000638:	0800                	addi	s0,sp,16
    8000063a:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000063c:	86b2                	mv	a3,a2
    8000063e:	863e                	mv	a2,a5
    80000640:	00000097          	auipc	ra,0x0
    80000644:	f52080e7          	jalr	-174(ra) # 80000592 <mappages>
    80000648:	e509                	bnez	a0,80000652 <kvmmap+0x20>
}
    8000064a:	60a2                	ld	ra,8(sp)
    8000064c:	6402                	ld	s0,0(sp)
    8000064e:	0141                	addi	sp,sp,16
    80000650:	8082                	ret
    panic("kvmmap");
    80000652:	00008517          	auipc	a0,0x8
    80000656:	a2650513          	addi	a0,a0,-1498 # 80008078 <etext+0x78>
    8000065a:	00005097          	auipc	ra,0x5
    8000065e:	60e080e7          	jalr	1550(ra) # 80005c68 <panic>

0000000080000662 <kvmmake>:
{
    80000662:	1101                	addi	sp,sp,-32
    80000664:	ec06                	sd	ra,24(sp)
    80000666:	e822                	sd	s0,16(sp)
    80000668:	e426                	sd	s1,8(sp)
    8000066a:	e04a                	sd	s2,0(sp)
    8000066c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000066e:	00000097          	auipc	ra,0x0
    80000672:	aaa080e7          	jalr	-1366(ra) # 80000118 <kalloc>
    80000676:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000678:	6605                	lui	a2,0x1
    8000067a:	4581                	li	a1,0
    8000067c:	00000097          	auipc	ra,0x0
    80000680:	b46080e7          	jalr	-1210(ra) # 800001c2 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000684:	4719                	li	a4,6
    80000686:	6685                	lui	a3,0x1
    80000688:	10000637          	lui	a2,0x10000
    8000068c:	100005b7          	lui	a1,0x10000
    80000690:	8526                	mv	a0,s1
    80000692:	00000097          	auipc	ra,0x0
    80000696:	fa0080e7          	jalr	-96(ra) # 80000632 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000069a:	4719                	li	a4,6
    8000069c:	6685                	lui	a3,0x1
    8000069e:	10001637          	lui	a2,0x10001
    800006a2:	100015b7          	lui	a1,0x10001
    800006a6:	8526                	mv	a0,s1
    800006a8:	00000097          	auipc	ra,0x0
    800006ac:	f8a080e7          	jalr	-118(ra) # 80000632 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800006b0:	4719                	li	a4,6
    800006b2:	004006b7          	lui	a3,0x400
    800006b6:	0c000637          	lui	a2,0xc000
    800006ba:	0c0005b7          	lui	a1,0xc000
    800006be:	8526                	mv	a0,s1
    800006c0:	00000097          	auipc	ra,0x0
    800006c4:	f72080e7          	jalr	-142(ra) # 80000632 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006c8:	00008917          	auipc	s2,0x8
    800006cc:	93890913          	addi	s2,s2,-1736 # 80008000 <etext>
    800006d0:	4729                	li	a4,10
    800006d2:	80008697          	auipc	a3,0x80008
    800006d6:	92e68693          	addi	a3,a3,-1746 # 8000 <_entry-0x7fff8000>
    800006da:	4605                	li	a2,1
    800006dc:	067e                	slli	a2,a2,0x1f
    800006de:	85b2                	mv	a1,a2
    800006e0:	8526                	mv	a0,s1
    800006e2:	00000097          	auipc	ra,0x0
    800006e6:	f50080e7          	jalr	-176(ra) # 80000632 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006ea:	4719                	li	a4,6
    800006ec:	46c5                	li	a3,17
    800006ee:	06ee                	slli	a3,a3,0x1b
    800006f0:	412686b3          	sub	a3,a3,s2
    800006f4:	864a                	mv	a2,s2
    800006f6:	85ca                	mv	a1,s2
    800006f8:	8526                	mv	a0,s1
    800006fa:	00000097          	auipc	ra,0x0
    800006fe:	f38080e7          	jalr	-200(ra) # 80000632 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000702:	4729                	li	a4,10
    80000704:	6685                	lui	a3,0x1
    80000706:	00007617          	auipc	a2,0x7
    8000070a:	8fa60613          	addi	a2,a2,-1798 # 80007000 <_trampoline>
    8000070e:	040005b7          	lui	a1,0x4000
    80000712:	15fd                	addi	a1,a1,-1
    80000714:	05b2                	slli	a1,a1,0xc
    80000716:	8526                	mv	a0,s1
    80000718:	00000097          	auipc	ra,0x0
    8000071c:	f1a080e7          	jalr	-230(ra) # 80000632 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000720:	8526                	mv	a0,s1
    80000722:	00000097          	auipc	ra,0x0
    80000726:	5fe080e7          	jalr	1534(ra) # 80000d20 <proc_mapstacks>
}
    8000072a:	8526                	mv	a0,s1
    8000072c:	60e2                	ld	ra,24(sp)
    8000072e:	6442                	ld	s0,16(sp)
    80000730:	64a2                	ld	s1,8(sp)
    80000732:	6902                	ld	s2,0(sp)
    80000734:	6105                	addi	sp,sp,32
    80000736:	8082                	ret

0000000080000738 <kvminit>:
{
    80000738:	1141                	addi	sp,sp,-16
    8000073a:	e406                	sd	ra,8(sp)
    8000073c:	e022                	sd	s0,0(sp)
    8000073e:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000740:	00000097          	auipc	ra,0x0
    80000744:	f22080e7          	jalr	-222(ra) # 80000662 <kvmmake>
    80000748:	00009797          	auipc	a5,0x9
    8000074c:	8ca7b023          	sd	a0,-1856(a5) # 80009008 <kernel_pagetable>
}
    80000750:	60a2                	ld	ra,8(sp)
    80000752:	6402                	ld	s0,0(sp)
    80000754:	0141                	addi	sp,sp,16
    80000756:	8082                	ret

0000000080000758 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000758:	715d                	addi	sp,sp,-80
    8000075a:	e486                	sd	ra,72(sp)
    8000075c:	e0a2                	sd	s0,64(sp)
    8000075e:	fc26                	sd	s1,56(sp)
    80000760:	f84a                	sd	s2,48(sp)
    80000762:	f44e                	sd	s3,40(sp)
    80000764:	f052                	sd	s4,32(sp)
    80000766:	ec56                	sd	s5,24(sp)
    80000768:	e85a                	sd	s6,16(sp)
    8000076a:	e45e                	sd	s7,8(sp)
    8000076c:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000076e:	03459793          	slli	a5,a1,0x34
    80000772:	e795                	bnez	a5,8000079e <uvmunmap+0x46>
    80000774:	8a2a                	mv	s4,a0
    80000776:	892e                	mv	s2,a1
    80000778:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000077a:	0632                	slli	a2,a2,0xc
    8000077c:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000780:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000782:	6b05                	lui	s6,0x1
    80000784:	0735e863          	bltu	a1,s3,800007f4 <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000788:	60a6                	ld	ra,72(sp)
    8000078a:	6406                	ld	s0,64(sp)
    8000078c:	74e2                	ld	s1,56(sp)
    8000078e:	7942                	ld	s2,48(sp)
    80000790:	79a2                	ld	s3,40(sp)
    80000792:	7a02                	ld	s4,32(sp)
    80000794:	6ae2                	ld	s5,24(sp)
    80000796:	6b42                	ld	s6,16(sp)
    80000798:	6ba2                	ld	s7,8(sp)
    8000079a:	6161                	addi	sp,sp,80
    8000079c:	8082                	ret
    panic("uvmunmap: not aligned");
    8000079e:	00008517          	auipc	a0,0x8
    800007a2:	8e250513          	addi	a0,a0,-1822 # 80008080 <etext+0x80>
    800007a6:	00005097          	auipc	ra,0x5
    800007aa:	4c2080e7          	jalr	1218(ra) # 80005c68 <panic>
      panic("uvmunmap: walk");
    800007ae:	00008517          	auipc	a0,0x8
    800007b2:	8ea50513          	addi	a0,a0,-1814 # 80008098 <etext+0x98>
    800007b6:	00005097          	auipc	ra,0x5
    800007ba:	4b2080e7          	jalr	1202(ra) # 80005c68 <panic>
      panic("uvmunmap: not mapped");
    800007be:	00008517          	auipc	a0,0x8
    800007c2:	8ea50513          	addi	a0,a0,-1814 # 800080a8 <etext+0xa8>
    800007c6:	00005097          	auipc	ra,0x5
    800007ca:	4a2080e7          	jalr	1186(ra) # 80005c68 <panic>
      panic("uvmunmap: not a leaf");
    800007ce:	00008517          	auipc	a0,0x8
    800007d2:	8f250513          	addi	a0,a0,-1806 # 800080c0 <etext+0xc0>
    800007d6:	00005097          	auipc	ra,0x5
    800007da:	492080e7          	jalr	1170(ra) # 80005c68 <panic>
      uint64 pa = PTE2PA(*pte);
    800007de:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007e0:	0532                	slli	a0,a0,0xc
    800007e2:	00000097          	auipc	ra,0x0
    800007e6:	83a080e7          	jalr	-1990(ra) # 8000001c <kfree>
    *pte = 0;
    800007ea:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007ee:	995a                	add	s2,s2,s6
    800007f0:	f9397ce3          	bgeu	s2,s3,80000788 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007f4:	4601                	li	a2,0
    800007f6:	85ca                	mv	a1,s2
    800007f8:	8552                	mv	a0,s4
    800007fa:	00000097          	auipc	ra,0x0
    800007fe:	cb0080e7          	jalr	-848(ra) # 800004aa <walk>
    80000802:	84aa                	mv	s1,a0
    80000804:	d54d                	beqz	a0,800007ae <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    80000806:	6108                	ld	a0,0(a0)
    80000808:	00157793          	andi	a5,a0,1
    8000080c:	dbcd                	beqz	a5,800007be <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000080e:	3ff57793          	andi	a5,a0,1023
    80000812:	fb778ee3          	beq	a5,s7,800007ce <uvmunmap+0x76>
    if(do_free){
    80000816:	fc0a8ae3          	beqz	s5,800007ea <uvmunmap+0x92>
    8000081a:	b7d1                	j	800007de <uvmunmap+0x86>

000000008000081c <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000081c:	1101                	addi	sp,sp,-32
    8000081e:	ec06                	sd	ra,24(sp)
    80000820:	e822                	sd	s0,16(sp)
    80000822:	e426                	sd	s1,8(sp)
    80000824:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000826:	00000097          	auipc	ra,0x0
    8000082a:	8f2080e7          	jalr	-1806(ra) # 80000118 <kalloc>
    8000082e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000830:	c519                	beqz	a0,8000083e <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000832:	6605                	lui	a2,0x1
    80000834:	4581                	li	a1,0
    80000836:	00000097          	auipc	ra,0x0
    8000083a:	98c080e7          	jalr	-1652(ra) # 800001c2 <memset>
  return pagetable;
}
    8000083e:	8526                	mv	a0,s1
    80000840:	60e2                	ld	ra,24(sp)
    80000842:	6442                	ld	s0,16(sp)
    80000844:	64a2                	ld	s1,8(sp)
    80000846:	6105                	addi	sp,sp,32
    80000848:	8082                	ret

000000008000084a <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    8000084a:	7179                	addi	sp,sp,-48
    8000084c:	f406                	sd	ra,40(sp)
    8000084e:	f022                	sd	s0,32(sp)
    80000850:	ec26                	sd	s1,24(sp)
    80000852:	e84a                	sd	s2,16(sp)
    80000854:	e44e                	sd	s3,8(sp)
    80000856:	e052                	sd	s4,0(sp)
    80000858:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000085a:	6785                	lui	a5,0x1
    8000085c:	04f67863          	bgeu	a2,a5,800008ac <uvminit+0x62>
    80000860:	8a2a                	mv	s4,a0
    80000862:	89ae                	mv	s3,a1
    80000864:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000866:	00000097          	auipc	ra,0x0
    8000086a:	8b2080e7          	jalr	-1870(ra) # 80000118 <kalloc>
    8000086e:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000870:	6605                	lui	a2,0x1
    80000872:	4581                	li	a1,0
    80000874:	00000097          	auipc	ra,0x0
    80000878:	94e080e7          	jalr	-1714(ra) # 800001c2 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000087c:	4779                	li	a4,30
    8000087e:	86ca                	mv	a3,s2
    80000880:	6605                	lui	a2,0x1
    80000882:	4581                	li	a1,0
    80000884:	8552                	mv	a0,s4
    80000886:	00000097          	auipc	ra,0x0
    8000088a:	d0c080e7          	jalr	-756(ra) # 80000592 <mappages>
  memmove(mem, src, sz);
    8000088e:	8626                	mv	a2,s1
    80000890:	85ce                	mv	a1,s3
    80000892:	854a                	mv	a0,s2
    80000894:	00000097          	auipc	ra,0x0
    80000898:	98e080e7          	jalr	-1650(ra) # 80000222 <memmove>
}
    8000089c:	70a2                	ld	ra,40(sp)
    8000089e:	7402                	ld	s0,32(sp)
    800008a0:	64e2                	ld	s1,24(sp)
    800008a2:	6942                	ld	s2,16(sp)
    800008a4:	69a2                	ld	s3,8(sp)
    800008a6:	6a02                	ld	s4,0(sp)
    800008a8:	6145                	addi	sp,sp,48
    800008aa:	8082                	ret
    panic("inituvm: more than a page");
    800008ac:	00008517          	auipc	a0,0x8
    800008b0:	82c50513          	addi	a0,a0,-2004 # 800080d8 <etext+0xd8>
    800008b4:	00005097          	auipc	ra,0x5
    800008b8:	3b4080e7          	jalr	948(ra) # 80005c68 <panic>

00000000800008bc <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800008bc:	1101                	addi	sp,sp,-32
    800008be:	ec06                	sd	ra,24(sp)
    800008c0:	e822                	sd	s0,16(sp)
    800008c2:	e426                	sd	s1,8(sp)
    800008c4:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008c6:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008c8:	00b67d63          	bgeu	a2,a1,800008e2 <uvmdealloc+0x26>
    800008cc:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008ce:	6785                	lui	a5,0x1
    800008d0:	17fd                	addi	a5,a5,-1
    800008d2:	00f60733          	add	a4,a2,a5
    800008d6:	767d                	lui	a2,0xfffff
    800008d8:	8f71                	and	a4,a4,a2
    800008da:	97ae                	add	a5,a5,a1
    800008dc:	8ff1                	and	a5,a5,a2
    800008de:	00f76863          	bltu	a4,a5,800008ee <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008e2:	8526                	mv	a0,s1
    800008e4:	60e2                	ld	ra,24(sp)
    800008e6:	6442                	ld	s0,16(sp)
    800008e8:	64a2                	ld	s1,8(sp)
    800008ea:	6105                	addi	sp,sp,32
    800008ec:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008ee:	8f99                	sub	a5,a5,a4
    800008f0:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008f2:	4685                	li	a3,1
    800008f4:	0007861b          	sext.w	a2,a5
    800008f8:	85ba                	mv	a1,a4
    800008fa:	00000097          	auipc	ra,0x0
    800008fe:	e5e080e7          	jalr	-418(ra) # 80000758 <uvmunmap>
    80000902:	b7c5                	j	800008e2 <uvmdealloc+0x26>

0000000080000904 <uvmalloc>:
  if(newsz < oldsz)
    80000904:	0ab66163          	bltu	a2,a1,800009a6 <uvmalloc+0xa2>
{
    80000908:	7139                	addi	sp,sp,-64
    8000090a:	fc06                	sd	ra,56(sp)
    8000090c:	f822                	sd	s0,48(sp)
    8000090e:	f426                	sd	s1,40(sp)
    80000910:	f04a                	sd	s2,32(sp)
    80000912:	ec4e                	sd	s3,24(sp)
    80000914:	e852                	sd	s4,16(sp)
    80000916:	e456                	sd	s5,8(sp)
    80000918:	0080                	addi	s0,sp,64
    8000091a:	8aaa                	mv	s5,a0
    8000091c:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000091e:	6985                	lui	s3,0x1
    80000920:	19fd                	addi	s3,s3,-1
    80000922:	95ce                	add	a1,a1,s3
    80000924:	79fd                	lui	s3,0xfffff
    80000926:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000092a:	08c9f063          	bgeu	s3,a2,800009aa <uvmalloc+0xa6>
    8000092e:	894e                	mv	s2,s3
    mem = kalloc();
    80000930:	fffff097          	auipc	ra,0xfffff
    80000934:	7e8080e7          	jalr	2024(ra) # 80000118 <kalloc>
    80000938:	84aa                	mv	s1,a0
    if(mem == 0){
    8000093a:	c51d                	beqz	a0,80000968 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    8000093c:	6605                	lui	a2,0x1
    8000093e:	4581                	li	a1,0
    80000940:	00000097          	auipc	ra,0x0
    80000944:	882080e7          	jalr	-1918(ra) # 800001c2 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000948:	4779                	li	a4,30
    8000094a:	86a6                	mv	a3,s1
    8000094c:	6605                	lui	a2,0x1
    8000094e:	85ca                	mv	a1,s2
    80000950:	8556                	mv	a0,s5
    80000952:	00000097          	auipc	ra,0x0
    80000956:	c40080e7          	jalr	-960(ra) # 80000592 <mappages>
    8000095a:	e905                	bnez	a0,8000098a <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000095c:	6785                	lui	a5,0x1
    8000095e:	993e                	add	s2,s2,a5
    80000960:	fd4968e3          	bltu	s2,s4,80000930 <uvmalloc+0x2c>
  return newsz;
    80000964:	8552                	mv	a0,s4
    80000966:	a809                	j	80000978 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000968:	864e                	mv	a2,s3
    8000096a:	85ca                	mv	a1,s2
    8000096c:	8556                	mv	a0,s5
    8000096e:	00000097          	auipc	ra,0x0
    80000972:	f4e080e7          	jalr	-178(ra) # 800008bc <uvmdealloc>
      return 0;
    80000976:	4501                	li	a0,0
}
    80000978:	70e2                	ld	ra,56(sp)
    8000097a:	7442                	ld	s0,48(sp)
    8000097c:	74a2                	ld	s1,40(sp)
    8000097e:	7902                	ld	s2,32(sp)
    80000980:	69e2                	ld	s3,24(sp)
    80000982:	6a42                	ld	s4,16(sp)
    80000984:	6aa2                	ld	s5,8(sp)
    80000986:	6121                	addi	sp,sp,64
    80000988:	8082                	ret
      kfree(mem);
    8000098a:	8526                	mv	a0,s1
    8000098c:	fffff097          	auipc	ra,0xfffff
    80000990:	690080e7          	jalr	1680(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000994:	864e                	mv	a2,s3
    80000996:	85ca                	mv	a1,s2
    80000998:	8556                	mv	a0,s5
    8000099a:	00000097          	auipc	ra,0x0
    8000099e:	f22080e7          	jalr	-222(ra) # 800008bc <uvmdealloc>
      return 0;
    800009a2:	4501                	li	a0,0
    800009a4:	bfd1                	j	80000978 <uvmalloc+0x74>
    return oldsz;
    800009a6:	852e                	mv	a0,a1
}
    800009a8:	8082                	ret
  return newsz;
    800009aa:	8532                	mv	a0,a2
    800009ac:	b7f1                	j	80000978 <uvmalloc+0x74>

00000000800009ae <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800009ae:	7179                	addi	sp,sp,-48
    800009b0:	f406                	sd	ra,40(sp)
    800009b2:	f022                	sd	s0,32(sp)
    800009b4:	ec26                	sd	s1,24(sp)
    800009b6:	e84a                	sd	s2,16(sp)
    800009b8:	e44e                	sd	s3,8(sp)
    800009ba:	e052                	sd	s4,0(sp)
    800009bc:	1800                	addi	s0,sp,48
    800009be:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009c0:	84aa                	mv	s1,a0
    800009c2:	6905                	lui	s2,0x1
    800009c4:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009c6:	4985                	li	s3,1
    800009c8:	a821                	j	800009e0 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009ca:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800009cc:	0532                	slli	a0,a0,0xc
    800009ce:	00000097          	auipc	ra,0x0
    800009d2:	fe0080e7          	jalr	-32(ra) # 800009ae <freewalk>
      pagetable[i] = 0;
    800009d6:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009da:	04a1                	addi	s1,s1,8
    800009dc:	03248163          	beq	s1,s2,800009fe <freewalk+0x50>
    pte_t pte = pagetable[i];
    800009e0:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009e2:	00f57793          	andi	a5,a0,15
    800009e6:	ff3782e3          	beq	a5,s3,800009ca <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009ea:	8905                	andi	a0,a0,1
    800009ec:	d57d                	beqz	a0,800009da <freewalk+0x2c>
      panic("freewalk: leaf");
    800009ee:	00007517          	auipc	a0,0x7
    800009f2:	70a50513          	addi	a0,a0,1802 # 800080f8 <etext+0xf8>
    800009f6:	00005097          	auipc	ra,0x5
    800009fa:	272080e7          	jalr	626(ra) # 80005c68 <panic>
    }
  }
  kfree((void*)pagetable);
    800009fe:	8552                	mv	a0,s4
    80000a00:	fffff097          	auipc	ra,0xfffff
    80000a04:	61c080e7          	jalr	1564(ra) # 8000001c <kfree>
}
    80000a08:	70a2                	ld	ra,40(sp)
    80000a0a:	7402                	ld	s0,32(sp)
    80000a0c:	64e2                	ld	s1,24(sp)
    80000a0e:	6942                	ld	s2,16(sp)
    80000a10:	69a2                	ld	s3,8(sp)
    80000a12:	6a02                	ld	s4,0(sp)
    80000a14:	6145                	addi	sp,sp,48
    80000a16:	8082                	ret

0000000080000a18 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a18:	1101                	addi	sp,sp,-32
    80000a1a:	ec06                	sd	ra,24(sp)
    80000a1c:	e822                	sd	s0,16(sp)
    80000a1e:	e426                	sd	s1,8(sp)
    80000a20:	1000                	addi	s0,sp,32
    80000a22:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a24:	e999                	bnez	a1,80000a3a <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a26:	8526                	mv	a0,s1
    80000a28:	00000097          	auipc	ra,0x0
    80000a2c:	f86080e7          	jalr	-122(ra) # 800009ae <freewalk>
}
    80000a30:	60e2                	ld	ra,24(sp)
    80000a32:	6442                	ld	s0,16(sp)
    80000a34:	64a2                	ld	s1,8(sp)
    80000a36:	6105                	addi	sp,sp,32
    80000a38:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a3a:	6605                	lui	a2,0x1
    80000a3c:	167d                	addi	a2,a2,-1
    80000a3e:	962e                	add	a2,a2,a1
    80000a40:	4685                	li	a3,1
    80000a42:	8231                	srli	a2,a2,0xc
    80000a44:	4581                	li	a1,0
    80000a46:	00000097          	auipc	ra,0x0
    80000a4a:	d12080e7          	jalr	-750(ra) # 80000758 <uvmunmap>
    80000a4e:	bfe1                	j	80000a26 <uvmfree+0xe>

0000000080000a50 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a50:	c679                	beqz	a2,80000b1e <uvmcopy+0xce>
{
    80000a52:	715d                	addi	sp,sp,-80
    80000a54:	e486                	sd	ra,72(sp)
    80000a56:	e0a2                	sd	s0,64(sp)
    80000a58:	fc26                	sd	s1,56(sp)
    80000a5a:	f84a                	sd	s2,48(sp)
    80000a5c:	f44e                	sd	s3,40(sp)
    80000a5e:	f052                	sd	s4,32(sp)
    80000a60:	ec56                	sd	s5,24(sp)
    80000a62:	e85a                	sd	s6,16(sp)
    80000a64:	e45e                	sd	s7,8(sp)
    80000a66:	0880                	addi	s0,sp,80
    80000a68:	8b2a                	mv	s6,a0
    80000a6a:	8aae                	mv	s5,a1
    80000a6c:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a6e:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a70:	4601                	li	a2,0
    80000a72:	85ce                	mv	a1,s3
    80000a74:	855a                	mv	a0,s6
    80000a76:	00000097          	auipc	ra,0x0
    80000a7a:	a34080e7          	jalr	-1484(ra) # 800004aa <walk>
    80000a7e:	c531                	beqz	a0,80000aca <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a80:	6118                	ld	a4,0(a0)
    80000a82:	00177793          	andi	a5,a4,1
    80000a86:	cbb1                	beqz	a5,80000ada <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a88:	00a75593          	srli	a1,a4,0xa
    80000a8c:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a90:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a94:	fffff097          	auipc	ra,0xfffff
    80000a98:	684080e7          	jalr	1668(ra) # 80000118 <kalloc>
    80000a9c:	892a                	mv	s2,a0
    80000a9e:	c939                	beqz	a0,80000af4 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000aa0:	6605                	lui	a2,0x1
    80000aa2:	85de                	mv	a1,s7
    80000aa4:	fffff097          	auipc	ra,0xfffff
    80000aa8:	77e080e7          	jalr	1918(ra) # 80000222 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000aac:	8726                	mv	a4,s1
    80000aae:	86ca                	mv	a3,s2
    80000ab0:	6605                	lui	a2,0x1
    80000ab2:	85ce                	mv	a1,s3
    80000ab4:	8556                	mv	a0,s5
    80000ab6:	00000097          	auipc	ra,0x0
    80000aba:	adc080e7          	jalr	-1316(ra) # 80000592 <mappages>
    80000abe:	e515                	bnez	a0,80000aea <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000ac0:	6785                	lui	a5,0x1
    80000ac2:	99be                	add	s3,s3,a5
    80000ac4:	fb49e6e3          	bltu	s3,s4,80000a70 <uvmcopy+0x20>
    80000ac8:	a081                	j	80000b08 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000aca:	00007517          	auipc	a0,0x7
    80000ace:	63e50513          	addi	a0,a0,1598 # 80008108 <etext+0x108>
    80000ad2:	00005097          	auipc	ra,0x5
    80000ad6:	196080e7          	jalr	406(ra) # 80005c68 <panic>
      panic("uvmcopy: page not present");
    80000ada:	00007517          	auipc	a0,0x7
    80000ade:	64e50513          	addi	a0,a0,1614 # 80008128 <etext+0x128>
    80000ae2:	00005097          	auipc	ra,0x5
    80000ae6:	186080e7          	jalr	390(ra) # 80005c68 <panic>
      kfree(mem);
    80000aea:	854a                	mv	a0,s2
    80000aec:	fffff097          	auipc	ra,0xfffff
    80000af0:	530080e7          	jalr	1328(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000af4:	4685                	li	a3,1
    80000af6:	00c9d613          	srli	a2,s3,0xc
    80000afa:	4581                	li	a1,0
    80000afc:	8556                	mv	a0,s5
    80000afe:	00000097          	auipc	ra,0x0
    80000b02:	c5a080e7          	jalr	-934(ra) # 80000758 <uvmunmap>
  return -1;
    80000b06:	557d                	li	a0,-1
}
    80000b08:	60a6                	ld	ra,72(sp)
    80000b0a:	6406                	ld	s0,64(sp)
    80000b0c:	74e2                	ld	s1,56(sp)
    80000b0e:	7942                	ld	s2,48(sp)
    80000b10:	79a2                	ld	s3,40(sp)
    80000b12:	7a02                	ld	s4,32(sp)
    80000b14:	6ae2                	ld	s5,24(sp)
    80000b16:	6b42                	ld	s6,16(sp)
    80000b18:	6ba2                	ld	s7,8(sp)
    80000b1a:	6161                	addi	sp,sp,80
    80000b1c:	8082                	ret
  return 0;
    80000b1e:	4501                	li	a0,0
}
    80000b20:	8082                	ret

0000000080000b22 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b22:	1141                	addi	sp,sp,-16
    80000b24:	e406                	sd	ra,8(sp)
    80000b26:	e022                	sd	s0,0(sp)
    80000b28:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b2a:	4601                	li	a2,0
    80000b2c:	00000097          	auipc	ra,0x0
    80000b30:	97e080e7          	jalr	-1666(ra) # 800004aa <walk>
  if(pte == 0)
    80000b34:	c901                	beqz	a0,80000b44 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b36:	611c                	ld	a5,0(a0)
    80000b38:	9bbd                	andi	a5,a5,-17
    80000b3a:	e11c                	sd	a5,0(a0)
}
    80000b3c:	60a2                	ld	ra,8(sp)
    80000b3e:	6402                	ld	s0,0(sp)
    80000b40:	0141                	addi	sp,sp,16
    80000b42:	8082                	ret
    panic("uvmclear");
    80000b44:	00007517          	auipc	a0,0x7
    80000b48:	60450513          	addi	a0,a0,1540 # 80008148 <etext+0x148>
    80000b4c:	00005097          	auipc	ra,0x5
    80000b50:	11c080e7          	jalr	284(ra) # 80005c68 <panic>

0000000080000b54 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b54:	c6bd                	beqz	a3,80000bc2 <copyout+0x6e>
{
    80000b56:	715d                	addi	sp,sp,-80
    80000b58:	e486                	sd	ra,72(sp)
    80000b5a:	e0a2                	sd	s0,64(sp)
    80000b5c:	fc26                	sd	s1,56(sp)
    80000b5e:	f84a                	sd	s2,48(sp)
    80000b60:	f44e                	sd	s3,40(sp)
    80000b62:	f052                	sd	s4,32(sp)
    80000b64:	ec56                	sd	s5,24(sp)
    80000b66:	e85a                	sd	s6,16(sp)
    80000b68:	e45e                	sd	s7,8(sp)
    80000b6a:	e062                	sd	s8,0(sp)
    80000b6c:	0880                	addi	s0,sp,80
    80000b6e:	8b2a                	mv	s6,a0
    80000b70:	8c2e                	mv	s8,a1
    80000b72:	8a32                	mv	s4,a2
    80000b74:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b76:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b78:	6a85                	lui	s5,0x1
    80000b7a:	a015                	j	80000b9e <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b7c:	9562                	add	a0,a0,s8
    80000b7e:	0004861b          	sext.w	a2,s1
    80000b82:	85d2                	mv	a1,s4
    80000b84:	41250533          	sub	a0,a0,s2
    80000b88:	fffff097          	auipc	ra,0xfffff
    80000b8c:	69a080e7          	jalr	1690(ra) # 80000222 <memmove>

    len -= n;
    80000b90:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b94:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b96:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b9a:	02098263          	beqz	s3,80000bbe <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b9e:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000ba2:	85ca                	mv	a1,s2
    80000ba4:	855a                	mv	a0,s6
    80000ba6:	00000097          	auipc	ra,0x0
    80000baa:	9aa080e7          	jalr	-1622(ra) # 80000550 <walkaddr>
    if(pa0 == 0)
    80000bae:	cd01                	beqz	a0,80000bc6 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000bb0:	418904b3          	sub	s1,s2,s8
    80000bb4:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bb6:	fc99f3e3          	bgeu	s3,s1,80000b7c <copyout+0x28>
    80000bba:	84ce                	mv	s1,s3
    80000bbc:	b7c1                	j	80000b7c <copyout+0x28>
  }
  return 0;
    80000bbe:	4501                	li	a0,0
    80000bc0:	a021                	j	80000bc8 <copyout+0x74>
    80000bc2:	4501                	li	a0,0
}
    80000bc4:	8082                	ret
      return -1;
    80000bc6:	557d                	li	a0,-1
}
    80000bc8:	60a6                	ld	ra,72(sp)
    80000bca:	6406                	ld	s0,64(sp)
    80000bcc:	74e2                	ld	s1,56(sp)
    80000bce:	7942                	ld	s2,48(sp)
    80000bd0:	79a2                	ld	s3,40(sp)
    80000bd2:	7a02                	ld	s4,32(sp)
    80000bd4:	6ae2                	ld	s5,24(sp)
    80000bd6:	6b42                	ld	s6,16(sp)
    80000bd8:	6ba2                	ld	s7,8(sp)
    80000bda:	6c02                	ld	s8,0(sp)
    80000bdc:	6161                	addi	sp,sp,80
    80000bde:	8082                	ret

0000000080000be0 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000be0:	c6bd                	beqz	a3,80000c4e <copyin+0x6e>
{
    80000be2:	715d                	addi	sp,sp,-80
    80000be4:	e486                	sd	ra,72(sp)
    80000be6:	e0a2                	sd	s0,64(sp)
    80000be8:	fc26                	sd	s1,56(sp)
    80000bea:	f84a                	sd	s2,48(sp)
    80000bec:	f44e                	sd	s3,40(sp)
    80000bee:	f052                	sd	s4,32(sp)
    80000bf0:	ec56                	sd	s5,24(sp)
    80000bf2:	e85a                	sd	s6,16(sp)
    80000bf4:	e45e                	sd	s7,8(sp)
    80000bf6:	e062                	sd	s8,0(sp)
    80000bf8:	0880                	addi	s0,sp,80
    80000bfa:	8b2a                	mv	s6,a0
    80000bfc:	8a2e                	mv	s4,a1
    80000bfe:	8c32                	mv	s8,a2
    80000c00:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c02:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c04:	6a85                	lui	s5,0x1
    80000c06:	a015                	j	80000c2a <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c08:	9562                	add	a0,a0,s8
    80000c0a:	0004861b          	sext.w	a2,s1
    80000c0e:	412505b3          	sub	a1,a0,s2
    80000c12:	8552                	mv	a0,s4
    80000c14:	fffff097          	auipc	ra,0xfffff
    80000c18:	60e080e7          	jalr	1550(ra) # 80000222 <memmove>

    len -= n;
    80000c1c:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c20:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c22:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c26:	02098263          	beqz	s3,80000c4a <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000c2a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c2e:	85ca                	mv	a1,s2
    80000c30:	855a                	mv	a0,s6
    80000c32:	00000097          	auipc	ra,0x0
    80000c36:	91e080e7          	jalr	-1762(ra) # 80000550 <walkaddr>
    if(pa0 == 0)
    80000c3a:	cd01                	beqz	a0,80000c52 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000c3c:	418904b3          	sub	s1,s2,s8
    80000c40:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c42:	fc99f3e3          	bgeu	s3,s1,80000c08 <copyin+0x28>
    80000c46:	84ce                	mv	s1,s3
    80000c48:	b7c1                	j	80000c08 <copyin+0x28>
  }
  return 0;
    80000c4a:	4501                	li	a0,0
    80000c4c:	a021                	j	80000c54 <copyin+0x74>
    80000c4e:	4501                	li	a0,0
}
    80000c50:	8082                	ret
      return -1;
    80000c52:	557d                	li	a0,-1
}
    80000c54:	60a6                	ld	ra,72(sp)
    80000c56:	6406                	ld	s0,64(sp)
    80000c58:	74e2                	ld	s1,56(sp)
    80000c5a:	7942                	ld	s2,48(sp)
    80000c5c:	79a2                	ld	s3,40(sp)
    80000c5e:	7a02                	ld	s4,32(sp)
    80000c60:	6ae2                	ld	s5,24(sp)
    80000c62:	6b42                	ld	s6,16(sp)
    80000c64:	6ba2                	ld	s7,8(sp)
    80000c66:	6c02                	ld	s8,0(sp)
    80000c68:	6161                	addi	sp,sp,80
    80000c6a:	8082                	ret

0000000080000c6c <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c6c:	c6c5                	beqz	a3,80000d14 <copyinstr+0xa8>
{
    80000c6e:	715d                	addi	sp,sp,-80
    80000c70:	e486                	sd	ra,72(sp)
    80000c72:	e0a2                	sd	s0,64(sp)
    80000c74:	fc26                	sd	s1,56(sp)
    80000c76:	f84a                	sd	s2,48(sp)
    80000c78:	f44e                	sd	s3,40(sp)
    80000c7a:	f052                	sd	s4,32(sp)
    80000c7c:	ec56                	sd	s5,24(sp)
    80000c7e:	e85a                	sd	s6,16(sp)
    80000c80:	e45e                	sd	s7,8(sp)
    80000c82:	0880                	addi	s0,sp,80
    80000c84:	8a2a                	mv	s4,a0
    80000c86:	8b2e                	mv	s6,a1
    80000c88:	8bb2                	mv	s7,a2
    80000c8a:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c8c:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c8e:	6985                	lui	s3,0x1
    80000c90:	a035                	j	80000cbc <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c92:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c96:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c98:	0017b793          	seqz	a5,a5
    80000c9c:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000ca0:	60a6                	ld	ra,72(sp)
    80000ca2:	6406                	ld	s0,64(sp)
    80000ca4:	74e2                	ld	s1,56(sp)
    80000ca6:	7942                	ld	s2,48(sp)
    80000ca8:	79a2                	ld	s3,40(sp)
    80000caa:	7a02                	ld	s4,32(sp)
    80000cac:	6ae2                	ld	s5,24(sp)
    80000cae:	6b42                	ld	s6,16(sp)
    80000cb0:	6ba2                	ld	s7,8(sp)
    80000cb2:	6161                	addi	sp,sp,80
    80000cb4:	8082                	ret
    srcva = va0 + PGSIZE;
    80000cb6:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000cba:	c8a9                	beqz	s1,80000d0c <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000cbc:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000cc0:	85ca                	mv	a1,s2
    80000cc2:	8552                	mv	a0,s4
    80000cc4:	00000097          	auipc	ra,0x0
    80000cc8:	88c080e7          	jalr	-1908(ra) # 80000550 <walkaddr>
    if(pa0 == 0)
    80000ccc:	c131                	beqz	a0,80000d10 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000cce:	41790833          	sub	a6,s2,s7
    80000cd2:	984e                	add	a6,a6,s3
    if(n > max)
    80000cd4:	0104f363          	bgeu	s1,a6,80000cda <copyinstr+0x6e>
    80000cd8:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000cda:	955e                	add	a0,a0,s7
    80000cdc:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000ce0:	fc080be3          	beqz	a6,80000cb6 <copyinstr+0x4a>
    80000ce4:	985a                	add	a6,a6,s6
    80000ce6:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000ce8:	41650633          	sub	a2,a0,s6
    80000cec:	14fd                	addi	s1,s1,-1
    80000cee:	9b26                	add	s6,s6,s1
    80000cf0:	00f60733          	add	a4,a2,a5
    80000cf4:	00074703          	lbu	a4,0(a4)
    80000cf8:	df49                	beqz	a4,80000c92 <copyinstr+0x26>
        *dst = *p;
    80000cfa:	00e78023          	sb	a4,0(a5)
      --max;
    80000cfe:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000d02:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d04:	ff0796e3          	bne	a5,a6,80000cf0 <copyinstr+0x84>
      dst++;
    80000d08:	8b42                	mv	s6,a6
    80000d0a:	b775                	j	80000cb6 <copyinstr+0x4a>
    80000d0c:	4781                	li	a5,0
    80000d0e:	b769                	j	80000c98 <copyinstr+0x2c>
      return -1;
    80000d10:	557d                	li	a0,-1
    80000d12:	b779                	j	80000ca0 <copyinstr+0x34>
  int got_null = 0;
    80000d14:	4781                	li	a5,0
  if(got_null){
    80000d16:	0017b793          	seqz	a5,a5
    80000d1a:	40f00533          	neg	a0,a5
}
    80000d1e:	8082                	ret

0000000080000d20 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl)
{
    80000d20:	7139                	addi	sp,sp,-64
    80000d22:	fc06                	sd	ra,56(sp)
    80000d24:	f822                	sd	s0,48(sp)
    80000d26:	f426                	sd	s1,40(sp)
    80000d28:	f04a                	sd	s2,32(sp)
    80000d2a:	ec4e                	sd	s3,24(sp)
    80000d2c:	e852                	sd	s4,16(sp)
    80000d2e:	e456                	sd	s5,8(sp)
    80000d30:	e05a                	sd	s6,0(sp)
    80000d32:	0080                	addi	s0,sp,64
    80000d34:	89aa                	mv	s3,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    80000d36:	00008497          	auipc	s1,0x8
    80000d3a:	74a48493          	addi	s1,s1,1866 # 80009480 <proc>
  {
    char *pa = kalloc();
    if (pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    80000d3e:	8b26                	mv	s6,s1
    80000d40:	00007a97          	auipc	s5,0x7
    80000d44:	2c0a8a93          	addi	s5,s5,704 # 80008000 <etext>
    80000d48:	04000937          	lui	s2,0x4000
    80000d4c:	197d                	addi	s2,s2,-1
    80000d4e:	0932                	slli	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++)
    80000d50:	0000fa17          	auipc	s4,0xf
    80000d54:	930a0a13          	addi	s4,s4,-1744 # 8000f680 <tickslock>
    char *pa = kalloc();
    80000d58:	fffff097          	auipc	ra,0xfffff
    80000d5c:	3c0080e7          	jalr	960(ra) # 80000118 <kalloc>
    80000d60:	862a                	mv	a2,a0
    if (pa == 0)
    80000d62:	c131                	beqz	a0,80000da6 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int)(p - proc));
    80000d64:	416485b3          	sub	a1,s1,s6
    80000d68:	858d                	srai	a1,a1,0x3
    80000d6a:	000ab783          	ld	a5,0(s5)
    80000d6e:	02f585b3          	mul	a1,a1,a5
    80000d72:	2585                	addiw	a1,a1,1
    80000d74:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d78:	4719                	li	a4,6
    80000d7a:	6685                	lui	a3,0x1
    80000d7c:	40b905b3          	sub	a1,s2,a1
    80000d80:	854e                	mv	a0,s3
    80000d82:	00000097          	auipc	ra,0x0
    80000d86:	8b0080e7          	jalr	-1872(ra) # 80000632 <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++)
    80000d8a:	18848493          	addi	s1,s1,392
    80000d8e:	fd4495e3          	bne	s1,s4,80000d58 <proc_mapstacks+0x38>
  }
}
    80000d92:	70e2                	ld	ra,56(sp)
    80000d94:	7442                	ld	s0,48(sp)
    80000d96:	74a2                	ld	s1,40(sp)
    80000d98:	7902                	ld	s2,32(sp)
    80000d9a:	69e2                	ld	s3,24(sp)
    80000d9c:	6a42                	ld	s4,16(sp)
    80000d9e:	6aa2                	ld	s5,8(sp)
    80000da0:	6b02                	ld	s6,0(sp)
    80000da2:	6121                	addi	sp,sp,64
    80000da4:	8082                	ret
      panic("kalloc");
    80000da6:	00007517          	auipc	a0,0x7
    80000daa:	3b250513          	addi	a0,a0,946 # 80008158 <etext+0x158>
    80000dae:	00005097          	auipc	ra,0x5
    80000db2:	eba080e7          	jalr	-326(ra) # 80005c68 <panic>

0000000080000db6 <procinit>:

// initialize the proc table at boot time.
void procinit(void)
{
    80000db6:	7139                	addi	sp,sp,-64
    80000db8:	fc06                	sd	ra,56(sp)
    80000dba:	f822                	sd	s0,48(sp)
    80000dbc:	f426                	sd	s1,40(sp)
    80000dbe:	f04a                	sd	s2,32(sp)
    80000dc0:	ec4e                	sd	s3,24(sp)
    80000dc2:	e852                	sd	s4,16(sp)
    80000dc4:	e456                	sd	s5,8(sp)
    80000dc6:	e05a                	sd	s6,0(sp)
    80000dc8:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    80000dca:	00007597          	auipc	a1,0x7
    80000dce:	39658593          	addi	a1,a1,918 # 80008160 <etext+0x160>
    80000dd2:	00008517          	auipc	a0,0x8
    80000dd6:	27e50513          	addi	a0,a0,638 # 80009050 <pid_lock>
    80000dda:	00005097          	auipc	ra,0x5
    80000dde:	348080e7          	jalr	840(ra) # 80006122 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000de2:	00007597          	auipc	a1,0x7
    80000de6:	38658593          	addi	a1,a1,902 # 80008168 <etext+0x168>
    80000dea:	00008517          	auipc	a0,0x8
    80000dee:	27e50513          	addi	a0,a0,638 # 80009068 <wait_lock>
    80000df2:	00005097          	auipc	ra,0x5
    80000df6:	330080e7          	jalr	816(ra) # 80006122 <initlock>
  for (p = proc; p < &proc[NPROC]; p++)
    80000dfa:	00008497          	auipc	s1,0x8
    80000dfe:	68648493          	addi	s1,s1,1670 # 80009480 <proc>
  {
    initlock(&p->lock, "proc");
    80000e02:	00007b17          	auipc	s6,0x7
    80000e06:	376b0b13          	addi	s6,s6,886 # 80008178 <etext+0x178>
    p->kstack = KSTACK((int)(p - proc));
    80000e0a:	8aa6                	mv	s5,s1
    80000e0c:	00007a17          	auipc	s4,0x7
    80000e10:	1f4a0a13          	addi	s4,s4,500 # 80008000 <etext>
    80000e14:	04000937          	lui	s2,0x4000
    80000e18:	197d                	addi	s2,s2,-1
    80000e1a:	0932                	slli	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++)
    80000e1c:	0000f997          	auipc	s3,0xf
    80000e20:	86498993          	addi	s3,s3,-1948 # 8000f680 <tickslock>
    initlock(&p->lock, "proc");
    80000e24:	85da                	mv	a1,s6
    80000e26:	8526                	mv	a0,s1
    80000e28:	00005097          	auipc	ra,0x5
    80000e2c:	2fa080e7          	jalr	762(ra) # 80006122 <initlock>
    p->kstack = KSTACK((int)(p - proc));
    80000e30:	415487b3          	sub	a5,s1,s5
    80000e34:	878d                	srai	a5,a5,0x3
    80000e36:	000a3703          	ld	a4,0(s4)
    80000e3a:	02e787b3          	mul	a5,a5,a4
    80000e3e:	2785                	addiw	a5,a5,1
    80000e40:	00d7979b          	slliw	a5,a5,0xd
    80000e44:	40f907b3          	sub	a5,s2,a5
    80000e48:	e4bc                	sd	a5,72(s1)
  for (p = proc; p < &proc[NPROC]; p++)
    80000e4a:	18848493          	addi	s1,s1,392
    80000e4e:	fd349be3          	bne	s1,s3,80000e24 <procinit+0x6e>
  }
}
    80000e52:	70e2                	ld	ra,56(sp)
    80000e54:	7442                	ld	s0,48(sp)
    80000e56:	74a2                	ld	s1,40(sp)
    80000e58:	7902                	ld	s2,32(sp)
    80000e5a:	69e2                	ld	s3,24(sp)
    80000e5c:	6a42                	ld	s4,16(sp)
    80000e5e:	6aa2                	ld	s5,8(sp)
    80000e60:	6b02                	ld	s6,0(sp)
    80000e62:	6121                	addi	sp,sp,64
    80000e64:	8082                	ret

0000000080000e66 <cpuid>:

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid()
{
    80000e66:	1141                	addi	sp,sp,-16
    80000e68:	e422                	sd	s0,8(sp)
    80000e6a:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r"(x));
    80000e6c:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e6e:	2501                	sext.w	a0,a0
    80000e70:	6422                	ld	s0,8(sp)
    80000e72:	0141                	addi	sp,sp,16
    80000e74:	8082                	ret

0000000080000e76 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *
mycpu(void)
{
    80000e76:	1141                	addi	sp,sp,-16
    80000e78:	e422                	sd	s0,8(sp)
    80000e7a:	0800                	addi	s0,sp,16
    80000e7c:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e7e:	2781                	sext.w	a5,a5
    80000e80:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e82:	00008517          	auipc	a0,0x8
    80000e86:	1fe50513          	addi	a0,a0,510 # 80009080 <cpus>
    80000e8a:	953e                	add	a0,a0,a5
    80000e8c:	6422                	ld	s0,8(sp)
    80000e8e:	0141                	addi	sp,sp,16
    80000e90:	8082                	ret

0000000080000e92 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *
myproc(void)
{
    80000e92:	1101                	addi	sp,sp,-32
    80000e94:	ec06                	sd	ra,24(sp)
    80000e96:	e822                	sd	s0,16(sp)
    80000e98:	e426                	sd	s1,8(sp)
    80000e9a:	1000                	addi	s0,sp,32
  push_off();
    80000e9c:	00005097          	auipc	ra,0x5
    80000ea0:	2ca080e7          	jalr	714(ra) # 80006166 <push_off>
    80000ea4:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000ea6:	2781                	sext.w	a5,a5
    80000ea8:	079e                	slli	a5,a5,0x7
    80000eaa:	00008717          	auipc	a4,0x8
    80000eae:	1a670713          	addi	a4,a4,422 # 80009050 <pid_lock>
    80000eb2:	97ba                	add	a5,a5,a4
    80000eb4:	7b84                	ld	s1,48(a5)
  pop_off();
    80000eb6:	00005097          	auipc	ra,0x5
    80000eba:	350080e7          	jalr	848(ra) # 80006206 <pop_off>
  return p;
}
    80000ebe:	8526                	mv	a0,s1
    80000ec0:	60e2                	ld	ra,24(sp)
    80000ec2:	6442                	ld	s0,16(sp)
    80000ec4:	64a2                	ld	s1,8(sp)
    80000ec6:	6105                	addi	sp,sp,32
    80000ec8:	8082                	ret

0000000080000eca <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80000eca:	1141                	addi	sp,sp,-16
    80000ecc:	e406                	sd	ra,8(sp)
    80000ece:	e022                	sd	s0,0(sp)
    80000ed0:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000ed2:	00000097          	auipc	ra,0x0
    80000ed6:	fc0080e7          	jalr	-64(ra) # 80000e92 <myproc>
    80000eda:	00005097          	auipc	ra,0x5
    80000ede:	38c080e7          	jalr	908(ra) # 80006266 <release>

  if (first)
    80000ee2:	00008797          	auipc	a5,0x8
    80000ee6:	ade7a783          	lw	a5,-1314(a5) # 800089c0 <first.1674>
    80000eea:	eb89                	bnez	a5,80000efc <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000eec:	00001097          	auipc	ra,0x1
    80000ef0:	c50080e7          	jalr	-944(ra) # 80001b3c <usertrapret>
}
    80000ef4:	60a2                	ld	ra,8(sp)
    80000ef6:	6402                	ld	s0,0(sp)
    80000ef8:	0141                	addi	sp,sp,16
    80000efa:	8082                	ret
    first = 0;
    80000efc:	00008797          	auipc	a5,0x8
    80000f00:	ac07a223          	sw	zero,-1340(a5) # 800089c0 <first.1674>
    fsinit(ROOTDEV);
    80000f04:	4505                	li	a0,1
    80000f06:	00002097          	auipc	ra,0x2
    80000f0a:	a32080e7          	jalr	-1486(ra) # 80002938 <fsinit>
    80000f0e:	bff9                	j	80000eec <forkret+0x22>

0000000080000f10 <allocpid>:
{
    80000f10:	1101                	addi	sp,sp,-32
    80000f12:	ec06                	sd	ra,24(sp)
    80000f14:	e822                	sd	s0,16(sp)
    80000f16:	e426                	sd	s1,8(sp)
    80000f18:	e04a                	sd	s2,0(sp)
    80000f1a:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f1c:	00008917          	auipc	s2,0x8
    80000f20:	13490913          	addi	s2,s2,308 # 80009050 <pid_lock>
    80000f24:	854a                	mv	a0,s2
    80000f26:	00005097          	auipc	ra,0x5
    80000f2a:	28c080e7          	jalr	652(ra) # 800061b2 <acquire>
  pid = nextpid;
    80000f2e:	00008797          	auipc	a5,0x8
    80000f32:	a9678793          	addi	a5,a5,-1386 # 800089c4 <nextpid>
    80000f36:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f38:	0014871b          	addiw	a4,s1,1
    80000f3c:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f3e:	854a                	mv	a0,s2
    80000f40:	00005097          	auipc	ra,0x5
    80000f44:	326080e7          	jalr	806(ra) # 80006266 <release>
}
    80000f48:	8526                	mv	a0,s1
    80000f4a:	60e2                	ld	ra,24(sp)
    80000f4c:	6442                	ld	s0,16(sp)
    80000f4e:	64a2                	ld	s1,8(sp)
    80000f50:	6902                	ld	s2,0(sp)
    80000f52:	6105                	addi	sp,sp,32
    80000f54:	8082                	ret

0000000080000f56 <proc_pagetable>:
{
    80000f56:	1101                	addi	sp,sp,-32
    80000f58:	ec06                	sd	ra,24(sp)
    80000f5a:	e822                	sd	s0,16(sp)
    80000f5c:	e426                	sd	s1,8(sp)
    80000f5e:	e04a                	sd	s2,0(sp)
    80000f60:	1000                	addi	s0,sp,32
    80000f62:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f64:	00000097          	auipc	ra,0x0
    80000f68:	8b8080e7          	jalr	-1864(ra) # 8000081c <uvmcreate>
    80000f6c:	84aa                	mv	s1,a0
  if (pagetable == 0)
    80000f6e:	c121                	beqz	a0,80000fae <proc_pagetable+0x58>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f70:	4729                	li	a4,10
    80000f72:	00006697          	auipc	a3,0x6
    80000f76:	08e68693          	addi	a3,a3,142 # 80007000 <_trampoline>
    80000f7a:	6605                	lui	a2,0x1
    80000f7c:	040005b7          	lui	a1,0x4000
    80000f80:	15fd                	addi	a1,a1,-1
    80000f82:	05b2                	slli	a1,a1,0xc
    80000f84:	fffff097          	auipc	ra,0xfffff
    80000f88:	60e080e7          	jalr	1550(ra) # 80000592 <mappages>
    80000f8c:	02054863          	bltz	a0,80000fbc <proc_pagetable+0x66>
  if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f90:	4719                	li	a4,6
    80000f92:	06093683          	ld	a3,96(s2)
    80000f96:	6605                	lui	a2,0x1
    80000f98:	020005b7          	lui	a1,0x2000
    80000f9c:	15fd                	addi	a1,a1,-1
    80000f9e:	05b6                	slli	a1,a1,0xd
    80000fa0:	8526                	mv	a0,s1
    80000fa2:	fffff097          	auipc	ra,0xfffff
    80000fa6:	5f0080e7          	jalr	1520(ra) # 80000592 <mappages>
    80000faa:	02054163          	bltz	a0,80000fcc <proc_pagetable+0x76>
}
    80000fae:	8526                	mv	a0,s1
    80000fb0:	60e2                	ld	ra,24(sp)
    80000fb2:	6442                	ld	s0,16(sp)
    80000fb4:	64a2                	ld	s1,8(sp)
    80000fb6:	6902                	ld	s2,0(sp)
    80000fb8:	6105                	addi	sp,sp,32
    80000fba:	8082                	ret
    uvmfree(pagetable, 0);
    80000fbc:	4581                	li	a1,0
    80000fbe:	8526                	mv	a0,s1
    80000fc0:	00000097          	auipc	ra,0x0
    80000fc4:	a58080e7          	jalr	-1448(ra) # 80000a18 <uvmfree>
    return 0;
    80000fc8:	4481                	li	s1,0
    80000fca:	b7d5                	j	80000fae <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fcc:	4681                	li	a3,0
    80000fce:	4605                	li	a2,1
    80000fd0:	040005b7          	lui	a1,0x4000
    80000fd4:	15fd                	addi	a1,a1,-1
    80000fd6:	05b2                	slli	a1,a1,0xc
    80000fd8:	8526                	mv	a0,s1
    80000fda:	fffff097          	auipc	ra,0xfffff
    80000fde:	77e080e7          	jalr	1918(ra) # 80000758 <uvmunmap>
    uvmfree(pagetable, 0);
    80000fe2:	4581                	li	a1,0
    80000fe4:	8526                	mv	a0,s1
    80000fe6:	00000097          	auipc	ra,0x0
    80000fea:	a32080e7          	jalr	-1486(ra) # 80000a18 <uvmfree>
    return 0;
    80000fee:	4481                	li	s1,0
    80000ff0:	bf7d                	j	80000fae <proc_pagetable+0x58>

0000000080000ff2 <proc_freepagetable>:
{
    80000ff2:	1101                	addi	sp,sp,-32
    80000ff4:	ec06                	sd	ra,24(sp)
    80000ff6:	e822                	sd	s0,16(sp)
    80000ff8:	e426                	sd	s1,8(sp)
    80000ffa:	e04a                	sd	s2,0(sp)
    80000ffc:	1000                	addi	s0,sp,32
    80000ffe:	84aa                	mv	s1,a0
    80001000:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001002:	4681                	li	a3,0
    80001004:	4605                	li	a2,1
    80001006:	040005b7          	lui	a1,0x4000
    8000100a:	15fd                	addi	a1,a1,-1
    8000100c:	05b2                	slli	a1,a1,0xc
    8000100e:	fffff097          	auipc	ra,0xfffff
    80001012:	74a080e7          	jalr	1866(ra) # 80000758 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001016:	4681                	li	a3,0
    80001018:	4605                	li	a2,1
    8000101a:	020005b7          	lui	a1,0x2000
    8000101e:	15fd                	addi	a1,a1,-1
    80001020:	05b6                	slli	a1,a1,0xd
    80001022:	8526                	mv	a0,s1
    80001024:	fffff097          	auipc	ra,0xfffff
    80001028:	734080e7          	jalr	1844(ra) # 80000758 <uvmunmap>
  uvmfree(pagetable, sz);
    8000102c:	85ca                	mv	a1,s2
    8000102e:	8526                	mv	a0,s1
    80001030:	00000097          	auipc	ra,0x0
    80001034:	9e8080e7          	jalr	-1560(ra) # 80000a18 <uvmfree>
}
    80001038:	60e2                	ld	ra,24(sp)
    8000103a:	6442                	ld	s0,16(sp)
    8000103c:	64a2                	ld	s1,8(sp)
    8000103e:	6902                	ld	s2,0(sp)
    80001040:	6105                	addi	sp,sp,32
    80001042:	8082                	ret

0000000080001044 <freeproc>:
{
    80001044:	1101                	addi	sp,sp,-32
    80001046:	ec06                	sd	ra,24(sp)
    80001048:	e822                	sd	s0,16(sp)
    8000104a:	e426                	sd	s1,8(sp)
    8000104c:	1000                	addi	s0,sp,32
    8000104e:	84aa                	mv	s1,a0
  if (p->trapframe)
    80001050:	7128                	ld	a0,96(a0)
    80001052:	c509                	beqz	a0,8000105c <freeproc+0x18>
    kfree((void *)p->trapframe);
    80001054:	fffff097          	auipc	ra,0xfffff
    80001058:	fc8080e7          	jalr	-56(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000105c:	0604b023          	sd	zero,96(s1)
  if (p->pagetable)
    80001060:	6ca8                	ld	a0,88(s1)
    80001062:	c511                	beqz	a0,8000106e <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001064:	68ac                	ld	a1,80(s1)
    80001066:	00000097          	auipc	ra,0x0
    8000106a:	f8c080e7          	jalr	-116(ra) # 80000ff2 <proc_freepagetable>
  p->pagetable = 0;
    8000106e:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    80001072:	0404b823          	sd	zero,80(s1)
  p->pid = 0;
    80001076:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000107a:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000107e:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    80001082:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001086:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000108a:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000108e:	0004ac23          	sw	zero,24(s1)
}
    80001092:	60e2                	ld	ra,24(sp)
    80001094:	6442                	ld	s0,16(sp)
    80001096:	64a2                	ld	s1,8(sp)
    80001098:	6105                	addi	sp,sp,32
    8000109a:	8082                	ret

000000008000109c <allocproc>:
{
    8000109c:	1101                	addi	sp,sp,-32
    8000109e:	ec06                	sd	ra,24(sp)
    800010a0:	e822                	sd	s0,16(sp)
    800010a2:	e426                	sd	s1,8(sp)
    800010a4:	e04a                	sd	s2,0(sp)
    800010a6:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++)
    800010a8:	00008497          	auipc	s1,0x8
    800010ac:	3d848493          	addi	s1,s1,984 # 80009480 <proc>
    800010b0:	0000e917          	auipc	s2,0xe
    800010b4:	5d090913          	addi	s2,s2,1488 # 8000f680 <tickslock>
    acquire(&p->lock);
    800010b8:	8526                	mv	a0,s1
    800010ba:	00005097          	auipc	ra,0x5
    800010be:	0f8080e7          	jalr	248(ra) # 800061b2 <acquire>
    if (p->state == UNUSED)
    800010c2:	4c9c                	lw	a5,24(s1)
    800010c4:	cf81                	beqz	a5,800010dc <allocproc+0x40>
      release(&p->lock);
    800010c6:	8526                	mv	a0,s1
    800010c8:	00005097          	auipc	ra,0x5
    800010cc:	19e080e7          	jalr	414(ra) # 80006266 <release>
  for (p = proc; p < &proc[NPROC]; p++)
    800010d0:	18848493          	addi	s1,s1,392
    800010d4:	ff2492e3          	bne	s1,s2,800010b8 <allocproc+0x1c>
  return 0;
    800010d8:	4481                	li	s1,0
    800010da:	a889                	j	8000112c <allocproc+0x90>
  p->pid = allocpid();
    800010dc:	00000097          	auipc	ra,0x0
    800010e0:	e34080e7          	jalr	-460(ra) # 80000f10 <allocpid>
    800010e4:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010e6:	4785                	li	a5,1
    800010e8:	cc9c                	sw	a5,24(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    800010ea:	fffff097          	auipc	ra,0xfffff
    800010ee:	02e080e7          	jalr	46(ra) # 80000118 <kalloc>
    800010f2:	892a                	mv	s2,a0
    800010f4:	f0a8                	sd	a0,96(s1)
    800010f6:	c131                	beqz	a0,8000113a <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010f8:	8526                	mv	a0,s1
    800010fa:	00000097          	auipc	ra,0x0
    800010fe:	e5c080e7          	jalr	-420(ra) # 80000f56 <proc_pagetable>
    80001102:	892a                	mv	s2,a0
    80001104:	eca8                	sd	a0,88(s1)
  if (p->pagetable == 0)
    80001106:	c531                	beqz	a0,80001152 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001108:	07000613          	li	a2,112
    8000110c:	4581                	li	a1,0
    8000110e:	06848513          	addi	a0,s1,104
    80001112:	fffff097          	auipc	ra,0xfffff
    80001116:	0b0080e7          	jalr	176(ra) # 800001c2 <memset>
  p->context.ra = (uint64)forkret;
    8000111a:	00000797          	auipc	a5,0x0
    8000111e:	db078793          	addi	a5,a5,-592 # 80000eca <forkret>
    80001122:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001124:	64bc                	ld	a5,72(s1)
    80001126:	6705                	lui	a4,0x1
    80001128:	97ba                	add	a5,a5,a4
    8000112a:	f8bc                	sd	a5,112(s1)
}
    8000112c:	8526                	mv	a0,s1
    8000112e:	60e2                	ld	ra,24(sp)
    80001130:	6442                	ld	s0,16(sp)
    80001132:	64a2                	ld	s1,8(sp)
    80001134:	6902                	ld	s2,0(sp)
    80001136:	6105                	addi	sp,sp,32
    80001138:	8082                	ret
    freeproc(p);
    8000113a:	8526                	mv	a0,s1
    8000113c:	00000097          	auipc	ra,0x0
    80001140:	f08080e7          	jalr	-248(ra) # 80001044 <freeproc>
    release(&p->lock);
    80001144:	8526                	mv	a0,s1
    80001146:	00005097          	auipc	ra,0x5
    8000114a:	120080e7          	jalr	288(ra) # 80006266 <release>
    return 0;
    8000114e:	84ca                	mv	s1,s2
    80001150:	bff1                	j	8000112c <allocproc+0x90>
    freeproc(p);
    80001152:	8526                	mv	a0,s1
    80001154:	00000097          	auipc	ra,0x0
    80001158:	ef0080e7          	jalr	-272(ra) # 80001044 <freeproc>
    release(&p->lock);
    8000115c:	8526                	mv	a0,s1
    8000115e:	00005097          	auipc	ra,0x5
    80001162:	108080e7          	jalr	264(ra) # 80006266 <release>
    return 0;
    80001166:	84ca                	mv	s1,s2
    80001168:	b7d1                	j	8000112c <allocproc+0x90>

000000008000116a <userinit>:
{
    8000116a:	1101                	addi	sp,sp,-32
    8000116c:	ec06                	sd	ra,24(sp)
    8000116e:	e822                	sd	s0,16(sp)
    80001170:	e426                	sd	s1,8(sp)
    80001172:	1000                	addi	s0,sp,32
  p = allocproc();
    80001174:	00000097          	auipc	ra,0x0
    80001178:	f28080e7          	jalr	-216(ra) # 8000109c <allocproc>
    8000117c:	84aa                	mv	s1,a0
  initproc = p;
    8000117e:	00008797          	auipc	a5,0x8
    80001182:	e8a7b923          	sd	a0,-366(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001186:	03400613          	li	a2,52
    8000118a:	00008597          	auipc	a1,0x8
    8000118e:	84658593          	addi	a1,a1,-1978 # 800089d0 <initcode>
    80001192:	6d28                	ld	a0,88(a0)
    80001194:	fffff097          	auipc	ra,0xfffff
    80001198:	6b6080e7          	jalr	1718(ra) # 8000084a <uvminit>
  p->sz = PGSIZE;
    8000119c:	6785                	lui	a5,0x1
    8000119e:	e8bc                	sd	a5,80(s1)
  p->trapframe->epc = 0;     // user program counter
    800011a0:	70b8                	ld	a4,96(s1)
    800011a2:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE; // user stack pointer
    800011a6:	70b8                	ld	a4,96(s1)
    800011a8:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011aa:	4641                	li	a2,16
    800011ac:	00007597          	auipc	a1,0x7
    800011b0:	fd458593          	addi	a1,a1,-44 # 80008180 <etext+0x180>
    800011b4:	16048513          	addi	a0,s1,352
    800011b8:	fffff097          	auipc	ra,0xfffff
    800011bc:	15c080e7          	jalr	348(ra) # 80000314 <safestrcpy>
  p->cwd = namei("/");
    800011c0:	00007517          	auipc	a0,0x7
    800011c4:	fd050513          	addi	a0,a0,-48 # 80008190 <etext+0x190>
    800011c8:	00002097          	auipc	ra,0x2
    800011cc:	19e080e7          	jalr	414(ra) # 80003366 <namei>
    800011d0:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    800011d4:	478d                	li	a5,3
    800011d6:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011d8:	8526                	mv	a0,s1
    800011da:	00005097          	auipc	ra,0x5
    800011de:	08c080e7          	jalr	140(ra) # 80006266 <release>
}
    800011e2:	60e2                	ld	ra,24(sp)
    800011e4:	6442                	ld	s0,16(sp)
    800011e6:	64a2                	ld	s1,8(sp)
    800011e8:	6105                	addi	sp,sp,32
    800011ea:	8082                	ret

00000000800011ec <growproc>:
{
    800011ec:	1101                	addi	sp,sp,-32
    800011ee:	ec06                	sd	ra,24(sp)
    800011f0:	e822                	sd	s0,16(sp)
    800011f2:	e426                	sd	s1,8(sp)
    800011f4:	e04a                	sd	s2,0(sp)
    800011f6:	1000                	addi	s0,sp,32
    800011f8:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011fa:	00000097          	auipc	ra,0x0
    800011fe:	c98080e7          	jalr	-872(ra) # 80000e92 <myproc>
    80001202:	892a                	mv	s2,a0
  sz = p->sz;
    80001204:	692c                	ld	a1,80(a0)
    80001206:	0005861b          	sext.w	a2,a1
  if (n > 0)
    8000120a:	00904f63          	bgtz	s1,80001228 <growproc+0x3c>
  else if (n < 0)
    8000120e:	0204cc63          	bltz	s1,80001246 <growproc+0x5a>
  p->sz = sz;
    80001212:	1602                	slli	a2,a2,0x20
    80001214:	9201                	srli	a2,a2,0x20
    80001216:	04c93823          	sd	a2,80(s2)
  return 0;
    8000121a:	4501                	li	a0,0
}
    8000121c:	60e2                	ld	ra,24(sp)
    8000121e:	6442                	ld	s0,16(sp)
    80001220:	64a2                	ld	s1,8(sp)
    80001222:	6902                	ld	s2,0(sp)
    80001224:	6105                	addi	sp,sp,32
    80001226:	8082                	ret
    if ((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0)
    80001228:	9e25                	addw	a2,a2,s1
    8000122a:	1602                	slli	a2,a2,0x20
    8000122c:	9201                	srli	a2,a2,0x20
    8000122e:	1582                	slli	a1,a1,0x20
    80001230:	9181                	srli	a1,a1,0x20
    80001232:	6d28                	ld	a0,88(a0)
    80001234:	fffff097          	auipc	ra,0xfffff
    80001238:	6d0080e7          	jalr	1744(ra) # 80000904 <uvmalloc>
    8000123c:	0005061b          	sext.w	a2,a0
    80001240:	fa69                	bnez	a2,80001212 <growproc+0x26>
      return -1;
    80001242:	557d                	li	a0,-1
    80001244:	bfe1                	j	8000121c <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001246:	9e25                	addw	a2,a2,s1
    80001248:	1602                	slli	a2,a2,0x20
    8000124a:	9201                	srli	a2,a2,0x20
    8000124c:	1582                	slli	a1,a1,0x20
    8000124e:	9181                	srli	a1,a1,0x20
    80001250:	6d28                	ld	a0,88(a0)
    80001252:	fffff097          	auipc	ra,0xfffff
    80001256:	66a080e7          	jalr	1642(ra) # 800008bc <uvmdealloc>
    8000125a:	0005061b          	sext.w	a2,a0
    8000125e:	bf55                	j	80001212 <growproc+0x26>

0000000080001260 <fork>:
{
    80001260:	7179                	addi	sp,sp,-48
    80001262:	f406                	sd	ra,40(sp)
    80001264:	f022                	sd	s0,32(sp)
    80001266:	ec26                	sd	s1,24(sp)
    80001268:	e84a                	sd	s2,16(sp)
    8000126a:	e44e                	sd	s3,8(sp)
    8000126c:	e052                	sd	s4,0(sp)
    8000126e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001270:	00000097          	auipc	ra,0x0
    80001274:	c22080e7          	jalr	-990(ra) # 80000e92 <myproc>
    80001278:	892a                	mv	s2,a0
  if ((np = allocproc()) == 0)
    8000127a:	00000097          	auipc	ra,0x0
    8000127e:	e22080e7          	jalr	-478(ra) # 8000109c <allocproc>
    80001282:	c52d                	beqz	a0,800012ec <fork+0x8c>
    80001284:	89aa                	mv	s3,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    80001286:	05093603          	ld	a2,80(s2)
    8000128a:	6d2c                	ld	a1,88(a0)
    8000128c:	05893503          	ld	a0,88(s2)
    80001290:	fffff097          	auipc	ra,0xfffff
    80001294:	7c0080e7          	jalr	1984(ra) # 80000a50 <uvmcopy>
    80001298:	06054463          	bltz	a0,80001300 <fork+0xa0>
  np->sz = p->sz;
    8000129c:	05093783          	ld	a5,80(s2)
    800012a0:	04f9b823          	sd	a5,80(s3)
  *(np->trapframe) = *(p->trapframe);
    800012a4:	06093683          	ld	a3,96(s2)
    800012a8:	87b6                	mv	a5,a3
    800012aa:	0609b703          	ld	a4,96(s3)
    800012ae:	12068693          	addi	a3,a3,288
    800012b2:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012b6:	6788                	ld	a0,8(a5)
    800012b8:	6b8c                	ld	a1,16(a5)
    800012ba:	6f90                	ld	a2,24(a5)
    800012bc:	01073023          	sd	a6,0(a4)
    800012c0:	e708                	sd	a0,8(a4)
    800012c2:	eb0c                	sd	a1,16(a4)
    800012c4:	ef10                	sd	a2,24(a4)
    800012c6:	02078793          	addi	a5,a5,32
    800012ca:	02070713          	addi	a4,a4,32
    800012ce:	fed792e3          	bne	a5,a3,800012b2 <fork+0x52>
  np->trace_mask = p->trace_mask; // father's trace_mask gives to son
    800012d2:	04092783          	lw	a5,64(s2)
    800012d6:	04f9a023          	sw	a5,64(s3)
  np->trapframe->a0 = 0;
    800012da:	0609b783          	ld	a5,96(s3)
    800012de:	0607b823          	sd	zero,112(a5)
    800012e2:	0d800493          	li	s1,216
  for (i = 0; i < NOFILE; i++)
    800012e6:	15800a13          	li	s4,344
    800012ea:	a089                	j	8000132c <fork+0xcc>
    printf("fork: allocproc failed\n");
    800012ec:	00007517          	auipc	a0,0x7
    800012f0:	eac50513          	addi	a0,a0,-340 # 80008198 <etext+0x198>
    800012f4:	00005097          	auipc	ra,0x5
    800012f8:	9be080e7          	jalr	-1602(ra) # 80005cb2 <printf>
    return -1;
    800012fc:	5a7d                	li	s4,-1
    800012fe:	a04d                	j	800013a0 <fork+0x140>
    freeproc(np);
    80001300:	854e                	mv	a0,s3
    80001302:	00000097          	auipc	ra,0x0
    80001306:	d42080e7          	jalr	-702(ra) # 80001044 <freeproc>
    release(&np->lock);
    8000130a:	854e                	mv	a0,s3
    8000130c:	00005097          	auipc	ra,0x5
    80001310:	f5a080e7          	jalr	-166(ra) # 80006266 <release>
    return -1;
    80001314:	5a7d                	li	s4,-1
    80001316:	a069                	j	800013a0 <fork+0x140>
      np->ofile[i] = filedup(p->ofile[i]);
    80001318:	00002097          	auipc	ra,0x2
    8000131c:	6e4080e7          	jalr	1764(ra) # 800039fc <filedup>
    80001320:	009987b3          	add	a5,s3,s1
    80001324:	e388                	sd	a0,0(a5)
  for (i = 0; i < NOFILE; i++)
    80001326:	04a1                	addi	s1,s1,8
    80001328:	01448763          	beq	s1,s4,80001336 <fork+0xd6>
    if (p->ofile[i])
    8000132c:	009907b3          	add	a5,s2,s1
    80001330:	6388                	ld	a0,0(a5)
    80001332:	f17d                	bnez	a0,80001318 <fork+0xb8>
    80001334:	bfcd                	j	80001326 <fork+0xc6>
  np->cwd = idup(p->cwd);
    80001336:	15893503          	ld	a0,344(s2)
    8000133a:	00002097          	auipc	ra,0x2
    8000133e:	838080e7          	jalr	-1992(ra) # 80002b72 <idup>
    80001342:	14a9bc23          	sd	a0,344(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001346:	4641                	li	a2,16
    80001348:	16090593          	addi	a1,s2,352
    8000134c:	16098513          	addi	a0,s3,352
    80001350:	fffff097          	auipc	ra,0xfffff
    80001354:	fc4080e7          	jalr	-60(ra) # 80000314 <safestrcpy>
  pid = np->pid;
    80001358:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    8000135c:	854e                	mv	a0,s3
    8000135e:	00005097          	auipc	ra,0x5
    80001362:	f08080e7          	jalr	-248(ra) # 80006266 <release>
  acquire(&wait_lock);
    80001366:	00008497          	auipc	s1,0x8
    8000136a:	d0248493          	addi	s1,s1,-766 # 80009068 <wait_lock>
    8000136e:	8526                	mv	a0,s1
    80001370:	00005097          	auipc	ra,0x5
    80001374:	e42080e7          	jalr	-446(ra) # 800061b2 <acquire>
  np->parent = p;
    80001378:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    8000137c:	8526                	mv	a0,s1
    8000137e:	00005097          	auipc	ra,0x5
    80001382:	ee8080e7          	jalr	-280(ra) # 80006266 <release>
  acquire(&np->lock);
    80001386:	854e                	mv	a0,s3
    80001388:	00005097          	auipc	ra,0x5
    8000138c:	e2a080e7          	jalr	-470(ra) # 800061b2 <acquire>
  np->state = RUNNABLE;
    80001390:	478d                	li	a5,3
    80001392:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001396:	854e                	mv	a0,s3
    80001398:	00005097          	auipc	ra,0x5
    8000139c:	ece080e7          	jalr	-306(ra) # 80006266 <release>
}
    800013a0:	8552                	mv	a0,s4
    800013a2:	70a2                	ld	ra,40(sp)
    800013a4:	7402                	ld	s0,32(sp)
    800013a6:	64e2                	ld	s1,24(sp)
    800013a8:	6942                	ld	s2,16(sp)
    800013aa:	69a2                	ld	s3,8(sp)
    800013ac:	6a02                	ld	s4,0(sp)
    800013ae:	6145                	addi	sp,sp,48
    800013b0:	8082                	ret

00000000800013b2 <scheduler>:
{
    800013b2:	7139                	addi	sp,sp,-64
    800013b4:	fc06                	sd	ra,56(sp)
    800013b6:	f822                	sd	s0,48(sp)
    800013b8:	f426                	sd	s1,40(sp)
    800013ba:	f04a                	sd	s2,32(sp)
    800013bc:	ec4e                	sd	s3,24(sp)
    800013be:	e852                	sd	s4,16(sp)
    800013c0:	e456                	sd	s5,8(sp)
    800013c2:	e05a                	sd	s6,0(sp)
    800013c4:	0080                	addi	s0,sp,64
    800013c6:	8792                	mv	a5,tp
  int id = r_tp();
    800013c8:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013ca:	00779a93          	slli	s5,a5,0x7
    800013ce:	00008717          	auipc	a4,0x8
    800013d2:	c8270713          	addi	a4,a4,-894 # 80009050 <pid_lock>
    800013d6:	9756                	add	a4,a4,s5
    800013d8:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013dc:	00008717          	auipc	a4,0x8
    800013e0:	cac70713          	addi	a4,a4,-852 # 80009088 <cpus+0x8>
    800013e4:	9aba                	add	s5,s5,a4
      if (p->state == RUNNABLE)
    800013e6:	498d                	li	s3,3
        p->state = RUNNING;
    800013e8:	4b11                	li	s6,4
        c->proc = p;
    800013ea:	079e                	slli	a5,a5,0x7
    800013ec:	00008a17          	auipc	s4,0x8
    800013f0:	c64a0a13          	addi	s4,s4,-924 # 80009050 <pid_lock>
    800013f4:	9a3e                	add	s4,s4,a5
    for (p = proc; p < &proc[NPROC]; p++)
    800013f6:	0000e917          	auipc	s2,0xe
    800013fa:	28a90913          	addi	s2,s2,650 # 8000f680 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800013fe:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001402:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001406:	10079073          	csrw	sstatus,a5
    8000140a:	00008497          	auipc	s1,0x8
    8000140e:	07648493          	addi	s1,s1,118 # 80009480 <proc>
    80001412:	a03d                	j	80001440 <scheduler+0x8e>
        p->state = RUNNING;
    80001414:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001418:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000141c:	06848593          	addi	a1,s1,104
    80001420:	8556                	mv	a0,s5
    80001422:	00000097          	auipc	ra,0x0
    80001426:	670080e7          	jalr	1648(ra) # 80001a92 <swtch>
        c->proc = 0;
    8000142a:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    8000142e:	8526                	mv	a0,s1
    80001430:	00005097          	auipc	ra,0x5
    80001434:	e36080e7          	jalr	-458(ra) # 80006266 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80001438:	18848493          	addi	s1,s1,392
    8000143c:	fd2481e3          	beq	s1,s2,800013fe <scheduler+0x4c>
      acquire(&p->lock);
    80001440:	8526                	mv	a0,s1
    80001442:	00005097          	auipc	ra,0x5
    80001446:	d70080e7          	jalr	-656(ra) # 800061b2 <acquire>
      if (p->state == RUNNABLE)
    8000144a:	4c9c                	lw	a5,24(s1)
    8000144c:	ff3791e3          	bne	a5,s3,8000142e <scheduler+0x7c>
    80001450:	b7d1                	j	80001414 <scheduler+0x62>

0000000080001452 <sched>:
{
    80001452:	7179                	addi	sp,sp,-48
    80001454:	f406                	sd	ra,40(sp)
    80001456:	f022                	sd	s0,32(sp)
    80001458:	ec26                	sd	s1,24(sp)
    8000145a:	e84a                	sd	s2,16(sp)
    8000145c:	e44e                	sd	s3,8(sp)
    8000145e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001460:	00000097          	auipc	ra,0x0
    80001464:	a32080e7          	jalr	-1486(ra) # 80000e92 <myproc>
    80001468:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    8000146a:	00005097          	auipc	ra,0x5
    8000146e:	cce080e7          	jalr	-818(ra) # 80006138 <holding>
    80001472:	c93d                	beqz	a0,800014e8 <sched+0x96>
  asm volatile("mv %0, tp" : "=r"(x));
    80001474:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    80001476:	2781                	sext.w	a5,a5
    80001478:	079e                	slli	a5,a5,0x7
    8000147a:	00008717          	auipc	a4,0x8
    8000147e:	bd670713          	addi	a4,a4,-1066 # 80009050 <pid_lock>
    80001482:	97ba                	add	a5,a5,a4
    80001484:	0a87a703          	lw	a4,168(a5)
    80001488:	4785                	li	a5,1
    8000148a:	06f71763          	bne	a4,a5,800014f8 <sched+0xa6>
  if (p->state == RUNNING)
    8000148e:	4c98                	lw	a4,24(s1)
    80001490:	4791                	li	a5,4
    80001492:	06f70b63          	beq	a4,a5,80001508 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001496:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000149a:	8b89                	andi	a5,a5,2
  if (intr_get())
    8000149c:	efb5                	bnez	a5,80001518 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r"(x));
    8000149e:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800014a0:	00008917          	auipc	s2,0x8
    800014a4:	bb090913          	addi	s2,s2,-1104 # 80009050 <pid_lock>
    800014a8:	2781                	sext.w	a5,a5
    800014aa:	079e                	slli	a5,a5,0x7
    800014ac:	97ca                	add	a5,a5,s2
    800014ae:	0ac7a983          	lw	s3,172(a5)
    800014b2:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014b4:	2781                	sext.w	a5,a5
    800014b6:	079e                	slli	a5,a5,0x7
    800014b8:	00008597          	auipc	a1,0x8
    800014bc:	bd058593          	addi	a1,a1,-1072 # 80009088 <cpus+0x8>
    800014c0:	95be                	add	a1,a1,a5
    800014c2:	06848513          	addi	a0,s1,104
    800014c6:	00000097          	auipc	ra,0x0
    800014ca:	5cc080e7          	jalr	1484(ra) # 80001a92 <swtch>
    800014ce:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014d0:	2781                	sext.w	a5,a5
    800014d2:	079e                	slli	a5,a5,0x7
    800014d4:	97ca                	add	a5,a5,s2
    800014d6:	0b37a623          	sw	s3,172(a5)
}
    800014da:	70a2                	ld	ra,40(sp)
    800014dc:	7402                	ld	s0,32(sp)
    800014de:	64e2                	ld	s1,24(sp)
    800014e0:	6942                	ld	s2,16(sp)
    800014e2:	69a2                	ld	s3,8(sp)
    800014e4:	6145                	addi	sp,sp,48
    800014e6:	8082                	ret
    panic("sched p->lock");
    800014e8:	00007517          	auipc	a0,0x7
    800014ec:	cc850513          	addi	a0,a0,-824 # 800081b0 <etext+0x1b0>
    800014f0:	00004097          	auipc	ra,0x4
    800014f4:	778080e7          	jalr	1912(ra) # 80005c68 <panic>
    panic("sched locks");
    800014f8:	00007517          	auipc	a0,0x7
    800014fc:	cc850513          	addi	a0,a0,-824 # 800081c0 <etext+0x1c0>
    80001500:	00004097          	auipc	ra,0x4
    80001504:	768080e7          	jalr	1896(ra) # 80005c68 <panic>
    panic("sched running");
    80001508:	00007517          	auipc	a0,0x7
    8000150c:	cc850513          	addi	a0,a0,-824 # 800081d0 <etext+0x1d0>
    80001510:	00004097          	auipc	ra,0x4
    80001514:	758080e7          	jalr	1880(ra) # 80005c68 <panic>
    panic("sched interruptible");
    80001518:	00007517          	auipc	a0,0x7
    8000151c:	cc850513          	addi	a0,a0,-824 # 800081e0 <etext+0x1e0>
    80001520:	00004097          	auipc	ra,0x4
    80001524:	748080e7          	jalr	1864(ra) # 80005c68 <panic>

0000000080001528 <yield>:
{
    80001528:	1101                	addi	sp,sp,-32
    8000152a:	ec06                	sd	ra,24(sp)
    8000152c:	e822                	sd	s0,16(sp)
    8000152e:	e426                	sd	s1,8(sp)
    80001530:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001532:	00000097          	auipc	ra,0x0
    80001536:	960080e7          	jalr	-1696(ra) # 80000e92 <myproc>
    8000153a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000153c:	00005097          	auipc	ra,0x5
    80001540:	c76080e7          	jalr	-906(ra) # 800061b2 <acquire>
  p->state = RUNNABLE;
    80001544:	478d                	li	a5,3
    80001546:	cc9c                	sw	a5,24(s1)
  sched();
    80001548:	00000097          	auipc	ra,0x0
    8000154c:	f0a080e7          	jalr	-246(ra) # 80001452 <sched>
  release(&p->lock);
    80001550:	8526                	mv	a0,s1
    80001552:	00005097          	auipc	ra,0x5
    80001556:	d14080e7          	jalr	-748(ra) # 80006266 <release>
}
    8000155a:	60e2                	ld	ra,24(sp)
    8000155c:	6442                	ld	s0,16(sp)
    8000155e:	64a2                	ld	s1,8(sp)
    80001560:	6105                	addi	sp,sp,32
    80001562:	8082                	ret

0000000080001564 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    80001564:	7179                	addi	sp,sp,-48
    80001566:	f406                	sd	ra,40(sp)
    80001568:	f022                	sd	s0,32(sp)
    8000156a:	ec26                	sd	s1,24(sp)
    8000156c:	e84a                	sd	s2,16(sp)
    8000156e:	e44e                	sd	s3,8(sp)
    80001570:	1800                	addi	s0,sp,48
    80001572:	89aa                	mv	s3,a0
    80001574:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001576:	00000097          	auipc	ra,0x0
    8000157a:	91c080e7          	jalr	-1764(ra) # 80000e92 <myproc>
    8000157e:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock); // DOC: sleeplock1
    80001580:	00005097          	auipc	ra,0x5
    80001584:	c32080e7          	jalr	-974(ra) # 800061b2 <acquire>
  release(lk);
    80001588:	854a                	mv	a0,s2
    8000158a:	00005097          	auipc	ra,0x5
    8000158e:	cdc080e7          	jalr	-804(ra) # 80006266 <release>

  // Go to sleep.
  p->chan = chan;
    80001592:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001596:	4789                	li	a5,2
    80001598:	cc9c                	sw	a5,24(s1)

  sched();
    8000159a:	00000097          	auipc	ra,0x0
    8000159e:	eb8080e7          	jalr	-328(ra) # 80001452 <sched>

  // Tidy up.
  p->chan = 0;
    800015a2:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800015a6:	8526                	mv	a0,s1
    800015a8:	00005097          	auipc	ra,0x5
    800015ac:	cbe080e7          	jalr	-834(ra) # 80006266 <release>
  acquire(lk);
    800015b0:	854a                	mv	a0,s2
    800015b2:	00005097          	auipc	ra,0x5
    800015b6:	c00080e7          	jalr	-1024(ra) # 800061b2 <acquire>
}
    800015ba:	70a2                	ld	ra,40(sp)
    800015bc:	7402                	ld	s0,32(sp)
    800015be:	64e2                	ld	s1,24(sp)
    800015c0:	6942                	ld	s2,16(sp)
    800015c2:	69a2                	ld	s3,8(sp)
    800015c4:	6145                	addi	sp,sp,48
    800015c6:	8082                	ret

00000000800015c8 <wait>:
{
    800015c8:	715d                	addi	sp,sp,-80
    800015ca:	e486                	sd	ra,72(sp)
    800015cc:	e0a2                	sd	s0,64(sp)
    800015ce:	fc26                	sd	s1,56(sp)
    800015d0:	f84a                	sd	s2,48(sp)
    800015d2:	f44e                	sd	s3,40(sp)
    800015d4:	f052                	sd	s4,32(sp)
    800015d6:	ec56                	sd	s5,24(sp)
    800015d8:	e85a                	sd	s6,16(sp)
    800015da:	e45e                	sd	s7,8(sp)
    800015dc:	e062                	sd	s8,0(sp)
    800015de:	0880                	addi	s0,sp,80
    800015e0:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015e2:	00000097          	auipc	ra,0x0
    800015e6:	8b0080e7          	jalr	-1872(ra) # 80000e92 <myproc>
    800015ea:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015ec:	00008517          	auipc	a0,0x8
    800015f0:	a7c50513          	addi	a0,a0,-1412 # 80009068 <wait_lock>
    800015f4:	00005097          	auipc	ra,0x5
    800015f8:	bbe080e7          	jalr	-1090(ra) # 800061b2 <acquire>
    havekids = 0;
    800015fc:	4b81                	li	s7,0
        if (np->state == ZOMBIE)
    800015fe:	4a15                	li	s4,5
    for (np = proc; np < &proc[NPROC]; np++)
    80001600:	0000e997          	auipc	s3,0xe
    80001604:	08098993          	addi	s3,s3,128 # 8000f680 <tickslock>
        havekids = 1;
    80001608:	4a85                	li	s5,1
    sleep(p, &wait_lock); // DOC: wait-sleep
    8000160a:	00008c17          	auipc	s8,0x8
    8000160e:	a5ec0c13          	addi	s8,s8,-1442 # 80009068 <wait_lock>
    havekids = 0;
    80001612:	875e                	mv	a4,s7
    for (np = proc; np < &proc[NPROC]; np++)
    80001614:	00008497          	auipc	s1,0x8
    80001618:	e6c48493          	addi	s1,s1,-404 # 80009480 <proc>
    8000161c:	a0bd                	j	8000168a <wait+0xc2>
          pid = np->pid;
    8000161e:	0304a983          	lw	s3,48(s1)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001622:	000b0e63          	beqz	s6,8000163e <wait+0x76>
    80001626:	4691                	li	a3,4
    80001628:	02c48613          	addi	a2,s1,44
    8000162c:	85da                	mv	a1,s6
    8000162e:	05893503          	ld	a0,88(s2)
    80001632:	fffff097          	auipc	ra,0xfffff
    80001636:	522080e7          	jalr	1314(ra) # 80000b54 <copyout>
    8000163a:	02054563          	bltz	a0,80001664 <wait+0x9c>
          freeproc(np);
    8000163e:	8526                	mv	a0,s1
    80001640:	00000097          	auipc	ra,0x0
    80001644:	a04080e7          	jalr	-1532(ra) # 80001044 <freeproc>
          release(&np->lock);
    80001648:	8526                	mv	a0,s1
    8000164a:	00005097          	auipc	ra,0x5
    8000164e:	c1c080e7          	jalr	-996(ra) # 80006266 <release>
          release(&wait_lock);
    80001652:	00008517          	auipc	a0,0x8
    80001656:	a1650513          	addi	a0,a0,-1514 # 80009068 <wait_lock>
    8000165a:	00005097          	auipc	ra,0x5
    8000165e:	c0c080e7          	jalr	-1012(ra) # 80006266 <release>
          return pid;
    80001662:	a09d                	j	800016c8 <wait+0x100>
            release(&np->lock);
    80001664:	8526                	mv	a0,s1
    80001666:	00005097          	auipc	ra,0x5
    8000166a:	c00080e7          	jalr	-1024(ra) # 80006266 <release>
            release(&wait_lock);
    8000166e:	00008517          	auipc	a0,0x8
    80001672:	9fa50513          	addi	a0,a0,-1542 # 80009068 <wait_lock>
    80001676:	00005097          	auipc	ra,0x5
    8000167a:	bf0080e7          	jalr	-1040(ra) # 80006266 <release>
            return -1;
    8000167e:	59fd                	li	s3,-1
    80001680:	a0a1                	j	800016c8 <wait+0x100>
    for (np = proc; np < &proc[NPROC]; np++)
    80001682:	18848493          	addi	s1,s1,392
    80001686:	03348463          	beq	s1,s3,800016ae <wait+0xe6>
      if (np->parent == p)
    8000168a:	7c9c                	ld	a5,56(s1)
    8000168c:	ff279be3          	bne	a5,s2,80001682 <wait+0xba>
        acquire(&np->lock);
    80001690:	8526                	mv	a0,s1
    80001692:	00005097          	auipc	ra,0x5
    80001696:	b20080e7          	jalr	-1248(ra) # 800061b2 <acquire>
        if (np->state == ZOMBIE)
    8000169a:	4c9c                	lw	a5,24(s1)
    8000169c:	f94781e3          	beq	a5,s4,8000161e <wait+0x56>
        release(&np->lock);
    800016a0:	8526                	mv	a0,s1
    800016a2:	00005097          	auipc	ra,0x5
    800016a6:	bc4080e7          	jalr	-1084(ra) # 80006266 <release>
        havekids = 1;
    800016aa:	8756                	mv	a4,s5
    800016ac:	bfd9                	j	80001682 <wait+0xba>
    if (!havekids || p->killed)
    800016ae:	c701                	beqz	a4,800016b6 <wait+0xee>
    800016b0:	02892783          	lw	a5,40(s2)
    800016b4:	c79d                	beqz	a5,800016e2 <wait+0x11a>
      release(&wait_lock);
    800016b6:	00008517          	auipc	a0,0x8
    800016ba:	9b250513          	addi	a0,a0,-1614 # 80009068 <wait_lock>
    800016be:	00005097          	auipc	ra,0x5
    800016c2:	ba8080e7          	jalr	-1112(ra) # 80006266 <release>
      return -1;
    800016c6:	59fd                	li	s3,-1
}
    800016c8:	854e                	mv	a0,s3
    800016ca:	60a6                	ld	ra,72(sp)
    800016cc:	6406                	ld	s0,64(sp)
    800016ce:	74e2                	ld	s1,56(sp)
    800016d0:	7942                	ld	s2,48(sp)
    800016d2:	79a2                	ld	s3,40(sp)
    800016d4:	7a02                	ld	s4,32(sp)
    800016d6:	6ae2                	ld	s5,24(sp)
    800016d8:	6b42                	ld	s6,16(sp)
    800016da:	6ba2                	ld	s7,8(sp)
    800016dc:	6c02                	ld	s8,0(sp)
    800016de:	6161                	addi	sp,sp,80
    800016e0:	8082                	ret
    sleep(p, &wait_lock); // DOC: wait-sleep
    800016e2:	85e2                	mv	a1,s8
    800016e4:	854a                	mv	a0,s2
    800016e6:	00000097          	auipc	ra,0x0
    800016ea:	e7e080e7          	jalr	-386(ra) # 80001564 <sleep>
    havekids = 0;
    800016ee:	b715                	j	80001612 <wait+0x4a>

00000000800016f0 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    800016f0:	7139                	addi	sp,sp,-64
    800016f2:	fc06                	sd	ra,56(sp)
    800016f4:	f822                	sd	s0,48(sp)
    800016f6:	f426                	sd	s1,40(sp)
    800016f8:	f04a                	sd	s2,32(sp)
    800016fa:	ec4e                	sd	s3,24(sp)
    800016fc:	e852                	sd	s4,16(sp)
    800016fe:	e456                	sd	s5,8(sp)
    80001700:	0080                	addi	s0,sp,64
    80001702:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    80001704:	00008497          	auipc	s1,0x8
    80001708:	d7c48493          	addi	s1,s1,-644 # 80009480 <proc>
  {
    if (p != myproc())
    {
      acquire(&p->lock);
      if (p->state == SLEEPING && p->chan == chan)
    8000170c:	4989                	li	s3,2
      {
        p->state = RUNNABLE;
    8000170e:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++)
    80001710:	0000e917          	auipc	s2,0xe
    80001714:	f7090913          	addi	s2,s2,-144 # 8000f680 <tickslock>
    80001718:	a821                	j	80001730 <wakeup+0x40>
        p->state = RUNNABLE;
    8000171a:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    8000171e:	8526                	mv	a0,s1
    80001720:	00005097          	auipc	ra,0x5
    80001724:	b46080e7          	jalr	-1210(ra) # 80006266 <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80001728:	18848493          	addi	s1,s1,392
    8000172c:	03248463          	beq	s1,s2,80001754 <wakeup+0x64>
    if (p != myproc())
    80001730:	fffff097          	auipc	ra,0xfffff
    80001734:	762080e7          	jalr	1890(ra) # 80000e92 <myproc>
    80001738:	fea488e3          	beq	s1,a0,80001728 <wakeup+0x38>
      acquire(&p->lock);
    8000173c:	8526                	mv	a0,s1
    8000173e:	00005097          	auipc	ra,0x5
    80001742:	a74080e7          	jalr	-1420(ra) # 800061b2 <acquire>
      if (p->state == SLEEPING && p->chan == chan)
    80001746:	4c9c                	lw	a5,24(s1)
    80001748:	fd379be3          	bne	a5,s3,8000171e <wakeup+0x2e>
    8000174c:	709c                	ld	a5,32(s1)
    8000174e:	fd4798e3          	bne	a5,s4,8000171e <wakeup+0x2e>
    80001752:	b7e1                	j	8000171a <wakeup+0x2a>
    }
  }
}
    80001754:	70e2                	ld	ra,56(sp)
    80001756:	7442                	ld	s0,48(sp)
    80001758:	74a2                	ld	s1,40(sp)
    8000175a:	7902                	ld	s2,32(sp)
    8000175c:	69e2                	ld	s3,24(sp)
    8000175e:	6a42                	ld	s4,16(sp)
    80001760:	6aa2                	ld	s5,8(sp)
    80001762:	6121                	addi	sp,sp,64
    80001764:	8082                	ret

0000000080001766 <reparent>:
{
    80001766:	7179                	addi	sp,sp,-48
    80001768:	f406                	sd	ra,40(sp)
    8000176a:	f022                	sd	s0,32(sp)
    8000176c:	ec26                	sd	s1,24(sp)
    8000176e:	e84a                	sd	s2,16(sp)
    80001770:	e44e                	sd	s3,8(sp)
    80001772:	e052                	sd	s4,0(sp)
    80001774:	1800                	addi	s0,sp,48
    80001776:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++)
    80001778:	00008497          	auipc	s1,0x8
    8000177c:	d0848493          	addi	s1,s1,-760 # 80009480 <proc>
      pp->parent = initproc;
    80001780:	00008a17          	auipc	s4,0x8
    80001784:	890a0a13          	addi	s4,s4,-1904 # 80009010 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++)
    80001788:	0000e997          	auipc	s3,0xe
    8000178c:	ef898993          	addi	s3,s3,-264 # 8000f680 <tickslock>
    80001790:	a029                	j	8000179a <reparent+0x34>
    80001792:	18848493          	addi	s1,s1,392
    80001796:	01348d63          	beq	s1,s3,800017b0 <reparent+0x4a>
    if (pp->parent == p)
    8000179a:	7c9c                	ld	a5,56(s1)
    8000179c:	ff279be3          	bne	a5,s2,80001792 <reparent+0x2c>
      pp->parent = initproc;
    800017a0:	000a3503          	ld	a0,0(s4)
    800017a4:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800017a6:	00000097          	auipc	ra,0x0
    800017aa:	f4a080e7          	jalr	-182(ra) # 800016f0 <wakeup>
    800017ae:	b7d5                	j	80001792 <reparent+0x2c>
}
    800017b0:	70a2                	ld	ra,40(sp)
    800017b2:	7402                	ld	s0,32(sp)
    800017b4:	64e2                	ld	s1,24(sp)
    800017b6:	6942                	ld	s2,16(sp)
    800017b8:	69a2                	ld	s3,8(sp)
    800017ba:	6a02                	ld	s4,0(sp)
    800017bc:	6145                	addi	sp,sp,48
    800017be:	8082                	ret

00000000800017c0 <exit>:
{
    800017c0:	7179                	addi	sp,sp,-48
    800017c2:	f406                	sd	ra,40(sp)
    800017c4:	f022                	sd	s0,32(sp)
    800017c6:	ec26                	sd	s1,24(sp)
    800017c8:	e84a                	sd	s2,16(sp)
    800017ca:	e44e                	sd	s3,8(sp)
    800017cc:	e052                	sd	s4,0(sp)
    800017ce:	1800                	addi	s0,sp,48
    800017d0:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017d2:	fffff097          	auipc	ra,0xfffff
    800017d6:	6c0080e7          	jalr	1728(ra) # 80000e92 <myproc>
    800017da:	89aa                	mv	s3,a0
  if (p == initproc)
    800017dc:	00008797          	auipc	a5,0x8
    800017e0:	8347b783          	ld	a5,-1996(a5) # 80009010 <initproc>
    800017e4:	0d850493          	addi	s1,a0,216
    800017e8:	15850913          	addi	s2,a0,344
    800017ec:	02a79363          	bne	a5,a0,80001812 <exit+0x52>
    panic("init exiting");
    800017f0:	00007517          	auipc	a0,0x7
    800017f4:	a0850513          	addi	a0,a0,-1528 # 800081f8 <etext+0x1f8>
    800017f8:	00004097          	auipc	ra,0x4
    800017fc:	470080e7          	jalr	1136(ra) # 80005c68 <panic>
      fileclose(f);
    80001800:	00002097          	auipc	ra,0x2
    80001804:	24e080e7          	jalr	590(ra) # 80003a4e <fileclose>
      p->ofile[fd] = 0;
    80001808:	0004b023          	sd	zero,0(s1)
  for (int fd = 0; fd < NOFILE; fd++)
    8000180c:	04a1                	addi	s1,s1,8
    8000180e:	01248563          	beq	s1,s2,80001818 <exit+0x58>
    if (p->ofile[fd])
    80001812:	6088                	ld	a0,0(s1)
    80001814:	f575                	bnez	a0,80001800 <exit+0x40>
    80001816:	bfdd                	j	8000180c <exit+0x4c>
  begin_op();
    80001818:	00002097          	auipc	ra,0x2
    8000181c:	d6a080e7          	jalr	-662(ra) # 80003582 <begin_op>
  iput(p->cwd);
    80001820:	1589b503          	ld	a0,344(s3)
    80001824:	00001097          	auipc	ra,0x1
    80001828:	546080e7          	jalr	1350(ra) # 80002d6a <iput>
  end_op();
    8000182c:	00002097          	auipc	ra,0x2
    80001830:	dd6080e7          	jalr	-554(ra) # 80003602 <end_op>
  p->cwd = 0;
    80001834:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    80001838:	00008497          	auipc	s1,0x8
    8000183c:	83048493          	addi	s1,s1,-2000 # 80009068 <wait_lock>
    80001840:	8526                	mv	a0,s1
    80001842:	00005097          	auipc	ra,0x5
    80001846:	970080e7          	jalr	-1680(ra) # 800061b2 <acquire>
  reparent(p);
    8000184a:	854e                	mv	a0,s3
    8000184c:	00000097          	auipc	ra,0x0
    80001850:	f1a080e7          	jalr	-230(ra) # 80001766 <reparent>
  wakeup(p->parent);
    80001854:	0389b503          	ld	a0,56(s3)
    80001858:	00000097          	auipc	ra,0x0
    8000185c:	e98080e7          	jalr	-360(ra) # 800016f0 <wakeup>
  acquire(&p->lock);
    80001860:	854e                	mv	a0,s3
    80001862:	00005097          	auipc	ra,0x5
    80001866:	950080e7          	jalr	-1712(ra) # 800061b2 <acquire>
  p->xstate = status;
    8000186a:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000186e:	4795                	li	a5,5
    80001870:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001874:	8526                	mv	a0,s1
    80001876:	00005097          	auipc	ra,0x5
    8000187a:	9f0080e7          	jalr	-1552(ra) # 80006266 <release>
  sched();
    8000187e:	00000097          	auipc	ra,0x0
    80001882:	bd4080e7          	jalr	-1068(ra) # 80001452 <sched>
  panic("zombie exit");
    80001886:	00007517          	auipc	a0,0x7
    8000188a:	98250513          	addi	a0,a0,-1662 # 80008208 <etext+0x208>
    8000188e:	00004097          	auipc	ra,0x4
    80001892:	3da080e7          	jalr	986(ra) # 80005c68 <panic>

0000000080001896 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    80001896:	7179                	addi	sp,sp,-48
    80001898:	f406                	sd	ra,40(sp)
    8000189a:	f022                	sd	s0,32(sp)
    8000189c:	ec26                	sd	s1,24(sp)
    8000189e:	e84a                	sd	s2,16(sp)
    800018a0:	e44e                	sd	s3,8(sp)
    800018a2:	1800                	addi	s0,sp,48
    800018a4:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    800018a6:	00008497          	auipc	s1,0x8
    800018aa:	bda48493          	addi	s1,s1,-1062 # 80009480 <proc>
    800018ae:	0000e997          	auipc	s3,0xe
    800018b2:	dd298993          	addi	s3,s3,-558 # 8000f680 <tickslock>
  {
    acquire(&p->lock);
    800018b6:	8526                	mv	a0,s1
    800018b8:	00005097          	auipc	ra,0x5
    800018bc:	8fa080e7          	jalr	-1798(ra) # 800061b2 <acquire>
    if (p->pid == pid)
    800018c0:	589c                	lw	a5,48(s1)
    800018c2:	01278d63          	beq	a5,s2,800018dc <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018c6:	8526                	mv	a0,s1
    800018c8:	00005097          	auipc	ra,0x5
    800018cc:	99e080e7          	jalr	-1634(ra) # 80006266 <release>
  for (p = proc; p < &proc[NPROC]; p++)
    800018d0:	18848493          	addi	s1,s1,392
    800018d4:	ff3491e3          	bne	s1,s3,800018b6 <kill+0x20>
  }
  return -1;
    800018d8:	557d                	li	a0,-1
    800018da:	a829                	j	800018f4 <kill+0x5e>
      p->killed = 1;
    800018dc:	4785                	li	a5,1
    800018de:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING)
    800018e0:	4c98                	lw	a4,24(s1)
    800018e2:	4789                	li	a5,2
    800018e4:	00f70f63          	beq	a4,a5,80001902 <kill+0x6c>
      release(&p->lock);
    800018e8:	8526                	mv	a0,s1
    800018ea:	00005097          	auipc	ra,0x5
    800018ee:	97c080e7          	jalr	-1668(ra) # 80006266 <release>
      return 0;
    800018f2:	4501                	li	a0,0
}
    800018f4:	70a2                	ld	ra,40(sp)
    800018f6:	7402                	ld	s0,32(sp)
    800018f8:	64e2                	ld	s1,24(sp)
    800018fa:	6942                	ld	s2,16(sp)
    800018fc:	69a2                	ld	s3,8(sp)
    800018fe:	6145                	addi	sp,sp,48
    80001900:	8082                	ret
        p->state = RUNNABLE;
    80001902:	478d                	li	a5,3
    80001904:	cc9c                	sw	a5,24(s1)
    80001906:	b7cd                	j	800018e8 <kill+0x52>

0000000080001908 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001908:	7179                	addi	sp,sp,-48
    8000190a:	f406                	sd	ra,40(sp)
    8000190c:	f022                	sd	s0,32(sp)
    8000190e:	ec26                	sd	s1,24(sp)
    80001910:	e84a                	sd	s2,16(sp)
    80001912:	e44e                	sd	s3,8(sp)
    80001914:	e052                	sd	s4,0(sp)
    80001916:	1800                	addi	s0,sp,48
    80001918:	84aa                	mv	s1,a0
    8000191a:	892e                	mv	s2,a1
    8000191c:	89b2                	mv	s3,a2
    8000191e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001920:	fffff097          	auipc	ra,0xfffff
    80001924:	572080e7          	jalr	1394(ra) # 80000e92 <myproc>
  if (user_dst)
    80001928:	c08d                	beqz	s1,8000194a <either_copyout+0x42>
  {
    return copyout(p->pagetable, dst, src, len);
    8000192a:	86d2                	mv	a3,s4
    8000192c:	864e                	mv	a2,s3
    8000192e:	85ca                	mv	a1,s2
    80001930:	6d28                	ld	a0,88(a0)
    80001932:	fffff097          	auipc	ra,0xfffff
    80001936:	222080e7          	jalr	546(ra) # 80000b54 <copyout>
  else
  {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000193a:	70a2                	ld	ra,40(sp)
    8000193c:	7402                	ld	s0,32(sp)
    8000193e:	64e2                	ld	s1,24(sp)
    80001940:	6942                	ld	s2,16(sp)
    80001942:	69a2                	ld	s3,8(sp)
    80001944:	6a02                	ld	s4,0(sp)
    80001946:	6145                	addi	sp,sp,48
    80001948:	8082                	ret
    memmove((char *)dst, src, len);
    8000194a:	000a061b          	sext.w	a2,s4
    8000194e:	85ce                	mv	a1,s3
    80001950:	854a                	mv	a0,s2
    80001952:	fffff097          	auipc	ra,0xfffff
    80001956:	8d0080e7          	jalr	-1840(ra) # 80000222 <memmove>
    return 0;
    8000195a:	8526                	mv	a0,s1
    8000195c:	bff9                	j	8000193a <either_copyout+0x32>

000000008000195e <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000195e:	7179                	addi	sp,sp,-48
    80001960:	f406                	sd	ra,40(sp)
    80001962:	f022                	sd	s0,32(sp)
    80001964:	ec26                	sd	s1,24(sp)
    80001966:	e84a                	sd	s2,16(sp)
    80001968:	e44e                	sd	s3,8(sp)
    8000196a:	e052                	sd	s4,0(sp)
    8000196c:	1800                	addi	s0,sp,48
    8000196e:	892a                	mv	s2,a0
    80001970:	84ae                	mv	s1,a1
    80001972:	89b2                	mv	s3,a2
    80001974:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001976:	fffff097          	auipc	ra,0xfffff
    8000197a:	51c080e7          	jalr	1308(ra) # 80000e92 <myproc>
  if (user_src)
    8000197e:	c08d                	beqz	s1,800019a0 <either_copyin+0x42>
  {
    return copyin(p->pagetable, dst, src, len);
    80001980:	86d2                	mv	a3,s4
    80001982:	864e                	mv	a2,s3
    80001984:	85ca                	mv	a1,s2
    80001986:	6d28                	ld	a0,88(a0)
    80001988:	fffff097          	auipc	ra,0xfffff
    8000198c:	258080e7          	jalr	600(ra) # 80000be0 <copyin>
  else
  {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    80001990:	70a2                	ld	ra,40(sp)
    80001992:	7402                	ld	s0,32(sp)
    80001994:	64e2                	ld	s1,24(sp)
    80001996:	6942                	ld	s2,16(sp)
    80001998:	69a2                	ld	s3,8(sp)
    8000199a:	6a02                	ld	s4,0(sp)
    8000199c:	6145                	addi	sp,sp,48
    8000199e:	8082                	ret
    memmove(dst, (char *)src, len);
    800019a0:	000a061b          	sext.w	a2,s4
    800019a4:	85ce                	mv	a1,s3
    800019a6:	854a                	mv	a0,s2
    800019a8:	fffff097          	auipc	ra,0xfffff
    800019ac:	87a080e7          	jalr	-1926(ra) # 80000222 <memmove>
    return 0;
    800019b0:	8526                	mv	a0,s1
    800019b2:	bff9                	j	80001990 <either_copyin+0x32>

00000000800019b4 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    800019b4:	715d                	addi	sp,sp,-80
    800019b6:	e486                	sd	ra,72(sp)
    800019b8:	e0a2                	sd	s0,64(sp)
    800019ba:	fc26                	sd	s1,56(sp)
    800019bc:	f84a                	sd	s2,48(sp)
    800019be:	f44e                	sd	s3,40(sp)
    800019c0:	f052                	sd	s4,32(sp)
    800019c2:	ec56                	sd	s5,24(sp)
    800019c4:	e85a                	sd	s6,16(sp)
    800019c6:	e45e                	sd	s7,8(sp)
    800019c8:	0880                	addi	s0,sp,80
      [RUNNING] "run   ",
      [ZOMBIE] "zombie"};
  struct proc *p;
  char *state;

  printf("\n");
    800019ca:	00006517          	auipc	a0,0x6
    800019ce:	67e50513          	addi	a0,a0,1662 # 80008048 <etext+0x48>
    800019d2:	00004097          	auipc	ra,0x4
    800019d6:	2e0080e7          	jalr	736(ra) # 80005cb2 <printf>
  for (p = proc; p < &proc[NPROC]; p++)
    800019da:	00008497          	auipc	s1,0x8
    800019de:	c0648493          	addi	s1,s1,-1018 # 800095e0 <proc+0x160>
    800019e2:	0000e917          	auipc	s2,0xe
    800019e6:	dfe90913          	addi	s2,s2,-514 # 8000f7e0 <bcache+0x148>
  {
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019ea:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019ec:	00007997          	auipc	s3,0x7
    800019f0:	82c98993          	addi	s3,s3,-2004 # 80008218 <etext+0x218>
    printf("%d %s %s", p->pid, state, p->name);
    800019f4:	00007a97          	auipc	s5,0x7
    800019f8:	82ca8a93          	addi	s5,s5,-2004 # 80008220 <etext+0x220>
    printf("\n");
    800019fc:	00006a17          	auipc	s4,0x6
    80001a00:	64ca0a13          	addi	s4,s4,1612 # 80008048 <etext+0x48>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a04:	00007b97          	auipc	s7,0x7
    80001a08:	854b8b93          	addi	s7,s7,-1964 # 80008258 <states.1711>
    80001a0c:	a00d                	j	80001a2e <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a0e:	ed06a583          	lw	a1,-304(a3)
    80001a12:	8556                	mv	a0,s5
    80001a14:	00004097          	auipc	ra,0x4
    80001a18:	29e080e7          	jalr	670(ra) # 80005cb2 <printf>
    printf("\n");
    80001a1c:	8552                	mv	a0,s4
    80001a1e:	00004097          	auipc	ra,0x4
    80001a22:	294080e7          	jalr	660(ra) # 80005cb2 <printf>
  for (p = proc; p < &proc[NPROC]; p++)
    80001a26:	18848493          	addi	s1,s1,392
    80001a2a:	03248163          	beq	s1,s2,80001a4c <procdump+0x98>
    if (p->state == UNUSED)
    80001a2e:	86a6                	mv	a3,s1
    80001a30:	eb84a783          	lw	a5,-328(s1)
    80001a34:	dbed                	beqz	a5,80001a26 <procdump+0x72>
      state = "???";
    80001a36:	864e                	mv	a2,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a38:	fcfb6be3          	bltu	s6,a5,80001a0e <procdump+0x5a>
    80001a3c:	1782                	slli	a5,a5,0x20
    80001a3e:	9381                	srli	a5,a5,0x20
    80001a40:	078e                	slli	a5,a5,0x3
    80001a42:	97de                	add	a5,a5,s7
    80001a44:	6390                	ld	a2,0(a5)
    80001a46:	f661                	bnez	a2,80001a0e <procdump+0x5a>
      state = "???";
    80001a48:	864e                	mv	a2,s3
    80001a4a:	b7d1                	j	80001a0e <procdump+0x5a>
  }
}
    80001a4c:	60a6                	ld	ra,72(sp)
    80001a4e:	6406                	ld	s0,64(sp)
    80001a50:	74e2                	ld	s1,56(sp)
    80001a52:	7942                	ld	s2,48(sp)
    80001a54:	79a2                	ld	s3,40(sp)
    80001a56:	7a02                	ld	s4,32(sp)
    80001a58:	6ae2                	ld	s5,24(sp)
    80001a5a:	6b42                	ld	s6,16(sp)
    80001a5c:	6ba2                	ld	s7,8(sp)
    80001a5e:	6161                	addi	sp,sp,80
    80001a60:	8082                	ret

0000000080001a62 <getprocesscount>:

int getprocesscount(void)
{
    80001a62:	1141                	addi	sp,sp,-16
    80001a64:	e422                	sd	s0,8(sp)
    80001a66:	0800                	addi	s0,sp,16
  uint64 count = 0;
  struct proc *p;
  for (p = proc; p < &proc[NPROC]; p++)
    80001a68:	00008797          	auipc	a5,0x8
    80001a6c:	a1878793          	addi	a5,a5,-1512 # 80009480 <proc>
  uint64 count = 0;
    80001a70:	4501                	li	a0,0
  for (p = proc; p < &proc[NPROC]; p++)
    80001a72:	0000e697          	auipc	a3,0xe
    80001a76:	c0e68693          	addi	a3,a3,-1010 # 8000f680 <tickslock>
  {
    if (p->state != UNUSED)
    80001a7a:	4f98                	lw	a4,24(a5)
      count++;
    80001a7c:	00e03733          	snez	a4,a4
    80001a80:	953a                	add	a0,a0,a4
  for (p = proc; p < &proc[NPROC]; p++)
    80001a82:	18878793          	addi	a5,a5,392
    80001a86:	fed79ae3          	bne	a5,a3,80001a7a <getprocesscount+0x18>
  }
  return count;
    80001a8a:	2501                	sext.w	a0,a0
    80001a8c:	6422                	ld	s0,8(sp)
    80001a8e:	0141                	addi	sp,sp,16
    80001a90:	8082                	ret

0000000080001a92 <swtch>:
    80001a92:	00153023          	sd	ra,0(a0)
    80001a96:	00253423          	sd	sp,8(a0)
    80001a9a:	e900                	sd	s0,16(a0)
    80001a9c:	ed04                	sd	s1,24(a0)
    80001a9e:	03253023          	sd	s2,32(a0)
    80001aa2:	03353423          	sd	s3,40(a0)
    80001aa6:	03453823          	sd	s4,48(a0)
    80001aaa:	03553c23          	sd	s5,56(a0)
    80001aae:	05653023          	sd	s6,64(a0)
    80001ab2:	05753423          	sd	s7,72(a0)
    80001ab6:	05853823          	sd	s8,80(a0)
    80001aba:	05953c23          	sd	s9,88(a0)
    80001abe:	07a53023          	sd	s10,96(a0)
    80001ac2:	07b53423          	sd	s11,104(a0)
    80001ac6:	0005b083          	ld	ra,0(a1)
    80001aca:	0085b103          	ld	sp,8(a1)
    80001ace:	6980                	ld	s0,16(a1)
    80001ad0:	6d84                	ld	s1,24(a1)
    80001ad2:	0205b903          	ld	s2,32(a1)
    80001ad6:	0285b983          	ld	s3,40(a1)
    80001ada:	0305ba03          	ld	s4,48(a1)
    80001ade:	0385ba83          	ld	s5,56(a1)
    80001ae2:	0405bb03          	ld	s6,64(a1)
    80001ae6:	0485bb83          	ld	s7,72(a1)
    80001aea:	0505bc03          	ld	s8,80(a1)
    80001aee:	0585bc83          	ld	s9,88(a1)
    80001af2:	0605bd03          	ld	s10,96(a1)
    80001af6:	0685bd83          	ld	s11,104(a1)
    80001afa:	8082                	ret

0000000080001afc <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001afc:	1141                	addi	sp,sp,-16
    80001afe:	e406                	sd	ra,8(sp)
    80001b00:	e022                	sd	s0,0(sp)
    80001b02:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b04:	00006597          	auipc	a1,0x6
    80001b08:	78458593          	addi	a1,a1,1924 # 80008288 <states.1711+0x30>
    80001b0c:	0000e517          	auipc	a0,0xe
    80001b10:	b7450513          	addi	a0,a0,-1164 # 8000f680 <tickslock>
    80001b14:	00004097          	auipc	ra,0x4
    80001b18:	60e080e7          	jalr	1550(ra) # 80006122 <initlock>
}
    80001b1c:	60a2                	ld	ra,8(sp)
    80001b1e:	6402                	ld	s0,0(sp)
    80001b20:	0141                	addi	sp,sp,16
    80001b22:	8082                	ret

0000000080001b24 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b24:	1141                	addi	sp,sp,-16
    80001b26:	e422                	sd	s0,8(sp)
    80001b28:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r"(x));
    80001b2a:	00003797          	auipc	a5,0x3
    80001b2e:	54678793          	addi	a5,a5,1350 # 80005070 <kernelvec>
    80001b32:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b36:	6422                	ld	s0,8(sp)
    80001b38:	0141                	addi	sp,sp,16
    80001b3a:	8082                	ret

0000000080001b3c <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b3c:	1141                	addi	sp,sp,-16
    80001b3e:	e406                	sd	ra,8(sp)
    80001b40:	e022                	sd	s0,0(sp)
    80001b42:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b44:	fffff097          	auipc	ra,0xfffff
    80001b48:	34e080e7          	jalr	846(ra) # 80000e92 <myproc>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001b4c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b50:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001b52:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001b56:	00005617          	auipc	a2,0x5
    80001b5a:	4aa60613          	addi	a2,a2,1194 # 80007000 <_trampoline>
    80001b5e:	00005697          	auipc	a3,0x5
    80001b62:	4a268693          	addi	a3,a3,1186 # 80007000 <_trampoline>
    80001b66:	8e91                	sub	a3,a3,a2
    80001b68:	040007b7          	lui	a5,0x4000
    80001b6c:	17fd                	addi	a5,a5,-1
    80001b6e:	07b2                	slli	a5,a5,0xc
    80001b70:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r"(x));
    80001b72:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b76:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r"(x));
    80001b78:	180026f3          	csrr	a3,satp
    80001b7c:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b7e:	7138                	ld	a4,96(a0)
    80001b80:	6534                	ld	a3,72(a0)
    80001b82:	6585                	lui	a1,0x1
    80001b84:	96ae                	add	a3,a3,a1
    80001b86:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b88:	7138                	ld	a4,96(a0)
    80001b8a:	00000697          	auipc	a3,0x0
    80001b8e:	13868693          	addi	a3,a3,312 # 80001cc2 <usertrap>
    80001b92:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b94:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r"(x));
    80001b96:	8692                	mv	a3,tp
    80001b98:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001b9a:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b9e:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001ba2:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001ba6:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001baa:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r"(x));
    80001bac:	6f18                	ld	a4,24(a4)
    80001bae:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001bb2:	6d2c                	ld	a1,88(a0)
    80001bb4:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001bb6:	00005717          	auipc	a4,0x5
    80001bba:	4da70713          	addi	a4,a4,1242 # 80007090 <userret>
    80001bbe:	8f11                	sub	a4,a4,a2
    80001bc0:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001bc2:	577d                	li	a4,-1
    80001bc4:	177e                	slli	a4,a4,0x3f
    80001bc6:	8dd9                	or	a1,a1,a4
    80001bc8:	02000537          	lui	a0,0x2000
    80001bcc:	157d                	addi	a0,a0,-1
    80001bce:	0536                	slli	a0,a0,0xd
    80001bd0:	9782                	jalr	a5
}
    80001bd2:	60a2                	ld	ra,8(sp)
    80001bd4:	6402                	ld	s0,0(sp)
    80001bd6:	0141                	addi	sp,sp,16
    80001bd8:	8082                	ret

0000000080001bda <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001bda:	1101                	addi	sp,sp,-32
    80001bdc:	ec06                	sd	ra,24(sp)
    80001bde:	e822                	sd	s0,16(sp)
    80001be0:	e426                	sd	s1,8(sp)
    80001be2:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001be4:	0000e497          	auipc	s1,0xe
    80001be8:	a9c48493          	addi	s1,s1,-1380 # 8000f680 <tickslock>
    80001bec:	8526                	mv	a0,s1
    80001bee:	00004097          	auipc	ra,0x4
    80001bf2:	5c4080e7          	jalr	1476(ra) # 800061b2 <acquire>
  ticks++;
    80001bf6:	00007517          	auipc	a0,0x7
    80001bfa:	42250513          	addi	a0,a0,1058 # 80009018 <ticks>
    80001bfe:	411c                	lw	a5,0(a0)
    80001c00:	2785                	addiw	a5,a5,1
    80001c02:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c04:	00000097          	auipc	ra,0x0
    80001c08:	aec080e7          	jalr	-1300(ra) # 800016f0 <wakeup>
  release(&tickslock);
    80001c0c:	8526                	mv	a0,s1
    80001c0e:	00004097          	auipc	ra,0x4
    80001c12:	658080e7          	jalr	1624(ra) # 80006266 <release>
}
    80001c16:	60e2                	ld	ra,24(sp)
    80001c18:	6442                	ld	s0,16(sp)
    80001c1a:	64a2                	ld	s1,8(sp)
    80001c1c:	6105                	addi	sp,sp,32
    80001c1e:	8082                	ret

0000000080001c20 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001c20:	1101                	addi	sp,sp,-32
    80001c22:	ec06                	sd	ra,24(sp)
    80001c24:	e822                	sd	s0,16(sp)
    80001c26:	e426                	sd	s1,8(sp)
    80001c28:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r"(x));
    80001c2a:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001c2e:	00074d63          	bltz	a4,80001c48 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001c32:	57fd                	li	a5,-1
    80001c34:	17fe                	slli	a5,a5,0x3f
    80001c36:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c38:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c3a:	06f70363          	beq	a4,a5,80001ca0 <devintr+0x80>
  }
}
    80001c3e:	60e2                	ld	ra,24(sp)
    80001c40:	6442                	ld	s0,16(sp)
    80001c42:	64a2                	ld	s1,8(sp)
    80001c44:	6105                	addi	sp,sp,32
    80001c46:	8082                	ret
     (scause & 0xff) == 9){
    80001c48:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001c4c:	46a5                	li	a3,9
    80001c4e:	fed792e3          	bne	a5,a3,80001c32 <devintr+0x12>
    int irq = plic_claim();
    80001c52:	00003097          	auipc	ra,0x3
    80001c56:	526080e7          	jalr	1318(ra) # 80005178 <plic_claim>
    80001c5a:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c5c:	47a9                	li	a5,10
    80001c5e:	02f50763          	beq	a0,a5,80001c8c <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001c62:	4785                	li	a5,1
    80001c64:	02f50963          	beq	a0,a5,80001c96 <devintr+0x76>
    return 1;
    80001c68:	4505                	li	a0,1
    } else if(irq){
    80001c6a:	d8f1                	beqz	s1,80001c3e <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c6c:	85a6                	mv	a1,s1
    80001c6e:	00006517          	auipc	a0,0x6
    80001c72:	62250513          	addi	a0,a0,1570 # 80008290 <states.1711+0x38>
    80001c76:	00004097          	auipc	ra,0x4
    80001c7a:	03c080e7          	jalr	60(ra) # 80005cb2 <printf>
      plic_complete(irq);
    80001c7e:	8526                	mv	a0,s1
    80001c80:	00003097          	auipc	ra,0x3
    80001c84:	51c080e7          	jalr	1308(ra) # 8000519c <plic_complete>
    return 1;
    80001c88:	4505                	li	a0,1
    80001c8a:	bf55                	j	80001c3e <devintr+0x1e>
      uartintr();
    80001c8c:	00004097          	auipc	ra,0x4
    80001c90:	446080e7          	jalr	1094(ra) # 800060d2 <uartintr>
    80001c94:	b7ed                	j	80001c7e <devintr+0x5e>
      virtio_disk_intr();
    80001c96:	00004097          	auipc	ra,0x4
    80001c9a:	9e6080e7          	jalr	-1562(ra) # 8000567c <virtio_disk_intr>
    80001c9e:	b7c5                	j	80001c7e <devintr+0x5e>
    if(cpuid() == 0){
    80001ca0:	fffff097          	auipc	ra,0xfffff
    80001ca4:	1c6080e7          	jalr	454(ra) # 80000e66 <cpuid>
    80001ca8:	c901                	beqz	a0,80001cb8 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r"(x));
    80001caa:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001cae:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r"(x));
    80001cb0:	14479073          	csrw	sip,a5
    return 2;
    80001cb4:	4509                	li	a0,2
    80001cb6:	b761                	j	80001c3e <devintr+0x1e>
      clockintr();
    80001cb8:	00000097          	auipc	ra,0x0
    80001cbc:	f22080e7          	jalr	-222(ra) # 80001bda <clockintr>
    80001cc0:	b7ed                	j	80001caa <devintr+0x8a>

0000000080001cc2 <usertrap>:
{
    80001cc2:	1101                	addi	sp,sp,-32
    80001cc4:	ec06                	sd	ra,24(sp)
    80001cc6:	e822                	sd	s0,16(sp)
    80001cc8:	e426                	sd	s1,8(sp)
    80001cca:	e04a                	sd	s2,0(sp)
    80001ccc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001cce:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001cd2:	1007f793          	andi	a5,a5,256
    80001cd6:	e3ad                	bnez	a5,80001d38 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r"(x));
    80001cd8:	00003797          	auipc	a5,0x3
    80001cdc:	39878793          	addi	a5,a5,920 # 80005070 <kernelvec>
    80001ce0:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001ce4:	fffff097          	auipc	ra,0xfffff
    80001ce8:	1ae080e7          	jalr	430(ra) # 80000e92 <myproc>
    80001cec:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001cee:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001cf0:	14102773          	csrr	a4,sepc
    80001cf4:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r"(x));
    80001cf6:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001cfa:	47a1                	li	a5,8
    80001cfc:	04f71c63          	bne	a4,a5,80001d54 <usertrap+0x92>
    if(p->killed)
    80001d00:	551c                	lw	a5,40(a0)
    80001d02:	e3b9                	bnez	a5,80001d48 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001d04:	70b8                	ld	a4,96(s1)
    80001d06:	6f1c                	ld	a5,24(a4)
    80001d08:	0791                	addi	a5,a5,4
    80001d0a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001d0c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d10:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001d14:	10079073          	csrw	sstatus,a5
    syscall();
    80001d18:	00000097          	auipc	ra,0x0
    80001d1c:	2e0080e7          	jalr	736(ra) # 80001ff8 <syscall>
  if(p->killed)
    80001d20:	549c                	lw	a5,40(s1)
    80001d22:	ebc1                	bnez	a5,80001db2 <usertrap+0xf0>
  usertrapret();
    80001d24:	00000097          	auipc	ra,0x0
    80001d28:	e18080e7          	jalr	-488(ra) # 80001b3c <usertrapret>
}
    80001d2c:	60e2                	ld	ra,24(sp)
    80001d2e:	6442                	ld	s0,16(sp)
    80001d30:	64a2                	ld	s1,8(sp)
    80001d32:	6902                	ld	s2,0(sp)
    80001d34:	6105                	addi	sp,sp,32
    80001d36:	8082                	ret
    panic("usertrap: not from user mode");
    80001d38:	00006517          	auipc	a0,0x6
    80001d3c:	57850513          	addi	a0,a0,1400 # 800082b0 <states.1711+0x58>
    80001d40:	00004097          	auipc	ra,0x4
    80001d44:	f28080e7          	jalr	-216(ra) # 80005c68 <panic>
      exit(-1);
    80001d48:	557d                	li	a0,-1
    80001d4a:	00000097          	auipc	ra,0x0
    80001d4e:	a76080e7          	jalr	-1418(ra) # 800017c0 <exit>
    80001d52:	bf4d                	j	80001d04 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001d54:	00000097          	auipc	ra,0x0
    80001d58:	ecc080e7          	jalr	-308(ra) # 80001c20 <devintr>
    80001d5c:	892a                	mv	s2,a0
    80001d5e:	c501                	beqz	a0,80001d66 <usertrap+0xa4>
  if(p->killed)
    80001d60:	549c                	lw	a5,40(s1)
    80001d62:	c3a1                	beqz	a5,80001da2 <usertrap+0xe0>
    80001d64:	a815                	j	80001d98 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r"(x));
    80001d66:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d6a:	5890                	lw	a2,48(s1)
    80001d6c:	00006517          	auipc	a0,0x6
    80001d70:	56450513          	addi	a0,a0,1380 # 800082d0 <states.1711+0x78>
    80001d74:	00004097          	auipc	ra,0x4
    80001d78:	f3e080e7          	jalr	-194(ra) # 80005cb2 <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001d7c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80001d80:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d84:	00006517          	auipc	a0,0x6
    80001d88:	57c50513          	addi	a0,a0,1404 # 80008300 <states.1711+0xa8>
    80001d8c:	00004097          	auipc	ra,0x4
    80001d90:	f26080e7          	jalr	-218(ra) # 80005cb2 <printf>
    p->killed = 1;
    80001d94:	4785                	li	a5,1
    80001d96:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001d98:	557d                	li	a0,-1
    80001d9a:	00000097          	auipc	ra,0x0
    80001d9e:	a26080e7          	jalr	-1498(ra) # 800017c0 <exit>
  if(which_dev == 2)
    80001da2:	4789                	li	a5,2
    80001da4:	f8f910e3          	bne	s2,a5,80001d24 <usertrap+0x62>
    yield();
    80001da8:	fffff097          	auipc	ra,0xfffff
    80001dac:	780080e7          	jalr	1920(ra) # 80001528 <yield>
    80001db0:	bf95                	j	80001d24 <usertrap+0x62>
  int which_dev = 0;
    80001db2:	4901                	li	s2,0
    80001db4:	b7d5                	j	80001d98 <usertrap+0xd6>

0000000080001db6 <kerneltrap>:
{
    80001db6:	7179                	addi	sp,sp,-48
    80001db8:	f406                	sd	ra,40(sp)
    80001dba:	f022                	sd	s0,32(sp)
    80001dbc:	ec26                	sd	s1,24(sp)
    80001dbe:	e84a                	sd	s2,16(sp)
    80001dc0:	e44e                	sd	s3,8(sp)
    80001dc2:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001dc4:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001dc8:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r"(x));
    80001dcc:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001dd0:	1004f793          	andi	a5,s1,256
    80001dd4:	cb85                	beqz	a5,80001e04 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001dd6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001dda:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001ddc:	ef85                	bnez	a5,80001e14 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001dde:	00000097          	auipc	ra,0x0
    80001de2:	e42080e7          	jalr	-446(ra) # 80001c20 <devintr>
    80001de6:	cd1d                	beqz	a0,80001e24 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001de8:	4789                	li	a5,2
    80001dea:	06f50a63          	beq	a0,a5,80001e5e <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r"(x));
    80001dee:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001df2:	10049073          	csrw	sstatus,s1
}
    80001df6:	70a2                	ld	ra,40(sp)
    80001df8:	7402                	ld	s0,32(sp)
    80001dfa:	64e2                	ld	s1,24(sp)
    80001dfc:	6942                	ld	s2,16(sp)
    80001dfe:	69a2                	ld	s3,8(sp)
    80001e00:	6145                	addi	sp,sp,48
    80001e02:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e04:	00006517          	auipc	a0,0x6
    80001e08:	51c50513          	addi	a0,a0,1308 # 80008320 <states.1711+0xc8>
    80001e0c:	00004097          	auipc	ra,0x4
    80001e10:	e5c080e7          	jalr	-420(ra) # 80005c68 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e14:	00006517          	auipc	a0,0x6
    80001e18:	53450513          	addi	a0,a0,1332 # 80008348 <states.1711+0xf0>
    80001e1c:	00004097          	auipc	ra,0x4
    80001e20:	e4c080e7          	jalr	-436(ra) # 80005c68 <panic>
    printf("scause %p\n", scause);
    80001e24:	85ce                	mv	a1,s3
    80001e26:	00006517          	auipc	a0,0x6
    80001e2a:	54250513          	addi	a0,a0,1346 # 80008368 <states.1711+0x110>
    80001e2e:	00004097          	auipc	ra,0x4
    80001e32:	e84080e7          	jalr	-380(ra) # 80005cb2 <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001e36:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80001e3a:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e3e:	00006517          	auipc	a0,0x6
    80001e42:	53a50513          	addi	a0,a0,1338 # 80008378 <states.1711+0x120>
    80001e46:	00004097          	auipc	ra,0x4
    80001e4a:	e6c080e7          	jalr	-404(ra) # 80005cb2 <printf>
    panic("kerneltrap");
    80001e4e:	00006517          	auipc	a0,0x6
    80001e52:	54250513          	addi	a0,a0,1346 # 80008390 <states.1711+0x138>
    80001e56:	00004097          	auipc	ra,0x4
    80001e5a:	e12080e7          	jalr	-494(ra) # 80005c68 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e5e:	fffff097          	auipc	ra,0xfffff
    80001e62:	034080e7          	jalr	52(ra) # 80000e92 <myproc>
    80001e66:	d541                	beqz	a0,80001dee <kerneltrap+0x38>
    80001e68:	fffff097          	auipc	ra,0xfffff
    80001e6c:	02a080e7          	jalr	42(ra) # 80000e92 <myproc>
    80001e70:	4d18                	lw	a4,24(a0)
    80001e72:	4791                	li	a5,4
    80001e74:	f6f71de3          	bne	a4,a5,80001dee <kerneltrap+0x38>
    yield();
    80001e78:	fffff097          	auipc	ra,0xfffff
    80001e7c:	6b0080e7          	jalr	1712(ra) # 80001528 <yield>
    80001e80:	b7bd                	j	80001dee <kerneltrap+0x38>

0000000080001e82 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e82:	1101                	addi	sp,sp,-32
    80001e84:	ec06                	sd	ra,24(sp)
    80001e86:	e822                	sd	s0,16(sp)
    80001e88:	e426                	sd	s1,8(sp)
    80001e8a:	1000                	addi	s0,sp,32
    80001e8c:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e8e:	fffff097          	auipc	ra,0xfffff
    80001e92:	004080e7          	jalr	4(ra) # 80000e92 <myproc>
  switch (n)
    80001e96:	4795                	li	a5,5
    80001e98:	0497e163          	bltu	a5,s1,80001eda <argraw+0x58>
    80001e9c:	048a                	slli	s1,s1,0x2
    80001e9e:	00006717          	auipc	a4,0x6
    80001ea2:	5f270713          	addi	a4,a4,1522 # 80008490 <states.1711+0x238>
    80001ea6:	94ba                	add	s1,s1,a4
    80001ea8:	409c                	lw	a5,0(s1)
    80001eaa:	97ba                	add	a5,a5,a4
    80001eac:	8782                	jr	a5
  {
  case 0:
    return p->trapframe->a0;
    80001eae:	713c                	ld	a5,96(a0)
    80001eb0:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001eb2:	60e2                	ld	ra,24(sp)
    80001eb4:	6442                	ld	s0,16(sp)
    80001eb6:	64a2                	ld	s1,8(sp)
    80001eb8:	6105                	addi	sp,sp,32
    80001eba:	8082                	ret
    return p->trapframe->a1;
    80001ebc:	713c                	ld	a5,96(a0)
    80001ebe:	7fa8                	ld	a0,120(a5)
    80001ec0:	bfcd                	j	80001eb2 <argraw+0x30>
    return p->trapframe->a2;
    80001ec2:	713c                	ld	a5,96(a0)
    80001ec4:	63c8                	ld	a0,128(a5)
    80001ec6:	b7f5                	j	80001eb2 <argraw+0x30>
    return p->trapframe->a3;
    80001ec8:	713c                	ld	a5,96(a0)
    80001eca:	67c8                	ld	a0,136(a5)
    80001ecc:	b7dd                	j	80001eb2 <argraw+0x30>
    return p->trapframe->a4;
    80001ece:	713c                	ld	a5,96(a0)
    80001ed0:	6bc8                	ld	a0,144(a5)
    80001ed2:	b7c5                	j	80001eb2 <argraw+0x30>
    return p->trapframe->a5;
    80001ed4:	713c                	ld	a5,96(a0)
    80001ed6:	6fc8                	ld	a0,152(a5)
    80001ed8:	bfe9                	j	80001eb2 <argraw+0x30>
  panic("argraw");
    80001eda:	00006517          	auipc	a0,0x6
    80001ede:	4c650513          	addi	a0,a0,1222 # 800083a0 <states.1711+0x148>
    80001ee2:	00004097          	auipc	ra,0x4
    80001ee6:	d86080e7          	jalr	-634(ra) # 80005c68 <panic>

0000000080001eea <fetchaddr>:
{
    80001eea:	1101                	addi	sp,sp,-32
    80001eec:	ec06                	sd	ra,24(sp)
    80001eee:	e822                	sd	s0,16(sp)
    80001ef0:	e426                	sd	s1,8(sp)
    80001ef2:	e04a                	sd	s2,0(sp)
    80001ef4:	1000                	addi	s0,sp,32
    80001ef6:	84aa                	mv	s1,a0
    80001ef8:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001efa:	fffff097          	auipc	ra,0xfffff
    80001efe:	f98080e7          	jalr	-104(ra) # 80000e92 <myproc>
  if (addr >= p->sz || addr + sizeof(uint64) > p->sz)
    80001f02:	693c                	ld	a5,80(a0)
    80001f04:	02f4f863          	bgeu	s1,a5,80001f34 <fetchaddr+0x4a>
    80001f08:	00848713          	addi	a4,s1,8
    80001f0c:	02e7e663          	bltu	a5,a4,80001f38 <fetchaddr+0x4e>
  if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f10:	46a1                	li	a3,8
    80001f12:	8626                	mv	a2,s1
    80001f14:	85ca                	mv	a1,s2
    80001f16:	6d28                	ld	a0,88(a0)
    80001f18:	fffff097          	auipc	ra,0xfffff
    80001f1c:	cc8080e7          	jalr	-824(ra) # 80000be0 <copyin>
    80001f20:	00a03533          	snez	a0,a0
    80001f24:	40a00533          	neg	a0,a0
}
    80001f28:	60e2                	ld	ra,24(sp)
    80001f2a:	6442                	ld	s0,16(sp)
    80001f2c:	64a2                	ld	s1,8(sp)
    80001f2e:	6902                	ld	s2,0(sp)
    80001f30:	6105                	addi	sp,sp,32
    80001f32:	8082                	ret
    return -1;
    80001f34:	557d                	li	a0,-1
    80001f36:	bfcd                	j	80001f28 <fetchaddr+0x3e>
    80001f38:	557d                	li	a0,-1
    80001f3a:	b7fd                	j	80001f28 <fetchaddr+0x3e>

0000000080001f3c <fetchstr>:
{
    80001f3c:	7179                	addi	sp,sp,-48
    80001f3e:	f406                	sd	ra,40(sp)
    80001f40:	f022                	sd	s0,32(sp)
    80001f42:	ec26                	sd	s1,24(sp)
    80001f44:	e84a                	sd	s2,16(sp)
    80001f46:	e44e                	sd	s3,8(sp)
    80001f48:	1800                	addi	s0,sp,48
    80001f4a:	892a                	mv	s2,a0
    80001f4c:	84ae                	mv	s1,a1
    80001f4e:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f50:	fffff097          	auipc	ra,0xfffff
    80001f54:	f42080e7          	jalr	-190(ra) # 80000e92 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001f58:	86ce                	mv	a3,s3
    80001f5a:	864a                	mv	a2,s2
    80001f5c:	85a6                	mv	a1,s1
    80001f5e:	6d28                	ld	a0,88(a0)
    80001f60:	fffff097          	auipc	ra,0xfffff
    80001f64:	d0c080e7          	jalr	-756(ra) # 80000c6c <copyinstr>
  if (err < 0)
    80001f68:	00054763          	bltz	a0,80001f76 <fetchstr+0x3a>
  return strlen(buf);
    80001f6c:	8526                	mv	a0,s1
    80001f6e:	ffffe097          	auipc	ra,0xffffe
    80001f72:	3d8080e7          	jalr	984(ra) # 80000346 <strlen>
}
    80001f76:	70a2                	ld	ra,40(sp)
    80001f78:	7402                	ld	s0,32(sp)
    80001f7a:	64e2                	ld	s1,24(sp)
    80001f7c:	6942                	ld	s2,16(sp)
    80001f7e:	69a2                	ld	s3,8(sp)
    80001f80:	6145                	addi	sp,sp,48
    80001f82:	8082                	ret

0000000080001f84 <argint>:

// Fetch the nth 32-bit system call argument.
int argint(int n, int *ip)
{
    80001f84:	1101                	addi	sp,sp,-32
    80001f86:	ec06                	sd	ra,24(sp)
    80001f88:	e822                	sd	s0,16(sp)
    80001f8a:	e426                	sd	s1,8(sp)
    80001f8c:	1000                	addi	s0,sp,32
    80001f8e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f90:	00000097          	auipc	ra,0x0
    80001f94:	ef2080e7          	jalr	-270(ra) # 80001e82 <argraw>
    80001f98:	c088                	sw	a0,0(s1)
  return 0;
}
    80001f9a:	4501                	li	a0,0
    80001f9c:	60e2                	ld	ra,24(sp)
    80001f9e:	6442                	ld	s0,16(sp)
    80001fa0:	64a2                	ld	s1,8(sp)
    80001fa2:	6105                	addi	sp,sp,32
    80001fa4:	8082                	ret

0000000080001fa6 <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int argaddr(int n, uint64 *ip)
{
    80001fa6:	1101                	addi	sp,sp,-32
    80001fa8:	ec06                	sd	ra,24(sp)
    80001faa:	e822                	sd	s0,16(sp)
    80001fac:	e426                	sd	s1,8(sp)
    80001fae:	1000                	addi	s0,sp,32
    80001fb0:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fb2:	00000097          	auipc	ra,0x0
    80001fb6:	ed0080e7          	jalr	-304(ra) # 80001e82 <argraw>
    80001fba:	e088                	sd	a0,0(s1)
  return 0;
}
    80001fbc:	4501                	li	a0,0
    80001fbe:	60e2                	ld	ra,24(sp)
    80001fc0:	6442                	ld	s0,16(sp)
    80001fc2:	64a2                	ld	s1,8(sp)
    80001fc4:	6105                	addi	sp,sp,32
    80001fc6:	8082                	ret

0000000080001fc8 <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max)
{
    80001fc8:	1101                	addi	sp,sp,-32
    80001fca:	ec06                	sd	ra,24(sp)
    80001fcc:	e822                	sd	s0,16(sp)
    80001fce:	e426                	sd	s1,8(sp)
    80001fd0:	e04a                	sd	s2,0(sp)
    80001fd2:	1000                	addi	s0,sp,32
    80001fd4:	84ae                	mv	s1,a1
    80001fd6:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001fd8:	00000097          	auipc	ra,0x0
    80001fdc:	eaa080e7          	jalr	-342(ra) # 80001e82 <argraw>
  uint64 addr;
  if (argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001fe0:	864a                	mv	a2,s2
    80001fe2:	85a6                	mv	a1,s1
    80001fe4:	00000097          	auipc	ra,0x0
    80001fe8:	f58080e7          	jalr	-168(ra) # 80001f3c <fetchstr>
}
    80001fec:	60e2                	ld	ra,24(sp)
    80001fee:	6442                	ld	s0,16(sp)
    80001ff0:	64a2                	ld	s1,8(sp)
    80001ff2:	6902                	ld	s2,0(sp)
    80001ff4:	6105                	addi	sp,sp,32
    80001ff6:	8082                	ret

0000000080001ff8 <syscall>:
    [SYS_sysinfo] "sysinfo",

};

void syscall(void)
{
    80001ff8:	7179                	addi	sp,sp,-48
    80001ffa:	f406                	sd	ra,40(sp)
    80001ffc:	f022                	sd	s0,32(sp)
    80001ffe:	ec26                	sd	s1,24(sp)
    80002000:	e84a                	sd	s2,16(sp)
    80002002:	e44e                	sd	s3,8(sp)
    80002004:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    80002006:	fffff097          	auipc	ra,0xfffff
    8000200a:	e8c080e7          	jalr	-372(ra) # 80000e92 <myproc>
    8000200e:	84aa                	mv	s1,a0

  num = p->trapframe->a7; //
    80002010:	06053903          	ld	s2,96(a0)
    80002014:	0a893783          	ld	a5,168(s2)
    80002018:	0007899b          	sext.w	s3,a5
  if (num > 0 && num < NELEM(syscalls) && syscalls[num])
    8000201c:	37fd                	addiw	a5,a5,-1
    8000201e:	4759                	li	a4,22
    80002020:	04f76763          	bltu	a4,a5,8000206e <syscall+0x76>
    80002024:	00399713          	slli	a4,s3,0x3
    80002028:	00006797          	auipc	a5,0x6
    8000202c:	48078793          	addi	a5,a5,1152 # 800084a8 <syscalls>
    80002030:	97ba                	add	a5,a5,a4
    80002032:	639c                	ld	a5,0(a5)
    80002034:	cf8d                	beqz	a5,8000206e <syscall+0x76>
  {
    p->trapframe->a0 = syscalls[num](); // run system call and save at a0
    80002036:	9782                	jalr	a5
    80002038:	06a93823          	sd	a0,112(s2)

    if ((1 << num) & p->trace_mask)
    8000203c:	40bc                	lw	a5,64(s1)
    8000203e:	4137d7bb          	sraw	a5,a5,s3
    80002042:	8b85                	andi	a5,a5,1
    80002044:	c7a1                	beqz	a5,8000208c <syscall+0x94>
      printf("%d: syscall %s -> %d\n", p->pid, syscalls_name[num], p->trapframe->a0);
    80002046:	70b8                	ld	a4,96(s1)
    80002048:	098e                	slli	s3,s3,0x3
    8000204a:	00006797          	auipc	a5,0x6
    8000204e:	45e78793          	addi	a5,a5,1118 # 800084a8 <syscalls>
    80002052:	99be                	add	s3,s3,a5
    80002054:	7b34                	ld	a3,112(a4)
    80002056:	0c09b603          	ld	a2,192(s3)
    8000205a:	588c                	lw	a1,48(s1)
    8000205c:	00006517          	auipc	a0,0x6
    80002060:	34c50513          	addi	a0,a0,844 # 800083a8 <states.1711+0x150>
    80002064:	00004097          	auipc	ra,0x4
    80002068:	c4e080e7          	jalr	-946(ra) # 80005cb2 <printf>
    8000206c:	a005                	j	8000208c <syscall+0x94>
  }
  else
  {
    printf("%d %s: unknown sys call %d\n",
    8000206e:	86ce                	mv	a3,s3
    80002070:	16048613          	addi	a2,s1,352
    80002074:	588c                	lw	a1,48(s1)
    80002076:	00006517          	auipc	a0,0x6
    8000207a:	34a50513          	addi	a0,a0,842 # 800083c0 <states.1711+0x168>
    8000207e:	00004097          	auipc	ra,0x4
    80002082:	c34080e7          	jalr	-972(ra) # 80005cb2 <printf>
           p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002086:	70bc                	ld	a5,96(s1)
    80002088:	577d                	li	a4,-1
    8000208a:	fbb8                	sd	a4,112(a5)
  }
    8000208c:	70a2                	ld	ra,40(sp)
    8000208e:	7402                	ld	s0,32(sp)
    80002090:	64e2                	ld	s1,24(sp)
    80002092:	6942                	ld	s2,16(sp)
    80002094:	69a2                	ld	s3,8(sp)
    80002096:	6145                	addi	sp,sp,48
    80002098:	8082                	ret

000000008000209a <sys_exit>:
uint64 getfreememory(void);
uint64 getprocesscount(void);

uint64
sys_exit(void)
{
    8000209a:	1101                	addi	sp,sp,-32
    8000209c:	ec06                	sd	ra,24(sp)
    8000209e:	e822                	sd	s0,16(sp)
    800020a0:	1000                	addi	s0,sp,32
  int n;
  if (argint(0, &n) < 0)
    800020a2:	fec40593          	addi	a1,s0,-20
    800020a6:	4501                	li	a0,0
    800020a8:	00000097          	auipc	ra,0x0
    800020ac:	edc080e7          	jalr	-292(ra) # 80001f84 <argint>
    return -1;
    800020b0:	57fd                	li	a5,-1
  if (argint(0, &n) < 0)
    800020b2:	00054963          	bltz	a0,800020c4 <sys_exit+0x2a>
  exit(n);
    800020b6:	fec42503          	lw	a0,-20(s0)
    800020ba:	fffff097          	auipc	ra,0xfffff
    800020be:	706080e7          	jalr	1798(ra) # 800017c0 <exit>
  return 0; // not reached
    800020c2:	4781                	li	a5,0
}
    800020c4:	853e                	mv	a0,a5
    800020c6:	60e2                	ld	ra,24(sp)
    800020c8:	6442                	ld	s0,16(sp)
    800020ca:	6105                	addi	sp,sp,32
    800020cc:	8082                	ret

00000000800020ce <sys_getpid>:

uint64
sys_getpid(void)
{
    800020ce:	1141                	addi	sp,sp,-16
    800020d0:	e406                	sd	ra,8(sp)
    800020d2:	e022                	sd	s0,0(sp)
    800020d4:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800020d6:	fffff097          	auipc	ra,0xfffff
    800020da:	dbc080e7          	jalr	-580(ra) # 80000e92 <myproc>
}
    800020de:	5908                	lw	a0,48(a0)
    800020e0:	60a2                	ld	ra,8(sp)
    800020e2:	6402                	ld	s0,0(sp)
    800020e4:	0141                	addi	sp,sp,16
    800020e6:	8082                	ret

00000000800020e8 <sys_fork>:

uint64
sys_fork(void)
{
    800020e8:	1141                	addi	sp,sp,-16
    800020ea:	e406                	sd	ra,8(sp)
    800020ec:	e022                	sd	s0,0(sp)
    800020ee:	0800                	addi	s0,sp,16
  return fork();
    800020f0:	fffff097          	auipc	ra,0xfffff
    800020f4:	170080e7          	jalr	368(ra) # 80001260 <fork>
}
    800020f8:	60a2                	ld	ra,8(sp)
    800020fa:	6402                	ld	s0,0(sp)
    800020fc:	0141                	addi	sp,sp,16
    800020fe:	8082                	ret

0000000080002100 <sys_wait>:

uint64
sys_wait(void)
{
    80002100:	1101                	addi	sp,sp,-32
    80002102:	ec06                	sd	ra,24(sp)
    80002104:	e822                	sd	s0,16(sp)
    80002106:	1000                	addi	s0,sp,32
  uint64 p;
  if (argaddr(0, &p) < 0)
    80002108:	fe840593          	addi	a1,s0,-24
    8000210c:	4501                	li	a0,0
    8000210e:	00000097          	auipc	ra,0x0
    80002112:	e98080e7          	jalr	-360(ra) # 80001fa6 <argaddr>
    80002116:	87aa                	mv	a5,a0
    return -1;
    80002118:	557d                	li	a0,-1
  if (argaddr(0, &p) < 0)
    8000211a:	0007c863          	bltz	a5,8000212a <sys_wait+0x2a>
  return wait(p);
    8000211e:	fe843503          	ld	a0,-24(s0)
    80002122:	fffff097          	auipc	ra,0xfffff
    80002126:	4a6080e7          	jalr	1190(ra) # 800015c8 <wait>
}
    8000212a:	60e2                	ld	ra,24(sp)
    8000212c:	6442                	ld	s0,16(sp)
    8000212e:	6105                	addi	sp,sp,32
    80002130:	8082                	ret

0000000080002132 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002132:	7179                	addi	sp,sp,-48
    80002134:	f406                	sd	ra,40(sp)
    80002136:	f022                	sd	s0,32(sp)
    80002138:	ec26                	sd	s1,24(sp)
    8000213a:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if (argint(0, &n) < 0)
    8000213c:	fdc40593          	addi	a1,s0,-36
    80002140:	4501                	li	a0,0
    80002142:	00000097          	auipc	ra,0x0
    80002146:	e42080e7          	jalr	-446(ra) # 80001f84 <argint>
    8000214a:	87aa                	mv	a5,a0
    return -1;
    8000214c:	557d                	li	a0,-1
  if (argint(0, &n) < 0)
    8000214e:	0207c063          	bltz	a5,8000216e <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002152:	fffff097          	auipc	ra,0xfffff
    80002156:	d40080e7          	jalr	-704(ra) # 80000e92 <myproc>
    8000215a:	4924                	lw	s1,80(a0)
  if (growproc(n) < 0)
    8000215c:	fdc42503          	lw	a0,-36(s0)
    80002160:	fffff097          	auipc	ra,0xfffff
    80002164:	08c080e7          	jalr	140(ra) # 800011ec <growproc>
    80002168:	00054863          	bltz	a0,80002178 <sys_sbrk+0x46>
    return -1;
  return addr;
    8000216c:	8526                	mv	a0,s1
}
    8000216e:	70a2                	ld	ra,40(sp)
    80002170:	7402                	ld	s0,32(sp)
    80002172:	64e2                	ld	s1,24(sp)
    80002174:	6145                	addi	sp,sp,48
    80002176:	8082                	ret
    return -1;
    80002178:	557d                	li	a0,-1
    8000217a:	bfd5                	j	8000216e <sys_sbrk+0x3c>

000000008000217c <sys_sleep>:

uint64
sys_sleep(void)
{
    8000217c:	7139                	addi	sp,sp,-64
    8000217e:	fc06                	sd	ra,56(sp)
    80002180:	f822                	sd	s0,48(sp)
    80002182:	f426                	sd	s1,40(sp)
    80002184:	f04a                	sd	s2,32(sp)
    80002186:	ec4e                	sd	s3,24(sp)
    80002188:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
    8000218a:	fcc40593          	addi	a1,s0,-52
    8000218e:	4501                	li	a0,0
    80002190:	00000097          	auipc	ra,0x0
    80002194:	df4080e7          	jalr	-524(ra) # 80001f84 <argint>
    return -1;
    80002198:	57fd                	li	a5,-1
  if (argint(0, &n) < 0)
    8000219a:	06054563          	bltz	a0,80002204 <sys_sleep+0x88>
  acquire(&tickslock);
    8000219e:	0000d517          	auipc	a0,0xd
    800021a2:	4e250513          	addi	a0,a0,1250 # 8000f680 <tickslock>
    800021a6:	00004097          	auipc	ra,0x4
    800021aa:	00c080e7          	jalr	12(ra) # 800061b2 <acquire>
  ticks0 = ticks;
    800021ae:	00007917          	auipc	s2,0x7
    800021b2:	e6a92903          	lw	s2,-406(s2) # 80009018 <ticks>
  while (ticks - ticks0 < n)
    800021b6:	fcc42783          	lw	a5,-52(s0)
    800021ba:	cf85                	beqz	a5,800021f2 <sys_sleep+0x76>
    if (myproc()->killed)
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800021bc:	0000d997          	auipc	s3,0xd
    800021c0:	4c498993          	addi	s3,s3,1220 # 8000f680 <tickslock>
    800021c4:	00007497          	auipc	s1,0x7
    800021c8:	e5448493          	addi	s1,s1,-428 # 80009018 <ticks>
    if (myproc()->killed)
    800021cc:	fffff097          	auipc	ra,0xfffff
    800021d0:	cc6080e7          	jalr	-826(ra) # 80000e92 <myproc>
    800021d4:	551c                	lw	a5,40(a0)
    800021d6:	ef9d                	bnez	a5,80002214 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800021d8:	85ce                	mv	a1,s3
    800021da:	8526                	mv	a0,s1
    800021dc:	fffff097          	auipc	ra,0xfffff
    800021e0:	388080e7          	jalr	904(ra) # 80001564 <sleep>
  while (ticks - ticks0 < n)
    800021e4:	409c                	lw	a5,0(s1)
    800021e6:	412787bb          	subw	a5,a5,s2
    800021ea:	fcc42703          	lw	a4,-52(s0)
    800021ee:	fce7efe3          	bltu	a5,a4,800021cc <sys_sleep+0x50>
  }
  release(&tickslock);
    800021f2:	0000d517          	auipc	a0,0xd
    800021f6:	48e50513          	addi	a0,a0,1166 # 8000f680 <tickslock>
    800021fa:	00004097          	auipc	ra,0x4
    800021fe:	06c080e7          	jalr	108(ra) # 80006266 <release>
  return 0;
    80002202:	4781                	li	a5,0
}
    80002204:	853e                	mv	a0,a5
    80002206:	70e2                	ld	ra,56(sp)
    80002208:	7442                	ld	s0,48(sp)
    8000220a:	74a2                	ld	s1,40(sp)
    8000220c:	7902                	ld	s2,32(sp)
    8000220e:	69e2                	ld	s3,24(sp)
    80002210:	6121                	addi	sp,sp,64
    80002212:	8082                	ret
      release(&tickslock);
    80002214:	0000d517          	auipc	a0,0xd
    80002218:	46c50513          	addi	a0,a0,1132 # 8000f680 <tickslock>
    8000221c:	00004097          	auipc	ra,0x4
    80002220:	04a080e7          	jalr	74(ra) # 80006266 <release>
      return -1;
    80002224:	57fd                	li	a5,-1
    80002226:	bff9                	j	80002204 <sys_sleep+0x88>

0000000080002228 <sys_kill>:

uint64
sys_kill(void)
{
    80002228:	1101                	addi	sp,sp,-32
    8000222a:	ec06                	sd	ra,24(sp)
    8000222c:	e822                	sd	s0,16(sp)
    8000222e:	1000                	addi	s0,sp,32
  int pid;

  if (argint(0, &pid) < 0)
    80002230:	fec40593          	addi	a1,s0,-20
    80002234:	4501                	li	a0,0
    80002236:	00000097          	auipc	ra,0x0
    8000223a:	d4e080e7          	jalr	-690(ra) # 80001f84 <argint>
    8000223e:	87aa                	mv	a5,a0
    return -1;
    80002240:	557d                	li	a0,-1
  if (argint(0, &pid) < 0)
    80002242:	0007c863          	bltz	a5,80002252 <sys_kill+0x2a>
  return kill(pid);
    80002246:	fec42503          	lw	a0,-20(s0)
    8000224a:	fffff097          	auipc	ra,0xfffff
    8000224e:	64c080e7          	jalr	1612(ra) # 80001896 <kill>
}
    80002252:	60e2                	ld	ra,24(sp)
    80002254:	6442                	ld	s0,16(sp)
    80002256:	6105                	addi	sp,sp,32
    80002258:	8082                	ret

000000008000225a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000225a:	1101                	addi	sp,sp,-32
    8000225c:	ec06                	sd	ra,24(sp)
    8000225e:	e822                	sd	s0,16(sp)
    80002260:	e426                	sd	s1,8(sp)
    80002262:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002264:	0000d517          	auipc	a0,0xd
    80002268:	41c50513          	addi	a0,a0,1052 # 8000f680 <tickslock>
    8000226c:	00004097          	auipc	ra,0x4
    80002270:	f46080e7          	jalr	-186(ra) # 800061b2 <acquire>
  xticks = ticks;
    80002274:	00007497          	auipc	s1,0x7
    80002278:	da44a483          	lw	s1,-604(s1) # 80009018 <ticks>
  release(&tickslock);
    8000227c:	0000d517          	auipc	a0,0xd
    80002280:	40450513          	addi	a0,a0,1028 # 8000f680 <tickslock>
    80002284:	00004097          	auipc	ra,0x4
    80002288:	fe2080e7          	jalr	-30(ra) # 80006266 <release>
  return xticks;
}
    8000228c:	02049513          	slli	a0,s1,0x20
    80002290:	9101                	srli	a0,a0,0x20
    80002292:	60e2                	ld	ra,24(sp)
    80002294:	6442                	ld	s0,16(sp)
    80002296:	64a2                	ld	s1,8(sp)
    80002298:	6105                	addi	sp,sp,32
    8000229a:	8082                	ret

000000008000229c <sys_trace>:

uint64
sys_trace(void)
{
    8000229c:	1141                	addi	sp,sp,-16
    8000229e:	e406                	sd	ra,8(sp)
    800022a0:	e022                	sd	s0,0(sp)
    800022a2:	0800                	addi	s0,sp,16
  argint(0, &(myproc()->trace_mask));
    800022a4:	fffff097          	auipc	ra,0xfffff
    800022a8:	bee080e7          	jalr	-1042(ra) # 80000e92 <myproc>
    800022ac:	04050593          	addi	a1,a0,64
    800022b0:	4501                	li	a0,0
    800022b2:	00000097          	auipc	ra,0x0
    800022b6:	cd2080e7          	jalr	-814(ra) # 80001f84 <argint>
  return 0;
}
    800022ba:	4501                	li	a0,0
    800022bc:	60a2                	ld	ra,8(sp)
    800022be:	6402                	ld	s0,0(sp)
    800022c0:	0141                	addi	sp,sp,16
    800022c2:	8082                	ret

00000000800022c4 <sys_sysinfo>:

uint64
sys_sysinfo(void)
{
    800022c4:	7179                	addi	sp,sp,-48
    800022c6:	f406                	sd	ra,40(sp)
    800022c8:	f022                	sd	s0,32(sp)
    800022ca:	1800                	addi	s0,sp,48
  uint64 addr;
  struct sysinfo info;
  if (argaddr(0, &addr) < 0)
    800022cc:	fe840593          	addi	a1,s0,-24
    800022d0:	4501                	li	a0,0
    800022d2:	00000097          	auipc	ra,0x0
    800022d6:	cd4080e7          	jalr	-812(ra) # 80001fa6 <argaddr>
    800022da:	87aa                	mv	a5,a0
    return -1;
    800022dc:	557d                	li	a0,-1
  if (argaddr(0, &addr) < 0)
    800022de:	0207cd63          	bltz	a5,80002318 <sys_sysinfo+0x54>

  info.freemem = (uint64)getfreememory();
    800022e2:	ffffe097          	auipc	ra,0xffffe
    800022e6:	e96080e7          	jalr	-362(ra) # 80000178 <getfreememory>
    800022ea:	fca43c23          	sd	a0,-40(s0)
  info.nproc = (uint64)getprocesscount();
    800022ee:	fffff097          	auipc	ra,0xfffff
    800022f2:	774080e7          	jalr	1908(ra) # 80001a62 <getprocesscount>
    800022f6:	fea43023          	sd	a0,-32(s0)

  if (copyout(myproc()->pagetable, addr, (char *)&(info), sizeof(info)) < 0)
    800022fa:	fffff097          	auipc	ra,0xfffff
    800022fe:	b98080e7          	jalr	-1128(ra) # 80000e92 <myproc>
    80002302:	46c1                	li	a3,16
    80002304:	fd840613          	addi	a2,s0,-40
    80002308:	fe843583          	ld	a1,-24(s0)
    8000230c:	6d28                	ld	a0,88(a0)
    8000230e:	fffff097          	auipc	ra,0xfffff
    80002312:	846080e7          	jalr	-1978(ra) # 80000b54 <copyout>
    80002316:	957d                	srai	a0,a0,0x3f
  {
    return -1;
  }
  return 0;
}
    80002318:	70a2                	ld	ra,40(sp)
    8000231a:	7402                	ld	s0,32(sp)
    8000231c:	6145                	addi	sp,sp,48
    8000231e:	8082                	ret

0000000080002320 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002320:	7179                	addi	sp,sp,-48
    80002322:	f406                	sd	ra,40(sp)
    80002324:	f022                	sd	s0,32(sp)
    80002326:	ec26                	sd	s1,24(sp)
    80002328:	e84a                	sd	s2,16(sp)
    8000232a:	e44e                	sd	s3,8(sp)
    8000232c:	e052                	sd	s4,0(sp)
    8000232e:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002330:	00006597          	auipc	a1,0x6
    80002334:	2f858593          	addi	a1,a1,760 # 80008628 <syscalls_name+0xc0>
    80002338:	0000d517          	auipc	a0,0xd
    8000233c:	36050513          	addi	a0,a0,864 # 8000f698 <bcache>
    80002340:	00004097          	auipc	ra,0x4
    80002344:	de2080e7          	jalr	-542(ra) # 80006122 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002348:	00015797          	auipc	a5,0x15
    8000234c:	35078793          	addi	a5,a5,848 # 80017698 <bcache+0x8000>
    80002350:	00015717          	auipc	a4,0x15
    80002354:	5b070713          	addi	a4,a4,1456 # 80017900 <bcache+0x8268>
    80002358:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000235c:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002360:	0000d497          	auipc	s1,0xd
    80002364:	35048493          	addi	s1,s1,848 # 8000f6b0 <bcache+0x18>
    b->next = bcache.head.next;
    80002368:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000236a:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000236c:	00006a17          	auipc	s4,0x6
    80002370:	2c4a0a13          	addi	s4,s4,708 # 80008630 <syscalls_name+0xc8>
    b->next = bcache.head.next;
    80002374:	2b893783          	ld	a5,696(s2)
    80002378:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000237a:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000237e:	85d2                	mv	a1,s4
    80002380:	01048513          	addi	a0,s1,16
    80002384:	00001097          	auipc	ra,0x1
    80002388:	4bc080e7          	jalr	1212(ra) # 80003840 <initsleeplock>
    bcache.head.next->prev = b;
    8000238c:	2b893783          	ld	a5,696(s2)
    80002390:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002392:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002396:	45848493          	addi	s1,s1,1112
    8000239a:	fd349de3          	bne	s1,s3,80002374 <binit+0x54>
  }
}
    8000239e:	70a2                	ld	ra,40(sp)
    800023a0:	7402                	ld	s0,32(sp)
    800023a2:	64e2                	ld	s1,24(sp)
    800023a4:	6942                	ld	s2,16(sp)
    800023a6:	69a2                	ld	s3,8(sp)
    800023a8:	6a02                	ld	s4,0(sp)
    800023aa:	6145                	addi	sp,sp,48
    800023ac:	8082                	ret

00000000800023ae <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800023ae:	7179                	addi	sp,sp,-48
    800023b0:	f406                	sd	ra,40(sp)
    800023b2:	f022                	sd	s0,32(sp)
    800023b4:	ec26                	sd	s1,24(sp)
    800023b6:	e84a                	sd	s2,16(sp)
    800023b8:	e44e                	sd	s3,8(sp)
    800023ba:	1800                	addi	s0,sp,48
    800023bc:	89aa                	mv	s3,a0
    800023be:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    800023c0:	0000d517          	auipc	a0,0xd
    800023c4:	2d850513          	addi	a0,a0,728 # 8000f698 <bcache>
    800023c8:	00004097          	auipc	ra,0x4
    800023cc:	dea080e7          	jalr	-534(ra) # 800061b2 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800023d0:	00015497          	auipc	s1,0x15
    800023d4:	5804b483          	ld	s1,1408(s1) # 80017950 <bcache+0x82b8>
    800023d8:	00015797          	auipc	a5,0x15
    800023dc:	52878793          	addi	a5,a5,1320 # 80017900 <bcache+0x8268>
    800023e0:	02f48f63          	beq	s1,a5,8000241e <bread+0x70>
    800023e4:	873e                	mv	a4,a5
    800023e6:	a021                	j	800023ee <bread+0x40>
    800023e8:	68a4                	ld	s1,80(s1)
    800023ea:	02e48a63          	beq	s1,a4,8000241e <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800023ee:	449c                	lw	a5,8(s1)
    800023f0:	ff379ce3          	bne	a5,s3,800023e8 <bread+0x3a>
    800023f4:	44dc                	lw	a5,12(s1)
    800023f6:	ff2799e3          	bne	a5,s2,800023e8 <bread+0x3a>
      b->refcnt++;
    800023fa:	40bc                	lw	a5,64(s1)
    800023fc:	2785                	addiw	a5,a5,1
    800023fe:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002400:	0000d517          	auipc	a0,0xd
    80002404:	29850513          	addi	a0,a0,664 # 8000f698 <bcache>
    80002408:	00004097          	auipc	ra,0x4
    8000240c:	e5e080e7          	jalr	-418(ra) # 80006266 <release>
      acquiresleep(&b->lock);
    80002410:	01048513          	addi	a0,s1,16
    80002414:	00001097          	auipc	ra,0x1
    80002418:	466080e7          	jalr	1126(ra) # 8000387a <acquiresleep>
      return b;
    8000241c:	a8b9                	j	8000247a <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000241e:	00015497          	auipc	s1,0x15
    80002422:	52a4b483          	ld	s1,1322(s1) # 80017948 <bcache+0x82b0>
    80002426:	00015797          	auipc	a5,0x15
    8000242a:	4da78793          	addi	a5,a5,1242 # 80017900 <bcache+0x8268>
    8000242e:	00f48863          	beq	s1,a5,8000243e <bread+0x90>
    80002432:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002434:	40bc                	lw	a5,64(s1)
    80002436:	cf81                	beqz	a5,8000244e <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002438:	64a4                	ld	s1,72(s1)
    8000243a:	fee49de3          	bne	s1,a4,80002434 <bread+0x86>
  panic("bget: no buffers");
    8000243e:	00006517          	auipc	a0,0x6
    80002442:	1fa50513          	addi	a0,a0,506 # 80008638 <syscalls_name+0xd0>
    80002446:	00004097          	auipc	ra,0x4
    8000244a:	822080e7          	jalr	-2014(ra) # 80005c68 <panic>
      b->dev = dev;
    8000244e:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002452:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002456:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000245a:	4785                	li	a5,1
    8000245c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000245e:	0000d517          	auipc	a0,0xd
    80002462:	23a50513          	addi	a0,a0,570 # 8000f698 <bcache>
    80002466:	00004097          	auipc	ra,0x4
    8000246a:	e00080e7          	jalr	-512(ra) # 80006266 <release>
      acquiresleep(&b->lock);
    8000246e:	01048513          	addi	a0,s1,16
    80002472:	00001097          	auipc	ra,0x1
    80002476:	408080e7          	jalr	1032(ra) # 8000387a <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000247a:	409c                	lw	a5,0(s1)
    8000247c:	cb89                	beqz	a5,8000248e <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000247e:	8526                	mv	a0,s1
    80002480:	70a2                	ld	ra,40(sp)
    80002482:	7402                	ld	s0,32(sp)
    80002484:	64e2                	ld	s1,24(sp)
    80002486:	6942                	ld	s2,16(sp)
    80002488:	69a2                	ld	s3,8(sp)
    8000248a:	6145                	addi	sp,sp,48
    8000248c:	8082                	ret
    virtio_disk_rw(b, 0);
    8000248e:	4581                	li	a1,0
    80002490:	8526                	mv	a0,s1
    80002492:	00003097          	auipc	ra,0x3
    80002496:	f14080e7          	jalr	-236(ra) # 800053a6 <virtio_disk_rw>
    b->valid = 1;
    8000249a:	4785                	li	a5,1
    8000249c:	c09c                	sw	a5,0(s1)
  return b;
    8000249e:	b7c5                	j	8000247e <bread+0xd0>

00000000800024a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800024a0:	1101                	addi	sp,sp,-32
    800024a2:	ec06                	sd	ra,24(sp)
    800024a4:	e822                	sd	s0,16(sp)
    800024a6:	e426                	sd	s1,8(sp)
    800024a8:	1000                	addi	s0,sp,32
    800024aa:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024ac:	0541                	addi	a0,a0,16
    800024ae:	00001097          	auipc	ra,0x1
    800024b2:	466080e7          	jalr	1126(ra) # 80003914 <holdingsleep>
    800024b6:	cd01                	beqz	a0,800024ce <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800024b8:	4585                	li	a1,1
    800024ba:	8526                	mv	a0,s1
    800024bc:	00003097          	auipc	ra,0x3
    800024c0:	eea080e7          	jalr	-278(ra) # 800053a6 <virtio_disk_rw>
}
    800024c4:	60e2                	ld	ra,24(sp)
    800024c6:	6442                	ld	s0,16(sp)
    800024c8:	64a2                	ld	s1,8(sp)
    800024ca:	6105                	addi	sp,sp,32
    800024cc:	8082                	ret
    panic("bwrite");
    800024ce:	00006517          	auipc	a0,0x6
    800024d2:	18250513          	addi	a0,a0,386 # 80008650 <syscalls_name+0xe8>
    800024d6:	00003097          	auipc	ra,0x3
    800024da:	792080e7          	jalr	1938(ra) # 80005c68 <panic>

00000000800024de <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800024de:	1101                	addi	sp,sp,-32
    800024e0:	ec06                	sd	ra,24(sp)
    800024e2:	e822                	sd	s0,16(sp)
    800024e4:	e426                	sd	s1,8(sp)
    800024e6:	e04a                	sd	s2,0(sp)
    800024e8:	1000                	addi	s0,sp,32
    800024ea:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024ec:	01050913          	addi	s2,a0,16
    800024f0:	854a                	mv	a0,s2
    800024f2:	00001097          	auipc	ra,0x1
    800024f6:	422080e7          	jalr	1058(ra) # 80003914 <holdingsleep>
    800024fa:	c92d                	beqz	a0,8000256c <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800024fc:	854a                	mv	a0,s2
    800024fe:	00001097          	auipc	ra,0x1
    80002502:	3d2080e7          	jalr	978(ra) # 800038d0 <releasesleep>

  acquire(&bcache.lock);
    80002506:	0000d517          	auipc	a0,0xd
    8000250a:	19250513          	addi	a0,a0,402 # 8000f698 <bcache>
    8000250e:	00004097          	auipc	ra,0x4
    80002512:	ca4080e7          	jalr	-860(ra) # 800061b2 <acquire>
  b->refcnt--;
    80002516:	40bc                	lw	a5,64(s1)
    80002518:	37fd                	addiw	a5,a5,-1
    8000251a:	0007871b          	sext.w	a4,a5
    8000251e:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002520:	eb05                	bnez	a4,80002550 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002522:	68bc                	ld	a5,80(s1)
    80002524:	64b8                	ld	a4,72(s1)
    80002526:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002528:	64bc                	ld	a5,72(s1)
    8000252a:	68b8                	ld	a4,80(s1)
    8000252c:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000252e:	00015797          	auipc	a5,0x15
    80002532:	16a78793          	addi	a5,a5,362 # 80017698 <bcache+0x8000>
    80002536:	2b87b703          	ld	a4,696(a5)
    8000253a:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000253c:	00015717          	auipc	a4,0x15
    80002540:	3c470713          	addi	a4,a4,964 # 80017900 <bcache+0x8268>
    80002544:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002546:	2b87b703          	ld	a4,696(a5)
    8000254a:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000254c:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002550:	0000d517          	auipc	a0,0xd
    80002554:	14850513          	addi	a0,a0,328 # 8000f698 <bcache>
    80002558:	00004097          	auipc	ra,0x4
    8000255c:	d0e080e7          	jalr	-754(ra) # 80006266 <release>
}
    80002560:	60e2                	ld	ra,24(sp)
    80002562:	6442                	ld	s0,16(sp)
    80002564:	64a2                	ld	s1,8(sp)
    80002566:	6902                	ld	s2,0(sp)
    80002568:	6105                	addi	sp,sp,32
    8000256a:	8082                	ret
    panic("brelse");
    8000256c:	00006517          	auipc	a0,0x6
    80002570:	0ec50513          	addi	a0,a0,236 # 80008658 <syscalls_name+0xf0>
    80002574:	00003097          	auipc	ra,0x3
    80002578:	6f4080e7          	jalr	1780(ra) # 80005c68 <panic>

000000008000257c <bpin>:

void
bpin(struct buf *b) {
    8000257c:	1101                	addi	sp,sp,-32
    8000257e:	ec06                	sd	ra,24(sp)
    80002580:	e822                	sd	s0,16(sp)
    80002582:	e426                	sd	s1,8(sp)
    80002584:	1000                	addi	s0,sp,32
    80002586:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002588:	0000d517          	auipc	a0,0xd
    8000258c:	11050513          	addi	a0,a0,272 # 8000f698 <bcache>
    80002590:	00004097          	auipc	ra,0x4
    80002594:	c22080e7          	jalr	-990(ra) # 800061b2 <acquire>
  b->refcnt++;
    80002598:	40bc                	lw	a5,64(s1)
    8000259a:	2785                	addiw	a5,a5,1
    8000259c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000259e:	0000d517          	auipc	a0,0xd
    800025a2:	0fa50513          	addi	a0,a0,250 # 8000f698 <bcache>
    800025a6:	00004097          	auipc	ra,0x4
    800025aa:	cc0080e7          	jalr	-832(ra) # 80006266 <release>
}
    800025ae:	60e2                	ld	ra,24(sp)
    800025b0:	6442                	ld	s0,16(sp)
    800025b2:	64a2                	ld	s1,8(sp)
    800025b4:	6105                	addi	sp,sp,32
    800025b6:	8082                	ret

00000000800025b8 <bunpin>:

void
bunpin(struct buf *b) {
    800025b8:	1101                	addi	sp,sp,-32
    800025ba:	ec06                	sd	ra,24(sp)
    800025bc:	e822                	sd	s0,16(sp)
    800025be:	e426                	sd	s1,8(sp)
    800025c0:	1000                	addi	s0,sp,32
    800025c2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025c4:	0000d517          	auipc	a0,0xd
    800025c8:	0d450513          	addi	a0,a0,212 # 8000f698 <bcache>
    800025cc:	00004097          	auipc	ra,0x4
    800025d0:	be6080e7          	jalr	-1050(ra) # 800061b2 <acquire>
  b->refcnt--;
    800025d4:	40bc                	lw	a5,64(s1)
    800025d6:	37fd                	addiw	a5,a5,-1
    800025d8:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025da:	0000d517          	auipc	a0,0xd
    800025de:	0be50513          	addi	a0,a0,190 # 8000f698 <bcache>
    800025e2:	00004097          	auipc	ra,0x4
    800025e6:	c84080e7          	jalr	-892(ra) # 80006266 <release>
}
    800025ea:	60e2                	ld	ra,24(sp)
    800025ec:	6442                	ld	s0,16(sp)
    800025ee:	64a2                	ld	s1,8(sp)
    800025f0:	6105                	addi	sp,sp,32
    800025f2:	8082                	ret

00000000800025f4 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800025f4:	1101                	addi	sp,sp,-32
    800025f6:	ec06                	sd	ra,24(sp)
    800025f8:	e822                	sd	s0,16(sp)
    800025fa:	e426                	sd	s1,8(sp)
    800025fc:	e04a                	sd	s2,0(sp)
    800025fe:	1000                	addi	s0,sp,32
    80002600:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002602:	00d5d59b          	srliw	a1,a1,0xd
    80002606:	00015797          	auipc	a5,0x15
    8000260a:	76e7a783          	lw	a5,1902(a5) # 80017d74 <sb+0x1c>
    8000260e:	9dbd                	addw	a1,a1,a5
    80002610:	00000097          	auipc	ra,0x0
    80002614:	d9e080e7          	jalr	-610(ra) # 800023ae <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002618:	0074f713          	andi	a4,s1,7
    8000261c:	4785                	li	a5,1
    8000261e:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002622:	14ce                	slli	s1,s1,0x33
    80002624:	90d9                	srli	s1,s1,0x36
    80002626:	00950733          	add	a4,a0,s1
    8000262a:	05874703          	lbu	a4,88(a4)
    8000262e:	00e7f6b3          	and	a3,a5,a4
    80002632:	c69d                	beqz	a3,80002660 <bfree+0x6c>
    80002634:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002636:	94aa                	add	s1,s1,a0
    80002638:	fff7c793          	not	a5,a5
    8000263c:	8ff9                	and	a5,a5,a4
    8000263e:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002642:	00001097          	auipc	ra,0x1
    80002646:	118080e7          	jalr	280(ra) # 8000375a <log_write>
  brelse(bp);
    8000264a:	854a                	mv	a0,s2
    8000264c:	00000097          	auipc	ra,0x0
    80002650:	e92080e7          	jalr	-366(ra) # 800024de <brelse>
}
    80002654:	60e2                	ld	ra,24(sp)
    80002656:	6442                	ld	s0,16(sp)
    80002658:	64a2                	ld	s1,8(sp)
    8000265a:	6902                	ld	s2,0(sp)
    8000265c:	6105                	addi	sp,sp,32
    8000265e:	8082                	ret
    panic("freeing free block");
    80002660:	00006517          	auipc	a0,0x6
    80002664:	00050513          	mv	a0,a0
    80002668:	00003097          	auipc	ra,0x3
    8000266c:	600080e7          	jalr	1536(ra) # 80005c68 <panic>

0000000080002670 <balloc>:
{
    80002670:	711d                	addi	sp,sp,-96
    80002672:	ec86                	sd	ra,88(sp)
    80002674:	e8a2                	sd	s0,80(sp)
    80002676:	e4a6                	sd	s1,72(sp)
    80002678:	e0ca                	sd	s2,64(sp)
    8000267a:	fc4e                	sd	s3,56(sp)
    8000267c:	f852                	sd	s4,48(sp)
    8000267e:	f456                	sd	s5,40(sp)
    80002680:	f05a                	sd	s6,32(sp)
    80002682:	ec5e                	sd	s7,24(sp)
    80002684:	e862                	sd	s8,16(sp)
    80002686:	e466                	sd	s9,8(sp)
    80002688:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000268a:	00015797          	auipc	a5,0x15
    8000268e:	6d27a783          	lw	a5,1746(a5) # 80017d5c <sb+0x4>
    80002692:	cbd1                	beqz	a5,80002726 <balloc+0xb6>
    80002694:	8baa                	mv	s7,a0
    80002696:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002698:	00015b17          	auipc	s6,0x15
    8000269c:	6c0b0b13          	addi	s6,s6,1728 # 80017d58 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026a0:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800026a2:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026a4:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800026a6:	6c89                	lui	s9,0x2
    800026a8:	a831                	j	800026c4 <balloc+0x54>
    brelse(bp);
    800026aa:	854a                	mv	a0,s2
    800026ac:	00000097          	auipc	ra,0x0
    800026b0:	e32080e7          	jalr	-462(ra) # 800024de <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800026b4:	015c87bb          	addw	a5,s9,s5
    800026b8:	00078a9b          	sext.w	s5,a5
    800026bc:	004b2703          	lw	a4,4(s6)
    800026c0:	06eaf363          	bgeu	s5,a4,80002726 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800026c4:	41fad79b          	sraiw	a5,s5,0x1f
    800026c8:	0137d79b          	srliw	a5,a5,0x13
    800026cc:	015787bb          	addw	a5,a5,s5
    800026d0:	40d7d79b          	sraiw	a5,a5,0xd
    800026d4:	01cb2583          	lw	a1,28(s6)
    800026d8:	9dbd                	addw	a1,a1,a5
    800026da:	855e                	mv	a0,s7
    800026dc:	00000097          	auipc	ra,0x0
    800026e0:	cd2080e7          	jalr	-814(ra) # 800023ae <bread>
    800026e4:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026e6:	004b2503          	lw	a0,4(s6)
    800026ea:	000a849b          	sext.w	s1,s5
    800026ee:	8662                	mv	a2,s8
    800026f0:	faa4fde3          	bgeu	s1,a0,800026aa <balloc+0x3a>
      m = 1 << (bi % 8);
    800026f4:	41f6579b          	sraiw	a5,a2,0x1f
    800026f8:	01d7d69b          	srliw	a3,a5,0x1d
    800026fc:	00c6873b          	addw	a4,a3,a2
    80002700:	00777793          	andi	a5,a4,7
    80002704:	9f95                	subw	a5,a5,a3
    80002706:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000270a:	4037571b          	sraiw	a4,a4,0x3
    8000270e:	00e906b3          	add	a3,s2,a4
    80002712:	0586c683          	lbu	a3,88(a3)
    80002716:	00d7f5b3          	and	a1,a5,a3
    8000271a:	cd91                	beqz	a1,80002736 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000271c:	2605                	addiw	a2,a2,1
    8000271e:	2485                	addiw	s1,s1,1
    80002720:	fd4618e3          	bne	a2,s4,800026f0 <balloc+0x80>
    80002724:	b759                	j	800026aa <balloc+0x3a>
  panic("balloc: out of blocks");
    80002726:	00006517          	auipc	a0,0x6
    8000272a:	f5250513          	addi	a0,a0,-174 # 80008678 <syscalls_name+0x110>
    8000272e:	00003097          	auipc	ra,0x3
    80002732:	53a080e7          	jalr	1338(ra) # 80005c68 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002736:	974a                	add	a4,a4,s2
    80002738:	8fd5                	or	a5,a5,a3
    8000273a:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    8000273e:	854a                	mv	a0,s2
    80002740:	00001097          	auipc	ra,0x1
    80002744:	01a080e7          	jalr	26(ra) # 8000375a <log_write>
        brelse(bp);
    80002748:	854a                	mv	a0,s2
    8000274a:	00000097          	auipc	ra,0x0
    8000274e:	d94080e7          	jalr	-620(ra) # 800024de <brelse>
  bp = bread(dev, bno);
    80002752:	85a6                	mv	a1,s1
    80002754:	855e                	mv	a0,s7
    80002756:	00000097          	auipc	ra,0x0
    8000275a:	c58080e7          	jalr	-936(ra) # 800023ae <bread>
    8000275e:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002760:	40000613          	li	a2,1024
    80002764:	4581                	li	a1,0
    80002766:	05850513          	addi	a0,a0,88
    8000276a:	ffffe097          	auipc	ra,0xffffe
    8000276e:	a58080e7          	jalr	-1448(ra) # 800001c2 <memset>
  log_write(bp);
    80002772:	854a                	mv	a0,s2
    80002774:	00001097          	auipc	ra,0x1
    80002778:	fe6080e7          	jalr	-26(ra) # 8000375a <log_write>
  brelse(bp);
    8000277c:	854a                	mv	a0,s2
    8000277e:	00000097          	auipc	ra,0x0
    80002782:	d60080e7          	jalr	-672(ra) # 800024de <brelse>
}
    80002786:	8526                	mv	a0,s1
    80002788:	60e6                	ld	ra,88(sp)
    8000278a:	6446                	ld	s0,80(sp)
    8000278c:	64a6                	ld	s1,72(sp)
    8000278e:	6906                	ld	s2,64(sp)
    80002790:	79e2                	ld	s3,56(sp)
    80002792:	7a42                	ld	s4,48(sp)
    80002794:	7aa2                	ld	s5,40(sp)
    80002796:	7b02                	ld	s6,32(sp)
    80002798:	6be2                	ld	s7,24(sp)
    8000279a:	6c42                	ld	s8,16(sp)
    8000279c:	6ca2                	ld	s9,8(sp)
    8000279e:	6125                	addi	sp,sp,96
    800027a0:	8082                	ret

00000000800027a2 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800027a2:	7179                	addi	sp,sp,-48
    800027a4:	f406                	sd	ra,40(sp)
    800027a6:	f022                	sd	s0,32(sp)
    800027a8:	ec26                	sd	s1,24(sp)
    800027aa:	e84a                	sd	s2,16(sp)
    800027ac:	e44e                	sd	s3,8(sp)
    800027ae:	e052                	sd	s4,0(sp)
    800027b0:	1800                	addi	s0,sp,48
    800027b2:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800027b4:	47ad                	li	a5,11
    800027b6:	04b7fe63          	bgeu	a5,a1,80002812 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800027ba:	ff45849b          	addiw	s1,a1,-12
    800027be:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800027c2:	0ff00793          	li	a5,255
    800027c6:	0ae7e363          	bltu	a5,a4,8000286c <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800027ca:	08052583          	lw	a1,128(a0)
    800027ce:	c5ad                	beqz	a1,80002838 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800027d0:	00092503          	lw	a0,0(s2)
    800027d4:	00000097          	auipc	ra,0x0
    800027d8:	bda080e7          	jalr	-1062(ra) # 800023ae <bread>
    800027dc:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800027de:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800027e2:	02049593          	slli	a1,s1,0x20
    800027e6:	9181                	srli	a1,a1,0x20
    800027e8:	058a                	slli	a1,a1,0x2
    800027ea:	00b784b3          	add	s1,a5,a1
    800027ee:	0004a983          	lw	s3,0(s1)
    800027f2:	04098d63          	beqz	s3,8000284c <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800027f6:	8552                	mv	a0,s4
    800027f8:	00000097          	auipc	ra,0x0
    800027fc:	ce6080e7          	jalr	-794(ra) # 800024de <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002800:	854e                	mv	a0,s3
    80002802:	70a2                	ld	ra,40(sp)
    80002804:	7402                	ld	s0,32(sp)
    80002806:	64e2                	ld	s1,24(sp)
    80002808:	6942                	ld	s2,16(sp)
    8000280a:	69a2                	ld	s3,8(sp)
    8000280c:	6a02                	ld	s4,0(sp)
    8000280e:	6145                	addi	sp,sp,48
    80002810:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002812:	02059493          	slli	s1,a1,0x20
    80002816:	9081                	srli	s1,s1,0x20
    80002818:	048a                	slli	s1,s1,0x2
    8000281a:	94aa                	add	s1,s1,a0
    8000281c:	0504a983          	lw	s3,80(s1)
    80002820:	fe0990e3          	bnez	s3,80002800 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002824:	4108                	lw	a0,0(a0)
    80002826:	00000097          	auipc	ra,0x0
    8000282a:	e4a080e7          	jalr	-438(ra) # 80002670 <balloc>
    8000282e:	0005099b          	sext.w	s3,a0
    80002832:	0534a823          	sw	s3,80(s1)
    80002836:	b7e9                	j	80002800 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002838:	4108                	lw	a0,0(a0)
    8000283a:	00000097          	auipc	ra,0x0
    8000283e:	e36080e7          	jalr	-458(ra) # 80002670 <balloc>
    80002842:	0005059b          	sext.w	a1,a0
    80002846:	08b92023          	sw	a1,128(s2)
    8000284a:	b759                	j	800027d0 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    8000284c:	00092503          	lw	a0,0(s2)
    80002850:	00000097          	auipc	ra,0x0
    80002854:	e20080e7          	jalr	-480(ra) # 80002670 <balloc>
    80002858:	0005099b          	sext.w	s3,a0
    8000285c:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002860:	8552                	mv	a0,s4
    80002862:	00001097          	auipc	ra,0x1
    80002866:	ef8080e7          	jalr	-264(ra) # 8000375a <log_write>
    8000286a:	b771                	j	800027f6 <bmap+0x54>
  panic("bmap: out of range");
    8000286c:	00006517          	auipc	a0,0x6
    80002870:	e2450513          	addi	a0,a0,-476 # 80008690 <syscalls_name+0x128>
    80002874:	00003097          	auipc	ra,0x3
    80002878:	3f4080e7          	jalr	1012(ra) # 80005c68 <panic>

000000008000287c <iget>:
{
    8000287c:	7179                	addi	sp,sp,-48
    8000287e:	f406                	sd	ra,40(sp)
    80002880:	f022                	sd	s0,32(sp)
    80002882:	ec26                	sd	s1,24(sp)
    80002884:	e84a                	sd	s2,16(sp)
    80002886:	e44e                	sd	s3,8(sp)
    80002888:	e052                	sd	s4,0(sp)
    8000288a:	1800                	addi	s0,sp,48
    8000288c:	89aa                	mv	s3,a0
    8000288e:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002890:	00015517          	auipc	a0,0x15
    80002894:	4e850513          	addi	a0,a0,1256 # 80017d78 <itable>
    80002898:	00004097          	auipc	ra,0x4
    8000289c:	91a080e7          	jalr	-1766(ra) # 800061b2 <acquire>
  empty = 0;
    800028a0:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028a2:	00015497          	auipc	s1,0x15
    800028a6:	4ee48493          	addi	s1,s1,1262 # 80017d90 <itable+0x18>
    800028aa:	00017697          	auipc	a3,0x17
    800028ae:	f7668693          	addi	a3,a3,-138 # 80019820 <log>
    800028b2:	a039                	j	800028c0 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028b4:	02090b63          	beqz	s2,800028ea <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028b8:	08848493          	addi	s1,s1,136
    800028bc:	02d48a63          	beq	s1,a3,800028f0 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800028c0:	449c                	lw	a5,8(s1)
    800028c2:	fef059e3          	blez	a5,800028b4 <iget+0x38>
    800028c6:	4098                	lw	a4,0(s1)
    800028c8:	ff3716e3          	bne	a4,s3,800028b4 <iget+0x38>
    800028cc:	40d8                	lw	a4,4(s1)
    800028ce:	ff4713e3          	bne	a4,s4,800028b4 <iget+0x38>
      ip->ref++;
    800028d2:	2785                	addiw	a5,a5,1
    800028d4:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800028d6:	00015517          	auipc	a0,0x15
    800028da:	4a250513          	addi	a0,a0,1186 # 80017d78 <itable>
    800028de:	00004097          	auipc	ra,0x4
    800028e2:	988080e7          	jalr	-1656(ra) # 80006266 <release>
      return ip;
    800028e6:	8926                	mv	s2,s1
    800028e8:	a03d                	j	80002916 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028ea:	f7f9                	bnez	a5,800028b8 <iget+0x3c>
    800028ec:	8926                	mv	s2,s1
    800028ee:	b7e9                	j	800028b8 <iget+0x3c>
  if(empty == 0)
    800028f0:	02090c63          	beqz	s2,80002928 <iget+0xac>
  ip->dev = dev;
    800028f4:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800028f8:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800028fc:	4785                	li	a5,1
    800028fe:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002902:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002906:	00015517          	auipc	a0,0x15
    8000290a:	47250513          	addi	a0,a0,1138 # 80017d78 <itable>
    8000290e:	00004097          	auipc	ra,0x4
    80002912:	958080e7          	jalr	-1704(ra) # 80006266 <release>
}
    80002916:	854a                	mv	a0,s2
    80002918:	70a2                	ld	ra,40(sp)
    8000291a:	7402                	ld	s0,32(sp)
    8000291c:	64e2                	ld	s1,24(sp)
    8000291e:	6942                	ld	s2,16(sp)
    80002920:	69a2                	ld	s3,8(sp)
    80002922:	6a02                	ld	s4,0(sp)
    80002924:	6145                	addi	sp,sp,48
    80002926:	8082                	ret
    panic("iget: no inodes");
    80002928:	00006517          	auipc	a0,0x6
    8000292c:	d8050513          	addi	a0,a0,-640 # 800086a8 <syscalls_name+0x140>
    80002930:	00003097          	auipc	ra,0x3
    80002934:	338080e7          	jalr	824(ra) # 80005c68 <panic>

0000000080002938 <fsinit>:
fsinit(int dev) {
    80002938:	7179                	addi	sp,sp,-48
    8000293a:	f406                	sd	ra,40(sp)
    8000293c:	f022                	sd	s0,32(sp)
    8000293e:	ec26                	sd	s1,24(sp)
    80002940:	e84a                	sd	s2,16(sp)
    80002942:	e44e                	sd	s3,8(sp)
    80002944:	1800                	addi	s0,sp,48
    80002946:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002948:	4585                	li	a1,1
    8000294a:	00000097          	auipc	ra,0x0
    8000294e:	a64080e7          	jalr	-1436(ra) # 800023ae <bread>
    80002952:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002954:	00015997          	auipc	s3,0x15
    80002958:	40498993          	addi	s3,s3,1028 # 80017d58 <sb>
    8000295c:	02000613          	li	a2,32
    80002960:	05850593          	addi	a1,a0,88
    80002964:	854e                	mv	a0,s3
    80002966:	ffffe097          	auipc	ra,0xffffe
    8000296a:	8bc080e7          	jalr	-1860(ra) # 80000222 <memmove>
  brelse(bp);
    8000296e:	8526                	mv	a0,s1
    80002970:	00000097          	auipc	ra,0x0
    80002974:	b6e080e7          	jalr	-1170(ra) # 800024de <brelse>
  if(sb.magic != FSMAGIC)
    80002978:	0009a703          	lw	a4,0(s3)
    8000297c:	102037b7          	lui	a5,0x10203
    80002980:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002984:	02f71263          	bne	a4,a5,800029a8 <fsinit+0x70>
  initlog(dev, &sb);
    80002988:	00015597          	auipc	a1,0x15
    8000298c:	3d058593          	addi	a1,a1,976 # 80017d58 <sb>
    80002990:	854a                	mv	a0,s2
    80002992:	00001097          	auipc	ra,0x1
    80002996:	b4c080e7          	jalr	-1204(ra) # 800034de <initlog>
}
    8000299a:	70a2                	ld	ra,40(sp)
    8000299c:	7402                	ld	s0,32(sp)
    8000299e:	64e2                	ld	s1,24(sp)
    800029a0:	6942                	ld	s2,16(sp)
    800029a2:	69a2                	ld	s3,8(sp)
    800029a4:	6145                	addi	sp,sp,48
    800029a6:	8082                	ret
    panic("invalid file system");
    800029a8:	00006517          	auipc	a0,0x6
    800029ac:	d1050513          	addi	a0,a0,-752 # 800086b8 <syscalls_name+0x150>
    800029b0:	00003097          	auipc	ra,0x3
    800029b4:	2b8080e7          	jalr	696(ra) # 80005c68 <panic>

00000000800029b8 <iinit>:
{
    800029b8:	7179                	addi	sp,sp,-48
    800029ba:	f406                	sd	ra,40(sp)
    800029bc:	f022                	sd	s0,32(sp)
    800029be:	ec26                	sd	s1,24(sp)
    800029c0:	e84a                	sd	s2,16(sp)
    800029c2:	e44e                	sd	s3,8(sp)
    800029c4:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800029c6:	00006597          	auipc	a1,0x6
    800029ca:	d0a58593          	addi	a1,a1,-758 # 800086d0 <syscalls_name+0x168>
    800029ce:	00015517          	auipc	a0,0x15
    800029d2:	3aa50513          	addi	a0,a0,938 # 80017d78 <itable>
    800029d6:	00003097          	auipc	ra,0x3
    800029da:	74c080e7          	jalr	1868(ra) # 80006122 <initlock>
  for(i = 0; i < NINODE; i++) {
    800029de:	00015497          	auipc	s1,0x15
    800029e2:	3c248493          	addi	s1,s1,962 # 80017da0 <itable+0x28>
    800029e6:	00017997          	auipc	s3,0x17
    800029ea:	e4a98993          	addi	s3,s3,-438 # 80019830 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800029ee:	00006917          	auipc	s2,0x6
    800029f2:	cea90913          	addi	s2,s2,-790 # 800086d8 <syscalls_name+0x170>
    800029f6:	85ca                	mv	a1,s2
    800029f8:	8526                	mv	a0,s1
    800029fa:	00001097          	auipc	ra,0x1
    800029fe:	e46080e7          	jalr	-442(ra) # 80003840 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a02:	08848493          	addi	s1,s1,136
    80002a06:	ff3498e3          	bne	s1,s3,800029f6 <iinit+0x3e>
}
    80002a0a:	70a2                	ld	ra,40(sp)
    80002a0c:	7402                	ld	s0,32(sp)
    80002a0e:	64e2                	ld	s1,24(sp)
    80002a10:	6942                	ld	s2,16(sp)
    80002a12:	69a2                	ld	s3,8(sp)
    80002a14:	6145                	addi	sp,sp,48
    80002a16:	8082                	ret

0000000080002a18 <ialloc>:
{
    80002a18:	715d                	addi	sp,sp,-80
    80002a1a:	e486                	sd	ra,72(sp)
    80002a1c:	e0a2                	sd	s0,64(sp)
    80002a1e:	fc26                	sd	s1,56(sp)
    80002a20:	f84a                	sd	s2,48(sp)
    80002a22:	f44e                	sd	s3,40(sp)
    80002a24:	f052                	sd	s4,32(sp)
    80002a26:	ec56                	sd	s5,24(sp)
    80002a28:	e85a                	sd	s6,16(sp)
    80002a2a:	e45e                	sd	s7,8(sp)
    80002a2c:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a2e:	00015717          	auipc	a4,0x15
    80002a32:	33672703          	lw	a4,822(a4) # 80017d64 <sb+0xc>
    80002a36:	4785                	li	a5,1
    80002a38:	04e7fa63          	bgeu	a5,a4,80002a8c <ialloc+0x74>
    80002a3c:	8aaa                	mv	s5,a0
    80002a3e:	8bae                	mv	s7,a1
    80002a40:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a42:	00015a17          	auipc	s4,0x15
    80002a46:	316a0a13          	addi	s4,s4,790 # 80017d58 <sb>
    80002a4a:	00048b1b          	sext.w	s6,s1
    80002a4e:	0044d593          	srli	a1,s1,0x4
    80002a52:	018a2783          	lw	a5,24(s4)
    80002a56:	9dbd                	addw	a1,a1,a5
    80002a58:	8556                	mv	a0,s5
    80002a5a:	00000097          	auipc	ra,0x0
    80002a5e:	954080e7          	jalr	-1708(ra) # 800023ae <bread>
    80002a62:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002a64:	05850993          	addi	s3,a0,88
    80002a68:	00f4f793          	andi	a5,s1,15
    80002a6c:	079a                	slli	a5,a5,0x6
    80002a6e:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002a70:	00099783          	lh	a5,0(s3)
    80002a74:	c785                	beqz	a5,80002a9c <ialloc+0x84>
    brelse(bp);
    80002a76:	00000097          	auipc	ra,0x0
    80002a7a:	a68080e7          	jalr	-1432(ra) # 800024de <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a7e:	0485                	addi	s1,s1,1
    80002a80:	00ca2703          	lw	a4,12(s4)
    80002a84:	0004879b          	sext.w	a5,s1
    80002a88:	fce7e1e3          	bltu	a5,a4,80002a4a <ialloc+0x32>
  panic("ialloc: no inodes");
    80002a8c:	00006517          	auipc	a0,0x6
    80002a90:	c5450513          	addi	a0,a0,-940 # 800086e0 <syscalls_name+0x178>
    80002a94:	00003097          	auipc	ra,0x3
    80002a98:	1d4080e7          	jalr	468(ra) # 80005c68 <panic>
      memset(dip, 0, sizeof(*dip));
    80002a9c:	04000613          	li	a2,64
    80002aa0:	4581                	li	a1,0
    80002aa2:	854e                	mv	a0,s3
    80002aa4:	ffffd097          	auipc	ra,0xffffd
    80002aa8:	71e080e7          	jalr	1822(ra) # 800001c2 <memset>
      dip->type = type;
    80002aac:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002ab0:	854a                	mv	a0,s2
    80002ab2:	00001097          	auipc	ra,0x1
    80002ab6:	ca8080e7          	jalr	-856(ra) # 8000375a <log_write>
      brelse(bp);
    80002aba:	854a                	mv	a0,s2
    80002abc:	00000097          	auipc	ra,0x0
    80002ac0:	a22080e7          	jalr	-1502(ra) # 800024de <brelse>
      return iget(dev, inum);
    80002ac4:	85da                	mv	a1,s6
    80002ac6:	8556                	mv	a0,s5
    80002ac8:	00000097          	auipc	ra,0x0
    80002acc:	db4080e7          	jalr	-588(ra) # 8000287c <iget>
}
    80002ad0:	60a6                	ld	ra,72(sp)
    80002ad2:	6406                	ld	s0,64(sp)
    80002ad4:	74e2                	ld	s1,56(sp)
    80002ad6:	7942                	ld	s2,48(sp)
    80002ad8:	79a2                	ld	s3,40(sp)
    80002ada:	7a02                	ld	s4,32(sp)
    80002adc:	6ae2                	ld	s5,24(sp)
    80002ade:	6b42                	ld	s6,16(sp)
    80002ae0:	6ba2                	ld	s7,8(sp)
    80002ae2:	6161                	addi	sp,sp,80
    80002ae4:	8082                	ret

0000000080002ae6 <iupdate>:
{
    80002ae6:	1101                	addi	sp,sp,-32
    80002ae8:	ec06                	sd	ra,24(sp)
    80002aea:	e822                	sd	s0,16(sp)
    80002aec:	e426                	sd	s1,8(sp)
    80002aee:	e04a                	sd	s2,0(sp)
    80002af0:	1000                	addi	s0,sp,32
    80002af2:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002af4:	415c                	lw	a5,4(a0)
    80002af6:	0047d79b          	srliw	a5,a5,0x4
    80002afa:	00015597          	auipc	a1,0x15
    80002afe:	2765a583          	lw	a1,630(a1) # 80017d70 <sb+0x18>
    80002b02:	9dbd                	addw	a1,a1,a5
    80002b04:	4108                	lw	a0,0(a0)
    80002b06:	00000097          	auipc	ra,0x0
    80002b0a:	8a8080e7          	jalr	-1880(ra) # 800023ae <bread>
    80002b0e:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b10:	05850793          	addi	a5,a0,88
    80002b14:	40c8                	lw	a0,4(s1)
    80002b16:	893d                	andi	a0,a0,15
    80002b18:	051a                	slli	a0,a0,0x6
    80002b1a:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002b1c:	04449703          	lh	a4,68(s1)
    80002b20:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002b24:	04649703          	lh	a4,70(s1)
    80002b28:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002b2c:	04849703          	lh	a4,72(s1)
    80002b30:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002b34:	04a49703          	lh	a4,74(s1)
    80002b38:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002b3c:	44f8                	lw	a4,76(s1)
    80002b3e:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b40:	03400613          	li	a2,52
    80002b44:	05048593          	addi	a1,s1,80
    80002b48:	0531                	addi	a0,a0,12
    80002b4a:	ffffd097          	auipc	ra,0xffffd
    80002b4e:	6d8080e7          	jalr	1752(ra) # 80000222 <memmove>
  log_write(bp);
    80002b52:	854a                	mv	a0,s2
    80002b54:	00001097          	auipc	ra,0x1
    80002b58:	c06080e7          	jalr	-1018(ra) # 8000375a <log_write>
  brelse(bp);
    80002b5c:	854a                	mv	a0,s2
    80002b5e:	00000097          	auipc	ra,0x0
    80002b62:	980080e7          	jalr	-1664(ra) # 800024de <brelse>
}
    80002b66:	60e2                	ld	ra,24(sp)
    80002b68:	6442                	ld	s0,16(sp)
    80002b6a:	64a2                	ld	s1,8(sp)
    80002b6c:	6902                	ld	s2,0(sp)
    80002b6e:	6105                	addi	sp,sp,32
    80002b70:	8082                	ret

0000000080002b72 <idup>:
{
    80002b72:	1101                	addi	sp,sp,-32
    80002b74:	ec06                	sd	ra,24(sp)
    80002b76:	e822                	sd	s0,16(sp)
    80002b78:	e426                	sd	s1,8(sp)
    80002b7a:	1000                	addi	s0,sp,32
    80002b7c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b7e:	00015517          	auipc	a0,0x15
    80002b82:	1fa50513          	addi	a0,a0,506 # 80017d78 <itable>
    80002b86:	00003097          	auipc	ra,0x3
    80002b8a:	62c080e7          	jalr	1580(ra) # 800061b2 <acquire>
  ip->ref++;
    80002b8e:	449c                	lw	a5,8(s1)
    80002b90:	2785                	addiw	a5,a5,1
    80002b92:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b94:	00015517          	auipc	a0,0x15
    80002b98:	1e450513          	addi	a0,a0,484 # 80017d78 <itable>
    80002b9c:	00003097          	auipc	ra,0x3
    80002ba0:	6ca080e7          	jalr	1738(ra) # 80006266 <release>
}
    80002ba4:	8526                	mv	a0,s1
    80002ba6:	60e2                	ld	ra,24(sp)
    80002ba8:	6442                	ld	s0,16(sp)
    80002baa:	64a2                	ld	s1,8(sp)
    80002bac:	6105                	addi	sp,sp,32
    80002bae:	8082                	ret

0000000080002bb0 <ilock>:
{
    80002bb0:	1101                	addi	sp,sp,-32
    80002bb2:	ec06                	sd	ra,24(sp)
    80002bb4:	e822                	sd	s0,16(sp)
    80002bb6:	e426                	sd	s1,8(sp)
    80002bb8:	e04a                	sd	s2,0(sp)
    80002bba:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002bbc:	c115                	beqz	a0,80002be0 <ilock+0x30>
    80002bbe:	84aa                	mv	s1,a0
    80002bc0:	451c                	lw	a5,8(a0)
    80002bc2:	00f05f63          	blez	a5,80002be0 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002bc6:	0541                	addi	a0,a0,16
    80002bc8:	00001097          	auipc	ra,0x1
    80002bcc:	cb2080e7          	jalr	-846(ra) # 8000387a <acquiresleep>
  if(ip->valid == 0){
    80002bd0:	40bc                	lw	a5,64(s1)
    80002bd2:	cf99                	beqz	a5,80002bf0 <ilock+0x40>
}
    80002bd4:	60e2                	ld	ra,24(sp)
    80002bd6:	6442                	ld	s0,16(sp)
    80002bd8:	64a2                	ld	s1,8(sp)
    80002bda:	6902                	ld	s2,0(sp)
    80002bdc:	6105                	addi	sp,sp,32
    80002bde:	8082                	ret
    panic("ilock");
    80002be0:	00006517          	auipc	a0,0x6
    80002be4:	b1850513          	addi	a0,a0,-1256 # 800086f8 <syscalls_name+0x190>
    80002be8:	00003097          	auipc	ra,0x3
    80002bec:	080080e7          	jalr	128(ra) # 80005c68 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002bf0:	40dc                	lw	a5,4(s1)
    80002bf2:	0047d79b          	srliw	a5,a5,0x4
    80002bf6:	00015597          	auipc	a1,0x15
    80002bfa:	17a5a583          	lw	a1,378(a1) # 80017d70 <sb+0x18>
    80002bfe:	9dbd                	addw	a1,a1,a5
    80002c00:	4088                	lw	a0,0(s1)
    80002c02:	fffff097          	auipc	ra,0xfffff
    80002c06:	7ac080e7          	jalr	1964(ra) # 800023ae <bread>
    80002c0a:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c0c:	05850593          	addi	a1,a0,88
    80002c10:	40dc                	lw	a5,4(s1)
    80002c12:	8bbd                	andi	a5,a5,15
    80002c14:	079a                	slli	a5,a5,0x6
    80002c16:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c18:	00059783          	lh	a5,0(a1)
    80002c1c:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c20:	00259783          	lh	a5,2(a1)
    80002c24:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c28:	00459783          	lh	a5,4(a1)
    80002c2c:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c30:	00659783          	lh	a5,6(a1)
    80002c34:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c38:	459c                	lw	a5,8(a1)
    80002c3a:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c3c:	03400613          	li	a2,52
    80002c40:	05b1                	addi	a1,a1,12
    80002c42:	05048513          	addi	a0,s1,80
    80002c46:	ffffd097          	auipc	ra,0xffffd
    80002c4a:	5dc080e7          	jalr	1500(ra) # 80000222 <memmove>
    brelse(bp);
    80002c4e:	854a                	mv	a0,s2
    80002c50:	00000097          	auipc	ra,0x0
    80002c54:	88e080e7          	jalr	-1906(ra) # 800024de <brelse>
    ip->valid = 1;
    80002c58:	4785                	li	a5,1
    80002c5a:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002c5c:	04449783          	lh	a5,68(s1)
    80002c60:	fbb5                	bnez	a5,80002bd4 <ilock+0x24>
      panic("ilock: no type");
    80002c62:	00006517          	auipc	a0,0x6
    80002c66:	a9e50513          	addi	a0,a0,-1378 # 80008700 <syscalls_name+0x198>
    80002c6a:	00003097          	auipc	ra,0x3
    80002c6e:	ffe080e7          	jalr	-2(ra) # 80005c68 <panic>

0000000080002c72 <iunlock>:
{
    80002c72:	1101                	addi	sp,sp,-32
    80002c74:	ec06                	sd	ra,24(sp)
    80002c76:	e822                	sd	s0,16(sp)
    80002c78:	e426                	sd	s1,8(sp)
    80002c7a:	e04a                	sd	s2,0(sp)
    80002c7c:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c7e:	c905                	beqz	a0,80002cae <iunlock+0x3c>
    80002c80:	84aa                	mv	s1,a0
    80002c82:	01050913          	addi	s2,a0,16
    80002c86:	854a                	mv	a0,s2
    80002c88:	00001097          	auipc	ra,0x1
    80002c8c:	c8c080e7          	jalr	-884(ra) # 80003914 <holdingsleep>
    80002c90:	cd19                	beqz	a0,80002cae <iunlock+0x3c>
    80002c92:	449c                	lw	a5,8(s1)
    80002c94:	00f05d63          	blez	a5,80002cae <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002c98:	854a                	mv	a0,s2
    80002c9a:	00001097          	auipc	ra,0x1
    80002c9e:	c36080e7          	jalr	-970(ra) # 800038d0 <releasesleep>
}
    80002ca2:	60e2                	ld	ra,24(sp)
    80002ca4:	6442                	ld	s0,16(sp)
    80002ca6:	64a2                	ld	s1,8(sp)
    80002ca8:	6902                	ld	s2,0(sp)
    80002caa:	6105                	addi	sp,sp,32
    80002cac:	8082                	ret
    panic("iunlock");
    80002cae:	00006517          	auipc	a0,0x6
    80002cb2:	a6250513          	addi	a0,a0,-1438 # 80008710 <syscalls_name+0x1a8>
    80002cb6:	00003097          	auipc	ra,0x3
    80002cba:	fb2080e7          	jalr	-78(ra) # 80005c68 <panic>

0000000080002cbe <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002cbe:	7179                	addi	sp,sp,-48
    80002cc0:	f406                	sd	ra,40(sp)
    80002cc2:	f022                	sd	s0,32(sp)
    80002cc4:	ec26                	sd	s1,24(sp)
    80002cc6:	e84a                	sd	s2,16(sp)
    80002cc8:	e44e                	sd	s3,8(sp)
    80002cca:	e052                	sd	s4,0(sp)
    80002ccc:	1800                	addi	s0,sp,48
    80002cce:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002cd0:	05050493          	addi	s1,a0,80
    80002cd4:	08050913          	addi	s2,a0,128
    80002cd8:	a021                	j	80002ce0 <itrunc+0x22>
    80002cda:	0491                	addi	s1,s1,4
    80002cdc:	01248d63          	beq	s1,s2,80002cf6 <itrunc+0x38>
    if(ip->addrs[i]){
    80002ce0:	408c                	lw	a1,0(s1)
    80002ce2:	dde5                	beqz	a1,80002cda <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002ce4:	0009a503          	lw	a0,0(s3)
    80002ce8:	00000097          	auipc	ra,0x0
    80002cec:	90c080e7          	jalr	-1780(ra) # 800025f4 <bfree>
      ip->addrs[i] = 0;
    80002cf0:	0004a023          	sw	zero,0(s1)
    80002cf4:	b7dd                	j	80002cda <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002cf6:	0809a583          	lw	a1,128(s3)
    80002cfa:	e185                	bnez	a1,80002d1a <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002cfc:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d00:	854e                	mv	a0,s3
    80002d02:	00000097          	auipc	ra,0x0
    80002d06:	de4080e7          	jalr	-540(ra) # 80002ae6 <iupdate>
}
    80002d0a:	70a2                	ld	ra,40(sp)
    80002d0c:	7402                	ld	s0,32(sp)
    80002d0e:	64e2                	ld	s1,24(sp)
    80002d10:	6942                	ld	s2,16(sp)
    80002d12:	69a2                	ld	s3,8(sp)
    80002d14:	6a02                	ld	s4,0(sp)
    80002d16:	6145                	addi	sp,sp,48
    80002d18:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d1a:	0009a503          	lw	a0,0(s3)
    80002d1e:	fffff097          	auipc	ra,0xfffff
    80002d22:	690080e7          	jalr	1680(ra) # 800023ae <bread>
    80002d26:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d28:	05850493          	addi	s1,a0,88
    80002d2c:	45850913          	addi	s2,a0,1112
    80002d30:	a811                	j	80002d44 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002d32:	0009a503          	lw	a0,0(s3)
    80002d36:	00000097          	auipc	ra,0x0
    80002d3a:	8be080e7          	jalr	-1858(ra) # 800025f4 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002d3e:	0491                	addi	s1,s1,4
    80002d40:	01248563          	beq	s1,s2,80002d4a <itrunc+0x8c>
      if(a[j])
    80002d44:	408c                	lw	a1,0(s1)
    80002d46:	dde5                	beqz	a1,80002d3e <itrunc+0x80>
    80002d48:	b7ed                	j	80002d32 <itrunc+0x74>
    brelse(bp);
    80002d4a:	8552                	mv	a0,s4
    80002d4c:	fffff097          	auipc	ra,0xfffff
    80002d50:	792080e7          	jalr	1938(ra) # 800024de <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d54:	0809a583          	lw	a1,128(s3)
    80002d58:	0009a503          	lw	a0,0(s3)
    80002d5c:	00000097          	auipc	ra,0x0
    80002d60:	898080e7          	jalr	-1896(ra) # 800025f4 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d64:	0809a023          	sw	zero,128(s3)
    80002d68:	bf51                	j	80002cfc <itrunc+0x3e>

0000000080002d6a <iput>:
{
    80002d6a:	1101                	addi	sp,sp,-32
    80002d6c:	ec06                	sd	ra,24(sp)
    80002d6e:	e822                	sd	s0,16(sp)
    80002d70:	e426                	sd	s1,8(sp)
    80002d72:	e04a                	sd	s2,0(sp)
    80002d74:	1000                	addi	s0,sp,32
    80002d76:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d78:	00015517          	auipc	a0,0x15
    80002d7c:	00050513          	mv	a0,a0
    80002d80:	00003097          	auipc	ra,0x3
    80002d84:	432080e7          	jalr	1074(ra) # 800061b2 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d88:	4498                	lw	a4,8(s1)
    80002d8a:	4785                	li	a5,1
    80002d8c:	02f70363          	beq	a4,a5,80002db2 <iput+0x48>
  ip->ref--;
    80002d90:	449c                	lw	a5,8(s1)
    80002d92:	37fd                	addiw	a5,a5,-1
    80002d94:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d96:	00015517          	auipc	a0,0x15
    80002d9a:	fe250513          	addi	a0,a0,-30 # 80017d78 <itable>
    80002d9e:	00003097          	auipc	ra,0x3
    80002da2:	4c8080e7          	jalr	1224(ra) # 80006266 <release>
}
    80002da6:	60e2                	ld	ra,24(sp)
    80002da8:	6442                	ld	s0,16(sp)
    80002daa:	64a2                	ld	s1,8(sp)
    80002dac:	6902                	ld	s2,0(sp)
    80002dae:	6105                	addi	sp,sp,32
    80002db0:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002db2:	40bc                	lw	a5,64(s1)
    80002db4:	dff1                	beqz	a5,80002d90 <iput+0x26>
    80002db6:	04a49783          	lh	a5,74(s1)
    80002dba:	fbf9                	bnez	a5,80002d90 <iput+0x26>
    acquiresleep(&ip->lock);
    80002dbc:	01048913          	addi	s2,s1,16
    80002dc0:	854a                	mv	a0,s2
    80002dc2:	00001097          	auipc	ra,0x1
    80002dc6:	ab8080e7          	jalr	-1352(ra) # 8000387a <acquiresleep>
    release(&itable.lock);
    80002dca:	00015517          	auipc	a0,0x15
    80002dce:	fae50513          	addi	a0,a0,-82 # 80017d78 <itable>
    80002dd2:	00003097          	auipc	ra,0x3
    80002dd6:	494080e7          	jalr	1172(ra) # 80006266 <release>
    itrunc(ip);
    80002dda:	8526                	mv	a0,s1
    80002ddc:	00000097          	auipc	ra,0x0
    80002de0:	ee2080e7          	jalr	-286(ra) # 80002cbe <itrunc>
    ip->type = 0;
    80002de4:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002de8:	8526                	mv	a0,s1
    80002dea:	00000097          	auipc	ra,0x0
    80002dee:	cfc080e7          	jalr	-772(ra) # 80002ae6 <iupdate>
    ip->valid = 0;
    80002df2:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002df6:	854a                	mv	a0,s2
    80002df8:	00001097          	auipc	ra,0x1
    80002dfc:	ad8080e7          	jalr	-1320(ra) # 800038d0 <releasesleep>
    acquire(&itable.lock);
    80002e00:	00015517          	auipc	a0,0x15
    80002e04:	f7850513          	addi	a0,a0,-136 # 80017d78 <itable>
    80002e08:	00003097          	auipc	ra,0x3
    80002e0c:	3aa080e7          	jalr	938(ra) # 800061b2 <acquire>
    80002e10:	b741                	j	80002d90 <iput+0x26>

0000000080002e12 <iunlockput>:
{
    80002e12:	1101                	addi	sp,sp,-32
    80002e14:	ec06                	sd	ra,24(sp)
    80002e16:	e822                	sd	s0,16(sp)
    80002e18:	e426                	sd	s1,8(sp)
    80002e1a:	1000                	addi	s0,sp,32
    80002e1c:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e1e:	00000097          	auipc	ra,0x0
    80002e22:	e54080e7          	jalr	-428(ra) # 80002c72 <iunlock>
  iput(ip);
    80002e26:	8526                	mv	a0,s1
    80002e28:	00000097          	auipc	ra,0x0
    80002e2c:	f42080e7          	jalr	-190(ra) # 80002d6a <iput>
}
    80002e30:	60e2                	ld	ra,24(sp)
    80002e32:	6442                	ld	s0,16(sp)
    80002e34:	64a2                	ld	s1,8(sp)
    80002e36:	6105                	addi	sp,sp,32
    80002e38:	8082                	ret

0000000080002e3a <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e3a:	1141                	addi	sp,sp,-16
    80002e3c:	e422                	sd	s0,8(sp)
    80002e3e:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e40:	411c                	lw	a5,0(a0)
    80002e42:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e44:	415c                	lw	a5,4(a0)
    80002e46:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e48:	04451783          	lh	a5,68(a0)
    80002e4c:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e50:	04a51783          	lh	a5,74(a0)
    80002e54:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e58:	04c56783          	lwu	a5,76(a0)
    80002e5c:	e99c                	sd	a5,16(a1)
}
    80002e5e:	6422                	ld	s0,8(sp)
    80002e60:	0141                	addi	sp,sp,16
    80002e62:	8082                	ret

0000000080002e64 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e64:	457c                	lw	a5,76(a0)
    80002e66:	0ed7e963          	bltu	a5,a3,80002f58 <readi+0xf4>
{
    80002e6a:	7159                	addi	sp,sp,-112
    80002e6c:	f486                	sd	ra,104(sp)
    80002e6e:	f0a2                	sd	s0,96(sp)
    80002e70:	eca6                	sd	s1,88(sp)
    80002e72:	e8ca                	sd	s2,80(sp)
    80002e74:	e4ce                	sd	s3,72(sp)
    80002e76:	e0d2                	sd	s4,64(sp)
    80002e78:	fc56                	sd	s5,56(sp)
    80002e7a:	f85a                	sd	s6,48(sp)
    80002e7c:	f45e                	sd	s7,40(sp)
    80002e7e:	f062                	sd	s8,32(sp)
    80002e80:	ec66                	sd	s9,24(sp)
    80002e82:	e86a                	sd	s10,16(sp)
    80002e84:	e46e                	sd	s11,8(sp)
    80002e86:	1880                	addi	s0,sp,112
    80002e88:	8baa                	mv	s7,a0
    80002e8a:	8c2e                	mv	s8,a1
    80002e8c:	8ab2                	mv	s5,a2
    80002e8e:	84b6                	mv	s1,a3
    80002e90:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002e92:	9f35                	addw	a4,a4,a3
    return 0;
    80002e94:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002e96:	0ad76063          	bltu	a4,a3,80002f36 <readi+0xd2>
  if(off + n > ip->size)
    80002e9a:	00e7f463          	bgeu	a5,a4,80002ea2 <readi+0x3e>
    n = ip->size - off;
    80002e9e:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ea2:	0a0b0963          	beqz	s6,80002f54 <readi+0xf0>
    80002ea6:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ea8:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002eac:	5cfd                	li	s9,-1
    80002eae:	a82d                	j	80002ee8 <readi+0x84>
    80002eb0:	020a1d93          	slli	s11,s4,0x20
    80002eb4:	020ddd93          	srli	s11,s11,0x20
    80002eb8:	05890613          	addi	a2,s2,88
    80002ebc:	86ee                	mv	a3,s11
    80002ebe:	963a                	add	a2,a2,a4
    80002ec0:	85d6                	mv	a1,s5
    80002ec2:	8562                	mv	a0,s8
    80002ec4:	fffff097          	auipc	ra,0xfffff
    80002ec8:	a44080e7          	jalr	-1468(ra) # 80001908 <either_copyout>
    80002ecc:	05950d63          	beq	a0,s9,80002f26 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002ed0:	854a                	mv	a0,s2
    80002ed2:	fffff097          	auipc	ra,0xfffff
    80002ed6:	60c080e7          	jalr	1548(ra) # 800024de <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002eda:	013a09bb          	addw	s3,s4,s3
    80002ede:	009a04bb          	addw	s1,s4,s1
    80002ee2:	9aee                	add	s5,s5,s11
    80002ee4:	0569f763          	bgeu	s3,s6,80002f32 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002ee8:	000ba903          	lw	s2,0(s7)
    80002eec:	00a4d59b          	srliw	a1,s1,0xa
    80002ef0:	855e                	mv	a0,s7
    80002ef2:	00000097          	auipc	ra,0x0
    80002ef6:	8b0080e7          	jalr	-1872(ra) # 800027a2 <bmap>
    80002efa:	0005059b          	sext.w	a1,a0
    80002efe:	854a                	mv	a0,s2
    80002f00:	fffff097          	auipc	ra,0xfffff
    80002f04:	4ae080e7          	jalr	1198(ra) # 800023ae <bread>
    80002f08:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f0a:	3ff4f713          	andi	a4,s1,1023
    80002f0e:	40ed07bb          	subw	a5,s10,a4
    80002f12:	413b06bb          	subw	a3,s6,s3
    80002f16:	8a3e                	mv	s4,a5
    80002f18:	2781                	sext.w	a5,a5
    80002f1a:	0006861b          	sext.w	a2,a3
    80002f1e:	f8f679e3          	bgeu	a2,a5,80002eb0 <readi+0x4c>
    80002f22:	8a36                	mv	s4,a3
    80002f24:	b771                	j	80002eb0 <readi+0x4c>
      brelse(bp);
    80002f26:	854a                	mv	a0,s2
    80002f28:	fffff097          	auipc	ra,0xfffff
    80002f2c:	5b6080e7          	jalr	1462(ra) # 800024de <brelse>
      tot = -1;
    80002f30:	59fd                	li	s3,-1
  }
  return tot;
    80002f32:	0009851b          	sext.w	a0,s3
}
    80002f36:	70a6                	ld	ra,104(sp)
    80002f38:	7406                	ld	s0,96(sp)
    80002f3a:	64e6                	ld	s1,88(sp)
    80002f3c:	6946                	ld	s2,80(sp)
    80002f3e:	69a6                	ld	s3,72(sp)
    80002f40:	6a06                	ld	s4,64(sp)
    80002f42:	7ae2                	ld	s5,56(sp)
    80002f44:	7b42                	ld	s6,48(sp)
    80002f46:	7ba2                	ld	s7,40(sp)
    80002f48:	7c02                	ld	s8,32(sp)
    80002f4a:	6ce2                	ld	s9,24(sp)
    80002f4c:	6d42                	ld	s10,16(sp)
    80002f4e:	6da2                	ld	s11,8(sp)
    80002f50:	6165                	addi	sp,sp,112
    80002f52:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f54:	89da                	mv	s3,s6
    80002f56:	bff1                	j	80002f32 <readi+0xce>
    return 0;
    80002f58:	4501                	li	a0,0
}
    80002f5a:	8082                	ret

0000000080002f5c <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f5c:	457c                	lw	a5,76(a0)
    80002f5e:	10d7e863          	bltu	a5,a3,8000306e <writei+0x112>
{
    80002f62:	7159                	addi	sp,sp,-112
    80002f64:	f486                	sd	ra,104(sp)
    80002f66:	f0a2                	sd	s0,96(sp)
    80002f68:	eca6                	sd	s1,88(sp)
    80002f6a:	e8ca                	sd	s2,80(sp)
    80002f6c:	e4ce                	sd	s3,72(sp)
    80002f6e:	e0d2                	sd	s4,64(sp)
    80002f70:	fc56                	sd	s5,56(sp)
    80002f72:	f85a                	sd	s6,48(sp)
    80002f74:	f45e                	sd	s7,40(sp)
    80002f76:	f062                	sd	s8,32(sp)
    80002f78:	ec66                	sd	s9,24(sp)
    80002f7a:	e86a                	sd	s10,16(sp)
    80002f7c:	e46e                	sd	s11,8(sp)
    80002f7e:	1880                	addi	s0,sp,112
    80002f80:	8b2a                	mv	s6,a0
    80002f82:	8c2e                	mv	s8,a1
    80002f84:	8ab2                	mv	s5,a2
    80002f86:	8936                	mv	s2,a3
    80002f88:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002f8a:	00e687bb          	addw	a5,a3,a4
    80002f8e:	0ed7e263          	bltu	a5,a3,80003072 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002f92:	00043737          	lui	a4,0x43
    80002f96:	0ef76063          	bltu	a4,a5,80003076 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f9a:	0c0b8863          	beqz	s7,8000306a <writei+0x10e>
    80002f9e:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fa0:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002fa4:	5cfd                	li	s9,-1
    80002fa6:	a091                	j	80002fea <writei+0x8e>
    80002fa8:	02099d93          	slli	s11,s3,0x20
    80002fac:	020ddd93          	srli	s11,s11,0x20
    80002fb0:	05848513          	addi	a0,s1,88
    80002fb4:	86ee                	mv	a3,s11
    80002fb6:	8656                	mv	a2,s5
    80002fb8:	85e2                	mv	a1,s8
    80002fba:	953a                	add	a0,a0,a4
    80002fbc:	fffff097          	auipc	ra,0xfffff
    80002fc0:	9a2080e7          	jalr	-1630(ra) # 8000195e <either_copyin>
    80002fc4:	07950263          	beq	a0,s9,80003028 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002fc8:	8526                	mv	a0,s1
    80002fca:	00000097          	auipc	ra,0x0
    80002fce:	790080e7          	jalr	1936(ra) # 8000375a <log_write>
    brelse(bp);
    80002fd2:	8526                	mv	a0,s1
    80002fd4:	fffff097          	auipc	ra,0xfffff
    80002fd8:	50a080e7          	jalr	1290(ra) # 800024de <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fdc:	01498a3b          	addw	s4,s3,s4
    80002fe0:	0129893b          	addw	s2,s3,s2
    80002fe4:	9aee                	add	s5,s5,s11
    80002fe6:	057a7663          	bgeu	s4,s7,80003032 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002fea:	000b2483          	lw	s1,0(s6)
    80002fee:	00a9559b          	srliw	a1,s2,0xa
    80002ff2:	855a                	mv	a0,s6
    80002ff4:	fffff097          	auipc	ra,0xfffff
    80002ff8:	7ae080e7          	jalr	1966(ra) # 800027a2 <bmap>
    80002ffc:	0005059b          	sext.w	a1,a0
    80003000:	8526                	mv	a0,s1
    80003002:	fffff097          	auipc	ra,0xfffff
    80003006:	3ac080e7          	jalr	940(ra) # 800023ae <bread>
    8000300a:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000300c:	3ff97713          	andi	a4,s2,1023
    80003010:	40ed07bb          	subw	a5,s10,a4
    80003014:	414b86bb          	subw	a3,s7,s4
    80003018:	89be                	mv	s3,a5
    8000301a:	2781                	sext.w	a5,a5
    8000301c:	0006861b          	sext.w	a2,a3
    80003020:	f8f674e3          	bgeu	a2,a5,80002fa8 <writei+0x4c>
    80003024:	89b6                	mv	s3,a3
    80003026:	b749                	j	80002fa8 <writei+0x4c>
      brelse(bp);
    80003028:	8526                	mv	a0,s1
    8000302a:	fffff097          	auipc	ra,0xfffff
    8000302e:	4b4080e7          	jalr	1204(ra) # 800024de <brelse>
  }

  if(off > ip->size)
    80003032:	04cb2783          	lw	a5,76(s6)
    80003036:	0127f463          	bgeu	a5,s2,8000303e <writei+0xe2>
    ip->size = off;
    8000303a:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000303e:	855a                	mv	a0,s6
    80003040:	00000097          	auipc	ra,0x0
    80003044:	aa6080e7          	jalr	-1370(ra) # 80002ae6 <iupdate>

  return tot;
    80003048:	000a051b          	sext.w	a0,s4
}
    8000304c:	70a6                	ld	ra,104(sp)
    8000304e:	7406                	ld	s0,96(sp)
    80003050:	64e6                	ld	s1,88(sp)
    80003052:	6946                	ld	s2,80(sp)
    80003054:	69a6                	ld	s3,72(sp)
    80003056:	6a06                	ld	s4,64(sp)
    80003058:	7ae2                	ld	s5,56(sp)
    8000305a:	7b42                	ld	s6,48(sp)
    8000305c:	7ba2                	ld	s7,40(sp)
    8000305e:	7c02                	ld	s8,32(sp)
    80003060:	6ce2                	ld	s9,24(sp)
    80003062:	6d42                	ld	s10,16(sp)
    80003064:	6da2                	ld	s11,8(sp)
    80003066:	6165                	addi	sp,sp,112
    80003068:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000306a:	8a5e                	mv	s4,s7
    8000306c:	bfc9                	j	8000303e <writei+0xe2>
    return -1;
    8000306e:	557d                	li	a0,-1
}
    80003070:	8082                	ret
    return -1;
    80003072:	557d                	li	a0,-1
    80003074:	bfe1                	j	8000304c <writei+0xf0>
    return -1;
    80003076:	557d                	li	a0,-1
    80003078:	bfd1                	j	8000304c <writei+0xf0>

000000008000307a <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000307a:	1141                	addi	sp,sp,-16
    8000307c:	e406                	sd	ra,8(sp)
    8000307e:	e022                	sd	s0,0(sp)
    80003080:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003082:	4639                	li	a2,14
    80003084:	ffffd097          	auipc	ra,0xffffd
    80003088:	216080e7          	jalr	534(ra) # 8000029a <strncmp>
}
    8000308c:	60a2                	ld	ra,8(sp)
    8000308e:	6402                	ld	s0,0(sp)
    80003090:	0141                	addi	sp,sp,16
    80003092:	8082                	ret

0000000080003094 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003094:	7139                	addi	sp,sp,-64
    80003096:	fc06                	sd	ra,56(sp)
    80003098:	f822                	sd	s0,48(sp)
    8000309a:	f426                	sd	s1,40(sp)
    8000309c:	f04a                	sd	s2,32(sp)
    8000309e:	ec4e                	sd	s3,24(sp)
    800030a0:	e852                	sd	s4,16(sp)
    800030a2:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800030a4:	04451703          	lh	a4,68(a0)
    800030a8:	4785                	li	a5,1
    800030aa:	00f71a63          	bne	a4,a5,800030be <dirlookup+0x2a>
    800030ae:	892a                	mv	s2,a0
    800030b0:	89ae                	mv	s3,a1
    800030b2:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800030b4:	457c                	lw	a5,76(a0)
    800030b6:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800030b8:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030ba:	e79d                	bnez	a5,800030e8 <dirlookup+0x54>
    800030bc:	a8a5                	j	80003134 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800030be:	00005517          	auipc	a0,0x5
    800030c2:	65a50513          	addi	a0,a0,1626 # 80008718 <syscalls_name+0x1b0>
    800030c6:	00003097          	auipc	ra,0x3
    800030ca:	ba2080e7          	jalr	-1118(ra) # 80005c68 <panic>
      panic("dirlookup read");
    800030ce:	00005517          	auipc	a0,0x5
    800030d2:	66250513          	addi	a0,a0,1634 # 80008730 <syscalls_name+0x1c8>
    800030d6:	00003097          	auipc	ra,0x3
    800030da:	b92080e7          	jalr	-1134(ra) # 80005c68 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030de:	24c1                	addiw	s1,s1,16
    800030e0:	04c92783          	lw	a5,76(s2)
    800030e4:	04f4f763          	bgeu	s1,a5,80003132 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800030e8:	4741                	li	a4,16
    800030ea:	86a6                	mv	a3,s1
    800030ec:	fc040613          	addi	a2,s0,-64
    800030f0:	4581                	li	a1,0
    800030f2:	854a                	mv	a0,s2
    800030f4:	00000097          	auipc	ra,0x0
    800030f8:	d70080e7          	jalr	-656(ra) # 80002e64 <readi>
    800030fc:	47c1                	li	a5,16
    800030fe:	fcf518e3          	bne	a0,a5,800030ce <dirlookup+0x3a>
    if(de.inum == 0)
    80003102:	fc045783          	lhu	a5,-64(s0)
    80003106:	dfe1                	beqz	a5,800030de <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003108:	fc240593          	addi	a1,s0,-62
    8000310c:	854e                	mv	a0,s3
    8000310e:	00000097          	auipc	ra,0x0
    80003112:	f6c080e7          	jalr	-148(ra) # 8000307a <namecmp>
    80003116:	f561                	bnez	a0,800030de <dirlookup+0x4a>
      if(poff)
    80003118:	000a0463          	beqz	s4,80003120 <dirlookup+0x8c>
        *poff = off;
    8000311c:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003120:	fc045583          	lhu	a1,-64(s0)
    80003124:	00092503          	lw	a0,0(s2)
    80003128:	fffff097          	auipc	ra,0xfffff
    8000312c:	754080e7          	jalr	1876(ra) # 8000287c <iget>
    80003130:	a011                	j	80003134 <dirlookup+0xa0>
  return 0;
    80003132:	4501                	li	a0,0
}
    80003134:	70e2                	ld	ra,56(sp)
    80003136:	7442                	ld	s0,48(sp)
    80003138:	74a2                	ld	s1,40(sp)
    8000313a:	7902                	ld	s2,32(sp)
    8000313c:	69e2                	ld	s3,24(sp)
    8000313e:	6a42                	ld	s4,16(sp)
    80003140:	6121                	addi	sp,sp,64
    80003142:	8082                	ret

0000000080003144 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003144:	711d                	addi	sp,sp,-96
    80003146:	ec86                	sd	ra,88(sp)
    80003148:	e8a2                	sd	s0,80(sp)
    8000314a:	e4a6                	sd	s1,72(sp)
    8000314c:	e0ca                	sd	s2,64(sp)
    8000314e:	fc4e                	sd	s3,56(sp)
    80003150:	f852                	sd	s4,48(sp)
    80003152:	f456                	sd	s5,40(sp)
    80003154:	f05a                	sd	s6,32(sp)
    80003156:	ec5e                	sd	s7,24(sp)
    80003158:	e862                	sd	s8,16(sp)
    8000315a:	e466                	sd	s9,8(sp)
    8000315c:	1080                	addi	s0,sp,96
    8000315e:	84aa                	mv	s1,a0
    80003160:	8b2e                	mv	s6,a1
    80003162:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003164:	00054703          	lbu	a4,0(a0)
    80003168:	02f00793          	li	a5,47
    8000316c:	02f70363          	beq	a4,a5,80003192 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003170:	ffffe097          	auipc	ra,0xffffe
    80003174:	d22080e7          	jalr	-734(ra) # 80000e92 <myproc>
    80003178:	15853503          	ld	a0,344(a0)
    8000317c:	00000097          	auipc	ra,0x0
    80003180:	9f6080e7          	jalr	-1546(ra) # 80002b72 <idup>
    80003184:	89aa                	mv	s3,a0
  while(*path == '/')
    80003186:	02f00913          	li	s2,47
  len = path - s;
    8000318a:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    8000318c:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000318e:	4c05                	li	s8,1
    80003190:	a865                	j	80003248 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003192:	4585                	li	a1,1
    80003194:	4505                	li	a0,1
    80003196:	fffff097          	auipc	ra,0xfffff
    8000319a:	6e6080e7          	jalr	1766(ra) # 8000287c <iget>
    8000319e:	89aa                	mv	s3,a0
    800031a0:	b7dd                	j	80003186 <namex+0x42>
      iunlockput(ip);
    800031a2:	854e                	mv	a0,s3
    800031a4:	00000097          	auipc	ra,0x0
    800031a8:	c6e080e7          	jalr	-914(ra) # 80002e12 <iunlockput>
      return 0;
    800031ac:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800031ae:	854e                	mv	a0,s3
    800031b0:	60e6                	ld	ra,88(sp)
    800031b2:	6446                	ld	s0,80(sp)
    800031b4:	64a6                	ld	s1,72(sp)
    800031b6:	6906                	ld	s2,64(sp)
    800031b8:	79e2                	ld	s3,56(sp)
    800031ba:	7a42                	ld	s4,48(sp)
    800031bc:	7aa2                	ld	s5,40(sp)
    800031be:	7b02                	ld	s6,32(sp)
    800031c0:	6be2                	ld	s7,24(sp)
    800031c2:	6c42                	ld	s8,16(sp)
    800031c4:	6ca2                	ld	s9,8(sp)
    800031c6:	6125                	addi	sp,sp,96
    800031c8:	8082                	ret
      iunlock(ip);
    800031ca:	854e                	mv	a0,s3
    800031cc:	00000097          	auipc	ra,0x0
    800031d0:	aa6080e7          	jalr	-1370(ra) # 80002c72 <iunlock>
      return ip;
    800031d4:	bfe9                	j	800031ae <namex+0x6a>
      iunlockput(ip);
    800031d6:	854e                	mv	a0,s3
    800031d8:	00000097          	auipc	ra,0x0
    800031dc:	c3a080e7          	jalr	-966(ra) # 80002e12 <iunlockput>
      return 0;
    800031e0:	89d2                	mv	s3,s4
    800031e2:	b7f1                	j	800031ae <namex+0x6a>
  len = path - s;
    800031e4:	40b48633          	sub	a2,s1,a1
    800031e8:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    800031ec:	094cd463          	bge	s9,s4,80003274 <namex+0x130>
    memmove(name, s, DIRSIZ);
    800031f0:	4639                	li	a2,14
    800031f2:	8556                	mv	a0,s5
    800031f4:	ffffd097          	auipc	ra,0xffffd
    800031f8:	02e080e7          	jalr	46(ra) # 80000222 <memmove>
  while(*path == '/')
    800031fc:	0004c783          	lbu	a5,0(s1)
    80003200:	01279763          	bne	a5,s2,8000320e <namex+0xca>
    path++;
    80003204:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003206:	0004c783          	lbu	a5,0(s1)
    8000320a:	ff278de3          	beq	a5,s2,80003204 <namex+0xc0>
    ilock(ip);
    8000320e:	854e                	mv	a0,s3
    80003210:	00000097          	auipc	ra,0x0
    80003214:	9a0080e7          	jalr	-1632(ra) # 80002bb0 <ilock>
    if(ip->type != T_DIR){
    80003218:	04499783          	lh	a5,68(s3)
    8000321c:	f98793e3          	bne	a5,s8,800031a2 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003220:	000b0563          	beqz	s6,8000322a <namex+0xe6>
    80003224:	0004c783          	lbu	a5,0(s1)
    80003228:	d3cd                	beqz	a5,800031ca <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000322a:	865e                	mv	a2,s7
    8000322c:	85d6                	mv	a1,s5
    8000322e:	854e                	mv	a0,s3
    80003230:	00000097          	auipc	ra,0x0
    80003234:	e64080e7          	jalr	-412(ra) # 80003094 <dirlookup>
    80003238:	8a2a                	mv	s4,a0
    8000323a:	dd51                	beqz	a0,800031d6 <namex+0x92>
    iunlockput(ip);
    8000323c:	854e                	mv	a0,s3
    8000323e:	00000097          	auipc	ra,0x0
    80003242:	bd4080e7          	jalr	-1068(ra) # 80002e12 <iunlockput>
    ip = next;
    80003246:	89d2                	mv	s3,s4
  while(*path == '/')
    80003248:	0004c783          	lbu	a5,0(s1)
    8000324c:	05279763          	bne	a5,s2,8000329a <namex+0x156>
    path++;
    80003250:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003252:	0004c783          	lbu	a5,0(s1)
    80003256:	ff278de3          	beq	a5,s2,80003250 <namex+0x10c>
  if(*path == 0)
    8000325a:	c79d                	beqz	a5,80003288 <namex+0x144>
    path++;
    8000325c:	85a6                	mv	a1,s1
  len = path - s;
    8000325e:	8a5e                	mv	s4,s7
    80003260:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003262:	01278963          	beq	a5,s2,80003274 <namex+0x130>
    80003266:	dfbd                	beqz	a5,800031e4 <namex+0xa0>
    path++;
    80003268:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    8000326a:	0004c783          	lbu	a5,0(s1)
    8000326e:	ff279ce3          	bne	a5,s2,80003266 <namex+0x122>
    80003272:	bf8d                	j	800031e4 <namex+0xa0>
    memmove(name, s, len);
    80003274:	2601                	sext.w	a2,a2
    80003276:	8556                	mv	a0,s5
    80003278:	ffffd097          	auipc	ra,0xffffd
    8000327c:	faa080e7          	jalr	-86(ra) # 80000222 <memmove>
    name[len] = 0;
    80003280:	9a56                	add	s4,s4,s5
    80003282:	000a0023          	sb	zero,0(s4)
    80003286:	bf9d                	j	800031fc <namex+0xb8>
  if(nameiparent){
    80003288:	f20b03e3          	beqz	s6,800031ae <namex+0x6a>
    iput(ip);
    8000328c:	854e                	mv	a0,s3
    8000328e:	00000097          	auipc	ra,0x0
    80003292:	adc080e7          	jalr	-1316(ra) # 80002d6a <iput>
    return 0;
    80003296:	4981                	li	s3,0
    80003298:	bf19                	j	800031ae <namex+0x6a>
  if(*path == 0)
    8000329a:	d7fd                	beqz	a5,80003288 <namex+0x144>
  while(*path != '/' && *path != 0)
    8000329c:	0004c783          	lbu	a5,0(s1)
    800032a0:	85a6                	mv	a1,s1
    800032a2:	b7d1                	j	80003266 <namex+0x122>

00000000800032a4 <dirlink>:
{
    800032a4:	7139                	addi	sp,sp,-64
    800032a6:	fc06                	sd	ra,56(sp)
    800032a8:	f822                	sd	s0,48(sp)
    800032aa:	f426                	sd	s1,40(sp)
    800032ac:	f04a                	sd	s2,32(sp)
    800032ae:	ec4e                	sd	s3,24(sp)
    800032b0:	e852                	sd	s4,16(sp)
    800032b2:	0080                	addi	s0,sp,64
    800032b4:	892a                	mv	s2,a0
    800032b6:	8a2e                	mv	s4,a1
    800032b8:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800032ba:	4601                	li	a2,0
    800032bc:	00000097          	auipc	ra,0x0
    800032c0:	dd8080e7          	jalr	-552(ra) # 80003094 <dirlookup>
    800032c4:	e93d                	bnez	a0,8000333a <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032c6:	04c92483          	lw	s1,76(s2)
    800032ca:	c49d                	beqz	s1,800032f8 <dirlink+0x54>
    800032cc:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032ce:	4741                	li	a4,16
    800032d0:	86a6                	mv	a3,s1
    800032d2:	fc040613          	addi	a2,s0,-64
    800032d6:	4581                	li	a1,0
    800032d8:	854a                	mv	a0,s2
    800032da:	00000097          	auipc	ra,0x0
    800032de:	b8a080e7          	jalr	-1142(ra) # 80002e64 <readi>
    800032e2:	47c1                	li	a5,16
    800032e4:	06f51163          	bne	a0,a5,80003346 <dirlink+0xa2>
    if(de.inum == 0)
    800032e8:	fc045783          	lhu	a5,-64(s0)
    800032ec:	c791                	beqz	a5,800032f8 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032ee:	24c1                	addiw	s1,s1,16
    800032f0:	04c92783          	lw	a5,76(s2)
    800032f4:	fcf4ede3          	bltu	s1,a5,800032ce <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800032f8:	4639                	li	a2,14
    800032fa:	85d2                	mv	a1,s4
    800032fc:	fc240513          	addi	a0,s0,-62
    80003300:	ffffd097          	auipc	ra,0xffffd
    80003304:	fd6080e7          	jalr	-42(ra) # 800002d6 <strncpy>
  de.inum = inum;
    80003308:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000330c:	4741                	li	a4,16
    8000330e:	86a6                	mv	a3,s1
    80003310:	fc040613          	addi	a2,s0,-64
    80003314:	4581                	li	a1,0
    80003316:	854a                	mv	a0,s2
    80003318:	00000097          	auipc	ra,0x0
    8000331c:	c44080e7          	jalr	-956(ra) # 80002f5c <writei>
    80003320:	872a                	mv	a4,a0
    80003322:	47c1                	li	a5,16
  return 0;
    80003324:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003326:	02f71863          	bne	a4,a5,80003356 <dirlink+0xb2>
}
    8000332a:	70e2                	ld	ra,56(sp)
    8000332c:	7442                	ld	s0,48(sp)
    8000332e:	74a2                	ld	s1,40(sp)
    80003330:	7902                	ld	s2,32(sp)
    80003332:	69e2                	ld	s3,24(sp)
    80003334:	6a42                	ld	s4,16(sp)
    80003336:	6121                	addi	sp,sp,64
    80003338:	8082                	ret
    iput(ip);
    8000333a:	00000097          	auipc	ra,0x0
    8000333e:	a30080e7          	jalr	-1488(ra) # 80002d6a <iput>
    return -1;
    80003342:	557d                	li	a0,-1
    80003344:	b7dd                	j	8000332a <dirlink+0x86>
      panic("dirlink read");
    80003346:	00005517          	auipc	a0,0x5
    8000334a:	3fa50513          	addi	a0,a0,1018 # 80008740 <syscalls_name+0x1d8>
    8000334e:	00003097          	auipc	ra,0x3
    80003352:	91a080e7          	jalr	-1766(ra) # 80005c68 <panic>
    panic("dirlink");
    80003356:	00005517          	auipc	a0,0x5
    8000335a:	4f250513          	addi	a0,a0,1266 # 80008848 <syscalls_name+0x2e0>
    8000335e:	00003097          	auipc	ra,0x3
    80003362:	90a080e7          	jalr	-1782(ra) # 80005c68 <panic>

0000000080003366 <namei>:

struct inode*
namei(char *path)
{
    80003366:	1101                	addi	sp,sp,-32
    80003368:	ec06                	sd	ra,24(sp)
    8000336a:	e822                	sd	s0,16(sp)
    8000336c:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000336e:	fe040613          	addi	a2,s0,-32
    80003372:	4581                	li	a1,0
    80003374:	00000097          	auipc	ra,0x0
    80003378:	dd0080e7          	jalr	-560(ra) # 80003144 <namex>
}
    8000337c:	60e2                	ld	ra,24(sp)
    8000337e:	6442                	ld	s0,16(sp)
    80003380:	6105                	addi	sp,sp,32
    80003382:	8082                	ret

0000000080003384 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003384:	1141                	addi	sp,sp,-16
    80003386:	e406                	sd	ra,8(sp)
    80003388:	e022                	sd	s0,0(sp)
    8000338a:	0800                	addi	s0,sp,16
    8000338c:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000338e:	4585                	li	a1,1
    80003390:	00000097          	auipc	ra,0x0
    80003394:	db4080e7          	jalr	-588(ra) # 80003144 <namex>
}
    80003398:	60a2                	ld	ra,8(sp)
    8000339a:	6402                	ld	s0,0(sp)
    8000339c:	0141                	addi	sp,sp,16
    8000339e:	8082                	ret

00000000800033a0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800033a0:	1101                	addi	sp,sp,-32
    800033a2:	ec06                	sd	ra,24(sp)
    800033a4:	e822                	sd	s0,16(sp)
    800033a6:	e426                	sd	s1,8(sp)
    800033a8:	e04a                	sd	s2,0(sp)
    800033aa:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800033ac:	00016917          	auipc	s2,0x16
    800033b0:	47490913          	addi	s2,s2,1140 # 80019820 <log>
    800033b4:	01892583          	lw	a1,24(s2)
    800033b8:	02892503          	lw	a0,40(s2)
    800033bc:	fffff097          	auipc	ra,0xfffff
    800033c0:	ff2080e7          	jalr	-14(ra) # 800023ae <bread>
    800033c4:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800033c6:	02c92683          	lw	a3,44(s2)
    800033ca:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800033cc:	02d05763          	blez	a3,800033fa <write_head+0x5a>
    800033d0:	00016797          	auipc	a5,0x16
    800033d4:	48078793          	addi	a5,a5,1152 # 80019850 <log+0x30>
    800033d8:	05c50713          	addi	a4,a0,92
    800033dc:	36fd                	addiw	a3,a3,-1
    800033de:	1682                	slli	a3,a3,0x20
    800033e0:	9281                	srli	a3,a3,0x20
    800033e2:	068a                	slli	a3,a3,0x2
    800033e4:	00016617          	auipc	a2,0x16
    800033e8:	47060613          	addi	a2,a2,1136 # 80019854 <log+0x34>
    800033ec:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800033ee:	4390                	lw	a2,0(a5)
    800033f0:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800033f2:	0791                	addi	a5,a5,4
    800033f4:	0711                	addi	a4,a4,4
    800033f6:	fed79ce3          	bne	a5,a3,800033ee <write_head+0x4e>
  }
  bwrite(buf);
    800033fa:	8526                	mv	a0,s1
    800033fc:	fffff097          	auipc	ra,0xfffff
    80003400:	0a4080e7          	jalr	164(ra) # 800024a0 <bwrite>
  brelse(buf);
    80003404:	8526                	mv	a0,s1
    80003406:	fffff097          	auipc	ra,0xfffff
    8000340a:	0d8080e7          	jalr	216(ra) # 800024de <brelse>
}
    8000340e:	60e2                	ld	ra,24(sp)
    80003410:	6442                	ld	s0,16(sp)
    80003412:	64a2                	ld	s1,8(sp)
    80003414:	6902                	ld	s2,0(sp)
    80003416:	6105                	addi	sp,sp,32
    80003418:	8082                	ret

000000008000341a <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000341a:	00016797          	auipc	a5,0x16
    8000341e:	4327a783          	lw	a5,1074(a5) # 8001984c <log+0x2c>
    80003422:	0af05d63          	blez	a5,800034dc <install_trans+0xc2>
{
    80003426:	7139                	addi	sp,sp,-64
    80003428:	fc06                	sd	ra,56(sp)
    8000342a:	f822                	sd	s0,48(sp)
    8000342c:	f426                	sd	s1,40(sp)
    8000342e:	f04a                	sd	s2,32(sp)
    80003430:	ec4e                	sd	s3,24(sp)
    80003432:	e852                	sd	s4,16(sp)
    80003434:	e456                	sd	s5,8(sp)
    80003436:	e05a                	sd	s6,0(sp)
    80003438:	0080                	addi	s0,sp,64
    8000343a:	8b2a                	mv	s6,a0
    8000343c:	00016a97          	auipc	s5,0x16
    80003440:	414a8a93          	addi	s5,s5,1044 # 80019850 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003444:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003446:	00016997          	auipc	s3,0x16
    8000344a:	3da98993          	addi	s3,s3,986 # 80019820 <log>
    8000344e:	a035                	j	8000347a <install_trans+0x60>
      bunpin(dbuf);
    80003450:	8526                	mv	a0,s1
    80003452:	fffff097          	auipc	ra,0xfffff
    80003456:	166080e7          	jalr	358(ra) # 800025b8 <bunpin>
    brelse(lbuf);
    8000345a:	854a                	mv	a0,s2
    8000345c:	fffff097          	auipc	ra,0xfffff
    80003460:	082080e7          	jalr	130(ra) # 800024de <brelse>
    brelse(dbuf);
    80003464:	8526                	mv	a0,s1
    80003466:	fffff097          	auipc	ra,0xfffff
    8000346a:	078080e7          	jalr	120(ra) # 800024de <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000346e:	2a05                	addiw	s4,s4,1
    80003470:	0a91                	addi	s5,s5,4
    80003472:	02c9a783          	lw	a5,44(s3)
    80003476:	04fa5963          	bge	s4,a5,800034c8 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000347a:	0189a583          	lw	a1,24(s3)
    8000347e:	014585bb          	addw	a1,a1,s4
    80003482:	2585                	addiw	a1,a1,1
    80003484:	0289a503          	lw	a0,40(s3)
    80003488:	fffff097          	auipc	ra,0xfffff
    8000348c:	f26080e7          	jalr	-218(ra) # 800023ae <bread>
    80003490:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003492:	000aa583          	lw	a1,0(s5)
    80003496:	0289a503          	lw	a0,40(s3)
    8000349a:	fffff097          	auipc	ra,0xfffff
    8000349e:	f14080e7          	jalr	-236(ra) # 800023ae <bread>
    800034a2:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800034a4:	40000613          	li	a2,1024
    800034a8:	05890593          	addi	a1,s2,88
    800034ac:	05850513          	addi	a0,a0,88
    800034b0:	ffffd097          	auipc	ra,0xffffd
    800034b4:	d72080e7          	jalr	-654(ra) # 80000222 <memmove>
    bwrite(dbuf);  // write dst to disk
    800034b8:	8526                	mv	a0,s1
    800034ba:	fffff097          	auipc	ra,0xfffff
    800034be:	fe6080e7          	jalr	-26(ra) # 800024a0 <bwrite>
    if(recovering == 0)
    800034c2:	f80b1ce3          	bnez	s6,8000345a <install_trans+0x40>
    800034c6:	b769                	j	80003450 <install_trans+0x36>
}
    800034c8:	70e2                	ld	ra,56(sp)
    800034ca:	7442                	ld	s0,48(sp)
    800034cc:	74a2                	ld	s1,40(sp)
    800034ce:	7902                	ld	s2,32(sp)
    800034d0:	69e2                	ld	s3,24(sp)
    800034d2:	6a42                	ld	s4,16(sp)
    800034d4:	6aa2                	ld	s5,8(sp)
    800034d6:	6b02                	ld	s6,0(sp)
    800034d8:	6121                	addi	sp,sp,64
    800034da:	8082                	ret
    800034dc:	8082                	ret

00000000800034de <initlog>:
{
    800034de:	7179                	addi	sp,sp,-48
    800034e0:	f406                	sd	ra,40(sp)
    800034e2:	f022                	sd	s0,32(sp)
    800034e4:	ec26                	sd	s1,24(sp)
    800034e6:	e84a                	sd	s2,16(sp)
    800034e8:	e44e                	sd	s3,8(sp)
    800034ea:	1800                	addi	s0,sp,48
    800034ec:	892a                	mv	s2,a0
    800034ee:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800034f0:	00016497          	auipc	s1,0x16
    800034f4:	33048493          	addi	s1,s1,816 # 80019820 <log>
    800034f8:	00005597          	auipc	a1,0x5
    800034fc:	25858593          	addi	a1,a1,600 # 80008750 <syscalls_name+0x1e8>
    80003500:	8526                	mv	a0,s1
    80003502:	00003097          	auipc	ra,0x3
    80003506:	c20080e7          	jalr	-992(ra) # 80006122 <initlock>
  log.start = sb->logstart;
    8000350a:	0149a583          	lw	a1,20(s3)
    8000350e:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003510:	0109a783          	lw	a5,16(s3)
    80003514:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003516:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000351a:	854a                	mv	a0,s2
    8000351c:	fffff097          	auipc	ra,0xfffff
    80003520:	e92080e7          	jalr	-366(ra) # 800023ae <bread>
  log.lh.n = lh->n;
    80003524:	4d3c                	lw	a5,88(a0)
    80003526:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003528:	02f05563          	blez	a5,80003552 <initlog+0x74>
    8000352c:	05c50713          	addi	a4,a0,92
    80003530:	00016697          	auipc	a3,0x16
    80003534:	32068693          	addi	a3,a3,800 # 80019850 <log+0x30>
    80003538:	37fd                	addiw	a5,a5,-1
    8000353a:	1782                	slli	a5,a5,0x20
    8000353c:	9381                	srli	a5,a5,0x20
    8000353e:	078a                	slli	a5,a5,0x2
    80003540:	06050613          	addi	a2,a0,96
    80003544:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003546:	4310                	lw	a2,0(a4)
    80003548:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    8000354a:	0711                	addi	a4,a4,4
    8000354c:	0691                	addi	a3,a3,4
    8000354e:	fef71ce3          	bne	a4,a5,80003546 <initlog+0x68>
  brelse(buf);
    80003552:	fffff097          	auipc	ra,0xfffff
    80003556:	f8c080e7          	jalr	-116(ra) # 800024de <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000355a:	4505                	li	a0,1
    8000355c:	00000097          	auipc	ra,0x0
    80003560:	ebe080e7          	jalr	-322(ra) # 8000341a <install_trans>
  log.lh.n = 0;
    80003564:	00016797          	auipc	a5,0x16
    80003568:	2e07a423          	sw	zero,744(a5) # 8001984c <log+0x2c>
  write_head(); // clear the log
    8000356c:	00000097          	auipc	ra,0x0
    80003570:	e34080e7          	jalr	-460(ra) # 800033a0 <write_head>
}
    80003574:	70a2                	ld	ra,40(sp)
    80003576:	7402                	ld	s0,32(sp)
    80003578:	64e2                	ld	s1,24(sp)
    8000357a:	6942                	ld	s2,16(sp)
    8000357c:	69a2                	ld	s3,8(sp)
    8000357e:	6145                	addi	sp,sp,48
    80003580:	8082                	ret

0000000080003582 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003582:	1101                	addi	sp,sp,-32
    80003584:	ec06                	sd	ra,24(sp)
    80003586:	e822                	sd	s0,16(sp)
    80003588:	e426                	sd	s1,8(sp)
    8000358a:	e04a                	sd	s2,0(sp)
    8000358c:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000358e:	00016517          	auipc	a0,0x16
    80003592:	29250513          	addi	a0,a0,658 # 80019820 <log>
    80003596:	00003097          	auipc	ra,0x3
    8000359a:	c1c080e7          	jalr	-996(ra) # 800061b2 <acquire>
  while(1){
    if(log.committing){
    8000359e:	00016497          	auipc	s1,0x16
    800035a2:	28248493          	addi	s1,s1,642 # 80019820 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035a6:	4979                	li	s2,30
    800035a8:	a039                	j	800035b6 <begin_op+0x34>
      sleep(&log, &log.lock);
    800035aa:	85a6                	mv	a1,s1
    800035ac:	8526                	mv	a0,s1
    800035ae:	ffffe097          	auipc	ra,0xffffe
    800035b2:	fb6080e7          	jalr	-74(ra) # 80001564 <sleep>
    if(log.committing){
    800035b6:	50dc                	lw	a5,36(s1)
    800035b8:	fbed                	bnez	a5,800035aa <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035ba:	509c                	lw	a5,32(s1)
    800035bc:	0017871b          	addiw	a4,a5,1
    800035c0:	0007069b          	sext.w	a3,a4
    800035c4:	0027179b          	slliw	a5,a4,0x2
    800035c8:	9fb9                	addw	a5,a5,a4
    800035ca:	0017979b          	slliw	a5,a5,0x1
    800035ce:	54d8                	lw	a4,44(s1)
    800035d0:	9fb9                	addw	a5,a5,a4
    800035d2:	00f95963          	bge	s2,a5,800035e4 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800035d6:	85a6                	mv	a1,s1
    800035d8:	8526                	mv	a0,s1
    800035da:	ffffe097          	auipc	ra,0xffffe
    800035de:	f8a080e7          	jalr	-118(ra) # 80001564 <sleep>
    800035e2:	bfd1                	j	800035b6 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800035e4:	00016517          	auipc	a0,0x16
    800035e8:	23c50513          	addi	a0,a0,572 # 80019820 <log>
    800035ec:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800035ee:	00003097          	auipc	ra,0x3
    800035f2:	c78080e7          	jalr	-904(ra) # 80006266 <release>
      break;
    }
  }
}
    800035f6:	60e2                	ld	ra,24(sp)
    800035f8:	6442                	ld	s0,16(sp)
    800035fa:	64a2                	ld	s1,8(sp)
    800035fc:	6902                	ld	s2,0(sp)
    800035fe:	6105                	addi	sp,sp,32
    80003600:	8082                	ret

0000000080003602 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003602:	7139                	addi	sp,sp,-64
    80003604:	fc06                	sd	ra,56(sp)
    80003606:	f822                	sd	s0,48(sp)
    80003608:	f426                	sd	s1,40(sp)
    8000360a:	f04a                	sd	s2,32(sp)
    8000360c:	ec4e                	sd	s3,24(sp)
    8000360e:	e852                	sd	s4,16(sp)
    80003610:	e456                	sd	s5,8(sp)
    80003612:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003614:	00016497          	auipc	s1,0x16
    80003618:	20c48493          	addi	s1,s1,524 # 80019820 <log>
    8000361c:	8526                	mv	a0,s1
    8000361e:	00003097          	auipc	ra,0x3
    80003622:	b94080e7          	jalr	-1132(ra) # 800061b2 <acquire>
  log.outstanding -= 1;
    80003626:	509c                	lw	a5,32(s1)
    80003628:	37fd                	addiw	a5,a5,-1
    8000362a:	0007891b          	sext.w	s2,a5
    8000362e:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003630:	50dc                	lw	a5,36(s1)
    80003632:	efb9                	bnez	a5,80003690 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003634:	06091663          	bnez	s2,800036a0 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80003638:	00016497          	auipc	s1,0x16
    8000363c:	1e848493          	addi	s1,s1,488 # 80019820 <log>
    80003640:	4785                	li	a5,1
    80003642:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003644:	8526                	mv	a0,s1
    80003646:	00003097          	auipc	ra,0x3
    8000364a:	c20080e7          	jalr	-992(ra) # 80006266 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000364e:	54dc                	lw	a5,44(s1)
    80003650:	06f04763          	bgtz	a5,800036be <end_op+0xbc>
    acquire(&log.lock);
    80003654:	00016497          	auipc	s1,0x16
    80003658:	1cc48493          	addi	s1,s1,460 # 80019820 <log>
    8000365c:	8526                	mv	a0,s1
    8000365e:	00003097          	auipc	ra,0x3
    80003662:	b54080e7          	jalr	-1196(ra) # 800061b2 <acquire>
    log.committing = 0;
    80003666:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000366a:	8526                	mv	a0,s1
    8000366c:	ffffe097          	auipc	ra,0xffffe
    80003670:	084080e7          	jalr	132(ra) # 800016f0 <wakeup>
    release(&log.lock);
    80003674:	8526                	mv	a0,s1
    80003676:	00003097          	auipc	ra,0x3
    8000367a:	bf0080e7          	jalr	-1040(ra) # 80006266 <release>
}
    8000367e:	70e2                	ld	ra,56(sp)
    80003680:	7442                	ld	s0,48(sp)
    80003682:	74a2                	ld	s1,40(sp)
    80003684:	7902                	ld	s2,32(sp)
    80003686:	69e2                	ld	s3,24(sp)
    80003688:	6a42                	ld	s4,16(sp)
    8000368a:	6aa2                	ld	s5,8(sp)
    8000368c:	6121                	addi	sp,sp,64
    8000368e:	8082                	ret
    panic("log.committing");
    80003690:	00005517          	auipc	a0,0x5
    80003694:	0c850513          	addi	a0,a0,200 # 80008758 <syscalls_name+0x1f0>
    80003698:	00002097          	auipc	ra,0x2
    8000369c:	5d0080e7          	jalr	1488(ra) # 80005c68 <panic>
    wakeup(&log);
    800036a0:	00016497          	auipc	s1,0x16
    800036a4:	18048493          	addi	s1,s1,384 # 80019820 <log>
    800036a8:	8526                	mv	a0,s1
    800036aa:	ffffe097          	auipc	ra,0xffffe
    800036ae:	046080e7          	jalr	70(ra) # 800016f0 <wakeup>
  release(&log.lock);
    800036b2:	8526                	mv	a0,s1
    800036b4:	00003097          	auipc	ra,0x3
    800036b8:	bb2080e7          	jalr	-1102(ra) # 80006266 <release>
  if(do_commit){
    800036bc:	b7c9                	j	8000367e <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036be:	00016a97          	auipc	s5,0x16
    800036c2:	192a8a93          	addi	s5,s5,402 # 80019850 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800036c6:	00016a17          	auipc	s4,0x16
    800036ca:	15aa0a13          	addi	s4,s4,346 # 80019820 <log>
    800036ce:	018a2583          	lw	a1,24(s4)
    800036d2:	012585bb          	addw	a1,a1,s2
    800036d6:	2585                	addiw	a1,a1,1
    800036d8:	028a2503          	lw	a0,40(s4)
    800036dc:	fffff097          	auipc	ra,0xfffff
    800036e0:	cd2080e7          	jalr	-814(ra) # 800023ae <bread>
    800036e4:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800036e6:	000aa583          	lw	a1,0(s5)
    800036ea:	028a2503          	lw	a0,40(s4)
    800036ee:	fffff097          	auipc	ra,0xfffff
    800036f2:	cc0080e7          	jalr	-832(ra) # 800023ae <bread>
    800036f6:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800036f8:	40000613          	li	a2,1024
    800036fc:	05850593          	addi	a1,a0,88
    80003700:	05848513          	addi	a0,s1,88
    80003704:	ffffd097          	auipc	ra,0xffffd
    80003708:	b1e080e7          	jalr	-1250(ra) # 80000222 <memmove>
    bwrite(to);  // write the log
    8000370c:	8526                	mv	a0,s1
    8000370e:	fffff097          	auipc	ra,0xfffff
    80003712:	d92080e7          	jalr	-622(ra) # 800024a0 <bwrite>
    brelse(from);
    80003716:	854e                	mv	a0,s3
    80003718:	fffff097          	auipc	ra,0xfffff
    8000371c:	dc6080e7          	jalr	-570(ra) # 800024de <brelse>
    brelse(to);
    80003720:	8526                	mv	a0,s1
    80003722:	fffff097          	auipc	ra,0xfffff
    80003726:	dbc080e7          	jalr	-580(ra) # 800024de <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000372a:	2905                	addiw	s2,s2,1
    8000372c:	0a91                	addi	s5,s5,4
    8000372e:	02ca2783          	lw	a5,44(s4)
    80003732:	f8f94ee3          	blt	s2,a5,800036ce <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003736:	00000097          	auipc	ra,0x0
    8000373a:	c6a080e7          	jalr	-918(ra) # 800033a0 <write_head>
    install_trans(0); // Now install writes to home locations
    8000373e:	4501                	li	a0,0
    80003740:	00000097          	auipc	ra,0x0
    80003744:	cda080e7          	jalr	-806(ra) # 8000341a <install_trans>
    log.lh.n = 0;
    80003748:	00016797          	auipc	a5,0x16
    8000374c:	1007a223          	sw	zero,260(a5) # 8001984c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003750:	00000097          	auipc	ra,0x0
    80003754:	c50080e7          	jalr	-944(ra) # 800033a0 <write_head>
    80003758:	bdf5                	j	80003654 <end_op+0x52>

000000008000375a <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000375a:	1101                	addi	sp,sp,-32
    8000375c:	ec06                	sd	ra,24(sp)
    8000375e:	e822                	sd	s0,16(sp)
    80003760:	e426                	sd	s1,8(sp)
    80003762:	e04a                	sd	s2,0(sp)
    80003764:	1000                	addi	s0,sp,32
    80003766:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003768:	00016917          	auipc	s2,0x16
    8000376c:	0b890913          	addi	s2,s2,184 # 80019820 <log>
    80003770:	854a                	mv	a0,s2
    80003772:	00003097          	auipc	ra,0x3
    80003776:	a40080e7          	jalr	-1472(ra) # 800061b2 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000377a:	02c92603          	lw	a2,44(s2)
    8000377e:	47f5                	li	a5,29
    80003780:	06c7c563          	blt	a5,a2,800037ea <log_write+0x90>
    80003784:	00016797          	auipc	a5,0x16
    80003788:	0b87a783          	lw	a5,184(a5) # 8001983c <log+0x1c>
    8000378c:	37fd                	addiw	a5,a5,-1
    8000378e:	04f65e63          	bge	a2,a5,800037ea <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003792:	00016797          	auipc	a5,0x16
    80003796:	0ae7a783          	lw	a5,174(a5) # 80019840 <log+0x20>
    8000379a:	06f05063          	blez	a5,800037fa <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000379e:	4781                	li	a5,0
    800037a0:	06c05563          	blez	a2,8000380a <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037a4:	44cc                	lw	a1,12(s1)
    800037a6:	00016717          	auipc	a4,0x16
    800037aa:	0aa70713          	addi	a4,a4,170 # 80019850 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037ae:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037b0:	4314                	lw	a3,0(a4)
    800037b2:	04b68c63          	beq	a3,a1,8000380a <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800037b6:	2785                	addiw	a5,a5,1
    800037b8:	0711                	addi	a4,a4,4
    800037ba:	fef61be3          	bne	a2,a5,800037b0 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800037be:	0621                	addi	a2,a2,8
    800037c0:	060a                	slli	a2,a2,0x2
    800037c2:	00016797          	auipc	a5,0x16
    800037c6:	05e78793          	addi	a5,a5,94 # 80019820 <log>
    800037ca:	963e                	add	a2,a2,a5
    800037cc:	44dc                	lw	a5,12(s1)
    800037ce:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800037d0:	8526                	mv	a0,s1
    800037d2:	fffff097          	auipc	ra,0xfffff
    800037d6:	daa080e7          	jalr	-598(ra) # 8000257c <bpin>
    log.lh.n++;
    800037da:	00016717          	auipc	a4,0x16
    800037de:	04670713          	addi	a4,a4,70 # 80019820 <log>
    800037e2:	575c                	lw	a5,44(a4)
    800037e4:	2785                	addiw	a5,a5,1
    800037e6:	d75c                	sw	a5,44(a4)
    800037e8:	a835                	j	80003824 <log_write+0xca>
    panic("too big a transaction");
    800037ea:	00005517          	auipc	a0,0x5
    800037ee:	f7e50513          	addi	a0,a0,-130 # 80008768 <syscalls_name+0x200>
    800037f2:	00002097          	auipc	ra,0x2
    800037f6:	476080e7          	jalr	1142(ra) # 80005c68 <panic>
    panic("log_write outside of trans");
    800037fa:	00005517          	auipc	a0,0x5
    800037fe:	f8650513          	addi	a0,a0,-122 # 80008780 <syscalls_name+0x218>
    80003802:	00002097          	auipc	ra,0x2
    80003806:	466080e7          	jalr	1126(ra) # 80005c68 <panic>
  log.lh.block[i] = b->blockno;
    8000380a:	00878713          	addi	a4,a5,8
    8000380e:	00271693          	slli	a3,a4,0x2
    80003812:	00016717          	auipc	a4,0x16
    80003816:	00e70713          	addi	a4,a4,14 # 80019820 <log>
    8000381a:	9736                	add	a4,a4,a3
    8000381c:	44d4                	lw	a3,12(s1)
    8000381e:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003820:	faf608e3          	beq	a2,a5,800037d0 <log_write+0x76>
  }
  release(&log.lock);
    80003824:	00016517          	auipc	a0,0x16
    80003828:	ffc50513          	addi	a0,a0,-4 # 80019820 <log>
    8000382c:	00003097          	auipc	ra,0x3
    80003830:	a3a080e7          	jalr	-1478(ra) # 80006266 <release>
}
    80003834:	60e2                	ld	ra,24(sp)
    80003836:	6442                	ld	s0,16(sp)
    80003838:	64a2                	ld	s1,8(sp)
    8000383a:	6902                	ld	s2,0(sp)
    8000383c:	6105                	addi	sp,sp,32
    8000383e:	8082                	ret

0000000080003840 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003840:	1101                	addi	sp,sp,-32
    80003842:	ec06                	sd	ra,24(sp)
    80003844:	e822                	sd	s0,16(sp)
    80003846:	e426                	sd	s1,8(sp)
    80003848:	e04a                	sd	s2,0(sp)
    8000384a:	1000                	addi	s0,sp,32
    8000384c:	84aa                	mv	s1,a0
    8000384e:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003850:	00005597          	auipc	a1,0x5
    80003854:	f5058593          	addi	a1,a1,-176 # 800087a0 <syscalls_name+0x238>
    80003858:	0521                	addi	a0,a0,8
    8000385a:	00003097          	auipc	ra,0x3
    8000385e:	8c8080e7          	jalr	-1848(ra) # 80006122 <initlock>
  lk->name = name;
    80003862:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003866:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000386a:	0204a423          	sw	zero,40(s1)
}
    8000386e:	60e2                	ld	ra,24(sp)
    80003870:	6442                	ld	s0,16(sp)
    80003872:	64a2                	ld	s1,8(sp)
    80003874:	6902                	ld	s2,0(sp)
    80003876:	6105                	addi	sp,sp,32
    80003878:	8082                	ret

000000008000387a <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000387a:	1101                	addi	sp,sp,-32
    8000387c:	ec06                	sd	ra,24(sp)
    8000387e:	e822                	sd	s0,16(sp)
    80003880:	e426                	sd	s1,8(sp)
    80003882:	e04a                	sd	s2,0(sp)
    80003884:	1000                	addi	s0,sp,32
    80003886:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003888:	00850913          	addi	s2,a0,8
    8000388c:	854a                	mv	a0,s2
    8000388e:	00003097          	auipc	ra,0x3
    80003892:	924080e7          	jalr	-1756(ra) # 800061b2 <acquire>
  while (lk->locked) {
    80003896:	409c                	lw	a5,0(s1)
    80003898:	cb89                	beqz	a5,800038aa <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000389a:	85ca                	mv	a1,s2
    8000389c:	8526                	mv	a0,s1
    8000389e:	ffffe097          	auipc	ra,0xffffe
    800038a2:	cc6080e7          	jalr	-826(ra) # 80001564 <sleep>
  while (lk->locked) {
    800038a6:	409c                	lw	a5,0(s1)
    800038a8:	fbed                	bnez	a5,8000389a <acquiresleep+0x20>
  }
  lk->locked = 1;
    800038aa:	4785                	li	a5,1
    800038ac:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038ae:	ffffd097          	auipc	ra,0xffffd
    800038b2:	5e4080e7          	jalr	1508(ra) # 80000e92 <myproc>
    800038b6:	591c                	lw	a5,48(a0)
    800038b8:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800038ba:	854a                	mv	a0,s2
    800038bc:	00003097          	auipc	ra,0x3
    800038c0:	9aa080e7          	jalr	-1622(ra) # 80006266 <release>
}
    800038c4:	60e2                	ld	ra,24(sp)
    800038c6:	6442                	ld	s0,16(sp)
    800038c8:	64a2                	ld	s1,8(sp)
    800038ca:	6902                	ld	s2,0(sp)
    800038cc:	6105                	addi	sp,sp,32
    800038ce:	8082                	ret

00000000800038d0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800038d0:	1101                	addi	sp,sp,-32
    800038d2:	ec06                	sd	ra,24(sp)
    800038d4:	e822                	sd	s0,16(sp)
    800038d6:	e426                	sd	s1,8(sp)
    800038d8:	e04a                	sd	s2,0(sp)
    800038da:	1000                	addi	s0,sp,32
    800038dc:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038de:	00850913          	addi	s2,a0,8
    800038e2:	854a                	mv	a0,s2
    800038e4:	00003097          	auipc	ra,0x3
    800038e8:	8ce080e7          	jalr	-1842(ra) # 800061b2 <acquire>
  lk->locked = 0;
    800038ec:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038f0:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800038f4:	8526                	mv	a0,s1
    800038f6:	ffffe097          	auipc	ra,0xffffe
    800038fa:	dfa080e7          	jalr	-518(ra) # 800016f0 <wakeup>
  release(&lk->lk);
    800038fe:	854a                	mv	a0,s2
    80003900:	00003097          	auipc	ra,0x3
    80003904:	966080e7          	jalr	-1690(ra) # 80006266 <release>
}
    80003908:	60e2                	ld	ra,24(sp)
    8000390a:	6442                	ld	s0,16(sp)
    8000390c:	64a2                	ld	s1,8(sp)
    8000390e:	6902                	ld	s2,0(sp)
    80003910:	6105                	addi	sp,sp,32
    80003912:	8082                	ret

0000000080003914 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003914:	7179                	addi	sp,sp,-48
    80003916:	f406                	sd	ra,40(sp)
    80003918:	f022                	sd	s0,32(sp)
    8000391a:	ec26                	sd	s1,24(sp)
    8000391c:	e84a                	sd	s2,16(sp)
    8000391e:	e44e                	sd	s3,8(sp)
    80003920:	1800                	addi	s0,sp,48
    80003922:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003924:	00850913          	addi	s2,a0,8
    80003928:	854a                	mv	a0,s2
    8000392a:	00003097          	auipc	ra,0x3
    8000392e:	888080e7          	jalr	-1912(ra) # 800061b2 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003932:	409c                	lw	a5,0(s1)
    80003934:	ef99                	bnez	a5,80003952 <holdingsleep+0x3e>
    80003936:	4481                	li	s1,0
  release(&lk->lk);
    80003938:	854a                	mv	a0,s2
    8000393a:	00003097          	auipc	ra,0x3
    8000393e:	92c080e7          	jalr	-1748(ra) # 80006266 <release>
  return r;
}
    80003942:	8526                	mv	a0,s1
    80003944:	70a2                	ld	ra,40(sp)
    80003946:	7402                	ld	s0,32(sp)
    80003948:	64e2                	ld	s1,24(sp)
    8000394a:	6942                	ld	s2,16(sp)
    8000394c:	69a2                	ld	s3,8(sp)
    8000394e:	6145                	addi	sp,sp,48
    80003950:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003952:	0284a983          	lw	s3,40(s1)
    80003956:	ffffd097          	auipc	ra,0xffffd
    8000395a:	53c080e7          	jalr	1340(ra) # 80000e92 <myproc>
    8000395e:	5904                	lw	s1,48(a0)
    80003960:	413484b3          	sub	s1,s1,s3
    80003964:	0014b493          	seqz	s1,s1
    80003968:	bfc1                	j	80003938 <holdingsleep+0x24>

000000008000396a <fileinit>:
  struct spinlock lock;
  struct file file[NFILE];
} ftable;

void fileinit(void)
{
    8000396a:	1141                	addi	sp,sp,-16
    8000396c:	e406                	sd	ra,8(sp)
    8000396e:	e022                	sd	s0,0(sp)
    80003970:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003972:	00005597          	auipc	a1,0x5
    80003976:	e3e58593          	addi	a1,a1,-450 # 800087b0 <syscalls_name+0x248>
    8000397a:	00016517          	auipc	a0,0x16
    8000397e:	fee50513          	addi	a0,a0,-18 # 80019968 <ftable>
    80003982:	00002097          	auipc	ra,0x2
    80003986:	7a0080e7          	jalr	1952(ra) # 80006122 <initlock>
}
    8000398a:	60a2                	ld	ra,8(sp)
    8000398c:	6402                	ld	s0,0(sp)
    8000398e:	0141                	addi	sp,sp,16
    80003990:	8082                	ret

0000000080003992 <filealloc>:

// Allocate a file structure.
struct file *
filealloc(void)
{
    80003992:	1101                	addi	sp,sp,-32
    80003994:	ec06                	sd	ra,24(sp)
    80003996:	e822                	sd	s0,16(sp)
    80003998:	e426                	sd	s1,8(sp)
    8000399a:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000399c:	00016517          	auipc	a0,0x16
    800039a0:	fcc50513          	addi	a0,a0,-52 # 80019968 <ftable>
    800039a4:	00003097          	auipc	ra,0x3
    800039a8:	80e080e7          	jalr	-2034(ra) # 800061b2 <acquire>
  for (f = ftable.file; f < ftable.file + NFILE; f++)
    800039ac:	00016497          	auipc	s1,0x16
    800039b0:	fd448493          	addi	s1,s1,-44 # 80019980 <ftable+0x18>
    800039b4:	00017717          	auipc	a4,0x17
    800039b8:	f6c70713          	addi	a4,a4,-148 # 8001a920 <ftable+0xfb8>
  {
    if (f->ref == 0)
    800039bc:	40dc                	lw	a5,4(s1)
    800039be:	cf99                	beqz	a5,800039dc <filealloc+0x4a>
  for (f = ftable.file; f < ftable.file + NFILE; f++)
    800039c0:	02848493          	addi	s1,s1,40
    800039c4:	fee49ce3          	bne	s1,a4,800039bc <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800039c8:	00016517          	auipc	a0,0x16
    800039cc:	fa050513          	addi	a0,a0,-96 # 80019968 <ftable>
    800039d0:	00003097          	auipc	ra,0x3
    800039d4:	896080e7          	jalr	-1898(ra) # 80006266 <release>
  return 0;
    800039d8:	4481                	li	s1,0
    800039da:	a819                	j	800039f0 <filealloc+0x5e>
      f->ref = 1;
    800039dc:	4785                	li	a5,1
    800039de:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800039e0:	00016517          	auipc	a0,0x16
    800039e4:	f8850513          	addi	a0,a0,-120 # 80019968 <ftable>
    800039e8:	00003097          	auipc	ra,0x3
    800039ec:	87e080e7          	jalr	-1922(ra) # 80006266 <release>
}
    800039f0:	8526                	mv	a0,s1
    800039f2:	60e2                	ld	ra,24(sp)
    800039f4:	6442                	ld	s0,16(sp)
    800039f6:	64a2                	ld	s1,8(sp)
    800039f8:	6105                	addi	sp,sp,32
    800039fa:	8082                	ret

00000000800039fc <filedup>:

// Increment ref count for file f.
struct file *
filedup(struct file *f)
{
    800039fc:	1101                	addi	sp,sp,-32
    800039fe:	ec06                	sd	ra,24(sp)
    80003a00:	e822                	sd	s0,16(sp)
    80003a02:	e426                	sd	s1,8(sp)
    80003a04:	1000                	addi	s0,sp,32
    80003a06:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a08:	00016517          	auipc	a0,0x16
    80003a0c:	f6050513          	addi	a0,a0,-160 # 80019968 <ftable>
    80003a10:	00002097          	auipc	ra,0x2
    80003a14:	7a2080e7          	jalr	1954(ra) # 800061b2 <acquire>
  if (f->ref < 1)
    80003a18:	40dc                	lw	a5,4(s1)
    80003a1a:	02f05263          	blez	a5,80003a3e <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a1e:	2785                	addiw	a5,a5,1
    80003a20:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a22:	00016517          	auipc	a0,0x16
    80003a26:	f4650513          	addi	a0,a0,-186 # 80019968 <ftable>
    80003a2a:	00003097          	auipc	ra,0x3
    80003a2e:	83c080e7          	jalr	-1988(ra) # 80006266 <release>
  return f;
}
    80003a32:	8526                	mv	a0,s1
    80003a34:	60e2                	ld	ra,24(sp)
    80003a36:	6442                	ld	s0,16(sp)
    80003a38:	64a2                	ld	s1,8(sp)
    80003a3a:	6105                	addi	sp,sp,32
    80003a3c:	8082                	ret
    panic("filedup");
    80003a3e:	00005517          	auipc	a0,0x5
    80003a42:	d7a50513          	addi	a0,a0,-646 # 800087b8 <syscalls_name+0x250>
    80003a46:	00002097          	auipc	ra,0x2
    80003a4a:	222080e7          	jalr	546(ra) # 80005c68 <panic>

0000000080003a4e <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void fileclose(struct file *f)
{
    80003a4e:	7139                	addi	sp,sp,-64
    80003a50:	fc06                	sd	ra,56(sp)
    80003a52:	f822                	sd	s0,48(sp)
    80003a54:	f426                	sd	s1,40(sp)
    80003a56:	f04a                	sd	s2,32(sp)
    80003a58:	ec4e                	sd	s3,24(sp)
    80003a5a:	e852                	sd	s4,16(sp)
    80003a5c:	e456                	sd	s5,8(sp)
    80003a5e:	0080                	addi	s0,sp,64
    80003a60:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a62:	00016517          	auipc	a0,0x16
    80003a66:	f0650513          	addi	a0,a0,-250 # 80019968 <ftable>
    80003a6a:	00002097          	auipc	ra,0x2
    80003a6e:	748080e7          	jalr	1864(ra) # 800061b2 <acquire>
  if (f->ref < 1)
    80003a72:	40dc                	lw	a5,4(s1)
    80003a74:	06f05163          	blez	a5,80003ad6 <fileclose+0x88>
    panic("fileclose");
  if (--f->ref > 0)
    80003a78:	37fd                	addiw	a5,a5,-1
    80003a7a:	0007871b          	sext.w	a4,a5
    80003a7e:	c0dc                	sw	a5,4(s1)
    80003a80:	06e04363          	bgtz	a4,80003ae6 <fileclose+0x98>
  {
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003a84:	0004a903          	lw	s2,0(s1)
    80003a88:	0094ca83          	lbu	s5,9(s1)
    80003a8c:	0104ba03          	ld	s4,16(s1)
    80003a90:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003a94:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003a98:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003a9c:	00016517          	auipc	a0,0x16
    80003aa0:	ecc50513          	addi	a0,a0,-308 # 80019968 <ftable>
    80003aa4:	00002097          	auipc	ra,0x2
    80003aa8:	7c2080e7          	jalr	1986(ra) # 80006266 <release>

  if (ff.type == FD_PIPE)
    80003aac:	4785                	li	a5,1
    80003aae:	04f90d63          	beq	s2,a5,80003b08 <fileclose+0xba>
  {
    pipeclose(ff.pipe, ff.writable);
  }
  else if (ff.type == FD_INODE || ff.type == FD_DEVICE)
    80003ab2:	3979                	addiw	s2,s2,-2
    80003ab4:	4785                	li	a5,1
    80003ab6:	0527e063          	bltu	a5,s2,80003af6 <fileclose+0xa8>
  {
    begin_op();
    80003aba:	00000097          	auipc	ra,0x0
    80003abe:	ac8080e7          	jalr	-1336(ra) # 80003582 <begin_op>
    iput(ff.ip);
    80003ac2:	854e                	mv	a0,s3
    80003ac4:	fffff097          	auipc	ra,0xfffff
    80003ac8:	2a6080e7          	jalr	678(ra) # 80002d6a <iput>
    end_op();
    80003acc:	00000097          	auipc	ra,0x0
    80003ad0:	b36080e7          	jalr	-1226(ra) # 80003602 <end_op>
    80003ad4:	a00d                	j	80003af6 <fileclose+0xa8>
    panic("fileclose");
    80003ad6:	00005517          	auipc	a0,0x5
    80003ada:	cea50513          	addi	a0,a0,-790 # 800087c0 <syscalls_name+0x258>
    80003ade:	00002097          	auipc	ra,0x2
    80003ae2:	18a080e7          	jalr	394(ra) # 80005c68 <panic>
    release(&ftable.lock);
    80003ae6:	00016517          	auipc	a0,0x16
    80003aea:	e8250513          	addi	a0,a0,-382 # 80019968 <ftable>
    80003aee:	00002097          	auipc	ra,0x2
    80003af2:	778080e7          	jalr	1912(ra) # 80006266 <release>
  }
}
    80003af6:	70e2                	ld	ra,56(sp)
    80003af8:	7442                	ld	s0,48(sp)
    80003afa:	74a2                	ld	s1,40(sp)
    80003afc:	7902                	ld	s2,32(sp)
    80003afe:	69e2                	ld	s3,24(sp)
    80003b00:	6a42                	ld	s4,16(sp)
    80003b02:	6aa2                	ld	s5,8(sp)
    80003b04:	6121                	addi	sp,sp,64
    80003b06:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b08:	85d6                	mv	a1,s5
    80003b0a:	8552                	mv	a0,s4
    80003b0c:	00000097          	auipc	ra,0x0
    80003b10:	34c080e7          	jalr	844(ra) # 80003e58 <pipeclose>
    80003b14:	b7cd                	j	80003af6 <fileclose+0xa8>

0000000080003b16 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int filestat(struct file *f, uint64 addr)
{
    80003b16:	715d                	addi	sp,sp,-80
    80003b18:	e486                	sd	ra,72(sp)
    80003b1a:	e0a2                	sd	s0,64(sp)
    80003b1c:	fc26                	sd	s1,56(sp)
    80003b1e:	f84a                	sd	s2,48(sp)
    80003b20:	f44e                	sd	s3,40(sp)
    80003b22:	0880                	addi	s0,sp,80
    80003b24:	84aa                	mv	s1,a0
    80003b26:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b28:	ffffd097          	auipc	ra,0xffffd
    80003b2c:	36a080e7          	jalr	874(ra) # 80000e92 <myproc>
  struct stat st;

  if (f->type == FD_INODE || f->type == FD_DEVICE)
    80003b30:	409c                	lw	a5,0(s1)
    80003b32:	37f9                	addiw	a5,a5,-2
    80003b34:	4705                	li	a4,1
    80003b36:	04f76763          	bltu	a4,a5,80003b84 <filestat+0x6e>
    80003b3a:	892a                	mv	s2,a0
  {
    ilock(f->ip);
    80003b3c:	6c88                	ld	a0,24(s1)
    80003b3e:	fffff097          	auipc	ra,0xfffff
    80003b42:	072080e7          	jalr	114(ra) # 80002bb0 <ilock>
    stati(f->ip, &st);
    80003b46:	fb840593          	addi	a1,s0,-72
    80003b4a:	6c88                	ld	a0,24(s1)
    80003b4c:	fffff097          	auipc	ra,0xfffff
    80003b50:	2ee080e7          	jalr	750(ra) # 80002e3a <stati>
    iunlock(f->ip);
    80003b54:	6c88                	ld	a0,24(s1)
    80003b56:	fffff097          	auipc	ra,0xfffff
    80003b5a:	11c080e7          	jalr	284(ra) # 80002c72 <iunlock>
    if (copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b5e:	46e1                	li	a3,24
    80003b60:	fb840613          	addi	a2,s0,-72
    80003b64:	85ce                	mv	a1,s3
    80003b66:	05893503          	ld	a0,88(s2)
    80003b6a:	ffffd097          	auipc	ra,0xffffd
    80003b6e:	fea080e7          	jalr	-22(ra) # 80000b54 <copyout>
    80003b72:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003b76:	60a6                	ld	ra,72(sp)
    80003b78:	6406                	ld	s0,64(sp)
    80003b7a:	74e2                	ld	s1,56(sp)
    80003b7c:	7942                	ld	s2,48(sp)
    80003b7e:	79a2                	ld	s3,40(sp)
    80003b80:	6161                	addi	sp,sp,80
    80003b82:	8082                	ret
  return -1;
    80003b84:	557d                	li	a0,-1
    80003b86:	bfc5                	j	80003b76 <filestat+0x60>

0000000080003b88 <fileread>:

// Read from file f.
// addr is a user virtual address.
int fileread(struct file *f, uint64 addr, int n)
{
    80003b88:	7179                	addi	sp,sp,-48
    80003b8a:	f406                	sd	ra,40(sp)
    80003b8c:	f022                	sd	s0,32(sp)
    80003b8e:	ec26                	sd	s1,24(sp)
    80003b90:	e84a                	sd	s2,16(sp)
    80003b92:	e44e                	sd	s3,8(sp)
    80003b94:	1800                	addi	s0,sp,48
  int r = 0;

  if (f->readable == 0)
    80003b96:	00854783          	lbu	a5,8(a0)
    80003b9a:	c3d5                	beqz	a5,80003c3e <fileread+0xb6>
    80003b9c:	84aa                	mv	s1,a0
    80003b9e:	89ae                	mv	s3,a1
    80003ba0:	8932                	mv	s2,a2
    return -1;

  if (f->type == FD_PIPE)
    80003ba2:	411c                	lw	a5,0(a0)
    80003ba4:	4705                	li	a4,1
    80003ba6:	04e78963          	beq	a5,a4,80003bf8 <fileread+0x70>
  {
    r = piperead(f->pipe, addr, n);
  }
  else if (f->type == FD_DEVICE)
    80003baa:	470d                	li	a4,3
    80003bac:	04e78d63          	beq	a5,a4,80003c06 <fileread+0x7e>
  {
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  }
  else if (f->type == FD_INODE)
    80003bb0:	4709                	li	a4,2
    80003bb2:	06e79e63          	bne	a5,a4,80003c2e <fileread+0xa6>
  {
    ilock(f->ip);
    80003bb6:	6d08                	ld	a0,24(a0)
    80003bb8:	fffff097          	auipc	ra,0xfffff
    80003bbc:	ff8080e7          	jalr	-8(ra) # 80002bb0 <ilock>
    if ((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003bc0:	874a                	mv	a4,s2
    80003bc2:	5094                	lw	a3,32(s1)
    80003bc4:	864e                	mv	a2,s3
    80003bc6:	4585                	li	a1,1
    80003bc8:	6c88                	ld	a0,24(s1)
    80003bca:	fffff097          	auipc	ra,0xfffff
    80003bce:	29a080e7          	jalr	666(ra) # 80002e64 <readi>
    80003bd2:	892a                	mv	s2,a0
    80003bd4:	00a05563          	blez	a0,80003bde <fileread+0x56>
      f->off += r;
    80003bd8:	509c                	lw	a5,32(s1)
    80003bda:	9fa9                	addw	a5,a5,a0
    80003bdc:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003bde:	6c88                	ld	a0,24(s1)
    80003be0:	fffff097          	auipc	ra,0xfffff
    80003be4:	092080e7          	jalr	146(ra) # 80002c72 <iunlock>
  {
    panic("fileread");
  }

  return r;
}
    80003be8:	854a                	mv	a0,s2
    80003bea:	70a2                	ld	ra,40(sp)
    80003bec:	7402                	ld	s0,32(sp)
    80003bee:	64e2                	ld	s1,24(sp)
    80003bf0:	6942                	ld	s2,16(sp)
    80003bf2:	69a2                	ld	s3,8(sp)
    80003bf4:	6145                	addi	sp,sp,48
    80003bf6:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003bf8:	6908                	ld	a0,16(a0)
    80003bfa:	00000097          	auipc	ra,0x0
    80003bfe:	3c8080e7          	jalr	968(ra) # 80003fc2 <piperead>
    80003c02:	892a                	mv	s2,a0
    80003c04:	b7d5                	j	80003be8 <fileread+0x60>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c06:	02451783          	lh	a5,36(a0)
    80003c0a:	03079693          	slli	a3,a5,0x30
    80003c0e:	92c1                	srli	a3,a3,0x30
    80003c10:	4725                	li	a4,9
    80003c12:	02d76863          	bltu	a4,a3,80003c42 <fileread+0xba>
    80003c16:	0792                	slli	a5,a5,0x4
    80003c18:	00016717          	auipc	a4,0x16
    80003c1c:	cb070713          	addi	a4,a4,-848 # 800198c8 <devsw>
    80003c20:	97ba                	add	a5,a5,a4
    80003c22:	639c                	ld	a5,0(a5)
    80003c24:	c38d                	beqz	a5,80003c46 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c26:	4505                	li	a0,1
    80003c28:	9782                	jalr	a5
    80003c2a:	892a                	mv	s2,a0
    80003c2c:	bf75                	j	80003be8 <fileread+0x60>
    panic("fileread");
    80003c2e:	00005517          	auipc	a0,0x5
    80003c32:	ba250513          	addi	a0,a0,-1118 # 800087d0 <syscalls_name+0x268>
    80003c36:	00002097          	auipc	ra,0x2
    80003c3a:	032080e7          	jalr	50(ra) # 80005c68 <panic>
    return -1;
    80003c3e:	597d                	li	s2,-1
    80003c40:	b765                	j	80003be8 <fileread+0x60>
      return -1;
    80003c42:	597d                	li	s2,-1
    80003c44:	b755                	j	80003be8 <fileread+0x60>
    80003c46:	597d                	li	s2,-1
    80003c48:	b745                	j	80003be8 <fileread+0x60>

0000000080003c4a <filewrite>:

// Write to file f.
// addr is a user virtual address.
int filewrite(struct file *f, uint64 addr, int n)
{
    80003c4a:	715d                	addi	sp,sp,-80
    80003c4c:	e486                	sd	ra,72(sp)
    80003c4e:	e0a2                	sd	s0,64(sp)
    80003c50:	fc26                	sd	s1,56(sp)
    80003c52:	f84a                	sd	s2,48(sp)
    80003c54:	f44e                	sd	s3,40(sp)
    80003c56:	f052                	sd	s4,32(sp)
    80003c58:	ec56                	sd	s5,24(sp)
    80003c5a:	e85a                	sd	s6,16(sp)
    80003c5c:	e45e                	sd	s7,8(sp)
    80003c5e:	e062                	sd	s8,0(sp)
    80003c60:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if (f->writable == 0)
    80003c62:	00954783          	lbu	a5,9(a0)
    80003c66:	10078663          	beqz	a5,80003d72 <filewrite+0x128>
    80003c6a:	892a                	mv	s2,a0
    80003c6c:	8aae                	mv	s5,a1
    80003c6e:	8a32                	mv	s4,a2
    return -1;

  if (f->type == FD_PIPE)
    80003c70:	411c                	lw	a5,0(a0)
    80003c72:	4705                	li	a4,1
    80003c74:	02e78263          	beq	a5,a4,80003c98 <filewrite+0x4e>
  {
    ret = pipewrite(f->pipe, addr, n);
  }
  else if (f->type == FD_DEVICE)
    80003c78:	470d                	li	a4,3
    80003c7a:	02e78663          	beq	a5,a4,80003ca6 <filewrite+0x5c>
  {
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  }
  else if (f->type == FD_INODE)
    80003c7e:	4709                	li	a4,2
    80003c80:	0ee79163          	bne	a5,a4,80003d62 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * BSIZE;
    int i = 0;
    while (i < n)
    80003c84:	0ac05d63          	blez	a2,80003d3e <filewrite+0xf4>
    int i = 0;
    80003c88:	4981                	li	s3,0
    80003c8a:	6b05                	lui	s6,0x1
    80003c8c:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003c90:	6b85                	lui	s7,0x1
    80003c92:	c00b8b9b          	addiw	s7,s7,-1024
    80003c96:	a861                	j	80003d2e <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003c98:	6908                	ld	a0,16(a0)
    80003c9a:	00000097          	auipc	ra,0x0
    80003c9e:	22e080e7          	jalr	558(ra) # 80003ec8 <pipewrite>
    80003ca2:	8a2a                	mv	s4,a0
    80003ca4:	a045                	j	80003d44 <filewrite+0xfa>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003ca6:	02451783          	lh	a5,36(a0)
    80003caa:	03079693          	slli	a3,a5,0x30
    80003cae:	92c1                	srli	a3,a3,0x30
    80003cb0:	4725                	li	a4,9
    80003cb2:	0cd76263          	bltu	a4,a3,80003d76 <filewrite+0x12c>
    80003cb6:	0792                	slli	a5,a5,0x4
    80003cb8:	00016717          	auipc	a4,0x16
    80003cbc:	c1070713          	addi	a4,a4,-1008 # 800198c8 <devsw>
    80003cc0:	97ba                	add	a5,a5,a4
    80003cc2:	679c                	ld	a5,8(a5)
    80003cc4:	cbdd                	beqz	a5,80003d7a <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003cc6:	4505                	li	a0,1
    80003cc8:	9782                	jalr	a5
    80003cca:	8a2a                	mv	s4,a0
    80003ccc:	a8a5                	j	80003d44 <filewrite+0xfa>
    80003cce:	00048c1b          	sext.w	s8,s1
    {
      int n1 = n - i;
      if (n1 > max)
        n1 = max;

      begin_op();
    80003cd2:	00000097          	auipc	ra,0x0
    80003cd6:	8b0080e7          	jalr	-1872(ra) # 80003582 <begin_op>
      ilock(f->ip);
    80003cda:	01893503          	ld	a0,24(s2)
    80003cde:	fffff097          	auipc	ra,0xfffff
    80003ce2:	ed2080e7          	jalr	-302(ra) # 80002bb0 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003ce6:	8762                	mv	a4,s8
    80003ce8:	02092683          	lw	a3,32(s2)
    80003cec:	01598633          	add	a2,s3,s5
    80003cf0:	4585                	li	a1,1
    80003cf2:	01893503          	ld	a0,24(s2)
    80003cf6:	fffff097          	auipc	ra,0xfffff
    80003cfa:	266080e7          	jalr	614(ra) # 80002f5c <writei>
    80003cfe:	84aa                	mv	s1,a0
    80003d00:	00a05763          	blez	a0,80003d0e <filewrite+0xc4>
        f->off += r;
    80003d04:	02092783          	lw	a5,32(s2)
    80003d08:	9fa9                	addw	a5,a5,a0
    80003d0a:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d0e:	01893503          	ld	a0,24(s2)
    80003d12:	fffff097          	auipc	ra,0xfffff
    80003d16:	f60080e7          	jalr	-160(ra) # 80002c72 <iunlock>
      end_op();
    80003d1a:	00000097          	auipc	ra,0x0
    80003d1e:	8e8080e7          	jalr	-1816(ra) # 80003602 <end_op>

      if (r != n1)
    80003d22:	009c1f63          	bne	s8,s1,80003d40 <filewrite+0xf6>
      {
        // error from writei
        break;
      }
      i += r;
    80003d26:	013489bb          	addw	s3,s1,s3
    while (i < n)
    80003d2a:	0149db63          	bge	s3,s4,80003d40 <filewrite+0xf6>
      int n1 = n - i;
    80003d2e:	413a07bb          	subw	a5,s4,s3
      if (n1 > max)
    80003d32:	84be                	mv	s1,a5
    80003d34:	2781                	sext.w	a5,a5
    80003d36:	f8fb5ce3          	bge	s6,a5,80003cce <filewrite+0x84>
    80003d3a:	84de                	mv	s1,s7
    80003d3c:	bf49                	j	80003cce <filewrite+0x84>
    int i = 0;
    80003d3e:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d40:	013a1f63          	bne	s4,s3,80003d5e <filewrite+0x114>
  {
    panic("filewrite");
  }

  return ret;
}
    80003d44:	8552                	mv	a0,s4
    80003d46:	60a6                	ld	ra,72(sp)
    80003d48:	6406                	ld	s0,64(sp)
    80003d4a:	74e2                	ld	s1,56(sp)
    80003d4c:	7942                	ld	s2,48(sp)
    80003d4e:	79a2                	ld	s3,40(sp)
    80003d50:	7a02                	ld	s4,32(sp)
    80003d52:	6ae2                	ld	s5,24(sp)
    80003d54:	6b42                	ld	s6,16(sp)
    80003d56:	6ba2                	ld	s7,8(sp)
    80003d58:	6c02                	ld	s8,0(sp)
    80003d5a:	6161                	addi	sp,sp,80
    80003d5c:	8082                	ret
    ret = (i == n ? n : -1);
    80003d5e:	5a7d                	li	s4,-1
    80003d60:	b7d5                	j	80003d44 <filewrite+0xfa>
    panic("filewrite");
    80003d62:	00005517          	auipc	a0,0x5
    80003d66:	a7e50513          	addi	a0,a0,-1410 # 800087e0 <syscalls_name+0x278>
    80003d6a:	00002097          	auipc	ra,0x2
    80003d6e:	efe080e7          	jalr	-258(ra) # 80005c68 <panic>
    return -1;
    80003d72:	5a7d                	li	s4,-1
    80003d74:	bfc1                	j	80003d44 <filewrite+0xfa>
      return -1;
    80003d76:	5a7d                	li	s4,-1
    80003d78:	b7f1                	j	80003d44 <filewrite+0xfa>
    80003d7a:	5a7d                	li	s4,-1
    80003d7c:	b7e1                	j	80003d44 <filewrite+0xfa>

0000000080003d7e <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003d7e:	7179                	addi	sp,sp,-48
    80003d80:	f406                	sd	ra,40(sp)
    80003d82:	f022                	sd	s0,32(sp)
    80003d84:	ec26                	sd	s1,24(sp)
    80003d86:	e84a                	sd	s2,16(sp)
    80003d88:	e44e                	sd	s3,8(sp)
    80003d8a:	e052                	sd	s4,0(sp)
    80003d8c:	1800                	addi	s0,sp,48
    80003d8e:	84aa                	mv	s1,a0
    80003d90:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003d92:	0005b023          	sd	zero,0(a1)
    80003d96:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003d9a:	00000097          	auipc	ra,0x0
    80003d9e:	bf8080e7          	jalr	-1032(ra) # 80003992 <filealloc>
    80003da2:	e088                	sd	a0,0(s1)
    80003da4:	c551                	beqz	a0,80003e30 <pipealloc+0xb2>
    80003da6:	00000097          	auipc	ra,0x0
    80003daa:	bec080e7          	jalr	-1044(ra) # 80003992 <filealloc>
    80003dae:	00aa3023          	sd	a0,0(s4)
    80003db2:	c92d                	beqz	a0,80003e24 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003db4:	ffffc097          	auipc	ra,0xffffc
    80003db8:	364080e7          	jalr	868(ra) # 80000118 <kalloc>
    80003dbc:	892a                	mv	s2,a0
    80003dbe:	c125                	beqz	a0,80003e1e <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003dc0:	4985                	li	s3,1
    80003dc2:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003dc6:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003dca:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003dce:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003dd2:	00004597          	auipc	a1,0x4
    80003dd6:	62658593          	addi	a1,a1,1574 # 800083f8 <states.1711+0x1a0>
    80003dda:	00002097          	auipc	ra,0x2
    80003dde:	348080e7          	jalr	840(ra) # 80006122 <initlock>
  (*f0)->type = FD_PIPE;
    80003de2:	609c                	ld	a5,0(s1)
    80003de4:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003de8:	609c                	ld	a5,0(s1)
    80003dea:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003dee:	609c                	ld	a5,0(s1)
    80003df0:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003df4:	609c                	ld	a5,0(s1)
    80003df6:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003dfa:	000a3783          	ld	a5,0(s4)
    80003dfe:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e02:	000a3783          	ld	a5,0(s4)
    80003e06:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e0a:	000a3783          	ld	a5,0(s4)
    80003e0e:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e12:	000a3783          	ld	a5,0(s4)
    80003e16:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e1a:	4501                	li	a0,0
    80003e1c:	a025                	j	80003e44 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e1e:	6088                	ld	a0,0(s1)
    80003e20:	e501                	bnez	a0,80003e28 <pipealloc+0xaa>
    80003e22:	a039                	j	80003e30 <pipealloc+0xb2>
    80003e24:	6088                	ld	a0,0(s1)
    80003e26:	c51d                	beqz	a0,80003e54 <pipealloc+0xd6>
    fileclose(*f0);
    80003e28:	00000097          	auipc	ra,0x0
    80003e2c:	c26080e7          	jalr	-986(ra) # 80003a4e <fileclose>
  if(*f1)
    80003e30:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e34:	557d                	li	a0,-1
  if(*f1)
    80003e36:	c799                	beqz	a5,80003e44 <pipealloc+0xc6>
    fileclose(*f1);
    80003e38:	853e                	mv	a0,a5
    80003e3a:	00000097          	auipc	ra,0x0
    80003e3e:	c14080e7          	jalr	-1004(ra) # 80003a4e <fileclose>
  return -1;
    80003e42:	557d                	li	a0,-1
}
    80003e44:	70a2                	ld	ra,40(sp)
    80003e46:	7402                	ld	s0,32(sp)
    80003e48:	64e2                	ld	s1,24(sp)
    80003e4a:	6942                	ld	s2,16(sp)
    80003e4c:	69a2                	ld	s3,8(sp)
    80003e4e:	6a02                	ld	s4,0(sp)
    80003e50:	6145                	addi	sp,sp,48
    80003e52:	8082                	ret
  return -1;
    80003e54:	557d                	li	a0,-1
    80003e56:	b7fd                	j	80003e44 <pipealloc+0xc6>

0000000080003e58 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e58:	1101                	addi	sp,sp,-32
    80003e5a:	ec06                	sd	ra,24(sp)
    80003e5c:	e822                	sd	s0,16(sp)
    80003e5e:	e426                	sd	s1,8(sp)
    80003e60:	e04a                	sd	s2,0(sp)
    80003e62:	1000                	addi	s0,sp,32
    80003e64:	84aa                	mv	s1,a0
    80003e66:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e68:	00002097          	auipc	ra,0x2
    80003e6c:	34a080e7          	jalr	842(ra) # 800061b2 <acquire>
  if(writable){
    80003e70:	02090d63          	beqz	s2,80003eaa <pipeclose+0x52>
    pi->writeopen = 0;
    80003e74:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003e78:	21848513          	addi	a0,s1,536
    80003e7c:	ffffe097          	auipc	ra,0xffffe
    80003e80:	874080e7          	jalr	-1932(ra) # 800016f0 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003e84:	2204b783          	ld	a5,544(s1)
    80003e88:	eb95                	bnez	a5,80003ebc <pipeclose+0x64>
    release(&pi->lock);
    80003e8a:	8526                	mv	a0,s1
    80003e8c:	00002097          	auipc	ra,0x2
    80003e90:	3da080e7          	jalr	986(ra) # 80006266 <release>
    kfree((char*)pi);
    80003e94:	8526                	mv	a0,s1
    80003e96:	ffffc097          	auipc	ra,0xffffc
    80003e9a:	186080e7          	jalr	390(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003e9e:	60e2                	ld	ra,24(sp)
    80003ea0:	6442                	ld	s0,16(sp)
    80003ea2:	64a2                	ld	s1,8(sp)
    80003ea4:	6902                	ld	s2,0(sp)
    80003ea6:	6105                	addi	sp,sp,32
    80003ea8:	8082                	ret
    pi->readopen = 0;
    80003eaa:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003eae:	21c48513          	addi	a0,s1,540
    80003eb2:	ffffe097          	auipc	ra,0xffffe
    80003eb6:	83e080e7          	jalr	-1986(ra) # 800016f0 <wakeup>
    80003eba:	b7e9                	j	80003e84 <pipeclose+0x2c>
    release(&pi->lock);
    80003ebc:	8526                	mv	a0,s1
    80003ebe:	00002097          	auipc	ra,0x2
    80003ec2:	3a8080e7          	jalr	936(ra) # 80006266 <release>
}
    80003ec6:	bfe1                	j	80003e9e <pipeclose+0x46>

0000000080003ec8 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003ec8:	7159                	addi	sp,sp,-112
    80003eca:	f486                	sd	ra,104(sp)
    80003ecc:	f0a2                	sd	s0,96(sp)
    80003ece:	eca6                	sd	s1,88(sp)
    80003ed0:	e8ca                	sd	s2,80(sp)
    80003ed2:	e4ce                	sd	s3,72(sp)
    80003ed4:	e0d2                	sd	s4,64(sp)
    80003ed6:	fc56                	sd	s5,56(sp)
    80003ed8:	f85a                	sd	s6,48(sp)
    80003eda:	f45e                	sd	s7,40(sp)
    80003edc:	f062                	sd	s8,32(sp)
    80003ede:	ec66                	sd	s9,24(sp)
    80003ee0:	1880                	addi	s0,sp,112
    80003ee2:	84aa                	mv	s1,a0
    80003ee4:	8aae                	mv	s5,a1
    80003ee6:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003ee8:	ffffd097          	auipc	ra,0xffffd
    80003eec:	faa080e7          	jalr	-86(ra) # 80000e92 <myproc>
    80003ef0:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003ef2:	8526                	mv	a0,s1
    80003ef4:	00002097          	auipc	ra,0x2
    80003ef8:	2be080e7          	jalr	702(ra) # 800061b2 <acquire>
  while(i < n){
    80003efc:	0d405163          	blez	s4,80003fbe <pipewrite+0xf6>
    80003f00:	8ba6                	mv	s7,s1
  int i = 0;
    80003f02:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f04:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f06:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f0a:	21c48c13          	addi	s8,s1,540
    80003f0e:	a08d                	j	80003f70 <pipewrite+0xa8>
      release(&pi->lock);
    80003f10:	8526                	mv	a0,s1
    80003f12:	00002097          	auipc	ra,0x2
    80003f16:	354080e7          	jalr	852(ra) # 80006266 <release>
      return -1;
    80003f1a:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f1c:	854a                	mv	a0,s2
    80003f1e:	70a6                	ld	ra,104(sp)
    80003f20:	7406                	ld	s0,96(sp)
    80003f22:	64e6                	ld	s1,88(sp)
    80003f24:	6946                	ld	s2,80(sp)
    80003f26:	69a6                	ld	s3,72(sp)
    80003f28:	6a06                	ld	s4,64(sp)
    80003f2a:	7ae2                	ld	s5,56(sp)
    80003f2c:	7b42                	ld	s6,48(sp)
    80003f2e:	7ba2                	ld	s7,40(sp)
    80003f30:	7c02                	ld	s8,32(sp)
    80003f32:	6ce2                	ld	s9,24(sp)
    80003f34:	6165                	addi	sp,sp,112
    80003f36:	8082                	ret
      wakeup(&pi->nread);
    80003f38:	8566                	mv	a0,s9
    80003f3a:	ffffd097          	auipc	ra,0xffffd
    80003f3e:	7b6080e7          	jalr	1974(ra) # 800016f0 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f42:	85de                	mv	a1,s7
    80003f44:	8562                	mv	a0,s8
    80003f46:	ffffd097          	auipc	ra,0xffffd
    80003f4a:	61e080e7          	jalr	1566(ra) # 80001564 <sleep>
    80003f4e:	a839                	j	80003f6c <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f50:	21c4a783          	lw	a5,540(s1)
    80003f54:	0017871b          	addiw	a4,a5,1
    80003f58:	20e4ae23          	sw	a4,540(s1)
    80003f5c:	1ff7f793          	andi	a5,a5,511
    80003f60:	97a6                	add	a5,a5,s1
    80003f62:	f9f44703          	lbu	a4,-97(s0)
    80003f66:	00e78c23          	sb	a4,24(a5)
      i++;
    80003f6a:	2905                	addiw	s2,s2,1
  while(i < n){
    80003f6c:	03495d63          	bge	s2,s4,80003fa6 <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    80003f70:	2204a783          	lw	a5,544(s1)
    80003f74:	dfd1                	beqz	a5,80003f10 <pipewrite+0x48>
    80003f76:	0289a783          	lw	a5,40(s3)
    80003f7a:	fbd9                	bnez	a5,80003f10 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f7c:	2184a783          	lw	a5,536(s1)
    80003f80:	21c4a703          	lw	a4,540(s1)
    80003f84:	2007879b          	addiw	a5,a5,512
    80003f88:	faf708e3          	beq	a4,a5,80003f38 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f8c:	4685                	li	a3,1
    80003f8e:	01590633          	add	a2,s2,s5
    80003f92:	f9f40593          	addi	a1,s0,-97
    80003f96:	0589b503          	ld	a0,88(s3)
    80003f9a:	ffffd097          	auipc	ra,0xffffd
    80003f9e:	c46080e7          	jalr	-954(ra) # 80000be0 <copyin>
    80003fa2:	fb6517e3          	bne	a0,s6,80003f50 <pipewrite+0x88>
  wakeup(&pi->nread);
    80003fa6:	21848513          	addi	a0,s1,536
    80003faa:	ffffd097          	auipc	ra,0xffffd
    80003fae:	746080e7          	jalr	1862(ra) # 800016f0 <wakeup>
  release(&pi->lock);
    80003fb2:	8526                	mv	a0,s1
    80003fb4:	00002097          	auipc	ra,0x2
    80003fb8:	2b2080e7          	jalr	690(ra) # 80006266 <release>
  return i;
    80003fbc:	b785                	j	80003f1c <pipewrite+0x54>
  int i = 0;
    80003fbe:	4901                	li	s2,0
    80003fc0:	b7dd                	j	80003fa6 <pipewrite+0xde>

0000000080003fc2 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003fc2:	715d                	addi	sp,sp,-80
    80003fc4:	e486                	sd	ra,72(sp)
    80003fc6:	e0a2                	sd	s0,64(sp)
    80003fc8:	fc26                	sd	s1,56(sp)
    80003fca:	f84a                	sd	s2,48(sp)
    80003fcc:	f44e                	sd	s3,40(sp)
    80003fce:	f052                	sd	s4,32(sp)
    80003fd0:	ec56                	sd	s5,24(sp)
    80003fd2:	e85a                	sd	s6,16(sp)
    80003fd4:	0880                	addi	s0,sp,80
    80003fd6:	84aa                	mv	s1,a0
    80003fd8:	892e                	mv	s2,a1
    80003fda:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003fdc:	ffffd097          	auipc	ra,0xffffd
    80003fe0:	eb6080e7          	jalr	-330(ra) # 80000e92 <myproc>
    80003fe4:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003fe6:	8b26                	mv	s6,s1
    80003fe8:	8526                	mv	a0,s1
    80003fea:	00002097          	auipc	ra,0x2
    80003fee:	1c8080e7          	jalr	456(ra) # 800061b2 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003ff2:	2184a703          	lw	a4,536(s1)
    80003ff6:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003ffa:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003ffe:	02f71463          	bne	a4,a5,80004026 <piperead+0x64>
    80004002:	2244a783          	lw	a5,548(s1)
    80004006:	c385                	beqz	a5,80004026 <piperead+0x64>
    if(pr->killed){
    80004008:	028a2783          	lw	a5,40(s4)
    8000400c:	ebc1                	bnez	a5,8000409c <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000400e:	85da                	mv	a1,s6
    80004010:	854e                	mv	a0,s3
    80004012:	ffffd097          	auipc	ra,0xffffd
    80004016:	552080e7          	jalr	1362(ra) # 80001564 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000401a:	2184a703          	lw	a4,536(s1)
    8000401e:	21c4a783          	lw	a5,540(s1)
    80004022:	fef700e3          	beq	a4,a5,80004002 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004026:	09505263          	blez	s5,800040aa <piperead+0xe8>
    8000402a:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000402c:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    8000402e:	2184a783          	lw	a5,536(s1)
    80004032:	21c4a703          	lw	a4,540(s1)
    80004036:	02f70d63          	beq	a4,a5,80004070 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000403a:	0017871b          	addiw	a4,a5,1
    8000403e:	20e4ac23          	sw	a4,536(s1)
    80004042:	1ff7f793          	andi	a5,a5,511
    80004046:	97a6                	add	a5,a5,s1
    80004048:	0187c783          	lbu	a5,24(a5)
    8000404c:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004050:	4685                	li	a3,1
    80004052:	fbf40613          	addi	a2,s0,-65
    80004056:	85ca                	mv	a1,s2
    80004058:	058a3503          	ld	a0,88(s4)
    8000405c:	ffffd097          	auipc	ra,0xffffd
    80004060:	af8080e7          	jalr	-1288(ra) # 80000b54 <copyout>
    80004064:	01650663          	beq	a0,s6,80004070 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004068:	2985                	addiw	s3,s3,1
    8000406a:	0905                	addi	s2,s2,1
    8000406c:	fd3a91e3          	bne	s5,s3,8000402e <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004070:	21c48513          	addi	a0,s1,540
    80004074:	ffffd097          	auipc	ra,0xffffd
    80004078:	67c080e7          	jalr	1660(ra) # 800016f0 <wakeup>
  release(&pi->lock);
    8000407c:	8526                	mv	a0,s1
    8000407e:	00002097          	auipc	ra,0x2
    80004082:	1e8080e7          	jalr	488(ra) # 80006266 <release>
  return i;
}
    80004086:	854e                	mv	a0,s3
    80004088:	60a6                	ld	ra,72(sp)
    8000408a:	6406                	ld	s0,64(sp)
    8000408c:	74e2                	ld	s1,56(sp)
    8000408e:	7942                	ld	s2,48(sp)
    80004090:	79a2                	ld	s3,40(sp)
    80004092:	7a02                	ld	s4,32(sp)
    80004094:	6ae2                	ld	s5,24(sp)
    80004096:	6b42                	ld	s6,16(sp)
    80004098:	6161                	addi	sp,sp,80
    8000409a:	8082                	ret
      release(&pi->lock);
    8000409c:	8526                	mv	a0,s1
    8000409e:	00002097          	auipc	ra,0x2
    800040a2:	1c8080e7          	jalr	456(ra) # 80006266 <release>
      return -1;
    800040a6:	59fd                	li	s3,-1
    800040a8:	bff9                	j	80004086 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040aa:	4981                	li	s3,0
    800040ac:	b7d1                	j	80004070 <piperead+0xae>

00000000800040ae <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800040ae:	df010113          	addi	sp,sp,-528
    800040b2:	20113423          	sd	ra,520(sp)
    800040b6:	20813023          	sd	s0,512(sp)
    800040ba:	ffa6                	sd	s1,504(sp)
    800040bc:	fbca                	sd	s2,496(sp)
    800040be:	f7ce                	sd	s3,488(sp)
    800040c0:	f3d2                	sd	s4,480(sp)
    800040c2:	efd6                	sd	s5,472(sp)
    800040c4:	ebda                	sd	s6,464(sp)
    800040c6:	e7de                	sd	s7,456(sp)
    800040c8:	e3e2                	sd	s8,448(sp)
    800040ca:	ff66                	sd	s9,440(sp)
    800040cc:	fb6a                	sd	s10,432(sp)
    800040ce:	f76e                	sd	s11,424(sp)
    800040d0:	0c00                	addi	s0,sp,528
    800040d2:	84aa                	mv	s1,a0
    800040d4:	dea43c23          	sd	a0,-520(s0)
    800040d8:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800040dc:	ffffd097          	auipc	ra,0xffffd
    800040e0:	db6080e7          	jalr	-586(ra) # 80000e92 <myproc>
    800040e4:	892a                	mv	s2,a0

  begin_op();
    800040e6:	fffff097          	auipc	ra,0xfffff
    800040ea:	49c080e7          	jalr	1180(ra) # 80003582 <begin_op>

  if((ip = namei(path)) == 0){
    800040ee:	8526                	mv	a0,s1
    800040f0:	fffff097          	auipc	ra,0xfffff
    800040f4:	276080e7          	jalr	630(ra) # 80003366 <namei>
    800040f8:	c92d                	beqz	a0,8000416a <exec+0xbc>
    800040fa:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800040fc:	fffff097          	auipc	ra,0xfffff
    80004100:	ab4080e7          	jalr	-1356(ra) # 80002bb0 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004104:	04000713          	li	a4,64
    80004108:	4681                	li	a3,0
    8000410a:	e5040613          	addi	a2,s0,-432
    8000410e:	4581                	li	a1,0
    80004110:	8526                	mv	a0,s1
    80004112:	fffff097          	auipc	ra,0xfffff
    80004116:	d52080e7          	jalr	-686(ra) # 80002e64 <readi>
    8000411a:	04000793          	li	a5,64
    8000411e:	00f51a63          	bne	a0,a5,80004132 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004122:	e5042703          	lw	a4,-432(s0)
    80004126:	464c47b7          	lui	a5,0x464c4
    8000412a:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000412e:	04f70463          	beq	a4,a5,80004176 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004132:	8526                	mv	a0,s1
    80004134:	fffff097          	auipc	ra,0xfffff
    80004138:	cde080e7          	jalr	-802(ra) # 80002e12 <iunlockput>
    end_op();
    8000413c:	fffff097          	auipc	ra,0xfffff
    80004140:	4c6080e7          	jalr	1222(ra) # 80003602 <end_op>
  }
  return -1;
    80004144:	557d                	li	a0,-1
}
    80004146:	20813083          	ld	ra,520(sp)
    8000414a:	20013403          	ld	s0,512(sp)
    8000414e:	74fe                	ld	s1,504(sp)
    80004150:	795e                	ld	s2,496(sp)
    80004152:	79be                	ld	s3,488(sp)
    80004154:	7a1e                	ld	s4,480(sp)
    80004156:	6afe                	ld	s5,472(sp)
    80004158:	6b5e                	ld	s6,464(sp)
    8000415a:	6bbe                	ld	s7,456(sp)
    8000415c:	6c1e                	ld	s8,448(sp)
    8000415e:	7cfa                	ld	s9,440(sp)
    80004160:	7d5a                	ld	s10,432(sp)
    80004162:	7dba                	ld	s11,424(sp)
    80004164:	21010113          	addi	sp,sp,528
    80004168:	8082                	ret
    end_op();
    8000416a:	fffff097          	auipc	ra,0xfffff
    8000416e:	498080e7          	jalr	1176(ra) # 80003602 <end_op>
    return -1;
    80004172:	557d                	li	a0,-1
    80004174:	bfc9                	j	80004146 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004176:	854a                	mv	a0,s2
    80004178:	ffffd097          	auipc	ra,0xffffd
    8000417c:	dde080e7          	jalr	-546(ra) # 80000f56 <proc_pagetable>
    80004180:	8baa                	mv	s7,a0
    80004182:	d945                	beqz	a0,80004132 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004184:	e7042983          	lw	s3,-400(s0)
    80004188:	e8845783          	lhu	a5,-376(s0)
    8000418c:	c7ad                	beqz	a5,800041f6 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000418e:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004190:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    80004192:	6c85                	lui	s9,0x1
    80004194:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004198:	def43823          	sd	a5,-528(s0)
    8000419c:	a42d                	j	800043c6 <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    8000419e:	00004517          	auipc	a0,0x4
    800041a2:	65250513          	addi	a0,a0,1618 # 800087f0 <syscalls_name+0x288>
    800041a6:	00002097          	auipc	ra,0x2
    800041aa:	ac2080e7          	jalr	-1342(ra) # 80005c68 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800041ae:	8756                	mv	a4,s5
    800041b0:	012d86bb          	addw	a3,s11,s2
    800041b4:	4581                	li	a1,0
    800041b6:	8526                	mv	a0,s1
    800041b8:	fffff097          	auipc	ra,0xfffff
    800041bc:	cac080e7          	jalr	-852(ra) # 80002e64 <readi>
    800041c0:	2501                	sext.w	a0,a0
    800041c2:	1aaa9963          	bne	s5,a0,80004374 <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    800041c6:	6785                	lui	a5,0x1
    800041c8:	0127893b          	addw	s2,a5,s2
    800041cc:	77fd                	lui	a5,0xfffff
    800041ce:	01478a3b          	addw	s4,a5,s4
    800041d2:	1f897163          	bgeu	s2,s8,800043b4 <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    800041d6:	02091593          	slli	a1,s2,0x20
    800041da:	9181                	srli	a1,a1,0x20
    800041dc:	95ea                	add	a1,a1,s10
    800041de:	855e                	mv	a0,s7
    800041e0:	ffffc097          	auipc	ra,0xffffc
    800041e4:	370080e7          	jalr	880(ra) # 80000550 <walkaddr>
    800041e8:	862a                	mv	a2,a0
    if(pa == 0)
    800041ea:	d955                	beqz	a0,8000419e <exec+0xf0>
      n = PGSIZE;
    800041ec:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    800041ee:	fd9a70e3          	bgeu	s4,s9,800041ae <exec+0x100>
      n = sz - i;
    800041f2:	8ad2                	mv	s5,s4
    800041f4:	bf6d                	j	800041ae <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041f6:	4901                	li	s2,0
  iunlockput(ip);
    800041f8:	8526                	mv	a0,s1
    800041fa:	fffff097          	auipc	ra,0xfffff
    800041fe:	c18080e7          	jalr	-1000(ra) # 80002e12 <iunlockput>
  end_op();
    80004202:	fffff097          	auipc	ra,0xfffff
    80004206:	400080e7          	jalr	1024(ra) # 80003602 <end_op>
  p = myproc();
    8000420a:	ffffd097          	auipc	ra,0xffffd
    8000420e:	c88080e7          	jalr	-888(ra) # 80000e92 <myproc>
    80004212:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004214:	05053d03          	ld	s10,80(a0)
  sz = PGROUNDUP(sz);
    80004218:	6785                	lui	a5,0x1
    8000421a:	17fd                	addi	a5,a5,-1
    8000421c:	993e                	add	s2,s2,a5
    8000421e:	757d                	lui	a0,0xfffff
    80004220:	00a977b3          	and	a5,s2,a0
    80004224:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004228:	6609                	lui	a2,0x2
    8000422a:	963e                	add	a2,a2,a5
    8000422c:	85be                	mv	a1,a5
    8000422e:	855e                	mv	a0,s7
    80004230:	ffffc097          	auipc	ra,0xffffc
    80004234:	6d4080e7          	jalr	1748(ra) # 80000904 <uvmalloc>
    80004238:	8b2a                	mv	s6,a0
  ip = 0;
    8000423a:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000423c:	12050c63          	beqz	a0,80004374 <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004240:	75f9                	lui	a1,0xffffe
    80004242:	95aa                	add	a1,a1,a0
    80004244:	855e                	mv	a0,s7
    80004246:	ffffd097          	auipc	ra,0xffffd
    8000424a:	8dc080e7          	jalr	-1828(ra) # 80000b22 <uvmclear>
  stackbase = sp - PGSIZE;
    8000424e:	7c7d                	lui	s8,0xfffff
    80004250:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004252:	e0043783          	ld	a5,-512(s0)
    80004256:	6388                	ld	a0,0(a5)
    80004258:	c535                	beqz	a0,800042c4 <exec+0x216>
    8000425a:	e9040993          	addi	s3,s0,-368
    8000425e:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004262:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004264:	ffffc097          	auipc	ra,0xffffc
    80004268:	0e2080e7          	jalr	226(ra) # 80000346 <strlen>
    8000426c:	2505                	addiw	a0,a0,1
    8000426e:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004272:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004276:	13896363          	bltu	s2,s8,8000439c <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000427a:	e0043d83          	ld	s11,-512(s0)
    8000427e:	000dba03          	ld	s4,0(s11)
    80004282:	8552                	mv	a0,s4
    80004284:	ffffc097          	auipc	ra,0xffffc
    80004288:	0c2080e7          	jalr	194(ra) # 80000346 <strlen>
    8000428c:	0015069b          	addiw	a3,a0,1
    80004290:	8652                	mv	a2,s4
    80004292:	85ca                	mv	a1,s2
    80004294:	855e                	mv	a0,s7
    80004296:	ffffd097          	auipc	ra,0xffffd
    8000429a:	8be080e7          	jalr	-1858(ra) # 80000b54 <copyout>
    8000429e:	10054363          	bltz	a0,800043a4 <exec+0x2f6>
    ustack[argc] = sp;
    800042a2:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800042a6:	0485                	addi	s1,s1,1
    800042a8:	008d8793          	addi	a5,s11,8
    800042ac:	e0f43023          	sd	a5,-512(s0)
    800042b0:	008db503          	ld	a0,8(s11)
    800042b4:	c911                	beqz	a0,800042c8 <exec+0x21a>
    if(argc >= MAXARG)
    800042b6:	09a1                	addi	s3,s3,8
    800042b8:	fb3c96e3          	bne	s9,s3,80004264 <exec+0x1b6>
  sz = sz1;
    800042bc:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800042c0:	4481                	li	s1,0
    800042c2:	a84d                	j	80004374 <exec+0x2c6>
  sp = sz;
    800042c4:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    800042c6:	4481                	li	s1,0
  ustack[argc] = 0;
    800042c8:	00349793          	slli	a5,s1,0x3
    800042cc:	f9040713          	addi	a4,s0,-112
    800042d0:	97ba                	add	a5,a5,a4
    800042d2:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    800042d6:	00148693          	addi	a3,s1,1
    800042da:	068e                	slli	a3,a3,0x3
    800042dc:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800042e0:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800042e4:	01897663          	bgeu	s2,s8,800042f0 <exec+0x242>
  sz = sz1;
    800042e8:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800042ec:	4481                	li	s1,0
    800042ee:	a059                	j	80004374 <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800042f0:	e9040613          	addi	a2,s0,-368
    800042f4:	85ca                	mv	a1,s2
    800042f6:	855e                	mv	a0,s7
    800042f8:	ffffd097          	auipc	ra,0xffffd
    800042fc:	85c080e7          	jalr	-1956(ra) # 80000b54 <copyout>
    80004300:	0a054663          	bltz	a0,800043ac <exec+0x2fe>
  p->trapframe->a1 = sp;
    80004304:	060ab783          	ld	a5,96(s5)
    80004308:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000430c:	df843783          	ld	a5,-520(s0)
    80004310:	0007c703          	lbu	a4,0(a5)
    80004314:	cf11                	beqz	a4,80004330 <exec+0x282>
    80004316:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004318:	02f00693          	li	a3,47
    8000431c:	a039                	j	8000432a <exec+0x27c>
      last = s+1;
    8000431e:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004322:	0785                	addi	a5,a5,1
    80004324:	fff7c703          	lbu	a4,-1(a5)
    80004328:	c701                	beqz	a4,80004330 <exec+0x282>
    if(*s == '/')
    8000432a:	fed71ce3          	bne	a4,a3,80004322 <exec+0x274>
    8000432e:	bfc5                	j	8000431e <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    80004330:	4641                	li	a2,16
    80004332:	df843583          	ld	a1,-520(s0)
    80004336:	160a8513          	addi	a0,s5,352
    8000433a:	ffffc097          	auipc	ra,0xffffc
    8000433e:	fda080e7          	jalr	-38(ra) # 80000314 <safestrcpy>
  oldpagetable = p->pagetable;
    80004342:	058ab503          	ld	a0,88(s5)
  p->pagetable = pagetable;
    80004346:	057abc23          	sd	s7,88(s5)
  p->sz = sz;
    8000434a:	056ab823          	sd	s6,80(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000434e:	060ab783          	ld	a5,96(s5)
    80004352:	e6843703          	ld	a4,-408(s0)
    80004356:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004358:	060ab783          	ld	a5,96(s5)
    8000435c:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004360:	85ea                	mv	a1,s10
    80004362:	ffffd097          	auipc	ra,0xffffd
    80004366:	c90080e7          	jalr	-880(ra) # 80000ff2 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000436a:	0004851b          	sext.w	a0,s1
    8000436e:	bbe1                	j	80004146 <exec+0x98>
    80004370:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004374:	e0843583          	ld	a1,-504(s0)
    80004378:	855e                	mv	a0,s7
    8000437a:	ffffd097          	auipc	ra,0xffffd
    8000437e:	c78080e7          	jalr	-904(ra) # 80000ff2 <proc_freepagetable>
  if(ip){
    80004382:	da0498e3          	bnez	s1,80004132 <exec+0x84>
  return -1;
    80004386:	557d                	li	a0,-1
    80004388:	bb7d                	j	80004146 <exec+0x98>
    8000438a:	e1243423          	sd	s2,-504(s0)
    8000438e:	b7dd                	j	80004374 <exec+0x2c6>
    80004390:	e1243423          	sd	s2,-504(s0)
    80004394:	b7c5                	j	80004374 <exec+0x2c6>
    80004396:	e1243423          	sd	s2,-504(s0)
    8000439a:	bfe9                	j	80004374 <exec+0x2c6>
  sz = sz1;
    8000439c:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043a0:	4481                	li	s1,0
    800043a2:	bfc9                	j	80004374 <exec+0x2c6>
  sz = sz1;
    800043a4:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043a8:	4481                	li	s1,0
    800043aa:	b7e9                	j	80004374 <exec+0x2c6>
  sz = sz1;
    800043ac:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043b0:	4481                	li	s1,0
    800043b2:	b7c9                	j	80004374 <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800043b4:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043b8:	2b05                	addiw	s6,s6,1
    800043ba:	0389899b          	addiw	s3,s3,56
    800043be:	e8845783          	lhu	a5,-376(s0)
    800043c2:	e2fb5be3          	bge	s6,a5,800041f8 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800043c6:	2981                	sext.w	s3,s3
    800043c8:	03800713          	li	a4,56
    800043cc:	86ce                	mv	a3,s3
    800043ce:	e1840613          	addi	a2,s0,-488
    800043d2:	4581                	li	a1,0
    800043d4:	8526                	mv	a0,s1
    800043d6:	fffff097          	auipc	ra,0xfffff
    800043da:	a8e080e7          	jalr	-1394(ra) # 80002e64 <readi>
    800043de:	03800793          	li	a5,56
    800043e2:	f8f517e3          	bne	a0,a5,80004370 <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    800043e6:	e1842783          	lw	a5,-488(s0)
    800043ea:	4705                	li	a4,1
    800043ec:	fce796e3          	bne	a5,a4,800043b8 <exec+0x30a>
    if(ph.memsz < ph.filesz)
    800043f0:	e4043603          	ld	a2,-448(s0)
    800043f4:	e3843783          	ld	a5,-456(s0)
    800043f8:	f8f669e3          	bltu	a2,a5,8000438a <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800043fc:	e2843783          	ld	a5,-472(s0)
    80004400:	963e                	add	a2,a2,a5
    80004402:	f8f667e3          	bltu	a2,a5,80004390 <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004406:	85ca                	mv	a1,s2
    80004408:	855e                	mv	a0,s7
    8000440a:	ffffc097          	auipc	ra,0xffffc
    8000440e:	4fa080e7          	jalr	1274(ra) # 80000904 <uvmalloc>
    80004412:	e0a43423          	sd	a0,-504(s0)
    80004416:	d141                	beqz	a0,80004396 <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    80004418:	e2843d03          	ld	s10,-472(s0)
    8000441c:	df043783          	ld	a5,-528(s0)
    80004420:	00fd77b3          	and	a5,s10,a5
    80004424:	fba1                	bnez	a5,80004374 <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004426:	e2042d83          	lw	s11,-480(s0)
    8000442a:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000442e:	f80c03e3          	beqz	s8,800043b4 <exec+0x306>
    80004432:	8a62                	mv	s4,s8
    80004434:	4901                	li	s2,0
    80004436:	b345                	j	800041d6 <exec+0x128>

0000000080004438 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004438:	7179                	addi	sp,sp,-48
    8000443a:	f406                	sd	ra,40(sp)
    8000443c:	f022                	sd	s0,32(sp)
    8000443e:	ec26                	sd	s1,24(sp)
    80004440:	e84a                	sd	s2,16(sp)
    80004442:	1800                	addi	s0,sp,48
    80004444:	892e                	mv	s2,a1
    80004446:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if (argint(n, &fd) < 0)
    80004448:	fdc40593          	addi	a1,s0,-36
    8000444c:	ffffe097          	auipc	ra,0xffffe
    80004450:	b38080e7          	jalr	-1224(ra) # 80001f84 <argint>
    80004454:	04054063          	bltz	a0,80004494 <argfd+0x5c>
    return -1;
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
    80004458:	fdc42703          	lw	a4,-36(s0)
    8000445c:	47bd                	li	a5,15
    8000445e:	02e7ed63          	bltu	a5,a4,80004498 <argfd+0x60>
    80004462:	ffffd097          	auipc	ra,0xffffd
    80004466:	a30080e7          	jalr	-1488(ra) # 80000e92 <myproc>
    8000446a:	fdc42703          	lw	a4,-36(s0)
    8000446e:	01a70793          	addi	a5,a4,26
    80004472:	078e                	slli	a5,a5,0x3
    80004474:	953e                	add	a0,a0,a5
    80004476:	651c                	ld	a5,8(a0)
    80004478:	c395                	beqz	a5,8000449c <argfd+0x64>
    return -1;
  if (pfd)
    8000447a:	00090463          	beqz	s2,80004482 <argfd+0x4a>
    *pfd = fd;
    8000447e:	00e92023          	sw	a4,0(s2)
  if (pf)
    *pf = f;
  return 0;
    80004482:	4501                	li	a0,0
  if (pf)
    80004484:	c091                	beqz	s1,80004488 <argfd+0x50>
    *pf = f;
    80004486:	e09c                	sd	a5,0(s1)
}
    80004488:	70a2                	ld	ra,40(sp)
    8000448a:	7402                	ld	s0,32(sp)
    8000448c:	64e2                	ld	s1,24(sp)
    8000448e:	6942                	ld	s2,16(sp)
    80004490:	6145                	addi	sp,sp,48
    80004492:	8082                	ret
    return -1;
    80004494:	557d                	li	a0,-1
    80004496:	bfcd                	j	80004488 <argfd+0x50>
    return -1;
    80004498:	557d                	li	a0,-1
    8000449a:	b7fd                	j	80004488 <argfd+0x50>
    8000449c:	557d                	li	a0,-1
    8000449e:	b7ed                	j	80004488 <argfd+0x50>

00000000800044a0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800044a0:	1101                	addi	sp,sp,-32
    800044a2:	ec06                	sd	ra,24(sp)
    800044a4:	e822                	sd	s0,16(sp)
    800044a6:	e426                	sd	s1,8(sp)
    800044a8:	1000                	addi	s0,sp,32
    800044aa:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800044ac:	ffffd097          	auipc	ra,0xffffd
    800044b0:	9e6080e7          	jalr	-1562(ra) # 80000e92 <myproc>
    800044b4:	862a                	mv	a2,a0

  for (fd = 0; fd < NOFILE; fd++)
    800044b6:	0d850793          	addi	a5,a0,216 # fffffffffffff0d8 <end+0xffffffff7ffd8e98>
    800044ba:	4501                	li	a0,0
    800044bc:	46c1                	li	a3,16
  {
    if (p->ofile[fd] == 0)
    800044be:	6398                	ld	a4,0(a5)
    800044c0:	cb19                	beqz	a4,800044d6 <fdalloc+0x36>
  for (fd = 0; fd < NOFILE; fd++)
    800044c2:	2505                	addiw	a0,a0,1
    800044c4:	07a1                	addi	a5,a5,8
    800044c6:	fed51ce3          	bne	a0,a3,800044be <fdalloc+0x1e>
    {
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800044ca:	557d                	li	a0,-1
}
    800044cc:	60e2                	ld	ra,24(sp)
    800044ce:	6442                	ld	s0,16(sp)
    800044d0:	64a2                	ld	s1,8(sp)
    800044d2:	6105                	addi	sp,sp,32
    800044d4:	8082                	ret
      p->ofile[fd] = f;
    800044d6:	01a50793          	addi	a5,a0,26
    800044da:	078e                	slli	a5,a5,0x3
    800044dc:	963e                	add	a2,a2,a5
    800044de:	e604                	sd	s1,8(a2)
      return fd;
    800044e0:	b7f5                	j	800044cc <fdalloc+0x2c>

00000000800044e2 <create>:
  return -1;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
    800044e2:	715d                	addi	sp,sp,-80
    800044e4:	e486                	sd	ra,72(sp)
    800044e6:	e0a2                	sd	s0,64(sp)
    800044e8:	fc26                	sd	s1,56(sp)
    800044ea:	f84a                	sd	s2,48(sp)
    800044ec:	f44e                	sd	s3,40(sp)
    800044ee:	f052                	sd	s4,32(sp)
    800044f0:	ec56                	sd	s5,24(sp)
    800044f2:	0880                	addi	s0,sp,80
    800044f4:	89ae                	mv	s3,a1
    800044f6:	8ab2                	mv	s5,a2
    800044f8:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
    800044fa:	fb040593          	addi	a1,s0,-80
    800044fe:	fffff097          	auipc	ra,0xfffff
    80004502:	e86080e7          	jalr	-378(ra) # 80003384 <nameiparent>
    80004506:	892a                	mv	s2,a0
    80004508:	12050f63          	beqz	a0,80004646 <create+0x164>
    return 0;

  ilock(dp);
    8000450c:	ffffe097          	auipc	ra,0xffffe
    80004510:	6a4080e7          	jalr	1700(ra) # 80002bb0 <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0)
    80004514:	4601                	li	a2,0
    80004516:	fb040593          	addi	a1,s0,-80
    8000451a:	854a                	mv	a0,s2
    8000451c:	fffff097          	auipc	ra,0xfffff
    80004520:	b78080e7          	jalr	-1160(ra) # 80003094 <dirlookup>
    80004524:	84aa                	mv	s1,a0
    80004526:	c921                	beqz	a0,80004576 <create+0x94>
  {
    iunlockput(dp);
    80004528:	854a                	mv	a0,s2
    8000452a:	fffff097          	auipc	ra,0xfffff
    8000452e:	8e8080e7          	jalr	-1816(ra) # 80002e12 <iunlockput>
    ilock(ip);
    80004532:	8526                	mv	a0,s1
    80004534:	ffffe097          	auipc	ra,0xffffe
    80004538:	67c080e7          	jalr	1660(ra) # 80002bb0 <ilock>
    if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000453c:	2981                	sext.w	s3,s3
    8000453e:	4789                	li	a5,2
    80004540:	02f99463          	bne	s3,a5,80004568 <create+0x86>
    80004544:	0444d783          	lhu	a5,68(s1)
    80004548:	37f9                	addiw	a5,a5,-2
    8000454a:	17c2                	slli	a5,a5,0x30
    8000454c:	93c1                	srli	a5,a5,0x30
    8000454e:	4705                	li	a4,1
    80004550:	00f76c63          	bltu	a4,a5,80004568 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004554:	8526                	mv	a0,s1
    80004556:	60a6                	ld	ra,72(sp)
    80004558:	6406                	ld	s0,64(sp)
    8000455a:	74e2                	ld	s1,56(sp)
    8000455c:	7942                	ld	s2,48(sp)
    8000455e:	79a2                	ld	s3,40(sp)
    80004560:	7a02                	ld	s4,32(sp)
    80004562:	6ae2                	ld	s5,24(sp)
    80004564:	6161                	addi	sp,sp,80
    80004566:	8082                	ret
    iunlockput(ip);
    80004568:	8526                	mv	a0,s1
    8000456a:	fffff097          	auipc	ra,0xfffff
    8000456e:	8a8080e7          	jalr	-1880(ra) # 80002e12 <iunlockput>
    return 0;
    80004572:	4481                	li	s1,0
    80004574:	b7c5                	j	80004554 <create+0x72>
  if ((ip = ialloc(dp->dev, type)) == 0)
    80004576:	85ce                	mv	a1,s3
    80004578:	00092503          	lw	a0,0(s2)
    8000457c:	ffffe097          	auipc	ra,0xffffe
    80004580:	49c080e7          	jalr	1180(ra) # 80002a18 <ialloc>
    80004584:	84aa                	mv	s1,a0
    80004586:	c529                	beqz	a0,800045d0 <create+0xee>
  ilock(ip);
    80004588:	ffffe097          	auipc	ra,0xffffe
    8000458c:	628080e7          	jalr	1576(ra) # 80002bb0 <ilock>
  ip->major = major;
    80004590:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80004594:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80004598:	4785                	li	a5,1
    8000459a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000459e:	8526                	mv	a0,s1
    800045a0:	ffffe097          	auipc	ra,0xffffe
    800045a4:	546080e7          	jalr	1350(ra) # 80002ae6 <iupdate>
  if (type == T_DIR)
    800045a8:	2981                	sext.w	s3,s3
    800045aa:	4785                	li	a5,1
    800045ac:	02f98a63          	beq	s3,a5,800045e0 <create+0xfe>
  if (dirlink(dp, name, ip->inum) < 0)
    800045b0:	40d0                	lw	a2,4(s1)
    800045b2:	fb040593          	addi	a1,s0,-80
    800045b6:	854a                	mv	a0,s2
    800045b8:	fffff097          	auipc	ra,0xfffff
    800045bc:	cec080e7          	jalr	-788(ra) # 800032a4 <dirlink>
    800045c0:	06054b63          	bltz	a0,80004636 <create+0x154>
  iunlockput(dp);
    800045c4:	854a                	mv	a0,s2
    800045c6:	fffff097          	auipc	ra,0xfffff
    800045ca:	84c080e7          	jalr	-1972(ra) # 80002e12 <iunlockput>
  return ip;
    800045ce:	b759                	j	80004554 <create+0x72>
    panic("create: ialloc");
    800045d0:	00004517          	auipc	a0,0x4
    800045d4:	24050513          	addi	a0,a0,576 # 80008810 <syscalls_name+0x2a8>
    800045d8:	00001097          	auipc	ra,0x1
    800045dc:	690080e7          	jalr	1680(ra) # 80005c68 <panic>
    dp->nlink++; // for ".."
    800045e0:	04a95783          	lhu	a5,74(s2)
    800045e4:	2785                	addiw	a5,a5,1
    800045e6:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800045ea:	854a                	mv	a0,s2
    800045ec:	ffffe097          	auipc	ra,0xffffe
    800045f0:	4fa080e7          	jalr	1274(ra) # 80002ae6 <iupdate>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800045f4:	40d0                	lw	a2,4(s1)
    800045f6:	00004597          	auipc	a1,0x4
    800045fa:	22a58593          	addi	a1,a1,554 # 80008820 <syscalls_name+0x2b8>
    800045fe:	8526                	mv	a0,s1
    80004600:	fffff097          	auipc	ra,0xfffff
    80004604:	ca4080e7          	jalr	-860(ra) # 800032a4 <dirlink>
    80004608:	00054f63          	bltz	a0,80004626 <create+0x144>
    8000460c:	00492603          	lw	a2,4(s2)
    80004610:	00004597          	auipc	a1,0x4
    80004614:	21858593          	addi	a1,a1,536 # 80008828 <syscalls_name+0x2c0>
    80004618:	8526                	mv	a0,s1
    8000461a:	fffff097          	auipc	ra,0xfffff
    8000461e:	c8a080e7          	jalr	-886(ra) # 800032a4 <dirlink>
    80004622:	f80557e3          	bgez	a0,800045b0 <create+0xce>
      panic("create dots");
    80004626:	00004517          	auipc	a0,0x4
    8000462a:	20a50513          	addi	a0,a0,522 # 80008830 <syscalls_name+0x2c8>
    8000462e:	00001097          	auipc	ra,0x1
    80004632:	63a080e7          	jalr	1594(ra) # 80005c68 <panic>
    panic("create: dirlink");
    80004636:	00004517          	auipc	a0,0x4
    8000463a:	20a50513          	addi	a0,a0,522 # 80008840 <syscalls_name+0x2d8>
    8000463e:	00001097          	auipc	ra,0x1
    80004642:	62a080e7          	jalr	1578(ra) # 80005c68 <panic>
    return 0;
    80004646:	84aa                	mv	s1,a0
    80004648:	b731                	j	80004554 <create+0x72>

000000008000464a <sys_dup>:
{
    8000464a:	7179                	addi	sp,sp,-48
    8000464c:	f406                	sd	ra,40(sp)
    8000464e:	f022                	sd	s0,32(sp)
    80004650:	ec26                	sd	s1,24(sp)
    80004652:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0)
    80004654:	fd840613          	addi	a2,s0,-40
    80004658:	4581                	li	a1,0
    8000465a:	4501                	li	a0,0
    8000465c:	00000097          	auipc	ra,0x0
    80004660:	ddc080e7          	jalr	-548(ra) # 80004438 <argfd>
    return -1;
    80004664:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0)
    80004666:	02054363          	bltz	a0,8000468c <sys_dup+0x42>
  if ((fd = fdalloc(f)) < 0)
    8000466a:	fd843503          	ld	a0,-40(s0)
    8000466e:	00000097          	auipc	ra,0x0
    80004672:	e32080e7          	jalr	-462(ra) # 800044a0 <fdalloc>
    80004676:	84aa                	mv	s1,a0
    return -1;
    80004678:	57fd                	li	a5,-1
  if ((fd = fdalloc(f)) < 0)
    8000467a:	00054963          	bltz	a0,8000468c <sys_dup+0x42>
  filedup(f);
    8000467e:	fd843503          	ld	a0,-40(s0)
    80004682:	fffff097          	auipc	ra,0xfffff
    80004686:	37a080e7          	jalr	890(ra) # 800039fc <filedup>
  return fd;
    8000468a:	87a6                	mv	a5,s1
}
    8000468c:	853e                	mv	a0,a5
    8000468e:	70a2                	ld	ra,40(sp)
    80004690:	7402                	ld	s0,32(sp)
    80004692:	64e2                	ld	s1,24(sp)
    80004694:	6145                	addi	sp,sp,48
    80004696:	8082                	ret

0000000080004698 <sys_read>:
{
    80004698:	7179                	addi	sp,sp,-48
    8000469a:	f406                	sd	ra,40(sp)
    8000469c:	f022                	sd	s0,32(sp)
    8000469e:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046a0:	fe840613          	addi	a2,s0,-24
    800046a4:	4581                	li	a1,0
    800046a6:	4501                	li	a0,0
    800046a8:	00000097          	auipc	ra,0x0
    800046ac:	d90080e7          	jalr	-624(ra) # 80004438 <argfd>
    return -1;
    800046b0:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046b2:	04054163          	bltz	a0,800046f4 <sys_read+0x5c>
    800046b6:	fe440593          	addi	a1,s0,-28
    800046ba:	4509                	li	a0,2
    800046bc:	ffffe097          	auipc	ra,0xffffe
    800046c0:	8c8080e7          	jalr	-1848(ra) # 80001f84 <argint>
    return -1;
    800046c4:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046c6:	02054763          	bltz	a0,800046f4 <sys_read+0x5c>
    800046ca:	fd840593          	addi	a1,s0,-40
    800046ce:	4505                	li	a0,1
    800046d0:	ffffe097          	auipc	ra,0xffffe
    800046d4:	8d6080e7          	jalr	-1834(ra) # 80001fa6 <argaddr>
    return -1;
    800046d8:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046da:	00054d63          	bltz	a0,800046f4 <sys_read+0x5c>
  return fileread(f, p, n);
    800046de:	fe442603          	lw	a2,-28(s0)
    800046e2:	fd843583          	ld	a1,-40(s0)
    800046e6:	fe843503          	ld	a0,-24(s0)
    800046ea:	fffff097          	auipc	ra,0xfffff
    800046ee:	49e080e7          	jalr	1182(ra) # 80003b88 <fileread>
    800046f2:	87aa                	mv	a5,a0
}
    800046f4:	853e                	mv	a0,a5
    800046f6:	70a2                	ld	ra,40(sp)
    800046f8:	7402                	ld	s0,32(sp)
    800046fa:	6145                	addi	sp,sp,48
    800046fc:	8082                	ret

00000000800046fe <sys_write>:
{
    800046fe:	7179                	addi	sp,sp,-48
    80004700:	f406                	sd	ra,40(sp)
    80004702:	f022                	sd	s0,32(sp)
    80004704:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004706:	fe840613          	addi	a2,s0,-24
    8000470a:	4581                	li	a1,0
    8000470c:	4501                	li	a0,0
    8000470e:	00000097          	auipc	ra,0x0
    80004712:	d2a080e7          	jalr	-726(ra) # 80004438 <argfd>
    return -1;
    80004716:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004718:	04054163          	bltz	a0,8000475a <sys_write+0x5c>
    8000471c:	fe440593          	addi	a1,s0,-28
    80004720:	4509                	li	a0,2
    80004722:	ffffe097          	auipc	ra,0xffffe
    80004726:	862080e7          	jalr	-1950(ra) # 80001f84 <argint>
    return -1;
    8000472a:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000472c:	02054763          	bltz	a0,8000475a <sys_write+0x5c>
    80004730:	fd840593          	addi	a1,s0,-40
    80004734:	4505                	li	a0,1
    80004736:	ffffe097          	auipc	ra,0xffffe
    8000473a:	870080e7          	jalr	-1936(ra) # 80001fa6 <argaddr>
    return -1;
    8000473e:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004740:	00054d63          	bltz	a0,8000475a <sys_write+0x5c>
  return filewrite(f, p, n);
    80004744:	fe442603          	lw	a2,-28(s0)
    80004748:	fd843583          	ld	a1,-40(s0)
    8000474c:	fe843503          	ld	a0,-24(s0)
    80004750:	fffff097          	auipc	ra,0xfffff
    80004754:	4fa080e7          	jalr	1274(ra) # 80003c4a <filewrite>
    80004758:	87aa                	mv	a5,a0
}
    8000475a:	853e                	mv	a0,a5
    8000475c:	70a2                	ld	ra,40(sp)
    8000475e:	7402                	ld	s0,32(sp)
    80004760:	6145                	addi	sp,sp,48
    80004762:	8082                	ret

0000000080004764 <sys_close>:
{
    80004764:	1101                	addi	sp,sp,-32
    80004766:	ec06                	sd	ra,24(sp)
    80004768:	e822                	sd	s0,16(sp)
    8000476a:	1000                	addi	s0,sp,32
  if (argfd(0, &fd, &f) < 0)
    8000476c:	fe040613          	addi	a2,s0,-32
    80004770:	fec40593          	addi	a1,s0,-20
    80004774:	4501                	li	a0,0
    80004776:	00000097          	auipc	ra,0x0
    8000477a:	cc2080e7          	jalr	-830(ra) # 80004438 <argfd>
    return -1;
    8000477e:	57fd                	li	a5,-1
  if (argfd(0, &fd, &f) < 0)
    80004780:	02054463          	bltz	a0,800047a8 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004784:	ffffc097          	auipc	ra,0xffffc
    80004788:	70e080e7          	jalr	1806(ra) # 80000e92 <myproc>
    8000478c:	fec42783          	lw	a5,-20(s0)
    80004790:	07e9                	addi	a5,a5,26
    80004792:	078e                	slli	a5,a5,0x3
    80004794:	97aa                	add	a5,a5,a0
    80004796:	0007b423          	sd	zero,8(a5)
  fileclose(f);
    8000479a:	fe043503          	ld	a0,-32(s0)
    8000479e:	fffff097          	auipc	ra,0xfffff
    800047a2:	2b0080e7          	jalr	688(ra) # 80003a4e <fileclose>
  return 0;
    800047a6:	4781                	li	a5,0
}
    800047a8:	853e                	mv	a0,a5
    800047aa:	60e2                	ld	ra,24(sp)
    800047ac:	6442                	ld	s0,16(sp)
    800047ae:	6105                	addi	sp,sp,32
    800047b0:	8082                	ret

00000000800047b2 <sys_link>:
{
    800047b2:	7169                	addi	sp,sp,-304
    800047b4:	f606                	sd	ra,296(sp)
    800047b6:	f222                	sd	s0,288(sp)
    800047b8:	ee26                	sd	s1,280(sp)
    800047ba:	ea4a                	sd	s2,272(sp)
    800047bc:	1a00                	addi	s0,sp,304
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047be:	08000613          	li	a2,128
    800047c2:	ed040593          	addi	a1,s0,-304
    800047c6:	4501                	li	a0,0
    800047c8:	ffffe097          	auipc	ra,0xffffe
    800047cc:	800080e7          	jalr	-2048(ra) # 80001fc8 <argstr>
    return -1;
    800047d0:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047d2:	10054e63          	bltz	a0,800048ee <sys_link+0x13c>
    800047d6:	08000613          	li	a2,128
    800047da:	f5040593          	addi	a1,s0,-176
    800047de:	4505                	li	a0,1
    800047e0:	ffffd097          	auipc	ra,0xffffd
    800047e4:	7e8080e7          	jalr	2024(ra) # 80001fc8 <argstr>
    return -1;
    800047e8:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047ea:	10054263          	bltz	a0,800048ee <sys_link+0x13c>
  begin_op();
    800047ee:	fffff097          	auipc	ra,0xfffff
    800047f2:	d94080e7          	jalr	-620(ra) # 80003582 <begin_op>
  if ((ip = namei(old)) == 0)
    800047f6:	ed040513          	addi	a0,s0,-304
    800047fa:	fffff097          	auipc	ra,0xfffff
    800047fe:	b6c080e7          	jalr	-1172(ra) # 80003366 <namei>
    80004802:	84aa                	mv	s1,a0
    80004804:	c551                	beqz	a0,80004890 <sys_link+0xde>
  ilock(ip);
    80004806:	ffffe097          	auipc	ra,0xffffe
    8000480a:	3aa080e7          	jalr	938(ra) # 80002bb0 <ilock>
  if (ip->type == T_DIR)
    8000480e:	04449703          	lh	a4,68(s1)
    80004812:	4785                	li	a5,1
    80004814:	08f70463          	beq	a4,a5,8000489c <sys_link+0xea>
  ip->nlink++;
    80004818:	04a4d783          	lhu	a5,74(s1)
    8000481c:	2785                	addiw	a5,a5,1
    8000481e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004822:	8526                	mv	a0,s1
    80004824:	ffffe097          	auipc	ra,0xffffe
    80004828:	2c2080e7          	jalr	706(ra) # 80002ae6 <iupdate>
  iunlock(ip);
    8000482c:	8526                	mv	a0,s1
    8000482e:	ffffe097          	auipc	ra,0xffffe
    80004832:	444080e7          	jalr	1092(ra) # 80002c72 <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
    80004836:	fd040593          	addi	a1,s0,-48
    8000483a:	f5040513          	addi	a0,s0,-176
    8000483e:	fffff097          	auipc	ra,0xfffff
    80004842:	b46080e7          	jalr	-1210(ra) # 80003384 <nameiparent>
    80004846:	892a                	mv	s2,a0
    80004848:	c935                	beqz	a0,800048bc <sys_link+0x10a>
  ilock(dp);
    8000484a:	ffffe097          	auipc	ra,0xffffe
    8000484e:	366080e7          	jalr	870(ra) # 80002bb0 <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
    80004852:	00092703          	lw	a4,0(s2)
    80004856:	409c                	lw	a5,0(s1)
    80004858:	04f71d63          	bne	a4,a5,800048b2 <sys_link+0x100>
    8000485c:	40d0                	lw	a2,4(s1)
    8000485e:	fd040593          	addi	a1,s0,-48
    80004862:	854a                	mv	a0,s2
    80004864:	fffff097          	auipc	ra,0xfffff
    80004868:	a40080e7          	jalr	-1472(ra) # 800032a4 <dirlink>
    8000486c:	04054363          	bltz	a0,800048b2 <sys_link+0x100>
  iunlockput(dp);
    80004870:	854a                	mv	a0,s2
    80004872:	ffffe097          	auipc	ra,0xffffe
    80004876:	5a0080e7          	jalr	1440(ra) # 80002e12 <iunlockput>
  iput(ip);
    8000487a:	8526                	mv	a0,s1
    8000487c:	ffffe097          	auipc	ra,0xffffe
    80004880:	4ee080e7          	jalr	1262(ra) # 80002d6a <iput>
  end_op();
    80004884:	fffff097          	auipc	ra,0xfffff
    80004888:	d7e080e7          	jalr	-642(ra) # 80003602 <end_op>
  return 0;
    8000488c:	4781                	li	a5,0
    8000488e:	a085                	j	800048ee <sys_link+0x13c>
    end_op();
    80004890:	fffff097          	auipc	ra,0xfffff
    80004894:	d72080e7          	jalr	-654(ra) # 80003602 <end_op>
    return -1;
    80004898:	57fd                	li	a5,-1
    8000489a:	a891                	j	800048ee <sys_link+0x13c>
    iunlockput(ip);
    8000489c:	8526                	mv	a0,s1
    8000489e:	ffffe097          	auipc	ra,0xffffe
    800048a2:	574080e7          	jalr	1396(ra) # 80002e12 <iunlockput>
    end_op();
    800048a6:	fffff097          	auipc	ra,0xfffff
    800048aa:	d5c080e7          	jalr	-676(ra) # 80003602 <end_op>
    return -1;
    800048ae:	57fd                	li	a5,-1
    800048b0:	a83d                	j	800048ee <sys_link+0x13c>
    iunlockput(dp);
    800048b2:	854a                	mv	a0,s2
    800048b4:	ffffe097          	auipc	ra,0xffffe
    800048b8:	55e080e7          	jalr	1374(ra) # 80002e12 <iunlockput>
  ilock(ip);
    800048bc:	8526                	mv	a0,s1
    800048be:	ffffe097          	auipc	ra,0xffffe
    800048c2:	2f2080e7          	jalr	754(ra) # 80002bb0 <ilock>
  ip->nlink--;
    800048c6:	04a4d783          	lhu	a5,74(s1)
    800048ca:	37fd                	addiw	a5,a5,-1
    800048cc:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048d0:	8526                	mv	a0,s1
    800048d2:	ffffe097          	auipc	ra,0xffffe
    800048d6:	214080e7          	jalr	532(ra) # 80002ae6 <iupdate>
  iunlockput(ip);
    800048da:	8526                	mv	a0,s1
    800048dc:	ffffe097          	auipc	ra,0xffffe
    800048e0:	536080e7          	jalr	1334(ra) # 80002e12 <iunlockput>
  end_op();
    800048e4:	fffff097          	auipc	ra,0xfffff
    800048e8:	d1e080e7          	jalr	-738(ra) # 80003602 <end_op>
  return -1;
    800048ec:	57fd                	li	a5,-1
}
    800048ee:	853e                	mv	a0,a5
    800048f0:	70b2                	ld	ra,296(sp)
    800048f2:	7412                	ld	s0,288(sp)
    800048f4:	64f2                	ld	s1,280(sp)
    800048f6:	6952                	ld	s2,272(sp)
    800048f8:	6155                	addi	sp,sp,304
    800048fa:	8082                	ret

00000000800048fc <sys_unlink>:
{
    800048fc:	7151                	addi	sp,sp,-240
    800048fe:	f586                	sd	ra,232(sp)
    80004900:	f1a2                	sd	s0,224(sp)
    80004902:	eda6                	sd	s1,216(sp)
    80004904:	e9ca                	sd	s2,208(sp)
    80004906:	e5ce                	sd	s3,200(sp)
    80004908:	1980                	addi	s0,sp,240
  if (argstr(0, path, MAXPATH) < 0)
    8000490a:	08000613          	li	a2,128
    8000490e:	f3040593          	addi	a1,s0,-208
    80004912:	4501                	li	a0,0
    80004914:	ffffd097          	auipc	ra,0xffffd
    80004918:	6b4080e7          	jalr	1716(ra) # 80001fc8 <argstr>
    8000491c:	18054163          	bltz	a0,80004a9e <sys_unlink+0x1a2>
  begin_op();
    80004920:	fffff097          	auipc	ra,0xfffff
    80004924:	c62080e7          	jalr	-926(ra) # 80003582 <begin_op>
  if ((dp = nameiparent(path, name)) == 0)
    80004928:	fb040593          	addi	a1,s0,-80
    8000492c:	f3040513          	addi	a0,s0,-208
    80004930:	fffff097          	auipc	ra,0xfffff
    80004934:	a54080e7          	jalr	-1452(ra) # 80003384 <nameiparent>
    80004938:	84aa                	mv	s1,a0
    8000493a:	c979                	beqz	a0,80004a10 <sys_unlink+0x114>
  ilock(dp);
    8000493c:	ffffe097          	auipc	ra,0xffffe
    80004940:	274080e7          	jalr	628(ra) # 80002bb0 <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004944:	00004597          	auipc	a1,0x4
    80004948:	edc58593          	addi	a1,a1,-292 # 80008820 <syscalls_name+0x2b8>
    8000494c:	fb040513          	addi	a0,s0,-80
    80004950:	ffffe097          	auipc	ra,0xffffe
    80004954:	72a080e7          	jalr	1834(ra) # 8000307a <namecmp>
    80004958:	14050a63          	beqz	a0,80004aac <sys_unlink+0x1b0>
    8000495c:	00004597          	auipc	a1,0x4
    80004960:	ecc58593          	addi	a1,a1,-308 # 80008828 <syscalls_name+0x2c0>
    80004964:	fb040513          	addi	a0,s0,-80
    80004968:	ffffe097          	auipc	ra,0xffffe
    8000496c:	712080e7          	jalr	1810(ra) # 8000307a <namecmp>
    80004970:	12050e63          	beqz	a0,80004aac <sys_unlink+0x1b0>
  if ((ip = dirlookup(dp, name, &off)) == 0)
    80004974:	f2c40613          	addi	a2,s0,-212
    80004978:	fb040593          	addi	a1,s0,-80
    8000497c:	8526                	mv	a0,s1
    8000497e:	ffffe097          	auipc	ra,0xffffe
    80004982:	716080e7          	jalr	1814(ra) # 80003094 <dirlookup>
    80004986:	892a                	mv	s2,a0
    80004988:	12050263          	beqz	a0,80004aac <sys_unlink+0x1b0>
  ilock(ip);
    8000498c:	ffffe097          	auipc	ra,0xffffe
    80004990:	224080e7          	jalr	548(ra) # 80002bb0 <ilock>
  if (ip->nlink < 1)
    80004994:	04a91783          	lh	a5,74(s2)
    80004998:	08f05263          	blez	a5,80004a1c <sys_unlink+0x120>
  if (ip->type == T_DIR && !isdirempty(ip))
    8000499c:	04491703          	lh	a4,68(s2)
    800049a0:	4785                	li	a5,1
    800049a2:	08f70563          	beq	a4,a5,80004a2c <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800049a6:	4641                	li	a2,16
    800049a8:	4581                	li	a1,0
    800049aa:	fc040513          	addi	a0,s0,-64
    800049ae:	ffffc097          	auipc	ra,0xffffc
    800049b2:	814080e7          	jalr	-2028(ra) # 800001c2 <memset>
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800049b6:	4741                	li	a4,16
    800049b8:	f2c42683          	lw	a3,-212(s0)
    800049bc:	fc040613          	addi	a2,s0,-64
    800049c0:	4581                	li	a1,0
    800049c2:	8526                	mv	a0,s1
    800049c4:	ffffe097          	auipc	ra,0xffffe
    800049c8:	598080e7          	jalr	1432(ra) # 80002f5c <writei>
    800049cc:	47c1                	li	a5,16
    800049ce:	0af51563          	bne	a0,a5,80004a78 <sys_unlink+0x17c>
  if (ip->type == T_DIR)
    800049d2:	04491703          	lh	a4,68(s2)
    800049d6:	4785                	li	a5,1
    800049d8:	0af70863          	beq	a4,a5,80004a88 <sys_unlink+0x18c>
  iunlockput(dp);
    800049dc:	8526                	mv	a0,s1
    800049de:	ffffe097          	auipc	ra,0xffffe
    800049e2:	434080e7          	jalr	1076(ra) # 80002e12 <iunlockput>
  ip->nlink--;
    800049e6:	04a95783          	lhu	a5,74(s2)
    800049ea:	37fd                	addiw	a5,a5,-1
    800049ec:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800049f0:	854a                	mv	a0,s2
    800049f2:	ffffe097          	auipc	ra,0xffffe
    800049f6:	0f4080e7          	jalr	244(ra) # 80002ae6 <iupdate>
  iunlockput(ip);
    800049fa:	854a                	mv	a0,s2
    800049fc:	ffffe097          	auipc	ra,0xffffe
    80004a00:	416080e7          	jalr	1046(ra) # 80002e12 <iunlockput>
  end_op();
    80004a04:	fffff097          	auipc	ra,0xfffff
    80004a08:	bfe080e7          	jalr	-1026(ra) # 80003602 <end_op>
  return 0;
    80004a0c:	4501                	li	a0,0
    80004a0e:	a84d                	j	80004ac0 <sys_unlink+0x1c4>
    end_op();
    80004a10:	fffff097          	auipc	ra,0xfffff
    80004a14:	bf2080e7          	jalr	-1038(ra) # 80003602 <end_op>
    return -1;
    80004a18:	557d                	li	a0,-1
    80004a1a:	a05d                	j	80004ac0 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004a1c:	00004517          	auipc	a0,0x4
    80004a20:	e3450513          	addi	a0,a0,-460 # 80008850 <syscalls_name+0x2e8>
    80004a24:	00001097          	auipc	ra,0x1
    80004a28:	244080e7          	jalr	580(ra) # 80005c68 <panic>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
    80004a2c:	04c92703          	lw	a4,76(s2)
    80004a30:	02000793          	li	a5,32
    80004a34:	f6e7f9e3          	bgeu	a5,a4,800049a6 <sys_unlink+0xaa>
    80004a38:	02000993          	li	s3,32
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a3c:	4741                	li	a4,16
    80004a3e:	86ce                	mv	a3,s3
    80004a40:	f1840613          	addi	a2,s0,-232
    80004a44:	4581                	li	a1,0
    80004a46:	854a                	mv	a0,s2
    80004a48:	ffffe097          	auipc	ra,0xffffe
    80004a4c:	41c080e7          	jalr	1052(ra) # 80002e64 <readi>
    80004a50:	47c1                	li	a5,16
    80004a52:	00f51b63          	bne	a0,a5,80004a68 <sys_unlink+0x16c>
    if (de.inum != 0)
    80004a56:	f1845783          	lhu	a5,-232(s0)
    80004a5a:	e7a1                	bnez	a5,80004aa2 <sys_unlink+0x1a6>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
    80004a5c:	29c1                	addiw	s3,s3,16
    80004a5e:	04c92783          	lw	a5,76(s2)
    80004a62:	fcf9ede3          	bltu	s3,a5,80004a3c <sys_unlink+0x140>
    80004a66:	b781                	j	800049a6 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004a68:	00004517          	auipc	a0,0x4
    80004a6c:	e0050513          	addi	a0,a0,-512 # 80008868 <syscalls_name+0x300>
    80004a70:	00001097          	auipc	ra,0x1
    80004a74:	1f8080e7          	jalr	504(ra) # 80005c68 <panic>
    panic("unlink: writei");
    80004a78:	00004517          	auipc	a0,0x4
    80004a7c:	e0850513          	addi	a0,a0,-504 # 80008880 <syscalls_name+0x318>
    80004a80:	00001097          	auipc	ra,0x1
    80004a84:	1e8080e7          	jalr	488(ra) # 80005c68 <panic>
    dp->nlink--;
    80004a88:	04a4d783          	lhu	a5,74(s1)
    80004a8c:	37fd                	addiw	a5,a5,-1
    80004a8e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004a92:	8526                	mv	a0,s1
    80004a94:	ffffe097          	auipc	ra,0xffffe
    80004a98:	052080e7          	jalr	82(ra) # 80002ae6 <iupdate>
    80004a9c:	b781                	j	800049dc <sys_unlink+0xe0>
    return -1;
    80004a9e:	557d                	li	a0,-1
    80004aa0:	a005                	j	80004ac0 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004aa2:	854a                	mv	a0,s2
    80004aa4:	ffffe097          	auipc	ra,0xffffe
    80004aa8:	36e080e7          	jalr	878(ra) # 80002e12 <iunlockput>
  iunlockput(dp);
    80004aac:	8526                	mv	a0,s1
    80004aae:	ffffe097          	auipc	ra,0xffffe
    80004ab2:	364080e7          	jalr	868(ra) # 80002e12 <iunlockput>
  end_op();
    80004ab6:	fffff097          	auipc	ra,0xfffff
    80004aba:	b4c080e7          	jalr	-1204(ra) # 80003602 <end_op>
  return -1;
    80004abe:	557d                	li	a0,-1
}
    80004ac0:	70ae                	ld	ra,232(sp)
    80004ac2:	740e                	ld	s0,224(sp)
    80004ac4:	64ee                	ld	s1,216(sp)
    80004ac6:	694e                	ld	s2,208(sp)
    80004ac8:	69ae                	ld	s3,200(sp)
    80004aca:	616d                	addi	sp,sp,240
    80004acc:	8082                	ret

0000000080004ace <sys_open>:

uint64
sys_open(void)
{
    80004ace:	7131                	addi	sp,sp,-192
    80004ad0:	fd06                	sd	ra,184(sp)
    80004ad2:	f922                	sd	s0,176(sp)
    80004ad4:	f526                	sd	s1,168(sp)
    80004ad6:	f14a                	sd	s2,160(sp)
    80004ad8:	ed4e                	sd	s3,152(sp)
    80004ada:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if ((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004adc:	08000613          	li	a2,128
    80004ae0:	f5040593          	addi	a1,s0,-176
    80004ae4:	4501                	li	a0,0
    80004ae6:	ffffd097          	auipc	ra,0xffffd
    80004aea:	4e2080e7          	jalr	1250(ra) # 80001fc8 <argstr>
    return -1;
    80004aee:	54fd                	li	s1,-1
  if ((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004af0:	0c054163          	bltz	a0,80004bb2 <sys_open+0xe4>
    80004af4:	f4c40593          	addi	a1,s0,-180
    80004af8:	4505                	li	a0,1
    80004afa:	ffffd097          	auipc	ra,0xffffd
    80004afe:	48a080e7          	jalr	1162(ra) # 80001f84 <argint>
    80004b02:	0a054863          	bltz	a0,80004bb2 <sys_open+0xe4>

  begin_op();
    80004b06:	fffff097          	auipc	ra,0xfffff
    80004b0a:	a7c080e7          	jalr	-1412(ra) # 80003582 <begin_op>

  if (omode & O_CREATE)
    80004b0e:	f4c42783          	lw	a5,-180(s0)
    80004b12:	2007f793          	andi	a5,a5,512
    80004b16:	cbdd                	beqz	a5,80004bcc <sys_open+0xfe>
  {
    ip = create(path, T_FILE, 0, 0);
    80004b18:	4681                	li	a3,0
    80004b1a:	4601                	li	a2,0
    80004b1c:	4589                	li	a1,2
    80004b1e:	f5040513          	addi	a0,s0,-176
    80004b22:	00000097          	auipc	ra,0x0
    80004b26:	9c0080e7          	jalr	-1600(ra) # 800044e2 <create>
    80004b2a:	892a                	mv	s2,a0
    if (ip == 0)
    80004b2c:	c959                	beqz	a0,80004bc2 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV))
    80004b2e:	04491703          	lh	a4,68(s2)
    80004b32:	478d                	li	a5,3
    80004b34:	00f71763          	bne	a4,a5,80004b42 <sys_open+0x74>
    80004b38:	04695703          	lhu	a4,70(s2)
    80004b3c:	47a5                	li	a5,9
    80004b3e:	0ce7ec63          	bltu	a5,a4,80004c16 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
    80004b42:	fffff097          	auipc	ra,0xfffff
    80004b46:	e50080e7          	jalr	-432(ra) # 80003992 <filealloc>
    80004b4a:	89aa                	mv	s3,a0
    80004b4c:	10050263          	beqz	a0,80004c50 <sys_open+0x182>
    80004b50:	00000097          	auipc	ra,0x0
    80004b54:	950080e7          	jalr	-1712(ra) # 800044a0 <fdalloc>
    80004b58:	84aa                	mv	s1,a0
    80004b5a:	0e054663          	bltz	a0,80004c46 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if (ip->type == T_DEVICE)
    80004b5e:	04491703          	lh	a4,68(s2)
    80004b62:	478d                	li	a5,3
    80004b64:	0cf70463          	beq	a4,a5,80004c2c <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  }
  else
  {
    f->type = FD_INODE;
    80004b68:	4789                	li	a5,2
    80004b6a:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004b6e:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004b72:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004b76:	f4c42783          	lw	a5,-180(s0)
    80004b7a:	0017c713          	xori	a4,a5,1
    80004b7e:	8b05                	andi	a4,a4,1
    80004b80:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004b84:	0037f713          	andi	a4,a5,3
    80004b88:	00e03733          	snez	a4,a4
    80004b8c:	00e984a3          	sb	a4,9(s3)

  if ((omode & O_TRUNC) && ip->type == T_FILE)
    80004b90:	4007f793          	andi	a5,a5,1024
    80004b94:	c791                	beqz	a5,80004ba0 <sys_open+0xd2>
    80004b96:	04491703          	lh	a4,68(s2)
    80004b9a:	4789                	li	a5,2
    80004b9c:	08f70f63          	beq	a4,a5,80004c3a <sys_open+0x16c>
  {
    itrunc(ip);
  }

  iunlock(ip);
    80004ba0:	854a                	mv	a0,s2
    80004ba2:	ffffe097          	auipc	ra,0xffffe
    80004ba6:	0d0080e7          	jalr	208(ra) # 80002c72 <iunlock>
  end_op();
    80004baa:	fffff097          	auipc	ra,0xfffff
    80004bae:	a58080e7          	jalr	-1448(ra) # 80003602 <end_op>

  return fd;
}
    80004bb2:	8526                	mv	a0,s1
    80004bb4:	70ea                	ld	ra,184(sp)
    80004bb6:	744a                	ld	s0,176(sp)
    80004bb8:	74aa                	ld	s1,168(sp)
    80004bba:	790a                	ld	s2,160(sp)
    80004bbc:	69ea                	ld	s3,152(sp)
    80004bbe:	6129                	addi	sp,sp,192
    80004bc0:	8082                	ret
      end_op();
    80004bc2:	fffff097          	auipc	ra,0xfffff
    80004bc6:	a40080e7          	jalr	-1472(ra) # 80003602 <end_op>
      return -1;
    80004bca:	b7e5                	j	80004bb2 <sys_open+0xe4>
    if ((ip = namei(path)) == 0)
    80004bcc:	f5040513          	addi	a0,s0,-176
    80004bd0:	ffffe097          	auipc	ra,0xffffe
    80004bd4:	796080e7          	jalr	1942(ra) # 80003366 <namei>
    80004bd8:	892a                	mv	s2,a0
    80004bda:	c905                	beqz	a0,80004c0a <sys_open+0x13c>
    ilock(ip);
    80004bdc:	ffffe097          	auipc	ra,0xffffe
    80004be0:	fd4080e7          	jalr	-44(ra) # 80002bb0 <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY)
    80004be4:	04491703          	lh	a4,68(s2)
    80004be8:	4785                	li	a5,1
    80004bea:	f4f712e3          	bne	a4,a5,80004b2e <sys_open+0x60>
    80004bee:	f4c42783          	lw	a5,-180(s0)
    80004bf2:	dba1                	beqz	a5,80004b42 <sys_open+0x74>
      iunlockput(ip);
    80004bf4:	854a                	mv	a0,s2
    80004bf6:	ffffe097          	auipc	ra,0xffffe
    80004bfa:	21c080e7          	jalr	540(ra) # 80002e12 <iunlockput>
      end_op();
    80004bfe:	fffff097          	auipc	ra,0xfffff
    80004c02:	a04080e7          	jalr	-1532(ra) # 80003602 <end_op>
      return -1;
    80004c06:	54fd                	li	s1,-1
    80004c08:	b76d                	j	80004bb2 <sys_open+0xe4>
      end_op();
    80004c0a:	fffff097          	auipc	ra,0xfffff
    80004c0e:	9f8080e7          	jalr	-1544(ra) # 80003602 <end_op>
      return -1;
    80004c12:	54fd                	li	s1,-1
    80004c14:	bf79                	j	80004bb2 <sys_open+0xe4>
    iunlockput(ip);
    80004c16:	854a                	mv	a0,s2
    80004c18:	ffffe097          	auipc	ra,0xffffe
    80004c1c:	1fa080e7          	jalr	506(ra) # 80002e12 <iunlockput>
    end_op();
    80004c20:	fffff097          	auipc	ra,0xfffff
    80004c24:	9e2080e7          	jalr	-1566(ra) # 80003602 <end_op>
    return -1;
    80004c28:	54fd                	li	s1,-1
    80004c2a:	b761                	j	80004bb2 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004c2c:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004c30:	04691783          	lh	a5,70(s2)
    80004c34:	02f99223          	sh	a5,36(s3)
    80004c38:	bf2d                	j	80004b72 <sys_open+0xa4>
    itrunc(ip);
    80004c3a:	854a                	mv	a0,s2
    80004c3c:	ffffe097          	auipc	ra,0xffffe
    80004c40:	082080e7          	jalr	130(ra) # 80002cbe <itrunc>
    80004c44:	bfb1                	j	80004ba0 <sys_open+0xd2>
      fileclose(f);
    80004c46:	854e                	mv	a0,s3
    80004c48:	fffff097          	auipc	ra,0xfffff
    80004c4c:	e06080e7          	jalr	-506(ra) # 80003a4e <fileclose>
    iunlockput(ip);
    80004c50:	854a                	mv	a0,s2
    80004c52:	ffffe097          	auipc	ra,0xffffe
    80004c56:	1c0080e7          	jalr	448(ra) # 80002e12 <iunlockput>
    end_op();
    80004c5a:	fffff097          	auipc	ra,0xfffff
    80004c5e:	9a8080e7          	jalr	-1624(ra) # 80003602 <end_op>
    return -1;
    80004c62:	54fd                	li	s1,-1
    80004c64:	b7b9                	j	80004bb2 <sys_open+0xe4>

0000000080004c66 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004c66:	7175                	addi	sp,sp,-144
    80004c68:	e506                	sd	ra,136(sp)
    80004c6a:	e122                	sd	s0,128(sp)
    80004c6c:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004c6e:	fffff097          	auipc	ra,0xfffff
    80004c72:	914080e7          	jalr	-1772(ra) # 80003582 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
    80004c76:	08000613          	li	a2,128
    80004c7a:	f7040593          	addi	a1,s0,-144
    80004c7e:	4501                	li	a0,0
    80004c80:	ffffd097          	auipc	ra,0xffffd
    80004c84:	348080e7          	jalr	840(ra) # 80001fc8 <argstr>
    80004c88:	02054963          	bltz	a0,80004cba <sys_mkdir+0x54>
    80004c8c:	4681                	li	a3,0
    80004c8e:	4601                	li	a2,0
    80004c90:	4585                	li	a1,1
    80004c92:	f7040513          	addi	a0,s0,-144
    80004c96:	00000097          	auipc	ra,0x0
    80004c9a:	84c080e7          	jalr	-1972(ra) # 800044e2 <create>
    80004c9e:	cd11                	beqz	a0,80004cba <sys_mkdir+0x54>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004ca0:	ffffe097          	auipc	ra,0xffffe
    80004ca4:	172080e7          	jalr	370(ra) # 80002e12 <iunlockput>
  end_op();
    80004ca8:	fffff097          	auipc	ra,0xfffff
    80004cac:	95a080e7          	jalr	-1702(ra) # 80003602 <end_op>
  return 0;
    80004cb0:	4501                	li	a0,0
}
    80004cb2:	60aa                	ld	ra,136(sp)
    80004cb4:	640a                	ld	s0,128(sp)
    80004cb6:	6149                	addi	sp,sp,144
    80004cb8:	8082                	ret
    end_op();
    80004cba:	fffff097          	auipc	ra,0xfffff
    80004cbe:	948080e7          	jalr	-1720(ra) # 80003602 <end_op>
    return -1;
    80004cc2:	557d                	li	a0,-1
    80004cc4:	b7fd                	j	80004cb2 <sys_mkdir+0x4c>

0000000080004cc6 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004cc6:	7135                	addi	sp,sp,-160
    80004cc8:	ed06                	sd	ra,152(sp)
    80004cca:	e922                	sd	s0,144(sp)
    80004ccc:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004cce:	fffff097          	auipc	ra,0xfffff
    80004cd2:	8b4080e7          	jalr	-1868(ra) # 80003582 <begin_op>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80004cd6:	08000613          	li	a2,128
    80004cda:	f7040593          	addi	a1,s0,-144
    80004cde:	4501                	li	a0,0
    80004ce0:	ffffd097          	auipc	ra,0xffffd
    80004ce4:	2e8080e7          	jalr	744(ra) # 80001fc8 <argstr>
    80004ce8:	04054a63          	bltz	a0,80004d3c <sys_mknod+0x76>
      argint(1, &major) < 0 ||
    80004cec:	f6c40593          	addi	a1,s0,-148
    80004cf0:	4505                	li	a0,1
    80004cf2:	ffffd097          	auipc	ra,0xffffd
    80004cf6:	292080e7          	jalr	658(ra) # 80001f84 <argint>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80004cfa:	04054163          	bltz	a0,80004d3c <sys_mknod+0x76>
      argint(2, &minor) < 0 ||
    80004cfe:	f6840593          	addi	a1,s0,-152
    80004d02:	4509                	li	a0,2
    80004d04:	ffffd097          	auipc	ra,0xffffd
    80004d08:	280080e7          	jalr	640(ra) # 80001f84 <argint>
      argint(1, &major) < 0 ||
    80004d0c:	02054863          	bltz	a0,80004d3c <sys_mknod+0x76>
      (ip = create(path, T_DEVICE, major, minor)) == 0)
    80004d10:	f6841683          	lh	a3,-152(s0)
    80004d14:	f6c41603          	lh	a2,-148(s0)
    80004d18:	458d                	li	a1,3
    80004d1a:	f7040513          	addi	a0,s0,-144
    80004d1e:	fffff097          	auipc	ra,0xfffff
    80004d22:	7c4080e7          	jalr	1988(ra) # 800044e2 <create>
      argint(2, &minor) < 0 ||
    80004d26:	c919                	beqz	a0,80004d3c <sys_mknod+0x76>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d28:	ffffe097          	auipc	ra,0xffffe
    80004d2c:	0ea080e7          	jalr	234(ra) # 80002e12 <iunlockput>
  end_op();
    80004d30:	fffff097          	auipc	ra,0xfffff
    80004d34:	8d2080e7          	jalr	-1838(ra) # 80003602 <end_op>
  return 0;
    80004d38:	4501                	li	a0,0
    80004d3a:	a031                	j	80004d46 <sys_mknod+0x80>
    end_op();
    80004d3c:	fffff097          	auipc	ra,0xfffff
    80004d40:	8c6080e7          	jalr	-1850(ra) # 80003602 <end_op>
    return -1;
    80004d44:	557d                	li	a0,-1
}
    80004d46:	60ea                	ld	ra,152(sp)
    80004d48:	644a                	ld	s0,144(sp)
    80004d4a:	610d                	addi	sp,sp,160
    80004d4c:	8082                	ret

0000000080004d4e <sys_chdir>:

uint64
sys_chdir(void)
{
    80004d4e:	7135                	addi	sp,sp,-160
    80004d50:	ed06                	sd	ra,152(sp)
    80004d52:	e922                	sd	s0,144(sp)
    80004d54:	e526                	sd	s1,136(sp)
    80004d56:	e14a                	sd	s2,128(sp)
    80004d58:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004d5a:	ffffc097          	auipc	ra,0xffffc
    80004d5e:	138080e7          	jalr	312(ra) # 80000e92 <myproc>
    80004d62:	892a                	mv	s2,a0

  begin_op();
    80004d64:	fffff097          	auipc	ra,0xfffff
    80004d68:	81e080e7          	jalr	-2018(ra) # 80003582 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0)
    80004d6c:	08000613          	li	a2,128
    80004d70:	f6040593          	addi	a1,s0,-160
    80004d74:	4501                	li	a0,0
    80004d76:	ffffd097          	auipc	ra,0xffffd
    80004d7a:	252080e7          	jalr	594(ra) # 80001fc8 <argstr>
    80004d7e:	04054b63          	bltz	a0,80004dd4 <sys_chdir+0x86>
    80004d82:	f6040513          	addi	a0,s0,-160
    80004d86:	ffffe097          	auipc	ra,0xffffe
    80004d8a:	5e0080e7          	jalr	1504(ra) # 80003366 <namei>
    80004d8e:	84aa                	mv	s1,a0
    80004d90:	c131                	beqz	a0,80004dd4 <sys_chdir+0x86>
  {
    end_op();
    return -1;
  }
  ilock(ip);
    80004d92:	ffffe097          	auipc	ra,0xffffe
    80004d96:	e1e080e7          	jalr	-482(ra) # 80002bb0 <ilock>
  if (ip->type != T_DIR)
    80004d9a:	04449703          	lh	a4,68(s1)
    80004d9e:	4785                	li	a5,1
    80004da0:	04f71063          	bne	a4,a5,80004de0 <sys_chdir+0x92>
  {
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004da4:	8526                	mv	a0,s1
    80004da6:	ffffe097          	auipc	ra,0xffffe
    80004daa:	ecc080e7          	jalr	-308(ra) # 80002c72 <iunlock>
  iput(p->cwd);
    80004dae:	15893503          	ld	a0,344(s2)
    80004db2:	ffffe097          	auipc	ra,0xffffe
    80004db6:	fb8080e7          	jalr	-72(ra) # 80002d6a <iput>
  end_op();
    80004dba:	fffff097          	auipc	ra,0xfffff
    80004dbe:	848080e7          	jalr	-1976(ra) # 80003602 <end_op>
  p->cwd = ip;
    80004dc2:	14993c23          	sd	s1,344(s2)
  return 0;
    80004dc6:	4501                	li	a0,0
}
    80004dc8:	60ea                	ld	ra,152(sp)
    80004dca:	644a                	ld	s0,144(sp)
    80004dcc:	64aa                	ld	s1,136(sp)
    80004dce:	690a                	ld	s2,128(sp)
    80004dd0:	610d                	addi	sp,sp,160
    80004dd2:	8082                	ret
    end_op();
    80004dd4:	fffff097          	auipc	ra,0xfffff
    80004dd8:	82e080e7          	jalr	-2002(ra) # 80003602 <end_op>
    return -1;
    80004ddc:	557d                	li	a0,-1
    80004dde:	b7ed                	j	80004dc8 <sys_chdir+0x7a>
    iunlockput(ip);
    80004de0:	8526                	mv	a0,s1
    80004de2:	ffffe097          	auipc	ra,0xffffe
    80004de6:	030080e7          	jalr	48(ra) # 80002e12 <iunlockput>
    end_op();
    80004dea:	fffff097          	auipc	ra,0xfffff
    80004dee:	818080e7          	jalr	-2024(ra) # 80003602 <end_op>
    return -1;
    80004df2:	557d                	li	a0,-1
    80004df4:	bfd1                	j	80004dc8 <sys_chdir+0x7a>

0000000080004df6 <sys_exec>:

uint64
sys_exec(void)
{
    80004df6:	7145                	addi	sp,sp,-464
    80004df8:	e786                	sd	ra,456(sp)
    80004dfa:	e3a2                	sd	s0,448(sp)
    80004dfc:	ff26                	sd	s1,440(sp)
    80004dfe:	fb4a                	sd	s2,432(sp)
    80004e00:	f74e                	sd	s3,424(sp)
    80004e02:	f352                	sd	s4,416(sp)
    80004e04:	ef56                	sd	s5,408(sp)
    80004e06:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if (argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0)
    80004e08:	08000613          	li	a2,128
    80004e0c:	f4040593          	addi	a1,s0,-192
    80004e10:	4501                	li	a0,0
    80004e12:	ffffd097          	auipc	ra,0xffffd
    80004e16:	1b6080e7          	jalr	438(ra) # 80001fc8 <argstr>
  {
    return -1;
    80004e1a:	597d                	li	s2,-1
  if (argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0)
    80004e1c:	0c054a63          	bltz	a0,80004ef0 <sys_exec+0xfa>
    80004e20:	e3840593          	addi	a1,s0,-456
    80004e24:	4505                	li	a0,1
    80004e26:	ffffd097          	auipc	ra,0xffffd
    80004e2a:	180080e7          	jalr	384(ra) # 80001fa6 <argaddr>
    80004e2e:	0c054163          	bltz	a0,80004ef0 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004e32:	10000613          	li	a2,256
    80004e36:	4581                	li	a1,0
    80004e38:	e4040513          	addi	a0,s0,-448
    80004e3c:	ffffb097          	auipc	ra,0xffffb
    80004e40:	386080e7          	jalr	902(ra) # 800001c2 <memset>
  for (i = 0;; i++)
  {
    if (i >= NELEM(argv))
    80004e44:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004e48:	89a6                	mv	s3,s1
    80004e4a:	4901                	li	s2,0
    if (i >= NELEM(argv))
    80004e4c:	02000a13          	li	s4,32
    80004e50:	00090a9b          	sext.w	s5,s2
    {
      goto bad;
    }
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0)
    80004e54:	00391513          	slli	a0,s2,0x3
    80004e58:	e3040593          	addi	a1,s0,-464
    80004e5c:	e3843783          	ld	a5,-456(s0)
    80004e60:	953e                	add	a0,a0,a5
    80004e62:	ffffd097          	auipc	ra,0xffffd
    80004e66:	088080e7          	jalr	136(ra) # 80001eea <fetchaddr>
    80004e6a:	02054a63          	bltz	a0,80004e9e <sys_exec+0xa8>
    {
      goto bad;
    }
    if (uarg == 0)
    80004e6e:	e3043783          	ld	a5,-464(s0)
    80004e72:	c3b9                	beqz	a5,80004eb8 <sys_exec+0xc2>
    {
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004e74:	ffffb097          	auipc	ra,0xffffb
    80004e78:	2a4080e7          	jalr	676(ra) # 80000118 <kalloc>
    80004e7c:	85aa                	mv	a1,a0
    80004e7e:	00a9b023          	sd	a0,0(s3)
    if (argv[i] == 0)
    80004e82:	cd11                	beqz	a0,80004e9e <sys_exec+0xa8>
      goto bad;
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004e84:	6605                	lui	a2,0x1
    80004e86:	e3043503          	ld	a0,-464(s0)
    80004e8a:	ffffd097          	auipc	ra,0xffffd
    80004e8e:	0b2080e7          	jalr	178(ra) # 80001f3c <fetchstr>
    80004e92:	00054663          	bltz	a0,80004e9e <sys_exec+0xa8>
    if (i >= NELEM(argv))
    80004e96:	0905                	addi	s2,s2,1
    80004e98:	09a1                	addi	s3,s3,8
    80004e9a:	fb491be3          	bne	s2,s4,80004e50 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

bad:
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e9e:	10048913          	addi	s2,s1,256
    80004ea2:	6088                	ld	a0,0(s1)
    80004ea4:	c529                	beqz	a0,80004eee <sys_exec+0xf8>
    kfree(argv[i]);
    80004ea6:	ffffb097          	auipc	ra,0xffffb
    80004eaa:	176080e7          	jalr	374(ra) # 8000001c <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004eae:	04a1                	addi	s1,s1,8
    80004eb0:	ff2499e3          	bne	s1,s2,80004ea2 <sys_exec+0xac>
  return -1;
    80004eb4:	597d                	li	s2,-1
    80004eb6:	a82d                	j	80004ef0 <sys_exec+0xfa>
      argv[i] = 0;
    80004eb8:	0a8e                	slli	s5,s5,0x3
    80004eba:	fc040793          	addi	a5,s0,-64
    80004ebe:	9abe                	add	s5,s5,a5
    80004ec0:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004ec4:	e4040593          	addi	a1,s0,-448
    80004ec8:	f4040513          	addi	a0,s0,-192
    80004ecc:	fffff097          	auipc	ra,0xfffff
    80004ed0:	1e2080e7          	jalr	482(ra) # 800040ae <exec>
    80004ed4:	892a                	mv	s2,a0
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ed6:	10048993          	addi	s3,s1,256
    80004eda:	6088                	ld	a0,0(s1)
    80004edc:	c911                	beqz	a0,80004ef0 <sys_exec+0xfa>
    kfree(argv[i]);
    80004ede:	ffffb097          	auipc	ra,0xffffb
    80004ee2:	13e080e7          	jalr	318(ra) # 8000001c <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ee6:	04a1                	addi	s1,s1,8
    80004ee8:	ff3499e3          	bne	s1,s3,80004eda <sys_exec+0xe4>
    80004eec:	a011                	j	80004ef0 <sys_exec+0xfa>
  return -1;
    80004eee:	597d                	li	s2,-1
}
    80004ef0:	854a                	mv	a0,s2
    80004ef2:	60be                	ld	ra,456(sp)
    80004ef4:	641e                	ld	s0,448(sp)
    80004ef6:	74fa                	ld	s1,440(sp)
    80004ef8:	795a                	ld	s2,432(sp)
    80004efa:	79ba                	ld	s3,424(sp)
    80004efc:	7a1a                	ld	s4,416(sp)
    80004efe:	6afa                	ld	s5,408(sp)
    80004f00:	6179                	addi	sp,sp,464
    80004f02:	8082                	ret

0000000080004f04 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f04:	7139                	addi	sp,sp,-64
    80004f06:	fc06                	sd	ra,56(sp)
    80004f08:	f822                	sd	s0,48(sp)
    80004f0a:	f426                	sd	s1,40(sp)
    80004f0c:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f0e:	ffffc097          	auipc	ra,0xffffc
    80004f12:	f84080e7          	jalr	-124(ra) # 80000e92 <myproc>
    80004f16:	84aa                	mv	s1,a0

  if (argaddr(0, &fdarray) < 0)
    80004f18:	fd840593          	addi	a1,s0,-40
    80004f1c:	4501                	li	a0,0
    80004f1e:	ffffd097          	auipc	ra,0xffffd
    80004f22:	088080e7          	jalr	136(ra) # 80001fa6 <argaddr>
    return -1;
    80004f26:	57fd                	li	a5,-1
  if (argaddr(0, &fdarray) < 0)
    80004f28:	0e054063          	bltz	a0,80005008 <sys_pipe+0x104>
  if (pipealloc(&rf, &wf) < 0)
    80004f2c:	fc840593          	addi	a1,s0,-56
    80004f30:	fd040513          	addi	a0,s0,-48
    80004f34:	fffff097          	auipc	ra,0xfffff
    80004f38:	e4a080e7          	jalr	-438(ra) # 80003d7e <pipealloc>
    return -1;
    80004f3c:	57fd                	li	a5,-1
  if (pipealloc(&rf, &wf) < 0)
    80004f3e:	0c054563          	bltz	a0,80005008 <sys_pipe+0x104>
  fd0 = -1;
    80004f42:	fcf42223          	sw	a5,-60(s0)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
    80004f46:	fd043503          	ld	a0,-48(s0)
    80004f4a:	fffff097          	auipc	ra,0xfffff
    80004f4e:	556080e7          	jalr	1366(ra) # 800044a0 <fdalloc>
    80004f52:	fca42223          	sw	a0,-60(s0)
    80004f56:	08054c63          	bltz	a0,80004fee <sys_pipe+0xea>
    80004f5a:	fc843503          	ld	a0,-56(s0)
    80004f5e:	fffff097          	auipc	ra,0xfffff
    80004f62:	542080e7          	jalr	1346(ra) # 800044a0 <fdalloc>
    80004f66:	fca42023          	sw	a0,-64(s0)
    80004f6a:	06054863          	bltz	a0,80004fda <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80004f6e:	4691                	li	a3,4
    80004f70:	fc440613          	addi	a2,s0,-60
    80004f74:	fd843583          	ld	a1,-40(s0)
    80004f78:	6ca8                	ld	a0,88(s1)
    80004f7a:	ffffc097          	auipc	ra,0xffffc
    80004f7e:	bda080e7          	jalr	-1062(ra) # 80000b54 <copyout>
    80004f82:	02054063          	bltz	a0,80004fa2 <sys_pipe+0x9e>
      copyout(p->pagetable, fdarray + sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0)
    80004f86:	4691                	li	a3,4
    80004f88:	fc040613          	addi	a2,s0,-64
    80004f8c:	fd843583          	ld	a1,-40(s0)
    80004f90:	0591                	addi	a1,a1,4
    80004f92:	6ca8                	ld	a0,88(s1)
    80004f94:	ffffc097          	auipc	ra,0xffffc
    80004f98:	bc0080e7          	jalr	-1088(ra) # 80000b54 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004f9c:	4781                	li	a5,0
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80004f9e:	06055563          	bgez	a0,80005008 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80004fa2:	fc442783          	lw	a5,-60(s0)
    80004fa6:	07e9                	addi	a5,a5,26
    80004fa8:	078e                	slli	a5,a5,0x3
    80004faa:	97a6                	add	a5,a5,s1
    80004fac:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80004fb0:	fc042503          	lw	a0,-64(s0)
    80004fb4:	0569                	addi	a0,a0,26
    80004fb6:	050e                	slli	a0,a0,0x3
    80004fb8:	9526                	add	a0,a0,s1
    80004fba:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    80004fbe:	fd043503          	ld	a0,-48(s0)
    80004fc2:	fffff097          	auipc	ra,0xfffff
    80004fc6:	a8c080e7          	jalr	-1396(ra) # 80003a4e <fileclose>
    fileclose(wf);
    80004fca:	fc843503          	ld	a0,-56(s0)
    80004fce:	fffff097          	auipc	ra,0xfffff
    80004fd2:	a80080e7          	jalr	-1408(ra) # 80003a4e <fileclose>
    return -1;
    80004fd6:	57fd                	li	a5,-1
    80004fd8:	a805                	j	80005008 <sys_pipe+0x104>
    if (fd0 >= 0)
    80004fda:	fc442783          	lw	a5,-60(s0)
    80004fde:	0007c863          	bltz	a5,80004fee <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80004fe2:	01a78513          	addi	a0,a5,26
    80004fe6:	050e                	slli	a0,a0,0x3
    80004fe8:	9526                	add	a0,a0,s1
    80004fea:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    80004fee:	fd043503          	ld	a0,-48(s0)
    80004ff2:	fffff097          	auipc	ra,0xfffff
    80004ff6:	a5c080e7          	jalr	-1444(ra) # 80003a4e <fileclose>
    fileclose(wf);
    80004ffa:	fc843503          	ld	a0,-56(s0)
    80004ffe:	fffff097          	auipc	ra,0xfffff
    80005002:	a50080e7          	jalr	-1456(ra) # 80003a4e <fileclose>
    return -1;
    80005006:	57fd                	li	a5,-1
}
    80005008:	853e                	mv	a0,a5
    8000500a:	70e2                	ld	ra,56(sp)
    8000500c:	7442                	ld	s0,48(sp)
    8000500e:	74a2                	ld	s1,40(sp)
    80005010:	6121                	addi	sp,sp,64
    80005012:	8082                	ret

0000000080005014 <sys_fstat>:

uint64
sys_fstat(void)
{
    80005014:	1101                	addi	sp,sp,-32
    80005016:	ec06                	sd	ra,24(sp)
    80005018:	e822                	sd	s0,16(sp)
    8000501a:	1000                	addi	s0,sp,32
  struct file *f;
  uint64 st; // user pointer to struct stat

  if (argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000501c:	fe840613          	addi	a2,s0,-24
    80005020:	4581                	li	a1,0
    80005022:	4501                	li	a0,0
    80005024:	fffff097          	auipc	ra,0xfffff
    80005028:	414080e7          	jalr	1044(ra) # 80004438 <argfd>
    return -1;
    8000502c:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000502e:	02054563          	bltz	a0,80005058 <sys_fstat+0x44>
    80005032:	fe040593          	addi	a1,s0,-32
    80005036:	4505                	li	a0,1
    80005038:	ffffd097          	auipc	ra,0xffffd
    8000503c:	f6e080e7          	jalr	-146(ra) # 80001fa6 <argaddr>
    return -1;
    80005040:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005042:	00054b63          	bltz	a0,80005058 <sys_fstat+0x44>
  return filestat(f, st);
    80005046:	fe043583          	ld	a1,-32(s0)
    8000504a:	fe843503          	ld	a0,-24(s0)
    8000504e:	fffff097          	auipc	ra,0xfffff
    80005052:	ac8080e7          	jalr	-1336(ra) # 80003b16 <filestat>
    80005056:	87aa                	mv	a5,a0
    80005058:	853e                	mv	a0,a5
    8000505a:	60e2                	ld	ra,24(sp)
    8000505c:	6442                	ld	s0,16(sp)
    8000505e:	6105                	addi	sp,sp,32
    80005060:	8082                	ret
	...

0000000080005070 <kernelvec>:
    80005070:	7111                	addi	sp,sp,-256
    80005072:	e006                	sd	ra,0(sp)
    80005074:	e40a                	sd	sp,8(sp)
    80005076:	e80e                	sd	gp,16(sp)
    80005078:	ec12                	sd	tp,24(sp)
    8000507a:	f016                	sd	t0,32(sp)
    8000507c:	f41a                	sd	t1,40(sp)
    8000507e:	f81e                	sd	t2,48(sp)
    80005080:	fc22                	sd	s0,56(sp)
    80005082:	e0a6                	sd	s1,64(sp)
    80005084:	e4aa                	sd	a0,72(sp)
    80005086:	e8ae                	sd	a1,80(sp)
    80005088:	ecb2                	sd	a2,88(sp)
    8000508a:	f0b6                	sd	a3,96(sp)
    8000508c:	f4ba                	sd	a4,104(sp)
    8000508e:	f8be                	sd	a5,112(sp)
    80005090:	fcc2                	sd	a6,120(sp)
    80005092:	e146                	sd	a7,128(sp)
    80005094:	e54a                	sd	s2,136(sp)
    80005096:	e94e                	sd	s3,144(sp)
    80005098:	ed52                	sd	s4,152(sp)
    8000509a:	f156                	sd	s5,160(sp)
    8000509c:	f55a                	sd	s6,168(sp)
    8000509e:	f95e                	sd	s7,176(sp)
    800050a0:	fd62                	sd	s8,184(sp)
    800050a2:	e1e6                	sd	s9,192(sp)
    800050a4:	e5ea                	sd	s10,200(sp)
    800050a6:	e9ee                	sd	s11,208(sp)
    800050a8:	edf2                	sd	t3,216(sp)
    800050aa:	f1f6                	sd	t4,224(sp)
    800050ac:	f5fa                	sd	t5,232(sp)
    800050ae:	f9fe                	sd	t6,240(sp)
    800050b0:	d07fc0ef          	jal	ra,80001db6 <kerneltrap>
    800050b4:	6082                	ld	ra,0(sp)
    800050b6:	6122                	ld	sp,8(sp)
    800050b8:	61c2                	ld	gp,16(sp)
    800050ba:	7282                	ld	t0,32(sp)
    800050bc:	7322                	ld	t1,40(sp)
    800050be:	73c2                	ld	t2,48(sp)
    800050c0:	7462                	ld	s0,56(sp)
    800050c2:	6486                	ld	s1,64(sp)
    800050c4:	6526                	ld	a0,72(sp)
    800050c6:	65c6                	ld	a1,80(sp)
    800050c8:	6666                	ld	a2,88(sp)
    800050ca:	7686                	ld	a3,96(sp)
    800050cc:	7726                	ld	a4,104(sp)
    800050ce:	77c6                	ld	a5,112(sp)
    800050d0:	7866                	ld	a6,120(sp)
    800050d2:	688a                	ld	a7,128(sp)
    800050d4:	692a                	ld	s2,136(sp)
    800050d6:	69ca                	ld	s3,144(sp)
    800050d8:	6a6a                	ld	s4,152(sp)
    800050da:	7a8a                	ld	s5,160(sp)
    800050dc:	7b2a                	ld	s6,168(sp)
    800050de:	7bca                	ld	s7,176(sp)
    800050e0:	7c6a                	ld	s8,184(sp)
    800050e2:	6c8e                	ld	s9,192(sp)
    800050e4:	6d2e                	ld	s10,200(sp)
    800050e6:	6dce                	ld	s11,208(sp)
    800050e8:	6e6e                	ld	t3,216(sp)
    800050ea:	7e8e                	ld	t4,224(sp)
    800050ec:	7f2e                	ld	t5,232(sp)
    800050ee:	7fce                	ld	t6,240(sp)
    800050f0:	6111                	addi	sp,sp,256
    800050f2:	10200073          	sret
    800050f6:	00000013          	nop
    800050fa:	00000013          	nop
    800050fe:	0001                	nop

0000000080005100 <timervec>:
    80005100:	34051573          	csrrw	a0,mscratch,a0
    80005104:	e10c                	sd	a1,0(a0)
    80005106:	e510                	sd	a2,8(a0)
    80005108:	e914                	sd	a3,16(a0)
    8000510a:	6d0c                	ld	a1,24(a0)
    8000510c:	7110                	ld	a2,32(a0)
    8000510e:	6194                	ld	a3,0(a1)
    80005110:	96b2                	add	a3,a3,a2
    80005112:	e194                	sd	a3,0(a1)
    80005114:	4589                	li	a1,2
    80005116:	14459073          	csrw	sip,a1
    8000511a:	6914                	ld	a3,16(a0)
    8000511c:	6510                	ld	a2,8(a0)
    8000511e:	610c                	ld	a1,0(a0)
    80005120:	34051573          	csrrw	a0,mscratch,a0
    80005124:	30200073          	mret
	...

000000008000512a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000512a:	1141                	addi	sp,sp,-16
    8000512c:	e422                	sd	s0,8(sp)
    8000512e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005130:	0c0007b7          	lui	a5,0xc000
    80005134:	4705                	li	a4,1
    80005136:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005138:	c3d8                	sw	a4,4(a5)
}
    8000513a:	6422                	ld	s0,8(sp)
    8000513c:	0141                	addi	sp,sp,16
    8000513e:	8082                	ret

0000000080005140 <plicinithart>:

void
plicinithart(void)
{
    80005140:	1141                	addi	sp,sp,-16
    80005142:	e406                	sd	ra,8(sp)
    80005144:	e022                	sd	s0,0(sp)
    80005146:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005148:	ffffc097          	auipc	ra,0xffffc
    8000514c:	d1e080e7          	jalr	-738(ra) # 80000e66 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005150:	0085171b          	slliw	a4,a0,0x8
    80005154:	0c0027b7          	lui	a5,0xc002
    80005158:	97ba                	add	a5,a5,a4
    8000515a:	40200713          	li	a4,1026
    8000515e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005162:	00d5151b          	slliw	a0,a0,0xd
    80005166:	0c2017b7          	lui	a5,0xc201
    8000516a:	953e                	add	a0,a0,a5
    8000516c:	00052023          	sw	zero,0(a0)
}
    80005170:	60a2                	ld	ra,8(sp)
    80005172:	6402                	ld	s0,0(sp)
    80005174:	0141                	addi	sp,sp,16
    80005176:	8082                	ret

0000000080005178 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005178:	1141                	addi	sp,sp,-16
    8000517a:	e406                	sd	ra,8(sp)
    8000517c:	e022                	sd	s0,0(sp)
    8000517e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005180:	ffffc097          	auipc	ra,0xffffc
    80005184:	ce6080e7          	jalr	-794(ra) # 80000e66 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005188:	00d5179b          	slliw	a5,a0,0xd
    8000518c:	0c201537          	lui	a0,0xc201
    80005190:	953e                	add	a0,a0,a5
  return irq;
}
    80005192:	4148                	lw	a0,4(a0)
    80005194:	60a2                	ld	ra,8(sp)
    80005196:	6402                	ld	s0,0(sp)
    80005198:	0141                	addi	sp,sp,16
    8000519a:	8082                	ret

000000008000519c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000519c:	1101                	addi	sp,sp,-32
    8000519e:	ec06                	sd	ra,24(sp)
    800051a0:	e822                	sd	s0,16(sp)
    800051a2:	e426                	sd	s1,8(sp)
    800051a4:	1000                	addi	s0,sp,32
    800051a6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800051a8:	ffffc097          	auipc	ra,0xffffc
    800051ac:	cbe080e7          	jalr	-834(ra) # 80000e66 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800051b0:	00d5151b          	slliw	a0,a0,0xd
    800051b4:	0c2017b7          	lui	a5,0xc201
    800051b8:	97aa                	add	a5,a5,a0
    800051ba:	c3c4                	sw	s1,4(a5)
}
    800051bc:	60e2                	ld	ra,24(sp)
    800051be:	6442                	ld	s0,16(sp)
    800051c0:	64a2                	ld	s1,8(sp)
    800051c2:	6105                	addi	sp,sp,32
    800051c4:	8082                	ret

00000000800051c6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800051c6:	1141                	addi	sp,sp,-16
    800051c8:	e406                	sd	ra,8(sp)
    800051ca:	e022                	sd	s0,0(sp)
    800051cc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800051ce:	479d                	li	a5,7
    800051d0:	06a7c963          	blt	a5,a0,80005242 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    800051d4:	00016797          	auipc	a5,0x16
    800051d8:	e2c78793          	addi	a5,a5,-468 # 8001b000 <disk>
    800051dc:	00a78733          	add	a4,a5,a0
    800051e0:	6789                	lui	a5,0x2
    800051e2:	97ba                	add	a5,a5,a4
    800051e4:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800051e8:	e7ad                	bnez	a5,80005252 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800051ea:	00451793          	slli	a5,a0,0x4
    800051ee:	00018717          	auipc	a4,0x18
    800051f2:	e1270713          	addi	a4,a4,-494 # 8001d000 <disk+0x2000>
    800051f6:	6314                	ld	a3,0(a4)
    800051f8:	96be                	add	a3,a3,a5
    800051fa:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800051fe:	6314                	ld	a3,0(a4)
    80005200:	96be                	add	a3,a3,a5
    80005202:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005206:	6314                	ld	a3,0(a4)
    80005208:	96be                	add	a3,a3,a5
    8000520a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000520e:	6318                	ld	a4,0(a4)
    80005210:	97ba                	add	a5,a5,a4
    80005212:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005216:	00016797          	auipc	a5,0x16
    8000521a:	dea78793          	addi	a5,a5,-534 # 8001b000 <disk>
    8000521e:	97aa                	add	a5,a5,a0
    80005220:	6509                	lui	a0,0x2
    80005222:	953e                	add	a0,a0,a5
    80005224:	4785                	li	a5,1
    80005226:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000522a:	00018517          	auipc	a0,0x18
    8000522e:	dee50513          	addi	a0,a0,-530 # 8001d018 <disk+0x2018>
    80005232:	ffffc097          	auipc	ra,0xffffc
    80005236:	4be080e7          	jalr	1214(ra) # 800016f0 <wakeup>
}
    8000523a:	60a2                	ld	ra,8(sp)
    8000523c:	6402                	ld	s0,0(sp)
    8000523e:	0141                	addi	sp,sp,16
    80005240:	8082                	ret
    panic("free_desc 1");
    80005242:	00003517          	auipc	a0,0x3
    80005246:	64e50513          	addi	a0,a0,1614 # 80008890 <syscalls_name+0x328>
    8000524a:	00001097          	auipc	ra,0x1
    8000524e:	a1e080e7          	jalr	-1506(ra) # 80005c68 <panic>
    panic("free_desc 2");
    80005252:	00003517          	auipc	a0,0x3
    80005256:	64e50513          	addi	a0,a0,1614 # 800088a0 <syscalls_name+0x338>
    8000525a:	00001097          	auipc	ra,0x1
    8000525e:	a0e080e7          	jalr	-1522(ra) # 80005c68 <panic>

0000000080005262 <virtio_disk_init>:
{
    80005262:	1101                	addi	sp,sp,-32
    80005264:	ec06                	sd	ra,24(sp)
    80005266:	e822                	sd	s0,16(sp)
    80005268:	e426                	sd	s1,8(sp)
    8000526a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000526c:	00003597          	auipc	a1,0x3
    80005270:	64458593          	addi	a1,a1,1604 # 800088b0 <syscalls_name+0x348>
    80005274:	00018517          	auipc	a0,0x18
    80005278:	eb450513          	addi	a0,a0,-332 # 8001d128 <disk+0x2128>
    8000527c:	00001097          	auipc	ra,0x1
    80005280:	ea6080e7          	jalr	-346(ra) # 80006122 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005284:	100017b7          	lui	a5,0x10001
    80005288:	4398                	lw	a4,0(a5)
    8000528a:	2701                	sext.w	a4,a4
    8000528c:	747277b7          	lui	a5,0x74727
    80005290:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005294:	0ef71163          	bne	a4,a5,80005376 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005298:	100017b7          	lui	a5,0x10001
    8000529c:	43dc                	lw	a5,4(a5)
    8000529e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052a0:	4705                	li	a4,1
    800052a2:	0ce79a63          	bne	a5,a4,80005376 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052a6:	100017b7          	lui	a5,0x10001
    800052aa:	479c                	lw	a5,8(a5)
    800052ac:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800052ae:	4709                	li	a4,2
    800052b0:	0ce79363          	bne	a5,a4,80005376 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800052b4:	100017b7          	lui	a5,0x10001
    800052b8:	47d8                	lw	a4,12(a5)
    800052ba:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052bc:	554d47b7          	lui	a5,0x554d4
    800052c0:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800052c4:	0af71963          	bne	a4,a5,80005376 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052c8:	100017b7          	lui	a5,0x10001
    800052cc:	4705                	li	a4,1
    800052ce:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052d0:	470d                	li	a4,3
    800052d2:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800052d4:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800052d6:	c7ffe737          	lui	a4,0xc7ffe
    800052da:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    800052de:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800052e0:	2701                	sext.w	a4,a4
    800052e2:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052e4:	472d                	li	a4,11
    800052e6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052e8:	473d                	li	a4,15
    800052ea:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800052ec:	6705                	lui	a4,0x1
    800052ee:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800052f0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800052f4:	5bdc                	lw	a5,52(a5)
    800052f6:	2781                	sext.w	a5,a5
  if(max == 0)
    800052f8:	c7d9                	beqz	a5,80005386 <virtio_disk_init+0x124>
  if(max < NUM)
    800052fa:	471d                	li	a4,7
    800052fc:	08f77d63          	bgeu	a4,a5,80005396 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005300:	100014b7          	lui	s1,0x10001
    80005304:	47a1                	li	a5,8
    80005306:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005308:	6609                	lui	a2,0x2
    8000530a:	4581                	li	a1,0
    8000530c:	00016517          	auipc	a0,0x16
    80005310:	cf450513          	addi	a0,a0,-780 # 8001b000 <disk>
    80005314:	ffffb097          	auipc	ra,0xffffb
    80005318:	eae080e7          	jalr	-338(ra) # 800001c2 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000531c:	00016717          	auipc	a4,0x16
    80005320:	ce470713          	addi	a4,a4,-796 # 8001b000 <disk>
    80005324:	00c75793          	srli	a5,a4,0xc
    80005328:	2781                	sext.w	a5,a5
    8000532a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000532c:	00018797          	auipc	a5,0x18
    80005330:	cd478793          	addi	a5,a5,-812 # 8001d000 <disk+0x2000>
    80005334:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005336:	00016717          	auipc	a4,0x16
    8000533a:	d4a70713          	addi	a4,a4,-694 # 8001b080 <disk+0x80>
    8000533e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005340:	00017717          	auipc	a4,0x17
    80005344:	cc070713          	addi	a4,a4,-832 # 8001c000 <disk+0x1000>
    80005348:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000534a:	4705                	li	a4,1
    8000534c:	00e78c23          	sb	a4,24(a5)
    80005350:	00e78ca3          	sb	a4,25(a5)
    80005354:	00e78d23          	sb	a4,26(a5)
    80005358:	00e78da3          	sb	a4,27(a5)
    8000535c:	00e78e23          	sb	a4,28(a5)
    80005360:	00e78ea3          	sb	a4,29(a5)
    80005364:	00e78f23          	sb	a4,30(a5)
    80005368:	00e78fa3          	sb	a4,31(a5)
}
    8000536c:	60e2                	ld	ra,24(sp)
    8000536e:	6442                	ld	s0,16(sp)
    80005370:	64a2                	ld	s1,8(sp)
    80005372:	6105                	addi	sp,sp,32
    80005374:	8082                	ret
    panic("could not find virtio disk");
    80005376:	00003517          	auipc	a0,0x3
    8000537a:	54a50513          	addi	a0,a0,1354 # 800088c0 <syscalls_name+0x358>
    8000537e:	00001097          	auipc	ra,0x1
    80005382:	8ea080e7          	jalr	-1814(ra) # 80005c68 <panic>
    panic("virtio disk has no queue 0");
    80005386:	00003517          	auipc	a0,0x3
    8000538a:	55a50513          	addi	a0,a0,1370 # 800088e0 <syscalls_name+0x378>
    8000538e:	00001097          	auipc	ra,0x1
    80005392:	8da080e7          	jalr	-1830(ra) # 80005c68 <panic>
    panic("virtio disk max queue too short");
    80005396:	00003517          	auipc	a0,0x3
    8000539a:	56a50513          	addi	a0,a0,1386 # 80008900 <syscalls_name+0x398>
    8000539e:	00001097          	auipc	ra,0x1
    800053a2:	8ca080e7          	jalr	-1846(ra) # 80005c68 <panic>

00000000800053a6 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800053a6:	7159                	addi	sp,sp,-112
    800053a8:	f486                	sd	ra,104(sp)
    800053aa:	f0a2                	sd	s0,96(sp)
    800053ac:	eca6                	sd	s1,88(sp)
    800053ae:	e8ca                	sd	s2,80(sp)
    800053b0:	e4ce                	sd	s3,72(sp)
    800053b2:	e0d2                	sd	s4,64(sp)
    800053b4:	fc56                	sd	s5,56(sp)
    800053b6:	f85a                	sd	s6,48(sp)
    800053b8:	f45e                	sd	s7,40(sp)
    800053ba:	f062                	sd	s8,32(sp)
    800053bc:	ec66                	sd	s9,24(sp)
    800053be:	e86a                	sd	s10,16(sp)
    800053c0:	1880                	addi	s0,sp,112
    800053c2:	892a                	mv	s2,a0
    800053c4:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800053c6:	00c52c83          	lw	s9,12(a0)
    800053ca:	001c9c9b          	slliw	s9,s9,0x1
    800053ce:	1c82                	slli	s9,s9,0x20
    800053d0:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800053d4:	00018517          	auipc	a0,0x18
    800053d8:	d5450513          	addi	a0,a0,-684 # 8001d128 <disk+0x2128>
    800053dc:	00001097          	auipc	ra,0x1
    800053e0:	dd6080e7          	jalr	-554(ra) # 800061b2 <acquire>
  for(int i = 0; i < 3; i++){
    800053e4:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800053e6:	4c21                	li	s8,8
      disk.free[i] = 0;
    800053e8:	00016b97          	auipc	s7,0x16
    800053ec:	c18b8b93          	addi	s7,s7,-1000 # 8001b000 <disk>
    800053f0:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    800053f2:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    800053f4:	8a4e                	mv	s4,s3
    800053f6:	a051                	j	8000547a <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    800053f8:	00fb86b3          	add	a3,s7,a5
    800053fc:	96da                	add	a3,a3,s6
    800053fe:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005402:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80005404:	0207c563          	bltz	a5,8000542e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005408:	2485                	addiw	s1,s1,1
    8000540a:	0711                	addi	a4,a4,4
    8000540c:	25548063          	beq	s1,s5,8000564c <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    80005410:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005412:	00018697          	auipc	a3,0x18
    80005416:	c0668693          	addi	a3,a3,-1018 # 8001d018 <disk+0x2018>
    8000541a:	87d2                	mv	a5,s4
    if(disk.free[i]){
    8000541c:	0006c583          	lbu	a1,0(a3)
    80005420:	fde1                	bnez	a1,800053f8 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005422:	2785                	addiw	a5,a5,1
    80005424:	0685                	addi	a3,a3,1
    80005426:	ff879be3          	bne	a5,s8,8000541c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000542a:	57fd                	li	a5,-1
    8000542c:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    8000542e:	02905a63          	blez	s1,80005462 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005432:	f9042503          	lw	a0,-112(s0)
    80005436:	00000097          	auipc	ra,0x0
    8000543a:	d90080e7          	jalr	-624(ra) # 800051c6 <free_desc>
      for(int j = 0; j < i; j++)
    8000543e:	4785                	li	a5,1
    80005440:	0297d163          	bge	a5,s1,80005462 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005444:	f9442503          	lw	a0,-108(s0)
    80005448:	00000097          	auipc	ra,0x0
    8000544c:	d7e080e7          	jalr	-642(ra) # 800051c6 <free_desc>
      for(int j = 0; j < i; j++)
    80005450:	4789                	li	a5,2
    80005452:	0097d863          	bge	a5,s1,80005462 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005456:	f9842503          	lw	a0,-104(s0)
    8000545a:	00000097          	auipc	ra,0x0
    8000545e:	d6c080e7          	jalr	-660(ra) # 800051c6 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005462:	00018597          	auipc	a1,0x18
    80005466:	cc658593          	addi	a1,a1,-826 # 8001d128 <disk+0x2128>
    8000546a:	00018517          	auipc	a0,0x18
    8000546e:	bae50513          	addi	a0,a0,-1106 # 8001d018 <disk+0x2018>
    80005472:	ffffc097          	auipc	ra,0xffffc
    80005476:	0f2080e7          	jalr	242(ra) # 80001564 <sleep>
  for(int i = 0; i < 3; i++){
    8000547a:	f9040713          	addi	a4,s0,-112
    8000547e:	84ce                	mv	s1,s3
    80005480:	bf41                	j	80005410 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005482:	20058713          	addi	a4,a1,512
    80005486:	00471693          	slli	a3,a4,0x4
    8000548a:	00016717          	auipc	a4,0x16
    8000548e:	b7670713          	addi	a4,a4,-1162 # 8001b000 <disk>
    80005492:	9736                	add	a4,a4,a3
    80005494:	4685                	li	a3,1
    80005496:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000549a:	20058713          	addi	a4,a1,512
    8000549e:	00471693          	slli	a3,a4,0x4
    800054a2:	00016717          	auipc	a4,0x16
    800054a6:	b5e70713          	addi	a4,a4,-1186 # 8001b000 <disk>
    800054aa:	9736                	add	a4,a4,a3
    800054ac:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800054b0:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800054b4:	7679                	lui	a2,0xffffe
    800054b6:	963e                	add	a2,a2,a5
    800054b8:	00018697          	auipc	a3,0x18
    800054bc:	b4868693          	addi	a3,a3,-1208 # 8001d000 <disk+0x2000>
    800054c0:	6298                	ld	a4,0(a3)
    800054c2:	9732                	add	a4,a4,a2
    800054c4:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800054c6:	6298                	ld	a4,0(a3)
    800054c8:	9732                	add	a4,a4,a2
    800054ca:	4541                	li	a0,16
    800054cc:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800054ce:	6298                	ld	a4,0(a3)
    800054d0:	9732                	add	a4,a4,a2
    800054d2:	4505                	li	a0,1
    800054d4:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800054d8:	f9442703          	lw	a4,-108(s0)
    800054dc:	6288                	ld	a0,0(a3)
    800054de:	962a                	add	a2,a2,a0
    800054e0:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    800054e4:	0712                	slli	a4,a4,0x4
    800054e6:	6290                	ld	a2,0(a3)
    800054e8:	963a                	add	a2,a2,a4
    800054ea:	05890513          	addi	a0,s2,88
    800054ee:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800054f0:	6294                	ld	a3,0(a3)
    800054f2:	96ba                	add	a3,a3,a4
    800054f4:	40000613          	li	a2,1024
    800054f8:	c690                	sw	a2,8(a3)
  if(write)
    800054fa:	140d0063          	beqz	s10,8000563a <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800054fe:	00018697          	auipc	a3,0x18
    80005502:	b026b683          	ld	a3,-1278(a3) # 8001d000 <disk+0x2000>
    80005506:	96ba                	add	a3,a3,a4
    80005508:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000550c:	00016817          	auipc	a6,0x16
    80005510:	af480813          	addi	a6,a6,-1292 # 8001b000 <disk>
    80005514:	00018517          	auipc	a0,0x18
    80005518:	aec50513          	addi	a0,a0,-1300 # 8001d000 <disk+0x2000>
    8000551c:	6114                	ld	a3,0(a0)
    8000551e:	96ba                	add	a3,a3,a4
    80005520:	00c6d603          	lhu	a2,12(a3)
    80005524:	00166613          	ori	a2,a2,1
    80005528:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000552c:	f9842683          	lw	a3,-104(s0)
    80005530:	6110                	ld	a2,0(a0)
    80005532:	9732                	add	a4,a4,a2
    80005534:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005538:	20058613          	addi	a2,a1,512
    8000553c:	0612                	slli	a2,a2,0x4
    8000553e:	9642                	add	a2,a2,a6
    80005540:	577d                	li	a4,-1
    80005542:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005546:	00469713          	slli	a4,a3,0x4
    8000554a:	6114                	ld	a3,0(a0)
    8000554c:	96ba                	add	a3,a3,a4
    8000554e:	03078793          	addi	a5,a5,48
    80005552:	97c2                	add	a5,a5,a6
    80005554:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005556:	611c                	ld	a5,0(a0)
    80005558:	97ba                	add	a5,a5,a4
    8000555a:	4685                	li	a3,1
    8000555c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000555e:	611c                	ld	a5,0(a0)
    80005560:	97ba                	add	a5,a5,a4
    80005562:	4809                	li	a6,2
    80005564:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005568:	611c                	ld	a5,0(a0)
    8000556a:	973e                	add	a4,a4,a5
    8000556c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005570:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80005574:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005578:	6518                	ld	a4,8(a0)
    8000557a:	00275783          	lhu	a5,2(a4)
    8000557e:	8b9d                	andi	a5,a5,7
    80005580:	0786                	slli	a5,a5,0x1
    80005582:	97ba                	add	a5,a5,a4
    80005584:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005588:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000558c:	6518                	ld	a4,8(a0)
    8000558e:	00275783          	lhu	a5,2(a4)
    80005592:	2785                	addiw	a5,a5,1
    80005594:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005598:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000559c:	100017b7          	lui	a5,0x10001
    800055a0:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800055a4:	00492703          	lw	a4,4(s2)
    800055a8:	4785                	li	a5,1
    800055aa:	02f71163          	bne	a4,a5,800055cc <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    800055ae:	00018997          	auipc	s3,0x18
    800055b2:	b7a98993          	addi	s3,s3,-1158 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    800055b6:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800055b8:	85ce                	mv	a1,s3
    800055ba:	854a                	mv	a0,s2
    800055bc:	ffffc097          	auipc	ra,0xffffc
    800055c0:	fa8080e7          	jalr	-88(ra) # 80001564 <sleep>
  while(b->disk == 1) {
    800055c4:	00492783          	lw	a5,4(s2)
    800055c8:	fe9788e3          	beq	a5,s1,800055b8 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    800055cc:	f9042903          	lw	s2,-112(s0)
    800055d0:	20090793          	addi	a5,s2,512
    800055d4:	00479713          	slli	a4,a5,0x4
    800055d8:	00016797          	auipc	a5,0x16
    800055dc:	a2878793          	addi	a5,a5,-1496 # 8001b000 <disk>
    800055e0:	97ba                	add	a5,a5,a4
    800055e2:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800055e6:	00018997          	auipc	s3,0x18
    800055ea:	a1a98993          	addi	s3,s3,-1510 # 8001d000 <disk+0x2000>
    800055ee:	00491713          	slli	a4,s2,0x4
    800055f2:	0009b783          	ld	a5,0(s3)
    800055f6:	97ba                	add	a5,a5,a4
    800055f8:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800055fc:	854a                	mv	a0,s2
    800055fe:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005602:	00000097          	auipc	ra,0x0
    80005606:	bc4080e7          	jalr	-1084(ra) # 800051c6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000560a:	8885                	andi	s1,s1,1
    8000560c:	f0ed                	bnez	s1,800055ee <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000560e:	00018517          	auipc	a0,0x18
    80005612:	b1a50513          	addi	a0,a0,-1254 # 8001d128 <disk+0x2128>
    80005616:	00001097          	auipc	ra,0x1
    8000561a:	c50080e7          	jalr	-944(ra) # 80006266 <release>
}
    8000561e:	70a6                	ld	ra,104(sp)
    80005620:	7406                	ld	s0,96(sp)
    80005622:	64e6                	ld	s1,88(sp)
    80005624:	6946                	ld	s2,80(sp)
    80005626:	69a6                	ld	s3,72(sp)
    80005628:	6a06                	ld	s4,64(sp)
    8000562a:	7ae2                	ld	s5,56(sp)
    8000562c:	7b42                	ld	s6,48(sp)
    8000562e:	7ba2                	ld	s7,40(sp)
    80005630:	7c02                	ld	s8,32(sp)
    80005632:	6ce2                	ld	s9,24(sp)
    80005634:	6d42                	ld	s10,16(sp)
    80005636:	6165                	addi	sp,sp,112
    80005638:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000563a:	00018697          	auipc	a3,0x18
    8000563e:	9c66b683          	ld	a3,-1594(a3) # 8001d000 <disk+0x2000>
    80005642:	96ba                	add	a3,a3,a4
    80005644:	4609                	li	a2,2
    80005646:	00c69623          	sh	a2,12(a3)
    8000564a:	b5c9                	j	8000550c <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000564c:	f9042583          	lw	a1,-112(s0)
    80005650:	20058793          	addi	a5,a1,512
    80005654:	0792                	slli	a5,a5,0x4
    80005656:	00016517          	auipc	a0,0x16
    8000565a:	a5250513          	addi	a0,a0,-1454 # 8001b0a8 <disk+0xa8>
    8000565e:	953e                	add	a0,a0,a5
  if(write)
    80005660:	e20d11e3          	bnez	s10,80005482 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005664:	20058713          	addi	a4,a1,512
    80005668:	00471693          	slli	a3,a4,0x4
    8000566c:	00016717          	auipc	a4,0x16
    80005670:	99470713          	addi	a4,a4,-1644 # 8001b000 <disk>
    80005674:	9736                	add	a4,a4,a3
    80005676:	0a072423          	sw	zero,168(a4)
    8000567a:	b505                	j	8000549a <virtio_disk_rw+0xf4>

000000008000567c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000567c:	1101                	addi	sp,sp,-32
    8000567e:	ec06                	sd	ra,24(sp)
    80005680:	e822                	sd	s0,16(sp)
    80005682:	e426                	sd	s1,8(sp)
    80005684:	e04a                	sd	s2,0(sp)
    80005686:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005688:	00018517          	auipc	a0,0x18
    8000568c:	aa050513          	addi	a0,a0,-1376 # 8001d128 <disk+0x2128>
    80005690:	00001097          	auipc	ra,0x1
    80005694:	b22080e7          	jalr	-1246(ra) # 800061b2 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005698:	10001737          	lui	a4,0x10001
    8000569c:	533c                	lw	a5,96(a4)
    8000569e:	8b8d                	andi	a5,a5,3
    800056a0:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800056a2:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800056a6:	00018797          	auipc	a5,0x18
    800056aa:	95a78793          	addi	a5,a5,-1702 # 8001d000 <disk+0x2000>
    800056ae:	6b94                	ld	a3,16(a5)
    800056b0:	0207d703          	lhu	a4,32(a5)
    800056b4:	0026d783          	lhu	a5,2(a3)
    800056b8:	06f70163          	beq	a4,a5,8000571a <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056bc:	00016917          	auipc	s2,0x16
    800056c0:	94490913          	addi	s2,s2,-1724 # 8001b000 <disk>
    800056c4:	00018497          	auipc	s1,0x18
    800056c8:	93c48493          	addi	s1,s1,-1732 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    800056cc:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056d0:	6898                	ld	a4,16(s1)
    800056d2:	0204d783          	lhu	a5,32(s1)
    800056d6:	8b9d                	andi	a5,a5,7
    800056d8:	078e                	slli	a5,a5,0x3
    800056da:	97ba                	add	a5,a5,a4
    800056dc:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800056de:	20078713          	addi	a4,a5,512
    800056e2:	0712                	slli	a4,a4,0x4
    800056e4:	974a                	add	a4,a4,s2
    800056e6:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800056ea:	e731                	bnez	a4,80005736 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800056ec:	20078793          	addi	a5,a5,512
    800056f0:	0792                	slli	a5,a5,0x4
    800056f2:	97ca                	add	a5,a5,s2
    800056f4:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800056f6:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800056fa:	ffffc097          	auipc	ra,0xffffc
    800056fe:	ff6080e7          	jalr	-10(ra) # 800016f0 <wakeup>

    disk.used_idx += 1;
    80005702:	0204d783          	lhu	a5,32(s1)
    80005706:	2785                	addiw	a5,a5,1
    80005708:	17c2                	slli	a5,a5,0x30
    8000570a:	93c1                	srli	a5,a5,0x30
    8000570c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005710:	6898                	ld	a4,16(s1)
    80005712:	00275703          	lhu	a4,2(a4)
    80005716:	faf71be3          	bne	a4,a5,800056cc <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000571a:	00018517          	auipc	a0,0x18
    8000571e:	a0e50513          	addi	a0,a0,-1522 # 8001d128 <disk+0x2128>
    80005722:	00001097          	auipc	ra,0x1
    80005726:	b44080e7          	jalr	-1212(ra) # 80006266 <release>
}
    8000572a:	60e2                	ld	ra,24(sp)
    8000572c:	6442                	ld	s0,16(sp)
    8000572e:	64a2                	ld	s1,8(sp)
    80005730:	6902                	ld	s2,0(sp)
    80005732:	6105                	addi	sp,sp,32
    80005734:	8082                	ret
      panic("virtio_disk_intr status");
    80005736:	00003517          	auipc	a0,0x3
    8000573a:	1ea50513          	addi	a0,a0,490 # 80008920 <syscalls_name+0x3b8>
    8000573e:	00000097          	auipc	ra,0x0
    80005742:	52a080e7          	jalr	1322(ra) # 80005c68 <panic>

0000000080005746 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005746:	1141                	addi	sp,sp,-16
    80005748:	e422                	sd	s0,8(sp)
    8000574a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r"(x));
    8000574c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005750:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005754:	0037979b          	slliw	a5,a5,0x3
    80005758:	02004737          	lui	a4,0x2004
    8000575c:	97ba                	add	a5,a5,a4
    8000575e:	0200c737          	lui	a4,0x200c
    80005762:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005766:	000f4637          	lui	a2,0xf4
    8000576a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000576e:	95b2                	add	a1,a1,a2
    80005770:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005772:	00269713          	slli	a4,a3,0x2
    80005776:	9736                	add	a4,a4,a3
    80005778:	00371693          	slli	a3,a4,0x3
    8000577c:	00019717          	auipc	a4,0x19
    80005780:	88470713          	addi	a4,a4,-1916 # 8001e000 <timer_scratch>
    80005784:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005786:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005788:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r"(x));
    8000578a:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r"(x));
    8000578e:	00000797          	auipc	a5,0x0
    80005792:	97278793          	addi	a5,a5,-1678 # 80005100 <timervec>
    80005796:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r"(x));
    8000579a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000579e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r"(x));
    800057a2:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r"(x));
    800057a6:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800057aa:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r"(x));
    800057ae:	30479073          	csrw	mie,a5
}
    800057b2:	6422                	ld	s0,8(sp)
    800057b4:	0141                	addi	sp,sp,16
    800057b6:	8082                	ret

00000000800057b8 <start>:
{
    800057b8:	1141                	addi	sp,sp,-16
    800057ba:	e406                	sd	ra,8(sp)
    800057bc:	e022                	sd	s0,0(sp)
    800057be:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r"(x));
    800057c0:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800057c4:	7779                	lui	a4,0xffffe
    800057c6:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    800057ca:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800057cc:	6705                	lui	a4,0x1
    800057ce:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800057d2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r"(x));
    800057d4:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r"(x));
    800057d8:	ffffb797          	auipc	a5,0xffffb
    800057dc:	b9878793          	addi	a5,a5,-1128 # 80000370 <main>
    800057e0:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r"(x));
    800057e4:	4781                	li	a5,0
    800057e6:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r"(x));
    800057ea:	67c1                	lui	a5,0x10
    800057ec:	17fd                	addi	a5,a5,-1
    800057ee:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r"(x));
    800057f2:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r"(x));
    800057f6:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800057fa:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r"(x));
    800057fe:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r"(x));
    80005802:	57fd                	li	a5,-1
    80005804:	83a9                	srli	a5,a5,0xa
    80005806:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r"(x));
    8000580a:	47bd                	li	a5,15
    8000580c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005810:	00000097          	auipc	ra,0x0
    80005814:	f36080e7          	jalr	-202(ra) # 80005746 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r"(x));
    80005818:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000581c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r"(x));
    8000581e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005820:	30200073          	mret
}
    80005824:	60a2                	ld	ra,8(sp)
    80005826:	6402                	ld	s0,0(sp)
    80005828:	0141                	addi	sp,sp,16
    8000582a:	8082                	ret

000000008000582c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000582c:	715d                	addi	sp,sp,-80
    8000582e:	e486                	sd	ra,72(sp)
    80005830:	e0a2                	sd	s0,64(sp)
    80005832:	fc26                	sd	s1,56(sp)
    80005834:	f84a                	sd	s2,48(sp)
    80005836:	f44e                	sd	s3,40(sp)
    80005838:	f052                	sd	s4,32(sp)
    8000583a:	ec56                	sd	s5,24(sp)
    8000583c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000583e:	04c05663          	blez	a2,8000588a <consolewrite+0x5e>
    80005842:	8a2a                	mv	s4,a0
    80005844:	84ae                	mv	s1,a1
    80005846:	89b2                	mv	s3,a2
    80005848:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000584a:	5afd                	li	s5,-1
    8000584c:	4685                	li	a3,1
    8000584e:	8626                	mv	a2,s1
    80005850:	85d2                	mv	a1,s4
    80005852:	fbf40513          	addi	a0,s0,-65
    80005856:	ffffc097          	auipc	ra,0xffffc
    8000585a:	108080e7          	jalr	264(ra) # 8000195e <either_copyin>
    8000585e:	01550c63          	beq	a0,s5,80005876 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005862:	fbf44503          	lbu	a0,-65(s0)
    80005866:	00000097          	auipc	ra,0x0
    8000586a:	78e080e7          	jalr	1934(ra) # 80005ff4 <uartputc>
  for(i = 0; i < n; i++){
    8000586e:	2905                	addiw	s2,s2,1
    80005870:	0485                	addi	s1,s1,1
    80005872:	fd299de3          	bne	s3,s2,8000584c <consolewrite+0x20>
  }

  return i;
}
    80005876:	854a                	mv	a0,s2
    80005878:	60a6                	ld	ra,72(sp)
    8000587a:	6406                	ld	s0,64(sp)
    8000587c:	74e2                	ld	s1,56(sp)
    8000587e:	7942                	ld	s2,48(sp)
    80005880:	79a2                	ld	s3,40(sp)
    80005882:	7a02                	ld	s4,32(sp)
    80005884:	6ae2                	ld	s5,24(sp)
    80005886:	6161                	addi	sp,sp,80
    80005888:	8082                	ret
  for(i = 0; i < n; i++){
    8000588a:	4901                	li	s2,0
    8000588c:	b7ed                	j	80005876 <consolewrite+0x4a>

000000008000588e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000588e:	7119                	addi	sp,sp,-128
    80005890:	fc86                	sd	ra,120(sp)
    80005892:	f8a2                	sd	s0,112(sp)
    80005894:	f4a6                	sd	s1,104(sp)
    80005896:	f0ca                	sd	s2,96(sp)
    80005898:	ecce                	sd	s3,88(sp)
    8000589a:	e8d2                	sd	s4,80(sp)
    8000589c:	e4d6                	sd	s5,72(sp)
    8000589e:	e0da                	sd	s6,64(sp)
    800058a0:	fc5e                	sd	s7,56(sp)
    800058a2:	f862                	sd	s8,48(sp)
    800058a4:	f466                	sd	s9,40(sp)
    800058a6:	f06a                	sd	s10,32(sp)
    800058a8:	ec6e                	sd	s11,24(sp)
    800058aa:	0100                	addi	s0,sp,128
    800058ac:	8b2a                	mv	s6,a0
    800058ae:	8aae                	mv	s5,a1
    800058b0:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800058b2:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    800058b6:	00021517          	auipc	a0,0x21
    800058ba:	88a50513          	addi	a0,a0,-1910 # 80026140 <cons>
    800058be:	00001097          	auipc	ra,0x1
    800058c2:	8f4080e7          	jalr	-1804(ra) # 800061b2 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800058c6:	00021497          	auipc	s1,0x21
    800058ca:	87a48493          	addi	s1,s1,-1926 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800058ce:	89a6                	mv	s3,s1
    800058d0:	00021917          	auipc	s2,0x21
    800058d4:	90890913          	addi	s2,s2,-1784 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800058d8:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800058da:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800058dc:	4da9                	li	s11,10
  while(n > 0){
    800058de:	07405863          	blez	s4,8000594e <consoleread+0xc0>
    while(cons.r == cons.w){
    800058e2:	0984a783          	lw	a5,152(s1)
    800058e6:	09c4a703          	lw	a4,156(s1)
    800058ea:	02f71463          	bne	a4,a5,80005912 <consoleread+0x84>
      if(myproc()->killed){
    800058ee:	ffffb097          	auipc	ra,0xffffb
    800058f2:	5a4080e7          	jalr	1444(ra) # 80000e92 <myproc>
    800058f6:	551c                	lw	a5,40(a0)
    800058f8:	e7b5                	bnez	a5,80005964 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    800058fa:	85ce                	mv	a1,s3
    800058fc:	854a                	mv	a0,s2
    800058fe:	ffffc097          	auipc	ra,0xffffc
    80005902:	c66080e7          	jalr	-922(ra) # 80001564 <sleep>
    while(cons.r == cons.w){
    80005906:	0984a783          	lw	a5,152(s1)
    8000590a:	09c4a703          	lw	a4,156(s1)
    8000590e:	fef700e3          	beq	a4,a5,800058ee <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005912:	0017871b          	addiw	a4,a5,1
    80005916:	08e4ac23          	sw	a4,152(s1)
    8000591a:	07f7f713          	andi	a4,a5,127
    8000591e:	9726                	add	a4,a4,s1
    80005920:	01874703          	lbu	a4,24(a4)
    80005924:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005928:	079c0663          	beq	s8,s9,80005994 <consoleread+0x106>
    cbuf = c;
    8000592c:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005930:	4685                	li	a3,1
    80005932:	f8f40613          	addi	a2,s0,-113
    80005936:	85d6                	mv	a1,s5
    80005938:	855a                	mv	a0,s6
    8000593a:	ffffc097          	auipc	ra,0xffffc
    8000593e:	fce080e7          	jalr	-50(ra) # 80001908 <either_copyout>
    80005942:	01a50663          	beq	a0,s10,8000594e <consoleread+0xc0>
    dst++;
    80005946:	0a85                	addi	s5,s5,1
    --n;
    80005948:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    8000594a:	f9bc1ae3          	bne	s8,s11,800058de <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    8000594e:	00020517          	auipc	a0,0x20
    80005952:	7f250513          	addi	a0,a0,2034 # 80026140 <cons>
    80005956:	00001097          	auipc	ra,0x1
    8000595a:	910080e7          	jalr	-1776(ra) # 80006266 <release>

  return target - n;
    8000595e:	414b853b          	subw	a0,s7,s4
    80005962:	a811                	j	80005976 <consoleread+0xe8>
        release(&cons.lock);
    80005964:	00020517          	auipc	a0,0x20
    80005968:	7dc50513          	addi	a0,a0,2012 # 80026140 <cons>
    8000596c:	00001097          	auipc	ra,0x1
    80005970:	8fa080e7          	jalr	-1798(ra) # 80006266 <release>
        return -1;
    80005974:	557d                	li	a0,-1
}
    80005976:	70e6                	ld	ra,120(sp)
    80005978:	7446                	ld	s0,112(sp)
    8000597a:	74a6                	ld	s1,104(sp)
    8000597c:	7906                	ld	s2,96(sp)
    8000597e:	69e6                	ld	s3,88(sp)
    80005980:	6a46                	ld	s4,80(sp)
    80005982:	6aa6                	ld	s5,72(sp)
    80005984:	6b06                	ld	s6,64(sp)
    80005986:	7be2                	ld	s7,56(sp)
    80005988:	7c42                	ld	s8,48(sp)
    8000598a:	7ca2                	ld	s9,40(sp)
    8000598c:	7d02                	ld	s10,32(sp)
    8000598e:	6de2                	ld	s11,24(sp)
    80005990:	6109                	addi	sp,sp,128
    80005992:	8082                	ret
      if(n < target){
    80005994:	000a071b          	sext.w	a4,s4
    80005998:	fb777be3          	bgeu	a4,s7,8000594e <consoleread+0xc0>
        cons.r--;
    8000599c:	00021717          	auipc	a4,0x21
    800059a0:	82f72e23          	sw	a5,-1988(a4) # 800261d8 <cons+0x98>
    800059a4:	b76d                	j	8000594e <consoleread+0xc0>

00000000800059a6 <consputc>:
{
    800059a6:	1141                	addi	sp,sp,-16
    800059a8:	e406                	sd	ra,8(sp)
    800059aa:	e022                	sd	s0,0(sp)
    800059ac:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800059ae:	10000793          	li	a5,256
    800059b2:	00f50a63          	beq	a0,a5,800059c6 <consputc+0x20>
    uartputc_sync(c);
    800059b6:	00000097          	auipc	ra,0x0
    800059ba:	564080e7          	jalr	1380(ra) # 80005f1a <uartputc_sync>
}
    800059be:	60a2                	ld	ra,8(sp)
    800059c0:	6402                	ld	s0,0(sp)
    800059c2:	0141                	addi	sp,sp,16
    800059c4:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800059c6:	4521                	li	a0,8
    800059c8:	00000097          	auipc	ra,0x0
    800059cc:	552080e7          	jalr	1362(ra) # 80005f1a <uartputc_sync>
    800059d0:	02000513          	li	a0,32
    800059d4:	00000097          	auipc	ra,0x0
    800059d8:	546080e7          	jalr	1350(ra) # 80005f1a <uartputc_sync>
    800059dc:	4521                	li	a0,8
    800059de:	00000097          	auipc	ra,0x0
    800059e2:	53c080e7          	jalr	1340(ra) # 80005f1a <uartputc_sync>
    800059e6:	bfe1                	j	800059be <consputc+0x18>

00000000800059e8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800059e8:	1101                	addi	sp,sp,-32
    800059ea:	ec06                	sd	ra,24(sp)
    800059ec:	e822                	sd	s0,16(sp)
    800059ee:	e426                	sd	s1,8(sp)
    800059f0:	e04a                	sd	s2,0(sp)
    800059f2:	1000                	addi	s0,sp,32
    800059f4:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800059f6:	00020517          	auipc	a0,0x20
    800059fa:	74a50513          	addi	a0,a0,1866 # 80026140 <cons>
    800059fe:	00000097          	auipc	ra,0x0
    80005a02:	7b4080e7          	jalr	1972(ra) # 800061b2 <acquire>

  switch(c){
    80005a06:	47d5                	li	a5,21
    80005a08:	0af48663          	beq	s1,a5,80005ab4 <consoleintr+0xcc>
    80005a0c:	0297ca63          	blt	a5,s1,80005a40 <consoleintr+0x58>
    80005a10:	47a1                	li	a5,8
    80005a12:	0ef48763          	beq	s1,a5,80005b00 <consoleintr+0x118>
    80005a16:	47c1                	li	a5,16
    80005a18:	10f49a63          	bne	s1,a5,80005b2c <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005a1c:	ffffc097          	auipc	ra,0xffffc
    80005a20:	f98080e7          	jalr	-104(ra) # 800019b4 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005a24:	00020517          	auipc	a0,0x20
    80005a28:	71c50513          	addi	a0,a0,1820 # 80026140 <cons>
    80005a2c:	00001097          	auipc	ra,0x1
    80005a30:	83a080e7          	jalr	-1990(ra) # 80006266 <release>
}
    80005a34:	60e2                	ld	ra,24(sp)
    80005a36:	6442                	ld	s0,16(sp)
    80005a38:	64a2                	ld	s1,8(sp)
    80005a3a:	6902                	ld	s2,0(sp)
    80005a3c:	6105                	addi	sp,sp,32
    80005a3e:	8082                	ret
  switch(c){
    80005a40:	07f00793          	li	a5,127
    80005a44:	0af48e63          	beq	s1,a5,80005b00 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005a48:	00020717          	auipc	a4,0x20
    80005a4c:	6f870713          	addi	a4,a4,1784 # 80026140 <cons>
    80005a50:	0a072783          	lw	a5,160(a4)
    80005a54:	09872703          	lw	a4,152(a4)
    80005a58:	9f99                	subw	a5,a5,a4
    80005a5a:	07f00713          	li	a4,127
    80005a5e:	fcf763e3          	bltu	a4,a5,80005a24 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005a62:	47b5                	li	a5,13
    80005a64:	0cf48763          	beq	s1,a5,80005b32 <consoleintr+0x14a>
      consputc(c);
    80005a68:	8526                	mv	a0,s1
    80005a6a:	00000097          	auipc	ra,0x0
    80005a6e:	f3c080e7          	jalr	-196(ra) # 800059a6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005a72:	00020797          	auipc	a5,0x20
    80005a76:	6ce78793          	addi	a5,a5,1742 # 80026140 <cons>
    80005a7a:	0a07a703          	lw	a4,160(a5)
    80005a7e:	0017069b          	addiw	a3,a4,1
    80005a82:	0006861b          	sext.w	a2,a3
    80005a86:	0ad7a023          	sw	a3,160(a5)
    80005a8a:	07f77713          	andi	a4,a4,127
    80005a8e:	97ba                	add	a5,a5,a4
    80005a90:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005a94:	47a9                	li	a5,10
    80005a96:	0cf48563          	beq	s1,a5,80005b60 <consoleintr+0x178>
    80005a9a:	4791                	li	a5,4
    80005a9c:	0cf48263          	beq	s1,a5,80005b60 <consoleintr+0x178>
    80005aa0:	00020797          	auipc	a5,0x20
    80005aa4:	7387a783          	lw	a5,1848(a5) # 800261d8 <cons+0x98>
    80005aa8:	0807879b          	addiw	a5,a5,128
    80005aac:	f6f61ce3          	bne	a2,a5,80005a24 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005ab0:	863e                	mv	a2,a5
    80005ab2:	a07d                	j	80005b60 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005ab4:	00020717          	auipc	a4,0x20
    80005ab8:	68c70713          	addi	a4,a4,1676 # 80026140 <cons>
    80005abc:	0a072783          	lw	a5,160(a4)
    80005ac0:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005ac4:	00020497          	auipc	s1,0x20
    80005ac8:	67c48493          	addi	s1,s1,1660 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005acc:	4929                	li	s2,10
    80005ace:	f4f70be3          	beq	a4,a5,80005a24 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005ad2:	37fd                	addiw	a5,a5,-1
    80005ad4:	07f7f713          	andi	a4,a5,127
    80005ad8:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005ada:	01874703          	lbu	a4,24(a4)
    80005ade:	f52703e3          	beq	a4,s2,80005a24 <consoleintr+0x3c>
      cons.e--;
    80005ae2:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005ae6:	10000513          	li	a0,256
    80005aea:	00000097          	auipc	ra,0x0
    80005aee:	ebc080e7          	jalr	-324(ra) # 800059a6 <consputc>
    while(cons.e != cons.w &&
    80005af2:	0a04a783          	lw	a5,160(s1)
    80005af6:	09c4a703          	lw	a4,156(s1)
    80005afa:	fcf71ce3          	bne	a4,a5,80005ad2 <consoleintr+0xea>
    80005afe:	b71d                	j	80005a24 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005b00:	00020717          	auipc	a4,0x20
    80005b04:	64070713          	addi	a4,a4,1600 # 80026140 <cons>
    80005b08:	0a072783          	lw	a5,160(a4)
    80005b0c:	09c72703          	lw	a4,156(a4)
    80005b10:	f0f70ae3          	beq	a4,a5,80005a24 <consoleintr+0x3c>
      cons.e--;
    80005b14:	37fd                	addiw	a5,a5,-1
    80005b16:	00020717          	auipc	a4,0x20
    80005b1a:	6cf72523          	sw	a5,1738(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005b1e:	10000513          	li	a0,256
    80005b22:	00000097          	auipc	ra,0x0
    80005b26:	e84080e7          	jalr	-380(ra) # 800059a6 <consputc>
    80005b2a:	bded                	j	80005a24 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b2c:	ee048ce3          	beqz	s1,80005a24 <consoleintr+0x3c>
    80005b30:	bf21                	j	80005a48 <consoleintr+0x60>
      consputc(c);
    80005b32:	4529                	li	a0,10
    80005b34:	00000097          	auipc	ra,0x0
    80005b38:	e72080e7          	jalr	-398(ra) # 800059a6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b3c:	00020797          	auipc	a5,0x20
    80005b40:	60478793          	addi	a5,a5,1540 # 80026140 <cons>
    80005b44:	0a07a703          	lw	a4,160(a5)
    80005b48:	0017069b          	addiw	a3,a4,1
    80005b4c:	0006861b          	sext.w	a2,a3
    80005b50:	0ad7a023          	sw	a3,160(a5)
    80005b54:	07f77713          	andi	a4,a4,127
    80005b58:	97ba                	add	a5,a5,a4
    80005b5a:	4729                	li	a4,10
    80005b5c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005b60:	00020797          	auipc	a5,0x20
    80005b64:	66c7ae23          	sw	a2,1660(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005b68:	00020517          	auipc	a0,0x20
    80005b6c:	67050513          	addi	a0,a0,1648 # 800261d8 <cons+0x98>
    80005b70:	ffffc097          	auipc	ra,0xffffc
    80005b74:	b80080e7          	jalr	-1152(ra) # 800016f0 <wakeup>
    80005b78:	b575                	j	80005a24 <consoleintr+0x3c>

0000000080005b7a <consoleinit>:

void
consoleinit(void)
{
    80005b7a:	1141                	addi	sp,sp,-16
    80005b7c:	e406                	sd	ra,8(sp)
    80005b7e:	e022                	sd	s0,0(sp)
    80005b80:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005b82:	00003597          	auipc	a1,0x3
    80005b86:	db658593          	addi	a1,a1,-586 # 80008938 <syscalls_name+0x3d0>
    80005b8a:	00020517          	auipc	a0,0x20
    80005b8e:	5b650513          	addi	a0,a0,1462 # 80026140 <cons>
    80005b92:	00000097          	auipc	ra,0x0
    80005b96:	590080e7          	jalr	1424(ra) # 80006122 <initlock>

  uartinit();
    80005b9a:	00000097          	auipc	ra,0x0
    80005b9e:	330080e7          	jalr	816(ra) # 80005eca <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005ba2:	00014797          	auipc	a5,0x14
    80005ba6:	d2678793          	addi	a5,a5,-730 # 800198c8 <devsw>
    80005baa:	00000717          	auipc	a4,0x0
    80005bae:	ce470713          	addi	a4,a4,-796 # 8000588e <consoleread>
    80005bb2:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005bb4:	00000717          	auipc	a4,0x0
    80005bb8:	c7870713          	addi	a4,a4,-904 # 8000582c <consolewrite>
    80005bbc:	ef98                	sd	a4,24(a5)
}
    80005bbe:	60a2                	ld	ra,8(sp)
    80005bc0:	6402                	ld	s0,0(sp)
    80005bc2:	0141                	addi	sp,sp,16
    80005bc4:	8082                	ret

0000000080005bc6 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005bc6:	7179                	addi	sp,sp,-48
    80005bc8:	f406                	sd	ra,40(sp)
    80005bca:	f022                	sd	s0,32(sp)
    80005bcc:	ec26                	sd	s1,24(sp)
    80005bce:	e84a                	sd	s2,16(sp)
    80005bd0:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005bd2:	c219                	beqz	a2,80005bd8 <printint+0x12>
    80005bd4:	08054663          	bltz	a0,80005c60 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005bd8:	2501                	sext.w	a0,a0
    80005bda:	4881                	li	a7,0
    80005bdc:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005be0:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005be2:	2581                	sext.w	a1,a1
    80005be4:	00003617          	auipc	a2,0x3
    80005be8:	d8460613          	addi	a2,a2,-636 # 80008968 <digits>
    80005bec:	883a                	mv	a6,a4
    80005bee:	2705                	addiw	a4,a4,1
    80005bf0:	02b577bb          	remuw	a5,a0,a1
    80005bf4:	1782                	slli	a5,a5,0x20
    80005bf6:	9381                	srli	a5,a5,0x20
    80005bf8:	97b2                	add	a5,a5,a2
    80005bfa:	0007c783          	lbu	a5,0(a5)
    80005bfe:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005c02:	0005079b          	sext.w	a5,a0
    80005c06:	02b5553b          	divuw	a0,a0,a1
    80005c0a:	0685                	addi	a3,a3,1
    80005c0c:	feb7f0e3          	bgeu	a5,a1,80005bec <printint+0x26>

  if(sign)
    80005c10:	00088b63          	beqz	a7,80005c26 <printint+0x60>
    buf[i++] = '-';
    80005c14:	fe040793          	addi	a5,s0,-32
    80005c18:	973e                	add	a4,a4,a5
    80005c1a:	02d00793          	li	a5,45
    80005c1e:	fef70823          	sb	a5,-16(a4)
    80005c22:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005c26:	02e05763          	blez	a4,80005c54 <printint+0x8e>
    80005c2a:	fd040793          	addi	a5,s0,-48
    80005c2e:	00e784b3          	add	s1,a5,a4
    80005c32:	fff78913          	addi	s2,a5,-1
    80005c36:	993a                	add	s2,s2,a4
    80005c38:	377d                	addiw	a4,a4,-1
    80005c3a:	1702                	slli	a4,a4,0x20
    80005c3c:	9301                	srli	a4,a4,0x20
    80005c3e:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005c42:	fff4c503          	lbu	a0,-1(s1)
    80005c46:	00000097          	auipc	ra,0x0
    80005c4a:	d60080e7          	jalr	-672(ra) # 800059a6 <consputc>
  while(--i >= 0)
    80005c4e:	14fd                	addi	s1,s1,-1
    80005c50:	ff2499e3          	bne	s1,s2,80005c42 <printint+0x7c>
}
    80005c54:	70a2                	ld	ra,40(sp)
    80005c56:	7402                	ld	s0,32(sp)
    80005c58:	64e2                	ld	s1,24(sp)
    80005c5a:	6942                	ld	s2,16(sp)
    80005c5c:	6145                	addi	sp,sp,48
    80005c5e:	8082                	ret
    x = -xx;
    80005c60:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005c64:	4885                	li	a7,1
    x = -xx;
    80005c66:	bf9d                	j	80005bdc <printint+0x16>

0000000080005c68 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005c68:	1101                	addi	sp,sp,-32
    80005c6a:	ec06                	sd	ra,24(sp)
    80005c6c:	e822                	sd	s0,16(sp)
    80005c6e:	e426                	sd	s1,8(sp)
    80005c70:	1000                	addi	s0,sp,32
    80005c72:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005c74:	00020797          	auipc	a5,0x20
    80005c78:	5807a623          	sw	zero,1420(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005c7c:	00003517          	auipc	a0,0x3
    80005c80:	cc450513          	addi	a0,a0,-828 # 80008940 <syscalls_name+0x3d8>
    80005c84:	00000097          	auipc	ra,0x0
    80005c88:	02e080e7          	jalr	46(ra) # 80005cb2 <printf>
  printf(s);
    80005c8c:	8526                	mv	a0,s1
    80005c8e:	00000097          	auipc	ra,0x0
    80005c92:	024080e7          	jalr	36(ra) # 80005cb2 <printf>
  printf("\n");
    80005c96:	00002517          	auipc	a0,0x2
    80005c9a:	3b250513          	addi	a0,a0,946 # 80008048 <etext+0x48>
    80005c9e:	00000097          	auipc	ra,0x0
    80005ca2:	014080e7          	jalr	20(ra) # 80005cb2 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005ca6:	4785                	li	a5,1
    80005ca8:	00003717          	auipc	a4,0x3
    80005cac:	36f72a23          	sw	a5,884(a4) # 8000901c <panicked>
  for(;;)
    80005cb0:	a001                	j	80005cb0 <panic+0x48>

0000000080005cb2 <printf>:
{
    80005cb2:	7131                	addi	sp,sp,-192
    80005cb4:	fc86                	sd	ra,120(sp)
    80005cb6:	f8a2                	sd	s0,112(sp)
    80005cb8:	f4a6                	sd	s1,104(sp)
    80005cba:	f0ca                	sd	s2,96(sp)
    80005cbc:	ecce                	sd	s3,88(sp)
    80005cbe:	e8d2                	sd	s4,80(sp)
    80005cc0:	e4d6                	sd	s5,72(sp)
    80005cc2:	e0da                	sd	s6,64(sp)
    80005cc4:	fc5e                	sd	s7,56(sp)
    80005cc6:	f862                	sd	s8,48(sp)
    80005cc8:	f466                	sd	s9,40(sp)
    80005cca:	f06a                	sd	s10,32(sp)
    80005ccc:	ec6e                	sd	s11,24(sp)
    80005cce:	0100                	addi	s0,sp,128
    80005cd0:	8a2a                	mv	s4,a0
    80005cd2:	e40c                	sd	a1,8(s0)
    80005cd4:	e810                	sd	a2,16(s0)
    80005cd6:	ec14                	sd	a3,24(s0)
    80005cd8:	f018                	sd	a4,32(s0)
    80005cda:	f41c                	sd	a5,40(s0)
    80005cdc:	03043823          	sd	a6,48(s0)
    80005ce0:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005ce4:	00020d97          	auipc	s11,0x20
    80005ce8:	51cdad83          	lw	s11,1308(s11) # 80026200 <pr+0x18>
  if(locking)
    80005cec:	020d9b63          	bnez	s11,80005d22 <printf+0x70>
  if (fmt == 0)
    80005cf0:	040a0263          	beqz	s4,80005d34 <printf+0x82>
  va_start(ap, fmt);
    80005cf4:	00840793          	addi	a5,s0,8
    80005cf8:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005cfc:	000a4503          	lbu	a0,0(s4)
    80005d00:	16050263          	beqz	a0,80005e64 <printf+0x1b2>
    80005d04:	4481                	li	s1,0
    if(c != '%'){
    80005d06:	02500a93          	li	s5,37
    switch(c){
    80005d0a:	07000b13          	li	s6,112
  consputc('x');
    80005d0e:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d10:	00003b97          	auipc	s7,0x3
    80005d14:	c58b8b93          	addi	s7,s7,-936 # 80008968 <digits>
    switch(c){
    80005d18:	07300c93          	li	s9,115
    80005d1c:	06400c13          	li	s8,100
    80005d20:	a82d                	j	80005d5a <printf+0xa8>
    acquire(&pr.lock);
    80005d22:	00020517          	auipc	a0,0x20
    80005d26:	4c650513          	addi	a0,a0,1222 # 800261e8 <pr>
    80005d2a:	00000097          	auipc	ra,0x0
    80005d2e:	488080e7          	jalr	1160(ra) # 800061b2 <acquire>
    80005d32:	bf7d                	j	80005cf0 <printf+0x3e>
    panic("null fmt");
    80005d34:	00003517          	auipc	a0,0x3
    80005d38:	c1c50513          	addi	a0,a0,-996 # 80008950 <syscalls_name+0x3e8>
    80005d3c:	00000097          	auipc	ra,0x0
    80005d40:	f2c080e7          	jalr	-212(ra) # 80005c68 <panic>
      consputc(c);
    80005d44:	00000097          	auipc	ra,0x0
    80005d48:	c62080e7          	jalr	-926(ra) # 800059a6 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d4c:	2485                	addiw	s1,s1,1
    80005d4e:	009a07b3          	add	a5,s4,s1
    80005d52:	0007c503          	lbu	a0,0(a5)
    80005d56:	10050763          	beqz	a0,80005e64 <printf+0x1b2>
    if(c != '%'){
    80005d5a:	ff5515e3          	bne	a0,s5,80005d44 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005d5e:	2485                	addiw	s1,s1,1
    80005d60:	009a07b3          	add	a5,s4,s1
    80005d64:	0007c783          	lbu	a5,0(a5)
    80005d68:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005d6c:	cfe5                	beqz	a5,80005e64 <printf+0x1b2>
    switch(c){
    80005d6e:	05678a63          	beq	a5,s6,80005dc2 <printf+0x110>
    80005d72:	02fb7663          	bgeu	s6,a5,80005d9e <printf+0xec>
    80005d76:	09978963          	beq	a5,s9,80005e08 <printf+0x156>
    80005d7a:	07800713          	li	a4,120
    80005d7e:	0ce79863          	bne	a5,a4,80005e4e <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005d82:	f8843783          	ld	a5,-120(s0)
    80005d86:	00878713          	addi	a4,a5,8
    80005d8a:	f8e43423          	sd	a4,-120(s0)
    80005d8e:	4605                	li	a2,1
    80005d90:	85ea                	mv	a1,s10
    80005d92:	4388                	lw	a0,0(a5)
    80005d94:	00000097          	auipc	ra,0x0
    80005d98:	e32080e7          	jalr	-462(ra) # 80005bc6 <printint>
      break;
    80005d9c:	bf45                	j	80005d4c <printf+0x9a>
    switch(c){
    80005d9e:	0b578263          	beq	a5,s5,80005e42 <printf+0x190>
    80005da2:	0b879663          	bne	a5,s8,80005e4e <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005da6:	f8843783          	ld	a5,-120(s0)
    80005daa:	00878713          	addi	a4,a5,8
    80005dae:	f8e43423          	sd	a4,-120(s0)
    80005db2:	4605                	li	a2,1
    80005db4:	45a9                	li	a1,10
    80005db6:	4388                	lw	a0,0(a5)
    80005db8:	00000097          	auipc	ra,0x0
    80005dbc:	e0e080e7          	jalr	-498(ra) # 80005bc6 <printint>
      break;
    80005dc0:	b771                	j	80005d4c <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005dc2:	f8843783          	ld	a5,-120(s0)
    80005dc6:	00878713          	addi	a4,a5,8
    80005dca:	f8e43423          	sd	a4,-120(s0)
    80005dce:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005dd2:	03000513          	li	a0,48
    80005dd6:	00000097          	auipc	ra,0x0
    80005dda:	bd0080e7          	jalr	-1072(ra) # 800059a6 <consputc>
  consputc('x');
    80005dde:	07800513          	li	a0,120
    80005de2:	00000097          	auipc	ra,0x0
    80005de6:	bc4080e7          	jalr	-1084(ra) # 800059a6 <consputc>
    80005dea:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005dec:	03c9d793          	srli	a5,s3,0x3c
    80005df0:	97de                	add	a5,a5,s7
    80005df2:	0007c503          	lbu	a0,0(a5)
    80005df6:	00000097          	auipc	ra,0x0
    80005dfa:	bb0080e7          	jalr	-1104(ra) # 800059a6 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005dfe:	0992                	slli	s3,s3,0x4
    80005e00:	397d                	addiw	s2,s2,-1
    80005e02:	fe0915e3          	bnez	s2,80005dec <printf+0x13a>
    80005e06:	b799                	j	80005d4c <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005e08:	f8843783          	ld	a5,-120(s0)
    80005e0c:	00878713          	addi	a4,a5,8
    80005e10:	f8e43423          	sd	a4,-120(s0)
    80005e14:	0007b903          	ld	s2,0(a5)
    80005e18:	00090e63          	beqz	s2,80005e34 <printf+0x182>
      for(; *s; s++)
    80005e1c:	00094503          	lbu	a0,0(s2)
    80005e20:	d515                	beqz	a0,80005d4c <printf+0x9a>
        consputc(*s);
    80005e22:	00000097          	auipc	ra,0x0
    80005e26:	b84080e7          	jalr	-1148(ra) # 800059a6 <consputc>
      for(; *s; s++)
    80005e2a:	0905                	addi	s2,s2,1
    80005e2c:	00094503          	lbu	a0,0(s2)
    80005e30:	f96d                	bnez	a0,80005e22 <printf+0x170>
    80005e32:	bf29                	j	80005d4c <printf+0x9a>
        s = "(null)";
    80005e34:	00003917          	auipc	s2,0x3
    80005e38:	b1490913          	addi	s2,s2,-1260 # 80008948 <syscalls_name+0x3e0>
      for(; *s; s++)
    80005e3c:	02800513          	li	a0,40
    80005e40:	b7cd                	j	80005e22 <printf+0x170>
      consputc('%');
    80005e42:	8556                	mv	a0,s5
    80005e44:	00000097          	auipc	ra,0x0
    80005e48:	b62080e7          	jalr	-1182(ra) # 800059a6 <consputc>
      break;
    80005e4c:	b701                	j	80005d4c <printf+0x9a>
      consputc('%');
    80005e4e:	8556                	mv	a0,s5
    80005e50:	00000097          	auipc	ra,0x0
    80005e54:	b56080e7          	jalr	-1194(ra) # 800059a6 <consputc>
      consputc(c);
    80005e58:	854a                	mv	a0,s2
    80005e5a:	00000097          	auipc	ra,0x0
    80005e5e:	b4c080e7          	jalr	-1204(ra) # 800059a6 <consputc>
      break;
    80005e62:	b5ed                	j	80005d4c <printf+0x9a>
  if(locking)
    80005e64:	020d9163          	bnez	s11,80005e86 <printf+0x1d4>
}
    80005e68:	70e6                	ld	ra,120(sp)
    80005e6a:	7446                	ld	s0,112(sp)
    80005e6c:	74a6                	ld	s1,104(sp)
    80005e6e:	7906                	ld	s2,96(sp)
    80005e70:	69e6                	ld	s3,88(sp)
    80005e72:	6a46                	ld	s4,80(sp)
    80005e74:	6aa6                	ld	s5,72(sp)
    80005e76:	6b06                	ld	s6,64(sp)
    80005e78:	7be2                	ld	s7,56(sp)
    80005e7a:	7c42                	ld	s8,48(sp)
    80005e7c:	7ca2                	ld	s9,40(sp)
    80005e7e:	7d02                	ld	s10,32(sp)
    80005e80:	6de2                	ld	s11,24(sp)
    80005e82:	6129                	addi	sp,sp,192
    80005e84:	8082                	ret
    release(&pr.lock);
    80005e86:	00020517          	auipc	a0,0x20
    80005e8a:	36250513          	addi	a0,a0,866 # 800261e8 <pr>
    80005e8e:	00000097          	auipc	ra,0x0
    80005e92:	3d8080e7          	jalr	984(ra) # 80006266 <release>
}
    80005e96:	bfc9                	j	80005e68 <printf+0x1b6>

0000000080005e98 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005e98:	1101                	addi	sp,sp,-32
    80005e9a:	ec06                	sd	ra,24(sp)
    80005e9c:	e822                	sd	s0,16(sp)
    80005e9e:	e426                	sd	s1,8(sp)
    80005ea0:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005ea2:	00020497          	auipc	s1,0x20
    80005ea6:	34648493          	addi	s1,s1,838 # 800261e8 <pr>
    80005eaa:	00003597          	auipc	a1,0x3
    80005eae:	ab658593          	addi	a1,a1,-1354 # 80008960 <syscalls_name+0x3f8>
    80005eb2:	8526                	mv	a0,s1
    80005eb4:	00000097          	auipc	ra,0x0
    80005eb8:	26e080e7          	jalr	622(ra) # 80006122 <initlock>
  pr.locking = 1;
    80005ebc:	4785                	li	a5,1
    80005ebe:	cc9c                	sw	a5,24(s1)
}
    80005ec0:	60e2                	ld	ra,24(sp)
    80005ec2:	6442                	ld	s0,16(sp)
    80005ec4:	64a2                	ld	s1,8(sp)
    80005ec6:	6105                	addi	sp,sp,32
    80005ec8:	8082                	ret

0000000080005eca <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005eca:	1141                	addi	sp,sp,-16
    80005ecc:	e406                	sd	ra,8(sp)
    80005ece:	e022                	sd	s0,0(sp)
    80005ed0:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005ed2:	100007b7          	lui	a5,0x10000
    80005ed6:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005eda:	f8000713          	li	a4,-128
    80005ede:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005ee2:	470d                	li	a4,3
    80005ee4:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005ee8:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005eec:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005ef0:	469d                	li	a3,7
    80005ef2:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005ef6:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005efa:	00003597          	auipc	a1,0x3
    80005efe:	a8658593          	addi	a1,a1,-1402 # 80008980 <digits+0x18>
    80005f02:	00020517          	auipc	a0,0x20
    80005f06:	30650513          	addi	a0,a0,774 # 80026208 <uart_tx_lock>
    80005f0a:	00000097          	auipc	ra,0x0
    80005f0e:	218080e7          	jalr	536(ra) # 80006122 <initlock>
}
    80005f12:	60a2                	ld	ra,8(sp)
    80005f14:	6402                	ld	s0,0(sp)
    80005f16:	0141                	addi	sp,sp,16
    80005f18:	8082                	ret

0000000080005f1a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005f1a:	1101                	addi	sp,sp,-32
    80005f1c:	ec06                	sd	ra,24(sp)
    80005f1e:	e822                	sd	s0,16(sp)
    80005f20:	e426                	sd	s1,8(sp)
    80005f22:	1000                	addi	s0,sp,32
    80005f24:	84aa                	mv	s1,a0
  push_off();
    80005f26:	00000097          	auipc	ra,0x0
    80005f2a:	240080e7          	jalr	576(ra) # 80006166 <push_off>

  if(panicked){
    80005f2e:	00003797          	auipc	a5,0x3
    80005f32:	0ee7a783          	lw	a5,238(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f36:	10000737          	lui	a4,0x10000
  if(panicked){
    80005f3a:	c391                	beqz	a5,80005f3e <uartputc_sync+0x24>
    for(;;)
    80005f3c:	a001                	j	80005f3c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f3e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005f42:	0ff7f793          	andi	a5,a5,255
    80005f46:	0207f793          	andi	a5,a5,32
    80005f4a:	dbf5                	beqz	a5,80005f3e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005f4c:	0ff4f793          	andi	a5,s1,255
    80005f50:	10000737          	lui	a4,0x10000
    80005f54:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80005f58:	00000097          	auipc	ra,0x0
    80005f5c:	2ae080e7          	jalr	686(ra) # 80006206 <pop_off>
}
    80005f60:	60e2                	ld	ra,24(sp)
    80005f62:	6442                	ld	s0,16(sp)
    80005f64:	64a2                	ld	s1,8(sp)
    80005f66:	6105                	addi	sp,sp,32
    80005f68:	8082                	ret

0000000080005f6a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005f6a:	00003717          	auipc	a4,0x3
    80005f6e:	0b673703          	ld	a4,182(a4) # 80009020 <uart_tx_r>
    80005f72:	00003797          	auipc	a5,0x3
    80005f76:	0b67b783          	ld	a5,182(a5) # 80009028 <uart_tx_w>
    80005f7a:	06e78c63          	beq	a5,a4,80005ff2 <uartstart+0x88>
{
    80005f7e:	7139                	addi	sp,sp,-64
    80005f80:	fc06                	sd	ra,56(sp)
    80005f82:	f822                	sd	s0,48(sp)
    80005f84:	f426                	sd	s1,40(sp)
    80005f86:	f04a                	sd	s2,32(sp)
    80005f88:	ec4e                	sd	s3,24(sp)
    80005f8a:	e852                	sd	s4,16(sp)
    80005f8c:	e456                	sd	s5,8(sp)
    80005f8e:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f90:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005f94:	00020a17          	auipc	s4,0x20
    80005f98:	274a0a13          	addi	s4,s4,628 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    80005f9c:	00003497          	auipc	s1,0x3
    80005fa0:	08448493          	addi	s1,s1,132 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005fa4:	00003997          	auipc	s3,0x3
    80005fa8:	08498993          	addi	s3,s3,132 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fac:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005fb0:	0ff7f793          	andi	a5,a5,255
    80005fb4:	0207f793          	andi	a5,a5,32
    80005fb8:	c785                	beqz	a5,80005fe0 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005fba:	01f77793          	andi	a5,a4,31
    80005fbe:	97d2                	add	a5,a5,s4
    80005fc0:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80005fc4:	0705                	addi	a4,a4,1
    80005fc6:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005fc8:	8526                	mv	a0,s1
    80005fca:	ffffb097          	auipc	ra,0xffffb
    80005fce:	726080e7          	jalr	1830(ra) # 800016f0 <wakeup>
    
    WriteReg(THR, c);
    80005fd2:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005fd6:	6098                	ld	a4,0(s1)
    80005fd8:	0009b783          	ld	a5,0(s3)
    80005fdc:	fce798e3          	bne	a5,a4,80005fac <uartstart+0x42>
  }
}
    80005fe0:	70e2                	ld	ra,56(sp)
    80005fe2:	7442                	ld	s0,48(sp)
    80005fe4:	74a2                	ld	s1,40(sp)
    80005fe6:	7902                	ld	s2,32(sp)
    80005fe8:	69e2                	ld	s3,24(sp)
    80005fea:	6a42                	ld	s4,16(sp)
    80005fec:	6aa2                	ld	s5,8(sp)
    80005fee:	6121                	addi	sp,sp,64
    80005ff0:	8082                	ret
    80005ff2:	8082                	ret

0000000080005ff4 <uartputc>:
{
    80005ff4:	7179                	addi	sp,sp,-48
    80005ff6:	f406                	sd	ra,40(sp)
    80005ff8:	f022                	sd	s0,32(sp)
    80005ffa:	ec26                	sd	s1,24(sp)
    80005ffc:	e84a                	sd	s2,16(sp)
    80005ffe:	e44e                	sd	s3,8(sp)
    80006000:	e052                	sd	s4,0(sp)
    80006002:	1800                	addi	s0,sp,48
    80006004:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006006:	00020517          	auipc	a0,0x20
    8000600a:	20250513          	addi	a0,a0,514 # 80026208 <uart_tx_lock>
    8000600e:	00000097          	auipc	ra,0x0
    80006012:	1a4080e7          	jalr	420(ra) # 800061b2 <acquire>
  if(panicked){
    80006016:	00003797          	auipc	a5,0x3
    8000601a:	0067a783          	lw	a5,6(a5) # 8000901c <panicked>
    8000601e:	c391                	beqz	a5,80006022 <uartputc+0x2e>
    for(;;)
    80006020:	a001                	j	80006020 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006022:	00003797          	auipc	a5,0x3
    80006026:	0067b783          	ld	a5,6(a5) # 80009028 <uart_tx_w>
    8000602a:	00003717          	auipc	a4,0x3
    8000602e:	ff673703          	ld	a4,-10(a4) # 80009020 <uart_tx_r>
    80006032:	02070713          	addi	a4,a4,32
    80006036:	02f71b63          	bne	a4,a5,8000606c <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000603a:	00020a17          	auipc	s4,0x20
    8000603e:	1cea0a13          	addi	s4,s4,462 # 80026208 <uart_tx_lock>
    80006042:	00003497          	auipc	s1,0x3
    80006046:	fde48493          	addi	s1,s1,-34 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000604a:	00003917          	auipc	s2,0x3
    8000604e:	fde90913          	addi	s2,s2,-34 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006052:	85d2                	mv	a1,s4
    80006054:	8526                	mv	a0,s1
    80006056:	ffffb097          	auipc	ra,0xffffb
    8000605a:	50e080e7          	jalr	1294(ra) # 80001564 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000605e:	00093783          	ld	a5,0(s2)
    80006062:	6098                	ld	a4,0(s1)
    80006064:	02070713          	addi	a4,a4,32
    80006068:	fef705e3          	beq	a4,a5,80006052 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000606c:	00020497          	auipc	s1,0x20
    80006070:	19c48493          	addi	s1,s1,412 # 80026208 <uart_tx_lock>
    80006074:	01f7f713          	andi	a4,a5,31
    80006078:	9726                	add	a4,a4,s1
    8000607a:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    8000607e:	0785                	addi	a5,a5,1
    80006080:	00003717          	auipc	a4,0x3
    80006084:	faf73423          	sd	a5,-88(a4) # 80009028 <uart_tx_w>
      uartstart();
    80006088:	00000097          	auipc	ra,0x0
    8000608c:	ee2080e7          	jalr	-286(ra) # 80005f6a <uartstart>
      release(&uart_tx_lock);
    80006090:	8526                	mv	a0,s1
    80006092:	00000097          	auipc	ra,0x0
    80006096:	1d4080e7          	jalr	468(ra) # 80006266 <release>
}
    8000609a:	70a2                	ld	ra,40(sp)
    8000609c:	7402                	ld	s0,32(sp)
    8000609e:	64e2                	ld	s1,24(sp)
    800060a0:	6942                	ld	s2,16(sp)
    800060a2:	69a2                	ld	s3,8(sp)
    800060a4:	6a02                	ld	s4,0(sp)
    800060a6:	6145                	addi	sp,sp,48
    800060a8:	8082                	ret

00000000800060aa <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800060aa:	1141                	addi	sp,sp,-16
    800060ac:	e422                	sd	s0,8(sp)
    800060ae:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800060b0:	100007b7          	lui	a5,0x10000
    800060b4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800060b8:	8b85                	andi	a5,a5,1
    800060ba:	cb91                	beqz	a5,800060ce <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800060bc:	100007b7          	lui	a5,0x10000
    800060c0:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800060c4:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800060c8:	6422                	ld	s0,8(sp)
    800060ca:	0141                	addi	sp,sp,16
    800060cc:	8082                	ret
    return -1;
    800060ce:	557d                	li	a0,-1
    800060d0:	bfe5                	j	800060c8 <uartgetc+0x1e>

00000000800060d2 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800060d2:	1101                	addi	sp,sp,-32
    800060d4:	ec06                	sd	ra,24(sp)
    800060d6:	e822                	sd	s0,16(sp)
    800060d8:	e426                	sd	s1,8(sp)
    800060da:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800060dc:	54fd                	li	s1,-1
    int c = uartgetc();
    800060de:	00000097          	auipc	ra,0x0
    800060e2:	fcc080e7          	jalr	-52(ra) # 800060aa <uartgetc>
    if(c == -1)
    800060e6:	00950763          	beq	a0,s1,800060f4 <uartintr+0x22>
      break;
    consoleintr(c);
    800060ea:	00000097          	auipc	ra,0x0
    800060ee:	8fe080e7          	jalr	-1794(ra) # 800059e8 <consoleintr>
  while(1){
    800060f2:	b7f5                	j	800060de <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800060f4:	00020497          	auipc	s1,0x20
    800060f8:	11448493          	addi	s1,s1,276 # 80026208 <uart_tx_lock>
    800060fc:	8526                	mv	a0,s1
    800060fe:	00000097          	auipc	ra,0x0
    80006102:	0b4080e7          	jalr	180(ra) # 800061b2 <acquire>
  uartstart();
    80006106:	00000097          	auipc	ra,0x0
    8000610a:	e64080e7          	jalr	-412(ra) # 80005f6a <uartstart>
  release(&uart_tx_lock);
    8000610e:	8526                	mv	a0,s1
    80006110:	00000097          	auipc	ra,0x0
    80006114:	156080e7          	jalr	342(ra) # 80006266 <release>
}
    80006118:	60e2                	ld	ra,24(sp)
    8000611a:	6442                	ld	s0,16(sp)
    8000611c:	64a2                	ld	s1,8(sp)
    8000611e:	6105                	addi	sp,sp,32
    80006120:	8082                	ret

0000000080006122 <initlock>:
#include "riscv.h"
#include "proc.h"
#include "defs.h"

void initlock(struct spinlock *lk, char *name)
{
    80006122:	1141                	addi	sp,sp,-16
    80006124:	e422                	sd	s0,8(sp)
    80006126:	0800                	addi	s0,sp,16
  lk->name = name;
    80006128:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000612a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000612e:	00053823          	sd	zero,16(a0)
}
    80006132:	6422                	ld	s0,8(sp)
    80006134:	0141                	addi	sp,sp,16
    80006136:	8082                	ret

0000000080006138 <holding>:
// Check whether this cpu is holding the lock.
// Interrupts must be off.
int holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006138:	411c                	lw	a5,0(a0)
    8000613a:	e399                	bnez	a5,80006140 <holding+0x8>
    8000613c:	4501                	li	a0,0
  return r;
}
    8000613e:	8082                	ret
{
    80006140:	1101                	addi	sp,sp,-32
    80006142:	ec06                	sd	ra,24(sp)
    80006144:	e822                	sd	s0,16(sp)
    80006146:	e426                	sd	s1,8(sp)
    80006148:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000614a:	6904                	ld	s1,16(a0)
    8000614c:	ffffb097          	auipc	ra,0xffffb
    80006150:	d2a080e7          	jalr	-726(ra) # 80000e76 <mycpu>
    80006154:	40a48533          	sub	a0,s1,a0
    80006158:	00153513          	seqz	a0,a0
}
    8000615c:	60e2                	ld	ra,24(sp)
    8000615e:	6442                	ld	s0,16(sp)
    80006160:	64a2                	ld	s1,8(sp)
    80006162:	6105                	addi	sp,sp,32
    80006164:	8082                	ret

0000000080006166 <push_off>:
// push_off/pop_off are like intr_off()/intr_on() except that they are matched:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void push_off(void)
{
    80006166:	1101                	addi	sp,sp,-32
    80006168:	ec06                	sd	ra,24(sp)
    8000616a:	e822                	sd	s0,16(sp)
    8000616c:	e426                	sd	s1,8(sp)
    8000616e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80006170:	100024f3          	csrr	s1,sstatus
    80006174:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006178:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r"(x));
    8000617a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if (mycpu()->noff == 0)
    8000617e:	ffffb097          	auipc	ra,0xffffb
    80006182:	cf8080e7          	jalr	-776(ra) # 80000e76 <mycpu>
    80006186:	5d3c                	lw	a5,120(a0)
    80006188:	cf89                	beqz	a5,800061a2 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000618a:	ffffb097          	auipc	ra,0xffffb
    8000618e:	cec080e7          	jalr	-788(ra) # 80000e76 <mycpu>
    80006192:	5d3c                	lw	a5,120(a0)
    80006194:	2785                	addiw	a5,a5,1
    80006196:	dd3c                	sw	a5,120(a0)
}
    80006198:	60e2                	ld	ra,24(sp)
    8000619a:	6442                	ld	s0,16(sp)
    8000619c:	64a2                	ld	s1,8(sp)
    8000619e:	6105                	addi	sp,sp,32
    800061a0:	8082                	ret
    mycpu()->intena = old;
    800061a2:	ffffb097          	auipc	ra,0xffffb
    800061a6:	cd4080e7          	jalr	-812(ra) # 80000e76 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800061aa:	8085                	srli	s1,s1,0x1
    800061ac:	8885                	andi	s1,s1,1
    800061ae:	dd64                	sw	s1,124(a0)
    800061b0:	bfe9                	j	8000618a <push_off+0x24>

00000000800061b2 <acquire>:
{
    800061b2:	1101                	addi	sp,sp,-32
    800061b4:	ec06                	sd	ra,24(sp)
    800061b6:	e822                	sd	s0,16(sp)
    800061b8:	e426                	sd	s1,8(sp)
    800061ba:	1000                	addi	s0,sp,32
    800061bc:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800061be:	00000097          	auipc	ra,0x0
    800061c2:	fa8080e7          	jalr	-88(ra) # 80006166 <push_off>
  if (holding(lk))
    800061c6:	8526                	mv	a0,s1
    800061c8:	00000097          	auipc	ra,0x0
    800061cc:	f70080e7          	jalr	-144(ra) # 80006138 <holding>
  while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061d0:	4705                	li	a4,1
  if (holding(lk))
    800061d2:	e115                	bnez	a0,800061f6 <acquire+0x44>
  while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061d4:	87ba                	mv	a5,a4
    800061d6:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800061da:	2781                	sext.w	a5,a5
    800061dc:	ffe5                	bnez	a5,800061d4 <acquire+0x22>
  __sync_synchronize();
    800061de:	0ff0000f          	fence
  lk->cpu = mycpu();
    800061e2:	ffffb097          	auipc	ra,0xffffb
    800061e6:	c94080e7          	jalr	-876(ra) # 80000e76 <mycpu>
    800061ea:	e888                	sd	a0,16(s1)
}
    800061ec:	60e2                	ld	ra,24(sp)
    800061ee:	6442                	ld	s0,16(sp)
    800061f0:	64a2                	ld	s1,8(sp)
    800061f2:	6105                	addi	sp,sp,32
    800061f4:	8082                	ret
    panic("acquire");
    800061f6:	00002517          	auipc	a0,0x2
    800061fa:	79250513          	addi	a0,a0,1938 # 80008988 <digits+0x20>
    800061fe:	00000097          	auipc	ra,0x0
    80006202:	a6a080e7          	jalr	-1430(ra) # 80005c68 <panic>

0000000080006206 <pop_off>:

void pop_off(void)
{
    80006206:	1141                	addi	sp,sp,-16
    80006208:	e406                	sd	ra,8(sp)
    8000620a:	e022                	sd	s0,0(sp)
    8000620c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000620e:	ffffb097          	auipc	ra,0xffffb
    80006212:	c68080e7          	jalr	-920(ra) # 80000e76 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80006216:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000621a:	8b89                	andi	a5,a5,2
  if (intr_get())
    8000621c:	e78d                	bnez	a5,80006246 <pop_off+0x40>
    panic("pop_off - interruptible");
  if (c->noff < 1)
    8000621e:	5d3c                	lw	a5,120(a0)
    80006220:	02f05b63          	blez	a5,80006256 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006224:	37fd                	addiw	a5,a5,-1
    80006226:	0007871b          	sext.w	a4,a5
    8000622a:	dd3c                	sw	a5,120(a0)
  if (c->noff == 0 && c->intena)
    8000622c:	eb09                	bnez	a4,8000623e <pop_off+0x38>
    8000622e:	5d7c                	lw	a5,124(a0)
    80006230:	c799                	beqz	a5,8000623e <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80006232:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006236:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    8000623a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000623e:	60a2                	ld	ra,8(sp)
    80006240:	6402                	ld	s0,0(sp)
    80006242:	0141                	addi	sp,sp,16
    80006244:	8082                	ret
    panic("pop_off - interruptible");
    80006246:	00002517          	auipc	a0,0x2
    8000624a:	74a50513          	addi	a0,a0,1866 # 80008990 <digits+0x28>
    8000624e:	00000097          	auipc	ra,0x0
    80006252:	a1a080e7          	jalr	-1510(ra) # 80005c68 <panic>
    panic("pop_off");
    80006256:	00002517          	auipc	a0,0x2
    8000625a:	75250513          	addi	a0,a0,1874 # 800089a8 <digits+0x40>
    8000625e:	00000097          	auipc	ra,0x0
    80006262:	a0a080e7          	jalr	-1526(ra) # 80005c68 <panic>

0000000080006266 <release>:
{
    80006266:	1101                	addi	sp,sp,-32
    80006268:	ec06                	sd	ra,24(sp)
    8000626a:	e822                	sd	s0,16(sp)
    8000626c:	e426                	sd	s1,8(sp)
    8000626e:	1000                	addi	s0,sp,32
    80006270:	84aa                	mv	s1,a0
  if (!holding(lk))
    80006272:	00000097          	auipc	ra,0x0
    80006276:	ec6080e7          	jalr	-314(ra) # 80006138 <holding>
    8000627a:	c115                	beqz	a0,8000629e <release+0x38>
  lk->cpu = 0;
    8000627c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006280:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006284:	0f50000f          	fence	iorw,ow
    80006288:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000628c:	00000097          	auipc	ra,0x0
    80006290:	f7a080e7          	jalr	-134(ra) # 80006206 <pop_off>
}
    80006294:	60e2                	ld	ra,24(sp)
    80006296:	6442                	ld	s0,16(sp)
    80006298:	64a2                	ld	s1,8(sp)
    8000629a:	6105                	addi	sp,sp,32
    8000629c:	8082                	ret
    panic("release");
    8000629e:	00002517          	auipc	a0,0x2
    800062a2:	71250513          	addi	a0,a0,1810 # 800089b0 <digits+0x48>
    800062a6:	00000097          	auipc	ra,0x0
    800062aa:	9c2080e7          	jalr	-1598(ra) # 80005c68 <panic>
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
