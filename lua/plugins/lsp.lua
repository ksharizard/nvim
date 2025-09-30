vim.diagnostic.config({
  virtual_text = {
    current_line = true,
    source = "if_many",
  },
  severity_sort = true,
})
-- vim.api.nvim_create_autocmd('LspAttach', {
-- 	group = vim.api.nvim_create_augroup('my.lsp', {}),
-- 	callback = function(args)
-- 		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
-- 		if client:supports_method('textDocument/completion') then
-- 			-- Optional: trigger autocompletion on EVERY keypress. May be slow!
-- 			local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
-- 			client.server_capabilities.completionProvider.triggerCharacters = chars
-- 			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
-- 		end
-- 	end,
-- })

vim.lsp.enable('luals')

return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    build = "cargo build --release",
    dependencies = "rafamadriz/friendly-snippets",
    event = "InsertEnter",
    opts = {
      keymap = {
        preset = "enter",
        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
      },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500
        },
        list = {
          selection = {
            preselect = false
          }
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
    opts_extend = { "sources.default" },
    signature = { enabled = true }
  },
  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
    opts = {
      enable_autosnippets = true,
    }
  },
  {
    "iurimateus/luasnip-latex-snippets.nvim",
    config = function ()
      require'luasnip-latex-snippets'.setup({ use_treesitter = true })
    end
  }
}
