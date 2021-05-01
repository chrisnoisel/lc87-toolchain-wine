#include <stdio.h>

void main( void )
{
    int i, a = 0, b = 1;
    int next = a + b;
    
    printf("Fibonacci : %d, %d", a, b);

    for (i = 1; i <= 20; ++i) {
        printf(", %d", next);
        a = b;
        b = next;
        next = a + b;
    }
}

// dummy interrupt definition
void _interrupt( 0x03 ) testINT( void )
{
	_nop();
}
