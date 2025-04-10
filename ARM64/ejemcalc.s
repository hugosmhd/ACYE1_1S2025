.global _start
.data

clear_screen:
    .asciz "\x1B[2J\x1B[H"
    lenClear = .- clear_screen

msg_resultado: 
    .asciz "El resultado de la operacion es: "
    lenMsgResultado = .- msg_resultado

value:  .asciz "00000000000000000000"
    lenValue = .- value // Se encargara de guardar los valores a imprimir en pantalla luego de una operacion (20 Espacios)

espacio:  .asciz "  "
    lenEspacio = .- espacio

salto:  .asciz "\n"
    lenSalto = .- salto

ingresoComando:
    .asciz ":"
    lenIngresoComando = .- ingresoComando   // Unicamente se colocan 2 pts para pedir el ingreso del comando


.bss
num:
    .space 22   // Variable encargada de guardar los parametros que ingrese el usuario

comando:
    .skip 50    // Encargado de guardar el comando que ingresa el usuario

tipo_comando: .zero 1

param1:
    .skip 8         // Reservar 8 bytes (64 bits) sin inicializar, variable que guarda un numero de 64 bits, uso general

param2:
    .skip 8         // Reservar 8 bytes (64 bits) sin inicializar, variable que guarda un numero de 64 bits, uso general

.text

// Macro para imprimir strings
.macro mPrint reg, len
    MOV x0, 1
    LDR x1, =\reg
    MOV x2, \len
    MOV x8, 64
    SVC 0
.endm

// Macro para limpiar la variable value y regresarla a 20 ceros
.macro mLimpiarValue
    MOV w6, 0
    // Se define una etiqueta local
    1:
        STRB w6, [x1], 1
        SUB w7, w7, 1
        CBNZ w7, 1b
.endm

// Macro para pedirle una entrada al usuario
.macro mRead stdin, buffer, len
    MOV x0, \stdin
    LDR x1, =\buffer
    MOV x2, \len
    MOV x8, 63
    SVC 0
.endm

limpiarVariables:
    clear_loop:
        strb w26, [x25], #1    // Guardar byte 0 en la posición actual y avanzar
        subs x27, x27, #1      // Decrementar contador
        b.ne clear_loop      // Si no es cero, seguir limpiando
    RET

getComando:
    mPrint ingresoComando, lenIngresoComando
    mRead 0, comando, 50
    RET
verificarParametro:
    // Retorna en w4, el tipo de parametro
    /*
    w4=1=numero
    */
    
    LDR x10, =num   // Direccion en memoria donde se almacena el parametro
    MOV x4, 0   // x4=tipo de parametro puede ser: Numero
                // En el procedimiento, x4 tambien nos servira para llevar el control de caracteres leidos
    v_exit:
        LDRB w20, [x0], #1  // Se Carga en w20 lo que sigue del comando, se espera que ya sea algun parametro
        ADD x4, x4, 1   // Numero de caracteres leidos se aumenta
        CMP w20, #'e'             // Compara w20 con 'e'
        BNE v_analizar_numero_resta        // Si w20 != 'e', salta a evaluar el numero
        
        LDRB w20, [x0], #1
        ADD x4, x4, 1   // Numero de caracteres leidos se aumenta
        CMP w20, #'x'             // Compara w20 con 'x'
        BNE v_analizar_numero_resta        // Si w20 != 'x', salta fuera del rango (deberia de dar error)
        
        LDRB w20, [x0], #1
        ADD x4, x4, 1   // Numero de caracteres leidos se aumenta
        CMP w20, #'i'             // Compara w20 con 'i'
        BNE v_analizar_numero_resta        // Si w20 != 'i', salta fuera del rango (deberia de dar error)
        
        LDRB w20, [x0], #1
        ADD x4, x4, 1   // Numero de caracteres leidos se aumenta
        CMP w20, #'t'             // Compara w20 con 't'
        BNE v_analizar_numero_resta        // Si w20 != 't', salta fuera del rango (deberia de dar error)
        
        MOV w4, 2
        B v_fin
    v_analizar_numero_resta:
        // En este caso como se evaluo primero la palabra "exit" y ya hizo avance en el buffer
        // Se debe restar lo que leyo para que pueda leer el numero completo en caso sea numero
        SUB x0, x0, x4
        MOV x4, 0 // Se reinicia las lecturas que se estan haciendo
        MOV w22, #0              // Flag: ¿ya hubo un '-'? (0 = no, 1 = sí)
    v_analizar_numero:
        LDRB w20, [x0], #1

        CMP w20, #'-'          // Compara el carácter con ' '
        BEQ verificar_guion           // Si es igual, salta a v_retornar_numero
        CMP w20, #'0'          // Compara el valor en w20 con 0
        BLT v_retornar_numero // Si el valor es menor que 0, salta a v_retornar_numero
        CMP w20, #'9'          // Compara el valor en w20 con 0
        BGT v_retornar_numero // Si el valor es mayor que 9, salta a v_retornar_numero

        B continuar_numero
    verificar_guion:
        CMP w22, #1              // ¿Ya hubo un '-'?
        BEQ v_retornar_numero    // Si sí, error (no permitir dos guiones)

        CMP x4, #0               // ¿Es el primer carácter?
        BNE v_retornar_numero    // Si no es el primero, error

        MOV w22, #1              // Marcar que hubo un '-'
    continuar_numero:
        STRB w20, [x10], 1
        ADD x4, x4, 1   // Numero de caracteres leidos se aumenta
        B v_analizar_numero
    v_retornar_numero:
        MOV w4, 1
        B v_fin
    v_fin:
    RET
