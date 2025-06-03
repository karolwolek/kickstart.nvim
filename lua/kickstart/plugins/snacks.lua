-- lazy.nvim
return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      image =
        ---@class snacks.image.Config
        ---@field enabled? boolean enable image viewer
        ---@field wo? vim.wo|{} options for windows showing the image
        ---@field bo? vim.bo|{} options for the image buffer
        ---@field formats? string[]
        --- Resolves a reference to an image with src in a file (currently markdown only).
        --- Return the absolute path or url to the image.
        --- When `nil`, the path is resolved relative to the file.
        ---@field resolve? fun(file: string, src: string): string?
        ---@field convert? snacks.image.convert.Config
        {
          formats = {
            'png',
            'jpg',
            'jpeg',
            'gif',
            'bmp',
            'webp',
            'tiff',
            'heic',
            'avif',
            'mp4',
            'mov',
            'avi',
            'mkv',
            'webm',
            'pdf',
          },
          doc = {
            -- enable image viewer for documents
            -- a treesitter parser must be available for the enabled languages.
            enabled = true,
            -- render the image inline in the buffer
            -- if your env doesn't support unicode placeholders, this will be disabled
            -- takes precedence over `opts.float` on supported terminals
            inline = true,
            -- render the image in a floating window
            -- only used if `opts.inline` is disabled
            float = false,
            max_width = 80,
            max_height = 40,
          },
          -- icons used to show where an inline image is located that is
          -- rendered below the text.
          icons = {
            math = '󰪚 ',
            chart = '󰄧 ',
            image = ' ',
          },
          math = {
            enabled = true, -- enable math expression rendering
            -- in the templates below, `${header}` comes from any section in your document,
            -- between a start/end header comment. Comment syntax is language-specific.
            -- * start comment: `// snacks: header start`
            -- * end comment:   `// snacks: header end`
            typst = {
              tpl = [[
        #set page(width: auto, height: auto, margin: (x: 2pt, y: 2pt))
        #show math.equation.where(block: false): set text(top-edge: "bounds", bottom-edge: "bounds")
        #set text(size: 12pt, fill: rgb("${color}"))
        ${header}
        ${content}]],
            },
            latex = {
              font_size = 'Large', -- see https://www.sascha-frank.com/latex-font-size.html
              -- for latex documents, the doc packages are included automatically,
              -- but you can add more packages here. Useful for markdown documents.
              packages = { 'amsmath', 'amssymb', 'amsfonts', 'amscd', 'mathtools' },
              tpl = [[
        \documentclass[preview,border=0pt,varwidth,12pt]{standalone}
        \usepackage{${packages}}
        \begin{document}
        ${header}
        { \${font_size} \selectfont
          \color[HTML]{${color}}
        ${content}}
        \end{document}]],
            },
          },
        },
    },
  },
}
