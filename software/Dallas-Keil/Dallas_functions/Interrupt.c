#include "Interrupt.h"
#include "MonDallas.h"
#include "ClavierI2C.h"
unsigned char ucTouche = 0x20;
unsigned char ucTemps = 0;
// *************************************************************************************************
//	Auteur: Alexandre Dionne
//  Date de création :  17 novembre 2023
//
//	Description :	Initialise les interruptions  
//			          
//
//	Paramètres d'entrée  : Aucun		
//	Paramètres de sortie : Aucun
//
void vInitInterrupt (void) 
// *************************************************************************************************
{
	IT0 = 1;
	IE0 = 0;
	EX0 = 1;
	TF0 = 0;
	ET0 = 1; 
	EA = 1;
}

// *************************************************************************************************
//	Auteur: Alexandre Dionne
//  Date de création :  17 novembre 2023
//
//	Description :	  
//			          
//
//	Paramètres d'entrée  : Aucun		
//	Paramètres de sortie : Aucun
//
void InterruptionTimer0 (void) interrupt 1 
// *************************************************************************************************
{
	ucTemps++;	
	TL0 = 0x00;
	TH0 = 0xDC;
	TF0 = 0;
}

// *************************************************************************************************
//	Auteur: Alexandre Dionne
//  Date de création :  17 novembre 2023
//
//	Description :	  
//			          
//
//	Paramètres d'entrée  : Aucun		
//	Paramètres de sortie : Aucun
//
void InterruptionExt0 (void) interrupt 0 
// *************************************************************************************************
{
	ucTouche = ucLireClavierI2C();
}