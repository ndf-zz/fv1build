; FV-1 Testing Bank
;
; Check behaviour of FV-1 against documentation
;

; Program 4 : Output Range
;
; Manually sweep output over all values
;
; Expected output: sawtooth with period 2**24/fs (~512s)

; Waveform parameters
equ	maxval	0x7fffff	; ACC maximum
equ	minval	0x800000	; ACC minimum
equ	incval	0x1		; per sample increment

; Registers
equ	PREV	REG0		; last output
equ	CUR	REG1		; next output
equ	MAX	REG3		; reg to store maxval
equ	MIN	REG4		; reg ro store minval
equ	INC	REG5		; reg to store incval

; Prepare constants
	skp	RUN,main
	clr
	or	maxval
	wrax	MAX,0.0
	or	minval
	wrax	MIN,0.0
	or	incval
	wrax	INC,0.0

main:	ldax	PREV		; read previous output
	xor	maxval		; compare with maximum value
	skp	ZRO,tomin	; if PREV was as max, change to MIN

incr:	ldax	INC		; load increment into ACC
	rdax	PREV,1.0	; load acc with PREV + INC
	wrax	CUR,0.0		; store to CUR and clear ACC
	skp	ZRO,output	; skip to output

tomin:	ldax	MIN		; load minimum val into ACC
	wrax	CUR,0.0		; store minimum in CUR and clear ACC
	skp	ZRO,output	; skip to output

output: ldax	CUR		; load the computed value into ACC
	wrax	PREV,1.0	; store value in PREV register
	wrax	DACL,0.0	; output value to DAC
