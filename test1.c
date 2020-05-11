#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[])
{
  int i, j;
  int beginningPriority = 20;
  const int loop = 1000;

  setPrior(beginningPriority); // set a priority value

  for (i = 0; i < loop; i++)
  {
    asm("nop");

    for (j = 0; j < loop; j++)
      asm("nop");
  }

  printf(1, "Program 1 with pid %d ended.\n",  getpid());
  printf(1, "Beginning priority: %d\n", beginningPriority);
  printf(1, "Ending priority: %d\n", getPrior());
  printf(1, "Turn time: %d\n", getTurnTime());
  printf(1, "Wait time: %d\n", getWaitTime());

  exit();
  return 0;
}
