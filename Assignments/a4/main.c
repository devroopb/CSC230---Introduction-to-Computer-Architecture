/*
Devroop Banerjee
V00837868
CSC 230
Assignment 4
*/

#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#include "main.h"
#include "lcd_drv.h"

int main(void){
	lcd_init();
	
	lcd_xy(0,0);
	char time1[12] = {48,48,':',48,48,':',48,48,':',48,48,0};

	lcd_xy(0,1);
	char time2[12] = {48,48,':',48,48,':',48,48,':',48,48,0};

	ADCSRA = 0x87;
	ADMUX = 0x40;

	//Display in line 2 starts as soon as any button is pressed
	
	int stop = 1;
	for(int hr1 = 0; hr1 <= 9; hr1++){
		for(int hr2 = 0; hr2 <= 9; hr2++){
			for(int min1 = 0; min1 <= 5; min1++){
				for(int min2 = 0; min2 <= 9; min2++){
					for(int sec1 = 0; sec1 <= 5; sec1++){
						for(int sec2 = 0; sec2 <= 9; sec2++){
							for(int sub1 = 0; sub1 <= 9; sub1++){
								for(int sub2 = 0; sub2 <= 9; sub2++){
									ADCSRA |= 0x40;
									while(ADCSRA & 0x40){
										unsigned int low = ADCL;
										unsigned int high = ADCH;
										low += (high << 8);

										if(low <= 1000){ 
											stop = stop ^ 230;
											break;
									    }
									}
									lcd_xy(0,0);
									lcd_puts(time1);
									time1[10]++;

									lcd_xy(0,stop);
									lcd_puts(time2);
									time2[10]++;
									_delay_ms(10);
								}
								time1[10] = 48;
								lcd_xy(0,0);
								lcd_puts(time1);
								time1[9]++;

								time2[10] = 48;
								lcd_xy(0,stop);
								lcd_puts(time2);
								time2[9]++;
							}
							time1[10] = 48;
							time1[9] = 48;
							lcd_xy(0,0);
							lcd_puts(time1);
							time1[7]++;

							time2[10] = 48;
							time2[9] = 48;
							lcd_xy(0,stop);
							lcd_puts(time2);
							time2[7]++;
						}
						time1[10] = 48;
						time1[9] = 48;
						time1[7] = 48;
						lcd_xy(0,0);
						lcd_puts(time1);
						time1[6]++;
							
						time2[10] = 48;
						time2[9] = 48;
						time2[7] = 48;
						lcd_xy(0,stop);
						lcd_puts(time2);
						time2[6]++;
					}
					time1[10] = 48;
					time1[9] = 48;
					time1[7] = 48;
					time1[6] = 48;
					lcd_xy(0,0);
					lcd_puts(time1);
					time1[4]++;

					time2[10] = 48;
					time2[9] = 48;
					time2[7] = 48;
					time2[6] = 48;
					lcd_xy(0,stop);
					lcd_puts(time2);
					time2[4]++;
				}
				time1[10] = 48;
				time1[9] = 48;
				time1[7] = 48;
				time1[6] = 48;
				time1[4] = 48;
				lcd_xy(0,0);
				lcd_puts(time1);
				time1[3]++;

				time2[10] = 48;
				time2[9] = 48;
				time2[7] = 48;
				time2[6] = 48;
				time2[4] = 48;
				lcd_xy(0,stop);
				lcd_puts(time2);
				time2[3]++;
			}
			time1[10] = 48;
			time1[9] = 48;
			time1[7] = 48;
			time1[6] = 48;
			time1[4] = 48;
			time1[3] = 48;
			lcd_xy(0,0);
			lcd_puts(time1);
			time1[1]++;

			time2[10] = 48;
			time2[9] = 48;
			time2[7] = 48;
			time2[6] = 48;
			time2[4] = 48;
			time2[3] = 48;
			lcd_xy(0,stop);
			lcd_puts(time2);
			time2[1]++;
		}
		time1[10] = 48;
		time1[9] = 48;
		time1[7] = 48;
		time1[6] = 48;
		time1[4] = 48;
		time1[3] = 48;
		time1[1] = 48;
		lcd_xy(0,0);
		lcd_puts(time1);
		time1[0]++;

		time2[10] = 48;
		time2[9] = 48;
		time2[7] = 48;
		time2[6] = 48;
		time2[4] = 48;
		time2[3] = 48;
		time2[1] = 48;
		lcd_xy(0,stop);
		lcd_puts(time2);
		time2[0]++;
	}
}
