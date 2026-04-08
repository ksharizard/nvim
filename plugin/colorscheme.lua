vim.pack.add({ "https://github.com/rose-pine/neovim" })
vim.cmd("colorscheme rose-pine")

require("rose-pine").setup({
  styles = {
    transparency = true,
  },
})
