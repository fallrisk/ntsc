/*
 * blink.asm
 *
 *  Created: 2014-09-18 10:00:55 AM
 *   Author: Justin
 */ 

/*
 * PC7 is the LED pin.
 */

.cseg
setup:
clr r16
ldi r16,0x80 // Set PINC to output.
st 0x27,r16 // Load r16 into the address 0x27 PORTC.
loop:
// Toggle the LED pin.
clr r16
ld r16,0x08
cpi r16,0x80
breq ledhigh
ledlow:
andi r16,0x7f
out 0x08,r16
jmp delay
ledhigh:
ori r16,0x80
out 0x08,r16
delay:
ldi r17,0
ldi r18,1
delayloop:
cpi r17,1000
breq delayend
add r17,r18
rjmp 0 // Dummy function call to delay.
jmp delayloop
delayend:
jmp loop
