    BITS 32

%include "constantes.asm"
%include "datos.asm"
%include "aleatorio.asm"
%include "colocacion_flota.asm"
%include "cpu.asm"

    section .data

aciertos        dd      0
disparos_hechos dd      0

    section .bss 

numbuf          resb    12

    section .text

    global main


main:
	pushad
	call    init_rng
	mov     byte [modo_de_juego_de_la_CPU], modo_intermedio	; <- cambia el modo aquí
	call    reinicio_de_la_CPU
	mov     dword [aciertos], 0
	mov     dword [disparos_hechos], 0
.turno:
	mov     edi, disparos_de_CPU_hacia_el_jugador1
	call    eleccion_de_disparo_de_la_CPU
	call    resolver_disparo
	test    edx, edx
	jz      .sin_acierto
	inc     dword [aciertos]
.sin_acierto:
	call    registro_resultado_de_la_CPU
	inc     dword [disparos_hechos]
	cmp     dword [aciertos], 17
	jb      .turno
	mov     esi, disparos_de_CPU_hacia_el_jugador1
	call    imprimir_tablero
	mov     eax, [disparos_hechos]
	call    print_number
	popad
	xor     eax, eax
	ret

imprimir_tablero:
	pushad
	mov     ebp, tamano_de_fila
.fila:
            ;primer bloque
	mov     eax, 4
	mov     ebx, 1
	mov     ecx, esi
	mov     edx, tamano_de_fila
	int     0x80
            ;segundo bloque
	mov     eax, 4
	mov     ebx, 1
	mov     ecx, salto_de_linea
	mov     edx, 1
	int     0x80

            ;pasa a la siguiente fila
	add     esi, tamano_de_fila
	dec     ebp
	jnz     .fila
	popad
	ret

print_number:
	pushad
	mov     edi, numbuf + 11
	mov     byte [edi], 10
	mov     ebx, 10
.dividir:
	xor     edx, edx
	div     ebx
	add     dl, '0'
	dec     edi
	mov     [edi], dl
	test    eax, eax
	jnz     .dividir
	mov     eax, 4
	mov     ebx, 1
	mov     ecx, edi
	mov     edx, numbuf + 12
	sub     edx, edi
	int     0x80
	popad
	ret

        section .note.GNU-stack noalloc noexec nowrite progbits
