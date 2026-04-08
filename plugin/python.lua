vim.pack.add({ "https://github.com/mfussenegger/nvim-dap" })
vim.pack.add({ "https://github.com/nvim-neotest/nvim-nio" })
vim.pack.add({ "https://github.com/rcarriga/nvim-dap-ui" })
require("dapui").setup({
  config = function()
    local listener = require("dap").listeners
    listener.after.event_initialized["dapui_config"] = function() require("dapui").open() end
  end,
})
vim.pack.add({ "https://github.com/mfussenegger/nvim-dap-python" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    -- uses the debugypy installation by mason
    -- local debugpyPythonPath = require("mason-registry").get_package("debugpy"):get_install_path()
    --   .. "/venv/bin/python3"
    -- require("dap-python").setup(debugpyPythonPath, {})
    require("dap-python").setup("python3")
  end,
})
-- vim.pack.add({"https://github.com/chrisgrieser/nvim-puppeteer"})