itoa:
    // params: x0 => number, x1 => buffer address
    MOV x8, 0 // contador de numeros
    MOV x3, 10 // base
    MOV w17, 1 // Control para ver si el numero es negativo
    i_negativo:
        TST x0, #0x8000000000000000
        BNE i_complemento_2
        B i_convertirAscii
    i_complemento_2:
        MVN x0, x0
        ADD x0, x0, 1
        MOV w17, 0
    i_convertirAscii:
        UDIV x16, x0, x3        // DIVISION
        MSUB x6, x16, x3, x0    // Sacar el residuo de la division
        ADD w6, w6, 48          // Sumarle 48 al residuo para que sea un numero en ascci

        // GUARDAR EN PILA
        SUB sp, sp, #8      // Reservar 16 bytes (por alineación) en la pila
        STR w6, [sp, #0]     // Almacenar el valor de w6 en la pila en la dirección apuntada por sp

        ADD x8, x8, 1   // Sumamos la cantidad de numeros leidos
        MOV x0, x16     // Movemos el resultado de la division (cociente) para x0 para la siguiente iteracion agarre el nuevo valor
        CBNZ x16, i_convertirAscii

        CBZ w17, i_agregar_signo
        B i_almacenar
    i_agregar_signo:
        MOV w6, 45
        // GUARDAR EN PILA
        SUB sp, sp, #8      // Reservar 16 bytes (por alineación) en la pila
        STR w6, [sp, #0]     // Almacenar el valor de w6 en la pila en la dirección apuntada por sp
        ADD x8, x8, 1
    i_almacenar:
        // Cargar el valor de vuelta desde la pila
        LDR w6, [sp, #0]     // Cargar el valor almacenado en la pila a w7
        STRB w6, [x1], 1
        // Limpiar el espacio de la pila
        ADD sp, sp, #8      // Recuperar los 16 bytes de la pila

        SUB x8, x8, 1   // Restamos el contador de la pila
        CBNZ x8, i_almacenar
        // B i_almacenar
    i_endConversion:
        RET
atoi:  // ascii to int
    // X12 -> DIRECCION DE MEMORIA DE LA CADENA A CONVERTIR
    mov x3, 0              // Inicializamos el número resultante en 0
    mov x21, 10             // Multiplicador
    mov x5, 0               // Guardara el caracter que se esta leyendo
    a_leerChar:
        LDRB w5, [x12], 1 // cargamos caracter por caracter a w5

        cmp w5, #45             // Verificar si es el carácter '-'
        beq a_signo_menos     // Si es '-', saltamos a "a_signo_menos"
        
        CMP w5, #'0'          // Compara el valor en w5 con 0
        BLT a_endConvertir // Si el valor es menor que 0, salta a a_endConvertir
        CMP w5, #'9'          // Compara el valor en w5 con 0
        BGT a_endConvertir // Si el valor es menor que 0, salta a a_endConvertir

        B a_seguir_conversion
    a_signo_menos:
        MOV x7, 1   // Bandera del signo pasa a 1
        B a_leerChar // Se continua leyendo

    a_seguir_conversion:
        sub w5, w5, 48         // Restar '0' (48 en ASCII) para convertir el carácter a número
        mul x3, x3, x21         // Multiplicar el número acumulado por 10 (shiftar un dígito a la izquierda)
        add x3, x3, x5         // Añadir el valor del dígito al número final

        b a_leerChar
    a_negativeNum:
        MOV x7, 0
        NEG x3, x3
    a_endConvertir:
        CMP x7, 1   
        BEQ a_negativeNum   // Si la bandera del signo esta activa, se salta a "a_negativeNum"
        STR x3, [x8] // usando 32 bits
    
    RET

parametroNumero:
    CMP w4, 01
    BEQ parametro_numero
    B retornar_parametro
    parametro_numero:
        // El numero de celda estara en w4
        ldr x12, =num
        STP x29, x30, [SP, -16]!     // Guardar x29 y x30 antes de la llamada
        BL atoi
        LDP x29, x30, [SP], 16       // Restaurar x29 y x30 después de la llamada
        B retornar_parametro
    retornar_parametro:
        RET

verificarOperacion:
    // Retorna en w4, el tipo de operacion encontrada
    MOV w4, 1 // w4=1 operaciion "+" encontrada
    CMP w20, #'+'          // Compara el carácter con '+'
    BEQ fin_verificar_intermedia           // Si es igual, termina de verificar

    MOV w4, 2 // w4=2 operaciion "-" encontrada
    CMP w20, #'-'          // Compara el carácter con '-'
    BEQ fin_verificar_intermedia           // Si es igual, termina de verificar

    MOV w4, 0
    B fin_verificar_intermedia
    fin_verificar_intermedia:
    RET

imprimirValue:
    // Limpiamos el valor
    LDR x1, =value // Direccion del value
    MOV w7, 20 // Largo del Buffer a limpiar
    mLimpiarValue

    LDR x1, =value
    STP x29, x30, [SP, -16]!     // Guardar x29 y x30 antes de la llamada al procedimiento
    BL itoa                     // Llamada a procedimiento ITOA
    LDP x29, x30, [SP], 16       // Restaurar x29 y x30 después de la llamada
    mPrint value, 20
    mPrint salto, lenSalto
    RET

_start:
    mPrint clear_screen, lenClear

    ingreso_comando:
        // Limpiar buffer: poner 0 en las 50 posiciones
        ldr x25, =comando         // x25 = dirección base del buffer
        mov x26, #0           // x26 = byte a escribir (0)
        mov x27, #50          // x27 = contador
        BL limpiarVariables

        ldr x25, =num         // x25 = dirección base del buffer
        mov x26, #0           // x26 = byte a escribir (0)
        mov x27, #22          // x27 = contador
        BL limpiarVariables

        BL getComando

        LDR x0, =comando
        // Apartir de aqui en w20 estara el recorrido del comando ingresado (11234+1230)
        // El valor de x0 no se debe perder ya que tiene la direccion de memoria del comando
        // Si en el proceso de lectura del comando se usa x0, se debera de usar la pila para no perder el valor de x0

        // Este es el primer parametro
        BL verificarParametro // Se verifica el tipo de parametro (Numero, Celda o Retorno) y guarda el valor del parametro para luego procesarlo
        CMP w4, 2
        BEQ final

        LDR x8, =param1
        BL parametroNumero

        BL verificarOperacion
        ADR x5, tipo_comando
        STRB w4, [x5]

        ldr x25, =num         // x25 = dirección base del buffer
        mov x26, #0           // x26 = byte a escribir (0)
        mov x27, #22          // x27 = contador
        BL limpiarVariables

        // Este es el segundo parametro
        BL verificarParametro
        LDR x8, =param2
        BL parametroNumero

        ADR x0, tipo_comando
        LDRB w2, [x0]

        CMP w2, 1
        BEQ hacer_suma

        CMP w2, 2
        BEQ hacer_resta


        B ingreso_comando
    hacer_suma:
        mPrint msg_resultado, lenMsgResultado
        LDR x9, =param1
        LDR x9, [x9]

        LDR x10, =param2
        LDR x10, [x10]

        ADDS x0, x9, x10

        BL imprimirValue
        B ingreso_comando
    hacer_resta:
        mPrint msg_resultado, lenMsgResultado
        LDR x9, =param1
        LDR x9, [x9]

        LDR x10, =param2
        LDR x10, [x10]

        cmp x10, #0
        bge hacer_resta_normal         // Si b es positivo, hacemos a - b
        NEG x10, x10
        add x0, x9, x10
        BL imprimirValue
        B ingreso_comando
    hacer_resta_normal:
        SUB x0, x9, x10
        BL imprimirValue
        B ingreso_comando
    final:
        mov x0, 0
        mov x8, 93
        svc 0