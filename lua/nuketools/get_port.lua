--- Get the port value from nukeserversocket config file
---@param jsonFile string
---@return integer?
local function parseJsonFile(jsonFile)
	-- XXX: vim has the json utils that we could use instead
	local f = io.open(jsonFile, "r")

	if f == nil then
		return nil
	end

	local line = ""
	while true do
		line = f:read()

		if line == nil then
			break
		end

		if string.match(line, "port") then
			line = string.match(line, "%d+")
			break
		end
	end

	io.close(f)

	if line == nil or line == "" then
		return nil
	end

	return tonumber(line)
end

--- Get the port value from nukeserversocket config file.
---
--- NOTE: This only supports NukeServerSocket >= 1.0.0.
---@return integer
local function getNssPort()
	local home = os.getenv("HOME")
	if home == nil then
		return 54321
	end

	local configFile = vim.fs.joinpath(home, ".nuke", "nukeserversocket.json")
	local port = parseJsonFile(configFile)

	if port == nil then
		return 54321
	end

	return port
end

return getNssPort()
