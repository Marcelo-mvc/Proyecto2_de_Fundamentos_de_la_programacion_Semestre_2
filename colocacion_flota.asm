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



    