-- Clear highlights on search when pressing <Esc> in normal mode
--  it also is clearing the cmdline in windows with :echo command
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>:echo<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Basic Autocommands ]]

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

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

local term_buf = nil

local open_terminal = function()
  if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
    local winid = vim.fn.bufwinid(term_buf)

    if winid ~= -1 and vim.api.nvim_win_is_valid(winid) then
      local winnum = vim.fn.bufwinnr(term_buf)
      vim.cmd(string.format('%dwincmd w', winnum))
    else
      -- buffer hidden reopen in bottom split
      vim.cmd('botright sbuffer' .. term_buf)
    end
  else
    -- create a new terminal
    vim.cmd [[
      botright new
      term
    ]]
    term_buf = vim.api.nvim_get_current_buf()
  end

  vim.api.nvim_win_set_height(0, 15)
end

vim.keymap.set('n', '<leader>ot', open_terminal, { desc = 'This opens a terminal at the bottom of your workspace' })

vim.keymap.set('n', '<leader>gs', function()
  open_terminal()
  local job_id = vim.api.nvim_get_option_value('channel', { buf = term_buf })
  vim.fn.chansend(job_id, 'git status\r\n')
end, { desc = 'Opens a git status message in a terminal' })
