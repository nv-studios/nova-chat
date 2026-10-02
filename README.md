# 🌌 Nova_Chat

Nova_Chat is a lightweight, secure chat system designed to run entirely inside the command terminal. It features a modern interface and operates on a smart **Client-Server file sync network** over a Local Area Network (LAN) or a shared network directory—requiring zero internet connectivity or complex web hosting.

The repository includes both native **Windows Batch (.bat)** scripts and native **Linux Shell (.sh)** scripts, making it fully cross-platform right out of the box.

---

## ✨ Features

- **🎯 Universal Terminal Interfaces:** Cross-platform support for Windows Command Prompt and Linux Bash environments.
- **💬 Themed Chatrooms:** Built-in multi-channel support featuring independent logs for channels like `#general` and `#gaming`.
- **🔒 Secure Split-Folder Architecture:** User databases, authentication systems, and encryption profiles live in a strictly **Private Folder**. Only anonymous request strings and active logs are pushed to the **Public Shared Folder**, preventing users from viewing other accounts' passwords or private files.
- **👑 Root Administrator Dashboard:** Dedicated server console managing storage pathways, system node states, and chat registry audits.
- **🎵 Interactive Chimes (Windows Node):** Customizable system beep notifications for new text entries and validation warnings.

---

## 🎮 Cross-Play Compatibility & Interface Differences

Nova_Chat is completely **cross-play compatible**. Because the network infrastructure relies purely on standard file read/write triggers, **a Windows user running the `.bat` client and a Linux user running the `.sh` client can chat in the exact same rooms at the exact same time.**

Please note the following platform differences:
- **Windows Client (`novachat-client.bat`):** Features full arrow-key menu navigation, custom user profiles/bios, direct messaging (DM Hub), and sound effects.
- **Linux Client (`novachat-client-linux.sh`):** Built as a streamlined console utility using standard number selection inputs (`1-3`) for maximum stability across different Linux distributions. *Note: Direct Messaging (DMs) and Bio editing are currently exclusive to the Windows client.*

---

## 🛠️ How It Works

Nova_Chat behaves like a secure digital filing cabinet:
1. **The Server Hub (`novachat_serverside.bat` / `novachat_server_side.sh`):** Stays hidden inside a private folder on the host computer. It listens for incoming packets, processes logins, verifies passwords, and updates text files safely.
2. **The Client Terminal (`novachat-client.bat` / `novachat-client-linux.sh`):** The interface files distributed to users. Clients write brief, temporary transaction tokens to the shared directory which the server interprets, authorizes, and wipes away in real-time.

---

## 🚀 Quick Start Deployment Guide

### Option A: Windows Deployment (`.bat` Engine)

#### 1. Setup the Files
- Download `novachat_serverside.bat` and drop it inside a private local folder on the host machine (e.g., `C:\NovaChat_Private`).
- Launch `novachat_serverside.bat`. On the first-time boot wizard, paste the full path of the shared network folder you want to use for the public exchange portal (e.g., `\\YOUR-PC\SharedFolder`).

#### 2. Network Folder Permissions
- Right-click your shared network folder, select **Properties** -> **Sharing** -> **Advanced Sharing...**
- Check **Share this folder**. Click **Permissions**, select the **Everyone** group, and check **Allow** for both **Full Control** and **Change**.

#### 3. Connect the Clients
- Place `novachat-client.bat` directly inside that same shared network folder. Anyone connected to your home Wi-Fi or local office router can double-click it from the network drive to log in and chat instantly!

---

### Option B: Linux Deployment (`.sh` Engine)

#### 1. Initialize Server Framework
- Open your terminal, navigate to your script directory, and grant execution flags:
  ```bash
  chmod +x novachat_server_side.sh novachat_client-linux.sh
  ```
- Launch the secure backend listener node:
  ```bash
  ./novachat_server_side.sh
  ```
- Press **Enter** on the first prompt to accept the automated default `./Public_Shared` storage path.

#### 2. Run the User Client
- Open a new terminal window or tab, navigate to the folder, and spin up the user interface:
  ```bash
  ./novachat_client-linux.sh
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
