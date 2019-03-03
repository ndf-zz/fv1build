; FV-1 Testing Bank A
;
; Check behaviour of FV-1 against documentation
;

; Program 7 : Delay Init Val
;
; Expected output: 0.0

mem	delay	1

	clr
	rda	delay,1.0	; read from empty delay
	wrax	DACL,0.0
