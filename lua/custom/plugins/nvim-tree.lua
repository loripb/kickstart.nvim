return {
  'nvim-tree/nvim-tree.lua',
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    local nvimtree = require 'nvim-tree'

    nvimtree.setup {
      view = {
        width = 35,
        relativenumber = true,
        side = 'left',
      },

      renderer = {
        indent_markers = {
          enable = true,
        },
      },

      git = {
        ignore = false,
      },
    }

    -- Set keymaps
    local keymap = vim.keymap
    keymap.set('n', '<F2>', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle file explorer' })
  end,
}
