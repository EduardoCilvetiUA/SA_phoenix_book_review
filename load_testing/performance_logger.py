import subprocess
import json
import time
from datetime import datetime
import signal
import sys
import os

arch = sys.argv[1]
name_file = sys.argv[2]

# Nombre del archivo de salida
OUTPUT_FILE =  f"arch_{arch}/{name_file}/{name_file}_data.json"

directory = os.path.dirname(OUTPUT_FILE)

# Verifica si el directorio existe, si no, lo crea
if not os.path.exists(directory):
    os.makedirs(directory)

INTERVAL = 1

# Función para capturar estadísticas de Docker
def capture_docker_stats():
    try:
        # Ejecuta el comando docker stats y captura la salida
        result = subprocess.run(
            ["docker", "stats", "--no-stream", "--format", "{{ json . }}"],
            capture_output=True, text=True
        )
        # Convierto la salida en una lista de diccionarios JSON
        stats = [json.loads(line) for line in result.stdout.splitlines()]
        return stats
    except Exception as e:
        print(f"Error capturando estadísticas de Docker: {e}")
        return []

# Función para manejar la señal de interrupción (Ctrl+C)
def signal_handler(sig, frame):
    print("\nCaptura de estadísticas detenida. Archivo guardado en", OUTPUT_FILE)
    sys.exit(0)

# Registrar la señal de interrupción
signal.signal(signal.SIGINT, signal_handler)

# Inicializa la estructura de datos JSON
data = []

print("Iniciando captura de estadísticas. Presiona Ctrl+C para detener...")

# Bucle infinito para capturar estadísticas
while True:
    # Obtener la marca de tiempo actual
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    # Capturar estadísticas
    stats = capture_docker_stats()
    
    # Crear una entrada JSON con la marca de tiempo y estadísticas de los contenedores
    json_entry = {timestamp: stats}
    
    # Agregar la nueva entrada al conjunto de datos
    data.append(json_entry)
    
    # Guardar las estadísticas en el archivo JSON
    with open(OUTPUT_FILE, 'w') as f:
        json.dump(data, f, indent=4)
    
    # Esperar el intervalo de tiempo especificado antes de la siguiente captura
    time.sleep(INTERVAL)
