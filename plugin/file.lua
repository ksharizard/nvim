vim.pack.add({ "https://github.com/mikavilpas/yazi.nvim" })
vim.pack.add({ "https://github.com/nvim-lua/plenary.nvim" })
vim.g.loaded_netrwPlugin = 1
-- desc = "Open yazi at the current file",

vim.api.nvim_create_autocmd("UIEnter", {
  callback = function()
    require("yazi").setup({
      open_for_directories = true,
      open_multiple_tabs = true,
      open_file_function = function(chosen_file, config, state) vim.cmd("tabnew" .. chosen_file) end,
    })
  end,
})
