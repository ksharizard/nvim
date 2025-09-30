local function getWords()
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

return {
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      theme = "dracula",
      options = {
        component_separators = '|',
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'filename', 'branch' },
        lualine_c = {},
        lualine_x = {},
        lualine_y = { 'filetype', getWords },
        lualine_z = { 'progress' },
      },
      inactive_sections = {
        lualine_a = { 'filename' },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { 'location' },
      },
      tabline = {},
      extensions = {},
    }
  },
}

