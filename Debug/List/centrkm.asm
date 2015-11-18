
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega328P
;Program type           : Application
;Clock frequency        : 16,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega328P
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x08FF
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _ton1=R3
	.DEF _ton1_msb=R4
	.DEF _a=R5
	.DEF _a_msb=R6
	.DEF _z=R8
	.DEF _n=R7
	.DEF _s435=R10
	.DEF _period=R9
	.DEF _per_old=R12
	.DEF _per_new=R11
	.DEF _i=R14
	.DEF _sig_bayt=R13

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _ana_comp_isr
	JMP  _twi_int_handler
	JMP  0x00

_sinus:
	.DB  0x82,0x85,0x88,0x8B,0x8F,0x92,0x95,0x98
	.DB  0x9B,0x9E,0xA1,0xA4,0xA7,0xAA,0xAD,0xB0
	.DB  0xB2,0xB5,0xB8,0xBB,0xBE,0xC0,0xC3,0xC6
	.DB  0xC8,0xCB,0xCD,0xD0,0xD2,0xD4,0xD7,0xD9
	.DB  0xDB,0xDD,0xDF,0xE1,0xE3,0xE5,0xE7,0xE9
	.DB  0xEA,0xEC,0xEE,0xEF,0xF0,0xF2,0xF3,0xF4
	.DB  0xF5,0xF7,0xF8,0xF9,0xF9,0xFA,0xFB,0xFC
	.DB  0xFC,0xFD,0xFD,0xFD,0xFE,0xFE,0xFE,0xFE
	.DB  0xFE,0xFE,0xFE,0xFD,0xFD,0xFD,0xFC,0xFC
	.DB  0xFB,0xFA,0xF9,0xF9,0xF8,0xF7,0xF5,0xF4
	.DB  0xF3,0xF2,0xF0,0xEF,0xEE,0xEC,0xEA,0xE9
	.DB  0xE7,0xE5,0xE3,0xE1,0xDF,0xDD,0xDB,0xD9
	.DB  0xD7,0xD4,0xD2,0xD0,0xCD,0xCB,0xC8,0xC6
	.DB  0xC3,0xC0,0xBE,0xBB,0xB8,0xB5,0xB2,0xB0
	.DB  0xAD,0xAA,0xA7,0xA4,0xA1,0x9E,0x9B,0x98
	.DB  0x95,0x92,0x8F,0x8B,0x88,0x85,0x82,0x7F
	.DB  0x7C,0x79,0x76,0x73,0x6F,0x6C,0x69,0x66
	.DB  0x63,0x60,0x5D,0x5A,0x57,0x54,0x51,0x4E
	.DB  0x4C,0x49,0x46,0x43,0x40,0x3E,0x3B,0x38
	.DB  0x36,0x33,0x31,0x2E,0x2C,0x2A,0x27,0x25
	.DB  0x23,0x21,0x1F,0x1D,0x1B,0x19,0x17,0x15
	.DB  0x14,0x12,0x10,0xF,0xE,0xC,0xB,0xA
	.DB  0x9,0x7,0x6,0x5,0x5,0x4,0x3,0x2
	.DB  0x2,0x1,0x1,0x1,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x1,0x1,0x1,0x2,0x2
	.DB  0x3,0x4,0x5,0x5,0x6,0x7,0x9,0xA
	.DB  0xB,0xC,0xE,0xF,0x10,0x12,0x14,0x15
	.DB  0x17,0x19,0x1B,0x1D,0x1F,0x21,0x23,0x25
	.DB  0x27,0x2A,0x2C,0x2E,0x31,0x33,0x36,0x38
	.DB  0x3B,0x3E,0x40,0x43,0x46,0x49,0x4C,0x4E
	.DB  0x51,0x54,0x57,0x5A,0x5D,0x60,0x63,0x66
	.DB  0x69,0x6C,0x6F,0x73,0x76,0x79,0x7C,0x7F
_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x0:
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x20,0x20,0x57,0x45,0x4C,0x43,0x4F
	.DB  0x4D,0x45,0x21,0x20,0x20,0x20,0x0,0x31
	.DB  0x20,0x20,0x20,0x0,0x45,0x72,0x72,0x6F
	.DB  0x72,0x20,0x50,0x69,0x74,0x61,0x6E,0x69
	.DB  0x65,0x21,0x21,0x21,0x0,0x33,0x31,0x20
	.DB  0x20,0x0,0x36,0x31,0x20,0x20,0x0,0x39
	.DB  0x31,0x20,0x20,0x0,0x20,0x20,0x45,0x72
	.DB  0x72,0x6F,0x72,0x20,0x53,0x79,0x6E,0x63
	.DB  0x21,0x21,0x21,0x20,0x0
_0x2000003:
	.DB  0x80,0xC0
