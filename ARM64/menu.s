.global _start

.section .data
    menu:   .asciz "Seleccione una opción:\n1. Opción 1\n2. Opción 2\n3. Opción 3\n4. Salir   \n"
    lenMenu = .- menu
    opcion1: .asciz "Has seleccionado la Opción 1\n"
    opcion2: .asciz "Has seleccionado la Opción 2\n"
    opcion3: .asciz "Has seleccionado la Opción 3\n"
    opcion4: .asciz "Has seleccionado la Opción 4\n"
    mensaje_error: .asciz "Opción no válida. Intente de nuevo.\n"

.section .bss
    input:  .skip 4   // Reservamos espacio para la opción seleccionada

.section .text
_start:
    // Imprimir el menú
    mov x0, 1             // File descriptor 1 (stdout)
    ldr x1, =menu         // Dirección del mensaje del menú
    mov x2, 76            // Longitud del mensaje
    mov x8, 64            // syscall número para write
    svc 0

    // Leer la opción seleccionada
    mov x0, 0             // File descriptor 0 (stdin)
    ldr x1, =input        // Dirección de memoria donde almacenar la entrada
    mov x2, 4             // Leer 4 bytes (tamaño suficiente para una opción numérica)
    mov x8, 63            // syscall número para read
    svc 0

    // Convertir la opción a un número entero
    ldr x1, =input
    ldrb w1, [x1]         // Leer un solo byte (opción seleccionada)
    sub w1, w1, #48       // Convertir el carácter ASCII a número (restar 48)
    
    // Comparar la opción
    cmp w1, #1
    beq opcion_1          // Si opción 1, saltar a opcion_1
    cmp w1, #2
    beq opcion_2          // Si opción 2, saltar a opcion_2
    cmp w1, #3
    beq opcion_3          // Si opción 3, saltar a opcion_3
    cmp w1, #4
    beq opcion_4          // Si opción 4, saltar a opcion_4

    // Si la opción no es válida, mostrar mensaje de error
    mov x0, 1             // File descriptor 1 (stdout)
    ldr x1, =mensaje_error // Dirección del mensaje de error
    mov x2, 31            // Longitud del mensaje de error
    mov x8, 64            // syscall número para write
    svc 0
    b _start              // Volver a mostrar el menú

opcion_1:
    mov x0, 1             // File descriptor 1 (stdout)
    ldr x1, =opcion1      // Dirección del mensaje de la opción 1
    mov x2, 30            // Longitud del mensaje
    mov x8, 64            // syscall número para write
    svc 0
    b _start              // Volver a mostrar el menú

opcion_2:
    mov x0, 1             // File descriptor 1 (stdout)
    ldr x1, =opcion2      // Dirección del mensaje de la opción 2
    mov x2, 30            // Longitud del mensaje
    mov x8, 64            // syscall número para write
    svc 0
    b _start              // Volver a mostrar el menú

opcion_3:
    mov x0, 1             // File descriptor 1 (stdout)
    ldr x1, =opcion3      // Dirección del mensaje de la opción 3
    mov x2, 30            // Longitud del mensaje
    mov x8, 64            // syscall número para write
    svc 0
    b _start              // Volver a mostrar el menú

opcion_4:
    mov x0, 0
    mov x8, 93
    svc 0
