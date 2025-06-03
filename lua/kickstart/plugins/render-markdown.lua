return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = {
      'echasnovski/mini.nvim',
      'nvim-tree/nvim-web-devicons',
      'nvim-treesitter/nvim-treesitter',
    },

    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      completions = { lsp = { enabled = true } },
      checkbox = {
        enabled = true,
        render_modes = false,
        right_pad = 1,
        unchecked = {
          icon = '󰄱 ',
          highlight = 'RenderMarkdownUnchecked',
          scope_highlight = nil,
        },
        checked = {
          icon = ' ',
          highlight = 'RenderMarkdownChecked',
          scope_highlight = nil,
        },
        -- Define custom checkbox states, more involved, not part of the markdown grammar.
        -- As a result this requires neovim >= 0.10.0 since it relies on 'inline' extmarks.
        -- The key is for healthcheck and to allow users to change its values, value type below.
        -- | raw             | matched against the raw text of a 'shortcut_link'           |
        -- | rendered        | replaces the 'raw' value when rendering                     |
        -- | highlight       | highlight for the 'rendered' icon                           |
        -- | scope_highlight | optional highlight for item associated with custom checkbox |
        -- stylua: ignore
        custom = {
            todo = { raw = '[-]', rendered = '󰥔 ', highlight = 'RenderMarkdownTodo', scope_highlight = nil },
            important = { raw = '[!]', rendered = '', highlight = 'RenderMarkdownError', scope_highlight = nil },
            arrow = { raw = '[>]', rendered = '', highlight = 'RenderMarkdownTodo', scope_highlight = nil},
            tilde = { raw = '[~]', rendered = '󰰱', highlight = 'RenderMarkdownWarn', scope_highlight = nil},
        },
      },
      indent = {
        -- Mimic org-indent-mode behavior by indenting everything under a heading based on the
        -- level of the heading. Indenting starts from level 2 headings onward by default.

        -- Turn on / off org-indent-mode.
        enabled = true,
        -- Additional modes to render indents.
        render_modes = false,
        -- Amount of additional padding added for each heading level.
        per_level = 4,
        -- Heading levels <= this value will not be indented.
        -- Use 0 to begin indenting from the very first level.
        skip_level = 1,
        -- Do not indent heading titles, only the body.
        skip_heading = false,
        -- Prefix added when indenting, one per level.
        icon = '▎',
        -- Applied to icon.
        highlight = 'RenderMarkdownIndent',
      },
      latex = {
        enabled = false,
      },
    },
  },
}
