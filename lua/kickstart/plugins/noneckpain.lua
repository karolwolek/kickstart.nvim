return {
  'shortcuts/no-neck-pain.nvim',
  version = '*',
  lazy = false,
  dependencies = {
    'epwalsh/obsidian.nvim', -- Make sure obsidian loads first
  },
  config = function()
    local function get_daily_note()
      local obClient = require('obsidian').get_client()
      return obClient:daily(0, { no_write = false, load = {
        load_contents = false,
      } }).path.filename
    end
    -- global width
    vim.g.nnwidth = 100

    local nnp = require 'no-neck-pain'
    nnp.setup {
      width = vim.g.nnwidth,
      autocmds = {
        enableOnVimEnter = false,
      },
      mappings = {
        enabled = false,
      },
      integrations = {
        -- @link https://github.com/nvim-neo-tree/neo-tree.nvim
        NeoTree = {
          -- The position of the tree.
          ---@type "left"|"right"
          position = 'left',
          -- When `true`, if the tree was opened before enabling the plugin, we will reopen it.
          reopen = true,
        },
      },
      buffers = {
        setNames = false,
        scratchPad = {
          enabled = false,
          pathToFile = get_daily_note(),
        },
        bo = {
          filetype = 'md',
        },
        right = {
          enabled = false,
        },
      },
    }
  end,
}
