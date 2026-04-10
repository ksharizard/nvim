vim.pack.add({ "https://github.com/mfussenegger/nvim-dap" })
vim.pack.add({ "https://github.com/nvim-neotest/nvim-nio" })
vim.pack.add({ "https://github.com/rcarriga/nvim-dap-ui" })

require("dapui").setup({
  config = function()
    local listener = require("dap").listeners
    listener.after.event_initialized["dapui_config"] = function() require("dapui").open() end
  end,
})
