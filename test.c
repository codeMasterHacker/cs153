#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[])
{
  int i, j;
  int beginningPriority = 10;
  const int loop = 43000;

  setPrior(beginningPriority); // set a priority value

  for (i = 0; i < loop; i++) 
  {
    asm("nop");
    
    for (j = 0; j < loop; j++)
      asm("nop");
  }

  printf(1, "Program 0 with pid %d ended.\n",  getpid());
  printf(1, "Beginning priority: %d\n", beginningPriority);

  exitStatus(0); 
 
  return 0;
}
