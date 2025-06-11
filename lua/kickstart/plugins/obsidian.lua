return {
  {
    'obsidian-nvim/obsidian.nvim',

    -- TODO: track release for resolved issues with folds etc.
    tag = 'v3.11.0',

    -- attach obsidian only when entering one of the vault's buffers
    event = {
      'BufEnter ' .. vim.fn.expand '~' .. '/Documents/myvault/*.md',
      'BufNewFile ' .. vim.fn.expand '~' .. '/Documents/myvault/*.md',
    },

    -- attach obsidian on one of the commands call
    cmd = 'Obsidian',

    opts = {
      workspaces = {
        {
          name = 'notes',
          path = '/home/karolwolek/Documents/myvault',
        },
      },
      log_level = vim.log.levels.INFO,

      -- [[ new notes location; inbox system ]]
      notes_subdir = 'inbox/',
      new_notes_location = 'notes_subdir',

      -- [[ my custom field for trash]]
      --
      -- The reason for this is to have some place to put discarded note into
      -- rather than deleting it. It's a safety feature for unwanted actions.
      trash_dir = '.trash',

      -- [[ use blink and fire it immediately ]]
      completion = {
        blink = true,
        nvim_cmp = false,
        min_chars = 0,
      },
      -- [[ configure daily notes with default template ]]
      daily_notes = {
        folder = 'notes/dailies',
        date_format = '%Y-%m-%d',
        alias_format = '%-d %B, %Y',
        default_tags = { 'pim', 'daily-notes' },
        template = 'daily.md',
        workdays_only = true,
      },

      -- [[ templates location and placeholders]]
      --
      -- I can add some custom placeholders
      templates = {
        folder = 'templates',
        date_format = '%Y-%m-%d',
        time_format = '%H:%M',
      },

      -- [[ mappings ]]
      --
      -- Some mappings get attached to a certain buffer,
      -- some mappings are using my custom obutils for several note taking system parts.
      --
      -- The reason they are defined here is that obsidian
      -- is managing autocmds with buffer attached mappings itself
      -- so i don't need to deal with checking whether the buffer
      -- is a part of the workspace or not
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
        ['<M-p>'] = {
          action = require('kickstart.obutils').paste_image_custom,
          opts = { buffer = true, expr = false, noremap = true, desc = '[P]aste image without default' },
        },
        -- paste image with default name
        ['<M-P>'] = {
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

      -- [[ note naming function]]
      --
      -- It attaches the timestamp to each note with pattern 2004-06-16.
      -- If note name is not specified the title is random ( I do not use it since
      -- my custom functions require the title).
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

      -- [[links customization]]
      wiki_link_func = 'prepend_note_path', -- meaning e.g. '[[foo-bar.md|Foo Bar]]'
      preferred_link_style = 'markdown', -- Either 'wiki' or 'markdown'.

      -- [[ open links in firefox ]]
      follow_url_func = function(url)
        vim.ui.open(url, { cmd = { 'firefox' } })
      end,

      -- [[ open images as a regular buffer ]]
      follow_img_func = function(img)
        vim.cmd { cmd = 'edit', args = { img } }
      end,

      -- [[ callbacks]]
      --
      -- Various actions for scripting during obsidian lifecycle.
      --
      -- Currently after entering the buffer i set custom `resolve` function for images
      -- in snacks because of the relative to the vault link setup.
      -- After leaving the note i schedule the job to nullify the `resolve`.
      -- Scheduling allows me to avoid the situation while snacks is still trying to render
      -- while i am interfering with config.
      --
      -- Second autocmds is for tag highlight. render-markdown is not detecting these properly
      -- and i need to have obisidan ui off due to incompatibility issues.
      callbacks = {
        ---@param client obsidian.Client
        enter_note = function(client, _)
          -- image snacks
          require('snacks.image').config.resolve = function(_, src)
            local workspace_path = client.current_workspace.path:resolve()
            local img_path = workspace_path:joinpath(src):resolve()
            return img_path.filename
          end
          -- Tag highlighting
          vim.cmd 'highlight myTag guifg=#71d4eb'
          vim.cmd 'match myTag /#[0-9]*[a-zA-Z_\\-\\/][a-zA-Z_\\-\\/0-9]*/'
        end,
        leave_note = function(_, _)
          -- image snacks
          vim.schedule(function()
            require('snacks.image').config.resolve = nil
          end)
          -- Tag highlighting
          vim.cmd 'highlight clear myTag'
        end,
      },

      -- [[ UI ]]
      --
      -- Disable the obsidian UI because of the incompatibility
      -- with render-markdown plugin
      ui = {
        enable = false,
      },

      -- [[ attachments ]]
      --
      -- Set default images folder,
      -- disable pasting confirmation and set custom filename function
      -- that properly renames the file to attach timestamps and prepares
      -- a string with just the name to inject in the text with a pattern:
      -- [this is example](images/this-is-example-20250616145425.jpg)
      attachments = {
        img_folder = '/home/karolwolek/Documents/myvault/images/',
        confirm_img_paste = false,
        img_text_func = function(client, path)
          local name = path.stem
          local path_with_timestamp = path.new(path:parent().filename)
          path_with_timestamp = path_with_timestamp:joinpath(path.stem .. os.date '-%Y%m%d%H%M%S' .. path.suffix)
          local target_file_name = string.gsub(path_with_timestamp.filename, ' ', '-')
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

      -- [[ status line integration ]]
      --
      -- This custom status line gets transferred to mini.statusline
      -- and is handled there accordingly.
      statusline = {
        enabled = true,
        format = '{{backlinks}} backlinks  {{properties}} properties  {{words}} words  {{chars}} chars',
      },
    },
  },
}
