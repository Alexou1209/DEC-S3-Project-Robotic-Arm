;****************************** ResetPCA9685 ***********************************
;       Nom de la fonction : ResetPCA9685                 
;       Auteur : Alexandre Dionne         
;       Date de creation : 16-11-20223                             
;       Description :   
;                       
;                       
;                       
;                                                       
;       Fonctions appelees :           
;       Paramètres d'entree :              
;       Paramètres de sortie :           
;       Variables utilisees :  
;       Include :    
;       Equate :                   
;       #Define :               
;                                               
;******************************************************************************
ResetPCA9685
    call    StartBitI2C
    
    movlw   0x00
    movwf   vOctet
    call    Ecrire8BitsI2C
    
    movlw   0x06
    movwf   vOctet  
    call    Ecrire8BitsI2C
    
    call    StopBitI2C
    
    return
;***************************** SetFreqPCA9685 **********************************
;       Nom de la fonction : SetFreqPCA9685                 
;       Auteur : Alexandre Dionne         
;       Date de creation : 16-11-20223                             
;       Description :   
;                       
;                       
;                       
;                                                       
;       Fonctions appelees :           
;       Paramètres d'entree :              
;       Paramètres de sortie :           
;       Variables utilisees :  
;       Include :    
;       Equate :                   
;       #Define :               
;                                               
;******************************************************************************
SetFreqPCA9685
    call    StartBitI2C
    
    movlw   0x80    
    movwf   vOctet
    call    Ecrire8BitsI2C
    
    movlw   0x00
    movwf   vOctet  
    call    Ecrire8BitsI2C
    
    movlw   0x10    
    movwf   vOctet
    call    Ecrire8BitsI2C
    
    call    StopBitI2C
    call    StartBitI2C
    
    movlw   0x80    
    movwf   vOctet
    call    Ecrire8BitsI2C
    
    movlw   0xFE    
    movwf   vOctet
    call    Ecrire8BitsI2C
    
    movlw   0x7C    
    movwf   vOctet
    call    Ecrire8BitsI2C
    
    call    StopBitI2C
    call    StartBitI2C
    
    movlw   0x80    
    movwf   vOctet
    call    Ecrire8BitsI2C
    
    movlw   0x00    
    movwf   vOctet
    call    Ecrire8BitsI2C
    
    movlw   0xA0    
    movwf   vOctet
    call    Ecrire8BitsI2C
    
    call   StopBitI2C 
    
    return
;****************************** SetPWMPCA9685 **********************************
;       Nom de la fonction : SetPWMPCA9685                 
;       Auteur : Alexandre Dionne         
;       Date de creation : 16-11-20223                             
;       Description :   
;                       
;                       
;                       
;                                                       
;       Fonctions appelees :           
;       Paramètres d'entree :              
;       Paramètres de sortie :           
;       Variables utilisees :  
;       Include :    
;       Equate :                   
;       #Define :               
;                                               
;******************************************************************************
SetPWMPCA9685
    bcf	    CARRY
    rlf	    vMoteurPCA
    rlf	    vMoteurPCA
    movlw   .6
    addwf   vMoteurPCA
    bcf	    CARRY
    movlw   .205
    addwf   vPWM
    btfss   CARRY
    goto    AddH0
    goto    AddH1
    
AddH1
    bsf	    vPWMH,0
    goto    Communication
    
AddH0
    bcf	    vPWMH,0
    
Communication
    call    StartBitI2C
    
    movlw   0x80    
    movwf   vOctet
    call    Ecrire8BitsI2C
    
    movfw   vMoteurPCA
    movwf   vOctet
    call    Ecrire8BitsI2C
   
    movlw   0x00    
    movwf   vOctet
    call    Ecrire8BitsI2C
    
    movlw   0x00    
    movwf   vOctet
    call    Ecrire8BitsI2C
    
    movfw   vPWM
    movwf   vOctet
    call    Ecrire8BitsI2C
    
    movfw   vPWMH
    movwf   vOctet
    call    Ecrire8BitsI2C
    
    call   StopBitI2C 
    
    return