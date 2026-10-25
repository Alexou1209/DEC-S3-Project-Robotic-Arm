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
void vInitVitessePortSerie(unsigned long fVitesse, unsigned long fFreq);


void main (void) 
{
 // Placer la declaration de vos variables ici.
  vInitVitessePortSerie(19200,11059200);

	printf("Bonjour");
  while (1)
  {
     // Votre programme ici.
  }
}   // Fin du main().

//******************************************************************************
// Nom de la fct:   vInitPortSerie                    Fait par: Pierre Chouinard
// Date:            17 Decembre 2008
// Revision :       A		
// Prototype:       void vInitPortSerie(void)
// Description:     Cette fonction configure le port serie 0 avec timer 1
//                  pour le baudrate demande, en N, 8, 1, sans interruption.
// Exemple d'appel: vInitVitessePortSerie(57600,11059200);
//******************************************************************************
void vInitVitessePortSerie(unsigned long fVitesse, unsigned long fFreq)
{
  SCON0 = 0x50;                     // Selectione mode 1, 8-bit avec reception      
  PCON  = PCON | 0x80;              // SMOD = 1 pour doubler la vitesse port serie 
  TMOD  = TMOD & 0x0F;              // timer 1, en timer mode 2, 
  TMOD  = TMOD | 0x20;              // 8-bit auto-reload        
  TH1   = (char) 256-(fFreq/16/12/fVitesse); // a 11.0592MHz: avec SMOD = 1
                                             // FA=9600,
                                             //FD=19200, FE=28800 et FF=57600    
  TR1   = 1;                        // Active le timer 1                          
  TI_0  = 1;                        // Met TI a 1 pour un premier charactere    
}// Fin --- vInitPortSerie()
