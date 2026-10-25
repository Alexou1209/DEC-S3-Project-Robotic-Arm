/****************************************************************************************
   Nom du fichier : Interrupt.h
   Auteur : Alexandre Dionne                  
      Date de création : 17 novembre 2023 
        Fichier de déclaration et de définition pour les fonctions de traitement des 
        Interruptions.
  
****************************************************************************************/

#ifndef INTERRUPT_H
  #define INTERRUPT_H

extern unsigned char ucTouche;
extern unsigned char ucTemps;
  
// *************************************************************************************************
//  Auteur: Alexandre Dionne
//  Date de création :  17 novembre 2023
//
//  Description: Initialise les interruptions
//  Paramètres d'entrées : Aucun
//  Paramètres de sortie : Aucun
//  Notes     		 	 : Aucune
//
void vInitInterrupt (void);
// *************************************************************************************************
#endif