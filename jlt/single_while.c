#include <stdio.h>
#include <stdint.h>
#include <string.h>

int main()
{
    uint32_t    len;
    char        input_string[] = {"Hello There!"};
    char        *p_str = input_string;

    len = 0;
    while (*(p_str + len++) != 0);

    printf("%d: %s\n", len, input_string);

    return 0;
}
