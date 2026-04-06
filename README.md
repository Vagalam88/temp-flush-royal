  # Temp Flush Royal

**Ultimate Temporary & Unnecessary Files Cleaner for Windows 11**  
*Version 2.0 – Multi-Drive Selection*
*by Robert Must 2.1

A powerful, safe, and user-friendly PowerShell script that cleans **all** temporary files, caches, and unnecessary data across **any drive** you choose (internal SSD/HDD, external drives, or USB keys).

---

## ✨ Features

- **Drive Selection** – Choose one, multiple, or all drives (C:, D:, E:, USB, external disks, etc.)
- **Full Preview Mode** – Shows exactly which folders and how many files will be deleted **before** any action
- **Smart Cleanup** – Automatically detects internal vs removable drives
- **System-Only Features** – Prefetch, SoftwareDistribution, Delivery Optimization, Internet cache, and Recycle Bin are cleaned **only on the system drive**
- **Automatic Administrator Elevation**
- **Safe & Non-Destructive** – Skips locked files gracefully
- **Modern & Clean Console Output**
- No third-party tools required

---

## 📋 What Gets Cleaned

On **every selected drive**:
- `\Temp` folder
- `\Windows\Temp` folder (if present)

On the **system drive (C:)** only:
- Windows Prefetch
- SoftwareDistribution\Download
- Delivery Optimization Cache
- Internet Explorer / Edge cache & cookies
- User Temp folder
- Thumbnail cache (Explorer)
- Recycle Bin

---

## 🚀 How to Use

1. Download the file `Temp-Flush-Royal.ps1`
2. Right-click on the file → **Run with PowerShell**
3. The script will automatically request Administrator rights if needed
4. It will list all your drives (internal + external/USB)
5. Choose which drive(s) you want to clean:
   - Type `C` → only C: drive
   - Type `C,D` → C: and D: drives
   - Type `All` → clean every drive
6. Review the preview, type `Y` and press Enter to start cleaning

---

## 🛡️ Safety

- Only deletes files inside known temporary and cache folders
- Never touches your personal documents, photos, or programs
- Uses `-ErrorAction SilentlyContinue` to skip files currently in use
- Fully transparent open-source code

---

## 💻 Requirements

- Windows 10 or Windows 11
- PowerShell 5.1 or higher (included by default)
- Administrator rights (automatically requested)

---

## 📄 License

MIT License – Free to use, modify, and distribute.

---

## ⭐ Support the Project

If this script helps you keep your PC fast and clean, please **star** the repository!

---

**Made for power users who want full control over their system cleanup.**

---

You can now create your new repository (`Temp-Flush-Royal`), upload the `Temp-Flush-Royal.ps1` file, and paste this README.

Would you like me to also give you:
- A short description for the GitHub repo page (the one-line description under the repo name)?
- Instructions on how to upload everything quickly?

Just say the word and I’ll send it right away. 🔥
