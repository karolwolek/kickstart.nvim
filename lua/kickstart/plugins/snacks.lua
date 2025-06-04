-- lazy.nvim
return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      image = {
        doc = {
          enabled = true,
          inline = true,
          float = false,
          max_width = 80,
          max_height = 40,
          conceal = false,
        },
      },
    },
  },
}
