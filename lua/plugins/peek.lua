-- return {
--   "toppair/peek.nvim",
--   ft = "markdown",
--   build = "deno task --quiet build:fast",
--   config = function()
--     require("peek").setup()
--     vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
--     vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
--   end,
-- }

return {
  "OXY2DEV/markview.nvim",
  ft = "markdown",
  keys = {
    {"<leader>lm", "<cmd>Markview toggle<cr>", desc = "Toggle markdown renderer"}
  },

  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons"
  },
  opts = {
    initial_state = false,
  }
}
