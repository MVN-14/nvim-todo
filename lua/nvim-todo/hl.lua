local M = {}

vim.api.nvim_set_hl(0, 'TODOHLGroup', {
  bg = "#ffffff",
  fg = "#000000"
})

M.highlight_lines = function(line_nums)
  M.match = vim.fn.matchaddpos("TODOHLGroup", line_nums)
end

return M