_0x2040003:
	.DB  0x7

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

	.DW  0x01
	.DW  _twi_result
	.DW  _0x2040003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x300

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 30/10 2015
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega328P
;Program type            : Application
;AVR Core Clock frequency: 16,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*******************************************************/
;
;#include <mega328p.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;//#include <delay.h>
;
;// Alphanumeric LCD functions
;#include <alcd.h>
;
;#define vyh_plus PORTD.4
;#define vyh_minus PORTD.2
;#define zvuk PORTD.5
;#define vyh_t0 DDRD.6
;#define kn1 PINC.0
;#define kn2 PINC.1
;#define kn3 PINC.2
;#define shim OCR2B
;
;
;
;// Declare your global variables here
;
;
;
;// Declare your global variables here   \
;
;// таблице синуса для формирования синусоидального напряжения
;flash unsigned char sinus[] = {130,133,136,139,143,146,149,152,155,158,161,164,167,170,173,176,178,
;181,184,187,190,192,195,198,200,203,205,208,210,212,215,217,219,221,223,225,227,229,231,233,234,236,
;238,239,240,242,243,244,245,247,248,249,249,250,251,252,252,253,253,253,254,254,254,254,254,254,254,
;253,253,253,252,252,251,250,249,249,248,247,245,244,243,242,240,239,238,236,234,233,231,229,227,225,
;223,221,219,217,215,212,210,208,205,203,200,198,195,192,190,187,184,181,178,176,173,170,167,164,161,
;158,155,152,149,146,143,139,136,133,130,127,124,121,118,115,111,108,105,102,99,96,93,90,87,84,81,78,
;76,73,70,67,64,62,59,56,54,51,49,46,44,42,39,37,35,33,31,29,27,25,23,21,20,18,16,15,14,12,11,10,9,7,
;6,5,5,4,3,2,2,1,1,1,0,0,0,0,0,0,0,1,1,1,2,2,3,4,5,5,6,7,9,10,11,12,14,15,16,18,20,21,23,25,27,29,31,33,35,37,39,42,
;44,46,49,51,54,56,59,62,64,67,70,73,76,78,81,84,87,90,93,96,99,102,105,108,111,115,118,121,124,127};
;
;unsigned int ton1,a;
;unsigned char z, n, s435, period, per_old, per_new, i, sig_bayt, sig_bit, sost[32], page, p10, x_dysp, y_dysp, pos;
;unsigned long time;
;bit flag435, trevoga, pit_ok, sinc_err, pit_err, fix, nagh;
;
;eeprom long procfreq = 16000000;
;eeprom unsigned char esost[32] ;
;
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0048 {

	.CSEG
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R0
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0049 // Place your code here
; 0000 004A a = a + ton1;      // Формирование синусоиды (форма в массиве sinus)
	__ADDWRR 5,6,3,4
; 0000 004B z = a>>8 ;
	MOV  R8,R6
; 0000 004C OCR0A=sinus[z];
	MOV  R30,R8
	LDI  R31,0
	SUBI R30,LOW(-_sinus*2)
	SBCI R31,HIGH(-_sinus*2)
	LPM  R0,Z
	OUT  0x27,R0
; 0000 004D 
; 0000 004E }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0052 {
_timer1_ovf_isr:
; .FSTART _timer1_ovf_isr
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0053 // Place your code here
; 0000 0054     time = time + 1;    // для измерения задержек (единица = 4 мС)
	LDS  R30,_time
	LDS  R31,_time+1
	LDS  R22,_time+2
	LDS  R23,_time+3
	__ADDD1N 1
	STS  _time,R30
	STS  _time+1,R31
	STS  _time+2,R22
	STS  _time+3,R23
; 0000 0055 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R23,Y+
	LD   R22,Y+
	RETI
; .FEND
;
;// Analog Comparator interrupt service routine
;interrupt [ANA_COMP] void ana_comp_isr(void)
; 0000 0059 {
_ana_comp_isr:
; .FSTART _ana_comp_isr
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 005A // Place your code here
; 0000 005B per_old = per_new;
	MOV  R12,R11
; 0000 005C per_new = TCNT1L;
	LDS  R11,132
; 0000 005D per_new = TCNT1H;
	LDS  R11,133
; 0000 005E if(per_old < per_new) period = per_new - per_old; else period = per_new + (255 - per_old);
	CP   R12,R11
	BRSH _0x3
	MOV  R30,R11
	SUB  R30,R12
	RJMP _0xF5
_0x3:
	LDI  R30,LOW(255)
	SUB  R30,R12
	ADD  R30,R11
_0xF5:
	MOV  R9,R30
; 0000 005F     if ((period > 0x80)&&(period < 0xA0)) //если период соответствует частоте 435 Гц
	LDI  R30,LOW(128)
	CP   R30,R9
	BRSH _0x6
	LDI  R30,LOW(160)
	CP   R9,R30
	BRLO _0x7
_0x6:
	RJMP _0x5
_0x7:
; 0000 0060     {
; 0000 0061        if (s435++ > 4) flag435 = 1 ;  // обработка при обнаружени частоты 435
	MOV  R30,R10
	INC  R10
	CPI  R30,LOW(0x5)
	BRLO _0x8
	SBI  0x1E,0
; 0000 0062     }
_0x8:
; 0000 0063     else s435 = 0;
	RJMP _0xB
_0x5:
	CLR  R10
; 0000 0064 }
_0xB:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
; .FEND
;
;// TWI functions
;#include <twi.h>
;
;// TWI Slave receive buffer
;#define TWI_RX_BUFFER_SIZE 32
;unsigned char twi_rx_buffer[TWI_RX_BUFFER_SIZE];
;
;// TWI Slave transmit buffer
;#define TWI_TX_BUFFER_SIZE 32
;unsigned char twi_tx_buffer[TWI_TX_BUFFER_SIZE];
;
;// TWI Slave receive handler
;// This handler is called everytime a byte
;// is received by the TWI slave
;bool twi_rx_handler(bool rx_complete)
; 0000 0075 {
_twi_rx_handler:
; .FSTART _twi_rx_handler
; 0000 0076 if (twi_result==TWI_RES_OK)
	ST   -Y,R26
;	rx_complete -> Y+0
	LDS  R30,_twi_result
	CPI  R30,0
	BREQ _0xD
; 0000 0077    {
; 0000 0078    // A data byte was received without error
; 0000 0079    // and it was stored at twi_rx_buffer[twi_rx_index]
; 0000 007A    // Place your code here to process the received byte
; 0000 007B    // Note: processing must be VERY FAST, otherwise
; 0000 007C    // it is better to process the received data when
; 0000 007D    // all communication with the master has finished
; 0000 007E 
; 0000 007F    }
; 0000 0080 else
; 0000 0081    {
; 0000 0082    // Receive error
; 0000 0083    // Place your code here to process the error
; 0000 0084 
; 0000 0085    return false; // Stop further reception
	LDI  R30,LOW(0)
	JMP  _0x20A0001
; 0000 0086    }
_0xD:
; 0000 0087 
; 0000 0088 // The TWI master has finished transmitting data?
; 0000 0089 if (rx_complete) return false; // Yes, no more bytes to receive
	LD   R30,Y
	CPI  R30,0
	BREQ _0xE
	LDI  R30,LOW(0)
	JMP  _0x20A0001
; 0000 008A 
; 0000 008B // Signal to the TWI master that the TWI slave
; 0000 008C // is ready to accept more data, as long as
; 0000 008D // there is enough space in the receive buffer
; 0000 008E return (twi_rx_index<sizeof(twi_rx_buffer));
_0xE:
	LDS  R26,_twi_rx_index
	LDI  R30,LOW(32)
	CALL __LTB12U
	JMP  _0x20A0001
; 0000 008F }
; .FEND
;
;// TWI Slave transmission handler
;// This handler is called for the first time when the
;// transmission from the TWI slave to the master
;// is about to begin, returning the number of bytes
;// that need to be transmitted
;// The second time the handler is called when the
;// transmission has finished
;// In this case it must return 0
;unsigned char twi_tx_handler(bool tx_complete)
; 0000 009A {
_twi_tx_handler:
; .FSTART _twi_tx_handler
; 0000 009B if (tx_complete==false)
	ST   -Y,R26
;	tx_complete -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0xF
; 0000 009C    {
; 0000 009D    // Transmission from slave to master is about to start
; 0000 009E    // Return the number of bytes to transmit
; 0000 009F    return sizeof(twi_tx_buffer);
	LDI  R30,LOW(32)
	JMP  _0x20A0001
; 0000 00A0    }
; 0000 00A1 
; 0000 00A2 // Transmission from slave to master has finished
; 0000 00A3 // Place code here to eventually process data from
; 0000 00A4 // the twi_rx_buffer, if it wasn't yet processed
; 0000 00A5 // in the twi_rx_handler
; 0000 00A6 
; 0000 00A7 // No more bytes to send in this transaction
; 0000 00A8 return 0;
_0xF:
	LDI  R30,LOW(0)
	JMP  _0x20A0001
; 0000 00A9 }
; .FEND
;
;
;
;
;unsigned int fdel(int freq)
; 0000 00AF {
_fdel:
; .FSTART _fdel
; 0000 00B0     long koeff;              //определение коеффициента деления для получения частоты
; 0000 00B1     int delit;
; 0000 00B2     koeff = (16777216000/procfreq);
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
;	freq -> Y+6
;	koeff -> Y+2
;	delit -> R16,R17
	LDI  R26,LOW(_procfreq)
	LDI  R27,HIGH(_procfreq)
	CALL __EEPROMRDD
	CALL __CDF1
	__GETD2N 0x507A0000
	CALL __DIVF21
	MOVW R26,R28
	ADIW R26,2
	CALL __CFD1
	CALL __PUTDP1
; 0000 00B3     koeff = (long)(koeff * freq);
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	__GETD2S 2
	CALL __CWD1
	CALL __MULD12
	__PUTD1S 2
; 0000 00B4     delit = koeff / 1000;
	__GETD2S 2
	__GETD1N 0x3E8
	CALL __DIVD21
	MOVW R16,R30
; 0000 00B5     return delit;
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	RET
; 0000 00B6 }
; .FEND
;
;void clear_lcd(void)
; 0000 00B9 {
_clear_lcd:
; .FSTART _clear_lcd
; 0000 00BA     lcd_gotoxy(0,0);
	CALL SUBOPT_0x0
; 0000 00BB     lcd_putsf("                                                                ");
	__POINTW2FN _0x0,0
	CALL _lcd_putsf
; 0000 00BC 
; 0000 00BD }
	RET
; .FEND
;
;
;void main(void)
; 0000 00C1 {
_main:
; .FSTART _main
; 0000 00C2 // Declare your local variables here
; 0000 00C3 
; 0000 00C4 // Crystal Oscillator division factor: 1
; 0000 00C5 #pragma optsize-
; 0000 00C6 CLKPR=(1<<CLKPCE);
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 00C7 CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 00C8 #ifdef _OPTIMIZE_SIZE_
; 0000 00C9 #pragma optsize+
; 0000 00CA #endif
; 0000 00CB 
; 0000 00CC // Input/Output Ports initialization
; 0000 00CD // Port B initialization
; 0000 00CE // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00CF DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x4,R30
; 0000 00D0 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00D1 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x5,R30
; 0000 00D2 
; 0000 00D3 // Port C initialization
; 0000 00D4 // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00D5 DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x7,R30
; 0000 00D6 // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=P Bit1=P Bit0=P
; 0000 00D7 PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (1<<PORTC2) | (1<<PORTC1) | (1<<PORTC0);
	LDI  R30,LOW(7)
	OUT  0x8,R30
; 0000 00D8 
; 0000 00D9 // Port D initialization
; 0000 00DA // Function: Bit7=In Bit6=In Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=In Bit0=In
; 0000 00DB DDRD=(0<<DDD7) | (0<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(60)
	OUT  0xA,R30
; 0000 00DC // State: Bit7=P Bit6=T Bit5=0 Bit4=0 Bit3=0 Bit2=T Bit1=T Bit0=T
; 0000 00DD PORTD=(1<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(128)
	OUT  0xB,R30
; 0000 00DE 
; 0000 00DF // Timer/Counter 0 initialization
; 0000 00E0 // Clock source: System Clock
; 0000 00E1 // Clock value: 16000,000 kHz
; 0000 00E2 // Mode: Fast PWM top=0xFF
; 0000 00E3 // OC0A output: Non-Inverted PWM
; 0000 00E4 // OC0B output: Disconnected
; 0000 00E5 // Timer Period: 0,016 ms
; 0000 00E6 // Output Pulse(s):
; 0000 00E7 // OC0A Period: 0,016 ms Width: 0 us
; 0000 00E8 TCCR0A=(1<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (1<<WGM01) | (1<<WGM00);
	LDI  R30,LOW(131)
	OUT  0x24,R30
; 0000 00E9 TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (1<<CS00);
	LDI  R30,LOW(1)
	OUT  0x25,R30
; 0000 00EA TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 00EB OCR0A=0x00;
	OUT  0x27,R30
; 0000 00EC OCR0B=0x00;
	OUT  0x28,R30
; 0000 00ED 
; 0000 00EE 
; 0000 00EF // Timer/Counter 1 initialization
; 0000 00F0 // Clock source: System Clock
; 0000 00F1 // Clock value: 16000,000 kHz
; 0000 00F2 // Mode: Normal top=0xFFFF
; 0000 00F3 // OC1A output: Disconnected
; 0000 00F4 // OC1B output: Disconnected
; 0000 00F5 // Noise Canceler: Off
; 0000 00F6 // Input Capture on Falling Edge
; 0000 00F7 // Timer Period: 4,096 ms
; 0000 00F8 // Timer1 Overflow Interrupt: On
; 0000 00F9 // Input Capture Interrupt: Off
; 0000 00FA // Compare A Match Interrupt: Off
; 0000 00FB // Compare B Match Interrupt: Off
; 0000 00FC TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	STS  128,R30
; 0000 00FD TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
	LDI  R30,LOW(1)
	STS  129,R30
; 0000 00FE TCNT1H=0x00;
	LDI  R30,LOW(0)
	STS  133,R30
; 0000 00FF TCNT1L=0x00;
	STS  132,R30
; 0000 0100 ICR1H=0x00;
	STS  135,R30
; 0000 0101 ICR1L=0x00;
	STS  134,R30
; 0000 0102 OCR1AH=0x00;
	STS  137,R30
; 0000 0103 OCR1AL=0x00;
	STS  136,R30
; 0000 0104 OCR1BH=0x00;
	STS  139,R30
; 0000 0105 OCR1BL=0x00;
	STS  138,R30
; 0000 0106 
; 0000 0107 // Timer/Counter 2 initialization
; 0000 0108 // Clock source: System Clock
; 0000 0109 // Clock value: 16000,000 kHz
; 0000 010A // Mode: Fast PWM top=0xFF
; 0000 010B // OC2A output: Disconnected
; 0000 010C // OC2B output: Non-Inverted PWM
; 0000 010D // Timer Period: 0,016 ms
; 0000 010E // Output Pulse(s):
; 0000 010F // OC2B Period: 0,016 ms Width: 8,0314 us
; 0000 0110 ASSR=(0<<EXCLK) | (0<<AS2);
	STS  182,R30
; 0000 0111 TCCR2A=(0<<COM2A1) | (0<<COM2A0) | (1<<COM2B1) | (0<<COM2B0) | (1<<WGM21) | (1<<WGM20);
	LDI  R30,LOW(35)
	STS  176,R30
; 0000 0112 TCCR2B=(0<<WGM22) | (0<<CS22) | (0<<CS21) | (1<<CS20);
	LDI  R30,LOW(1)
	STS  177,R30
; 0000 0113 TCNT2=0x00;
	LDI  R30,LOW(0)
	STS  178,R30
; 0000 0114 OCR2A=0x00;
	STS  179,R30
; 0000 0115 OCR2B=0x00;
	STS  180,R30
; 0000 0116 
; 0000 0117 // Timer/Counter 0 Interrupt(s) initialization
; 0000 0118 TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (1<<TOIE0);
	LDI  R30,LOW(1)
	STS  110,R30
; 0000 0119 
; 0000 011A // Timer/Counter 1 Interrupt(s) initialization
; 0000 011B TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (1<<TOIE1);
	STS  111,R30
; 0000 011C 
; 0000 011D // Timer/Counter 2 Interrupt(s) initialization
; 0000 011E TIMSK2=(0<<OCIE2B) | (0<<OCIE2A) | (0<<TOIE2);
	LDI  R30,LOW(0)
	STS  112,R30
; 0000 011F 
; 0000 0120 // External Interrupt(s) initialization
; 0000 0121 // INT0: Off
; 0000 0122 // INT1: Off
; 0000 0123 // Interrupt on any change on pins PCINT0-7: Off
; 0000 0124 // Interrupt on any change on pins PCINT8-14: Off
; 0000 0125 // Interrupt on any change on pins PCINT16-23: Off
; 0000 0126 EICRA=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	STS  105,R30
; 0000 0127 EIMSK=(0<<INT1) | (0<<INT0);
	OUT  0x1D,R30
; 0000 0128 PCICR=(0<<PCIE2) | (0<<PCIE1) | (0<<PCIE0);
	STS  104,R30
; 0000 0129 
; 0000 012A // USART initialization
; 0000 012B // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 012C // USART Receiver: On
; 0000 012D // USART Transmitter: On
; 0000 012E // USART0 Mode: Asynchronous
; 0000 012F // USART Baud Rate: 9600
; 0000 0130 UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
	STS  192,R30
; 0000 0131 UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	LDI  R30,LOW(24)
	STS  193,R30
; 0000 0132 UCSR0C=(0<<UMSEL01) | (0<<UMSEL00) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
	LDI  R30,LOW(6)
	STS  194,R30
; 0000 0133 UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  197,R30
; 0000 0134 UBRR0L=0x67;
	LDI  R30,LOW(103)
	STS  196,R30
; 0000 0135 
; 0000 0136 // Analog Comparator initialization
; 0000 0137 // Analog Comparator: On
; 0000 0138 // The Analog Comparator's positive input is
; 0000 0139 // connected to the AIN0 pin
; 0000 013A // The Analog Comparator's negative input is
; 0000 013B // connected to the AIN1 pin
; 0000 013C // Interrupt on Rising Output Edge
; 0000 013D // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 013E ACSR=(0<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (1<<ACIE) | (0<<ACIC) | (1<<ACIS1) | (1<<ACIS0);
	LDI  R30,LOW(11)
	OUT  0x30,R30
; 0000 013F ADCSRB=(0<<ACME);
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 0140 // Digital input buffer on AIN0: On
; 0000 0141 // Digital input buffer on AIN1: On
; 0000 0142 DIDR1=(0<<AIN0D) | (0<<AIN1D);
	STS  127,R30
; 0000 0143 
; 0000 0144 // ADC initialization
; 0000 0145 // ADC disabled
; 0000 0146 ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	STS  122,R30
; 0000 0147 
; 0000 0148 // SPI initialization
; 0000 0149 // SPI disabled
; 0000 014A SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0x2C,R30
; 0000 014B 
; 0000 014C // TWI initialization
; 0000 014D // Mode: TWI Slave
; 0000 014E // Match Any Slave Address: Off
; 0000 014F // I2C Bus Slave Address: 0x21
; 0000 0150 twi_slave_init(false,0x21,twi_rx_buffer,sizeof(twi_rx_buffer),twi_tx_buffer,twi_rx_handler,twi_tx_handler);
	ST   -Y,R30
	LDI  R30,LOW(33)
	ST   -Y,R30
	LDI  R30,LOW(_twi_rx_buffer)
	LDI  R31,HIGH(_twi_rx_buffer)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(32)
	ST   -Y,R30
	LDI  R30,LOW(_twi_tx_buffer)
	LDI  R31,HIGH(_twi_tx_buffer)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_twi_rx_handler)
	LDI  R31,HIGH(_twi_rx_handler)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_twi_tx_handler)
	LDI  R27,HIGH(_twi_tx_handler)
	CALL _twi_slave_init
; 0000 0151 
; 0000 0152 // Alphanumeric LCD initialization
; 0000 0153 // Connections are specified in the
; 0000 0154 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 0155 // RS - PORTB Bit 0
; 0000 0156 // RD - PORTB Bit 7
; 0000 0157 // EN - PORTB Bit 1
; 0000 0158 // D4 - PORTB Bit 2
; 0000 0159 // D5 - PORTB Bit 3
; 0000 015A // D6 - PORTB Bit 4
; 0000 015B // D7 - PORTB Bit 5
; 0000 015C // Characters/line: 16
; 0000 015D lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 015E lcd_putsf("  WELCOME!   ");
	__POINTW2FN _0x0,65
	CALL _lcd_putsf
; 0000 015F // Global enable interrupts
; 0000 0160 
; 0000 0161 ACSR |= (1<<ACIE); // включить перывания от компарат
	IN   R30,0x30
	ORI  R30,8
	OUT  0x30,R30
; 0000 0162 ACSR &= ~(1<<ACIE); // выкл прер компар
	IN   R30,0x30
	ANDI R30,0XF7
	OUT  0x30,R30
; 0000 0163 
; 0000 0164 vyh_t0 = 0;             // выкл таймер 0
	CBI  0xA,6
; 0000 0165 TCCR0A &= ~(1<<CS00);
	IN   R30,0x24
	ANDI R30,0xFE
	OUT  0x24,R30
; 0000 0166 
; 0000 0167 
; 0000 0168 
; 0000 0169 procfreq = 16000000 ;
	LDI  R26,LOW(_procfreq)
	LDI  R27,HIGH(_procfreq)
	__GETD1N 0xF42400
	CALL __EEPROMWRD
; 0000 016A ton1 = fdel(1080);
	LDI  R26,LOW(1080)
	LDI  R27,HIGH(1080)
	RCALL _fdel
	__PUTW1R 3,4
; 0000 016B 
; 0000 016C 
; 0000 016D 
; 0000 016E 
; 0000 016F 
; 0000 0170 for (n = 0; n < 32; n++) sost[n] = esost[n];
	CLR  R7
_0x13:
	LDI  R30,LOW(32)
	CP   R7,R30
	BRSH _0x14
	CALL SUBOPT_0x1
	INC  R7
	RJMP _0x13
_0x14:
; 0000 0175 #asm("sei")
	sei
; 0000 0176 //vyh_plus = 1;
; 0000 0177 OCR2B=0x00; // выключение преобразователя
	LDI  R30,LOW(0)
	STS  180,R30
; 0000 0178 //          time = 0;
; 0000 0179 //          while (time < 1000) #asm("wdr");  // задержка 25 мСек
; 0000 017A //
; 0000 017B // OCR2B=0x50; // выключение преобразователя
; 0000 017C //
; 0000 017D //          time = 0;
; 0000 017E //          while (time < 1000) #asm("wdr");  // задержка 25 мСек
; 0000 017F //
; 0000 0180 //OCR2B=0x50; // выключение преобразователя
; 0000 0181 //
; 0000 0182 //          time = 0;
; 0000 0183 //          while (time < 1000) #asm("wdr");  // задержка 25 мСек
; 0000 0184 // vyh_plus = 0;
; 0000 0185 // vyh_minus = 1;
; 0000 0186 //
; 0000 0187 //OCR2B=0xB0; // выключение преобразователя
; 0000 0188 //
; 0000 0189 //          time = 0;
; 0000 018A //          while (time < 1000) #asm("wdr");  // задержка 25 мСек
; 0000 018B //
; 0000 018C //
; 0000 018D //OCR2B=0xFF; // выключение преобразователя
; 0000 018E //
; 0000 018F 
; 0000 0190 
; 0000 0191 for(n=0;n<31;n++) sost[n] = esost[n]; // загрузка состояния с флеша.
	CLR  R7
_0x16:
	LDI  R30,LOW(31)
	CP   R7,R30
	BRSH _0x17
	CALL SUBOPT_0x1
	INC  R7
	RJMP _0x16
_0x17:
; 0000 0193 while (1)
_0x18:
; 0000 0194     {
; 0000 0195       for (i = 0 ; i < 128 ; i++)
	CLR  R14
_0x1C:
	LDI  R30,LOW(128)
	CP   R14,R30
	BRLO PC+2
	RJMP _0x1D
; 0000 0196       {
; 0000 0197           if(kn1&kn3) nagh = 0;  // сброс флага нажатия при отпущеной кнопке
	LDI  R26,0
	SBIC 0x6,0
	LDI  R26,1
	LDI  R30,0
	SBIC 0x6,2
	LDI  R30,1
	AND  R30,R26
	BREQ _0x1E
	CBI  0x1E,6
; 0000 0198           if(!kn1)
_0x1E:
	SBIC 0x6,0
	RJMP _0x21
; 0000 0199           {
; 0000 019A             if(!nagh)  // если кнопка только-что нажата
	SBIC 0x1E,6
	RJMP _0x22
; 0000 019B             {
; 0000 019C                 nagh = 1;
	SBI  0x1E,6
; 0000 019D                 lcd_gotoxy(3,0);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0000 019E                 if (fix)
	SBIS 0x1E,5
	RJMP _0x25
; 0000 019F                 {
; 0000 01A0                     fix  = 0;         // если была включена фиксация, - выключить
	CBI  0x1E,5
; 0000 01A1                     lcd_putchar(' ');
	LDI  R26,LOW(32)
	RJMP _0xF6
; 0000 01A2                 }
; 0000 01A3                 else
_0x25:
; 0000 01A4                 {
; 0000 01A5                     fix = 1;         // включить фиксацию
	SBI  0x1E,5
; 0000 01A6                     page = (i / 32); // на какой странице зафиксировано
	MOV  R26,R14
	LDI  R27,0
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	CALL __DIVW21
	STS  _page,R30
; 0000 01A7                     if (page == 0) page = 4;
	CPI  R30,0
	BRNE _0x2B
	LDI  R30,LOW(4)
	STS  _page,R30
; 0000 01A8                     page--;
_0x2B:
	LDS  R30,_page
	SUBI R30,LOW(1)
	STS  _page,R30
; 0000 01A9                     page *= 32;
	LDI  R26,LOW(32)
	MULS R30,R26
	MOVW R30,R0
	STS  _page,R30
; 0000 01AA                     pos = 0;
	LDI  R30,LOW(0)
	STS  _pos,R30
; 0000 01AB                     x_dysp = 5;
	LDI  R30,LOW(5)
	STS  _x_dysp,R30
; 0000 01AC                     y_dysp = 0;
	LDI  R30,LOW(0)
	STS  _y_dysp,R30
; 0000 01AD                     lcd_putchar('F');
	LDI  R26,LOW(70)
_0xF6:
	CALL _lcd_putchar
; 0000 01AE                 }
; 0000 01AF 
; 0000 01B0             }
; 0000 01B1 
; 0000 01B2           }
_0x22:
; 0000 01B3           if(fix)
_0x21:
	SBIS 0x1E,5
	RJMP _0x2C
; 0000 01B4           {
; 0000 01B5             if(p10++ == 0)
	LDS  R30,_p10
	SUBI R30,-LOW(1)
	STS  _p10,R30
	SUBI R30,LOW(1)
	BRNE _0x2D
; 0000 01B6             {
; 0000 01B7             // отображение подч
; 0000 01B8 
; 0000 01B9                     lcd_gotoxy(x_dysp,y_dysp);
	CALL SUBOPT_0x2
; 0000 01BA                     lcd_putchar('_');
	LDI  R26,LOW(95)
	CALL _lcd_putchar
; 0000 01BB 
; 0000 01BC             }
; 0000 01BD             if(p10 == 8)
_0x2D:
	LDS  R26,_p10
	CPI  R26,LOW(0x8)
	BRNE _0x2E
; 0000 01BE             {
; 0000 01BF                 // отображение текущего состояние точки n
; 0000 01C0 
; 0000 01C1                                 sig_bayt = (pos+page) / 4;    // текущий байт в слове состояния
	CALL SUBOPT_0x3
; 0000 01C2                                 sig_bit = ((pos + page) - (sig_bayt * 4)) * 2;   // текущая двухбитовая пара в слове сос ...
; 0000 01C3                                 lcd_gotoxy(x_dysp,y_dysp);
	CALL SUBOPT_0x2
; 0000 01C4                                 if((sost[sig_bayt]&(1<<sig_bit)))
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
	BREQ _0x2F
; 0000 01C5                                 {
; 0000 01C6                                      if((sost[sig_bayt]&(1<<(sig_bit+1)))) lcd_putchar(255);
	CALL SUBOPT_0x4
	CALL SUBOPT_0x6
	BREQ _0x30
	LDI  R26,LOW(255)
	RJMP _0xF7
; 0000 01C7                                      else  lcd_putchar('.');
_0x30:
	LDI  R26,LOW(46)
_0xF7:
	CALL _lcd_putchar
; 0000 01C8                                 } else lcd_putchar(' ');
	RJMP _0x32
_0x2F:
	LDI  R26,LOW(32)
	CALL _lcd_putchar
; 0000 01C9 
; 0000 01CA 
; 0000 01CB             }
_0x32:
; 0000 01CC             if(p10 > 16)
_0x2E:
	LDS  R26,_p10
	CPI  R26,LOW(0x11)
	BRSH PC+2
	RJMP _0x33
; 0000 01CD             {
; 0000 01CE                 p10 = 0;
	LDI  R30,LOW(0)
	STS  _p10,R30
; 0000 01CF 
; 0000 01D0                 if(!kn2)
	SBIC 0x6,1
	RJMP _0x34
; 0000 01D1                 {
; 0000 01D2                     if(++pos >  30)
	LDS  R26,_pos
	SUBI R26,-LOW(1)
	STS  _pos,R26
	CPI  R26,LOW(0x1F)
	BRLO _0x35
; 0000 01D3                     {
; 0000 01D4                         pos = 0;
	LDI  R30,LOW(0)
	STS  _pos,R30
; 0000 01D5                         x_dysp = 3;
	LDI  R30,LOW(3)
	STS  _x_dysp,R30
; 0000 01D6                         y_dysp = 0;
	LDI  R30,LOW(0)
	STS  _y_dysp,R30
; 0000 01D7                     }
; 0000 01D8                     else if(pos == 15) pos++;
	RJMP _0x36
_0x35:
	LDS  R26,_pos
	CPI  R26,LOW(0xF)
	BRNE _0x37
	LDS  R30,_pos
	SUBI R30,-LOW(1)
	STS  _pos,R30
; 0000 01D9                     x_dysp++;
_0x37:
_0x36:
	LDS  R30,_x_dysp
	SUBI R30,-LOW(1)
	STS  _x_dysp,R30
; 0000 01DA                     if(++x_dysp > 15)
	LDS  R26,_x_dysp
	SUBI R26,-LOW(1)
	STS  _x_dysp,R26
	CPI  R26,LOW(0x10)
	BRLO _0x38
; 0000 01DB                     {
; 0000 01DC                         y_dysp++;
	LDS  R30,_y_dysp
	SUBI R30,-LOW(1)
	STS  _y_dysp,R30
; 0000 01DD                         x_dysp = 1;
	LDI  R30,LOW(1)
	STS  _x_dysp,R30
; 0000 01DE                     }
; 0000 01DF 
; 0000 01E0                 }
_0x38:
; 0000 01E1                 if(!kn3)
_0x34:
	SBIC 0x6,2
	RJMP _0x39
; 0000 01E2                 {
; 0000 01E3                     if(!nagh)  // если кнопка только-что нажата
	SBIC 0x1E,6
	RJMP _0x3A
; 0000 01E4                     {
; 0000 01E5                     nagh = 1;
	SBI  0x1E,6
; 0000 01E6                      // включение - выключение охраны
; 0000 01E7                     lcd_gotoxy(x_dysp,y_dysp);
	CALL SUBOPT_0x2
; 0000 01E8                                 sig_bayt = (pos+page) / 4;    // текущий байт в слове состояния
	CALL SUBOPT_0x3
; 0000 01E9                                 sig_bit = ((pos + page) - (sig_bayt * 4)) * 2;   // текущая двухбитовая пара в слове сос ...
; 0000 01EA                                 if((sost[sig_bayt]&(1<<sig_bit)))
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
	BREQ _0x3D
; 0000 01EB                                 {
; 0000 01EC                                     sost[sig_bayt] &= ~(1<<sig_bit);     // выкл. охрану
	CALL SUBOPT_0x7
	COM  R30
	AND  R30,R1
	MOVW R26,R22
	ST   X,R30
; 0000 01ED                                     lcd_putchar(' ');
	LDI  R26,LOW(32)
	RJMP _0xF8
; 0000 01EE                                 } else
_0x3D:
; 0000 01EF                                 {
; 0000 01F0                                     sost[sig_bayt] |= (1<<sig_bit);      // включаем охрану
	CALL SUBOPT_0x7
	OR   R30,R1
	MOVW R26,R22
	ST   X,R30
; 0000 01F1                                     lcd_putchar('.');
	LDI  R26,LOW(46)
_0xF8:
	CALL _lcd_putchar
; 0000 01F2                                 }
; 0000 01F3                     }
; 0000 01F4                 }
_0x3A:
; 0000 01F5             }
_0x39:
; 0000 01F6           }
_0x33:
; 0000 01F7           sig_bayt = i / 4;    // текущий байт в слове состояния
_0x2C:
	MOV  R26,R14
	LDI  R27,0
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __DIVW21
	MOV  R13,R30
; 0000 01F8           sig_bit = (i - sig_bayt * 4) * 2;   // текущая двухбитовая пара в слове состояния
	LSL  R30
	LSL  R30
	MOV  R26,R30
	MOV  R30,R14
	SUB  R30,R26
	LSL  R30
	STS  _sig_bit,R30
; 0000 01F9           OCR0A=0x00;
	CALL SUBOPT_0x8
; 0000 01FA           a = 49728;
; 0000 01FB           TCCR0A |= (1<<CS00);  // включить таймер 0;
	ORI  R30,1
	OUT  0x24,R30
; 0000 01FC           TIMSK0 |= (1<<TOIE0); //
	LDS  R30,110
	ORI  R30,1
	STS  110,R30
; 0000 01FD           time = 0;
	CALL SUBOPT_0x9
; 0000 01FE           while (time < 6) #asm("wdr");  // задержка 25 мСек
_0x3F:
	CALL SUBOPT_0xA
	__CPD2N 0x6
	BRSH _0x41
	wdr
; 0000 01FF           zvuk = 0;
	RJMP _0x3F
_0x41:
	CBI  0xB,5
; 0000 0200           if(i == 0) while (time < 75) #asm("wdr"); // если первый шаг, задержка 300 мСек
	TST  R14
	BRNE _0x44
_0x45:
	CALL SUBOPT_0xA
	__CPD2N 0x4B
	BRSH _0x47
	wdr
; 0000 0201           TIMSK0 &= ~(1<<TOIE0); //
	RJMP _0x45
_0x47:
_0x44:
	LDS  R30,110
	ANDI R30,0xFE
	STS  110,R30
; 0000 0202           OCR0A=0x00;
	CALL SUBOPT_0x8
; 0000 0203           a = 49728;
; 0000 0204           TCCR0A &= ~(1<<CS00);    // выкл таймер 0
	ANDI R30,0xFE
	OUT  0x24,R30
; 0000 0205           vyh_t0 = 0;            // переключить а вход
	CBI  0xA,6
; 0000 0206           ACSR |= (1<<ACIE); // включить перывания от компарат
	IN   R30,0x30
	ORI  R30,8
	OUT  0x30,R30
; 0000 0207           time = 0;
	CALL SUBOPT_0x9
; 0000 0208           while (time < 9) #asm("wdr");    // 25мСек + 12
_0x4A:
	CALL SUBOPT_0xA
	__CPD2N 0x9
	BRSH _0x4C
	wdr
; 0000 0209           ACSR &= ~(1<<ACIE); // выкл прер компар
	RJMP _0x4A
_0x4C:
	IN   R30,0x30
	ANDI R30,0XF7
	OUT  0x30,R30
; 0000 020A           vyh_t0 = 1;            // переключить а вyход
	SBI  0xA,6
; 0000 020B           if (flag435) // если был отлет 435 Гц
	SBIS 0x1E,0
	RJMP _0x4F
; 0000 020C           {
; 0000 020D             switch (i)
	MOV  R30,R14
	LDI  R31,0
; 0000 020E             {
; 0000 020F                 case 31:
	CPI  R30,LOW(0x1F)
	LDI  R26,HIGH(0x1F)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x53
; 0000 0210                     // вывод первой половины на дисп
; 0000 0211                     if (!fix)
	SBIC 0x1E,5
	RJMP _0x54
; 0000 0212                     {
; 0000 0213                         clear_lcd();
	CALL SUBOPT_0xB
; 0000 0214                         lcd_gotoxy(0,0);
; 0000 0215                         lcd_putsf("1   ");
	__POINTW2FN _0x0,79
	CALL SUBOPT_0xC
; 0000 0216                         n = 1;
; 0000 0217                         for (sig_bayt = 0; sig_bayt < 8 ; sig_bayt++)
	CLR  R13
_0x56:
	LDI  R30,LOW(8)
	CP   R13,R30
	BRSH _0x57
; 0000 0218                         {
; 0000 0219                             for(sig_bit = 0; (sig_bayt == 3 || sig_bayt == 7)? sig_bit < 6: sig_bit < 8; sig_bit += 2)
	LDI  R30,LOW(0)
	STS  _sig_bit,R30
_0x59:
	LDI  R30,LOW(3)
	CP   R30,R13
	BREQ _0x5B
	LDI  R30,LOW(7)
	CP   R30,R13
	BRNE _0x5D
_0x5B:
	LDS  R26,_sig_bit
	LDI  R30,LOW(6)
	RJMP _0xF9
_0x5D:
	LDS  R26,_sig_bit
	LDI  R30,LOW(8)
_0xF9:
	CALL __LTB12U
	CPI  R30,0
	BREQ _0x5A
; 0000 021A                             {
; 0000 021B                                 if(++n>10) n = 1;
	INC  R7
	LDI  R30,LOW(10)
	CP   R30,R7
	BRSH _0x60
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 021C                                 lcd_putchar(47+n);
_0x60:
	CALL SUBOPT_0xD
; 0000 021D                                 if((sost[sig_bayt]&(1<<sig_bit)))
	CALL SUBOPT_0x5
	BREQ _0x61
; 0000 021E                                 {
; 0000 021F                                      if((sost[sig_bayt]&(1<<(sig_bit+1)))) lcd_putchar(255);
	CALL SUBOPT_0x4
	CALL SUBOPT_0x6
	BREQ _0x62
	LDI  R26,LOW(255)
	RJMP _0xFA
; 0000 0220                                      else  lcd_putchar('.');
_0x62:
	LDI  R26,LOW(46)
_0xFA:
	CALL _lcd_putchar
; 0000 0221                                 } else lcd_putchar(' ');
	RJMP _0x64
_0x61:
	LDI  R26,LOW(32)
	CALL _lcd_putchar
; 0000 0222                             }
_0x64:
	CALL SUBOPT_0xE
	RJMP _0x59
_0x5A:
; 0000 0223                         }
	INC  R13
	RJMP _0x56
_0x57:
; 0000 0224                     }
; 0000 0225                     pit_ok = 1;
_0x54:
	SBI  0x1E,2
; 0000 0226                     while (time < 125) #asm("wdr");  // задержка до 0.5 сек
_0x67:
	CALL SUBOPT_0xF
	BRSH _0x69
	wdr
; 0000 0227                     break;
	RJMP _0x67
_0x69:
	RJMP _0x52
; 0000 0228                 case 15:
_0x53:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BREQ _0x6B
; 0000 0229                 case 47:
	CPI  R30,LOW(0x2F)
	LDI  R26,HIGH(0x2F)
	CPC  R31,R26
	BRNE _0x6C
_0x6B:
; 0000 022A                 case 63:
	RJMP _0x6D
_0x6C:
	CPI  R30,LOW(0x3F)
	LDI  R26,HIGH(0x3F)
	CPC  R31,R26
	BRNE _0x6E
_0x6D:
; 0000 022B                 case 79:
	RJMP _0x6F
_0x6E:
	CPI  R30,LOW(0x4F)
	LDI  R26,HIGH(0x4F)
	CPC  R31,R26
	BRNE _0x70
_0x6F:
; 0000 022C                 case 95:
	RJMP _0x71
_0x70:
	CPI  R30,LOW(0x5F)
	LDI  R26,HIGH(0x5F)
	CPC  R31,R26
	BRNE _0x72
_0x71:
; 0000 022D                 case 111:
	RJMP _0x73
_0x72:
	CPI  R30,LOW(0x6F)
	LDI  R26,HIGH(0x6F)
	CPC  R31,R26
	BRNE _0x74
_0x73:
; 0000 022E                 case 127:
	RJMP _0x75
_0x74:
	CPI  R30,LOW(0x7F)
	LDI  R26,HIGH(0x7F)
	CPC  R31,R26
	BRNE _0x7B
_0x75:
; 0000 022F                     sinc_err = 1;      // ошибка синхронизации
	SBI  0x1E,3
; 0000 0230                     zvuk = 1;
	SBI  0xB,5
; 0000 0231                     break;
	RJMP _0x52
; 0000 0232                 default:
_0x7B:
; 0000 0233                     if (sost[sig_bayt]&(1<<sig_bit))   // если под охраной
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
	BREQ _0x7C
; 0000 0234                     {
; 0000 0235                         if ((esost[sig_bayt]&(1<<sig_bit) == 0))
	CALL SUBOPT_0x10
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __LSLW12
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	CALL __EQW12
	AND  R30,R1
	BREQ _0x7D
; 0000 0236                         {
; 0000 0237                             //если не был под охр. поставить под охрану.
; 0000 0238                             OCR2B=0x50; // выдача на шим
	LDI  R30,LOW(80)
	STS  180,R30
; 0000 0239                             vyh_plus = 1;
	SBI  0xB,4
; 0000 023A                             esost[sig_bayt] |= (1<<sig_bit);      // включаем охрану
	CALL SUBOPT_0x11
	OR   R30,R1
	MOVW R26,R22
	CALL __EEPROMWRB
; 0000 023B                         }
; 0000 023C                         else
	RJMP _0x80
_0x7D:
; 0000 023D                         {
; 0000 023E                         // если объекм был по охраной тревога
; 0000 023F                             sost[sig_bayt] |= (1<<(sig_bit+1));
	MOV  R30,R13
	LDI  R31,0
	SUBI R30,LOW(-_sost)
	SBCI R31,HIGH(-_sost)
	MOVW R22,R30
	LD   R1,Z
	LDS  R30,_sig_bit
	SUBI R30,-LOW(1)
	LDI  R26,LOW(1)
	CALL __LSLB12
	OR   R30,R1
	MOVW R26,R22
	ST   X,R30
; 0000 0240                             trevoga = 1;
	SBI  0x1E,1
; 0000 0241                             zvuk = 1;
	SBI  0xB,5
; 0000 0242                         }
_0x80:
; 0000 0243                         while(time<375) #asm("wdr");
_0x85:
	CALL SUBOPT_0x12
	BRSH _0x87
	wdr
; 0000 0244                         vyh_plus = 0;
	RJMP _0x85
_0x87:
	CBI  0xB,4
; 0000 0245                         OCR2B=0xFF;
	RJMP _0xFB
; 0000 0246                     }
; 0000 0247                     else  if (esost[sig_bayt]&(1<<sig_bit))  // не под охр, но был
_0x7C:
	CALL SUBOPT_0x10
	CALL SUBOPT_0x5
	BREQ _0x8B
; 0000 0248                     {
; 0000 0249                             //если был под охр. снять с охр.
; 0000 024A                             OCR2B=0xB0; // выдача на шим
	CALL SUBOPT_0x13
; 0000 024B                             vyh_minus = 1;
; 0000 024C                             esost[sig_bayt] &= ~(1<<sig_bit);      //
	COM  R30
	AND  R30,R1
	MOVW R26,R22
	CALL __EEPROMWRB
; 0000 024D                             while(time<375) #asm("wdr");
_0x8E:
	CALL SUBOPT_0x12
	BRSH _0x90
	wdr
; 0000 024E                             vyh_minus = 0;
	RJMP _0x8E
_0x90:
	CBI  0xB,2
; 0000 024F                             OCR2B=0xFF;
_0xFB:
	LDI  R30,LOW(255)
	STS  180,R30
; 0000 0250 
; 0000 0251                     }
; 0000 0252 
; 0000 0253             }
_0x8B:
_0x52:
; 0000 0254           }
; 0000 0255           else      // если не было ответа
	RJMP _0x93
_0x4F:
; 0000 0256           {
; 0000 0257             switch (i)
	MOV  R30,R14
	LDI  R31,0
; 0000 0258             {
; 0000 0259                 case 31:
	CPI  R30,LOW(0x1F)
	LDI  R26,HIGH(0x1F)
	CPC  R31,R26
	BRNE _0x97
; 0000 025A                     // вкл питание
; 0000 025B 
; 0000 025C                     if (!fix)
	SBIC 0x1E,5
	RJMP _0x98
; 0000 025D                     {
; 0000 025E                         clear_lcd();
	CALL SUBOPT_0x14
; 0000 025F                         lcd_gotoxy(0,1);
; 0000 0260                         lcd_putsf("Error Pitanie!!!");
	__POINTW2FN _0x0,84
	CALL _lcd_putsf
; 0000 0261                     }
; 0000 0262 
; 0000 0263                     pit_err = 1;
_0x98:
	SBI  0x1E,4
; 0000 0264                     pit_ok = 0;
	CBI  0x1E,2
; 0000 0265                     break;
	RJMP _0x96
; 0000 0266                 case 63:
_0x97:
	CPI  R30,LOW(0x3F)
	LDI  R26,HIGH(0x3F)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x9D
; 0000 0267                     // вывод второй половины на дисп
; 0000 0268                     if (!fix)
	SBIC 0x1E,5
	RJMP _0x9E
; 0000 0269                     {
; 0000 026A                         clear_lcd();
	CALL SUBOPT_0xB
; 0000 026B                         lcd_gotoxy(0,0);
; 0000 026C                         lcd_putsf("31  ");
	__POINTW2FN _0x0,101
	CALL SUBOPT_0xC
; 0000 026D                         n = 1;
; 0000 026E                         for (sig_bayt = 8; sig_bayt < 16 ; sig_bayt++)
	LDI  R30,LOW(8)
	MOV  R13,R30
_0xA0:
	LDI  R30,LOW(16)
	CP   R13,R30
	BRSH _0xA1
; 0000 026F                         {
; 0000 0270                             for(sig_bit = 0; (sig_bayt == 11 || sig_bayt == 15)? sig_bit < 6: sig_bit < 8; sig_bit += 2)
	LDI  R30,LOW(0)
	STS  _sig_bit,R30
_0xA3:
	LDI  R30,LOW(11)
	CP   R30,R13
	BREQ _0xA5
	LDI  R30,LOW(15)
	CP   R30,R13
	BRNE _0xA7
_0xA5:
	LDS  R26,_sig_bit
	LDI  R30,LOW(6)
	RJMP _0xFC
_0xA7:
	LDS  R26,_sig_bit
	LDI  R30,LOW(8)
_0xFC:
	CALL __LTB12U
	CPI  R30,0
	BREQ _0xA4
; 0000 0271                             {
; 0000 0272                                 if(++n>10) n = 1;
	INC  R7
	LDI  R30,LOW(10)
	CP   R30,R7
	BRSH _0xAA
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 0273                                 lcd_putchar(47+n);
_0xAA:
	CALL SUBOPT_0xD
; 0000 0274                                 if((sost[sig_bayt]&(1<<sig_bit)))
	CALL SUBOPT_0x5
	BREQ _0xAB
; 0000 0275                                 {
; 0000 0276                                      if((sost[sig_bayt]&(1<<(sig_bit+1)))) lcd_putchar(255);
	CALL SUBOPT_0x4
	CALL SUBOPT_0x6
	BREQ _0xAC
	LDI  R26,LOW(255)
	RJMP _0xFD
; 0000 0277                                      else  lcd_putchar('.');
_0xAC:
	LDI  R26,LOW(46)
_0xFD:
	CALL _lcd_putchar
; 0000 0278                                 } else lcd_putchar(' ');
	RJMP _0xAE
_0xAB:
	LDI  R26,LOW(32)
	CALL _lcd_putchar
; 0000 0279                             }
_0xAE:
	CALL SUBOPT_0xE
	RJMP _0xA3
_0xA4:
; 0000 027A                         }
	INC  R13
	RJMP _0xA0
_0xA1:
; 0000 027B                     }
; 0000 027C 
; 0000 027D                     break;
_0x9E:
	RJMP _0x96
; 0000 027E                 case 95:
_0x9D:
	CPI  R30,LOW(0x5F)
	LDI  R26,HIGH(0x5F)
	CPC  R31,R26
	BRNE _0xAF
; 0000 027F                     // вывод третьей половины на дисп
; 0000 0280                     if (!fix)
	SBIC 0x1E,5
	RJMP _0xB0
; 0000 0281                     {
; 0000 0282                         clear_lcd();
	CALL SUBOPT_0xB
; 0000 0283                         lcd_gotoxy(0,0);
; 0000 0284                         lcd_putsf("61  ");
	__POINTW2FN _0x0,106
	CALL SUBOPT_0xC
; 0000 0285                         n = 1;
; 0000 0286                         for (sig_bayt = 16; sig_bayt < 24 ; sig_bayt++)
	LDI  R30,LOW(16)
	MOV  R13,R30
_0xB2:
	LDI  R30,LOW(24)
	CP   R13,R30
	BRSH _0xB3
; 0000 0287                         {
; 0000 0288                             for(sig_bit = 0; (sig_bayt == 19 || sig_bayt == 23)? sig_bit < 6: sig_bit < 8; sig_bit += 2)
	LDI  R30,LOW(0)
	STS  _sig_bit,R30
_0xB5:
	LDI  R30,LOW(19)
	CP   R30,R13
	BREQ _0xB7
	LDI  R30,LOW(23)
	CP   R30,R13
	BRNE _0xB9
_0xB7:
	LDS  R26,_sig_bit
	LDI  R30,LOW(6)
	RJMP _0xFE
_0xB9:
	LDS  R26,_sig_bit
	LDI  R30,LOW(8)
_0xFE:
	CALL __LTB12U
	CPI  R30,0
	BREQ _0xB6
; 0000 0289                             {
; 0000 028A                                 if(++n>10) n = 1;
	INC  R7
	LDI  R30,LOW(10)
	CP   R30,R7
	BRSH _0xBC
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 028B                                 lcd_putchar(47+n);
_0xBC:
	CALL SUBOPT_0xD
; 0000 028C                                 if((sost[sig_bayt]&(1<<sig_bit)))
	CALL SUBOPT_0x5
	BREQ _0xBD
; 0000 028D                                 {
; 0000 028E                                      if((sost[sig_bayt]&(1<<(sig_bit+1)))) lcd_putchar(255);
	CALL SUBOPT_0x4
	CALL SUBOPT_0x6
	BREQ _0xBE
	LDI  R26,LOW(255)
	RJMP _0xFF
; 0000 028F                                      else  lcd_putchar('.');
_0xBE:
	LDI  R26,LOW(46)
_0xFF:
	RCALL _lcd_putchar
; 0000 0290                                 } else lcd_putchar(' ');
	RJMP _0xC0
_0xBD:
	LDI  R26,LOW(32)
	RCALL _lcd_putchar
; 0000 0291                             }
_0xC0:
	CALL SUBOPT_0xE
	RJMP _0xB5
_0xB6:
; 0000 0292                         }
	INC  R13
	RJMP _0xB2
_0xB3:
; 0000 0293                     }
; 0000 0294                     break;
_0xB0:
	RJMP _0x96
; 0000 0295                 case 127:
_0xAF:
	CPI  R30,LOW(0x7F)
	LDI  R26,HIGH(0x7F)
	CPC  R31,R26
	BRNE _0xC1
; 0000 0296                     // вывод четвертой половины на дисп
; 0000 0297                     if (!fix)
	SBIC 0x1E,5
	RJMP _0xC2
; 0000 0298                     {
; 0000 0299                         clear_lcd();
	CALL SUBOPT_0xB
; 0000 029A                         lcd_gotoxy(0,0);
; 0000 029B                         lcd_putsf("91  ");
	__POINTW2FN _0x0,111
	CALL SUBOPT_0xC
; 0000 029C                         n = 1;
; 0000 029D                         for (sig_bayt = 24; sig_bayt < 32; sig_bayt++)
	LDI  R30,LOW(24)
	MOV  R13,R30
_0xC4:
	LDI  R30,LOW(32)
	CP   R13,R30
	BRSH _0xC5
; 0000 029E                         {
; 0000 029F                             for(sig_bit = 0; (sig_bayt == 27 || sig_bayt == 31)? sig_bit < 6: sig_bit < 8; sig_bit += 2)
	LDI  R30,LOW(0)
	STS  _sig_bit,R30
_0xC7:
	LDI  R30,LOW(27)
	CP   R30,R13
	BREQ _0xC9
	LDI  R30,LOW(31)
	CP   R30,R13
	BRNE _0xCB
_0xC9:
	LDS  R26,_sig_bit
	LDI  R30,LOW(6)
	RJMP _0x100
_0xCB:
	LDS  R26,_sig_bit
	LDI  R30,LOW(8)
_0x100:
	CALL __LTB12U
	CPI  R30,0
	BREQ _0xC8
; 0000 02A0                             {
; 0000 02A1                                 if(++n>10) n = 1;
	INC  R7
	LDI  R30,LOW(10)
	CP   R30,R7
	BRSH _0xCE
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 02A2                                 lcd_putchar(47+n);
_0xCE:
	CALL SUBOPT_0xD
; 0000 02A3                                 if((sost[sig_bayt]&(1<<sig_bit)))
	CALL SUBOPT_0x5
	BREQ _0xCF
; 0000 02A4                                 {
; 0000 02A5                                      if((sost[sig_bayt]&(1<<(sig_bit+1)))) lcd_putchar(255);
	CALL SUBOPT_0x4
	CALL SUBOPT_0x6
	BREQ _0xD0
	LDI  R26,LOW(255)
	RJMP _0x101
; 0000 02A6                                      else  lcd_putchar('.');
_0xD0:
	LDI  R26,LOW(46)
_0x101:
	RCALL _lcd_putchar
; 0000 02A7                                 } else lcd_putchar(' ');
	RJMP _0xD2
_0xCF:
	LDI  R26,LOW(32)
	RCALL _lcd_putchar
; 0000 02A8                             }
_0xD2:
	CALL SUBOPT_0xE
	RJMP _0xC7
_0xC8:
; 0000 02A9                         }
	INC  R13
	RJMP _0xC4
_0xC5:
; 0000 02AA                     }
; 0000 02AB //                    for(n=0;n<32;n++) if (sost[n] != esost[n]) esost[n] = sost[n]; // запись изменений в еепром
; 0000 02AC                     break;
_0xC2:
	RJMP _0x96
; 0000 02AD                 case 15:
_0xC1:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BREQ _0xD4
; 0000 02AE                 case 47:
	CPI  R30,LOW(0x2F)
	LDI  R26,HIGH(0x2F)
	CPC  R31,R26
	BRNE _0xD5
_0xD4:
; 0000 02AF                 case 79:
	RJMP _0xD6
_0xD5:
	CPI  R30,LOW(0x4F)
	LDI  R26,HIGH(0x4F)
	CPC  R31,R26
	BRNE _0xD7
_0xD6:
; 0000 02B0                 case 111:
	RJMP _0xD8
_0xD7:
	CPI  R30,LOW(0x6F)
	LDI  R26,HIGH(0x6F)
	CPC  R31,R26
	BRNE _0xDA
_0xD8:
; 0000 02B1                     break;
	RJMP _0x96
; 0000 02B2                 default:
_0xDA:
; 0000 02B3                     if ((sost[sig_bayt]&(1<<sig_bit)) == 0)
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
	BRNE _0xDB
; 0000 02B4                     {
; 0000 02B5 
; 0000 02B6                         if (esost[sig_bayt]&(1<<sig_bit))  // не под охр, но был
	CALL SUBOPT_0x10
	CALL SUBOPT_0x5
	BREQ _0xDC
; 0000 02B7                         {
; 0000 02B8                             //если был под охр. снять с охр.
; 0000 02B9                             OCR2B=0xB0; // выдача на шим
	CALL SUBOPT_0x13
; 0000 02BA                             vyh_minus = 1;
; 0000 02BB                             esost[sig_bayt] &= ~(1<<sig_bit);      //
	COM  R30
	AND  R30,R1
	MOVW R26,R22
	CALL __EEPROMWRB
; 0000 02BC                             while(time<375) #asm("wdr");
_0xDF:
	CALL SUBOPT_0x12
	BRSH _0xE1
	wdr
; 0000 02BD                             vyh_minus = 0;
	RJMP _0xDF
_0xE1:
	CBI  0xB,2
; 0000 02BE                             OCR2B=0xFF;
	LDI  R30,LOW(255)
	STS  180,R30
; 0000 02BF 
; 0000 02C0                         }
; 0000 02C1                         else  zvuk = 1; // звук если нет ответа от номера не под охраной
	RJMP _0xE4
_0xDC:
	SBI  0xB,5
; 0000 02C2                     }
_0xE4:
; 0000 02C3 
; 0000 02C4             }
_0xDB:
_0x96:
; 0000 02C5 
; 0000 02C6           }
_0x93:
; 0000 02C7           flag435 = 0;
	CBI  0x1E,0
; 0000 02C8           if (pit_ok)
	SBIS 0x1E,2
	RJMP _0xE9
; 0000 02C9           {
; 0000 02CA             while (time < 125) #asm("wdr");
_0xEA:
	CALL SUBOPT_0xF
	BRSH _0xEC
	wdr
; 0000 02CB             pit_ok = 0;
	RJMP _0xEA
_0xEC:
	CBI  0x1E,2
; 0000 02CC           }
; 0000 02CD 
; 0000 02CE //          if (trevoga) //while (time < 375);
; 0000 02CF //          trevoga = 0;
; 0000 02D0           if (sinc_err)
_0xE9:
	SBIS 0x1E,3
	RJMP _0xEF
; 0000 02D1           {
; 0000 02D2             sinc_err = 0;
	CBI  0x1E,3
; 0000 02D3             if (!fix)
	SBIC 0x1E,5
	RJMP _0xF2
; 0000 02D4             {
; 0000 02D5                 clear_lcd();
	CALL SUBOPT_0x14
; 0000 02D6                 lcd_gotoxy(0,1);
; 0000 02D7                 lcd_putsf("  Error Sync!!! ");
	__POINTW2FN _0x0,116
	RCALL _lcd_putsf
; 0000 02D8             } else
	RJMP _0xF3
_0xF2:
; 0000 02D9             {
; 0000 02DA                 lcd_gotoxy(3,0);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
; 0000 02DB                 lcd_putchar('F');
	LDI  R26,LOW(70)
	RCALL _lcd_putchar
; 0000 02DC             }
_0xF3:
; 0000 02DD             break;
	RJMP _0x1D
; 0000 02DE           }
; 0000 02DF       }
_0xEF:
	INC  R14
	RJMP _0x1C
_0x1D:
; 0000 02E0 
; 0000 02E1 
; 0000 02E2     }
	RJMP _0x18
; 0000 02E3 
; 0000 02E4 }
_0xF4:
	RJMP _0xF4
; .FEND
;
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2000004
	SBI  0x5,2
	RJMP _0x2000005
_0x2000004:
	CBI  0x5,2
_0x2000005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2000006
	SBI  0x5,3
	RJMP _0x2000007
_0x2000006:
	CBI  0x5,3
_0x2000007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2000008
	SBI  0x5,4
	RJMP _0x2000009
_0x2000008:
	CBI  0x5,4
_0x2000009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x200000A
	SBI  0x5,5
	RJMP _0x200000B
_0x200000A:
	CBI  0x5,5
_0x200000B:
	__DELAY_USB 27
	SBI  0x5,1
	__DELAY_USB 27
	CBI  0x5,1
	__DELAY_USB 27
	RJMP _0x20A0001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RJMP _0x20A0001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x15
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x15
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000011
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2000010
_0x2000011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000013
	RJMP _0x20A0001
_0x2000013:
_0x2000010:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x5,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x5,0
	RJMP _0x20A0001
; .FEND
_lcd_putsf:
; .FSTART _lcd_putsf
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000017:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000019
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000017
_0x2000019:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	SBI  0x4,2
	SBI  0x4,3
	SBI  0x4,4
	SBI  0x4,5
	SBI  0x4,1
	SBI  0x4,0
	SBI  0x4,7
	CBI  0x5,1
	CBI  0x5,0
	CBI  0x5,7
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x16
	CALL SUBOPT_0x16
	CALL SUBOPT_0x16
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 400
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20A0001:
	ADIW R28,1
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif

	.DSEG

	.CSEG
_twi_slave_init:
; .FSTART _twi_slave_init
	ST   -Y,R27
	ST   -Y,R26
	SET
	BLD  R2,0
	LDI  R30,LOW(7)
	STS  _twi_result,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	STS  _twi_rx_buffer_G102,R30
	STS  _twi_rx_buffer_G102+1,R31
	LDD  R30,Y+6
	STS  _twi_rx_buffer_size_G102,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	STS  _twi_tx_buffer_G102,R30
	STS  _twi_tx_buffer_G102+1,R31
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	STS  _twi_slave_rx_handler_G102,R30
	STS  _twi_slave_rx_handler_G102+1,R31
	LD   R30,Y
	LDD  R31,Y+1
	STS  _twi_slave_tx_handler_G102,R30
	STS  _twi_slave_tx_handler_G102+1,R31
	SBI  0x8,4
	SBI  0x8,5
	LDD  R30,Y+10
	CPI  R30,0
	BREQ _0x2040016
	LDI  R30,LOW(1)
	STS  186,R30
	LDI  R30,LOW(254)
	RJMP _0x2040073
_0x2040016:
	LDD  R30,Y+9
	LSL  R30
	STS  186,R30
	LDI  R30,LOW(0)
_0x2040073:
	STS  189,R30
	LDS  R30,188
	ANDI R30,LOW(0x80)
	ORI  R30,LOW(0x45)
	STS  188,R30
	ADIW R28,11
	RET
; .FEND
_twi_int_handler:
; .FSTART _twi_int_handler
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	CALL __SAVELOCR6
	LDS  R17,_twi_rx_index
	LDS  R16,_twi_tx_index
	LDS  R19,_bytes_to_tx_G102
	LDS  R18,_twi_result
	MOV  R30,R17
	LDS  R26,_twi_rx_buffer_G102
	LDS  R27,_twi_rx_buffer_G102+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R20,R30
	LDS  R30,185
	ANDI R30,LOW(0xF8)
	CPI  R30,LOW(0x8)
	BRNE _0x204001B
	LDI  R18,LOW(0)
	RJMP _0x204001C
_0x204001B:
	CPI  R30,LOW(0x10)
	BRNE _0x204001D
_0x204001C:
	LDS  R30,_slave_address_G102
	RJMP _0x2040074
_0x204001D:
	CPI  R30,LOW(0x18)
	BREQ _0x2040021
	CPI  R30,LOW(0x28)
	BRNE _0x2040022
_0x2040021:
	CP   R16,R19
	BRSH _0x2040023
	MOV  R30,R16
	SUBI R16,-1
	LDS  R26,_twi_tx_buffer_G102
	LDS  R27,_twi_tx_buffer_G102+1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
_0x2040074:
	STS  187,R30
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	STS  188,R30
	RJMP _0x2040024
_0x2040023:
	LDS  R30,_bytes_to_rx_G102
	CP   R17,R30
	BRSH _0x2040025
	LDS  R30,_slave_address_G102
	ORI  R30,1
	STS  _slave_address_G102,R30
	CBI  0x1E,7
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xA0)
	STS  188,R30
	RJMP _0x204001A
_0x2040025:
	RJMP _0x2040028
_0x2040024:
	RJMP _0x204001A
_0x2040022:
	CPI  R30,LOW(0x50)
	BRNE _0x2040029
	LDS  R30,187
	MOVW R26,R20
	ST   X,R30
	SUBI R17,-LOW(1)
	RJMP _0x204002A
_0x2040029:
	CPI  R30,LOW(0x40)
	BRNE _0x204002B
_0x204002A:
	LDS  R30,_bytes_to_rx_G102
	SUBI R30,LOW(1)
	CP   R17,R30
	BRLO _0x204002C
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	RJMP _0x2040075
_0x204002C:
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
_0x2040075:
	STS  188,R30
	RJMP _0x204001A
_0x204002B:
	CPI  R30,LOW(0x58)
	BRNE _0x204002E
	LDS  R30,187
	MOVW R26,R20
	ST   X,R30
	SUBI R17,-LOW(1)
	RJMP _0x204002F
_0x204002E:
	CPI  R30,LOW(0x20)
	BRNE _0x2040030
_0x204002F:
	RJMP _0x2040031
_0x2040030:
	CPI  R30,LOW(0x30)
	BRNE _0x2040032
_0x2040031:
	RJMP _0x2040033
_0x2040032:
	CPI  R30,LOW(0x48)
	BRNE _0x2040034
_0x2040033:
	CPI  R18,0
	BRNE _0x2040035
	SBIS 0x1E,7
	RJMP _0x2040036
	CP   R16,R19
	BRLO _0x2040038
	RJMP _0x2040039
_0x2040036:
	LDS  R30,_bytes_to_rx_G102
	CP   R17,R30
	BRSH _0x204003A
_0x2040038:
	LDI  R18,LOW(4)
_0x204003A:
_0x2040039:
_0x2040035:
_0x2040028:
	RJMP _0x2040076
_0x2040034:
	CPI  R30,LOW(0x38)
	BRNE _0x204003D
	LDI  R18,LOW(2)
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	RJMP _0x2040077
_0x204003D:
	CPI  R30,LOW(0x68)
	BREQ _0x2040040
	CPI  R30,LOW(0x78)
	BRNE _0x2040041
_0x2040040:
	LDI  R18,LOW(2)
	RJMP _0x2040042
_0x2040041:
	CPI  R30,LOW(0x60)
	BREQ _0x2040045
	CPI  R30,LOW(0x70)
	BRNE _0x2040046
_0x2040045:
	LDI  R18,LOW(0)
_0x2040042:
	LDI  R17,LOW(0)
	CBI  0x1E,7
	LDS  R30,_twi_rx_buffer_size_G102
	CPI  R30,0
	BRNE _0x2040049
	LDI  R18,LOW(1)
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	RJMP _0x2040078
_0x2040049:
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
_0x2040078:
	STS  188,R30
	RJMP _0x204001A
_0x2040046:
	CPI  R30,LOW(0x80)
	BREQ _0x204004C
	CPI  R30,LOW(0x90)
	BRNE _0x204004D
_0x204004C:
	SBIS 0x1E,7
	RJMP _0x204004E
	LDI  R18,LOW(1)
	RJMP _0x204004F
_0x204004E:
	LDS  R30,187
	MOVW R26,R20
	ST   X,R30
	SUBI R17,-LOW(1)
	LDS  R30,_twi_rx_buffer_size_G102
	CP   R17,R30
	BRSH _0x2040050
	LDS  R30,_twi_slave_rx_handler_G102
	LDS  R31,_twi_slave_rx_handler_G102+1
	SBIW R30,0
	BRNE _0x2040051
	LDI  R18,LOW(6)
	RJMP _0x204004F
_0x2040051:
	LDI  R26,LOW(0)
	__CALL1MN _twi_slave_rx_handler_G102,0
	CPI  R30,0
	BREQ _0x2040052
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	STS  188,R30
	RJMP _0x204001A
_0x2040052:
	RJMP _0x2040053
_0x2040050:
	SBI  0x1E,7
_0x2040053:
	RJMP _0x2040056
_0x204004D:
	CPI  R30,LOW(0x88)
	BRNE _0x2040057
_0x2040056:
	RJMP _0x2040058
_0x2040057:
	CPI  R30,LOW(0x98)
	BRNE _0x2040059
_0x2040058:
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	STS  188,R30
	RJMP _0x204001A
_0x2040059:
	CPI  R30,LOW(0xA0)
	BRNE _0x204005A
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	STS  188,R30
	SET
	BLD  R2,0
	LDS  R30,_twi_slave_rx_handler_G102
	LDS  R31,_twi_slave_rx_handler_G102+1
	SBIW R30,0
	BREQ _0x204005B
	LDI  R26,LOW(1)
	__CALL1MN _twi_slave_rx_handler_G102,0
	RJMP _0x204005C
_0x204005B:
	LDI  R18,LOW(6)
_0x204005C:
	RJMP _0x204001A
_0x204005A:
	CPI  R30,LOW(0xB0)
	BRNE _0x204005D
	LDI  R18,LOW(2)
	RJMP _0x204005E
_0x204005D:
	CPI  R30,LOW(0xA8)
	BRNE _0x204005F
_0x204005E:
	LDS  R30,_twi_slave_tx_handler_G102
	LDS  R31,_twi_slave_tx_handler_G102+1
	SBIW R30,0
	BREQ _0x2040060
	LDI  R26,LOW(0)
	__CALL1MN _twi_slave_tx_handler_G102,0
	MOV  R19,R30
	CPI  R30,0
	BREQ _0x2040062
	LDI  R18,LOW(0)
	RJMP _0x2040063
_0x2040060:
_0x2040062:
	LDI  R18,LOW(6)
	RJMP _0x204004F
_0x2040063:
	LDI  R16,LOW(0)
	CBI  0x1E,7
	RJMP _0x2040066
_0x204005F:
	CPI  R30,LOW(0xB8)
	BRNE _0x2040067
_0x2040066:
	SBIS 0x1E,7
	RJMP _0x2040068
	LDI  R18,LOW(1)
	RJMP _0x204004F
_0x2040068:
	MOV  R30,R16
	SUBI R16,-1
	LDS  R26,_twi_tx_buffer_G102
	LDS  R27,_twi_tx_buffer_G102+1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	STS  187,R30
	CP   R16,R19
	BRSH _0x2040069
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	RJMP _0x2040079
_0x2040069:
	SBI  0x1E,7
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
_0x2040079:
	STS  188,R30
	RJMP _0x204001A
_0x2040067:
	CPI  R30,LOW(0xC0)
	BREQ _0x204006E
	CPI  R30,LOW(0xC8)
	BRNE _0x204006F
_0x204006E:
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	STS  188,R30
	LDS  R30,_twi_slave_tx_handler_G102
	LDS  R31,_twi_slave_tx_handler_G102+1
	SBIW R30,0
	BREQ _0x2040070
	LDI  R26,LOW(1)
	__CALL1MN _twi_slave_tx_handler_G102,0
_0x2040070:
	RJMP _0x204003B
_0x204006F:
	CPI  R30,0
	BRNE _0x204001A
	LDI  R18,LOW(3)
_0x204004F:
_0x2040076:
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xD0)
_0x2040077:
	STS  188,R30
