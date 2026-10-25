;   This file is a basic code template for assembly code generation   *
;   on the PICmicro PIC16F88. This file contains the basic code       *
;   building blocks to build upon.                                    *
;                                                                     *
;   If interrupts are not used all code presented between the ORG     *
;   0x004 directive and the label main can be removed. In addition    *
;   the variable assignments for 'w_temp' and 'status_temp' can       *
;   be removed.                                                       *
;                                                                     *
;   Refer to the MPASM User's Guide for additional information on     *
;   features of the assembler (Document DS33014).                     *
;                                                                     *
;   Refer to the respective PICmicro data sheet for additional        *
;   information on the instruction set.                               *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Filename:	    ADCPIC.asm                                        *
;    Date: 23-11-28                                                   *
;    File Version: V1                                                 *
;                                                                     *
;    Author:                                                          *
;    Company:                                                         *
;                                                                     *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Files required:                                                  *
;                                                                     *
;                                                                     *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Notes:                                                           *
;                                                                     *
;                                                                     *
;                                                                     *
;                                                                     *
;**********************************************************************

     LIST      p=16f88         ; Liste des directives du processeur.
     #include <p16F88.inc>     ; Définition des registres spécifiques au CPU.

     errorlevel  -302          ; Retrait du message d'erreur 302.

     __CONFIG    _CONFIG1, _CP_OFF & _CCP1_RB0 & _DEBUG_OFF & _WRT_PROTECT_OFF & _CPD_OFF & _LVP_OFF & _BODEN_ON & _MCLR_ON & _PWRTE_ON & _WDT_OFF & _INTRC_IO

     __CONFIG    _CONFIG2, _IESO_OFF & _FCMEN_OFF



; '__CONFIG' directive is used to embed configuration word within .asm file.
; The lables following the directive are located in the respective .inc file.
; See data sheet for additional information on configuration word settings.


;***********************************DEFINES************************************
#define      BANK0             bcf   STATUS,RP0;
#define      BANK1             bsf   STATUS,RP0;

#define	    SW1     PORTB, 06
#define	    SW2	    PORTB, 07
#define	    SW3	    PORTA, 07
#define	    LED1    PORTB, 03
#define	    LED2    PORTB, 04

;***** VARIABLE DEFINITIONS
w_temp        EQU     0x71        ; variable used for context saving 
status_temp   EQU     0x72        ; variable used for context saving
pclath_temp   EQU     0x73	  ; variable used for context saving



;VosVariables  EQU     0x20       ; Mettre ici vos Variables
  CBLOCK  0x20
  vADCH				  ; Valeur Haute du resultat de conversion
  vADCL                           ; Valeur Basse du resultat de conversion

  endc





;*************************VECTEUR DE RESET*************************************
     ORG     0x000             ; Processor reset vector
     clrf    PCLATH            ; Page 0 (a cause du BootLoader)
     goto    main              ; 
        

;***********************VECTEUR D'INTERRUPTION*********************************    
     ORG     0x004             ; Interrupt vector location
     goto    Interruption

main
     call   InitPic
     
     
Again
     
     goto   Again
     


   
     
     
     
     
; remaining code goes here









;******************************************************************************

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
     bcf     STATUS, RP1       ; Pour s'assurer d'être dans les bank 0 et 1 
     BANK1                     ; Select Bank1        
     bcf     INTCON,GIE        ; Désactive les interruptions        
     clrf    ANSEL             ; Désactive les convertisseurs reg ANSEL 0x9B        
     movlw   b'01111000'       ; osc internal 8 Mhz
     movwf   OSCCON
     movlw   b'11111111'       ; Remplacer les x par des 1 ou 0.
     movwf   TRISA             ; PortA en entree         
     movlw   b'11100111'       ; Bits en entrées sauf,
     movwf   TRISB             ; RB3 (Led1), RB4 (Led2) en sortie. 
     BANK0                     ; Select Bank0
     return

; fin routine InitPic ---------------------------------------------------------


     
;******************************* InitADC **************************************
;       Nom de la fonction : InitADC                   
;       Auteur : Félix Tremblay
;       Date de creation : 23-11-28                              
;       Description : Fonction d'initialisation de l'ADC. 
;	              Le bit A0 du PortA est pour etre convertit, de base.
;		      Les bits A0, A1 et A2 sont configurer en entree analogique
;                                                       
;       Fonctions appelees : NA 
;       Paramètres d'entree : NA  
;       Paramètres de sortie : NA 
;       Variables utilisees : NA  
;       Include : Fichier P16F88.inc
;       Equates : NA
;       Define : Aucun 
;                                               
;******************************************************************************
InitADC
     BANK1
     movlw   b'00000111'
     movwf   ANSEL
     movlw   b'11000000'
     movwf   ADCON1
     BANK0
     movlw   b'10000001'
     movwf   ADCON0
     return 
