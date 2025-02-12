# Ruby Development Environment with Docker
---

# **Ruby Development with Docker (Linux & Windows Containers)**  

## **Overview**  
This project provides **Docker containers** for Ruby development on both **Linux** and **Windows** environments.  

- 🐧 **Linux Container**: Uses the official [`ruby:3.1.2`](https://hub.docker.com/_/ruby) Docker image for a lightweight setup.  
- 🖥️ **Windows Container**: Based on **Windows Server Core LTSC 2022**, installing Ruby via **Chocolatey**.  

---

## **System Requirements**  
### **For Linux/macOS users (WSL2 or native Linux/macOS)**  
✅ Docker Desktop with **Linux containers enabled**  
✅ macOS/Linux terminal (or WSL2 for Windows users)  

### **For Windows users**  
✅ Docker Desktop with **Windows containers enabled**  
✅ Windows 10/11 (Pro, Enterprise, or Education)  

---

## **How to Build the Containers**  

### **Building the Linux Container**  
```sh
docker build -t ruby-linux -f Dockerfile.linux .
```

### **Building the Windows Container**  
```powershell
docker build -t ruby-windows -f Dockerfile.windows .
```

To specify a **different Ruby version**, use `--build-arg`:
```sh
docker build --build-arg rubyVersion=3.2.0 -t ruby-linux -f Dockerfile.linux .
```
```powershell
docker build --build-arg rubyVersion=3.2.0 -t ruby-windows -f Dockerfile.windows .
```

---

## **How to Run the Containers**  

### **Running the Linux Container**
```sh
docker run -it --rm -v $(pwd):/workspace ruby-linux bash
```
- Mounts the current project directory to `/workspace` inside the container.  
- Starts an interactive shell session.  

### **Running the Windows Container**
```powershell
docker run -it --rm -v ${PWD}:/workspace ruby-windows powershell
```
- Mounts the project directory as `C:\workspace`.  
- Starts an interactive PowerShell session.  

---

## **Switching Between Windows and Linux Containers**  
⚠ **IMPORTANT:** Docker **cannot run both Linux and Windows containers simultaneously**. If you're switching between them:  

### **Switch to Linux Containers**  
1. Open **Docker Desktop**.  
2. Click the **Settings** ⚙️ icon.  
3. Under **General**, check **"Use the WSL 2 based engine"**.  
4. Right-click the Docker icon in the system tray → **Switch to Linux containers**.  

### **Switch to Windows Containers**  
1. Right-click the **Docker Desktop** icon in the system tray.  
2. Select **"Switch to Windows containers"**.  

---

## **Verifying Ruby Installation**
Once inside a running container, check the installed Ruby version:  
```sh
ruby -v
```

---

## **Troubleshooting**
❌ **Issue:** "Cannot switch to Windows/Linux containers"  
✅ **Solution:** Restart **Docker Desktop** and try again.  

❌ **Issue:** "Mounting volume fails on Windows"  
✅ **Solution:** Ensure **file sharing** is enabled in Docker settings under **Resources > File Sharing**.  

❌ **Issue:** "Exception calling "DownloadString" with "1" argument(s): "The remote name could not be resolved: 'community.chocolatey.org'"  
✅ **Solution:** Ensure **Docker network ls** is using the correct network.
 - docker network ls
 - docker network inspect "name"
 - use the right network: docker build --network="NameOfNetwork" -t ruby-windows -f 
---