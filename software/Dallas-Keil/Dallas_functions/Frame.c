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


#include "MonDallas.h"      // Declaration des registres de fonctions speciales 
                           // pour la famille Dallas DS89C4xx       

#include <stdio.h>         // Predeclaration des fonctions d'entree/sortie
                           // pour utiliser printf( ) et getchar( )



void main (void) 
{
 // Placer la declaration de vos variables ici.
  
  
  
  
  // Setup port serie 0 du Dallas pour 57600 baud a 11.059MHz.
  SCON0 = 0x50;            // SCON: mode 1, 8-bit UART, enable rcvr.
  TMOD |= 0x20;            // TMOD: timer 1, mode 2, 8-bit reload.
  TH1   = 255;             // TH1:  reload value for 57600 baud @ 11.059MHz.
  PCON  = 0x80;            // SMOD_0 = 1 (doubleur de baud).
  TR1   = 1;               // TR1:  Part le timer 1.
  TI_0  = 1;               // TI:   set TI to send first char of UART.


  while (1)
  {
     // Votre programme ici.
  }
}   // Fin du main().


