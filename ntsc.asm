
/*******************************************************************************
 * This program generates the NTSC signal.
 *
 * @author Justin Watson 
 *
 * 0 and 0 = 0 v
 * 450 off and 900 on 
 *
 *
 * 8-bit microcontroller
 ******************************************************************************/

/*
 * Pins, Page 411
 *  - PD4 is 450 ohm pin.
 *  - PD7 is 900 ohm pin.
 */

//.def NTSC_VERSION 'v0.0.1'

 /******************************************************************************
 * MACROS
 ******************************************************************************/

/**
 * Uses r16 to set the two ports. Sets both the signal pins to ground.
 */
.macro SYNCS
clr r16 // Clear a register for use.
in r16,0x09 // Grab the value of the port. 0x09 is PIND.
andi r16,0x6f  // Set both pins to low.
out 0x0b,r16 // Set the port pins. 0x0b is PORTD.
.endm

 /**
  * Uses r16 to set the two ports. Sets the 450 ohm to ground and the 900 ohm
  * to 5 volts. 
  */
.macro GREY
clr r16
in r16,0x09
andi r16,0xef
ori r16,0x10
out 0x0b,r16
.endm

 /**
  * Uses r16 to set the two ports. Set the 450 ohm to 5 volts and the 900 ohm
  * to ground.
  */
.macro WHITE
clr r16
in r16,0x09
andi r16,0x7f
ori r16,0x80
out 0x0b,r16
.endm

 /**
  * Uses r16 to set the two ports. Sets both pins to 5 volts.
  */
.macro BLACK
clr r16
in r16,0x09
ori r16,0x90
out 0x0b,r16
.endm


/*******************************************************************************
 * SUBROUTINES
 ******************************************************************************/
 
 /**
 * delayus Delay microseconds.
 * 
 * At 16 Mhz CLK / 4 to the power -1 is 250 nanoseconds per clock cycle (cc).
 * 
 * @param r17 The number of microseconds to delay.
 */
delayus:
subi r17,1 ; 1 cc
breq delayusend ; false (1 cc), true (2 cc)
nop ; 1 cc
nop ; 1 cc
rjmp delayus ; 2 cc
delayusend: // delay microsecond end
ret

/**
 * draw
 *
 * @param A1
 */
draw:
// First we must draw the odd lines and then the even lines.
call drawframe
call drawframe
ret

/**
 * drawframe
 *
 */
drawframe: 
// Draw the 242 lines and then the 20 blank lines for a total of 262 lines.

drawvsync:
// The vertical sync has an inverted horizontal sync with blank video lines
// 243 to 262, which is 19 lines.
// Set to 0.3 V for 4.7us (inverted horizontal sync)

ret

/**
 * drawline
 * 
 * Drawing a line requires four steps.
 *  1. Draw the horizontal sync pulse (4.7 us)
 *  2. Draw the back porch, non-visible pre-scan region (5.9us).
 *  3. Draw the visible scan region (51.5us).
 *  4. Draw the front porch non-visible post-scan region (1.4us).
 */
drawline:
// Draw a line. Total scan time for one line is 63.5us.
// Draw the horizontal sync pulse (4.7 us)
ldi r28,$28 ; Set Y to the address of PORTC.
ldi r18,$40 ; Set PC6 to HIGH. 
st Y,r18 ; Push the setting.
ldi r30,$2B ; Set Z to the address of PORTD.
ldi r18,$80 ; Set PD7 to HIGH.
st Z,r18 ; Push the setting.
ldi r17,3 ; Set r17 to the number of microseconds to wait.
call delayus 
// Draw the back porch, non-visible pre-scan region (5.9us).

// Draw the visible scan region (51.5us).

// Draw the front porch non-visible post-scan region (1.4us).

ret

