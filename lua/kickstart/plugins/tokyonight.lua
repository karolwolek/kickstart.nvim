return {
  {
    'folke/tokyonight.nvim',
    lazy = false, -- Load immediately
    priority = 1000, -- Load before other plugins
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        transparent = false,
        styles = {
          comments = { italic = true }, -- Disable italics in comments
        },
      }

      vim.cmd.colorscheme 'tokyonight-moon'
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
