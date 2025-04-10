    .data                   // Sección de datos
x9_value:
    .quad 5                 // Asigna el valor 5 a x9_value

    .text                   // Sección de código
    .global main            // Hacer la etiqueta main accesible globalmente

main:
    // Cargar los valores desde la sección de datos
    ldr x9, =x9_value       // Cargar la dirección de x9_value en x9
    ldr x9, [x9]            // Cargar el valor de x9_value en x9 (5)

    // Realizar la negación
    neg x5, x9              // x5 = -x9 (5 se convierte en -5)
    ret
    // Terminar el programa (salir)
    // mov x8, #93             // Número de sistema para exit en Linux (ARM64 usa 93 para exit)
    // mov x0, #0              // Código de salida 0
    // svc #0                  // Llamada al sistema para salir
