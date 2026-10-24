;constantes del tablero y la flota
agua            equ     '.'						; 46 en ascii
tamano_de_fila  equ     10
celdas          equ     100
numero_de_barcos equ     5

;estas constantes las uso para los modos de la cpu
modo_principiante equ   1
modo_intermedio equ     2
modo_experto    equ     3
disparo_al_agua equ     '~'
disparo_a_barco equ     'X'
si_resultado_es_al_agua equ     0
si_resultado_es_a_barco_tocado equ     1
si_resultado_es_barco_hundido equ     2
no_tiene_orientacion equ     0
orientacion_horizontal equ     1
orientacion_vertical equ     2