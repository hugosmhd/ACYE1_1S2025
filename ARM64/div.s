    .data                   // Sección de datos
x10_value:
    .quad -20                // Asigna el valor 20 a x10_value
x5_value:
    .quad 4                 // Asigna el valor 4 a x5_value

    .text                   // Sección de código
    .global main            // Hacer la etiqueta main accesible globalmente

main:
    // Cargar los valores desde la sección de datos
    ldr x10, =x10_value     // Cargar la dirección de x10_value en x10
    ldr x10, [x10]          // Cargar el valor de x10_value en x10 (20)
    ldr x5, =x5_value       // Cargar la dirección de x5_value en x5
    ldr x5, [x5]            // Cargar el valor de x5_value en x5 (4)

    // Realizar la división con signo (signed division)
    sdiv x1, x10, x5        // x1 = x10 / x5 (20 / 4 = 5)

    // Realizar la división sin signo (unsigned division)
    udiv x2, x10, x5        // x2 = x10 / x5 (unsigned division) (-20 / 4, pero tratado como 2^64 - 20)

    ret
    // Terminar el programa (salir)
    // mov x8, #93             // Número de sistema para exit en Linux (x86_64 es 60, ARM64 es 93)
    // mov x0, #0              // Código de salida 0
    // svc #0                  // Llamada al sistema para salir
