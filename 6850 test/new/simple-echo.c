#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#define SER_BUFSIZE 0x3F
#define SER_FULLSIZE 0x30
#define SER_EMPTYSIZE 5
#define RTS_HIGH 0xD6
#define RTS_LOW 0x96

uint16_t serBuf = 0x2000;
uint16_t serInPtr = serBuf + SER_BUFSIZE;
uint16_t serRdPtr = serInPtr + 2;
uint16_t serBufUsed = serRdPtr + 2;
uint16_t TEMPSTACK = 0x20ED;

void init(void) {
// Initialize Hardware
}

void serialInt(void) {
uint8_t a;
uint16_t hl;

a = inb(0x80);
if (!(a & 0x01)) {
return;
}

a = inb(0x81);
hl = serBufUsed;
if (hl == SER_BUFSIZE) {
return;
}

hl = serInPtr;
hl++;
if (hl == (serBuf + SER_BUFSIZE)) {
hl = serBuf;
}
serInPtr = hl;
*hl = a;
hl = serBufUsed;
hl++;
serBufUsed = hl;
if (hl == SER_FULLSIZE) {
outb(RTS_HIGH, 0x80);
}
}

uint8_t rxa(void) {
uint16_t hl;

while (serBufUsed == 0) {
// wait for character
}

hl = serRdPtr;
hl++;
if (hl == (serBuf + SER_BUFSIZE)) {
hl = serBuf;
}
serRdPtr = hl;
serBufUsed--;
if (serBufUsed == SER_EMPTYSIZE) {
outb(RTS_LOW, 0x80);
}
return *hl;
}

void txa(uint8_t a) {
// Store character
while (inb(0x80) & 0x02) {
// wait until flag signals ready
}
outb(a, 0x81);
}

int ckinchar(void) {
return serBufUsed > 0;
}

void print(uint8_t *str) {
uint8_t a;
while ((a = *str++)) {
txa(a);
}
}

int main(void) {
init();
while (1) {
if (ckinchar()) {
uint8_t ch = rxa();
print("You typed: ");
txa(ch);
print("\r\n");
}
}
return 0;
}
