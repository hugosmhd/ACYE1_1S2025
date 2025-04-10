    .data                   // Sección de datos
x10_value: 
    .quad 10                // Asigna el valor 10 a x10_value
x5_value:
    .quad 3                 // Asigna el valor 3 a x5_value

    .text                   // Sección de código
    .global main            // Hacer la etiqueta main accesible globalmente

main:
    // Cargar los valores desde la sección de datos
    ldr x10, =x10_value     // Cargar la dirección de x10_value en x10
    ldr x10, [x10]          // Cargar el valor de x10_value en x10 (10)
    ldr x5, =x5_value       // Cargar la dirección de x5_value en x5
    ldr x5, [x5]            // Cargar el valor de x5_value en x5 (3)

    // Realizar la sustracción
    sub x1, x10, x5         // x1 = x10 - x5 (10 - 3 = 7)

    ret                      // Retornar
