#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#define DEBUG               (0)

typedef struct __attribute__((packed)) data_t
{
    uint8_t     num;
    uint8_t     num_sq;
} data_t;

typedef struct __attribute__((packed)) hdr_t
{
    uint32_t        pattern;
    uint8_t         index;
    uint8_t         total;
} hdr_t;

typedef struct __attribute__((packed)) buffer_t
{
    hdr_t           hdr;
    data_t          data_sets[];
} buffer_t;

#define PAINT_PATTERN       (0xabababab)
#define TOTAL_SIZE(x)       (sizeof(hdr_t) + x * sizeof(data_t))

void debug_print(buffer_t *pBuf)
{
#if DEBUG
    if (pBuf)
    {
        printf("0x%x, %d, %d:", pBuf->hdr.pattern, pBuf->hdr.total, pBuf->hdr.index);
        for (uint16_t i = 0; i < pBuf->hdr.total; i++)
        {
            if (pBuf->data_sets[i].num != 0xab)
                printf(" %d %d,", pBuf->data_sets[i].num, pBuf->data_sets[i].num_sq);
            else
                printf(" %x %x,", pBuf->data_sets[i].num, pBuf->data_sets[i].num_sq);
        }
        printf("\n");
    }
#endif
}

void init_buffer(buffer_t *pBuf, uint32_t size)
{
    if (pBuf)
    {
        memset((void *)pBuf, PAINT_PATTERN, size);
        pBuf->hdr.index = 0;
        pBuf->hdr.total = (size - sizeof(hdr_t))/sizeof(data_t);
#if DEBUG
        printf("size: %d\n", size);
        printf("%d, %d\n", (uint32_t)sizeof(hdr_t), (uint32_t)sizeof(data_t));
        debug_print(pBuf);
#endif
    }
}

void write_buffer(buffer_t *pBuf, uint8_t new_data)
{
    if (pBuf)
    {
        if (pBuf->hdr.pattern != PAINT_PATTERN)
        {
            return;
        }

        if (pBuf->hdr.index >= pBuf->hdr.total)
        {
            pBuf->hdr.index = 0;
        }

        pBuf->data_sets[pBuf->hdr.index] = (data_t){.num = new_data, .num_sq = new_data * 2};
#if DEBUG
        printf("%d written to index %d\n", new_data, pBuf->hdr.index);
#endif
        pBuf->hdr.index++;
    }

    debug_print(pBuf);
}

void print_buffer(buffer_t *pBuf)
{
    if (pBuf)
    {
        if (pBuf->hdr.pattern != PAINT_PATTERN)
        {
            return;
        }

        uint8_t start_index = pBuf->hdr.index;
        uint8_t count;
        uint8_t i;

        for (count = start_index; count < pBuf->hdr.total; count++)
        {
            if (pBuf->data_sets[count].num == (uint8_t)PAINT_PATTERN)
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
            printf("%d, ", pBuf->data_sets[i].num);
        }

        for (i = 0; i < start_index; i++)
        {
            printf("%d, ", pBuf->data_sets[i].num);
        }
        printf("\n");
    }
}

int main()
{
    buffer_t *pBuf = malloc(TOTAL_SIZE(10));
    init_buffer(pBuf, TOTAL_SIZE(10));

    write_buffer(pBuf, 45);
    write_buffer(pBuf, 46);
    write_buffer(pBuf, 47);
    write_buffer(pBuf, 48);
    write_buffer(pBuf, 49);
    write_buffer(pBuf, 50);
    write_buffer(pBuf, 51);
    write_buffer(pBuf, 52);
    write_buffer(pBuf, 53);
    write_buffer(pBuf, 54);

    print_buffer(pBuf);

    write_buffer(pBuf, 55);
    write_buffer(pBuf, 56);

    print_buffer(pBuf);

    init_buffer(pBuf, TOTAL_SIZE(10));

    write_buffer(pBuf, 75);
    write_buffer(pBuf, 76);
    write_buffer(pBuf, 77);
    write_buffer(pBuf, 78);
    write_buffer(pBuf, 79);

    print_buffer(pBuf);

    return 0;
}
