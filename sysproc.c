#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int sys_exitStatus(void) //cs153_lab1: exitStatus
{
	int arg;

	if (argint(0, &arg) < 0)
		exitStatus(1); //didn't receive an argument, so I'm forcefully sending a one
	else
		exitStatus(arg);

	return 0; //not reached
}

int
sys_wait(void)
{
  return wait();
}

int sys_waitStatus(void) //cs153_lab1: waitStatus
{
	int* argPtr;

	if (argptr(0, (void*)&argPtr, sizeof(int)) < 0)
		return -1;
	else
		return waitStatus(argPtr);
}

int sys_waitpid(void) //cs153_lab1: waitpid
{
	int pid, options, argInt1, argInt2, argPtr;
	int* status;

	argInt1 = argint(0, &pid);
	argPtr = argptr(1, (void*)&status, sizeof(int));
	argInt2 = argint(2, &options);

	if (argInt1 < 0 || argPtr < 0 || argInt2 < 0)
		return -1;
	else
		return waitpid(pid, status, options);
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}
