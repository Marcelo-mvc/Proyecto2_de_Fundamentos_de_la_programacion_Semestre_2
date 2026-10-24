    BITS 32 

%include "constantes.inc"

global barcos_del_jugador
global barcos_de_la_CPU
global disparos_de_jugador1_hacia_la_CPU
global disparos_de_CPU_hacia_el_jugador1
global tamano_barcos
global salto_de_linea
global modo_de_juego_de_la_CPU

    section .data

barcos_del_jugador:
	times   celdas db agua

barcos_de_la_CPU:
	times   celdas db agua

disparos_de_jugador1_hacia_la_CPU:
	times   celdas db agua

disparos_de_CPU_hacia_el_jugador1:
	times   celdas db agua

tamano_barcos   db      5, 4, 3, 3, 2

salto_de_linea  db      10

modo_de_juego_de_la_CPU db      modo_principiante