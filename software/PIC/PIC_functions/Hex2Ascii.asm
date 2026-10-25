;****************************** HexEnASCII ************************************
;       Nom de la fonction : HexEnASCII                  
;       Auteur : Alain Champagne       
;       Date de creation : 23-07-2019                          
;       Modification :               
;       Description : Fonction qui convertie la valeur placée dans W de HEX à
;                     ASCII et retournant le résultat de la conversion dans
;                     les variables vValH et vValL.
;                     Entrée: W. 
;                     Sortie: vValH et vValL.
;
;                   
;  Fonctions appelees : NA       
;  Paramètres d'entree : W      
;  Paramètres de sortie : vValH et vValL.       
;  Variables utilisees : vValA, vValH et vValL.   
;  Equate : NA     
;  #Define : NA     
;              
;******************************************************************************
HexEnASCII
     movwf   vValH             ; Place W dans la variable vValH.
     call    WEnASCII          ; Appel de la sous-routine WEnASCII.
     movwf   vValL             ; Place W dans la variable vValL.
     swapf   vValH,w           ; 
     call    WEnASCII          ;
     movwf   vValH             ;
     return                    ;
WEnASCII                       ;
     andlw   0x0F              ;
     movwf   vValA             ; 
     movlw   0x0A              ;
     subwf   vValA,w           ; 
     SKPC                      ;
     goto    Add37             ;
     addlw   0x07              ;
Add37                          ;
     addlw   0x3A              ;
     return	                   ;
; fin routine HexEnAscii ------------------------------------------------------