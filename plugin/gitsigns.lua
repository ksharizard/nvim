vim.pack.add({ "https://github.com/nvim-mini/mini.diff" })

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    require("mini.diff").setup()
  end,
})
