; FV-1 Testing Bank A
;
; Check behaviour of FV-1 against documentation
;

; Program 6 : ACC Init Val
;
;	note: also copies ADCL into delay for use with program 7
;
; Expected output: 0.0

mem	delay	1

	skp	RUN,output
	wrax	REG1,0.0	; store ACC init value
output:	ldax	REG1
	wrax	DACL,0.0
	ldax	ADCL
	wra	delay,1.0
	wrax	DACR,0.0
