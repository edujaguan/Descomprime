Descomprime:        ld r20, r30, 0 ;cargamos en r20 el puntero a com 
                    or r10, r0, r0 ;offset a posicion en com
                    or r12, r0, 5 ;offset mapa de bits

                    ld r21, r30, 4 ;cargamos en r21 el puntero a desc
                    or r11, r0, r0 ;offset en desc

                    ld.bu r29, r20, 0 ;primer byte de la cabecera
                    ld.bu r15, r20, 1 ;segundo byte de la cabecera 
                    mulu r15, r15, 256 ;desplazamos r15
                    or r29, r29, r15 ;r29 <-- priemros 2 bytes de la cabecera


                    ld.bu r13, r20, 3
                    ld.bu r14, r20, 4
                    mulu r14, r14, 256
                    or r10, r13, r14 ;r10 es el offset de la cadena com

                    or r8, r0, 8

buc8xM_des:         ld.bu r15, r20, r10
                    cmp  r5, r8, 0
                    bb1 eq, r5, buc_byte
                    st.b r15, r21, r11
                    addu r11, r11, 1
                    addu r10, r10, 1
                    subu r8, r8, 1
                    br buc8xM_des     

buc_byte:         jmp(r1)  
     
