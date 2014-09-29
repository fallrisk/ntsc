/*******************************************************************************
 * This program tests the NTSC generator by printing an image to the screen.
 *
 * @author Justin Watson 
 *******************************************************************************/
 .cseg
main:
; Set PC6 (DP5, Digital Pin) and PD7 (DP6) to outputs. DP5 is 450 ohm and DP6 is 900 ohm.
; Refer to document () to see how I am using these two resistors.
; Also set PC7 to output for the LED.
; DDRD ($2A) PORTD ($2B) DDRC ($27) PORTC ($28)
ldi r16,$C0 ; Set r0 to $80 for PC7.
ldi r26,$27 ; Set X to $27 (DDRC).
st X,r16 ; Store the value of r16 into address X, which is DDRC register in this case.
ldi r16,$80 ; Load r16 with bit 7 high. This will be used to turn on PC7.
ldi r26,$28 ; Set X to $28 (PORTC).
; At this point the LED should be on.
st X,r16 ; Set PC7 to state high. This turns on the LED.
ldi r16,$80
ldi r26,$2A ; $2A (DDRD)
st X,r16
mainlp:
nop
rjmp mainlp
ret
