return {
  'ibhagwan/fzf-lua',
  -- optional for icon support
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  -- or if using mini.icons/mini.nvim
  -- dependencies = { "echasnovski/mini.icons" },
  opts = {},
  config = function()
    require('fzf-lua').setup {
      defaults = {
        git_icons = false,
        file_icons = false,
        color_icons = false,
      },
    }

    local get_open_filelist = function(cwd)
      local bufnrs = filter(function(b)
        if 1 ~= vim.fn.buflisted(b) then
          return false
        end
        return true
      end, vim.api.nvim_list_bufs())
      if not next(bufnrs) then
        return
      end

      local filelist = {}
      for _, bufnr in ipairs(bufnrs) do
        local file = vim.api.nvim_buf_get_name(bufnr)
        table.insert(filelist, Path:new(file):make_relative(cwd))
      end
      return filelist
    end

    local builtin = require 'fzf-lua'
    vim.keymap.set('n', '<leader>sh', builtin.helptags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>sf', builtin.files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect FzfLua' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_cword, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_cWORD, { desc = '[S]earch current [W]ORD' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by Live[G]rep' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics_document, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

    -- Slightly advanced example of overriding default behavior and theme
    vim.keymap.set('n', '<leader>/', builtin.lgrep_curbuf, { desc = '[/] Fuzzily search in current buffer' })

    -- It's also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    vim.keymap.set('n', '<leader>s/', function()
      require('fzf-lua').fzf_live(get_open_filelist(vim.fn.getcwd()))
    end, { desc = '[S]earch [/] in Open Files' })

    -- Shortcut for searching your Neovim configuration files
    vim.keymap.set('n', '<leader>sn', function()
      builtin.files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim files' })
  end,
}
