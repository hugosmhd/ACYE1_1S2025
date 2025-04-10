.data
val1:   .quad 0x0000000000000002   // 2 en decimal (64 bits)
val2:   .quad 0x0000000000000003   // 3 en decimal (64 bits)
val3:   .word 0xFFFFFFFFFFFFFFFE   // -2 en decimal (64 bits con signo)
val4:   .word 0x0000000000000003   // 3 en decimal (64 bits sin signo)

.text
.global main
main:
    // 1. Ejemplo de multiplicación simple `mul` (64-bit Signed Multiplication)
    ldr x0, =val1                  // Cargar la dirección de val1 en x0
    ldr x0, [x0]                   // Cargar el valor de val1 en x0 (2)

    ldr x1, =val2                  // Cargar la dirección de val2 en x1
    ldr x1, [x1]                   // Cargar el valor de val2 en x1 (3)

    // Multiplicación con signo de 64 bits
    mul x2, x0, x1                 // x2 = x0 * x1 (2 * 3 = 6)

    // 2. Ejemplo de `smull` (Signed Multiplication Long)
    ldr x0, =val3                  // Cargar la dirección de val3 en w0 (32 bits)
    ldr w0, [x0]                   // Cargar el valor de val3 en w0 (-2)

    ldr x1, =val4                  // Cargar la dirección de val4 en x1 (32 bits)
    ldr w1, [x1]                   // Cargar el valor de val4 en w1 (3)

    // Multiplicación larga con signo (smull usa registros de 32 bits)
    smull x2, w0, w1               // x2 = low 32 bits, x3 = high 32 bits (resultado de 64 bits)

    // 3. Ejemplo de `umull` (Unsigned Multiplication Long)
    ldr x0, =val4                  // Cargar la dirección de val4 en w0 (32 bits)
    ldr w0, [x0]                   // Cargar el valor de val4 en w0 (3)

    ldr x1, =val2                  // Cargar la dirección de val2 en w1 (32 bits)
    ldr w1, [x1]                   // Cargar el valor de val2 en w1 (3)

    // Multiplicación larga sin signo (umull usa registros de 32 bits)
    umull x2, w0, w1               // x2 = low 32 bits, x3 = high 32 bits (resultado en 64 bits)

    ret                            // Finalizar la función
