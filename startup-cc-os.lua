local completion = require "cc.shell.completion"
local expect = dofile("rom/modules/main/cc/expect.lua").expect

local customCompletion = {
	file = function(shell, text)
		if text == nil then
			text = ""
		end

		-- string replace replace ~ with /home
		text = string.gsub(text, "~", "/home")

		return fs.complete(text, shell.dir(), true, false)
	end,
	dir = function(shell, text)
		if text == nil then
			text = ""
		end

		-- string replace replace ~ with /home
		text = string.gsub(text, "~", "/home")

		return fs.complete(text, shell.dir(), false, true)
	end,
	dirOrFile = function(shell, text)
		if text == nil then
			text = ""
		end

		-- string replace replace ~ with /home
		text = string.gsub(text, "~", "/home")

		local results = fs.complete(text, shell.dir(), true, true)
		if add_space then
			for n = 1, #results do
				local result = results[n]
				if result:sub(-1) ~= "/" then
					results[n] = result .. " "
				end
			end
		end
		return results
	end,
}

-- update path to include /bin
local path = shell.path()
path = path .. ":/bin"
shell.setPath(path)

-- update shell.resolve ~ to /home
shell.resolve = function(path)
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

local function printOSHeader()
	if term.isColour() then
		promptColour = colours.yellow
		textColour = colours.white
		bgColour = colours.black
	else
		promptColour = colours.white
		textColour = colours.white
		bgColour = colours.black
	end
	
	-- print version
	term.clear()
	term.setCursorPos(1,1)
	term.setBackgroundColor(bgColour)
	term.setTextColour(promptColour)
	print(os.version())
	term.setTextColour(textColour)

	-- print motd
	-- Show MOTD
	if settings.get("motd.enable") then
		shell.run("motd")
	end
end

-- update tab completion to include "~"
shell.setCompletionFunction("rom/programs/cd.lua", completion.build(customCompletion.dir))
shell.setCompletionFunction("rom/programs/copy.lua", completion.build(
	{ customCompletion.dirOrFile, true },
	customCompletion.dirOrFile
))
shell.setCompletionFunction("rom/programs/delete.lua", completion.build({ customCompletion.dirOrFile, many = true }))
shell.setCompletionFunction("rom/programs/drive.lua", completion.build(customCompletion.dir))
shell.setCompletionFunction("rom/programs/edit.lua", completion.build(customCompletion.file))
shell.setCompletionFunction("rom/programs/list.lua", completion.build(customCompletion.dir))
shell.setCompletionFunction("rom/programs/mkdir.lua", completion.build({ customCompletion.dir, many = true }))
shell.setCompletionFunction("rom/programs/move.lua", completion.build(
	{ customCompletion.dirOrFile, true },
	customCompletion.dirOrFile
))
shell.setCompletionFunction("rom/programs/rename.lua", completion.build(
	{ customCompletion.dirOrFile, true },
	customCompletion.dirOrFile
))
shell.setCompletionFunction("rom/programs/type.lua", completion.build(completion.dirOrFile))
shell.setCompletionFunction("rom/programs/fun/advanced/paint.lua", completion.build(completion.file))

-- custom aliases
shell.setAlias("restart", "reboot")

-- update os version
function os.version()
    return "Baco 1.0 Pre-Alpha"
end

-- start in /home
shell.setDir("/home")

-- print os version and motd
printOSHeader()
