# download_workshop.py
# Workshop Items Downloader for Quake Live Server
import os
import shutil
import subprocess

# Define workshop.txt, steamcmd & quakelive directories
quakelive_dir = "/home/steam/quakelive"
workshop_file = quakelive_dir + "/home/workshop.txt"
steamcmd_dir = "/home/steam"
workshop_appid = "282440"

if not os.path.exists(workshop_file):
    print(f"workshop.txt not found at {workshop_file}")
    exit(0)

with open(workshop_file, 'r') as archivo:
    lineas = archivo.readlines()

# Save workshop IDs (skip empty lines and comments)
workshopIDs = [linea.strip() for linea in lineas if linea.strip() and not linea.strip().startswith('#')]
print(f"IDs: {workshopIDs}")
print(f"Total items: {len(workshopIDs)}")

# Download workshop items
steamcmd_exe = os.path.join(steamcmd_dir, 'steamcmd.sh')

for i in range(len(workshopIDs)):
    print(f"\nDownloading item {workshopIDs[i]} from Steam... ({i+1}/{len(workshopIDs)})\n")
    subprocess.run([steamcmd_exe, '+login anonymous', f'+workshop_download_item {workshop_appid} ' + workshopIDs[i], '+quit'])

# Move workshop files from steamcmd to the Quake Live server install folder
origin = steamcmd_dir + "/steamapps/workshop/content/" + workshop_appid + "/"
destiny = quakelive_dir + "/qlds/steamapps/workshop/content/" + workshop_appid + "/"

print("\n")
if not os.path.isdir(origin):
    print("No downloaded workshop content found.")
    exit(0)

os.makedirs(destiny, exist_ok=True)
for item in os.listdir(origin):
    src = os.path.join(origin, item)
    dst = os.path.join(destiny, item)
    if os.path.exists(dst):
        shutil.rmtree(dst)
    shutil.move(src, dst)
    print(f'Item: {item} successfully moved')
