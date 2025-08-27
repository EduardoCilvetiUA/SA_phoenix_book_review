#!/usr/bin/env python3
"""
Performance Graph Generator - Adapted for load_testing structure
Usage: python generate_graphs.py [architecture] [test_name]
"""

import json
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
from datetime import datetime
import sys
import os

def main():
    if len(sys.argv) < 3:
        print("Usage: python generate_graphs.py [architecture] [test_name]")
        print("Example: python generate_graphs.py base 1_request")
        sys.exit(1)
    
    arch = sys.argv[1]
    name_file = sys.argv[2]
    
    # Input file path
    input_file = f"arch_{arch}/{name_file}/{name_file}_data.json"
    
    # Check if file exists
    if not os.path.exists(input_file):
        print(f"❌ Error: File not found: {input_file}")
        print("Make sure you ran docker_logger.py first")
        sys.exit(1)
    
    print(f"📊 Generating graphs for: {arch} - {name_file}")
    print(f"📂 Reading data from: {input_file}")
    
    # Read JSON data
    try:
        with open(input_file, 'r') as f:
            data = json.load(f)
    except Exception as e:
        print(f"❌ Error reading file: {e}")
        sys.exit(1)
    
    # Prepare data for graphs
    timestamps = []
    cpu_usage = {}
    mem_usage = {}
    threads_count = {}
    
    def convert_mem_usage(mem_str):
        """Convert memory usage to MiB"""
        mem_str = mem_str.split(" / ")[0]
        mem_value = mem_str.replace("GiB", "").replace("MiB", "").replace("KiB", "").replace("B", "")
        
        try:
            if 'GiB' in mem_str:
                return float(mem_value) * 1024
            elif 'MiB' in mem_str:
                return float(mem_value)
            elif 'KiB' in mem_str:
                return float(mem_value) / 1024
            else:
                # Assume bytes
                return float(mem_value) / 1024 / 1024
        except ValueError:
            return 0.0
    
    # Process data
    for entry in data:
        for timestamp, stats in entry.items():
            try:
                time_val = datetime.strptime(timestamp, "%Y-%m-%d %H:%M:%S")
                timestamps.append(time_val)
                
                for container in stats:
                    container_name = container["Name"]
                    
                    # Initialize container data if not exists
                    if container_name not in cpu_usage:
                        cpu_usage[container_name] = []
                        mem_usage[container_name] = []
                        threads_count[container_name] = []
                    
                    # Parse CPU percentage
                    cpu_percent = float(container["CPUPerc"].replace('%', ''))
                    cpu_usage[container_name].append(cpu_percent)
                    
                    # Convert memory usage to MiB
                    mem_usage_value = convert_mem_usage(container["MemUsage"])
                    mem_usage[container_name].append(mem_usage_value)
                    
                    # Parse PIDs
                    pids = float(container["PIDs"])
                    threads_count[container_name].append(pids)
                    
            except Exception as e:
                print(f"⚠️  Warning: Error processing entry {timestamp}: {e}")
                continue
    
    if not timestamps:
        print("❌ No valid data found in file")
        sys.exit(1)
    
    print(f"✅ Processed {len(timestamps)} data points")
    
    # Calculate time deltas in seconds from first timestamp
    first_timestamp = timestamps[0]
    time_deltas = [(t - first_timestamp).total_seconds() for t in timestamps]
    
    # Configuration
    interval = 30  # Grid interval in seconds
    interval_line = 60  # Vertical line interval
    
    def add_vertical_lines(ax, interval, max_time):
        """Add vertical grid lines"""
        for x in range(0, int(max_time) + 1, interval):
            ax.axvline(x=x, color='gray', linestyle='--', linewidth=0.5, alpha=0.7)
    
    # Create output directory
    output_dir = f"arch_{arch}/{name_file}"
    
    # Generate CPU Usage Graph
    plt.figure(figsize=(12, 6))
    ax = plt.gca()
    
    for container_name, usage in cpu_usage.items():
        if usage:  # Only plot if we have data
            plt.plot(time_deltas[:len(usage)], usage, 
                    label=f'{container_name} CPU Usage', linewidth=2, marker='o', markersize=3)
    
    plt.xlabel('Time (seconds)')
    plt.ylabel('CPU Usage (%)')
    plt.title(f'CPU Usage Over Time - {arch.upper()} ({name_file})')
    plt.legend()
    plt.grid(True, alpha=0.3)
    
    # Configure x-axis
    if time_deltas:
        plt.xticks(range(0, int(time_deltas[-1]) + 1, interval))
        add_vertical_lines(ax, interval_line, time_deltas[-1])
    
    plt.tight_layout()
    cpu_output = f"{output_dir}/{name_file}_cpu_usage.png"
    plt.savefig(cpu_output, dpi=300, bbox_inches='tight')
    plt.close()
    print(f"📊 CPU graph saved: {cpu_output}")
    
    # Generate Memory Usage Graph
    plt.figure(figsize=(12, 6))
    ax = plt.gca()
    
    for container_name, usage in mem_usage.items():
        if usage:  # Only plot if we have data
            plt.plot(time_deltas[:len(usage)], usage, 
                    label=f'{container_name} Memory Usage (MiB)', linewidth=2, marker='s', markersize=3)
    
    plt.xlabel('Time (seconds)')
    plt.ylabel('Memory Usage (MiB)')
    plt.title(f'Memory Usage Over Time - {arch.upper()} ({name_file})')
    plt.legend()
    plt.grid(True, alpha=0.3)
    
    # Configure x-axis
    if time_deltas:
        plt.xticks(range(0, int(time_deltas[-1]) + 1, interval))
        add_vertical_lines(ax, interval_line, time_deltas[-1])
    
    plt.tight_layout()
    mem_output = f"{output_dir}/{name_file}_memory_usage.png"
    plt.savefig(mem_output, dpi=300, bbox_inches='tight')
    plt.close()
    print(f"💾 Memory graph saved: {mem_output}")
    
    # Generate Threads Count Graph
    plt.figure(figsize=(12, 6))
    ax = plt.gca()
    
    for container_name, threads in threads_count.items():
        if threads:  # Only plot if we have data
            plt.plot(time_deltas[:len(threads)], threads, 
                    label=f'{container_name} Threads Count', linewidth=2, marker='^', markersize=3)
    
    plt.xlabel('Time (seconds)')
    plt.ylabel('Threads Count')
    plt.title(f'Threads Count Over Time - {arch.upper()} ({name_file})')
    plt.legend()
    plt.grid(True, alpha=0.3)
    
    # Configure x-axis
    if time_deltas:
        plt.xticks(range(0, int(time_deltas[-1]) + 1, interval))
        add_vertical_lines(ax, interval_line, time_deltas[-1])
    
    plt.tight_layout()
    threads_output = f"{output_dir}/{name_file}_threads_count.png"
    plt.savefig(threads_output, dpi=300, bbox_inches='tight')
    plt.close()
    print(f"🧵 Threads graph saved: {threads_output}")
    
    print(f"\n✅ All graphs generated successfully!")
    print(f"📂 Output directory: {output_dir}")

if __name__ == "__main__":
    main()