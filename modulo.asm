BITS 32
;constantes
agua equ '.' ; 46 en ascii
tamano_de_tablero equ 10
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
section .bss

section .text

global main


main:
    xor eax, eax
    ret 

section .note.GNU-stack noalloc noexec nowrite progbits