_0x204003B:
	SET
	BLD  R2,0
_0x204001A:
	STS  _twi_rx_index,R17
	STS  _twi_tx_index,R16
	STS  _twi_result,R18
	STS  _bytes_to_tx_G102,R19
	CALL __LOADLOCR6
	ADIW R28,6
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND

	.CSEG

	.CSEG

	.DSEG
_sig_bit:
	.BYTE 0x1
_sost:
	.BYTE 0x20
_page:
	.BYTE 0x1
_p10:
	.BYTE 0x1
_x_dysp:
	.BYTE 0x1
_y_dysp:
	.BYTE 0x1
_pos:
	.BYTE 0x1
_time:
	.BYTE 0x4

	.ESEG
_procfreq:
	.DB  0x0,0x24,0xF4,0x0
_esost:
	.BYTE 0x20

	.DSEG
_twi_tx_index:
	.BYTE 0x1
_twi_rx_index:
	.BYTE 0x1
_twi_result:
	.BYTE 0x1
_twi_rx_buffer:
	.BYTE 0x20
_twi_tx_buffer:
	.BYTE 0x20
__base_y_G100:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1
_slave_address_G102:
	.BYTE 0x1
_twi_tx_buffer_G102:
	.BYTE 0x2
_bytes_to_tx_G102:
	.BYTE 0x1
