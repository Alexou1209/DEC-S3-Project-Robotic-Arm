#include "Dallas.h"					 // Include de tout les fichier necessaire pour le fonctionnement du programme


struct STReception stReception;      // Structure pour buffer reception

unsigned char ucNumMoteur = BASE;
unsigned char ucBloc      = AUCUN;
unsigned char ucIncrement = 5;


bit bTrame = NONRECU;				 // Bit indicant l'etat de reception de la trame
bit bDelai200ms = 0;
bit bDelai300ms = 0;
bit bDelai2s    = 0;
bit bEchauffementFait = NONFAIT;	 // Bit servant a toggle le mode repos et echauffement





// *************************************************************************************************
void vTraiteTouche(unsigned char ucTouche, struct STState *pstState, unsigned char *ucSequence,
			       unsigned char *ucEtatSequence, unsigned char *ucStep)
//
//  Auteur: Felix Tremblay, Alexandre Dionne et Marie-Pier Morin 	
//  Date de création : 9 decembre 2023 
//  Version 1.0
//
//  Description: Fonction traitant les touches appuyer sur le clavier I2C et effectue les actions en consequence.
//  Paramètres d'entrées : Touche appuyer sur le clavier I2C, pointeur de la structure STState, 
//						   la sequence actuelle, le step actuel 
//  Paramètres de sortie : Aucun
//  Notes     		     : Aucune
//
// *************************************************************************************************
{
	switch(ucTouche)
	{
		case '1' :						// Changement des moteur selectionnes
	      ucNumMoteur = BASE;   			        
		break;
		case '2' :
		  ucNumMoteur = EPAULE;			//
		break;
		case '3' :                 
		  ucNumMoteur = COUDE;			//
		break;
		case '4' :                  
	      ucNumMoteur = POIGNET;		//
		break;
		case '5' :                 
		  ucNumMoteur = PINCE;			// Changement des moteurs selectionnes
		break;
		case '0' :                		// Changement de l'incrementation
		if(ucIncrement < 17)
		{
          ucIncrement = ucIncrement +4;
        }
        else
        {			
		  ucIncrement = 1;
		}
		break;
		case '*' :  						// Diminue la valeur du moteur selectionne               
		  vDecMouvement(pstState);
		break;
		case '#' :                 			// Augmente la valeur du moteur selectionne
		  vIncMouvement(pstState);                     			
		break;
		
		case 'A' :      			   		 // Echauffement du bras ou remise au repos      
		  if(*ucEtatSequence == NONACTIVE)	// Evite d'enclencher les sequences de repos et d'echauffement
		  {									// durant une autre sequence 
		    if(bEchauffementFait == NONFAIT)		 
		    {
			  *ucSequence = 7;				// Sequence d'echauffement 
		      *ucEtatSequence = ACTIVE;  
			  bEchauffementFait = FAIT;
			  ucTouche = ESPACE;			// Reset ucTouche pour eviter de retourner directement dans le else 
		    }
		    else 
		    {
			  *ucSequence = 8;				// Sequence de retour au repos 
			  *ucEtatSequence = ACTIVE;
			  bEchauffementFait = NONFAIT;
		    }  
		  }
		break;
					  
		case 'B':							// Permet de positionner le bras en position attente
	      if(*ucEtatSequence == NONACTIVE)	// si Aucune sequence en cours 
		  {
		    if(bEchauffementFait == FAIT)	// Si le bras n'est pas au repos 
			{
				*ucSequence = 7;			// Retour position attente 
				*ucStep = 8;
				*ucEtatSequence = ACTIVE;
			}
		  }
		break;
	}
}



