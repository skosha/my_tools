#include <stdio.h>
#include <stdint.h>

int main()
{
    uint8_t i;

    for (i = 0; i < 6; i++)
    {
        printf("%d\n", i);
        if (i > 4)
            break;
    }

    printf("%d\n", i);

    return 0;
}
