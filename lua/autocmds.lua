-- NOTE: [[ obsidian with mini statusline ]]
-- ============================================================================
--
-- vim.api.nvim_create_autocmd('BufEnter', {
--   pattern = '*.md',
--   group = vim.api.nvim_create_augroup('obsidian-statusline', { clear = true }),
--   callback = function()
--     local statusline_config = require('mini.statusline').config
--     local original_file_section = statusline_config.section_fileinfo
--     statusline_config.section_fileinfo = function(args)
--       if package.loaded['obsidian'] ~= nil then
--         local client = require('obsidian').get_client()
--         local current_path = vim.api.nvim_buf_get_name(0)
--         if client:path_is_note(current_path) then
--           return vim.g.obsidian
--         else
--           return original_file_section(args)
--         end
--       end
--     end
--     require('mini.statusline').setup(statusline_config)
--   end,
--   once = true,
-- })

-- -- NOTE: [[ Load render-markdown with some lag]]
--
-- vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile', 'BufWritePre' }, {
--   pattern = '*.md',
--   group = vim.api.nvim_create_augroup('render-markdown-schedule', { clear = true }),
--   callback = vim.schedule_wrap(function()
--     require 'render-markdown'
--   end),
-- })

-- NOTE: [[ lsp autocommands ]]
-- ============================================================================
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    -- Rename the variable under your cursor.
    --  Most Language Servers support renaming across files, etc.
    map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

    -- Execute a code action, usually your cursor needs to be on top of an error
    -- or a suggestion from your LSP for this to activate.
    map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

    -- Find references for the word under your cursor.
    map('grr', '<cmd>Telescope lsp_references<cr>', '[G]oto [R]eferences')

    -- Jump to the implementation of the word under your cursor.
    --  Useful when your language has ways of declaring types without an actual implementation.
    map('gri', '<cmd>Telescope lsp_implementations<cr>', '[G]oto [I]mplementation')

    -- Jump to the definition of the word under your cursor.
    --  This is where a variable was first declared, or where a function is defined, etc.
    --  To jump back, press <C-t>.
    map('grd', '<cmd>Telescope lsp_definitions<cr>', '[G]oto [D]efinition')

    map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    -- Fuzzy find all the symbols in your current document.
    --  Symbols are things like variables, functions, types, etc.
    map('gO', '<cmd>Telescope lsp_document_symbols<cr>', 'Open Document Symbols')

    -- Fuzzy find all the symbols in your current workspace.
    --  Similar to document symbols, except searches over your entire project.
    map('gW', '<cmd>Telescope lsp_dynamic_workspace_symbols<cr>', 'Open Workspace Symbols')

    -- Jump to the type of the word under your cursor.
    --  Useful when you're not sure what type a variable is and you want to see
    --  the definition of its *type*, not where it was *defined*.
    map('grt', '<cmd>Telescope lsp_type_definitions<cr>', '[G]oto [T]ype Definition')

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
        end,
      })
    end

    -- The following code creates a keymap to toggle inlay hints in your
    -- code, if the language server you are using supports them
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
      map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, '[T]oggle Inlay [H]ints')
    end
  end,
})
