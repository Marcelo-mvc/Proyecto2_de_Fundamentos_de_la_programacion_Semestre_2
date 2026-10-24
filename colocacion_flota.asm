    section .data

    section .bss

    section .text

limpiar_tablero:
	pushad
	cld
	mov     al, agua
	mov     ecx, celdas
	rep     stosb
	popad
	ret

	;esi trae la direccion del tablero
	;edx trae la horientacion, se la copia a esi, tambien es el paso
	;ecx trae el tamaño del barco 
	;ebx se le copia eax que trae la celda

puede_colocar:
	push ecx 
	push edx 
	push esi 
	push ebx

	mov ebx, eax
	mov esi, edx

	xor edx, edx

	push ecx
	mov ecx, tamano_de_fila
	div ecx
	pop ecx

	cmp esi, orientacion_horizontal
	jne .vertical

	add edx, ecx
	cmp edx, tamano_de_fila
	ja .fuera_limites
	mov edx, 1
	jmp .revisar

.vertical:
	add eax, ecx
	cmp eax, tamano_de_fila
	ja .fuera_limites
	mov edx, tamano_de_fila

.revisar:
	cmp byte [edi + ebx], agua
	jne .traslapa
	add ebx, edx
	dec ecx
	jnz .revisar
	xor eax, eax
	jmp .fin


.fuera_limites:
	mov eax, 1
	jmp .fin

.traslapa:
	mov eax, 2
	
.fin:
	pop ebx
	pop esi
	pop edx
	pop ecx
	ret

	; edx = horientacion del barco, tambien es el paso
	; edi = direccion del barco 
	; eax = celda
	; ecx = tamaño del barco

colocar_barco:
	pushad 

	cmp edx, orientacion_horizontal
	jne .vertical
	mov edx, 1
	jmp .poner
	
.vertical:
	mov edx, tamano_de_fila

.poner:
	mov [edi + eax], bl
	add eax, edx
	sub ecx, 1
	cmp ecx, 0
	jne .poner
	popad 
	ret
	










	






    