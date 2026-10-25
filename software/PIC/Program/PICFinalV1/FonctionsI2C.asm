;********************************** SDA SCL ***********************************
;
; Gestion de SDA et SCL pour ne jamais mettre de vrai 1 sur le bus. C'est les 
; pull-up sur SDA et SCL qui s'en charge.
;
; Pour mettre SDA ou SCL à 1 on met le bit en entree.
;
;******************************************************************************
SDA0     
     bcf     SDA               ; On s'assure que bit du latch est a 0.
     BANK1
     bcf     TRISB,1           ; SDA en output met bit a 0.
     BANK0
     return
; fin routine SDA0 ------------------------------------------------------------

;******************************************************************************      
SDA1 
     BANK1
     bsf     TRISB,1           ; SDA input (pull-up met a 1 ).
     BANK0
     return  
; fin routine SDA1 ------------------------------------------------------------

;******************************************************************************
SCL0 
     bcf     SCL               ; On s'assure que le bit du latch est a 0.
     BANK1
     bcf     TRISB,0           ; SCL en output met bit a 0.
     BANK0
     return
; fin routine SCL0 ------------------------------------------------------------

;******************************************************************************         
SCL1 
     BANK1
     bsf     TRISB,0           ; SCL input (pull-up met a 1 ).
     BANK0
     return 
; fin routine SCL1 ------------------------------------------------------------  

;****************************** StartBitI2C ***********************************
;       Nom de la fonction : StartBitI2C                       
;       Auteur : Félix Trempblay, Marie-Pier Morin, Alexandre Dionne                
;       Date de creation : 02-11-2023                                
;       Description :   Routine d'initiation d'une communication serie I2C. 
;                       Doit être appelee à chaque debut d'operation.
;                       Le passage de 1 à 0 sur la ligne SDA durant
;                       un niveau 1 sur la ligne SCL initie un START BIT.
;
;                                                       
;       Fonctions appelees : SDA0/1 et SCL0/1           
;       Paramètres d'entree : Aucun            
;       Paramètres de sortie : Aucun            
;       Variables utilisees : Aucune                  
;                                               
;******************************************************************************
StartBitI2C
    call    SDA1
    call    SCL1
    call    SDA0
    call    SCL0
    return
; fin routine StartBitI2C------------------------------------------------------

;******************************* StopBitI2C ***********************************
;       Nom de la fonction : StopBitI2C                 
;       Auteur : Félix Trempblay, Marie-Pier Morin, Alexandre Dionne         
;       Date de creation : 02-11-2023                             
;       Description :   Routine de clôture d'une communication serie I2C.
;                       Doit être appelee à la fin de toutes operations.
;                       Passage de 0 à 1 sur la ligne SDA durant
;                       un niveau 1 sur la ligne SCL initie un STOP BIT.
;                                       
;
;       Fonctions appelees : SDA0/1 et SCL0/1          
;       Paramètres d'entree : Aucun             
;       Paramètres de sortie : Aucun           
;       Variables utilisees : Aucune             
;                                               
;******************************************************************************
StopBitI2C
    call    SDA0
    call    SCL1
    call    SDA1
    call    SCL0
    return    
; fin routine StopBitI2C-------------------------------------------------------          
      
;******************************* Lire1BitI2C **********************************
;       Nom de la fonction : Lire1BitI2C                        
;       Auteur : Félix Trempblay, Marie-Pier Morin, Alexandre Dionne           
;       Date de creation : 02-11-2023                          
;       Description : Routine de reception d'un bit de communication I2C.
;                     La routine prend le bit de la ligne SDA après avoir 
;                     active la ligne SCL. Le bit de donnee est place 
;                     temporairement dans la variable v1Bit et sera  
;                     reutilise dans la routine de traitement d'octets.
;                     
;
;       Fonctions appelees : SCL1, SCL0, SDA1, SDA0, Delai5us       
;       Paramètres d'entree : Aucun             
;       Paramètres de sortie : Aucun              
;       Variables utilisees : v1Bit          
;                                               
;******************************************************************************
Lire1BitI2C
    call    SCL0
    call    SDA1
    call    SCL1
    call    Delai5us
    btfss   SDA
    goto    Lu0
    goto    Lu1
