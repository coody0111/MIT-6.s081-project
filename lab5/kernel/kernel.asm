
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0003e117          	auipc	sp,0x3e
    80000004:	14010113          	addi	sp,sp,320 # 8003e140 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	053050ef          	jal	ra,80005868 <start>

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
    8000002c:	e7c1                	bnez	a5,800000b4 <kfree+0x98>
    8000002e:	892a                	mv	s2,a0
    80000030:	00046797          	auipc	a5,0x46
    80000034:	21078793          	addi	a5,a5,528 # 80046240 <end>
    80000038:	06f56e63          	bltu	a0,a5,800000b4 <kfree+0x98>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	06f57a63          	bgeu	a0,a5,800000b4 <kfree+0x98>
    panic("kfree");

  // 檢查並減少引用計數
  int index = REFCOUNT_INDEX((uint64)pa);
    80000044:	800004b7          	lui	s1,0x80000
    80000048:	94aa                	add	s1,s1,a0
    8000004a:	80b1                	srli	s1,s1,0xc
    8000004c:	2481                	sext.w	s1,s1
  if (index >= 0 && index < sizeof(ref_count) / sizeof(ref_count[0]))
    8000004e:	67a1                	lui	a5,0x8
    80000050:	08f4fb63          	bgeu	s1,a5,800000e6 <kfree+0xca>
  {
    acquire(&kmem.lock);
    80000054:	00009517          	auipc	a0,0x9
    80000058:	fdc50513          	addi	a0,a0,-36 # 80009030 <kmem>
    8000005c:	00006097          	auipc	ra,0x6
    80000060:	206080e7          	jalr	518(ra) # 80006262 <acquire>
    if (ref_count[index] > 0)
    80000064:	00249713          	slli	a4,s1,0x2
    80000068:	00009797          	auipc	a5,0x9
    8000006c:	fe878793          	addi	a5,a5,-24 # 80009050 <ref_count>
    80000070:	97ba                	add	a5,a5,a4
    80000072:	439c                	lw	a5,0(a5)
    80000074:	00f05a63          	blez	a5,80000088 <kfree+0x6c>
    {
      ref_count[index]--;
    80000078:	86ba                	mv	a3,a4
    8000007a:	00009717          	auipc	a4,0x9
    8000007e:	fd670713          	addi	a4,a4,-42 # 80009050 <ref_count>
    80000082:	9736                	add	a4,a4,a3
    80000084:	37fd                	addiw	a5,a5,-1
    80000086:	c31c                	sw	a5,0(a4)
    }
    if (ref_count[index] == 0)
    80000088:	048a                	slli	s1,s1,0x2
    8000008a:	00009797          	auipc	a5,0x9
    8000008e:	fc678793          	addi	a5,a5,-58 # 80009050 <ref_count>
    80000092:	94be                	add	s1,s1,a5
    80000094:	409c                	lw	a5,0(s1)
    80000096:	c79d                	beqz	a5,800000c4 <kfree+0xa8>

      r = (struct run *)pa;
      r->next = kmem.freelist;
      kmem.freelist = r;
    }
    release(&kmem.lock);
    80000098:	00009517          	auipc	a0,0x9
    8000009c:	f9850513          	addi	a0,a0,-104 # 80009030 <kmem>
    800000a0:	00006097          	auipc	ra,0x6
    800000a4:	276080e7          	jalr	630(ra) # 80006316 <release>
  }
  else
  {
    panic("kfree: ref_count index out of bounds");
  }
}
    800000a8:	60e2                	ld	ra,24(sp)
    800000aa:	6442                	ld	s0,16(sp)
    800000ac:	64a2                	ld	s1,8(sp)
    800000ae:	6902                	ld	s2,0(sp)
    800000b0:	6105                	addi	sp,sp,32
    800000b2:	8082                	ret
    panic("kfree");
    800000b4:	00008517          	auipc	a0,0x8
    800000b8:	f5c50513          	addi	a0,a0,-164 # 80008010 <etext+0x10>
    800000bc:	00006097          	auipc	ra,0x6
    800000c0:	c5c080e7          	jalr	-932(ra) # 80005d18 <panic>
      memset(pa, 1, PGSIZE);
    800000c4:	6605                	lui	a2,0x1
    800000c6:	4585                	li	a1,1
    800000c8:	854a                	mv	a0,s2
    800000ca:	00000097          	auipc	ra,0x0
    800000ce:	148080e7          	jalr	328(ra) # 80000212 <memset>
      r->next = kmem.freelist;
    800000d2:	00009797          	auipc	a5,0x9
    800000d6:	f5e78793          	addi	a5,a5,-162 # 80009030 <kmem>
    800000da:	6f98                	ld	a4,24(a5)
    800000dc:	00e93023          	sd	a4,0(s2)
      kmem.freelist = r;
    800000e0:	0127bc23          	sd	s2,24(a5)
    800000e4:	bf55                	j	80000098 <kfree+0x7c>
    panic("kfree: ref_count index out of bounds");
    800000e6:	00008517          	auipc	a0,0x8
    800000ea:	f3250513          	addi	a0,a0,-206 # 80008018 <etext+0x18>
    800000ee:	00006097          	auipc	ra,0x6
    800000f2:	c2a080e7          	jalr	-982(ra) # 80005d18 <panic>

00000000800000f6 <freerange>:
{
    800000f6:	7179                	addi	sp,sp,-48
    800000f8:	f406                	sd	ra,40(sp)
    800000fa:	f022                	sd	s0,32(sp)
    800000fc:	ec26                	sd	s1,24(sp)
    800000fe:	e84a                	sd	s2,16(sp)
    80000100:	e44e                	sd	s3,8(sp)
    80000102:	e052                	sd	s4,0(sp)
    80000104:	1800                	addi	s0,sp,48
  p = (char *)PGROUNDUP((uint64)pa_start);
    80000106:	6785                	lui	a5,0x1
    80000108:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    8000010c:	94aa                	add	s1,s1,a0
    8000010e:	757d                	lui	a0,0xfffff
    80000110:	8ce9                	and	s1,s1,a0
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000112:	94be                	add	s1,s1,a5
    80000114:	0095ee63          	bltu	a1,s1,80000130 <freerange+0x3a>
    80000118:	892e                	mv	s2,a1
    kfree(p);
    8000011a:	7a7d                	lui	s4,0xfffff
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    8000011c:	6985                	lui	s3,0x1
    kfree(p);
    8000011e:	01448533          	add	a0,s1,s4
    80000122:	00000097          	auipc	ra,0x0
    80000126:	efa080e7          	jalr	-262(ra) # 8000001c <kfree>
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    8000012a:	94ce                	add	s1,s1,s3
    8000012c:	fe9979e3          	bgeu	s2,s1,8000011e <freerange+0x28>
}
    80000130:	70a2                	ld	ra,40(sp)
    80000132:	7402                	ld	s0,32(sp)
    80000134:	64e2                	ld	s1,24(sp)
    80000136:	6942                	ld	s2,16(sp)
    80000138:	69a2                	ld	s3,8(sp)
    8000013a:	6a02                	ld	s4,0(sp)
    8000013c:	6145                	addi	sp,sp,48
    8000013e:	8082                	ret

0000000080000140 <kinit>:
{
    80000140:	1141                	addi	sp,sp,-16
    80000142:	e406                	sd	ra,8(sp)
    80000144:	e022                	sd	s0,0(sp)
    80000146:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000148:	00008597          	auipc	a1,0x8
    8000014c:	ef858593          	addi	a1,a1,-264 # 80008040 <etext+0x40>
    80000150:	00009517          	auipc	a0,0x9
    80000154:	ee050513          	addi	a0,a0,-288 # 80009030 <kmem>
    80000158:	00006097          	auipc	ra,0x6
    8000015c:	07a080e7          	jalr	122(ra) # 800061d2 <initlock>
  freerange(end, (void *)PHYSTOP);
    80000160:	45c5                	li	a1,17
    80000162:	05ee                	slli	a1,a1,0x1b
    80000164:	00046517          	auipc	a0,0x46
    80000168:	0dc50513          	addi	a0,a0,220 # 80046240 <end>
    8000016c:	00000097          	auipc	ra,0x0
    80000170:	f8a080e7          	jalr	-118(ra) # 800000f6 <freerange>
}
    80000174:	60a2                	ld	ra,8(sp)
    80000176:	6402                	ld	s0,0(sp)
    80000178:	0141                	addi	sp,sp,16
    8000017a:	8082                	ret

000000008000017c <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000017c:	1101                	addi	sp,sp,-32
    8000017e:	ec06                	sd	ra,24(sp)
    80000180:	e822                	sd	s0,16(sp)
    80000182:	e426                	sd	s1,8(sp)
    80000184:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000186:	00009497          	auipc	s1,0x9
    8000018a:	eaa48493          	addi	s1,s1,-342 # 80009030 <kmem>
    8000018e:	8526                	mv	a0,s1
    80000190:	00006097          	auipc	ra,0x6
    80000194:	0d2080e7          	jalr	210(ra) # 80006262 <acquire>
  r = kmem.freelist;
    80000198:	6c84                	ld	s1,24(s1)
  if (r)
    8000019a:	c0bd                	beqz	s1,80000200 <kalloc+0x84>
  {
    kmem.freelist = r->next;
    8000019c:	609c                	ld	a5,0(s1)
    8000019e:	00009717          	auipc	a4,0x9
    800001a2:	eaf73523          	sd	a5,-342(a4) # 80009048 <kmem+0x18>

    // 初始化引用計數為 1
    int index = REFCOUNT_INDEX((uint64)r);
    800001a6:	800007b7          	lui	a5,0x80000
    800001aa:	97a6                	add	a5,a5,s1
    800001ac:	83b1                	srli	a5,a5,0xc
    800001ae:	2781                	sext.w	a5,a5
    if (index >= 0 && index < sizeof(ref_count) / sizeof(ref_count[0]))
    800001b0:	6721                	lui	a4,0x8
    800001b2:	02e7ff63          	bgeu	a5,a4,800001f0 <kalloc+0x74>
    {
      ref_count[index] = 1;
    800001b6:	078a                	slli	a5,a5,0x2
    800001b8:	00009717          	auipc	a4,0x9
    800001bc:	e9870713          	addi	a4,a4,-360 # 80009050 <ref_count>
    800001c0:	97ba                	add	a5,a5,a4
    800001c2:	4705                	li	a4,1
    800001c4:	c398                	sw	a4,0(a5)
    else
    {
      panic("kalloc: ref_count index out of bounds");
    }
  }
  release(&kmem.lock);
    800001c6:	00009517          	auipc	a0,0x9
    800001ca:	e6a50513          	addi	a0,a0,-406 # 80009030 <kmem>
    800001ce:	00006097          	auipc	ra,0x6
    800001d2:	148080e7          	jalr	328(ra) # 80006316 <release>

  if (r)
    memset((char *)r, 5, PGSIZE); // fill with junk
    800001d6:	6605                	lui	a2,0x1
    800001d8:	4595                	li	a1,5
    800001da:	8526                	mv	a0,s1
    800001dc:	00000097          	auipc	ra,0x0
    800001e0:	036080e7          	jalr	54(ra) # 80000212 <memset>
  return (void *)r;
}
    800001e4:	8526                	mv	a0,s1
    800001e6:	60e2                	ld	ra,24(sp)
    800001e8:	6442                	ld	s0,16(sp)
    800001ea:	64a2                	ld	s1,8(sp)
    800001ec:	6105                	addi	sp,sp,32
    800001ee:	8082                	ret
      panic("kalloc: ref_count index out of bounds");
    800001f0:	00008517          	auipc	a0,0x8
    800001f4:	e5850513          	addi	a0,a0,-424 # 80008048 <etext+0x48>
    800001f8:	00006097          	auipc	ra,0x6
    800001fc:	b20080e7          	jalr	-1248(ra) # 80005d18 <panic>
  release(&kmem.lock);
    80000200:	00009517          	auipc	a0,0x9
    80000204:	e3050513          	addi	a0,a0,-464 # 80009030 <kmem>
    80000208:	00006097          	auipc	ra,0x6
    8000020c:	10e080e7          	jalr	270(ra) # 80006316 <release>
  if (r)
    80000210:	bfd1                	j	800001e4 <kalloc+0x68>

0000000080000212 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000212:	1141                	addi	sp,sp,-16
    80000214:	e422                	sd	s0,8(sp)
    80000216:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000218:	ce09                	beqz	a2,80000232 <memset+0x20>
    8000021a:	87aa                	mv	a5,a0
    8000021c:	fff6071b          	addiw	a4,a2,-1
    80000220:	1702                	slli	a4,a4,0x20
    80000222:	9301                	srli	a4,a4,0x20
    80000224:	0705                	addi	a4,a4,1
    80000226:	972a                	add	a4,a4,a0
    cdst[i] = c;
    80000228:	00b78023          	sb	a1,0(a5) # ffffffff80000000 <end+0xfffffffefffb9dc0>
  for(i = 0; i < n; i++){
    8000022c:	0785                	addi	a5,a5,1
    8000022e:	fee79de3          	bne	a5,a4,80000228 <memset+0x16>
  }
  return dst;
}
    80000232:	6422                	ld	s0,8(sp)
    80000234:	0141                	addi	sp,sp,16
    80000236:	8082                	ret

0000000080000238 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000238:	1141                	addi	sp,sp,-16
    8000023a:	e422                	sd	s0,8(sp)
    8000023c:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    8000023e:	ca05                	beqz	a2,8000026e <memcmp+0x36>
    80000240:	fff6069b          	addiw	a3,a2,-1
    80000244:	1682                	slli	a3,a3,0x20
    80000246:	9281                	srli	a3,a3,0x20
    80000248:	0685                	addi	a3,a3,1
    8000024a:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    8000024c:	00054783          	lbu	a5,0(a0)
    80000250:	0005c703          	lbu	a4,0(a1)
    80000254:	00e79863          	bne	a5,a4,80000264 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000258:	0505                	addi	a0,a0,1
    8000025a:	0585                	addi	a1,a1,1
  while(n-- > 0){
    8000025c:	fed518e3          	bne	a0,a3,8000024c <memcmp+0x14>
  }

  return 0;
    80000260:	4501                	li	a0,0
    80000262:	a019                	j	80000268 <memcmp+0x30>
      return *s1 - *s2;
    80000264:	40e7853b          	subw	a0,a5,a4
}
    80000268:	6422                	ld	s0,8(sp)
    8000026a:	0141                	addi	sp,sp,16
    8000026c:	8082                	ret
  return 0;
    8000026e:	4501                	li	a0,0
    80000270:	bfe5                	j	80000268 <memcmp+0x30>

0000000080000272 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000272:	1141                	addi	sp,sp,-16
    80000274:	e422                	sd	s0,8(sp)
    80000276:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000278:	ca0d                	beqz	a2,800002aa <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    8000027a:	00a5f963          	bgeu	a1,a0,8000028c <memmove+0x1a>
    8000027e:	02061693          	slli	a3,a2,0x20
    80000282:	9281                	srli	a3,a3,0x20
    80000284:	00d58733          	add	a4,a1,a3
    80000288:	02e56463          	bltu	a0,a4,800002b0 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    8000028c:	fff6079b          	addiw	a5,a2,-1
    80000290:	1782                	slli	a5,a5,0x20
    80000292:	9381                	srli	a5,a5,0x20
    80000294:	0785                	addi	a5,a5,1
    80000296:	97ae                	add	a5,a5,a1
    80000298:	872a                	mv	a4,a0
      *d++ = *s++;
    8000029a:	0585                	addi	a1,a1,1
    8000029c:	0705                	addi	a4,a4,1
    8000029e:	fff5c683          	lbu	a3,-1(a1)
    800002a2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800002a6:	fef59ae3          	bne	a1,a5,8000029a <memmove+0x28>

  return dst;
}
    800002aa:	6422                	ld	s0,8(sp)
    800002ac:	0141                	addi	sp,sp,16
    800002ae:	8082                	ret
    d += n;
    800002b0:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800002b2:	fff6079b          	addiw	a5,a2,-1
    800002b6:	1782                	slli	a5,a5,0x20
    800002b8:	9381                	srli	a5,a5,0x20
    800002ba:	fff7c793          	not	a5,a5
    800002be:	97ba                	add	a5,a5,a4
      *--d = *--s;
    800002c0:	177d                	addi	a4,a4,-1
    800002c2:	16fd                	addi	a3,a3,-1
    800002c4:	00074603          	lbu	a2,0(a4)
    800002c8:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    800002cc:	fef71ae3          	bne	a4,a5,800002c0 <memmove+0x4e>
    800002d0:	bfe9                	j	800002aa <memmove+0x38>

00000000800002d2 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    800002d2:	1141                	addi	sp,sp,-16
    800002d4:	e406                	sd	ra,8(sp)
    800002d6:	e022                	sd	s0,0(sp)
    800002d8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    800002da:	00000097          	auipc	ra,0x0
    800002de:	f98080e7          	jalr	-104(ra) # 80000272 <memmove>
}
    800002e2:	60a2                	ld	ra,8(sp)
    800002e4:	6402                	ld	s0,0(sp)
    800002e6:	0141                	addi	sp,sp,16
    800002e8:	8082                	ret

00000000800002ea <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    800002ea:	1141                	addi	sp,sp,-16
    800002ec:	e422                	sd	s0,8(sp)
    800002ee:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    800002f0:	ce11                	beqz	a2,8000030c <strncmp+0x22>
    800002f2:	00054783          	lbu	a5,0(a0)
    800002f6:	cf89                	beqz	a5,80000310 <strncmp+0x26>
    800002f8:	0005c703          	lbu	a4,0(a1)
    800002fc:	00f71a63          	bne	a4,a5,80000310 <strncmp+0x26>
    n--, p++, q++;
    80000300:	367d                	addiw	a2,a2,-1
    80000302:	0505                	addi	a0,a0,1
    80000304:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000306:	f675                	bnez	a2,800002f2 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000308:	4501                	li	a0,0
    8000030a:	a809                	j	8000031c <strncmp+0x32>
    8000030c:	4501                	li	a0,0
    8000030e:	a039                	j	8000031c <strncmp+0x32>
  if(n == 0)
    80000310:	ca09                	beqz	a2,80000322 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000312:	00054503          	lbu	a0,0(a0)
    80000316:	0005c783          	lbu	a5,0(a1)
    8000031a:	9d1d                	subw	a0,a0,a5
}
    8000031c:	6422                	ld	s0,8(sp)
    8000031e:	0141                	addi	sp,sp,16
    80000320:	8082                	ret
    return 0;
    80000322:	4501                	li	a0,0
    80000324:	bfe5                	j	8000031c <strncmp+0x32>

0000000080000326 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000326:	1141                	addi	sp,sp,-16
    80000328:	e422                	sd	s0,8(sp)
    8000032a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000032c:	872a                	mv	a4,a0
    8000032e:	8832                	mv	a6,a2
    80000330:	367d                	addiw	a2,a2,-1
    80000332:	01005963          	blez	a6,80000344 <strncpy+0x1e>
    80000336:	0705                	addi	a4,a4,1
    80000338:	0005c783          	lbu	a5,0(a1)
    8000033c:	fef70fa3          	sb	a5,-1(a4)
    80000340:	0585                	addi	a1,a1,1
    80000342:	f7f5                	bnez	a5,8000032e <strncpy+0x8>
    ;
  while(n-- > 0)
    80000344:	00c05d63          	blez	a2,8000035e <strncpy+0x38>
    80000348:	86ba                	mv	a3,a4
    *s++ = 0;
    8000034a:	0685                	addi	a3,a3,1
    8000034c:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000350:	fff6c793          	not	a5,a3
    80000354:	9fb9                	addw	a5,a5,a4
    80000356:	010787bb          	addw	a5,a5,a6
    8000035a:	fef048e3          	bgtz	a5,8000034a <strncpy+0x24>
  return os;
}
    8000035e:	6422                	ld	s0,8(sp)
    80000360:	0141                	addi	sp,sp,16
    80000362:	8082                	ret

0000000080000364 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000364:	1141                	addi	sp,sp,-16
    80000366:	e422                	sd	s0,8(sp)
    80000368:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    8000036a:	02c05363          	blez	a2,80000390 <safestrcpy+0x2c>
    8000036e:	fff6069b          	addiw	a3,a2,-1
    80000372:	1682                	slli	a3,a3,0x20
    80000374:	9281                	srli	a3,a3,0x20
    80000376:	96ae                	add	a3,a3,a1
    80000378:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    8000037a:	00d58963          	beq	a1,a3,8000038c <safestrcpy+0x28>
    8000037e:	0585                	addi	a1,a1,1
    80000380:	0785                	addi	a5,a5,1
    80000382:	fff5c703          	lbu	a4,-1(a1)
    80000386:	fee78fa3          	sb	a4,-1(a5)
    8000038a:	fb65                	bnez	a4,8000037a <safestrcpy+0x16>
    ;
  *s = 0;
    8000038c:	00078023          	sb	zero,0(a5)
  return os;
}
    80000390:	6422                	ld	s0,8(sp)
    80000392:	0141                	addi	sp,sp,16
    80000394:	8082                	ret

0000000080000396 <strlen>:

int
strlen(const char *s)
{
    80000396:	1141                	addi	sp,sp,-16
    80000398:	e422                	sd	s0,8(sp)
    8000039a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    8000039c:	00054783          	lbu	a5,0(a0)
    800003a0:	cf91                	beqz	a5,800003bc <strlen+0x26>
    800003a2:	0505                	addi	a0,a0,1
    800003a4:	87aa                	mv	a5,a0
    800003a6:	4685                	li	a3,1
    800003a8:	9e89                	subw	a3,a3,a0
    800003aa:	00f6853b          	addw	a0,a3,a5
    800003ae:	0785                	addi	a5,a5,1
    800003b0:	fff7c703          	lbu	a4,-1(a5)
    800003b4:	fb7d                	bnez	a4,800003aa <strlen+0x14>
    ;
  return n;
}
    800003b6:	6422                	ld	s0,8(sp)
    800003b8:	0141                	addi	sp,sp,16
    800003ba:	8082                	ret
  for(n = 0; s[n]; n++)
    800003bc:	4501                	li	a0,0
    800003be:	bfe5                	j	800003b6 <strlen+0x20>

00000000800003c0 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    800003c0:	1141                	addi	sp,sp,-16
    800003c2:	e406                	sd	ra,8(sp)
    800003c4:	e022                	sd	s0,0(sp)
    800003c6:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    800003c8:	00001097          	auipc	ra,0x1
    800003cc:	b2e080e7          	jalr	-1234(ra) # 80000ef6 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    800003d0:	00009717          	auipc	a4,0x9
    800003d4:	c3070713          	addi	a4,a4,-976 # 80009000 <started>
  if(cpuid() == 0){
    800003d8:	c139                	beqz	a0,8000041e <main+0x5e>
    while(started == 0)
    800003da:	431c                	lw	a5,0(a4)
    800003dc:	2781                	sext.w	a5,a5
    800003de:	dff5                	beqz	a5,800003da <main+0x1a>
      ;
    __sync_synchronize();
    800003e0:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	b12080e7          	jalr	-1262(ra) # 80000ef6 <cpuid>
    800003ec:	85aa                	mv	a1,a0
    800003ee:	00008517          	auipc	a0,0x8
    800003f2:	c9a50513          	addi	a0,a0,-870 # 80008088 <etext+0x88>
    800003f6:	00006097          	auipc	ra,0x6
    800003fa:	96c080e7          	jalr	-1684(ra) # 80005d62 <printf>
    kvminithart();    // turn on paging
    800003fe:	00000097          	auipc	ra,0x0
    80000402:	0d8080e7          	jalr	216(ra) # 800004d6 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000406:	00001097          	auipc	ra,0x1
    8000040a:	768080e7          	jalr	1896(ra) # 80001b6e <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000040e:	00005097          	auipc	ra,0x5
    80000412:	de2080e7          	jalr	-542(ra) # 800051f0 <plicinithart>
  }

  scheduler();        
    80000416:	00001097          	auipc	ra,0x1
    8000041a:	016080e7          	jalr	22(ra) # 8000142c <scheduler>
    consoleinit();
    8000041e:	00006097          	auipc	ra,0x6
    80000422:	80c080e7          	jalr	-2036(ra) # 80005c2a <consoleinit>
    printfinit();
    80000426:	00006097          	auipc	ra,0x6
    8000042a:	b22080e7          	jalr	-1246(ra) # 80005f48 <printfinit>
    printf("\n");
    8000042e:	00008517          	auipc	a0,0x8
    80000432:	c6a50513          	addi	a0,a0,-918 # 80008098 <etext+0x98>
    80000436:	00006097          	auipc	ra,0x6
    8000043a:	92c080e7          	jalr	-1748(ra) # 80005d62 <printf>
    printf("xv6 kernel is booting\n");
    8000043e:	00008517          	auipc	a0,0x8
    80000442:	c3250513          	addi	a0,a0,-974 # 80008070 <etext+0x70>
    80000446:	00006097          	auipc	ra,0x6
    8000044a:	91c080e7          	jalr	-1764(ra) # 80005d62 <printf>
    printf("\n");
    8000044e:	00008517          	auipc	a0,0x8
    80000452:	c4a50513          	addi	a0,a0,-950 # 80008098 <etext+0x98>
    80000456:	00006097          	auipc	ra,0x6
    8000045a:	90c080e7          	jalr	-1780(ra) # 80005d62 <printf>
    kinit();         // physical page allocator
    8000045e:	00000097          	auipc	ra,0x0
    80000462:	ce2080e7          	jalr	-798(ra) # 80000140 <kinit>
    kvminit();       // create kernel page table
    80000466:	00000097          	auipc	ra,0x0
    8000046a:	322080e7          	jalr	802(ra) # 80000788 <kvminit>
    kvminithart();   // turn on paging
    8000046e:	00000097          	auipc	ra,0x0
    80000472:	068080e7          	jalr	104(ra) # 800004d6 <kvminithart>
    procinit();      // process table
    80000476:	00001097          	auipc	ra,0x1
    8000047a:	9d0080e7          	jalr	-1584(ra) # 80000e46 <procinit>
    trapinit();      // trap vectors
    8000047e:	00001097          	auipc	ra,0x1
    80000482:	6c8080e7          	jalr	1736(ra) # 80001b46 <trapinit>
    trapinithart();  // install kernel trap vector
    80000486:	00001097          	auipc	ra,0x1
    8000048a:	6e8080e7          	jalr	1768(ra) # 80001b6e <trapinithart>
    plicinit();      // set up interrupt controller
    8000048e:	00005097          	auipc	ra,0x5
    80000492:	d4c080e7          	jalr	-692(ra) # 800051da <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000496:	00005097          	auipc	ra,0x5
    8000049a:	d5a080e7          	jalr	-678(ra) # 800051f0 <plicinithart>
    binit();         // buffer cache
    8000049e:	00002097          	auipc	ra,0x2
    800004a2:	f3e080e7          	jalr	-194(ra) # 800023dc <binit>
    iinit();         // inode table
    800004a6:	00002097          	auipc	ra,0x2
    800004aa:	5ce080e7          	jalr	1486(ra) # 80002a74 <iinit>
    fileinit();      // file table
    800004ae:	00003097          	auipc	ra,0x3
    800004b2:	578080e7          	jalr	1400(ra) # 80003a26 <fileinit>
    virtio_disk_init(); // emulated hard disk
    800004b6:	00005097          	auipc	ra,0x5
    800004ba:	e5c080e7          	jalr	-420(ra) # 80005312 <virtio_disk_init>
    userinit();      // first user process
    800004be:	00001097          	auipc	ra,0x1
    800004c2:	d3c080e7          	jalr	-708(ra) # 800011fa <userinit>
    __sync_synchronize();
    800004c6:	0ff0000f          	fence
    started = 1;
    800004ca:	4785                	li	a5,1
    800004cc:	00009717          	auipc	a4,0x9
    800004d0:	b2f72a23          	sw	a5,-1228(a4) # 80009000 <started>
    800004d4:	b789                	j	80000416 <main+0x56>

00000000800004d6 <kvminithart>:
}

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void kvminithart()
{
    800004d6:	1141                	addi	sp,sp,-16
    800004d8:	e422                	sd	s0,8(sp)
    800004da:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    800004dc:	00009797          	auipc	a5,0x9
    800004e0:	b2c7b783          	ld	a5,-1236(a5) # 80009008 <kernel_pagetable>
    800004e4:	83b1                	srli	a5,a5,0xc
    800004e6:	577d                	li	a4,-1
    800004e8:	177e                	slli	a4,a4,0x3f
    800004ea:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r"(x));
    800004ec:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800004f0:	12000073          	sfence.vma
  sfence_vma();
}
    800004f4:	6422                	ld	s0,8(sp)
    800004f6:	0141                	addi	sp,sp,16
    800004f8:	8082                	ret

00000000800004fa <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800004fa:	7139                	addi	sp,sp,-64
    800004fc:	fc06                	sd	ra,56(sp)
    800004fe:	f822                	sd	s0,48(sp)
    80000500:	f426                	sd	s1,40(sp)
    80000502:	f04a                	sd	s2,32(sp)
    80000504:	ec4e                	sd	s3,24(sp)
    80000506:	e852                	sd	s4,16(sp)
    80000508:	e456                	sd	s5,8(sp)
    8000050a:	e05a                	sd	s6,0(sp)
    8000050c:	0080                	addi	s0,sp,64
    8000050e:	84aa                	mv	s1,a0
    80000510:	89ae                	mv	s3,a1
    80000512:	8ab2                	mv	s5,a2
  if (va >= MAXVA)
    80000514:	57fd                	li	a5,-1
    80000516:	83e9                	srli	a5,a5,0x1a
    80000518:	4a79                	li	s4,30
    panic("walk");

  for (int level = 2; level > 0; level--)
    8000051a:	4b31                	li	s6,12
  if (va >= MAXVA)
    8000051c:	04b7f263          	bgeu	a5,a1,80000560 <walk+0x66>
    panic("walk");
    80000520:	00008517          	auipc	a0,0x8
    80000524:	b8050513          	addi	a0,a0,-1152 # 800080a0 <etext+0xa0>
    80000528:	00005097          	auipc	ra,0x5
    8000052c:	7f0080e7          	jalr	2032(ra) # 80005d18 <panic>
    {
      pagetable = (pagetable_t)PTE2PA(*pte);
    }
    else
    {
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
    80000530:	060a8663          	beqz	s5,8000059c <walk+0xa2>
    80000534:	00000097          	auipc	ra,0x0
    80000538:	c48080e7          	jalr	-952(ra) # 8000017c <kalloc>
    8000053c:	84aa                	mv	s1,a0
    8000053e:	c529                	beqz	a0,80000588 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000540:	6605                	lui	a2,0x1
    80000542:	4581                	li	a1,0
    80000544:	00000097          	auipc	ra,0x0
    80000548:	cce080e7          	jalr	-818(ra) # 80000212 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    8000054c:	00c4d793          	srli	a5,s1,0xc
    80000550:	07aa                	slli	a5,a5,0xa
    80000552:	0017e793          	ori	a5,a5,1
    80000556:	00f93023          	sd	a5,0(s2)
  for (int level = 2; level > 0; level--)
    8000055a:	3a5d                	addiw	s4,s4,-9
    8000055c:	036a0063          	beq	s4,s6,8000057c <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000560:	0149d933          	srl	s2,s3,s4
    80000564:	1ff97913          	andi	s2,s2,511
    80000568:	090e                	slli	s2,s2,0x3
    8000056a:	9926                	add	s2,s2,s1
    if (*pte & PTE_V)
    8000056c:	00093483          	ld	s1,0(s2)
    80000570:	0014f793          	andi	a5,s1,1
    80000574:	dfd5                	beqz	a5,80000530 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000576:	80a9                	srli	s1,s1,0xa
    80000578:	04b2                	slli	s1,s1,0xc
    8000057a:	b7c5                	j	8000055a <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    8000057c:	00c9d513          	srli	a0,s3,0xc
    80000580:	1ff57513          	andi	a0,a0,511
    80000584:	050e                	slli	a0,a0,0x3
    80000586:	9526                	add	a0,a0,s1
}
    80000588:	70e2                	ld	ra,56(sp)
    8000058a:	7442                	ld	s0,48(sp)
    8000058c:	74a2                	ld	s1,40(sp)
    8000058e:	7902                	ld	s2,32(sp)
    80000590:	69e2                	ld	s3,24(sp)
    80000592:	6a42                	ld	s4,16(sp)
    80000594:	6aa2                	ld	s5,8(sp)
    80000596:	6b02                	ld	s6,0(sp)
    80000598:	6121                	addi	sp,sp,64
    8000059a:	8082                	ret
        return 0;
    8000059c:	4501                	li	a0,0
    8000059e:	b7ed                	j	80000588 <walk+0x8e>

00000000800005a0 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if (va >= MAXVA)
    800005a0:	57fd                	li	a5,-1
    800005a2:	83e9                	srli	a5,a5,0x1a
    800005a4:	00b7f463          	bgeu	a5,a1,800005ac <walkaddr+0xc>
    return 0;
    800005a8:	4501                	li	a0,0
    return 0;
  if ((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800005aa:	8082                	ret
{
    800005ac:	1141                	addi	sp,sp,-16
    800005ae:	e406                	sd	ra,8(sp)
    800005b0:	e022                	sd	s0,0(sp)
    800005b2:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800005b4:	4601                	li	a2,0
    800005b6:	00000097          	auipc	ra,0x0
    800005ba:	f44080e7          	jalr	-188(ra) # 800004fa <walk>
  if (pte == 0)
    800005be:	c105                	beqz	a0,800005de <walkaddr+0x3e>
  if ((*pte & PTE_V) == 0)
    800005c0:	611c                	ld	a5,0(a0)
  if ((*pte & PTE_U) == 0)
    800005c2:	0117f693          	andi	a3,a5,17
    800005c6:	4745                	li	a4,17
    return 0;
    800005c8:	4501                	li	a0,0
  if ((*pte & PTE_U) == 0)
    800005ca:	00e68663          	beq	a3,a4,800005d6 <walkaddr+0x36>
}
    800005ce:	60a2                	ld	ra,8(sp)
    800005d0:	6402                	ld	s0,0(sp)
    800005d2:	0141                	addi	sp,sp,16
    800005d4:	8082                	ret
  pa = PTE2PA(*pte);
    800005d6:	00a7d513          	srli	a0,a5,0xa
    800005da:	0532                	slli	a0,a0,0xc
  return pa;
    800005dc:	bfcd                	j	800005ce <walkaddr+0x2e>
    return 0;
    800005de:	4501                	li	a0,0
    800005e0:	b7fd                	j	800005ce <walkaddr+0x2e>

00000000800005e2 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800005e2:	715d                	addi	sp,sp,-80
    800005e4:	e486                	sd	ra,72(sp)
    800005e6:	e0a2                	sd	s0,64(sp)
    800005e8:	fc26                	sd	s1,56(sp)
    800005ea:	f84a                	sd	s2,48(sp)
    800005ec:	f44e                	sd	s3,40(sp)
    800005ee:	f052                	sd	s4,32(sp)
    800005f0:	ec56                	sd	s5,24(sp)
    800005f2:	e85a                	sd	s6,16(sp)
    800005f4:	e45e                	sd	s7,8(sp)
    800005f6:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if (size == 0)
    800005f8:	c205                	beqz	a2,80000618 <mappages+0x36>
    800005fa:	8aaa                	mv	s5,a0
    800005fc:	8b3a                	mv	s6,a4
    panic("mappages: size");

  a = PGROUNDDOWN(va);
    800005fe:	77fd                	lui	a5,0xfffff
    80000600:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    80000604:	15fd                	addi	a1,a1,-1
    80000606:	00c589b3          	add	s3,a1,a2
    8000060a:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    8000060e:	8952                	mv	s2,s4
    80000610:	41468a33          	sub	s4,a3,s4
    if (*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last)
      break;
    a += PGSIZE;
    80000614:	6b85                	lui	s7,0x1
    80000616:	a015                	j	8000063a <mappages+0x58>
    panic("mappages: size");
    80000618:	00008517          	auipc	a0,0x8
    8000061c:	a9050513          	addi	a0,a0,-1392 # 800080a8 <etext+0xa8>
    80000620:	00005097          	auipc	ra,0x5
    80000624:	6f8080e7          	jalr	1784(ra) # 80005d18 <panic>
      panic("mappages: remap");
    80000628:	00008517          	auipc	a0,0x8
    8000062c:	a9050513          	addi	a0,a0,-1392 # 800080b8 <etext+0xb8>
    80000630:	00005097          	auipc	ra,0x5
    80000634:	6e8080e7          	jalr	1768(ra) # 80005d18 <panic>
    a += PGSIZE;
    80000638:	995e                	add	s2,s2,s7
  for (;;)
    8000063a:	012a04b3          	add	s1,s4,s2
    if ((pte = walk(pagetable, a, 1)) == 0)
    8000063e:	4605                	li	a2,1
    80000640:	85ca                	mv	a1,s2
    80000642:	8556                	mv	a0,s5
    80000644:	00000097          	auipc	ra,0x0
    80000648:	eb6080e7          	jalr	-330(ra) # 800004fa <walk>
    8000064c:	cd19                	beqz	a0,8000066a <mappages+0x88>
    if (*pte & PTE_V)
    8000064e:	611c                	ld	a5,0(a0)
    80000650:	8b85                	andi	a5,a5,1
    80000652:	fbf9                	bnez	a5,80000628 <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000654:	80b1                	srli	s1,s1,0xc
    80000656:	04aa                	slli	s1,s1,0xa
    80000658:	0164e4b3          	or	s1,s1,s6
    8000065c:	0014e493          	ori	s1,s1,1
    80000660:	e104                	sd	s1,0(a0)
    if (a == last)
    80000662:	fd391be3          	bne	s2,s3,80000638 <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    80000666:	4501                	li	a0,0
    80000668:	a011                	j	8000066c <mappages+0x8a>
      return -1;
    8000066a:	557d                	li	a0,-1
}
    8000066c:	60a6                	ld	ra,72(sp)
    8000066e:	6406                	ld	s0,64(sp)
    80000670:	74e2                	ld	s1,56(sp)
    80000672:	7942                	ld	s2,48(sp)
    80000674:	79a2                	ld	s3,40(sp)
    80000676:	7a02                	ld	s4,32(sp)
    80000678:	6ae2                	ld	s5,24(sp)
    8000067a:	6b42                	ld	s6,16(sp)
    8000067c:	6ba2                	ld	s7,8(sp)
    8000067e:	6161                	addi	sp,sp,80
    80000680:	8082                	ret

0000000080000682 <kvmmap>:
{
    80000682:	1141                	addi	sp,sp,-16
    80000684:	e406                	sd	ra,8(sp)
    80000686:	e022                	sd	s0,0(sp)
    80000688:	0800                	addi	s0,sp,16
    8000068a:	87b6                	mv	a5,a3
  if (mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000068c:	86b2                	mv	a3,a2
    8000068e:	863e                	mv	a2,a5
    80000690:	00000097          	auipc	ra,0x0
    80000694:	f52080e7          	jalr	-174(ra) # 800005e2 <mappages>
    80000698:	e509                	bnez	a0,800006a2 <kvmmap+0x20>
}
    8000069a:	60a2                	ld	ra,8(sp)
    8000069c:	6402                	ld	s0,0(sp)
    8000069e:	0141                	addi	sp,sp,16
    800006a0:	8082                	ret
    panic("kvmmap");
    800006a2:	00008517          	auipc	a0,0x8
    800006a6:	a2650513          	addi	a0,a0,-1498 # 800080c8 <etext+0xc8>
    800006aa:	00005097          	auipc	ra,0x5
    800006ae:	66e080e7          	jalr	1646(ra) # 80005d18 <panic>

00000000800006b2 <kvmmake>:
{
    800006b2:	1101                	addi	sp,sp,-32
    800006b4:	ec06                	sd	ra,24(sp)
    800006b6:	e822                	sd	s0,16(sp)
    800006b8:	e426                	sd	s1,8(sp)
    800006ba:	e04a                	sd	s2,0(sp)
    800006bc:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t)kalloc();
    800006be:	00000097          	auipc	ra,0x0
    800006c2:	abe080e7          	jalr	-1346(ra) # 8000017c <kalloc>
    800006c6:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800006c8:	6605                	lui	a2,0x1
    800006ca:	4581                	li	a1,0
    800006cc:	00000097          	auipc	ra,0x0
    800006d0:	b46080e7          	jalr	-1210(ra) # 80000212 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800006d4:	4719                	li	a4,6
    800006d6:	6685                	lui	a3,0x1
    800006d8:	10000637          	lui	a2,0x10000
    800006dc:	100005b7          	lui	a1,0x10000
    800006e0:	8526                	mv	a0,s1
    800006e2:	00000097          	auipc	ra,0x0
    800006e6:	fa0080e7          	jalr	-96(ra) # 80000682 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800006ea:	4719                	li	a4,6
    800006ec:	6685                	lui	a3,0x1
    800006ee:	10001637          	lui	a2,0x10001
    800006f2:	100015b7          	lui	a1,0x10001
    800006f6:	8526                	mv	a0,s1
    800006f8:	00000097          	auipc	ra,0x0
    800006fc:	f8a080e7          	jalr	-118(ra) # 80000682 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000700:	4719                	li	a4,6
    80000702:	004006b7          	lui	a3,0x400
    80000706:	0c000637          	lui	a2,0xc000
    8000070a:	0c0005b7          	lui	a1,0xc000
    8000070e:	8526                	mv	a0,s1
    80000710:	00000097          	auipc	ra,0x0
    80000714:	f72080e7          	jalr	-142(ra) # 80000682 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    80000718:	00008917          	auipc	s2,0x8
    8000071c:	8e890913          	addi	s2,s2,-1816 # 80008000 <etext>
    80000720:	4729                	li	a4,10
    80000722:	80008697          	auipc	a3,0x80008
    80000726:	8de68693          	addi	a3,a3,-1826 # 8000 <_entry-0x7fff8000>
    8000072a:	4605                	li	a2,1
    8000072c:	067e                	slli	a2,a2,0x1f
    8000072e:	85b2                	mv	a1,a2
    80000730:	8526                	mv	a0,s1
    80000732:	00000097          	auipc	ra,0x0
    80000736:	f50080e7          	jalr	-176(ra) # 80000682 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext, PTE_R | PTE_W);
    8000073a:	4719                	li	a4,6
    8000073c:	46c5                	li	a3,17
    8000073e:	06ee                	slli	a3,a3,0x1b
    80000740:	412686b3          	sub	a3,a3,s2
    80000744:	864a                	mv	a2,s2
    80000746:	85ca                	mv	a1,s2
    80000748:	8526                	mv	a0,s1
    8000074a:	00000097          	auipc	ra,0x0
    8000074e:	f38080e7          	jalr	-200(ra) # 80000682 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000752:	4729                	li	a4,10
    80000754:	6685                	lui	a3,0x1
    80000756:	00007617          	auipc	a2,0x7
    8000075a:	8aa60613          	addi	a2,a2,-1878 # 80007000 <_trampoline>
    8000075e:	040005b7          	lui	a1,0x4000
    80000762:	15fd                	addi	a1,a1,-1
    80000764:	05b2                	slli	a1,a1,0xc
    80000766:	8526                	mv	a0,s1
    80000768:	00000097          	auipc	ra,0x0
    8000076c:	f1a080e7          	jalr	-230(ra) # 80000682 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000770:	8526                	mv	a0,s1
    80000772:	00000097          	auipc	ra,0x0
    80000776:	63e080e7          	jalr	1598(ra) # 80000db0 <proc_mapstacks>
}
    8000077a:	8526                	mv	a0,s1
    8000077c:	60e2                	ld	ra,24(sp)
    8000077e:	6442                	ld	s0,16(sp)
    80000780:	64a2                	ld	s1,8(sp)
    80000782:	6902                	ld	s2,0(sp)
    80000784:	6105                	addi	sp,sp,32
    80000786:	8082                	ret

0000000080000788 <kvminit>:
{
    80000788:	1141                	addi	sp,sp,-16
    8000078a:	e406                	sd	ra,8(sp)
    8000078c:	e022                	sd	s0,0(sp)
    8000078e:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000790:	00000097          	auipc	ra,0x0
    80000794:	f22080e7          	jalr	-222(ra) # 800006b2 <kvmmake>
    80000798:	00009797          	auipc	a5,0x9
    8000079c:	86a7b823          	sd	a0,-1936(a5) # 80009008 <kernel_pagetable>
}
    800007a0:	60a2                	ld	ra,8(sp)
    800007a2:	6402                	ld	s0,0(sp)
    800007a4:	0141                	addi	sp,sp,16
    800007a6:	8082                	ret

00000000800007a8 <uvmunmap>:

// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800007a8:	715d                	addi	sp,sp,-80
    800007aa:	e486                	sd	ra,72(sp)
    800007ac:	e0a2                	sd	s0,64(sp)
    800007ae:	fc26                	sd	s1,56(sp)
    800007b0:	f84a                	sd	s2,48(sp)
    800007b2:	f44e                	sd	s3,40(sp)
    800007b4:	f052                	sd	s4,32(sp)
    800007b6:	ec56                	sd	s5,24(sp)
    800007b8:	e85a                	sd	s6,16(sp)
    800007ba:	e45e                	sd	s7,8(sp)
    800007bc:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if ((va % PGSIZE) != 0)
    800007be:	03459793          	slli	a5,a1,0x34
    800007c2:	e795                	bnez	a5,800007ee <uvmunmap+0x46>
    800007c4:	8a2a                	mv	s4,a0
    800007c6:	892e                	mv	s2,a1
    800007c8:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    800007ca:	0632                	slli	a2,a2,0xc
    800007cc:	00b609b3          	add	s3,a2,a1
  {
    if ((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if ((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if (PTE_FLAGS(*pte) == PTE_V)
    800007d0:	4b85                	li	s7,1
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    800007d2:	6b05                	lui	s6,0x1
    800007d4:	0735e863          	bltu	a1,s3,80000844 <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void *)pa);
    }
    *pte = 0;
  }
}
    800007d8:	60a6                	ld	ra,72(sp)
    800007da:	6406                	ld	s0,64(sp)
    800007dc:	74e2                	ld	s1,56(sp)
    800007de:	7942                	ld	s2,48(sp)
    800007e0:	79a2                	ld	s3,40(sp)
    800007e2:	7a02                	ld	s4,32(sp)
    800007e4:	6ae2                	ld	s5,24(sp)
    800007e6:	6b42                	ld	s6,16(sp)
    800007e8:	6ba2                	ld	s7,8(sp)
    800007ea:	6161                	addi	sp,sp,80
    800007ec:	8082                	ret
    panic("uvmunmap: not aligned");
    800007ee:	00008517          	auipc	a0,0x8
    800007f2:	8e250513          	addi	a0,a0,-1822 # 800080d0 <etext+0xd0>
    800007f6:	00005097          	auipc	ra,0x5
    800007fa:	522080e7          	jalr	1314(ra) # 80005d18 <panic>
      panic("uvmunmap: walk");
    800007fe:	00008517          	auipc	a0,0x8
    80000802:	8ea50513          	addi	a0,a0,-1814 # 800080e8 <etext+0xe8>
    80000806:	00005097          	auipc	ra,0x5
    8000080a:	512080e7          	jalr	1298(ra) # 80005d18 <panic>
      panic("uvmunmap: not mapped");
    8000080e:	00008517          	auipc	a0,0x8
    80000812:	8ea50513          	addi	a0,a0,-1814 # 800080f8 <etext+0xf8>
    80000816:	00005097          	auipc	ra,0x5
    8000081a:	502080e7          	jalr	1282(ra) # 80005d18 <panic>
      panic("uvmunmap: not a leaf");
    8000081e:	00008517          	auipc	a0,0x8
    80000822:	8f250513          	addi	a0,a0,-1806 # 80008110 <etext+0x110>
    80000826:	00005097          	auipc	ra,0x5
    8000082a:	4f2080e7          	jalr	1266(ra) # 80005d18 <panic>
      uint64 pa = PTE2PA(*pte);
    8000082e:	8129                	srli	a0,a0,0xa
      kfree((void *)pa);
    80000830:	0532                	slli	a0,a0,0xc
    80000832:	fffff097          	auipc	ra,0xfffff
    80000836:	7ea080e7          	jalr	2026(ra) # 8000001c <kfree>
    *pte = 0;
    8000083a:	0004b023          	sd	zero,0(s1)
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    8000083e:	995a                	add	s2,s2,s6
    80000840:	f9397ce3          	bgeu	s2,s3,800007d8 <uvmunmap+0x30>
    if ((pte = walk(pagetable, a, 0)) == 0)
    80000844:	4601                	li	a2,0
    80000846:	85ca                	mv	a1,s2
    80000848:	8552                	mv	a0,s4
    8000084a:	00000097          	auipc	ra,0x0
    8000084e:	cb0080e7          	jalr	-848(ra) # 800004fa <walk>
    80000852:	84aa                	mv	s1,a0
    80000854:	d54d                	beqz	a0,800007fe <uvmunmap+0x56>
    if ((*pte & PTE_V) == 0)
    80000856:	6108                	ld	a0,0(a0)
    80000858:	00157793          	andi	a5,a0,1
    8000085c:	dbcd                	beqz	a5,8000080e <uvmunmap+0x66>
    if (PTE_FLAGS(*pte) == PTE_V)
    8000085e:	3ff57793          	andi	a5,a0,1023
    80000862:	fb778ee3          	beq	a5,s7,8000081e <uvmunmap+0x76>
    if (do_free)
    80000866:	fc0a8ae3          	beqz	s5,8000083a <uvmunmap+0x92>
    8000086a:	b7d1                	j	8000082e <uvmunmap+0x86>

000000008000086c <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000086c:	1101                	addi	sp,sp,-32
    8000086e:	ec06                	sd	ra,24(sp)
    80000870:	e822                	sd	s0,16(sp)
    80000872:	e426                	sd	s1,8(sp)
    80000874:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
    80000876:	00000097          	auipc	ra,0x0
    8000087a:	906080e7          	jalr	-1786(ra) # 8000017c <kalloc>
    8000087e:	84aa                	mv	s1,a0
  if (pagetable == 0)
    80000880:	c519                	beqz	a0,8000088e <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000882:	6605                	lui	a2,0x1
    80000884:	4581                	li	a1,0
    80000886:	00000097          	auipc	ra,0x0
    8000088a:	98c080e7          	jalr	-1652(ra) # 80000212 <memset>
  return pagetable;
}
    8000088e:	8526                	mv	a0,s1
    80000890:	60e2                	ld	ra,24(sp)
    80000892:	6442                	ld	s0,16(sp)
    80000894:	64a2                	ld	s1,8(sp)
    80000896:	6105                	addi	sp,sp,32
    80000898:	8082                	ret

000000008000089a <uvminit>:

// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    8000089a:	7179                	addi	sp,sp,-48
    8000089c:	f406                	sd	ra,40(sp)
    8000089e:	f022                	sd	s0,32(sp)
    800008a0:	ec26                	sd	s1,24(sp)
    800008a2:	e84a                	sd	s2,16(sp)
    800008a4:	e44e                	sd	s3,8(sp)
    800008a6:	e052                	sd	s4,0(sp)
    800008a8:	1800                	addi	s0,sp,48
  char *mem;

  if (sz >= PGSIZE)
    800008aa:	6785                	lui	a5,0x1
    800008ac:	04f67863          	bgeu	a2,a5,800008fc <uvminit+0x62>
    800008b0:	8a2a                	mv	s4,a0
    800008b2:	89ae                	mv	s3,a1
    800008b4:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    800008b6:	00000097          	auipc	ra,0x0
    800008ba:	8c6080e7          	jalr	-1850(ra) # 8000017c <kalloc>
    800008be:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800008c0:	6605                	lui	a2,0x1
    800008c2:	4581                	li	a1,0
    800008c4:	00000097          	auipc	ra,0x0
    800008c8:	94e080e7          	jalr	-1714(ra) # 80000212 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W | PTE_R | PTE_X | PTE_U);
    800008cc:	4779                	li	a4,30
    800008ce:	86ca                	mv	a3,s2
    800008d0:	6605                	lui	a2,0x1
    800008d2:	4581                	li	a1,0
    800008d4:	8552                	mv	a0,s4
    800008d6:	00000097          	auipc	ra,0x0
    800008da:	d0c080e7          	jalr	-756(ra) # 800005e2 <mappages>
  memmove(mem, src, sz);
    800008de:	8626                	mv	a2,s1
    800008e0:	85ce                	mv	a1,s3
    800008e2:	854a                	mv	a0,s2
    800008e4:	00000097          	auipc	ra,0x0
    800008e8:	98e080e7          	jalr	-1650(ra) # 80000272 <memmove>
}
    800008ec:	70a2                	ld	ra,40(sp)
    800008ee:	7402                	ld	s0,32(sp)
    800008f0:	64e2                	ld	s1,24(sp)
    800008f2:	6942                	ld	s2,16(sp)
    800008f4:	69a2                	ld	s3,8(sp)
    800008f6:	6a02                	ld	s4,0(sp)
    800008f8:	6145                	addi	sp,sp,48
    800008fa:	8082                	ret
    panic("inituvm: more than a page");
    800008fc:	00008517          	auipc	a0,0x8
    80000900:	82c50513          	addi	a0,a0,-2004 # 80008128 <etext+0x128>
    80000904:	00005097          	auipc	ra,0x5
    80000908:	414080e7          	jalr	1044(ra) # 80005d18 <panic>

000000008000090c <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000090c:	1101                	addi	sp,sp,-32
    8000090e:	ec06                	sd	ra,24(sp)
    80000910:	e822                	sd	s0,16(sp)
    80000912:	e426                	sd	s1,8(sp)
    80000914:	1000                	addi	s0,sp,32
  if (newsz >= oldsz)
    return oldsz;
    80000916:	84ae                	mv	s1,a1
  if (newsz >= oldsz)
    80000918:	00b67d63          	bgeu	a2,a1,80000932 <uvmdealloc+0x26>
    8000091c:	84b2                	mv	s1,a2

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz))
    8000091e:	6785                	lui	a5,0x1
    80000920:	17fd                	addi	a5,a5,-1
    80000922:	00f60733          	add	a4,a2,a5
    80000926:	767d                	lui	a2,0xfffff
    80000928:	8f71                	and	a4,a4,a2
    8000092a:	97ae                	add	a5,a5,a1
    8000092c:	8ff1                	and	a5,a5,a2
    8000092e:	00f76863          	bltu	a4,a5,8000093e <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000932:	8526                	mv	a0,s1
    80000934:	60e2                	ld	ra,24(sp)
    80000936:	6442                	ld	s0,16(sp)
    80000938:	64a2                	ld	s1,8(sp)
    8000093a:	6105                	addi	sp,sp,32
    8000093c:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000093e:	8f99                	sub	a5,a5,a4
    80000940:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000942:	4685                	li	a3,1
    80000944:	0007861b          	sext.w	a2,a5
    80000948:	85ba                	mv	a1,a4
    8000094a:	00000097          	auipc	ra,0x0
    8000094e:	e5e080e7          	jalr	-418(ra) # 800007a8 <uvmunmap>
    80000952:	b7c5                	j	80000932 <uvmdealloc+0x26>

0000000080000954 <uvmalloc>:
  if (newsz < oldsz)
    80000954:	0ab66163          	bltu	a2,a1,800009f6 <uvmalloc+0xa2>
{
    80000958:	7139                	addi	sp,sp,-64
    8000095a:	fc06                	sd	ra,56(sp)
    8000095c:	f822                	sd	s0,48(sp)
    8000095e:	f426                	sd	s1,40(sp)
    80000960:	f04a                	sd	s2,32(sp)
    80000962:	ec4e                	sd	s3,24(sp)
    80000964:	e852                	sd	s4,16(sp)
    80000966:	e456                	sd	s5,8(sp)
    80000968:	0080                	addi	s0,sp,64
    8000096a:	8aaa                	mv	s5,a0
    8000096c:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000096e:	6985                	lui	s3,0x1
    80000970:	19fd                	addi	s3,s3,-1
    80000972:	95ce                	add	a1,a1,s3
    80000974:	79fd                	lui	s3,0xfffff
    80000976:	0135f9b3          	and	s3,a1,s3
  for (a = oldsz; a < newsz; a += PGSIZE)
    8000097a:	08c9f063          	bgeu	s3,a2,800009fa <uvmalloc+0xa6>
    8000097e:	894e                	mv	s2,s3
    mem = kalloc();
    80000980:	fffff097          	auipc	ra,0xfffff
    80000984:	7fc080e7          	jalr	2044(ra) # 8000017c <kalloc>
    80000988:	84aa                	mv	s1,a0
    if (mem == 0)
    8000098a:	c51d                	beqz	a0,800009b8 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    8000098c:	6605                	lui	a2,0x1
    8000098e:	4581                	li	a1,0
    80000990:	00000097          	auipc	ra,0x0
    80000994:	882080e7          	jalr	-1918(ra) # 80000212 <memset>
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W | PTE_X | PTE_R | PTE_U) != 0)
    80000998:	4779                	li	a4,30
    8000099a:	86a6                	mv	a3,s1
    8000099c:	6605                	lui	a2,0x1
    8000099e:	85ca                	mv	a1,s2
    800009a0:	8556                	mv	a0,s5
    800009a2:	00000097          	auipc	ra,0x0
    800009a6:	c40080e7          	jalr	-960(ra) # 800005e2 <mappages>
    800009aa:	e905                	bnez	a0,800009da <uvmalloc+0x86>
  for (a = oldsz; a < newsz; a += PGSIZE)
    800009ac:	6785                	lui	a5,0x1
    800009ae:	993e                	add	s2,s2,a5
    800009b0:	fd4968e3          	bltu	s2,s4,80000980 <uvmalloc+0x2c>
  return newsz;
    800009b4:	8552                	mv	a0,s4
    800009b6:	a809                	j	800009c8 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    800009b8:	864e                	mv	a2,s3
    800009ba:	85ca                	mv	a1,s2
    800009bc:	8556                	mv	a0,s5
    800009be:	00000097          	auipc	ra,0x0
    800009c2:	f4e080e7          	jalr	-178(ra) # 8000090c <uvmdealloc>
      return 0;
    800009c6:	4501                	li	a0,0
}
    800009c8:	70e2                	ld	ra,56(sp)
    800009ca:	7442                	ld	s0,48(sp)
    800009cc:	74a2                	ld	s1,40(sp)
    800009ce:	7902                	ld	s2,32(sp)
    800009d0:	69e2                	ld	s3,24(sp)
    800009d2:	6a42                	ld	s4,16(sp)
    800009d4:	6aa2                	ld	s5,8(sp)
    800009d6:	6121                	addi	sp,sp,64
    800009d8:	8082                	ret
      kfree(mem);
    800009da:	8526                	mv	a0,s1
    800009dc:	fffff097          	auipc	ra,0xfffff
    800009e0:	640080e7          	jalr	1600(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800009e4:	864e                	mv	a2,s3
    800009e6:	85ca                	mv	a1,s2
    800009e8:	8556                	mv	a0,s5
    800009ea:	00000097          	auipc	ra,0x0
    800009ee:	f22080e7          	jalr	-222(ra) # 8000090c <uvmdealloc>
      return 0;
    800009f2:	4501                	li	a0,0
    800009f4:	bfd1                	j	800009c8 <uvmalloc+0x74>
    return oldsz;
    800009f6:	852e                	mv	a0,a1
}
    800009f8:	8082                	ret
  return newsz;
    800009fa:	8532                	mv	a0,a2
    800009fc:	b7f1                	j	800009c8 <uvmalloc+0x74>

00000000800009fe <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void freewalk(pagetable_t pagetable)
{
    800009fe:	7179                	addi	sp,sp,-48
    80000a00:	f406                	sd	ra,40(sp)
    80000a02:	f022                	sd	s0,32(sp)
    80000a04:	ec26                	sd	s1,24(sp)
    80000a06:	e84a                	sd	s2,16(sp)
    80000a08:	e44e                	sd	s3,8(sp)
    80000a0a:	e052                	sd	s4,0(sp)
    80000a0c:	1800                	addi	s0,sp,48
    80000a0e:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++)
    80000a10:	84aa                	mv	s1,a0
    80000a12:	6905                	lui	s2,0x1
    80000a14:	992a                	add	s2,s2,a0
  {
    pte_t pte = pagetable[i];
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0)
    80000a16:	4985                	li	s3,1
    80000a18:	a821                	j	80000a30 <freewalk+0x32>
    {
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000a1a:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000a1c:	0532                	slli	a0,a0,0xc
    80000a1e:	00000097          	auipc	ra,0x0
    80000a22:	fe0080e7          	jalr	-32(ra) # 800009fe <freewalk>
      pagetable[i] = 0;
    80000a26:	0004b023          	sd	zero,0(s1)
  for (int i = 0; i < 512; i++)
    80000a2a:	04a1                	addi	s1,s1,8
    80000a2c:	03248163          	beq	s1,s2,80000a4e <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000a30:	6088                	ld	a0,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0)
    80000a32:	00f57793          	andi	a5,a0,15
    80000a36:	ff3782e3          	beq	a5,s3,80000a1a <freewalk+0x1c>
    }
    else if (pte & PTE_V)
    80000a3a:	8905                	andi	a0,a0,1
    80000a3c:	d57d                	beqz	a0,80000a2a <freewalk+0x2c>
    {
      panic("freewalk: leaf");
    80000a3e:	00007517          	auipc	a0,0x7
    80000a42:	70a50513          	addi	a0,a0,1802 # 80008148 <etext+0x148>
    80000a46:	00005097          	auipc	ra,0x5
    80000a4a:	2d2080e7          	jalr	722(ra) # 80005d18 <panic>
    }
  }
  kfree((void *)pagetable);
    80000a4e:	8552                	mv	a0,s4
    80000a50:	fffff097          	auipc	ra,0xfffff
    80000a54:	5cc080e7          	jalr	1484(ra) # 8000001c <kfree>
}
    80000a58:	70a2                	ld	ra,40(sp)
    80000a5a:	7402                	ld	s0,32(sp)
    80000a5c:	64e2                	ld	s1,24(sp)
    80000a5e:	6942                	ld	s2,16(sp)
    80000a60:	69a2                	ld	s3,8(sp)
    80000a62:	6a02                	ld	s4,0(sp)
    80000a64:	6145                	addi	sp,sp,48
    80000a66:	8082                	ret

0000000080000a68 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a68:	1101                	addi	sp,sp,-32
    80000a6a:	ec06                	sd	ra,24(sp)
    80000a6c:	e822                	sd	s0,16(sp)
    80000a6e:	e426                	sd	s1,8(sp)
    80000a70:	1000                	addi	s0,sp,32
    80000a72:	84aa                	mv	s1,a0
  if (sz > 0)
    80000a74:	e999                	bnez	a1,80000a8a <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
  freewalk(pagetable);
    80000a76:	8526                	mv	a0,s1
    80000a78:	00000097          	auipc	ra,0x0
    80000a7c:	f86080e7          	jalr	-122(ra) # 800009fe <freewalk>
}
    80000a80:	60e2                	ld	ra,24(sp)
    80000a82:	6442                	ld	s0,16(sp)
    80000a84:	64a2                	ld	s1,8(sp)
    80000a86:	6105                	addi	sp,sp,32
    80000a88:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    80000a8a:	6605                	lui	a2,0x1
    80000a8c:	167d                	addi	a2,a2,-1
    80000a8e:	962e                	add	a2,a2,a1
    80000a90:	4685                	li	a3,1
    80000a92:	8231                	srli	a2,a2,0xc
    80000a94:	4581                	li	a1,0
    80000a96:	00000097          	auipc	ra,0x0
    80000a9a:	d12080e7          	jalr	-750(ra) # 800007a8 <uvmunmap>
    80000a9e:	bfe1                	j	80000a76 <uvmfree+0xe>

0000000080000aa0 <uvmcopy>:
// Copies both the page table and the
// physical memory.
// returns 0 on success, -1 on failure.
// frees any allocated pages on failure.
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
{
    80000aa0:	7119                	addi	sp,sp,-128
    80000aa2:	fc86                	sd	ra,120(sp)
    80000aa4:	f8a2                	sd	s0,112(sp)
    80000aa6:	f4a6                	sd	s1,104(sp)
    80000aa8:	f0ca                	sd	s2,96(sp)
    80000aaa:	ecce                	sd	s3,88(sp)
    80000aac:	e8d2                	sd	s4,80(sp)
    80000aae:	e4d6                	sd	s5,72(sp)
    80000ab0:	e0da                	sd	s6,64(sp)
    80000ab2:	fc5e                	sd	s7,56(sp)
    80000ab4:	f862                	sd	s8,48(sp)
    80000ab6:	f466                	sd	s9,40(sp)
    80000ab8:	f06a                	sd	s10,32(sp)
    80000aba:	ec6e                	sd	s11,24(sp)
    80000abc:	0100                	addi	s0,sp,128
    80000abe:	f8a43423          	sd	a0,-120(s0)
  uint flags;
  // struct proc *p = myproc();
  // uint64 va = r_stval(); // get page fault address
  // char *mem;

  for (i = 0; i < sz; i += PGSIZE)
    80000ac2:	c675                	beqz	a2,80000bae <uvmcopy+0x10e>
    80000ac4:	8bae                	mv	s7,a1
    80000ac6:	8b32                	mv	s6,a2
    80000ac8:	4a81                	li	s5,0
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    flags = flags & ~PTE_W;
    flags = flags | PTE_COW;

    int index = REFCOUNT_INDEX(pa);
    80000aca:	80000d37          	lui	s10,0x80000
    if (index >= 0 && index < REFCOUNT_SIZE)
    80000ace:	6ca1                	lui	s9,0x8
    {
      ref_count[index]++;
    80000ad0:	00008d97          	auipc	s11,0x8
    80000ad4:	580d8d93          	addi	s11,s11,1408 # 80009050 <ref_count>
    if (mappages(new, i, PGSIZE, pa, flags) != 0)
    {
      ref_count[index]--;
      goto err;
    }
    *pte = PA2PTE(pa) | flags; // updated for father's pte
    80000ad8:	7c7d                	lui	s8,0xfffff
    80000ada:	002c5c13          	srli	s8,s8,0x2
    if ((pte = walk(old, i, 0)) == 0)
    80000ade:	4601                	li	a2,0
    80000ae0:	85d6                	mv	a1,s5
    80000ae2:	f8843503          	ld	a0,-120(s0)
    80000ae6:	00000097          	auipc	ra,0x0
    80000aea:	a14080e7          	jalr	-1516(ra) # 800004fa <walk>
    80000aee:	8a2a                	mv	s4,a0
    80000af0:	cd29                	beqz	a0,80000b4a <uvmcopy+0xaa>
    if ((*pte & PTE_V) == 0)
    80000af2:	00053903          	ld	s2,0(a0)
    80000af6:	00197793          	andi	a5,s2,1
    80000afa:	c3a5                	beqz	a5,80000b5a <uvmcopy+0xba>
    pa = PTE2PA(*pte);
    80000afc:	00a95693          	srli	a3,s2,0xa
    80000b00:	06b2                	slli	a3,a3,0xc
    flags = flags & ~PTE_W;
    80000b02:	3fb97993          	andi	s3,s2,1019
    flags = flags | PTE_COW;
    80000b06:	1009e993          	ori	s3,s3,256
    int index = REFCOUNT_INDEX(pa);
    80000b0a:	01a684b3          	add	s1,a3,s10
    80000b0e:	80b1                	srli	s1,s1,0xc
    80000b10:	2481                	sext.w	s1,s1
    if (index >= 0 && index < REFCOUNT_SIZE)
    80000b12:	0794f563          	bgeu	s1,s9,80000b7c <uvmcopy+0xdc>
      ref_count[index]++;
    80000b16:	00249793          	slli	a5,s1,0x2
    80000b1a:	97ee                	add	a5,a5,s11
    80000b1c:	4398                	lw	a4,0(a5)
    80000b1e:	2705                	addiw	a4,a4,1
    80000b20:	c398                	sw	a4,0(a5)
    if (mappages(new, i, PGSIZE, pa, flags) != 0)
    80000b22:	874e                	mv	a4,s3
    80000b24:	6605                	lui	a2,0x1
    80000b26:	85d6                	mv	a1,s5
    80000b28:	855e                	mv	a0,s7
    80000b2a:	00000097          	auipc	ra,0x0
    80000b2e:	ab8080e7          	jalr	-1352(ra) # 800005e2 <mappages>
    80000b32:	ed05                	bnez	a0,80000b6a <uvmcopy+0xca>
    *pte = PA2PTE(pa) | flags; // updated for father's pte
    80000b34:	01897933          	and	s2,s2,s8
    80000b38:	0129e933          	or	s2,s3,s2
    80000b3c:	012a3023          	sd	s2,0(s4) # fffffffffffff000 <end+0xffffffff7ffb8dc0>
  for (i = 0; i < sz; i += PGSIZE)
    80000b40:	6785                	lui	a5,0x1
    80000b42:	9abe                	add	s5,s5,a5
    80000b44:	f96aede3          	bltu	s5,s6,80000ade <uvmcopy+0x3e>
    80000b48:	a0a1                	j	80000b90 <uvmcopy+0xf0>
      panic("uvmcopy: pte should exist");
    80000b4a:	00007517          	auipc	a0,0x7
    80000b4e:	60e50513          	addi	a0,a0,1550 # 80008158 <etext+0x158>
    80000b52:	00005097          	auipc	ra,0x5
    80000b56:	1c6080e7          	jalr	454(ra) # 80005d18 <panic>
      panic("uvmcopy: page not present");
    80000b5a:	00007517          	auipc	a0,0x7
    80000b5e:	61e50513          	addi	a0,a0,1566 # 80008178 <etext+0x178>
    80000b62:	00005097          	auipc	ra,0x5
    80000b66:	1b6080e7          	jalr	438(ra) # 80005d18 <panic>
      ref_count[index]--;
    80000b6a:	048a                	slli	s1,s1,0x2
    80000b6c:	00008797          	auipc	a5,0x8
    80000b70:	4e478793          	addi	a5,a5,1252 # 80009050 <ref_count>
    80000b74:	94be                	add	s1,s1,a5
    80000b76:	409c                	lw	a5,0(s1)
    80000b78:	37fd                	addiw	a5,a5,-1
    80000b7a:	c09c                	sw	a5,0(s1)
  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000b7c:	4685                	li	a3,1
    80000b7e:	00cad613          	srli	a2,s5,0xc
    80000b82:	4581                	li	a1,0
    80000b84:	855e                	mv	a0,s7
    80000b86:	00000097          	auipc	ra,0x0
    80000b8a:	c22080e7          	jalr	-990(ra) # 800007a8 <uvmunmap>
  return -1;
    80000b8e:	557d                	li	a0,-1
}
    80000b90:	70e6                	ld	ra,120(sp)
    80000b92:	7446                	ld	s0,112(sp)
    80000b94:	74a6                	ld	s1,104(sp)
    80000b96:	7906                	ld	s2,96(sp)
    80000b98:	69e6                	ld	s3,88(sp)
    80000b9a:	6a46                	ld	s4,80(sp)
    80000b9c:	6aa6                	ld	s5,72(sp)
    80000b9e:	6b06                	ld	s6,64(sp)
    80000ba0:	7be2                	ld	s7,56(sp)
    80000ba2:	7c42                	ld	s8,48(sp)
    80000ba4:	7ca2                	ld	s9,40(sp)
    80000ba6:	7d02                	ld	s10,32(sp)
    80000ba8:	6de2                	ld	s11,24(sp)
    80000baa:	6109                	addi	sp,sp,128
    80000bac:	8082                	ret
  return 0;
    80000bae:	4501                	li	a0,0
    80000bb0:	b7c5                	j	80000b90 <uvmcopy+0xf0>

0000000080000bb2 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void uvmclear(pagetable_t pagetable, uint64 va)
{
    80000bb2:	1141                	addi	sp,sp,-16
    80000bb4:	e406                	sd	ra,8(sp)
    80000bb6:	e022                	sd	s0,0(sp)
    80000bb8:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    80000bba:	4601                	li	a2,0
    80000bbc:	00000097          	auipc	ra,0x0
    80000bc0:	93e080e7          	jalr	-1730(ra) # 800004fa <walk>
  if (pte == 0)
    80000bc4:	c901                	beqz	a0,80000bd4 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000bc6:	611c                	ld	a5,0(a0)
    80000bc8:	9bbd                	andi	a5,a5,-17
    80000bca:	e11c                	sd	a5,0(a0)
}
    80000bcc:	60a2                	ld	ra,8(sp)
    80000bce:	6402                	ld	s0,0(sp)
    80000bd0:	0141                	addi	sp,sp,16
    80000bd2:	8082                	ret
    panic("uvmclear");
    80000bd4:	00007517          	auipc	a0,0x7
    80000bd8:	5c450513          	addi	a0,a0,1476 # 80008198 <etext+0x198>
    80000bdc:	00005097          	auipc	ra,0x5
    80000be0:	13c080e7          	jalr	316(ra) # 80005d18 <panic>

0000000080000be4 <copyout>:
// Return 0 on success, -1 on error.
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while (len > 0)
    80000be4:	c6bd                	beqz	a3,80000c52 <copyout+0x6e>
{
    80000be6:	715d                	addi	sp,sp,-80
    80000be8:	e486                	sd	ra,72(sp)
    80000bea:	e0a2                	sd	s0,64(sp)
    80000bec:	fc26                	sd	s1,56(sp)
    80000bee:	f84a                	sd	s2,48(sp)
    80000bf0:	f44e                	sd	s3,40(sp)
    80000bf2:	f052                	sd	s4,32(sp)
    80000bf4:	ec56                	sd	s5,24(sp)
    80000bf6:	e85a                	sd	s6,16(sp)
    80000bf8:	e45e                	sd	s7,8(sp)
    80000bfa:	e062                	sd	s8,0(sp)
    80000bfc:	0880                	addi	s0,sp,80
    80000bfe:	8b2a                	mv	s6,a0
    80000c00:	8c2e                	mv	s8,a1
    80000c02:	8a32                	mv	s4,a2
    80000c04:	89b6                	mv	s3,a3
  {
    va0 = PGROUNDDOWN(dstva);
    80000c06:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000c08:	6a85                	lui	s5,0x1
    80000c0a:	a015                	j	80000c2e <copyout+0x4a>
    if (n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000c0c:	9562                	add	a0,a0,s8
    80000c0e:	0004861b          	sext.w	a2,s1
    80000c12:	85d2                	mv	a1,s4
    80000c14:	41250533          	sub	a0,a0,s2
    80000c18:	fffff097          	auipc	ra,0xfffff
    80000c1c:	65a080e7          	jalr	1626(ra) # 80000272 <memmove>

    len -= n;
    80000c20:	409989b3          	sub	s3,s3,s1
    src += n;
    80000c24:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000c26:	01590c33          	add	s8,s2,s5
  while (len > 0)
    80000c2a:	02098263          	beqz	s3,80000c4e <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000c2e:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c32:	85ca                	mv	a1,s2
    80000c34:	855a                	mv	a0,s6
    80000c36:	00000097          	auipc	ra,0x0
    80000c3a:	96a080e7          	jalr	-1686(ra) # 800005a0 <walkaddr>
    if (pa0 == 0)
    80000c3e:	cd01                	beqz	a0,80000c56 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000c40:	418904b3          	sub	s1,s2,s8
    80000c44:	94d6                	add	s1,s1,s5
    if (n > len)
    80000c46:	fc99f3e3          	bgeu	s3,s1,80000c0c <copyout+0x28>
    80000c4a:	84ce                	mv	s1,s3
    80000c4c:	b7c1                	j	80000c0c <copyout+0x28>
  }
  return 0;
    80000c4e:	4501                	li	a0,0
    80000c50:	a021                	j	80000c58 <copyout+0x74>
    80000c52:	4501                	li	a0,0
}
    80000c54:	8082                	ret
      return -1;
    80000c56:	557d                	li	a0,-1
}
    80000c58:	60a6                	ld	ra,72(sp)
    80000c5a:	6406                	ld	s0,64(sp)
    80000c5c:	74e2                	ld	s1,56(sp)
    80000c5e:	7942                	ld	s2,48(sp)
    80000c60:	79a2                	ld	s3,40(sp)
    80000c62:	7a02                	ld	s4,32(sp)
    80000c64:	6ae2                	ld	s5,24(sp)
    80000c66:	6b42                	ld	s6,16(sp)
    80000c68:	6ba2                	ld	s7,8(sp)
    80000c6a:	6c02                	ld	s8,0(sp)
    80000c6c:	6161                	addi	sp,sp,80
    80000c6e:	8082                	ret

0000000080000c70 <copyin>:
// Return 0 on success, -1 on error.
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while (len > 0)
    80000c70:	c6bd                	beqz	a3,80000cde <copyin+0x6e>
{
    80000c72:	715d                	addi	sp,sp,-80
    80000c74:	e486                	sd	ra,72(sp)
    80000c76:	e0a2                	sd	s0,64(sp)
    80000c78:	fc26                	sd	s1,56(sp)
    80000c7a:	f84a                	sd	s2,48(sp)
    80000c7c:	f44e                	sd	s3,40(sp)
    80000c7e:	f052                	sd	s4,32(sp)
    80000c80:	ec56                	sd	s5,24(sp)
    80000c82:	e85a                	sd	s6,16(sp)
    80000c84:	e45e                	sd	s7,8(sp)
    80000c86:	e062                	sd	s8,0(sp)
    80000c88:	0880                	addi	s0,sp,80
    80000c8a:	8b2a                	mv	s6,a0
    80000c8c:	8a2e                	mv	s4,a1
    80000c8e:	8c32                	mv	s8,a2
    80000c90:	89b6                	mv	s3,a3
  {
    va0 = PGROUNDDOWN(srcva);
    80000c92:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c94:	6a85                	lui	s5,0x1
    80000c96:	a015                	j	80000cba <copyin+0x4a>
    if (n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c98:	9562                	add	a0,a0,s8
    80000c9a:	0004861b          	sext.w	a2,s1
    80000c9e:	412505b3          	sub	a1,a0,s2
    80000ca2:	8552                	mv	a0,s4
    80000ca4:	fffff097          	auipc	ra,0xfffff
    80000ca8:	5ce080e7          	jalr	1486(ra) # 80000272 <memmove>

    len -= n;
    80000cac:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000cb0:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000cb2:	01590c33          	add	s8,s2,s5
  while (len > 0)
    80000cb6:	02098263          	beqz	s3,80000cda <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000cba:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000cbe:	85ca                	mv	a1,s2
    80000cc0:	855a                	mv	a0,s6
    80000cc2:	00000097          	auipc	ra,0x0
    80000cc6:	8de080e7          	jalr	-1826(ra) # 800005a0 <walkaddr>
    if (pa0 == 0)
    80000cca:	cd01                	beqz	a0,80000ce2 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000ccc:	418904b3          	sub	s1,s2,s8
    80000cd0:	94d6                	add	s1,s1,s5
    if (n > len)
    80000cd2:	fc99f3e3          	bgeu	s3,s1,80000c98 <copyin+0x28>
    80000cd6:	84ce                	mv	s1,s3
    80000cd8:	b7c1                	j	80000c98 <copyin+0x28>
  }
  return 0;
    80000cda:	4501                	li	a0,0
    80000cdc:	a021                	j	80000ce4 <copyin+0x74>
    80000cde:	4501                	li	a0,0
}
    80000ce0:	8082                	ret
      return -1;
    80000ce2:	557d                	li	a0,-1
}
    80000ce4:	60a6                	ld	ra,72(sp)
    80000ce6:	6406                	ld	s0,64(sp)
    80000ce8:	74e2                	ld	s1,56(sp)
    80000cea:	7942                	ld	s2,48(sp)
    80000cec:	79a2                	ld	s3,40(sp)
    80000cee:	7a02                	ld	s4,32(sp)
    80000cf0:	6ae2                	ld	s5,24(sp)
    80000cf2:	6b42                	ld	s6,16(sp)
    80000cf4:	6ba2                	ld	s7,8(sp)
    80000cf6:	6c02                	ld	s8,0(sp)
    80000cf8:	6161                	addi	sp,sp,80
    80000cfa:	8082                	ret

0000000080000cfc <copyinstr>:
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while (got_null == 0 && max > 0)
    80000cfc:	c6c5                	beqz	a3,80000da4 <copyinstr+0xa8>
{
    80000cfe:	715d                	addi	sp,sp,-80
    80000d00:	e486                	sd	ra,72(sp)
    80000d02:	e0a2                	sd	s0,64(sp)
    80000d04:	fc26                	sd	s1,56(sp)
    80000d06:	f84a                	sd	s2,48(sp)
    80000d08:	f44e                	sd	s3,40(sp)
    80000d0a:	f052                	sd	s4,32(sp)
    80000d0c:	ec56                	sd	s5,24(sp)
    80000d0e:	e85a                	sd	s6,16(sp)
    80000d10:	e45e                	sd	s7,8(sp)
    80000d12:	0880                	addi	s0,sp,80
    80000d14:	8a2a                	mv	s4,a0
    80000d16:	8b2e                	mv	s6,a1
    80000d18:	8bb2                	mv	s7,a2
    80000d1a:	84b6                	mv	s1,a3
  {
    va0 = PGROUNDDOWN(srcva);
    80000d1c:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000d1e:	6985                	lui	s3,0x1
    80000d20:	a035                	j	80000d4c <copyinstr+0x50>
    char *p = (char *)(pa0 + (srcva - va0));
    while (n > 0)
    {
      if (*p == '\0')
      {
        *dst = '\0';
    80000d22:	00078023          	sb	zero,0(a5)
    80000d26:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if (got_null)
    80000d28:	0017b793          	seqz	a5,a5
    80000d2c:	40f00533          	neg	a0,a5
  }
  else
  {
    return -1;
  }
}
    80000d30:	60a6                	ld	ra,72(sp)
    80000d32:	6406                	ld	s0,64(sp)
    80000d34:	74e2                	ld	s1,56(sp)
    80000d36:	7942                	ld	s2,48(sp)
    80000d38:	79a2                	ld	s3,40(sp)
    80000d3a:	7a02                	ld	s4,32(sp)
    80000d3c:	6ae2                	ld	s5,24(sp)
    80000d3e:	6b42                	ld	s6,16(sp)
    80000d40:	6ba2                	ld	s7,8(sp)
    80000d42:	6161                	addi	sp,sp,80
    80000d44:	8082                	ret
    srcva = va0 + PGSIZE;
    80000d46:	01390bb3          	add	s7,s2,s3
  while (got_null == 0 && max > 0)
    80000d4a:	c8a9                	beqz	s1,80000d9c <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000d4c:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000d50:	85ca                	mv	a1,s2
    80000d52:	8552                	mv	a0,s4
    80000d54:	00000097          	auipc	ra,0x0
    80000d58:	84c080e7          	jalr	-1972(ra) # 800005a0 <walkaddr>
    if (pa0 == 0)
    80000d5c:	c131                	beqz	a0,80000da0 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000d5e:	41790833          	sub	a6,s2,s7
    80000d62:	984e                	add	a6,a6,s3
    if (n > max)
    80000d64:	0104f363          	bgeu	s1,a6,80000d6a <copyinstr+0x6e>
    80000d68:	8826                	mv	a6,s1
    char *p = (char *)(pa0 + (srcva - va0));
    80000d6a:	955e                	add	a0,a0,s7
    80000d6c:	41250533          	sub	a0,a0,s2
    while (n > 0)
    80000d70:	fc080be3          	beqz	a6,80000d46 <copyinstr+0x4a>
    80000d74:	985a                	add	a6,a6,s6
    80000d76:	87da                	mv	a5,s6
      if (*p == '\0')
    80000d78:	41650633          	sub	a2,a0,s6
    80000d7c:	14fd                	addi	s1,s1,-1
    80000d7e:	9b26                	add	s6,s6,s1
    80000d80:	00f60733          	add	a4,a2,a5
    80000d84:	00074703          	lbu	a4,0(a4)
    80000d88:	df49                	beqz	a4,80000d22 <copyinstr+0x26>
        *dst = *p;
    80000d8a:	00e78023          	sb	a4,0(a5)
      --max;
    80000d8e:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000d92:	0785                	addi	a5,a5,1
    while (n > 0)
    80000d94:	ff0796e3          	bne	a5,a6,80000d80 <copyinstr+0x84>
      dst++;
    80000d98:	8b42                	mv	s6,a6
    80000d9a:	b775                	j	80000d46 <copyinstr+0x4a>
    80000d9c:	4781                	li	a5,0
    80000d9e:	b769                	j	80000d28 <copyinstr+0x2c>
      return -1;
    80000da0:	557d                	li	a0,-1
    80000da2:	b779                	j	80000d30 <copyinstr+0x34>
  int got_null = 0;
    80000da4:	4781                	li	a5,0
  if (got_null)
    80000da6:	0017b793          	seqz	a5,a5
    80000daa:	40f00533          	neg	a0,a5
}
    80000dae:	8082                	ret

0000000080000db0 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000db0:	7139                	addi	sp,sp,-64
    80000db2:	fc06                	sd	ra,56(sp)
    80000db4:	f822                	sd	s0,48(sp)
    80000db6:	f426                	sd	s1,40(sp)
    80000db8:	f04a                	sd	s2,32(sp)
    80000dba:	ec4e                	sd	s3,24(sp)
    80000dbc:	e852                	sd	s4,16(sp)
    80000dbe:	e456                	sd	s5,8(sp)
    80000dc0:	e05a                	sd	s6,0(sp)
    80000dc2:	0080                	addi	s0,sp,64
    80000dc4:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dc6:	00028497          	auipc	s1,0x28
    80000dca:	6ba48493          	addi	s1,s1,1722 # 80029480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000dce:	8b26                	mv	s6,s1
    80000dd0:	00007a97          	auipc	s5,0x7
    80000dd4:	230a8a93          	addi	s5,s5,560 # 80008000 <etext>
    80000dd8:	04000937          	lui	s2,0x4000
    80000ddc:	197d                	addi	s2,s2,-1
    80000dde:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000de0:	0002ea17          	auipc	s4,0x2e
    80000de4:	0a0a0a13          	addi	s4,s4,160 # 8002ee80 <tickslock>
    char *pa = kalloc();
    80000de8:	fffff097          	auipc	ra,0xfffff
    80000dec:	394080e7          	jalr	916(ra) # 8000017c <kalloc>
    80000df0:	862a                	mv	a2,a0
    if(pa == 0)
    80000df2:	c131                	beqz	a0,80000e36 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000df4:	416485b3          	sub	a1,s1,s6
    80000df8:	858d                	srai	a1,a1,0x3
    80000dfa:	000ab783          	ld	a5,0(s5)
    80000dfe:	02f585b3          	mul	a1,a1,a5
    80000e02:	2585                	addiw	a1,a1,1
    80000e04:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e08:	4719                	li	a4,6
    80000e0a:	6685                	lui	a3,0x1
    80000e0c:	40b905b3          	sub	a1,s2,a1
    80000e10:	854e                	mv	a0,s3
    80000e12:	00000097          	auipc	ra,0x0
    80000e16:	870080e7          	jalr	-1936(ra) # 80000682 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e1a:	16848493          	addi	s1,s1,360
    80000e1e:	fd4495e3          	bne	s1,s4,80000de8 <proc_mapstacks+0x38>
  }
}
    80000e22:	70e2                	ld	ra,56(sp)
    80000e24:	7442                	ld	s0,48(sp)
    80000e26:	74a2                	ld	s1,40(sp)
    80000e28:	7902                	ld	s2,32(sp)
    80000e2a:	69e2                	ld	s3,24(sp)
    80000e2c:	6a42                	ld	s4,16(sp)
    80000e2e:	6aa2                	ld	s5,8(sp)
    80000e30:	6b02                	ld	s6,0(sp)
    80000e32:	6121                	addi	sp,sp,64
    80000e34:	8082                	ret
      panic("kalloc");
    80000e36:	00007517          	auipc	a0,0x7
    80000e3a:	37250513          	addi	a0,a0,882 # 800081a8 <etext+0x1a8>
    80000e3e:	00005097          	auipc	ra,0x5
    80000e42:	eda080e7          	jalr	-294(ra) # 80005d18 <panic>

0000000080000e46 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000e46:	7139                	addi	sp,sp,-64
    80000e48:	fc06                	sd	ra,56(sp)
    80000e4a:	f822                	sd	s0,48(sp)
    80000e4c:	f426                	sd	s1,40(sp)
    80000e4e:	f04a                	sd	s2,32(sp)
    80000e50:	ec4e                	sd	s3,24(sp)
    80000e52:	e852                	sd	s4,16(sp)
    80000e54:	e456                	sd	s5,8(sp)
    80000e56:	e05a                	sd	s6,0(sp)
    80000e58:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000e5a:	00007597          	auipc	a1,0x7
    80000e5e:	35658593          	addi	a1,a1,854 # 800081b0 <etext+0x1b0>
    80000e62:	00028517          	auipc	a0,0x28
    80000e66:	1ee50513          	addi	a0,a0,494 # 80029050 <pid_lock>
    80000e6a:	00005097          	auipc	ra,0x5
    80000e6e:	368080e7          	jalr	872(ra) # 800061d2 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000e72:	00007597          	auipc	a1,0x7
    80000e76:	34658593          	addi	a1,a1,838 # 800081b8 <etext+0x1b8>
    80000e7a:	00028517          	auipc	a0,0x28
    80000e7e:	1ee50513          	addi	a0,a0,494 # 80029068 <wait_lock>
    80000e82:	00005097          	auipc	ra,0x5
    80000e86:	350080e7          	jalr	848(ra) # 800061d2 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e8a:	00028497          	auipc	s1,0x28
    80000e8e:	5f648493          	addi	s1,s1,1526 # 80029480 <proc>
      initlock(&p->lock, "proc");
    80000e92:	00007b17          	auipc	s6,0x7
    80000e96:	336b0b13          	addi	s6,s6,822 # 800081c8 <etext+0x1c8>
      p->kstack = KSTACK((int) (p - proc));
    80000e9a:	8aa6                	mv	s5,s1
    80000e9c:	00007a17          	auipc	s4,0x7
    80000ea0:	164a0a13          	addi	s4,s4,356 # 80008000 <etext>
    80000ea4:	04000937          	lui	s2,0x4000
    80000ea8:	197d                	addi	s2,s2,-1
    80000eaa:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000eac:	0002e997          	auipc	s3,0x2e
    80000eb0:	fd498993          	addi	s3,s3,-44 # 8002ee80 <tickslock>
      initlock(&p->lock, "proc");
    80000eb4:	85da                	mv	a1,s6
    80000eb6:	8526                	mv	a0,s1
    80000eb8:	00005097          	auipc	ra,0x5
    80000ebc:	31a080e7          	jalr	794(ra) # 800061d2 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000ec0:	415487b3          	sub	a5,s1,s5
    80000ec4:	878d                	srai	a5,a5,0x3
    80000ec6:	000a3703          	ld	a4,0(s4)
    80000eca:	02e787b3          	mul	a5,a5,a4
    80000ece:	2785                	addiw	a5,a5,1
    80000ed0:	00d7979b          	slliw	a5,a5,0xd
    80000ed4:	40f907b3          	sub	a5,s2,a5
    80000ed8:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000eda:	16848493          	addi	s1,s1,360
    80000ede:	fd349be3          	bne	s1,s3,80000eb4 <procinit+0x6e>
  }
}
    80000ee2:	70e2                	ld	ra,56(sp)
    80000ee4:	7442                	ld	s0,48(sp)
    80000ee6:	74a2                	ld	s1,40(sp)
    80000ee8:	7902                	ld	s2,32(sp)
    80000eea:	69e2                	ld	s3,24(sp)
    80000eec:	6a42                	ld	s4,16(sp)
    80000eee:	6aa2                	ld	s5,8(sp)
    80000ef0:	6b02                	ld	s6,0(sp)
    80000ef2:	6121                	addi	sp,sp,64
    80000ef4:	8082                	ret

0000000080000ef6 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000ef6:	1141                	addi	sp,sp,-16
    80000ef8:	e422                	sd	s0,8(sp)
    80000efa:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r"(x));
    80000efc:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000efe:	2501                	sext.w	a0,a0
    80000f00:	6422                	ld	s0,8(sp)
    80000f02:	0141                	addi	sp,sp,16
    80000f04:	8082                	ret

0000000080000f06 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000f06:	1141                	addi	sp,sp,-16
    80000f08:	e422                	sd	s0,8(sp)
    80000f0a:	0800                	addi	s0,sp,16
    80000f0c:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f0e:	2781                	sext.w	a5,a5
    80000f10:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f12:	00028517          	auipc	a0,0x28
    80000f16:	16e50513          	addi	a0,a0,366 # 80029080 <cpus>
    80000f1a:	953e                	add	a0,a0,a5
    80000f1c:	6422                	ld	s0,8(sp)
    80000f1e:	0141                	addi	sp,sp,16
    80000f20:	8082                	ret

0000000080000f22 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000f22:	1101                	addi	sp,sp,-32
    80000f24:	ec06                	sd	ra,24(sp)
    80000f26:	e822                	sd	s0,16(sp)
    80000f28:	e426                	sd	s1,8(sp)
    80000f2a:	1000                	addi	s0,sp,32
  push_off();
    80000f2c:	00005097          	auipc	ra,0x5
    80000f30:	2ea080e7          	jalr	746(ra) # 80006216 <push_off>
    80000f34:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f36:	2781                	sext.w	a5,a5
    80000f38:	079e                	slli	a5,a5,0x7
    80000f3a:	00028717          	auipc	a4,0x28
    80000f3e:	11670713          	addi	a4,a4,278 # 80029050 <pid_lock>
    80000f42:	97ba                	add	a5,a5,a4
    80000f44:	7b84                	ld	s1,48(a5)
  pop_off();
    80000f46:	00005097          	auipc	ra,0x5
    80000f4a:	370080e7          	jalr	880(ra) # 800062b6 <pop_off>
  return p;
}
    80000f4e:	8526                	mv	a0,s1
    80000f50:	60e2                	ld	ra,24(sp)
    80000f52:	6442                	ld	s0,16(sp)
    80000f54:	64a2                	ld	s1,8(sp)
    80000f56:	6105                	addi	sp,sp,32
    80000f58:	8082                	ret

0000000080000f5a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000f5a:	1141                	addi	sp,sp,-16
    80000f5c:	e406                	sd	ra,8(sp)
    80000f5e:	e022                	sd	s0,0(sp)
    80000f60:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000f62:	00000097          	auipc	ra,0x0
    80000f66:	fc0080e7          	jalr	-64(ra) # 80000f22 <myproc>
    80000f6a:	00005097          	auipc	ra,0x5
    80000f6e:	3ac080e7          	jalr	940(ra) # 80006316 <release>

  if (first) {
    80000f72:	00008797          	auipc	a5,0x8
    80000f76:	96e7a783          	lw	a5,-1682(a5) # 800088e0 <first.1677>
    80000f7a:	eb89                	bnez	a5,80000f8c <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000f7c:	00001097          	auipc	ra,0x1
    80000f80:	c0a080e7          	jalr	-1014(ra) # 80001b86 <usertrapret>
}
    80000f84:	60a2                	ld	ra,8(sp)
    80000f86:	6402                	ld	s0,0(sp)
    80000f88:	0141                	addi	sp,sp,16
    80000f8a:	8082                	ret
    first = 0;
    80000f8c:	00008797          	auipc	a5,0x8
    80000f90:	9407aa23          	sw	zero,-1708(a5) # 800088e0 <first.1677>
    fsinit(ROOTDEV);
    80000f94:	4505                	li	a0,1
    80000f96:	00002097          	auipc	ra,0x2
    80000f9a:	a5e080e7          	jalr	-1442(ra) # 800029f4 <fsinit>
    80000f9e:	bff9                	j	80000f7c <forkret+0x22>

0000000080000fa0 <allocpid>:
allocpid() {
    80000fa0:	1101                	addi	sp,sp,-32
    80000fa2:	ec06                	sd	ra,24(sp)
    80000fa4:	e822                	sd	s0,16(sp)
    80000fa6:	e426                	sd	s1,8(sp)
    80000fa8:	e04a                	sd	s2,0(sp)
    80000faa:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000fac:	00028917          	auipc	s2,0x28
    80000fb0:	0a490913          	addi	s2,s2,164 # 80029050 <pid_lock>
    80000fb4:	854a                	mv	a0,s2
    80000fb6:	00005097          	auipc	ra,0x5
    80000fba:	2ac080e7          	jalr	684(ra) # 80006262 <acquire>
  pid = nextpid;
    80000fbe:	00008797          	auipc	a5,0x8
    80000fc2:	92678793          	addi	a5,a5,-1754 # 800088e4 <nextpid>
    80000fc6:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000fc8:	0014871b          	addiw	a4,s1,1
    80000fcc:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000fce:	854a                	mv	a0,s2
    80000fd0:	00005097          	auipc	ra,0x5
    80000fd4:	346080e7          	jalr	838(ra) # 80006316 <release>
}
    80000fd8:	8526                	mv	a0,s1
    80000fda:	60e2                	ld	ra,24(sp)
    80000fdc:	6442                	ld	s0,16(sp)
    80000fde:	64a2                	ld	s1,8(sp)
    80000fe0:	6902                	ld	s2,0(sp)
    80000fe2:	6105                	addi	sp,sp,32
    80000fe4:	8082                	ret

0000000080000fe6 <proc_pagetable>:
{
    80000fe6:	1101                	addi	sp,sp,-32
    80000fe8:	ec06                	sd	ra,24(sp)
    80000fea:	e822                	sd	s0,16(sp)
    80000fec:	e426                	sd	s1,8(sp)
    80000fee:	e04a                	sd	s2,0(sp)
    80000ff0:	1000                	addi	s0,sp,32
    80000ff2:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000ff4:	00000097          	auipc	ra,0x0
    80000ff8:	878080e7          	jalr	-1928(ra) # 8000086c <uvmcreate>
    80000ffc:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000ffe:	c121                	beqz	a0,8000103e <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001000:	4729                	li	a4,10
    80001002:	00006697          	auipc	a3,0x6
    80001006:	ffe68693          	addi	a3,a3,-2 # 80007000 <_trampoline>
    8000100a:	6605                	lui	a2,0x1
    8000100c:	040005b7          	lui	a1,0x4000
    80001010:	15fd                	addi	a1,a1,-1
    80001012:	05b2                	slli	a1,a1,0xc
    80001014:	fffff097          	auipc	ra,0xfffff
    80001018:	5ce080e7          	jalr	1486(ra) # 800005e2 <mappages>
    8000101c:	02054863          	bltz	a0,8000104c <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001020:	4719                	li	a4,6
    80001022:	05893683          	ld	a3,88(s2)
    80001026:	6605                	lui	a2,0x1
    80001028:	020005b7          	lui	a1,0x2000
    8000102c:	15fd                	addi	a1,a1,-1
    8000102e:	05b6                	slli	a1,a1,0xd
    80001030:	8526                	mv	a0,s1
    80001032:	fffff097          	auipc	ra,0xfffff
    80001036:	5b0080e7          	jalr	1456(ra) # 800005e2 <mappages>
    8000103a:	02054163          	bltz	a0,8000105c <proc_pagetable+0x76>
}
    8000103e:	8526                	mv	a0,s1
    80001040:	60e2                	ld	ra,24(sp)
    80001042:	6442                	ld	s0,16(sp)
    80001044:	64a2                	ld	s1,8(sp)
    80001046:	6902                	ld	s2,0(sp)
    80001048:	6105                	addi	sp,sp,32
    8000104a:	8082                	ret
    uvmfree(pagetable, 0);
    8000104c:	4581                	li	a1,0
    8000104e:	8526                	mv	a0,s1
    80001050:	00000097          	auipc	ra,0x0
    80001054:	a18080e7          	jalr	-1512(ra) # 80000a68 <uvmfree>
    return 0;
    80001058:	4481                	li	s1,0
    8000105a:	b7d5                	j	8000103e <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000105c:	4681                	li	a3,0
    8000105e:	4605                	li	a2,1
    80001060:	040005b7          	lui	a1,0x4000
    80001064:	15fd                	addi	a1,a1,-1
    80001066:	05b2                	slli	a1,a1,0xc
    80001068:	8526                	mv	a0,s1
    8000106a:	fffff097          	auipc	ra,0xfffff
    8000106e:	73e080e7          	jalr	1854(ra) # 800007a8 <uvmunmap>
    uvmfree(pagetable, 0);
    80001072:	4581                	li	a1,0
    80001074:	8526                	mv	a0,s1
    80001076:	00000097          	auipc	ra,0x0
    8000107a:	9f2080e7          	jalr	-1550(ra) # 80000a68 <uvmfree>
    return 0;
    8000107e:	4481                	li	s1,0
    80001080:	bf7d                	j	8000103e <proc_pagetable+0x58>

0000000080001082 <proc_freepagetable>:
{
    80001082:	1101                	addi	sp,sp,-32
    80001084:	ec06                	sd	ra,24(sp)
    80001086:	e822                	sd	s0,16(sp)
    80001088:	e426                	sd	s1,8(sp)
    8000108a:	e04a                	sd	s2,0(sp)
    8000108c:	1000                	addi	s0,sp,32
    8000108e:	84aa                	mv	s1,a0
    80001090:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001092:	4681                	li	a3,0
    80001094:	4605                	li	a2,1
    80001096:	040005b7          	lui	a1,0x4000
    8000109a:	15fd                	addi	a1,a1,-1
    8000109c:	05b2                	slli	a1,a1,0xc
    8000109e:	fffff097          	auipc	ra,0xfffff
    800010a2:	70a080e7          	jalr	1802(ra) # 800007a8 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800010a6:	4681                	li	a3,0
    800010a8:	4605                	li	a2,1
    800010aa:	020005b7          	lui	a1,0x2000
    800010ae:	15fd                	addi	a1,a1,-1
    800010b0:	05b6                	slli	a1,a1,0xd
    800010b2:	8526                	mv	a0,s1
    800010b4:	fffff097          	auipc	ra,0xfffff
    800010b8:	6f4080e7          	jalr	1780(ra) # 800007a8 <uvmunmap>
  uvmfree(pagetable, sz);
    800010bc:	85ca                	mv	a1,s2
    800010be:	8526                	mv	a0,s1
    800010c0:	00000097          	auipc	ra,0x0
    800010c4:	9a8080e7          	jalr	-1624(ra) # 80000a68 <uvmfree>
}
    800010c8:	60e2                	ld	ra,24(sp)
    800010ca:	6442                	ld	s0,16(sp)
    800010cc:	64a2                	ld	s1,8(sp)
    800010ce:	6902                	ld	s2,0(sp)
    800010d0:	6105                	addi	sp,sp,32
    800010d2:	8082                	ret

00000000800010d4 <freeproc>:
{
    800010d4:	1101                	addi	sp,sp,-32
    800010d6:	ec06                	sd	ra,24(sp)
    800010d8:	e822                	sd	s0,16(sp)
    800010da:	e426                	sd	s1,8(sp)
    800010dc:	1000                	addi	s0,sp,32
    800010de:	84aa                	mv	s1,a0
  if(p->trapframe)
    800010e0:	6d28                	ld	a0,88(a0)
    800010e2:	c509                	beqz	a0,800010ec <freeproc+0x18>
    kfree((void*)p->trapframe);
    800010e4:	fffff097          	auipc	ra,0xfffff
    800010e8:	f38080e7          	jalr	-200(ra) # 8000001c <kfree>
  p->trapframe = 0;
    800010ec:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    800010f0:	68a8                	ld	a0,80(s1)
    800010f2:	c511                	beqz	a0,800010fe <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    800010f4:	64ac                	ld	a1,72(s1)
    800010f6:	00000097          	auipc	ra,0x0
    800010fa:	f8c080e7          	jalr	-116(ra) # 80001082 <proc_freepagetable>
  p->pagetable = 0;
    800010fe:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001102:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001106:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000110a:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000110e:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001112:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001116:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000111a:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000111e:	0004ac23          	sw	zero,24(s1)
}
    80001122:	60e2                	ld	ra,24(sp)
    80001124:	6442                	ld	s0,16(sp)
    80001126:	64a2                	ld	s1,8(sp)
    80001128:	6105                	addi	sp,sp,32
    8000112a:	8082                	ret

000000008000112c <allocproc>:
{
    8000112c:	1101                	addi	sp,sp,-32
    8000112e:	ec06                	sd	ra,24(sp)
    80001130:	e822                	sd	s0,16(sp)
    80001132:	e426                	sd	s1,8(sp)
    80001134:	e04a                	sd	s2,0(sp)
    80001136:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001138:	00028497          	auipc	s1,0x28
    8000113c:	34848493          	addi	s1,s1,840 # 80029480 <proc>
    80001140:	0002e917          	auipc	s2,0x2e
    80001144:	d4090913          	addi	s2,s2,-704 # 8002ee80 <tickslock>
    acquire(&p->lock);
    80001148:	8526                	mv	a0,s1
    8000114a:	00005097          	auipc	ra,0x5
    8000114e:	118080e7          	jalr	280(ra) # 80006262 <acquire>
    if(p->state == UNUSED) {
    80001152:	4c9c                	lw	a5,24(s1)
    80001154:	cf81                	beqz	a5,8000116c <allocproc+0x40>
      release(&p->lock);
    80001156:	8526                	mv	a0,s1
    80001158:	00005097          	auipc	ra,0x5
    8000115c:	1be080e7          	jalr	446(ra) # 80006316 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001160:	16848493          	addi	s1,s1,360
    80001164:	ff2492e3          	bne	s1,s2,80001148 <allocproc+0x1c>
  return 0;
    80001168:	4481                	li	s1,0
    8000116a:	a889                	j	800011bc <allocproc+0x90>
  p->pid = allocpid();
    8000116c:	00000097          	auipc	ra,0x0
    80001170:	e34080e7          	jalr	-460(ra) # 80000fa0 <allocpid>
    80001174:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001176:	4785                	li	a5,1
    80001178:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    8000117a:	fffff097          	auipc	ra,0xfffff
    8000117e:	002080e7          	jalr	2(ra) # 8000017c <kalloc>
    80001182:	892a                	mv	s2,a0
    80001184:	eca8                	sd	a0,88(s1)
    80001186:	c131                	beqz	a0,800011ca <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001188:	8526                	mv	a0,s1
    8000118a:	00000097          	auipc	ra,0x0
    8000118e:	e5c080e7          	jalr	-420(ra) # 80000fe6 <proc_pagetable>
    80001192:	892a                	mv	s2,a0
    80001194:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001196:	c531                	beqz	a0,800011e2 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001198:	07000613          	li	a2,112
    8000119c:	4581                	li	a1,0
    8000119e:	06048513          	addi	a0,s1,96
    800011a2:	fffff097          	auipc	ra,0xfffff
    800011a6:	070080e7          	jalr	112(ra) # 80000212 <memset>
  p->context.ra = (uint64)forkret;
    800011aa:	00000797          	auipc	a5,0x0
    800011ae:	db078793          	addi	a5,a5,-592 # 80000f5a <forkret>
    800011b2:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800011b4:	60bc                	ld	a5,64(s1)
    800011b6:	6705                	lui	a4,0x1
    800011b8:	97ba                	add	a5,a5,a4
    800011ba:	f4bc                	sd	a5,104(s1)
}
    800011bc:	8526                	mv	a0,s1
    800011be:	60e2                	ld	ra,24(sp)
    800011c0:	6442                	ld	s0,16(sp)
    800011c2:	64a2                	ld	s1,8(sp)
    800011c4:	6902                	ld	s2,0(sp)
    800011c6:	6105                	addi	sp,sp,32
    800011c8:	8082                	ret
    freeproc(p);
    800011ca:	8526                	mv	a0,s1
    800011cc:	00000097          	auipc	ra,0x0
    800011d0:	f08080e7          	jalr	-248(ra) # 800010d4 <freeproc>
    release(&p->lock);
    800011d4:	8526                	mv	a0,s1
    800011d6:	00005097          	auipc	ra,0x5
    800011da:	140080e7          	jalr	320(ra) # 80006316 <release>
    return 0;
    800011de:	84ca                	mv	s1,s2
    800011e0:	bff1                	j	800011bc <allocproc+0x90>
    freeproc(p);
    800011e2:	8526                	mv	a0,s1
    800011e4:	00000097          	auipc	ra,0x0
    800011e8:	ef0080e7          	jalr	-272(ra) # 800010d4 <freeproc>
    release(&p->lock);
    800011ec:	8526                	mv	a0,s1
    800011ee:	00005097          	auipc	ra,0x5
    800011f2:	128080e7          	jalr	296(ra) # 80006316 <release>
    return 0;
    800011f6:	84ca                	mv	s1,s2
    800011f8:	b7d1                	j	800011bc <allocproc+0x90>

00000000800011fa <userinit>:
{
    800011fa:	1101                	addi	sp,sp,-32
    800011fc:	ec06                	sd	ra,24(sp)
    800011fe:	e822                	sd	s0,16(sp)
    80001200:	e426                	sd	s1,8(sp)
    80001202:	1000                	addi	s0,sp,32
  p = allocproc();
    80001204:	00000097          	auipc	ra,0x0
    80001208:	f28080e7          	jalr	-216(ra) # 8000112c <allocproc>
    8000120c:	84aa                	mv	s1,a0
  initproc = p;
    8000120e:	00008797          	auipc	a5,0x8
    80001212:	e0a7b123          	sd	a0,-510(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001216:	03400613          	li	a2,52
    8000121a:	00007597          	auipc	a1,0x7
    8000121e:	6d658593          	addi	a1,a1,1750 # 800088f0 <initcode>
    80001222:	6928                	ld	a0,80(a0)
    80001224:	fffff097          	auipc	ra,0xfffff
    80001228:	676080e7          	jalr	1654(ra) # 8000089a <uvminit>
  p->sz = PGSIZE;
    8000122c:	6785                	lui	a5,0x1
    8000122e:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001230:	6cb8                	ld	a4,88(s1)
    80001232:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001236:	6cb8                	ld	a4,88(s1)
    80001238:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000123a:	4641                	li	a2,16
    8000123c:	00007597          	auipc	a1,0x7
    80001240:	f9458593          	addi	a1,a1,-108 # 800081d0 <etext+0x1d0>
    80001244:	15848513          	addi	a0,s1,344
    80001248:	fffff097          	auipc	ra,0xfffff
    8000124c:	11c080e7          	jalr	284(ra) # 80000364 <safestrcpy>
  p->cwd = namei("/");
    80001250:	00007517          	auipc	a0,0x7
    80001254:	f9050513          	addi	a0,a0,-112 # 800081e0 <etext+0x1e0>
    80001258:	00002097          	auipc	ra,0x2
    8000125c:	1ca080e7          	jalr	458(ra) # 80003422 <namei>
    80001260:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001264:	478d                	li	a5,3
    80001266:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001268:	8526                	mv	a0,s1
    8000126a:	00005097          	auipc	ra,0x5
    8000126e:	0ac080e7          	jalr	172(ra) # 80006316 <release>
}
    80001272:	60e2                	ld	ra,24(sp)
    80001274:	6442                	ld	s0,16(sp)
    80001276:	64a2                	ld	s1,8(sp)
    80001278:	6105                	addi	sp,sp,32
    8000127a:	8082                	ret

000000008000127c <growproc>:
{
    8000127c:	1101                	addi	sp,sp,-32
    8000127e:	ec06                	sd	ra,24(sp)
    80001280:	e822                	sd	s0,16(sp)
    80001282:	e426                	sd	s1,8(sp)
    80001284:	e04a                	sd	s2,0(sp)
    80001286:	1000                	addi	s0,sp,32
    80001288:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000128a:	00000097          	auipc	ra,0x0
    8000128e:	c98080e7          	jalr	-872(ra) # 80000f22 <myproc>
    80001292:	892a                	mv	s2,a0
  sz = p->sz;
    80001294:	652c                	ld	a1,72(a0)
    80001296:	0005861b          	sext.w	a2,a1
  if(n > 0){
    8000129a:	00904f63          	bgtz	s1,800012b8 <growproc+0x3c>
  } else if(n < 0){
    8000129e:	0204cc63          	bltz	s1,800012d6 <growproc+0x5a>
  p->sz = sz;
    800012a2:	1602                	slli	a2,a2,0x20
    800012a4:	9201                	srli	a2,a2,0x20
    800012a6:	04c93423          	sd	a2,72(s2)
  return 0;
    800012aa:	4501                	li	a0,0
}
    800012ac:	60e2                	ld	ra,24(sp)
    800012ae:	6442                	ld	s0,16(sp)
    800012b0:	64a2                	ld	s1,8(sp)
    800012b2:	6902                	ld	s2,0(sp)
    800012b4:	6105                	addi	sp,sp,32
    800012b6:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800012b8:	9e25                	addw	a2,a2,s1
    800012ba:	1602                	slli	a2,a2,0x20
    800012bc:	9201                	srli	a2,a2,0x20
    800012be:	1582                	slli	a1,a1,0x20
    800012c0:	9181                	srli	a1,a1,0x20
    800012c2:	6928                	ld	a0,80(a0)
    800012c4:	fffff097          	auipc	ra,0xfffff
    800012c8:	690080e7          	jalr	1680(ra) # 80000954 <uvmalloc>
    800012cc:	0005061b          	sext.w	a2,a0
    800012d0:	fa69                	bnez	a2,800012a2 <growproc+0x26>
      return -1;
    800012d2:	557d                	li	a0,-1
    800012d4:	bfe1                	j	800012ac <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800012d6:	9e25                	addw	a2,a2,s1
    800012d8:	1602                	slli	a2,a2,0x20
    800012da:	9201                	srli	a2,a2,0x20
    800012dc:	1582                	slli	a1,a1,0x20
    800012de:	9181                	srli	a1,a1,0x20
    800012e0:	6928                	ld	a0,80(a0)
    800012e2:	fffff097          	auipc	ra,0xfffff
    800012e6:	62a080e7          	jalr	1578(ra) # 8000090c <uvmdealloc>
    800012ea:	0005061b          	sext.w	a2,a0
    800012ee:	bf55                	j	800012a2 <growproc+0x26>

00000000800012f0 <fork>:
{
    800012f0:	7179                	addi	sp,sp,-48
    800012f2:	f406                	sd	ra,40(sp)
    800012f4:	f022                	sd	s0,32(sp)
    800012f6:	ec26                	sd	s1,24(sp)
    800012f8:	e84a                	sd	s2,16(sp)
    800012fa:	e44e                	sd	s3,8(sp)
    800012fc:	e052                	sd	s4,0(sp)
    800012fe:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001300:	00000097          	auipc	ra,0x0
    80001304:	c22080e7          	jalr	-990(ra) # 80000f22 <myproc>
    80001308:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    8000130a:	00000097          	auipc	ra,0x0
    8000130e:	e22080e7          	jalr	-478(ra) # 8000112c <allocproc>
    80001312:	10050b63          	beqz	a0,80001428 <fork+0x138>
    80001316:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001318:	04893603          	ld	a2,72(s2)
    8000131c:	692c                	ld	a1,80(a0)
    8000131e:	05093503          	ld	a0,80(s2)
    80001322:	fffff097          	auipc	ra,0xfffff
    80001326:	77e080e7          	jalr	1918(ra) # 80000aa0 <uvmcopy>
    8000132a:	04054663          	bltz	a0,80001376 <fork+0x86>
  np->sz = p->sz;
    8000132e:	04893783          	ld	a5,72(s2)
    80001332:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80001336:	05893683          	ld	a3,88(s2)
    8000133a:	87b6                	mv	a5,a3
    8000133c:	0589b703          	ld	a4,88(s3)
    80001340:	12068693          	addi	a3,a3,288
    80001344:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001348:	6788                	ld	a0,8(a5)
    8000134a:	6b8c                	ld	a1,16(a5)
    8000134c:	6f90                	ld	a2,24(a5)
    8000134e:	01073023          	sd	a6,0(a4)
    80001352:	e708                	sd	a0,8(a4)
    80001354:	eb0c                	sd	a1,16(a4)
    80001356:	ef10                	sd	a2,24(a4)
    80001358:	02078793          	addi	a5,a5,32
    8000135c:	02070713          	addi	a4,a4,32
    80001360:	fed792e3          	bne	a5,a3,80001344 <fork+0x54>
  np->trapframe->a0 = 0;
    80001364:	0589b783          	ld	a5,88(s3)
    80001368:	0607b823          	sd	zero,112(a5)
    8000136c:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    80001370:	15000a13          	li	s4,336
    80001374:	a03d                	j	800013a2 <fork+0xb2>
    freeproc(np);
    80001376:	854e                	mv	a0,s3
    80001378:	00000097          	auipc	ra,0x0
    8000137c:	d5c080e7          	jalr	-676(ra) # 800010d4 <freeproc>
    release(&np->lock);
    80001380:	854e                	mv	a0,s3
    80001382:	00005097          	auipc	ra,0x5
    80001386:	f94080e7          	jalr	-108(ra) # 80006316 <release>
    return -1;
    8000138a:	5a7d                	li	s4,-1
    8000138c:	a069                	j	80001416 <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    8000138e:	00002097          	auipc	ra,0x2
    80001392:	72a080e7          	jalr	1834(ra) # 80003ab8 <filedup>
    80001396:	009987b3          	add	a5,s3,s1
    8000139a:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    8000139c:	04a1                	addi	s1,s1,8
    8000139e:	01448763          	beq	s1,s4,800013ac <fork+0xbc>
    if(p->ofile[i])
    800013a2:	009907b3          	add	a5,s2,s1
    800013a6:	6388                	ld	a0,0(a5)
    800013a8:	f17d                	bnez	a0,8000138e <fork+0x9e>
    800013aa:	bfcd                	j	8000139c <fork+0xac>
  np->cwd = idup(p->cwd);
    800013ac:	15093503          	ld	a0,336(s2)
    800013b0:	00002097          	auipc	ra,0x2
    800013b4:	87e080e7          	jalr	-1922(ra) # 80002c2e <idup>
    800013b8:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800013bc:	4641                	li	a2,16
    800013be:	15890593          	addi	a1,s2,344
    800013c2:	15898513          	addi	a0,s3,344
    800013c6:	fffff097          	auipc	ra,0xfffff
    800013ca:	f9e080e7          	jalr	-98(ra) # 80000364 <safestrcpy>
  pid = np->pid;
    800013ce:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    800013d2:	854e                	mv	a0,s3
    800013d4:	00005097          	auipc	ra,0x5
    800013d8:	f42080e7          	jalr	-190(ra) # 80006316 <release>
  acquire(&wait_lock);
    800013dc:	00028497          	auipc	s1,0x28
    800013e0:	c8c48493          	addi	s1,s1,-884 # 80029068 <wait_lock>
    800013e4:	8526                	mv	a0,s1
    800013e6:	00005097          	auipc	ra,0x5
    800013ea:	e7c080e7          	jalr	-388(ra) # 80006262 <acquire>
  np->parent = p;
    800013ee:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    800013f2:	8526                	mv	a0,s1
    800013f4:	00005097          	auipc	ra,0x5
    800013f8:	f22080e7          	jalr	-222(ra) # 80006316 <release>
  acquire(&np->lock);
    800013fc:	854e                	mv	a0,s3
    800013fe:	00005097          	auipc	ra,0x5
    80001402:	e64080e7          	jalr	-412(ra) # 80006262 <acquire>
  np->state = RUNNABLE;
    80001406:	478d                	li	a5,3
    80001408:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    8000140c:	854e                	mv	a0,s3
    8000140e:	00005097          	auipc	ra,0x5
    80001412:	f08080e7          	jalr	-248(ra) # 80006316 <release>
}
    80001416:	8552                	mv	a0,s4
    80001418:	70a2                	ld	ra,40(sp)
    8000141a:	7402                	ld	s0,32(sp)
    8000141c:	64e2                	ld	s1,24(sp)
    8000141e:	6942                	ld	s2,16(sp)
    80001420:	69a2                	ld	s3,8(sp)
    80001422:	6a02                	ld	s4,0(sp)
    80001424:	6145                	addi	sp,sp,48
    80001426:	8082                	ret
    return -1;
    80001428:	5a7d                	li	s4,-1
    8000142a:	b7f5                	j	80001416 <fork+0x126>

000000008000142c <scheduler>:
{
    8000142c:	7139                	addi	sp,sp,-64
    8000142e:	fc06                	sd	ra,56(sp)
    80001430:	f822                	sd	s0,48(sp)
    80001432:	f426                	sd	s1,40(sp)
    80001434:	f04a                	sd	s2,32(sp)
    80001436:	ec4e                	sd	s3,24(sp)
    80001438:	e852                	sd	s4,16(sp)
    8000143a:	e456                	sd	s5,8(sp)
    8000143c:	e05a                	sd	s6,0(sp)
    8000143e:	0080                	addi	s0,sp,64
    80001440:	8792                	mv	a5,tp
  int id = r_tp();
    80001442:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001444:	00779a93          	slli	s5,a5,0x7
    80001448:	00028717          	auipc	a4,0x28
    8000144c:	c0870713          	addi	a4,a4,-1016 # 80029050 <pid_lock>
    80001450:	9756                	add	a4,a4,s5
    80001452:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001456:	00028717          	auipc	a4,0x28
    8000145a:	c3270713          	addi	a4,a4,-974 # 80029088 <cpus+0x8>
    8000145e:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001460:	498d                	li	s3,3
        p->state = RUNNING;
    80001462:	4b11                	li	s6,4
        c->proc = p;
    80001464:	079e                	slli	a5,a5,0x7
    80001466:	00028a17          	auipc	s4,0x28
    8000146a:	beaa0a13          	addi	s4,s4,-1046 # 80029050 <pid_lock>
    8000146e:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001470:	0002e917          	auipc	s2,0x2e
    80001474:	a1090913          	addi	s2,s2,-1520 # 8002ee80 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001478:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000147c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001480:	10079073          	csrw	sstatus,a5
    80001484:	00028497          	auipc	s1,0x28
    80001488:	ffc48493          	addi	s1,s1,-4 # 80029480 <proc>
    8000148c:	a03d                	j	800014ba <scheduler+0x8e>
        p->state = RUNNING;
    8000148e:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001492:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001496:	06048593          	addi	a1,s1,96
    8000149a:	8556                	mv	a0,s5
    8000149c:	00000097          	auipc	ra,0x0
    800014a0:	640080e7          	jalr	1600(ra) # 80001adc <swtch>
        c->proc = 0;
    800014a4:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    800014a8:	8526                	mv	a0,s1
    800014aa:	00005097          	auipc	ra,0x5
    800014ae:	e6c080e7          	jalr	-404(ra) # 80006316 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800014b2:	16848493          	addi	s1,s1,360
    800014b6:	fd2481e3          	beq	s1,s2,80001478 <scheduler+0x4c>
      acquire(&p->lock);
    800014ba:	8526                	mv	a0,s1
    800014bc:	00005097          	auipc	ra,0x5
    800014c0:	da6080e7          	jalr	-602(ra) # 80006262 <acquire>
      if(p->state == RUNNABLE) {
    800014c4:	4c9c                	lw	a5,24(s1)
    800014c6:	ff3791e3          	bne	a5,s3,800014a8 <scheduler+0x7c>
    800014ca:	b7d1                	j	8000148e <scheduler+0x62>

00000000800014cc <sched>:
{
    800014cc:	7179                	addi	sp,sp,-48
    800014ce:	f406                	sd	ra,40(sp)
    800014d0:	f022                	sd	s0,32(sp)
    800014d2:	ec26                	sd	s1,24(sp)
    800014d4:	e84a                	sd	s2,16(sp)
    800014d6:	e44e                	sd	s3,8(sp)
    800014d8:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800014da:	00000097          	auipc	ra,0x0
    800014de:	a48080e7          	jalr	-1464(ra) # 80000f22 <myproc>
    800014e2:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800014e4:	00005097          	auipc	ra,0x5
    800014e8:	d04080e7          	jalr	-764(ra) # 800061e8 <holding>
    800014ec:	c93d                	beqz	a0,80001562 <sched+0x96>
  asm volatile("mv %0, tp" : "=r"(x));
    800014ee:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800014f0:	2781                	sext.w	a5,a5
    800014f2:	079e                	slli	a5,a5,0x7
    800014f4:	00028717          	auipc	a4,0x28
    800014f8:	b5c70713          	addi	a4,a4,-1188 # 80029050 <pid_lock>
    800014fc:	97ba                	add	a5,a5,a4
    800014fe:	0a87a703          	lw	a4,168(a5)
    80001502:	4785                	li	a5,1
    80001504:	06f71763          	bne	a4,a5,80001572 <sched+0xa6>
  if(p->state == RUNNING)
    80001508:	4c98                	lw	a4,24(s1)
    8000150a:	4791                	li	a5,4
    8000150c:	06f70b63          	beq	a4,a5,80001582 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001510:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001514:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001516:	efb5                	bnez	a5,80001592 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r"(x));
    80001518:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000151a:	00028917          	auipc	s2,0x28
    8000151e:	b3690913          	addi	s2,s2,-1226 # 80029050 <pid_lock>
    80001522:	2781                	sext.w	a5,a5
    80001524:	079e                	slli	a5,a5,0x7
    80001526:	97ca                	add	a5,a5,s2
    80001528:	0ac7a983          	lw	s3,172(a5)
    8000152c:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000152e:	2781                	sext.w	a5,a5
    80001530:	079e                	slli	a5,a5,0x7
    80001532:	00028597          	auipc	a1,0x28
    80001536:	b5658593          	addi	a1,a1,-1194 # 80029088 <cpus+0x8>
    8000153a:	95be                	add	a1,a1,a5
    8000153c:	06048513          	addi	a0,s1,96
    80001540:	00000097          	auipc	ra,0x0
    80001544:	59c080e7          	jalr	1436(ra) # 80001adc <swtch>
    80001548:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000154a:	2781                	sext.w	a5,a5
    8000154c:	079e                	slli	a5,a5,0x7
    8000154e:	97ca                	add	a5,a5,s2
    80001550:	0b37a623          	sw	s3,172(a5)
}
    80001554:	70a2                	ld	ra,40(sp)
    80001556:	7402                	ld	s0,32(sp)
    80001558:	64e2                	ld	s1,24(sp)
    8000155a:	6942                	ld	s2,16(sp)
    8000155c:	69a2                	ld	s3,8(sp)
    8000155e:	6145                	addi	sp,sp,48
    80001560:	8082                	ret
    panic("sched p->lock");
    80001562:	00007517          	auipc	a0,0x7
    80001566:	c8650513          	addi	a0,a0,-890 # 800081e8 <etext+0x1e8>
    8000156a:	00004097          	auipc	ra,0x4
    8000156e:	7ae080e7          	jalr	1966(ra) # 80005d18 <panic>
    panic("sched locks");
    80001572:	00007517          	auipc	a0,0x7
    80001576:	c8650513          	addi	a0,a0,-890 # 800081f8 <etext+0x1f8>
    8000157a:	00004097          	auipc	ra,0x4
    8000157e:	79e080e7          	jalr	1950(ra) # 80005d18 <panic>
    panic("sched running");
    80001582:	00007517          	auipc	a0,0x7
    80001586:	c8650513          	addi	a0,a0,-890 # 80008208 <etext+0x208>
    8000158a:	00004097          	auipc	ra,0x4
    8000158e:	78e080e7          	jalr	1934(ra) # 80005d18 <panic>
    panic("sched interruptible");
    80001592:	00007517          	auipc	a0,0x7
    80001596:	c8650513          	addi	a0,a0,-890 # 80008218 <etext+0x218>
    8000159a:	00004097          	auipc	ra,0x4
    8000159e:	77e080e7          	jalr	1918(ra) # 80005d18 <panic>

00000000800015a2 <yield>:
{
    800015a2:	1101                	addi	sp,sp,-32
    800015a4:	ec06                	sd	ra,24(sp)
    800015a6:	e822                	sd	s0,16(sp)
    800015a8:	e426                	sd	s1,8(sp)
    800015aa:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800015ac:	00000097          	auipc	ra,0x0
    800015b0:	976080e7          	jalr	-1674(ra) # 80000f22 <myproc>
    800015b4:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800015b6:	00005097          	auipc	ra,0x5
    800015ba:	cac080e7          	jalr	-852(ra) # 80006262 <acquire>
  p->state = RUNNABLE;
    800015be:	478d                	li	a5,3
    800015c0:	cc9c                	sw	a5,24(s1)
  sched();
    800015c2:	00000097          	auipc	ra,0x0
    800015c6:	f0a080e7          	jalr	-246(ra) # 800014cc <sched>
  release(&p->lock);
    800015ca:	8526                	mv	a0,s1
    800015cc:	00005097          	auipc	ra,0x5
    800015d0:	d4a080e7          	jalr	-694(ra) # 80006316 <release>
}
    800015d4:	60e2                	ld	ra,24(sp)
    800015d6:	6442                	ld	s0,16(sp)
    800015d8:	64a2                	ld	s1,8(sp)
    800015da:	6105                	addi	sp,sp,32
    800015dc:	8082                	ret

00000000800015de <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800015de:	7179                	addi	sp,sp,-48
    800015e0:	f406                	sd	ra,40(sp)
    800015e2:	f022                	sd	s0,32(sp)
    800015e4:	ec26                	sd	s1,24(sp)
    800015e6:	e84a                	sd	s2,16(sp)
    800015e8:	e44e                	sd	s3,8(sp)
    800015ea:	1800                	addi	s0,sp,48
    800015ec:	89aa                	mv	s3,a0
    800015ee:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800015f0:	00000097          	auipc	ra,0x0
    800015f4:	932080e7          	jalr	-1742(ra) # 80000f22 <myproc>
    800015f8:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800015fa:	00005097          	auipc	ra,0x5
    800015fe:	c68080e7          	jalr	-920(ra) # 80006262 <acquire>
  release(lk);
    80001602:	854a                	mv	a0,s2
    80001604:	00005097          	auipc	ra,0x5
    80001608:	d12080e7          	jalr	-750(ra) # 80006316 <release>

  // Go to sleep.
  p->chan = chan;
    8000160c:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001610:	4789                	li	a5,2
    80001612:	cc9c                	sw	a5,24(s1)

  sched();
    80001614:	00000097          	auipc	ra,0x0
    80001618:	eb8080e7          	jalr	-328(ra) # 800014cc <sched>

  // Tidy up.
  p->chan = 0;
    8000161c:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001620:	8526                	mv	a0,s1
    80001622:	00005097          	auipc	ra,0x5
    80001626:	cf4080e7          	jalr	-780(ra) # 80006316 <release>
  acquire(lk);
    8000162a:	854a                	mv	a0,s2
    8000162c:	00005097          	auipc	ra,0x5
    80001630:	c36080e7          	jalr	-970(ra) # 80006262 <acquire>
}
    80001634:	70a2                	ld	ra,40(sp)
    80001636:	7402                	ld	s0,32(sp)
    80001638:	64e2                	ld	s1,24(sp)
    8000163a:	6942                	ld	s2,16(sp)
    8000163c:	69a2                	ld	s3,8(sp)
    8000163e:	6145                	addi	sp,sp,48
    80001640:	8082                	ret

0000000080001642 <wait>:
{
    80001642:	715d                	addi	sp,sp,-80
    80001644:	e486                	sd	ra,72(sp)
    80001646:	e0a2                	sd	s0,64(sp)
    80001648:	fc26                	sd	s1,56(sp)
    8000164a:	f84a                	sd	s2,48(sp)
    8000164c:	f44e                	sd	s3,40(sp)
    8000164e:	f052                	sd	s4,32(sp)
    80001650:	ec56                	sd	s5,24(sp)
    80001652:	e85a                	sd	s6,16(sp)
    80001654:	e45e                	sd	s7,8(sp)
    80001656:	e062                	sd	s8,0(sp)
    80001658:	0880                	addi	s0,sp,80
    8000165a:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000165c:	00000097          	auipc	ra,0x0
    80001660:	8c6080e7          	jalr	-1850(ra) # 80000f22 <myproc>
    80001664:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001666:	00028517          	auipc	a0,0x28
    8000166a:	a0250513          	addi	a0,a0,-1534 # 80029068 <wait_lock>
    8000166e:	00005097          	auipc	ra,0x5
    80001672:	bf4080e7          	jalr	-1036(ra) # 80006262 <acquire>
    havekids = 0;
    80001676:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80001678:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    8000167a:	0002e997          	auipc	s3,0x2e
    8000167e:	80698993          	addi	s3,s3,-2042 # 8002ee80 <tickslock>
        havekids = 1;
    80001682:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001684:	00028c17          	auipc	s8,0x28
    80001688:	9e4c0c13          	addi	s8,s8,-1564 # 80029068 <wait_lock>
    havekids = 0;
    8000168c:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    8000168e:	00028497          	auipc	s1,0x28
    80001692:	df248493          	addi	s1,s1,-526 # 80029480 <proc>
    80001696:	a0bd                	j	80001704 <wait+0xc2>
          pid = np->pid;
    80001698:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000169c:	000b0e63          	beqz	s6,800016b8 <wait+0x76>
    800016a0:	4691                	li	a3,4
    800016a2:	02c48613          	addi	a2,s1,44
    800016a6:	85da                	mv	a1,s6
    800016a8:	05093503          	ld	a0,80(s2)
    800016ac:	fffff097          	auipc	ra,0xfffff
    800016b0:	538080e7          	jalr	1336(ra) # 80000be4 <copyout>
    800016b4:	02054563          	bltz	a0,800016de <wait+0x9c>
          freeproc(np);
    800016b8:	8526                	mv	a0,s1
    800016ba:	00000097          	auipc	ra,0x0
    800016be:	a1a080e7          	jalr	-1510(ra) # 800010d4 <freeproc>
          release(&np->lock);
    800016c2:	8526                	mv	a0,s1
    800016c4:	00005097          	auipc	ra,0x5
    800016c8:	c52080e7          	jalr	-942(ra) # 80006316 <release>
          release(&wait_lock);
    800016cc:	00028517          	auipc	a0,0x28
    800016d0:	99c50513          	addi	a0,a0,-1636 # 80029068 <wait_lock>
    800016d4:	00005097          	auipc	ra,0x5
    800016d8:	c42080e7          	jalr	-958(ra) # 80006316 <release>
          return pid;
    800016dc:	a09d                	j	80001742 <wait+0x100>
            release(&np->lock);
    800016de:	8526                	mv	a0,s1
    800016e0:	00005097          	auipc	ra,0x5
    800016e4:	c36080e7          	jalr	-970(ra) # 80006316 <release>
            release(&wait_lock);
    800016e8:	00028517          	auipc	a0,0x28
    800016ec:	98050513          	addi	a0,a0,-1664 # 80029068 <wait_lock>
    800016f0:	00005097          	auipc	ra,0x5
    800016f4:	c26080e7          	jalr	-986(ra) # 80006316 <release>
            return -1;
    800016f8:	59fd                	li	s3,-1
    800016fa:	a0a1                	j	80001742 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    800016fc:	16848493          	addi	s1,s1,360
    80001700:	03348463          	beq	s1,s3,80001728 <wait+0xe6>
      if(np->parent == p){
    80001704:	7c9c                	ld	a5,56(s1)
    80001706:	ff279be3          	bne	a5,s2,800016fc <wait+0xba>
        acquire(&np->lock);
    8000170a:	8526                	mv	a0,s1
    8000170c:	00005097          	auipc	ra,0x5
    80001710:	b56080e7          	jalr	-1194(ra) # 80006262 <acquire>
        if(np->state == ZOMBIE){
    80001714:	4c9c                	lw	a5,24(s1)
    80001716:	f94781e3          	beq	a5,s4,80001698 <wait+0x56>
        release(&np->lock);
    8000171a:	8526                	mv	a0,s1
    8000171c:	00005097          	auipc	ra,0x5
    80001720:	bfa080e7          	jalr	-1030(ra) # 80006316 <release>
        havekids = 1;
    80001724:	8756                	mv	a4,s5
    80001726:	bfd9                	j	800016fc <wait+0xba>
    if(!havekids || p->killed){
    80001728:	c701                	beqz	a4,80001730 <wait+0xee>
    8000172a:	02892783          	lw	a5,40(s2)
    8000172e:	c79d                	beqz	a5,8000175c <wait+0x11a>
      release(&wait_lock);
    80001730:	00028517          	auipc	a0,0x28
    80001734:	93850513          	addi	a0,a0,-1736 # 80029068 <wait_lock>
    80001738:	00005097          	auipc	ra,0x5
    8000173c:	bde080e7          	jalr	-1058(ra) # 80006316 <release>
      return -1;
    80001740:	59fd                	li	s3,-1
}
    80001742:	854e                	mv	a0,s3
    80001744:	60a6                	ld	ra,72(sp)
    80001746:	6406                	ld	s0,64(sp)
    80001748:	74e2                	ld	s1,56(sp)
    8000174a:	7942                	ld	s2,48(sp)
    8000174c:	79a2                	ld	s3,40(sp)
    8000174e:	7a02                	ld	s4,32(sp)
    80001750:	6ae2                	ld	s5,24(sp)
    80001752:	6b42                	ld	s6,16(sp)
    80001754:	6ba2                	ld	s7,8(sp)
    80001756:	6c02                	ld	s8,0(sp)
    80001758:	6161                	addi	sp,sp,80
    8000175a:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000175c:	85e2                	mv	a1,s8
    8000175e:	854a                	mv	a0,s2
    80001760:	00000097          	auipc	ra,0x0
    80001764:	e7e080e7          	jalr	-386(ra) # 800015de <sleep>
    havekids = 0;
    80001768:	b715                	j	8000168c <wait+0x4a>

000000008000176a <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000176a:	7139                	addi	sp,sp,-64
    8000176c:	fc06                	sd	ra,56(sp)
    8000176e:	f822                	sd	s0,48(sp)
    80001770:	f426                	sd	s1,40(sp)
    80001772:	f04a                	sd	s2,32(sp)
    80001774:	ec4e                	sd	s3,24(sp)
    80001776:	e852                	sd	s4,16(sp)
    80001778:	e456                	sd	s5,8(sp)
    8000177a:	0080                	addi	s0,sp,64
    8000177c:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000177e:	00028497          	auipc	s1,0x28
    80001782:	d0248493          	addi	s1,s1,-766 # 80029480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001786:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001788:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000178a:	0002d917          	auipc	s2,0x2d
    8000178e:	6f690913          	addi	s2,s2,1782 # 8002ee80 <tickslock>
    80001792:	a821                	j	800017aa <wakeup+0x40>
        p->state = RUNNABLE;
    80001794:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    80001798:	8526                	mv	a0,s1
    8000179a:	00005097          	auipc	ra,0x5
    8000179e:	b7c080e7          	jalr	-1156(ra) # 80006316 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800017a2:	16848493          	addi	s1,s1,360
    800017a6:	03248463          	beq	s1,s2,800017ce <wakeup+0x64>
    if(p != myproc()){
    800017aa:	fffff097          	auipc	ra,0xfffff
    800017ae:	778080e7          	jalr	1912(ra) # 80000f22 <myproc>
    800017b2:	fea488e3          	beq	s1,a0,800017a2 <wakeup+0x38>
      acquire(&p->lock);
    800017b6:	8526                	mv	a0,s1
    800017b8:	00005097          	auipc	ra,0x5
    800017bc:	aaa080e7          	jalr	-1366(ra) # 80006262 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800017c0:	4c9c                	lw	a5,24(s1)
    800017c2:	fd379be3          	bne	a5,s3,80001798 <wakeup+0x2e>
    800017c6:	709c                	ld	a5,32(s1)
    800017c8:	fd4798e3          	bne	a5,s4,80001798 <wakeup+0x2e>
    800017cc:	b7e1                	j	80001794 <wakeup+0x2a>
    }
  }
}
    800017ce:	70e2                	ld	ra,56(sp)
    800017d0:	7442                	ld	s0,48(sp)
    800017d2:	74a2                	ld	s1,40(sp)
    800017d4:	7902                	ld	s2,32(sp)
    800017d6:	69e2                	ld	s3,24(sp)
    800017d8:	6a42                	ld	s4,16(sp)
    800017da:	6aa2                	ld	s5,8(sp)
    800017dc:	6121                	addi	sp,sp,64
    800017de:	8082                	ret

00000000800017e0 <reparent>:
{
    800017e0:	7179                	addi	sp,sp,-48
    800017e2:	f406                	sd	ra,40(sp)
    800017e4:	f022                	sd	s0,32(sp)
    800017e6:	ec26                	sd	s1,24(sp)
    800017e8:	e84a                	sd	s2,16(sp)
    800017ea:	e44e                	sd	s3,8(sp)
    800017ec:	e052                	sd	s4,0(sp)
    800017ee:	1800                	addi	s0,sp,48
    800017f0:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800017f2:	00028497          	auipc	s1,0x28
    800017f6:	c8e48493          	addi	s1,s1,-882 # 80029480 <proc>
      pp->parent = initproc;
    800017fa:	00008a17          	auipc	s4,0x8
    800017fe:	816a0a13          	addi	s4,s4,-2026 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001802:	0002d997          	auipc	s3,0x2d
    80001806:	67e98993          	addi	s3,s3,1662 # 8002ee80 <tickslock>
    8000180a:	a029                	j	80001814 <reparent+0x34>
    8000180c:	16848493          	addi	s1,s1,360
    80001810:	01348d63          	beq	s1,s3,8000182a <reparent+0x4a>
    if(pp->parent == p){
    80001814:	7c9c                	ld	a5,56(s1)
    80001816:	ff279be3          	bne	a5,s2,8000180c <reparent+0x2c>
      pp->parent = initproc;
    8000181a:	000a3503          	ld	a0,0(s4)
    8000181e:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001820:	00000097          	auipc	ra,0x0
    80001824:	f4a080e7          	jalr	-182(ra) # 8000176a <wakeup>
    80001828:	b7d5                	j	8000180c <reparent+0x2c>
}
    8000182a:	70a2                	ld	ra,40(sp)
    8000182c:	7402                	ld	s0,32(sp)
    8000182e:	64e2                	ld	s1,24(sp)
    80001830:	6942                	ld	s2,16(sp)
    80001832:	69a2                	ld	s3,8(sp)
    80001834:	6a02                	ld	s4,0(sp)
    80001836:	6145                	addi	sp,sp,48
    80001838:	8082                	ret

000000008000183a <exit>:
{
    8000183a:	7179                	addi	sp,sp,-48
    8000183c:	f406                	sd	ra,40(sp)
    8000183e:	f022                	sd	s0,32(sp)
    80001840:	ec26                	sd	s1,24(sp)
    80001842:	e84a                	sd	s2,16(sp)
    80001844:	e44e                	sd	s3,8(sp)
    80001846:	e052                	sd	s4,0(sp)
    80001848:	1800                	addi	s0,sp,48
    8000184a:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000184c:	fffff097          	auipc	ra,0xfffff
    80001850:	6d6080e7          	jalr	1750(ra) # 80000f22 <myproc>
    80001854:	89aa                	mv	s3,a0
  if(p == initproc)
    80001856:	00007797          	auipc	a5,0x7
    8000185a:	7ba7b783          	ld	a5,1978(a5) # 80009010 <initproc>
    8000185e:	0d050493          	addi	s1,a0,208
    80001862:	15050913          	addi	s2,a0,336
    80001866:	02a79363          	bne	a5,a0,8000188c <exit+0x52>
    panic("init exiting");
    8000186a:	00007517          	auipc	a0,0x7
    8000186e:	9c650513          	addi	a0,a0,-1594 # 80008230 <etext+0x230>
    80001872:	00004097          	auipc	ra,0x4
    80001876:	4a6080e7          	jalr	1190(ra) # 80005d18 <panic>
      fileclose(f);
    8000187a:	00002097          	auipc	ra,0x2
    8000187e:	290080e7          	jalr	656(ra) # 80003b0a <fileclose>
      p->ofile[fd] = 0;
    80001882:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001886:	04a1                	addi	s1,s1,8
    80001888:	01248563          	beq	s1,s2,80001892 <exit+0x58>
    if(p->ofile[fd]){
    8000188c:	6088                	ld	a0,0(s1)
    8000188e:	f575                	bnez	a0,8000187a <exit+0x40>
    80001890:	bfdd                	j	80001886 <exit+0x4c>
  begin_op();
    80001892:	00002097          	auipc	ra,0x2
    80001896:	dac080e7          	jalr	-596(ra) # 8000363e <begin_op>
  iput(p->cwd);
    8000189a:	1509b503          	ld	a0,336(s3)
    8000189e:	00001097          	auipc	ra,0x1
    800018a2:	588080e7          	jalr	1416(ra) # 80002e26 <iput>
  end_op();
    800018a6:	00002097          	auipc	ra,0x2
    800018aa:	e18080e7          	jalr	-488(ra) # 800036be <end_op>
  p->cwd = 0;
    800018ae:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800018b2:	00027497          	auipc	s1,0x27
    800018b6:	7b648493          	addi	s1,s1,1974 # 80029068 <wait_lock>
    800018ba:	8526                	mv	a0,s1
    800018bc:	00005097          	auipc	ra,0x5
    800018c0:	9a6080e7          	jalr	-1626(ra) # 80006262 <acquire>
  reparent(p);
    800018c4:	854e                	mv	a0,s3
    800018c6:	00000097          	auipc	ra,0x0
    800018ca:	f1a080e7          	jalr	-230(ra) # 800017e0 <reparent>
  wakeup(p->parent);
    800018ce:	0389b503          	ld	a0,56(s3)
    800018d2:	00000097          	auipc	ra,0x0
    800018d6:	e98080e7          	jalr	-360(ra) # 8000176a <wakeup>
  acquire(&p->lock);
    800018da:	854e                	mv	a0,s3
    800018dc:	00005097          	auipc	ra,0x5
    800018e0:	986080e7          	jalr	-1658(ra) # 80006262 <acquire>
  p->xstate = status;
    800018e4:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800018e8:	4795                	li	a5,5
    800018ea:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800018ee:	8526                	mv	a0,s1
    800018f0:	00005097          	auipc	ra,0x5
    800018f4:	a26080e7          	jalr	-1498(ra) # 80006316 <release>
  sched();
    800018f8:	00000097          	auipc	ra,0x0
    800018fc:	bd4080e7          	jalr	-1068(ra) # 800014cc <sched>
  panic("zombie exit");
    80001900:	00007517          	auipc	a0,0x7
    80001904:	94050513          	addi	a0,a0,-1728 # 80008240 <etext+0x240>
    80001908:	00004097          	auipc	ra,0x4
    8000190c:	410080e7          	jalr	1040(ra) # 80005d18 <panic>

0000000080001910 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001910:	7179                	addi	sp,sp,-48
    80001912:	f406                	sd	ra,40(sp)
    80001914:	f022                	sd	s0,32(sp)
    80001916:	ec26                	sd	s1,24(sp)
    80001918:	e84a                	sd	s2,16(sp)
    8000191a:	e44e                	sd	s3,8(sp)
    8000191c:	1800                	addi	s0,sp,48
    8000191e:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001920:	00028497          	auipc	s1,0x28
    80001924:	b6048493          	addi	s1,s1,-1184 # 80029480 <proc>
    80001928:	0002d997          	auipc	s3,0x2d
    8000192c:	55898993          	addi	s3,s3,1368 # 8002ee80 <tickslock>
    acquire(&p->lock);
    80001930:	8526                	mv	a0,s1
    80001932:	00005097          	auipc	ra,0x5
    80001936:	930080e7          	jalr	-1744(ra) # 80006262 <acquire>
    if(p->pid == pid){
    8000193a:	589c                	lw	a5,48(s1)
    8000193c:	01278d63          	beq	a5,s2,80001956 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001940:	8526                	mv	a0,s1
    80001942:	00005097          	auipc	ra,0x5
    80001946:	9d4080e7          	jalr	-1580(ra) # 80006316 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000194a:	16848493          	addi	s1,s1,360
    8000194e:	ff3491e3          	bne	s1,s3,80001930 <kill+0x20>
  }
  return -1;
    80001952:	557d                	li	a0,-1
    80001954:	a829                	j	8000196e <kill+0x5e>
      p->killed = 1;
    80001956:	4785                	li	a5,1
    80001958:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000195a:	4c98                	lw	a4,24(s1)
    8000195c:	4789                	li	a5,2
    8000195e:	00f70f63          	beq	a4,a5,8000197c <kill+0x6c>
      release(&p->lock);
    80001962:	8526                	mv	a0,s1
    80001964:	00005097          	auipc	ra,0x5
    80001968:	9b2080e7          	jalr	-1614(ra) # 80006316 <release>
      return 0;
    8000196c:	4501                	li	a0,0
}
    8000196e:	70a2                	ld	ra,40(sp)
    80001970:	7402                	ld	s0,32(sp)
    80001972:	64e2                	ld	s1,24(sp)
    80001974:	6942                	ld	s2,16(sp)
    80001976:	69a2                	ld	s3,8(sp)
    80001978:	6145                	addi	sp,sp,48
    8000197a:	8082                	ret
        p->state = RUNNABLE;
    8000197c:	478d                	li	a5,3
    8000197e:	cc9c                	sw	a5,24(s1)
    80001980:	b7cd                	j	80001962 <kill+0x52>

0000000080001982 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001982:	7179                	addi	sp,sp,-48
    80001984:	f406                	sd	ra,40(sp)
    80001986:	f022                	sd	s0,32(sp)
    80001988:	ec26                	sd	s1,24(sp)
    8000198a:	e84a                	sd	s2,16(sp)
    8000198c:	e44e                	sd	s3,8(sp)
    8000198e:	e052                	sd	s4,0(sp)
    80001990:	1800                	addi	s0,sp,48
    80001992:	84aa                	mv	s1,a0
    80001994:	892e                	mv	s2,a1
    80001996:	89b2                	mv	s3,a2
    80001998:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000199a:	fffff097          	auipc	ra,0xfffff
    8000199e:	588080e7          	jalr	1416(ra) # 80000f22 <myproc>
  if(user_dst){
    800019a2:	c08d                	beqz	s1,800019c4 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800019a4:	86d2                	mv	a3,s4
    800019a6:	864e                	mv	a2,s3
    800019a8:	85ca                	mv	a1,s2
    800019aa:	6928                	ld	a0,80(a0)
    800019ac:	fffff097          	auipc	ra,0xfffff
    800019b0:	238080e7          	jalr	568(ra) # 80000be4 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800019b4:	70a2                	ld	ra,40(sp)
    800019b6:	7402                	ld	s0,32(sp)
    800019b8:	64e2                	ld	s1,24(sp)
    800019ba:	6942                	ld	s2,16(sp)
    800019bc:	69a2                	ld	s3,8(sp)
    800019be:	6a02                	ld	s4,0(sp)
    800019c0:	6145                	addi	sp,sp,48
    800019c2:	8082                	ret
    memmove((char *)dst, src, len);
    800019c4:	000a061b          	sext.w	a2,s4
    800019c8:	85ce                	mv	a1,s3
    800019ca:	854a                	mv	a0,s2
    800019cc:	fffff097          	auipc	ra,0xfffff
    800019d0:	8a6080e7          	jalr	-1882(ra) # 80000272 <memmove>
    return 0;
    800019d4:	8526                	mv	a0,s1
    800019d6:	bff9                	j	800019b4 <either_copyout+0x32>

00000000800019d8 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800019d8:	7179                	addi	sp,sp,-48
    800019da:	f406                	sd	ra,40(sp)
    800019dc:	f022                	sd	s0,32(sp)
    800019de:	ec26                	sd	s1,24(sp)
    800019e0:	e84a                	sd	s2,16(sp)
    800019e2:	e44e                	sd	s3,8(sp)
    800019e4:	e052                	sd	s4,0(sp)
    800019e6:	1800                	addi	s0,sp,48
    800019e8:	892a                	mv	s2,a0
    800019ea:	84ae                	mv	s1,a1
    800019ec:	89b2                	mv	s3,a2
    800019ee:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019f0:	fffff097          	auipc	ra,0xfffff
    800019f4:	532080e7          	jalr	1330(ra) # 80000f22 <myproc>
  if(user_src){
    800019f8:	c08d                	beqz	s1,80001a1a <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800019fa:	86d2                	mv	a3,s4
    800019fc:	864e                	mv	a2,s3
    800019fe:	85ca                	mv	a1,s2
    80001a00:	6928                	ld	a0,80(a0)
    80001a02:	fffff097          	auipc	ra,0xfffff
    80001a06:	26e080e7          	jalr	622(ra) # 80000c70 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001a0a:	70a2                	ld	ra,40(sp)
    80001a0c:	7402                	ld	s0,32(sp)
    80001a0e:	64e2                	ld	s1,24(sp)
    80001a10:	6942                	ld	s2,16(sp)
    80001a12:	69a2                	ld	s3,8(sp)
    80001a14:	6a02                	ld	s4,0(sp)
    80001a16:	6145                	addi	sp,sp,48
    80001a18:	8082                	ret
    memmove(dst, (char*)src, len);
    80001a1a:	000a061b          	sext.w	a2,s4
    80001a1e:	85ce                	mv	a1,s3
    80001a20:	854a                	mv	a0,s2
    80001a22:	fffff097          	auipc	ra,0xfffff
    80001a26:	850080e7          	jalr	-1968(ra) # 80000272 <memmove>
    return 0;
    80001a2a:	8526                	mv	a0,s1
    80001a2c:	bff9                	j	80001a0a <either_copyin+0x32>

0000000080001a2e <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001a2e:	715d                	addi	sp,sp,-80
    80001a30:	e486                	sd	ra,72(sp)
    80001a32:	e0a2                	sd	s0,64(sp)
    80001a34:	fc26                	sd	s1,56(sp)
    80001a36:	f84a                	sd	s2,48(sp)
    80001a38:	f44e                	sd	s3,40(sp)
    80001a3a:	f052                	sd	s4,32(sp)
    80001a3c:	ec56                	sd	s5,24(sp)
    80001a3e:	e85a                	sd	s6,16(sp)
    80001a40:	e45e                	sd	s7,8(sp)
    80001a42:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001a44:	00006517          	auipc	a0,0x6
    80001a48:	65450513          	addi	a0,a0,1620 # 80008098 <etext+0x98>
    80001a4c:	00004097          	auipc	ra,0x4
    80001a50:	316080e7          	jalr	790(ra) # 80005d62 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a54:	00028497          	auipc	s1,0x28
    80001a58:	b8448493          	addi	s1,s1,-1148 # 800295d8 <proc+0x158>
    80001a5c:	0002d917          	auipc	s2,0x2d
    80001a60:	57c90913          	addi	s2,s2,1404 # 8002efd8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a64:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001a66:	00006997          	auipc	s3,0x6
    80001a6a:	7ea98993          	addi	s3,s3,2026 # 80008250 <etext+0x250>
    printf("%d %s %s", p->pid, state, p->name);
    80001a6e:	00006a97          	auipc	s5,0x6
    80001a72:	7eaa8a93          	addi	s5,s5,2026 # 80008258 <etext+0x258>
    printf("\n");
    80001a76:	00006a17          	auipc	s4,0x6
    80001a7a:	622a0a13          	addi	s4,s4,1570 # 80008098 <etext+0x98>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a7e:	00007b97          	auipc	s7,0x7
    80001a82:	812b8b93          	addi	s7,s7,-2030 # 80008290 <states.1714>
    80001a86:	a00d                	j	80001aa8 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a88:	ed86a583          	lw	a1,-296(a3)
    80001a8c:	8556                	mv	a0,s5
    80001a8e:	00004097          	auipc	ra,0x4
    80001a92:	2d4080e7          	jalr	724(ra) # 80005d62 <printf>
    printf("\n");
    80001a96:	8552                	mv	a0,s4
    80001a98:	00004097          	auipc	ra,0x4
    80001a9c:	2ca080e7          	jalr	714(ra) # 80005d62 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001aa0:	16848493          	addi	s1,s1,360
    80001aa4:	03248163          	beq	s1,s2,80001ac6 <procdump+0x98>
    if(p->state == UNUSED)
    80001aa8:	86a6                	mv	a3,s1
    80001aaa:	ec04a783          	lw	a5,-320(s1)
    80001aae:	dbed                	beqz	a5,80001aa0 <procdump+0x72>
      state = "???";
    80001ab0:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ab2:	fcfb6be3          	bltu	s6,a5,80001a88 <procdump+0x5a>
    80001ab6:	1782                	slli	a5,a5,0x20
    80001ab8:	9381                	srli	a5,a5,0x20
    80001aba:	078e                	slli	a5,a5,0x3
    80001abc:	97de                	add	a5,a5,s7
    80001abe:	6390                	ld	a2,0(a5)
    80001ac0:	f661                	bnez	a2,80001a88 <procdump+0x5a>
      state = "???";
    80001ac2:	864e                	mv	a2,s3
    80001ac4:	b7d1                	j	80001a88 <procdump+0x5a>
  }
}
    80001ac6:	60a6                	ld	ra,72(sp)
    80001ac8:	6406                	ld	s0,64(sp)
    80001aca:	74e2                	ld	s1,56(sp)
    80001acc:	7942                	ld	s2,48(sp)
    80001ace:	79a2                	ld	s3,40(sp)
    80001ad0:	7a02                	ld	s4,32(sp)
    80001ad2:	6ae2                	ld	s5,24(sp)
    80001ad4:	6b42                	ld	s6,16(sp)
    80001ad6:	6ba2                	ld	s7,8(sp)
    80001ad8:	6161                	addi	sp,sp,80
    80001ada:	8082                	ret

0000000080001adc <swtch>:
    80001adc:	00153023          	sd	ra,0(a0)
    80001ae0:	00253423          	sd	sp,8(a0)
    80001ae4:	e900                	sd	s0,16(a0)
    80001ae6:	ed04                	sd	s1,24(a0)
    80001ae8:	03253023          	sd	s2,32(a0)
    80001aec:	03353423          	sd	s3,40(a0)
    80001af0:	03453823          	sd	s4,48(a0)
    80001af4:	03553c23          	sd	s5,56(a0)
    80001af8:	05653023          	sd	s6,64(a0)
    80001afc:	05753423          	sd	s7,72(a0)
    80001b00:	05853823          	sd	s8,80(a0)
    80001b04:	05953c23          	sd	s9,88(a0)
    80001b08:	07a53023          	sd	s10,96(a0)
    80001b0c:	07b53423          	sd	s11,104(a0)
    80001b10:	0005b083          	ld	ra,0(a1)
    80001b14:	0085b103          	ld	sp,8(a1)
    80001b18:	6980                	ld	s0,16(a1)
    80001b1a:	6d84                	ld	s1,24(a1)
    80001b1c:	0205b903          	ld	s2,32(a1)
    80001b20:	0285b983          	ld	s3,40(a1)
    80001b24:	0305ba03          	ld	s4,48(a1)
    80001b28:	0385ba83          	ld	s5,56(a1)
    80001b2c:	0405bb03          	ld	s6,64(a1)
    80001b30:	0485bb83          	ld	s7,72(a1)
    80001b34:	0505bc03          	ld	s8,80(a1)
    80001b38:	0585bc83          	ld	s9,88(a1)
    80001b3c:	0605bd03          	ld	s10,96(a1)
    80001b40:	0685bd83          	ld	s11,104(a1)
    80001b44:	8082                	ret

0000000080001b46 <trapinit>:
void kernelvec();

extern int devintr();

void trapinit(void)
{
    80001b46:	1141                	addi	sp,sp,-16
    80001b48:	e406                	sd	ra,8(sp)
    80001b4a:	e022                	sd	s0,0(sp)
    80001b4c:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b4e:	00006597          	auipc	a1,0x6
    80001b52:	77258593          	addi	a1,a1,1906 # 800082c0 <states.1714+0x30>
    80001b56:	0002d517          	auipc	a0,0x2d
    80001b5a:	32a50513          	addi	a0,a0,810 # 8002ee80 <tickslock>
    80001b5e:	00004097          	auipc	ra,0x4
    80001b62:	674080e7          	jalr	1652(ra) # 800061d2 <initlock>
}
    80001b66:	60a2                	ld	ra,8(sp)
    80001b68:	6402                	ld	s0,0(sp)
    80001b6a:	0141                	addi	sp,sp,16
    80001b6c:	8082                	ret

0000000080001b6e <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    80001b6e:	1141                	addi	sp,sp,-16
    80001b70:	e422                	sd	s0,8(sp)
    80001b72:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r"(x));
    80001b74:	00003797          	auipc	a5,0x3
    80001b78:	5ac78793          	addi	a5,a5,1452 # 80005120 <kernelvec>
    80001b7c:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b80:	6422                	ld	s0,8(sp)
    80001b82:	0141                	addi	sp,sp,16
    80001b84:	8082                	ret

0000000080001b86 <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    80001b86:	1141                	addi	sp,sp,-16
    80001b88:	e406                	sd	ra,8(sp)
    80001b8a:	e022                	sd	s0,0(sp)
    80001b8c:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b8e:	fffff097          	auipc	ra,0xfffff
    80001b92:	394080e7          	jalr	916(ra) # 80000f22 <myproc>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001b96:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b9a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001b9c:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001ba0:	00005617          	auipc	a2,0x5
    80001ba4:	46060613          	addi	a2,a2,1120 # 80007000 <_trampoline>
    80001ba8:	00005697          	auipc	a3,0x5
    80001bac:	45868693          	addi	a3,a3,1112 # 80007000 <_trampoline>
    80001bb0:	8e91                	sub	a3,a3,a2
    80001bb2:	040007b7          	lui	a5,0x4000
    80001bb6:	17fd                	addi	a5,a5,-1
    80001bb8:	07b2                	slli	a5,a5,0xc
    80001bba:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r"(x));
    80001bbc:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001bc0:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r"(x));
    80001bc2:	180026f3          	csrr	a3,satp
    80001bc6:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001bc8:	6d38                	ld	a4,88(a0)
    80001bca:	6134                	ld	a3,64(a0)
    80001bcc:	6585                	lui	a1,0x1
    80001bce:	96ae                	add	a3,a3,a1
    80001bd0:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001bd2:	6d38                	ld	a4,88(a0)
    80001bd4:	00000697          	auipc	a3,0x0
    80001bd8:	13868693          	addi	a3,a3,312 # 80001d0c <usertrap>
    80001bdc:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80001bde:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r"(x));
    80001be0:	8692                	mv	a3,tp
    80001be2:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001be4:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001be8:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001bec:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001bf0:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001bf4:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r"(x));
    80001bf6:	6f18                	ld	a4,24(a4)
    80001bf8:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001bfc:	692c                	ld	a1,80(a0)
    80001bfe:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001c00:	00005717          	auipc	a4,0x5
    80001c04:	49070713          	addi	a4,a4,1168 # 80007090 <userret>
    80001c08:	8f11                	sub	a4,a4,a2
    80001c0a:	97ba                	add	a5,a5,a4
  ((void (*)(uint64, uint64))fn)(TRAPFRAME, satp);
    80001c0c:	577d                	li	a4,-1
    80001c0e:	177e                	slli	a4,a4,0x3f
    80001c10:	8dd9                	or	a1,a1,a4
    80001c12:	02000537          	lui	a0,0x2000
    80001c16:	157d                	addi	a0,a0,-1
    80001c18:	0536                	slli	a0,a0,0xd
    80001c1a:	9782                	jalr	a5
}
    80001c1c:	60a2                	ld	ra,8(sp)
    80001c1e:	6402                	ld	s0,0(sp)
    80001c20:	0141                	addi	sp,sp,16
    80001c22:	8082                	ret

0000000080001c24 <clockintr>:
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr()
{
    80001c24:	1101                	addi	sp,sp,-32
    80001c26:	ec06                	sd	ra,24(sp)
    80001c28:	e822                	sd	s0,16(sp)
    80001c2a:	e426                	sd	s1,8(sp)
    80001c2c:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c2e:	0002d497          	auipc	s1,0x2d
    80001c32:	25248493          	addi	s1,s1,594 # 8002ee80 <tickslock>
    80001c36:	8526                	mv	a0,s1
    80001c38:	00004097          	auipc	ra,0x4
    80001c3c:	62a080e7          	jalr	1578(ra) # 80006262 <acquire>
  ticks++;
    80001c40:	00007517          	auipc	a0,0x7
    80001c44:	3d850513          	addi	a0,a0,984 # 80009018 <ticks>
    80001c48:	411c                	lw	a5,0(a0)
    80001c4a:	2785                	addiw	a5,a5,1
    80001c4c:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c4e:	00000097          	auipc	ra,0x0
    80001c52:	b1c080e7          	jalr	-1252(ra) # 8000176a <wakeup>
  release(&tickslock);
    80001c56:	8526                	mv	a0,s1
    80001c58:	00004097          	auipc	ra,0x4
    80001c5c:	6be080e7          	jalr	1726(ra) # 80006316 <release>
}
    80001c60:	60e2                	ld	ra,24(sp)
    80001c62:	6442                	ld	s0,16(sp)
    80001c64:	64a2                	ld	s1,8(sp)
    80001c66:	6105                	addi	sp,sp,32
    80001c68:	8082                	ret

0000000080001c6a <devintr>:
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int devintr()
{
    80001c6a:	1101                	addi	sp,sp,-32
    80001c6c:	ec06                	sd	ra,24(sp)
    80001c6e:	e822                	sd	s0,16(sp)
    80001c70:	e426                	sd	s1,8(sp)
    80001c72:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r"(x));
    80001c74:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if ((scause & 0x8000000000000000L) &&
    80001c78:	00074d63          	bltz	a4,80001c92 <devintr+0x28>
    if (irq)
      plic_complete(irq);

    return 1;
  }
  else if (scause == 0x8000000000000001L)
    80001c7c:	57fd                	li	a5,-1
    80001c7e:	17fe                	slli	a5,a5,0x3f
    80001c80:	0785                	addi	a5,a5,1

    return 2;
  }
  else
  {
    return 0;
    80001c82:	4501                	li	a0,0
  else if (scause == 0x8000000000000001L)
    80001c84:	06f70363          	beq	a4,a5,80001cea <devintr+0x80>
  }
}
    80001c88:	60e2                	ld	ra,24(sp)
    80001c8a:	6442                	ld	s0,16(sp)
    80001c8c:	64a2                	ld	s1,8(sp)
    80001c8e:	6105                	addi	sp,sp,32
    80001c90:	8082                	ret
      (scause & 0xff) == 9)
    80001c92:	0ff77793          	andi	a5,a4,255
  if ((scause & 0x8000000000000000L) &&
    80001c96:	46a5                	li	a3,9
    80001c98:	fed792e3          	bne	a5,a3,80001c7c <devintr+0x12>
    int irq = plic_claim();
    80001c9c:	00003097          	auipc	ra,0x3
    80001ca0:	58c080e7          	jalr	1420(ra) # 80005228 <plic_claim>
    80001ca4:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ)
    80001ca6:	47a9                	li	a5,10
    80001ca8:	02f50763          	beq	a0,a5,80001cd6 <devintr+0x6c>
    else if (irq == VIRTIO0_IRQ)
    80001cac:	4785                	li	a5,1
    80001cae:	02f50963          	beq	a0,a5,80001ce0 <devintr+0x76>
    return 1;
    80001cb2:	4505                	li	a0,1
    else if (irq)
    80001cb4:	d8f1                	beqz	s1,80001c88 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001cb6:	85a6                	mv	a1,s1
    80001cb8:	00006517          	auipc	a0,0x6
    80001cbc:	61050513          	addi	a0,a0,1552 # 800082c8 <states.1714+0x38>
    80001cc0:	00004097          	auipc	ra,0x4
    80001cc4:	0a2080e7          	jalr	162(ra) # 80005d62 <printf>
      plic_complete(irq);
    80001cc8:	8526                	mv	a0,s1
    80001cca:	00003097          	auipc	ra,0x3
    80001cce:	582080e7          	jalr	1410(ra) # 8000524c <plic_complete>
    return 1;
    80001cd2:	4505                	li	a0,1
    80001cd4:	bf55                	j	80001c88 <devintr+0x1e>
      uartintr();
    80001cd6:	00004097          	auipc	ra,0x4
    80001cda:	4ac080e7          	jalr	1196(ra) # 80006182 <uartintr>
    80001cde:	b7ed                	j	80001cc8 <devintr+0x5e>
      virtio_disk_intr();
    80001ce0:	00004097          	auipc	ra,0x4
    80001ce4:	a4c080e7          	jalr	-1460(ra) # 8000572c <virtio_disk_intr>
    80001ce8:	b7c5                	j	80001cc8 <devintr+0x5e>
    if (cpuid() == 0)
    80001cea:	fffff097          	auipc	ra,0xfffff
    80001cee:	20c080e7          	jalr	524(ra) # 80000ef6 <cpuid>
    80001cf2:	c901                	beqz	a0,80001d02 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r"(x));
    80001cf4:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001cf8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r"(x));
    80001cfa:	14479073          	csrw	sip,a5
    return 2;
    80001cfe:	4509                	li	a0,2
    80001d00:	b761                	j	80001c88 <devintr+0x1e>
      clockintr();
    80001d02:	00000097          	auipc	ra,0x0
    80001d06:	f22080e7          	jalr	-222(ra) # 80001c24 <clockintr>
    80001d0a:	b7ed                	j	80001cf4 <devintr+0x8a>

0000000080001d0c <usertrap>:
{
    80001d0c:	7139                	addi	sp,sp,-64
    80001d0e:	fc06                	sd	ra,56(sp)
    80001d10:	f822                	sd	s0,48(sp)
    80001d12:	f426                	sd	s1,40(sp)
    80001d14:	f04a                	sd	s2,32(sp)
    80001d16:	ec4e                	sd	s3,24(sp)
    80001d18:	e852                	sd	s4,16(sp)
    80001d1a:	e456                	sd	s5,8(sp)
    80001d1c:	0080                	addi	s0,sp,64
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001d1e:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    80001d22:	1007f793          	andi	a5,a5,256
    80001d26:	e7a9                	bnez	a5,80001d70 <usertrap+0x64>
  asm volatile("csrw stvec, %0" : : "r"(x));
    80001d28:	00003797          	auipc	a5,0x3
    80001d2c:	3f878793          	addi	a5,a5,1016 # 80005120 <kernelvec>
    80001d30:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d34:	fffff097          	auipc	ra,0xfffff
    80001d38:	1ee080e7          	jalr	494(ra) # 80000f22 <myproc>
    80001d3c:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d3e:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001d40:	14102773          	csrr	a4,sepc
    80001d44:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r"(x));
    80001d46:	14202773          	csrr	a4,scause
  if (r_scause() == 8)
    80001d4a:	47a1                	li	a5,8
    80001d4c:	02f70a63          	beq	a4,a5,80001d80 <usertrap+0x74>
    80001d50:	14202773          	csrr	a4,scause
  else if (r_scause() == 15)
    80001d54:	47bd                	li	a5,15
    80001d56:	06f70063          	beq	a4,a5,80001db6 <usertrap+0xaa>
  else if ((which_dev = devintr()) != 0)
    80001d5a:	00000097          	auipc	ra,0x0
    80001d5e:	f10080e7          	jalr	-240(ra) # 80001c6a <devintr>
    80001d62:	892a                	mv	s2,a0
    80001d64:	16050063          	beqz	a0,80001ec4 <usertrap+0x1b8>
  if (p->killed)
    80001d68:	549c                	lw	a5,40(s1)
    80001d6a:	18078c63          	beqz	a5,80001f02 <usertrap+0x1f6>
    80001d6e:	a269                	j	80001ef8 <usertrap+0x1ec>
    panic("usertrap: not from user mode");
    80001d70:	00006517          	auipc	a0,0x6
    80001d74:	57850513          	addi	a0,a0,1400 # 800082e8 <states.1714+0x58>
    80001d78:	00004097          	auipc	ra,0x4
    80001d7c:	fa0080e7          	jalr	-96(ra) # 80005d18 <panic>
    if (p->killed)
    80001d80:	551c                	lw	a5,40(a0)
    80001d82:	e785                	bnez	a5,80001daa <usertrap+0x9e>
    p->trapframe->epc += 4;
    80001d84:	6cb8                	ld	a4,88(s1)
    80001d86:	6f1c                	ld	a5,24(a4)
    80001d88:	0791                	addi	a5,a5,4
    80001d8a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001d8c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d90:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001d94:	10079073          	csrw	sstatus,a5
    syscall();
    80001d98:	00000097          	auipc	ra,0x0
    80001d9c:	3d6080e7          	jalr	982(ra) # 8000216e <syscall>
  if (p->killed)
    80001da0:	549c                	lw	a5,40(s1)
    80001da2:	16078363          	beqz	a5,80001f08 <usertrap+0x1fc>
    80001da6:	4901                	li	s2,0
    80001da8:	aa81                	j	80001ef8 <usertrap+0x1ec>
      exit(-1);
    80001daa:	557d                	li	a0,-1
    80001dac:	00000097          	auipc	ra,0x0
    80001db0:	a8e080e7          	jalr	-1394(ra) # 8000183a <exit>
    80001db4:	bfc1                	j	80001d84 <usertrap+0x78>
  asm volatile("csrr %0, stval" : "=r"(x));
    80001db6:	143029f3          	csrr	s3,stval
    uint64 va = PGROUNDDOWN(r_stval());
    80001dba:	77fd                	lui	a5,0xfffff
    80001dbc:	00f9f9b3          	and	s3,s3,a5
    if ((pte = walk(p->pagetable, va, 0)) == 0 || !(*pte & PTE_V))
    80001dc0:	4601                	li	a2,0
    80001dc2:	85ce                	mv	a1,s3
    80001dc4:	6928                	ld	a0,80(a0)
    80001dc6:	ffffe097          	auipc	ra,0xffffe
    80001dca:	734080e7          	jalr	1844(ra) # 800004fa <walk>
    80001dce:	892a                	mv	s2,a0
    80001dd0:	c509                	beqz	a0,80001dda <usertrap+0xce>
    80001dd2:	611c                	ld	a5,0(a0)
    80001dd4:	0017f713          	andi	a4,a5,1
    80001dd8:	ef01                	bnez	a4,80001df0 <usertrap+0xe4>
      printf("usertrap: page not present\n");
    80001dda:	00006517          	auipc	a0,0x6
    80001dde:	52e50513          	addi	a0,a0,1326 # 80008308 <states.1714+0x78>
    80001de2:	00004097          	auipc	ra,0x4
    80001de6:	f80080e7          	jalr	-128(ra) # 80005d62 <printf>
      p->killed = 1;
    80001dea:	4785                	li	a5,1
    80001dec:	d49c                	sw	a5,40(s1)
    80001dee:	a221                	j	80001ef6 <usertrap+0x1ea>
    else if ((*pte & PTE_COW) && !(*pte & PTE_W))
    80001df0:	1047f793          	andi	a5,a5,260
    80001df4:	10000713          	li	a4,256
    80001df8:	00e78e63          	beq	a5,a4,80001e14 <usertrap+0x108>
      printf("Non-COW page fault at 0x%p\n", va);
    80001dfc:	85ce                	mv	a1,s3
    80001dfe:	00006517          	auipc	a0,0x6
    80001e02:	56250513          	addi	a0,a0,1378 # 80008360 <states.1714+0xd0>
    80001e06:	00004097          	auipc	ra,0x4
    80001e0a:	f5c080e7          	jalr	-164(ra) # 80005d62 <printf>
      p->killed = 1;
    80001e0e:	4785                	li	a5,1
    80001e10:	d49c                	sw	a5,40(s1)
    80001e12:	a0d5                	j	80001ef6 <usertrap+0x1ea>
      printf("COW page fault at va 0x%p\n", va);
    80001e14:	85ce                	mv	a1,s3
    80001e16:	00006517          	auipc	a0,0x6
    80001e1a:	51250513          	addi	a0,a0,1298 # 80008328 <states.1714+0x98>
    80001e1e:	00004097          	auipc	ra,0x4
    80001e22:	f44080e7          	jalr	-188(ra) # 80005d62 <printf>
      uint64 pa = PTE2PA(*pte);
    80001e26:	00093a83          	ld	s5,0(s2)
      void *new_page = kalloc();
    80001e2a:	ffffe097          	auipc	ra,0xffffe
    80001e2e:	352080e7          	jalr	850(ra) # 8000017c <kalloc>
    80001e32:	89aa                	mv	s3,a0
      if (new_page == 0)
    80001e34:	c53d                	beqz	a0,80001ea2 <usertrap+0x196>
      uint64 pa = PTE2PA(*pte);
    80001e36:	00aada13          	srli	s4,s5,0xa
    80001e3a:	0a32                	slli	s4,s4,0xc
        memmove(new_page, (void *)pa, PGSIZE);
    80001e3c:	6605                	lui	a2,0x1
    80001e3e:	85d2                	mv	a1,s4
    80001e40:	ffffe097          	auipc	ra,0xffffe
    80001e44:	432080e7          	jalr	1074(ra) # 80000272 <memmove>
        *pte = PA2PTE(new_pa) | flags;
    80001e48:	00c9d793          	srli	a5,s3,0xc
    80001e4c:	07aa                	slli	a5,a5,0xa
        flags = (flags | PTE_W) & ~PTE_COW;
    80001e4e:	2ffafa93          	andi	s5,s5,767
        *pte = PA2PTE(new_pa) | flags;
    80001e52:	004aea93          	ori	s5,s5,4
    80001e56:	0157e7b3          	or	a5,a5,s5
    80001e5a:	00f93023          	sd	a5,0(s2)
        int index = REFCOUNT_INDEX(pa);
    80001e5e:	800007b7          	lui	a5,0x80000
    80001e62:	97d2                	add	a5,a5,s4
    80001e64:	83b1                	srli	a5,a5,0xc
    80001e66:	2781                	sext.w	a5,a5
        if (ref_count[index] > 0)
    80001e68:	00279693          	slli	a3,a5,0x2
    80001e6c:	00007717          	auipc	a4,0x7
    80001e70:	1e470713          	addi	a4,a4,484 # 80009050 <ref_count>
    80001e74:	9736                	add	a4,a4,a3
    80001e76:	4318                	lw	a4,0(a4)
    80001e78:	00e05a63          	blez	a4,80001e8c <usertrap+0x180>
          ref_count[index]--;
    80001e7c:	8636                	mv	a2,a3
    80001e7e:	00007697          	auipc	a3,0x7
    80001e82:	1d268693          	addi	a3,a3,466 # 80009050 <ref_count>
    80001e86:	96b2                	add	a3,a3,a2
    80001e88:	377d                	addiw	a4,a4,-1
    80001e8a:	c298                	sw	a4,0(a3)
        if (ref_count[index] == 0)
    80001e8c:	078a                	slli	a5,a5,0x2
    80001e8e:	00007717          	auipc	a4,0x7
    80001e92:	1c270713          	addi	a4,a4,450 # 80009050 <ref_count>
    80001e96:	97ba                	add	a5,a5,a4
    80001e98:	439c                	lw	a5,0(a5)
    80001e9a:	cf99                	beqz	a5,80001eb8 <usertrap+0x1ac>
  asm volatile("sfence.vma zero, zero");
    80001e9c:	12000073          	sfence.vma
}
    80001ea0:	b701                	j	80001da0 <usertrap+0x94>
        printf("COW: kalloc failed\n");
    80001ea2:	00006517          	auipc	a0,0x6
    80001ea6:	4a650513          	addi	a0,a0,1190 # 80008348 <states.1714+0xb8>
    80001eaa:	00004097          	auipc	ra,0x4
    80001eae:	eb8080e7          	jalr	-328(ra) # 80005d62 <printf>
        p->killed = 1;
    80001eb2:	4785                	li	a5,1
    80001eb4:	d49c                	sw	a5,40(s1)
    80001eb6:	a081                	j	80001ef6 <usertrap+0x1ea>
          kfree((void *)pa);
    80001eb8:	8552                	mv	a0,s4
    80001eba:	ffffe097          	auipc	ra,0xffffe
    80001ebe:	162080e7          	jalr	354(ra) # 8000001c <kfree>
    80001ec2:	bfe9                	j	80001e9c <usertrap+0x190>
  asm volatile("csrr %0, scause" : "=r"(x));
    80001ec4:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001ec8:	5890                	lw	a2,48(s1)
    80001eca:	00006517          	auipc	a0,0x6
    80001ece:	4b650513          	addi	a0,a0,1206 # 80008380 <states.1714+0xf0>
    80001ed2:	00004097          	auipc	ra,0x4
    80001ed6:	e90080e7          	jalr	-368(ra) # 80005d62 <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001eda:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80001ede:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001ee2:	00006517          	auipc	a0,0x6
    80001ee6:	4ce50513          	addi	a0,a0,1230 # 800083b0 <states.1714+0x120>
    80001eea:	00004097          	auipc	ra,0x4
    80001eee:	e78080e7          	jalr	-392(ra) # 80005d62 <printf>
    p->killed = 1;
    80001ef2:	4785                	li	a5,1
    80001ef4:	d49c                	sw	a5,40(s1)
{
    80001ef6:	4901                	li	s2,0
    exit(-1);
    80001ef8:	557d                	li	a0,-1
    80001efa:	00000097          	auipc	ra,0x0
    80001efe:	940080e7          	jalr	-1728(ra) # 8000183a <exit>
  if (which_dev == 2)
    80001f02:	4789                	li	a5,2
    80001f04:	00f90f63          	beq	s2,a5,80001f22 <usertrap+0x216>
  usertrapret();
    80001f08:	00000097          	auipc	ra,0x0
    80001f0c:	c7e080e7          	jalr	-898(ra) # 80001b86 <usertrapret>
}
    80001f10:	70e2                	ld	ra,56(sp)
    80001f12:	7442                	ld	s0,48(sp)
    80001f14:	74a2                	ld	s1,40(sp)
    80001f16:	7902                	ld	s2,32(sp)
    80001f18:	69e2                	ld	s3,24(sp)
    80001f1a:	6a42                	ld	s4,16(sp)
    80001f1c:	6aa2                	ld	s5,8(sp)
    80001f1e:	6121                	addi	sp,sp,64
    80001f20:	8082                	ret
    yield();
    80001f22:	fffff097          	auipc	ra,0xfffff
    80001f26:	680080e7          	jalr	1664(ra) # 800015a2 <yield>
    80001f2a:	bff9                	j	80001f08 <usertrap+0x1fc>

0000000080001f2c <kerneltrap>:
{
    80001f2c:	7179                	addi	sp,sp,-48
    80001f2e:	f406                	sd	ra,40(sp)
    80001f30:	f022                	sd	s0,32(sp)
    80001f32:	ec26                	sd	s1,24(sp)
    80001f34:	e84a                	sd	s2,16(sp)
    80001f36:	e44e                	sd	s3,8(sp)
    80001f38:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001f3a:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001f3e:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r"(x));
    80001f42:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    80001f46:	1004f793          	andi	a5,s1,256
    80001f4a:	cb85                	beqz	a5,80001f7a <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001f4c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f50:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    80001f52:	ef85                	bnez	a5,80001f8a <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0)
    80001f54:	00000097          	auipc	ra,0x0
    80001f58:	d16080e7          	jalr	-746(ra) # 80001c6a <devintr>
    80001f5c:	cd1d                	beqz	a0,80001f9a <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f5e:	4789                	li	a5,2
    80001f60:	06f50a63          	beq	a0,a5,80001fd4 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r"(x));
    80001f64:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001f68:	10049073          	csrw	sstatus,s1
}
    80001f6c:	70a2                	ld	ra,40(sp)
    80001f6e:	7402                	ld	s0,32(sp)
    80001f70:	64e2                	ld	s1,24(sp)
    80001f72:	6942                	ld	s2,16(sp)
    80001f74:	69a2                	ld	s3,8(sp)
    80001f76:	6145                	addi	sp,sp,48
    80001f78:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f7a:	00006517          	auipc	a0,0x6
    80001f7e:	45650513          	addi	a0,a0,1110 # 800083d0 <states.1714+0x140>
    80001f82:	00004097          	auipc	ra,0x4
    80001f86:	d96080e7          	jalr	-618(ra) # 80005d18 <panic>
    panic("kerneltrap: interrupts enabled");
    80001f8a:	00006517          	auipc	a0,0x6
    80001f8e:	46e50513          	addi	a0,a0,1134 # 800083f8 <states.1714+0x168>
    80001f92:	00004097          	auipc	ra,0x4
    80001f96:	d86080e7          	jalr	-634(ra) # 80005d18 <panic>
    printf("scause %p\n", scause);
    80001f9a:	85ce                	mv	a1,s3
    80001f9c:	00006517          	auipc	a0,0x6
    80001fa0:	47c50513          	addi	a0,a0,1148 # 80008418 <states.1714+0x188>
    80001fa4:	00004097          	auipc	ra,0x4
    80001fa8:	dbe080e7          	jalr	-578(ra) # 80005d62 <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001fac:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80001fb0:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001fb4:	00006517          	auipc	a0,0x6
    80001fb8:	47450513          	addi	a0,a0,1140 # 80008428 <states.1714+0x198>
    80001fbc:	00004097          	auipc	ra,0x4
    80001fc0:	da6080e7          	jalr	-602(ra) # 80005d62 <printf>
    panic("kerneltrap");
    80001fc4:	00006517          	auipc	a0,0x6
    80001fc8:	47c50513          	addi	a0,a0,1148 # 80008440 <states.1714+0x1b0>
    80001fcc:	00004097          	auipc	ra,0x4
    80001fd0:	d4c080e7          	jalr	-692(ra) # 80005d18 <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001fd4:	fffff097          	auipc	ra,0xfffff
    80001fd8:	f4e080e7          	jalr	-178(ra) # 80000f22 <myproc>
    80001fdc:	d541                	beqz	a0,80001f64 <kerneltrap+0x38>
    80001fde:	fffff097          	auipc	ra,0xfffff
    80001fe2:	f44080e7          	jalr	-188(ra) # 80000f22 <myproc>
    80001fe6:	4d18                	lw	a4,24(a0)
    80001fe8:	4791                	li	a5,4
    80001fea:	f6f71de3          	bne	a4,a5,80001f64 <kerneltrap+0x38>
    yield();
    80001fee:	fffff097          	auipc	ra,0xfffff
    80001ff2:	5b4080e7          	jalr	1460(ra) # 800015a2 <yield>
    80001ff6:	b7bd                	j	80001f64 <kerneltrap+0x38>

0000000080001ff8 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001ff8:	1101                	addi	sp,sp,-32
    80001ffa:	ec06                	sd	ra,24(sp)
    80001ffc:	e822                	sd	s0,16(sp)
    80001ffe:	e426                	sd	s1,8(sp)
    80002000:	1000                	addi	s0,sp,32
    80002002:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002004:	fffff097          	auipc	ra,0xfffff
    80002008:	f1e080e7          	jalr	-226(ra) # 80000f22 <myproc>
  switch (n) {
    8000200c:	4795                	li	a5,5
    8000200e:	0497e163          	bltu	a5,s1,80002050 <argraw+0x58>
    80002012:	048a                	slli	s1,s1,0x2
    80002014:	00006717          	auipc	a4,0x6
    80002018:	46470713          	addi	a4,a4,1124 # 80008478 <states.1714+0x1e8>
    8000201c:	94ba                	add	s1,s1,a4
    8000201e:	409c                	lw	a5,0(s1)
    80002020:	97ba                	add	a5,a5,a4
    80002022:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002024:	6d3c                	ld	a5,88(a0)
    80002026:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002028:	60e2                	ld	ra,24(sp)
    8000202a:	6442                	ld	s0,16(sp)
    8000202c:	64a2                	ld	s1,8(sp)
    8000202e:	6105                	addi	sp,sp,32
    80002030:	8082                	ret
    return p->trapframe->a1;
    80002032:	6d3c                	ld	a5,88(a0)
    80002034:	7fa8                	ld	a0,120(a5)
    80002036:	bfcd                	j	80002028 <argraw+0x30>
    return p->trapframe->a2;
    80002038:	6d3c                	ld	a5,88(a0)
    8000203a:	63c8                	ld	a0,128(a5)
    8000203c:	b7f5                	j	80002028 <argraw+0x30>
    return p->trapframe->a3;
    8000203e:	6d3c                	ld	a5,88(a0)
    80002040:	67c8                	ld	a0,136(a5)
    80002042:	b7dd                	j	80002028 <argraw+0x30>
    return p->trapframe->a4;
    80002044:	6d3c                	ld	a5,88(a0)
    80002046:	6bc8                	ld	a0,144(a5)
    80002048:	b7c5                	j	80002028 <argraw+0x30>
    return p->trapframe->a5;
    8000204a:	6d3c                	ld	a5,88(a0)
    8000204c:	6fc8                	ld	a0,152(a5)
    8000204e:	bfe9                	j	80002028 <argraw+0x30>
  panic("argraw");
    80002050:	00006517          	auipc	a0,0x6
    80002054:	40050513          	addi	a0,a0,1024 # 80008450 <states.1714+0x1c0>
    80002058:	00004097          	auipc	ra,0x4
    8000205c:	cc0080e7          	jalr	-832(ra) # 80005d18 <panic>

0000000080002060 <fetchaddr>:
{
    80002060:	1101                	addi	sp,sp,-32
    80002062:	ec06                	sd	ra,24(sp)
    80002064:	e822                	sd	s0,16(sp)
    80002066:	e426                	sd	s1,8(sp)
    80002068:	e04a                	sd	s2,0(sp)
    8000206a:	1000                	addi	s0,sp,32
    8000206c:	84aa                	mv	s1,a0
    8000206e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002070:	fffff097          	auipc	ra,0xfffff
    80002074:	eb2080e7          	jalr	-334(ra) # 80000f22 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002078:	653c                	ld	a5,72(a0)
    8000207a:	02f4f863          	bgeu	s1,a5,800020aa <fetchaddr+0x4a>
    8000207e:	00848713          	addi	a4,s1,8
    80002082:	02e7e663          	bltu	a5,a4,800020ae <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002086:	46a1                	li	a3,8
    80002088:	8626                	mv	a2,s1
    8000208a:	85ca                	mv	a1,s2
    8000208c:	6928                	ld	a0,80(a0)
    8000208e:	fffff097          	auipc	ra,0xfffff
    80002092:	be2080e7          	jalr	-1054(ra) # 80000c70 <copyin>
    80002096:	00a03533          	snez	a0,a0
    8000209a:	40a00533          	neg	a0,a0
}
    8000209e:	60e2                	ld	ra,24(sp)
    800020a0:	6442                	ld	s0,16(sp)
    800020a2:	64a2                	ld	s1,8(sp)
    800020a4:	6902                	ld	s2,0(sp)
    800020a6:	6105                	addi	sp,sp,32
    800020a8:	8082                	ret
    return -1;
    800020aa:	557d                	li	a0,-1
    800020ac:	bfcd                	j	8000209e <fetchaddr+0x3e>
    800020ae:	557d                	li	a0,-1
    800020b0:	b7fd                	j	8000209e <fetchaddr+0x3e>

00000000800020b2 <fetchstr>:
{
    800020b2:	7179                	addi	sp,sp,-48
    800020b4:	f406                	sd	ra,40(sp)
    800020b6:	f022                	sd	s0,32(sp)
    800020b8:	ec26                	sd	s1,24(sp)
    800020ba:	e84a                	sd	s2,16(sp)
    800020bc:	e44e                	sd	s3,8(sp)
    800020be:	1800                	addi	s0,sp,48
    800020c0:	892a                	mv	s2,a0
    800020c2:	84ae                	mv	s1,a1
    800020c4:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800020c6:	fffff097          	auipc	ra,0xfffff
    800020ca:	e5c080e7          	jalr	-420(ra) # 80000f22 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    800020ce:	86ce                	mv	a3,s3
    800020d0:	864a                	mv	a2,s2
    800020d2:	85a6                	mv	a1,s1
    800020d4:	6928                	ld	a0,80(a0)
    800020d6:	fffff097          	auipc	ra,0xfffff
    800020da:	c26080e7          	jalr	-986(ra) # 80000cfc <copyinstr>
  if(err < 0)
    800020de:	00054763          	bltz	a0,800020ec <fetchstr+0x3a>
  return strlen(buf);
    800020e2:	8526                	mv	a0,s1
    800020e4:	ffffe097          	auipc	ra,0xffffe
    800020e8:	2b2080e7          	jalr	690(ra) # 80000396 <strlen>
}
    800020ec:	70a2                	ld	ra,40(sp)
    800020ee:	7402                	ld	s0,32(sp)
    800020f0:	64e2                	ld	s1,24(sp)
    800020f2:	6942                	ld	s2,16(sp)
    800020f4:	69a2                	ld	s3,8(sp)
    800020f6:	6145                	addi	sp,sp,48
    800020f8:	8082                	ret

00000000800020fa <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    800020fa:	1101                	addi	sp,sp,-32
    800020fc:	ec06                	sd	ra,24(sp)
    800020fe:	e822                	sd	s0,16(sp)
    80002100:	e426                	sd	s1,8(sp)
    80002102:	1000                	addi	s0,sp,32
    80002104:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002106:	00000097          	auipc	ra,0x0
    8000210a:	ef2080e7          	jalr	-270(ra) # 80001ff8 <argraw>
    8000210e:	c088                	sw	a0,0(s1)
  return 0;
}
    80002110:	4501                	li	a0,0
    80002112:	60e2                	ld	ra,24(sp)
    80002114:	6442                	ld	s0,16(sp)
    80002116:	64a2                	ld	s1,8(sp)
    80002118:	6105                	addi	sp,sp,32
    8000211a:	8082                	ret

000000008000211c <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    8000211c:	1101                	addi	sp,sp,-32
    8000211e:	ec06                	sd	ra,24(sp)
    80002120:	e822                	sd	s0,16(sp)
    80002122:	e426                	sd	s1,8(sp)
    80002124:	1000                	addi	s0,sp,32
    80002126:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002128:	00000097          	auipc	ra,0x0
    8000212c:	ed0080e7          	jalr	-304(ra) # 80001ff8 <argraw>
    80002130:	e088                	sd	a0,0(s1)
  return 0;
}
    80002132:	4501                	li	a0,0
    80002134:	60e2                	ld	ra,24(sp)
    80002136:	6442                	ld	s0,16(sp)
    80002138:	64a2                	ld	s1,8(sp)
    8000213a:	6105                	addi	sp,sp,32
    8000213c:	8082                	ret

000000008000213e <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000213e:	1101                	addi	sp,sp,-32
    80002140:	ec06                	sd	ra,24(sp)
    80002142:	e822                	sd	s0,16(sp)
    80002144:	e426                	sd	s1,8(sp)
    80002146:	e04a                	sd	s2,0(sp)
    80002148:	1000                	addi	s0,sp,32
    8000214a:	84ae                	mv	s1,a1
    8000214c:	8932                	mv	s2,a2
  *ip = argraw(n);
    8000214e:	00000097          	auipc	ra,0x0
    80002152:	eaa080e7          	jalr	-342(ra) # 80001ff8 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002156:	864a                	mv	a2,s2
    80002158:	85a6                	mv	a1,s1
    8000215a:	00000097          	auipc	ra,0x0
    8000215e:	f58080e7          	jalr	-168(ra) # 800020b2 <fetchstr>
}
    80002162:	60e2                	ld	ra,24(sp)
    80002164:	6442                	ld	s0,16(sp)
    80002166:	64a2                	ld	s1,8(sp)
    80002168:	6902                	ld	s2,0(sp)
    8000216a:	6105                	addi	sp,sp,32
    8000216c:	8082                	ret

000000008000216e <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    8000216e:	1101                	addi	sp,sp,-32
    80002170:	ec06                	sd	ra,24(sp)
    80002172:	e822                	sd	s0,16(sp)
    80002174:	e426                	sd	s1,8(sp)
    80002176:	e04a                	sd	s2,0(sp)
    80002178:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000217a:	fffff097          	auipc	ra,0xfffff
    8000217e:	da8080e7          	jalr	-600(ra) # 80000f22 <myproc>
    80002182:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002184:	05853903          	ld	s2,88(a0)
    80002188:	0a893783          	ld	a5,168(s2)
    8000218c:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002190:	37fd                	addiw	a5,a5,-1
    80002192:	4751                	li	a4,20
    80002194:	00f76f63          	bltu	a4,a5,800021b2 <syscall+0x44>
    80002198:	00369713          	slli	a4,a3,0x3
    8000219c:	00006797          	auipc	a5,0x6
    800021a0:	2f478793          	addi	a5,a5,756 # 80008490 <syscalls>
    800021a4:	97ba                	add	a5,a5,a4
    800021a6:	639c                	ld	a5,0(a5)
    800021a8:	c789                	beqz	a5,800021b2 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    800021aa:	9782                	jalr	a5
    800021ac:	06a93823          	sd	a0,112(s2)
    800021b0:	a839                	j	800021ce <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800021b2:	15848613          	addi	a2,s1,344
    800021b6:	588c                	lw	a1,48(s1)
    800021b8:	00006517          	auipc	a0,0x6
    800021bc:	2a050513          	addi	a0,a0,672 # 80008458 <states.1714+0x1c8>
    800021c0:	00004097          	auipc	ra,0x4
    800021c4:	ba2080e7          	jalr	-1118(ra) # 80005d62 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800021c8:	6cbc                	ld	a5,88(s1)
    800021ca:	577d                	li	a4,-1
    800021cc:	fbb8                	sd	a4,112(a5)
  }
}
    800021ce:	60e2                	ld	ra,24(sp)
    800021d0:	6442                	ld	s0,16(sp)
    800021d2:	64a2                	ld	s1,8(sp)
    800021d4:	6902                	ld	s2,0(sp)
    800021d6:	6105                	addi	sp,sp,32
    800021d8:	8082                	ret

00000000800021da <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800021da:	1101                	addi	sp,sp,-32
    800021dc:	ec06                	sd	ra,24(sp)
    800021de:	e822                	sd	s0,16(sp)
    800021e0:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800021e2:	fec40593          	addi	a1,s0,-20
    800021e6:	4501                	li	a0,0
    800021e8:	00000097          	auipc	ra,0x0
    800021ec:	f12080e7          	jalr	-238(ra) # 800020fa <argint>
    return -1;
    800021f0:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800021f2:	00054963          	bltz	a0,80002204 <sys_exit+0x2a>
  exit(n);
    800021f6:	fec42503          	lw	a0,-20(s0)
    800021fa:	fffff097          	auipc	ra,0xfffff
    800021fe:	640080e7          	jalr	1600(ra) # 8000183a <exit>
  return 0;  // not reached
    80002202:	4781                	li	a5,0
}
    80002204:	853e                	mv	a0,a5
    80002206:	60e2                	ld	ra,24(sp)
    80002208:	6442                	ld	s0,16(sp)
    8000220a:	6105                	addi	sp,sp,32
    8000220c:	8082                	ret

000000008000220e <sys_getpid>:

uint64
sys_getpid(void)
{
    8000220e:	1141                	addi	sp,sp,-16
    80002210:	e406                	sd	ra,8(sp)
    80002212:	e022                	sd	s0,0(sp)
    80002214:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002216:	fffff097          	auipc	ra,0xfffff
    8000221a:	d0c080e7          	jalr	-756(ra) # 80000f22 <myproc>
}
    8000221e:	5908                	lw	a0,48(a0)
    80002220:	60a2                	ld	ra,8(sp)
    80002222:	6402                	ld	s0,0(sp)
    80002224:	0141                	addi	sp,sp,16
    80002226:	8082                	ret

0000000080002228 <sys_fork>:

uint64
sys_fork(void)
{
    80002228:	1141                	addi	sp,sp,-16
    8000222a:	e406                	sd	ra,8(sp)
    8000222c:	e022                	sd	s0,0(sp)
    8000222e:	0800                	addi	s0,sp,16
  return fork();
    80002230:	fffff097          	auipc	ra,0xfffff
    80002234:	0c0080e7          	jalr	192(ra) # 800012f0 <fork>
}
    80002238:	60a2                	ld	ra,8(sp)
    8000223a:	6402                	ld	s0,0(sp)
    8000223c:	0141                	addi	sp,sp,16
    8000223e:	8082                	ret

0000000080002240 <sys_wait>:

uint64
sys_wait(void)
{
    80002240:	1101                	addi	sp,sp,-32
    80002242:	ec06                	sd	ra,24(sp)
    80002244:	e822                	sd	s0,16(sp)
    80002246:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002248:	fe840593          	addi	a1,s0,-24
    8000224c:	4501                	li	a0,0
    8000224e:	00000097          	auipc	ra,0x0
    80002252:	ece080e7          	jalr	-306(ra) # 8000211c <argaddr>
    80002256:	87aa                	mv	a5,a0
    return -1;
    80002258:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    8000225a:	0007c863          	bltz	a5,8000226a <sys_wait+0x2a>
  return wait(p);
    8000225e:	fe843503          	ld	a0,-24(s0)
    80002262:	fffff097          	auipc	ra,0xfffff
    80002266:	3e0080e7          	jalr	992(ra) # 80001642 <wait>
}
    8000226a:	60e2                	ld	ra,24(sp)
    8000226c:	6442                	ld	s0,16(sp)
    8000226e:	6105                	addi	sp,sp,32
    80002270:	8082                	ret

0000000080002272 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002272:	7179                	addi	sp,sp,-48
    80002274:	f406                	sd	ra,40(sp)
    80002276:	f022                	sd	s0,32(sp)
    80002278:	ec26                	sd	s1,24(sp)
    8000227a:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    8000227c:	fdc40593          	addi	a1,s0,-36
    80002280:	4501                	li	a0,0
    80002282:	00000097          	auipc	ra,0x0
    80002286:	e78080e7          	jalr	-392(ra) # 800020fa <argint>
    8000228a:	87aa                	mv	a5,a0
    return -1;
    8000228c:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    8000228e:	0207c063          	bltz	a5,800022ae <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002292:	fffff097          	auipc	ra,0xfffff
    80002296:	c90080e7          	jalr	-880(ra) # 80000f22 <myproc>
    8000229a:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    8000229c:	fdc42503          	lw	a0,-36(s0)
    800022a0:	fffff097          	auipc	ra,0xfffff
    800022a4:	fdc080e7          	jalr	-36(ra) # 8000127c <growproc>
    800022a8:	00054863          	bltz	a0,800022b8 <sys_sbrk+0x46>
    return -1;
  return addr;
    800022ac:	8526                	mv	a0,s1
}
    800022ae:	70a2                	ld	ra,40(sp)
    800022b0:	7402                	ld	s0,32(sp)
    800022b2:	64e2                	ld	s1,24(sp)
    800022b4:	6145                	addi	sp,sp,48
    800022b6:	8082                	ret
    return -1;
    800022b8:	557d                	li	a0,-1
    800022ba:	bfd5                	j	800022ae <sys_sbrk+0x3c>

00000000800022bc <sys_sleep>:

uint64
sys_sleep(void)
{
    800022bc:	7139                	addi	sp,sp,-64
    800022be:	fc06                	sd	ra,56(sp)
    800022c0:	f822                	sd	s0,48(sp)
    800022c2:	f426                	sd	s1,40(sp)
    800022c4:	f04a                	sd	s2,32(sp)
    800022c6:	ec4e                	sd	s3,24(sp)
    800022c8:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800022ca:	fcc40593          	addi	a1,s0,-52
    800022ce:	4501                	li	a0,0
    800022d0:	00000097          	auipc	ra,0x0
    800022d4:	e2a080e7          	jalr	-470(ra) # 800020fa <argint>
    return -1;
    800022d8:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800022da:	06054563          	bltz	a0,80002344 <sys_sleep+0x88>
  acquire(&tickslock);
    800022de:	0002d517          	auipc	a0,0x2d
    800022e2:	ba250513          	addi	a0,a0,-1118 # 8002ee80 <tickslock>
    800022e6:	00004097          	auipc	ra,0x4
    800022ea:	f7c080e7          	jalr	-132(ra) # 80006262 <acquire>
  ticks0 = ticks;
    800022ee:	00007917          	auipc	s2,0x7
    800022f2:	d2a92903          	lw	s2,-726(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800022f6:	fcc42783          	lw	a5,-52(s0)
    800022fa:	cf85                	beqz	a5,80002332 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800022fc:	0002d997          	auipc	s3,0x2d
    80002300:	b8498993          	addi	s3,s3,-1148 # 8002ee80 <tickslock>
    80002304:	00007497          	auipc	s1,0x7
    80002308:	d1448493          	addi	s1,s1,-748 # 80009018 <ticks>
    if(myproc()->killed){
    8000230c:	fffff097          	auipc	ra,0xfffff
    80002310:	c16080e7          	jalr	-1002(ra) # 80000f22 <myproc>
    80002314:	551c                	lw	a5,40(a0)
    80002316:	ef9d                	bnez	a5,80002354 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002318:	85ce                	mv	a1,s3
    8000231a:	8526                	mv	a0,s1
    8000231c:	fffff097          	auipc	ra,0xfffff
    80002320:	2c2080e7          	jalr	706(ra) # 800015de <sleep>
  while(ticks - ticks0 < n){
    80002324:	409c                	lw	a5,0(s1)
    80002326:	412787bb          	subw	a5,a5,s2
    8000232a:	fcc42703          	lw	a4,-52(s0)
    8000232e:	fce7efe3          	bltu	a5,a4,8000230c <sys_sleep+0x50>
  }
  release(&tickslock);
    80002332:	0002d517          	auipc	a0,0x2d
    80002336:	b4e50513          	addi	a0,a0,-1202 # 8002ee80 <tickslock>
    8000233a:	00004097          	auipc	ra,0x4
    8000233e:	fdc080e7          	jalr	-36(ra) # 80006316 <release>
  return 0;
    80002342:	4781                	li	a5,0
}
    80002344:	853e                	mv	a0,a5
    80002346:	70e2                	ld	ra,56(sp)
    80002348:	7442                	ld	s0,48(sp)
    8000234a:	74a2                	ld	s1,40(sp)
    8000234c:	7902                	ld	s2,32(sp)
    8000234e:	69e2                	ld	s3,24(sp)
    80002350:	6121                	addi	sp,sp,64
    80002352:	8082                	ret
      release(&tickslock);
    80002354:	0002d517          	auipc	a0,0x2d
    80002358:	b2c50513          	addi	a0,a0,-1236 # 8002ee80 <tickslock>
    8000235c:	00004097          	auipc	ra,0x4
    80002360:	fba080e7          	jalr	-70(ra) # 80006316 <release>
      return -1;
    80002364:	57fd                	li	a5,-1
    80002366:	bff9                	j	80002344 <sys_sleep+0x88>

0000000080002368 <sys_kill>:

uint64
sys_kill(void)
{
    80002368:	1101                	addi	sp,sp,-32
    8000236a:	ec06                	sd	ra,24(sp)
    8000236c:	e822                	sd	s0,16(sp)
    8000236e:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002370:	fec40593          	addi	a1,s0,-20
    80002374:	4501                	li	a0,0
    80002376:	00000097          	auipc	ra,0x0
    8000237a:	d84080e7          	jalr	-636(ra) # 800020fa <argint>
    8000237e:	87aa                	mv	a5,a0
    return -1;
    80002380:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002382:	0007c863          	bltz	a5,80002392 <sys_kill+0x2a>
  return kill(pid);
    80002386:	fec42503          	lw	a0,-20(s0)
    8000238a:	fffff097          	auipc	ra,0xfffff
    8000238e:	586080e7          	jalr	1414(ra) # 80001910 <kill>
}
    80002392:	60e2                	ld	ra,24(sp)
    80002394:	6442                	ld	s0,16(sp)
    80002396:	6105                	addi	sp,sp,32
    80002398:	8082                	ret

000000008000239a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000239a:	1101                	addi	sp,sp,-32
    8000239c:	ec06                	sd	ra,24(sp)
    8000239e:	e822                	sd	s0,16(sp)
    800023a0:	e426                	sd	s1,8(sp)
    800023a2:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800023a4:	0002d517          	auipc	a0,0x2d
    800023a8:	adc50513          	addi	a0,a0,-1316 # 8002ee80 <tickslock>
    800023ac:	00004097          	auipc	ra,0x4
    800023b0:	eb6080e7          	jalr	-330(ra) # 80006262 <acquire>
  xticks = ticks;
    800023b4:	00007497          	auipc	s1,0x7
    800023b8:	c644a483          	lw	s1,-924(s1) # 80009018 <ticks>
  release(&tickslock);
    800023bc:	0002d517          	auipc	a0,0x2d
    800023c0:	ac450513          	addi	a0,a0,-1340 # 8002ee80 <tickslock>
    800023c4:	00004097          	auipc	ra,0x4
    800023c8:	f52080e7          	jalr	-174(ra) # 80006316 <release>
  return xticks;
}
    800023cc:	02049513          	slli	a0,s1,0x20
    800023d0:	9101                	srli	a0,a0,0x20
    800023d2:	60e2                	ld	ra,24(sp)
    800023d4:	6442                	ld	s0,16(sp)
    800023d6:	64a2                	ld	s1,8(sp)
    800023d8:	6105                	addi	sp,sp,32
    800023da:	8082                	ret

00000000800023dc <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800023dc:	7179                	addi	sp,sp,-48
    800023de:	f406                	sd	ra,40(sp)
    800023e0:	f022                	sd	s0,32(sp)
    800023e2:	ec26                	sd	s1,24(sp)
    800023e4:	e84a                	sd	s2,16(sp)
    800023e6:	e44e                	sd	s3,8(sp)
    800023e8:	e052                	sd	s4,0(sp)
    800023ea:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800023ec:	00006597          	auipc	a1,0x6
    800023f0:	15458593          	addi	a1,a1,340 # 80008540 <syscalls+0xb0>
    800023f4:	0002d517          	auipc	a0,0x2d
    800023f8:	aa450513          	addi	a0,a0,-1372 # 8002ee98 <bcache>
    800023fc:	00004097          	auipc	ra,0x4
    80002400:	dd6080e7          	jalr	-554(ra) # 800061d2 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002404:	00035797          	auipc	a5,0x35
    80002408:	a9478793          	addi	a5,a5,-1388 # 80036e98 <bcache+0x8000>
    8000240c:	00035717          	auipc	a4,0x35
    80002410:	cf470713          	addi	a4,a4,-780 # 80037100 <bcache+0x8268>
    80002414:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002418:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000241c:	0002d497          	auipc	s1,0x2d
    80002420:	a9448493          	addi	s1,s1,-1388 # 8002eeb0 <bcache+0x18>
    b->next = bcache.head.next;
    80002424:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002426:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002428:	00006a17          	auipc	s4,0x6
    8000242c:	120a0a13          	addi	s4,s4,288 # 80008548 <syscalls+0xb8>
    b->next = bcache.head.next;
    80002430:	2b893783          	ld	a5,696(s2)
    80002434:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002436:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000243a:	85d2                	mv	a1,s4
    8000243c:	01048513          	addi	a0,s1,16
    80002440:	00001097          	auipc	ra,0x1
    80002444:	4bc080e7          	jalr	1212(ra) # 800038fc <initsleeplock>
    bcache.head.next->prev = b;
    80002448:	2b893783          	ld	a5,696(s2)
    8000244c:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000244e:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002452:	45848493          	addi	s1,s1,1112
    80002456:	fd349de3          	bne	s1,s3,80002430 <binit+0x54>
  }
}
    8000245a:	70a2                	ld	ra,40(sp)
    8000245c:	7402                	ld	s0,32(sp)
    8000245e:	64e2                	ld	s1,24(sp)
    80002460:	6942                	ld	s2,16(sp)
    80002462:	69a2                	ld	s3,8(sp)
    80002464:	6a02                	ld	s4,0(sp)
    80002466:	6145                	addi	sp,sp,48
    80002468:	8082                	ret

000000008000246a <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000246a:	7179                	addi	sp,sp,-48
    8000246c:	f406                	sd	ra,40(sp)
    8000246e:	f022                	sd	s0,32(sp)
    80002470:	ec26                	sd	s1,24(sp)
    80002472:	e84a                	sd	s2,16(sp)
    80002474:	e44e                	sd	s3,8(sp)
    80002476:	1800                	addi	s0,sp,48
    80002478:	89aa                	mv	s3,a0
    8000247a:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    8000247c:	0002d517          	auipc	a0,0x2d
    80002480:	a1c50513          	addi	a0,a0,-1508 # 8002ee98 <bcache>
    80002484:	00004097          	auipc	ra,0x4
    80002488:	dde080e7          	jalr	-546(ra) # 80006262 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000248c:	00035497          	auipc	s1,0x35
    80002490:	cc44b483          	ld	s1,-828(s1) # 80037150 <bcache+0x82b8>
    80002494:	00035797          	auipc	a5,0x35
    80002498:	c6c78793          	addi	a5,a5,-916 # 80037100 <bcache+0x8268>
    8000249c:	02f48f63          	beq	s1,a5,800024da <bread+0x70>
    800024a0:	873e                	mv	a4,a5
    800024a2:	a021                	j	800024aa <bread+0x40>
    800024a4:	68a4                	ld	s1,80(s1)
    800024a6:	02e48a63          	beq	s1,a4,800024da <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800024aa:	449c                	lw	a5,8(s1)
    800024ac:	ff379ce3          	bne	a5,s3,800024a4 <bread+0x3a>
    800024b0:	44dc                	lw	a5,12(s1)
    800024b2:	ff2799e3          	bne	a5,s2,800024a4 <bread+0x3a>
      b->refcnt++;
    800024b6:	40bc                	lw	a5,64(s1)
    800024b8:	2785                	addiw	a5,a5,1
    800024ba:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024bc:	0002d517          	auipc	a0,0x2d
    800024c0:	9dc50513          	addi	a0,a0,-1572 # 8002ee98 <bcache>
    800024c4:	00004097          	auipc	ra,0x4
    800024c8:	e52080e7          	jalr	-430(ra) # 80006316 <release>
      acquiresleep(&b->lock);
    800024cc:	01048513          	addi	a0,s1,16
    800024d0:	00001097          	auipc	ra,0x1
    800024d4:	466080e7          	jalr	1126(ra) # 80003936 <acquiresleep>
      return b;
    800024d8:	a8b9                	j	80002536 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024da:	00035497          	auipc	s1,0x35
    800024de:	c6e4b483          	ld	s1,-914(s1) # 80037148 <bcache+0x82b0>
    800024e2:	00035797          	auipc	a5,0x35
    800024e6:	c1e78793          	addi	a5,a5,-994 # 80037100 <bcache+0x8268>
    800024ea:	00f48863          	beq	s1,a5,800024fa <bread+0x90>
    800024ee:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800024f0:	40bc                	lw	a5,64(s1)
    800024f2:	cf81                	beqz	a5,8000250a <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024f4:	64a4                	ld	s1,72(s1)
    800024f6:	fee49de3          	bne	s1,a4,800024f0 <bread+0x86>
  panic("bget: no buffers");
    800024fa:	00006517          	auipc	a0,0x6
    800024fe:	05650513          	addi	a0,a0,86 # 80008550 <syscalls+0xc0>
    80002502:	00004097          	auipc	ra,0x4
    80002506:	816080e7          	jalr	-2026(ra) # 80005d18 <panic>
      b->dev = dev;
    8000250a:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    8000250e:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002512:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002516:	4785                	li	a5,1
    80002518:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000251a:	0002d517          	auipc	a0,0x2d
    8000251e:	97e50513          	addi	a0,a0,-1666 # 8002ee98 <bcache>
    80002522:	00004097          	auipc	ra,0x4
    80002526:	df4080e7          	jalr	-524(ra) # 80006316 <release>
      acquiresleep(&b->lock);
    8000252a:	01048513          	addi	a0,s1,16
    8000252e:	00001097          	auipc	ra,0x1
    80002532:	408080e7          	jalr	1032(ra) # 80003936 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002536:	409c                	lw	a5,0(s1)
    80002538:	cb89                	beqz	a5,8000254a <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000253a:	8526                	mv	a0,s1
    8000253c:	70a2                	ld	ra,40(sp)
    8000253e:	7402                	ld	s0,32(sp)
    80002540:	64e2                	ld	s1,24(sp)
    80002542:	6942                	ld	s2,16(sp)
    80002544:	69a2                	ld	s3,8(sp)
    80002546:	6145                	addi	sp,sp,48
    80002548:	8082                	ret
    virtio_disk_rw(b, 0);
    8000254a:	4581                	li	a1,0
    8000254c:	8526                	mv	a0,s1
    8000254e:	00003097          	auipc	ra,0x3
    80002552:	f08080e7          	jalr	-248(ra) # 80005456 <virtio_disk_rw>
    b->valid = 1;
    80002556:	4785                	li	a5,1
    80002558:	c09c                	sw	a5,0(s1)
  return b;
    8000255a:	b7c5                	j	8000253a <bread+0xd0>

000000008000255c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000255c:	1101                	addi	sp,sp,-32
    8000255e:	ec06                	sd	ra,24(sp)
    80002560:	e822                	sd	s0,16(sp)
    80002562:	e426                	sd	s1,8(sp)
    80002564:	1000                	addi	s0,sp,32
    80002566:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002568:	0541                	addi	a0,a0,16
    8000256a:	00001097          	auipc	ra,0x1
    8000256e:	466080e7          	jalr	1126(ra) # 800039d0 <holdingsleep>
    80002572:	cd01                	beqz	a0,8000258a <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002574:	4585                	li	a1,1
    80002576:	8526                	mv	a0,s1
    80002578:	00003097          	auipc	ra,0x3
    8000257c:	ede080e7          	jalr	-290(ra) # 80005456 <virtio_disk_rw>
}
    80002580:	60e2                	ld	ra,24(sp)
    80002582:	6442                	ld	s0,16(sp)
    80002584:	64a2                	ld	s1,8(sp)
    80002586:	6105                	addi	sp,sp,32
    80002588:	8082                	ret
    panic("bwrite");
    8000258a:	00006517          	auipc	a0,0x6
    8000258e:	fde50513          	addi	a0,a0,-34 # 80008568 <syscalls+0xd8>
    80002592:	00003097          	auipc	ra,0x3
    80002596:	786080e7          	jalr	1926(ra) # 80005d18 <panic>

000000008000259a <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000259a:	1101                	addi	sp,sp,-32
    8000259c:	ec06                	sd	ra,24(sp)
    8000259e:	e822                	sd	s0,16(sp)
    800025a0:	e426                	sd	s1,8(sp)
    800025a2:	e04a                	sd	s2,0(sp)
    800025a4:	1000                	addi	s0,sp,32
    800025a6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800025a8:	01050913          	addi	s2,a0,16
    800025ac:	854a                	mv	a0,s2
    800025ae:	00001097          	auipc	ra,0x1
    800025b2:	422080e7          	jalr	1058(ra) # 800039d0 <holdingsleep>
    800025b6:	c92d                	beqz	a0,80002628 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800025b8:	854a                	mv	a0,s2
    800025ba:	00001097          	auipc	ra,0x1
    800025be:	3d2080e7          	jalr	978(ra) # 8000398c <releasesleep>

  acquire(&bcache.lock);
    800025c2:	0002d517          	auipc	a0,0x2d
    800025c6:	8d650513          	addi	a0,a0,-1834 # 8002ee98 <bcache>
    800025ca:	00004097          	auipc	ra,0x4
    800025ce:	c98080e7          	jalr	-872(ra) # 80006262 <acquire>
  b->refcnt--;
    800025d2:	40bc                	lw	a5,64(s1)
    800025d4:	37fd                	addiw	a5,a5,-1
    800025d6:	0007871b          	sext.w	a4,a5
    800025da:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800025dc:	eb05                	bnez	a4,8000260c <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800025de:	68bc                	ld	a5,80(s1)
    800025e0:	64b8                	ld	a4,72(s1)
    800025e2:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800025e4:	64bc                	ld	a5,72(s1)
    800025e6:	68b8                	ld	a4,80(s1)
    800025e8:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800025ea:	00035797          	auipc	a5,0x35
    800025ee:	8ae78793          	addi	a5,a5,-1874 # 80036e98 <bcache+0x8000>
    800025f2:	2b87b703          	ld	a4,696(a5)
    800025f6:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800025f8:	00035717          	auipc	a4,0x35
    800025fc:	b0870713          	addi	a4,a4,-1272 # 80037100 <bcache+0x8268>
    80002600:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002602:	2b87b703          	ld	a4,696(a5)
    80002606:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002608:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000260c:	0002d517          	auipc	a0,0x2d
    80002610:	88c50513          	addi	a0,a0,-1908 # 8002ee98 <bcache>
    80002614:	00004097          	auipc	ra,0x4
    80002618:	d02080e7          	jalr	-766(ra) # 80006316 <release>
}
    8000261c:	60e2                	ld	ra,24(sp)
    8000261e:	6442                	ld	s0,16(sp)
    80002620:	64a2                	ld	s1,8(sp)
    80002622:	6902                	ld	s2,0(sp)
    80002624:	6105                	addi	sp,sp,32
    80002626:	8082                	ret
    panic("brelse");
    80002628:	00006517          	auipc	a0,0x6
    8000262c:	f4850513          	addi	a0,a0,-184 # 80008570 <syscalls+0xe0>
    80002630:	00003097          	auipc	ra,0x3
    80002634:	6e8080e7          	jalr	1768(ra) # 80005d18 <panic>

0000000080002638 <bpin>:

void
bpin(struct buf *b) {
    80002638:	1101                	addi	sp,sp,-32
    8000263a:	ec06                	sd	ra,24(sp)
    8000263c:	e822                	sd	s0,16(sp)
    8000263e:	e426                	sd	s1,8(sp)
    80002640:	1000                	addi	s0,sp,32
    80002642:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002644:	0002d517          	auipc	a0,0x2d
    80002648:	85450513          	addi	a0,a0,-1964 # 8002ee98 <bcache>
    8000264c:	00004097          	auipc	ra,0x4
    80002650:	c16080e7          	jalr	-1002(ra) # 80006262 <acquire>
  b->refcnt++;
    80002654:	40bc                	lw	a5,64(s1)
    80002656:	2785                	addiw	a5,a5,1
    80002658:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000265a:	0002d517          	auipc	a0,0x2d
    8000265e:	83e50513          	addi	a0,a0,-1986 # 8002ee98 <bcache>
    80002662:	00004097          	auipc	ra,0x4
    80002666:	cb4080e7          	jalr	-844(ra) # 80006316 <release>
}
    8000266a:	60e2                	ld	ra,24(sp)
    8000266c:	6442                	ld	s0,16(sp)
    8000266e:	64a2                	ld	s1,8(sp)
    80002670:	6105                	addi	sp,sp,32
    80002672:	8082                	ret

0000000080002674 <bunpin>:

void
bunpin(struct buf *b) {
    80002674:	1101                	addi	sp,sp,-32
    80002676:	ec06                	sd	ra,24(sp)
    80002678:	e822                	sd	s0,16(sp)
    8000267a:	e426                	sd	s1,8(sp)
    8000267c:	1000                	addi	s0,sp,32
    8000267e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002680:	0002d517          	auipc	a0,0x2d
    80002684:	81850513          	addi	a0,a0,-2024 # 8002ee98 <bcache>
    80002688:	00004097          	auipc	ra,0x4
    8000268c:	bda080e7          	jalr	-1062(ra) # 80006262 <acquire>
  b->refcnt--;
    80002690:	40bc                	lw	a5,64(s1)
    80002692:	37fd                	addiw	a5,a5,-1
    80002694:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002696:	0002d517          	auipc	a0,0x2d
    8000269a:	80250513          	addi	a0,a0,-2046 # 8002ee98 <bcache>
    8000269e:	00004097          	auipc	ra,0x4
    800026a2:	c78080e7          	jalr	-904(ra) # 80006316 <release>
}
    800026a6:	60e2                	ld	ra,24(sp)
    800026a8:	6442                	ld	s0,16(sp)
    800026aa:	64a2                	ld	s1,8(sp)
    800026ac:	6105                	addi	sp,sp,32
    800026ae:	8082                	ret

00000000800026b0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800026b0:	1101                	addi	sp,sp,-32
    800026b2:	ec06                	sd	ra,24(sp)
    800026b4:	e822                	sd	s0,16(sp)
    800026b6:	e426                	sd	s1,8(sp)
    800026b8:	e04a                	sd	s2,0(sp)
    800026ba:	1000                	addi	s0,sp,32
    800026bc:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800026be:	00d5d59b          	srliw	a1,a1,0xd
    800026c2:	00035797          	auipc	a5,0x35
    800026c6:	eb27a783          	lw	a5,-334(a5) # 80037574 <sb+0x1c>
    800026ca:	9dbd                	addw	a1,a1,a5
    800026cc:	00000097          	auipc	ra,0x0
    800026d0:	d9e080e7          	jalr	-610(ra) # 8000246a <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800026d4:	0074f713          	andi	a4,s1,7
    800026d8:	4785                	li	a5,1
    800026da:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800026de:	14ce                	slli	s1,s1,0x33
    800026e0:	90d9                	srli	s1,s1,0x36
    800026e2:	00950733          	add	a4,a0,s1
    800026e6:	05874703          	lbu	a4,88(a4)
    800026ea:	00e7f6b3          	and	a3,a5,a4
    800026ee:	c69d                	beqz	a3,8000271c <bfree+0x6c>
    800026f0:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800026f2:	94aa                	add	s1,s1,a0
    800026f4:	fff7c793          	not	a5,a5
    800026f8:	8ff9                	and	a5,a5,a4
    800026fa:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800026fe:	00001097          	auipc	ra,0x1
    80002702:	118080e7          	jalr	280(ra) # 80003816 <log_write>
  brelse(bp);
    80002706:	854a                	mv	a0,s2
    80002708:	00000097          	auipc	ra,0x0
    8000270c:	e92080e7          	jalr	-366(ra) # 8000259a <brelse>
}
    80002710:	60e2                	ld	ra,24(sp)
    80002712:	6442                	ld	s0,16(sp)
    80002714:	64a2                	ld	s1,8(sp)
    80002716:	6902                	ld	s2,0(sp)
    80002718:	6105                	addi	sp,sp,32
    8000271a:	8082                	ret
    panic("freeing free block");
    8000271c:	00006517          	auipc	a0,0x6
    80002720:	e5c50513          	addi	a0,a0,-420 # 80008578 <syscalls+0xe8>
    80002724:	00003097          	auipc	ra,0x3
    80002728:	5f4080e7          	jalr	1524(ra) # 80005d18 <panic>

000000008000272c <balloc>:
{
    8000272c:	711d                	addi	sp,sp,-96
    8000272e:	ec86                	sd	ra,88(sp)
    80002730:	e8a2                	sd	s0,80(sp)
    80002732:	e4a6                	sd	s1,72(sp)
    80002734:	e0ca                	sd	s2,64(sp)
    80002736:	fc4e                	sd	s3,56(sp)
    80002738:	f852                	sd	s4,48(sp)
    8000273a:	f456                	sd	s5,40(sp)
    8000273c:	f05a                	sd	s6,32(sp)
    8000273e:	ec5e                	sd	s7,24(sp)
    80002740:	e862                	sd	s8,16(sp)
    80002742:	e466                	sd	s9,8(sp)
    80002744:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002746:	00035797          	auipc	a5,0x35
    8000274a:	e167a783          	lw	a5,-490(a5) # 8003755c <sb+0x4>
    8000274e:	cbd1                	beqz	a5,800027e2 <balloc+0xb6>
    80002750:	8baa                	mv	s7,a0
    80002752:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002754:	00035b17          	auipc	s6,0x35
    80002758:	e04b0b13          	addi	s6,s6,-508 # 80037558 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000275c:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000275e:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002760:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002762:	6c89                	lui	s9,0x2
    80002764:	a831                	j	80002780 <balloc+0x54>
    brelse(bp);
    80002766:	854a                	mv	a0,s2
    80002768:	00000097          	auipc	ra,0x0
    8000276c:	e32080e7          	jalr	-462(ra) # 8000259a <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002770:	015c87bb          	addw	a5,s9,s5
    80002774:	00078a9b          	sext.w	s5,a5
    80002778:	004b2703          	lw	a4,4(s6)
    8000277c:	06eaf363          	bgeu	s5,a4,800027e2 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80002780:	41fad79b          	sraiw	a5,s5,0x1f
    80002784:	0137d79b          	srliw	a5,a5,0x13
    80002788:	015787bb          	addw	a5,a5,s5
    8000278c:	40d7d79b          	sraiw	a5,a5,0xd
    80002790:	01cb2583          	lw	a1,28(s6)
    80002794:	9dbd                	addw	a1,a1,a5
    80002796:	855e                	mv	a0,s7
    80002798:	00000097          	auipc	ra,0x0
    8000279c:	cd2080e7          	jalr	-814(ra) # 8000246a <bread>
    800027a0:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027a2:	004b2503          	lw	a0,4(s6)
    800027a6:	000a849b          	sext.w	s1,s5
    800027aa:	8662                	mv	a2,s8
    800027ac:	faa4fde3          	bgeu	s1,a0,80002766 <balloc+0x3a>
      m = 1 << (bi % 8);
    800027b0:	41f6579b          	sraiw	a5,a2,0x1f
    800027b4:	01d7d69b          	srliw	a3,a5,0x1d
    800027b8:	00c6873b          	addw	a4,a3,a2
    800027bc:	00777793          	andi	a5,a4,7
    800027c0:	9f95                	subw	a5,a5,a3
    800027c2:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800027c6:	4037571b          	sraiw	a4,a4,0x3
    800027ca:	00e906b3          	add	a3,s2,a4
    800027ce:	0586c683          	lbu	a3,88(a3)
    800027d2:	00d7f5b3          	and	a1,a5,a3
    800027d6:	cd91                	beqz	a1,800027f2 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027d8:	2605                	addiw	a2,a2,1
    800027da:	2485                	addiw	s1,s1,1
    800027dc:	fd4618e3          	bne	a2,s4,800027ac <balloc+0x80>
    800027e0:	b759                	j	80002766 <balloc+0x3a>
  panic("balloc: out of blocks");
    800027e2:	00006517          	auipc	a0,0x6
    800027e6:	dae50513          	addi	a0,a0,-594 # 80008590 <syscalls+0x100>
    800027ea:	00003097          	auipc	ra,0x3
    800027ee:	52e080e7          	jalr	1326(ra) # 80005d18 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800027f2:	974a                	add	a4,a4,s2
    800027f4:	8fd5                	or	a5,a5,a3
    800027f6:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800027fa:	854a                	mv	a0,s2
    800027fc:	00001097          	auipc	ra,0x1
    80002800:	01a080e7          	jalr	26(ra) # 80003816 <log_write>
        brelse(bp);
    80002804:	854a                	mv	a0,s2
    80002806:	00000097          	auipc	ra,0x0
    8000280a:	d94080e7          	jalr	-620(ra) # 8000259a <brelse>
  bp = bread(dev, bno);
    8000280e:	85a6                	mv	a1,s1
    80002810:	855e                	mv	a0,s7
    80002812:	00000097          	auipc	ra,0x0
    80002816:	c58080e7          	jalr	-936(ra) # 8000246a <bread>
    8000281a:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000281c:	40000613          	li	a2,1024
    80002820:	4581                	li	a1,0
    80002822:	05850513          	addi	a0,a0,88
    80002826:	ffffe097          	auipc	ra,0xffffe
    8000282a:	9ec080e7          	jalr	-1556(ra) # 80000212 <memset>
  log_write(bp);
    8000282e:	854a                	mv	a0,s2
    80002830:	00001097          	auipc	ra,0x1
    80002834:	fe6080e7          	jalr	-26(ra) # 80003816 <log_write>
  brelse(bp);
    80002838:	854a                	mv	a0,s2
    8000283a:	00000097          	auipc	ra,0x0
    8000283e:	d60080e7          	jalr	-672(ra) # 8000259a <brelse>
}
    80002842:	8526                	mv	a0,s1
    80002844:	60e6                	ld	ra,88(sp)
    80002846:	6446                	ld	s0,80(sp)
    80002848:	64a6                	ld	s1,72(sp)
    8000284a:	6906                	ld	s2,64(sp)
    8000284c:	79e2                	ld	s3,56(sp)
    8000284e:	7a42                	ld	s4,48(sp)
    80002850:	7aa2                	ld	s5,40(sp)
    80002852:	7b02                	ld	s6,32(sp)
    80002854:	6be2                	ld	s7,24(sp)
    80002856:	6c42                	ld	s8,16(sp)
    80002858:	6ca2                	ld	s9,8(sp)
    8000285a:	6125                	addi	sp,sp,96
    8000285c:	8082                	ret

000000008000285e <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    8000285e:	7179                	addi	sp,sp,-48
    80002860:	f406                	sd	ra,40(sp)
    80002862:	f022                	sd	s0,32(sp)
    80002864:	ec26                	sd	s1,24(sp)
    80002866:	e84a                	sd	s2,16(sp)
    80002868:	e44e                	sd	s3,8(sp)
    8000286a:	e052                	sd	s4,0(sp)
    8000286c:	1800                	addi	s0,sp,48
    8000286e:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002870:	47ad                	li	a5,11
    80002872:	04b7fe63          	bgeu	a5,a1,800028ce <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002876:	ff45849b          	addiw	s1,a1,-12
    8000287a:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000287e:	0ff00793          	li	a5,255
    80002882:	0ae7e363          	bltu	a5,a4,80002928 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002886:	08052583          	lw	a1,128(a0)
    8000288a:	c5ad                	beqz	a1,800028f4 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    8000288c:	00092503          	lw	a0,0(s2)
    80002890:	00000097          	auipc	ra,0x0
    80002894:	bda080e7          	jalr	-1062(ra) # 8000246a <bread>
    80002898:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000289a:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000289e:	02049593          	slli	a1,s1,0x20
    800028a2:	9181                	srli	a1,a1,0x20
    800028a4:	058a                	slli	a1,a1,0x2
    800028a6:	00b784b3          	add	s1,a5,a1
    800028aa:	0004a983          	lw	s3,0(s1)
    800028ae:	04098d63          	beqz	s3,80002908 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800028b2:	8552                	mv	a0,s4
    800028b4:	00000097          	auipc	ra,0x0
    800028b8:	ce6080e7          	jalr	-794(ra) # 8000259a <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800028bc:	854e                	mv	a0,s3
    800028be:	70a2                	ld	ra,40(sp)
    800028c0:	7402                	ld	s0,32(sp)
    800028c2:	64e2                	ld	s1,24(sp)
    800028c4:	6942                	ld	s2,16(sp)
    800028c6:	69a2                	ld	s3,8(sp)
    800028c8:	6a02                	ld	s4,0(sp)
    800028ca:	6145                	addi	sp,sp,48
    800028cc:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800028ce:	02059493          	slli	s1,a1,0x20
    800028d2:	9081                	srli	s1,s1,0x20
    800028d4:	048a                	slli	s1,s1,0x2
    800028d6:	94aa                	add	s1,s1,a0
    800028d8:	0504a983          	lw	s3,80(s1)
    800028dc:	fe0990e3          	bnez	s3,800028bc <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800028e0:	4108                	lw	a0,0(a0)
    800028e2:	00000097          	auipc	ra,0x0
    800028e6:	e4a080e7          	jalr	-438(ra) # 8000272c <balloc>
    800028ea:	0005099b          	sext.w	s3,a0
    800028ee:	0534a823          	sw	s3,80(s1)
    800028f2:	b7e9                	j	800028bc <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800028f4:	4108                	lw	a0,0(a0)
    800028f6:	00000097          	auipc	ra,0x0
    800028fa:	e36080e7          	jalr	-458(ra) # 8000272c <balloc>
    800028fe:	0005059b          	sext.w	a1,a0
    80002902:	08b92023          	sw	a1,128(s2)
    80002906:	b759                	j	8000288c <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002908:	00092503          	lw	a0,0(s2)
    8000290c:	00000097          	auipc	ra,0x0
    80002910:	e20080e7          	jalr	-480(ra) # 8000272c <balloc>
    80002914:	0005099b          	sext.w	s3,a0
    80002918:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    8000291c:	8552                	mv	a0,s4
    8000291e:	00001097          	auipc	ra,0x1
    80002922:	ef8080e7          	jalr	-264(ra) # 80003816 <log_write>
    80002926:	b771                	j	800028b2 <bmap+0x54>
  panic("bmap: out of range");
    80002928:	00006517          	auipc	a0,0x6
    8000292c:	c8050513          	addi	a0,a0,-896 # 800085a8 <syscalls+0x118>
    80002930:	00003097          	auipc	ra,0x3
    80002934:	3e8080e7          	jalr	1000(ra) # 80005d18 <panic>

0000000080002938 <iget>:
{
    80002938:	7179                	addi	sp,sp,-48
    8000293a:	f406                	sd	ra,40(sp)
    8000293c:	f022                	sd	s0,32(sp)
    8000293e:	ec26                	sd	s1,24(sp)
    80002940:	e84a                	sd	s2,16(sp)
    80002942:	e44e                	sd	s3,8(sp)
    80002944:	e052                	sd	s4,0(sp)
    80002946:	1800                	addi	s0,sp,48
    80002948:	89aa                	mv	s3,a0
    8000294a:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000294c:	00035517          	auipc	a0,0x35
    80002950:	c2c50513          	addi	a0,a0,-980 # 80037578 <itable>
    80002954:	00004097          	auipc	ra,0x4
    80002958:	90e080e7          	jalr	-1778(ra) # 80006262 <acquire>
  empty = 0;
    8000295c:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000295e:	00035497          	auipc	s1,0x35
    80002962:	c3248493          	addi	s1,s1,-974 # 80037590 <itable+0x18>
    80002966:	00036697          	auipc	a3,0x36
    8000296a:	6ba68693          	addi	a3,a3,1722 # 80039020 <log>
    8000296e:	a039                	j	8000297c <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002970:	02090b63          	beqz	s2,800029a6 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002974:	08848493          	addi	s1,s1,136
    80002978:	02d48a63          	beq	s1,a3,800029ac <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000297c:	449c                	lw	a5,8(s1)
    8000297e:	fef059e3          	blez	a5,80002970 <iget+0x38>
    80002982:	4098                	lw	a4,0(s1)
    80002984:	ff3716e3          	bne	a4,s3,80002970 <iget+0x38>
    80002988:	40d8                	lw	a4,4(s1)
    8000298a:	ff4713e3          	bne	a4,s4,80002970 <iget+0x38>
      ip->ref++;
    8000298e:	2785                	addiw	a5,a5,1
    80002990:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002992:	00035517          	auipc	a0,0x35
    80002996:	be650513          	addi	a0,a0,-1050 # 80037578 <itable>
    8000299a:	00004097          	auipc	ra,0x4
    8000299e:	97c080e7          	jalr	-1668(ra) # 80006316 <release>
      return ip;
    800029a2:	8926                	mv	s2,s1
    800029a4:	a03d                	j	800029d2 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800029a6:	f7f9                	bnez	a5,80002974 <iget+0x3c>
    800029a8:	8926                	mv	s2,s1
    800029aa:	b7e9                	j	80002974 <iget+0x3c>
  if(empty == 0)
    800029ac:	02090c63          	beqz	s2,800029e4 <iget+0xac>
  ip->dev = dev;
    800029b0:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800029b4:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800029b8:	4785                	li	a5,1
    800029ba:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800029be:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800029c2:	00035517          	auipc	a0,0x35
    800029c6:	bb650513          	addi	a0,a0,-1098 # 80037578 <itable>
    800029ca:	00004097          	auipc	ra,0x4
    800029ce:	94c080e7          	jalr	-1716(ra) # 80006316 <release>
}
    800029d2:	854a                	mv	a0,s2
    800029d4:	70a2                	ld	ra,40(sp)
    800029d6:	7402                	ld	s0,32(sp)
    800029d8:	64e2                	ld	s1,24(sp)
    800029da:	6942                	ld	s2,16(sp)
    800029dc:	69a2                	ld	s3,8(sp)
    800029de:	6a02                	ld	s4,0(sp)
    800029e0:	6145                	addi	sp,sp,48
    800029e2:	8082                	ret
    panic("iget: no inodes");
    800029e4:	00006517          	auipc	a0,0x6
    800029e8:	bdc50513          	addi	a0,a0,-1060 # 800085c0 <syscalls+0x130>
    800029ec:	00003097          	auipc	ra,0x3
    800029f0:	32c080e7          	jalr	812(ra) # 80005d18 <panic>

00000000800029f4 <fsinit>:
fsinit(int dev) {
    800029f4:	7179                	addi	sp,sp,-48
    800029f6:	f406                	sd	ra,40(sp)
    800029f8:	f022                	sd	s0,32(sp)
    800029fa:	ec26                	sd	s1,24(sp)
    800029fc:	e84a                	sd	s2,16(sp)
    800029fe:	e44e                	sd	s3,8(sp)
    80002a00:	1800                	addi	s0,sp,48
    80002a02:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002a04:	4585                	li	a1,1
    80002a06:	00000097          	auipc	ra,0x0
    80002a0a:	a64080e7          	jalr	-1436(ra) # 8000246a <bread>
    80002a0e:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002a10:	00035997          	auipc	s3,0x35
    80002a14:	b4898993          	addi	s3,s3,-1208 # 80037558 <sb>
    80002a18:	02000613          	li	a2,32
    80002a1c:	05850593          	addi	a1,a0,88
    80002a20:	854e                	mv	a0,s3
    80002a22:	ffffe097          	auipc	ra,0xffffe
    80002a26:	850080e7          	jalr	-1968(ra) # 80000272 <memmove>
  brelse(bp);
    80002a2a:	8526                	mv	a0,s1
    80002a2c:	00000097          	auipc	ra,0x0
    80002a30:	b6e080e7          	jalr	-1170(ra) # 8000259a <brelse>
  if(sb.magic != FSMAGIC)
    80002a34:	0009a703          	lw	a4,0(s3)
    80002a38:	102037b7          	lui	a5,0x10203
    80002a3c:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a40:	02f71263          	bne	a4,a5,80002a64 <fsinit+0x70>
  initlog(dev, &sb);
    80002a44:	00035597          	auipc	a1,0x35
    80002a48:	b1458593          	addi	a1,a1,-1260 # 80037558 <sb>
    80002a4c:	854a                	mv	a0,s2
    80002a4e:	00001097          	auipc	ra,0x1
    80002a52:	b4c080e7          	jalr	-1204(ra) # 8000359a <initlog>
}
    80002a56:	70a2                	ld	ra,40(sp)
    80002a58:	7402                	ld	s0,32(sp)
    80002a5a:	64e2                	ld	s1,24(sp)
    80002a5c:	6942                	ld	s2,16(sp)
    80002a5e:	69a2                	ld	s3,8(sp)
    80002a60:	6145                	addi	sp,sp,48
    80002a62:	8082                	ret
    panic("invalid file system");
    80002a64:	00006517          	auipc	a0,0x6
    80002a68:	b6c50513          	addi	a0,a0,-1172 # 800085d0 <syscalls+0x140>
    80002a6c:	00003097          	auipc	ra,0x3
    80002a70:	2ac080e7          	jalr	684(ra) # 80005d18 <panic>

0000000080002a74 <iinit>:
{
    80002a74:	7179                	addi	sp,sp,-48
    80002a76:	f406                	sd	ra,40(sp)
    80002a78:	f022                	sd	s0,32(sp)
    80002a7a:	ec26                	sd	s1,24(sp)
    80002a7c:	e84a                	sd	s2,16(sp)
    80002a7e:	e44e                	sd	s3,8(sp)
    80002a80:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a82:	00006597          	auipc	a1,0x6
    80002a86:	b6658593          	addi	a1,a1,-1178 # 800085e8 <syscalls+0x158>
    80002a8a:	00035517          	auipc	a0,0x35
    80002a8e:	aee50513          	addi	a0,a0,-1298 # 80037578 <itable>
    80002a92:	00003097          	auipc	ra,0x3
    80002a96:	740080e7          	jalr	1856(ra) # 800061d2 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002a9a:	00035497          	auipc	s1,0x35
    80002a9e:	b0648493          	addi	s1,s1,-1274 # 800375a0 <itable+0x28>
    80002aa2:	00036997          	auipc	s3,0x36
    80002aa6:	58e98993          	addi	s3,s3,1422 # 80039030 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002aaa:	00006917          	auipc	s2,0x6
    80002aae:	b4690913          	addi	s2,s2,-1210 # 800085f0 <syscalls+0x160>
    80002ab2:	85ca                	mv	a1,s2
    80002ab4:	8526                	mv	a0,s1
    80002ab6:	00001097          	auipc	ra,0x1
    80002aba:	e46080e7          	jalr	-442(ra) # 800038fc <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002abe:	08848493          	addi	s1,s1,136
    80002ac2:	ff3498e3          	bne	s1,s3,80002ab2 <iinit+0x3e>
}
    80002ac6:	70a2                	ld	ra,40(sp)
    80002ac8:	7402                	ld	s0,32(sp)
    80002aca:	64e2                	ld	s1,24(sp)
    80002acc:	6942                	ld	s2,16(sp)
    80002ace:	69a2                	ld	s3,8(sp)
    80002ad0:	6145                	addi	sp,sp,48
    80002ad2:	8082                	ret

0000000080002ad4 <ialloc>:
{
    80002ad4:	715d                	addi	sp,sp,-80
    80002ad6:	e486                	sd	ra,72(sp)
    80002ad8:	e0a2                	sd	s0,64(sp)
    80002ada:	fc26                	sd	s1,56(sp)
    80002adc:	f84a                	sd	s2,48(sp)
    80002ade:	f44e                	sd	s3,40(sp)
    80002ae0:	f052                	sd	s4,32(sp)
    80002ae2:	ec56                	sd	s5,24(sp)
    80002ae4:	e85a                	sd	s6,16(sp)
    80002ae6:	e45e                	sd	s7,8(sp)
    80002ae8:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002aea:	00035717          	auipc	a4,0x35
    80002aee:	a7a72703          	lw	a4,-1414(a4) # 80037564 <sb+0xc>
    80002af2:	4785                	li	a5,1
    80002af4:	04e7fa63          	bgeu	a5,a4,80002b48 <ialloc+0x74>
    80002af8:	8aaa                	mv	s5,a0
    80002afa:	8bae                	mv	s7,a1
    80002afc:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002afe:	00035a17          	auipc	s4,0x35
    80002b02:	a5aa0a13          	addi	s4,s4,-1446 # 80037558 <sb>
    80002b06:	00048b1b          	sext.w	s6,s1
    80002b0a:	0044d593          	srli	a1,s1,0x4
    80002b0e:	018a2783          	lw	a5,24(s4)
    80002b12:	9dbd                	addw	a1,a1,a5
    80002b14:	8556                	mv	a0,s5
    80002b16:	00000097          	auipc	ra,0x0
    80002b1a:	954080e7          	jalr	-1708(ra) # 8000246a <bread>
    80002b1e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002b20:	05850993          	addi	s3,a0,88
    80002b24:	00f4f793          	andi	a5,s1,15
    80002b28:	079a                	slli	a5,a5,0x6
    80002b2a:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002b2c:	00099783          	lh	a5,0(s3)
    80002b30:	c785                	beqz	a5,80002b58 <ialloc+0x84>
    brelse(bp);
    80002b32:	00000097          	auipc	ra,0x0
    80002b36:	a68080e7          	jalr	-1432(ra) # 8000259a <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b3a:	0485                	addi	s1,s1,1
    80002b3c:	00ca2703          	lw	a4,12(s4)
    80002b40:	0004879b          	sext.w	a5,s1
    80002b44:	fce7e1e3          	bltu	a5,a4,80002b06 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002b48:	00006517          	auipc	a0,0x6
    80002b4c:	ab050513          	addi	a0,a0,-1360 # 800085f8 <syscalls+0x168>
    80002b50:	00003097          	auipc	ra,0x3
    80002b54:	1c8080e7          	jalr	456(ra) # 80005d18 <panic>
      memset(dip, 0, sizeof(*dip));
    80002b58:	04000613          	li	a2,64
    80002b5c:	4581                	li	a1,0
    80002b5e:	854e                	mv	a0,s3
    80002b60:	ffffd097          	auipc	ra,0xffffd
    80002b64:	6b2080e7          	jalr	1714(ra) # 80000212 <memset>
      dip->type = type;
    80002b68:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002b6c:	854a                	mv	a0,s2
    80002b6e:	00001097          	auipc	ra,0x1
    80002b72:	ca8080e7          	jalr	-856(ra) # 80003816 <log_write>
      brelse(bp);
    80002b76:	854a                	mv	a0,s2
    80002b78:	00000097          	auipc	ra,0x0
    80002b7c:	a22080e7          	jalr	-1502(ra) # 8000259a <brelse>
      return iget(dev, inum);
    80002b80:	85da                	mv	a1,s6
    80002b82:	8556                	mv	a0,s5
    80002b84:	00000097          	auipc	ra,0x0
    80002b88:	db4080e7          	jalr	-588(ra) # 80002938 <iget>
}
    80002b8c:	60a6                	ld	ra,72(sp)
    80002b8e:	6406                	ld	s0,64(sp)
    80002b90:	74e2                	ld	s1,56(sp)
    80002b92:	7942                	ld	s2,48(sp)
    80002b94:	79a2                	ld	s3,40(sp)
    80002b96:	7a02                	ld	s4,32(sp)
    80002b98:	6ae2                	ld	s5,24(sp)
    80002b9a:	6b42                	ld	s6,16(sp)
    80002b9c:	6ba2                	ld	s7,8(sp)
    80002b9e:	6161                	addi	sp,sp,80
    80002ba0:	8082                	ret

0000000080002ba2 <iupdate>:
{
    80002ba2:	1101                	addi	sp,sp,-32
    80002ba4:	ec06                	sd	ra,24(sp)
    80002ba6:	e822                	sd	s0,16(sp)
    80002ba8:	e426                	sd	s1,8(sp)
    80002baa:	e04a                	sd	s2,0(sp)
    80002bac:	1000                	addi	s0,sp,32
    80002bae:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002bb0:	415c                	lw	a5,4(a0)
    80002bb2:	0047d79b          	srliw	a5,a5,0x4
    80002bb6:	00035597          	auipc	a1,0x35
    80002bba:	9ba5a583          	lw	a1,-1606(a1) # 80037570 <sb+0x18>
    80002bbe:	9dbd                	addw	a1,a1,a5
    80002bc0:	4108                	lw	a0,0(a0)
    80002bc2:	00000097          	auipc	ra,0x0
    80002bc6:	8a8080e7          	jalr	-1880(ra) # 8000246a <bread>
    80002bca:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002bcc:	05850793          	addi	a5,a0,88
    80002bd0:	40c8                	lw	a0,4(s1)
    80002bd2:	893d                	andi	a0,a0,15
    80002bd4:	051a                	slli	a0,a0,0x6
    80002bd6:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002bd8:	04449703          	lh	a4,68(s1)
    80002bdc:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002be0:	04649703          	lh	a4,70(s1)
    80002be4:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002be8:	04849703          	lh	a4,72(s1)
    80002bec:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002bf0:	04a49703          	lh	a4,74(s1)
    80002bf4:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002bf8:	44f8                	lw	a4,76(s1)
    80002bfa:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002bfc:	03400613          	li	a2,52
    80002c00:	05048593          	addi	a1,s1,80
    80002c04:	0531                	addi	a0,a0,12
    80002c06:	ffffd097          	auipc	ra,0xffffd
    80002c0a:	66c080e7          	jalr	1644(ra) # 80000272 <memmove>
  log_write(bp);
    80002c0e:	854a                	mv	a0,s2
    80002c10:	00001097          	auipc	ra,0x1
    80002c14:	c06080e7          	jalr	-1018(ra) # 80003816 <log_write>
  brelse(bp);
    80002c18:	854a                	mv	a0,s2
    80002c1a:	00000097          	auipc	ra,0x0
    80002c1e:	980080e7          	jalr	-1664(ra) # 8000259a <brelse>
}
    80002c22:	60e2                	ld	ra,24(sp)
    80002c24:	6442                	ld	s0,16(sp)
    80002c26:	64a2                	ld	s1,8(sp)
    80002c28:	6902                	ld	s2,0(sp)
    80002c2a:	6105                	addi	sp,sp,32
    80002c2c:	8082                	ret

0000000080002c2e <idup>:
{
    80002c2e:	1101                	addi	sp,sp,-32
    80002c30:	ec06                	sd	ra,24(sp)
    80002c32:	e822                	sd	s0,16(sp)
    80002c34:	e426                	sd	s1,8(sp)
    80002c36:	1000                	addi	s0,sp,32
    80002c38:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c3a:	00035517          	auipc	a0,0x35
    80002c3e:	93e50513          	addi	a0,a0,-1730 # 80037578 <itable>
    80002c42:	00003097          	auipc	ra,0x3
    80002c46:	620080e7          	jalr	1568(ra) # 80006262 <acquire>
  ip->ref++;
    80002c4a:	449c                	lw	a5,8(s1)
    80002c4c:	2785                	addiw	a5,a5,1
    80002c4e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c50:	00035517          	auipc	a0,0x35
    80002c54:	92850513          	addi	a0,a0,-1752 # 80037578 <itable>
    80002c58:	00003097          	auipc	ra,0x3
    80002c5c:	6be080e7          	jalr	1726(ra) # 80006316 <release>
}
    80002c60:	8526                	mv	a0,s1
    80002c62:	60e2                	ld	ra,24(sp)
    80002c64:	6442                	ld	s0,16(sp)
    80002c66:	64a2                	ld	s1,8(sp)
    80002c68:	6105                	addi	sp,sp,32
    80002c6a:	8082                	ret

0000000080002c6c <ilock>:
{
    80002c6c:	1101                	addi	sp,sp,-32
    80002c6e:	ec06                	sd	ra,24(sp)
    80002c70:	e822                	sd	s0,16(sp)
    80002c72:	e426                	sd	s1,8(sp)
    80002c74:	e04a                	sd	s2,0(sp)
    80002c76:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002c78:	c115                	beqz	a0,80002c9c <ilock+0x30>
    80002c7a:	84aa                	mv	s1,a0
    80002c7c:	451c                	lw	a5,8(a0)
    80002c7e:	00f05f63          	blez	a5,80002c9c <ilock+0x30>
  acquiresleep(&ip->lock);
    80002c82:	0541                	addi	a0,a0,16
    80002c84:	00001097          	auipc	ra,0x1
    80002c88:	cb2080e7          	jalr	-846(ra) # 80003936 <acquiresleep>
  if(ip->valid == 0){
    80002c8c:	40bc                	lw	a5,64(s1)
    80002c8e:	cf99                	beqz	a5,80002cac <ilock+0x40>
}
    80002c90:	60e2                	ld	ra,24(sp)
    80002c92:	6442                	ld	s0,16(sp)
    80002c94:	64a2                	ld	s1,8(sp)
    80002c96:	6902                	ld	s2,0(sp)
    80002c98:	6105                	addi	sp,sp,32
    80002c9a:	8082                	ret
    panic("ilock");
    80002c9c:	00006517          	auipc	a0,0x6
    80002ca0:	97450513          	addi	a0,a0,-1676 # 80008610 <syscalls+0x180>
    80002ca4:	00003097          	auipc	ra,0x3
    80002ca8:	074080e7          	jalr	116(ra) # 80005d18 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002cac:	40dc                	lw	a5,4(s1)
    80002cae:	0047d79b          	srliw	a5,a5,0x4
    80002cb2:	00035597          	auipc	a1,0x35
    80002cb6:	8be5a583          	lw	a1,-1858(a1) # 80037570 <sb+0x18>
    80002cba:	9dbd                	addw	a1,a1,a5
    80002cbc:	4088                	lw	a0,0(s1)
    80002cbe:	fffff097          	auipc	ra,0xfffff
    80002cc2:	7ac080e7          	jalr	1964(ra) # 8000246a <bread>
    80002cc6:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002cc8:	05850593          	addi	a1,a0,88
    80002ccc:	40dc                	lw	a5,4(s1)
    80002cce:	8bbd                	andi	a5,a5,15
    80002cd0:	079a                	slli	a5,a5,0x6
    80002cd2:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002cd4:	00059783          	lh	a5,0(a1)
    80002cd8:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002cdc:	00259783          	lh	a5,2(a1)
    80002ce0:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002ce4:	00459783          	lh	a5,4(a1)
    80002ce8:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002cec:	00659783          	lh	a5,6(a1)
    80002cf0:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002cf4:	459c                	lw	a5,8(a1)
    80002cf6:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002cf8:	03400613          	li	a2,52
    80002cfc:	05b1                	addi	a1,a1,12
    80002cfe:	05048513          	addi	a0,s1,80
    80002d02:	ffffd097          	auipc	ra,0xffffd
    80002d06:	570080e7          	jalr	1392(ra) # 80000272 <memmove>
    brelse(bp);
    80002d0a:	854a                	mv	a0,s2
    80002d0c:	00000097          	auipc	ra,0x0
    80002d10:	88e080e7          	jalr	-1906(ra) # 8000259a <brelse>
    ip->valid = 1;
    80002d14:	4785                	li	a5,1
    80002d16:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002d18:	04449783          	lh	a5,68(s1)
    80002d1c:	fbb5                	bnez	a5,80002c90 <ilock+0x24>
      panic("ilock: no type");
    80002d1e:	00006517          	auipc	a0,0x6
    80002d22:	8fa50513          	addi	a0,a0,-1798 # 80008618 <syscalls+0x188>
    80002d26:	00003097          	auipc	ra,0x3
    80002d2a:	ff2080e7          	jalr	-14(ra) # 80005d18 <panic>

0000000080002d2e <iunlock>:
{
    80002d2e:	1101                	addi	sp,sp,-32
    80002d30:	ec06                	sd	ra,24(sp)
    80002d32:	e822                	sd	s0,16(sp)
    80002d34:	e426                	sd	s1,8(sp)
    80002d36:	e04a                	sd	s2,0(sp)
    80002d38:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002d3a:	c905                	beqz	a0,80002d6a <iunlock+0x3c>
    80002d3c:	84aa                	mv	s1,a0
    80002d3e:	01050913          	addi	s2,a0,16
    80002d42:	854a                	mv	a0,s2
    80002d44:	00001097          	auipc	ra,0x1
    80002d48:	c8c080e7          	jalr	-884(ra) # 800039d0 <holdingsleep>
    80002d4c:	cd19                	beqz	a0,80002d6a <iunlock+0x3c>
    80002d4e:	449c                	lw	a5,8(s1)
    80002d50:	00f05d63          	blez	a5,80002d6a <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002d54:	854a                	mv	a0,s2
    80002d56:	00001097          	auipc	ra,0x1
    80002d5a:	c36080e7          	jalr	-970(ra) # 8000398c <releasesleep>
}
    80002d5e:	60e2                	ld	ra,24(sp)
    80002d60:	6442                	ld	s0,16(sp)
    80002d62:	64a2                	ld	s1,8(sp)
    80002d64:	6902                	ld	s2,0(sp)
    80002d66:	6105                	addi	sp,sp,32
    80002d68:	8082                	ret
    panic("iunlock");
    80002d6a:	00006517          	auipc	a0,0x6
    80002d6e:	8be50513          	addi	a0,a0,-1858 # 80008628 <syscalls+0x198>
    80002d72:	00003097          	auipc	ra,0x3
    80002d76:	fa6080e7          	jalr	-90(ra) # 80005d18 <panic>

0000000080002d7a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002d7a:	7179                	addi	sp,sp,-48
    80002d7c:	f406                	sd	ra,40(sp)
    80002d7e:	f022                	sd	s0,32(sp)
    80002d80:	ec26                	sd	s1,24(sp)
    80002d82:	e84a                	sd	s2,16(sp)
    80002d84:	e44e                	sd	s3,8(sp)
    80002d86:	e052                	sd	s4,0(sp)
    80002d88:	1800                	addi	s0,sp,48
    80002d8a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002d8c:	05050493          	addi	s1,a0,80
    80002d90:	08050913          	addi	s2,a0,128
    80002d94:	a021                	j	80002d9c <itrunc+0x22>
    80002d96:	0491                	addi	s1,s1,4
    80002d98:	01248d63          	beq	s1,s2,80002db2 <itrunc+0x38>
    if(ip->addrs[i]){
    80002d9c:	408c                	lw	a1,0(s1)
    80002d9e:	dde5                	beqz	a1,80002d96 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002da0:	0009a503          	lw	a0,0(s3)
    80002da4:	00000097          	auipc	ra,0x0
    80002da8:	90c080e7          	jalr	-1780(ra) # 800026b0 <bfree>
      ip->addrs[i] = 0;
    80002dac:	0004a023          	sw	zero,0(s1)
    80002db0:	b7dd                	j	80002d96 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002db2:	0809a583          	lw	a1,128(s3)
    80002db6:	e185                	bnez	a1,80002dd6 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002db8:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002dbc:	854e                	mv	a0,s3
    80002dbe:	00000097          	auipc	ra,0x0
    80002dc2:	de4080e7          	jalr	-540(ra) # 80002ba2 <iupdate>
}
    80002dc6:	70a2                	ld	ra,40(sp)
    80002dc8:	7402                	ld	s0,32(sp)
    80002dca:	64e2                	ld	s1,24(sp)
    80002dcc:	6942                	ld	s2,16(sp)
    80002dce:	69a2                	ld	s3,8(sp)
    80002dd0:	6a02                	ld	s4,0(sp)
    80002dd2:	6145                	addi	sp,sp,48
    80002dd4:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002dd6:	0009a503          	lw	a0,0(s3)
    80002dda:	fffff097          	auipc	ra,0xfffff
    80002dde:	690080e7          	jalr	1680(ra) # 8000246a <bread>
    80002de2:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002de4:	05850493          	addi	s1,a0,88
    80002de8:	45850913          	addi	s2,a0,1112
    80002dec:	a811                	j	80002e00 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002dee:	0009a503          	lw	a0,0(s3)
    80002df2:	00000097          	auipc	ra,0x0
    80002df6:	8be080e7          	jalr	-1858(ra) # 800026b0 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002dfa:	0491                	addi	s1,s1,4
    80002dfc:	01248563          	beq	s1,s2,80002e06 <itrunc+0x8c>
      if(a[j])
    80002e00:	408c                	lw	a1,0(s1)
    80002e02:	dde5                	beqz	a1,80002dfa <itrunc+0x80>
    80002e04:	b7ed                	j	80002dee <itrunc+0x74>
    brelse(bp);
    80002e06:	8552                	mv	a0,s4
    80002e08:	fffff097          	auipc	ra,0xfffff
    80002e0c:	792080e7          	jalr	1938(ra) # 8000259a <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002e10:	0809a583          	lw	a1,128(s3)
    80002e14:	0009a503          	lw	a0,0(s3)
    80002e18:	00000097          	auipc	ra,0x0
    80002e1c:	898080e7          	jalr	-1896(ra) # 800026b0 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002e20:	0809a023          	sw	zero,128(s3)
    80002e24:	bf51                	j	80002db8 <itrunc+0x3e>

0000000080002e26 <iput>:
{
    80002e26:	1101                	addi	sp,sp,-32
    80002e28:	ec06                	sd	ra,24(sp)
    80002e2a:	e822                	sd	s0,16(sp)
    80002e2c:	e426                	sd	s1,8(sp)
    80002e2e:	e04a                	sd	s2,0(sp)
    80002e30:	1000                	addi	s0,sp,32
    80002e32:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e34:	00034517          	auipc	a0,0x34
    80002e38:	74450513          	addi	a0,a0,1860 # 80037578 <itable>
    80002e3c:	00003097          	auipc	ra,0x3
    80002e40:	426080e7          	jalr	1062(ra) # 80006262 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e44:	4498                	lw	a4,8(s1)
    80002e46:	4785                	li	a5,1
    80002e48:	02f70363          	beq	a4,a5,80002e6e <iput+0x48>
  ip->ref--;
    80002e4c:	449c                	lw	a5,8(s1)
    80002e4e:	37fd                	addiw	a5,a5,-1
    80002e50:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e52:	00034517          	auipc	a0,0x34
    80002e56:	72650513          	addi	a0,a0,1830 # 80037578 <itable>
    80002e5a:	00003097          	auipc	ra,0x3
    80002e5e:	4bc080e7          	jalr	1212(ra) # 80006316 <release>
}
    80002e62:	60e2                	ld	ra,24(sp)
    80002e64:	6442                	ld	s0,16(sp)
    80002e66:	64a2                	ld	s1,8(sp)
    80002e68:	6902                	ld	s2,0(sp)
    80002e6a:	6105                	addi	sp,sp,32
    80002e6c:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e6e:	40bc                	lw	a5,64(s1)
    80002e70:	dff1                	beqz	a5,80002e4c <iput+0x26>
    80002e72:	04a49783          	lh	a5,74(s1)
    80002e76:	fbf9                	bnez	a5,80002e4c <iput+0x26>
    acquiresleep(&ip->lock);
    80002e78:	01048913          	addi	s2,s1,16
    80002e7c:	854a                	mv	a0,s2
    80002e7e:	00001097          	auipc	ra,0x1
    80002e82:	ab8080e7          	jalr	-1352(ra) # 80003936 <acquiresleep>
    release(&itable.lock);
    80002e86:	00034517          	auipc	a0,0x34
    80002e8a:	6f250513          	addi	a0,a0,1778 # 80037578 <itable>
    80002e8e:	00003097          	auipc	ra,0x3
    80002e92:	488080e7          	jalr	1160(ra) # 80006316 <release>
    itrunc(ip);
    80002e96:	8526                	mv	a0,s1
    80002e98:	00000097          	auipc	ra,0x0
    80002e9c:	ee2080e7          	jalr	-286(ra) # 80002d7a <itrunc>
    ip->type = 0;
    80002ea0:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002ea4:	8526                	mv	a0,s1
    80002ea6:	00000097          	auipc	ra,0x0
    80002eaa:	cfc080e7          	jalr	-772(ra) # 80002ba2 <iupdate>
    ip->valid = 0;
    80002eae:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002eb2:	854a                	mv	a0,s2
    80002eb4:	00001097          	auipc	ra,0x1
    80002eb8:	ad8080e7          	jalr	-1320(ra) # 8000398c <releasesleep>
    acquire(&itable.lock);
    80002ebc:	00034517          	auipc	a0,0x34
    80002ec0:	6bc50513          	addi	a0,a0,1724 # 80037578 <itable>
    80002ec4:	00003097          	auipc	ra,0x3
    80002ec8:	39e080e7          	jalr	926(ra) # 80006262 <acquire>
    80002ecc:	b741                	j	80002e4c <iput+0x26>

0000000080002ece <iunlockput>:
{
    80002ece:	1101                	addi	sp,sp,-32
    80002ed0:	ec06                	sd	ra,24(sp)
    80002ed2:	e822                	sd	s0,16(sp)
    80002ed4:	e426                	sd	s1,8(sp)
    80002ed6:	1000                	addi	s0,sp,32
    80002ed8:	84aa                	mv	s1,a0
  iunlock(ip);
    80002eda:	00000097          	auipc	ra,0x0
    80002ede:	e54080e7          	jalr	-428(ra) # 80002d2e <iunlock>
  iput(ip);
    80002ee2:	8526                	mv	a0,s1
    80002ee4:	00000097          	auipc	ra,0x0
    80002ee8:	f42080e7          	jalr	-190(ra) # 80002e26 <iput>
}
    80002eec:	60e2                	ld	ra,24(sp)
    80002eee:	6442                	ld	s0,16(sp)
    80002ef0:	64a2                	ld	s1,8(sp)
    80002ef2:	6105                	addi	sp,sp,32
    80002ef4:	8082                	ret

0000000080002ef6 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002ef6:	1141                	addi	sp,sp,-16
    80002ef8:	e422                	sd	s0,8(sp)
    80002efa:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002efc:	411c                	lw	a5,0(a0)
    80002efe:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002f00:	415c                	lw	a5,4(a0)
    80002f02:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002f04:	04451783          	lh	a5,68(a0)
    80002f08:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002f0c:	04a51783          	lh	a5,74(a0)
    80002f10:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002f14:	04c56783          	lwu	a5,76(a0)
    80002f18:	e99c                	sd	a5,16(a1)
}
    80002f1a:	6422                	ld	s0,8(sp)
    80002f1c:	0141                	addi	sp,sp,16
    80002f1e:	8082                	ret

0000000080002f20 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f20:	457c                	lw	a5,76(a0)
    80002f22:	0ed7e963          	bltu	a5,a3,80003014 <readi+0xf4>
{
    80002f26:	7159                	addi	sp,sp,-112
    80002f28:	f486                	sd	ra,104(sp)
    80002f2a:	f0a2                	sd	s0,96(sp)
    80002f2c:	eca6                	sd	s1,88(sp)
    80002f2e:	e8ca                	sd	s2,80(sp)
    80002f30:	e4ce                	sd	s3,72(sp)
    80002f32:	e0d2                	sd	s4,64(sp)
    80002f34:	fc56                	sd	s5,56(sp)
    80002f36:	f85a                	sd	s6,48(sp)
    80002f38:	f45e                	sd	s7,40(sp)
    80002f3a:	f062                	sd	s8,32(sp)
    80002f3c:	ec66                	sd	s9,24(sp)
    80002f3e:	e86a                	sd	s10,16(sp)
    80002f40:	e46e                	sd	s11,8(sp)
    80002f42:	1880                	addi	s0,sp,112
    80002f44:	8baa                	mv	s7,a0
    80002f46:	8c2e                	mv	s8,a1
    80002f48:	8ab2                	mv	s5,a2
    80002f4a:	84b6                	mv	s1,a3
    80002f4c:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002f4e:	9f35                	addw	a4,a4,a3
    return 0;
    80002f50:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002f52:	0ad76063          	bltu	a4,a3,80002ff2 <readi+0xd2>
  if(off + n > ip->size)
    80002f56:	00e7f463          	bgeu	a5,a4,80002f5e <readi+0x3e>
    n = ip->size - off;
    80002f5a:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f5e:	0a0b0963          	beqz	s6,80003010 <readi+0xf0>
    80002f62:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f64:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002f68:	5cfd                	li	s9,-1
    80002f6a:	a82d                	j	80002fa4 <readi+0x84>
    80002f6c:	020a1d93          	slli	s11,s4,0x20
    80002f70:	020ddd93          	srli	s11,s11,0x20
    80002f74:	05890613          	addi	a2,s2,88
    80002f78:	86ee                	mv	a3,s11
    80002f7a:	963a                	add	a2,a2,a4
    80002f7c:	85d6                	mv	a1,s5
    80002f7e:	8562                	mv	a0,s8
    80002f80:	fffff097          	auipc	ra,0xfffff
    80002f84:	a02080e7          	jalr	-1534(ra) # 80001982 <either_copyout>
    80002f88:	05950d63          	beq	a0,s9,80002fe2 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f8c:	854a                	mv	a0,s2
    80002f8e:	fffff097          	auipc	ra,0xfffff
    80002f92:	60c080e7          	jalr	1548(ra) # 8000259a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f96:	013a09bb          	addw	s3,s4,s3
    80002f9a:	009a04bb          	addw	s1,s4,s1
    80002f9e:	9aee                	add	s5,s5,s11
    80002fa0:	0569f763          	bgeu	s3,s6,80002fee <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002fa4:	000ba903          	lw	s2,0(s7)
    80002fa8:	00a4d59b          	srliw	a1,s1,0xa
    80002fac:	855e                	mv	a0,s7
    80002fae:	00000097          	auipc	ra,0x0
    80002fb2:	8b0080e7          	jalr	-1872(ra) # 8000285e <bmap>
    80002fb6:	0005059b          	sext.w	a1,a0
    80002fba:	854a                	mv	a0,s2
    80002fbc:	fffff097          	auipc	ra,0xfffff
    80002fc0:	4ae080e7          	jalr	1198(ra) # 8000246a <bread>
    80002fc4:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fc6:	3ff4f713          	andi	a4,s1,1023
    80002fca:	40ed07bb          	subw	a5,s10,a4
    80002fce:	413b06bb          	subw	a3,s6,s3
    80002fd2:	8a3e                	mv	s4,a5
    80002fd4:	2781                	sext.w	a5,a5
    80002fd6:	0006861b          	sext.w	a2,a3
    80002fda:	f8f679e3          	bgeu	a2,a5,80002f6c <readi+0x4c>
    80002fde:	8a36                	mv	s4,a3
    80002fe0:	b771                	j	80002f6c <readi+0x4c>
      brelse(bp);
    80002fe2:	854a                	mv	a0,s2
    80002fe4:	fffff097          	auipc	ra,0xfffff
    80002fe8:	5b6080e7          	jalr	1462(ra) # 8000259a <brelse>
      tot = -1;
    80002fec:	59fd                	li	s3,-1
  }
  return tot;
    80002fee:	0009851b          	sext.w	a0,s3
}
    80002ff2:	70a6                	ld	ra,104(sp)
    80002ff4:	7406                	ld	s0,96(sp)
    80002ff6:	64e6                	ld	s1,88(sp)
    80002ff8:	6946                	ld	s2,80(sp)
    80002ffa:	69a6                	ld	s3,72(sp)
    80002ffc:	6a06                	ld	s4,64(sp)
    80002ffe:	7ae2                	ld	s5,56(sp)
    80003000:	7b42                	ld	s6,48(sp)
    80003002:	7ba2                	ld	s7,40(sp)
    80003004:	7c02                	ld	s8,32(sp)
    80003006:	6ce2                	ld	s9,24(sp)
    80003008:	6d42                	ld	s10,16(sp)
    8000300a:	6da2                	ld	s11,8(sp)
    8000300c:	6165                	addi	sp,sp,112
    8000300e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003010:	89da                	mv	s3,s6
    80003012:	bff1                	j	80002fee <readi+0xce>
    return 0;
    80003014:	4501                	li	a0,0
}
    80003016:	8082                	ret

0000000080003018 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003018:	457c                	lw	a5,76(a0)
    8000301a:	10d7e863          	bltu	a5,a3,8000312a <writei+0x112>
{
    8000301e:	7159                	addi	sp,sp,-112
    80003020:	f486                	sd	ra,104(sp)
    80003022:	f0a2                	sd	s0,96(sp)
    80003024:	eca6                	sd	s1,88(sp)
    80003026:	e8ca                	sd	s2,80(sp)
    80003028:	e4ce                	sd	s3,72(sp)
    8000302a:	e0d2                	sd	s4,64(sp)
    8000302c:	fc56                	sd	s5,56(sp)
    8000302e:	f85a                	sd	s6,48(sp)
    80003030:	f45e                	sd	s7,40(sp)
    80003032:	f062                	sd	s8,32(sp)
    80003034:	ec66                	sd	s9,24(sp)
    80003036:	e86a                	sd	s10,16(sp)
    80003038:	e46e                	sd	s11,8(sp)
    8000303a:	1880                	addi	s0,sp,112
    8000303c:	8b2a                	mv	s6,a0
    8000303e:	8c2e                	mv	s8,a1
    80003040:	8ab2                	mv	s5,a2
    80003042:	8936                	mv	s2,a3
    80003044:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003046:	00e687bb          	addw	a5,a3,a4
    8000304a:	0ed7e263          	bltu	a5,a3,8000312e <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000304e:	00043737          	lui	a4,0x43
    80003052:	0ef76063          	bltu	a4,a5,80003132 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003056:	0c0b8863          	beqz	s7,80003126 <writei+0x10e>
    8000305a:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    8000305c:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003060:	5cfd                	li	s9,-1
    80003062:	a091                	j	800030a6 <writei+0x8e>
    80003064:	02099d93          	slli	s11,s3,0x20
    80003068:	020ddd93          	srli	s11,s11,0x20
    8000306c:	05848513          	addi	a0,s1,88
    80003070:	86ee                	mv	a3,s11
    80003072:	8656                	mv	a2,s5
    80003074:	85e2                	mv	a1,s8
    80003076:	953a                	add	a0,a0,a4
    80003078:	fffff097          	auipc	ra,0xfffff
    8000307c:	960080e7          	jalr	-1696(ra) # 800019d8 <either_copyin>
    80003080:	07950263          	beq	a0,s9,800030e4 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003084:	8526                	mv	a0,s1
    80003086:	00000097          	auipc	ra,0x0
    8000308a:	790080e7          	jalr	1936(ra) # 80003816 <log_write>
    brelse(bp);
    8000308e:	8526                	mv	a0,s1
    80003090:	fffff097          	auipc	ra,0xfffff
    80003094:	50a080e7          	jalr	1290(ra) # 8000259a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003098:	01498a3b          	addw	s4,s3,s4
    8000309c:	0129893b          	addw	s2,s3,s2
    800030a0:	9aee                	add	s5,s5,s11
    800030a2:	057a7663          	bgeu	s4,s7,800030ee <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800030a6:	000b2483          	lw	s1,0(s6)
    800030aa:	00a9559b          	srliw	a1,s2,0xa
    800030ae:	855a                	mv	a0,s6
    800030b0:	fffff097          	auipc	ra,0xfffff
    800030b4:	7ae080e7          	jalr	1966(ra) # 8000285e <bmap>
    800030b8:	0005059b          	sext.w	a1,a0
    800030bc:	8526                	mv	a0,s1
    800030be:	fffff097          	auipc	ra,0xfffff
    800030c2:	3ac080e7          	jalr	940(ra) # 8000246a <bread>
    800030c6:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030c8:	3ff97713          	andi	a4,s2,1023
    800030cc:	40ed07bb          	subw	a5,s10,a4
    800030d0:	414b86bb          	subw	a3,s7,s4
    800030d4:	89be                	mv	s3,a5
    800030d6:	2781                	sext.w	a5,a5
    800030d8:	0006861b          	sext.w	a2,a3
    800030dc:	f8f674e3          	bgeu	a2,a5,80003064 <writei+0x4c>
    800030e0:	89b6                	mv	s3,a3
    800030e2:	b749                	j	80003064 <writei+0x4c>
      brelse(bp);
    800030e4:	8526                	mv	a0,s1
    800030e6:	fffff097          	auipc	ra,0xfffff
    800030ea:	4b4080e7          	jalr	1204(ra) # 8000259a <brelse>
  }

  if(off > ip->size)
    800030ee:	04cb2783          	lw	a5,76(s6)
    800030f2:	0127f463          	bgeu	a5,s2,800030fa <writei+0xe2>
    ip->size = off;
    800030f6:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800030fa:	855a                	mv	a0,s6
    800030fc:	00000097          	auipc	ra,0x0
    80003100:	aa6080e7          	jalr	-1370(ra) # 80002ba2 <iupdate>

  return tot;
    80003104:	000a051b          	sext.w	a0,s4
}
    80003108:	70a6                	ld	ra,104(sp)
    8000310a:	7406                	ld	s0,96(sp)
    8000310c:	64e6                	ld	s1,88(sp)
    8000310e:	6946                	ld	s2,80(sp)
    80003110:	69a6                	ld	s3,72(sp)
    80003112:	6a06                	ld	s4,64(sp)
    80003114:	7ae2                	ld	s5,56(sp)
    80003116:	7b42                	ld	s6,48(sp)
    80003118:	7ba2                	ld	s7,40(sp)
    8000311a:	7c02                	ld	s8,32(sp)
    8000311c:	6ce2                	ld	s9,24(sp)
    8000311e:	6d42                	ld	s10,16(sp)
    80003120:	6da2                	ld	s11,8(sp)
    80003122:	6165                	addi	sp,sp,112
    80003124:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003126:	8a5e                	mv	s4,s7
    80003128:	bfc9                	j	800030fa <writei+0xe2>
    return -1;
    8000312a:	557d                	li	a0,-1
}
    8000312c:	8082                	ret
    return -1;
    8000312e:	557d                	li	a0,-1
    80003130:	bfe1                	j	80003108 <writei+0xf0>
    return -1;
    80003132:	557d                	li	a0,-1
    80003134:	bfd1                	j	80003108 <writei+0xf0>

0000000080003136 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003136:	1141                	addi	sp,sp,-16
    80003138:	e406                	sd	ra,8(sp)
    8000313a:	e022                	sd	s0,0(sp)
    8000313c:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000313e:	4639                	li	a2,14
    80003140:	ffffd097          	auipc	ra,0xffffd
    80003144:	1aa080e7          	jalr	426(ra) # 800002ea <strncmp>
}
    80003148:	60a2                	ld	ra,8(sp)
    8000314a:	6402                	ld	s0,0(sp)
    8000314c:	0141                	addi	sp,sp,16
    8000314e:	8082                	ret

0000000080003150 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003150:	7139                	addi	sp,sp,-64
    80003152:	fc06                	sd	ra,56(sp)
    80003154:	f822                	sd	s0,48(sp)
    80003156:	f426                	sd	s1,40(sp)
    80003158:	f04a                	sd	s2,32(sp)
    8000315a:	ec4e                	sd	s3,24(sp)
    8000315c:	e852                	sd	s4,16(sp)
    8000315e:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003160:	04451703          	lh	a4,68(a0)
    80003164:	4785                	li	a5,1
    80003166:	00f71a63          	bne	a4,a5,8000317a <dirlookup+0x2a>
    8000316a:	892a                	mv	s2,a0
    8000316c:	89ae                	mv	s3,a1
    8000316e:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003170:	457c                	lw	a5,76(a0)
    80003172:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003174:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003176:	e79d                	bnez	a5,800031a4 <dirlookup+0x54>
    80003178:	a8a5                	j	800031f0 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000317a:	00005517          	auipc	a0,0x5
    8000317e:	4b650513          	addi	a0,a0,1206 # 80008630 <syscalls+0x1a0>
    80003182:	00003097          	auipc	ra,0x3
    80003186:	b96080e7          	jalr	-1130(ra) # 80005d18 <panic>
      panic("dirlookup read");
    8000318a:	00005517          	auipc	a0,0x5
    8000318e:	4be50513          	addi	a0,a0,1214 # 80008648 <syscalls+0x1b8>
    80003192:	00003097          	auipc	ra,0x3
    80003196:	b86080e7          	jalr	-1146(ra) # 80005d18 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000319a:	24c1                	addiw	s1,s1,16
    8000319c:	04c92783          	lw	a5,76(s2)
    800031a0:	04f4f763          	bgeu	s1,a5,800031ee <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031a4:	4741                	li	a4,16
    800031a6:	86a6                	mv	a3,s1
    800031a8:	fc040613          	addi	a2,s0,-64
    800031ac:	4581                	li	a1,0
    800031ae:	854a                	mv	a0,s2
    800031b0:	00000097          	auipc	ra,0x0
    800031b4:	d70080e7          	jalr	-656(ra) # 80002f20 <readi>
    800031b8:	47c1                	li	a5,16
    800031ba:	fcf518e3          	bne	a0,a5,8000318a <dirlookup+0x3a>
    if(de.inum == 0)
    800031be:	fc045783          	lhu	a5,-64(s0)
    800031c2:	dfe1                	beqz	a5,8000319a <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800031c4:	fc240593          	addi	a1,s0,-62
    800031c8:	854e                	mv	a0,s3
    800031ca:	00000097          	auipc	ra,0x0
    800031ce:	f6c080e7          	jalr	-148(ra) # 80003136 <namecmp>
    800031d2:	f561                	bnez	a0,8000319a <dirlookup+0x4a>
      if(poff)
    800031d4:	000a0463          	beqz	s4,800031dc <dirlookup+0x8c>
        *poff = off;
    800031d8:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800031dc:	fc045583          	lhu	a1,-64(s0)
    800031e0:	00092503          	lw	a0,0(s2)
    800031e4:	fffff097          	auipc	ra,0xfffff
    800031e8:	754080e7          	jalr	1876(ra) # 80002938 <iget>
    800031ec:	a011                	j	800031f0 <dirlookup+0xa0>
  return 0;
    800031ee:	4501                	li	a0,0
}
    800031f0:	70e2                	ld	ra,56(sp)
    800031f2:	7442                	ld	s0,48(sp)
    800031f4:	74a2                	ld	s1,40(sp)
    800031f6:	7902                	ld	s2,32(sp)
    800031f8:	69e2                	ld	s3,24(sp)
    800031fa:	6a42                	ld	s4,16(sp)
    800031fc:	6121                	addi	sp,sp,64
    800031fe:	8082                	ret

0000000080003200 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003200:	711d                	addi	sp,sp,-96
    80003202:	ec86                	sd	ra,88(sp)
    80003204:	e8a2                	sd	s0,80(sp)
    80003206:	e4a6                	sd	s1,72(sp)
    80003208:	e0ca                	sd	s2,64(sp)
    8000320a:	fc4e                	sd	s3,56(sp)
    8000320c:	f852                	sd	s4,48(sp)
    8000320e:	f456                	sd	s5,40(sp)
    80003210:	f05a                	sd	s6,32(sp)
    80003212:	ec5e                	sd	s7,24(sp)
    80003214:	e862                	sd	s8,16(sp)
    80003216:	e466                	sd	s9,8(sp)
    80003218:	1080                	addi	s0,sp,96
    8000321a:	84aa                	mv	s1,a0
    8000321c:	8b2e                	mv	s6,a1
    8000321e:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003220:	00054703          	lbu	a4,0(a0)
    80003224:	02f00793          	li	a5,47
    80003228:	02f70363          	beq	a4,a5,8000324e <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000322c:	ffffe097          	auipc	ra,0xffffe
    80003230:	cf6080e7          	jalr	-778(ra) # 80000f22 <myproc>
    80003234:	15053503          	ld	a0,336(a0)
    80003238:	00000097          	auipc	ra,0x0
    8000323c:	9f6080e7          	jalr	-1546(ra) # 80002c2e <idup>
    80003240:	89aa                	mv	s3,a0
  while(*path == '/')
    80003242:	02f00913          	li	s2,47
  len = path - s;
    80003246:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    80003248:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000324a:	4c05                	li	s8,1
    8000324c:	a865                	j	80003304 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    8000324e:	4585                	li	a1,1
    80003250:	4505                	li	a0,1
    80003252:	fffff097          	auipc	ra,0xfffff
    80003256:	6e6080e7          	jalr	1766(ra) # 80002938 <iget>
    8000325a:	89aa                	mv	s3,a0
    8000325c:	b7dd                	j	80003242 <namex+0x42>
      iunlockput(ip);
    8000325e:	854e                	mv	a0,s3
    80003260:	00000097          	auipc	ra,0x0
    80003264:	c6e080e7          	jalr	-914(ra) # 80002ece <iunlockput>
      return 0;
    80003268:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000326a:	854e                	mv	a0,s3
    8000326c:	60e6                	ld	ra,88(sp)
    8000326e:	6446                	ld	s0,80(sp)
    80003270:	64a6                	ld	s1,72(sp)
    80003272:	6906                	ld	s2,64(sp)
    80003274:	79e2                	ld	s3,56(sp)
    80003276:	7a42                	ld	s4,48(sp)
    80003278:	7aa2                	ld	s5,40(sp)
    8000327a:	7b02                	ld	s6,32(sp)
    8000327c:	6be2                	ld	s7,24(sp)
    8000327e:	6c42                	ld	s8,16(sp)
    80003280:	6ca2                	ld	s9,8(sp)
    80003282:	6125                	addi	sp,sp,96
    80003284:	8082                	ret
      iunlock(ip);
    80003286:	854e                	mv	a0,s3
    80003288:	00000097          	auipc	ra,0x0
    8000328c:	aa6080e7          	jalr	-1370(ra) # 80002d2e <iunlock>
      return ip;
    80003290:	bfe9                	j	8000326a <namex+0x6a>
      iunlockput(ip);
    80003292:	854e                	mv	a0,s3
    80003294:	00000097          	auipc	ra,0x0
    80003298:	c3a080e7          	jalr	-966(ra) # 80002ece <iunlockput>
      return 0;
    8000329c:	89d2                	mv	s3,s4
    8000329e:	b7f1                	j	8000326a <namex+0x6a>
  len = path - s;
    800032a0:	40b48633          	sub	a2,s1,a1
    800032a4:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    800032a8:	094cd463          	bge	s9,s4,80003330 <namex+0x130>
    memmove(name, s, DIRSIZ);
    800032ac:	4639                	li	a2,14
    800032ae:	8556                	mv	a0,s5
    800032b0:	ffffd097          	auipc	ra,0xffffd
    800032b4:	fc2080e7          	jalr	-62(ra) # 80000272 <memmove>
  while(*path == '/')
    800032b8:	0004c783          	lbu	a5,0(s1)
    800032bc:	01279763          	bne	a5,s2,800032ca <namex+0xca>
    path++;
    800032c0:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032c2:	0004c783          	lbu	a5,0(s1)
    800032c6:	ff278de3          	beq	a5,s2,800032c0 <namex+0xc0>
    ilock(ip);
    800032ca:	854e                	mv	a0,s3
    800032cc:	00000097          	auipc	ra,0x0
    800032d0:	9a0080e7          	jalr	-1632(ra) # 80002c6c <ilock>
    if(ip->type != T_DIR){
    800032d4:	04499783          	lh	a5,68(s3)
    800032d8:	f98793e3          	bne	a5,s8,8000325e <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800032dc:	000b0563          	beqz	s6,800032e6 <namex+0xe6>
    800032e0:	0004c783          	lbu	a5,0(s1)
    800032e4:	d3cd                	beqz	a5,80003286 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800032e6:	865e                	mv	a2,s7
    800032e8:	85d6                	mv	a1,s5
    800032ea:	854e                	mv	a0,s3
    800032ec:	00000097          	auipc	ra,0x0
    800032f0:	e64080e7          	jalr	-412(ra) # 80003150 <dirlookup>
    800032f4:	8a2a                	mv	s4,a0
    800032f6:	dd51                	beqz	a0,80003292 <namex+0x92>
    iunlockput(ip);
    800032f8:	854e                	mv	a0,s3
    800032fa:	00000097          	auipc	ra,0x0
    800032fe:	bd4080e7          	jalr	-1068(ra) # 80002ece <iunlockput>
    ip = next;
    80003302:	89d2                	mv	s3,s4
  while(*path == '/')
    80003304:	0004c783          	lbu	a5,0(s1)
    80003308:	05279763          	bne	a5,s2,80003356 <namex+0x156>
    path++;
    8000330c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000330e:	0004c783          	lbu	a5,0(s1)
    80003312:	ff278de3          	beq	a5,s2,8000330c <namex+0x10c>
  if(*path == 0)
    80003316:	c79d                	beqz	a5,80003344 <namex+0x144>
    path++;
    80003318:	85a6                	mv	a1,s1
  len = path - s;
    8000331a:	8a5e                	mv	s4,s7
    8000331c:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    8000331e:	01278963          	beq	a5,s2,80003330 <namex+0x130>
    80003322:	dfbd                	beqz	a5,800032a0 <namex+0xa0>
    path++;
    80003324:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003326:	0004c783          	lbu	a5,0(s1)
    8000332a:	ff279ce3          	bne	a5,s2,80003322 <namex+0x122>
    8000332e:	bf8d                	j	800032a0 <namex+0xa0>
    memmove(name, s, len);
    80003330:	2601                	sext.w	a2,a2
    80003332:	8556                	mv	a0,s5
    80003334:	ffffd097          	auipc	ra,0xffffd
    80003338:	f3e080e7          	jalr	-194(ra) # 80000272 <memmove>
    name[len] = 0;
    8000333c:	9a56                	add	s4,s4,s5
    8000333e:	000a0023          	sb	zero,0(s4)
    80003342:	bf9d                	j	800032b8 <namex+0xb8>
  if(nameiparent){
    80003344:	f20b03e3          	beqz	s6,8000326a <namex+0x6a>
    iput(ip);
    80003348:	854e                	mv	a0,s3
    8000334a:	00000097          	auipc	ra,0x0
    8000334e:	adc080e7          	jalr	-1316(ra) # 80002e26 <iput>
    return 0;
    80003352:	4981                	li	s3,0
    80003354:	bf19                	j	8000326a <namex+0x6a>
  if(*path == 0)
    80003356:	d7fd                	beqz	a5,80003344 <namex+0x144>
  while(*path != '/' && *path != 0)
    80003358:	0004c783          	lbu	a5,0(s1)
    8000335c:	85a6                	mv	a1,s1
    8000335e:	b7d1                	j	80003322 <namex+0x122>

0000000080003360 <dirlink>:
{
    80003360:	7139                	addi	sp,sp,-64
    80003362:	fc06                	sd	ra,56(sp)
    80003364:	f822                	sd	s0,48(sp)
    80003366:	f426                	sd	s1,40(sp)
    80003368:	f04a                	sd	s2,32(sp)
    8000336a:	ec4e                	sd	s3,24(sp)
    8000336c:	e852                	sd	s4,16(sp)
    8000336e:	0080                	addi	s0,sp,64
    80003370:	892a                	mv	s2,a0
    80003372:	8a2e                	mv	s4,a1
    80003374:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003376:	4601                	li	a2,0
    80003378:	00000097          	auipc	ra,0x0
    8000337c:	dd8080e7          	jalr	-552(ra) # 80003150 <dirlookup>
    80003380:	e93d                	bnez	a0,800033f6 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003382:	04c92483          	lw	s1,76(s2)
    80003386:	c49d                	beqz	s1,800033b4 <dirlink+0x54>
    80003388:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000338a:	4741                	li	a4,16
    8000338c:	86a6                	mv	a3,s1
    8000338e:	fc040613          	addi	a2,s0,-64
    80003392:	4581                	li	a1,0
    80003394:	854a                	mv	a0,s2
    80003396:	00000097          	auipc	ra,0x0
    8000339a:	b8a080e7          	jalr	-1142(ra) # 80002f20 <readi>
    8000339e:	47c1                	li	a5,16
    800033a0:	06f51163          	bne	a0,a5,80003402 <dirlink+0xa2>
    if(de.inum == 0)
    800033a4:	fc045783          	lhu	a5,-64(s0)
    800033a8:	c791                	beqz	a5,800033b4 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033aa:	24c1                	addiw	s1,s1,16
    800033ac:	04c92783          	lw	a5,76(s2)
    800033b0:	fcf4ede3          	bltu	s1,a5,8000338a <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800033b4:	4639                	li	a2,14
    800033b6:	85d2                	mv	a1,s4
    800033b8:	fc240513          	addi	a0,s0,-62
    800033bc:	ffffd097          	auipc	ra,0xffffd
    800033c0:	f6a080e7          	jalr	-150(ra) # 80000326 <strncpy>
  de.inum = inum;
    800033c4:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033c8:	4741                	li	a4,16
    800033ca:	86a6                	mv	a3,s1
    800033cc:	fc040613          	addi	a2,s0,-64
    800033d0:	4581                	li	a1,0
    800033d2:	854a                	mv	a0,s2
    800033d4:	00000097          	auipc	ra,0x0
    800033d8:	c44080e7          	jalr	-956(ra) # 80003018 <writei>
    800033dc:	872a                	mv	a4,a0
    800033de:	47c1                	li	a5,16
  return 0;
    800033e0:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033e2:	02f71863          	bne	a4,a5,80003412 <dirlink+0xb2>
}
    800033e6:	70e2                	ld	ra,56(sp)
    800033e8:	7442                	ld	s0,48(sp)
    800033ea:	74a2                	ld	s1,40(sp)
    800033ec:	7902                	ld	s2,32(sp)
    800033ee:	69e2                	ld	s3,24(sp)
    800033f0:	6a42                	ld	s4,16(sp)
    800033f2:	6121                	addi	sp,sp,64
    800033f4:	8082                	ret
    iput(ip);
    800033f6:	00000097          	auipc	ra,0x0
    800033fa:	a30080e7          	jalr	-1488(ra) # 80002e26 <iput>
    return -1;
    800033fe:	557d                	li	a0,-1
    80003400:	b7dd                	j	800033e6 <dirlink+0x86>
      panic("dirlink read");
    80003402:	00005517          	auipc	a0,0x5
    80003406:	25650513          	addi	a0,a0,598 # 80008658 <syscalls+0x1c8>
    8000340a:	00003097          	auipc	ra,0x3
    8000340e:	90e080e7          	jalr	-1778(ra) # 80005d18 <panic>
    panic("dirlink");
    80003412:	00005517          	auipc	a0,0x5
    80003416:	35650513          	addi	a0,a0,854 # 80008768 <syscalls+0x2d8>
    8000341a:	00003097          	auipc	ra,0x3
    8000341e:	8fe080e7          	jalr	-1794(ra) # 80005d18 <panic>

0000000080003422 <namei>:

struct inode*
namei(char *path)
{
    80003422:	1101                	addi	sp,sp,-32
    80003424:	ec06                	sd	ra,24(sp)
    80003426:	e822                	sd	s0,16(sp)
    80003428:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000342a:	fe040613          	addi	a2,s0,-32
    8000342e:	4581                	li	a1,0
    80003430:	00000097          	auipc	ra,0x0
    80003434:	dd0080e7          	jalr	-560(ra) # 80003200 <namex>
}
    80003438:	60e2                	ld	ra,24(sp)
    8000343a:	6442                	ld	s0,16(sp)
    8000343c:	6105                	addi	sp,sp,32
    8000343e:	8082                	ret

0000000080003440 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003440:	1141                	addi	sp,sp,-16
    80003442:	e406                	sd	ra,8(sp)
    80003444:	e022                	sd	s0,0(sp)
    80003446:	0800                	addi	s0,sp,16
    80003448:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000344a:	4585                	li	a1,1
    8000344c:	00000097          	auipc	ra,0x0
    80003450:	db4080e7          	jalr	-588(ra) # 80003200 <namex>
}
    80003454:	60a2                	ld	ra,8(sp)
    80003456:	6402                	ld	s0,0(sp)
    80003458:	0141                	addi	sp,sp,16
    8000345a:	8082                	ret

000000008000345c <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000345c:	1101                	addi	sp,sp,-32
    8000345e:	ec06                	sd	ra,24(sp)
    80003460:	e822                	sd	s0,16(sp)
    80003462:	e426                	sd	s1,8(sp)
    80003464:	e04a                	sd	s2,0(sp)
    80003466:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003468:	00036917          	auipc	s2,0x36
    8000346c:	bb890913          	addi	s2,s2,-1096 # 80039020 <log>
    80003470:	01892583          	lw	a1,24(s2)
    80003474:	02892503          	lw	a0,40(s2)
    80003478:	fffff097          	auipc	ra,0xfffff
    8000347c:	ff2080e7          	jalr	-14(ra) # 8000246a <bread>
    80003480:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003482:	02c92683          	lw	a3,44(s2)
    80003486:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003488:	02d05763          	blez	a3,800034b6 <write_head+0x5a>
    8000348c:	00036797          	auipc	a5,0x36
    80003490:	bc478793          	addi	a5,a5,-1084 # 80039050 <log+0x30>
    80003494:	05c50713          	addi	a4,a0,92
    80003498:	36fd                	addiw	a3,a3,-1
    8000349a:	1682                	slli	a3,a3,0x20
    8000349c:	9281                	srli	a3,a3,0x20
    8000349e:	068a                	slli	a3,a3,0x2
    800034a0:	00036617          	auipc	a2,0x36
    800034a4:	bb460613          	addi	a2,a2,-1100 # 80039054 <log+0x34>
    800034a8:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800034aa:	4390                	lw	a2,0(a5)
    800034ac:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800034ae:	0791                	addi	a5,a5,4
    800034b0:	0711                	addi	a4,a4,4
    800034b2:	fed79ce3          	bne	a5,a3,800034aa <write_head+0x4e>
  }
  bwrite(buf);
    800034b6:	8526                	mv	a0,s1
    800034b8:	fffff097          	auipc	ra,0xfffff
    800034bc:	0a4080e7          	jalr	164(ra) # 8000255c <bwrite>
  brelse(buf);
    800034c0:	8526                	mv	a0,s1
    800034c2:	fffff097          	auipc	ra,0xfffff
    800034c6:	0d8080e7          	jalr	216(ra) # 8000259a <brelse>
}
    800034ca:	60e2                	ld	ra,24(sp)
    800034cc:	6442                	ld	s0,16(sp)
    800034ce:	64a2                	ld	s1,8(sp)
    800034d0:	6902                	ld	s2,0(sp)
    800034d2:	6105                	addi	sp,sp,32
    800034d4:	8082                	ret

00000000800034d6 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800034d6:	00036797          	auipc	a5,0x36
    800034da:	b767a783          	lw	a5,-1162(a5) # 8003904c <log+0x2c>
    800034de:	0af05d63          	blez	a5,80003598 <install_trans+0xc2>
{
    800034e2:	7139                	addi	sp,sp,-64
    800034e4:	fc06                	sd	ra,56(sp)
    800034e6:	f822                	sd	s0,48(sp)
    800034e8:	f426                	sd	s1,40(sp)
    800034ea:	f04a                	sd	s2,32(sp)
    800034ec:	ec4e                	sd	s3,24(sp)
    800034ee:	e852                	sd	s4,16(sp)
    800034f0:	e456                	sd	s5,8(sp)
    800034f2:	e05a                	sd	s6,0(sp)
    800034f4:	0080                	addi	s0,sp,64
    800034f6:	8b2a                	mv	s6,a0
    800034f8:	00036a97          	auipc	s5,0x36
    800034fc:	b58a8a93          	addi	s5,s5,-1192 # 80039050 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003500:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003502:	00036997          	auipc	s3,0x36
    80003506:	b1e98993          	addi	s3,s3,-1250 # 80039020 <log>
    8000350a:	a035                	j	80003536 <install_trans+0x60>
      bunpin(dbuf);
    8000350c:	8526                	mv	a0,s1
    8000350e:	fffff097          	auipc	ra,0xfffff
    80003512:	166080e7          	jalr	358(ra) # 80002674 <bunpin>
    brelse(lbuf);
    80003516:	854a                	mv	a0,s2
    80003518:	fffff097          	auipc	ra,0xfffff
    8000351c:	082080e7          	jalr	130(ra) # 8000259a <brelse>
    brelse(dbuf);
    80003520:	8526                	mv	a0,s1
    80003522:	fffff097          	auipc	ra,0xfffff
    80003526:	078080e7          	jalr	120(ra) # 8000259a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000352a:	2a05                	addiw	s4,s4,1
    8000352c:	0a91                	addi	s5,s5,4
    8000352e:	02c9a783          	lw	a5,44(s3)
    80003532:	04fa5963          	bge	s4,a5,80003584 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003536:	0189a583          	lw	a1,24(s3)
    8000353a:	014585bb          	addw	a1,a1,s4
    8000353e:	2585                	addiw	a1,a1,1
    80003540:	0289a503          	lw	a0,40(s3)
    80003544:	fffff097          	auipc	ra,0xfffff
    80003548:	f26080e7          	jalr	-218(ra) # 8000246a <bread>
    8000354c:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000354e:	000aa583          	lw	a1,0(s5)
    80003552:	0289a503          	lw	a0,40(s3)
    80003556:	fffff097          	auipc	ra,0xfffff
    8000355a:	f14080e7          	jalr	-236(ra) # 8000246a <bread>
    8000355e:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003560:	40000613          	li	a2,1024
    80003564:	05890593          	addi	a1,s2,88
    80003568:	05850513          	addi	a0,a0,88
    8000356c:	ffffd097          	auipc	ra,0xffffd
    80003570:	d06080e7          	jalr	-762(ra) # 80000272 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003574:	8526                	mv	a0,s1
    80003576:	fffff097          	auipc	ra,0xfffff
    8000357a:	fe6080e7          	jalr	-26(ra) # 8000255c <bwrite>
    if(recovering == 0)
    8000357e:	f80b1ce3          	bnez	s6,80003516 <install_trans+0x40>
    80003582:	b769                	j	8000350c <install_trans+0x36>
}
    80003584:	70e2                	ld	ra,56(sp)
    80003586:	7442                	ld	s0,48(sp)
    80003588:	74a2                	ld	s1,40(sp)
    8000358a:	7902                	ld	s2,32(sp)
    8000358c:	69e2                	ld	s3,24(sp)
    8000358e:	6a42                	ld	s4,16(sp)
    80003590:	6aa2                	ld	s5,8(sp)
    80003592:	6b02                	ld	s6,0(sp)
    80003594:	6121                	addi	sp,sp,64
    80003596:	8082                	ret
    80003598:	8082                	ret

000000008000359a <initlog>:
{
    8000359a:	7179                	addi	sp,sp,-48
    8000359c:	f406                	sd	ra,40(sp)
    8000359e:	f022                	sd	s0,32(sp)
    800035a0:	ec26                	sd	s1,24(sp)
    800035a2:	e84a                	sd	s2,16(sp)
    800035a4:	e44e                	sd	s3,8(sp)
    800035a6:	1800                	addi	s0,sp,48
    800035a8:	892a                	mv	s2,a0
    800035aa:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800035ac:	00036497          	auipc	s1,0x36
    800035b0:	a7448493          	addi	s1,s1,-1420 # 80039020 <log>
    800035b4:	00005597          	auipc	a1,0x5
    800035b8:	0b458593          	addi	a1,a1,180 # 80008668 <syscalls+0x1d8>
    800035bc:	8526                	mv	a0,s1
    800035be:	00003097          	auipc	ra,0x3
    800035c2:	c14080e7          	jalr	-1004(ra) # 800061d2 <initlock>
  log.start = sb->logstart;
    800035c6:	0149a583          	lw	a1,20(s3)
    800035ca:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800035cc:	0109a783          	lw	a5,16(s3)
    800035d0:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800035d2:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800035d6:	854a                	mv	a0,s2
    800035d8:	fffff097          	auipc	ra,0xfffff
    800035dc:	e92080e7          	jalr	-366(ra) # 8000246a <bread>
  log.lh.n = lh->n;
    800035e0:	4d3c                	lw	a5,88(a0)
    800035e2:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800035e4:	02f05563          	blez	a5,8000360e <initlog+0x74>
    800035e8:	05c50713          	addi	a4,a0,92
    800035ec:	00036697          	auipc	a3,0x36
    800035f0:	a6468693          	addi	a3,a3,-1436 # 80039050 <log+0x30>
    800035f4:	37fd                	addiw	a5,a5,-1
    800035f6:	1782                	slli	a5,a5,0x20
    800035f8:	9381                	srli	a5,a5,0x20
    800035fa:	078a                	slli	a5,a5,0x2
    800035fc:	06050613          	addi	a2,a0,96
    80003600:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003602:	4310                	lw	a2,0(a4)
    80003604:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003606:	0711                	addi	a4,a4,4
    80003608:	0691                	addi	a3,a3,4
    8000360a:	fef71ce3          	bne	a4,a5,80003602 <initlog+0x68>
  brelse(buf);
    8000360e:	fffff097          	auipc	ra,0xfffff
    80003612:	f8c080e7          	jalr	-116(ra) # 8000259a <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003616:	4505                	li	a0,1
    80003618:	00000097          	auipc	ra,0x0
    8000361c:	ebe080e7          	jalr	-322(ra) # 800034d6 <install_trans>
  log.lh.n = 0;
    80003620:	00036797          	auipc	a5,0x36
    80003624:	a207a623          	sw	zero,-1492(a5) # 8003904c <log+0x2c>
  write_head(); // clear the log
    80003628:	00000097          	auipc	ra,0x0
    8000362c:	e34080e7          	jalr	-460(ra) # 8000345c <write_head>
}
    80003630:	70a2                	ld	ra,40(sp)
    80003632:	7402                	ld	s0,32(sp)
    80003634:	64e2                	ld	s1,24(sp)
    80003636:	6942                	ld	s2,16(sp)
    80003638:	69a2                	ld	s3,8(sp)
    8000363a:	6145                	addi	sp,sp,48
    8000363c:	8082                	ret

000000008000363e <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000363e:	1101                	addi	sp,sp,-32
    80003640:	ec06                	sd	ra,24(sp)
    80003642:	e822                	sd	s0,16(sp)
    80003644:	e426                	sd	s1,8(sp)
    80003646:	e04a                	sd	s2,0(sp)
    80003648:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000364a:	00036517          	auipc	a0,0x36
    8000364e:	9d650513          	addi	a0,a0,-1578 # 80039020 <log>
    80003652:	00003097          	auipc	ra,0x3
    80003656:	c10080e7          	jalr	-1008(ra) # 80006262 <acquire>
  while(1){
    if(log.committing){
    8000365a:	00036497          	auipc	s1,0x36
    8000365e:	9c648493          	addi	s1,s1,-1594 # 80039020 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003662:	4979                	li	s2,30
    80003664:	a039                	j	80003672 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003666:	85a6                	mv	a1,s1
    80003668:	8526                	mv	a0,s1
    8000366a:	ffffe097          	auipc	ra,0xffffe
    8000366e:	f74080e7          	jalr	-140(ra) # 800015de <sleep>
    if(log.committing){
    80003672:	50dc                	lw	a5,36(s1)
    80003674:	fbed                	bnez	a5,80003666 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003676:	509c                	lw	a5,32(s1)
    80003678:	0017871b          	addiw	a4,a5,1
    8000367c:	0007069b          	sext.w	a3,a4
    80003680:	0027179b          	slliw	a5,a4,0x2
    80003684:	9fb9                	addw	a5,a5,a4
    80003686:	0017979b          	slliw	a5,a5,0x1
    8000368a:	54d8                	lw	a4,44(s1)
    8000368c:	9fb9                	addw	a5,a5,a4
    8000368e:	00f95963          	bge	s2,a5,800036a0 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003692:	85a6                	mv	a1,s1
    80003694:	8526                	mv	a0,s1
    80003696:	ffffe097          	auipc	ra,0xffffe
    8000369a:	f48080e7          	jalr	-184(ra) # 800015de <sleep>
    8000369e:	bfd1                	j	80003672 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800036a0:	00036517          	auipc	a0,0x36
    800036a4:	98050513          	addi	a0,a0,-1664 # 80039020 <log>
    800036a8:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800036aa:	00003097          	auipc	ra,0x3
    800036ae:	c6c080e7          	jalr	-916(ra) # 80006316 <release>
      break;
    }
  }
}
    800036b2:	60e2                	ld	ra,24(sp)
    800036b4:	6442                	ld	s0,16(sp)
    800036b6:	64a2                	ld	s1,8(sp)
    800036b8:	6902                	ld	s2,0(sp)
    800036ba:	6105                	addi	sp,sp,32
    800036bc:	8082                	ret

00000000800036be <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800036be:	7139                	addi	sp,sp,-64
    800036c0:	fc06                	sd	ra,56(sp)
    800036c2:	f822                	sd	s0,48(sp)
    800036c4:	f426                	sd	s1,40(sp)
    800036c6:	f04a                	sd	s2,32(sp)
    800036c8:	ec4e                	sd	s3,24(sp)
    800036ca:	e852                	sd	s4,16(sp)
    800036cc:	e456                	sd	s5,8(sp)
    800036ce:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800036d0:	00036497          	auipc	s1,0x36
    800036d4:	95048493          	addi	s1,s1,-1712 # 80039020 <log>
    800036d8:	8526                	mv	a0,s1
    800036da:	00003097          	auipc	ra,0x3
    800036de:	b88080e7          	jalr	-1144(ra) # 80006262 <acquire>
  log.outstanding -= 1;
    800036e2:	509c                	lw	a5,32(s1)
    800036e4:	37fd                	addiw	a5,a5,-1
    800036e6:	0007891b          	sext.w	s2,a5
    800036ea:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800036ec:	50dc                	lw	a5,36(s1)
    800036ee:	efb9                	bnez	a5,8000374c <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    800036f0:	06091663          	bnez	s2,8000375c <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    800036f4:	00036497          	auipc	s1,0x36
    800036f8:	92c48493          	addi	s1,s1,-1748 # 80039020 <log>
    800036fc:	4785                	li	a5,1
    800036fe:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003700:	8526                	mv	a0,s1
    80003702:	00003097          	auipc	ra,0x3
    80003706:	c14080e7          	jalr	-1004(ra) # 80006316 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000370a:	54dc                	lw	a5,44(s1)
    8000370c:	06f04763          	bgtz	a5,8000377a <end_op+0xbc>
    acquire(&log.lock);
    80003710:	00036497          	auipc	s1,0x36
    80003714:	91048493          	addi	s1,s1,-1776 # 80039020 <log>
    80003718:	8526                	mv	a0,s1
    8000371a:	00003097          	auipc	ra,0x3
    8000371e:	b48080e7          	jalr	-1208(ra) # 80006262 <acquire>
    log.committing = 0;
    80003722:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003726:	8526                	mv	a0,s1
    80003728:	ffffe097          	auipc	ra,0xffffe
    8000372c:	042080e7          	jalr	66(ra) # 8000176a <wakeup>
    release(&log.lock);
    80003730:	8526                	mv	a0,s1
    80003732:	00003097          	auipc	ra,0x3
    80003736:	be4080e7          	jalr	-1052(ra) # 80006316 <release>
}
    8000373a:	70e2                	ld	ra,56(sp)
    8000373c:	7442                	ld	s0,48(sp)
    8000373e:	74a2                	ld	s1,40(sp)
    80003740:	7902                	ld	s2,32(sp)
    80003742:	69e2                	ld	s3,24(sp)
    80003744:	6a42                	ld	s4,16(sp)
    80003746:	6aa2                	ld	s5,8(sp)
    80003748:	6121                	addi	sp,sp,64
    8000374a:	8082                	ret
    panic("log.committing");
    8000374c:	00005517          	auipc	a0,0x5
    80003750:	f2450513          	addi	a0,a0,-220 # 80008670 <syscalls+0x1e0>
    80003754:	00002097          	auipc	ra,0x2
    80003758:	5c4080e7          	jalr	1476(ra) # 80005d18 <panic>
    wakeup(&log);
    8000375c:	00036497          	auipc	s1,0x36
    80003760:	8c448493          	addi	s1,s1,-1852 # 80039020 <log>
    80003764:	8526                	mv	a0,s1
    80003766:	ffffe097          	auipc	ra,0xffffe
    8000376a:	004080e7          	jalr	4(ra) # 8000176a <wakeup>
  release(&log.lock);
    8000376e:	8526                	mv	a0,s1
    80003770:	00003097          	auipc	ra,0x3
    80003774:	ba6080e7          	jalr	-1114(ra) # 80006316 <release>
  if(do_commit){
    80003778:	b7c9                	j	8000373a <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000377a:	00036a97          	auipc	s5,0x36
    8000377e:	8d6a8a93          	addi	s5,s5,-1834 # 80039050 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003782:	00036a17          	auipc	s4,0x36
    80003786:	89ea0a13          	addi	s4,s4,-1890 # 80039020 <log>
    8000378a:	018a2583          	lw	a1,24(s4)
    8000378e:	012585bb          	addw	a1,a1,s2
    80003792:	2585                	addiw	a1,a1,1
    80003794:	028a2503          	lw	a0,40(s4)
    80003798:	fffff097          	auipc	ra,0xfffff
    8000379c:	cd2080e7          	jalr	-814(ra) # 8000246a <bread>
    800037a0:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800037a2:	000aa583          	lw	a1,0(s5)
    800037a6:	028a2503          	lw	a0,40(s4)
    800037aa:	fffff097          	auipc	ra,0xfffff
    800037ae:	cc0080e7          	jalr	-832(ra) # 8000246a <bread>
    800037b2:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800037b4:	40000613          	li	a2,1024
    800037b8:	05850593          	addi	a1,a0,88
    800037bc:	05848513          	addi	a0,s1,88
    800037c0:	ffffd097          	auipc	ra,0xffffd
    800037c4:	ab2080e7          	jalr	-1358(ra) # 80000272 <memmove>
    bwrite(to);  // write the log
    800037c8:	8526                	mv	a0,s1
    800037ca:	fffff097          	auipc	ra,0xfffff
    800037ce:	d92080e7          	jalr	-622(ra) # 8000255c <bwrite>
    brelse(from);
    800037d2:	854e                	mv	a0,s3
    800037d4:	fffff097          	auipc	ra,0xfffff
    800037d8:	dc6080e7          	jalr	-570(ra) # 8000259a <brelse>
    brelse(to);
    800037dc:	8526                	mv	a0,s1
    800037de:	fffff097          	auipc	ra,0xfffff
    800037e2:	dbc080e7          	jalr	-580(ra) # 8000259a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800037e6:	2905                	addiw	s2,s2,1
    800037e8:	0a91                	addi	s5,s5,4
    800037ea:	02ca2783          	lw	a5,44(s4)
    800037ee:	f8f94ee3          	blt	s2,a5,8000378a <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800037f2:	00000097          	auipc	ra,0x0
    800037f6:	c6a080e7          	jalr	-918(ra) # 8000345c <write_head>
    install_trans(0); // Now install writes to home locations
    800037fa:	4501                	li	a0,0
    800037fc:	00000097          	auipc	ra,0x0
    80003800:	cda080e7          	jalr	-806(ra) # 800034d6 <install_trans>
    log.lh.n = 0;
    80003804:	00036797          	auipc	a5,0x36
    80003808:	8407a423          	sw	zero,-1976(a5) # 8003904c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000380c:	00000097          	auipc	ra,0x0
    80003810:	c50080e7          	jalr	-944(ra) # 8000345c <write_head>
    80003814:	bdf5                	j	80003710 <end_op+0x52>

0000000080003816 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003816:	1101                	addi	sp,sp,-32
    80003818:	ec06                	sd	ra,24(sp)
    8000381a:	e822                	sd	s0,16(sp)
    8000381c:	e426                	sd	s1,8(sp)
    8000381e:	e04a                	sd	s2,0(sp)
    80003820:	1000                	addi	s0,sp,32
    80003822:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003824:	00035917          	auipc	s2,0x35
    80003828:	7fc90913          	addi	s2,s2,2044 # 80039020 <log>
    8000382c:	854a                	mv	a0,s2
    8000382e:	00003097          	auipc	ra,0x3
    80003832:	a34080e7          	jalr	-1484(ra) # 80006262 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003836:	02c92603          	lw	a2,44(s2)
    8000383a:	47f5                	li	a5,29
    8000383c:	06c7c563          	blt	a5,a2,800038a6 <log_write+0x90>
    80003840:	00035797          	auipc	a5,0x35
    80003844:	7fc7a783          	lw	a5,2044(a5) # 8003903c <log+0x1c>
    80003848:	37fd                	addiw	a5,a5,-1
    8000384a:	04f65e63          	bge	a2,a5,800038a6 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000384e:	00035797          	auipc	a5,0x35
    80003852:	7f27a783          	lw	a5,2034(a5) # 80039040 <log+0x20>
    80003856:	06f05063          	blez	a5,800038b6 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000385a:	4781                	li	a5,0
    8000385c:	06c05563          	blez	a2,800038c6 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003860:	44cc                	lw	a1,12(s1)
    80003862:	00035717          	auipc	a4,0x35
    80003866:	7ee70713          	addi	a4,a4,2030 # 80039050 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000386a:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000386c:	4314                	lw	a3,0(a4)
    8000386e:	04b68c63          	beq	a3,a1,800038c6 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003872:	2785                	addiw	a5,a5,1
    80003874:	0711                	addi	a4,a4,4
    80003876:	fef61be3          	bne	a2,a5,8000386c <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000387a:	0621                	addi	a2,a2,8
    8000387c:	060a                	slli	a2,a2,0x2
    8000387e:	00035797          	auipc	a5,0x35
    80003882:	7a278793          	addi	a5,a5,1954 # 80039020 <log>
    80003886:	963e                	add	a2,a2,a5
    80003888:	44dc                	lw	a5,12(s1)
    8000388a:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000388c:	8526                	mv	a0,s1
    8000388e:	fffff097          	auipc	ra,0xfffff
    80003892:	daa080e7          	jalr	-598(ra) # 80002638 <bpin>
    log.lh.n++;
    80003896:	00035717          	auipc	a4,0x35
    8000389a:	78a70713          	addi	a4,a4,1930 # 80039020 <log>
    8000389e:	575c                	lw	a5,44(a4)
    800038a0:	2785                	addiw	a5,a5,1
    800038a2:	d75c                	sw	a5,44(a4)
    800038a4:	a835                	j	800038e0 <log_write+0xca>
    panic("too big a transaction");
    800038a6:	00005517          	auipc	a0,0x5
    800038aa:	dda50513          	addi	a0,a0,-550 # 80008680 <syscalls+0x1f0>
    800038ae:	00002097          	auipc	ra,0x2
    800038b2:	46a080e7          	jalr	1130(ra) # 80005d18 <panic>
    panic("log_write outside of trans");
    800038b6:	00005517          	auipc	a0,0x5
    800038ba:	de250513          	addi	a0,a0,-542 # 80008698 <syscalls+0x208>
    800038be:	00002097          	auipc	ra,0x2
    800038c2:	45a080e7          	jalr	1114(ra) # 80005d18 <panic>
  log.lh.block[i] = b->blockno;
    800038c6:	00878713          	addi	a4,a5,8
    800038ca:	00271693          	slli	a3,a4,0x2
    800038ce:	00035717          	auipc	a4,0x35
    800038d2:	75270713          	addi	a4,a4,1874 # 80039020 <log>
    800038d6:	9736                	add	a4,a4,a3
    800038d8:	44d4                	lw	a3,12(s1)
    800038da:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800038dc:	faf608e3          	beq	a2,a5,8000388c <log_write+0x76>
  }
  release(&log.lock);
    800038e0:	00035517          	auipc	a0,0x35
    800038e4:	74050513          	addi	a0,a0,1856 # 80039020 <log>
    800038e8:	00003097          	auipc	ra,0x3
    800038ec:	a2e080e7          	jalr	-1490(ra) # 80006316 <release>
}
    800038f0:	60e2                	ld	ra,24(sp)
    800038f2:	6442                	ld	s0,16(sp)
    800038f4:	64a2                	ld	s1,8(sp)
    800038f6:	6902                	ld	s2,0(sp)
    800038f8:	6105                	addi	sp,sp,32
    800038fa:	8082                	ret

00000000800038fc <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800038fc:	1101                	addi	sp,sp,-32
    800038fe:	ec06                	sd	ra,24(sp)
    80003900:	e822                	sd	s0,16(sp)
    80003902:	e426                	sd	s1,8(sp)
    80003904:	e04a                	sd	s2,0(sp)
    80003906:	1000                	addi	s0,sp,32
    80003908:	84aa                	mv	s1,a0
    8000390a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000390c:	00005597          	auipc	a1,0x5
    80003910:	dac58593          	addi	a1,a1,-596 # 800086b8 <syscalls+0x228>
    80003914:	0521                	addi	a0,a0,8
    80003916:	00003097          	auipc	ra,0x3
    8000391a:	8bc080e7          	jalr	-1860(ra) # 800061d2 <initlock>
  lk->name = name;
    8000391e:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003922:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003926:	0204a423          	sw	zero,40(s1)
}
    8000392a:	60e2                	ld	ra,24(sp)
    8000392c:	6442                	ld	s0,16(sp)
    8000392e:	64a2                	ld	s1,8(sp)
    80003930:	6902                	ld	s2,0(sp)
    80003932:	6105                	addi	sp,sp,32
    80003934:	8082                	ret

0000000080003936 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003936:	1101                	addi	sp,sp,-32
    80003938:	ec06                	sd	ra,24(sp)
    8000393a:	e822                	sd	s0,16(sp)
    8000393c:	e426                	sd	s1,8(sp)
    8000393e:	e04a                	sd	s2,0(sp)
    80003940:	1000                	addi	s0,sp,32
    80003942:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003944:	00850913          	addi	s2,a0,8
    80003948:	854a                	mv	a0,s2
    8000394a:	00003097          	auipc	ra,0x3
    8000394e:	918080e7          	jalr	-1768(ra) # 80006262 <acquire>
  while (lk->locked) {
    80003952:	409c                	lw	a5,0(s1)
    80003954:	cb89                	beqz	a5,80003966 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003956:	85ca                	mv	a1,s2
    80003958:	8526                	mv	a0,s1
    8000395a:	ffffe097          	auipc	ra,0xffffe
    8000395e:	c84080e7          	jalr	-892(ra) # 800015de <sleep>
  while (lk->locked) {
    80003962:	409c                	lw	a5,0(s1)
    80003964:	fbed                	bnez	a5,80003956 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003966:	4785                	li	a5,1
    80003968:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000396a:	ffffd097          	auipc	ra,0xffffd
    8000396e:	5b8080e7          	jalr	1464(ra) # 80000f22 <myproc>
    80003972:	591c                	lw	a5,48(a0)
    80003974:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003976:	854a                	mv	a0,s2
    80003978:	00003097          	auipc	ra,0x3
    8000397c:	99e080e7          	jalr	-1634(ra) # 80006316 <release>
}
    80003980:	60e2                	ld	ra,24(sp)
    80003982:	6442                	ld	s0,16(sp)
    80003984:	64a2                	ld	s1,8(sp)
    80003986:	6902                	ld	s2,0(sp)
    80003988:	6105                	addi	sp,sp,32
    8000398a:	8082                	ret

000000008000398c <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000398c:	1101                	addi	sp,sp,-32
    8000398e:	ec06                	sd	ra,24(sp)
    80003990:	e822                	sd	s0,16(sp)
    80003992:	e426                	sd	s1,8(sp)
    80003994:	e04a                	sd	s2,0(sp)
    80003996:	1000                	addi	s0,sp,32
    80003998:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000399a:	00850913          	addi	s2,a0,8
    8000399e:	854a                	mv	a0,s2
    800039a0:	00003097          	auipc	ra,0x3
    800039a4:	8c2080e7          	jalr	-1854(ra) # 80006262 <acquire>
  lk->locked = 0;
    800039a8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039ac:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800039b0:	8526                	mv	a0,s1
    800039b2:	ffffe097          	auipc	ra,0xffffe
    800039b6:	db8080e7          	jalr	-584(ra) # 8000176a <wakeup>
  release(&lk->lk);
    800039ba:	854a                	mv	a0,s2
    800039bc:	00003097          	auipc	ra,0x3
    800039c0:	95a080e7          	jalr	-1702(ra) # 80006316 <release>
}
    800039c4:	60e2                	ld	ra,24(sp)
    800039c6:	6442                	ld	s0,16(sp)
    800039c8:	64a2                	ld	s1,8(sp)
    800039ca:	6902                	ld	s2,0(sp)
    800039cc:	6105                	addi	sp,sp,32
    800039ce:	8082                	ret

00000000800039d0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800039d0:	7179                	addi	sp,sp,-48
    800039d2:	f406                	sd	ra,40(sp)
    800039d4:	f022                	sd	s0,32(sp)
    800039d6:	ec26                	sd	s1,24(sp)
    800039d8:	e84a                	sd	s2,16(sp)
    800039da:	e44e                	sd	s3,8(sp)
    800039dc:	1800                	addi	s0,sp,48
    800039de:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800039e0:	00850913          	addi	s2,a0,8
    800039e4:	854a                	mv	a0,s2
    800039e6:	00003097          	auipc	ra,0x3
    800039ea:	87c080e7          	jalr	-1924(ra) # 80006262 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800039ee:	409c                	lw	a5,0(s1)
    800039f0:	ef99                	bnez	a5,80003a0e <holdingsleep+0x3e>
    800039f2:	4481                	li	s1,0
  release(&lk->lk);
    800039f4:	854a                	mv	a0,s2
    800039f6:	00003097          	auipc	ra,0x3
    800039fa:	920080e7          	jalr	-1760(ra) # 80006316 <release>
  return r;
}
    800039fe:	8526                	mv	a0,s1
    80003a00:	70a2                	ld	ra,40(sp)
    80003a02:	7402                	ld	s0,32(sp)
    80003a04:	64e2                	ld	s1,24(sp)
    80003a06:	6942                	ld	s2,16(sp)
    80003a08:	69a2                	ld	s3,8(sp)
    80003a0a:	6145                	addi	sp,sp,48
    80003a0c:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a0e:	0284a983          	lw	s3,40(s1)
    80003a12:	ffffd097          	auipc	ra,0xffffd
    80003a16:	510080e7          	jalr	1296(ra) # 80000f22 <myproc>
    80003a1a:	5904                	lw	s1,48(a0)
    80003a1c:	413484b3          	sub	s1,s1,s3
    80003a20:	0014b493          	seqz	s1,s1
    80003a24:	bfc1                	j	800039f4 <holdingsleep+0x24>

0000000080003a26 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003a26:	1141                	addi	sp,sp,-16
    80003a28:	e406                	sd	ra,8(sp)
    80003a2a:	e022                	sd	s0,0(sp)
    80003a2c:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003a2e:	00005597          	auipc	a1,0x5
    80003a32:	c9a58593          	addi	a1,a1,-870 # 800086c8 <syscalls+0x238>
    80003a36:	00035517          	auipc	a0,0x35
    80003a3a:	73250513          	addi	a0,a0,1842 # 80039168 <ftable>
    80003a3e:	00002097          	auipc	ra,0x2
    80003a42:	794080e7          	jalr	1940(ra) # 800061d2 <initlock>
}
    80003a46:	60a2                	ld	ra,8(sp)
    80003a48:	6402                	ld	s0,0(sp)
    80003a4a:	0141                	addi	sp,sp,16
    80003a4c:	8082                	ret

0000000080003a4e <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003a4e:	1101                	addi	sp,sp,-32
    80003a50:	ec06                	sd	ra,24(sp)
    80003a52:	e822                	sd	s0,16(sp)
    80003a54:	e426                	sd	s1,8(sp)
    80003a56:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003a58:	00035517          	auipc	a0,0x35
    80003a5c:	71050513          	addi	a0,a0,1808 # 80039168 <ftable>
    80003a60:	00003097          	auipc	ra,0x3
    80003a64:	802080e7          	jalr	-2046(ra) # 80006262 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a68:	00035497          	auipc	s1,0x35
    80003a6c:	71848493          	addi	s1,s1,1816 # 80039180 <ftable+0x18>
    80003a70:	00036717          	auipc	a4,0x36
    80003a74:	6b070713          	addi	a4,a4,1712 # 8003a120 <ftable+0xfb8>
    if(f->ref == 0){
    80003a78:	40dc                	lw	a5,4(s1)
    80003a7a:	cf99                	beqz	a5,80003a98 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a7c:	02848493          	addi	s1,s1,40
    80003a80:	fee49ce3          	bne	s1,a4,80003a78 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a84:	00035517          	auipc	a0,0x35
    80003a88:	6e450513          	addi	a0,a0,1764 # 80039168 <ftable>
    80003a8c:	00003097          	auipc	ra,0x3
    80003a90:	88a080e7          	jalr	-1910(ra) # 80006316 <release>
  return 0;
    80003a94:	4481                	li	s1,0
    80003a96:	a819                	j	80003aac <filealloc+0x5e>
      f->ref = 1;
    80003a98:	4785                	li	a5,1
    80003a9a:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a9c:	00035517          	auipc	a0,0x35
    80003aa0:	6cc50513          	addi	a0,a0,1740 # 80039168 <ftable>
    80003aa4:	00003097          	auipc	ra,0x3
    80003aa8:	872080e7          	jalr	-1934(ra) # 80006316 <release>
}
    80003aac:	8526                	mv	a0,s1
    80003aae:	60e2                	ld	ra,24(sp)
    80003ab0:	6442                	ld	s0,16(sp)
    80003ab2:	64a2                	ld	s1,8(sp)
    80003ab4:	6105                	addi	sp,sp,32
    80003ab6:	8082                	ret

0000000080003ab8 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003ab8:	1101                	addi	sp,sp,-32
    80003aba:	ec06                	sd	ra,24(sp)
    80003abc:	e822                	sd	s0,16(sp)
    80003abe:	e426                	sd	s1,8(sp)
    80003ac0:	1000                	addi	s0,sp,32
    80003ac2:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003ac4:	00035517          	auipc	a0,0x35
    80003ac8:	6a450513          	addi	a0,a0,1700 # 80039168 <ftable>
    80003acc:	00002097          	auipc	ra,0x2
    80003ad0:	796080e7          	jalr	1942(ra) # 80006262 <acquire>
  if(f->ref < 1)
    80003ad4:	40dc                	lw	a5,4(s1)
    80003ad6:	02f05263          	blez	a5,80003afa <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003ada:	2785                	addiw	a5,a5,1
    80003adc:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003ade:	00035517          	auipc	a0,0x35
    80003ae2:	68a50513          	addi	a0,a0,1674 # 80039168 <ftable>
    80003ae6:	00003097          	auipc	ra,0x3
    80003aea:	830080e7          	jalr	-2000(ra) # 80006316 <release>
  return f;
}
    80003aee:	8526                	mv	a0,s1
    80003af0:	60e2                	ld	ra,24(sp)
    80003af2:	6442                	ld	s0,16(sp)
    80003af4:	64a2                	ld	s1,8(sp)
    80003af6:	6105                	addi	sp,sp,32
    80003af8:	8082                	ret
    panic("filedup");
    80003afa:	00005517          	auipc	a0,0x5
    80003afe:	bd650513          	addi	a0,a0,-1066 # 800086d0 <syscalls+0x240>
    80003b02:	00002097          	auipc	ra,0x2
    80003b06:	216080e7          	jalr	534(ra) # 80005d18 <panic>

0000000080003b0a <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003b0a:	7139                	addi	sp,sp,-64
    80003b0c:	fc06                	sd	ra,56(sp)
    80003b0e:	f822                	sd	s0,48(sp)
    80003b10:	f426                	sd	s1,40(sp)
    80003b12:	f04a                	sd	s2,32(sp)
    80003b14:	ec4e                	sd	s3,24(sp)
    80003b16:	e852                	sd	s4,16(sp)
    80003b18:	e456                	sd	s5,8(sp)
    80003b1a:	0080                	addi	s0,sp,64
    80003b1c:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003b1e:	00035517          	auipc	a0,0x35
    80003b22:	64a50513          	addi	a0,a0,1610 # 80039168 <ftable>
    80003b26:	00002097          	auipc	ra,0x2
    80003b2a:	73c080e7          	jalr	1852(ra) # 80006262 <acquire>
  if(f->ref < 1)
    80003b2e:	40dc                	lw	a5,4(s1)
    80003b30:	06f05163          	blez	a5,80003b92 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003b34:	37fd                	addiw	a5,a5,-1
    80003b36:	0007871b          	sext.w	a4,a5
    80003b3a:	c0dc                	sw	a5,4(s1)
    80003b3c:	06e04363          	bgtz	a4,80003ba2 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003b40:	0004a903          	lw	s2,0(s1)
    80003b44:	0094ca83          	lbu	s5,9(s1)
    80003b48:	0104ba03          	ld	s4,16(s1)
    80003b4c:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003b50:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003b54:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003b58:	00035517          	auipc	a0,0x35
    80003b5c:	61050513          	addi	a0,a0,1552 # 80039168 <ftable>
    80003b60:	00002097          	auipc	ra,0x2
    80003b64:	7b6080e7          	jalr	1974(ra) # 80006316 <release>

  if(ff.type == FD_PIPE){
    80003b68:	4785                	li	a5,1
    80003b6a:	04f90d63          	beq	s2,a5,80003bc4 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003b6e:	3979                	addiw	s2,s2,-2
    80003b70:	4785                	li	a5,1
    80003b72:	0527e063          	bltu	a5,s2,80003bb2 <fileclose+0xa8>
    begin_op();
    80003b76:	00000097          	auipc	ra,0x0
    80003b7a:	ac8080e7          	jalr	-1336(ra) # 8000363e <begin_op>
    iput(ff.ip);
    80003b7e:	854e                	mv	a0,s3
    80003b80:	fffff097          	auipc	ra,0xfffff
    80003b84:	2a6080e7          	jalr	678(ra) # 80002e26 <iput>
    end_op();
    80003b88:	00000097          	auipc	ra,0x0
    80003b8c:	b36080e7          	jalr	-1226(ra) # 800036be <end_op>
    80003b90:	a00d                	j	80003bb2 <fileclose+0xa8>
    panic("fileclose");
    80003b92:	00005517          	auipc	a0,0x5
    80003b96:	b4650513          	addi	a0,a0,-1210 # 800086d8 <syscalls+0x248>
    80003b9a:	00002097          	auipc	ra,0x2
    80003b9e:	17e080e7          	jalr	382(ra) # 80005d18 <panic>
    release(&ftable.lock);
    80003ba2:	00035517          	auipc	a0,0x35
    80003ba6:	5c650513          	addi	a0,a0,1478 # 80039168 <ftable>
    80003baa:	00002097          	auipc	ra,0x2
    80003bae:	76c080e7          	jalr	1900(ra) # 80006316 <release>
  }
}
    80003bb2:	70e2                	ld	ra,56(sp)
    80003bb4:	7442                	ld	s0,48(sp)
    80003bb6:	74a2                	ld	s1,40(sp)
    80003bb8:	7902                	ld	s2,32(sp)
    80003bba:	69e2                	ld	s3,24(sp)
    80003bbc:	6a42                	ld	s4,16(sp)
    80003bbe:	6aa2                	ld	s5,8(sp)
    80003bc0:	6121                	addi	sp,sp,64
    80003bc2:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003bc4:	85d6                	mv	a1,s5
    80003bc6:	8552                	mv	a0,s4
    80003bc8:	00000097          	auipc	ra,0x0
    80003bcc:	34c080e7          	jalr	844(ra) # 80003f14 <pipeclose>
    80003bd0:	b7cd                	j	80003bb2 <fileclose+0xa8>

0000000080003bd2 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003bd2:	715d                	addi	sp,sp,-80
    80003bd4:	e486                	sd	ra,72(sp)
    80003bd6:	e0a2                	sd	s0,64(sp)
    80003bd8:	fc26                	sd	s1,56(sp)
    80003bda:	f84a                	sd	s2,48(sp)
    80003bdc:	f44e                	sd	s3,40(sp)
    80003bde:	0880                	addi	s0,sp,80
    80003be0:	84aa                	mv	s1,a0
    80003be2:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003be4:	ffffd097          	auipc	ra,0xffffd
    80003be8:	33e080e7          	jalr	830(ra) # 80000f22 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003bec:	409c                	lw	a5,0(s1)
    80003bee:	37f9                	addiw	a5,a5,-2
    80003bf0:	4705                	li	a4,1
    80003bf2:	04f76763          	bltu	a4,a5,80003c40 <filestat+0x6e>
    80003bf6:	892a                	mv	s2,a0
    ilock(f->ip);
    80003bf8:	6c88                	ld	a0,24(s1)
    80003bfa:	fffff097          	auipc	ra,0xfffff
    80003bfe:	072080e7          	jalr	114(ra) # 80002c6c <ilock>
    stati(f->ip, &st);
    80003c02:	fb840593          	addi	a1,s0,-72
    80003c06:	6c88                	ld	a0,24(s1)
    80003c08:	fffff097          	auipc	ra,0xfffff
    80003c0c:	2ee080e7          	jalr	750(ra) # 80002ef6 <stati>
    iunlock(f->ip);
    80003c10:	6c88                	ld	a0,24(s1)
    80003c12:	fffff097          	auipc	ra,0xfffff
    80003c16:	11c080e7          	jalr	284(ra) # 80002d2e <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003c1a:	46e1                	li	a3,24
    80003c1c:	fb840613          	addi	a2,s0,-72
    80003c20:	85ce                	mv	a1,s3
    80003c22:	05093503          	ld	a0,80(s2)
    80003c26:	ffffd097          	auipc	ra,0xffffd
    80003c2a:	fbe080e7          	jalr	-66(ra) # 80000be4 <copyout>
    80003c2e:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003c32:	60a6                	ld	ra,72(sp)
    80003c34:	6406                	ld	s0,64(sp)
    80003c36:	74e2                	ld	s1,56(sp)
    80003c38:	7942                	ld	s2,48(sp)
    80003c3a:	79a2                	ld	s3,40(sp)
    80003c3c:	6161                	addi	sp,sp,80
    80003c3e:	8082                	ret
  return -1;
    80003c40:	557d                	li	a0,-1
    80003c42:	bfc5                	j	80003c32 <filestat+0x60>

0000000080003c44 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003c44:	7179                	addi	sp,sp,-48
    80003c46:	f406                	sd	ra,40(sp)
    80003c48:	f022                	sd	s0,32(sp)
    80003c4a:	ec26                	sd	s1,24(sp)
    80003c4c:	e84a                	sd	s2,16(sp)
    80003c4e:	e44e                	sd	s3,8(sp)
    80003c50:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003c52:	00854783          	lbu	a5,8(a0)
    80003c56:	c3d5                	beqz	a5,80003cfa <fileread+0xb6>
    80003c58:	84aa                	mv	s1,a0
    80003c5a:	89ae                	mv	s3,a1
    80003c5c:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c5e:	411c                	lw	a5,0(a0)
    80003c60:	4705                	li	a4,1
    80003c62:	04e78963          	beq	a5,a4,80003cb4 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c66:	470d                	li	a4,3
    80003c68:	04e78d63          	beq	a5,a4,80003cc2 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c6c:	4709                	li	a4,2
    80003c6e:	06e79e63          	bne	a5,a4,80003cea <fileread+0xa6>
    ilock(f->ip);
    80003c72:	6d08                	ld	a0,24(a0)
    80003c74:	fffff097          	auipc	ra,0xfffff
    80003c78:	ff8080e7          	jalr	-8(ra) # 80002c6c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c7c:	874a                	mv	a4,s2
    80003c7e:	5094                	lw	a3,32(s1)
    80003c80:	864e                	mv	a2,s3
    80003c82:	4585                	li	a1,1
    80003c84:	6c88                	ld	a0,24(s1)
    80003c86:	fffff097          	auipc	ra,0xfffff
    80003c8a:	29a080e7          	jalr	666(ra) # 80002f20 <readi>
    80003c8e:	892a                	mv	s2,a0
    80003c90:	00a05563          	blez	a0,80003c9a <fileread+0x56>
      f->off += r;
    80003c94:	509c                	lw	a5,32(s1)
    80003c96:	9fa9                	addw	a5,a5,a0
    80003c98:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c9a:	6c88                	ld	a0,24(s1)
    80003c9c:	fffff097          	auipc	ra,0xfffff
    80003ca0:	092080e7          	jalr	146(ra) # 80002d2e <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003ca4:	854a                	mv	a0,s2
    80003ca6:	70a2                	ld	ra,40(sp)
    80003ca8:	7402                	ld	s0,32(sp)
    80003caa:	64e2                	ld	s1,24(sp)
    80003cac:	6942                	ld	s2,16(sp)
    80003cae:	69a2                	ld	s3,8(sp)
    80003cb0:	6145                	addi	sp,sp,48
    80003cb2:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003cb4:	6908                	ld	a0,16(a0)
    80003cb6:	00000097          	auipc	ra,0x0
    80003cba:	3c8080e7          	jalr	968(ra) # 8000407e <piperead>
    80003cbe:	892a                	mv	s2,a0
    80003cc0:	b7d5                	j	80003ca4 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003cc2:	02451783          	lh	a5,36(a0)
    80003cc6:	03079693          	slli	a3,a5,0x30
    80003cca:	92c1                	srli	a3,a3,0x30
    80003ccc:	4725                	li	a4,9
    80003cce:	02d76863          	bltu	a4,a3,80003cfe <fileread+0xba>
    80003cd2:	0792                	slli	a5,a5,0x4
    80003cd4:	00035717          	auipc	a4,0x35
    80003cd8:	3f470713          	addi	a4,a4,1012 # 800390c8 <devsw>
    80003cdc:	97ba                	add	a5,a5,a4
    80003cde:	639c                	ld	a5,0(a5)
    80003ce0:	c38d                	beqz	a5,80003d02 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003ce2:	4505                	li	a0,1
    80003ce4:	9782                	jalr	a5
    80003ce6:	892a                	mv	s2,a0
    80003ce8:	bf75                	j	80003ca4 <fileread+0x60>
    panic("fileread");
    80003cea:	00005517          	auipc	a0,0x5
    80003cee:	9fe50513          	addi	a0,a0,-1538 # 800086e8 <syscalls+0x258>
    80003cf2:	00002097          	auipc	ra,0x2
    80003cf6:	026080e7          	jalr	38(ra) # 80005d18 <panic>
    return -1;
    80003cfa:	597d                	li	s2,-1
    80003cfc:	b765                	j	80003ca4 <fileread+0x60>
      return -1;
    80003cfe:	597d                	li	s2,-1
    80003d00:	b755                	j	80003ca4 <fileread+0x60>
    80003d02:	597d                	li	s2,-1
    80003d04:	b745                	j	80003ca4 <fileread+0x60>

0000000080003d06 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003d06:	715d                	addi	sp,sp,-80
    80003d08:	e486                	sd	ra,72(sp)
    80003d0a:	e0a2                	sd	s0,64(sp)
    80003d0c:	fc26                	sd	s1,56(sp)
    80003d0e:	f84a                	sd	s2,48(sp)
    80003d10:	f44e                	sd	s3,40(sp)
    80003d12:	f052                	sd	s4,32(sp)
    80003d14:	ec56                	sd	s5,24(sp)
    80003d16:	e85a                	sd	s6,16(sp)
    80003d18:	e45e                	sd	s7,8(sp)
    80003d1a:	e062                	sd	s8,0(sp)
    80003d1c:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003d1e:	00954783          	lbu	a5,9(a0)
    80003d22:	10078663          	beqz	a5,80003e2e <filewrite+0x128>
    80003d26:	892a                	mv	s2,a0
    80003d28:	8aae                	mv	s5,a1
    80003d2a:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d2c:	411c                	lw	a5,0(a0)
    80003d2e:	4705                	li	a4,1
    80003d30:	02e78263          	beq	a5,a4,80003d54 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d34:	470d                	li	a4,3
    80003d36:	02e78663          	beq	a5,a4,80003d62 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d3a:	4709                	li	a4,2
    80003d3c:	0ee79163          	bne	a5,a4,80003e1e <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003d40:	0ac05d63          	blez	a2,80003dfa <filewrite+0xf4>
    int i = 0;
    80003d44:	4981                	li	s3,0
    80003d46:	6b05                	lui	s6,0x1
    80003d48:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003d4c:	6b85                	lui	s7,0x1
    80003d4e:	c00b8b9b          	addiw	s7,s7,-1024
    80003d52:	a861                	j	80003dea <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003d54:	6908                	ld	a0,16(a0)
    80003d56:	00000097          	auipc	ra,0x0
    80003d5a:	22e080e7          	jalr	558(ra) # 80003f84 <pipewrite>
    80003d5e:	8a2a                	mv	s4,a0
    80003d60:	a045                	j	80003e00 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d62:	02451783          	lh	a5,36(a0)
    80003d66:	03079693          	slli	a3,a5,0x30
    80003d6a:	92c1                	srli	a3,a3,0x30
    80003d6c:	4725                	li	a4,9
    80003d6e:	0cd76263          	bltu	a4,a3,80003e32 <filewrite+0x12c>
    80003d72:	0792                	slli	a5,a5,0x4
    80003d74:	00035717          	auipc	a4,0x35
    80003d78:	35470713          	addi	a4,a4,852 # 800390c8 <devsw>
    80003d7c:	97ba                	add	a5,a5,a4
    80003d7e:	679c                	ld	a5,8(a5)
    80003d80:	cbdd                	beqz	a5,80003e36 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003d82:	4505                	li	a0,1
    80003d84:	9782                	jalr	a5
    80003d86:	8a2a                	mv	s4,a0
    80003d88:	a8a5                	j	80003e00 <filewrite+0xfa>
    80003d8a:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003d8e:	00000097          	auipc	ra,0x0
    80003d92:	8b0080e7          	jalr	-1872(ra) # 8000363e <begin_op>
      ilock(f->ip);
    80003d96:	01893503          	ld	a0,24(s2)
    80003d9a:	fffff097          	auipc	ra,0xfffff
    80003d9e:	ed2080e7          	jalr	-302(ra) # 80002c6c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003da2:	8762                	mv	a4,s8
    80003da4:	02092683          	lw	a3,32(s2)
    80003da8:	01598633          	add	a2,s3,s5
    80003dac:	4585                	li	a1,1
    80003dae:	01893503          	ld	a0,24(s2)
    80003db2:	fffff097          	auipc	ra,0xfffff
    80003db6:	266080e7          	jalr	614(ra) # 80003018 <writei>
    80003dba:	84aa                	mv	s1,a0
    80003dbc:	00a05763          	blez	a0,80003dca <filewrite+0xc4>
        f->off += r;
    80003dc0:	02092783          	lw	a5,32(s2)
    80003dc4:	9fa9                	addw	a5,a5,a0
    80003dc6:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003dca:	01893503          	ld	a0,24(s2)
    80003dce:	fffff097          	auipc	ra,0xfffff
    80003dd2:	f60080e7          	jalr	-160(ra) # 80002d2e <iunlock>
      end_op();
    80003dd6:	00000097          	auipc	ra,0x0
    80003dda:	8e8080e7          	jalr	-1816(ra) # 800036be <end_op>

      if(r != n1){
    80003dde:	009c1f63          	bne	s8,s1,80003dfc <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003de2:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003de6:	0149db63          	bge	s3,s4,80003dfc <filewrite+0xf6>
      int n1 = n - i;
    80003dea:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003dee:	84be                	mv	s1,a5
    80003df0:	2781                	sext.w	a5,a5
    80003df2:	f8fb5ce3          	bge	s6,a5,80003d8a <filewrite+0x84>
    80003df6:	84de                	mv	s1,s7
    80003df8:	bf49                	j	80003d8a <filewrite+0x84>
    int i = 0;
    80003dfa:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003dfc:	013a1f63          	bne	s4,s3,80003e1a <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003e00:	8552                	mv	a0,s4
    80003e02:	60a6                	ld	ra,72(sp)
    80003e04:	6406                	ld	s0,64(sp)
    80003e06:	74e2                	ld	s1,56(sp)
    80003e08:	7942                	ld	s2,48(sp)
    80003e0a:	79a2                	ld	s3,40(sp)
    80003e0c:	7a02                	ld	s4,32(sp)
    80003e0e:	6ae2                	ld	s5,24(sp)
    80003e10:	6b42                	ld	s6,16(sp)
    80003e12:	6ba2                	ld	s7,8(sp)
    80003e14:	6c02                	ld	s8,0(sp)
    80003e16:	6161                	addi	sp,sp,80
    80003e18:	8082                	ret
    ret = (i == n ? n : -1);
    80003e1a:	5a7d                	li	s4,-1
    80003e1c:	b7d5                	j	80003e00 <filewrite+0xfa>
    panic("filewrite");
    80003e1e:	00005517          	auipc	a0,0x5
    80003e22:	8da50513          	addi	a0,a0,-1830 # 800086f8 <syscalls+0x268>
    80003e26:	00002097          	auipc	ra,0x2
    80003e2a:	ef2080e7          	jalr	-270(ra) # 80005d18 <panic>
    return -1;
    80003e2e:	5a7d                	li	s4,-1
    80003e30:	bfc1                	j	80003e00 <filewrite+0xfa>
      return -1;
    80003e32:	5a7d                	li	s4,-1
    80003e34:	b7f1                	j	80003e00 <filewrite+0xfa>
    80003e36:	5a7d                	li	s4,-1
    80003e38:	b7e1                	j	80003e00 <filewrite+0xfa>

0000000080003e3a <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e3a:	7179                	addi	sp,sp,-48
    80003e3c:	f406                	sd	ra,40(sp)
    80003e3e:	f022                	sd	s0,32(sp)
    80003e40:	ec26                	sd	s1,24(sp)
    80003e42:	e84a                	sd	s2,16(sp)
    80003e44:	e44e                	sd	s3,8(sp)
    80003e46:	e052                	sd	s4,0(sp)
    80003e48:	1800                	addi	s0,sp,48
    80003e4a:	84aa                	mv	s1,a0
    80003e4c:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e4e:	0005b023          	sd	zero,0(a1)
    80003e52:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e56:	00000097          	auipc	ra,0x0
    80003e5a:	bf8080e7          	jalr	-1032(ra) # 80003a4e <filealloc>
    80003e5e:	e088                	sd	a0,0(s1)
    80003e60:	c551                	beqz	a0,80003eec <pipealloc+0xb2>
    80003e62:	00000097          	auipc	ra,0x0
    80003e66:	bec080e7          	jalr	-1044(ra) # 80003a4e <filealloc>
    80003e6a:	00aa3023          	sd	a0,0(s4)
    80003e6e:	c92d                	beqz	a0,80003ee0 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e70:	ffffc097          	auipc	ra,0xffffc
    80003e74:	30c080e7          	jalr	780(ra) # 8000017c <kalloc>
    80003e78:	892a                	mv	s2,a0
    80003e7a:	c125                	beqz	a0,80003eda <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003e7c:	4985                	li	s3,1
    80003e7e:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e82:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e86:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e8a:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e8e:	00005597          	auipc	a1,0x5
    80003e92:	87a58593          	addi	a1,a1,-1926 # 80008708 <syscalls+0x278>
    80003e96:	00002097          	auipc	ra,0x2
    80003e9a:	33c080e7          	jalr	828(ra) # 800061d2 <initlock>
  (*f0)->type = FD_PIPE;
    80003e9e:	609c                	ld	a5,0(s1)
    80003ea0:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003ea4:	609c                	ld	a5,0(s1)
    80003ea6:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003eaa:	609c                	ld	a5,0(s1)
    80003eac:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003eb0:	609c                	ld	a5,0(s1)
    80003eb2:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003eb6:	000a3783          	ld	a5,0(s4)
    80003eba:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003ebe:	000a3783          	ld	a5,0(s4)
    80003ec2:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003ec6:	000a3783          	ld	a5,0(s4)
    80003eca:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003ece:	000a3783          	ld	a5,0(s4)
    80003ed2:	0127b823          	sd	s2,16(a5)
  return 0;
    80003ed6:	4501                	li	a0,0
    80003ed8:	a025                	j	80003f00 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003eda:	6088                	ld	a0,0(s1)
    80003edc:	e501                	bnez	a0,80003ee4 <pipealloc+0xaa>
    80003ede:	a039                	j	80003eec <pipealloc+0xb2>
    80003ee0:	6088                	ld	a0,0(s1)
    80003ee2:	c51d                	beqz	a0,80003f10 <pipealloc+0xd6>
    fileclose(*f0);
    80003ee4:	00000097          	auipc	ra,0x0
    80003ee8:	c26080e7          	jalr	-986(ra) # 80003b0a <fileclose>
  if(*f1)
    80003eec:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003ef0:	557d                	li	a0,-1
  if(*f1)
    80003ef2:	c799                	beqz	a5,80003f00 <pipealloc+0xc6>
    fileclose(*f1);
    80003ef4:	853e                	mv	a0,a5
    80003ef6:	00000097          	auipc	ra,0x0
    80003efa:	c14080e7          	jalr	-1004(ra) # 80003b0a <fileclose>
  return -1;
    80003efe:	557d                	li	a0,-1
}
    80003f00:	70a2                	ld	ra,40(sp)
    80003f02:	7402                	ld	s0,32(sp)
    80003f04:	64e2                	ld	s1,24(sp)
    80003f06:	6942                	ld	s2,16(sp)
    80003f08:	69a2                	ld	s3,8(sp)
    80003f0a:	6a02                	ld	s4,0(sp)
    80003f0c:	6145                	addi	sp,sp,48
    80003f0e:	8082                	ret
  return -1;
    80003f10:	557d                	li	a0,-1
    80003f12:	b7fd                	j	80003f00 <pipealloc+0xc6>

0000000080003f14 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003f14:	1101                	addi	sp,sp,-32
    80003f16:	ec06                	sd	ra,24(sp)
    80003f18:	e822                	sd	s0,16(sp)
    80003f1a:	e426                	sd	s1,8(sp)
    80003f1c:	e04a                	sd	s2,0(sp)
    80003f1e:	1000                	addi	s0,sp,32
    80003f20:	84aa                	mv	s1,a0
    80003f22:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f24:	00002097          	auipc	ra,0x2
    80003f28:	33e080e7          	jalr	830(ra) # 80006262 <acquire>
  if(writable){
    80003f2c:	02090d63          	beqz	s2,80003f66 <pipeclose+0x52>
    pi->writeopen = 0;
    80003f30:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f34:	21848513          	addi	a0,s1,536
    80003f38:	ffffe097          	auipc	ra,0xffffe
    80003f3c:	832080e7          	jalr	-1998(ra) # 8000176a <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f40:	2204b783          	ld	a5,544(s1)
    80003f44:	eb95                	bnez	a5,80003f78 <pipeclose+0x64>
    release(&pi->lock);
    80003f46:	8526                	mv	a0,s1
    80003f48:	00002097          	auipc	ra,0x2
    80003f4c:	3ce080e7          	jalr	974(ra) # 80006316 <release>
    kfree((char*)pi);
    80003f50:	8526                	mv	a0,s1
    80003f52:	ffffc097          	auipc	ra,0xffffc
    80003f56:	0ca080e7          	jalr	202(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f5a:	60e2                	ld	ra,24(sp)
    80003f5c:	6442                	ld	s0,16(sp)
    80003f5e:	64a2                	ld	s1,8(sp)
    80003f60:	6902                	ld	s2,0(sp)
    80003f62:	6105                	addi	sp,sp,32
    80003f64:	8082                	ret
    pi->readopen = 0;
    80003f66:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f6a:	21c48513          	addi	a0,s1,540
    80003f6e:	ffffd097          	auipc	ra,0xffffd
    80003f72:	7fc080e7          	jalr	2044(ra) # 8000176a <wakeup>
    80003f76:	b7e9                	j	80003f40 <pipeclose+0x2c>
    release(&pi->lock);
    80003f78:	8526                	mv	a0,s1
    80003f7a:	00002097          	auipc	ra,0x2
    80003f7e:	39c080e7          	jalr	924(ra) # 80006316 <release>
}
    80003f82:	bfe1                	j	80003f5a <pipeclose+0x46>

0000000080003f84 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f84:	7159                	addi	sp,sp,-112
    80003f86:	f486                	sd	ra,104(sp)
    80003f88:	f0a2                	sd	s0,96(sp)
    80003f8a:	eca6                	sd	s1,88(sp)
    80003f8c:	e8ca                	sd	s2,80(sp)
    80003f8e:	e4ce                	sd	s3,72(sp)
    80003f90:	e0d2                	sd	s4,64(sp)
    80003f92:	fc56                	sd	s5,56(sp)
    80003f94:	f85a                	sd	s6,48(sp)
    80003f96:	f45e                	sd	s7,40(sp)
    80003f98:	f062                	sd	s8,32(sp)
    80003f9a:	ec66                	sd	s9,24(sp)
    80003f9c:	1880                	addi	s0,sp,112
    80003f9e:	84aa                	mv	s1,a0
    80003fa0:	8aae                	mv	s5,a1
    80003fa2:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003fa4:	ffffd097          	auipc	ra,0xffffd
    80003fa8:	f7e080e7          	jalr	-130(ra) # 80000f22 <myproc>
    80003fac:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003fae:	8526                	mv	a0,s1
    80003fb0:	00002097          	auipc	ra,0x2
    80003fb4:	2b2080e7          	jalr	690(ra) # 80006262 <acquire>
  while(i < n){
    80003fb8:	0d405163          	blez	s4,8000407a <pipewrite+0xf6>
    80003fbc:	8ba6                	mv	s7,s1
  int i = 0;
    80003fbe:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fc0:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003fc2:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003fc6:	21c48c13          	addi	s8,s1,540
    80003fca:	a08d                	j	8000402c <pipewrite+0xa8>
      release(&pi->lock);
    80003fcc:	8526                	mv	a0,s1
    80003fce:	00002097          	auipc	ra,0x2
    80003fd2:	348080e7          	jalr	840(ra) # 80006316 <release>
      return -1;
    80003fd6:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003fd8:	854a                	mv	a0,s2
    80003fda:	70a6                	ld	ra,104(sp)
    80003fdc:	7406                	ld	s0,96(sp)
    80003fde:	64e6                	ld	s1,88(sp)
    80003fe0:	6946                	ld	s2,80(sp)
    80003fe2:	69a6                	ld	s3,72(sp)
    80003fe4:	6a06                	ld	s4,64(sp)
    80003fe6:	7ae2                	ld	s5,56(sp)
    80003fe8:	7b42                	ld	s6,48(sp)
    80003fea:	7ba2                	ld	s7,40(sp)
    80003fec:	7c02                	ld	s8,32(sp)
    80003fee:	6ce2                	ld	s9,24(sp)
    80003ff0:	6165                	addi	sp,sp,112
    80003ff2:	8082                	ret
      wakeup(&pi->nread);
    80003ff4:	8566                	mv	a0,s9
    80003ff6:	ffffd097          	auipc	ra,0xffffd
    80003ffa:	774080e7          	jalr	1908(ra) # 8000176a <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003ffe:	85de                	mv	a1,s7
    80004000:	8562                	mv	a0,s8
    80004002:	ffffd097          	auipc	ra,0xffffd
    80004006:	5dc080e7          	jalr	1500(ra) # 800015de <sleep>
    8000400a:	a839                	j	80004028 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000400c:	21c4a783          	lw	a5,540(s1)
    80004010:	0017871b          	addiw	a4,a5,1
    80004014:	20e4ae23          	sw	a4,540(s1)
    80004018:	1ff7f793          	andi	a5,a5,511
    8000401c:	97a6                	add	a5,a5,s1
    8000401e:	f9f44703          	lbu	a4,-97(s0)
    80004022:	00e78c23          	sb	a4,24(a5)
      i++;
    80004026:	2905                	addiw	s2,s2,1
  while(i < n){
    80004028:	03495d63          	bge	s2,s4,80004062 <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    8000402c:	2204a783          	lw	a5,544(s1)
    80004030:	dfd1                	beqz	a5,80003fcc <pipewrite+0x48>
    80004032:	0289a783          	lw	a5,40(s3)
    80004036:	fbd9                	bnez	a5,80003fcc <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004038:	2184a783          	lw	a5,536(s1)
    8000403c:	21c4a703          	lw	a4,540(s1)
    80004040:	2007879b          	addiw	a5,a5,512
    80004044:	faf708e3          	beq	a4,a5,80003ff4 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004048:	4685                	li	a3,1
    8000404a:	01590633          	add	a2,s2,s5
    8000404e:	f9f40593          	addi	a1,s0,-97
    80004052:	0509b503          	ld	a0,80(s3)
    80004056:	ffffd097          	auipc	ra,0xffffd
    8000405a:	c1a080e7          	jalr	-998(ra) # 80000c70 <copyin>
    8000405e:	fb6517e3          	bne	a0,s6,8000400c <pipewrite+0x88>
  wakeup(&pi->nread);
    80004062:	21848513          	addi	a0,s1,536
    80004066:	ffffd097          	auipc	ra,0xffffd
    8000406a:	704080e7          	jalr	1796(ra) # 8000176a <wakeup>
  release(&pi->lock);
    8000406e:	8526                	mv	a0,s1
    80004070:	00002097          	auipc	ra,0x2
    80004074:	2a6080e7          	jalr	678(ra) # 80006316 <release>
  return i;
    80004078:	b785                	j	80003fd8 <pipewrite+0x54>
  int i = 0;
    8000407a:	4901                	li	s2,0
    8000407c:	b7dd                	j	80004062 <pipewrite+0xde>

000000008000407e <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000407e:	715d                	addi	sp,sp,-80
    80004080:	e486                	sd	ra,72(sp)
    80004082:	e0a2                	sd	s0,64(sp)
    80004084:	fc26                	sd	s1,56(sp)
    80004086:	f84a                	sd	s2,48(sp)
    80004088:	f44e                	sd	s3,40(sp)
    8000408a:	f052                	sd	s4,32(sp)
    8000408c:	ec56                	sd	s5,24(sp)
    8000408e:	e85a                	sd	s6,16(sp)
    80004090:	0880                	addi	s0,sp,80
    80004092:	84aa                	mv	s1,a0
    80004094:	892e                	mv	s2,a1
    80004096:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004098:	ffffd097          	auipc	ra,0xffffd
    8000409c:	e8a080e7          	jalr	-374(ra) # 80000f22 <myproc>
    800040a0:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800040a2:	8b26                	mv	s6,s1
    800040a4:	8526                	mv	a0,s1
    800040a6:	00002097          	auipc	ra,0x2
    800040aa:	1bc080e7          	jalr	444(ra) # 80006262 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040ae:	2184a703          	lw	a4,536(s1)
    800040b2:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040b6:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040ba:	02f71463          	bne	a4,a5,800040e2 <piperead+0x64>
    800040be:	2244a783          	lw	a5,548(s1)
    800040c2:	c385                	beqz	a5,800040e2 <piperead+0x64>
    if(pr->killed){
    800040c4:	028a2783          	lw	a5,40(s4)
    800040c8:	ebc1                	bnez	a5,80004158 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040ca:	85da                	mv	a1,s6
    800040cc:	854e                	mv	a0,s3
    800040ce:	ffffd097          	auipc	ra,0xffffd
    800040d2:	510080e7          	jalr	1296(ra) # 800015de <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040d6:	2184a703          	lw	a4,536(s1)
    800040da:	21c4a783          	lw	a5,540(s1)
    800040de:	fef700e3          	beq	a4,a5,800040be <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040e2:	09505263          	blez	s5,80004166 <piperead+0xe8>
    800040e6:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040e8:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    800040ea:	2184a783          	lw	a5,536(s1)
    800040ee:	21c4a703          	lw	a4,540(s1)
    800040f2:	02f70d63          	beq	a4,a5,8000412c <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800040f6:	0017871b          	addiw	a4,a5,1
    800040fa:	20e4ac23          	sw	a4,536(s1)
    800040fe:	1ff7f793          	andi	a5,a5,511
    80004102:	97a6                	add	a5,a5,s1
    80004104:	0187c783          	lbu	a5,24(a5)
    80004108:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000410c:	4685                	li	a3,1
    8000410e:	fbf40613          	addi	a2,s0,-65
    80004112:	85ca                	mv	a1,s2
    80004114:	050a3503          	ld	a0,80(s4)
    80004118:	ffffd097          	auipc	ra,0xffffd
    8000411c:	acc080e7          	jalr	-1332(ra) # 80000be4 <copyout>
    80004120:	01650663          	beq	a0,s6,8000412c <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004124:	2985                	addiw	s3,s3,1
    80004126:	0905                	addi	s2,s2,1
    80004128:	fd3a91e3          	bne	s5,s3,800040ea <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000412c:	21c48513          	addi	a0,s1,540
    80004130:	ffffd097          	auipc	ra,0xffffd
    80004134:	63a080e7          	jalr	1594(ra) # 8000176a <wakeup>
  release(&pi->lock);
    80004138:	8526                	mv	a0,s1
    8000413a:	00002097          	auipc	ra,0x2
    8000413e:	1dc080e7          	jalr	476(ra) # 80006316 <release>
  return i;
}
    80004142:	854e                	mv	a0,s3
    80004144:	60a6                	ld	ra,72(sp)
    80004146:	6406                	ld	s0,64(sp)
    80004148:	74e2                	ld	s1,56(sp)
    8000414a:	7942                	ld	s2,48(sp)
    8000414c:	79a2                	ld	s3,40(sp)
    8000414e:	7a02                	ld	s4,32(sp)
    80004150:	6ae2                	ld	s5,24(sp)
    80004152:	6b42                	ld	s6,16(sp)
    80004154:	6161                	addi	sp,sp,80
    80004156:	8082                	ret
      release(&pi->lock);
    80004158:	8526                	mv	a0,s1
    8000415a:	00002097          	auipc	ra,0x2
    8000415e:	1bc080e7          	jalr	444(ra) # 80006316 <release>
      return -1;
    80004162:	59fd                	li	s3,-1
    80004164:	bff9                	j	80004142 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004166:	4981                	li	s3,0
    80004168:	b7d1                	j	8000412c <piperead+0xae>

000000008000416a <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    8000416a:	df010113          	addi	sp,sp,-528
    8000416e:	20113423          	sd	ra,520(sp)
    80004172:	20813023          	sd	s0,512(sp)
    80004176:	ffa6                	sd	s1,504(sp)
    80004178:	fbca                	sd	s2,496(sp)
    8000417a:	f7ce                	sd	s3,488(sp)
    8000417c:	f3d2                	sd	s4,480(sp)
    8000417e:	efd6                	sd	s5,472(sp)
    80004180:	ebda                	sd	s6,464(sp)
    80004182:	e7de                	sd	s7,456(sp)
    80004184:	e3e2                	sd	s8,448(sp)
    80004186:	ff66                	sd	s9,440(sp)
    80004188:	fb6a                	sd	s10,432(sp)
    8000418a:	f76e                	sd	s11,424(sp)
    8000418c:	0c00                	addi	s0,sp,528
    8000418e:	84aa                	mv	s1,a0
    80004190:	dea43c23          	sd	a0,-520(s0)
    80004194:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004198:	ffffd097          	auipc	ra,0xffffd
    8000419c:	d8a080e7          	jalr	-630(ra) # 80000f22 <myproc>
    800041a0:	892a                	mv	s2,a0

  begin_op();
    800041a2:	fffff097          	auipc	ra,0xfffff
    800041a6:	49c080e7          	jalr	1180(ra) # 8000363e <begin_op>

  if((ip = namei(path)) == 0){
    800041aa:	8526                	mv	a0,s1
    800041ac:	fffff097          	auipc	ra,0xfffff
    800041b0:	276080e7          	jalr	630(ra) # 80003422 <namei>
    800041b4:	c92d                	beqz	a0,80004226 <exec+0xbc>
    800041b6:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800041b8:	fffff097          	auipc	ra,0xfffff
    800041bc:	ab4080e7          	jalr	-1356(ra) # 80002c6c <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800041c0:	04000713          	li	a4,64
    800041c4:	4681                	li	a3,0
    800041c6:	e5040613          	addi	a2,s0,-432
    800041ca:	4581                	li	a1,0
    800041cc:	8526                	mv	a0,s1
    800041ce:	fffff097          	auipc	ra,0xfffff
    800041d2:	d52080e7          	jalr	-686(ra) # 80002f20 <readi>
    800041d6:	04000793          	li	a5,64
    800041da:	00f51a63          	bne	a0,a5,800041ee <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800041de:	e5042703          	lw	a4,-432(s0)
    800041e2:	464c47b7          	lui	a5,0x464c4
    800041e6:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800041ea:	04f70463          	beq	a4,a5,80004232 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800041ee:	8526                	mv	a0,s1
    800041f0:	fffff097          	auipc	ra,0xfffff
    800041f4:	cde080e7          	jalr	-802(ra) # 80002ece <iunlockput>
    end_op();
    800041f8:	fffff097          	auipc	ra,0xfffff
    800041fc:	4c6080e7          	jalr	1222(ra) # 800036be <end_op>
  }
  return -1;
    80004200:	557d                	li	a0,-1
}
    80004202:	20813083          	ld	ra,520(sp)
    80004206:	20013403          	ld	s0,512(sp)
    8000420a:	74fe                	ld	s1,504(sp)
    8000420c:	795e                	ld	s2,496(sp)
    8000420e:	79be                	ld	s3,488(sp)
    80004210:	7a1e                	ld	s4,480(sp)
    80004212:	6afe                	ld	s5,472(sp)
    80004214:	6b5e                	ld	s6,464(sp)
    80004216:	6bbe                	ld	s7,456(sp)
    80004218:	6c1e                	ld	s8,448(sp)
    8000421a:	7cfa                	ld	s9,440(sp)
    8000421c:	7d5a                	ld	s10,432(sp)
    8000421e:	7dba                	ld	s11,424(sp)
    80004220:	21010113          	addi	sp,sp,528
    80004224:	8082                	ret
    end_op();
    80004226:	fffff097          	auipc	ra,0xfffff
    8000422a:	498080e7          	jalr	1176(ra) # 800036be <end_op>
    return -1;
    8000422e:	557d                	li	a0,-1
    80004230:	bfc9                	j	80004202 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004232:	854a                	mv	a0,s2
    80004234:	ffffd097          	auipc	ra,0xffffd
    80004238:	db2080e7          	jalr	-590(ra) # 80000fe6 <proc_pagetable>
    8000423c:	8baa                	mv	s7,a0
    8000423e:	d945                	beqz	a0,800041ee <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004240:	e7042983          	lw	s3,-400(s0)
    80004244:	e8845783          	lhu	a5,-376(s0)
    80004248:	c7ad                	beqz	a5,800042b2 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000424a:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000424c:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    8000424e:	6c85                	lui	s9,0x1
    80004250:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004254:	def43823          	sd	a5,-528(s0)
    80004258:	a42d                	j	80004482 <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    8000425a:	00004517          	auipc	a0,0x4
    8000425e:	4b650513          	addi	a0,a0,1206 # 80008710 <syscalls+0x280>
    80004262:	00002097          	auipc	ra,0x2
    80004266:	ab6080e7          	jalr	-1354(ra) # 80005d18 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000426a:	8756                	mv	a4,s5
    8000426c:	012d86bb          	addw	a3,s11,s2
    80004270:	4581                	li	a1,0
    80004272:	8526                	mv	a0,s1
    80004274:	fffff097          	auipc	ra,0xfffff
    80004278:	cac080e7          	jalr	-852(ra) # 80002f20 <readi>
    8000427c:	2501                	sext.w	a0,a0
    8000427e:	1aaa9963          	bne	s5,a0,80004430 <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    80004282:	6785                	lui	a5,0x1
    80004284:	0127893b          	addw	s2,a5,s2
    80004288:	77fd                	lui	a5,0xfffff
    8000428a:	01478a3b          	addw	s4,a5,s4
    8000428e:	1f897163          	bgeu	s2,s8,80004470 <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    80004292:	02091593          	slli	a1,s2,0x20
    80004296:	9181                	srli	a1,a1,0x20
    80004298:	95ea                	add	a1,a1,s10
    8000429a:	855e                	mv	a0,s7
    8000429c:	ffffc097          	auipc	ra,0xffffc
    800042a0:	304080e7          	jalr	772(ra) # 800005a0 <walkaddr>
    800042a4:	862a                	mv	a2,a0
    if(pa == 0)
    800042a6:	d955                	beqz	a0,8000425a <exec+0xf0>
      n = PGSIZE;
    800042a8:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    800042aa:	fd9a70e3          	bgeu	s4,s9,8000426a <exec+0x100>
      n = sz - i;
    800042ae:	8ad2                	mv	s5,s4
    800042b0:	bf6d                	j	8000426a <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042b2:	4901                	li	s2,0
  iunlockput(ip);
    800042b4:	8526                	mv	a0,s1
    800042b6:	fffff097          	auipc	ra,0xfffff
    800042ba:	c18080e7          	jalr	-1000(ra) # 80002ece <iunlockput>
  end_op();
    800042be:	fffff097          	auipc	ra,0xfffff
    800042c2:	400080e7          	jalr	1024(ra) # 800036be <end_op>
  p = myproc();
    800042c6:	ffffd097          	auipc	ra,0xffffd
    800042ca:	c5c080e7          	jalr	-932(ra) # 80000f22 <myproc>
    800042ce:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800042d0:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800042d4:	6785                	lui	a5,0x1
    800042d6:	17fd                	addi	a5,a5,-1
    800042d8:	993e                	add	s2,s2,a5
    800042da:	757d                	lui	a0,0xfffff
    800042dc:	00a977b3          	and	a5,s2,a0
    800042e0:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800042e4:	6609                	lui	a2,0x2
    800042e6:	963e                	add	a2,a2,a5
    800042e8:	85be                	mv	a1,a5
    800042ea:	855e                	mv	a0,s7
    800042ec:	ffffc097          	auipc	ra,0xffffc
    800042f0:	668080e7          	jalr	1640(ra) # 80000954 <uvmalloc>
    800042f4:	8b2a                	mv	s6,a0
  ip = 0;
    800042f6:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800042f8:	12050c63          	beqz	a0,80004430 <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    800042fc:	75f9                	lui	a1,0xffffe
    800042fe:	95aa                	add	a1,a1,a0
    80004300:	855e                	mv	a0,s7
    80004302:	ffffd097          	auipc	ra,0xffffd
    80004306:	8b0080e7          	jalr	-1872(ra) # 80000bb2 <uvmclear>
  stackbase = sp - PGSIZE;
    8000430a:	7c7d                	lui	s8,0xfffff
    8000430c:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    8000430e:	e0043783          	ld	a5,-512(s0)
    80004312:	6388                	ld	a0,0(a5)
    80004314:	c535                	beqz	a0,80004380 <exec+0x216>
    80004316:	e9040993          	addi	s3,s0,-368
    8000431a:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    8000431e:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004320:	ffffc097          	auipc	ra,0xffffc
    80004324:	076080e7          	jalr	118(ra) # 80000396 <strlen>
    80004328:	2505                	addiw	a0,a0,1
    8000432a:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000432e:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004332:	13896363          	bltu	s2,s8,80004458 <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004336:	e0043d83          	ld	s11,-512(s0)
    8000433a:	000dba03          	ld	s4,0(s11)
    8000433e:	8552                	mv	a0,s4
    80004340:	ffffc097          	auipc	ra,0xffffc
    80004344:	056080e7          	jalr	86(ra) # 80000396 <strlen>
    80004348:	0015069b          	addiw	a3,a0,1
    8000434c:	8652                	mv	a2,s4
    8000434e:	85ca                	mv	a1,s2
    80004350:	855e                	mv	a0,s7
    80004352:	ffffd097          	auipc	ra,0xffffd
    80004356:	892080e7          	jalr	-1902(ra) # 80000be4 <copyout>
    8000435a:	10054363          	bltz	a0,80004460 <exec+0x2f6>
    ustack[argc] = sp;
    8000435e:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004362:	0485                	addi	s1,s1,1
    80004364:	008d8793          	addi	a5,s11,8
    80004368:	e0f43023          	sd	a5,-512(s0)
    8000436c:	008db503          	ld	a0,8(s11)
    80004370:	c911                	beqz	a0,80004384 <exec+0x21a>
    if(argc >= MAXARG)
    80004372:	09a1                	addi	s3,s3,8
    80004374:	fb3c96e3          	bne	s9,s3,80004320 <exec+0x1b6>
  sz = sz1;
    80004378:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000437c:	4481                	li	s1,0
    8000437e:	a84d                	j	80004430 <exec+0x2c6>
  sp = sz;
    80004380:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004382:	4481                	li	s1,0
  ustack[argc] = 0;
    80004384:	00349793          	slli	a5,s1,0x3
    80004388:	f9040713          	addi	a4,s0,-112
    8000438c:	97ba                	add	a5,a5,a4
    8000438e:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    80004392:	00148693          	addi	a3,s1,1
    80004396:	068e                	slli	a3,a3,0x3
    80004398:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000439c:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800043a0:	01897663          	bgeu	s2,s8,800043ac <exec+0x242>
  sz = sz1;
    800043a4:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043a8:	4481                	li	s1,0
    800043aa:	a059                	j	80004430 <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800043ac:	e9040613          	addi	a2,s0,-368
    800043b0:	85ca                	mv	a1,s2
    800043b2:	855e                	mv	a0,s7
    800043b4:	ffffd097          	auipc	ra,0xffffd
    800043b8:	830080e7          	jalr	-2000(ra) # 80000be4 <copyout>
    800043bc:	0a054663          	bltz	a0,80004468 <exec+0x2fe>
  p->trapframe->a1 = sp;
    800043c0:	058ab783          	ld	a5,88(s5)
    800043c4:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800043c8:	df843783          	ld	a5,-520(s0)
    800043cc:	0007c703          	lbu	a4,0(a5)
    800043d0:	cf11                	beqz	a4,800043ec <exec+0x282>
    800043d2:	0785                	addi	a5,a5,1
    if(*s == '/')
    800043d4:	02f00693          	li	a3,47
    800043d8:	a039                	j	800043e6 <exec+0x27c>
      last = s+1;
    800043da:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800043de:	0785                	addi	a5,a5,1
    800043e0:	fff7c703          	lbu	a4,-1(a5)
    800043e4:	c701                	beqz	a4,800043ec <exec+0x282>
    if(*s == '/')
    800043e6:	fed71ce3          	bne	a4,a3,800043de <exec+0x274>
    800043ea:	bfc5                	j	800043da <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    800043ec:	4641                	li	a2,16
    800043ee:	df843583          	ld	a1,-520(s0)
    800043f2:	158a8513          	addi	a0,s5,344
    800043f6:	ffffc097          	auipc	ra,0xffffc
    800043fa:	f6e080e7          	jalr	-146(ra) # 80000364 <safestrcpy>
  oldpagetable = p->pagetable;
    800043fe:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004402:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    80004406:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000440a:	058ab783          	ld	a5,88(s5)
    8000440e:	e6843703          	ld	a4,-408(s0)
    80004412:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004414:	058ab783          	ld	a5,88(s5)
    80004418:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000441c:	85ea                	mv	a1,s10
    8000441e:	ffffd097          	auipc	ra,0xffffd
    80004422:	c64080e7          	jalr	-924(ra) # 80001082 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004426:	0004851b          	sext.w	a0,s1
    8000442a:	bbe1                	j	80004202 <exec+0x98>
    8000442c:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004430:	e0843583          	ld	a1,-504(s0)
    80004434:	855e                	mv	a0,s7
    80004436:	ffffd097          	auipc	ra,0xffffd
    8000443a:	c4c080e7          	jalr	-948(ra) # 80001082 <proc_freepagetable>
  if(ip){
    8000443e:	da0498e3          	bnez	s1,800041ee <exec+0x84>
  return -1;
    80004442:	557d                	li	a0,-1
    80004444:	bb7d                	j	80004202 <exec+0x98>
    80004446:	e1243423          	sd	s2,-504(s0)
    8000444a:	b7dd                	j	80004430 <exec+0x2c6>
    8000444c:	e1243423          	sd	s2,-504(s0)
    80004450:	b7c5                	j	80004430 <exec+0x2c6>
    80004452:	e1243423          	sd	s2,-504(s0)
    80004456:	bfe9                	j	80004430 <exec+0x2c6>
  sz = sz1;
    80004458:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000445c:	4481                	li	s1,0
    8000445e:	bfc9                	j	80004430 <exec+0x2c6>
  sz = sz1;
    80004460:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004464:	4481                	li	s1,0
    80004466:	b7e9                	j	80004430 <exec+0x2c6>
  sz = sz1;
    80004468:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000446c:	4481                	li	s1,0
    8000446e:	b7c9                	j	80004430 <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004470:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004474:	2b05                	addiw	s6,s6,1
    80004476:	0389899b          	addiw	s3,s3,56
    8000447a:	e8845783          	lhu	a5,-376(s0)
    8000447e:	e2fb5be3          	bge	s6,a5,800042b4 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004482:	2981                	sext.w	s3,s3
    80004484:	03800713          	li	a4,56
    80004488:	86ce                	mv	a3,s3
    8000448a:	e1840613          	addi	a2,s0,-488
    8000448e:	4581                	li	a1,0
    80004490:	8526                	mv	a0,s1
    80004492:	fffff097          	auipc	ra,0xfffff
    80004496:	a8e080e7          	jalr	-1394(ra) # 80002f20 <readi>
    8000449a:	03800793          	li	a5,56
    8000449e:	f8f517e3          	bne	a0,a5,8000442c <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    800044a2:	e1842783          	lw	a5,-488(s0)
    800044a6:	4705                	li	a4,1
    800044a8:	fce796e3          	bne	a5,a4,80004474 <exec+0x30a>
    if(ph.memsz < ph.filesz)
    800044ac:	e4043603          	ld	a2,-448(s0)
    800044b0:	e3843783          	ld	a5,-456(s0)
    800044b4:	f8f669e3          	bltu	a2,a5,80004446 <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800044b8:	e2843783          	ld	a5,-472(s0)
    800044bc:	963e                	add	a2,a2,a5
    800044be:	f8f667e3          	bltu	a2,a5,8000444c <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800044c2:	85ca                	mv	a1,s2
    800044c4:	855e                	mv	a0,s7
    800044c6:	ffffc097          	auipc	ra,0xffffc
    800044ca:	48e080e7          	jalr	1166(ra) # 80000954 <uvmalloc>
    800044ce:	e0a43423          	sd	a0,-504(s0)
    800044d2:	d141                	beqz	a0,80004452 <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    800044d4:	e2843d03          	ld	s10,-472(s0)
    800044d8:	df043783          	ld	a5,-528(s0)
    800044dc:	00fd77b3          	and	a5,s10,a5
    800044e0:	fba1                	bnez	a5,80004430 <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800044e2:	e2042d83          	lw	s11,-480(s0)
    800044e6:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800044ea:	f80c03e3          	beqz	s8,80004470 <exec+0x306>
    800044ee:	8a62                	mv	s4,s8
    800044f0:	4901                	li	s2,0
    800044f2:	b345                	j	80004292 <exec+0x128>

00000000800044f4 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800044f4:	7179                	addi	sp,sp,-48
    800044f6:	f406                	sd	ra,40(sp)
    800044f8:	f022                	sd	s0,32(sp)
    800044fa:	ec26                	sd	s1,24(sp)
    800044fc:	e84a                	sd	s2,16(sp)
    800044fe:	1800                	addi	s0,sp,48
    80004500:	892e                	mv	s2,a1
    80004502:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004504:	fdc40593          	addi	a1,s0,-36
    80004508:	ffffe097          	auipc	ra,0xffffe
    8000450c:	bf2080e7          	jalr	-1038(ra) # 800020fa <argint>
    80004510:	04054063          	bltz	a0,80004550 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004514:	fdc42703          	lw	a4,-36(s0)
    80004518:	47bd                	li	a5,15
    8000451a:	02e7ed63          	bltu	a5,a4,80004554 <argfd+0x60>
    8000451e:	ffffd097          	auipc	ra,0xffffd
    80004522:	a04080e7          	jalr	-1532(ra) # 80000f22 <myproc>
    80004526:	fdc42703          	lw	a4,-36(s0)
    8000452a:	01a70793          	addi	a5,a4,26
    8000452e:	078e                	slli	a5,a5,0x3
    80004530:	953e                	add	a0,a0,a5
    80004532:	611c                	ld	a5,0(a0)
    80004534:	c395                	beqz	a5,80004558 <argfd+0x64>
    return -1;
  if(pfd)
    80004536:	00090463          	beqz	s2,8000453e <argfd+0x4a>
    *pfd = fd;
    8000453a:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000453e:	4501                	li	a0,0
  if(pf)
    80004540:	c091                	beqz	s1,80004544 <argfd+0x50>
    *pf = f;
    80004542:	e09c                	sd	a5,0(s1)
}
    80004544:	70a2                	ld	ra,40(sp)
    80004546:	7402                	ld	s0,32(sp)
    80004548:	64e2                	ld	s1,24(sp)
    8000454a:	6942                	ld	s2,16(sp)
    8000454c:	6145                	addi	sp,sp,48
    8000454e:	8082                	ret
    return -1;
    80004550:	557d                	li	a0,-1
    80004552:	bfcd                	j	80004544 <argfd+0x50>
    return -1;
    80004554:	557d                	li	a0,-1
    80004556:	b7fd                	j	80004544 <argfd+0x50>
    80004558:	557d                	li	a0,-1
    8000455a:	b7ed                	j	80004544 <argfd+0x50>

000000008000455c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000455c:	1101                	addi	sp,sp,-32
    8000455e:	ec06                	sd	ra,24(sp)
    80004560:	e822                	sd	s0,16(sp)
    80004562:	e426                	sd	s1,8(sp)
    80004564:	1000                	addi	s0,sp,32
    80004566:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004568:	ffffd097          	auipc	ra,0xffffd
    8000456c:	9ba080e7          	jalr	-1606(ra) # 80000f22 <myproc>
    80004570:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004572:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffb8e90>
    80004576:	4501                	li	a0,0
    80004578:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000457a:	6398                	ld	a4,0(a5)
    8000457c:	cb19                	beqz	a4,80004592 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000457e:	2505                	addiw	a0,a0,1
    80004580:	07a1                	addi	a5,a5,8
    80004582:	fed51ce3          	bne	a0,a3,8000457a <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004586:	557d                	li	a0,-1
}
    80004588:	60e2                	ld	ra,24(sp)
    8000458a:	6442                	ld	s0,16(sp)
    8000458c:	64a2                	ld	s1,8(sp)
    8000458e:	6105                	addi	sp,sp,32
    80004590:	8082                	ret
      p->ofile[fd] = f;
    80004592:	01a50793          	addi	a5,a0,26
    80004596:	078e                	slli	a5,a5,0x3
    80004598:	963e                	add	a2,a2,a5
    8000459a:	e204                	sd	s1,0(a2)
      return fd;
    8000459c:	b7f5                	j	80004588 <fdalloc+0x2c>

000000008000459e <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000459e:	715d                	addi	sp,sp,-80
    800045a0:	e486                	sd	ra,72(sp)
    800045a2:	e0a2                	sd	s0,64(sp)
    800045a4:	fc26                	sd	s1,56(sp)
    800045a6:	f84a                	sd	s2,48(sp)
    800045a8:	f44e                	sd	s3,40(sp)
    800045aa:	f052                	sd	s4,32(sp)
    800045ac:	ec56                	sd	s5,24(sp)
    800045ae:	0880                	addi	s0,sp,80
    800045b0:	89ae                	mv	s3,a1
    800045b2:	8ab2                	mv	s5,a2
    800045b4:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800045b6:	fb040593          	addi	a1,s0,-80
    800045ba:	fffff097          	auipc	ra,0xfffff
    800045be:	e86080e7          	jalr	-378(ra) # 80003440 <nameiparent>
    800045c2:	892a                	mv	s2,a0
    800045c4:	12050f63          	beqz	a0,80004702 <create+0x164>
    return 0;

  ilock(dp);
    800045c8:	ffffe097          	auipc	ra,0xffffe
    800045cc:	6a4080e7          	jalr	1700(ra) # 80002c6c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800045d0:	4601                	li	a2,0
    800045d2:	fb040593          	addi	a1,s0,-80
    800045d6:	854a                	mv	a0,s2
    800045d8:	fffff097          	auipc	ra,0xfffff
    800045dc:	b78080e7          	jalr	-1160(ra) # 80003150 <dirlookup>
    800045e0:	84aa                	mv	s1,a0
    800045e2:	c921                	beqz	a0,80004632 <create+0x94>
    iunlockput(dp);
    800045e4:	854a                	mv	a0,s2
    800045e6:	fffff097          	auipc	ra,0xfffff
    800045ea:	8e8080e7          	jalr	-1816(ra) # 80002ece <iunlockput>
    ilock(ip);
    800045ee:	8526                	mv	a0,s1
    800045f0:	ffffe097          	auipc	ra,0xffffe
    800045f4:	67c080e7          	jalr	1660(ra) # 80002c6c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800045f8:	2981                	sext.w	s3,s3
    800045fa:	4789                	li	a5,2
    800045fc:	02f99463          	bne	s3,a5,80004624 <create+0x86>
    80004600:	0444d783          	lhu	a5,68(s1)
    80004604:	37f9                	addiw	a5,a5,-2
    80004606:	17c2                	slli	a5,a5,0x30
    80004608:	93c1                	srli	a5,a5,0x30
    8000460a:	4705                	li	a4,1
    8000460c:	00f76c63          	bltu	a4,a5,80004624 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004610:	8526                	mv	a0,s1
    80004612:	60a6                	ld	ra,72(sp)
    80004614:	6406                	ld	s0,64(sp)
    80004616:	74e2                	ld	s1,56(sp)
    80004618:	7942                	ld	s2,48(sp)
    8000461a:	79a2                	ld	s3,40(sp)
    8000461c:	7a02                	ld	s4,32(sp)
    8000461e:	6ae2                	ld	s5,24(sp)
    80004620:	6161                	addi	sp,sp,80
    80004622:	8082                	ret
    iunlockput(ip);
    80004624:	8526                	mv	a0,s1
    80004626:	fffff097          	auipc	ra,0xfffff
    8000462a:	8a8080e7          	jalr	-1880(ra) # 80002ece <iunlockput>
    return 0;
    8000462e:	4481                	li	s1,0
    80004630:	b7c5                	j	80004610 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004632:	85ce                	mv	a1,s3
    80004634:	00092503          	lw	a0,0(s2)
    80004638:	ffffe097          	auipc	ra,0xffffe
    8000463c:	49c080e7          	jalr	1180(ra) # 80002ad4 <ialloc>
    80004640:	84aa                	mv	s1,a0
    80004642:	c529                	beqz	a0,8000468c <create+0xee>
  ilock(ip);
    80004644:	ffffe097          	auipc	ra,0xffffe
    80004648:	628080e7          	jalr	1576(ra) # 80002c6c <ilock>
  ip->major = major;
    8000464c:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80004650:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80004654:	4785                	li	a5,1
    80004656:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000465a:	8526                	mv	a0,s1
    8000465c:	ffffe097          	auipc	ra,0xffffe
    80004660:	546080e7          	jalr	1350(ra) # 80002ba2 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004664:	2981                	sext.w	s3,s3
    80004666:	4785                	li	a5,1
    80004668:	02f98a63          	beq	s3,a5,8000469c <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    8000466c:	40d0                	lw	a2,4(s1)
    8000466e:	fb040593          	addi	a1,s0,-80
    80004672:	854a                	mv	a0,s2
    80004674:	fffff097          	auipc	ra,0xfffff
    80004678:	cec080e7          	jalr	-788(ra) # 80003360 <dirlink>
    8000467c:	06054b63          	bltz	a0,800046f2 <create+0x154>
  iunlockput(dp);
    80004680:	854a                	mv	a0,s2
    80004682:	fffff097          	auipc	ra,0xfffff
    80004686:	84c080e7          	jalr	-1972(ra) # 80002ece <iunlockput>
  return ip;
    8000468a:	b759                	j	80004610 <create+0x72>
    panic("create: ialloc");
    8000468c:	00004517          	auipc	a0,0x4
    80004690:	0a450513          	addi	a0,a0,164 # 80008730 <syscalls+0x2a0>
    80004694:	00001097          	auipc	ra,0x1
    80004698:	684080e7          	jalr	1668(ra) # 80005d18 <panic>
    dp->nlink++;  // for ".."
    8000469c:	04a95783          	lhu	a5,74(s2)
    800046a0:	2785                	addiw	a5,a5,1
    800046a2:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800046a6:	854a                	mv	a0,s2
    800046a8:	ffffe097          	auipc	ra,0xffffe
    800046ac:	4fa080e7          	jalr	1274(ra) # 80002ba2 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800046b0:	40d0                	lw	a2,4(s1)
    800046b2:	00004597          	auipc	a1,0x4
    800046b6:	08e58593          	addi	a1,a1,142 # 80008740 <syscalls+0x2b0>
    800046ba:	8526                	mv	a0,s1
    800046bc:	fffff097          	auipc	ra,0xfffff
    800046c0:	ca4080e7          	jalr	-860(ra) # 80003360 <dirlink>
    800046c4:	00054f63          	bltz	a0,800046e2 <create+0x144>
    800046c8:	00492603          	lw	a2,4(s2)
    800046cc:	00004597          	auipc	a1,0x4
    800046d0:	07c58593          	addi	a1,a1,124 # 80008748 <syscalls+0x2b8>
    800046d4:	8526                	mv	a0,s1
    800046d6:	fffff097          	auipc	ra,0xfffff
    800046da:	c8a080e7          	jalr	-886(ra) # 80003360 <dirlink>
    800046de:	f80557e3          	bgez	a0,8000466c <create+0xce>
      panic("create dots");
    800046e2:	00004517          	auipc	a0,0x4
    800046e6:	06e50513          	addi	a0,a0,110 # 80008750 <syscalls+0x2c0>
    800046ea:	00001097          	auipc	ra,0x1
    800046ee:	62e080e7          	jalr	1582(ra) # 80005d18 <panic>
    panic("create: dirlink");
    800046f2:	00004517          	auipc	a0,0x4
    800046f6:	06e50513          	addi	a0,a0,110 # 80008760 <syscalls+0x2d0>
    800046fa:	00001097          	auipc	ra,0x1
    800046fe:	61e080e7          	jalr	1566(ra) # 80005d18 <panic>
    return 0;
    80004702:	84aa                	mv	s1,a0
    80004704:	b731                	j	80004610 <create+0x72>

0000000080004706 <sys_dup>:
{
    80004706:	7179                	addi	sp,sp,-48
    80004708:	f406                	sd	ra,40(sp)
    8000470a:	f022                	sd	s0,32(sp)
    8000470c:	ec26                	sd	s1,24(sp)
    8000470e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004710:	fd840613          	addi	a2,s0,-40
    80004714:	4581                	li	a1,0
    80004716:	4501                	li	a0,0
    80004718:	00000097          	auipc	ra,0x0
    8000471c:	ddc080e7          	jalr	-548(ra) # 800044f4 <argfd>
    return -1;
    80004720:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004722:	02054363          	bltz	a0,80004748 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80004726:	fd843503          	ld	a0,-40(s0)
    8000472a:	00000097          	auipc	ra,0x0
    8000472e:	e32080e7          	jalr	-462(ra) # 8000455c <fdalloc>
    80004732:	84aa                	mv	s1,a0
    return -1;
    80004734:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004736:	00054963          	bltz	a0,80004748 <sys_dup+0x42>
  filedup(f);
    8000473a:	fd843503          	ld	a0,-40(s0)
    8000473e:	fffff097          	auipc	ra,0xfffff
    80004742:	37a080e7          	jalr	890(ra) # 80003ab8 <filedup>
  return fd;
    80004746:	87a6                	mv	a5,s1
}
    80004748:	853e                	mv	a0,a5
    8000474a:	70a2                	ld	ra,40(sp)
    8000474c:	7402                	ld	s0,32(sp)
    8000474e:	64e2                	ld	s1,24(sp)
    80004750:	6145                	addi	sp,sp,48
    80004752:	8082                	ret

0000000080004754 <sys_read>:
{
    80004754:	7179                	addi	sp,sp,-48
    80004756:	f406                	sd	ra,40(sp)
    80004758:	f022                	sd	s0,32(sp)
    8000475a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000475c:	fe840613          	addi	a2,s0,-24
    80004760:	4581                	li	a1,0
    80004762:	4501                	li	a0,0
    80004764:	00000097          	auipc	ra,0x0
    80004768:	d90080e7          	jalr	-624(ra) # 800044f4 <argfd>
    return -1;
    8000476c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000476e:	04054163          	bltz	a0,800047b0 <sys_read+0x5c>
    80004772:	fe440593          	addi	a1,s0,-28
    80004776:	4509                	li	a0,2
    80004778:	ffffe097          	auipc	ra,0xffffe
    8000477c:	982080e7          	jalr	-1662(ra) # 800020fa <argint>
    return -1;
    80004780:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004782:	02054763          	bltz	a0,800047b0 <sys_read+0x5c>
    80004786:	fd840593          	addi	a1,s0,-40
    8000478a:	4505                	li	a0,1
    8000478c:	ffffe097          	auipc	ra,0xffffe
    80004790:	990080e7          	jalr	-1648(ra) # 8000211c <argaddr>
    return -1;
    80004794:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004796:	00054d63          	bltz	a0,800047b0 <sys_read+0x5c>
  return fileread(f, p, n);
    8000479a:	fe442603          	lw	a2,-28(s0)
    8000479e:	fd843583          	ld	a1,-40(s0)
    800047a2:	fe843503          	ld	a0,-24(s0)
    800047a6:	fffff097          	auipc	ra,0xfffff
    800047aa:	49e080e7          	jalr	1182(ra) # 80003c44 <fileread>
    800047ae:	87aa                	mv	a5,a0
}
    800047b0:	853e                	mv	a0,a5
    800047b2:	70a2                	ld	ra,40(sp)
    800047b4:	7402                	ld	s0,32(sp)
    800047b6:	6145                	addi	sp,sp,48
    800047b8:	8082                	ret

00000000800047ba <sys_write>:
{
    800047ba:	7179                	addi	sp,sp,-48
    800047bc:	f406                	sd	ra,40(sp)
    800047be:	f022                	sd	s0,32(sp)
    800047c0:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047c2:	fe840613          	addi	a2,s0,-24
    800047c6:	4581                	li	a1,0
    800047c8:	4501                	li	a0,0
    800047ca:	00000097          	auipc	ra,0x0
    800047ce:	d2a080e7          	jalr	-726(ra) # 800044f4 <argfd>
    return -1;
    800047d2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047d4:	04054163          	bltz	a0,80004816 <sys_write+0x5c>
    800047d8:	fe440593          	addi	a1,s0,-28
    800047dc:	4509                	li	a0,2
    800047de:	ffffe097          	auipc	ra,0xffffe
    800047e2:	91c080e7          	jalr	-1764(ra) # 800020fa <argint>
    return -1;
    800047e6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047e8:	02054763          	bltz	a0,80004816 <sys_write+0x5c>
    800047ec:	fd840593          	addi	a1,s0,-40
    800047f0:	4505                	li	a0,1
    800047f2:	ffffe097          	auipc	ra,0xffffe
    800047f6:	92a080e7          	jalr	-1750(ra) # 8000211c <argaddr>
    return -1;
    800047fa:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047fc:	00054d63          	bltz	a0,80004816 <sys_write+0x5c>
  return filewrite(f, p, n);
    80004800:	fe442603          	lw	a2,-28(s0)
    80004804:	fd843583          	ld	a1,-40(s0)
    80004808:	fe843503          	ld	a0,-24(s0)
    8000480c:	fffff097          	auipc	ra,0xfffff
    80004810:	4fa080e7          	jalr	1274(ra) # 80003d06 <filewrite>
    80004814:	87aa                	mv	a5,a0
}
    80004816:	853e                	mv	a0,a5
    80004818:	70a2                	ld	ra,40(sp)
    8000481a:	7402                	ld	s0,32(sp)
    8000481c:	6145                	addi	sp,sp,48
    8000481e:	8082                	ret

0000000080004820 <sys_close>:
{
    80004820:	1101                	addi	sp,sp,-32
    80004822:	ec06                	sd	ra,24(sp)
    80004824:	e822                	sd	s0,16(sp)
    80004826:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004828:	fe040613          	addi	a2,s0,-32
    8000482c:	fec40593          	addi	a1,s0,-20
    80004830:	4501                	li	a0,0
    80004832:	00000097          	auipc	ra,0x0
    80004836:	cc2080e7          	jalr	-830(ra) # 800044f4 <argfd>
    return -1;
    8000483a:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000483c:	02054463          	bltz	a0,80004864 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004840:	ffffc097          	auipc	ra,0xffffc
    80004844:	6e2080e7          	jalr	1762(ra) # 80000f22 <myproc>
    80004848:	fec42783          	lw	a5,-20(s0)
    8000484c:	07e9                	addi	a5,a5,26
    8000484e:	078e                	slli	a5,a5,0x3
    80004850:	97aa                	add	a5,a5,a0
    80004852:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004856:	fe043503          	ld	a0,-32(s0)
    8000485a:	fffff097          	auipc	ra,0xfffff
    8000485e:	2b0080e7          	jalr	688(ra) # 80003b0a <fileclose>
  return 0;
    80004862:	4781                	li	a5,0
}
    80004864:	853e                	mv	a0,a5
    80004866:	60e2                	ld	ra,24(sp)
    80004868:	6442                	ld	s0,16(sp)
    8000486a:	6105                	addi	sp,sp,32
    8000486c:	8082                	ret

000000008000486e <sys_fstat>:
{
    8000486e:	1101                	addi	sp,sp,-32
    80004870:	ec06                	sd	ra,24(sp)
    80004872:	e822                	sd	s0,16(sp)
    80004874:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004876:	fe840613          	addi	a2,s0,-24
    8000487a:	4581                	li	a1,0
    8000487c:	4501                	li	a0,0
    8000487e:	00000097          	auipc	ra,0x0
    80004882:	c76080e7          	jalr	-906(ra) # 800044f4 <argfd>
    return -1;
    80004886:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004888:	02054563          	bltz	a0,800048b2 <sys_fstat+0x44>
    8000488c:	fe040593          	addi	a1,s0,-32
    80004890:	4505                	li	a0,1
    80004892:	ffffe097          	auipc	ra,0xffffe
    80004896:	88a080e7          	jalr	-1910(ra) # 8000211c <argaddr>
    return -1;
    8000489a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000489c:	00054b63          	bltz	a0,800048b2 <sys_fstat+0x44>
  return filestat(f, st);
    800048a0:	fe043583          	ld	a1,-32(s0)
    800048a4:	fe843503          	ld	a0,-24(s0)
    800048a8:	fffff097          	auipc	ra,0xfffff
    800048ac:	32a080e7          	jalr	810(ra) # 80003bd2 <filestat>
    800048b0:	87aa                	mv	a5,a0
}
    800048b2:	853e                	mv	a0,a5
    800048b4:	60e2                	ld	ra,24(sp)
    800048b6:	6442                	ld	s0,16(sp)
    800048b8:	6105                	addi	sp,sp,32
    800048ba:	8082                	ret

00000000800048bc <sys_link>:
{
    800048bc:	7169                	addi	sp,sp,-304
    800048be:	f606                	sd	ra,296(sp)
    800048c0:	f222                	sd	s0,288(sp)
    800048c2:	ee26                	sd	s1,280(sp)
    800048c4:	ea4a                	sd	s2,272(sp)
    800048c6:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048c8:	08000613          	li	a2,128
    800048cc:	ed040593          	addi	a1,s0,-304
    800048d0:	4501                	li	a0,0
    800048d2:	ffffe097          	auipc	ra,0xffffe
    800048d6:	86c080e7          	jalr	-1940(ra) # 8000213e <argstr>
    return -1;
    800048da:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048dc:	10054e63          	bltz	a0,800049f8 <sys_link+0x13c>
    800048e0:	08000613          	li	a2,128
    800048e4:	f5040593          	addi	a1,s0,-176
    800048e8:	4505                	li	a0,1
    800048ea:	ffffe097          	auipc	ra,0xffffe
    800048ee:	854080e7          	jalr	-1964(ra) # 8000213e <argstr>
    return -1;
    800048f2:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048f4:	10054263          	bltz	a0,800049f8 <sys_link+0x13c>
  begin_op();
    800048f8:	fffff097          	auipc	ra,0xfffff
    800048fc:	d46080e7          	jalr	-698(ra) # 8000363e <begin_op>
  if((ip = namei(old)) == 0){
    80004900:	ed040513          	addi	a0,s0,-304
    80004904:	fffff097          	auipc	ra,0xfffff
    80004908:	b1e080e7          	jalr	-1250(ra) # 80003422 <namei>
    8000490c:	84aa                	mv	s1,a0
    8000490e:	c551                	beqz	a0,8000499a <sys_link+0xde>
  ilock(ip);
    80004910:	ffffe097          	auipc	ra,0xffffe
    80004914:	35c080e7          	jalr	860(ra) # 80002c6c <ilock>
  if(ip->type == T_DIR){
    80004918:	04449703          	lh	a4,68(s1)
    8000491c:	4785                	li	a5,1
    8000491e:	08f70463          	beq	a4,a5,800049a6 <sys_link+0xea>
  ip->nlink++;
    80004922:	04a4d783          	lhu	a5,74(s1)
    80004926:	2785                	addiw	a5,a5,1
    80004928:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000492c:	8526                	mv	a0,s1
    8000492e:	ffffe097          	auipc	ra,0xffffe
    80004932:	274080e7          	jalr	628(ra) # 80002ba2 <iupdate>
  iunlock(ip);
    80004936:	8526                	mv	a0,s1
    80004938:	ffffe097          	auipc	ra,0xffffe
    8000493c:	3f6080e7          	jalr	1014(ra) # 80002d2e <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004940:	fd040593          	addi	a1,s0,-48
    80004944:	f5040513          	addi	a0,s0,-176
    80004948:	fffff097          	auipc	ra,0xfffff
    8000494c:	af8080e7          	jalr	-1288(ra) # 80003440 <nameiparent>
    80004950:	892a                	mv	s2,a0
    80004952:	c935                	beqz	a0,800049c6 <sys_link+0x10a>
  ilock(dp);
    80004954:	ffffe097          	auipc	ra,0xffffe
    80004958:	318080e7          	jalr	792(ra) # 80002c6c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000495c:	00092703          	lw	a4,0(s2)
    80004960:	409c                	lw	a5,0(s1)
    80004962:	04f71d63          	bne	a4,a5,800049bc <sys_link+0x100>
    80004966:	40d0                	lw	a2,4(s1)
    80004968:	fd040593          	addi	a1,s0,-48
    8000496c:	854a                	mv	a0,s2
    8000496e:	fffff097          	auipc	ra,0xfffff
    80004972:	9f2080e7          	jalr	-1550(ra) # 80003360 <dirlink>
    80004976:	04054363          	bltz	a0,800049bc <sys_link+0x100>
  iunlockput(dp);
    8000497a:	854a                	mv	a0,s2
    8000497c:	ffffe097          	auipc	ra,0xffffe
    80004980:	552080e7          	jalr	1362(ra) # 80002ece <iunlockput>
  iput(ip);
    80004984:	8526                	mv	a0,s1
    80004986:	ffffe097          	auipc	ra,0xffffe
    8000498a:	4a0080e7          	jalr	1184(ra) # 80002e26 <iput>
  end_op();
    8000498e:	fffff097          	auipc	ra,0xfffff
    80004992:	d30080e7          	jalr	-720(ra) # 800036be <end_op>
  return 0;
    80004996:	4781                	li	a5,0
    80004998:	a085                	j	800049f8 <sys_link+0x13c>
    end_op();
    8000499a:	fffff097          	auipc	ra,0xfffff
    8000499e:	d24080e7          	jalr	-732(ra) # 800036be <end_op>
    return -1;
    800049a2:	57fd                	li	a5,-1
    800049a4:	a891                	j	800049f8 <sys_link+0x13c>
    iunlockput(ip);
    800049a6:	8526                	mv	a0,s1
    800049a8:	ffffe097          	auipc	ra,0xffffe
    800049ac:	526080e7          	jalr	1318(ra) # 80002ece <iunlockput>
    end_op();
    800049b0:	fffff097          	auipc	ra,0xfffff
    800049b4:	d0e080e7          	jalr	-754(ra) # 800036be <end_op>
    return -1;
    800049b8:	57fd                	li	a5,-1
    800049ba:	a83d                	j	800049f8 <sys_link+0x13c>
    iunlockput(dp);
    800049bc:	854a                	mv	a0,s2
    800049be:	ffffe097          	auipc	ra,0xffffe
    800049c2:	510080e7          	jalr	1296(ra) # 80002ece <iunlockput>
  ilock(ip);
    800049c6:	8526                	mv	a0,s1
    800049c8:	ffffe097          	auipc	ra,0xffffe
    800049cc:	2a4080e7          	jalr	676(ra) # 80002c6c <ilock>
  ip->nlink--;
    800049d0:	04a4d783          	lhu	a5,74(s1)
    800049d4:	37fd                	addiw	a5,a5,-1
    800049d6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800049da:	8526                	mv	a0,s1
    800049dc:	ffffe097          	auipc	ra,0xffffe
    800049e0:	1c6080e7          	jalr	454(ra) # 80002ba2 <iupdate>
  iunlockput(ip);
    800049e4:	8526                	mv	a0,s1
    800049e6:	ffffe097          	auipc	ra,0xffffe
    800049ea:	4e8080e7          	jalr	1256(ra) # 80002ece <iunlockput>
  end_op();
    800049ee:	fffff097          	auipc	ra,0xfffff
    800049f2:	cd0080e7          	jalr	-816(ra) # 800036be <end_op>
  return -1;
    800049f6:	57fd                	li	a5,-1
}
    800049f8:	853e                	mv	a0,a5
    800049fa:	70b2                	ld	ra,296(sp)
    800049fc:	7412                	ld	s0,288(sp)
    800049fe:	64f2                	ld	s1,280(sp)
    80004a00:	6952                	ld	s2,272(sp)
    80004a02:	6155                	addi	sp,sp,304
    80004a04:	8082                	ret

0000000080004a06 <sys_unlink>:
{
    80004a06:	7151                	addi	sp,sp,-240
    80004a08:	f586                	sd	ra,232(sp)
    80004a0a:	f1a2                	sd	s0,224(sp)
    80004a0c:	eda6                	sd	s1,216(sp)
    80004a0e:	e9ca                	sd	s2,208(sp)
    80004a10:	e5ce                	sd	s3,200(sp)
    80004a12:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004a14:	08000613          	li	a2,128
    80004a18:	f3040593          	addi	a1,s0,-208
    80004a1c:	4501                	li	a0,0
    80004a1e:	ffffd097          	auipc	ra,0xffffd
    80004a22:	720080e7          	jalr	1824(ra) # 8000213e <argstr>
    80004a26:	18054163          	bltz	a0,80004ba8 <sys_unlink+0x1a2>
  begin_op();
    80004a2a:	fffff097          	auipc	ra,0xfffff
    80004a2e:	c14080e7          	jalr	-1004(ra) # 8000363e <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004a32:	fb040593          	addi	a1,s0,-80
    80004a36:	f3040513          	addi	a0,s0,-208
    80004a3a:	fffff097          	auipc	ra,0xfffff
    80004a3e:	a06080e7          	jalr	-1530(ra) # 80003440 <nameiparent>
    80004a42:	84aa                	mv	s1,a0
    80004a44:	c979                	beqz	a0,80004b1a <sys_unlink+0x114>
  ilock(dp);
    80004a46:	ffffe097          	auipc	ra,0xffffe
    80004a4a:	226080e7          	jalr	550(ra) # 80002c6c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a4e:	00004597          	auipc	a1,0x4
    80004a52:	cf258593          	addi	a1,a1,-782 # 80008740 <syscalls+0x2b0>
    80004a56:	fb040513          	addi	a0,s0,-80
    80004a5a:	ffffe097          	auipc	ra,0xffffe
    80004a5e:	6dc080e7          	jalr	1756(ra) # 80003136 <namecmp>
    80004a62:	14050a63          	beqz	a0,80004bb6 <sys_unlink+0x1b0>
    80004a66:	00004597          	auipc	a1,0x4
    80004a6a:	ce258593          	addi	a1,a1,-798 # 80008748 <syscalls+0x2b8>
    80004a6e:	fb040513          	addi	a0,s0,-80
    80004a72:	ffffe097          	auipc	ra,0xffffe
    80004a76:	6c4080e7          	jalr	1732(ra) # 80003136 <namecmp>
    80004a7a:	12050e63          	beqz	a0,80004bb6 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004a7e:	f2c40613          	addi	a2,s0,-212
    80004a82:	fb040593          	addi	a1,s0,-80
    80004a86:	8526                	mv	a0,s1
    80004a88:	ffffe097          	auipc	ra,0xffffe
    80004a8c:	6c8080e7          	jalr	1736(ra) # 80003150 <dirlookup>
    80004a90:	892a                	mv	s2,a0
    80004a92:	12050263          	beqz	a0,80004bb6 <sys_unlink+0x1b0>
  ilock(ip);
    80004a96:	ffffe097          	auipc	ra,0xffffe
    80004a9a:	1d6080e7          	jalr	470(ra) # 80002c6c <ilock>
  if(ip->nlink < 1)
    80004a9e:	04a91783          	lh	a5,74(s2)
    80004aa2:	08f05263          	blez	a5,80004b26 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004aa6:	04491703          	lh	a4,68(s2)
    80004aaa:	4785                	li	a5,1
    80004aac:	08f70563          	beq	a4,a5,80004b36 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004ab0:	4641                	li	a2,16
    80004ab2:	4581                	li	a1,0
    80004ab4:	fc040513          	addi	a0,s0,-64
    80004ab8:	ffffb097          	auipc	ra,0xffffb
    80004abc:	75a080e7          	jalr	1882(ra) # 80000212 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ac0:	4741                	li	a4,16
    80004ac2:	f2c42683          	lw	a3,-212(s0)
    80004ac6:	fc040613          	addi	a2,s0,-64
    80004aca:	4581                	li	a1,0
    80004acc:	8526                	mv	a0,s1
    80004ace:	ffffe097          	auipc	ra,0xffffe
    80004ad2:	54a080e7          	jalr	1354(ra) # 80003018 <writei>
    80004ad6:	47c1                	li	a5,16
    80004ad8:	0af51563          	bne	a0,a5,80004b82 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004adc:	04491703          	lh	a4,68(s2)
    80004ae0:	4785                	li	a5,1
    80004ae2:	0af70863          	beq	a4,a5,80004b92 <sys_unlink+0x18c>
  iunlockput(dp);
    80004ae6:	8526                	mv	a0,s1
    80004ae8:	ffffe097          	auipc	ra,0xffffe
    80004aec:	3e6080e7          	jalr	998(ra) # 80002ece <iunlockput>
  ip->nlink--;
    80004af0:	04a95783          	lhu	a5,74(s2)
    80004af4:	37fd                	addiw	a5,a5,-1
    80004af6:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004afa:	854a                	mv	a0,s2
    80004afc:	ffffe097          	auipc	ra,0xffffe
    80004b00:	0a6080e7          	jalr	166(ra) # 80002ba2 <iupdate>
  iunlockput(ip);
    80004b04:	854a                	mv	a0,s2
    80004b06:	ffffe097          	auipc	ra,0xffffe
    80004b0a:	3c8080e7          	jalr	968(ra) # 80002ece <iunlockput>
  end_op();
    80004b0e:	fffff097          	auipc	ra,0xfffff
    80004b12:	bb0080e7          	jalr	-1104(ra) # 800036be <end_op>
  return 0;
    80004b16:	4501                	li	a0,0
    80004b18:	a84d                	j	80004bca <sys_unlink+0x1c4>
    end_op();
    80004b1a:	fffff097          	auipc	ra,0xfffff
    80004b1e:	ba4080e7          	jalr	-1116(ra) # 800036be <end_op>
    return -1;
    80004b22:	557d                	li	a0,-1
    80004b24:	a05d                	j	80004bca <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004b26:	00004517          	auipc	a0,0x4
    80004b2a:	c4a50513          	addi	a0,a0,-950 # 80008770 <syscalls+0x2e0>
    80004b2e:	00001097          	auipc	ra,0x1
    80004b32:	1ea080e7          	jalr	490(ra) # 80005d18 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b36:	04c92703          	lw	a4,76(s2)
    80004b3a:	02000793          	li	a5,32
    80004b3e:	f6e7f9e3          	bgeu	a5,a4,80004ab0 <sys_unlink+0xaa>
    80004b42:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b46:	4741                	li	a4,16
    80004b48:	86ce                	mv	a3,s3
    80004b4a:	f1840613          	addi	a2,s0,-232
    80004b4e:	4581                	li	a1,0
    80004b50:	854a                	mv	a0,s2
    80004b52:	ffffe097          	auipc	ra,0xffffe
    80004b56:	3ce080e7          	jalr	974(ra) # 80002f20 <readi>
    80004b5a:	47c1                	li	a5,16
    80004b5c:	00f51b63          	bne	a0,a5,80004b72 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004b60:	f1845783          	lhu	a5,-232(s0)
    80004b64:	e7a1                	bnez	a5,80004bac <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b66:	29c1                	addiw	s3,s3,16
    80004b68:	04c92783          	lw	a5,76(s2)
    80004b6c:	fcf9ede3          	bltu	s3,a5,80004b46 <sys_unlink+0x140>
    80004b70:	b781                	j	80004ab0 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004b72:	00004517          	auipc	a0,0x4
    80004b76:	c1650513          	addi	a0,a0,-1002 # 80008788 <syscalls+0x2f8>
    80004b7a:	00001097          	auipc	ra,0x1
    80004b7e:	19e080e7          	jalr	414(ra) # 80005d18 <panic>
    panic("unlink: writei");
    80004b82:	00004517          	auipc	a0,0x4
    80004b86:	c1e50513          	addi	a0,a0,-994 # 800087a0 <syscalls+0x310>
    80004b8a:	00001097          	auipc	ra,0x1
    80004b8e:	18e080e7          	jalr	398(ra) # 80005d18 <panic>
    dp->nlink--;
    80004b92:	04a4d783          	lhu	a5,74(s1)
    80004b96:	37fd                	addiw	a5,a5,-1
    80004b98:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b9c:	8526                	mv	a0,s1
    80004b9e:	ffffe097          	auipc	ra,0xffffe
    80004ba2:	004080e7          	jalr	4(ra) # 80002ba2 <iupdate>
    80004ba6:	b781                	j	80004ae6 <sys_unlink+0xe0>
    return -1;
    80004ba8:	557d                	li	a0,-1
    80004baa:	a005                	j	80004bca <sys_unlink+0x1c4>
    iunlockput(ip);
    80004bac:	854a                	mv	a0,s2
    80004bae:	ffffe097          	auipc	ra,0xffffe
    80004bb2:	320080e7          	jalr	800(ra) # 80002ece <iunlockput>
  iunlockput(dp);
    80004bb6:	8526                	mv	a0,s1
    80004bb8:	ffffe097          	auipc	ra,0xffffe
    80004bbc:	316080e7          	jalr	790(ra) # 80002ece <iunlockput>
  end_op();
    80004bc0:	fffff097          	auipc	ra,0xfffff
    80004bc4:	afe080e7          	jalr	-1282(ra) # 800036be <end_op>
  return -1;
    80004bc8:	557d                	li	a0,-1
}
    80004bca:	70ae                	ld	ra,232(sp)
    80004bcc:	740e                	ld	s0,224(sp)
    80004bce:	64ee                	ld	s1,216(sp)
    80004bd0:	694e                	ld	s2,208(sp)
    80004bd2:	69ae                	ld	s3,200(sp)
    80004bd4:	616d                	addi	sp,sp,240
    80004bd6:	8082                	ret

0000000080004bd8 <sys_open>:

uint64
sys_open(void)
{
    80004bd8:	7131                	addi	sp,sp,-192
    80004bda:	fd06                	sd	ra,184(sp)
    80004bdc:	f922                	sd	s0,176(sp)
    80004bde:	f526                	sd	s1,168(sp)
    80004be0:	f14a                	sd	s2,160(sp)
    80004be2:	ed4e                	sd	s3,152(sp)
    80004be4:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004be6:	08000613          	li	a2,128
    80004bea:	f5040593          	addi	a1,s0,-176
    80004bee:	4501                	li	a0,0
    80004bf0:	ffffd097          	auipc	ra,0xffffd
    80004bf4:	54e080e7          	jalr	1358(ra) # 8000213e <argstr>
    return -1;
    80004bf8:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004bfa:	0c054163          	bltz	a0,80004cbc <sys_open+0xe4>
    80004bfe:	f4c40593          	addi	a1,s0,-180
    80004c02:	4505                	li	a0,1
    80004c04:	ffffd097          	auipc	ra,0xffffd
    80004c08:	4f6080e7          	jalr	1270(ra) # 800020fa <argint>
    80004c0c:	0a054863          	bltz	a0,80004cbc <sys_open+0xe4>

  begin_op();
    80004c10:	fffff097          	auipc	ra,0xfffff
    80004c14:	a2e080e7          	jalr	-1490(ra) # 8000363e <begin_op>

  if(omode & O_CREATE){
    80004c18:	f4c42783          	lw	a5,-180(s0)
    80004c1c:	2007f793          	andi	a5,a5,512
    80004c20:	cbdd                	beqz	a5,80004cd6 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004c22:	4681                	li	a3,0
    80004c24:	4601                	li	a2,0
    80004c26:	4589                	li	a1,2
    80004c28:	f5040513          	addi	a0,s0,-176
    80004c2c:	00000097          	auipc	ra,0x0
    80004c30:	972080e7          	jalr	-1678(ra) # 8000459e <create>
    80004c34:	892a                	mv	s2,a0
    if(ip == 0){
    80004c36:	c959                	beqz	a0,80004ccc <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004c38:	04491703          	lh	a4,68(s2)
    80004c3c:	478d                	li	a5,3
    80004c3e:	00f71763          	bne	a4,a5,80004c4c <sys_open+0x74>
    80004c42:	04695703          	lhu	a4,70(s2)
    80004c46:	47a5                	li	a5,9
    80004c48:	0ce7ec63          	bltu	a5,a4,80004d20 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004c4c:	fffff097          	auipc	ra,0xfffff
    80004c50:	e02080e7          	jalr	-510(ra) # 80003a4e <filealloc>
    80004c54:	89aa                	mv	s3,a0
    80004c56:	10050263          	beqz	a0,80004d5a <sys_open+0x182>
    80004c5a:	00000097          	auipc	ra,0x0
    80004c5e:	902080e7          	jalr	-1790(ra) # 8000455c <fdalloc>
    80004c62:	84aa                	mv	s1,a0
    80004c64:	0e054663          	bltz	a0,80004d50 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004c68:	04491703          	lh	a4,68(s2)
    80004c6c:	478d                	li	a5,3
    80004c6e:	0cf70463          	beq	a4,a5,80004d36 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004c72:	4789                	li	a5,2
    80004c74:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004c78:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004c7c:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004c80:	f4c42783          	lw	a5,-180(s0)
    80004c84:	0017c713          	xori	a4,a5,1
    80004c88:	8b05                	andi	a4,a4,1
    80004c8a:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004c8e:	0037f713          	andi	a4,a5,3
    80004c92:	00e03733          	snez	a4,a4
    80004c96:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004c9a:	4007f793          	andi	a5,a5,1024
    80004c9e:	c791                	beqz	a5,80004caa <sys_open+0xd2>
    80004ca0:	04491703          	lh	a4,68(s2)
    80004ca4:	4789                	li	a5,2
    80004ca6:	08f70f63          	beq	a4,a5,80004d44 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004caa:	854a                	mv	a0,s2
    80004cac:	ffffe097          	auipc	ra,0xffffe
    80004cb0:	082080e7          	jalr	130(ra) # 80002d2e <iunlock>
  end_op();
    80004cb4:	fffff097          	auipc	ra,0xfffff
    80004cb8:	a0a080e7          	jalr	-1526(ra) # 800036be <end_op>

  return fd;
}
    80004cbc:	8526                	mv	a0,s1
    80004cbe:	70ea                	ld	ra,184(sp)
    80004cc0:	744a                	ld	s0,176(sp)
    80004cc2:	74aa                	ld	s1,168(sp)
    80004cc4:	790a                	ld	s2,160(sp)
    80004cc6:	69ea                	ld	s3,152(sp)
    80004cc8:	6129                	addi	sp,sp,192
    80004cca:	8082                	ret
      end_op();
    80004ccc:	fffff097          	auipc	ra,0xfffff
    80004cd0:	9f2080e7          	jalr	-1550(ra) # 800036be <end_op>
      return -1;
    80004cd4:	b7e5                	j	80004cbc <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004cd6:	f5040513          	addi	a0,s0,-176
    80004cda:	ffffe097          	auipc	ra,0xffffe
    80004cde:	748080e7          	jalr	1864(ra) # 80003422 <namei>
    80004ce2:	892a                	mv	s2,a0
    80004ce4:	c905                	beqz	a0,80004d14 <sys_open+0x13c>
    ilock(ip);
    80004ce6:	ffffe097          	auipc	ra,0xffffe
    80004cea:	f86080e7          	jalr	-122(ra) # 80002c6c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004cee:	04491703          	lh	a4,68(s2)
    80004cf2:	4785                	li	a5,1
    80004cf4:	f4f712e3          	bne	a4,a5,80004c38 <sys_open+0x60>
    80004cf8:	f4c42783          	lw	a5,-180(s0)
    80004cfc:	dba1                	beqz	a5,80004c4c <sys_open+0x74>
      iunlockput(ip);
    80004cfe:	854a                	mv	a0,s2
    80004d00:	ffffe097          	auipc	ra,0xffffe
    80004d04:	1ce080e7          	jalr	462(ra) # 80002ece <iunlockput>
      end_op();
    80004d08:	fffff097          	auipc	ra,0xfffff
    80004d0c:	9b6080e7          	jalr	-1610(ra) # 800036be <end_op>
      return -1;
    80004d10:	54fd                	li	s1,-1
    80004d12:	b76d                	j	80004cbc <sys_open+0xe4>
      end_op();
    80004d14:	fffff097          	auipc	ra,0xfffff
    80004d18:	9aa080e7          	jalr	-1622(ra) # 800036be <end_op>
      return -1;
    80004d1c:	54fd                	li	s1,-1
    80004d1e:	bf79                	j	80004cbc <sys_open+0xe4>
    iunlockput(ip);
    80004d20:	854a                	mv	a0,s2
    80004d22:	ffffe097          	auipc	ra,0xffffe
    80004d26:	1ac080e7          	jalr	428(ra) # 80002ece <iunlockput>
    end_op();
    80004d2a:	fffff097          	auipc	ra,0xfffff
    80004d2e:	994080e7          	jalr	-1644(ra) # 800036be <end_op>
    return -1;
    80004d32:	54fd                	li	s1,-1
    80004d34:	b761                	j	80004cbc <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004d36:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004d3a:	04691783          	lh	a5,70(s2)
    80004d3e:	02f99223          	sh	a5,36(s3)
    80004d42:	bf2d                	j	80004c7c <sys_open+0xa4>
    itrunc(ip);
    80004d44:	854a                	mv	a0,s2
    80004d46:	ffffe097          	auipc	ra,0xffffe
    80004d4a:	034080e7          	jalr	52(ra) # 80002d7a <itrunc>
    80004d4e:	bfb1                	j	80004caa <sys_open+0xd2>
      fileclose(f);
    80004d50:	854e                	mv	a0,s3
    80004d52:	fffff097          	auipc	ra,0xfffff
    80004d56:	db8080e7          	jalr	-584(ra) # 80003b0a <fileclose>
    iunlockput(ip);
    80004d5a:	854a                	mv	a0,s2
    80004d5c:	ffffe097          	auipc	ra,0xffffe
    80004d60:	172080e7          	jalr	370(ra) # 80002ece <iunlockput>
    end_op();
    80004d64:	fffff097          	auipc	ra,0xfffff
    80004d68:	95a080e7          	jalr	-1702(ra) # 800036be <end_op>
    return -1;
    80004d6c:	54fd                	li	s1,-1
    80004d6e:	b7b9                	j	80004cbc <sys_open+0xe4>

0000000080004d70 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004d70:	7175                	addi	sp,sp,-144
    80004d72:	e506                	sd	ra,136(sp)
    80004d74:	e122                	sd	s0,128(sp)
    80004d76:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004d78:	fffff097          	auipc	ra,0xfffff
    80004d7c:	8c6080e7          	jalr	-1850(ra) # 8000363e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004d80:	08000613          	li	a2,128
    80004d84:	f7040593          	addi	a1,s0,-144
    80004d88:	4501                	li	a0,0
    80004d8a:	ffffd097          	auipc	ra,0xffffd
    80004d8e:	3b4080e7          	jalr	948(ra) # 8000213e <argstr>
    80004d92:	02054963          	bltz	a0,80004dc4 <sys_mkdir+0x54>
    80004d96:	4681                	li	a3,0
    80004d98:	4601                	li	a2,0
    80004d9a:	4585                	li	a1,1
    80004d9c:	f7040513          	addi	a0,s0,-144
    80004da0:	fffff097          	auipc	ra,0xfffff
    80004da4:	7fe080e7          	jalr	2046(ra) # 8000459e <create>
    80004da8:	cd11                	beqz	a0,80004dc4 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004daa:	ffffe097          	auipc	ra,0xffffe
    80004dae:	124080e7          	jalr	292(ra) # 80002ece <iunlockput>
  end_op();
    80004db2:	fffff097          	auipc	ra,0xfffff
    80004db6:	90c080e7          	jalr	-1780(ra) # 800036be <end_op>
  return 0;
    80004dba:	4501                	li	a0,0
}
    80004dbc:	60aa                	ld	ra,136(sp)
    80004dbe:	640a                	ld	s0,128(sp)
    80004dc0:	6149                	addi	sp,sp,144
    80004dc2:	8082                	ret
    end_op();
    80004dc4:	fffff097          	auipc	ra,0xfffff
    80004dc8:	8fa080e7          	jalr	-1798(ra) # 800036be <end_op>
    return -1;
    80004dcc:	557d                	li	a0,-1
    80004dce:	b7fd                	j	80004dbc <sys_mkdir+0x4c>

0000000080004dd0 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004dd0:	7135                	addi	sp,sp,-160
    80004dd2:	ed06                	sd	ra,152(sp)
    80004dd4:	e922                	sd	s0,144(sp)
    80004dd6:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004dd8:	fffff097          	auipc	ra,0xfffff
    80004ddc:	866080e7          	jalr	-1946(ra) # 8000363e <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004de0:	08000613          	li	a2,128
    80004de4:	f7040593          	addi	a1,s0,-144
    80004de8:	4501                	li	a0,0
    80004dea:	ffffd097          	auipc	ra,0xffffd
    80004dee:	354080e7          	jalr	852(ra) # 8000213e <argstr>
    80004df2:	04054a63          	bltz	a0,80004e46 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004df6:	f6c40593          	addi	a1,s0,-148
    80004dfa:	4505                	li	a0,1
    80004dfc:	ffffd097          	auipc	ra,0xffffd
    80004e00:	2fe080e7          	jalr	766(ra) # 800020fa <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e04:	04054163          	bltz	a0,80004e46 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004e08:	f6840593          	addi	a1,s0,-152
    80004e0c:	4509                	li	a0,2
    80004e0e:	ffffd097          	auipc	ra,0xffffd
    80004e12:	2ec080e7          	jalr	748(ra) # 800020fa <argint>
     argint(1, &major) < 0 ||
    80004e16:	02054863          	bltz	a0,80004e46 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004e1a:	f6841683          	lh	a3,-152(s0)
    80004e1e:	f6c41603          	lh	a2,-148(s0)
    80004e22:	458d                	li	a1,3
    80004e24:	f7040513          	addi	a0,s0,-144
    80004e28:	fffff097          	auipc	ra,0xfffff
    80004e2c:	776080e7          	jalr	1910(ra) # 8000459e <create>
     argint(2, &minor) < 0 ||
    80004e30:	c919                	beqz	a0,80004e46 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e32:	ffffe097          	auipc	ra,0xffffe
    80004e36:	09c080e7          	jalr	156(ra) # 80002ece <iunlockput>
  end_op();
    80004e3a:	fffff097          	auipc	ra,0xfffff
    80004e3e:	884080e7          	jalr	-1916(ra) # 800036be <end_op>
  return 0;
    80004e42:	4501                	li	a0,0
    80004e44:	a031                	j	80004e50 <sys_mknod+0x80>
    end_op();
    80004e46:	fffff097          	auipc	ra,0xfffff
    80004e4a:	878080e7          	jalr	-1928(ra) # 800036be <end_op>
    return -1;
    80004e4e:	557d                	li	a0,-1
}
    80004e50:	60ea                	ld	ra,152(sp)
    80004e52:	644a                	ld	s0,144(sp)
    80004e54:	610d                	addi	sp,sp,160
    80004e56:	8082                	ret

0000000080004e58 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004e58:	7135                	addi	sp,sp,-160
    80004e5a:	ed06                	sd	ra,152(sp)
    80004e5c:	e922                	sd	s0,144(sp)
    80004e5e:	e526                	sd	s1,136(sp)
    80004e60:	e14a                	sd	s2,128(sp)
    80004e62:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004e64:	ffffc097          	auipc	ra,0xffffc
    80004e68:	0be080e7          	jalr	190(ra) # 80000f22 <myproc>
    80004e6c:	892a                	mv	s2,a0
  
  begin_op();
    80004e6e:	ffffe097          	auipc	ra,0xffffe
    80004e72:	7d0080e7          	jalr	2000(ra) # 8000363e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004e76:	08000613          	li	a2,128
    80004e7a:	f6040593          	addi	a1,s0,-160
    80004e7e:	4501                	li	a0,0
    80004e80:	ffffd097          	auipc	ra,0xffffd
    80004e84:	2be080e7          	jalr	702(ra) # 8000213e <argstr>
    80004e88:	04054b63          	bltz	a0,80004ede <sys_chdir+0x86>
    80004e8c:	f6040513          	addi	a0,s0,-160
    80004e90:	ffffe097          	auipc	ra,0xffffe
    80004e94:	592080e7          	jalr	1426(ra) # 80003422 <namei>
    80004e98:	84aa                	mv	s1,a0
    80004e9a:	c131                	beqz	a0,80004ede <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004e9c:	ffffe097          	auipc	ra,0xffffe
    80004ea0:	dd0080e7          	jalr	-560(ra) # 80002c6c <ilock>
  if(ip->type != T_DIR){
    80004ea4:	04449703          	lh	a4,68(s1)
    80004ea8:	4785                	li	a5,1
    80004eaa:	04f71063          	bne	a4,a5,80004eea <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004eae:	8526                	mv	a0,s1
    80004eb0:	ffffe097          	auipc	ra,0xffffe
    80004eb4:	e7e080e7          	jalr	-386(ra) # 80002d2e <iunlock>
  iput(p->cwd);
    80004eb8:	15093503          	ld	a0,336(s2)
    80004ebc:	ffffe097          	auipc	ra,0xffffe
    80004ec0:	f6a080e7          	jalr	-150(ra) # 80002e26 <iput>
  end_op();
    80004ec4:	ffffe097          	auipc	ra,0xffffe
    80004ec8:	7fa080e7          	jalr	2042(ra) # 800036be <end_op>
  p->cwd = ip;
    80004ecc:	14993823          	sd	s1,336(s2)
  return 0;
    80004ed0:	4501                	li	a0,0
}
    80004ed2:	60ea                	ld	ra,152(sp)
    80004ed4:	644a                	ld	s0,144(sp)
    80004ed6:	64aa                	ld	s1,136(sp)
    80004ed8:	690a                	ld	s2,128(sp)
    80004eda:	610d                	addi	sp,sp,160
    80004edc:	8082                	ret
    end_op();
    80004ede:	ffffe097          	auipc	ra,0xffffe
    80004ee2:	7e0080e7          	jalr	2016(ra) # 800036be <end_op>
    return -1;
    80004ee6:	557d                	li	a0,-1
    80004ee8:	b7ed                	j	80004ed2 <sys_chdir+0x7a>
    iunlockput(ip);
    80004eea:	8526                	mv	a0,s1
    80004eec:	ffffe097          	auipc	ra,0xffffe
    80004ef0:	fe2080e7          	jalr	-30(ra) # 80002ece <iunlockput>
    end_op();
    80004ef4:	ffffe097          	auipc	ra,0xffffe
    80004ef8:	7ca080e7          	jalr	1994(ra) # 800036be <end_op>
    return -1;
    80004efc:	557d                	li	a0,-1
    80004efe:	bfd1                	j	80004ed2 <sys_chdir+0x7a>

0000000080004f00 <sys_exec>:

uint64
sys_exec(void)
{
    80004f00:	7145                	addi	sp,sp,-464
    80004f02:	e786                	sd	ra,456(sp)
    80004f04:	e3a2                	sd	s0,448(sp)
    80004f06:	ff26                	sd	s1,440(sp)
    80004f08:	fb4a                	sd	s2,432(sp)
    80004f0a:	f74e                	sd	s3,424(sp)
    80004f0c:	f352                	sd	s4,416(sp)
    80004f0e:	ef56                	sd	s5,408(sp)
    80004f10:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f12:	08000613          	li	a2,128
    80004f16:	f4040593          	addi	a1,s0,-192
    80004f1a:	4501                	li	a0,0
    80004f1c:	ffffd097          	auipc	ra,0xffffd
    80004f20:	222080e7          	jalr	546(ra) # 8000213e <argstr>
    return -1;
    80004f24:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f26:	0c054a63          	bltz	a0,80004ffa <sys_exec+0xfa>
    80004f2a:	e3840593          	addi	a1,s0,-456
    80004f2e:	4505                	li	a0,1
    80004f30:	ffffd097          	auipc	ra,0xffffd
    80004f34:	1ec080e7          	jalr	492(ra) # 8000211c <argaddr>
    80004f38:	0c054163          	bltz	a0,80004ffa <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004f3c:	10000613          	li	a2,256
    80004f40:	4581                	li	a1,0
    80004f42:	e4040513          	addi	a0,s0,-448
    80004f46:	ffffb097          	auipc	ra,0xffffb
    80004f4a:	2cc080e7          	jalr	716(ra) # 80000212 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004f4e:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004f52:	89a6                	mv	s3,s1
    80004f54:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004f56:	02000a13          	li	s4,32
    80004f5a:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004f5e:	00391513          	slli	a0,s2,0x3
    80004f62:	e3040593          	addi	a1,s0,-464
    80004f66:	e3843783          	ld	a5,-456(s0)
    80004f6a:	953e                	add	a0,a0,a5
    80004f6c:	ffffd097          	auipc	ra,0xffffd
    80004f70:	0f4080e7          	jalr	244(ra) # 80002060 <fetchaddr>
    80004f74:	02054a63          	bltz	a0,80004fa8 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004f78:	e3043783          	ld	a5,-464(s0)
    80004f7c:	c3b9                	beqz	a5,80004fc2 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004f7e:	ffffb097          	auipc	ra,0xffffb
    80004f82:	1fe080e7          	jalr	510(ra) # 8000017c <kalloc>
    80004f86:	85aa                	mv	a1,a0
    80004f88:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004f8c:	cd11                	beqz	a0,80004fa8 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004f8e:	6605                	lui	a2,0x1
    80004f90:	e3043503          	ld	a0,-464(s0)
    80004f94:	ffffd097          	auipc	ra,0xffffd
    80004f98:	11e080e7          	jalr	286(ra) # 800020b2 <fetchstr>
    80004f9c:	00054663          	bltz	a0,80004fa8 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004fa0:	0905                	addi	s2,s2,1
    80004fa2:	09a1                	addi	s3,s3,8
    80004fa4:	fb491be3          	bne	s2,s4,80004f5a <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fa8:	10048913          	addi	s2,s1,256
    80004fac:	6088                	ld	a0,0(s1)
    80004fae:	c529                	beqz	a0,80004ff8 <sys_exec+0xf8>
    kfree(argv[i]);
    80004fb0:	ffffb097          	auipc	ra,0xffffb
    80004fb4:	06c080e7          	jalr	108(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fb8:	04a1                	addi	s1,s1,8
    80004fba:	ff2499e3          	bne	s1,s2,80004fac <sys_exec+0xac>
  return -1;
    80004fbe:	597d                	li	s2,-1
    80004fc0:	a82d                	j	80004ffa <sys_exec+0xfa>
      argv[i] = 0;
    80004fc2:	0a8e                	slli	s5,s5,0x3
    80004fc4:	fc040793          	addi	a5,s0,-64
    80004fc8:	9abe                	add	s5,s5,a5
    80004fca:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004fce:	e4040593          	addi	a1,s0,-448
    80004fd2:	f4040513          	addi	a0,s0,-192
    80004fd6:	fffff097          	auipc	ra,0xfffff
    80004fda:	194080e7          	jalr	404(ra) # 8000416a <exec>
    80004fde:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fe0:	10048993          	addi	s3,s1,256
    80004fe4:	6088                	ld	a0,0(s1)
    80004fe6:	c911                	beqz	a0,80004ffa <sys_exec+0xfa>
    kfree(argv[i]);
    80004fe8:	ffffb097          	auipc	ra,0xffffb
    80004fec:	034080e7          	jalr	52(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ff0:	04a1                	addi	s1,s1,8
    80004ff2:	ff3499e3          	bne	s1,s3,80004fe4 <sys_exec+0xe4>
    80004ff6:	a011                	j	80004ffa <sys_exec+0xfa>
  return -1;
    80004ff8:	597d                	li	s2,-1
}
    80004ffa:	854a                	mv	a0,s2
    80004ffc:	60be                	ld	ra,456(sp)
    80004ffe:	641e                	ld	s0,448(sp)
    80005000:	74fa                	ld	s1,440(sp)
    80005002:	795a                	ld	s2,432(sp)
    80005004:	79ba                	ld	s3,424(sp)
    80005006:	7a1a                	ld	s4,416(sp)
    80005008:	6afa                	ld	s5,408(sp)
    8000500a:	6179                	addi	sp,sp,464
    8000500c:	8082                	ret

000000008000500e <sys_pipe>:

uint64
sys_pipe(void)
{
    8000500e:	7139                	addi	sp,sp,-64
    80005010:	fc06                	sd	ra,56(sp)
    80005012:	f822                	sd	s0,48(sp)
    80005014:	f426                	sd	s1,40(sp)
    80005016:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005018:	ffffc097          	auipc	ra,0xffffc
    8000501c:	f0a080e7          	jalr	-246(ra) # 80000f22 <myproc>
    80005020:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005022:	fd840593          	addi	a1,s0,-40
    80005026:	4501                	li	a0,0
    80005028:	ffffd097          	auipc	ra,0xffffd
    8000502c:	0f4080e7          	jalr	244(ra) # 8000211c <argaddr>
    return -1;
    80005030:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005032:	0e054063          	bltz	a0,80005112 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005036:	fc840593          	addi	a1,s0,-56
    8000503a:	fd040513          	addi	a0,s0,-48
    8000503e:	fffff097          	auipc	ra,0xfffff
    80005042:	dfc080e7          	jalr	-516(ra) # 80003e3a <pipealloc>
    return -1;
    80005046:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005048:	0c054563          	bltz	a0,80005112 <sys_pipe+0x104>
  fd0 = -1;
    8000504c:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005050:	fd043503          	ld	a0,-48(s0)
    80005054:	fffff097          	auipc	ra,0xfffff
    80005058:	508080e7          	jalr	1288(ra) # 8000455c <fdalloc>
    8000505c:	fca42223          	sw	a0,-60(s0)
    80005060:	08054c63          	bltz	a0,800050f8 <sys_pipe+0xea>
    80005064:	fc843503          	ld	a0,-56(s0)
    80005068:	fffff097          	auipc	ra,0xfffff
    8000506c:	4f4080e7          	jalr	1268(ra) # 8000455c <fdalloc>
    80005070:	fca42023          	sw	a0,-64(s0)
    80005074:	06054863          	bltz	a0,800050e4 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005078:	4691                	li	a3,4
    8000507a:	fc440613          	addi	a2,s0,-60
    8000507e:	fd843583          	ld	a1,-40(s0)
    80005082:	68a8                	ld	a0,80(s1)
    80005084:	ffffc097          	auipc	ra,0xffffc
    80005088:	b60080e7          	jalr	-1184(ra) # 80000be4 <copyout>
    8000508c:	02054063          	bltz	a0,800050ac <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005090:	4691                	li	a3,4
    80005092:	fc040613          	addi	a2,s0,-64
    80005096:	fd843583          	ld	a1,-40(s0)
    8000509a:	0591                	addi	a1,a1,4
    8000509c:	68a8                	ld	a0,80(s1)
    8000509e:	ffffc097          	auipc	ra,0xffffc
    800050a2:	b46080e7          	jalr	-1210(ra) # 80000be4 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800050a6:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050a8:	06055563          	bgez	a0,80005112 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    800050ac:	fc442783          	lw	a5,-60(s0)
    800050b0:	07e9                	addi	a5,a5,26
    800050b2:	078e                	slli	a5,a5,0x3
    800050b4:	97a6                	add	a5,a5,s1
    800050b6:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800050ba:	fc042503          	lw	a0,-64(s0)
    800050be:	0569                	addi	a0,a0,26
    800050c0:	050e                	slli	a0,a0,0x3
    800050c2:	9526                	add	a0,a0,s1
    800050c4:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    800050c8:	fd043503          	ld	a0,-48(s0)
    800050cc:	fffff097          	auipc	ra,0xfffff
    800050d0:	a3e080e7          	jalr	-1474(ra) # 80003b0a <fileclose>
    fileclose(wf);
    800050d4:	fc843503          	ld	a0,-56(s0)
    800050d8:	fffff097          	auipc	ra,0xfffff
    800050dc:	a32080e7          	jalr	-1486(ra) # 80003b0a <fileclose>
    return -1;
    800050e0:	57fd                	li	a5,-1
    800050e2:	a805                	j	80005112 <sys_pipe+0x104>
    if(fd0 >= 0)
    800050e4:	fc442783          	lw	a5,-60(s0)
    800050e8:	0007c863          	bltz	a5,800050f8 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    800050ec:	01a78513          	addi	a0,a5,26
    800050f0:	050e                	slli	a0,a0,0x3
    800050f2:	9526                	add	a0,a0,s1
    800050f4:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    800050f8:	fd043503          	ld	a0,-48(s0)
    800050fc:	fffff097          	auipc	ra,0xfffff
    80005100:	a0e080e7          	jalr	-1522(ra) # 80003b0a <fileclose>
    fileclose(wf);
    80005104:	fc843503          	ld	a0,-56(s0)
    80005108:	fffff097          	auipc	ra,0xfffff
    8000510c:	a02080e7          	jalr	-1534(ra) # 80003b0a <fileclose>
    return -1;
    80005110:	57fd                	li	a5,-1
}
    80005112:	853e                	mv	a0,a5
    80005114:	70e2                	ld	ra,56(sp)
    80005116:	7442                	ld	s0,48(sp)
    80005118:	74a2                	ld	s1,40(sp)
    8000511a:	6121                	addi	sp,sp,64
    8000511c:	8082                	ret
	...

0000000080005120 <kernelvec>:
    80005120:	7111                	addi	sp,sp,-256
    80005122:	e006                	sd	ra,0(sp)
    80005124:	e40a                	sd	sp,8(sp)
    80005126:	e80e                	sd	gp,16(sp)
    80005128:	ec12                	sd	tp,24(sp)
    8000512a:	f016                	sd	t0,32(sp)
    8000512c:	f41a                	sd	t1,40(sp)
    8000512e:	f81e                	sd	t2,48(sp)
    80005130:	fc22                	sd	s0,56(sp)
    80005132:	e0a6                	sd	s1,64(sp)
    80005134:	e4aa                	sd	a0,72(sp)
    80005136:	e8ae                	sd	a1,80(sp)
    80005138:	ecb2                	sd	a2,88(sp)
    8000513a:	f0b6                	sd	a3,96(sp)
    8000513c:	f4ba                	sd	a4,104(sp)
    8000513e:	f8be                	sd	a5,112(sp)
    80005140:	fcc2                	sd	a6,120(sp)
    80005142:	e146                	sd	a7,128(sp)
    80005144:	e54a                	sd	s2,136(sp)
    80005146:	e94e                	sd	s3,144(sp)
    80005148:	ed52                	sd	s4,152(sp)
    8000514a:	f156                	sd	s5,160(sp)
    8000514c:	f55a                	sd	s6,168(sp)
    8000514e:	f95e                	sd	s7,176(sp)
    80005150:	fd62                	sd	s8,184(sp)
    80005152:	e1e6                	sd	s9,192(sp)
    80005154:	e5ea                	sd	s10,200(sp)
    80005156:	e9ee                	sd	s11,208(sp)
    80005158:	edf2                	sd	t3,216(sp)
    8000515a:	f1f6                	sd	t4,224(sp)
    8000515c:	f5fa                	sd	t5,232(sp)
    8000515e:	f9fe                	sd	t6,240(sp)
    80005160:	dcdfc0ef          	jal	ra,80001f2c <kerneltrap>
    80005164:	6082                	ld	ra,0(sp)
    80005166:	6122                	ld	sp,8(sp)
    80005168:	61c2                	ld	gp,16(sp)
    8000516a:	7282                	ld	t0,32(sp)
    8000516c:	7322                	ld	t1,40(sp)
    8000516e:	73c2                	ld	t2,48(sp)
    80005170:	7462                	ld	s0,56(sp)
    80005172:	6486                	ld	s1,64(sp)
    80005174:	6526                	ld	a0,72(sp)
    80005176:	65c6                	ld	a1,80(sp)
    80005178:	6666                	ld	a2,88(sp)
    8000517a:	7686                	ld	a3,96(sp)
    8000517c:	7726                	ld	a4,104(sp)
    8000517e:	77c6                	ld	a5,112(sp)
    80005180:	7866                	ld	a6,120(sp)
    80005182:	688a                	ld	a7,128(sp)
    80005184:	692a                	ld	s2,136(sp)
    80005186:	69ca                	ld	s3,144(sp)
    80005188:	6a6a                	ld	s4,152(sp)
    8000518a:	7a8a                	ld	s5,160(sp)
    8000518c:	7b2a                	ld	s6,168(sp)
    8000518e:	7bca                	ld	s7,176(sp)
    80005190:	7c6a                	ld	s8,184(sp)
    80005192:	6c8e                	ld	s9,192(sp)
    80005194:	6d2e                	ld	s10,200(sp)
    80005196:	6dce                	ld	s11,208(sp)
    80005198:	6e6e                	ld	t3,216(sp)
    8000519a:	7e8e                	ld	t4,224(sp)
    8000519c:	7f2e                	ld	t5,232(sp)
    8000519e:	7fce                	ld	t6,240(sp)
    800051a0:	6111                	addi	sp,sp,256
    800051a2:	10200073          	sret
    800051a6:	00000013          	nop
    800051aa:	00000013          	nop
    800051ae:	0001                	nop

00000000800051b0 <timervec>:
    800051b0:	34051573          	csrrw	a0,mscratch,a0
    800051b4:	e10c                	sd	a1,0(a0)
    800051b6:	e510                	sd	a2,8(a0)
    800051b8:	e914                	sd	a3,16(a0)
    800051ba:	6d0c                	ld	a1,24(a0)
    800051bc:	7110                	ld	a2,32(a0)
    800051be:	6194                	ld	a3,0(a1)
    800051c0:	96b2                	add	a3,a3,a2
    800051c2:	e194                	sd	a3,0(a1)
    800051c4:	4589                	li	a1,2
    800051c6:	14459073          	csrw	sip,a1
    800051ca:	6914                	ld	a3,16(a0)
    800051cc:	6510                	ld	a2,8(a0)
    800051ce:	610c                	ld	a1,0(a0)
    800051d0:	34051573          	csrrw	a0,mscratch,a0
    800051d4:	30200073          	mret
	...

00000000800051da <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800051da:	1141                	addi	sp,sp,-16
    800051dc:	e422                	sd	s0,8(sp)
    800051de:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800051e0:	0c0007b7          	lui	a5,0xc000
    800051e4:	4705                	li	a4,1
    800051e6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800051e8:	c3d8                	sw	a4,4(a5)
}
    800051ea:	6422                	ld	s0,8(sp)
    800051ec:	0141                	addi	sp,sp,16
    800051ee:	8082                	ret

00000000800051f0 <plicinithart>:

void
plicinithart(void)
{
    800051f0:	1141                	addi	sp,sp,-16
    800051f2:	e406                	sd	ra,8(sp)
    800051f4:	e022                	sd	s0,0(sp)
    800051f6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051f8:	ffffc097          	auipc	ra,0xffffc
    800051fc:	cfe080e7          	jalr	-770(ra) # 80000ef6 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005200:	0085171b          	slliw	a4,a0,0x8
    80005204:	0c0027b7          	lui	a5,0xc002
    80005208:	97ba                	add	a5,a5,a4
    8000520a:	40200713          	li	a4,1026
    8000520e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005212:	00d5151b          	slliw	a0,a0,0xd
    80005216:	0c2017b7          	lui	a5,0xc201
    8000521a:	953e                	add	a0,a0,a5
    8000521c:	00052023          	sw	zero,0(a0)
}
    80005220:	60a2                	ld	ra,8(sp)
    80005222:	6402                	ld	s0,0(sp)
    80005224:	0141                	addi	sp,sp,16
    80005226:	8082                	ret

0000000080005228 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005228:	1141                	addi	sp,sp,-16
    8000522a:	e406                	sd	ra,8(sp)
    8000522c:	e022                	sd	s0,0(sp)
    8000522e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005230:	ffffc097          	auipc	ra,0xffffc
    80005234:	cc6080e7          	jalr	-826(ra) # 80000ef6 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005238:	00d5179b          	slliw	a5,a0,0xd
    8000523c:	0c201537          	lui	a0,0xc201
    80005240:	953e                	add	a0,a0,a5
  return irq;
}
    80005242:	4148                	lw	a0,4(a0)
    80005244:	60a2                	ld	ra,8(sp)
    80005246:	6402                	ld	s0,0(sp)
    80005248:	0141                	addi	sp,sp,16
    8000524a:	8082                	ret

000000008000524c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000524c:	1101                	addi	sp,sp,-32
    8000524e:	ec06                	sd	ra,24(sp)
    80005250:	e822                	sd	s0,16(sp)
    80005252:	e426                	sd	s1,8(sp)
    80005254:	1000                	addi	s0,sp,32
    80005256:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005258:	ffffc097          	auipc	ra,0xffffc
    8000525c:	c9e080e7          	jalr	-866(ra) # 80000ef6 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005260:	00d5151b          	slliw	a0,a0,0xd
    80005264:	0c2017b7          	lui	a5,0xc201
    80005268:	97aa                	add	a5,a5,a0
    8000526a:	c3c4                	sw	s1,4(a5)
}
    8000526c:	60e2                	ld	ra,24(sp)
    8000526e:	6442                	ld	s0,16(sp)
    80005270:	64a2                	ld	s1,8(sp)
    80005272:	6105                	addi	sp,sp,32
    80005274:	8082                	ret

0000000080005276 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005276:	1141                	addi	sp,sp,-16
    80005278:	e406                	sd	ra,8(sp)
    8000527a:	e022                	sd	s0,0(sp)
    8000527c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000527e:	479d                	li	a5,7
    80005280:	06a7c963          	blt	a5,a0,800052f2 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80005284:	00036797          	auipc	a5,0x36
    80005288:	d7c78793          	addi	a5,a5,-644 # 8003b000 <disk>
    8000528c:	00a78733          	add	a4,a5,a0
    80005290:	6789                	lui	a5,0x2
    80005292:	97ba                	add	a5,a5,a4
    80005294:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005298:	e7ad                	bnez	a5,80005302 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000529a:	00451793          	slli	a5,a0,0x4
    8000529e:	00038717          	auipc	a4,0x38
    800052a2:	d6270713          	addi	a4,a4,-670 # 8003d000 <disk+0x2000>
    800052a6:	6314                	ld	a3,0(a4)
    800052a8:	96be                	add	a3,a3,a5
    800052aa:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800052ae:	6314                	ld	a3,0(a4)
    800052b0:	96be                	add	a3,a3,a5
    800052b2:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800052b6:	6314                	ld	a3,0(a4)
    800052b8:	96be                	add	a3,a3,a5
    800052ba:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800052be:	6318                	ld	a4,0(a4)
    800052c0:	97ba                	add	a5,a5,a4
    800052c2:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800052c6:	00036797          	auipc	a5,0x36
    800052ca:	d3a78793          	addi	a5,a5,-710 # 8003b000 <disk>
    800052ce:	97aa                	add	a5,a5,a0
    800052d0:	6509                	lui	a0,0x2
    800052d2:	953e                	add	a0,a0,a5
    800052d4:	4785                	li	a5,1
    800052d6:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800052da:	00038517          	auipc	a0,0x38
    800052de:	d3e50513          	addi	a0,a0,-706 # 8003d018 <disk+0x2018>
    800052e2:	ffffc097          	auipc	ra,0xffffc
    800052e6:	488080e7          	jalr	1160(ra) # 8000176a <wakeup>
}
    800052ea:	60a2                	ld	ra,8(sp)
    800052ec:	6402                	ld	s0,0(sp)
    800052ee:	0141                	addi	sp,sp,16
    800052f0:	8082                	ret
    panic("free_desc 1");
    800052f2:	00003517          	auipc	a0,0x3
    800052f6:	4be50513          	addi	a0,a0,1214 # 800087b0 <syscalls+0x320>
    800052fa:	00001097          	auipc	ra,0x1
    800052fe:	a1e080e7          	jalr	-1506(ra) # 80005d18 <panic>
    panic("free_desc 2");
    80005302:	00003517          	auipc	a0,0x3
    80005306:	4be50513          	addi	a0,a0,1214 # 800087c0 <syscalls+0x330>
    8000530a:	00001097          	auipc	ra,0x1
    8000530e:	a0e080e7          	jalr	-1522(ra) # 80005d18 <panic>

0000000080005312 <virtio_disk_init>:
{
    80005312:	1101                	addi	sp,sp,-32
    80005314:	ec06                	sd	ra,24(sp)
    80005316:	e822                	sd	s0,16(sp)
    80005318:	e426                	sd	s1,8(sp)
    8000531a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000531c:	00003597          	auipc	a1,0x3
    80005320:	4b458593          	addi	a1,a1,1204 # 800087d0 <syscalls+0x340>
    80005324:	00038517          	auipc	a0,0x38
    80005328:	e0450513          	addi	a0,a0,-508 # 8003d128 <disk+0x2128>
    8000532c:	00001097          	auipc	ra,0x1
    80005330:	ea6080e7          	jalr	-346(ra) # 800061d2 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005334:	100017b7          	lui	a5,0x10001
    80005338:	4398                	lw	a4,0(a5)
    8000533a:	2701                	sext.w	a4,a4
    8000533c:	747277b7          	lui	a5,0x74727
    80005340:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005344:	0ef71163          	bne	a4,a5,80005426 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005348:	100017b7          	lui	a5,0x10001
    8000534c:	43dc                	lw	a5,4(a5)
    8000534e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005350:	4705                	li	a4,1
    80005352:	0ce79a63          	bne	a5,a4,80005426 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005356:	100017b7          	lui	a5,0x10001
    8000535a:	479c                	lw	a5,8(a5)
    8000535c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000535e:	4709                	li	a4,2
    80005360:	0ce79363          	bne	a5,a4,80005426 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005364:	100017b7          	lui	a5,0x10001
    80005368:	47d8                	lw	a4,12(a5)
    8000536a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000536c:	554d47b7          	lui	a5,0x554d4
    80005370:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005374:	0af71963          	bne	a4,a5,80005426 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005378:	100017b7          	lui	a5,0x10001
    8000537c:	4705                	li	a4,1
    8000537e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005380:	470d                	li	a4,3
    80005382:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005384:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005386:	c7ffe737          	lui	a4,0xc7ffe
    8000538a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fb851f>
    8000538e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005390:	2701                	sext.w	a4,a4
    80005392:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005394:	472d                	li	a4,11
    80005396:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005398:	473d                	li	a4,15
    8000539a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000539c:	6705                	lui	a4,0x1
    8000539e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800053a0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800053a4:	5bdc                	lw	a5,52(a5)
    800053a6:	2781                	sext.w	a5,a5
  if(max == 0)
    800053a8:	c7d9                	beqz	a5,80005436 <virtio_disk_init+0x124>
  if(max < NUM)
    800053aa:	471d                	li	a4,7
    800053ac:	08f77d63          	bgeu	a4,a5,80005446 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800053b0:	100014b7          	lui	s1,0x10001
    800053b4:	47a1                	li	a5,8
    800053b6:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800053b8:	6609                	lui	a2,0x2
    800053ba:	4581                	li	a1,0
    800053bc:	00036517          	auipc	a0,0x36
    800053c0:	c4450513          	addi	a0,a0,-956 # 8003b000 <disk>
    800053c4:	ffffb097          	auipc	ra,0xffffb
    800053c8:	e4e080e7          	jalr	-434(ra) # 80000212 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800053cc:	00036717          	auipc	a4,0x36
    800053d0:	c3470713          	addi	a4,a4,-972 # 8003b000 <disk>
    800053d4:	00c75793          	srli	a5,a4,0xc
    800053d8:	2781                	sext.w	a5,a5
    800053da:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    800053dc:	00038797          	auipc	a5,0x38
    800053e0:	c2478793          	addi	a5,a5,-988 # 8003d000 <disk+0x2000>
    800053e4:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    800053e6:	00036717          	auipc	a4,0x36
    800053ea:	c9a70713          	addi	a4,a4,-870 # 8003b080 <disk+0x80>
    800053ee:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800053f0:	00037717          	auipc	a4,0x37
    800053f4:	c1070713          	addi	a4,a4,-1008 # 8003c000 <disk+0x1000>
    800053f8:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800053fa:	4705                	li	a4,1
    800053fc:	00e78c23          	sb	a4,24(a5)
    80005400:	00e78ca3          	sb	a4,25(a5)
    80005404:	00e78d23          	sb	a4,26(a5)
    80005408:	00e78da3          	sb	a4,27(a5)
    8000540c:	00e78e23          	sb	a4,28(a5)
    80005410:	00e78ea3          	sb	a4,29(a5)
    80005414:	00e78f23          	sb	a4,30(a5)
    80005418:	00e78fa3          	sb	a4,31(a5)
}
    8000541c:	60e2                	ld	ra,24(sp)
    8000541e:	6442                	ld	s0,16(sp)
    80005420:	64a2                	ld	s1,8(sp)
    80005422:	6105                	addi	sp,sp,32
    80005424:	8082                	ret
    panic("could not find virtio disk");
    80005426:	00003517          	auipc	a0,0x3
    8000542a:	3ba50513          	addi	a0,a0,954 # 800087e0 <syscalls+0x350>
    8000542e:	00001097          	auipc	ra,0x1
    80005432:	8ea080e7          	jalr	-1814(ra) # 80005d18 <panic>
    panic("virtio disk has no queue 0");
    80005436:	00003517          	auipc	a0,0x3
    8000543a:	3ca50513          	addi	a0,a0,970 # 80008800 <syscalls+0x370>
    8000543e:	00001097          	auipc	ra,0x1
    80005442:	8da080e7          	jalr	-1830(ra) # 80005d18 <panic>
    panic("virtio disk max queue too short");
    80005446:	00003517          	auipc	a0,0x3
    8000544a:	3da50513          	addi	a0,a0,986 # 80008820 <syscalls+0x390>
    8000544e:	00001097          	auipc	ra,0x1
    80005452:	8ca080e7          	jalr	-1846(ra) # 80005d18 <panic>

0000000080005456 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005456:	7159                	addi	sp,sp,-112
    80005458:	f486                	sd	ra,104(sp)
    8000545a:	f0a2                	sd	s0,96(sp)
    8000545c:	eca6                	sd	s1,88(sp)
    8000545e:	e8ca                	sd	s2,80(sp)
    80005460:	e4ce                	sd	s3,72(sp)
    80005462:	e0d2                	sd	s4,64(sp)
    80005464:	fc56                	sd	s5,56(sp)
    80005466:	f85a                	sd	s6,48(sp)
    80005468:	f45e                	sd	s7,40(sp)
    8000546a:	f062                	sd	s8,32(sp)
    8000546c:	ec66                	sd	s9,24(sp)
    8000546e:	e86a                	sd	s10,16(sp)
    80005470:	1880                	addi	s0,sp,112
    80005472:	892a                	mv	s2,a0
    80005474:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005476:	00c52c83          	lw	s9,12(a0)
    8000547a:	001c9c9b          	slliw	s9,s9,0x1
    8000547e:	1c82                	slli	s9,s9,0x20
    80005480:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005484:	00038517          	auipc	a0,0x38
    80005488:	ca450513          	addi	a0,a0,-860 # 8003d128 <disk+0x2128>
    8000548c:	00001097          	auipc	ra,0x1
    80005490:	dd6080e7          	jalr	-554(ra) # 80006262 <acquire>
  for(int i = 0; i < 3; i++){
    80005494:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005496:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005498:	00036b97          	auipc	s7,0x36
    8000549c:	b68b8b93          	addi	s7,s7,-1176 # 8003b000 <disk>
    800054a0:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    800054a2:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    800054a4:	8a4e                	mv	s4,s3
    800054a6:	a051                	j	8000552a <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    800054a8:	00fb86b3          	add	a3,s7,a5
    800054ac:	96da                	add	a3,a3,s6
    800054ae:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    800054b2:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800054b4:	0207c563          	bltz	a5,800054de <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800054b8:	2485                	addiw	s1,s1,1
    800054ba:	0711                	addi	a4,a4,4
    800054bc:	25548063          	beq	s1,s5,800056fc <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    800054c0:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    800054c2:	00038697          	auipc	a3,0x38
    800054c6:	b5668693          	addi	a3,a3,-1194 # 8003d018 <disk+0x2018>
    800054ca:	87d2                	mv	a5,s4
    if(disk.free[i]){
    800054cc:	0006c583          	lbu	a1,0(a3)
    800054d0:	fde1                	bnez	a1,800054a8 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800054d2:	2785                	addiw	a5,a5,1
    800054d4:	0685                	addi	a3,a3,1
    800054d6:	ff879be3          	bne	a5,s8,800054cc <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800054da:	57fd                	li	a5,-1
    800054dc:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    800054de:	02905a63          	blez	s1,80005512 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800054e2:	f9042503          	lw	a0,-112(s0)
    800054e6:	00000097          	auipc	ra,0x0
    800054ea:	d90080e7          	jalr	-624(ra) # 80005276 <free_desc>
      for(int j = 0; j < i; j++)
    800054ee:	4785                	li	a5,1
    800054f0:	0297d163          	bge	a5,s1,80005512 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800054f4:	f9442503          	lw	a0,-108(s0)
    800054f8:	00000097          	auipc	ra,0x0
    800054fc:	d7e080e7          	jalr	-642(ra) # 80005276 <free_desc>
      for(int j = 0; j < i; j++)
    80005500:	4789                	li	a5,2
    80005502:	0097d863          	bge	a5,s1,80005512 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005506:	f9842503          	lw	a0,-104(s0)
    8000550a:	00000097          	auipc	ra,0x0
    8000550e:	d6c080e7          	jalr	-660(ra) # 80005276 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005512:	00038597          	auipc	a1,0x38
    80005516:	c1658593          	addi	a1,a1,-1002 # 8003d128 <disk+0x2128>
    8000551a:	00038517          	auipc	a0,0x38
    8000551e:	afe50513          	addi	a0,a0,-1282 # 8003d018 <disk+0x2018>
    80005522:	ffffc097          	auipc	ra,0xffffc
    80005526:	0bc080e7          	jalr	188(ra) # 800015de <sleep>
  for(int i = 0; i < 3; i++){
    8000552a:	f9040713          	addi	a4,s0,-112
    8000552e:	84ce                	mv	s1,s3
    80005530:	bf41                	j	800054c0 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005532:	20058713          	addi	a4,a1,512
    80005536:	00471693          	slli	a3,a4,0x4
    8000553a:	00036717          	auipc	a4,0x36
    8000553e:	ac670713          	addi	a4,a4,-1338 # 8003b000 <disk>
    80005542:	9736                	add	a4,a4,a3
    80005544:	4685                	li	a3,1
    80005546:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000554a:	20058713          	addi	a4,a1,512
    8000554e:	00471693          	slli	a3,a4,0x4
    80005552:	00036717          	auipc	a4,0x36
    80005556:	aae70713          	addi	a4,a4,-1362 # 8003b000 <disk>
    8000555a:	9736                	add	a4,a4,a3
    8000555c:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005560:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005564:	7679                	lui	a2,0xffffe
    80005566:	963e                	add	a2,a2,a5
    80005568:	00038697          	auipc	a3,0x38
    8000556c:	a9868693          	addi	a3,a3,-1384 # 8003d000 <disk+0x2000>
    80005570:	6298                	ld	a4,0(a3)
    80005572:	9732                	add	a4,a4,a2
    80005574:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005576:	6298                	ld	a4,0(a3)
    80005578:	9732                	add	a4,a4,a2
    8000557a:	4541                	li	a0,16
    8000557c:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000557e:	6298                	ld	a4,0(a3)
    80005580:	9732                	add	a4,a4,a2
    80005582:	4505                	li	a0,1
    80005584:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005588:	f9442703          	lw	a4,-108(s0)
    8000558c:	6288                	ld	a0,0(a3)
    8000558e:	962a                	add	a2,a2,a0
    80005590:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffb7dce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005594:	0712                	slli	a4,a4,0x4
    80005596:	6290                	ld	a2,0(a3)
    80005598:	963a                	add	a2,a2,a4
    8000559a:	05890513          	addi	a0,s2,88
    8000559e:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800055a0:	6294                	ld	a3,0(a3)
    800055a2:	96ba                	add	a3,a3,a4
    800055a4:	40000613          	li	a2,1024
    800055a8:	c690                	sw	a2,8(a3)
  if(write)
    800055aa:	140d0063          	beqz	s10,800056ea <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800055ae:	00038697          	auipc	a3,0x38
    800055b2:	a526b683          	ld	a3,-1454(a3) # 8003d000 <disk+0x2000>
    800055b6:	96ba                	add	a3,a3,a4
    800055b8:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800055bc:	00036817          	auipc	a6,0x36
    800055c0:	a4480813          	addi	a6,a6,-1468 # 8003b000 <disk>
    800055c4:	00038517          	auipc	a0,0x38
    800055c8:	a3c50513          	addi	a0,a0,-1476 # 8003d000 <disk+0x2000>
    800055cc:	6114                	ld	a3,0(a0)
    800055ce:	96ba                	add	a3,a3,a4
    800055d0:	00c6d603          	lhu	a2,12(a3)
    800055d4:	00166613          	ori	a2,a2,1
    800055d8:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800055dc:	f9842683          	lw	a3,-104(s0)
    800055e0:	6110                	ld	a2,0(a0)
    800055e2:	9732                	add	a4,a4,a2
    800055e4:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800055e8:	20058613          	addi	a2,a1,512
    800055ec:	0612                	slli	a2,a2,0x4
    800055ee:	9642                	add	a2,a2,a6
    800055f0:	577d                	li	a4,-1
    800055f2:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800055f6:	00469713          	slli	a4,a3,0x4
    800055fa:	6114                	ld	a3,0(a0)
    800055fc:	96ba                	add	a3,a3,a4
    800055fe:	03078793          	addi	a5,a5,48
    80005602:	97c2                	add	a5,a5,a6
    80005604:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005606:	611c                	ld	a5,0(a0)
    80005608:	97ba                	add	a5,a5,a4
    8000560a:	4685                	li	a3,1
    8000560c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000560e:	611c                	ld	a5,0(a0)
    80005610:	97ba                	add	a5,a5,a4
    80005612:	4809                	li	a6,2
    80005614:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005618:	611c                	ld	a5,0(a0)
    8000561a:	973e                	add	a4,a4,a5
    8000561c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005620:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80005624:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005628:	6518                	ld	a4,8(a0)
    8000562a:	00275783          	lhu	a5,2(a4)
    8000562e:	8b9d                	andi	a5,a5,7
    80005630:	0786                	slli	a5,a5,0x1
    80005632:	97ba                	add	a5,a5,a4
    80005634:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005638:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000563c:	6518                	ld	a4,8(a0)
    8000563e:	00275783          	lhu	a5,2(a4)
    80005642:	2785                	addiw	a5,a5,1
    80005644:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005648:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000564c:	100017b7          	lui	a5,0x10001
    80005650:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005654:	00492703          	lw	a4,4(s2)
    80005658:	4785                	li	a5,1
    8000565a:	02f71163          	bne	a4,a5,8000567c <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    8000565e:	00038997          	auipc	s3,0x38
    80005662:	aca98993          	addi	s3,s3,-1334 # 8003d128 <disk+0x2128>
  while(b->disk == 1) {
    80005666:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005668:	85ce                	mv	a1,s3
    8000566a:	854a                	mv	a0,s2
    8000566c:	ffffc097          	auipc	ra,0xffffc
    80005670:	f72080e7          	jalr	-142(ra) # 800015de <sleep>
  while(b->disk == 1) {
    80005674:	00492783          	lw	a5,4(s2)
    80005678:	fe9788e3          	beq	a5,s1,80005668 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    8000567c:	f9042903          	lw	s2,-112(s0)
    80005680:	20090793          	addi	a5,s2,512
    80005684:	00479713          	slli	a4,a5,0x4
    80005688:	00036797          	auipc	a5,0x36
    8000568c:	97878793          	addi	a5,a5,-1672 # 8003b000 <disk>
    80005690:	97ba                	add	a5,a5,a4
    80005692:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005696:	00038997          	auipc	s3,0x38
    8000569a:	96a98993          	addi	s3,s3,-1686 # 8003d000 <disk+0x2000>
    8000569e:	00491713          	slli	a4,s2,0x4
    800056a2:	0009b783          	ld	a5,0(s3)
    800056a6:	97ba                	add	a5,a5,a4
    800056a8:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800056ac:	854a                	mv	a0,s2
    800056ae:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800056b2:	00000097          	auipc	ra,0x0
    800056b6:	bc4080e7          	jalr	-1084(ra) # 80005276 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800056ba:	8885                	andi	s1,s1,1
    800056bc:	f0ed                	bnez	s1,8000569e <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800056be:	00038517          	auipc	a0,0x38
    800056c2:	a6a50513          	addi	a0,a0,-1430 # 8003d128 <disk+0x2128>
    800056c6:	00001097          	auipc	ra,0x1
    800056ca:	c50080e7          	jalr	-944(ra) # 80006316 <release>
}
    800056ce:	70a6                	ld	ra,104(sp)
    800056d0:	7406                	ld	s0,96(sp)
    800056d2:	64e6                	ld	s1,88(sp)
    800056d4:	6946                	ld	s2,80(sp)
    800056d6:	69a6                	ld	s3,72(sp)
    800056d8:	6a06                	ld	s4,64(sp)
    800056da:	7ae2                	ld	s5,56(sp)
    800056dc:	7b42                	ld	s6,48(sp)
    800056de:	7ba2                	ld	s7,40(sp)
    800056e0:	7c02                	ld	s8,32(sp)
    800056e2:	6ce2                	ld	s9,24(sp)
    800056e4:	6d42                	ld	s10,16(sp)
    800056e6:	6165                	addi	sp,sp,112
    800056e8:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800056ea:	00038697          	auipc	a3,0x38
    800056ee:	9166b683          	ld	a3,-1770(a3) # 8003d000 <disk+0x2000>
    800056f2:	96ba                	add	a3,a3,a4
    800056f4:	4609                	li	a2,2
    800056f6:	00c69623          	sh	a2,12(a3)
    800056fa:	b5c9                	j	800055bc <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800056fc:	f9042583          	lw	a1,-112(s0)
    80005700:	20058793          	addi	a5,a1,512
    80005704:	0792                	slli	a5,a5,0x4
    80005706:	00036517          	auipc	a0,0x36
    8000570a:	9a250513          	addi	a0,a0,-1630 # 8003b0a8 <disk+0xa8>
    8000570e:	953e                	add	a0,a0,a5
  if(write)
    80005710:	e20d11e3          	bnez	s10,80005532 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005714:	20058713          	addi	a4,a1,512
    80005718:	00471693          	slli	a3,a4,0x4
    8000571c:	00036717          	auipc	a4,0x36
    80005720:	8e470713          	addi	a4,a4,-1820 # 8003b000 <disk>
    80005724:	9736                	add	a4,a4,a3
    80005726:	0a072423          	sw	zero,168(a4)
    8000572a:	b505                	j	8000554a <virtio_disk_rw+0xf4>

000000008000572c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000572c:	1101                	addi	sp,sp,-32
    8000572e:	ec06                	sd	ra,24(sp)
    80005730:	e822                	sd	s0,16(sp)
    80005732:	e426                	sd	s1,8(sp)
    80005734:	e04a                	sd	s2,0(sp)
    80005736:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005738:	00038517          	auipc	a0,0x38
    8000573c:	9f050513          	addi	a0,a0,-1552 # 8003d128 <disk+0x2128>
    80005740:	00001097          	auipc	ra,0x1
    80005744:	b22080e7          	jalr	-1246(ra) # 80006262 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005748:	10001737          	lui	a4,0x10001
    8000574c:	533c                	lw	a5,96(a4)
    8000574e:	8b8d                	andi	a5,a5,3
    80005750:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005752:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005756:	00038797          	auipc	a5,0x38
    8000575a:	8aa78793          	addi	a5,a5,-1878 # 8003d000 <disk+0x2000>
    8000575e:	6b94                	ld	a3,16(a5)
    80005760:	0207d703          	lhu	a4,32(a5)
    80005764:	0026d783          	lhu	a5,2(a3)
    80005768:	06f70163          	beq	a4,a5,800057ca <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000576c:	00036917          	auipc	s2,0x36
    80005770:	89490913          	addi	s2,s2,-1900 # 8003b000 <disk>
    80005774:	00038497          	auipc	s1,0x38
    80005778:	88c48493          	addi	s1,s1,-1908 # 8003d000 <disk+0x2000>
    __sync_synchronize();
    8000577c:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005780:	6898                	ld	a4,16(s1)
    80005782:	0204d783          	lhu	a5,32(s1)
    80005786:	8b9d                	andi	a5,a5,7
    80005788:	078e                	slli	a5,a5,0x3
    8000578a:	97ba                	add	a5,a5,a4
    8000578c:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000578e:	20078713          	addi	a4,a5,512
    80005792:	0712                	slli	a4,a4,0x4
    80005794:	974a                	add	a4,a4,s2
    80005796:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    8000579a:	e731                	bnez	a4,800057e6 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000579c:	20078793          	addi	a5,a5,512
    800057a0:	0792                	slli	a5,a5,0x4
    800057a2:	97ca                	add	a5,a5,s2
    800057a4:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800057a6:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800057aa:	ffffc097          	auipc	ra,0xffffc
    800057ae:	fc0080e7          	jalr	-64(ra) # 8000176a <wakeup>

    disk.used_idx += 1;
    800057b2:	0204d783          	lhu	a5,32(s1)
    800057b6:	2785                	addiw	a5,a5,1
    800057b8:	17c2                	slli	a5,a5,0x30
    800057ba:	93c1                	srli	a5,a5,0x30
    800057bc:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800057c0:	6898                	ld	a4,16(s1)
    800057c2:	00275703          	lhu	a4,2(a4)
    800057c6:	faf71be3          	bne	a4,a5,8000577c <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    800057ca:	00038517          	auipc	a0,0x38
    800057ce:	95e50513          	addi	a0,a0,-1698 # 8003d128 <disk+0x2128>
    800057d2:	00001097          	auipc	ra,0x1
    800057d6:	b44080e7          	jalr	-1212(ra) # 80006316 <release>
}
    800057da:	60e2                	ld	ra,24(sp)
    800057dc:	6442                	ld	s0,16(sp)
    800057de:	64a2                	ld	s1,8(sp)
    800057e0:	6902                	ld	s2,0(sp)
    800057e2:	6105                	addi	sp,sp,32
    800057e4:	8082                	ret
      panic("virtio_disk_intr status");
    800057e6:	00003517          	auipc	a0,0x3
    800057ea:	05a50513          	addi	a0,a0,90 # 80008840 <syscalls+0x3b0>
    800057ee:	00000097          	auipc	ra,0x0
    800057f2:	52a080e7          	jalr	1322(ra) # 80005d18 <panic>

00000000800057f6 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800057f6:	1141                	addi	sp,sp,-16
    800057f8:	e422                	sd	s0,8(sp)
    800057fa:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r"(x));
    800057fc:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005800:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005804:	0037979b          	slliw	a5,a5,0x3
    80005808:	02004737          	lui	a4,0x2004
    8000580c:	97ba                	add	a5,a5,a4
    8000580e:	0200c737          	lui	a4,0x200c
    80005812:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005816:	000f4637          	lui	a2,0xf4
    8000581a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000581e:	95b2                	add	a1,a1,a2
    80005820:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005822:	00269713          	slli	a4,a3,0x2
    80005826:	9736                	add	a4,a4,a3
    80005828:	00371693          	slli	a3,a4,0x3
    8000582c:	00038717          	auipc	a4,0x38
    80005830:	7d470713          	addi	a4,a4,2004 # 8003e000 <timer_scratch>
    80005834:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005836:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005838:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r"(x));
    8000583a:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r"(x));
    8000583e:	00000797          	auipc	a5,0x0
    80005842:	97278793          	addi	a5,a5,-1678 # 800051b0 <timervec>
    80005846:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r"(x));
    8000584a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000584e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r"(x));
    80005852:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r"(x));
    80005856:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000585a:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r"(x));
    8000585e:	30479073          	csrw	mie,a5
}
    80005862:	6422                	ld	s0,8(sp)
    80005864:	0141                	addi	sp,sp,16
    80005866:	8082                	ret

0000000080005868 <start>:
{
    80005868:	1141                	addi	sp,sp,-16
    8000586a:	e406                	sd	ra,8(sp)
    8000586c:	e022                	sd	s0,0(sp)
    8000586e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r"(x));
    80005870:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005874:	7779                	lui	a4,0xffffe
    80005876:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffb85bf>
    8000587a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000587c:	6705                	lui	a4,0x1
    8000587e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005882:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r"(x));
    80005884:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r"(x));
    80005888:	ffffb797          	auipc	a5,0xffffb
    8000588c:	b3878793          	addi	a5,a5,-1224 # 800003c0 <main>
    80005890:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r"(x));
    80005894:	4781                	li	a5,0
    80005896:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r"(x));
    8000589a:	67c1                	lui	a5,0x10
    8000589c:	17fd                	addi	a5,a5,-1
    8000589e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r"(x));
    800058a2:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r"(x));
    800058a6:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800058aa:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r"(x));
    800058ae:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r"(x));
    800058b2:	57fd                	li	a5,-1
    800058b4:	83a9                	srli	a5,a5,0xa
    800058b6:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r"(x));
    800058ba:	47bd                	li	a5,15
    800058bc:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800058c0:	00000097          	auipc	ra,0x0
    800058c4:	f36080e7          	jalr	-202(ra) # 800057f6 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r"(x));
    800058c8:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800058cc:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r"(x));
    800058ce:	823e                	mv	tp,a5
  asm volatile("mret");
    800058d0:	30200073          	mret
}
    800058d4:	60a2                	ld	ra,8(sp)
    800058d6:	6402                	ld	s0,0(sp)
    800058d8:	0141                	addi	sp,sp,16
    800058da:	8082                	ret

00000000800058dc <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800058dc:	715d                	addi	sp,sp,-80
    800058de:	e486                	sd	ra,72(sp)
    800058e0:	e0a2                	sd	s0,64(sp)
    800058e2:	fc26                	sd	s1,56(sp)
    800058e4:	f84a                	sd	s2,48(sp)
    800058e6:	f44e                	sd	s3,40(sp)
    800058e8:	f052                	sd	s4,32(sp)
    800058ea:	ec56                	sd	s5,24(sp)
    800058ec:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800058ee:	04c05663          	blez	a2,8000593a <consolewrite+0x5e>
    800058f2:	8a2a                	mv	s4,a0
    800058f4:	84ae                	mv	s1,a1
    800058f6:	89b2                	mv	s3,a2
    800058f8:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800058fa:	5afd                	li	s5,-1
    800058fc:	4685                	li	a3,1
    800058fe:	8626                	mv	a2,s1
    80005900:	85d2                	mv	a1,s4
    80005902:	fbf40513          	addi	a0,s0,-65
    80005906:	ffffc097          	auipc	ra,0xffffc
    8000590a:	0d2080e7          	jalr	210(ra) # 800019d8 <either_copyin>
    8000590e:	01550c63          	beq	a0,s5,80005926 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005912:	fbf44503          	lbu	a0,-65(s0)
    80005916:	00000097          	auipc	ra,0x0
    8000591a:	78e080e7          	jalr	1934(ra) # 800060a4 <uartputc>
  for(i = 0; i < n; i++){
    8000591e:	2905                	addiw	s2,s2,1
    80005920:	0485                	addi	s1,s1,1
    80005922:	fd299de3          	bne	s3,s2,800058fc <consolewrite+0x20>
  }

  return i;
}
    80005926:	854a                	mv	a0,s2
    80005928:	60a6                	ld	ra,72(sp)
    8000592a:	6406                	ld	s0,64(sp)
    8000592c:	74e2                	ld	s1,56(sp)
    8000592e:	7942                	ld	s2,48(sp)
    80005930:	79a2                	ld	s3,40(sp)
    80005932:	7a02                	ld	s4,32(sp)
    80005934:	6ae2                	ld	s5,24(sp)
    80005936:	6161                	addi	sp,sp,80
    80005938:	8082                	ret
  for(i = 0; i < n; i++){
    8000593a:	4901                	li	s2,0
    8000593c:	b7ed                	j	80005926 <consolewrite+0x4a>

000000008000593e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000593e:	7119                	addi	sp,sp,-128
    80005940:	fc86                	sd	ra,120(sp)
    80005942:	f8a2                	sd	s0,112(sp)
    80005944:	f4a6                	sd	s1,104(sp)
    80005946:	f0ca                	sd	s2,96(sp)
    80005948:	ecce                	sd	s3,88(sp)
    8000594a:	e8d2                	sd	s4,80(sp)
    8000594c:	e4d6                	sd	s5,72(sp)
    8000594e:	e0da                	sd	s6,64(sp)
    80005950:	fc5e                	sd	s7,56(sp)
    80005952:	f862                	sd	s8,48(sp)
    80005954:	f466                	sd	s9,40(sp)
    80005956:	f06a                	sd	s10,32(sp)
    80005958:	ec6e                	sd	s11,24(sp)
    8000595a:	0100                	addi	s0,sp,128
    8000595c:	8b2a                	mv	s6,a0
    8000595e:	8aae                	mv	s5,a1
    80005960:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005962:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005966:	00040517          	auipc	a0,0x40
    8000596a:	7da50513          	addi	a0,a0,2010 # 80046140 <cons>
    8000596e:	00001097          	auipc	ra,0x1
    80005972:	8f4080e7          	jalr	-1804(ra) # 80006262 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005976:	00040497          	auipc	s1,0x40
    8000597a:	7ca48493          	addi	s1,s1,1994 # 80046140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000597e:	89a6                	mv	s3,s1
    80005980:	00041917          	auipc	s2,0x41
    80005984:	85890913          	addi	s2,s2,-1960 # 800461d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005988:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000598a:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    8000598c:	4da9                	li	s11,10
  while(n > 0){
    8000598e:	07405863          	blez	s4,800059fe <consoleread+0xc0>
    while(cons.r == cons.w){
    80005992:	0984a783          	lw	a5,152(s1)
    80005996:	09c4a703          	lw	a4,156(s1)
    8000599a:	02f71463          	bne	a4,a5,800059c2 <consoleread+0x84>
      if(myproc()->killed){
    8000599e:	ffffb097          	auipc	ra,0xffffb
    800059a2:	584080e7          	jalr	1412(ra) # 80000f22 <myproc>
    800059a6:	551c                	lw	a5,40(a0)
    800059a8:	e7b5                	bnez	a5,80005a14 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    800059aa:	85ce                	mv	a1,s3
    800059ac:	854a                	mv	a0,s2
    800059ae:	ffffc097          	auipc	ra,0xffffc
    800059b2:	c30080e7          	jalr	-976(ra) # 800015de <sleep>
    while(cons.r == cons.w){
    800059b6:	0984a783          	lw	a5,152(s1)
    800059ba:	09c4a703          	lw	a4,156(s1)
    800059be:	fef700e3          	beq	a4,a5,8000599e <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800059c2:	0017871b          	addiw	a4,a5,1
    800059c6:	08e4ac23          	sw	a4,152(s1)
    800059ca:	07f7f713          	andi	a4,a5,127
    800059ce:	9726                	add	a4,a4,s1
    800059d0:	01874703          	lbu	a4,24(a4)
    800059d4:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    800059d8:	079c0663          	beq	s8,s9,80005a44 <consoleread+0x106>
    cbuf = c;
    800059dc:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800059e0:	4685                	li	a3,1
    800059e2:	f8f40613          	addi	a2,s0,-113
    800059e6:	85d6                	mv	a1,s5
    800059e8:	855a                	mv	a0,s6
    800059ea:	ffffc097          	auipc	ra,0xffffc
    800059ee:	f98080e7          	jalr	-104(ra) # 80001982 <either_copyout>
    800059f2:	01a50663          	beq	a0,s10,800059fe <consoleread+0xc0>
    dst++;
    800059f6:	0a85                	addi	s5,s5,1
    --n;
    800059f8:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    800059fa:	f9bc1ae3          	bne	s8,s11,8000598e <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800059fe:	00040517          	auipc	a0,0x40
    80005a02:	74250513          	addi	a0,a0,1858 # 80046140 <cons>
    80005a06:	00001097          	auipc	ra,0x1
    80005a0a:	910080e7          	jalr	-1776(ra) # 80006316 <release>

  return target - n;
    80005a0e:	414b853b          	subw	a0,s7,s4
    80005a12:	a811                	j	80005a26 <consoleread+0xe8>
        release(&cons.lock);
    80005a14:	00040517          	auipc	a0,0x40
    80005a18:	72c50513          	addi	a0,a0,1836 # 80046140 <cons>
    80005a1c:	00001097          	auipc	ra,0x1
    80005a20:	8fa080e7          	jalr	-1798(ra) # 80006316 <release>
        return -1;
    80005a24:	557d                	li	a0,-1
}
    80005a26:	70e6                	ld	ra,120(sp)
    80005a28:	7446                	ld	s0,112(sp)
    80005a2a:	74a6                	ld	s1,104(sp)
    80005a2c:	7906                	ld	s2,96(sp)
    80005a2e:	69e6                	ld	s3,88(sp)
    80005a30:	6a46                	ld	s4,80(sp)
    80005a32:	6aa6                	ld	s5,72(sp)
    80005a34:	6b06                	ld	s6,64(sp)
    80005a36:	7be2                	ld	s7,56(sp)
    80005a38:	7c42                	ld	s8,48(sp)
    80005a3a:	7ca2                	ld	s9,40(sp)
    80005a3c:	7d02                	ld	s10,32(sp)
    80005a3e:	6de2                	ld	s11,24(sp)
    80005a40:	6109                	addi	sp,sp,128
    80005a42:	8082                	ret
      if(n < target){
    80005a44:	000a071b          	sext.w	a4,s4
    80005a48:	fb777be3          	bgeu	a4,s7,800059fe <consoleread+0xc0>
        cons.r--;
    80005a4c:	00040717          	auipc	a4,0x40
    80005a50:	78f72623          	sw	a5,1932(a4) # 800461d8 <cons+0x98>
    80005a54:	b76d                	j	800059fe <consoleread+0xc0>

0000000080005a56 <consputc>:
{
    80005a56:	1141                	addi	sp,sp,-16
    80005a58:	e406                	sd	ra,8(sp)
    80005a5a:	e022                	sd	s0,0(sp)
    80005a5c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005a5e:	10000793          	li	a5,256
    80005a62:	00f50a63          	beq	a0,a5,80005a76 <consputc+0x20>
    uartputc_sync(c);
    80005a66:	00000097          	auipc	ra,0x0
    80005a6a:	564080e7          	jalr	1380(ra) # 80005fca <uartputc_sync>
}
    80005a6e:	60a2                	ld	ra,8(sp)
    80005a70:	6402                	ld	s0,0(sp)
    80005a72:	0141                	addi	sp,sp,16
    80005a74:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005a76:	4521                	li	a0,8
    80005a78:	00000097          	auipc	ra,0x0
    80005a7c:	552080e7          	jalr	1362(ra) # 80005fca <uartputc_sync>
    80005a80:	02000513          	li	a0,32
    80005a84:	00000097          	auipc	ra,0x0
    80005a88:	546080e7          	jalr	1350(ra) # 80005fca <uartputc_sync>
    80005a8c:	4521                	li	a0,8
    80005a8e:	00000097          	auipc	ra,0x0
    80005a92:	53c080e7          	jalr	1340(ra) # 80005fca <uartputc_sync>
    80005a96:	bfe1                	j	80005a6e <consputc+0x18>

0000000080005a98 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005a98:	1101                	addi	sp,sp,-32
    80005a9a:	ec06                	sd	ra,24(sp)
    80005a9c:	e822                	sd	s0,16(sp)
    80005a9e:	e426                	sd	s1,8(sp)
    80005aa0:	e04a                	sd	s2,0(sp)
    80005aa2:	1000                	addi	s0,sp,32
    80005aa4:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005aa6:	00040517          	auipc	a0,0x40
    80005aaa:	69a50513          	addi	a0,a0,1690 # 80046140 <cons>
    80005aae:	00000097          	auipc	ra,0x0
    80005ab2:	7b4080e7          	jalr	1972(ra) # 80006262 <acquire>

  switch(c){
    80005ab6:	47d5                	li	a5,21
    80005ab8:	0af48663          	beq	s1,a5,80005b64 <consoleintr+0xcc>
    80005abc:	0297ca63          	blt	a5,s1,80005af0 <consoleintr+0x58>
    80005ac0:	47a1                	li	a5,8
    80005ac2:	0ef48763          	beq	s1,a5,80005bb0 <consoleintr+0x118>
    80005ac6:	47c1                	li	a5,16
    80005ac8:	10f49a63          	bne	s1,a5,80005bdc <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005acc:	ffffc097          	auipc	ra,0xffffc
    80005ad0:	f62080e7          	jalr	-158(ra) # 80001a2e <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005ad4:	00040517          	auipc	a0,0x40
    80005ad8:	66c50513          	addi	a0,a0,1644 # 80046140 <cons>
    80005adc:	00001097          	auipc	ra,0x1
    80005ae0:	83a080e7          	jalr	-1990(ra) # 80006316 <release>
}
    80005ae4:	60e2                	ld	ra,24(sp)
    80005ae6:	6442                	ld	s0,16(sp)
    80005ae8:	64a2                	ld	s1,8(sp)
    80005aea:	6902                	ld	s2,0(sp)
    80005aec:	6105                	addi	sp,sp,32
    80005aee:	8082                	ret
  switch(c){
    80005af0:	07f00793          	li	a5,127
    80005af4:	0af48e63          	beq	s1,a5,80005bb0 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005af8:	00040717          	auipc	a4,0x40
    80005afc:	64870713          	addi	a4,a4,1608 # 80046140 <cons>
    80005b00:	0a072783          	lw	a5,160(a4)
    80005b04:	09872703          	lw	a4,152(a4)
    80005b08:	9f99                	subw	a5,a5,a4
    80005b0a:	07f00713          	li	a4,127
    80005b0e:	fcf763e3          	bltu	a4,a5,80005ad4 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005b12:	47b5                	li	a5,13
    80005b14:	0cf48763          	beq	s1,a5,80005be2 <consoleintr+0x14a>
      consputc(c);
    80005b18:	8526                	mv	a0,s1
    80005b1a:	00000097          	auipc	ra,0x0
    80005b1e:	f3c080e7          	jalr	-196(ra) # 80005a56 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b22:	00040797          	auipc	a5,0x40
    80005b26:	61e78793          	addi	a5,a5,1566 # 80046140 <cons>
    80005b2a:	0a07a703          	lw	a4,160(a5)
    80005b2e:	0017069b          	addiw	a3,a4,1
    80005b32:	0006861b          	sext.w	a2,a3
    80005b36:	0ad7a023          	sw	a3,160(a5)
    80005b3a:	07f77713          	andi	a4,a4,127
    80005b3e:	97ba                	add	a5,a5,a4
    80005b40:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005b44:	47a9                	li	a5,10
    80005b46:	0cf48563          	beq	s1,a5,80005c10 <consoleintr+0x178>
    80005b4a:	4791                	li	a5,4
    80005b4c:	0cf48263          	beq	s1,a5,80005c10 <consoleintr+0x178>
    80005b50:	00040797          	auipc	a5,0x40
    80005b54:	6887a783          	lw	a5,1672(a5) # 800461d8 <cons+0x98>
    80005b58:	0807879b          	addiw	a5,a5,128
    80005b5c:	f6f61ce3          	bne	a2,a5,80005ad4 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b60:	863e                	mv	a2,a5
    80005b62:	a07d                	j	80005c10 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005b64:	00040717          	auipc	a4,0x40
    80005b68:	5dc70713          	addi	a4,a4,1500 # 80046140 <cons>
    80005b6c:	0a072783          	lw	a5,160(a4)
    80005b70:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005b74:	00040497          	auipc	s1,0x40
    80005b78:	5cc48493          	addi	s1,s1,1484 # 80046140 <cons>
    while(cons.e != cons.w &&
    80005b7c:	4929                	li	s2,10
    80005b7e:	f4f70be3          	beq	a4,a5,80005ad4 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005b82:	37fd                	addiw	a5,a5,-1
    80005b84:	07f7f713          	andi	a4,a5,127
    80005b88:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005b8a:	01874703          	lbu	a4,24(a4)
    80005b8e:	f52703e3          	beq	a4,s2,80005ad4 <consoleintr+0x3c>
      cons.e--;
    80005b92:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005b96:	10000513          	li	a0,256
    80005b9a:	00000097          	auipc	ra,0x0
    80005b9e:	ebc080e7          	jalr	-324(ra) # 80005a56 <consputc>
    while(cons.e != cons.w &&
    80005ba2:	0a04a783          	lw	a5,160(s1)
    80005ba6:	09c4a703          	lw	a4,156(s1)
    80005baa:	fcf71ce3          	bne	a4,a5,80005b82 <consoleintr+0xea>
    80005bae:	b71d                	j	80005ad4 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005bb0:	00040717          	auipc	a4,0x40
    80005bb4:	59070713          	addi	a4,a4,1424 # 80046140 <cons>
    80005bb8:	0a072783          	lw	a5,160(a4)
    80005bbc:	09c72703          	lw	a4,156(a4)
    80005bc0:	f0f70ae3          	beq	a4,a5,80005ad4 <consoleintr+0x3c>
      cons.e--;
    80005bc4:	37fd                	addiw	a5,a5,-1
    80005bc6:	00040717          	auipc	a4,0x40
    80005bca:	60f72d23          	sw	a5,1562(a4) # 800461e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005bce:	10000513          	li	a0,256
    80005bd2:	00000097          	auipc	ra,0x0
    80005bd6:	e84080e7          	jalr	-380(ra) # 80005a56 <consputc>
    80005bda:	bded                	j	80005ad4 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005bdc:	ee048ce3          	beqz	s1,80005ad4 <consoleintr+0x3c>
    80005be0:	bf21                	j	80005af8 <consoleintr+0x60>
      consputc(c);
    80005be2:	4529                	li	a0,10
    80005be4:	00000097          	auipc	ra,0x0
    80005be8:	e72080e7          	jalr	-398(ra) # 80005a56 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005bec:	00040797          	auipc	a5,0x40
    80005bf0:	55478793          	addi	a5,a5,1364 # 80046140 <cons>
    80005bf4:	0a07a703          	lw	a4,160(a5)
    80005bf8:	0017069b          	addiw	a3,a4,1
    80005bfc:	0006861b          	sext.w	a2,a3
    80005c00:	0ad7a023          	sw	a3,160(a5)
    80005c04:	07f77713          	andi	a4,a4,127
    80005c08:	97ba                	add	a5,a5,a4
    80005c0a:	4729                	li	a4,10
    80005c0c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005c10:	00040797          	auipc	a5,0x40
    80005c14:	5cc7a623          	sw	a2,1484(a5) # 800461dc <cons+0x9c>
        wakeup(&cons.r);
    80005c18:	00040517          	auipc	a0,0x40
    80005c1c:	5c050513          	addi	a0,a0,1472 # 800461d8 <cons+0x98>
    80005c20:	ffffc097          	auipc	ra,0xffffc
    80005c24:	b4a080e7          	jalr	-1206(ra) # 8000176a <wakeup>
    80005c28:	b575                	j	80005ad4 <consoleintr+0x3c>

0000000080005c2a <consoleinit>:

void
consoleinit(void)
{
    80005c2a:	1141                	addi	sp,sp,-16
    80005c2c:	e406                	sd	ra,8(sp)
    80005c2e:	e022                	sd	s0,0(sp)
    80005c30:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005c32:	00003597          	auipc	a1,0x3
    80005c36:	c2658593          	addi	a1,a1,-986 # 80008858 <syscalls+0x3c8>
    80005c3a:	00040517          	auipc	a0,0x40
    80005c3e:	50650513          	addi	a0,a0,1286 # 80046140 <cons>
    80005c42:	00000097          	auipc	ra,0x0
    80005c46:	590080e7          	jalr	1424(ra) # 800061d2 <initlock>

  uartinit();
    80005c4a:	00000097          	auipc	ra,0x0
    80005c4e:	330080e7          	jalr	816(ra) # 80005f7a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005c52:	00033797          	auipc	a5,0x33
    80005c56:	47678793          	addi	a5,a5,1142 # 800390c8 <devsw>
    80005c5a:	00000717          	auipc	a4,0x0
    80005c5e:	ce470713          	addi	a4,a4,-796 # 8000593e <consoleread>
    80005c62:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005c64:	00000717          	auipc	a4,0x0
    80005c68:	c7870713          	addi	a4,a4,-904 # 800058dc <consolewrite>
    80005c6c:	ef98                	sd	a4,24(a5)
}
    80005c6e:	60a2                	ld	ra,8(sp)
    80005c70:	6402                	ld	s0,0(sp)
    80005c72:	0141                	addi	sp,sp,16
    80005c74:	8082                	ret

0000000080005c76 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005c76:	7179                	addi	sp,sp,-48
    80005c78:	f406                	sd	ra,40(sp)
    80005c7a:	f022                	sd	s0,32(sp)
    80005c7c:	ec26                	sd	s1,24(sp)
    80005c7e:	e84a                	sd	s2,16(sp)
    80005c80:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005c82:	c219                	beqz	a2,80005c88 <printint+0x12>
    80005c84:	08054663          	bltz	a0,80005d10 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005c88:	2501                	sext.w	a0,a0
    80005c8a:	4881                	li	a7,0
    80005c8c:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005c90:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005c92:	2581                	sext.w	a1,a1
    80005c94:	00003617          	auipc	a2,0x3
    80005c98:	bf460613          	addi	a2,a2,-1036 # 80008888 <digits>
    80005c9c:	883a                	mv	a6,a4
    80005c9e:	2705                	addiw	a4,a4,1
    80005ca0:	02b577bb          	remuw	a5,a0,a1
    80005ca4:	1782                	slli	a5,a5,0x20
    80005ca6:	9381                	srli	a5,a5,0x20
    80005ca8:	97b2                	add	a5,a5,a2
    80005caa:	0007c783          	lbu	a5,0(a5)
    80005cae:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005cb2:	0005079b          	sext.w	a5,a0
    80005cb6:	02b5553b          	divuw	a0,a0,a1
    80005cba:	0685                	addi	a3,a3,1
    80005cbc:	feb7f0e3          	bgeu	a5,a1,80005c9c <printint+0x26>

  if(sign)
    80005cc0:	00088b63          	beqz	a7,80005cd6 <printint+0x60>
    buf[i++] = '-';
    80005cc4:	fe040793          	addi	a5,s0,-32
    80005cc8:	973e                	add	a4,a4,a5
    80005cca:	02d00793          	li	a5,45
    80005cce:	fef70823          	sb	a5,-16(a4)
    80005cd2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005cd6:	02e05763          	blez	a4,80005d04 <printint+0x8e>
    80005cda:	fd040793          	addi	a5,s0,-48
    80005cde:	00e784b3          	add	s1,a5,a4
    80005ce2:	fff78913          	addi	s2,a5,-1
    80005ce6:	993a                	add	s2,s2,a4
    80005ce8:	377d                	addiw	a4,a4,-1
    80005cea:	1702                	slli	a4,a4,0x20
    80005cec:	9301                	srli	a4,a4,0x20
    80005cee:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005cf2:	fff4c503          	lbu	a0,-1(s1)
    80005cf6:	00000097          	auipc	ra,0x0
    80005cfa:	d60080e7          	jalr	-672(ra) # 80005a56 <consputc>
  while(--i >= 0)
    80005cfe:	14fd                	addi	s1,s1,-1
    80005d00:	ff2499e3          	bne	s1,s2,80005cf2 <printint+0x7c>
}
    80005d04:	70a2                	ld	ra,40(sp)
    80005d06:	7402                	ld	s0,32(sp)
    80005d08:	64e2                	ld	s1,24(sp)
    80005d0a:	6942                	ld	s2,16(sp)
    80005d0c:	6145                	addi	sp,sp,48
    80005d0e:	8082                	ret
    x = -xx;
    80005d10:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005d14:	4885                	li	a7,1
    x = -xx;
    80005d16:	bf9d                	j	80005c8c <printint+0x16>

0000000080005d18 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005d18:	1101                	addi	sp,sp,-32
    80005d1a:	ec06                	sd	ra,24(sp)
    80005d1c:	e822                	sd	s0,16(sp)
    80005d1e:	e426                	sd	s1,8(sp)
    80005d20:	1000                	addi	s0,sp,32
    80005d22:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005d24:	00040797          	auipc	a5,0x40
    80005d28:	4c07ae23          	sw	zero,1244(a5) # 80046200 <pr+0x18>
  printf("panic: ");
    80005d2c:	00003517          	auipc	a0,0x3
    80005d30:	b3450513          	addi	a0,a0,-1228 # 80008860 <syscalls+0x3d0>
    80005d34:	00000097          	auipc	ra,0x0
    80005d38:	02e080e7          	jalr	46(ra) # 80005d62 <printf>
  printf(s);
    80005d3c:	8526                	mv	a0,s1
    80005d3e:	00000097          	auipc	ra,0x0
    80005d42:	024080e7          	jalr	36(ra) # 80005d62 <printf>
  printf("\n");
    80005d46:	00002517          	auipc	a0,0x2
    80005d4a:	35250513          	addi	a0,a0,850 # 80008098 <etext+0x98>
    80005d4e:	00000097          	auipc	ra,0x0
    80005d52:	014080e7          	jalr	20(ra) # 80005d62 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005d56:	4785                	li	a5,1
    80005d58:	00003717          	auipc	a4,0x3
    80005d5c:	2cf72223          	sw	a5,708(a4) # 8000901c <panicked>
  for(;;)
    80005d60:	a001                	j	80005d60 <panic+0x48>

0000000080005d62 <printf>:
{
    80005d62:	7131                	addi	sp,sp,-192
    80005d64:	fc86                	sd	ra,120(sp)
    80005d66:	f8a2                	sd	s0,112(sp)
    80005d68:	f4a6                	sd	s1,104(sp)
    80005d6a:	f0ca                	sd	s2,96(sp)
    80005d6c:	ecce                	sd	s3,88(sp)
    80005d6e:	e8d2                	sd	s4,80(sp)
    80005d70:	e4d6                	sd	s5,72(sp)
    80005d72:	e0da                	sd	s6,64(sp)
    80005d74:	fc5e                	sd	s7,56(sp)
    80005d76:	f862                	sd	s8,48(sp)
    80005d78:	f466                	sd	s9,40(sp)
    80005d7a:	f06a                	sd	s10,32(sp)
    80005d7c:	ec6e                	sd	s11,24(sp)
    80005d7e:	0100                	addi	s0,sp,128
    80005d80:	8a2a                	mv	s4,a0
    80005d82:	e40c                	sd	a1,8(s0)
    80005d84:	e810                	sd	a2,16(s0)
    80005d86:	ec14                	sd	a3,24(s0)
    80005d88:	f018                	sd	a4,32(s0)
    80005d8a:	f41c                	sd	a5,40(s0)
    80005d8c:	03043823          	sd	a6,48(s0)
    80005d90:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005d94:	00040d97          	auipc	s11,0x40
    80005d98:	46cdad83          	lw	s11,1132(s11) # 80046200 <pr+0x18>
  if(locking)
    80005d9c:	020d9b63          	bnez	s11,80005dd2 <printf+0x70>
  if (fmt == 0)
    80005da0:	040a0263          	beqz	s4,80005de4 <printf+0x82>
  va_start(ap, fmt);
    80005da4:	00840793          	addi	a5,s0,8
    80005da8:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005dac:	000a4503          	lbu	a0,0(s4)
    80005db0:	16050263          	beqz	a0,80005f14 <printf+0x1b2>
    80005db4:	4481                	li	s1,0
    if(c != '%'){
    80005db6:	02500a93          	li	s5,37
    switch(c){
    80005dba:	07000b13          	li	s6,112
  consputc('x');
    80005dbe:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005dc0:	00003b97          	auipc	s7,0x3
    80005dc4:	ac8b8b93          	addi	s7,s7,-1336 # 80008888 <digits>
    switch(c){
    80005dc8:	07300c93          	li	s9,115
    80005dcc:	06400c13          	li	s8,100
    80005dd0:	a82d                	j	80005e0a <printf+0xa8>
    acquire(&pr.lock);
    80005dd2:	00040517          	auipc	a0,0x40
    80005dd6:	41650513          	addi	a0,a0,1046 # 800461e8 <pr>
    80005dda:	00000097          	auipc	ra,0x0
    80005dde:	488080e7          	jalr	1160(ra) # 80006262 <acquire>
    80005de2:	bf7d                	j	80005da0 <printf+0x3e>
    panic("null fmt");
    80005de4:	00003517          	auipc	a0,0x3
    80005de8:	a8c50513          	addi	a0,a0,-1396 # 80008870 <syscalls+0x3e0>
    80005dec:	00000097          	auipc	ra,0x0
    80005df0:	f2c080e7          	jalr	-212(ra) # 80005d18 <panic>
      consputc(c);
    80005df4:	00000097          	auipc	ra,0x0
    80005df8:	c62080e7          	jalr	-926(ra) # 80005a56 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005dfc:	2485                	addiw	s1,s1,1
    80005dfe:	009a07b3          	add	a5,s4,s1
    80005e02:	0007c503          	lbu	a0,0(a5)
    80005e06:	10050763          	beqz	a0,80005f14 <printf+0x1b2>
    if(c != '%'){
    80005e0a:	ff5515e3          	bne	a0,s5,80005df4 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005e0e:	2485                	addiw	s1,s1,1
    80005e10:	009a07b3          	add	a5,s4,s1
    80005e14:	0007c783          	lbu	a5,0(a5)
    80005e18:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005e1c:	cfe5                	beqz	a5,80005f14 <printf+0x1b2>
    switch(c){
    80005e1e:	05678a63          	beq	a5,s6,80005e72 <printf+0x110>
    80005e22:	02fb7663          	bgeu	s6,a5,80005e4e <printf+0xec>
    80005e26:	09978963          	beq	a5,s9,80005eb8 <printf+0x156>
    80005e2a:	07800713          	li	a4,120
    80005e2e:	0ce79863          	bne	a5,a4,80005efe <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005e32:	f8843783          	ld	a5,-120(s0)
    80005e36:	00878713          	addi	a4,a5,8
    80005e3a:	f8e43423          	sd	a4,-120(s0)
    80005e3e:	4605                	li	a2,1
    80005e40:	85ea                	mv	a1,s10
    80005e42:	4388                	lw	a0,0(a5)
    80005e44:	00000097          	auipc	ra,0x0
    80005e48:	e32080e7          	jalr	-462(ra) # 80005c76 <printint>
      break;
    80005e4c:	bf45                	j	80005dfc <printf+0x9a>
    switch(c){
    80005e4e:	0b578263          	beq	a5,s5,80005ef2 <printf+0x190>
    80005e52:	0b879663          	bne	a5,s8,80005efe <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005e56:	f8843783          	ld	a5,-120(s0)
    80005e5a:	00878713          	addi	a4,a5,8
    80005e5e:	f8e43423          	sd	a4,-120(s0)
    80005e62:	4605                	li	a2,1
    80005e64:	45a9                	li	a1,10
    80005e66:	4388                	lw	a0,0(a5)
    80005e68:	00000097          	auipc	ra,0x0
    80005e6c:	e0e080e7          	jalr	-498(ra) # 80005c76 <printint>
      break;
    80005e70:	b771                	j	80005dfc <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005e72:	f8843783          	ld	a5,-120(s0)
    80005e76:	00878713          	addi	a4,a5,8
    80005e7a:	f8e43423          	sd	a4,-120(s0)
    80005e7e:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005e82:	03000513          	li	a0,48
    80005e86:	00000097          	auipc	ra,0x0
    80005e8a:	bd0080e7          	jalr	-1072(ra) # 80005a56 <consputc>
  consputc('x');
    80005e8e:	07800513          	li	a0,120
    80005e92:	00000097          	auipc	ra,0x0
    80005e96:	bc4080e7          	jalr	-1084(ra) # 80005a56 <consputc>
    80005e9a:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e9c:	03c9d793          	srli	a5,s3,0x3c
    80005ea0:	97de                	add	a5,a5,s7
    80005ea2:	0007c503          	lbu	a0,0(a5)
    80005ea6:	00000097          	auipc	ra,0x0
    80005eaa:	bb0080e7          	jalr	-1104(ra) # 80005a56 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005eae:	0992                	slli	s3,s3,0x4
    80005eb0:	397d                	addiw	s2,s2,-1
    80005eb2:	fe0915e3          	bnez	s2,80005e9c <printf+0x13a>
    80005eb6:	b799                	j	80005dfc <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005eb8:	f8843783          	ld	a5,-120(s0)
    80005ebc:	00878713          	addi	a4,a5,8
    80005ec0:	f8e43423          	sd	a4,-120(s0)
    80005ec4:	0007b903          	ld	s2,0(a5)
    80005ec8:	00090e63          	beqz	s2,80005ee4 <printf+0x182>
      for(; *s; s++)
    80005ecc:	00094503          	lbu	a0,0(s2)
    80005ed0:	d515                	beqz	a0,80005dfc <printf+0x9a>
        consputc(*s);
    80005ed2:	00000097          	auipc	ra,0x0
    80005ed6:	b84080e7          	jalr	-1148(ra) # 80005a56 <consputc>
      for(; *s; s++)
    80005eda:	0905                	addi	s2,s2,1
    80005edc:	00094503          	lbu	a0,0(s2)
    80005ee0:	f96d                	bnez	a0,80005ed2 <printf+0x170>
    80005ee2:	bf29                	j	80005dfc <printf+0x9a>
        s = "(null)";
    80005ee4:	00003917          	auipc	s2,0x3
    80005ee8:	98490913          	addi	s2,s2,-1660 # 80008868 <syscalls+0x3d8>
      for(; *s; s++)
    80005eec:	02800513          	li	a0,40
    80005ef0:	b7cd                	j	80005ed2 <printf+0x170>
      consputc('%');
    80005ef2:	8556                	mv	a0,s5
    80005ef4:	00000097          	auipc	ra,0x0
    80005ef8:	b62080e7          	jalr	-1182(ra) # 80005a56 <consputc>
      break;
    80005efc:	b701                	j	80005dfc <printf+0x9a>
      consputc('%');
    80005efe:	8556                	mv	a0,s5
    80005f00:	00000097          	auipc	ra,0x0
    80005f04:	b56080e7          	jalr	-1194(ra) # 80005a56 <consputc>
      consputc(c);
    80005f08:	854a                	mv	a0,s2
    80005f0a:	00000097          	auipc	ra,0x0
    80005f0e:	b4c080e7          	jalr	-1204(ra) # 80005a56 <consputc>
      break;
    80005f12:	b5ed                	j	80005dfc <printf+0x9a>
  if(locking)
    80005f14:	020d9163          	bnez	s11,80005f36 <printf+0x1d4>
}
    80005f18:	70e6                	ld	ra,120(sp)
    80005f1a:	7446                	ld	s0,112(sp)
    80005f1c:	74a6                	ld	s1,104(sp)
    80005f1e:	7906                	ld	s2,96(sp)
    80005f20:	69e6                	ld	s3,88(sp)
    80005f22:	6a46                	ld	s4,80(sp)
    80005f24:	6aa6                	ld	s5,72(sp)
    80005f26:	6b06                	ld	s6,64(sp)
    80005f28:	7be2                	ld	s7,56(sp)
    80005f2a:	7c42                	ld	s8,48(sp)
    80005f2c:	7ca2                	ld	s9,40(sp)
    80005f2e:	7d02                	ld	s10,32(sp)
    80005f30:	6de2                	ld	s11,24(sp)
    80005f32:	6129                	addi	sp,sp,192
    80005f34:	8082                	ret
    release(&pr.lock);
    80005f36:	00040517          	auipc	a0,0x40
    80005f3a:	2b250513          	addi	a0,a0,690 # 800461e8 <pr>
    80005f3e:	00000097          	auipc	ra,0x0
    80005f42:	3d8080e7          	jalr	984(ra) # 80006316 <release>
}
    80005f46:	bfc9                	j	80005f18 <printf+0x1b6>

0000000080005f48 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005f48:	1101                	addi	sp,sp,-32
    80005f4a:	ec06                	sd	ra,24(sp)
    80005f4c:	e822                	sd	s0,16(sp)
    80005f4e:	e426                	sd	s1,8(sp)
    80005f50:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005f52:	00040497          	auipc	s1,0x40
    80005f56:	29648493          	addi	s1,s1,662 # 800461e8 <pr>
    80005f5a:	00003597          	auipc	a1,0x3
    80005f5e:	92658593          	addi	a1,a1,-1754 # 80008880 <syscalls+0x3f0>
    80005f62:	8526                	mv	a0,s1
    80005f64:	00000097          	auipc	ra,0x0
    80005f68:	26e080e7          	jalr	622(ra) # 800061d2 <initlock>
  pr.locking = 1;
    80005f6c:	4785                	li	a5,1
    80005f6e:	cc9c                	sw	a5,24(s1)
}
    80005f70:	60e2                	ld	ra,24(sp)
    80005f72:	6442                	ld	s0,16(sp)
    80005f74:	64a2                	ld	s1,8(sp)
    80005f76:	6105                	addi	sp,sp,32
    80005f78:	8082                	ret

0000000080005f7a <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005f7a:	1141                	addi	sp,sp,-16
    80005f7c:	e406                	sd	ra,8(sp)
    80005f7e:	e022                	sd	s0,0(sp)
    80005f80:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005f82:	100007b7          	lui	a5,0x10000
    80005f86:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005f8a:	f8000713          	li	a4,-128
    80005f8e:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005f92:	470d                	li	a4,3
    80005f94:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005f98:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005f9c:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005fa0:	469d                	li	a3,7
    80005fa2:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005fa6:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005faa:	00003597          	auipc	a1,0x3
    80005fae:	8f658593          	addi	a1,a1,-1802 # 800088a0 <digits+0x18>
    80005fb2:	00040517          	auipc	a0,0x40
    80005fb6:	25650513          	addi	a0,a0,598 # 80046208 <uart_tx_lock>
    80005fba:	00000097          	auipc	ra,0x0
    80005fbe:	218080e7          	jalr	536(ra) # 800061d2 <initlock>
}
    80005fc2:	60a2                	ld	ra,8(sp)
    80005fc4:	6402                	ld	s0,0(sp)
    80005fc6:	0141                	addi	sp,sp,16
    80005fc8:	8082                	ret

0000000080005fca <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005fca:	1101                	addi	sp,sp,-32
    80005fcc:	ec06                	sd	ra,24(sp)
    80005fce:	e822                	sd	s0,16(sp)
    80005fd0:	e426                	sd	s1,8(sp)
    80005fd2:	1000                	addi	s0,sp,32
    80005fd4:	84aa                	mv	s1,a0
  push_off();
    80005fd6:	00000097          	auipc	ra,0x0
    80005fda:	240080e7          	jalr	576(ra) # 80006216 <push_off>

  if(panicked){
    80005fde:	00003797          	auipc	a5,0x3
    80005fe2:	03e7a783          	lw	a5,62(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005fe6:	10000737          	lui	a4,0x10000
  if(panicked){
    80005fea:	c391                	beqz	a5,80005fee <uartputc_sync+0x24>
    for(;;)
    80005fec:	a001                	j	80005fec <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005fee:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005ff2:	0ff7f793          	andi	a5,a5,255
    80005ff6:	0207f793          	andi	a5,a5,32
    80005ffa:	dbf5                	beqz	a5,80005fee <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005ffc:	0ff4f793          	andi	a5,s1,255
    80006000:	10000737          	lui	a4,0x10000
    80006004:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80006008:	00000097          	auipc	ra,0x0
    8000600c:	2ae080e7          	jalr	686(ra) # 800062b6 <pop_off>
}
    80006010:	60e2                	ld	ra,24(sp)
    80006012:	6442                	ld	s0,16(sp)
    80006014:	64a2                	ld	s1,8(sp)
    80006016:	6105                	addi	sp,sp,32
    80006018:	8082                	ret

000000008000601a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000601a:	00003717          	auipc	a4,0x3
    8000601e:	00673703          	ld	a4,6(a4) # 80009020 <uart_tx_r>
    80006022:	00003797          	auipc	a5,0x3
    80006026:	0067b783          	ld	a5,6(a5) # 80009028 <uart_tx_w>
    8000602a:	06e78c63          	beq	a5,a4,800060a2 <uartstart+0x88>
{
    8000602e:	7139                	addi	sp,sp,-64
    80006030:	fc06                	sd	ra,56(sp)
    80006032:	f822                	sd	s0,48(sp)
    80006034:	f426                	sd	s1,40(sp)
    80006036:	f04a                	sd	s2,32(sp)
    80006038:	ec4e                	sd	s3,24(sp)
    8000603a:	e852                	sd	s4,16(sp)
    8000603c:	e456                	sd	s5,8(sp)
    8000603e:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006040:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006044:	00040a17          	auipc	s4,0x40
    80006048:	1c4a0a13          	addi	s4,s4,452 # 80046208 <uart_tx_lock>
    uart_tx_r += 1;
    8000604c:	00003497          	auipc	s1,0x3
    80006050:	fd448493          	addi	s1,s1,-44 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006054:	00003997          	auipc	s3,0x3
    80006058:	fd498993          	addi	s3,s3,-44 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000605c:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006060:	0ff7f793          	andi	a5,a5,255
    80006064:	0207f793          	andi	a5,a5,32
    80006068:	c785                	beqz	a5,80006090 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000606a:	01f77793          	andi	a5,a4,31
    8000606e:	97d2                	add	a5,a5,s4
    80006070:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80006074:	0705                	addi	a4,a4,1
    80006076:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006078:	8526                	mv	a0,s1
    8000607a:	ffffb097          	auipc	ra,0xffffb
    8000607e:	6f0080e7          	jalr	1776(ra) # 8000176a <wakeup>
    
    WriteReg(THR, c);
    80006082:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006086:	6098                	ld	a4,0(s1)
    80006088:	0009b783          	ld	a5,0(s3)
    8000608c:	fce798e3          	bne	a5,a4,8000605c <uartstart+0x42>
  }
}
    80006090:	70e2                	ld	ra,56(sp)
    80006092:	7442                	ld	s0,48(sp)
    80006094:	74a2                	ld	s1,40(sp)
    80006096:	7902                	ld	s2,32(sp)
    80006098:	69e2                	ld	s3,24(sp)
    8000609a:	6a42                	ld	s4,16(sp)
    8000609c:	6aa2                	ld	s5,8(sp)
    8000609e:	6121                	addi	sp,sp,64
    800060a0:	8082                	ret
    800060a2:	8082                	ret

00000000800060a4 <uartputc>:
{
    800060a4:	7179                	addi	sp,sp,-48
    800060a6:	f406                	sd	ra,40(sp)
    800060a8:	f022                	sd	s0,32(sp)
    800060aa:	ec26                	sd	s1,24(sp)
    800060ac:	e84a                	sd	s2,16(sp)
    800060ae:	e44e                	sd	s3,8(sp)
    800060b0:	e052                	sd	s4,0(sp)
    800060b2:	1800                	addi	s0,sp,48
    800060b4:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    800060b6:	00040517          	auipc	a0,0x40
    800060ba:	15250513          	addi	a0,a0,338 # 80046208 <uart_tx_lock>
    800060be:	00000097          	auipc	ra,0x0
    800060c2:	1a4080e7          	jalr	420(ra) # 80006262 <acquire>
  if(panicked){
    800060c6:	00003797          	auipc	a5,0x3
    800060ca:	f567a783          	lw	a5,-170(a5) # 8000901c <panicked>
    800060ce:	c391                	beqz	a5,800060d2 <uartputc+0x2e>
    for(;;)
    800060d0:	a001                	j	800060d0 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800060d2:	00003797          	auipc	a5,0x3
    800060d6:	f567b783          	ld	a5,-170(a5) # 80009028 <uart_tx_w>
    800060da:	00003717          	auipc	a4,0x3
    800060de:	f4673703          	ld	a4,-186(a4) # 80009020 <uart_tx_r>
    800060e2:	02070713          	addi	a4,a4,32
    800060e6:	02f71b63          	bne	a4,a5,8000611c <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    800060ea:	00040a17          	auipc	s4,0x40
    800060ee:	11ea0a13          	addi	s4,s4,286 # 80046208 <uart_tx_lock>
    800060f2:	00003497          	auipc	s1,0x3
    800060f6:	f2e48493          	addi	s1,s1,-210 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800060fa:	00003917          	auipc	s2,0x3
    800060fe:	f2e90913          	addi	s2,s2,-210 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006102:	85d2                	mv	a1,s4
    80006104:	8526                	mv	a0,s1
    80006106:	ffffb097          	auipc	ra,0xffffb
    8000610a:	4d8080e7          	jalr	1240(ra) # 800015de <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000610e:	00093783          	ld	a5,0(s2)
    80006112:	6098                	ld	a4,0(s1)
    80006114:	02070713          	addi	a4,a4,32
    80006118:	fef705e3          	beq	a4,a5,80006102 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000611c:	00040497          	auipc	s1,0x40
    80006120:	0ec48493          	addi	s1,s1,236 # 80046208 <uart_tx_lock>
    80006124:	01f7f713          	andi	a4,a5,31
    80006128:	9726                	add	a4,a4,s1
    8000612a:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    8000612e:	0785                	addi	a5,a5,1
    80006130:	00003717          	auipc	a4,0x3
    80006134:	eef73c23          	sd	a5,-264(a4) # 80009028 <uart_tx_w>
      uartstart();
    80006138:	00000097          	auipc	ra,0x0
    8000613c:	ee2080e7          	jalr	-286(ra) # 8000601a <uartstart>
      release(&uart_tx_lock);
    80006140:	8526                	mv	a0,s1
    80006142:	00000097          	auipc	ra,0x0
    80006146:	1d4080e7          	jalr	468(ra) # 80006316 <release>
}
    8000614a:	70a2                	ld	ra,40(sp)
    8000614c:	7402                	ld	s0,32(sp)
    8000614e:	64e2                	ld	s1,24(sp)
    80006150:	6942                	ld	s2,16(sp)
    80006152:	69a2                	ld	s3,8(sp)
    80006154:	6a02                	ld	s4,0(sp)
    80006156:	6145                	addi	sp,sp,48
    80006158:	8082                	ret

000000008000615a <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000615a:	1141                	addi	sp,sp,-16
    8000615c:	e422                	sd	s0,8(sp)
    8000615e:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006160:	100007b7          	lui	a5,0x10000
    80006164:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006168:	8b85                	andi	a5,a5,1
    8000616a:	cb91                	beqz	a5,8000617e <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    8000616c:	100007b7          	lui	a5,0x10000
    80006170:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80006174:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006178:	6422                	ld	s0,8(sp)
    8000617a:	0141                	addi	sp,sp,16
    8000617c:	8082                	ret
    return -1;
    8000617e:	557d                	li	a0,-1
    80006180:	bfe5                	j	80006178 <uartgetc+0x1e>

0000000080006182 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006182:	1101                	addi	sp,sp,-32
    80006184:	ec06                	sd	ra,24(sp)
    80006186:	e822                	sd	s0,16(sp)
    80006188:	e426                	sd	s1,8(sp)
    8000618a:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000618c:	54fd                	li	s1,-1
    int c = uartgetc();
    8000618e:	00000097          	auipc	ra,0x0
    80006192:	fcc080e7          	jalr	-52(ra) # 8000615a <uartgetc>
    if(c == -1)
    80006196:	00950763          	beq	a0,s1,800061a4 <uartintr+0x22>
      break;
    consoleintr(c);
    8000619a:	00000097          	auipc	ra,0x0
    8000619e:	8fe080e7          	jalr	-1794(ra) # 80005a98 <consoleintr>
  while(1){
    800061a2:	b7f5                	j	8000618e <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800061a4:	00040497          	auipc	s1,0x40
    800061a8:	06448493          	addi	s1,s1,100 # 80046208 <uart_tx_lock>
    800061ac:	8526                	mv	a0,s1
    800061ae:	00000097          	auipc	ra,0x0
    800061b2:	0b4080e7          	jalr	180(ra) # 80006262 <acquire>
  uartstart();
    800061b6:	00000097          	auipc	ra,0x0
    800061ba:	e64080e7          	jalr	-412(ra) # 8000601a <uartstart>
  release(&uart_tx_lock);
    800061be:	8526                	mv	a0,s1
    800061c0:	00000097          	auipc	ra,0x0
    800061c4:	156080e7          	jalr	342(ra) # 80006316 <release>
}
    800061c8:	60e2                	ld	ra,24(sp)
    800061ca:	6442                	ld	s0,16(sp)
    800061cc:	64a2                	ld	s1,8(sp)
    800061ce:	6105                	addi	sp,sp,32
    800061d0:	8082                	ret

00000000800061d2 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800061d2:	1141                	addi	sp,sp,-16
    800061d4:	e422                	sd	s0,8(sp)
    800061d6:	0800                	addi	s0,sp,16
  lk->name = name;
    800061d8:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800061da:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800061de:	00053823          	sd	zero,16(a0)
}
    800061e2:	6422                	ld	s0,8(sp)
    800061e4:	0141                	addi	sp,sp,16
    800061e6:	8082                	ret

00000000800061e8 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800061e8:	411c                	lw	a5,0(a0)
    800061ea:	e399                	bnez	a5,800061f0 <holding+0x8>
    800061ec:	4501                	li	a0,0
  return r;
}
    800061ee:	8082                	ret
{
    800061f0:	1101                	addi	sp,sp,-32
    800061f2:	ec06                	sd	ra,24(sp)
    800061f4:	e822                	sd	s0,16(sp)
    800061f6:	e426                	sd	s1,8(sp)
    800061f8:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800061fa:	6904                	ld	s1,16(a0)
    800061fc:	ffffb097          	auipc	ra,0xffffb
    80006200:	d0a080e7          	jalr	-758(ra) # 80000f06 <mycpu>
    80006204:	40a48533          	sub	a0,s1,a0
    80006208:	00153513          	seqz	a0,a0
}
    8000620c:	60e2                	ld	ra,24(sp)
    8000620e:	6442                	ld	s0,16(sp)
    80006210:	64a2                	ld	s1,8(sp)
    80006212:	6105                	addi	sp,sp,32
    80006214:	8082                	ret

0000000080006216 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006216:	1101                	addi	sp,sp,-32
    80006218:	ec06                	sd	ra,24(sp)
    8000621a:	e822                	sd	s0,16(sp)
    8000621c:	e426                	sd	s1,8(sp)
    8000621e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80006220:	100024f3          	csrr	s1,sstatus
    80006224:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006228:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r"(x));
    8000622a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000622e:	ffffb097          	auipc	ra,0xffffb
    80006232:	cd8080e7          	jalr	-808(ra) # 80000f06 <mycpu>
    80006236:	5d3c                	lw	a5,120(a0)
    80006238:	cf89                	beqz	a5,80006252 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000623a:	ffffb097          	auipc	ra,0xffffb
    8000623e:	ccc080e7          	jalr	-820(ra) # 80000f06 <mycpu>
    80006242:	5d3c                	lw	a5,120(a0)
    80006244:	2785                	addiw	a5,a5,1
    80006246:	dd3c                	sw	a5,120(a0)
}
    80006248:	60e2                	ld	ra,24(sp)
    8000624a:	6442                	ld	s0,16(sp)
    8000624c:	64a2                	ld	s1,8(sp)
    8000624e:	6105                	addi	sp,sp,32
    80006250:	8082                	ret
    mycpu()->intena = old;
    80006252:	ffffb097          	auipc	ra,0xffffb
    80006256:	cb4080e7          	jalr	-844(ra) # 80000f06 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000625a:	8085                	srli	s1,s1,0x1
    8000625c:	8885                	andi	s1,s1,1
    8000625e:	dd64                	sw	s1,124(a0)
    80006260:	bfe9                	j	8000623a <push_off+0x24>

0000000080006262 <acquire>:
{
    80006262:	1101                	addi	sp,sp,-32
    80006264:	ec06                	sd	ra,24(sp)
    80006266:	e822                	sd	s0,16(sp)
    80006268:	e426                	sd	s1,8(sp)
    8000626a:	1000                	addi	s0,sp,32
    8000626c:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000626e:	00000097          	auipc	ra,0x0
    80006272:	fa8080e7          	jalr	-88(ra) # 80006216 <push_off>
  if(holding(lk))
    80006276:	8526                	mv	a0,s1
    80006278:	00000097          	auipc	ra,0x0
    8000627c:	f70080e7          	jalr	-144(ra) # 800061e8 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006280:	4705                	li	a4,1
  if(holding(lk))
    80006282:	e115                	bnez	a0,800062a6 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006284:	87ba                	mv	a5,a4
    80006286:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000628a:	2781                	sext.w	a5,a5
    8000628c:	ffe5                	bnez	a5,80006284 <acquire+0x22>
  __sync_synchronize();
    8000628e:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006292:	ffffb097          	auipc	ra,0xffffb
    80006296:	c74080e7          	jalr	-908(ra) # 80000f06 <mycpu>
    8000629a:	e888                	sd	a0,16(s1)
}
    8000629c:	60e2                	ld	ra,24(sp)
    8000629e:	6442                	ld	s0,16(sp)
    800062a0:	64a2                	ld	s1,8(sp)
    800062a2:	6105                	addi	sp,sp,32
    800062a4:	8082                	ret
    panic("acquire");
    800062a6:	00002517          	auipc	a0,0x2
    800062aa:	60250513          	addi	a0,a0,1538 # 800088a8 <digits+0x20>
    800062ae:	00000097          	auipc	ra,0x0
    800062b2:	a6a080e7          	jalr	-1430(ra) # 80005d18 <panic>

00000000800062b6 <pop_off>:

void
pop_off(void)
{
    800062b6:	1141                	addi	sp,sp,-16
    800062b8:	e406                	sd	ra,8(sp)
    800062ba:	e022                	sd	s0,0(sp)
    800062bc:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800062be:	ffffb097          	auipc	ra,0xffffb
    800062c2:	c48080e7          	jalr	-952(ra) # 80000f06 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800062c6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800062ca:	8b89                	andi	a5,a5,2
  if(intr_get())
    800062cc:	e78d                	bnez	a5,800062f6 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800062ce:	5d3c                	lw	a5,120(a0)
    800062d0:	02f05b63          	blez	a5,80006306 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800062d4:	37fd                	addiw	a5,a5,-1
    800062d6:	0007871b          	sext.w	a4,a5
    800062da:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800062dc:	eb09                	bnez	a4,800062ee <pop_off+0x38>
    800062de:	5d7c                	lw	a5,124(a0)
    800062e0:	c799                	beqz	a5,800062ee <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800062e2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800062e6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    800062ea:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800062ee:	60a2                	ld	ra,8(sp)
    800062f0:	6402                	ld	s0,0(sp)
    800062f2:	0141                	addi	sp,sp,16
    800062f4:	8082                	ret
    panic("pop_off - interruptible");
    800062f6:	00002517          	auipc	a0,0x2
    800062fa:	5ba50513          	addi	a0,a0,1466 # 800088b0 <digits+0x28>
    800062fe:	00000097          	auipc	ra,0x0
    80006302:	a1a080e7          	jalr	-1510(ra) # 80005d18 <panic>
    panic("pop_off");
    80006306:	00002517          	auipc	a0,0x2
    8000630a:	5c250513          	addi	a0,a0,1474 # 800088c8 <digits+0x40>
    8000630e:	00000097          	auipc	ra,0x0
    80006312:	a0a080e7          	jalr	-1526(ra) # 80005d18 <panic>

0000000080006316 <release>:
{
    80006316:	1101                	addi	sp,sp,-32
    80006318:	ec06                	sd	ra,24(sp)
    8000631a:	e822                	sd	s0,16(sp)
    8000631c:	e426                	sd	s1,8(sp)
    8000631e:	1000                	addi	s0,sp,32
    80006320:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006322:	00000097          	auipc	ra,0x0
    80006326:	ec6080e7          	jalr	-314(ra) # 800061e8 <holding>
    8000632a:	c115                	beqz	a0,8000634e <release+0x38>
  lk->cpu = 0;
    8000632c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006330:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006334:	0f50000f          	fence	iorw,ow
    80006338:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000633c:	00000097          	auipc	ra,0x0
    80006340:	f7a080e7          	jalr	-134(ra) # 800062b6 <pop_off>
}
    80006344:	60e2                	ld	ra,24(sp)
    80006346:	6442                	ld	s0,16(sp)
    80006348:	64a2                	ld	s1,8(sp)
    8000634a:	6105                	addi	sp,sp,32
    8000634c:	8082                	ret
    panic("release");
    8000634e:	00002517          	auipc	a0,0x2
    80006352:	58250513          	addi	a0,a0,1410 # 800088d0 <digits+0x48>
    80006356:	00000097          	auipc	ra,0x0
    8000635a:	9c2080e7          	jalr	-1598(ra) # 80005d18 <panic>
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
