#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char* argv[])
{
  int pid, wait, status;

  pid = fork();

  switch (pid)
  {
    case -1: printf(2, "Error in forking!\n"); exitStatus(1); break;

    case 0: printf(1, "Child process executed.\n"); exitStatus(5); break;

    default:
      wait = waitpid(pid, &status, 0);

      if (pid == wait)
        printf(1, "Process: %d terminated with exit status: %d\n", wait, status);

      break;
  }

  exitStatus(0);
  return 0;
}