// *************************************************************************************************
void vIncMouvement(struct STState *pstState)
//
//  Auteur: Felix Tremblay, Alexandre Dionne et Marie-Pier Morin 	
//  Date de création : 9 decembre 2023  
//  Version 1.0
//
//  Description: Fonction Servant a incrementer la valeur du moteur selectionne 
//  Paramètres d'entrées : pointeur de la structure STState
//  Paramètres de sortie : Aucun
//  Notes     		       : Aucune
//
// *************************************************************************************************
{
	switch(ucNumMoteur)
	{
		case BASE :
		  if(pstState->ucBase <= ucIncrement)
			{
			  pstState->ucBase = 0;
			}
			else 
			{
			  pstState->ucBase = pstState->ucBase - ucIncrement;	
			}
		break;
		
		case EPAULE :
		  pstState->ucEpaule = pstState->ucEpaule + ucIncrement;	
		  if(pstState->ucEpaule >= 205) 
		  {
		    pstState->ucEpaule = 205;
		  }
		break;
		
		case COUDE :
		  if(pstState->ucCoude <= ucIncrement)
		  {
		    pstState->ucCoude = 0;
		  }
		  else 
		  {
		    pstState->ucCoude = pstState->ucCoude- ucIncrement;	
		  }
		break;
		
		case POIGNET :
		  pstState->ucPoignet = pstState->ucPoignet + ucIncrement;	
		  if(pstState->ucPoignet >= 205) 
		  {
		    pstState->ucPoignet = 205;
		  }
		break;
		
		case PINCE :
		  pstState->ucPince = pstState->ucPince + ucIncrement;	
		  if(pstState->ucPince >= 205) 
		  {
		    pstState->ucPince = 205;
		  }
		break;
	}
	
}

// *************************************************************************************************
void vDecMouvement(struct STState *pstState)
//
//  Auteur: Felix Tremblay, Alexandre Dionne et Marie-Pier Morin 	
//  Date de création : 9 decembre 2023
//  Version 1.0
//
//  Description: Fonction servant a decrementer la valeur du moteur selectionne
//  Paramètres d'entrées : pointeur de la structure STState
//  Paramètres de sortie : Aucun
//  Notes     		       : Aucune
//
// *************************************************************************************************
{
	switch(ucNumMoteur)
	{
		case BASE :
			pstState->ucBase = pstState->ucBase + ucIncrement;
			if(pstState->ucBase >= 205) 
			{
				pstState->ucBase = 205;
			}
		break;
		
		case EPAULE :
		  if(pstState->ucEpaule <= ucIncrement)
			{
			  pstState->ucEpaule = 0;
			}
			else 
			{
			  pstState->ucEpaule = pstState->ucEpaule - ucIncrement;	
			}
		break;
		
		case COUDE :
			pstState->ucCoude = pstState->ucCoude + ucIncrement;	
		  if(pstState->ucCoude >= 205) 
			{
				pstState->ucCoude = 205;
			}
		break;
		
		case POIGNET :
		  if(pstState->ucPoignet <= ucIncrement)
			{
			  pstState->ucPoignet = 0;
			}
			else 
			{
			  pstState->ucPoignet = pstState->ucPoignet - ucIncrement;	
			}
		break;
		
		case PINCE :
		  if(pstState->ucPince <= ucIncrement)
			{
			  pstState->ucPince = 0;
			}
			else 
			{
			  pstState->ucPince = pstState->ucPince - ucIncrement;	
			}
		break;
	}	
}


