-- LSP Plugins
-- NOTE: some of these config use MariaSolOS' as inspiration
-- https://github.com/MariaSolOs/dotfiles/tree/main/.config/nvim
return {
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    'mason-org/mason.nvim',
    opts = {},
    dependencies = {
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'saghen/blink.cmp',
    },
    config = function()
      require('mason').setup()

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
          map('grr', require('fzf-lua').lsp_references, '[G]oto [R]eferences')
          map('gri', require('fzf-lua').lsp_implementations, '[G]oto [I]mplementation')
          map('grd', require('fzf-lua').lsp_definitions, '[G]oto [D]efinition')
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('gO', require('fzf-lua').lsp_document_symbols, 'Open Document Symbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('gW', require('fzf-lua').lsp_workspace_symbols, 'Open Workspace Symbols')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('grt', require('fzf-lua').lsp_typedefs, '[G]oto [T]ype Definition')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method('textDocument/documentHighlight', event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })
            -- When you move your cursor, the highlights will be cleared
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

          -- This may be unwanted, since they displace some of your code
          if client and client:supports_method('textDocument/inlayHint', event.buf) then
            map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- expand global capabilities
      local capabilities = require('blink.cmp').get_lsp_capabilities(nil, true)
      vim.lsp.config('*', { capabilities = capabilities })

      local servers_to_install = {
        clangd = {},
        gopls = {},
        pyright = {},
        rust_analyzer = {},
        lua_ls = {},
        ts_ls = {},
      }

      local ensure_installed = vim.tbl_keys(servers_to_install or {})
      vim.list_extend(ensure_installed, {
        -- add any other tools we want from mason
        stylua = {},
        { 'golangci-lint' },
        biome = {
          -- TODO: make biome autocompletions and suggestions work for ts, js, tsx, jsx files instead of ts_ls
          -- NOTE right now doing npm i -g @biomejs/biome activates lsp client, but completions/suggestions
          -- dont work
          -- I need this here if I want conform formatting to work using biome for ts, tsx, js jsx files.
          -- Another option is doing npm intall -g @biomejs/biome and commething this biome server
          -- to have the formatter work too, and then uninstall from mason
          -- cmd = { 'biome', 'lsp-proxy' },
          -- root_dir = require('lspconfig').util.root_pattern('package.json', '.git'),
        },
      })
      -- NOTE: check lsp logs for errors
      -- :lua vim.cmd.edit(vim.lsp.get_log_path())
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      -- Get filenames in lsp/*.lua and transform them to table to enable them
      local servers = vim.iter(vim.api.nvim_get_runtime_file('lsp/*.lua', true)):map(function(file) return vim.fn.fnamemodify(file, ':t:r') end):totable()
      vim.lsp.enable(servers)

      -- In case you want to install an lsp directly on your system, you;ll need to configure it and enable it manually
      -- local system_installed_servers = {
      --   clangd = {},
      -- }
      --
      -- for system_server_name, system_server_config in pairs(system_installed_servers) do
      --   local server_config = system_server_config or {}
      --   server_config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server_config.capabilities or {})
      --   vim.lsp.config(system_server_name, server_config)
      --   vim.lsp.enable(system_server_name)
      -- end
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
