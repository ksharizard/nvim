vim.pack.add({ "https://github.com/mikavilpas/yazi.nvim" })
vim.pack.add({ "https://github.com/nvim-lua/plenary.nvim" })
vim.g.loaded_netrwPlugin = 1

vim.api.nvim_create_autocmd("UIEnter", {
  callback = function()
    require("yazi").setup({
      open_for_directories = true,
      open_multiple_tabs = true,
      open_file_function = function(chosen_file, _, _) vim.cmd("tabnew" .. chosen_file) end,
    })
  end,
})
