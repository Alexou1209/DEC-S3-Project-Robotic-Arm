
;******************************************************************************
;                                                                             *
;    Filename:      Frame.asm                                                 *
;    Date:                                                                    *
;    File Version:                                                            *
;                                                                             *
;    Author:                                                                  *
;    Company:                                                                 *
;                                                                             *
;                                                                             *
;******************************************************************************
;                                                                             *
;    Files required:                                                          *
;                                                                             *
;                                                                             *
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



;******************** Les fonctions utilisees *********************************
; InitPic                      ; Initialise le PIC.
; SDA0                         ; Met SDA a 0
; SDA1                         ; Met SDA a 1
; SCL0                         ; Met SCL a 0 
; SCL1                         ; Met SCL a 1  
; EcrireMemI2C                 ; Ecrire un octet en memoire I2C
; LireMemI2C                   ; Lecture d'un octet en memoire I2C
; Ecrire8BitsI2C               ; Ecrire 8 bits sur la ligne I2C
; Lire8BitsI2C                 ; Lire 8 bits sur la ligne I2C
; Ecrit1BitI2C                 ; Emet 1 bit sur la ligne I2C
; Lire1BitI2C                  ; Recoit 1 bit sur la ligne I2C
; StartBitI2C                  ; Start une communication I2C
; StopBitI2C                   ; Termine une communication I2C
; Delai5us                     ; Delai pour maintenir signaux 5us.
;******************************************************************************



     LIST      p=16f88         ; Liste des directives du processeur.
     #include <p16F88.inc>     ; Définition des registres spécifiques au CPU.

     errorlevel  -302          ; Retrait du message d'erreur 302.

     __CONFIG    _CONFIG1, _CP_OFF & _CCP1_RB0 & _DEBUG_OFF & _WRT_PROTECT_OFF & _CPD_OFF & _LVP_OFF & _BODEN_ON & _MCLR_ON & _PWRTE_ON & _WDT_OFF & _INTRC_IO

     __CONFIG    _CONFIG2, _IESO_OFF & _FCMEN_OFF



;*********************************** DEFINES **********************************
#define      BANK0   bcf       STATUS,RP0;
#define      BANK1   bsf       STATUS,RP0;
#define      CARRY	       STATUS,C
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
     
;***** VARIABLE DEFINITIONS  **************************************************
;w_temp        EQU     0x71     ; variable used for context saving 
;status_temp   EQU     0x72     ; variable used for context saving
;pclath_temp   EQU     0x73     ; variable used for context saving


;VosVariables  EQU     0x20     ; Mettre ici vos Variables
  CBLOCK  0x20
  
;Variables Fonctions I2C 
;  v1Bit                         ; Variable Bit
;  vOctet                        ; Variable Octets
;  vAckValue			; Valeur du Ack/NoAck envoyé
;  vAddH                         ; Adresse basse
;  vAddB				; Adresse haute
;  vData				; Donnée à envoyer
;  vCompteur			; Utilisée pour les boucles I2C
;  vCompt1ms			; Compteur pour le délai 1ms
;  vCompt5ms			; Compteur pour le délai 5ms
  
;Variables fonctions RS-232
  vReceive			; Utilisée dans les fonctions RS232
  vFlag
  vDonneeRx
  vDonnee0
  vDonnee1
  vDonnee2
  vDonnee3
  vDonnee4
  vDonnee5
  vDonnee6
  vDonnee7
  vNbDonneeRx
  vNbDonneeTx
  
  vCompt1                        
  vCompt2
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
    BANK1
    bsf	    PIE1,RCIE
;    bsf	    PIE1,TXIE
    bsf	    INTCON,PEIE
    bsf	    INTCON,GIE
    BANK0
    movlw   .0
    movwf   vNbDonneeRx
    
Loop
    
TestFlagRx
    btfsc   FLAGRX
    goto    SwitchCaseRx
    goto    TestFlagTx
    
TestFlagTx
    btfsc   PIR1,TXIF
    goto    TestSW1   
    goto    Loop 
    
TestSW1
    btfss   SW1
    goto    Toggle1
    goto    TestSW2
    
Toggle1
    btfss    SW1
    goto     Toggle1
    goto     EnvoyerS
    
EnvoyerS
    movlw   'Z'
    movwf   TXREG
    
TestSW2
    btfss    SW2
    goto     Toggle2
    goto     TestSW3
    
Toggle2
    btfss    SW2
    goto     Toggle2
    goto     EnvoyerPhrase
    
TestSW3
    btfss    SW3
    goto     Toggle3
    goto     Loop
    
Toggle3
    btfss    SW3
    goto     Toggle3
    goto     CLEAR
    