; fin routine InitADC ---------------------------------------------------------
     
     
;******************************* StartConvADC **********************************
;       Nom de la fonction : StartConvADC                   
;       Auteur : Félix Tremblay
;       Date de creation : 23-11-28                              
;       Description : Fonction qui demarre une converstion ADC
;			
;                                                       
;       Fonctions appelees : NA 
;       Paramètres d'entree : NA  
;       Paramètres de sortie : NA 
;       Variables utilisees : NA  
;       Include : Fichier P16F88.inc
;       Equates : NA
;       Define : Aucun 
;                                               
;******************************************************************************
StartConvADC
     bsf     ADCON0, 02
     return 
; fin routine StartConvADC -----------------------------------------------------
     
     
;******************************* LectureADC ************************************
;       Nom de la fonction : LectureADC                 
;       Auteur : Félix Tremblay
;       Date de creation : 23-11-28                              
;       Description : Fonction qui lit le resultat convertit de l'ADC 
;                     vADCL et vADCH doivent etre declare au debut du programme
;
;                                                       
;       Fonctions appelees : NA 
;       Paramètres d'entree : NA  
;       Paramètres de sortie : NA 
;       Variables utilisees : vADCH, vADCL  
;       Include : Fichier P16F88.inc
;       Equates : NA
;       Define : Aucun 
;                                               
;******************************************************************************
LectureADC
     BANK1
     movf    ADRESL, w
     movwf   vADCL
     BANK0
     movf    ADRESH, w
     movwf   vADCH
     return 
; fin routine  LectureADC ------------------------------------------------------ 
          

     
;******************************* SelectPA0ADC **********************************
;       Nom de la fonction : SelectPA0ADC                   
;       Auteur : Félix Tremblay
;       Date de creation : 23-11-28                              
;       Description : Fonction qui selectionne l'entree A0 du PortA pour etre 
;		      convertit     
;
;                                                       
;       Fonctions appelees : NA 
;       Paramètres d'entree : NA  
;       Paramètres de sortie : NA 
;       Variables utilisees : NA  
;       Include : Fichier P16F88.inc
;       Equates : NA
;       Define : Aucun 
;                                               
;******************************************************************************
SelectPA0ADC
     bcf     ADCON0, 03
     bcf     ADCON0, 04
     return 
; fin routine  SelectPA0ADC ----------------------------------------------------
     

;******************************* SelectPA1ADC **********************************
;       Nom de la fonction : SelectPA1ADC                   
;       Auteur : Félix Tremblay
;       Date de creation : 23-11-28                              
;       Description : Fonction qui selectionne l'entree A1 du PortA pour etre 
;		      convertit     
;
;                                                       
;       Fonctions appelees : NA 
;       Paramètres d'entree : NA  
;       Paramètres de sortie : NA 
;       Variables utilisees : NA  
;       Include : Fichier P16F88.inc
;       Equates : NA
;       Define : Aucun 
;                                               
;******************************************************************************
SelectPA1ADC
     bcf     ADCON0, 04
     bsf     ADCON0, 03
     return 
; fin routine  SelectPA0ADC ----------------------------------------------------
     
     
;******************************* SelectPA2ADC **********************************
;       Nom de la fonction : SelectPA2ADC                   
;       Auteur : Félix Tremblay
;       Date de creation : 23-11-28                              
;       Description : Fonction qui selectionne l'entree A2 du PortA pour etre 
;		      convertit     
;
;                                                       
;       Fonctions appelees : NA 
;       Paramètres d'entree : NA  
;       Paramètres de sortie : NA 
;       Variables utilisees : NA  
;       Include : Fichier P16F88.inc
;       Equates : NA
;       Define : Aucun 
;                                               
;******************************************************************************
SelectPA2ADC
     bcf     ADCON0, 03
     bsf     ADCON0, 04
     return 
; fin routine  SelectPA2ADC ----------------------------------------------------     
     
     

;****************************** Interruption **********************************
Interruption

;    movwf     w_temp         ; save off current W register contents
;    movf      STATUS,w       ; move STATUS register into W register
;    movwf     status_temp    ; save off contents of STATUS register
;    movf      PCLATH,W       ; move PCLATH register into W register
;    movwf     pclath_temp    ; save off contents of PCLATH register

; isr code can go here or be located as a call subroutine elsewhere


;    movf      pclath_temp,w  ; retrieve copy of PCLATH register
;    movwf     PCLATH         ; restore pre-isr PCLATH register contents
;    movf      status_temp,w  ; retrieve copy of STATUS register
;    movwf     STATUS         ; restore pre-isr STATUS register contents
;    swapf     w_temp,f
;    swapf     w_temp,w       ; restore pre-isr W register contents
    retfie                   ; return from interrupt

; fin de la routine Interruption-----------------------------------------------



; initialize eeprom locations

	ORG	0x2100
	DE	0x00, 0x01, 0x02, 0x03


	END                       ; directive 'end of program'

