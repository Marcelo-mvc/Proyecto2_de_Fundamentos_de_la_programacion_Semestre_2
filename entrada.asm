extern modulo.asm
extern printf
extern scanf

    section .data

    ;mensaje de bienvenida
    bienvenida db "Bienvenido a el mejor Battle ship del mundo!", 10, 
    "los modos de juego son los siguientes:", 10,
    "1. Principiante", 10, "2. Intermedio", 10, "3. Experto", 10, 10
    "A continuación, ingrese el modo de juego que quiere jugar: ", 0

    opcion_format db "%d", 10, 0
    


    section .bss 
    opcion resd 1

    section .text
    global entrada

entrada:
    push ebp
    mov ebp, esp

    push bienvenida
    call printf
    add esp, 4

    push opcion_format
    push opcion
    call scanf
    add esp, 4

    mov esp, ebp
    pop ebp
    ret


