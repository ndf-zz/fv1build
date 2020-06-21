# Makefile for FV-1 program bank
#
# --
# 2018 Nathan Fraser <ndf@metarace.com.au>
#
# To the extent possible under law, the author(s) have dedicated
# all copyright and related and neighboring rights to this software
# to the public domain worldwide. This software is distributed
# without any warranty.
#
# You should have received a copy of the CC0 Public Domain Dedication
# along with this software. If not, see:
#
#   http://creativecommons.org/publicdomain/zero/1.0/
# --
#
# Input files:
#	N_prog.asm		N is a program number from 0-7
#
# Output files:
#	bank.bin		FV-1 program bank binary
#	bank.bnk		Dervish combined program & text bank
#	bank_zdisplay.bin	Display text binary for zDSP
#
# Program text is extracted from assembly files automatically
# to fit the following zDSP template:
#
#    +------------------------+
#    | <N>-    Program Name   |
#    |LABEL0   LABEL1   LABEL2|
#    +------------------------+
# 
#  - N is the program number 0-7, set in the filename
#  - Program Name is a string up to 18 characters long set from the
#    filename or from a line in the assembly that matches:
#	Program N : Program Name
#  - Potentiometer labels are up to 8 characters set from lines in
#    the assembly that match:
#	POTn : LABEL
#    Where n is one of 0, 1 or 2. Label is truncated to 8 characters
#
# In the Dervish bank, text is translated to the following template
# and each field can be up to 20 characters long. If pot labels use a
# 7 character word followed by a space and then supplemental information,
# the full capabilities of both zDSP and Dervish can be exploited.
#
#   +--------------------+
#   |Bankname            |
#   |N  =================|
#   |Program Name        |
#   |                    |
#   |LABEL0  Supplemental|
#   |LABEL1              |
#   |LABEL2              |
#   +--------------------+
#

# Bank file and information strings
BANKFILE = bank
BANKNO = 1				# Dervish bank number 0 - 11 decimal
BANKNAME =  "FV-1 Test Bank A        "	# 20 chars for dervish, 24 for zDSP
BANKINFO1 = "Immediate & Initial Cond"	# zDSP bank info strings, 24 chars
BANKINFO2 = " (CC0) - Public Domain  "
BANKINFO3 = " <ndf@metarace.com.au>  "

# FV-1 assembler and flags
AS = asfv1
ASFLAGS = -b

# Helper scripts for extracting display texts
ZDSPTXT = zdsptext
DRVTXT = drvtext

# Programmer script for zDSP/Spin devel board
ZDSPPROG = zdspwrite

# Programmer for Dervish i2c eeprom programmer (also for Elta Console)
DERVISHPROG = fv1-eeprom-host
DERVISHTTY = /dev/ttyACM0

# --
TARGET = $(addsuffix .bin,$(BANKFILE))
ZDSPDISPLAY = $(TARGET:.bin=_zdisplay.bin)
DERVISHBANK = $(TARGET:.bin=.bnk)
SOURCES = $(wildcard [01234567]_*.asm)
PROGS = $(SOURCES:.asm=.prg)
ZTEXTS = $(SOURCES:.asm=.zdt)
DVTEXTS = $(SOURCES:.asm=.dvt)

.PHONY: files
files:	$(TARGET) $(ZDSPDISPLAY) $(DERVISHBANK)

$(TARGET):	$(PROGS)

$(DERVISHBANK): $(TARGET) $(DVTEXTS)
	dd if=$(TARGET) bs=512 count=8 conv=notrunc of=$(DERVISHBANK)
	printf '%-20.20b\n' $(BANKNAME) \
		| dd bs=21 count=1 seek=4096 oflag=seek_bytes conv=notrunc of=$(DERVISHBANK)
	
$(ZDSPDISPLAY):	$(ZTEXTS)
	printf '%-24.24b%-24.24b%-24.24b%-55.55b\0' $(BANKNAME) $(BANKINFO1) $(BANKINFO2) $(BANKINFO3) \
		| dd bs=128 count=1 seek=384 oflag=seek_bytes conv=notrunc of=$(ZDSPDISPLAY)

%.dvt: %.asm
	$(DRVTXT) $< $@
	dd if=$@ bs=84 count=1 seek=$(shell echo $$(( 4117 + $(firstword $(subst _, ,$<)) * 84 ))) oflag=seek_bytes conv=notrunc of=$(DERVISHBANK)

%.zdt: %.asm
	$(ZDSPTXT) $< $@
	dd if=$@ bs=48 count=1 seek=$(firstword $(subst _, ,$<)) conv=notrunc of=$(ZDSPDISPLAY)

%.prg: %.asm
	$(AS) $(ASFLAGS) $< $@
	dd if=$@ bs=512 count=1 seek=$(firstword $(subst _, ,$<)) conv=notrunc of=$(TARGET)

.PHONY: zprog
zprog: $(ZDSPDISPLAY) $(TARGET)
	$(ZDSPPROG) $(ZDSPDISPLAY) $(TARGET)

.PHONY: dprog
dprog: $(DERVISHBANK)
	$(DERVISHPROG) -v -n 4789 -o $(shell echo $$(( 5120 * $(BANKNO) ))) -p 128 -t $(DERVISHTTY) -f $(DERVISHBANK) -c W

.PHONY: eprog
eprog: $(TARGET)
	$(DERVISHPROG) -v -n 4096 -o 0 -p 32 -t $(DERVISHTTY) -f $(DERVISHBANK) -c W

.PHONY: help
help:
	@echo
	@echo Targets:
	@echo "	files [default]	assemble sources into bank and display files"
	@echo "	zprog		program bank and display for zDSP using Numberz"
	@echo "	dprog		program bank on a (u)dervish via i2c"
	@echo "	eprog		program bank for Elta Console via i2c"
	@echo "	clean		remove all intermediate files"
	@echo

.PHONY: clean
clean:
	-rm -f $(TARGET) $(ZDSPDISPLAY) $(DERVISHBANK) $(PROGS) $(ZTEXTS) $(DVTEXTS)
