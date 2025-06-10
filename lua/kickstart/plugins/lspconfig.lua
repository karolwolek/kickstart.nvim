return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' },
    dependencies = {
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'mason-org/mason.nvim', opts = {} },
      {
        'j-hui/fidget.nvim',
        opts = {},
        event = 'LspAttach', -- Only load when LSP actually attaches
      },
    },
    config = function()
      local servers = require('kickstart.lsp-servers').servers
      require('mason-tool-installer').setup {
        ensure_installed = vim.tbl_keys(servers),
      }
      require('mason-lspconfig').setup {
        automatic_enable = true,
        ensure_installed = {},
      }
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
