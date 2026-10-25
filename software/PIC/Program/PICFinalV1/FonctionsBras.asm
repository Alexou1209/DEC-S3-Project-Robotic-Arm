;****************************** LirePince *************************************
;       Nom de la fonction : LirePince                 
;       Auteur : Félix Trempblay, Marie-Pier Morin, Alexandre Dionne         
;       Date de creation : 04-12-2023                             
;       Description : Fonctions qui lit la valeur de la cellules de charge  
;                     présente sur la pince du bras robotisé. Mets la valeur  
;                     lu dans vPince
;                       
;                                                       
;       Fonctions appelees : SelectPA3ADC, StartConvADC, LectureADC            
;       Paramètres d'entree : Aucun             
;       Paramètres de sortie : Aucun          
;       Variables utilisees : vPince               
;                                               
;******************************************************************************
LirePince 
    call    SelectPA3ADC
    call    StartConvADC
AttenteADCP
    btfss   PIR1,ADIF
    goto    AttenteADCP
    bcf	    PIR1,ADIF
    call    LectureADC
    movfw   vADCH
    movwf   vPince
    return
; fin routine LirePince -------------------------------------------------------

;****************************** LirePaveXY ************************************
;       Nom de la fonction : LirePaveXY                 
;       Auteur : Félix Trempblay, Marie-Pier Morin, Alexandre Dionne         
;       Date de creation : 04-12-2023                             
;       Description : Fonctions qui lit la valeur du pave tactile en X et en Y.  
;                     Mets la valeur lu dans vPince.   
;                                            
;                                                       
;       Fonctions appelees : Delai1ms, SelectPA0ADC, SelectPA1ADC,  
;			     StartConvADC, LectureADC          
;       Paramètres d'entree : Aucun             
;       Paramètres de sortie : Aucun          
;       Variables utilisees : vPaveX, vPaveY                
;                                               
;******************************************************************************
LirePaveXY
    BANK1
    movlw   b'10111110'       ; PortA en entree sauf A0 et A6
    movwf   TRISA                   
    BANK0
    call    Delai1ms
    bsf	    PORTA,6
    bcf	    PORTA,0
    call    SelectPA1ADC
    call    StartConvADC
AttenteADCY
    btfss   PIR1,ADIF
    goto    AttenteADCY
    bcf	    PIR1,ADIF
    call    LectureADC
    movfw   vADCH
    movwf   vPaveX
    
    BANK1
    movlw   b'01111101'       ; PortA en entree sauf A1 et A7
    movwf   TRISA                   
    BANK0
    call    Delai1ms
    bsf	    PORTA,7
    bcf	    PORTA,1
    call    SelectPA0ADC
    call    StartConvADC
AttenteADCX
    btfss   PIR1,ADIF
    goto    AttenteADCX
    bcf	    PIR1,ADIF
    call    LectureADC
    movfw   vADCH
    movwf   vPaveY
    
    return
; fin routine LirePaveXY ------------------------------------------------------
    
;****************************** LireBalance ***********************************
;       Nom de la fonction : LireBalance                 
;       Auteur : Félix Trempblay, Marie-Pier Morin, Alexandre Dionne         
;       Date de creation : 04-12-2023                             
;       Description : Fonctions qui lit la valeur de la balance. Mets la valeur  
;                     lu dans vBalance.                   
;                       
;                                                       
;       Fonctions appelees : SelectPA2ADC, StartConvADC, LectureADC          
;       Paramètres d'entree : Aucun             
;       Paramètres de sortie : Aucun           
;       Variables utilisees : vBalance                
;                                               
;******************************************************************************
LireBalance  
    call    SelectPA2ADC
    call    StartConvADC
AttenteADCB
    btfss   PIR1,ADIF
    goto    AttenteADCB
    bcf	    PIR1,ADIF
    call    LectureADC
    movfw   vADCH
    movwf   vBalance
    return
; fin routine LireBalance -----------------------------------------------------

;*************************** BougerMoteurs ************************************
;       Nom de la fonction : BougerMoteurs                 
;       Auteur : Félix Trempblay, Marie-Pier Morin, Alexandre Dionne         
;       Date de creation : 04-12-2023                             
;       Description : Fonctions qui déplace les moteurs du bras robotisés en   
;                     fonction de la valeurs des variables vMoteur(0-4)                       
;                         
;
;       Fonctions appelees : SetPWMPCA9685          
;       Paramètres d'entree : vMoteur0, vMoteur1, vMoteur2, vMoteur3, vMoteur4             
;       Paramètres de sortie : Aucun           
;       Variables utilisees : Aucune                
;                                               
;******************************************************************************
BougerMoteurs
    bcf	    FLAGTRAMEOK
    movlw   .0
    movwf   vMoteurPCA
    movfw   vMoteur0
    movwf   vPWM
    call    SetPWMPCA9685
    movlw   .1
    movwf   vMoteurPCA
    movfw   vMoteur1
    movwf   vPWM
    call    SetPWMPCA9685
    movlw   .2
    movwf   vMoteurPCA
    movfw   vMoteur2
    movwf   vPWM
    call    SetPWMPCA9685
    movlw   .3
    movwf   vMoteurPCA
    movfw   vMoteur3
    movwf   vPWM
    call    SetPWMPCA9685
    movlw   .4
    movwf   vMoteurPCA
    movfw   vMoteur4
    movwf   vPWM
    call    SetPWMPCA9685
    return
