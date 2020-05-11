#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[])
{
  int i, j, pid1, pid2, pid3;
  const int loop = 1000;

  pid1 = fork();
  if (!pid1) //child1
  {
    for (i = 0; i < loop; i++)
    {
      asm("nop");

      for (j = 0; j < loop; j++)
        asm("nop");
    }

    exit();    

    printf(1, "Child 1 ended.\n");
    printf(1, "Beginning priority: %d\n", beginningPriority);
    printf(1, "Ending priority: %d\n", getPrior());
    printf(1, "Turn time: %d\n", getTurnTime());
    printf(1, "Wait time: %d\n", getWaitTime());
  }
  else //parent
  {
    pid2 = fork();
    if (!pid2) //child2
    {
      for (i = 0; i < loop; i++)
      {
        asm("nop");

        for (j = 0; j < loop; j++)
          asm("nop");
      }

      exit();

      printf(1, "Child 2 ended.\n");
      printf(1, "Beginning priority: %d\n", beginningPriority);
      printf(1, "Ending priority: %d\n", getPrior());
      printf(1, "Turn time: %d\n", getTurnTime());
      printf(1, "Wait time: %d\n", getWaitTime());
    }
    else //parent
    {
      pid3 = fork();
      if (!pid3) //child
      {
        for (i = 0; i < loop; i++)
        {
          asm("nop");

          for (j = 0; j < loop; j++)
            asm("nop");
        }

        exit();

        printf(1, "Child 3 ended.\n");
        printf(1, "Beginning priority: %d\n", beginningPriority);
        printf(1, "Ending priority: %d\n", getPrior());
        printf(1, "Turn time: %d\n", getTurnTime());
        printf(1, "Wait time: %d\n", getWaitTime());
      }
    }
  }

  setPrior(beginningPriority); // set a priority value

  for (i = 0; i < loop; i++)
  {
    asm("nop");

    for (j = 0; j < loop; j++)
      asm("nop");
  }

  printf(1, "Program 0 with pid %d ended.\n",  getpid());
  printf(1, "Beginning priority: %d\n", beginningPriority);
  printf(1, "Ending priority: %d\n", getPrior());
  printf(1, "Turn time: %d\n", getTurnTime());
  printf(1, "Wait time: %d\n", getWaitTime());

  exit();

  return 0;
}
