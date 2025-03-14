from datetime import datetime
from urllib.parse import quote
import pymongo

# Configura la conexión a MongoDB
def connect_to_mongo():
    # Colocar su linea de conexion
    encoded_password = quote('') # Colocar su contraseña
    uri = "mongodb+srv://<nombre_usuario>:"+ encoded_password +"@todo_lo que sigue de su linea de conexion" # Colocar su linea de conexion

    client = pymongo.MongoClient(uri)
    db = client['semaforo_inteligente']
    collection = db['densidad_vehicular']
    return collection

# Función para almacenar la marca de tiempo y densidad vehicular en MongoDB
def registrar_densidad(collection, interseccion, densidad_intersecciones):
    documento = {
        "timestamp": datetime.now(),  # Marca de tiempo actual
        "intersection_id": interseccion,
        "lane_data":densidad_intersecciones
    }
    # Insertar el documento en MongoDB
    collection.insert_one(documento)
    print(f"Datos registrados en MongoDB: {documento}")