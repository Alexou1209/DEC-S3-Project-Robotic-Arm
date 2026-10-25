/****************************************************************************************
   Nom du fichier : ClavierI2C.h
   Auteur : Alaxandre Dionne                 
      Date de création : 28-11-2023 
        Fichier de déclaration et de définition pour les fonctions de traitement du 
        Clavier en I2C.
  
****************************************************************************************/
#ifndef	CLAVIERI2C_H
#define CLAVIERI2C_H
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
unsigned char ucLireClavierI2C();
// *************************************************************************************************
#endif