CLEAR
    movlw   .0
    movwf   vDonnee0
    movwf   vDonnee1
    movwf   vDonnee2
    movwf   vDonnee3
    movwf   vDonnee4
    movwf   vDonnee5
    movwf   vDonnee6
    movwf   vDonnee7
    movwf   vDonneeRx
    movwf   vNbDonneeRx
    goto    Loop
    
EnvoyerPhrase
    movfw   vDonnee0
    call    Tx232
    movfw   vDonnee1
    call    Tx232
    movfw   vDonnee2
    call    Tx232
    movfw   vDonnee3
    call    Tx232
    movfw   vDonnee4
    call    Tx232
    movfw   vDonnee5
    call    Tx232
    movfw   vDonnee6
    call    Tx232
    movfw   vDonnee7
    call    Tx232
    goto    Loop
    
SwitchCaseRx
    movfw   vNbDonneeRx
    sublw   .1
    btfss   ZERO
    goto    SWITCH1Rx

    movfw   vDonneeRx        
    movwf   vDonnee0
;    incf    vNbDonneeRx
    
SWITCH1Rx
    movfw   vNbDonneeRx
    sublw   .2
    btfss   ZERO
    goto    SWITCH2Rx
    
    movfw   vDonneeRx        
    movwf   vDonnee1
;    incf    vNbDonneeRx
    
SWITCH2Rx
    movfw   vNbDonneeRx
    sublw   .3
    btfss   ZERO
    goto    SWITCH3Rx
    
    movfw   vDonneeRx        
    movwf   vDonnee2
;    incf    vNbDonneeRx
    
SWITCH3Rx
    movfw   vNbDonneeRx
    sublw   .4
    btfss   ZERO
    goto    SWITCH4Rx
    
    movfw   vDonneeRx        
    movwf   vDonnee3
;    incf    vNbDonneeRx
    
SWITCH4Rx
    movfw   vNbDonneeRx
    sublw   .5
    btfss   ZERO
    goto    SWITCH5Rx
    
    movfw   vDonneeRx        
    movwf   vDonnee4
;    incf    vNbDonneeRx
    
SWITCH5Rx
    movfw   vNbDonneeRx
    sublw   .6
    btfss   ZERO
    goto    SWITCH6Rx
    
    movfw   vDonneeRx        
    movwf   vDonnee5
;    incf    vNbDonneeRx
    
SWITCH6Rx
    movfw   vNbDonneeRx
    sublw   .7
    btfss   ZERO
    goto    SWITCH7Rx
    
    movfw   vDonneeRx        
    movwf   vDonnee6
;    incf    vNbDonneeRx
    
SWITCH7Rx  
    movfw   vNbDonneeRx
    sublw   .8
    btfss   ZERO
    goto    FINSWITCHCASE
    
    movfw   vDonneeRx        
    movwf   vDonnee7
;    incf    vNbDonneeRx
   
Test7Switch
    btfsc   CARRY
    goto    DONNEA0
    goto    FINSWITCHCASE
    
DONNEA0
    movlw   .0
    movwf   vNbDonneeRx
    
FINSWITCHCASE
    goto    TestFlagTx
    
Delai5us
    nop
    nop
    nop
    Return
    
Delai1ms
    Movlw    .200
    Movwf    vCompt1
BoucleDelai
    call     Delai5us
    decfsz   vCompt1
    goto     BoucleDelai
    Return
    
Delai5ms
    Movlw    .5
    Movwf    vCompt2
BoucleDelai2
    call     Delai1ms
    decfsz   vCompt2
    goto     BoucleDelai2
    Return
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
     movlw   b'11100100'       ; Bits en entrées sauf,
     movwf   TRISB             ; RB3 (Led1), RB4 (Led2) en sortie. 
     BANK0                     ; Select Bank0
     return
; fin routine InitPic ---------------------------------------------------------

#include <FonctionsRS-232.asm>
  
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
;    movlw   'a'
;    call    Tx232
     
;TestTx
;    btfsc   PIR1,TXIF
;    goto    TxFlag
;    goto    TestRx
;    
;TxFlag
;    bsf	    FLAGTX
;    bcf	    PIR1,TXIF
;    goto    TestRx
    
TestRx
    btfsc   PIR1,RCIF
    goto    RxFlag
    goto    FinInterrupt 
    
RxFlag
    movfw   RCREG        
    movwf   vDonneeRx
    bcf	    PIR1,RCIF
    incf    vNbDonneeRx
    
FinInterrupt
    retfie                   ; return from interrupt

; fin de la routine Interruption-----------------------------------------------



        END                       ; directive 'end of program'





