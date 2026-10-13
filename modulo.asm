    BITS 32
    ;constantes
    agua equ '.' ; 46 en ascii
    tamano_de_fila equ 10
    celdas equ 100
    numero_de_barcos equ 5

    ;estas constantes las uso para los modos de la cpu
    modo_principiante equ 1
    modo_intermedio equ 2
    modo_experto equ 3
    disparo_al_agua equ '~'
    disparo_a_barco equ 'X' 
    si_resultado_es_al_agua equ 0
    si_resultado_es_a_barco_tocado equ 1
    si_resultado_es_barco_hundido equ 2
    no_tiene_orientacion equ 0
    orientacion_horizontal equ 1
    orientacion_vertical equ 2

    section .data 
        ;primera parte
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

        ;segunda parte 
        modo_de_juego_de_la_CPU db modo_principiante

        numero_de_celdas_en_los_objetivos db 0
        numero_de_impactos_del_barco_atacante db 0
        
        ;modo experto
        celda_de_impacto_minimo db 0
        celda_de_impacto_maximo db 0

        orientacion db 0

        pila_de_objetivos times celdas db 0

        estado_aleatorio db 0


    section .bss

    section .text

    global main


    main:
        pushad
        call init_rng
        mov edi, disparos_de_CPU_hacia_el_jugador1
        call limpiar_tablero
        mov ebp, celdas
    .disparar:
        call eleccion_de_disparo_de_la_CPU
        xor edx, edx
        call registro_resultado_de_la_CPU
        dec ebp
        jnz .disparar
        mov esi, disparos_de_CPU_hacia_el_jugador1
        call imprimir_tablero
        popad
        xor eax, eax
        ret
    imprimir_tablero:
        pushad
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
        ret 
    
    limpiar_tablero:
        pushad
        cld
        mov al, agua
        mov ecx, celdas
        rep stosb 
        popad 
        ret 

    reinicio_de_la_CPU:
        mov byte [numero_de_celdas_en_los_objetivos], 0
        mov byte [numero_de_impactos_del_barco_atacante], 0
        mov byte [orientacion], no_tiene_orientacion
        ret

    disparo_aleatorio_de_la_CPU:
        .regreso:
            mov eax, celdas
            call rand_range 
            cmp byte [edi + eax], agua
            jne .regreso
            ret

    
    eleccion_de_disparo_de_la_CPU:
       call disparo_aleatorio_de_la_CPU
       ret

    registro_resultado_de_la_CPU:
        pushad
        test edx, edx
        jnz .impacto
        mov byte [edi + eax], disparo_al_agua
        jmp .fin
    .impacto:
        mov byte [edi + eax], disparo_a_barco
    .fin:
        popad
        ret


        ; ===== TEMPORAL: reemplazar por el módulo de la Obs. #6 =====
    init_rng:
        push ebx
        push ecx
        push edx
        rdtsc
        xor eax, edx
        mov ecx, eax
        mov eax, 13
        xor ebx, ebx
        int 0x80
        xor eax, ecx
        imul eax, eax, 0x9E3779B1
        test eax, eax
        jnz .listo
        mov eax, 0x2545F491
    .listo:
        mov [estado_aleatorio], eax
        pop edx
        pop ecx
        pop ebx
        ret

    rand32:
        push ecx
        mov eax, [estado_aleatorio]
        mov ecx, eax
        shl ecx, 13
        xor eax, ecx
        mov ecx, eax
        shr ecx, 17
        xor eax, ecx
        mov ecx, eax
        shl ecx, 5
        xor eax, ecx
        mov [estado_aleatorio], eax
        pop ecx
        ret

    rand_range:
        push ecx
        push edx
        mov ecx, eax
        call rand32
        xor edx, edx
        div ecx
        mov eax, edx
        pop edx
        pop ecx
        ret
    section .note.GNU-stack noalloc noexec nowrite progbits
