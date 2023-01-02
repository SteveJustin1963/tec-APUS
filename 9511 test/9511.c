; Note that this code uses the outb and inb functions to access the I/O ports. 
; These functions are not part of the C standard and may need to be implemented differently 
; depending on the platform and compiler you are using. 
; You may also need to include additional headers or libraries to use these functions.

  #include <stdio.h>

#define DATA_PORT 0x10
#define COMMAND_PORT 0x11
#define STATUS_PORT 0x12

#define BUSY 0x80
#define SIGN 0x40
#define ZERO 0x20
#define ERROR_MASK 0x1E
#define CARRY 0x01

#define SADD 0x6C

int main(void)
{
    int arg1 = 1, arg2 = 1, result = 0;
    unsigned char error = 0;

    while (1)
    {
        // Push data
        outb(DATA_PORT, (unsigned char)arg1);
        outb(DATA_PORT, (unsigned char)(arg1 >> 8));
        outb(DATA_PORT, (unsigned char)arg2);
        outb(DATA_PORT, (unsigned char)(arg2 >> 8));

        // Send command
        outb(COMMAND_PORT, SADD);

        // Wait for result
        while (inb(STATUS_PORT) & BUSY);

        // Get error code
        error = (inb(STATUS_PORT) & ERROR_MASK) >> 1;

        // Get result
        result = inb(DATA_PORT);
        result |= (inb(DATA_PORT) << 8);

        // Store result
        printf("Result: %d\n", result);

        // Wait for key press
        getchar();
    }

    return 0;
}




