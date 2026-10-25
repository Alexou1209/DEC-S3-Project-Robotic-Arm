#include "I2C.h"
#include "MonDallas.h"
void vI2CEcrireUnBit(bit bBit);
bit bI2CLireUnBit(); 

// *************************************************************************************************
//  Auteur: Stéphane Deschênes
//
//  Description: fonction de délai pour la communication I2C
//  Paramètres d'entrées : iTemps
//  Paramètres de sortie : Aucun
//  Notes     		 	     : Aucune
//
void vI2CDelai (unsigned int iTemps)
// *************************************************************************************************
{
	while (iTemps > 0) //Effectue la boucle le nombre de fois indiqué dans le paramètre
	{
		iTemps --;
	}
}
	
// *************************************************************************************************
//  Auteur: Stéphane Deschênes, basé sur des fonctions faites par Alain Champagne le 30 mai 2007
//  Date de création :  28 mai 2021
//
//  Description: provoque un "start-condition" I2C sur les lignes SDA et SCL
//  Paramètres d'entrées : Aucun
//  Paramètres de sortie : Aucun
//  Notes     		 	     : Aucune
//
void vI2CStartBit(void)
// *************************************************************************************************
{
	SDA = 1;								//Mets SDA à 0 lorsque  SCL est à 1.Mets ensuite SCL à 0  
	vI2CDelai (I2C_DELAI);
	SCL = 1;
	vI2CDelai (I2C_DELAI);
	SDA = 0;          
	vI2CDelai (I2C_DELAI);
	SCL = 0;
	vI2CDelai (I2C_DELAI);
	
}

// *************************************************************************************************
//  Auteur: Stéphane Deschênes, basé sur des fonctions faites par Alain Champagne le 30 mai 2007
//  Date de création :  28 mai 2021
//
//  Description: provoque un "stop-condition" I2C sur les lignes SDA et SCL
//  Paramètres d'entrées : Aucun
//  Paramètres de sortie : Aucun
//  Notes     		 : Aucune
//
void vI2CStopBit(void)
// *************************************************************************************************
{
	SDA = 0;								//Mets SDA à 1 lorsque SCL est à 1.Mets ensuite SCL à 0
	vI2CDelai (I2C_DELAI);
	SCL = 1;
	vI2CDelai (I2C_DELAI);
	SDA = 1;
	vI2CDelai (I2C_DELAI);
	SCL = 0;
	vI2CDelai (I2C_DELAI);
}

// *************************************************************************************************
//  Auteur: Alexandre Dionne
//  Date de création : 15 septembre 2023 
//
//  Description: Fonction qui permet d'écrire un bit en communication I2C
//  Paramètres d'entrées : bBit ; valeur souhaité du bit à écrire
//  Paramètres de sortie : Aucun
//  Notes     		       : Aucune
//
void vI2CEcrireUnBit(bit bBit)
// *************************************************************************************************
{
	SCL = 0;								//Mets SDA à la valeur transférer puis mets SCL à 1
	vI2CDelai (I2C_DELAI);
	if (bBit) {SDA = 1;}
	else 		  {SDA = 0;}
	vI2CDelai (I2C_DELAI);
	SCL = 1;
	vI2CDelai (I2C_DELAI);
	SCL = 0;
	vI2CDelai (I2C_DELAI);
	SDA = 1;
}

// *************************************************************************************************
//  Auteur: Alexandre Dionne
//  Date de création :  15 septembre 2023
//
//  Description: Fonction qui permet de lire un bit en communication I2C
//  Paramètres d'entrées : Aucun
//  Paramètres de sortie : La valeur du bit lu
//  Notes     		       : Aucune
//
bit bI2CLireUnBit()
// *************************************************************************************************
{
	bit bBit;								//Met SDA a 1 et SCL à 0, attend légerement et mets SCL a 1.
	SDA = 1;								//lit ensuite la valeur sur SDA
	vI2CDelai (I2C_DELAI);
	SCL = 0;
	vI2CDelai (I2C_DELAI);
	SCL = 1;
	vI2CDelai (I2C_DELAI);
	bBit = SDA;
	SCL = 0;
	return bBit;
}

// *************************************************************************************************
//  Auteur: Alexandre Dionne
//  Date de création :  15 septembre 2023
//  
//  Description          : Fonction d'envoie de 8 bits de données en I2C.
//  Paramètres d'entrées : Octet que l'on veut envoyer
//  Paramètres de sortie : État du ack venant de l'esclave
//  Notes     		 			 : Aucune
//
void vI2CEcrire8Bits (unsigned char ucTxData)
// *************************************************************************************************
{
	UC i;									
	bit bBit;
	for(i=0; i<8; i++)				//Boucle qui appelle la fonction EcrireUnBit 8 fois, en lui transférant
	{													//la valeur du bit de chaque position (0,1,2,3,4,5,6,7)
		if((ucTxData & 0x80) == 0x80){bBit = 1;}
		else 					     {bBit = 0;}
		vI2CEcrireUnBit(bBit);
		ucTxData = ucTxData << 1;
	}
	bI2CLireUnBit();
}

// *************************************************************************************************
//	Auteur: Alexandre Dionne
//  Date de création :  15 septembre 2023
//
//	Description :	Fonction de réception de 8 bits de donnée 
//			        provenant d'une communication I2C.
//
//	Paramètres d'entrée : 	Valeur du ack voulu 0 = Ack  1 = NACK		
//	Paramètres de sortie : 	Octet reçu.		
//
unsigned char ucI2CLire8Bits (bit bAckValue)
// *************************************************************************************************
{
	UC ucRxData;
	UC ucTempo = 0;
	UC i;
	for(i=0; i<8; i++)				//Boucle qui appelle 8 fois la fonction LireUnBit, et stocke les 8 bits			
	{													//reçus dans une variable qui est retournée.
		ucRxData = ucRxData << 1;
		ucTempo = bI2CLireUnBit();
		ucRxData = ucTempo + ucRxData;
	}
	vI2CEcrireUnBit(bAckValue);
	return ucRxData;
}