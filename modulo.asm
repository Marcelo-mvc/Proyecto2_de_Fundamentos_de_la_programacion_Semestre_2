    BITS 32
    ;constantes
    agua equ '.' ; 46 en ascii
    tamano_de_fila equ 10
    celdas equ 100
    numero_de_barcos equ 5
    section .data 
        barcos_del_jugador:
            times celdas db agua 
        barcos_de_la_CPU:
            times celdas db agua
        disparos_de_jugador1_hacia_la_CPU:
            times celdas db agua
        disparos_de_CPU_hacia_el_jugador1:
            times celdas db agua

        tamano_barcos db 5, 4, 3, 3, 2
        salto_de_linea db 10
    section .bss

    section .text

    global main


    main: 
        pushad 
        mov esi, barcos_del_jugador
        mov ebp, tamano_de_fila
    .fila:
        ;primer bloque
        mov eax, 4
        mov ebx, 1
        mov ecx, esi
        mov edx, tamano_de_fila
        int 0x80  
        ;segundo bloque
        mov eax, 4
        mov ebx, 1
        mov ecx, salto_de_linea
        mov edx, 1
        int 0x80

        ;pasa a la siguiente fila
        add esi, tamano_de_fila
        dec ebp 
        jnz .fila
        popad
        xor eax, eax
        ret 
        


    section .note.GNU-stack noalloc noexec nowrite progbits
