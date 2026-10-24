
BITS 32

extern printf

section .data

    azul        db 27, "[96m", 0
    rojo        db 27, "[91m", 0
    verde       db 27, "[92m", 0
    amarillo    db 27, "[93m", 0
    magenta     db 27, "[95m", 0
    blanco      db 27, "[97m", 0
    reset       db 27, "[0m", 0

    titulo db 10
           db "          [ B A T A L L A   N A V A L ]", 10, 10, 0

    encabezados db "       TU TABLERO                         TABLERO ENEMIGO (CPU)", 10
                db "     A B C D E F G H I J               A B C D E F G H I J", 10, 0

    fila1 db " 1   . . . . . . . . . .           1   . . . . . . . . . .", 10, 0
    fila2 db " 2   . . . . . . . . . .           2   . . . . . . . . . .", 10, 0
    fila3 db " 3   . . . . . . . . . .           3   . . . . . . . . . .", 10, 0
    fila4 db " 4   . . . . . . . . . .           4   . . . . . . . . . .", 10, 0
    fila5 db " 5   . . . . . . . . . .           5   . . . . . . . . . .", 10, 0
    fila6 db " 6   . . . . . . . . . .           6   . . . . . . . . . .", 10, 0
    fila7 db " 7   . . . . . . . . . .           7   . . . . . . . . . .", 10, 0
    fila8 db " 8   . . . . . . . . . .           8   . . . . . . . . . .", 10, 0
    fila9 db " 9   . . . . . . . . . .           9   . . . . . . . . . .", 10, 0
    fila10 db "10   . . . . . . . . . .          10   . . . . . . . . . .", 10, 0

    separador db "---------------------------------------------------------------", 10, 0

    flota db "FLOTA (5 barcos)", 10
          db "Portaaviones (5): [R][R][R][R][R]", 10
          db "Acorazado    (4): [A][A][A][A]", 10
          db "Crucero      (3): [C][C][C]", 10
          db "Submarino    (3): [S][S][S]", 10
          db "Destructor   (2): [D][D]", 10, 0

    leyenda db "LEYENDA", 10
            db ". Agua sin disparo", 10
            db "O Disparo al agua", 10
            db "X Barco tocado", 10
            db "* Barco hundido", 10, 0

    turno db 10, "TURNO: Tu turno", 10, 0

    instrucciones db 10, "INGRESA UNA COORDENADA (ejemplo A5 o J10): ", 0

section .text
global mostrar_interfaz

mostrar_interfaz:
    push ebp
    mov ebp, esp

    push azul
    call printf
    add esp, 4

    push titulo
    call printf
    add esp, 4

    push reset
    call printf
    add esp, 4

    push encabezados
    call printf
    add esp, 4

    push fila1
    call printf
    add esp, 4
    push fila2
    call printf
    add esp, 4
    push fila3
    call printf
    add esp, 4
    push fila4
    call printf
    add esp, 4
    push fila5
    call printf
    add esp, 4
    push fila6
    call printf
    add esp, 4
    push fila7
    call printf
    add esp, 4
    push fila8
    call printf
    add esp, 4
    push fila9
    call printf
    add esp, 4
    push fila10
    call printf
    add esp, 4

    push separador
    call printf
    add esp, 4

    push verde
    call printf
    add esp, 4
    push flota
    call printf
    add esp, 4

    push reset
    call printf
    add esp, 4

    push blanco
    call printf
    add esp, 4
    push leyenda
    call printf
    add esp, 4

    push amarillo
    call printf
    add esp, 4
    push turno
    call printf
    add esp, 4

    push instrucciones
    call printf
    add esp, 4

    push reset
    call printf
    add esp, 4

    mov esp, ebp
    pop ebp
    ret

section .note.GNU-stack noalloc noexec nowrite progbits
