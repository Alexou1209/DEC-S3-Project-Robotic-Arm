;******************************************************************************
;                                                                             *
;    Filename:      Main.asm                                                  *
;    Date:	    17 décembre 2023                                          *
;    File Version:  V1                                                        *
;                                                                             *
;    Author:	    Marie-Pier Morin, Félix Tremblay et Alexandre Dionne      *
;                                                                             *
;******************************************************************************
;                                                                             *
;    Files required: FonctionsPCA9685.asm, FonctionsRS-232.asm,               *
;                    FonctionsBras.asm, FonctionDelai.asm, FonctionsI2C.asm,  *
;                    FonctionsADC.asm                                         *
;                                                                             *
;******************************************************************************
;                                                                             *
;    Notes:                                                                   *
;                                                                             *
;                                                                             *
;                                                                             *
;                                                                             *
;******************************************************************************

;***********************DIAGRAMME DU CONTROLEUR********************************
;                                                                     
;                     IN  IN  S3  IN      S2  S1  TX  D2            S: Switch 
;                     A1  A0  A7  A6 VDD  B7  B6  B5  B4              
;                    ____________________________________             
;           PIN     | 18  17  16  15  14  13  12  11  10 |            
;                   |               16C88                |            
;           PIN     | 1   2   3  _4_  5   6   7   8   9  |            
;                    ------------------------------------             
;                     A2  A3  A4  A5 VSS  B0  B1  B2  B3              
;                     IN  IN  IN  MCL     SCL SDA RX  D1            D: Del  
;
;******************************************************************************

     LIST      p=16f88          ; Liste des directives du processeur.
     #include <p16F88.inc>      ; Définition des registres spécifiques au CPU.

     errorlevel  -302           ; Retrait du message d'erreur 302.

     __CONFIG    _CONFIG1, _CP_OFF & _CCP1_RB0 & _DEBUG_OFF & _WRT_PROTECT_OFF & _CPD_OFF & _LVP_OFF & _BODEN_ON & _MCLR_ON & _PWRTE_ON & _WDT_OFF & _INTRC_IO

     __CONFIG    _CONFIG2, _IESO_OFF & _FCMEN_OFF

;*********************************** DEFINES **********************************
#define      BANK0   bcf       STATUS,RP0;
#define      BANK1   bsf       STATUS,RP0;
#define      CARRY             STATUS,C
#define	     ZERO	       STATUS,Z
;*********************************** KIT-PIC **********************************
#define      SW1               PORTB,6
#define      SW2               PORTB,7
#define      SW3               PORTA,7
#define      DEL1              PORTB,3
#define      DEL2              PORTB,4
;************************************ I2C *************************************
#define      SCL               PORTB,0
#define      SDA               PORTB,1
#define      BITSDA            v1Bit,0
#define      OCTET             vOctet,7
;*********************************** RS-232 ***********************************
#define	    FLAGRX	       vFlag,0
#define	    FLAGTX	       vFlag,1
#define	    FLAGFINTRAME       vFlag,2
#define	    FLAGTRAMEOK	       vFlag,3
;*********************************** Timer ************************************
#define	    FLAG100MS	       vFlag,4
;***** VARIABLE DEFINITIONS  **************************************************

  CBLOCK  0x20
;Variables communication RS-232
  vOctet0			; Variables utilisées pour 
  vOctet1			; le stockage temporaire des
  vOctet2			; octets reçu par communication
  vOctet3			; RS-232.
  vOctet4			; Placées de l'adresse 0x20 
  vOctet5			; à 0x27 pour pouvoir modifier
  vOctet6			; leurs valeurs de manière
  vOctet7			; indirecte
  vIndiceIN			; Nombre d'éléments reçu non traités
  vIndiceOUT			; Nombre d'éléments reçu traités
  vOctetG			; Octet de début de trame
  vOctetO			; 2e octet de début de trame
  vCheckSum			; Octet de fin de trame pour vérifier 
				; la validité de celle-ci
;Variables fonctions I2C 
  v1Bit                         ; Variable Bit
  vOctet                        ; Variable Octets
  vAckValue			; Valeur du Ack/NoAck envoyé
  vAddH                         ; Adresse basse
  vAddB				; Adresse haute
  vData				; Donnée à envoyer
  vCompteur			; Utilisée pour les boucles I2C
  vCompt1ms			; Compteur pour le délai 1ms
  vCompt5ms			; Compteur pour le délai 5ms
  
;Variables Fonctions ADC
  vADCL				; Valeur basse de l'ADC
  vADCH				; Valeur haute de l'ADC

;Variables fonctions PCA9685
  vPWM				; Valeur basse du PWM
  vPWMH				; Valeur haute du PWM
  vMoteurPCA			; Moteur sélectionné
  
;Variables Fonctions bras robotisé
  vPaveX			; Valeurs lue du pavé sur l'axe X
  vPaveY			; Valeurs lue du pavé sur l'axe Y
  vPince			; Valeurs lue de la pince
  vBalance			; Valeurs lue de la balance 
  vMoteur0			; Position du moteur 0 (base)
  vMoteur1			; Position du moteur 1 (épaule)
  vMoteur2			; Position du moteur 2 (coude)
  vMoteur3			; Position du moteur 3 (poignet)
  vMoteur4			; Position du moteur 4 (pince)
  
;Variables autres
  vFlag				; différents flag utilisés dans le programme

  endc