Lu1
    bsf     BITSDA
    goto    FinLire1Bit
Lu0
    bcf	    BITSDA
FinLire1Bit
    call    SCL0
    return
; fin routine Lire1BitI2C------------------------------------------------------

;****************************** Ecrire1BitI2C *********************************
;       Nom de la fonction : Ecrire1BitI2C                      
;       Auteur : Félix Trempblay, Marie-Pier Morin, Alexandre Dionne                  
;       Date de creation : 02-11-2023                         
;       Description : Routine d'emission d'un bit de communication I2C.
;                     La routine utilise le bit 0 de la variable v1Bit 
;                     pour ajuster le niveau de la ligne SDA.  
;                     Les lignes SDA et SCL sont activee à tour de rôle pour 
;                     communiquer l'information du maître à l'esclave.
;                        
;
;       Fonctions appelees : SCL1, SCL0, SDA1, SDA0, Delai5us          
;       Paramètres d'entree : Aucun                 
;       Paramètres de sortie : Aucun          
;       Variables utilisees : v1Bit                
;                                               
;******************************************************************************
Ecrire1BitI2C
    call    SCL0
    call    Delai5us
    btfsc   BITSDA
    goto    Ecrit1 
    goto    Ecrit0
Ecrit0
    call    SDA0
    goto    FinEcrire1Bit    
Ecrit1
    call    SDA1
FinEcrire1Bit
    call    SCL1
    call    Delai5us
    call    SCL0
    return 
; fin routine Ecrire1BitI2C----------------------------------------------------

;***************************** Lire8BitsI2C ***********************************
;       Nom de la fonction : Lire8BitsI2C                      
;       Auteur : Félix Trempblay, Marie-Pier Morin, Alexandre Dionne         
;       Date de creation : 02-11-2023                            
;       Description : Routine de reception de 8 bits de donnee 
;                     provenant du dispositif I2C.
;                     La donnee lue est memorisee dans la variable vOctet.
;                     Ecrit ensuite un ACK ou un NOACK
;
;
;       Fonctions appelees : Lire1BitI2C, Ecrire1BitI2C           
;       Paramètres d'entree : Aucun          
;       Paramètres de sortie : Aucun              
;       Variables utilisees : vCompteur, vOctet, v1Bit, vAckValue               
;                                               
;******************************************************************************
Lire8BitsI2C
    movlw   .8
    movwf   vCompteur
Lire8Bits
    rlf	    vOctet
    bcf	    CARRY
    call    Lire1BitI2C
    btfsc   v1Bit, 0
    goto    IfValBit1
    goto    IfValBit0
    
IfValBit0
    bcf	    vOctet,0
    goto    SLire
    
IfValBit1
    bsf	    vOctet,0
    
SLire
    decfsz  vCompteur
    goto    Lire8Bits
    btfsc   vAckValue, 0
    goto    NOACK
    goto    ACK
    
NOACK
    bsf	    BITSDA
    goto    FinLire8Bits
ACK
    bcf	    BITSDA
    
FinLire8Bits
    call    Ecrire1BitI2C
    return
; fin routine Lire8BitsI2C-----------------------------------------------------

;**************************  Ecrire8BitsI2C ***********************************
;       Nom de la fonction : Ecrire8BitsI2C
;       Auteur : Félix Trempblay, Marie-Pier Morin, Alexandre Dionne        
;       Date de creation : 02-11-2023                            
;       Description :   Routine d'ecriture d'un octet de donnee vers
;                       le dispositif I2C.
;                       L'octet a transmettre est dans la variable vOctet 
;                       avant l'appel de la fonction.
;                       Lecture d'un bit apres la transmission pour le 
;                       ACK/NOACK 
;
;
;       Fonctions appelees : Ecrire1BitI2C, Lire1BitI2C        
;       Paramètres d'entree : Aucun
;       Paramètres de sortie : Aucun    
;       Variables utilisees : vCompteur, vOctet, v1Bit      
;                                               
;******************************************************************************
Ecrire8BitsI2C
    movlw   .8
    movwf   vCompteur
