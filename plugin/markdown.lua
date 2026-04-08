vim.pack.add({"https://github.com/OXY2DEV/markview.nvim"})
vim.pack.add({"http://github.com/nvim-tree/nvim-web-devicons"})
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    require("markview").setup({
      initial_state = false,
    })
  end
})

