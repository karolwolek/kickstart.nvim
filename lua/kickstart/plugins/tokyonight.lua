return {
  {
    -- INFO: Colorscheme config

    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
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
