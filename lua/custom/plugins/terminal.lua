--[
-- This is my first plugin made with a TJ help "and a little gpt help"
-- It's opening a terminal attached at the bottom with <leader>ot combination
-- You can map here some basic functionalities like git status with <leader>gs
--]

vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})

local term_buff = nil
local term_win = 0

local open_terminal = function()
  if term_buff and vim.api.nvim_buf_is_valid(term_buff) then
    -- if terminal exists, just show it
    vim.api.nvim_set_current_win(term_win)
  else
    -- create a new terminal
    vim.cmd.vnew()
    vim.cmd.term()
    vim.cmd.wincmd 'J'
    vim.api.nvim_win_set_height(0, 15)

    --store the window ID
    term_win = vim.api.nvim_get_current_win()
  end
end

vim.keymap.set('n', '<leader>ot', open_terminal, { desc = 'This opens a terminal at the bottom of your workspace' })

vim.keymap.set('n', '<leader>gs', function()
  if not term_buff or vim.api.nvim_buff_is_valid(term_buff) then
    open_terminal()
  end
  local job_id = vim.api.nvim_get_option_value('channel', { buf = term_buff })
  vim.fn.chansend(job_id, 'git status\r\n')
end)
