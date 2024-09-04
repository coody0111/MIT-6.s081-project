// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"
extern int ref_count[];
int ref_count[(PHYSTOP - KERNBASE) / PGSIZE];

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run
{
  struct run *next;
};

struct
{
  struct spinlock lock;
  struct run *freelist;
} kmem;

void kinit()
{
  initlock(&kmem.lock, "kmem");
  freerange(end, (void *)PHYSTOP);
}

void freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char *)PGROUNDUP((uint64)pa_start);
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    kfree(p);
}

// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(void *pa)
{
  struct run *r;

  if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  // 檢查並減少引用計數
  int index = REFCOUNT_INDEX((uint64)pa);
  if (index >= 0 && index < sizeof(ref_count) / sizeof(ref_count[0]))
  {
    acquire(&kmem.lock);
    if (ref_count[index] > 0)
    {
      ref_count[index]--;
    }
    if (ref_count[index] == 0)
    {
      // 只有當引用計數為 0 時才真正釋放頁面
      // 填充垃圾數據
      memset(pa, 1, PGSIZE);

      r = (struct run *)pa;
      r->next = kmem.freelist;
      kmem.freelist = r;
    }
    release(&kmem.lock);
  }
  else
  {
    panic("kfree: ref_count index out of bounds");
  }
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  struct run *r;

  acquire(&kmem.lock);
  r = kmem.freelist;
  if (r)
  {
    kmem.freelist = r->next;

    // 初始化引用計數為 1
    int index = REFCOUNT_INDEX((uint64)r);
    if (index >= 0 && index < sizeof(ref_count) / sizeof(ref_count[0]))
    {
      ref_count[index] = 1;
    }
    else
    {
      panic("kalloc: ref_count index out of bounds");
    }
  }
  release(&kmem.lock);

  if (r)
    memset((char *)r, 5, PGSIZE); // fill with junk
  return (void *)r;
}
