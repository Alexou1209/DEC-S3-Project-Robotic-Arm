/****************************************************************************************
   Nom du fichier : I2C.h
   Auteur : Stéphane Deschênes                  
      Date de création : 19-03-2006 
        Fichier de déclaration et de définition pour les fonctions de traitement du 
        I2C.
  
****************************************************************************************/

#ifndef I2C_H
  #define I2C_H


// *************************************************************************************************
//  CONSTANTES
// *************************************************************************************************
//Definitions de parametres. 
#define SDA P3_4
#define SCL P3_5
#define INT P3_2

#define I2C_DELAI 1
 
// *************************************************************************************************
//  LES PROTOTYPES DES FONCTIONS
// *************************************************************************************************
  
// *************************************************************************************************
//  Auteur: Stéphane Deschênes, basé sur des fonctions faites par Alain Champagne le 30 mai 2007
//  Date de création :  28 mai 2021
//
//  Description: provoque un "start-condition" I2C sur les lignes SDA et SCL
//  Paramètres d'entrées : Aucun
//  Paramètres de sortie : Aucun
//  Notes     		 	 : Aucune
//
void vI2CStartBit(void);
// *************************************************************************************************

// *************************************************************************************************
//  Auteur: Stéphane Deschênes, basé sur des fonctions faites par Alain Champagne le 30 mai 2007
//  Date de création :  28 mai 2021
//
//  Description: provoque un "stop-condition" I2C sur les lignes SDA et SCL
//  Paramètres d'entrées : Aucun
//  Paramètres de sortie : Aucun
//  Notes     		 : Aucune
//
void vI2CStopBit(void);
// *************************************************************************************************


// *************************************************************************************************
//  Auteur: Alexandre Dionne
//  Date de création :  15 septembre 2023
//  
//  Description          : Fonction d'envoie de 8 bits de données en I2C.
//  Paramètres d'entrées : Octet que l'on veut envoyer
//  Paramètres de sortie : État du ack venant de l'esclave
//  Notes     		 			 : Aucune
//
void vI2CEcrire8Bits (unsigned char ucTxData);
// *************************************************************************************************


// *************************************************************************************************
//	Auteur: Alexandre Dionne
//  Date de création :  15 septembre 2023
//
//	Description :	Fonction de réception de 8 bits de donnée 
//			          provenant d'une communication I2C.
//
//	Paramètres d'entrée : 	Valeur du ack voulu 0 = Ack  1 = NACK		
//	Paramètres de sortie : 	Octet reçu.		
//
unsigned char ucI2CLire8Bits (bit bAckValue);
// *************************************************************************************************


#endif 