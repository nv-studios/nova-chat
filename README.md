# 🌌 Nova_Chat

Nova_Chat is a lightweight, dark-themed, interactive chat application built entirely using **Windows Batch (.bat)** and **PowerShell**. It operates on a decentralized Client-Server file architecture, allowing seamless communication over a Local Area Network (LAN) or a shared network folder without needing external hosting or internet connectivity.

## ✨ Features

- **🎯 Arrow-Key UI Navigation:** Fully customized menu system using keyboard arrow keys and Enter—no clunky number menus.
- **💬 Modular Chat Rooms:** Multiple themed public channels including `#general`, `#gaming`, and `#help`.
- **🔒 Direct Messaging (DM Hub):** Private peer-to-peer conversations with profile bio lookups.
- **👑 Robust Admin Controls:** Dedicated administrator interface featuring system-wide sound toggles, chat log wiping, and user banning systems.
- **🎵 Customizable Chimes:** Native sound notifications for new text entries and validation warnings.

---

## 🚀 Installation & Architecture Setup

Nova_Chat runs on a **Client-Server file network**. The Server manages the flat-file database storage while individual Client apps interface with it.

### 1. Deployment of Server Core
1. Create a dedicated folder on your master computer (e.g., `NovaChat_Server`).
2. Inside that folder, create a blank text file named `Nova_Server.bat`.
3. Open the file in Notepad, paste the **Server Script Code** inside, and save it.
4. Launch `Nova_Server.bat` once to automatically build the user directories and initialize the default master Admin account.

### 2. Configure Local Network Folder Sharing
For client nodes to write data to the server, Windows must grant network permissions to the hosting directory:
1. Right-click your `NovaChat_Server` folder and select **Properties**.
2. Navigate to the **Sharing** tab and click **Advanced Sharing...**
3. Enable **Share this folder**.
4. Click **Permissions**, highlight the **Everyone** group, and ensure **Full Control** and **Change** are checked under **Allow**.
5. Click **Apply** and confirm your changes.

### 3. Client Distribution Config
1. Create a blank file on your workstation named `Nova_Client.bat`.
2. Paste the unified **Client Script Code** inside.
3. **Crucial Step:** Locate **Line 8** of the script and update the server directory variable to map exactly to your network target path:
   ```batch
   set "SERVER_DIR=\\YOUR-HOST-PC-NAME\NovaChat_Server\"
   ```
4. Distribute the configured `Nova_Client.bat` file to your peers over your shared local router network (via USB, Discord, or Email).

---

## 🔒 Default Administrator Access
On your very first application boot, use the hardcoded master supervisor credentials to log into the administrative root environment:
* **Default Username:** `Admin`
* **Default Password:** `NovaPass123`

*Note: You can instantly modify these default verification values by changing the initialization strings at the absolute top of the source files.*

---

## 🛠️ Network Troubleshooting Check
If a remote client reports boot handshake failures or directory dropping errors:
1. Ensure both host and client computers are actively authenticated on the **same router node or Wi-Fi network**.
2. Verify that your active Windows Network Profile layout configuration is explicitly set to **Private** on both endpoints.
3. Run the included connection validator macro script (`Test_Connection.bat`) on the client machine to isolate read/write access drops.


! Attention Passwords, Users, and Messages are NOT private basically anyone can look at the files!
