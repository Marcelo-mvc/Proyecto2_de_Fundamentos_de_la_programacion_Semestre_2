    section .data

estado_aleatorio dd      0

    section .text
    
            ; ===== TEMPORAL: reemplazar por el módulo de la Obs. #6 =====
init_rng:
	push    ebx
	push    ecx
	push    edx
	rdtsc
	xor     eax, edx
	mov     ecx, eax
	mov     eax, 13
	xor     ebx, ebx
	int     0x80
	xor     eax, ecx
	imul    eax, eax, 0x9E3779B1
	test    eax, eax
	jnz     .listo
	mov     eax, 0x2545F491
.listo:
	mov     [estado_aleatorio], eax
	pop     edx
	pop     ecx
	pop     ebx
	ret

rand32:
	push    ecx
	mov     eax, [estado_aleatorio]
	mov     ecx, eax
	shl     ecx, 13
	xor     eax, ecx
	mov     ecx, eax
	shr     ecx, 17
	xor     eax, ecx
	mov     ecx, eax
	shl     ecx, 5
	xor     eax, ecx
	mov     [estado_aleatorio], eax
	pop     ecx
	ret

rand_range:
	push    ecx
	push    edx
	mov     ecx, eax
	call    rand32
	xor     edx, edx
	div     ecx
	mov     eax, edx
	pop     edx
	pop     ecx
	ret