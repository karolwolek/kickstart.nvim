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

-- Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Move windows focus
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Move the lines up and down
vim.keymap.set({ 'n', 'i' }, '<C-n>', '<ESC>ddp', { noremap = true, desc = 'Move the line down one line' })
vim.keymap.set({ 'n', 'i' }, '<C-p>', '<ESC>ddkP', { noremap = true, desc = 'Move the line up one line' })

-- lowercase/uppercase the word
vim.keymap.set('n', '<S-u>', 'vawU', { noremap = true, desc = 'Convert a word to the uppercase' })
vim.keymap.set('n', '<S-l>', 'vawu', { noremap = true, desc = 'convert a word to the lowercase' })

-- no-neck-pain
vim.keymap.set('n', '<leader><leader>', '<cmd>NoNeckPain<CR>', { desc = 'Center the window', silent = true, noremap = true })
vim.keymap.set({ 'n', 'i', 'v', 't' }, '<M-->', function()
  ---@diagnostic disable-next-line: param-type-mismatch
  pcall(vim.cmd, 'NoNeckPainWidthDown') -- No warning
end, { desc = 'Decrease window size', silent = true, noremap = true })
vim.keymap.set({ 'n', 'i', 'v', 't' }, '<M-=>', function()
  ---@diagnostic disable-next-line: param-type-mismatch
  pcall(vim.cmd, 'NoNeckPainWidthUp')
end, { desc = 'Increase window size', silent = true, noremap = true })
vim.keymap.set('n', '<leader>ts', function()
  ---@diagnostic disable-next-line: param-type-mismatch
  pcall(vim.cmd, 'NoNeckPainScratchPad')
end, { desc = "[T]oggle [S]hratchpad with today's note", silent = true, noremap = true })

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

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('q-close-help', { clear = true }),
  pattern = { 'help', 'man' },
  desc = 'Use q to close the window',
  command = 'nnoremap <buffer> q <cmd>quit<cr>',
})

--[
-- This is my first plugin made with a TJ help
-- It's opening a terminal attached at the bottom with <leader>tt combination
--]

-- INFO: [[TERMINAL]] terminal opening helpers

local term_buf = nil

local open_terminal = function()
  if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
    local winid = vim.fn.bufwinid(term_buf)

    if winid ~= -1 and vim.api.nvim_win_is_valid(winid) then
      local winnum = vim.fn.bufwinnr(term_buf)
      vim.cmd(string.format('%dwincmd w', winnum))
    else
      -- buffer hidden reopen in bottom split
      -- botright opens bottom split, sbuffer open buffer in split
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

-- INFO: [[TERMINAL]] keymaps and auto-commands

vim.api.nvim_create_augroup('custom-term-open', { clear = true })

vim.api.nvim_create_autocmd('TermOpen', {
  group = 'custom-term-open',
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
    vim.cmd 'startinsert'
  end,
  desc = 'Disable numbers in terminal',
})

vim.api.nvim_create_autocmd('TermOpen', {
  group = 'custom-term-open',
  desc = 'Close terminal with q',
  command = 'map <buffer> q <cmd>quit<cr>',
})

vim.keymap.set('n', '<leader>tt', open_terminal, { desc = '[T]oggle [T]erminal' })
