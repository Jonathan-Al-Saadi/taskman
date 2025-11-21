local M = {}

M.setup = function()
  vim.api.nvim_create_user_command(
    "NewTask",
    function()
      M.open_new_task_form()
    end,
    { desc = "Create a new task using a floating form" }
  )
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
  local seperator = "^%-%s%[%s%]"

  for _, line in ipairs(lines) do
    if line:find(seperator) then
      table.insert(tasks.tasks, line)
    end
  end

  return tasks
end

local create_centered_window = function(buf, height, width)
  local opts = {
    relative = "editor",
    style = "minimal",
    border = "rounded",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
  }

  return vim.api.nvim_open_win(buf, true, opts)
end

local trim = function(value)
  return (value or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local extract_field = function(label, line)
  local pattern = string.format("^%s%s*(.*)", vim.pesc(label), vim.pesc(":"))
  local match = line:match(pattern)

  return match and trim(match) or ""
end

local insert_task_line = function(buf, cursor, values)
  local task = trim(values.task)

  if task == "" then
    vim.notify("Task description is required", vim.log.levels.WARN)
    return
  end

  local line = "- [ ] " .. task

  if values.due ~= "" then
    line = string.format("%s (due: %s)", line, values.due)
  end

  if values.tags ~= "" then
    line = string.format("%s [%s]", line, values.tags)
  end

  local position = cursor[1]

  vim.api.nvim_buf_set_lines(buf, position, position, true, { line })
  vim.api.nvim_win_set_cursor(0, { position + 1, 0 })
end

local function format_initial_lines()
  return {
    "New Task",
    "Task: ",
    "Due date: ",
    "Tags: ",
    "",
    "Press <Enter> to save or <Esc> to cancel.",
  }
end

M.open_new_task_form = function()
  local original_win = vim.api.nvim_get_current_win()
  local original_buf = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(original_win)

  local form_buf = vim.api.nvim_create_buf(false, true)
  local form_height = 6
  local form_width = math.max(40, math.floor(vim.o.columns * 0.4))

  local form_win = create_centered_window(form_buf, form_height, form_width)

  vim.api.nvim_buf_set_option(form_buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(form_buf, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(form_buf, "modifiable", true)
  vim.api.nvim_win_set_option(form_win, "cursorline", true)
  vim.api.nvim_buf_set_lines(form_buf, 0, -1, false, format_initial_lines())
  vim.api.nvim_win_set_cursor(form_win, { 2, 7 })

  local function close_form()
    if vim.api.nvim_win_is_valid(form_win) then
      vim.api.nvim_win_close(form_win, true)
    end
  end

  local function submit_form()
    local lines = vim.api.nvim_buf_get_lines(form_buf, 0, -1, false)

    local values = {
      task = extract_field("Task", lines[2] or ""),
      due = extract_field("Due date", lines[3] or ""),
      tags = extract_field("Tags", lines[4] or ""),
    }

    close_form()
    vim.api.nvim_set_current_win(original_win)
    insert_task_line(original_buf, cursor, values)
  end

  vim.keymap.set("n", "<CR>", submit_form, { buffer = form_buf, nowait = true })
  vim.keymap.set("n", "<Esc>", close_form, { buffer = form_buf, nowait = true })
  vim.keymap.set("n", "q", close_form, { buffer = form_buf, nowait = true })
end

return M
