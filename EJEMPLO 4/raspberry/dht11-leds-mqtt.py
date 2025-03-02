import RPi.GPIO as GPIO
import paho.mqtt.client as paho
import Adafruit_DHT
import time
from paho import mqtt

# Configuración de los pines GPIO
GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)

# Pines de los LEDs
GREEN_LED_PIN = 17
BLUE_LED_PIN = 27

# Configurar los pines como salida
GPIO.setup(GREEN_LED_PIN, GPIO.OUT)
GPIO.setup(BLUE_LED_PIN, GPIO.OUT)

# Configuración del sensor DHT11
DHT_SENSOR = Adafruit_DHT.DHT11
DHT_PIN = 4  # El pin GPIO al que está conectado el sensor

# Configuración de MQTT
TOPIC_GREEN = "raspberry/led/green"
TOPIC_BLUE = "raspberry/led/blue"
TOPIC_TEMPERATURE = "raspberry/temperature"
CLIENT_ID = "raspberry_pi_control"

# Función que se llama cuando el cliente se conecta al broker
def on_connect(client, userdata, flags, rc, properties=None):
    print(f"Conectado con resultado {rc}")
    client.subscribe(TOPIC_GREEN, qos=1)
    client.subscribe(TOPIC_BLUE, qos=1)

# Función que se llama cuando se recibe un mensaje MQTT
def on_message(client, userdata, msg):
    print(f"Mensaje recibido en el tema {msg.topic}: {msg.payload.decode()}")

    # Control de LEDs según el mensaje recibido
    if msg.topic == TOPIC_GREEN:
        if msg.payload.decode() == "ON":
            GPIO.output(GREEN_LED_PIN, GPIO.HIGH)  # Encender LED verde
        elif msg.payload.decode() == "OFF":
            GPIO.output(GREEN_LED_PIN, GPIO.LOW)   # Apagar LED verde
    elif msg.topic == TOPIC_BLUE:
        if msg.payload.decode() == "ON":
            GPIO.output(BLUE_LED_PIN, GPIO.HIGH)   # Encender LED azul
        elif msg.payload.decode() == "OFF":
            GPIO.output(BLUE_LED_PIN, GPIO.LOW)    # Apagar LED azul

# Publicar la temperatura en el tema MQTT
def publish_temperature():
    humidity, temperature = Adafruit_DHT.read(DHT_SENSOR, DHT_PIN)
    if temperature is not None:
        print(f"Temperatura: {temperature}°C")
        client.publish(TOPIC_TEMPERATURE, temperature)
    else:
        print("Error al leer el sensor de temperatura.")    
    # if temperature is not None:
    #     print(f"Temperatura: {temperature}°C")
    #     # Publicar la temperatura en el tema MQTT
    #     client.publish(TOPIC_TEMPERATURE, temperature)  # Enviar temperatura como mensaje
    # else:
    #     print("Error al leer el sensor de temperatura.")

# Configuración del cliente MQTT
client = paho.Client(client_id=CLIENT_ID, userdata=None, protocol=paho.MQTTv5)
client.on_connect = on_connect
client.on_message = on_message

# Habilitar TLS para conexión segura (si es necesario)
client.tls_set(tls_version=mqtt.client.ssl.PROTOCOL_TLS)
# Configurar las credenciales para HiveMQ Cloud
client.username_pw_set("hugosmhd", "123ACyE1")
# Conectar a HiveMQ Cloud
client.connect("f7a8da598bef4164b9c054b527512caa.s1.eu.hivemq.cloud", 8883)

# Iniciar el bucle de comunicación MQTT
client.loop_start()

# Bucle principal para leer la temperatura y controlar los LEDs
while True:
    # Publicar la temperatura cada 5 segundos
    publish_temperature()
    
    # Esperar 5 segundos antes de la siguiente lectura de temperatura
    time.sleep(5)