// *************************************************************************************************
void vTraiteTrame(void)
//
//  Auteur: Felix Tremblay, Alexandre Dionne et Marie-Pier Morin 	
//  Date de création : 9 decembre 2023
//  Version 1.0
//
//  Description: Fonction qui traite les donnes recues sur le port serie et les enregistres dans la 
//				 structure de reception une fois ceux si verifier 
//  Paramètres d'entrées : Aucun
//  Paramètres de sortie : Aucun
//  Notes     		       : Aucune
//
// *************************************************************************************************
{
	static unsigned char ucCompteurBuffer = 0;
	unsigned char ucOctetTemp = 0;
	static unsigned char ucCheckSum = 0;
	
	ucOctetTemp = SBUF0;								// Charger le premier octet 
		
	switch(ucCompteurBuffer)
	{
		case 0:
			if(ucOctetTemp == 'G')						// Assure d'avoir recu un 'G'
			{
				stReception.ucOctet0 = ucOctetTemp;
				ucCheckSum = ucCheckSum + stReception.ucOctet0;
				ucCompteurBuffer++;	
			}
			else 
			{
				ucCompteurBuffer = 0;					// Reset du buffer 
			}
		break;
		
		case 1:
			if(ucOctetTemp == 'O')						// Assure d'avoir recu un 'O'
			{
				stReception.ucOctet1 = ucOctetTemp;		// Enregistre la valeur dans la structure de reception
				ucCheckSum = ucCheckSum + stReception.ucOctet1;	// Addition du ChekSum
				ucCompteurBuffer++;
			}
			else 
			{
				ucCompteurBuffer = 0;					// Reset du buffer 
			}
		break;
		
		case 2:											// Les commentaires sont identiques pour les autres cas
		  stReception.ucOctet2 = ucOctetTemp;
		  ucCheckSum = ucCheckSum + stReception.ucOctet2;
		  ucCompteurBuffer++;
		break;
		
		case 3:
		  stReception.ucOctet3 = ucOctetTemp;
		  ucCheckSum = ucCheckSum + stReception.ucOctet3;
		  ucCompteurBuffer++;
		break;
		
		case 4:
		  stReception.ucOctet4 = ucOctetTemp;
		  ucCheckSum = ucCheckSum + stReception.ucOctet4;
		  ucCompteurBuffer++;
		break;
		
		case 5:
	      stReception.ucOctet5 = ucOctetTemp;
		  ucCheckSum = ucCheckSum + stReception.ucOctet5;
		  ucCompteurBuffer++;
		break;
		
		case 6:
	      stReception.ucOctet6 = ucOctetTemp;
		  ucCheckSum = ucCheckSum + stReception.ucOctet6;
		  ucCompteurBuffer++;
		break;
		
		case 7:
		  if(ucCheckSum == ucOctetTemp)
		  {
			stReception.ucOctet7 = ucOctetTemp;
			bTrame = RECU;								// Indique que la trame est bonne et bien recue
			ucCheckSum = 0;								
		  }
		  ucCompteurBuffer = 0; 						// Reset du buffer 
	  break;
		  
	  default:
	  break;		
	}
}

// *************************************************************************************************
void vEnvoieTrame(struct STState *pstState)
//
//  Auteur: Felix Tremblay, Alexandre Dionne et Marie-Pier Morin 	
//  Date de création : 9 decembre 2023
//  Version 1.0
//
//  Description: Fonction qui envoie les valeurs des moteurs au pic 
//  Paramètres d'entrées : pointeur de la structure STState
//  Paramètres de sortie : Aucun
//  Notes     		       : Aucune
//
// *************************************************************************************************
{
	unsigned char ucCheckSum = 0;
	
	
	ES0 = 0;											// Desactive Interrupt RS232 pour eviter que 
														// la transmission cause interrupt non voulu	
	SBUF0 = 'G';										// Envoie du 'G'
	ucCheckSum = ucCheckSum + 'G';						// Addition du CheckSum
	while(!TI_0);	 					
	TI_0 = 0;
	
	SBUF0 = 'O';										// Envoie du 'O'
	ucCheckSum = ucCheckSum + 'O';		
	while(!TI_0);	 
	TI_0 = 0;
	
	SBUF0 = pstState->ucBase;							// Envoie la valeur de la Base
	ucCheckSum = ucCheckSum + pstState->ucBase;
	while(!TI_0);	 
	TI_0 = 0;
	
	SBUF0 = pstState->ucEpaule;							// Envoie la valeur de l'Epaule
	ucCheckSum = ucCheckSum + pstState->ucEpaule;
	while(!TI_0);	 
	TI_0 = 0;
	
	SBUF0 = pstState->ucCoude;							// Envoie la valeur du Coude
	ucCheckSum = ucCheckSum + pstState->ucCoude;
	while(!TI_0);	 
	TI_0 = 0;
		
	SBUF0 = pstState->ucPoignet;						// Envoie la valeur du Poignet
	ucCheckSum = ucCheckSum + pstState->ucPoignet;
	while(!TI_0);	 
	TI_0 = 0;
	
	SBUF0 = pstState->ucPince;							// Envoie la valeur de la Pince
	ucCheckSum = ucCheckSum + pstState->ucPince;	
	while(!TI_0);	 
	TI_0 = 0;
	
	SBUF0 = ucCheckSum;									// Envoie du CheckSum
	while(!TI_0);	 
	TI_0 = 0;
	
	ES0 = 1;											// Reactive Interrupt RS232
}


