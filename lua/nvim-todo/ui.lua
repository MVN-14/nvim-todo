local hl = require("nvim-todo.hl")

WinHandle = nil
Bufnr = nil

local M = {}

local augroup = vim.api.nvim_create_augroup("TODOAuGroup", { clear = true })
vim.api.nvim_create_autocmd("CursorMoved", {
  pattern = ".todo",
  callback = function()
    local pos = vim.fn.getpos(".")
    hl.highlight_lines(pospos)
  end
})
local function create_window()
  local height = 20
  local width = 120
  local bufr_text = {}

  local todos = require("nvim-todo.todos").todos
  for i, todo in ipairs(todos) do
    local checkbox
    if todo.completed then
      checkbox = "[X]"
    else
      checkbox = "[ ]"
    end

    table.insert(bufr_text, string.format("%s %d. %s", checkbox, i, todo.name))
    table.insert(bufr_text, string.format("%8s%s", "-  ", todo.desc))
--    table.insert(bufr_text, "")
  end

  Bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(Bufnr, 0, 0, false, bufr_text)
  vim.api.nvim_buf_set_option(Bufnr, "buftype", "nowrite")
  vim.api.nvim_buf_set_option(Bufnr, "bufhidden", "delete")

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

--  hl.highlight_lines({1, 2, 3})
end

local function close_window()
  vim.api.nvim_win_close(WinHandle, true)

  WinHandle = nil
  Bufnr = nil
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
