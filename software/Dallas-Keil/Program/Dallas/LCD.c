#include "LCD.h"



unsigned char xdata *PtrLCDConfig = 0x8000;
unsigned char xdata *PtrLCDChar = 0x8002;
unsigned char xdata *PtrLCDBusy = 0x8001;
	
// *************************************************************************************************
//  Auteur: Alexandre Dionne
//  Date de création :  22 septembre 2023
//  
//  Description          : Fonction qui configure le LCD sur la carte Dallas.
//  Paramètres d'entrées : Aucun
//  Paramètres de sortie : Aucun
//  Notes     		 			 : Aucune
//
void vLCDConfig(void)
// ************************************************************************************************
{
	unsigned int i; 
  
	for(i = 0; i < 12000; i++);	//Delai d'activation de l'ecran au demarrage	
    vAttendreBusyLcd();
	*PtrLCDConfig = 0x38;
 	vAttendreBusyLcd();
	*PtrLCDConfig = 0x0C;
	vAttendreBusyLcd();
	*PtrLCDConfig = 0x06;
	vAttendreBusyLcd();	
    vEffaceLCD();
}

// *************************************************************************************************
//  Auteur: Alexandre Dionne
//  Date de création :  22 septembre 2023
//  
//  Description          : Fonction pour écrire un caractère sur le LCD.
//  Paramètres d'entrées : le caractère, la ligne et la colonne
//  Paramètres de sortie : Aucun
//  Notes     		 			 : Aucune
//
void vLCDEcrireCaract(unsigned char ucCaract, unsigned char ucLigne, unsigned char ucColonne)
// ************************************************************************************************
{
  *PtrLCDConfig = ucLigne + ucColonne;
  vAttendreBusyLcd();
  *PtrLCDChar = ucCaract;
  vAttendreBusyLcd();
}

// *************************************************************************************************
//
//  Auteur: Stéphane Deschênes 	
//  Date de création :  25 août 2019
//
//  Description					 : Fonction qui verifie l'état du busy flag du LCD
//  Paramètres d'entrées : Aucun
//  Paramètres de sortie : Aucun
//  Notes     		       : Aucune
void vAttendreBusyLcd(void)
// *************************************************************************************************
{
	unsigned char i;
	while ( *PtrLCDBusy & 0x80 )
  {
  };
  for(i=0; i<10; i++);	
}

// ************************************************************************************************
//
//  Auteur: Stéphane Deschênes 	
//  Date de création :  25 août 2019
//
//  Description					 : Fonction qui verifie l'état du busy flag du LCD
//  Paramètres d'entrées : Aucun
//  Paramètres de sortie : Aucun
//  Notes     		       : Aucune
void vAfficheLigneLCD(unsigned char ucTab[21], unsigned char ucLigne)
// *************************************************************************************************
{
	int i;
	for(i=0; i<20; i++)
	{
		vLCDEcrireCaract(ucTab[i], ucLigne,i);
	}
}

// ************************************************************************************************
//
//  Auteur: Stéphane Deschênes 	
//  Date de création :  25 août 2019
//
//  Description					 : Fonction qui verifie l'état du busy flag du LCD
//  Paramètres d'entrées : Aucun
//  Paramètres de sortie : Aucun
//  Notes     		       : Aucune
void vAfficheLCDComplet(unsigned char ucTab[4][21])
// *************************************************************************************************
{
	unsigned char ucTabLigne[4] = {0x80, 0xC0, 0x94, 0xD4};
	int i;
	for(i=0; i<4; i++)
	{
		vAfficheLigneLCD(&ucTab[i][0],ucTabLigne[i]);
	}
}

// ************************************************************************************************
//
//  Auteur: Alexandre Dionne	
//  Date de création :  22 septembre 2023
//
//  Description					 : Fonction qui efface tous les caractère sur le LCD
//  Paramètres d'entrées : Aucun
//  Paramètres de sortie : Aucun
//  Notes     		       : Aucune
void vEffaceLCD(void)
// *************************************************************************************************
{
	vAttendreBusyLcd();
	*PtrLCDConfig = 0x01;
	vAttendreBusyLcd();
	*PtrLCDConfig = 0x02;
	vAttendreBusyLcd();
}
#ifdef CARACTERE_SPECIAUX
// ************************************************************************************************
//
//  Auteur: Alexandre Dionne	
//  Date de création :  22 septembre 2023
//
//  Description					 : Fonction qui charge la CGRAM du LCD
//  Paramètres d'entrées : Aucun
//  Paramètres de sortie : Aucun
//  Notes     		       : Aucune
void vLoadCGRAMLCD(unsigned char ucTab[8][8])
// *************************************************************************************************
{
	unsigned char ucCompteurCaract;
	unsigned char ucCompteurOctetsDansCaract;
	// Boucle pour chacun des 8 caractères
	for (ucCompteurCaract= 0; ucCompteurCaract < 8; ucCompteurCaract++)
	{
		// Boucle pour chacune des 8 lignes dans un caractère
		for(ucCompteurOctetsDansCaract = 0; ucCompteurOctetsDansCaract < 8;	ucCompteurOctetsDansCaract++)
		{
			vAttendreBusyLcd();
			*PtrLCDConfig = 0x40 + (8*ucCompteurCaract) + ucCompteurOctetsDansCaract;
			vAttendreBusyLcd();
			*PtrLCDChar = ucTab[ucCompteurCaract][ucCompteurOctetsDansCaract];
		}
	}
}
#endif









