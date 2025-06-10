return {
  {
    'obsidian-nvim/obsidian.nvim',
    tag = 'v3.11.0',
    -- lazy = true,
    event = {
      'BufEnter ' .. vim.fn.expand '~' .. '/Documents/myvault/*.md',
      'BufNewFile ' .. vim.fn.expand '~' .. '/Documents/myvault/*.md',
    },
    cmd = 'Obsidian',
    opts = {
      workspaces = {
        {
          name = 'notes',
          path = '/home/karolwolek/Documents/myvault',
        },
      },
      log_level = vim.log.levels.INFO,
      notes_subdir = 'inbox/',
      new_notes_location = 'notes_subdir',
      trash_dir = '.trash',
      completion = {
        blink = true,
        nvim_cmp = false,
        min_chars = 0,
      },
      daily_notes = {
        folder = 'notes/dailies',
        date_format = '%Y-%m-%d',
        alias_format = '%-d %B, %Y',
        default_tags = { 'pim', 'daily-notes' },
        template = 'daily.md',
        workdays_only = true,
      },
      templates = {
        folder = 'templates',
        date_format = '%Y-%m-%d',
        time_format = '%H:%M',
      },
      mappings = {
        -- Toggle check-boxes.
        ['<leader>ch'] = {
          action = function()
            return require('obsidian').util.toggle_checkbox()
          end,
          opts = { buffer = true, desc = 'Toggle check-box' },
        },
        -- Smart action depending on context, either follow link or toggle checkbox.
        ['<cr>'] = {
          action = function()
            return require('obsidian').util.smart_action()
          end,
          opts = { buffer = true, expr = true, desc = 'Obsidian smart action' },
        },
        -- search for tags in current vault
        ['<leader>st'] = {
          action = function()
            return '<cmd>Obsidian tags<CR>'
          end,
          opts = { buffer = false, expr = true, noremap = true, desc = '[S]earch [T]ags' },
        },
        -- search for notes in current vault
        ['<leader>sn'] = {
          action = function()
            return '<cmd>Obsidian quick_switch<CR>'
          end,
          opts = { buffer = false, expr = true, noremap = true, desc = '[S]earch [N]otes' },
        },
        -- search for notes in the inbox
        ['<leader>si'] = {
          action = require('kickstart.obutils').search_inbox,
          opts = { buffer = false, expr = false, noremap = true, desc = '[S]earch [I]nbox notes' },
        },
        -- open a new note
        ['<leader>nn'] = {
          action = require('kickstart.obutils').open_new_note,
          opts = { buffer = false, expr = false, noremap = true, desc = '[N]ote [N]ew' },
        },
        -- open links for this note
        ['<leader>nl'] = {
          action = function()
            return '<cmd>Obsidian links<cr>'
          end,
          opts = { buffer = true, expr = true, noremap = true, desc = '[N]ote [L]inks' },
        },
        -- open backlinks for this note
        ['<leader>nb'] = {
          action = function()
            return '<cmd>Obsidian backlinks<cr>'
          end,
          opts = { buffer = true, expr = true, noremap = true, desc = '[N]ote [B]acklinks' },
        },
        -- accept the note from the inbox
        ['<leader>na'] = {
          action = require('kickstart.obutils').accept_inbox_note,
          opts = { buffer = true, expr = false, noremap = true, desc = '[N]ote [A]ccept' },
        },
        -- paste image without default name
        ['<M-P>'] = {
          action = require('kickstart.obutils').paste_image_custom,
          opts = { buffer = true, expr = false, noremap = true, desc = '[P]aste image without default' },
        },
        -- paste image with default name
        ['<M-p>'] = {
          action = require('kickstart.obutils').paste_image_default,
          opts = { buffer = true, expr = false, noremap = true, desc = '[P]aste image with default name' },
        },
        -- open dailies with picker
        ['<leader>nd'] = {
          action = function()
            return '<cmd>Obsidian dailies<cr>'
          end,
          opts = { buffer = false, expr = true, noremap = true, desc = '[N]ote [D]ailes' },
        },
        -- open yesterdays note
        ['<leader>ny'] = {
          action = function()
            return '<cmd>Obsidian yesterday<cr>'
          end,
          opts = { buffer = false, expr = true, noremap = true, desc = '[N]ote [Y]esterday' },
        },
        -- open todays note
        ['<leader>nt'] = {
          action = function()
            return '<cmd>Obsidian today<cr>'
          end,
          opts = { buffer = false, expr = true, noremap = true, desc = '[N]ote [T]oday' },
        },
      },
      ---@param title string|?
      ---@return string
      note_id_func = function(title)
        local suffix = ''
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          suffix = title:gsub(' ', '_'):lower()
        else
          -- If title is nil, just add 4 random uppercase letters to the suffix.
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.date '%Y-%m-%d') .. '_' .. suffix
      end,
      wiki_link_func = 'prepend_note_path',
      -- Optional, customize how markdown links are formatted.
      markdown_link_func = function(opts)
        return require('obsidian.util').markdown_link(opts)
      end,
      preferred_link_style = 'wiki',
      disable_frontmatter = false,

      -- Optional, alternatively you can customize the frontmatter data.
      ---@return table
      note_frontmatter_func = function(note)
        -- Add the title of the note as an alias.
        if note.title then
          note:add_alias(note.title)
        end

        local out = { id = note.id, aliases = note.aliases, tags = note.tags }

        -- `note.metadata` contains any manually added fields in the frontmatter.
        -- So here we just make sure those fields are kept in the frontmatter.
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end

        return out
      end,

      follow_url_func = function(url)
        vim.fn.jobstart { 'xdg-open', url } -- linux
      end,

      follow_img_func = function(img)
        vim.fn.jobstart { 'xdg-open', img } -- linux
      end,

      callbacks = {
        enter_note = function(_, _)
          -- Tag highlighting
          vim.cmd 'highlight myTag guifg=#71d4eb'
          vim.cmd 'match myTag /#[0-9]*[a-zA-Z_\\-\\/][a-zA-Z_\\-\\/0-9]*/'
        end,
        leave_note = function(_, _)
          -- Tag highlighting
          vim.cmd 'highlight clear myTag'
        end,
      },
      -- Disable the obsidian UI because of the incompatibility with render-markdown plugin
      ui = {
        enable = false,
      },

      attachments = {
        img_folder = '/home/karolwolek/Documents/myvault/images/',
        confirm_img_paste = false,
        img_name_func = function()
          return string.format('Pasted image %s', os.date '%Y%m%d%H%M%S')
        end,

        ---@param client obsidian.Client
        ---@param path obsidian.Path the absolute path to the image file
        ---@return string
        img_text_func = function(client, path)
          local name = path.stem
          local target_file_name = string.gsub(path.filename, ' ', '-')
          local success, err = pcall(function()
            os.rename(path.filename, target_file_name)
          end)
          if not success then
            print(err)
          end
          path = path.new(target_file_name)
          path = client:vault_relative_path(path) or path
          return string.format('![%s](%s)', name, path)
        end,
      },
      statusline = {
        enabled = true,
        format = '{{backlinks}} backlinks  {{properties}} properties  {{words}} words  {{chars}} chars',
      },
    },
  },
}
