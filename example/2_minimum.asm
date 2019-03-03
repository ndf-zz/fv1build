; FV-1 Testing Bank
;
; Check behaviour of FV-1 against documentation
;

; Program 2 : Output Min Val
	clr			; clear ACC
	or	0x800000	; load min value to ACC
	wrax	DACL,0.0	; Write to DACL
