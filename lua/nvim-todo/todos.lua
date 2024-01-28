local M = {}

M.todos = {
  { id = 1, name = "Default TODO",         desc = "Default todo item with an extra super duper long name with will hopefully wrap" },
  { id = 2, name = "Another Default TODO", desc = "Default todo item with an extra super duper long name with will hopefully wrap" },
  { id = 3, name = "Default TODO",         desc = "Default todo item with an extra super duper long name with will hopefully wrap" },
  { id = 4, name = "Another Default TODO", desc = "Default todo item with an extra super duper long name with will hopefully wrap" }
}

M.add_todo = function(name, desc)
  table.insert(M.todos, { id = #M.todos + 1, name = name, desc = desc })
end

M.remove_todo = function(id)
  for i, todo in ipairs(M.todos) do
    if (todo.id == id) then
      table.remove(M.todos, i)
      break
    end
  end
end

M.print_todos = function()
  for _, todo in ipairs(M.todos) do
    P(todo)
  end
end

M.open_todos = function()
  vim.cmd("split");
end

return M
