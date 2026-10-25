#include "MonDallas.h"
#include "ClavierI2C.h"
#include "I2C.h"

unsigned char ucReadKeyboardI2C(void)	
{
	unsigned char ucKey[16] = {'1', '2', '3', 'A', '4', '5', '6', 'B', '7', '8', '9', 'C', '*', '0', '#', 'D'};
	unsigned char ucIndice;
	unsigned char ucTouche = ' ';
	
	if(INT == 0)				
	{
		vI2CStartBit();							
		vI2CEcrire8Bits(ADRLECTURE);		
		ucIndice = ucI2CLire8Bits(NOACK);	// Lecture I2C de la valeur envoyee par le clavier
		vI2CStopBit();
		ucTouche = ucKey[ucIndice];			// Selection du caractere selon la valeur de la touche recue 
	}
	return(ucTouche);
}