Descomprime:        ld r20, r30, 0 ;cargamos en r20 el puntero a com 
                    or r10, r0, r0 ;offset a posicion en com
                    or r12, r0, 5 ;offset mapa de bits

                    ld r21, r30, 4 ;cargamos en r21 el puntero a desc
                    or r11, r0, r0 ;offset en desc

                    ld.bu r29, r20, 0 ;primer byte de la cabecera
                    ld.bu r15, r20, 1 ;segundo byte de la cabecera 
                    mulu r15, r15, 256 ;desplazamos r15
                    or r29, r29, r15
                    
buc8xM:         

buc_byte:       
fin:            