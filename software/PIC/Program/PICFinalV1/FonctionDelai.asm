;***************************** InitTimer1 *************************************
;       Nom de la fonction : InitTimer1                   
;       Auteur : Félix Trempblay, Marie-Pier Morin, Alexandre Dionne
;       Date de creation : 02-12-2023                              
;       Description : Fonction d'initialisation du Timer1 
;                                                       
;       Fonctions appelees : Aucune 
;       Paramètres d'entree : Aucun  
;       Paramètres de sortie : Aucun 
;       Variables utilisees : Aucune  
;                                               
;******************************************************************************
InitTimer1
    movlw   0x99	; Setup du timer1
    movwf   TMR1H	; à une fréquence de 
    movlw   0xFE	; 250kHz
    movwf   TMR1L	; 100ms de délai
    movlw   b'00110001' ; 0x9E TH et 0x58 TL théoriquement
    movwf   T1CON
    return
; fin routine InitTimer1 ------------------------------------------------------

;******************************** Delai5us ************************************
;  Nom de la fonction : Delai5us      
;  Auteur : Félix Trempblay, Marie-Pier Morin, Alexandre Dionne   
;  Date de creation : 02-11-2023             
;  Description : Routine de delai de 5 us par plusieur nop
;                Calcul : 1 nop = 1us, 1 call + 1 return = 2us
;                5 * 1us  = 5us
; 
;              
;  Fonctions appelees : Aucune       
;  Paramètres d'entree : Aucun           
;  Paramètres de sortie : Aucun           
;  Variables utilisees : Aucune               
;              
;******************************************************************************
Delai5us
    nop                     ; 3 no operation 
    nop			    ; pour faire un delai
    nop			    ; de 5us, car 1 nop = 1us
    Return		    ; Pareil pour le return et le call
; fin routine Delai5us---------------------------------------------------------
    
;******************************* Delai1ms *************************************
;       Nom de la fonction : Delai1ms                   
;       Auteur : Félix Trempblay, Marie-Pier Morin, Alexandre Dionne
;       Date de creation : 26-10-2023                                
;       Description : Fonction de délai de 1ms par appel de la fonction 5us. 
;                     Calcul : 5us * 200 = 1ms
;
;                                                       
;       Fonctions appelees : Delai5us
;       Paramètres d'entree : Aucun  
;       Paramètres de sortie : Aucun 
;       Variables utilisees : vCompt1ms  
;                                               
;******************************************************************************
Delai1ms
     movlw  .200
     movwf  vCompt1ms
encore1ms
     call   Delai5us
     decfsz vCompt1ms
     goto   encore1ms
     return   
; fin routine Delai1ms --------------------------------------------------------

;******************************* Delai5ms *************************************
;       Nom de la fonction : Delai5ms                   
;       Auteur : Félix Trempblay, Marie-Pier Morin, Alexandre Dionne
;       Date de creation : 26-10-2023                                
;       Description : Fonction de délai de 5ms par appel de la fonction 1ms. 
;                     Calcul : 5 * 1ms = 5ms     
;          
;
;       Fonctions appelees : Delai1ms  
;       Paramètres d'entree : Aucun  
;       Paramètres de sortie : Aucun 
;       Variables utilisees : vCompt5ms  
;                                               
;******************************************************************************
Delai5ms
     movlw  .5
     movwf  vCompt5ms
encore5ms
     call   Delai1ms
     decfsz vCompt5ms
     goto   encore5ms
     return   
; fin routine Delai5ms --------------------------------------------------------