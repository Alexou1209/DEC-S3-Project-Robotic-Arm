/**************************************************************************************************
Nom du fichier : Main.c
Auteur : Alexandre Dionne, Felix Tremblay, Marie-Pier Morin                 
Date de création : 6 Decembre
Version 1.0

		
		Versions:
		1.0 - 06-12-2023 - Première version 
	
***************************************************************************************************/

// *************************************************************************************************
//  INCLUDES
// *************************************************************************************************	

#include <stdio.h>           // Prototype de declarations des fonctions I/O
	
#include "Dallas.h"					 // Declaration des fonctions et des definitions de base au programme 
#include "TableauSequence.h"


// *************************************************************************************************
//  CONSTANTES
// *************************************************************************************************


// *************************************************************************************************
//  FONCTIONS LOCALES
// *************************************************************************************************



// *************************************************************************************************
//  STRUCTURES ET UNIONS
// *************************************************************************************************

struct STState stState = {0x45, 0x5A, 0x05, 0x088, 0xCD};  // Position de depart. (Pince dans la boite)
struct STState *pstState = &stState;



// *************************************************************************************************
// VARIABLES 
// *************************************************************************************************
    unsigned char ucEtatSequence = NONACTIVE;
	unsigned char ucTouche = ESPACE;
	unsigned char ucSequence = 0;
	unsigned char ucStep = 0;
   
    unsigned char ucTemps300ms;						// Variable pour delai de 300ms sans trame recue



	unsigned char ucEcranBase[4][21] = {{"1:   2:   3:   4:   "},		// Affichage de depart 
										{"5:   X:   Y:   P:   "},
										{"B:   Bloc:          "},
										{"?? Seq:  Step:  OffL"}};
	 

// ************************************************************************************************                     


void main (void) 
{
  vInitTimer0();
  vInitVitessePortSerie(19200,11059200);
  vLCDConfig();
  vAfficheLCDComplet(ucEcranBase);
  vInitInterrupt();
	
  vEnvoieTrame(pstState);		// Envoie la premiere trame pour assurer le bonne position du bras 
	
	
  while(1)
  {
	  if(ucEtatSequence == ACTIVE)				// Mis a jour des valeur des moteurs dans la structure 
	  {
	    stState.ucBase    = ucSeqData[ucSequence][ucStep][0];
		stState.ucEpaule  = ucSeqData[ucSequence][ucStep][1];
		stState.ucCoude   = ucSeqData[ucSequence][ucStep][2];
		stState.ucPoignet = ucSeqData[ucSequence][ucStep][3];
		stState.ucPince   = ucSeqData[ucSequence][ucStep][4];
	  }
	
	
	  ucTouche = ucReadKeyboardI2C();			// Lecture du clavier I2C
	  if(ucTouche != 0x20)					
	  {											// Traitement de la touche appuyer 
	    vTraiteTouche(ucTouche, pstState, &ucSequence, &ucEtatSequence, &ucStep);	
	  }
	  
	  if(bTrame == RECU)
	  {
		vLCDEcrireCaract('n', LIGNE3, 17);		// Affiche OnL
		vLCDEcrireCaract('L', LIGNE3, 18);
	    vLCDEcrireCaract(' ', LIGNE3, 19);
		  
	    vEnvoieTrame(pstState);					// Envoie la trame 
		ucTemps300ms = 0;						// Reset delai attente 300ms sans trame recue
		bTrame = NONRECU;					
	  }
		
	  if(bDelai300ms == 1)						// 300ms sans trame recu
	  {
	    bDelai300ms = 0;						// Clear du flag Delai300ms
		if(bTrame == NONRECU)
	    {
		  vLCDEcrireCaract('f', LIGNE3, 17);	// Affiche OffL
		  vLCDEcrireCaract('f', LIGNE3, 18);
	      vLCDEcrireCaract('L', LIGNE3, 19);			
	    }
	  }
		
	  if(bDelai200ms == 1)
	  {
		bDelai200ms = 0;										// Clear flag Delai200ms
		vAfficheEtat(pstState, ucSequence, ucStep);				// Affiche les valeurs sur le LCD
	  }
			
	  if(bDelai2s == 1)
	  {	
		bDelai2s = 0;										    // Clear le flag Delai2s
		vTraiteSequence(&ucEtatSequence, &ucSequence, &ucStep);	// Traite les sequences a realiser selon le cas 
	  }
			
	  if(ucEtatSequence == NONACTIVE)							// Aucune sequence en cours 
	  {
		vTraitePave(&ucEtatSequence, &ucSequence);				// Lecture du pave pour determiner la case appuyer 
	  }
		
    }
  }