; fin routine BougerMoteurs ---------------------------------------------------
    
;************************** TraiterCaractere **********************************
;       Nom de la fonction : TraiterCaractere                 
;       Auteur : Félix Trempblay, Marie-Pier Morin, Alexandre Dionne         
;       Date de creation : 04-12-2023                             
;       Description : Traite les caractères reçu par communication RS-232.  
;                     Vérifie si la trame est valide lorsque tous les   
;                     caractères sont reçus.  
;                       
;                                                       
;       Fonctions appelees : Aucune          
;       Paramètres d'entree : vOctet(0-7)              
;       Paramètres de sortie : Aucun           
;       Variables utilisees : vOctetG, vOctetO, vMoteur0, vMoteur1, vMoteur2                 
;                             vMoteur3, vMoteur4, vCheckSum
;
;******************************************************************************
TraiterCaractere
    movfw   vIndiceOUT	  
    sublw   0x20
    btfss   ZERO
    goto    SWITCH1Rx

    movfw   vOctet0 
    sublw   'G'
    btfss   ZERO
    goto    BADCOM
    movfw   vOctet0
    movwf   vOctetG
    incf    vIndiceOUT
    goto    FINSWITCHCASE
    
SWITCH1Rx
    movfw   vIndiceOUT
    sublw   0x21
    btfss   ZERO
    goto    SWITCH2Rx
    
    movfw   vOctet1 
    sublw   'O'
    btfss   ZERO
    goto    BADCOM
    movfw   vOctet1        
    movwf   vOctetO
    incf    vIndiceOUT
    goto    FINSWITCHCASE
    
SWITCH2Rx
    movfw   vIndiceOUT  
    sublw   0x22
    btfss   ZERO
    goto    SWITCH3Rx
    
    movfw   vOctet2        
    movwf   vMoteur0
    incf    vIndiceOUT
    goto    FINSWITCHCASE
    
SWITCH3Rx
    movfw   vIndiceOUT
    sublw   0x23
    btfss   ZERO
    goto    SWITCH4Rx
    
    movfw   vOctet3        
    movwf   vMoteur1
    incf    vIndiceOUT
    goto    FINSWITCHCASE
    
SWITCH4Rx
    movfw   vIndiceOUT
    sublw   0x24
    btfss   ZERO
    goto    SWITCH5Rx
    
    movfw   vOctet4        
    movwf   vMoteur2
    incf    vIndiceOUT
    goto    FINSWITCHCASE
    
SWITCH5Rx
    movfw   vIndiceOUT
    sublw   0x25
    btfss   ZERO
    goto    SWITCH6Rx
    
    movfw   vOctet5        
    movwf   vMoteur3
    incf    vIndiceOUT
    goto    FINSWITCHCASE
    
SWITCH6Rx
    movfw   vIndiceOUT
    sublw   0x26
    btfss   ZERO
    goto    SWITCH7Rx
    
    movfw   vOctet6        
    movwf   vMoteur4
    incf    vIndiceOUT
    goto    FINSWITCHCASE
    
SWITCH7Rx  
    movfw   vIndiceOUT
    sublw   0x27
    btfss   ZERO
    goto    FINSWITCHCASE
          
    movfw   vOctet0
    addwf   vOctet1,W
    addwf   vOctet2,W
    addwf   vOctet3,W
    addwf   vOctet4,W
    addwf   vOctet5,W
    addwf   vOctet6,W
    subwf   vOctet7,W
    btfss   ZERO 
    goto    BADCOM
    movfw   vOctet7
    movwf   vCheckSum
    movlw   0x20
    movwf   vIndiceOUT
    bsf	    FLAGTRAMEOK
    goto    FINSWITCHCASE
    
BADCOM
    movlw   0x20
    movwf   vIndiceOUT
    movwf   vIndiceIN
    
FINSWITCHCASE
    return
; fin routine TraiterCaractere ------------------------------------------------
    
;************************* EnvoyerTrameDallas *********************************
;       Nom de la fonction : EnvoyerTrameDallas                 
;       Auteur : Félix Trempblay, Marie-Pier Morin, Alexandre Dionne         
;       Date de creation : 04-12-2023                             
;       Description : Envoie la trame à la carte Dallas par communication  
;                     RS-232  
;                               
;                                                       
;       Fonctions appelees : LirePaveXY, LireBalance, LirePince, Tx232        
;       Paramètres d'entree : Aucun             
;       Paramètres de sortie : Aucun          
;       Variables utilisees : vPaveX, vPaveY, vPince, vBalance, vCheckSum                
;                                               
;******************************************************************************
EnvoyerTrameDallas
    bcf     FLAG100MS
    call    LirePaveXY
    call    LireBalance
    call    LirePince
    
    bcf	    FLAG100MS
    movlw   'G'
    addlw   'O'
    addwf   vPaveX,W
    addwf   vPaveY,W
    addwf   vPince,W
    addwf   vBalance,W
    movwf   vCheckSum
    movlw   'G'
    call    Tx232
    movlw   'O'
    call    Tx232
    movfw   vPaveX
    call    Tx232
    movfw   vPaveY
    call    Tx232
    movfw   vPince
    call    Tx232
    movfw   vBalance
    call    Tx232
    movlw   0x00
    call    Tx232
    movfw   vCheckSum
    call    Tx232
    return
; fin routine EnvoyerTrameDallas ----------------------------------------------