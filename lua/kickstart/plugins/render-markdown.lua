return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'nvim-treesitter/nvim-treesitter',
    },
    event = {
      'BufReadPost *.md',
      'BufNewFile *.md',
      'BufEnter *.md',
    },
    opts = {
      enabled = true,
      completions = {
        blink = { enabled = true },
        filter = {
          callout = function(value)
            return value.category ~= 'obsidian'
          end,
        },
      },
      heading = {
        icons = { '󰎤 ', '󰎧 ', '󰎪 ', '󰎭 ', '󰎱 ', '󰎳 ' },
      },
      checkbox = {
        enabled = true,
        render_modes = false,
        right_pad = 1,
        unchecked = {
          icon = '󰄱 ',
          highlight = 'RenderMarkdownUnchecked',
        },
        checked = {
          icon = ' ',
          highlight = 'RenderMarkdownChecked',
          scope_highlight = '@markup.strikethrough',
        },
        custom = {
          todo = { raw = '[-]', rendered = '󰥔 ', highlight = 'RenderMarkdownTodo', scope_highlight = nil },
          important = { raw = '[!]', rendered = ' ', highlight = 'RenderMarkdownError', scope_highlight = nil },
          arrow = { raw = '[>]', rendered = ' ', highlight = 'RenderMarkdownTodo', scope_highlight = nil },
          tilde = { raw = '[~]', rendered = '󰰱 ', highlight = 'RenderMarkdownWarn', scope_highlight = nil },
        },
      },
      code = {
        width = 'block',
        min_width = 80,
      },
      indent = {
        enabled = false,
      },
      latex = {
        enabled = false,
      },
    },
  },
}
