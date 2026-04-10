local function get_words()
  local filetype = vim.bo.filetype
  if filetype == "text" or filetype == "" or filetype == "markdown" then
    local wordcount = vim.fn.wordcount()
    local visual_words = wordcount.visual_words
    local words = visual_words or wordcount.words

    if visual_words == 1 then
      return "1 word"
    else
      return tostring(words) .. " words"
    end
  end
  return ""
end

local function section_pathname(args)
  args = vim.tbl_extend("force", {
    modified_hl = nil,
    filename_hl = nil,
    trunc_width = 80,
  }, args or {})

  if vim.bo.buftype == "terminal" then
    return "%t"
  end

  local path = vim.fn.expand("%:p")
  local cwd = vim.uv.cwd() or ""
  cwd = vim.uv.fs_realpath(cwd) or ""

  if path:find(cwd, 1, true) == 1 then
    path = path:sub(#cwd + 2)
  end

  local sep = package.config:sub(1, 1)
  local parts = vim.split(path, sep)
  if require("mini.statusline").is_truncated(args.trunc_width) and #parts > 3 then
    parts = { parts[1], "…", parts[#parts - 1], parts[#parts] }
  end

  local dir = ""
  if #parts > 1 then
    dir = table.concat({ unpack(parts, 1, #parts - 1) }, sep) .. sep
  end

  local file = parts[#parts]
  local file_hl = ""
  if vim.bo.modified and args.modified_hl then
    file_hl = "%#" .. args.modified_hl .. "#"
  elseif args.filename_hl then
    file_hl = "%#" .. args.filename_hl .. "#"
  end
  local modified = vim.bo.modified and " [+]" or ""
  return dir .. file_hl .. file .. modified
end

vim.pack.add({ "https://github.com/nvim-mini/mini.statusline" })
require("mini.statusline").setup({
  content = {
    active = function()
      local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
      local git = MiniStatusline.section_git({ icon = "", trunc_width = 40 })
      local diff = MiniStatusline.section_diff({ trunc_width = 80 })

      local pathname = section_pathname({
        trunc_width = 100,
        filename_hl = "MiniStatuslineFilename",
        modified_hl = "MiniStatuslineFilenameModified",
      })
      -- Search Selection Count
      local search = MiniStatusline.section_searchcount({ trunc_width = 75 })

      -- Word Count
      local word_count = get_words()

      -- Filetype and Icon
      local filetype = vim.bo.filetype
      local icon = ""
      local has_devicons, devicons = pcall(require, "mini.icons")
      if has_devicons then
        icon = devicons.get("file", vim.fn.expand("%:t")) or ""
      end
      local file_info = ""
      if filetype ~= "" then
        if icon ~= "" then
          file_info = icon .. " " .. filetype
        else
          file_info = filetype
        end
      end

      local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 60 })
      -- Location (Percentage only)
      local location = "%2p%%"

      -- Combine the groups
      return MiniStatusline.combine_groups({
        -- LEFT SIDE
        { hl = mode_hl, strings = { mode:upper() } },
        { hl = "MiniStatuslineDevinfo", strings = { git } },

        "%<", -- Mark general truncate point
        { hl = "MiniStatuslineDirectory", strings = { pathname } },
        "%=", -- Right align everything after this point

        -- RIGHT SIDE
        { hl = "MiniStatuslineDevinfo", strings = { search, word_count } },
        { hl = "MiniStatuslineFileinfo", strings = { file_info, diagnostics } },
        { hl = mode_hl, strings = { location } },
      })
    end,
  },
})
