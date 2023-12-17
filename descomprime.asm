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
                    or r2, r0, 7

buc8xM_des:         ld.bu r15, r20, r10
                    cmp  r5, r8, 0
                    bb1 eq, r5, buc_byte
                    st.b r15, r21, r11
                    addu r11, r11, 1
                    addu r10, r10, 1
                    subu r8, r8, 1
                    br buc8xM_des     

buc_byte:           cmp  r5, r11, r29
                    bb1 ht, r5, fin_des

                    cmp r5, r2, 7
                    bb1 eq, r5, pos7

                    cmp r5, r2, 6
                    bb1 eq, r5, pos6

                    cmp r5, r2, 5
                    bb1 eq, r5, pos5

                    cmp r5, r2, 4
                    bb1 eq, r5, pos4

                    cmp r5, r2, 3
                    bb1 eq, r5, pos3

                    cmp r5, r2, 2
                    bb1 eq, r5, pos2

                    cmp r5, r2, 1
                    bb1 eq, r5, pos1

                    ;pos0
                    or r16, r15, 1
                    or r2, r0, 7
                    cmp r5, r16, r15
                    bb1 eq, r5, bit1
                    br bit0  
pos7:               ld.bu r15, r20, r12 ;cargamos en r15 el byte del mapa de bits
                    addu r12, r12, 1
                    or r16, r15, 128
                    subu r2, r2, 1
                    cmp r5, r16, r15
                    bb1 eq, r5, bit1
                    br bit0  
pos6:               or r16, r15, 64
                    cmp r5, r16, r15
                    bb1 eq, r5, bit1
                    br bit0  
pos5:               or r16, r15, 32
                    subu r2, r2, 1
                    cmp r5, r16, r15
                    bb1 eq, r5, bit1
                    br bit0  
pos4:               or r16, r15, 16
                    subu r2, r2, 1
                    cmp r5, r16, r15
                    bb1 eq, r5, bit1
                    br bit0  
pos3:               or r16, r15, 8
                    subu r2, r2, 1
                    cmp r5, r16, r15
                    bb1 eq, r5, bit1
                    br bit0  
pos2:               or r16, r15, 4
                    subu r2, r2, 1
                    cmp r5, r16, r15
                    bb1 eq, r5, bit1
                    br bit0  
pos1:               or r16, r15, 2
                    subu r2, r2, 1
                    cmp r5, r16, r15
                    bb1 eq, r5, bit1
                    br bit0  

bit0:               ld.bu r17, r20, r10 ;guardamos en r17 el siguiente caracter del texto comprimido
                    st.b r17, r21, r11 ;guardamos en le texto descomprimido el caracter
                    addu r11, r11, 1 ;aumentamos punteros para apuntar a los siguientes bytes
                    addu r10, r10, 1
                    br buc_byte         
bit1:               ld.bu r18, r20, r10 ;guardamos en r18 el siguiente byte del texto comprimido
                    addu r10, r10, 1 ;incrementamos el offset para ahora leer el siguiente byte de P
                    ld.bu r19, r20, r10 ;leemos el segundo byte de P
                    mulu r19, r19, 256
                    or r19, r19, r18 ;desplazamos el byte menos significativo para que sea el mas significativo y los juntamos r19 <-- P
                    addu r10, r10, 1
                    ld.bu r18, r20, r10 ; r18 <-- L
                    addu r10, r10, 1
Bucle_copia:        cmp r5, r18, r0 ;verificamos si hemos leido los L elementos
                    bb1 lt, r5, buc_byte

                    ld.bu r17, r21, r19 ;cargo en r17 descp[p] ya que r19 <-- p
                    st.b r17, r21, r11
                    addu r11, r11, 1  ;aumentamos punteros y decrementamos L 
                    addu r19, r19, 1
                    subu r18, r18, 1 

                    br Bucle_copia   

fin_des:                st.b r0, r21, r11 ;guardamos caracter nulo
                    jmp(r1)  
     
