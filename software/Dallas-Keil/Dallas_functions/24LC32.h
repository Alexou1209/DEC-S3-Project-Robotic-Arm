/****************************************************************************************
   Nom du fichier : 24LC32.h
   Auteur : Alain Champagne                  
      Date de création : 19-03-2006 
        Fichier de déclaration et de définition pour les fonctions de traitement du 
        I2C.
  
****************************************************************************************/

#ifndef MEMI2C_H
  #define MEMI2C_H


// *************************************************************************************************
//  CONSTANTES
// *************************************************************************************************

// *************************************************************************************************
//  LES PROTOTYPES DES FONCTIONS
// *************************************************************************************************


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
void vEcrireMemI2C(unsigned char ucData, unsigned int uiAdr);
// *************************************************************************************************


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
unsigned char ucLireMemI2C(unsigned int uiAdr);
// *************************************************************************************************


#endif 

















