# 🌌 Nova_Chat

Nova_Chat is a split-server messaging console built entirely using **Windows Batch (.bat)** and **PowerShell**. It safely connects users across a local network using transaction tokens, keeping database files completely hidden from the shared public directory.

---

## 🚀 Setup Steps for Host Deployment

### Step 1: Establish Your Directories
1. Create a private folder on your hard drive named `NovaChat_Private` (Keep this folder completely private).
2. Create a second folder named `NovaChat_Shared` anywhere you want.

### Step 2: Share the Public Folder
1. Right-click the **`NovaChat_Shared`** folder and select **Properties**.
2. Go to **Sharing** -> **Advanced Sharing...** -> Check **Share this folder**.
3. Click **Permissions**, highlight the group **Everyone**, and check **Allow** for both **Full Control** and **Change**. Click Apply.

### Step 3: Run the Server
1. Download `Nova_Server.bat` and drop it inside your `NovaChat_Private` directory.
2. Launch the script. When prompted by the console window, paste the path to your **`NovaChat_Shared`** folder and press Enter.

### Step 4: Share the Client
1. Drop `Nova_Client.bat` directly inside the **`NovaChat_Shared`** directory.
2. Anyone connected to your home router or office Wi-Fi can open that shared directory, run the client file, and chat safely without seeing anyone's passwords!
