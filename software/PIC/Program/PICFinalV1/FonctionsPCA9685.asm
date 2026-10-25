;****************************** ResetPCA9685 **********************************
;       Nom de la fonction : ResetPCA9685                 
;       Auteur : Félix Trempblay, Marie-Pier Morin, Alexandre Dionne         
;       Date de creation : 16-11-2023                             
;       Description : Fonction qui réinitialise la carte PCA9685                          
;                       
;                                                       
;       Fonctions appelees : StartBitI2C, StopBitI2C, Ecrire8BitsI2C          
;       Paramètres d'entree : Aucun              
;       Paramètres de sortie : Aucun          
;       Variables utilisees : vOctet                
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
; fin routine ResetPCA9685 ----------------------------------------------------
    
;***************************** SetFreqPCA9685 *********************************
;       Nom de la fonction : SetFreqPCA9685                 
;       Auteur : Félix Trempblay, Marie-Pier Morin, Alexandre Dionne         
;       Date de creation : 16-11-2023                             
;       Description : Fonction qui détermine la fréquence du PCA9685 à 50Hz 
;                       
;                                                                            
;       Fonctions appelees : StartBitI2C, StopBitI2C, Ecrire8BitsI2C          
;       Paramètres d'entree : Aucun            
;       Paramètres de sortie : Aucun          
;       Variables utilisees : vOctet               
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
    
    movlw   0x79    
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
; fin routine SetFreqPCA9685 --------------------------------------------------
    
;****************************** SetPWMPCA9685 *********************************
;       Nom de la fonction : SetPWMPCA9685                 
;       Auteur : Félix Trempblay, Marie-Pier Morin, Alexandre Dionne         
;       Date de creation : 16-11-2023                             
;       Description : Fonction qui selectionne le moteur et indique la 
;                     position de celui-ci   
;                       
;                                                                            
;       Fonctions appelees : StartBitI2C, StopBitI2C, Ecrire8BitsI2C           
;       Paramètres d'entree : Aucun             
;       Paramètres de sortie : Aucun           
;       Variables utilisees : voctet, vMoteurPCA, vPWM, vPWMH                
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
    clrf    vPWMH
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
; fin routine SetPWMPCA9685 ---------------------------------------------------