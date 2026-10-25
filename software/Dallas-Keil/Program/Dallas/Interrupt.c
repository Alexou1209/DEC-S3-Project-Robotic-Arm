#include "Dallas.h"


// *************************************************************************************************
//	Auteur: Alexandre Dionne
//  Date de création :  17 novembre 2023
//
//	Description :	Initialise les interruptions necessaire au programme 
//	Paramètres d'entrée  : Aucun		
//	Paramètres de sortie : Aucun
//
void vInitInterrupt (void) 
// *************************************************************************************************
{	
	ET0 = 1;	// Active interruption Timer0
	ES0 = 1; 	// Active interruption RS232 
	EA  = 1;	// Active interruption globales 
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
	static unsigned char ucTemps;	
	
	ucTemps++;					
	ucTemps300ms++;
	TL0 = 0x00;
	TH0 = 0x4C;    				// Valeur pour 50ms
	TF0 = 0;
	
	if(ucTemps%4 == 0)			// 50ms x 4 = 200ms
	{
		bDelai200ms = 1;
	}
	if(ucTemps300ms%6 == 0)		// 50ms x 6 = 200ms
	{
		bDelai300ms = 1;
	}
	if(ucTemps == 40)			// 50ms x 40 = 2sec 
	{
		bDelai2s = 1;
		ucTemps = 0;			// Reset Compteur temps
	}
}

void vInterruptRS232(void) interrupt 4	
{
	if(TI_0 == 1)				// Interrupt Tx
	{
		TI_0 = 0;
	}
	
	if(RI_0 == 1)				// Interrupt Rx
	{
		RI_0 = 0;
		vTraiteTrame();			// Traitement de la trame recue 
	}		
	
}