;***************************VECTEUR DE RESET***********************************
     ORG     0x000             ; Processor reset vector
     clrf    PCLATH            ; Page 0 (a cause du BootLoader)
     goto    Main              ;       

;***********************VECTEUR D'INTERRUPTION*********************************    
     ORG     0x004             ; Interrupt vector location
     goto    Interruption         
             
;**************************PROGRAMME PRINCIPAL*********************************
             
Main         
    call    InitPic             ; Initialise PIC et place les ports en IN/OUT
    call    InitRS232           ; Initialise la communication RS232 du PIC 
    call    InitADC		; Initialise l'ADC du PIC
    call    ResetPCA9685	; Initialise la carte PCA9685
    call    SetFreqPCA9685
   
    clrf    vFlag		; Tous les flag à 0
    movlw   0x20		
    movwf   vIndiceIN		; Valeur initiale de vIndiceIN (0x20)
    movwf   vIndiceOUT		; Valeur initiale de vIndiceOUT (0x20)
    
    bcf	   PIR1,TMR1IF		; Mets le flag du timer 1 a 0
    bcf    PIR1,RCIF		; Mets le flag de la reception RS-232 a 0
    BANK1			
    bsf	    PIE1,RCIE		; Activation des interruptions en reception
    bsf	    PIE1,TMR1IE		; Activation des interruptions du timer1
    bsf	    INTCON,PEIE		; Activation des interruptions des périphérique
    bsf	    INTCON,GIE		; Activation des inyterruptions globales
    BANK0
    
    call    InitTimer1		; Initialise le timer1 a 100ms de délai
    
Loop
    movfw   vIndiceOUT
    subwf   vIndiceIN,W		
    btfss   ZERO		; Si vIndiceIN différent de vIndiceOUT
    call    TraiterCaractere	; Traite les caractères reçus
    btfsc   FLAGTRAMEOK		; Si la trame reçu est valide
    call    BougerMoteurs	; Déplace les moteurs aux nouvelles positions
    nop
    btfsc   FLAG100MS		; Si 100ms de délai
    call    EnvoyerTrameDallas  ; Envoie de la trame à la carte Dallas
    goto    Loop		; Boucle infini
   
;******************************* ROUTINES *************************************

;******************************* InitPic **************************************
;       Nom de la fonction : InitPic                    
;       Auteur : Alain Champagne
;       Date de creation : 23-09-2018                                
;       Description :      Routine d'initiation des registres du PIC.
;                          - RP1 à 0 pour être toujours dans Bank 0 et 1,
;                          - Désactiver les interruptions,
;                          - Désactiver les entrées analogiques,
;                          - PortA en entrée,
;                          - PortB en entrée sauf: Bits I2C et LEDs en sortie.
;                                                       
;       Fonctions appelees : NA 
;       Paramètres d'entree : NA  
;       Paramètres de sortie : NA 
;       Variables utilisees : NA  
;       Include : Fichier P16F88.inc
;       Equates : NA
;       #Defines : BANK0, BANK1 
;                                               
;******************************************************************************
InitPic
     bcf     STATUS, RP1        ; Pour s'assurer d'être dans les bank 0 et 1 
     BANK1                      ; Select Bank1        
     bcf     INTCON,GIE         ; Désactive les interruptions        
     clrf    ANSEL              ; Désactive les convertisseurs reg ANSEL 0x9B        
     movlw   b'01111000'        ; osc internal 8 Mhz
     movwf   OSCCON
     movlw   b'11111111'        ; Remplacer les x par des 1 ou 0.
     movwf   TRISA              ; PortA en entree         
     movlw   b'11100100'        ; Bits en entrées sauf,
     movwf   TRISB              ; RB3 (Led1), RB4 (Led2) en sortie. 
     BANK0                      ; Select Bank0
     return
; fin routine InitPic ---------------------------------------------------------

#include    <FonctionsPCA9685.asm> 
#include    <FonctionsRS-232.asm>
#include    <FonctionsBras.asm> 
#include    <FonctionDelai.asm> 
#include    <FonctionsI2C.asm>
#include    <FonctionsADC.asm> 

;****************************** Interruption **********************************
Interruption

TestFlagRx			
    btfss   PIR1,RCIF		; Test du flag de reception RS-232	
    goto   TestFlagTimer1	; Si non, test du flag du timer1
    movfw  vIndiceIN		; Si oui, stocker l'octet
    movwf  FSR			; Recu dans la variables pointé
    movfw  RCREG		; par IndiceIN
    movwf  INDF
    bcf    PIR1,RCIF		; Remise du flag a 0
    incf   vIndiceIN		; Incrémente vIndiceIN
    movfw  vIndiceIN		
    andlw  0x27			; si vIndiceIN > 0x27, vIndiceIN = 0x20
    movwf  vIndiceIN  
     
TestFlagTimer1
    btfss   PIR1,TMR1IF		; Test du flag du timer1
    goto    FinInterrupt	; Si flag = 0, aller à la fin des interruptions
    bcf	    PIR1,TMR1IF		; Remise du flag du timer1 a 0
    movlw   0x99		; Recharge du timer1
    movwf   TMR1H		; à une fréquence de 
    movlw   0xFE		; 250kHz
    movwf   TMR1L		; 100ms de délai
    bsf	    FLAG100MS		; mets a 1 le flag 100ms de délai
    
FinInterrupt
    retfie			; return from interrupt
; fin de la routine Interruption-----------------------------------------------
    
        END                     ; directive 'end of program'