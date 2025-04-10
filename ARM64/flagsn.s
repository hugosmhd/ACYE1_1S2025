    .data
var1:   .byte 0b00110010 // 50
    .align
var2:   .byte 0b11000000  // -64
    .align

    .text
    .global main
main:
    // nop                // Instrucción "no operación" al inicio
    // Cargar la dirección de var1 en el registro x1
    ldr x1, =var1          // x1 <- &var1
    // Cargar el valor de var1 en x1 y sign-extend a 64 bits
    ldrsb x1, [x1]         // x1 <- *x1 (sign-extend)
    
    // Cargar la dirección de var2 en el registro x2
    ldr x2, =var2          // x2 <- &var2
    // Cargar el valor de var2 en x2 y sign-extend a 64 bits
    ldrsb x2, [x2]         // x2 <- *x2 (sign-extend)
    
    // Sumar los valores en x1 y x2, y almacenar el resultado en x0
    adds x0, x1, x2         // x0 <- x1 + x2
    
    // Volver de la función
    ret
