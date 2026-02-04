return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = vim.tbl_extend("force", opts.formatters_by_ft or {}, {
        html = { "prettierd" },
        css = { "prettierd" },
        javascript = { "prettierd" },
        javascriptreact = { "prettierd" },
        typescript = { "prettierd" },
        typescriptreact = { "prettierd" },
        vue = { "prettierd" },
        php = { "phpcsfixer" },
        python = { "black" },
      })

      opts.format_on_save = opts.format_on_save or {}
      opts.format_on_save.timeout_ms = opts.format_on_save.timeout_ms or 500
      opts.formatters = opts.formatters or {}
      opts.formatters.prettierd = opts.formatters.prettierd or {}
    end,
  },
}
