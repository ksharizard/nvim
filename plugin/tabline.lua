vim.pack.add({ "https://github.com/nvim-mini/mini.tabline" })
vim.api.nvim_create_autocmd("BufEnter", {
  callback = vim.schedule_wrap(function()
    local n_listed_bufs = 0
    for _, buf_id in ipairs(vim.api.nvim_list_bufs()) do
      if vim.fn.buflisted(buf_id) == 1 then
        n_listed_bufs = n_listed_bufs + 1
      end
    end

    -- Use either approach: first (commented) directly hides tabline while second makes it blank
    vim.o.showtabline = n_listed_bufs > 1 and 2 or 0
    -- vim.o.tabline = n_listed_bufs > 1 and "%!v:lua.MiniTabline.make_tabline_string()" or " "
  end),
  desc = "Update tabline based on the number of listed buffers",
})
