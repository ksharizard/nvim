local options = {
  -- autocomplete = true,
  cmdheight = 0,
  completeopt = { "menuone", "noselect", "fuzzy", "nosort" }, -- mostly just for completion
  fillchars = 'eob: ',
  fileencoding = "utf-8",
  hlsearch = false,
  hidden = false,
  ignorecase = true,
  laststatus = 3,
  relativenumber = true,
  signcolumn = "yes",
  smartcase = true,
  smartindent = true,
  splitbelow = true,
  splitright = true,
  swapfile = false,
  timeoutlen = 200,    -- time to wait for a mapped sequence to complete (in milliseconds)
  undofile = true,     -- enable persistent undo
  updatetime = 100,    -- faster completion (4000ms default)
  writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  expandtab = true,    -- convert tabs to spaces
  shiftwidth = 2,
  number = true,       -- set numbered lines
  numberwidth = 2,     -- set number column width to 2 {default 4}
  scrolloff = 8,       -- minimal number of screen lines to keep above and below the cursor
  sidescrolloff = 8,   -- minimal number of screen columns either side of cursor if wrap is `false`
  softtabstop = -1,
  virtualedit = "onemore",
  winborder = "rounded",
  wrap = false,
  clipboard = 'unnamedplus',
  whichwrap = "<,>,[,]",
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

-- Fixes WSL clipboard
if vim.fn.has('wsl') == 1 then
  vim.g.clipboard = {
    name = 'WslClipboard',
    copy = {
      ['+'] = 'clip.exe',
      ['*'] = 'clip.exe',
    },
    paste = {
      ['+'] =
      'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ['*'] =
      'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
end
