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
    require('no-neck-pain').setup {
      width = 100,
      autocmds = {
        enableOnVimEnter = false,
      },
      mappings = {
        enabled = false,
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
      },
    }
  end,
}
