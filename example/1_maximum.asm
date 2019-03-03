; FV-1 Testing Bank
;
; Check behaviour of FV-1 against documentation
;

; Program 1 : Output Max Val
	clr			; clear ACC
	or	0x7fffff	; load max value to ACC
	wrax	DACL,0.0	; Write to DACL
