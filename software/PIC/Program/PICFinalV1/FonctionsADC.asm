;******************************* InitADC **************************************
;       Nom de la fonction : InitADC                   
;       Auteur : Félix Trempblay, Marie-Pier Morin, Alexandre Dionne
;       Date de creation : 23-11-28                              
;       Description : Fonction d'initialisation de l'ADC. 
;	              Le bit A0 du PortA est pour etre convertit, de base.
;		      Les bits A0, A1 et A2 sont configurer en entree analogique
;                     
;
;       Fonctions appelees : Deali1ms 
;       Paramètres d'entree : Aucun  
;       Paramètres de sortie : Aucun 
;       Variables utilisees : Aucune  
;                                               
;******************************************************************************
InitADC
     BANK1
     movlw   b'00000011'
     movwf   ANSEL
     movlw   b'00000000'
     movwf   ADCON1
     BANK0
     movlw   b'11000001'
     movwf   ADCON0
     call   Delai1ms
     return 
; fin routine InitADC ---------------------------------------------------------
     
     
;******************************* StartConvADC *********************************
;       Nom de la fonction : StartConvADC                   
;       Auteur : Félix Trempblay, Marie-Pier Morin, Alexandre Dionne
;       Date de creation : 23-11-28                              
;       Description : Fonction qui demarre une converstion ADC
;			
;                                                       
;       Fonctions appelees : Aucune 
;       Paramètres d'entree : Aucun  
;       Paramètres de sortie : Aucun 
;       Variables utilisees : Aucune  
;                                               
;******************************************************************************
StartConvADC
     bsf     ADCON0,GO_DONE
     return 
; fin routine StartConvADC ----------------------------------------------------
     
     
;******************************* LectureADC ***********************************
;       Nom de la fonction : LectureADC                 
;       Auteur : Félix Trempblay, Marie-Pier Morin, Alexandre Dionne
;       Date de creation : 23-11-28                              
;       Description : Fonction qui lit le resultat convertit de l'ADC 
;                     vADCL et vADCH doivent etre declare au debut du programme
;
;                                                       
;       Fonctions appelees : Aucune 
;       Paramètres d'entree : Aucun  
;       Paramètres de sortie : Aucun 
;       Variables utilisees : vADCH, vADCL   
;                                               
;******************************************************************************
LectureADC
     BANK1
     movf    ADRESL,w
     clrf    ADRESL
     BANK0
     movwf   vADCL
     movf    ADRESH,w
     clrf    ADRESH
     movwf   vADCH
     return 
; fin routine  LectureADC ----------------------------------------------------- 
          

     
;******************************* SelectPA0ADC *********************************
;       Nom de la fonction : SelectPA0ADC                   
;       Auteur : Félix Trempblay, Marie-Pier Morin, Alexandre Dionne
;       Date de creation : 23-11-28                              
;       Description : Fonction qui selectionne l'entree A0 du PortA pour etre 
;		      convertit     
;
;                                                       
;       Fonctions appelees : Delai1ms 
;       Paramètres d'entree : Aucun  
;       Paramètres de sortie : Aucun 
;       Variables utilisees : Aucune  
;                                               
;******************************************************************************
SelectPA0ADC
     bcf    ADCON0,CHS0
     bcf    ADCON0,CHS1
     bcf    ADCON0,CHS2
     call   Delai1ms
     return 
; fin routine  SelectPA0ADC ---------------------------------------------------
     

;******************************* SelectPA1ADC *********************************
;       Nom de la fonction : SelectPA1ADC                   
;       Auteur : Félix Trempblay, Marie-Pier Morin, Alexandre Dionne
;       Date de creation : 23-11-28                              
;       Description : Fonction qui selectionne l'entree A1 du PortA pour etre 
;		      convertit     
;
;                                                       
;       Fonctions appelees : Delai1ms 
;       Paramètres d'entree : Aucun  
;       Paramètres de sortie : Aucun 
;       Variables utilisees : Aucune  
;                                               
;******************************************************************************
SelectPA1ADC
     bsf    ADCON0,CHS0
     bcf    ADCON0,CHS1
     bcf    ADCON0,CHS2
     call   Delai1ms
     return 
; fin routine  SelectPA0ADC ---------------------------------------------------
     
;******************************* SelectPA2ADC *********************************
;       Nom de la fonction : SelectPA0ADC                   
;       Auteur : Félix Trempblay, Marie-Pier Morin, Alexandre Dionne
;       Date de creation : 23-11-28                              
;       Description : Fonction qui selectionne l'entree A0 du PortA pour etre 
;		      convertit     
;
;                                                       
;       Fonctions appelees : Delai1ms 
;       Paramètres d'entree : Aucun  
;       Paramètres de sortie : Aucun 
;       Variables utilisees : Aucune  
;                                               
;******************************************************************************
SelectPA2ADC
     bcf    ADCON0,CHS0
     bsf    ADCON0,CHS1
     bcf    ADCON0,CHS2
     call   Delai1ms
     return 
; fin routine  SelectPA0ADC ---------------------------------------------------
     
;******************************* SelectPA3ADC *********************************
;       Nom de la fonction : SelectPA0ADC                   
;       Auteur : Félix Trempblay, Marie-Pier Morin, Alexandre Dionne
;       Date de creation : 23-11-28                              
;       Description : Fonction qui selectionne l'entree A0 du PortA pour etre 
;		      convertit     
;
;                                                       
;       Fonctions appelees : Delai1ms 
;       Paramètres d'entree : Aucun  
;       Paramètres de sortie : Aucun 
;       Variables utilisees : Aucune   
;                                               
;******************************************************************************
SelectPA3ADC
     bsf    ADCON0,CHS0
     bsf    ADCON0,CHS1
     bcf    ADCON0,CHS2
     call   Delai1ms
     return 
; fin routine  SelectPA0ADC ---------------------------------------------------