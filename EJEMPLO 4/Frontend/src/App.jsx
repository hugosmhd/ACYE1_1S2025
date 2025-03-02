import React, { useState, useEffect } from 'react';
import mqtt from 'mqtt';
import { Line } from 'react-chartjs-2';
import { Chart as ChartJS, CategoryScale, LinearScale, PointElement, LineElement, Title, Tooltip, Legend } from 'chart.js';

const options = {
  protocol: "wss",
  username: "hugosmhd",
  password: "123ACyE1",
  clientId: `mqttjs_${Math.random().toString(16).substring(2, 8)}`,
};

const MQTT_URL = 'wss://f7a8da598bef4164b9c054b527512caa.s1.eu.hivemq.cloud:8884/mqtt'; // URL del broker HiveMQ
const TOPIC_GREEN = 'raspberry/led/green';
const TOPIC_BLUE = 'raspberry/led/blue';
const TOPIC_TEMPERATURE = 'raspberry/temperature';

// Registrar los componentes necesarios de Chart.js
ChartJS.register(CategoryScale, LinearScale, PointElement, LineElement, Title, Tooltip, Legend);


const App = () => {
  const [client, setClient] = useState(null);
  const [temperatureData, setTemperatureData] = useState([]);
  const [labels, setLabels] = useState([]);

  // Conectar con el broker MQTT
  const connectMQTT = () => {
    const mqttClient = mqtt.connect(MQTT_URL, options);

    mqttClient.on('connect', () => {
      console.log('Conectado al broker MQTT');
    });

    setClient(mqttClient);
  };

  // Enviar mensaje para encender o apagar LED verde
  const controlGreenLED = (action) => {
    if (client) {
      client.publish(TOPIC_GREEN, action);  // "ON" o "OFF"
    }
  };

  // Enviar mensaje para encender o apagar LED azul
  const controlBlueLED = (action) => {
    if (client) {
      client.publish(TOPIC_BLUE, action);  // "ON" o "OFF"
    }
  };

  // Conectar con el broker MQTT
  useEffect(() => {
    const mqttClient = mqtt.connect(MQTT_URL, options);

    mqttClient.on('connect', () => {
      console.log('Conectado al broker MQTT');
      mqttClient.subscribe(TOPIC_TEMPERATURE);
    });

    mqttClient.on('message', (topic, message) => {
      if (topic === TOPIC_TEMPERATURE) {
        const temp = parseFloat(message.toString());
        const timestamp = new Date().toLocaleTimeString();

        setLabels((prevLabels) => [...prevLabels, timestamp]);
        setTemperatureData((prevData) => [...prevData, temp]);

        // Limitar la cantidad de datos mostrados (ej. últimos 30 puntos)
        if (temperatureData.length > 30) {
          setTemperatureData((prevData) => prevData.slice(1));
          setLabels((prevLabels) => prevLabels.slice(1));
        }
      }
    });

    setClient(mqttClient);

    return () => {
      mqttClient.end();
    };
  }, []);

  // Datos para la gráfica
  const data = {
    labels: labels,
    datasets: [
      {
        label: 'Temperatura (°C)',
        data: temperatureData,
        borderColor: 'rgb(75, 192, 192)',
        backgroundColor: 'rgba(75, 192, 192, 0.2)',
        fill: true,
      },
    ],
  };

  return (
    <div>
      <div>
        <h1>Control de LEDs</h1>
        <button onClick={connectMQTT}>Conectar a MQTT</button>

        <div>
          <h2>LED Verde</h2>
          <button onClick={() => controlGreenLED('ON')}>Encender</button>
          <button onClick={() => controlGreenLED('OFF')}>Apagar</button>
        </div>

        <div>
          <h2>LED Azul</h2>
          <button onClick={() => controlBlueLED('ON')}>Encender</button>
          <button onClick={() => controlBlueLED('OFF')}>Apagar</button>
        </div>
      </div>

      <h1>Gráfica de Temperatura</h1>
      <Line data={data} />
    </div>
  );
};

export default App;

