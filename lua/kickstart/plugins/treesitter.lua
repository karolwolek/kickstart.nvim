return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
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
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },

    { -- Treesitter context
      'nvim-treesitter/nvim-treesitter-context',
      opts = {
        enable = true, -- Enable this plugin
        multiwindow = false, -- Enable multiwindow support
        max_lines = 0, -- No limit for how many lines the window should span
        min_window_height = 0, -- No limit for the minimum window height
        line_numbers = true, -- Show line numbers in the context
        multiline_threshold = 20, -- Maximum lines for a single context
        trim_scope = 'outer', -- Discard outer context if max_lines is exceeded
        mode = 'cursor', -- Context calculated based on cursor position
        separator = nil, -- No separator between context and content
        zindex = 20, -- Z-index for the context window
        on_attach = nil, -- Optional function to attach to the buffer
      },
    },
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },
}

-- vim: ts=2 sts=2 sw=2 et
