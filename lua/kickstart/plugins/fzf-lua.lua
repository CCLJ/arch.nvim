return {
  'ibhagwan/fzf-lua',
  -- optional for icon support
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  -- or if using mini.icons/mini.nvim
  -- dependencies = { "echasnovski/mini.icons" },
  opts = {
    defaults = {
      git_icons = false,
      file_icons = false,
      color_icons = false,
    },
  },
  config = function()
    local builtin = require 'fzf-lua'
    vim.keymap.set('n', '<leader>sh', builtin.helptags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>sf', builtin.files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]ee FzfLua' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_cword, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sW', builtin.grep_cWORD, { desc = '[S]earch current [W]ORD' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by Live[G]rep' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics_document, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
    vim.keymap.set('n', '<leader>/', builtin.lgrep_curbuf, { desc = '[/] Fuzzily search in current buffer' })

    -- Shortcut for searching your Neovim configuration files
    vim.keymap.set('n', '<leader>sn', function()
      builtin.files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim files' })
  end,
}
