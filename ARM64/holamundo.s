.global _start

.text  // Sección de código

_start:
    mov x0, 1         // set stdout
    ldr x1, =msg      // load msg
    mov x2, 14        // size msg
    mov x8, 64        // write syscall_num
    svc 0             // generic syscall
    
    mov x0, 0         // return value
    mov x8, 93        // exit syscall_num
    svc 0             // generic syscall

.data  // Sección de datos
msg: .asciz "Hello, World!\n"  // Cadena de texto

/*
MAS COMENTARIOS

.global 
Esta directiva le indica al ensamblador que la etiqueta _start es global, lo que significa que puede ser referenciada desde fuera del archivo ensamblador (en este caso, por el enlazador para que sea el punto de entrada del programa).

_start:
Esta es una etiqueta que marca el inicio del programa. Es el punto de entrada donde se ejecutará el código.

mov x0, 1
Este movimiento coloca el valor 1 en el registro x0, que es el descriptor de archivo para la salida estándar (stdout). Esto es necesario para la syscall write que usaremos después para imprimir el mensaje.

ldr x1, =msg
La instrucción ldr carga la dirección de la etiqueta msg en el registro x1. Esta etiqueta msg es donde está almacenada la cadena de texto "Hello, World!\n". El registro x1 se usa para pasar la dirección del mensaje a la syscall write.

mov x2, 14
Este movimiento pone el valor 14 en el registro x2, que indica el tamaño del mensaje que vamos a imprimir (es decir, la longitud de la cadena "Hello, World!\n" que es de 14 caracteres).

mov x8, 64
El valor 64 se coloca en el registro x8, que es el número de la syscall write en el sistema operativo Linux (es la syscall para escribir en un archivo o dispositivo).

svc 0
svc es una llamada a sistema, que genera una interrupción del software para realizar una operación del sistema operativo. En este caso, estamos invocando la syscall write con los valores previamente cargados en los registros. svc 0 es la invocación para hacer la llamada de sistema.

mov x0, 0

Este movimiento pone el valor 0 en el registro x0, que se usará como valor de retorno para la siguiente syscall (en este caso, para la syscall exit).

mov x8, 93
El valor 93 se coloca en el registro x8, que es el número de la syscall exit en Linux (es la syscall para terminar un programa).

svc 0
Esta es otra llamada a sistema, esta vez invocando la syscall exit. El programa se termina y se devuelve el valor contenido en el registro x0 (en este caso, 0 que indica una salida exitosa).

.data
Esta directiva marca el inicio de la sección de datos del programa. La sección de datos es donde se almacenan las variables y cadenas que el programa usará.

msg: .asciz "Hello, World!\n"
Define la cadena de texto "Hello, World!\n" como un objeto de datos nulo-terminado (como una cadena de texto en C). Esta cadena se almacenará en la memoria y se referenciará con la etiqueta msg, que luego es utilizada en el código para la syscall write.
 */