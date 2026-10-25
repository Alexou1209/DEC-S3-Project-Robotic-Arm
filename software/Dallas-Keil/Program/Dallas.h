#ifndef DALLAS_H
#define DALLAS_H

#include "Interrupt.h"
#include "LCD.h"
#include "ClavierI2C.h"
#include "MonDallas.h"
#include "I2C.h"

#define NONACTIVE   0
#define NONFAIT		0
#define ACTIVE      1
#define FAIT		1
#define NONRECU     0
#define RECU        1
#define APPUYER     0         
#define RELACHER	1

#define BASE        0
#define EPAULE      1
#define COUDE	    2
#define POIGNET	    3
#define PINCE		4

#define ESPACE      0x20

#define AUCUN		0
#define PETIT		1
#define MOYEN	    2
#define GROS	    3


extern bit bDelai200ms;			
extern bit bDelai300ms;
extern bit bDelai2s;
extern bit bTrame;

extern unsigned char ucTemps300ms;		

struct STState 						// Valeurs des moteurs du bras
{
  unsigned char ucBase;
  unsigned char ucEpaule;
  unsigned char ucCoude;
  unsigned char ucPoignet;
  unsigned char ucPince;
};

struct STReception					// Buffer de reception
{
	unsigned char ucOctet0;
	unsigned char ucOctet1;
	unsigned char ucOctet2;
	unsigned char ucOctet3;
	unsigned char ucOctet4;
	unsigned char ucOctet5;
	unsigned char ucOctet6;
	unsigned char ucOctet7;
};


void vTraiteTouche(unsigned char ucTouche, struct STState *pstState, unsigned char *ucSequence, unsigned char *ucEtatSequence, unsigned char *ucStep);

void vInitTimer0(void);

void vInitVitessePortSerie(unsigned long fVitesse, unsigned long fFreq);

void vIncMouvement(struct STState *pstState);

void vDecMouvement(struct STState *pstState);

void vTraiteTrame(void);

unsigned char ucConvHextoASCII(unsigned char ucHex);

void vAfficheEtat(struct STState *pstState, unsigned char ucSequence, unsigned char ucStep);

void vTraiteSequence(unsigned char *ucEtatSequence, unsigned char *ucSequence, unsigned char *ucStep);

void vTraitePave(unsigned char *ucSequenceActive, unsigned char *ucsequence);

void vEnvoieTrame(struct STState *pstState);




#endif