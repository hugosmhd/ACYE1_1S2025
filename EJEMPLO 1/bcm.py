import RPi.GPIO as GPIO
import time

# Configurar el modo de numeración de los pines como BCM
GPIO.setmode(GPIO.BCM)

# Establecer el pin GPIO 17 como salida (en lugar del pin físico 11)
GPIO.setup(17, GPIO.OUT)

try:
    while True:
        # Encender el LED
        GPIO.output(17, GPIO.HIGH)
        print("LED encendido")
        time.sleep(1)  # Espera 1 segundo
        
        # Apagar el LED
        GPIO.output(17, GPIO.LOW)
        print("LED apagado")
        time.sleep(1)  # Espera 1 segundo

except KeyboardInterrupt:
    # Limpiar la configuración GPIO cuando se interrumpe el programa
    GPIO.cleanup()
    print("Programa detenido.")
