#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#define DEBUG               (0)
#define PAINT_PATTERN       (0xabababab)
#define SIZE_HDR            (sizeof(uint32_t) + sizeof(uint16_t))
#define SIZE_TOTAL          (16)

uint8_t  *c_buffer;

void init_buffer()
{
    if (c_buffer)
    {
        uint16_t *p = (uint16_t *)c_buffer;
        memset((void *)p, PAINT_PATTERN, SIZE_TOTAL);
        p += 2;
        *p = 0;
    }
}

void debug_print()
{
#if DEBUG
    if (c_buffer)
    {
        for (uint8_t i = 0; i < SIZE_TOTAL; i++)
        {
            uint8_t byte = *(c_buffer + i);

            if (byte == 0xab) printf("%x, ", byte);
            else printf("%d, ", byte);
        }
        printf("\n");
    }
#endif
}

void write_buffer(uint8_t new_data)
{
    if (c_buffer)
    {
        uint16_t *p = (uint16_t *)c_buffer;

        if (*((uint32_t *)p) != PAINT_PATTERN)
        {
            return;
        }

        p += 2;
        if ((*p + sizeof(uint8_t) + SIZE_HDR) > SIZE_TOTAL)
        {
            *p = 0;
        }

        *(c_buffer + SIZE_HDR + (*p * sizeof(uint8_t))) = new_data;
#if DEBUG
        printf("%d written to index %d\n", new_data, *p);
#endif
        (*p)++;
    }

    debug_print();
}

void print_buffer()
{
    if (c_buffer)
    {

        uint16_t *p = (uint16_t *)c_buffer;

        if (*((uint32_t *)p) != PAINT_PATTERN)
        {
            return;
        }

        p += 2;
        uint16_t start_index = *p;
        uint16_t count;
        uint16_t i;

        uint8_t *p_buf = (uint8_t *)(c_buffer + SIZE_HDR);

        for (count = start_index; count < (SIZE_TOTAL - SIZE_HDR); count++)
        {
            if ((*(p_buf + count*sizeof(uint8_t)) & 0xff) == (PAINT_PATTERN & 0xff))
            {
                start_index = 0;
                break;
            }
        }

#if DEBUG
        printf("%d\t%d\n", start_index, count);
#endif

        for (i = start_index; i < count; i++)
        {
            printf("%d, ", *(p_buf + i*sizeof(uint8_t)));
        }

        for (i = 0; i < start_index; i++)
        {
            printf("%d, ", *(p_buf + i*sizeof(uint8_t)));
        }
        printf("\n");
    }
}

int main()
{
    c_buffer = malloc(52);
    init_buffer();

    write_buffer(45);
    write_buffer(46);
    write_buffer(47);
    write_buffer(48);
    write_buffer(49);
    write_buffer(50);
    write_buffer(51);
    write_buffer(52);
    write_buffer(53);
    write_buffer(54);

    print_buffer();

    write_buffer(55);
    write_buffer(56);

    print_buffer();

    init_buffer();

    write_buffer(75);
    write_buffer(76);
    write_buffer(77);
    write_buffer(78);
    write_buffer(79);

    print_buffer();

    return 0;
}
