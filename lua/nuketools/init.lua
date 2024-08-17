---NukeTools neovim edition

---@type integer
local getPort = require("nuketools.get_port")

---@type Buffer
local Buffer = require("nuketools.buffer")

local M = {}
M.defaultConfig = {
	host = "127.0.0.1",
	port = getPort,
	formatOutput = true,
	clearOutput = true,
	formatText = "1",
	buf = nil,
}

---Display an error message
---@param msg string
local function errMsg(msg)
	vim.schedule(function()
		vim.api.nvim_err_writeln("[NukeTools] " .. msg)
	end)
end

---Create a new TCP client
---@param host string
---@param port integer
---@param callback fun(param: string)
---@return any
local function newTcpClient(host, port, callback)
	local client = vim.uv.new_tcp()

	client:connect(host, port, function(err)
		if err then
			errMsg("Error connecting: " .. err)
			return
		end

		client:read_start(function(err, chunk)
			if err then
				errMsg("Error reading socket: " .. err)
				return
			end

			if chunk then
				callback(chunk)
			else
				client:close()
			end
		end)
	end)
	--
	return client
end

---@param startLine integer
---@param endLine integer
---@retrun string
local function getText(startLine, endLine)
	local lines = vim.api.nvim_buf_get_lines(0, startLine, endLine, false)
	local text = table.concat(lines, "\n")
	-- 	text = [[
	-- import random
	-- print('HELLO WORLD'.title())
	-- print('random number', random.randint(1, 1000))
	-- 	 ]]
	return text
end

---SendNuke
---
---Send the current buffer to Nuke and display the output in a new buffer
---@param args table
function ExecuteInNuke(args)
	local arg = args.args
	if arg == "" then
		arg = nil
	end

	local startLine = 0
	local endLine = -1

	-- docs says range could be 0, 1, 2. I got 0 for no selection and 2 for a selection.
	-- dont know about 1 though.
	if args.range ~= 0 then
		startLine = args.line1 - 1
		endLine = args.line2
	end

	local text = arg or getText(startLine, endLine)

	local opts = M.defaultConfig

	local client = newTcpClient(opts.host, opts.port, function(data)
		opts.buf:write(data)
	end)

	local data = {
		text = text,
		file = vim.api.nvim_buf_get_name(0),
		formatText = opts.formatText,
	}

	client:write(vim.json.encode(data))
end

---Setup NukeTools
---@param opts table
function M.setup(opts)
	M.defaultConfig = vim.tbl_deep_extend("force", M.defaultConfig, opts or {})

	---@type boolean
	if M.defaultConfig.clearOutput ~= false then
		M.defaultConfig.clearOutput = true
	end

	---@type boolean
	if M.defaultConfig.formatOutput == false then
		M.defaultConfig.formatText = "0"
	end

	M.defaultConfig.buf = Buffer.new(M.defaultConfig.clearOutput)

	vim.api.nvim_create_user_command("ExecuteInNuke", ExecuteInNuke, { nargs = "?" })
	vim.api.nvim_create_user_command("ExecuteSelectionInNuke", ExecuteInNuke, { range = true })
end

return M
