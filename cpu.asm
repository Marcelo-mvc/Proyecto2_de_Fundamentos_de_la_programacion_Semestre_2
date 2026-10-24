    section .data

numero_de_celdas_en_los_objetivos db      0
numero_de_impactos_del_barco_atacante db      0

        ;modo experto
celda_de_impacto_minimo db      0
celda_de_impacto_maximo db      0

orientacion     db      0

pila_de_objetivos times celdas db 0
  
    section .text 

reinicio_de_la_CPU:
	mov     byte [numero_de_celdas_en_los_objetivos], 0
	mov     byte [numero_de_impactos_del_barco_atacante], 0
	mov     byte [orientacion], no_tiene_orientacion
	ret

disparo_aleatorio_de_la_CPU:
.regreso:
	mov     eax, celdas
	call    rand_range
	cmp     byte [edi + eax], agua
	jne     .regreso
	ret


eleccion_de_disparo_de_la_CPU:
	cmp     byte [modo_de_juego_de_la_CPU], modo_principiante
	je      .aleatorio
	call    sacar_el_objetivo
	cmp     eax, -1
	jne     .fin
	mov byte [numero_de_impactos_del_barco_atacante], 0
	mov byte [orientacion], no_tiene_orientacion
	cmp byte [modo_de_juego_de_la_CPU], modo_experto
	je .ajedrez
.aleatorio:
	call    disparo_aleatorio_de_la_CPU
	jmp .fin
.ajedrez:
	call disparo_aleatorio_de_la_CPU_modo_experto
.fin:
	ret


registro_resultado_de_la_CPU:
	pushad
	test    edx, edx
	jnz     .impacto
	mov     byte [edi + eax], disparo_al_agua
	jmp     .fin
.impacto:
	mov     byte [edi + eax], disparo_a_barco
	cmp     edx, si_resultado_es_barco_hundido
	je      .hundido
	cmp     byte [modo_de_juego_de_la_CPU], modo_principiante
	je      .fin
	cmp 	byte [modo_de_juego_de_la_CPU], modo_experto
	je	 	.experto
	call    agregar_vecinos
	jmp     .fin
.experto:
	call registro_de_impacto_de_la_CPU_modo_experto
	jmp .fin
.hundido:
	mov     byte [numero_de_celdas_en_los_objetivos], 0
	mov		byte [numero_de_impactos_del_barco_atacante], 0
	mov		byte [orientacion], no_tiene_orientacion
.fin:
	popad
	ret


resolver_disparo:
	push    ebx
	push    ecx
	push    esi
	movzx   ebx, byte [barcos_del_jugador + eax]
	cmp     bl, agua
	jne     .hay_barco
	xor     edx, edx
	jmp     .fin
.hay_barco:
	mov     byte [barcos_del_jugador + eax], '#'
	mov     ecx, celdas
	mov     esi, barcos_del_jugador
.buscar:
	cmp     [esi], bl
	je      .quedan
	inc     esi
	dec     ecx
	jnz     .buscar
	mov     edx, si_resultado_es_barco_hundido
	jmp     .fin
.quedan:
	mov     edx, si_resultado_es_a_barco_tocado
.fin:
	pop     esi
	pop     ecx
	pop     ebx
	ret

agregar_objetivo:
	push    ebx
	cmp     byte [edi + eax], agua
	jne     .fin
	movzx   ebx, byte [numero_de_celdas_en_los_objetivos]
	mov     [pila_de_objetivos + ebx], al
	inc     byte [numero_de_celdas_en_los_objetivos]
.fin:
	pop     ebx
	ret

agregar_vecinos:
	pushad
	mov     ebx, eax
	xor     edx, edx
	mov     ecx, tamano_de_fila
	div     ecx
	mov     esi, eax
.arriba:
	test    esi, esi
	jz      .abajo
	lea     eax, [ebx - tamano_de_fila]
	call    agregar_objetivo
