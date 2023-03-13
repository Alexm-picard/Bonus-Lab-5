#include "stm32l476xx.h"
#include "SysClock.h"
#include "I2C.h"
#include "ssd1306.h"
#include "ssd1306_tests.h"
#include <string.h>
#include <stdio.h>


 
 void lcdinit(void){
	uint8_t Data_Receive[6];
	uint8_t Data_Send[6];
	void I2C_GPIO_init(void);
	I2C_GPIO_init();
	I2C_Initialization(I2C1);
	ssd1306_Init();
	ssd1306_Fill(White);
	ssd1306_SetCursor(2,0);
	 int counter =0;
	 char message[10];
	ssd1306_WriteString(message, Font_11x18, Black);		
	ssd1306_UpdateScreen();
 }

 int lcd_do(int counter){
	lcdinit();
	 char message[10];
	 sprintf(message,"%d",counter);
	 ssd1306_SetCursor(2,0);
	 ssd1306_WriteString(message, Font_11x18, Black);
	 ssd1306_UpdateScreen();
	 counter++;
	 return counter;
 }

