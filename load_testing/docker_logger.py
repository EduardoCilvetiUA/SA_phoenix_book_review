#!/usr/bin/env python3
"""
Docker Performance Logger - Compatible with performance_graph.py
Usage: python docker_logger.py [architecture] [test_name]
"""

import subprocess
import json
import time
from datetime import datetime
import signal
import sys
import os

def main():
    if len(sys.argv) < 3:
        print("Usage: python docker_logger.py [architecture] [test_name]")
        print("Example: python docker_logger.py base 1_request")
        sys.exit(1)
    
    arch = sys.argv[1]
    name_file = sys.argv[2]
    
    # Create output directory structure
    output_dir = f"arch_{arch}/{name_file}"
    output_file = f"{output_dir}/{name_file}_data.json"
    
    # Create directory if it doesn't exist
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
        print(f"Created directory: {output_dir}")
    
    INTERVAL = 1  # 1 second interval
    
    def capture_docker_stats():
        """Capture Docker stats in the expected format"""
        try:
            # Execute docker stats command
            result = subprocess.run(
                ["docker", "stats", "--no-stream", "--format", "{{ json . }}"],
                capture_output=True, text=True
            )
            
            # Parse each line as JSON and format it
            stats = []
            for line in result.stdout.splitlines():
                if line.strip():
                    container_data = json.loads(line)
                    # Format to match expected structure
                    formatted_data = {
                        "Name": container_data.get("Name", ""),
                        "CPUPerc": container_data.get("CPUPerc", "0.00%"),
                        "MemUsage": container_data.get("MemUsage", "0B / 0B"),
                        "PIDs": container_data.get("PIDs", "0")
                    }
                    stats.append(formatted_data)
            
            return stats
            
        except Exception as e:
            print(f"Error capturing Docker stats: {e}")
            return []
    
    def signal_handler(sig, frame):
        """Handle Ctrl+C gracefully"""
        print(f"\nCapture stopped. Data saved to: {output_file}")
        sys.exit(0)
    
    # Register signal handler
    signal.signal(signal.SIGINT, signal_handler)
    
    # Initialize data structure
    data = []
    
    print(f"🚀 Starting Docker metrics capture...")
    print(f"📊 Architecture: {arch}")
    print(f"🎯 Test: {name_file}")
    print(f"💾 Output: {output_file}")
    print(f"⏱️  Interval: {INTERVAL} second(s)")
    print("Press Ctrl+C to stop...\n")
    
    # Main capture loop
    try:
        while True:
            # Get current timestamp
            timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            
            # Capture Docker stats
            stats = capture_docker_stats()
            
            if stats:
                # Print current stats
                print(f"📊 {timestamp}")
                for container in stats:
                    name = container["Name"]
                    cpu = container["CPUPerc"]
                    mem = container["MemUsage"].split(" / ")[0]
                    pids = container["PIDs"]
                    print(f"   🐳 {name}: CPU {cpu} | Memory {mem} | PIDs {pids}")
                
                # Create JSON entry with timestamp as key
                json_entry = {timestamp: stats}
                data.append(json_entry)
                
                # Save to file
                with open(output_file, 'w') as f:
                    json.dump(data, f, indent=4)
                
                print()  # Empty line for readability
            
            # Wait for next interval
            time.sleep(INTERVAL)
            
    except KeyboardInterrupt:
        signal_handler(None, None)

if __name__ == "__main__":
    main()