/****************************************************************************************
   Nom du fichier : LCD.h
   Auteur : Alexandre Dionne                 
      Date de création : 28-11-2023 
        Fichier de déclaration et de définition pour les fonctions de traitement du 
        LCD de la carte Dallas.
  
****************************************************************************************/
#ifndef	LCD_H
#define	LCD_H

#define LIGNE0 0x80
#define LIGNE1 0xC0
#define LIGNE2 0x94
#define LIGNE3 0xD4

// ************************************************************************************************
//  Auteur: Alexandre Dionne
//  Date de création :  22 septembre 2023
//  
//  Description          : Fonction qui configure le LCD sur la carte Dallas.
//  Paramètres d'entrées : Aucun
//  Paramètres de sortie : Aucun
//  Notes     		 			 : Aucune
//
void vLCDConfig(void);
// ************************************************************************************************
// ************************************************************************************************
//  Auteur: Alexandre Dionne
//  Date de création :  22 septembre 2023
//  
//  Description          : Fonction pour écrire un caractère sur le LCD.
//  Paramètres d'entrées : le caractère, la ligne et la colonne
//  Paramètres de sortie : Aucun
//  Notes     		 			 : Aucune
//
void vLCDEcrireCaract(unsigned char ucCaract, unsigned char ucLigne, unsigned char ucColonne);
// ************************************************************************************************
// ************************************************************************************************
//
//  Auteur: Stéphane Deschênes 	
//  Date de création :  25 août 2019
//
//  Description					 : Fonction qui verifie l'état du busy flag du LCD
//  Paramètres d'entrées : Aucun
//  Paramètres de sortie : Aucun
//  Notes     		       : Aucune
void vAttendreBusyLcd(void);
// *************************************************************************************************
// ************************************************************************************************
//
//  Auteur: Alexandre Dionne 	
//  Date de création :  22 septembre 2023
//
//  Description					 : Fonction qui écrit une lgne sur le LCD
//  Paramètres d'entrées : Caractère de la ligne et la ligne où écrire
//  Paramètres de sortie : Aucun
//  Notes     		       : Aucune
void vAfficheLigneLCD(unsigned char *ucTab, unsigned char ucLigne);
// *************************************************************************************************
// ************************************************************************************************
//
//  Auteur: Alexandre Dionne
//  Date de création :  22 septembre 2023
//
//  Description					 : Fonction qui écrit sur le LCD au complet
//  Paramètres d'entrées : Caractèrre pour chaque lignes/colonnes
//  Paramètres de sortie : Aucun
//  Notes     		       : Aucune
void vAfficheLCDComplet(unsigned char ucTab[4][21]);
// *************************************************************************************************
// ************************************************************************************************
//
//  Auteur: Alexandre Dionne	
//  Date de création :  22 septembre 2023
//
//  Description					 : Fonction qui efface tous les caractère sur le LCD
//  Paramètres d'entrées : Aucun
//  Paramètres de sortie : Aucun
//  Notes     		       : Aucune
void vEffaceLCD(void);
// *************************************************************************************************
// ************************************************************************************************
//
//  Auteur: Alexandre Dionne	
//  Date de création :  22 septembre 2023
//
//  Description					 : Fonction qui charge la CGRAM du LCD
//  Paramètres d'entrées : Aucun
//  Paramètres de sortie : Aucun
//  Notes     		       : Aucune
void vLoadCGRAMLCD(unsigned char ucTab[8][8]);
// *************************************************************************************************
#endif
