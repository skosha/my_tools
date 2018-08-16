#include <stdio.h>
#include <stdint.h>
#include <string.h>

int main()
{
    char *filter_str = "mlme_";
    char *name_str[2] = {"macrame_fsm", "mlme_fsm"};
    uint8_t i;

    printf("%d len of %s\n", (int)strlen(filter_str), filter_str);

    for (i = 0; i < 2; i++)
    {
        if (strncmp(name_str[i], filter_str, strlen(filter_str)))
        {
            continue;
        }

        printf("%s\n", name_str[i]);
    }

    return 0;
}
