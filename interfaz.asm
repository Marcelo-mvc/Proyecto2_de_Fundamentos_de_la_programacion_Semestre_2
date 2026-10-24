
BITS 32

extern printf

%define RESET    27, "[0m"
%define AZUL     27, "[96m"
%define ROJO     27, "[91m"
%define VERDE    27, "[92m"
%define AMARILLO 27, "[93m"
%define MAGENTA  27, "[95m"
%define BLANCO   27, "[97m"
%define GRIS     27, "[90m"

%macro PRINT 1
    push dword %1
    call printf
    add esp, 4
%endmacro

; Imprime una fila de los cuatro paneles.
; Los textos se rellenan hasta el ancho indicado.
%macro ROW 4
    push dword %4
    push dword %3
    push dword %2
    push dword %1
    push dword formato_fila
    call printf
    add esp, 20
%endmacro

section .data

    limpiar db 27, "[2J", 27, "[H", 0
    color_reset db 27, "[0m", 0
    color_gris  db 27, "[90m", 0

    titulo db AZUL
           db "                         ===========================", 10
           db "                         [ B A T A L L A   N A V A L ]", 10
           db "                         ===========================", RESET, 10, 10, 0

    ; Anchos interiores: flota 20, tableros 44, leyenda 20.
    formato_fila:
        db AZUL, "| ", "%-20.20s", AZUL, " | "
        db AZUL, "| ", GRIS, "%-44.44s", AZUL, " | "
        db ROJO, "| ", GRIS, "%-44.44s", ROJO, " | "
        db GRIS, "| ", "%-20.20s", GRIS, " |"
        db RESET, 10, 0

    borde:
        db AZUL, "+----------------------+ "
        db AZUL, "+----------------------------------------------+ "
        db ROJO, "+----------------------------------------------+ "
        db GRIS, "+----------------------+", RESET, 10, 0

    separador:
        db AZUL, "|----------------------| "
        db AZUL, "|----------------------------------------------| "
        db ROJO, "|----------------------------------------------| "
        db GRIS, "|----------------------|", RESET, 10, 0

    vacio db 0

    titulo_flota db "FLOTA (5 barcos)", 0
    titulo_jugador db "TU TABLERO", 0
    titulo_cpu db "TABLERO ENEMIGO (CPU)", 0
    titulo_leyenda db "LEYENDA", 0

    columnas db "     A   B   C   D   E   F   G   H   I   J", 0

    grid db "   +---+---+---+---+---+---+---+---+---+---+", 0

    j1  db " 1 | . | . | . | . | . | . | . | . | . | . |", 0
    j2  db " 2 | . | . | . | . | . | . | . | . | . | . |", 0
    j3  db " 3 | . | . | . | . | . | . | . | . | . | . |", 0
    j4  db " 4 | . | . | . | . | . | . | . | . | . | . |", 0
    j5  db " 5 | . | . | . | . | . | . | . | . | . | . |", 0
    j6  db " 6 | . | . | . | . | . | . | . | . | . | . |", 0
    j7  db " 7 | . | . | . | . | . | . | . | . | . | . |", 0
    j8  db " 8 | . | . | . | . | . | . | . | . | . | . |", 0
    j9  db " 9 | . | . | . | . | . | . | . | . | . | . |", 0
    j10 db "10 | . | . | . | . | . | . | . | . | . | . |", 0

    e1  db " 1 | . | . | . | . | . | . | . | . | . | . |", 0
    e2  db " 2 | . | . | . | . | . | . | . | . | . | . |", 0
    e3  db " 3 | . | . | . | . | . | . | . | . | . | . |", 0
    e4  db " 4 | . | . | . | . | . | . | . | . | . | . |", 0
    e5  db " 5 | . | . | . | . | . | . | . | . | . | . |", 0
    e6  db " 6 | . | . | . | . | . | . | . | . | . | . |", 0
    e7  db " 7 | . | . | . | . | . | . | . | . | . | . |", 0
    e8  db " 8 | . | . | . | . | . | . | . | . | . | . |", 0
    e9  db " 9 | . | . | . | . | . | . | . | . | . | . |", 0
    e10 db "10 | . | . | . | . | . | . | . | . | . | . |", 0

    porta_nombre db "Portaaviones (5)", 0
    porta_color db ROJO, "[ ][ ][ ][ ][ ]", RESET, "          ", 0

    acor_nombre db "Acorazado (4)", 0
    acor_color db AZUL, "[ ][ ][ ][ ]", RESET, "            ", 0

    crucero_nombre db "Crucero (3)", 0
    crucero_color db VERDE, "[ ][ ][ ]", RESET, "              ", 0

    sub_nombre db "Submarino (3)", 0
    sub_color db AMARILLO, "[ ][ ][ ]", RESET, "              ", 0

    dest_nombre db "Destructor (2)", 0
    dest_color db MAGENTA, "[ ][ ]", RESET, "              ", 0

    leyenda1 db ". Agua sin disparo", 0
    leyenda2 db "O Disparo al agua", 0
    leyenda3 db "X Barco tocado", 0
    leyenda4 db "* Barco hundido", 0

    turno_titulo db "TURNO", 0
    turno_texto db "Tu turno", 0
    coord_titulo db "INGRESA UNA", 0
    coord_subtitulo db "COORDENADA", 0
    coord_ejemplo db "Ejemplo: A5, J10", 0

    entrada_superior:
        db AZUL, "+----------------------------------------------------------------------------------------------------------------+", RESET, 10, 0

    entrada_texto:
        db AZUL, "| ", BLANCO, "Coordenada > ", RESET, 0

    entrada_inferior:
        db AZUL, "|                                                                                                               |", RESET, 10, 0

    entrada_cierre:
        db AZUL, "+----------------------------------------------------------------------------------------------------------------+", RESET, 10, 0

