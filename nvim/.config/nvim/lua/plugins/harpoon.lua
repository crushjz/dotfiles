local harpoon = require 'harpoon'

harpoon.setup()

vim.keymap.set('n', '<C-e>', function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = 'Show harpoon list' })
vim.keymap.set('n', '<leader>p', function()
  harpoon:list():add()
end, { desc = 'Add to harpoon list' })

harpoon:extend {
  UI_CREATE = function(cx)
    vim.keymap.set('n', '<C-v>', function()
      harpoon.ui:select_menu_item { vsplit = true }
    end, { buffer = cx.bufnr })

    vim.keymap.set('n', '<C-x>', function()
      harpoon.ui:select_menu_item { split = true }
    end, { buffer = cx.bufnr })

    vim.keymap.set('n', '<C-t>', function()
      harpoon.ui:select_menu_item { tabedit = true }
    end, { buffer = cx.bufnr })
  end,
}

-- vim.keymap.set('n', '<C-h>', function()
--   harpoon:list():select(1)
-- end)
-- vim.keymap.set('n', '<C-t>', function()
--   harpoon:list():select(2)
-- end)
-- vim.keymap.set('n', '<C-n>', function()
--   harpoon:list():select(3)
-- end)
-- vim.keymap.set('n', '<C-s>', function()
--   harpoon:list():select(4)
-- end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set('n', '[[', function()
  harpoon:list():prev()
end, { desc = 'Previous harpoon buffer' })
vim.keymap.set('n', ']]', function()
  harpoon:list():next()
end, { desc = 'Next harpoon buffer' })