Envoie8Bits
    btfsc   vOctet,7
    goto    IfBitVal1
    goto    IfBitVal0
    
IfBitVal0
    bcf	    BITSDA
    call    Ecrire1BitI2C
    goto    SEnvoie
    
IfBitVal1
    bsf	    BITSDA
    call    Ecrire1BitI2C
    
SEnvoie
    bcf     CARRY
    rlf     vOctet
    decfsz  vCompteur,F
    goto    Envoie8Bits
    call    Lire1BitI2C 
    return
; fin routine Ecrire8BitsI2C---------------------------------------------------

;***************************** EcrireMemI2C ***********************************
;       Nom de la fonction : EcrireMemI2C                                      
;       Auteur : Félix Trempblay, Marie-Pier Morin, Alexandre Dionne                                         
;       Date de creation : 02-11-2023                                                                 
;       Description :   Routine de transmission d'un octet de donnée          
;                       vers la memoire I2C (24LC32).
;                       Genere les Start et les Stop. 
;                       Avant l'appel de la fonction: 
;                       Mettre l'addresse d'écriture dans vADDL et vADDH
;                       et mettre la donnée à écrire dans vData
;                       Une fois l'ecriture effectuée, un délai de 5ms.
;
;                                                                             
;       Fonctions appelees : StartBitI2C, StopBitI2C, Ecrire8BitsI2C, ,Delai5ms   
;       Paramètres d'entree : Aucun                              
;       Paramètres de sortie : Aucun                                         
;       Variables utilisees : Aucun                                                     
;                                                                             
;******************************************************************************      
EcrireMemI2C
    call    StartBitI2C
    movlw   0xA0
    movwf   vOctet
    call    Ecrire8BitsI2C
    
    movfw   vAddH
    movwf   vOctet
    call    Ecrire8BitsI2C
    
    movfw   vAddB
    movwf   vOctet
    call    Ecrire8BitsI2C
    
    movfw   vData
    movwf   vOctet
    call    Ecrire8BitsI2C
    call    StopBitI2C
    call    Delai5ms
    return
; fin routine EcrireMemI2C-----------------------------------------------------

;****************************** LireMemI2C ************************************
;       Nom de la fonction : LireMemI2C                  
;       Auteur : Félix Trempblay, Marie-Pier Morin, Alexandre Dionne           
;       Date de creation : 02-11-2023                            
;       Description :   Routine de reception d'un octet de donnee 
;                       provenant de la memoire I2C (24LC32).
;                       Genere les Start et les Stop. 
;                       Avant l'appel de la fonction: 
;                       Decrire les parametres d'entrees.
;                       A la sortie de la fonction:
;                       Decrire les parametres de sortie.
;
;                       
;       Fonctions appelees : StartBitI2C, StopBitI2C, Ecrire8BitsI2C,
;                            Lire8BitsI2C             
;       Paramètres d'entree : Aucun                  
;       Paramètres de sortie : Aucun                 
;       Variables utilisees : vOctet, vADDH, vADDL, vAckValue         
;                        
;******************************************************************************
LireMemI2C
    call    StartBitI2C
    movlw   0xA0
    movwf   vOctet
    call    Ecrire8BitsI2C
    
    movfw   vAddH
    movwf   vOctet
    call    Ecrire8BitsI2C
    
    movfw   vAddB
    movwf   vOctet
    call    Ecrire8BitsI2C
    call    StopBitI2C
    
    call    StartBitI2C
    movlw   0xA1
    movwf   vOctet
    call    Ecrire8BitsI2C
    movlw   .1
    movwf   vAckValue
    call    Lire8BitsI2C
    call    StopBitI2C
    return
; fin routine LireMemI2C-------------------------------------------------------