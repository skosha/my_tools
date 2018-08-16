#include <stdio.h>
#include <stdint.h>

#define ALLOWANCE       (0.05)
#define ALLOWANCE_PLUS(x)       ((uint32_t)(x * 1.05))
#define ALLOWANCE_MINUS(x)      ((uint32_t)(x * 0.95))

int main()
{
    uint32_t time = 0x45235722;

    printf("0x%08x --> 0x%08x\n", time, (uint32_t)(time * ALLOWANCE));
    printf("0x%08x --> 0x%08x\n", ALLOWANCE_PLUS(time), ALLOWANCE_MINUS(time));

    return 0;
}
