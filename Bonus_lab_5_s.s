;******************** (C) Yifeng ZHU *******************************************
; @file    main.s
; @author  Yifeng Zhu
; @date    Jan-17-2023
;*******************************************************************************

	INCLUDE core_cm4_constants.s		; Load Constant Definitions
	INCLUDE stm32l476xx_constants.s      

; Green LED <--> PA.5
LED_PIN	EQU	5
BUTTON_PIN EQU 13	
	AREA    main, CODE, READONLY
	EXPORT	__main				; make __main visible to linker
	IMPORT lcd_do
	IMPORT lcdinit
	ENTRY			
light PROC
	PUSH{r0,r1,r2,r3,LR}
	; Enable the clock to GPIO Port A	
	LDR r0, =RCC_BASE
	LDR r1, [r0, #RCC_AHB2ENR]
	ORR r1, r1, #RCC_AHB2ENR_GPIOAEN
	STR r1, [r0, #RCC_AHB2ENR]
	LDR r2, =RCC_BASE
	LDR r3, [r2, #RCC_AHB2ENR]
	ORR r3, r3, #RCC_AHB2ENR_GPIOCEN
	STR r3, [r2, #RCC_AHB2ENR]
	; MODE: 00: Input mode, 01: General purpose output mode
    ;       10: Alternate function mode, 11: Analog mode (reset state)
	LDR r0, =GPIOA_BASE
	LDR r1, [r0, #GPIO_MODER]
	BIC r1, r1, #(3<<(2*LED_PIN))
	ORR r1, r1, #(1<<(2*LED_PIN))
	STR r1, [r0, #GPIO_MODER]
	
	LDR r2, =GPIOC_BASE
	LDR r3, [r2, #GPIO_MODER]
	BIC r3, r3, #(3<<(2*BUTTON_PIN))
	ORR r3, r3, #(0<<(2*BUTTON_PIN))
	STR r3, [r2, #GPIO_MODER]
	
	LDR r0, =GPIOA_BASE
	LDR r1, [r0,#GPIO_OSPEEDR]
	BIC r1, r1,#(3<<(2*LED_PIN))
	ORR r1, r1, #(0<<(2*LED_PIN))
	STR r1, [r0, #GPIO_OSPEEDR]
	
	;PUSH-PULL
	LDR r0, =GPIOA_BASE
	LDR r1, [r0,#GPIO_OTYPER]
 	BIC r1, r1,#(1<<LED_PIN)
	STR r1, [r0, #GPIO_OTYPER]
	
	;NO PULL UP OR PULL DOWN
	LDR r0, =GPIOA_BASE
	LDR r1, [r0,#GPIO_PUPDR]
	BIC r1, r1,#(3<<(2*LED_PIN))
	STR r1, [r0, #GPIO_PUPDR]

	LDR r2, =GPIOC_BASE
	LDR r3, [r2,#GPIO_PUPDR]
	BIC r3, r3,#(3<<(2*BUTTON_PIN))
	STR r3, [r2, #GPIO_PUPDR]

;while loop for first while in lab 1


try	LDR r3, [r2, #GPIO_IDR]
	AND r3, r3,#GPIO_IDR_IDR_13
	CMP r3, #(1<<BUTTON_PIN)
	BEQ endloop
	B try
endloop	
;2nd while in lab 1
try1 LDR r3, [r2, #GPIO_IDR]
	AND r3, r3,#GPIO_IDR_IDR_13
	CMP r3, #(1<<BUTTON_PIN)
	BNE endloop1
	B try1
endloop1	
	LDR r1, [r0, #GPIO_ODR]
	EOR r1, r1, #(1<<LED_PIN)
	STR r1, [r0, #GPIO_ODR]
	POP{r0,r1,r2,r3,PC}
	ENDP
__main	PROC
	MOV r0,#0
start1

	BL lcd_do
	BL light
	
	
	B start1
stop 	B 		stop     		; dead loop & program hangs here

	ENDP
					
	ALIGN			

	AREA    myData, DATA, READWRITE
	ALIGN
message	DCD   1, 2, 3, 4,5,6,7,8,9
counter DCD 1
	END

