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

vim.pack.add({ "https://github.com/nvim-mini/mini.statusline" })
require("mini.statusline").setup({
  content = {
    active = function()
      -- Mode
      local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
      mode = string.upper(mode)

      -- Filename
      local filename = vim.fn.expand("%:t")
      if filename == "" then
        filename = "[No Name]"
      end

      -- Git branch, and Git Diff
      local git = MiniStatusline.section_git({ icon = "", trunc_width = 75 })
      if git ~= "" then
        git = string.match(git, "^%S+%s+%S+") or git
      end

      local diff = MiniStatusline.section_diff({ trunc_width = 75 })

      local file_and_git = filename
      if git ~= "" then
        file_and_git = file_and_git .. " | " .. git
      end
      if diff ~= "" then
        file_and_git = file_and_git .. " " .. diff
      end

      -- Search Selection Count
      local search = MiniStatusline.section_searchcount({ trunc_width = 75 })

      -- Word Count
      local word_count = get_words()

      -- Filetype and Icon
      local filetype = vim.bo.filetype
      local icon = ""
      local has_devicons, devicons = pcall(require, "nvim-web-devicons")
      if has_devicons then
        icon = devicons.get_icon(filename, vim.fn.expand("%:e"), { default = true }) or ""
      end

      local file_info = ""
      if filetype ~= "" then
        if icon ~= "" then
          file_info = icon .. " " .. filetype
        else
          file_info = filetype
        end
      end

      -- Location (Percentage only)
      local location = "%2p%%"

      -- Combine the groups
      return MiniStatusline.combine_groups({
        -- LEFT SIDE
        { hl = mode_hl, strings = { mode } },
        { hl = "MiniStatuslineDevinfo", strings = { file_and_git } },

        "%<", -- Mark general truncate point
        "%=", -- Right align everything after this point

        -- RIGHT SIDE
        { hl = "MiniStatuslineDevinfo", strings = { search } },
        { hl = "MiniStatuslineDevinfo", strings = { word_count } },
        { hl = "MiniStatuslineFileinfo", strings = { file_info } },
        { hl = mode_hl, strings = { location } },
      })
    end,
  },
})
