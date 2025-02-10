import RPi.GPIO as GPIO
import time

# Configurar el modo de numeración de los pines como BCM
GPIO.setmode(GPIO.BOARD)

# Establecer el pin GPIO 17 como salida (en lugar del pin físico 11)
GPIO.setup(11, GPIO.OUT)

try:
    while True:
        # Encender el LED
        GPIO.output(11, GPIO.HIGH)
        print("LED encendido")
        time.sleep(1)  # Espera 1 segundo
        
        # Apagar el LED
        GPIO.output(11, GPIO.LOW)
        print("LED apagado")
        time.sleep(1)  # Espera 1 segundo

except KeyboardInterrupt:
    # Limpiar la configuración GPIO cuando se interrumpe el programa
    GPIO.cleanup()
    print("Programa detenido.")
