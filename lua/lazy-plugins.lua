require('lazy').setup({
  -- NOTE: This plugin requires no configuration
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  'bullets-vim/bullets.vim',

  require 'kickstart/plugins/gitsigns',

  require 'kickstart/plugins/which-key',

  require 'kickstart/plugins/telescope',

  require 'kickstart/plugins/lspconfig',

  require 'kickstart/plugins/conform',

  require 'kickstart/plugins/tokyonight',

  require 'kickstart/plugins/todo-comments',

  require 'kickstart/plugins/mini',

  require 'kickstart/plugins/treesitter',

  require 'kickstart/plugins/context',

  require 'kickstart/plugins/autocompletion',

  require 'kickstart/plugins/obsidian',

  require 'kickstart/plugins/render-markdown',

  -- require 'kickstart.plugins.debug',

  require 'kickstart.plugins.indent_line',

  require 'kickstart.plugins.lint',

  -- require 'kickstart.plugins.autopairs',

  require 'kickstart.plugins.neo-tree',
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- vim: ts=2 sts=2 sw=2 et
