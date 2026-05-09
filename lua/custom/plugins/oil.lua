return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    view_options = {
      show_hidden = true,
    },
  },
  dependencies = { { 'nvim-mini/mini.icons', opts = {} } },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
  lazy = false,
  config = function(_, opts)
    require('oil').setup(opts)
    -- add keymap to save file and trigger oil afterwards
    vim.keymap.set('n', '<A-o>', function()
      vim.cmd 'w'
      vim.cmd 'Oil'
    end, { desc = 'Save file and show parent directory' })
    vim.keymap.set('n', '<A-e>', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
  end,
}
