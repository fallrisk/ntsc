;*******************************************************************************
; This program creates the NTSC signal.
;
; Justin Watson 
;
;
;*******************************************************************************
.org $0000
main:
; Set PD0 and PD1 to outputs. PD1 is 450 ohm and PD0 is 900 ohm.
ldi $03,r0 ; Set r0 to 3.
st r0,($2A) ; Store 3 into the DDRD, which is $2A
ldi $80,r0 ; Set PC7 to output, which is Arduino digital pin 13
st r0,($27) ; Set DDRC.
ldi $80,r0
st r0,($28)
mainlp:
nop
jmp mainlp
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
ldi $0000,r10

drawvsync:
; The vertical sync has an inverted horizontal sync with blank video lines
;   243 to 262, which is 19 lines.
; Set to 0.3 V for 4.7us (inverted horizontal sync)
st $2B,r11  ; Set the out port to 

ret
;*******************************************************************************
drawline:
; Draw a line. Total scan time for one line is 63.5us.
; Draw the horizontal sync pulse (4.7 us)
; Draw the back porch, non-visible pre-scan region (5.9us)
; Draw the visible scan region (51.5us)
; Draw the front porch non-visible post-scan region (1.4us)
ret
.EXIT