section .text
global mostrar_interfaz

mostrar_interfaz:
    push ebp
    mov ebp, esp
    push ebx
    push esi
    push edi

    PRINT limpiar
    PRINT titulo
    PRINT borde

    ; Encabezados de los cuatro paneles.
    ROW titulo_flota, titulo_jugador, titulo_cpu, titulo_leyenda
    PRINT separador

    ; Letras de las columnas, centradas sobre los tableros.
    ROW vacio, columnas, columnas, vacio
    PRINT color_gris

    ; Primera línea de las cuadrículas.
    ROW vacio, grid, grid, vacio

    ; Filas 1 a 10: cada fila se imprime completa.
    ROW porta_nombre, j1, e1, turno_titulo
    ROW porta_color, grid, grid, turno_texto

    ROW acor_nombre, j2, e2, leyenda1
    ROW acor_color, grid, grid, leyenda2

    ROW crucero_nombre, j3, e3, leyenda3
    ROW crucero_color, grid, grid, leyenda4

    ROW sub_nombre, j4, e4, coord_titulo
    ROW sub_color, grid, grid, coord_subtitulo

    ROW dest_nombre, j5, e5, coord_ejemplo
    ROW dest_color, grid, grid, vacio

    ROW vacio, j6, e6, vacio
    ROW vacio, grid, grid, vacio

    ROW vacio, j7, e7, vacio
    ROW vacio, grid, grid, vacio

    ROW vacio, j8, e8, vacio
    ROW vacio, grid, grid, vacio

    ROW vacio, j9, e9, vacio
    ROW vacio, grid, grid, vacio

    ROW vacio, j10, e10, vacio
    ROW vacio, grid, grid, vacio

    PRINT color_reset
    PRINT borde

    ; Cuadro inferior de coordenadas cerrado.
    PRINT entrada_superior
    PRINT entrada_texto
    PRINT entrada_inferior
    PRINT entrada_cierre

    pop edi
    pop esi
    pop ebx
    mov esp, ebp
    pop ebp
    ret

section .note.GNU-stack noalloc noexec nowrite progbits
