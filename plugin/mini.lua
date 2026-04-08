vim.pack.add({
  "https://github.com/nvim-mini/mini.ai",
  "https://github.com/nvim-mini/mini.extra",
  "https://github.com/nvim-mini/mini.hipatterns",
  "https://github.com/nvim-mini/mini.indentscope",
  "https://github.com/nvim-mini/mini.pairs",
  "https://github.com/nvim-mini/mini.surround",
  "https://github.com/nvim-mini/mini.clue",
})

require('mini.ai').setup { n_lines = 500 }

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    require("mini.indentscope").setup({
      symbol = "│",
      options = { try_as_border = true },
    })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "help",
    "lazy",
    "mason",
    "notify",
    "toggleterm",
  },
  callback = function()
    vim.b.miniindentscope_disable = true
  end,
})

vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function()
    require("mini.pairs").setup({
      modes = { insert = true, command = true, terminal = false },
      -- skip autopair when next character is one of these
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      -- skip autopair when the cursor is inside these treesitter nodes
      skip_ts = { "string" },
      -- skip autopair when next character is closing pair
      -- and there are more closing pairs than opening pairs
      skip_unbalanced = true,
      -- better deal with markdown code blocks
      markdown = true,
    })
  end,
})

require("mini.surround").setup()
local miniclue = require('mini.clue')
miniclue.setup({
  window = {
    -- Delay before showing clue window
    delay = 300,
  },
  triggers = {
    -- Leader triggers
    { mode = { 'n', 'x' }, keys = '<Leader>' },

    -- `[` and `]` keys
    { mode = 'n', keys = '[' },
    { mode = 'n', keys = ']' },

    -- Built-in completion
    { mode = 'i', keys = '<C-x>' },

    -- `g` key
    { mode = { 'n', 'x' }, keys = 'g' },

    -- Marks
    { mode = { 'n', 'x' }, keys = "'" },
    { mode = { 'n', 'x' }, keys = '`' },

    -- Registers
    { mode = { 'n', 'x' }, keys = '"' },
    { mode = { 'i', 'c' }, keys = '<C-r>' },

    -- Window commands
    { mode = 'n', keys = '<C-w>' },

    -- `z` key
    { mode = { 'n', 'x' }, keys = 'z' },
  },

  clues = {
    miniclue.gen_clues.square_brackets(),
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
  },
})

require("mini.extra").setup()
local hipatterns = require('mini.hipatterns')
local hi_words = require('mini.extra').gen_highlighter.words
hipatterns.setup({
  highlighters = {
    -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
    fix = hi_words({ 'FIX', 'Fix', 'fix' }, 'MiniHipatternsFixme'),
    todo = hi_words({ 'TODO', 'Todo', 'todo' }, 'MiniHipatternsTodo'),
    hack = hi_words({ 'HACK', 'Hack', 'hack' }, 'MiniHipatternsHack'),
    note = hi_words({ 'NOTE', 'Note', 'note' }, 'MiniHipatternsNote'),
    -- Highlight hex color strings (`#rrggbb`) using that color
    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
})