_twi_rx_buffer_G102:
	.BYTE 0x2
_bytes_to_rx_G102:
	.BYTE 0x1
_twi_rx_buffer_size_G102:
	.BYTE 0x1
_twi_slave_rx_handler_G102:
	.BYTE 0x2
_twi_slave_tx_handler_G102:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1:
	MOV  R30,R7
	LDI  R31,0
	SUBI R30,LOW(-_sost)
	SBCI R31,HIGH(-_sost)
	MOVW R0,R30
	MOV  R26,R7
	LDI  R27,0
	SUBI R26,LOW(-_esost)
	SBCI R27,HIGH(-_esost)
	CALL __EEPROMRDB
	MOVW R26,R0
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2:
	LDS  R30,_x_dysp
	ST   -Y,R30
	LDS  R26,_y_dysp
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x3:
	LDS  R26,_pos
	CLR  R27
	LDS  R30,_page
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __DIVW21
	MOV  R13,R30
	LDS  R30,_page
	LDS  R26,_pos
	ADD  R26,R30
	MOV  R30,R13
	LSL  R30
	LSL  R30
	SUB  R26,R30
	LDI  R30,LOW(2)
	MULS R30,R26
	MOVW R30,R0
	STS  _sig_bit,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x4:
	MOV  R30,R13
	LDI  R31,0
	SUBI R30,LOW(-_sost)
	SBCI R31,HIGH(-_sost)
	LD   R1,Z
	LDS  R30,_sig_bit
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:95 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __LSLW12
	MOV  R26,R1
	LDI  R27,0
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6:
	LDI  R31,0
	ADIW R30,1
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x7:
	MOV  R30,R13
	LDI  R31,0
	SUBI R30,LOW(-_sost)
	SBCI R31,HIGH(-_sost)
	MOVW R22,R30
	LD   R1,Z
	LDS  R30,_sig_bit
	LDI  R26,LOW(1)
	CALL __LSLB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(0)
	OUT  0x27,R30
	LDI  R30,LOW(49728)
	LDI  R31,HIGH(49728)
	__PUTW1R 5,6
	IN   R30,0x24
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(0)
	STS  _time,R30
	STS  _time+1,R30
	STS  _time+2,R30
	STS  _time+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0xA:
	LDS  R26,_time
	LDS  R27,_time+1
	LDS  R24,_time+2
	LDS  R25,_time+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	CALL _clear_lcd
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	CALL _lcd_putsf
	LDI  R30,LOW(1)
	MOV  R7,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xD:
	MOV  R26,R7
	SUBI R26,-LOW(47)
	CALL _lcd_putchar
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xE:
	LDS  R30,_sig_bit
	SUBI R30,-LOW(2)
	STS  _sig_bit,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xF:
	RCALL SUBOPT_0xA
	__CPD2N 0x7D
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x10:
	MOV  R26,R13
	LDI  R27,0
	SUBI R26,LOW(-_esost)
	SBCI R27,HIGH(-_esost)
	CALL __EEPROMRDB
	MOV  R1,R30
	LDS  R30,_sig_bit
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x11:
	MOV  R30,R13
	LDI  R31,0
	SUBI R30,LOW(-_esost)
	SBCI R31,HIGH(-_esost)
	MOVW R22,R30
	MOVW R26,R30
	CALL __EEPROMRDB
	MOV  R1,R30
	LDS  R30,_sig_bit
	LDI  R26,LOW(1)
	CALL __LSLB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x12:
	RCALL SUBOPT_0xA
	__CPD2N 0x177
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(176)
	STS  180,R30
	SBI  0xB,2
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x14:
	CALL _clear_lcd
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x16:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G100
	__DELAY_USW 400
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSLW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __LSLW12R
__LSLW12L:
	LSL  R30
	ROL  R31
	DEC  R0
	BRNE __LSLW12L
