local M = {}

M.search_inbox = function()
  -- function redefinition for recursion
  -- after deleting the function is called again for refresh
  local function search_inbox()
    local client = require('obsidian').get_client()
    local picker = assert(client:picker())
    picker:find_files {
      prompt_title = 'Notes in the inbox',
      dir = '/home/karolwolek/Documents/myvault/inbox/',
      -- TODO: refactor for multiple selection
      selection_mappings = {
        ['<C-d>'] = {
          callback = function(note_or_path)
            ---@type obsidian.Note
            local note = require 'obsidian.note'
            if note.is_note_obj(note_or_path) then
              note = note
            else
              note = note.from_file(note_or_path)
            end

            local config_trash = client.opts.trash_dir -- config injected (trash_dir)
            local target_dir = client.current_workspace.path:joinpath(config_trash)
            if not target_dir then
              target_dir = client.current_workspace.path:joinpath '.trash'
            end
            if not target_dir:is_dir() then
              target_dir:mkdir()
            end

            local target_path = target_dir:joinpath(note.path.name)

            local success, err = pcall(function()
              os.rename(note.path.filename, target_path.filename)
            end)

            if success then
              print('Note moved to: ' .. target_path.filename)
              search_inbox()
            else
              print('Error moving note: ' .. (err or 'Unknown error'))
            end
          end,
          desc = 'Discard note',
          keep_open = true,
          allow_multiple = false,
        },
      },
    }
  end
  search_inbox()
end

M.open_new_note = function()
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
    vim.api.nvim_buf_delete(buf, { force = true })

    vim.cmd { cmd = 'ObsidianNew', args = { title } }
    vim.cmd 'stopinsert'
  end, { buffer = buf, noremap = true, silent = true })

  -- with <ESC> close the floating window
  vim.keymap.set('i', '<ESC>', function()
    vim.api.nvim_win_close(win, true)
    vim.cmd 'stopinsert'
  end, { buffer = buf, noremap = true, silent = false })
end

M.accept_inbox_note = function()
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
end

M.paste_image_custom = function()
  local client = require('obsidian').get_client()
  client.opts.attachments.img_name_func = nil
  local success, err = pcall(vim.cmd, 'Obsidian paste_img')
  if not success then
    print 'There is not image in the clipboard'
  end
end

M.paste_image_default = function()
  local client = require('obsidian').get_client()
  client.opts.attachments.img_name_func = function()
    return string.format('Pasted image %s', os.date '%Y%m%d%H%M%S')
  end
  local success, err = pcall(vim.cmd, 'Obsidian paste_img')
  if not success then
    print 'There is not image in the clipboard'
  end
end

return M
