-- This is a one time run script to setup the CC OS to be more linux like
local startup_script_url = "https://raw.githubusercontent.com/foopis23/cc-baco/master/startup-cc-os.lua"

textutils.slowPrint("Setting up...")

-- create standard directories
fs.makeDir("/bin")
fs.makeDir("/etc")
fs.makeDir("/home")
fs.makeDir("/lib")

-- download startup script
local request = http.get(startup_script_url)
local startup = request.readAll()
request.close()

-- save startup script
local fd = fs.open("startup", "w")
fd.write(startup)
fd.close()

-- reboot system
textutils.slowPrint("Setup Complete. Restarting...")
sleep(1)
os.reboot()
