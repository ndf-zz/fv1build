; FV-1 Testing Bank
;
; Check behaviour of FV-1 against documentation
;

; Program 5 : PACC Init Val
;
; Expected output: 0.0

	skp	RUN,output
	wrlx	REG0,0.0	; copy PACC into ACC
	wrax	REG1,0.0
output:	ldax	REG1
	wrax	DACL,0.0	; output stored value
