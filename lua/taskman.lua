local M = {}

M.setup = function()
	--nothing
end

---@class task.line
---@field tasks string[]
---@field urgency string[]
---@field tag string[]
---@field date_due string[]
---@field date_done string[]
---@field date_created string[]

--- Takes some lines and parses them for tasks
---@param lines string []: The lines in the buffer
---@return task.line
local parse_tasks = function(lines)
	local tasks = { tasks = {} }
	local current_tasks = {}
	local seperator = "^%-%s%[%s%]"

	for _, line in ipairs(lines) do
		print(line, "find: ", line:find(seperator), "|")
		if line:find(seperator) then
			table.insert(tasks.tasks, line)
		end
	end

	return tasks
end

vim.print(parse_tasks({
	"- [ ] test",
	"another line",
	"- [ ] test2",
	"test2",
}))

return M
