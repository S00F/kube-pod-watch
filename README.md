# 🚀 kube-pod-watch

A lightweight shell script for monitoring Kubernetes **pods, deployments, and resource usage** with real-time **alerts**.

---

## 📌 Features
✅ Real-time Pod Status Monitoring  
✅ Deployment Health Checks  
✅ CPU & Memory Usage Tracking  
✅ Automatic Logging  
✅ CPU & Memory Usage Tracking  

---

## 🛠 Installation & Setup

### 1️⃣ Clone the Repository
```sh
git clone https://github.com/S00F/kube-pod-watch.git
cd kube-pod-watch
```

### 2️⃣ Install Dependencies
Ensure you have:
- `kubectl` (installed & configured)
- `jq` (for JSON processing)
- `curl` (for sending alerts)

Install jq if missing:
```sh
sudo apt install jq   # Debian/Ubuntu
brew install jq       # MacOS
```

### 3️⃣ Configure Settings
Edit `config.env`:
```sh
NAMESPACE="default"
```

### 4️⃣ Run the Script
```sh
chmod +x kube-pod-watch.sh
./kube-pod-watch.sh
```

---

## 📊 Logs & Monitoring

- Logs are saved in `logs/pod_monitor.log`.  
- To view real-time logs:
  ```sh
  tail -f logs/pod_monitor.log
  ```

- Track CPU and memory usage:
  ```sh
  kubectl top pods --namespace "$NAMESPACE"
  ```

---

## 📌 Future Enhancements
🔹 Multi-namespace monitoring  
🔹 More alerting options (PagerDuty, Email)  
🔹 Grafana/Prometheus integration  

---



## 🤝 Contributing
1. Fork the repo  
2. Create a feature branch (`feature-new-alerts`)  
3. Commit changes  
4. Open a Pull Request  

---
