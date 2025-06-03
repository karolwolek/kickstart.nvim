return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      local configs = require 'nvim-treesitter.configs'

      configs.setup {
        ensure_installed = {
          'bash',
          'c',
          'python',
          'javascript',
          'typescript',
          'diff',
          'html',
          'lua',
          'luadoc',
          'query',
          'vim',
          'vimdoc',
          'markdown',
          'markdown_inline',
          'css',
          'latex',
          'norg',
          'scss',
          'svelte',
          'tsx',
          'typst',
          'vue',
        },
        auto_install = true,
        highlight = {
          enable = true,
          -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
          --  If you are experiencing weird indenting issues, add the language to
          --  the list of additional_vim_regex_highlighting and disabled languages for indent.
          additional_vim_regex_highlighting = { 'ruby' },
        },
        indent = { enable = true, disable = { 'ruby' } },
      }
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
