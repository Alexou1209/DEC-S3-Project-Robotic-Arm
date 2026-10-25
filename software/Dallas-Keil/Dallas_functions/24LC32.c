#include "24LC32.h"
#include "MonDallas.h"
#include "I2C.h"


// *************************************************************************************************
//	Auteur: Alexandre Dionne
//  Date de création :  15 septembre 2023
//
//	Description :	Fonction pour écrire un octet au 24LC32 en communication I2C 
//			          
//
//	Paramètres d'entrée  : Octet à écrire, Adresse de la case mémoire ou Écrire		
//	Paramètres de sortie : Aucun
//
void vEcrireMemI2C(unsigned char ucData, unsigned int uiAdr)
// *************************************************************************************************
{
	int i;											//Divise uiAdr en 2 UC, puis effectue le protocole nécessaire pour 
	UC ucMSB;										//Ecrire un octet dans la mémoire 24LC32 en I2C
	UC ucLSB;
	ucLSB = uiAdr & 0x00FF;
	ucMSB = uiAdr >> 8;
	vI2CStartBit();							//Start bit
	vI2CEcrire8Bits(0xA0);			//Adresse I2C de la mémoire, en écriture
	vI2CEcrire8Bits(ucMSB);			//Adresse haute de la case mémoire
	vI2CEcrire8Bits(ucLSB);			//Adresse basse de la case mémoire
	vI2CEcrire8Bits(ucData);		//Valeur à écrire
	vI2CStopBit();							//Stop bit
	for(i=0; i<5000; i++);
}


// *************************************************************************************************
//	Auteur: Alexandre Dionne
//  Date de création :  15 septembre 2023
//
//	Description :	Fonction pour lire un octet au 24LC32 en communication I2C 
//			          
//
//	Paramètres d'entrée  : Adresse de l'octet à lire	
//	Paramètres de sortie : Octet lu
//
unsigned char ucLireMemI2C(unsigned int uiAdr)
// *************************************************************************************************
{
	UC ucMSB;											//Divise uiAdr en 2 UC, puis effectue le protocole nécessaire pour
	UC ucLSB;											//Lire un octet dans la mémoire 24LC32 en I2C
	UC ucRxData;								
	ucLSB = uiAdr & 0x00FF;
	ucMSB = uiAdr >> 8;
	vI2CStartBit();								//Start bit
	vI2CEcrire8Bits(0xA0);				//Adresse I2C de la mémoire, en écriture
	vI2CEcrire8Bits(ucMSB);				//Adresse haute de la case mémoire
	vI2CEcrire8Bits(ucLSB);				//Adresse basse de la case mémoire
	vI2CStopBit();								//Stop bit
	vI2CStartBit();								//Start bit
	vI2CEcrire8Bits(0xA1);				//Adresse I2C de la mémoire, en lecture
	ucRxData = ucI2CLire8Bits(1); //Lecture de l'octet, et envoie d'un NOACK
	vI2CStopBit();								//Stop bit
	return ucRxData;							//Retourne la valeur lue
}