#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[])
{
    setPrior(10); // set a priority value

    int i, j;
    const int loop = 43000;

    for (i = 0; i < loop; i++) 
    {
        asm("nop");

        for (j = 0; j < loop; j++)
            asm("nop");
    }

    printf(1, "Program 0 finished with starting priority: %d\n", getPrior());

    exitStatus(0);
    return 0;
}
