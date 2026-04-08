vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "nvim-treesitter" and kind == "update" then
      if not ev.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      vim.cmd("TSUpdate")
    end
  end,
})

vim.pack.add({
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = "main",
  },
  -- {
  --   src = "https://github.com/nvim-treesitter/nvim-treesitter-context",
  -- },
})

opts = {
  highlight = { enable = true },
  ensure_installed = {
    "bash",
    "c",
    "css",
    "diff",
    "gitcommit",
    "html",
    "javascript",
    "lua",
    "luadoc",
    "markdown",
    "markdown_inline",
    "python",
    "query",
    "vim",
    "vimdoc",
    "yaml",
  },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-space>",
      node_incremental = "<C-space>",
      scope_incremental = false,
      node_decremental = "<bs>",
    },
  },
}

if type(opts.ensure_installed) == "table" then
  local added = {}
  opts.ensure_installed = vim.tbl_filter(function(lang)
    if added[lang] then
      return false
    end
    added[lang] = true
    return true
  end, opts.ensure_installed)
end
require("nvim-treesitter.config").setup(opts)
