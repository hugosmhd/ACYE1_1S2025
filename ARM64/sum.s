    .data                   // Sección de datos
x10_value: 
    .quad 2                 // Asigna el valor 2 a x10_value
x5_value:
    .quad 3                 // Asigna el valor 3 a x5_value

    .text                   // Sección de código
    .global main            // Hacer la etiqueta main accesible globalmente

main:
    // Cargar los valores desde la sección de datos
    ldr x10, =x10_value     // Cargar la dirección de x10_value en x10
    ldr x10, [x10]          // Cargar el valor de x10_value en x10 (2)
    ldr x5, =x5_value       // Cargar la dirección de x5_value en x5
    ldr x5, [x5]            // Cargar el valor de x5_value en x5 (3)
    // Realizar la suma
    add x1, x10, x5         // x1 = x10 + x5 (2 + 3 = 5)

    ret
    // Finalizar el programa (salir)
    // mov x8, #93             // Número de sistema para exit en Linux (x86_64 es 60, ARM64 es 93)
    // mov x0, #0              // Código de salida 0
    // svc #0                  // Llamada al sistema para salir
