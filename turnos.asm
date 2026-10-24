section .data
contadores_jugador dd 0, 0
contadores_cpu     dd 0, 0

section .text
global calcular_porcentaje

calcular_porcentaje:
    push    edx
    imul    eax, eax, 100
    test    ecx, ecx
    jz      .fin
    xor     edx,edx
div ecx
.fin:
    pop     edx
    ret

reiniciar_contadores
    push    edi
    cld
    xor     eax, eax
    mov     edi, contadores_jugador
    mov     ecx, 4
    rep     stosd
    pop     edi
    ret
