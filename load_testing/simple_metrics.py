#!/usr/bin/env python3
"""
Simple Docker Metrics Collector
Usage: python simple_metrics.py [architecture_name] [user_count]
"""

import docker
import psutil
import time
import json
import csv
import sys
from datetime import datetime
import signal

class SimpleMetricsCollector:
    def __init__(self):
        self.client = docker.from_env()
        self.collecting = False
        self.metrics_data = []
        
        # Handle Ctrl+C gracefully
        signal.signal(signal.SIGINT, self.stop_collection)
    
    def stop_collection(self, signum=None, frame=None):
        """Stop collection and save results"""
        if self.collecting:
            print("\n🛑 Stopping metrics collection...")
            self.collecting = False
    
    def get_container_stats(self):
        """Get current stats for all running containers"""
        containers_stats = {}
        
        try:
            containers = self.client.containers.list()
            
            for container in containers:
                try:
                    # Get container stats (non-streaming)
                    stats = container.stats(stream=False)
                    
                    # Calculate CPU percentage
                    cpu_delta = stats['cpu_stats']['cpu_usage']['total_usage'] - \
                               stats['precpu_stats']['cpu_usage']['total_usage']
                    system_delta = stats['cpu_stats']['system_cpu_usage'] - \
                                  stats['precpu_stats']['system_cpu_usage']
                    
                    cpu_percent = 0.0
                    if system_delta > 0 and cpu_delta > 0:
                        cpu_percent = (cpu_delta / system_delta) * \
                                     len(stats['cpu_stats']['cpu_usage']['percpu_usage']) * 100.0
                    
                    # Get memory stats
                    memory_usage = stats['memory_stats']['usage']
                    memory_limit = stats['memory_stats']['limit']
                    memory_percent = (memory_usage / memory_limit) * 100.0
                    
                    # Get process/thread count
                    pids_current = stats.get('pids_stats', {}).get('current', 0)
                    
                    containers_stats[container.name] = {
                        'cpu_percent': round(cpu_percent, 2),
                        'memory_mb': round(memory_usage / (1024*1024), 2),
                        'memory_percent': round(memory_percent, 2),
                        'pids': pids_current,
                        'status': container.status
                    }
                    
                except Exception as e:
                    print(f"⚠️  Error getting stats for {container.name}: {e}")
                    
        except Exception as e:
            print(f"❌ Error listing containers: {e}")
            
        return containers_stats
    
    def get_system_stats(self):
        """Get system-wide stats"""
        cpu_percent = psutil.cpu_percent(interval=1)
        memory = psutil.virtual_memory()
        
        return {
            'cpu_percent': cpu_percent,
            'memory_percent': memory.percent,
            'memory_used_gb': round(memory.used / (1024**3), 2),
            'memory_total_gb': round(memory.total / (1024**3), 2)
        }
    
    def collect_once(self):
        """Collect metrics once"""
        timestamp = datetime.now()
        
        print(f"📊 {timestamp.strftime('%H:%M:%S')} - Collecting metrics...")
        
        container_stats = self.get_container_stats()
        system_stats = self.get_system_stats()
        
        sample = {
            'timestamp': timestamp.isoformat(),
            'system': system_stats,
            'containers': container_stats
        }
        
        # Print current stats
        print(f"   💻 System: CPU {system_stats['cpu_percent']:.1f}% | Memory {system_stats['memory_percent']:.1f}%")
        
        for name, stats in container_stats.items():
            print(f"   🐳 {name}: CPU {stats['cpu_percent']:.1f}% | Memory {stats['memory_mb']:.1f}MB | PIDs {stats['pids']}")
        
        return sample
    
    def start_collection(self, interval=5):
        """Start continuous collection"""
        self.collecting = True
        self.metrics_data = []
        
        print("🚀 Starting metrics collection...")
        print("   Press Ctrl+C to stop and save results")
        print("   Collecting every {} seconds".format(interval))
        print()
        
        try:
            while self.collecting:
                sample = self.collect_once()
                self.metrics_data.append(sample)
                
                if not self.collecting:
                    break
                    
                time.sleep(interval)
                
        except KeyboardInterrupt:
            self.stop_collection()
        
        print(f"\n✅ Collection stopped. Collected {len(self.metrics_data)} samples")
    
    def save_results(self, architecture, users):
        """Save collected metrics"""
        if not self.metrics_data:
            print("❌ No data to save")
            return
            
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        base_name = f"{architecture}_{users}users_{timestamp}"
        
        # Save as JSON
        json_file = f"metrics/{base_name}.json"
        with open(json_file, 'w') as f:
            json.dump(self.metrics_data, f, indent=2)
        
        # Save as CSV (flattened)
        csv_file = f"metrics/{base_name}.csv"
        self.save_csv(csv_file)
        
        # Generate summary
        summary_file = f"metrics/{base_name}_summary.txt"
        self.save_summary(summary_file, architecture, users)
        
        print(f"💾 Results saved:")
        print(f"   📄 {json_file}")
        print(f"   📊 {csv_file}")  
        print(f"   📋 {summary_file}")
    
    def save_csv(self, filename):
        """Save as CSV"""
        with open(filename, 'w', newline='') as csvfile:
            fieldnames = ['timestamp', 'system_cpu', 'system_memory', 'container', 
                         'container_cpu', 'container_memory_mb', 'container_pids']
            
            writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
            writer.writeheader()
            
            for sample in self.metrics_data:
                base_row = {
                    'timestamp': sample['timestamp'],
                    'system_cpu': sample['system']['cpu_percent'],
                    'system_memory': sample['system']['memory_percent']
                }
                
                for container_name, container_data in sample['containers'].items():
                    row = base_row.copy()
                    row.update({
                        'container': container_name,
                        'container_cpu': container_data['cpu_percent'],
                        'container_memory_mb': container_data['memory_mb'],
                        'container_pids': container_data['pids']
                    })
                    writer.writerow(row)
    
    def save_summary(self, filename, architecture, users):
        """Generate text summary"""
        if not self.metrics_data:
            return
            
        # Calculate averages and maxes
        system_cpu = [s['system']['cpu_percent'] for s in self.metrics_data]
        system_mem = [s['system']['memory_percent'] for s in self.metrics_data]
        
        container_stats = {}
        for sample in self.metrics_data:
            for name, stats in sample['containers'].items():
                if name not in container_stats:
                    container_stats[name] = {'cpu': [], 'memory': [], 'pids': []}
                container_stats[name]['cpu'].append(stats['cpu_percent'])
                container_stats[name]['memory'].append(stats['memory_mb'])
                container_stats[name]['pids'].append(stats['pids'])
        
        with open(filename, 'w') as f:
            f.write("="*60 + "\n")
            f.write("DOCKER METRICS SUMMARY\n")
            f.write("="*60 + "\n")
            f.write(f"Architecture: {architecture}\n")
            f.write(f"Users: {users}\n")
            f.write(f"Samples: {len(self.metrics_data)}\n")
            f.write(f"Duration: ~{len(self.metrics_data) * 5 / 60:.1f} minutes\n")
            f.write(f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n")
            
            f.write("SYSTEM METRICS\n")
            f.write("-" * 30 + "\n")
            f.write(f"CPU Usage: {sum(system_cpu)/len(system_cpu):.1f}% avg, {max(system_cpu):.1f}% max\n")
            f.write(f"Memory Usage: {sum(system_mem)/len(system_mem):.1f}% avg, {max(system_mem):.1f}% max\n\n")
            
            f.write("CONTAINER METRICS\n")
            f.write("-" * 30 + "\n")
            for name, stats in container_stats.items():
                f.write(f"{name}:\n")
                f.write(f"  CPU: {sum(stats['cpu'])/len(stats['cpu']):.1f}% avg, {max(stats['cpu']):.1f}% max\n")
                f.write(f"  Memory: {sum(stats['memory'])/len(stats['memory']):.1f}MB avg, {max(stats['memory']):.1f}MB max\n")
                f.write(f"  PIDs: {sum(stats['pids'])/len(stats['pids']):.1f} avg, {max(stats['pids'])} max\n\n")

def main():
    import os
    os.makedirs('metrics', exist_ok=True)
    
    collector = SimpleMetricsCollector()
    
    # Get architecture and users from command line
    architecture = sys.argv[1] if len(sys.argv) > 1 else input("Architecture name (base/cache/search/proxy/full): ")
    users = sys.argv[2] if len(sys.argv) > 2 else input("Number of users: ")
    
    print(f"🎯 Testing: {architecture} architecture with {users} users")
    print("🚀 Start your JMeter test now!")
    print("   This script will collect metrics until you press Ctrl+C")
    print()
    
    try:
        collector.start_collection(interval=5)
        collector.save_results(architecture, users)
        
    except Exception as e:
        print(f"❌ Error: {e}")
        if collector.metrics_data:
            collector.save_results(architecture, users)

if __name__ == "__main__":
    main()