__LSLW12R:
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__LTB12U:
	CP   R26,R30
	LDI  R30,1
	BRLO __LTB12U1
	CLR  R30
__LTB12U1:
	RET

__EQW12:
	CP   R30,R26
	CPC  R31,R27
	LDI  R30,1
	BREQ __EQW12T
	CLR  R30
__EQW12T:
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__MULD12:
	RCALL __CHKSIGND
	RCALL __MULD12U
	BRTC __MULD121
	RCALL __ANEGD1
__MULD121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__DIVD21:
	RCALL __CHKSIGND
	RCALL __DIVD21U
	BRTC __DIVD211
	RCALL __ANEGD1
__DIVD211:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__CHKSIGND:
	CLT
	SBRS R23,7
	RJMP __CHKSD1
	RCALL __ANEGD1
	SET
__CHKSD1:
	SBRS R25,7
	RJMP __CHKSD2
	CLR  R0
	COM  R26
	COM  R27
	COM  R24
	COM  R25
	ADIW R26,1
	ADC  R24,R0
	ADC  R25,R0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSD2:
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__EEPROMRDD:
	ADIW R26,2
	RCALL __EEPROMRDW
	MOVW R22,R30
	SBIW R26,2

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRD:
	RCALL __EEPROMWRW
	ADIW R26,2
	MOVW R0,R30
	MOVW R30,R22
	RCALL __EEPROMWRW
	MOVW R30,R0
	SBIW R26,2
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
