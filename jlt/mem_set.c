#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

int main()
{
    uint8_t *buffer;
    uint16_t i;

    buffer = (char *)malloc(100);

    memset((void *)buffer, 0xABAB, 52);

    printf("0x");
    for (i = 0; i < 100; i++)
    {
        if (i == 52) printf("\n0x");
        printf("%02x", buffer[i]);
    }
    printf("\n");

    return 0;
}

