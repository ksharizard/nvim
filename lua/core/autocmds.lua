-- Wrap and SpellCheck in Markdown and gitcommit
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = 'Visual', timeout = 200 })
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "notify",
    "startuptime",
    "man",
    "checkhealth"
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.cmd('normal! g`"zz')
    end
  end,
})

-- remove trailing whitespaces and ^M chars
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*" },
  callback = function(_)
    local save_cursor = vim.fn.getpos(".")
    vim.cmd [[%s/\s\+$//e]]
    vim.fn.setpos(".", save_cursor)
  end,
})

-- Create directories when needed, when saving a file (except for URIs "://").
vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function(event)
    if event.match:match('^%w%w+://') then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})

-- Don't auto comment new lines
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '',
  command = 'set fo-=c fo-=r fo-=o'
})

-- Set text filetype
-- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {

--   pattern = "*.txt",
--   command = 'setfiletype text'
-- })

-- sudo write
vim.api.nvim_create_user_command("Suw", function()
  local filepath = vim.fn.expand("%:p")
  if filepath == "" then
    vim.notify("E32: No file name", vim.log.levels.ERROR)
    return
  end
  -- Save buffer to a temporary file
  local tmpfile = vim.fn.tempname()
  vim.cmd("write! " .. tmpfile)
  -- Prompt for password
  vim.fn.inputsave()
  local password = vim.fn.inputsecret("Password: ")
  vim.fn.inputrestore()
  if password == "" then
    vim.notify("Invalid password, sudo aborted", vim.log.levels.WARN)
    return
  end
  -- Use sudo to move the file
  local cmd =
    string.format("sudo -p '' -S dd if=%s of=%s bs=1048576", vim.fn.shellescape(tmpfile), vim.fn.shellescape(filepath))
  local proc = vim.system({ "sh", "-c", string.format("echo %q | %s", password, cmd) }):wait()
  -- Handle result
  if proc.code == 0 then
    vim.bo.modified = false
    vim.cmd.checktime()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>", true, false, true), "n", true)
  else
    vim.notify(proc.stderr, vim.log.levels.ERROR)
  end

  vim.fn.delete(tmpfile)
end, { desc = "Sudo write current buffer" })

