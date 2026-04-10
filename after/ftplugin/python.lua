-- use pep8 standards
vim.opt_local.shiftwidth = 4

-- folds based on indentation https://neovim.io/doc/user/fold.html#fold-indent
-- if you are a heavy user of folds, consider using `nvim-ufo`
-- vim.opt_local.foldmethod = "indent"

-- automatically capitalize boolean values. Useful if you come from a
-- different language, and lowercase them out of habit.
vim.cmd.inoreabbrev("<buffer> true True")
vim.cmd.inoreabbrev("<buffer> false False")

-- in the same way, we can fix habits regarding comments or None
vim.cmd.inoreabbrev("<buffer> -- #")
vim.cmd.inoreabbrev("<buffer> null None")
vim.cmd.inoreabbrev("<buffer> none None")
vim.cmd.inoreabbrev("<buffer> nil None")

vim.pack.add({ "https://github.com/mfussenegger/nvim-dap-python" })

-- uses the debugypy installation by mason
-- local debugpyPythonPath = require("mason-registry").get_package("debugpy"):get_install_path()
--   .. "/venv/bin/python3"
-- require("dap-python").setup(debugpyPythonPath, {})
require("dap-python").setup("python3")
-- vim.pack.add({"https://github.com/chrisgrieser/nvim-puppeteer"})
