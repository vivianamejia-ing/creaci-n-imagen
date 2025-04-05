import os
from pymongo import MongoClient
from pymongo.server_api import ServerApi
from dotenv import load_dotenv
from datetime import datetime

load_dotenv()

def connect_to_mongodb(db_name, collection_name):
    uri = os.getenv("mongodb+srv://karolamejia08:828k505d@patient.gz8al.mongodb.net/?retryWrites=true&w=majority&appName=Patient")
    client = MongoClient(uri, server_api=ServerApi('1'))
    db = client[db_name]
    collection = db[collection_name]
    return collection

def crear_registro_ris(
    paciente_id,
    nombre_paciente,
    tipo_estudio,
    observaciones,
    imagen_url  # puede ser ruta local o URL
):
    collection = connect_to_mongodb("RIS_DB", "imagenes_ris")
    
    documento = {
        "paciente_id": paciente_id,
        "nombre_paciente": nombre_paciente,
        "tipo_estudio": tipo_estudio,
        "fecha_estudio": datetime.now(),
        "observaciones": observaciones,
        "imagen": imagen_url  # o puedes guardar en base64
    }

    resultado = collection.insert_one(documento)
    print(f"Registro creado con ID: {resultado.inserted_id}")
