-- This is a one time run script to setup the CC OS to be more linux like
local startup_script_url = "https://raw.githubusercontent.com/foopis23/cc-baco/master/startup-cc-os.lua"
local lex_library_url = "https://raw.githubusercontent.com/foopis23/cc-baco/master/lex.lua"
local shedit_url = "https://raw.githubusercontent.com/foopis23/cc-baco/master/shedit.lua"

textutils.slowPrint("Setting up...")

-- create standard directories
fs.makeDir("/bin")
fs.makeDir("/etc")
fs.makeDir("/home")
fs.makeDir("/lib")

local function downloadFile(url, path)
	local request = http.get(url)
	local startup = request.readAll()
	request.close()

	local fd = fs.open(path, "w")
	fd.write(startup)
	fd.close()
end

-- download startup script
downloadFile(startup_script_url, "/startup")
downloadFile(lex_library_url, "/lib/lex.lua")
downloadFile(shedit_url, "/bin/shedit")

-- reboot system
textutils.slowPrint("Setup Complete. Restarting...")
sleep(1)
os.reboot()
