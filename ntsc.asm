;*******************************************************************************
; This program creates the NTSC signal.
;
; Justin Watson 
;
;
;
;
; 0 and 0 = 0 v
; 450 off and 900 on 
;
;
; 8-bit microcontroller
;*******************************************************************************
.macro SYNCS
.endmacro

.macro GREY
.endmacro

.macro WHITE
.endmacro

.macro BLACK
.endmacro

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

;*******************************************************************************
draw:
; First we must draw the odd lines and then the even lines.
jmp drawframe
jmp drawframe
ret

;*******************************************************************************
drawframe: 
; Draw the 242 lines and then the 20 blank lines for a total of 262 lines.

drawvsync:
; The vertical sync has an inverted horizontal sync with blank video lines
;   243 to 262, which is 19 lines.
; Set to 0.3 V for 4.7us (inverted horizontal sync)
  ; Set the out port to 

ret

;*******************************************************************************
drawline:
; Draw a line. Total scan time for one line is 63.5us.
; Draw the horizontal sync pulse (4.7 us)
ldi r28,$28 ; Set Y to the address of PORTC.
ldi r18,$40 ; Set PC6 to HIGH. 
st Y,r18 ; Push the setting.
ldi r30,$2B ; Set Z to the address of PORTD.
ldi r18,$80 ; Set PD7 to HIGH.
st Z,r18 ; Push the setting.
ldi r17,3 ; Set r17 to the number of microseconds to wait.
call delayus 
; Draw the back porch, non-visible pre-scan region (5.9us).

; Draw the visible scan region (51.5us).

; Draw the front porch non-visible post-scan region (1.4us).

ret

;*******************************************************************************
; delayus 
; 
; At 16 Mhz CLK / 4 to the power -1 is 250 nanoseconds per clock cycle (cc).
; 
; @param r17 The number of microseconds to delay.
delayus:
subi r17,1 ; 1 cc
breq delayusend ; false (1 cc), true (2 cc)
nop ; 1 cc
nop ; 1 cc
rjmp delayus ; 2 cc
delayusend:
ret
.EXIT
