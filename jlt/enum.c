#include <stdio.h>
#include <stdint.h>
#include <string.h>

typedef enum my_enum
{
    VALUE_1 = 1,
    VALUE_4 = 4,
    VALUE_5 = 5,
    VALUE_8 = 8,
    VALUE_10 = 10,
} my_enum;

typedef struct test_struct
{
    my_enum     value;
    uint32_t    param1;
    uint32_t    param2;
} test_struct;

static void init_struct(test_struct *p)
{
    if (p)
    {
        p->value = VALUE_5;
        p->param1 = 0xdead;
        p->param2 = 0xbeef;
    }
}

int main()
{
    test_struct params;

    memset(&params, 0, sizeof(test_struct));
    init_struct(&params);

    printf("value: %d\n", params.value);
    printf("param1: %x\n", params.param1);
    printf("param2: %x\n", params.param2);

    return 0;
}
