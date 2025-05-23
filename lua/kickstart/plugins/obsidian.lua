return {
  {
    'obsidian-nvim/obsidian.nvim',
    version = '*',
    lazy = true,
    event = {
      'BufReadPre ' .. vim.fn.expand '~' .. '/Documents/myvault/*.md',
      'BufNewFile ' .. vim.fn.expand '~' .. '/Documents/myvault/*.md',
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'saghen/blink.cmp',
      'nvim-treesitter',
    },
    opts = {
      -- When obsidian.nvim is loaded by your plugin manager, it will automatically set
      -- the workspace to the first workspace in the list whose `path` is a parent of the
      -- current markdown file being edited.
      workspaces = {

        -- INFO: [[ MAIN VAULT ]]
        {
          name = 'notes',
          path = '/home/karolwolek/Documents/myvault',
        },
      },

      -- Optional, set the log level for obsidian.nvim. This is an integer corresponding to one of the log
      -- levels defined by "vim.log.levels.*".
      log_level = vim.log.levels.INFO,

      notes_subdir = 'inbox/',
      new_notes_location = 'notes_subdir',

      -- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
      completion = {
        blink = true,
        -- migrated to blink
        nvim_cmp = false,
        -- Trigger completion at 2 chars.
        min_chars = 2,
      },

      -- Optional, configure key mappings. These are the defaults. If you don't want to set any keymappings this
      -- way then set 'mappings = {}'.
      mappings = {
        -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
        ['grf'] = {
          action = function()
            return require('obsidian').util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true, desc = 'Follow markdown/wiki links within my vault' },
        },
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
          action = function()
            local client = require('obsidian').get_client()
            local picker = assert(client:picker())
            picker:find_files {
              prompt_title = 'Notes in the inbox',
              dir = '/home/karolwolek/Documents/myvault/inbox/',
            }
          end,
          opts = { buffer = false, expr = false, noremap = true, desc = '[S]earch [I]nbox notes' },
        },
        -- open a new note
        ['<leader>nn'] = {
          action = function()
            local width = 40
            local height = 1

            local col = math.floor((vim.o.columns - width) / 2)
            local row = math.floor((vim.o.lines - height) / 2)

            local buf = vim.api.nvim_create_buf(false, true)

            local win_config = {
              relative = 'editor',
              width = width,
              height = height,
              col = col,
              row = row,
              style = 'minimal',
              border = 'rounded',
              title = ' Enter the note title ',
              title_pos = 'center',
            }

            local win = vim.api.nvim_open_win(buf, true, win_config)

            vim.cmd 'startinsert'

            -- accept the title for the note with <enter>
            vim.keymap.set('i', '<CR>', function()
              local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
              local title = lines[1] or ''
              if title == '' then
                print 'Please enter a note title'
                return
              end

              vim.api.nvim_win_close(win, true)

              vim.cmd { cmd = 'ObsidianNew', args = { title } }
              vim.cmd 'stopinsert'
            end, { buffer = buf, noremap = true, silent = true })

            -- with <ESC> close the floating window
            vim.keymap.set('i', '<ESC>', function()
              vim.api.nvim_win_close(win, true)
              vim.cmd 'stopinsert'
            end, { buffer = buf, noremap = true, silent = false })
          end,
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
          action = function()
            local client = require('obsidian').get_client()
            local bufer = vim.api.nvim_get_current_buf()
            local note = client:current_note(bufer)

            if not note then
              print 'There are currently no notes open'
              return
            end

            local notes_subdir = client.opts.notes_subdir
            local expected_path = client.current_workspace.path:joinpath(notes_subdir):joinpath(note.path.name)

            if note.path ~= expected_path then
              print 'Not in the inbox'
              return
            end

            if not note.tags or #note.tags == 0 then
              print 'No tags found'
              return
            end

            local target_tag = note.tags[1]
            local target_name = note.path.name:gsub('inbox', '')
            local target_path = client.current_workspace.path:joinpath 'notes'

            if target_tag:find '^projects' then
              target_path = target_path:joinpath('projects', target_name)
            elseif target_tag:find '^areas' then
              target_path = target_path:joinpath('areas', target_name)
            elseif target_tag:find '^resources' then
              target_path = target_path:joinpath('resources', target_name)
            elseif target_tag:match '^archives' then
              print 'Cannot accept into archive'
              return
            else
              print 'Please attach a base tag out of "projects", "areas", "resources" as a first tag'
              return
            end

            -- Ensure the target directory exists
            local target_dir = target_path:parent()
            if not target_dir then
              print 'Error with resolving target directory'
              return
            end

            if not vim.fn.isdirectory(target_dir.filename) then
              vim.fn.mkdir(target_dir.filename, 'p')
            end

            -- try to move the file
            local success, err = pcall(function()
              os.rename(note.path.filename, target_path.filename)
            end)

            if success then
              vim.api.nvim_buf_delete(bufer, { force = true })
              print('Note moved to: ' .. target_path.filename)
              client:open_note(target_path.filename)
            else
              print('Error moving note: ' .. (err or 'Unknown error'))
            end
          end,
          opts = { buffer = true, expr = false, noremap = true, desc = '[N]ote [A]ccept' },
        },
      },

      -- Optional, customize how note IDs are generated given an optional title.
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

      -- Optional, customize how note file names are generated given the ID, target directory, and title.
      ---@param spec { id: string, dir: obsidian.Path, title: string|? }
      ---@return string|obsidian.Path The full path to the new note.
      note_path_func = function(spec)
        -- This is equivalent to the default behavior.
        local path = spec.dir / tostring(spec.id)
        return path:with_suffix '.md'
      end,

      wiki_link_func = 'prepend_note_path',

      -- Optional, customize how markdown links are formatted.
      markdown_link_func = function(opts)
        return require('obsidian.util').markdown_link(opts)
      end,

      -- Either 'wiki' or 'markdown'.
      preferred_link_style = 'wiki',

      -- Optional, boolean or a function that takes a filename and returns a boolean.
      -- `true` indicates that you don't want obsidian.nvim to manage frontmatter.
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

      -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
      -- URL it will be ignored but you can customize this behavior here.
      ---@param url string
      follow_url_func = function(url)
        -- Open the URL in the default web browser.
        -- vim.fn.jobstart { 'open', url } -- Mac OS
        vim.fn.jobstart { 'xdg-open', url } -- linux
        -- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
        -- vim.ui.open(url) -- need Neovim 0.10.0+
      end,

      -- Optional, by default when you use `:ObsidianFollowLink` on a link to an image
      -- file it will be ignored but you can customize this behavior here.
      ---@param img string
      follow_img_func = function(img)
        -- vim.fn.jobstart { 'qlmanage', '-p', img } -- Mac OS quick look preview
        vim.fn.jobstart { 'xdg-open', url } -- linux
        -- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
      end,

      -- Disable the obsidian UI because of the incompatible ui
      -- with render-markdown plugin
      ui = {
        enable = false,
      },

      -- Specify how to handle attachments.
      attachments = {
        -- The default folder to place images in via `:Obsidian pasteimg`.
        -- If this is a relative path it will be interpreted as relative to the vault root.
        -- You can always override this per image by passing a full path to the command instead of just a filename.
        img_folder = '/home/karolwolek/Documents/myvault/images/',
      },
    },
  },
}
