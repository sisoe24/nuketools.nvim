---@class Buffer
---@field buf integer
---@field win integer
---@field clearOutput boolean
---@field new fun(param: boolean): table
---@field setup fun(self: Buffer)
---@field write fun(self: Buffer, param: string)
---@field exists fun(self: Buffer): boolean
local Buffer = {}
Buffer.__index = Buffer

---Check if the buffer exists in any window
---@return boolean
function Buffer:exists()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_buf(win) == self.buf then
			return true
		end
	end
	return false
end

---Setup the Buffer.
---
---Creates a new window and sets the buffer in it
function Buffer:setup()
	local current_win = vim.api.nvim_get_current_win()
	vim.cmd("split")

	self.win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(self.win, self.buf)
	vim.api.nvim_set_option_value("wrap", true, { win = self.win })

	local height = math.floor(vim.api.nvim_win_get_height(current_win) / 3)
	vim.api.nvim_win_set_height(self.win, height)

	vim.api.nvim_set_current_win(current_win)
end

---Write text to the Buffer
---@param message string
function Buffer:write(message)
	vim.schedule(function()
		if not self:exists() then
			self:setup()
		end

		local line = 0
		if self.clearOutput == false then
			line = vim.api.nvim_buf_line_count(self.buf)
			vim.api.nvim_win_set_cursor(self.win, { line, 0 })
		end

		vim.api.nvim_set_option_value("modifiable", true, { buf = self.buf })
		vim.api.nvim_buf_set_lines(self.buf, line, -1, false, vim.split(message, "\n"))
		vim.api.nvim_set_option_value("modifiable", false, { buf = self.buf })
	end)
end

---Create a new Buffer
---@param clearOutput boolean
---@return table
function Buffer.new(clearOutput)
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
	vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf })

	local self = setmetatable({}, Buffer)

	self.buf = buf
	self.win = -1
	self.clearOutput = clearOutput

	return self
end

return Buffer
