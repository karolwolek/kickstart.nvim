return {
  {
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup {
        n_lines = 500,
      }

      -- Simple and easy statusline.
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- cursor location LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      --- obsidian status line (if workspace) OR filetype
      local original_file_section = statusline.section_fileinfo
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_fileinfo = function(args)
        if package.loaded['obsidian'] ~= nil then
          local client = require('obsidian').get_client()
          local current_path = vim.api.nvim_buf_get_name(0)
          if client:path_is_note(current_path) then
            return vim.g.obsidian
          end
        else
          return original_file_section(args)
        end
      end
    end,
  },
}