// *************************************************************************************************
void vAfficheEtat(struct STState *pstState, unsigned char ucSequence, unsigned char ucStep)
//
//  Auteur: Felix Tremblay, Alexandre Dionne et Marie-Pier Morin 	
//  Date de création : 9 decembre 2023  
//  Version 1.0
//
//  Description: Fonction qui affiche la valeurs des moteurs, les valeurs de la balance, de la pince
//				 et du pave tactile, lues par le pic, la grosseur du poids, la valeur de l'increment 
//				 des moteurs en mode manuel, la sequence actuelle, le step actuel et l'etat de la 
//				 transmission
//  Paramètres d'entrées : pointeur de la structure STState, la sequence actuelle, le step actuel 
//  Paramètres de sortie : Aucun
//  Notes     		     : Aucune
//
// *************************************************************************************************
{
	vLCDEcrireCaract(ucConvHextoASCII(pstState->ucBase/16), LIGNE0, 2);		// Valeur de la Base
	vLCDEcrireCaract(ucConvHextoASCII(pstState->ucBase%16), LIGNE0, 3);
	
	vLCDEcrireCaract(ucConvHextoASCII(pstState->ucEpaule/16), LIGNE0, 7);	// Valeur de l'Epaule
	vLCDEcrireCaract(ucConvHextoASCII(pstState->ucEpaule%16), LIGNE0, 8);
	
	vLCDEcrireCaract(ucConvHextoASCII(pstState->ucCoude/16), LIGNE0, 12);	// Valeur du Coude
	vLCDEcrireCaract(ucConvHextoASCII(pstState->ucCoude%16), LIGNE0, 13);
	
	vLCDEcrireCaract(ucConvHextoASCII(pstState->ucPoignet/16), LIGNE0, 17);	// Valeur du Poignet
	vLCDEcrireCaract(ucConvHextoASCII(pstState->ucPoignet%16), LIGNE0, 18);
	
	vLCDEcrireCaract(ucConvHextoASCII(pstState->ucPince/16), LIGNE1, 2);	// Valeur de la Pince
	vLCDEcrireCaract(ucConvHextoASCII(pstState->ucPince%16), LIGNE1, 3);
		
	vLCDEcrireCaract(ucConvHextoASCII(stReception.ucOctet2/16), LIGNE1, 7);	// Valeur pos X sur le pave
	vLCDEcrireCaract(ucConvHextoASCII(stReception.ucOctet2%16), LIGNE1, 8);
	
	vLCDEcrireCaract(ucConvHextoASCII(stReception.ucOctet3/16), LIGNE1, 12);// Valeur pos Y sur le pave	
	vLCDEcrireCaract(ucConvHextoASCII(stReception.ucOctet3%16), LIGNE1, 13);
	
	vLCDEcrireCaract(ucConvHextoASCII(stReception.ucOctet4/16), LIGNE1, 17);// Valeur capteur de la pince
	vLCDEcrireCaract(ucConvHextoASCII(stReception.ucOctet4%16), LIGNE1, 18);
	
	vLCDEcrireCaract(ucConvHextoASCII(stReception.ucOctet5/16), LIGNE2, 2);	// Valeur de la balance
	vLCDEcrireCaract(ucConvHextoASCII(stReception.ucOctet5%16), LIGNE2, 3);
	
	switch(ucBloc)				// Affiche la grosseur du bloc selon le cas 
	{
		case AUCUN:
		  vLCDEcrireCaract('-', LIGNE2, 10);		// Affiche aucun
		  vLCDEcrireCaract('-', LIGNE2, 11);
		break;
		
		case PETIT: 
	      vLCDEcrireCaract('P', LIGNE2, 10);		// Affiche Petit
		  vLCDEcrireCaract('e', LIGNE2, 11);		
		break;
		
		case MOYEN: 
		  vLCDEcrireCaract('M', LIGNE2, 10);		// Affiche Moyen
		  vLCDEcrireCaract('o', LIGNE2, 11);
		break;
		
		case GROS: 
		  vLCDEcrireCaract('G', LIGNE2, 10);		// Affiche Gros
		  vLCDEcrireCaract('r', LIGNE2, 11);
		break;
	}
	
	vLCDEcrireCaract(ucConvHextoASCII(ucIncrement/16), LIGNE3, 0);			// Valeur de l'increment
	vLCDEcrireCaract(ucConvHextoASCII(ucIncrement%16), LIGNE3, 1);
	
	vLCDEcrireCaract(ucConvHextoASCII(ucSequence%16), LIGNE3, 7);			// Sequence actuelle
	
	vLCDEcrireCaract(ucConvHextoASCII(ucStep%16), LIGNE3, 14);				// Step actuel
}

