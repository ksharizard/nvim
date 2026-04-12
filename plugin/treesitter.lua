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
})
local function treesitter_try_attach(buf, language)
  if not vim.treesitter.language.add(language) then
    return
  end
  vim.treesitter.start(buf, language)
  vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
end
local available_parsers = require("nvim-treesitter").get_available()
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "*" },
  group = vim.api.nvim_create_augroup("danwlker/nvim-treesitter-start-and-indentexpr", { clear = true }),
  callback = function(args)
    local buf, filetype = args.buf, args.match
    local language = vim.treesitter.language.get_lang(filetype)
    if not language then
      return
    end

    local installed_parsers = require("nvim-treesitter").get_installed("parsers")
    if vim.tbl_contains(installed_parsers, language) then
      -- enable the parser if it is installed
      treesitter_try_attach(buf, language)
    elseif vim.tbl_contains(available_parsers, language) then
      -- if a parser is available in `nvim-treesitter` auto install it, and enable it after the installation is done
      require("nvim-treesitter").install(language):await(function() treesitter_try_attach(buf, language) end)
    else
      -- try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
      treesitter_try_attach(buf, language)
    end
  end,
})
local nvim_treesitter = require("nvim-treesitter")
nvim_treesitter.setup()
nvim_treesitter.install({
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
  "dockerfile",
  "json",
  "scss",
  "make",
  "regex",
  "toml",
  "rust",
})
