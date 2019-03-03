; FV-1 Testing Bank
;
; Check behaviour of FV-1 against documentation
;

; Program 0 : Output Zero
	clr			; clear ACC
	wrax	DACL,0.0	; Write to DACL
