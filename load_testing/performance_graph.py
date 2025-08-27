import json
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
from datetime import datetime
import sys

arch = sys.argv[1]
name_file = sys.argv[2]

# Nombre del archivo JSON
INPUT_FILE = f"arch_{arch}/{name_file}/{name_file}_data.json"

# Leer el archivo JSON
with open(INPUT_FILE, 'r') as f:
    data = json.load(f)

# Preparar datos para las gráficas
timestamps = []
cpu_usage = {}
mem_usage = {}
threads_count = {}

def convert_mem_usage(mem_str):
    """Convertir el uso de memoria a MiB."""
    mem_str = mem_str.split(" / ")[0]
    mem_value = mem_str.replace("GiB", "").replace("MiB", "").replace("KiB", "")
    if 'GiB' in mem_str:
        return float(mem_value) * 1024
    elif 'MiB' in mem_str:
        return float(mem_value)
    elif 'KiB' in mem_str:
        return float(mem_value) / 1024
    else:
        return float(mem_value) / 1024 / 1024  # Asumir que es en bytes

for entry in data:
    for timestamp, stats in entry.items():
        time_val = datetime.strptime(timestamp, "%Y-%m-%d %H:%M:%S")
        timestamps.append(time_val)
        for container in stats:
            container_name = container["Name"]
            if container_name not in cpu_usage:
                cpu_usage[container_name] = []
                mem_usage[container_name] = []
                threads_count[container_name] = []
            cpu_usage[container_name].append(float(container["CPUPerc"].replace('%', '')))
            
            # Convertir el uso de memoria a MiB
            mem_usage_value = convert_mem_usage(container["MemUsage"])
            mem_usage[container_name].append(mem_usage_value)
            
            threads_count[container_name].append(float(container["PIDs"]))

# Calcular el delta de tiempo en segundos desde el primer timestamp
first_timestamp = timestamps[0]
time_deltas = [(t - first_timestamp).total_seconds() for t in timestamps]

# Configuración de intervalo de tiempo
interval = 30  # Intervalo en segundos
interval_line = 60

def add_vertical_lines(ax, interval, max_time):
    for x in range(0, int(max_time) + 1, interval):
        ax.axvline(x=x, color='gray', linestyle='--', linewidth=1)  # Línea vertical más oscura cada intervalo


# Graficar uso de CPU
plt.figure(figsize=(12, 6))
ax = plt.gca()  # Obtener el eje actual
for container_name, usage in cpu_usage.items():
    plt.plot(time_deltas[:len(usage)], usage, label=f'{container_name} CPU Usage')
plt.xlabel('Time (seconds)')
plt.ylabel('CPU Usage (%)')
plt.title('CPU Usage Over Time')
plt.legend()
plt.grid(True)

# Configurar el formato del eje x para intervalos
plt.xticks(range(0, int(time_deltas[-1]) + 1, interval))
add_vertical_lines(ax, interval_line, time_deltas[-1])  # Añadir líneas verticales
plt.tight_layout()
plt.savefig(f"arch_{arch}/{name_file}/{name_file}_cpu_usage.png")


# Graficar uso de memoria
plt.figure(figsize=(12, 6))
ax = plt.gca()  # Obtener el eje actual
for container_name, usage in mem_usage.items():
    plt.plot(time_deltas[:len(usage)], usage, label=f'{container_name} Memory Usage (MiB)')
plt.xlabel('Time (seconds)')
plt.ylabel('Memory Usage (MiB)')
plt.title('Memory Usage Over Time')
plt.legend()
plt.grid(True)

# Configurar el formato del eje x para intervalos
plt.xticks(range(0, int(time_deltas[-1]) + 1, interval))
add_vertical_lines(ax, interval_line, time_deltas[-1])  # Añadir líneas verticales
plt.tight_layout()
plt.savefig(f"arch_{arch}/{name_file}/{name_file}_memory_usage.png")


# Graficar número de threads
plt.figure(figsize=(12, 6))
ax = plt.gca()  # Obtener el eje actual
for container_name, threads in threads_count.items():
    plt.plot(time_deltas[:len(threads)], threads, label=f'{container_name} Threads Count')
plt.xlabel('Time (seconds)')
plt.ylabel('Threads Count')
plt.title('Threads Count Over Time')
plt.legend()
plt.grid(True)

# Configurar el formato del eje x para intervalos
plt.xticks(range(0, int(time_deltas[-1]) + 1, interval))
add_vertical_lines(ax, interval_line, time_deltas[-1])  # Añadir líneas verticales
plt.tight_layout()
plt.savefig(f"arch_{arch}/{name_file}/{name_file}_threads_count.png")