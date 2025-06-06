-- lazy.nvim
return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      styles = {
        -- INFO: show top right of screen
        snacks_image = {
          relative = 'editor',
          col = -1,
        },
      },
      image = {
        doc = {
          enabled = true,
          inline = false,
          float = true,
          max_width = 80,
          max_height = 40,
          conceal = function(_, type)
            require('snacks').image.hover()
            return type == 'math'
          end,
        },
      },
    },
  },
}
