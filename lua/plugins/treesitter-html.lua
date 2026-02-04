return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      local ensure = opts.ensure_installed
      if type(ensure) == "table" then
        if not vim.tbl_contains(ensure, "html") then
          table.insert(ensure, "html")
        end
        if not vim.tbl_contains(ensure, "css") then
          table.insert(ensure, "css")
        end
      end

      opts.highlight = opts.highlight or {}
      opts.highlight.enable = true
      opts.highlight.additional_vim_regex_highlighting = opts.highlight.additional_vim_regex_highlighting or {}
    end,
  },
}
