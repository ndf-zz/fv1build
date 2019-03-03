# fv1build
Makefile and scripts for a FV1

## Contents

Makefile	A blank fv1 build makefile

scripts/	Supporting scripts for text file and upload

example/	An example bank complete with source files

## Usage

Create a folder for your bank. Add source files to the folder with
filenames in the form:

	N_prog.asm

Where 'N' is the program number from 0 to 7 and 'prog' is a short
name for the program. For example:

	2_chorus.asm

In each source file, additional optional text can be provided for Tiptop
zDSP and gBiz uDervish devices by adding lines as follows:

	; Program N : Program Name
	; POT0 : Pot0 Function
	; POT1 : Pot1 Function
	; POT2 : Pot2 Function

## License

To the extent possible under law, the author(s) have dedicated
all copyright and related and neighboring rights to this software
to the public domain worldwide. This software is distributed
without any warranty.

