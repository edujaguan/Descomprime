Descomprime:        ld r20, r30, 0 ;guardamos en r20 com (texto comprimido)
                    or r10, r0, r0 ;contador de la posicion en texto comprimido
                    addu r12, r0, 5 ;contador de la posicion en el mapa de bits  --- mantenemos un unico puntero (r20) y los accesos si es al texto los hacemos sumando r10 y si es al mapa de bits sumando r12

                    ld r21, r30, 4 ;guardamos en r21 desc (zona donde guardar textp descomprimido)
                    or r11, r0, r0 ;contador de la posicion en la zona de texto descomprimido

                    addu r9, r0, 8 ;contador de los 8 primeros bytes

                    ld.bu r29,r20 ,0 ;Iniciamos el byte menos significativo de r29 con la longitud de la cadena descomprimida
                    ld.bu r15, r20, 1 ;cargamos en r15 el byte de r20
                    mulu r15, r15, 256 ;desplazamos el byte ,menos significativo para que ahora sea el segundo menos significativo
                    or r29, r29, r15 ;metemos el segundo byte de r15 en el segundo byte menos significativo de r29

                    ld.bu r8, r20, 3;cargamos en r8 el byte menos significativo de la posocion donde comienza el texto comprimido
                    ld.bu r7, r20, 4 ;misma operacion de desplazamiento que arriba
                    mulu r7, r7, 256 
                    or r8, r8, r7

                    or r10, r8, r8 ;r10 ahora apunta a la zona donde comiena el texto comprimido
                    or r2, r0, 7 ;contador de bits de cada byte


buc8xM_des:         ld.bu r15, r20, r10 ;cargamos el byte del texto en r15
                    cmp r5, r9, r0 ;comparamos si hemos copiado ya los 8 primeros bytes
                    bb1 eq, r5, buc_byte ;si ya los hemos copiado salimos del bucle
                    st.b r15, r21, r11 ;guardamos el byte en la zona de texto descomprimido
                    addu r10, r10, 1
                    addu r11, r11, 1
                    subu r9, r9, 1 ;restamos al contador
                    br buc8xM_des

buc_byte:           cmp r5, r11, r29 ;comparamos si hemos reccorido todos los bytes del texto descomprimido
                    bb1 eq, r5, fin_des

                    ;logica de ver que valor tiene cada bit (0 o 1) y hacer lo que corresponda
                    cmp r5, r2, 7
                    bb1 eq, r5, pos7
                    br bit0

                    cmp r5, r2, 6
                    bb1 eq, r5, pos6
                    br bit0

                    cmp r5, r2, 5
                    bb1 eq, r5, pos5
                    br bit0

                    cmp r5, r2, 4
                    bb1 eq, r5, pos4
                    br bit0

                    cmp r5, r2, 3
                    bb1 eq, r5, pos3
                    br bit0

                    cmp r5, r2, 2
                    bb1 eq, r5, pos2
                    br bit0

                    cmp r5, r2, 1
                    bb1 eq, r5, pos1
                    br bit0

                    ;si estamos en la ultima posicion (pos0)----
                    or r16, r15, 1
                    addu r2,r0, 7
                    ld.bu r15, r20, r12 ;cargamos el byte del mapa de bits en r15
                    addu r12, r12, 1 ;apuntamos al siguiente byte
                    cmp r5, r16, r15
                    bb1 eq, r5, bit1
                    ;el bit es 0
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

pos7:               or r16, r15, 128
                    subu r2, r2, 1
                    cmp r5, r16, r15
                    bb1 eq, r5, bit1  
pos6:               or r16, r15, 64
                    subu r2, r2, 1
                    cmp r5, r16, r15
                    bb1 eq, r5, bit1  
pos5:               or r16, r15, 32
                    subu r2, r2, 1
                    cmp r5, r16, r15
                    bb1 eq, r5, bit1  
pos4:               or r16, r15, 16
                    subu r2, r2, 1
                    cmp r5, r16, r15
                    bb1 eq, r5, bit1  
pos3:               or r16, r15, 8
                    subu r2, r2, 1
                    cmp r5, r16, r15
                    bb1 eq, r5, bit1  
pos2:               or r16, r15, 4
                    subu r2, r2, 1
                    cmp r5, r16, r15
                    bb1 eq, r5, bit1  
pos1:               or r16, r15, 2
                    subu r2, r2, 1
                    cmp r5, r16, r15
                    bb1 eq, r5, bit1  


fin_des:            st.b r0, r21, r11 ;almacenar '/0' al final de la cadena descomprimida
                    jmp(r1)