// *************************************************************************************************
unsigned char ucConvHextoASCII(unsigned char ucHex)
//
//  Auteur: Felix Tremblay, Alexandre Dionne et Marie-Pier Morin 	
//  Date de création : 9 decembre 2023
//  Version 1.0
//
//  Description: Fonction qui convertit un chiffre hexadecimal ou decimal en code ASCII pour l'afficher  
//				 sur l'ecran LCD de la Dallas
//  Paramètres d'entrées : Valeur en hexadicimal ou decimal, ucHex
//  Paramètres de sortie : Lettre ou chiffre en hexadecimal de la valeur convertit 
//  Notes     		     : Aucune
//
// *************************************************************************************************
{
	unsigned char ucASCII;
	
	if(ucHex >= 0 && ucHex <= 9)		// Ajoute 0x30 au chiffre a convertir pour 
	{									// acceder au chiffre 0 a 9 ASCII
	  ucASCII = ucHex + 0x30;			
	}
	
	if(ucHex >= 10 && ucHex <= 15)		// Ajoute 0x37 au chiffre a convertir pour 
	{									// acceder au lettre A a F ASCII
      ucASCII = ucHex + 0x37;
	}
	return(ucASCII);
}


// *************************************************************************************************
void vTraiteSequence(unsigned char *ucEtatSequence, unsigned char *ucSequence, unsigned char *ucStep)
//
//  Auteur: Felix Tremblay, Alexandre Dionne et Marie-Pier Morin 	
//  Date de création : 9 decembre 2023 
//  Version 1.0
//
//  Description: 
//  Paramètres d'entrées : l'etat de la sequence, la sequence actuelle, le step actuel 
//  Paramètres de sortie : Aucun
//  Notes     		     : Aucune
//
// *************************************************************************************************
{
	if(*ucEtatSequence == ACTIVE)
	{
		
		
		switch(*ucSequence)
		{
			case 0:  						// Saisie du poids sur case A2
			case 1:							// Saisie du poids sur case B7
			case 2:							// Saisie du poids sur case C6
			  if(*ucStep >= 7)				// Termine la sequence pour eviter l'attente
			  {
			    
				if(stReception.ucOctet4 <= 0x40)  // Test pression dans la pince 
				{
					*ucSequence = 3;		// Continue la sequence a la balance
					*ucStep = 9;			// si un poids est saisie
				}							
				else 
				{
				  *ucStep     = 8;  		// Retour a la position attente
				  *ucSequence = 7;			
				  ucBloc = AUCUN;
				}
				
			  }	
			break;
				
			case 3:                 		// Test de la balance pour determiner la grosseur du poids  
			  
				if(*ucStep >= 4 && *ucStep <= 5)   
				{
				  if(stReception.ucOctet5 >= 0x00 && stReception.ucOctet5 < 0x30)	// Valeur pour aucun poids 
				  {
					ucBloc = AUCUN;
				  }
				  if(stReception.ucOctet5 >= 0x30 && stReception.ucOctet5 <= 0x40)	// Valeur pour petit poids 
				  {
					ucBloc = PETIT;
			      }
				  if(stReception.ucOctet5 >= 0x60 && stReception.ucOctet5 <= 0x80)	// Valeur pour poids moyen
				  {
					ucBloc = MOYEN;
				  }
				  if(stReception.ucOctet5 >= 0xA0 && stReception.ucOctet5 <= 0xB0)	// Valeur pour gros poids 
				  {
					ucBloc = GROS;
				  }
			    }
				
				if(*ucStep >= 8)	
				{
				  *ucStep = 9;			
				  switch(ucBloc)  		// Choisie la sequence de triage selon la grosseur du poids
				  {
				    case PETIT:
					  *ucSequence = 4;
					break;
						
					case MOYEN:
					  *ucSequence = 5;
					break;
						
					case GROS:
					  *ucSequence = 6;
					break;
						
					case AUCUN:				// Retour position attente si aucun poids
					  *ucSequence = 7;
					  *ucStep = 8; 
					break;
				  }
				}
			break;
				
			case 4:                			// Place le bloc sur triage 20g  
			case 5:							// Place le bloc sur triage 50g 
			case 6: 			  			// Place le bloc sur triage 70g 
			  if(*ucStep >= 6)				// Termine la sequence pour eviter l'attente
			  {
			    *ucStep = 9;
				 *ucSequence = 0;			// Retour a la position attente
				*ucEtatSequence = NONACTIVE;
				ucBloc = AUCUN;
			  }	
			break;
			
			case 7:							// Sequence de rechauffement et position attente
		      if(*ucStep >= 7)				// Termine la sequence pour eviter l'attente
			  {
				  *ucStep = 9;
				  *ucSequence = 0;
				  *ucEtatSequence = NONACTIVE;
			  }
			break;
			  
			case 8:							// Sequence retour au repos 
			  if(*ucStep >= 6)				// Termine la sequence pour eviter l'attente
			  {
				  *ucStep = 9;
				  *ucSequence = 0;
				  *ucEtatSequence = NONACTIVE;
			  }
			break;
			  
        }
		
		if(*ucStep != 9)					
		{
			*ucStep = *ucStep + 1;			// Incremente ucStep a chaque 2 secondes
		}
		else 
		{
			*ucStep = 0;					// Jusqu'a 9
		}
		
	}
}

