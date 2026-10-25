/****************************************************************************************
   Nom du fichier : ClavierI2C.h
   Auteur : Félix Tremblay                 
   Date de création : 23-11-24
        Fichier de déclaration et de définition pour les fonctions de traitement du 
        clavier I2C.
  
****************************************************************************************/

#ifndef CLAVIERI2C_H
  #define CLAVIERI2C_H
	#define ESPACE      0x20
	#define ADRLECTURE  0x29
	#define NOACK		1
	#define INT			P3_2




// *************************************************************************************************
//  Auteur: Félix Tremblay
//  Date de création : 23-11-24
//  Version 1.0
//
//  Description	: Fonction qui lit les touches appuyé sur le clavier I2C
//  Paramètres d'entrées : Aucune
//  Paramètres de sortie : La valeur ASCII de la touche appuyé 
//
//  Notes     		       : Cette fonction lit le clavier lorsqu'il y a un interruption sur INT
// **************************************************************************************************
unsigned char ucReadKeyboardI2C(void);


#endif 