.abajo:
	cmp     esi, tamano_de_fila - 1
	je      .izquierda
	lea     eax, [ebx + tamano_de_fila]
	call    agregar_objetivo
.izquierda:
	test    edx, edx
	jz      .derecha
	lea     eax, [ebx - 1]
	call    agregar_objetivo
.derecha:
	cmp     edx, tamano_de_fila - 1
	je      .fin
	lea     eax, [ebx + 1]
	call    agregar_objetivo
.fin:
	popad
	ret

sacar_el_objetivo:
	push    ebx
.otro:
	movzx   ebx, byte [numero_de_celdas_en_los_objetivos]
	test    ebx, ebx
	jz      .vacia
	dec     ebx
	mov     [numero_de_celdas_en_los_objetivos], bl
	movzx   eax, byte [pila_de_objetivos + ebx]
	cmp     byte [edi + eax], agua
	jne     .otro
	jmp     .fin
.vacia:
	mov     eax, -1
.fin:
	pop     ebx
	ret

;modo experto
disparo_aleatorio_de_la_CPU_modo_experto:
    push ebx
    push ecx
    push edx
    push esi
    mov esi, tamano_de_fila
    mov ecx, 300
.intento:
    mov eax, celdas
    call rand_range
    cmp byte [edi + eax], agua
    jne .otro
    mov ebx, eax
    xor edx, edx
    div esi
    add eax, edx
    test eax, 1
    jnz .otro
    mov eax, ebx
    jmp .fin
.otro:
    dec ecx 
    jnz .intento
    call disparo_aleatorio_de_la_CPU
.fin:
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret


registro_de_impacto_de_la_CPU_modo_experto:
    pushad
    movzx ebx, byte [numero_de_impactos_del_barco_atacante]
    test ebx, ebx
    jnz .siguiente
    mov [celda_de_impacto_minimo], al
    mov [celda_de_impacto_maximo], al
    mov byte [numero_de_impactos_del_barco_atacante], 1
    call agregar_vecinos
    jmp .fin
.siguiente:
    inc byte [numero_de_impactos_del_barco_atacante]
    cmp byte [orientacion], no_tiene_orientacion
    jne .actualizacion
    movzx ebx, byte [celda_de_impacto_minimo]
    mov ecx, eax 
    sub ecx, ebx
    cmp ecx, 1
    je .horizontal
    cmp ecx, -1
    je .horizontal
    mov byte [orientacion], orientacion_vertical
    jmp .actualizacion
.horizontal:
    mov byte [orientacion], orientacion_horizontal
.actualizacion:
    cmp al, [celda_de_impacto_minimo]
    jae .maximo
    mov [celda_de_impacto_minimo], al
.maximo:
    cmp al, [celda_de_impacto_maximo]
    jbe .objetivos
    mov [celda_de_impacto_maximo], al
.objetivos:
    mov byte [numero_de_celdas_en_los_objetivos], 0
	movzx esi, byte [celda_de_impacto_minimo]
	movzx ebx, byte [celda_de_impacto_maximo]
	mov ecx, tamano_de_fila
	cmp byte [orientacion], orientacion_horizontal
	jne .linea_vertical
	mov eax, esi 
	xor edx, edx
	div ecx
	test edx, edx
	jz .derecha
	lea eax, [esi - 1]
	call agregar_objetivo
.derecha:
	mov eax, ebx 
	xor edx, edx
	div ecx 
	cmp edx, tamano_de_fila - 1
	je .fin
	lea eax, [ebx + 1]
	call agregar_objetivo
	jmp .fin
.linea_vertical:
	cmp esi, tamano_de_fila
	jb .abajo
	lea eax, [esi - tamano_de_fila]
	call agregar_objetivo
.abajo:
	cmp ebx, celdas - tamano_de_fila
	jae .fin
	lea eax, [ebx + tamano_de_fila]
	call agregar_objetivo
.fin:
	popad
	ret