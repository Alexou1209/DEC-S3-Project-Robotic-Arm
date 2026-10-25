#include "InitPortSerie.h"
#include "MonDallas.h"

// *************************************************************************************************
//	Auteur: Alexandre Dionne
//  Date de création :  10 novembre 2023
//
//	Description :	Fonction qui initialise le port serie de la carte dallas a 57600 bauds
//			          
//
//	Paramètres d'entrée  : Aucun		
//	Paramètres de sortie : Aucun
//
void vInitPortSerie()
// *************************************************************************************************
{
	// Setup port serie 0 du Dallas pour 57600 baud a 11.059MHz.
	SCON0 = 0x50;            // SCON: mode 1, 8-bit UART, enable rcvr.
	TMOD |= 0x20;            // TMOD: timer 1, mode 2, 8-bit reload.
	TH1   = 255;             // TH1:  reload value for 57600 baud @ 11.059MHz.
  PCON  = 0x80;            // SMOD_0 = 1 (doubleur de baud).
  TR1   = 1;               // TR1:  Part le timer 1.
  TI_0  = 1;               // TI:   set TI to send first char of UART.
}