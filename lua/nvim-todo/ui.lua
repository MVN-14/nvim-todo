local todos = require("nvim-todo.todos").todos
local hl = require("nvim-todo.hl")

WinHandle = nil
Bufnr = nil

local M = {}
M.todo_lines = {}

local augroup = vim.api.nvim_create_augroup("TODOAuGroup", { clear = true })
vim.api.nvim_create_autocmd("CursorMoved", {
  pattern = "*.todo",
  callback = function()
    local linenum = vim.fn.getpos(".")[2]
    local todonum = math.floor((linenum - 1) / 3) + 1
    print("todonum: " .. todonum)
    hl.highlight_lines(M.todo_lines[todonum] or M.todo_lines[#todos])
  end,
  group = augroup
})

local function create_window()
  local height = 20
  local width = 120
  local bufr_text = {}

  for i, todo in ipairs(todos) do
    local line_offset = (i - 1) * 3;
    M.todo_lines[i] = {line_offset + 1, line_offset + 2, line_offset + 3}

    local checkbox
    if todo.completed then
      checkbox = "[X]"
    else
      checkbox = "[ ]"
    end

    table.insert(bufr_text, string.format("%s %d. %s", checkbox, i, todo.name))
    table.insert(bufr_text, string.format("%8s%s", "-  ", todo.desc))
    table.insert(bufr_text, "")
  end

  Bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(Bufnr, 0, 0, false, bufr_text)
  vim.api.nvim_buf_set_name(Bufnr, ".todo")
  vim.api.nvim_set_option_value("buftype", "nowrite", { buf = Bufnr })
  vim.api.nvim_set_option_value("bufhidden", "delete", { buf = Bufnr })
  vim.api.nvim_set_option_value("filetype", "todo", { buf = Bufnr })

  WinHandle = vim.api.nvim_open_win(Bufnr, true, {
    relative = "editor",
    row = math.floor(((vim.o.lines - height) / 2) - 1),
    col = math.floor((vim.o.columns - width) / 2),
    width = width,
    height = height,
    style = "minimal",
    border = "rounded",
    title = "TODO",
    title_pos = "center"
  })

  vim.keymap.set("n", "<Tab>", M.toggle_window)
  vim.keymap.set("n", "q", M.toggle_window, { buffer = Bufnr })
  vim.keymap.set("n", "<Esc>", M.toggle_window, { buffer = Bufnr })
end

local function close_window()
  vim.api.nvim_win_close(WinHandle, true)

  WinHandle = nil
  Bufnr = nil
  hl.match = nil
end

M.toggle_window = function()
  if WinHandle ~= nil then
    close_window()
    return
  end

  create_window()
  if (Bufnr == nil or WinHandle == nil) then
    print('Error creating window')
    return
  end
end

return M
