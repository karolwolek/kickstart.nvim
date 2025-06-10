return {
  'bullets-vim/bullets.vim',
  config = function()
    vim.g.bullets_outline_levels = { 'num', 'num', 'num' }
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('bulletsIndent', { clear = true }),
      pattern = { 'markdown', 'text' },
      callback = function()
        vim.opt_local_shiftwidth = 4
        vim.opt_local.softtabstop = 4
        vim.opt_local.expandtab = true
      end,
    })
  end,
}