// *************************************************************************************************
void vTraitePave(unsigned char *ucEtatSequence, unsigned char *ucSequence)
//
//  Auteur: Felix Tremblay, Alexandre Dionne et Marie-Pier Morin 	
//  Date de création : 9 decembre 2023 
//  Version 1.0
//
//  Description: Fonction qui traite les valeurs X et Y lues sur le pave tactile et effectue les actions 
//				 necessaire pour nos case specifique
//  Paramètres d'entrées : Etat de la sequence, la sequence actuelle 
//  Paramètres de sortie : Aucun
//  Notes     		     : Aucune
//
// *************************************************************************************************
{
  unsigned char ucX;
  unsigned char ucY;
	
  ucX = stReception.ucOctet2;									// Valeur X du pave 
  ucY = stReception.ucOctet3;									// Valeur Y du pave

	
  if(bEchauffementFait == FAIT)										// Lit les cases seulement si le 					
  {																	// bras est en position attente
    if(ucX >= 0x80 && ucX <= 0xA0 && ucY >= 0x30 && ucY <= 0x60)	// Valeur pour Case A2
    {
	  *ucSequence = 0;
	  *ucEtatSequence = ACTIVE;										// Active la sequence
    }
	
    if(ucX >= 0xE0 && ucX <= 0xF0 && ucY >= 0x60 && ucY <= 0x90)	// Valeur pour Case B7
    {
	  *ucSequence = 1;
	  *ucEtatSequence = ACTIVE;										// Active la sequence
    }
	
    if(ucX >= 0xD0 && ucX <= 0xE0 && ucY >= 0x90 && ucY <= 0xC0)	// Valeur pour Case C6
    {
	  *ucSequence = 2;
      *ucEtatSequence = ACTIVE;										// Active la sequence
    }		  
  }
}


// *************************************************************************************************
void vInitTimer0(void)
//  Auteur: Felix Tremblay, Alexandre Dionne et Marie-Pier Morin 	
//  Date de création : 9 decembre 2023
//
//   Description : Cette fonction initialise le Timer0 en mode 16, pour lever du flag a 50ms          
//   Paramètres d'entrée : Aucun.
//   Paramètres de sortie : Aucun.                
//   Variables utilisées : Aucun.
//***************************************************************************************************
{
	TMOD = (TMOD | 0x01);					// Mode 16 Bits
	TH0 = 0x4C;								// Valeur pour 50ms
	TL0 = 0x00;
	TF0 = 0;								// Clear le flag 
	TR0 = 1;								// Active le Timer0
}

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

