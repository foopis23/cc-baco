local expect = dofile("rom/modules/main/cc/expect.lua").expect

local function custom_dir_completion(shell, _, text, _)
	if text == nil then
		text = ""
	end

	-- string replace replace ~ with /home
	text = string.gsub(text, "~", "/home")

	return fs.complete(text, shell.dir(), false, true)
end

local function custom_shell_resolve(path) 
	expect(1, path, "string")

	local sStartChar = string.sub(path, 1, 1)
	if sStartChar == "/" or sStartChar == "\\" then
		return fs.combine("", path)
	elseif (sStartChar == "~") then
		return fs.combine("/home", string.sub(path, 2))
	else
		return fs.combine(shell.dir(), path)
	end
end

-- update path to include /bin
local path = shell.path()
path = path .. ":/bin"
shell.setPath(path)

-- update shell.resolve ~ to /home
shell.resolve = custom_shell_resolve

-- update tab completion to include ~
shell.setCompletionFunction("rom/programs/cd.lua", custom_dir_completion)

-- start in /home
shell.setDir("/home")
