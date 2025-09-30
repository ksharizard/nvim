-- Sane defaults
local options = {
  cmdheight = 0,
  completeopt = { "menuone", "noselect", "fuzzy", "nosort" }, -- mostly just for completion
  fileencoding = "utf-8",
  hlsearch = false,
  hidden = false,
  ignorecase = true,
  laststatus = 3,
  mouse = "a",                             -- allow the mouse to be used in neovim
  relativenumber = true,
  signcolumn = "yes",
  smartcase = true,
  smartindent = true,
  splitbelow = true,
  splitright = true,
  swapfile = false,
  timeoutlen = 200,                        -- time to wait for a mapped sequence to complete (in milliseconds)
  undofile = true,                         -- enable persistent undo
  updatetime = 100,                        -- faster completion (4000ms default)
  writebackup = false,                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  expandtab = true,                        -- convert tabs to spaces
  shiftwidth = 2,
  tabstop = 2,                             -- insert 2 spaces for a tab
  number = true,                           -- set numbered lines
  numberwidth = 2,                         -- set number column width to 2 {default 4}
  scrolloff = 8,                           -- minimal number of screen lines to keep above and below the cursor
  sidescrolloff = 8,                       -- minimal number of screen columns either side of cursor if wrap is `false`
  showtabline = 1,
  virtualedit = "onemore",
  winborder = "rounded",
  wrap = false,
  whichwrap = "<,>,[,]",
}
vim.wo.fillchars = 'eob: '

for k, v in pairs(options) do
  vim.opt[k] = v
end

-- Clipboard
-- Sync clipboard between OS and Neovim. Schedule the setting after `UiEnter` because it can
-- increase startup-time. Remove this option if you want your OS clipboard to remain independent.
vim.api.nvim_create_autocmd('UIEnter', {
  callback = function()
    vim.o.clipboard = 'unnamedplus'
  end,
})

if vim.fn.has('wsl') == 1 then
  vim.g.clipboard = {
    name = 'WslClipboard',
    copy = {
      ['+'] = '/mnt/c/Windows/System32/clip.exe',
      ['*'] = '/mnt/c/Windows/System32/clip.exe',
    },
    paste = {
      ['+'] =
      '/mnt/c/Windows/System32/WindowsPowershell/v1.0/powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ['*'] =
      '/mnt/c/Windows/System32/WindowsPowershell/v1.0/powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
end

