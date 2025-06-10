-- lazy.nvim
return {
  {
    'folke/snacks.nvim',
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
      dashboard =
        ---@class snacks.dashboard.Config
        {
          width = 60,
          row = nil, -- dashboard position. nil for center
          col = nil, -- dashboard position. nil for center
          pane_gap = 4, -- empty columns between vertical panes
          autokeys = '1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', -- autokey sequence
          -- These settings are used by some built-in sections
          preset = {
            pick = 'telescope.nvim',
            keys = {
              { icon = ' ', key = 'f', desc = 'Find File', action = ":lua Snacks.dashboard.pick('files')" },
              { icon = ' ', key = 'N', desc = 'New File', action = ':ene | startinsert' },
              { icon = ' ', key = 'r', desc = 'Recent Files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
              {
                icon = '󰂺 ',
                key = 'n',
                desc = 'Search Notes',
                action = function()
                  if package.loaded['obsidian'] == nil then
                    require('lazy').load { plugins = { 'obsidian.nvim' } }
                  end
                  vim.cmd 'Obsidian quick_switch'
                end,
              },
              {
                icon = '󰓹 ',
                key = 't',
                desc = 'Notes tags',
                action = function()
                  if package.loaded['obsidian'] == nil then
                    require('lazy').load { plugins = { 'obsidian.nvim' } }
                  end
                  vim.cmd 'Obsidian tags'
                end,
              },
              {
                icon = '󰃶 ',
                key = 'd',
                desc = 'Open daily notes',
                action = function()
                  if package.loaded['obsidian'] == nil then
                    require('lazy').load { plugins = { 'obsidian.nvim' } }
                  end
                  require('kickstart.obutils').search_inbox()
                end,
              },
              {
                icon = ' ',
                key = 'i',
                desc = 'Search inbox',
                action = function()
                  if package.loaded['obsidian'] == nil then
                    require('lazy').load { plugins = { 'obsidian.nvim' } }
                  end
                  require('kickstart.obutils').search_inbox()
                end,
              },
              { icon = ' ', key = 'c', desc = 'Config', action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
              { icon = '󰒲 ', key = 'L', desc = 'Lazy', action = ':Lazy', enabled = package.loaded.lazy ~= nil },
              { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
            },
            header = [[
██████╗  █████╗   ███╗  ██╗ █████╗ ████████╗
██╔══██╗██╔══██╗  ████╗ ██║██╔══██╗╚══██╔══╝
██║  ██║██║  ██║  ██╔██╗██║██║  ██║   ██║   
██║  ██║██║  ██║  ██║╚████║██║  ██║   ██║   
██████╔╝╚█████╔╝  ██║ ╚███║╚█████╔╝   ██║   
╚═════╝  ╚════╝   ╚═╝  ╚══╝ ╚════╝    ╚═╝   

 ██████╗ ██╗██╗   ██╗███████╗  ██╗   ██╗██████╗ 
██╔════╝ ██║██║   ██║██╔════╝  ██║   ██║██╔══██╗
██║  ██╗ ██║╚██╗ ██╔╝█████╗    ██║   ██║██████╔╝
██║  ╚██╗██║ ╚████╔╝ ██╔══╝    ██║   ██║██╔═══╝ 
╚██████╔╝██║  ╚██╔╝  ███████╗  ╚██████╔╝██║     
 ╚═════╝ ╚═╝   ╚═╝   ╚══════╝   ╚═════╝ ╚═╝     
          ]],
          },
          formats = {
            icon = function(item)
              if item.file and item.icon == 'file' or item.icon == 'directory' then
                return M.icon(item.file, item.icon)
              end
              return { item.icon, width = 2, hl = 'icon' }
            end,
            footer = { '%s', align = 'center' },
            header = { '%s', align = 'center' },
            file = function(item, ctx)
              local fname = vim.fn.fnamemodify(item.file, ':~')
              fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
              if #fname > ctx.width then
                local dir = vim.fn.fnamemodify(fname, ':h')
                local file = vim.fn.fnamemodify(fname, ':t')
                if dir and file then
                  file = file:sub(-(ctx.width - #dir - 2))
                  fname = dir .. '/…' .. file
                end
              end
              local dir, file = fname:match '^(.*)/(.+)$'
              return dir and { { dir .. '/', hl = 'dir' }, { file, hl = 'file' } } or { { fname, hl = 'file' } }
            end,
          },
          sections = {
            { section = 'header' },
            { section = 'keys', gap = 1, padding = 1 },
            { section = 'startup' },
          },
        },
    },
  },
}
