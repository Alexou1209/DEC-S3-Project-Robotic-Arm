//////////////////////////////////////////////////////////////////////////////
//
//  Fichier:     
//
//  Description: - 
//               
//
//  Programmeur: 
//
//  Date:        
//
//  Compilateur: Keil 9.53  (uVision 5)
//
//  Modification:
//        
//
//////////////////////////////////////////////////////////////////////////////

#ifndef	MONDALLAS_H
#define	MONDALLAS_H
#include <DS89C4xx.H>      // Declaration des registres de fonctions speciales 
                           // pour la famille Dallas DS89C4xx 

#define UC unsigned char 

#define UI unsigned int      

// P1 adresse sfr 0x90 
sbit P1_7 = 0x97; 
sbit P1_6 = 0x96; 
sbit P1_5 = 0x95; 
sbit P1_4 = 0x94; 
sbit P1_3 = 0x93; 
sbit P1_2 = 0x92; 
sbit P1_1 = 0x91; 
sbit P1_0 = 0x90; 

// P3 adresse sfr 0xB0 
sbit P3_7 = 0xB7; 
sbit P3_6 = 0xB6; 
sbit P3_5 = 0xB5; 
sbit P3_4 = 0xB4; 
sbit P3_3 = 0xB3; 
sbit P3_2 = 0xB2; 
sbit P3_1 = 0xB1; 
sbit P3_0 = 0xB0;

#include <stdio.h>         // Predeclaration des fonctions d'entree/sortie
                           // pour utiliser printf( ) et getchar( )
#endif