return {
  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'garymjr/nvim-snippets',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'rafamadriz/friendly-snippets',
    },
    config = function()
      local cmp = require('cmp')

      cmp.setup({
        sources = {
          { name = 'nvim_lsp', priority = 1000 },
          { name = 'snippets', priority = 750 },
          { name = 'buffer',   priority = 500 },
          { name = 'path',     priority = 250 },
        },

        -- Window appearance
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        -- Improved mapping for a better completion experience
        mapping = cmp.mapping.preset.insert({
          ['<Tab>'] = cmp.mapping(function(fallback)
            local col = vim.fn.col('.') - 1

            if cmp.visible() then
              cmp.select_next_item({ behavior = 'select' })
            elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
              fallback()
            else
              cmp.complete()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = 'select' }),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
        }),

        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },

        -- Add borders to completion menu
        formatting = {
          format = function(entry, vim_item)
            vim_item.menu = ({
              nvim_lsp = "[LSP]",
              buffer = "[Buffer]",
              path = "[Path]",
            })[entry.source.name]
            return vim_item
          end
        },
      })
    end
  },
  {
    "garymjr/nvim-snippets",
    dependencies = {
      'rafamadriz/friendly-snippets',
    },
    keys = {
      {
        "<Tab>",
        function()
          if vim.snippet.active({ direction = 1 }) then
            vim.schedule(function()
              vim.snippet.jump(1)
            end)
            return
          end
          return "<Tab>"
        end,
        expr = true,
        silent = true,
        mode = "i",
      },
      {
        "<Tab>",
        function()
          vim.schedule(function()
            vim.snippet.jump(1)
          end)
        end,
        expr = true,
        silent = true,
        mode = "s",
      },
      {
        "<S-Tab>",
        function()
          if vim.snippet.active({ direction = -1 }) then
            vim.schedule(function()
              vim.snippet.jump(-1)
            end)
            return
          end
          return "<S-Tab>"
        end,
        expr = true,
        silent = true,
        mode = { "i", "s" },
      },
    },
    opts = {
      friendly_snippets = true
    },
  },

  -- LSP
  {
    'neovim/nvim-lspconfig',
    cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },
      { 'folke/lazydev.nvim',               ft = "lua", opts = {} },
    },
    config = function()
      -- LSP Diagnostics configuration
      vim.diagnostic.config({
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " "
          },
        },
        capabilities = {
          workspace = {
            fileOperations = {
              didRename = true,
              willRename = true,
            },
          },
        },
      })
      local lsp_defaults = require('lspconfig').util.default_config
      lsp_defaults.capabilities = vim.tbl_deep_extend(
        'force',
        lsp_defaults.capabilities,
        require('cmp_nvim_lsp').default_capabilities()
      )

      vim.api.nvim_create_autocmd('LspAttach', {
        desc = 'LSP actions',
        callback = function(event)
          local opts = { buffer = event.buf, noremap = true, silent = true }

          -- Enhanced keymaps
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, opts)
          vim.keymap.set({'n', 'x'}, '<F3>', function() vim.lsp.buf.format({async = false, timeout_ms = 10000}) end, opts)
          vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action, opts)

          -- Diagnostic keymaps
          vim.keymap.set('n', 'gl', vim.diagnostic.open_float, opts)
          vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
          vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
        end,
      })

      -- Configure specific language servers
      local lspconfig = require('lspconfig')

      -- Lua LSP configuration
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' }
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
          basedpyright = {
            -- Using Ruff's import organizer
            disableOrganizeImports = true,
            analysis = {
              -- Ignore all files for analysis to exclusively use Ruff for linting
              ignore = { '*' },
            },
          },
        },
      })
      require('mason-lspconfig').setup({
        handlers = {
          function(server_name)
            require('lspconfig')[server_name].setup({})
          end,
        }
      })
    end,
  },

  -- Mason
  {
    'williamboman/mason.nvim',
    lazy = false,
    config = true,
  },

  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = {
      { "williamboman/mason.nvim",          config = true },
      { "williamboman/mason-lspconfig.nvim" },
    },
    opts = {
      ensure_installed = {
        "lua_ls",
        "basedpyright",
        "ruff",
        "debugpy",
        "black",
        "isort",
        "taplo",
      },
      auto_update = true,
    },
  }
}
