return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed
        or {
          "lua",
          "javascript",
          "query",
          "typescript",
          "php",
          "go",
          "python",
          "html",
          "css",
          "json",
          "bash",
          "dockerfile",
          "yaml",
          "toml",
          "markdown",
        }
      local ensure = opts.ensure_installed
      if type(ensure) == "table" then
        for _, lang in ipairs({ "html", "css" }) do
          if not vim.tbl_contains(ensure, lang) then
            table.insert(ensure, lang)
          end
        end
      end

      opts.highlight = opts.highlight or {}
      opts.highlight.enable = true
      opts.highlight.additional_vim_regex_highlighting = opts.highlight.additional_vim_regex_highlighting or {}

      opts.indent = vim.tbl_deep_extend("force", opts.indent or {}, {
        enable = true,
        disable = { "yaml" },
      })
    end,
  },
}
