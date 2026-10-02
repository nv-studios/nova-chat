# 🌌 Nova_Chat

Nova_Chat is a lightweight, secure chat system designed to run entirely inside the command terminal. It features a modern, clean interface and operates on a smart **Client-Server file sync network** over a Local Area Network (LAN) or a shared network directory—requiring zero internet connectivity or complex web hosting.

The repository includes both native **Windows Batch (.bat)** scripts and native **Linux Shell (.sh)** scripts, making it fully cross-platform right out of the box.

---

## ✨ Features

- **🎯 Universal Terminal Interfaces:** Cross-platform support for Windows Command Prompt and Linux Bash environments.
- **💬 Themed Chatrooms:** Built-in multi-channel support featuring independent logs for channels like `#general` and `#gaming`.
- **🔒 Secure Split-Folder Architecture:** User databases, authentication systems, and encryption profiles live in a strictly **Private Folder**. Only anonymous request strings and active logs are pushed to the **Public Shared Folder**, preventing users from viewing other accounts' passwords or private files.
- **👑 Root Administrator Dashboard:** Dedicated server console managing storage pathways, system node states, and chat registry audits.
- **🎵 Interactive Chimes (Windows Node):** Customizable system beep notifications for new text entries and validation warnings.

---

## 🛠️ How It Works

Nova_Chat behaves like a secure digital filing cabinet:
1. **The Server Hub (`Nova_Server`):** Stays hidden inside a private folder on the host computer. It listens for incoming packets, processes logins, verifies passwords, and updates text files safely.
2. **The Client Terminal (`Nova_Client`):** The interface files distributed to users. Clients write brief, temporary transaction tokens to the shared directory which the server interprets, authorizes, and wipes away in real-time.

---

## 🚀 Quick Start Deployment Guide

### Option A: Windows Deployment (`.bat` Engine)

#### 1. Setup the Files
- Download `Nova_Server.bat` and drop it inside a private local folder on the host machine (e.g., `C:\NovaChat_Private`).
- Launch `Nova_Server.bat`. On the first-time boot wizard, paste the full path of the shared network folder you want to use for the public exchange portal (e.g., `\\YOUR-PC\SharedFolder`).

#### 2. Network Folder Permissions
- Right-click your shared network folder, select **Properties** -> **Sharing** -> **Advanced Sharing...**
- Check **Share this folder**. Click **Permissions**, select the **Everyone** group, and check **Allow** for both **Full Control** and **Change**.

#### 3. Connect the Clients
- Place `Nova_Client.bat` directly inside that same shared network folder. Anyone connected to your home Wi-Fi or local office router can double-click it from the network drive to log in and chat instantly!

---

### Option B: Linux Deployment (`.sh` Engine)

#### 1. Initialize Server Framework
- Open your terminal, navigate to your script directory, and grant execution flags:
  ```bash
  chmod +x novachat_serverside_linux.sh novachat_client_linux.sh
  ```
- Launch the secure backend listener node:
  ```bash
  ./novachat_serverside_linux.sh
  ```
- Press **Enter** on the first prompt to accept the automated default `./Public_Shared` storage path.

#### 2. Run the User Client
- Open a new terminal window or tab, navigate to the folder, and spin up the user interface:
  ```bash
  ./novachat_client_linux.sh
  ```

---

## 🔑 Default Administrator Access
On your very first application boot, use these master credentials to unlock administrative supervisor controls:
- **Default Username:** `Admin`
- **Default Password:** `NovaPass123`

*(Note: These default values can be instantly modified by editing the configuration variables located right at the top of the script files).*

---

## ⚖️ License & Attribution
Distributed under the MIT Open Source License. 

Made with ❤️ by **Nova Studios**. Feel free to fork this project, report bugs, or submit updates!


## Notice!
The Linux version does not have all the features mentioned. it is a work in progress.
