#include "ClavierI2C.h"
#include "MonDallas.h"
#include "I2C.h"

// *************************************************************************************************
//	Auteur: Alexandre Dionne
//  Date de création :  10 novembre 2023
//
//	Description :	Fonction pour lire la touche appuyer sur le clavier I2C
//			          
//
//	Paramètres d'entrée  : Aucun	
//	Paramètres de sortie : Touche Lu
//
unsigned char ucLireClavierI2C()
// *************************************************************************************************
{
	unsigned char ucTouche;
	vI2CStartBit();								//Start bit
	vI2CEcrire8Bits(0x29);				//Adresse I2C du clavier, en lecturee
	ucTouche = ucI2CLire8Bits(1); //Lecture de l'octet, et envoie d'un NOACK
	vI2CStopBit();								//Stop bit
	return ucTouche;							//Retourne la valeur lue
}