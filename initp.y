from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import Optional
import random
import time
import uuid
app = FastAPI()
# Modelo Pydantic para solicitud de nueva imagen
class NuevaImagen(BaseModel):
    paciente: str
    kvp: int = 120
    mas: float = 2.5
# Modelo Pydantic para respuesta de imagen
class ImagenRespuesta(BaseModel):
    id_imagen: str
    paciente: str
    calidad: str
    informe: Optional[str] = None
    estado: str
# Base de datos simulada
db_imagenes = {}
@app.get("/imagenes/{id_imagen}", response_model=ImagenRespuesta)
def obtener_imagen(id_imagen: str):
    """Obtener detalles de una imagen por ID (GET)"""
    if id_imagen not in db_imagenes:
        raise HTTPException(status_code=404, detail="Imagen no encontrada")
    return db_imagenes[id_imagen]
@app.post("/imagenes/", response_model=ImagenRespuesta)
def crear_imagen(imagen: NuevaImagen):
    """Crear una nueva imagen radiológica (POST)"""
    # Paso 1: Generar un ID único
    id_imagen = str(uuid.uuid4())
    # Paso 2: Simular adquisición (calidad aleatoria)
    calidad = random.choice(["Buena", "Aceptable", "Pobre"])
    # Paso 3: Procesamiento (simulado)
    time.sleep(1)
    # Paso 4: Generar informe si la imagen es válida
    informe = None
    if calidad in ["Buena", "Aceptable"]:
        informe = f"Informe radiológico para {imagen.paciente}. Calidad: {calidad}"
    # Guardar en "base de datos" simulada
    db_imagenes[id_imagen] = {
        "id_imagen": id_imagen,
        "paciente": imagen.paciente,
        "calidad": calidad,
        "informe": informe,
        "estado": "Completado" if informe else "Requiere repetición"
    }
    return db_imagenes[id_imagen]
@app.get("/imagenes/")
def listar_imagenes():
    """Listar todas las imágenes almacenadas (GET)"""
    return db_imagenes
