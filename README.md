# Operating System Implementation for RISC-V (MIT 6.S081 xv6)

![Course](https://img.shields.io/badge/course-MIT%206.S081-blue.svg)
![Architecture](https://img.shields.io/badge/architecture-RISC--V-green.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

This project is part of the MIT 6.S081 (Operating System Engineering) course, focusing on implementing an operating system based on the RISC-V architecture. Through a series of labs, we progressively build a fully functional Unix-like operating system kernel.

## Table of Contents

- [Project Overview](#project-overview)
- [Environment Setup](#environment-setup)
- [Lab Descriptions](#lab-descriptions)
- [Build and Run](#build-and-run)
- [References](#references)
- [License](#license)

## Project Overview

This project is based on xv6, an operating system designed for teaching purposes. By completing a series of labs, we will:

- Gain a deep understanding of core operating system concepts
- Implement basic system calls, process management, and virtual memory.
- Explore memory management and file systems
- Handle concurrency and synchronization issues
- Optimize system performance

## Environment Setup

### Prerequisites

- RISC-V toolchain
- QEMU emulator
- GDB debugger

### Installation Steps

1. Install RISC-V toolchain:
   ```
   sudo apt-get install gcc-riscv64-linux-gnu
   ```
2. Install QEMU
  ```c=
  sudo apt-get install qemu-system-riscv64
  ```
3. Clone the project repository:
  ```
  git clone https://github.com/mit-pdos/xv6-riscv.git
  cd xv6-riscv
  ```
## Lab Descriptions
### Lab 1: Unix Utilities

- Implement basic Unix commands (e.g., sleep, pingpong, primes, find, xargs)
- Learn to use xv6 system calls
- Understand process creation and inter-process communication
- Key concepts: fork(), exec(), pipe(), wait()

### Lab 2: System Calls

- Add new system calls to the xv6 kernel (e.g., trace, sysinfo)
- Understand the interaction between user space and kernel space
- Modify the kernel to track system call invocations
- Key concepts: syscall interface, kernel modifications, process tracing

### Lab 3: Page Tables

- Explore virtual memory management
- Implement page table manipulations
- Add new page table features (e.g., printing page tables, creating user-level mappings)
- Key concepts: virtual memory, page tables, memory-mapped I/O

### Lab 4: Traps

- Handle interrupts and exceptions
- Implement RISC-V privilege mode transitions
- Add support for user-level alarm (e.g., periodic signals to processes)
- Key concepts: trap handling, RISC-V CSRs, user-kernel transitions

### Lab 5: Lazy Allocation

- Implement lazy loading and copy-on-write fork
- Optimize memory usage by allocating pages only when needed
- Modify the page fault handler to support lazy allocation
- Key concepts: demand paging, copy-on-write, page fault handling

### Lab 6: Copy-on-Write Fork

- Implement copy-on-write (COW) fork to optimize process creation
- Modify the page fault handler to support COW
- Implement reference counting for shared pages
- Key concepts: COW, memory optimization, page sharing

### Lab 7: Multithreading

- Implement user-level threads
- Explore concurrent programming
- Add support for thread creation, switching, and synchronization
- Key concepts: context switching, thread scheduling, synchronization primitives

### Lab 8: Lock

- Implement and optimize synchronization primitives
- Solve concurrency problems in the xv6 kernel
- Improve parallelism in various subsystems (e.g., memory allocator, block cache)
- Key concepts: mutual exclusion, lock contention, fine-grained locking

### Lab 9: File System

- Enhance the xv6 file system
- Implement new features like large files, symbolic links
- Optimize file system performance
- Key concepts: inode structure, disk layout, file system consistency

### Lab 10: mmap

- Implement memory-mapped files
- Add support for mmap and munmap system calls
- Handle page faults for mapped regions
- Key concepts: memory mapping, demand paging, file-backed memory
