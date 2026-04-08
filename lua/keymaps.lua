-- Remap space as leader key
vim.keymap.set("", "<Space>", "<Nop>", { silent = true, desc = "Disable Space" })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Better window navigation
vim.keymap.set("n", "<leader>wh", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<leader>wj", "<C-w>j", { desc = "Go to lower window" })
vim.keymap.set("n", "<leader>wk", "<C-w>k", { desc = "Go to upper window" })
vim.keymap.set("n", "<leader>wl", "<C-w>l", { desc = "Go to right window" })

-- Resize windows
vim.keymap.set("n", "<A-k>", ":resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<A-j>", ":resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<A-h>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<A-l>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Navigate buffers
vim.keymap.set("n", "L", ":bnext<CR>", { silent = true, desc = "Next buffer" })
vim.keymap.set("n", "H", ":bprevious<CR>", { silent = true, desc = "Previous buffer" })

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", { desc = "Indent and keep selection" })
vim.keymap.set("v", ">", ">gv", { desc = "Unindent and keep selection" })
vim.keymap.set("v", "p", '"_dP', { desc = "Paste without overwriting register" })

-- Move text up and down
vim.keymap.set("x", "J", ":move '>+1<CR>gv-gv", { desc = "Move text down" })
vim.keymap.set("x", "K", ":move '<-2<CR>gv-gv", { desc = "Move text up" })

-- Don't yank on delete char
vim.keymap.set({ "n", "v" }, "x", '"_x', { desc = "Delete character without yanking" })

-- Keep cursor centered when scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })

-- DAP (Debugger)
vim.keymap.set("n", "<leader>dc", function() require("dap").continue() end, { desc = "Start/Continue Debugger" })
vim.keymap.set("n", "<leader>db", function() require("dap").toggle_breakpoint() end, { desc = "Add Breakpoint" })
vim.keymap.set("n", "<leader>dt", function() require("dap").terminate() end, { desc = "Terminate Debugger" })
vim.keymap.set("n", "<leader>du", function() require("dapui").toggle() end, { desc = "Toggle Debugger UI" })

-- Misc
vim.keymap.set("n", "<leader>e", "<cmd>Yazi<cr>", { desc = "Open Yazi" })
vim.keymap.set("n", "<leader>m", "<cmd>Markview Toggle<cr>", { desc = "Toggle markdown renderer" })

-- LSP
vim.keymap.set("n", "grn", vim.lsp.buf.rename, { desc = "LSP: [R]e[n]ame" })
vim.keymap.set({ "n", "x" }, "grn", vim.lsp.buf.code_action, { desc = "LSP: [G]oto Code [A]ction" })
vim.keymap.set("n", "grn", vim.lsp.buf.declaration, { desc = "LSP: [G]oto [D]eclaration" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set(
  "n",
  "<leader>f",
  function() require("conform").format({ async = true, lsp_format = "fallback" }) end,
  { desc = "[F]ormat buffer" }
)

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })
