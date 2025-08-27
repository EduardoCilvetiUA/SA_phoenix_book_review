# Load Testing with Docker Metrics and Graphs

## 📁 New Scripts Added

- **`docker_logger.py`** - Docker metrics collector (compatible with graph generator)
- **`generate_graphs.py`** - Performance graph generator
- **`simple_metrics.py`** - Simple metrics collector (original)

## 🚀 Two Workflows Available

### **Workflow 1: Simple Metrics (Original)**
```bash
# Collect metrics
python simple_metrics.py base 1

# Results: JSON + CSV + Summary text
# Output: metrics/base_1users_timestamp.*
```

### **Workflow 2: Docker Logger + Graphs (New)**
```bash
# Collect metrics with graph support
python docker_logger.py base 1_request

# Generate performance graphs
python generate_graphs.py base 1_request

# Results: JSON + 3 PNG graphs
# Output: arch_base/1_request/
```

---

## 📊 Complete Testing Example

### **Step 1: Start Docker**
```bash
docker-compose up -d
curl http://localhost:4000/analytics/top_rated_books
```

### **Step 2: Start Metrics (Choose one)**

**Option A - Simple metrics:**
```bash
python simple_metrics.py base 1
```

**Option B - Docker logger with graphs:**
```bash
python docker_logger.py base 1_request
```

### **Step 3: Run JMeter Test**
- Open `All_Load_Tests.jmx` in JMeter GUI
- Enable only "Test 1 Request"
- Click Start (▶️)

### **Step 4: Stop Metrics**
- Press `Ctrl+C` in metrics terminal

### **Step 5: Generate Graphs (Option B only)**
```bash
python generate_graphs.py base 1_request
```

### **Step 6: Clean Up**
```bash
docker-compose down -v
```

---

## 📈 Graph Outputs (Workflow 2)

For each test, you get **3 professional graphs**:

### **CPU Usage Graph**
- `arch_base/1_request/1_request_cpu_usage.png`
- Shows CPU% over time for each container

### **Memory Usage Graph** 
- `arch_base/1_request/1_request_memory_usage.png`
- Shows memory in MiB over time

### **Threads Count Graph**
- `arch_base/1_request/1_request_threads_count.png`
- Shows process/thread count over time

---

## 📂 Directory Structure

### **Workflow 1 (Simple):**
```
load_testing/
├── metrics/
│   ├── base_1users_20241127_142315.json
│   ├── base_1users_20241127_142315.csv
│   └── base_1users_20241127_142315_summary.txt
```

### **Workflow 2 (Docker Logger):**
```
load_testing/
├── arch_base/
│   └── 1_request/
│       ├── 1_request_data.json
│       ├── 1_request_cpu_usage.png
│       ├── 1_request_memory_usage.png
│       └── 1_request_threads_count.png
├── arch_cache/
│   └── 10_requests/
│       ├── 10_requests_data.json
│       ├── 10_requests_cpu_usage.png
│       ├── 10_requests_memory_usage.png
│       └── 10_requests_threads_count.png
```

---

## 🎯 Test Naming Convention

| JMeter Test | Architecture | Test Name | Example Command |
|-------------|--------------|-----------|-----------------|
| 1 Request | base | 1_request | `docker_logger.py base 1_request` |
| 10 Requests | cache | 10_requests | `docker_logger.py cache 10_requests` |
| 100 Requests | search | 100_requests | `docker_logger.py search 100_requests` |
| 1000 Requests | proxy | 1000_requests | `docker_logger.py proxy 1000_requests` |
| 5000 Requests | full | 5000_requests | `docker_logger.py full 5000_requests` |

---

## 🔧 Dependencies

Make sure you have:
```bash
pip install matplotlib psutil docker
```

---

## ✅ Workflow 2 Full Example

**Complete test for cache architecture with 100 requests:**

```bash
# 1. Start cache architecture
docker-compose -f docker-compose.cache.yml up -d

# 2. Start metrics logger
python docker_logger.py cache 100_requests

# 3. In JMeter GUI: Enable "Test 100 Requests", run test

# 4. Stop logger (Ctrl+C) when JMeter finishes

# 5. Generate graphs
python generate_graphs.py cache 100_requests

# 6. View results in: arch_cache/100_requests/

# 7. Stop Docker
docker-compose down -v
```

**Results:**
- Professional CPU, Memory, and Threads graphs
- Time-series data in JSON format
- Ready for assignment report!

---

## 📊 Which Workflow to Use?

**Use Workflow 1 (simple_metrics.py) if:**
- ✅ You want quick CSV data for analysis
- ✅ You prefer text summaries
- ✅ You're doing basic comparisons

**Use Workflow 2 (docker_logger.py + graphs) if:**
- ✅ You need professional graphs for reports
- ✅ You want detailed time-series visualization
- ✅ You're writing the assignment report
- ✅ You need publication-ready charts