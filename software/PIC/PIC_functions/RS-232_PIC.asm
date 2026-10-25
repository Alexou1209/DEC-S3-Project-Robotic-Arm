
;******************************************************************************
; Ne pas oublier:  Appeler InitRS232 dans la fonction InitPic
;******************************************************************************


;------------------------------------RS 232------------------------------------
;*********************************InitRS232************************************
;	Nom de la fonction : InitRS232			
;	Auteur : Pierre Chouinard		
;       Date de création : 10-10-2009	
;       Date de modification : 21-07-2018	A.C. 					      
;	Description : 	Routine d'initialisation du port de communication série.
;                   RS232 sur le PIC16F88 à 19200 bd (RX=RB2 et TX=RB5)
;							
;	Fonctions appelées : 	Aucune.		
;	Paramètres d'entrée : 	Aucune.		
;	Paramètres de sortie : 	Aucun.		
;	Variables utilisées : 	Aucune.
;	Equate : 	            Aucun.	
;	#Define :               BANK0, BANK1.  
;              
;							
;******************************************************************************
InitRS232
    movlw   b'10010000';     Set reception sur port serie SPEN=CREN = 1
    movwf   RCSTA;       
    BANK1;       
    movlw   b'00100100';     Set la transmission sur le port serie
    movwf   TXSTA;       
    movlw   .25;             Set la vitesse a 19200 bds
    movwf   SPBRG;       
    BANK0;      
    return;             
;fin routine InitRS232---------------------------------------------------------

;*************************************Rx232************************************
;	Nom de la fonction : Rx232			
;	Auteur : Pierre Chouinard		
;       Date de création : 10-10-2009	
;       Date de modification : 21-07-2018	A.C. 					      
;	Description : 	Routine de réception de la communication série RS-232.
;                   RS232 sur le PIC16F88 à 19200 bd (RX=RB2 et TX=RB5)
;							
;	Fonctions appelées : 	Aucune.		
;	Paramètres d'entrée : 	Aucune.		
;	Paramètres de sortie : 	vReceive.		
;	Variables utilisées : 	Aucune.
;	Equate : 	            Aucun.	
;	#Define :               Aucun. 
; 						
;******************************************************************************
Rx232;
    Btfss   PIR1,RCIF;       Attend de recevoir quelque chose sur 
    goto    Rx232;           le port serie.
Rx232Go;                     Si recu sur le port serie
    movfw   RCREG;        
    movwf   vReceive;        Met le caractère reçu dans vReceive
    return;
;fin routine Rx232-------------------------------------------------------------


;*************************************Tx232************************************
;	Nom de la fonction : Tx232			
;	Auteur : Pierre Chouinard		
;       Date de création : 10-10-2009	
;       Date de modification : 21-07-2018	A.C. 					      
;	Description : 	Routine de transmission de la communication série RS-232.
;                   RS232 sur le PIC16F88 à 19200 bd (RX=RB2 et TX=RB5)
;							
;	Fonctions appelées : 	Aucune.		
;	Paramètres d'entrée : 	Aucune.		
;	Paramètres de sortie :  Aucun.		
;	Variables utilisées : 	Aucune.
;	Equate :                Aucun.	
;	#Define :               Aucun. 
;
;******************************************************************************
Tx232
    btfss   PIR1,TXIF;       Attend que la transmission du caractere 
    goto    Tx232;           precedant soit terminer   
    movwf   TXREG;           Transmet le caractere
    return;       
;fin routine Tx232-------------------------------------------------------------