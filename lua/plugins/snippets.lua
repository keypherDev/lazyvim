return {
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
      region_check_events = "CursorHold",
    },
    config = function(_, opts)
      local luasnip = require("luasnip")
      luasnip.config.set_config(opts)
      require("luasnip.loaders.from_vscode").lazy_load()

      local local_snippets = vim.fn.stdpath("config") .. "/snippets"
      if vim.fn.isdirectory(local_snippets) == 1 then
        require("luasnip.loaders.from_lua").lazy_load({ paths = local_snippets })
      end
    end,
  },
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.snippets = vim.tbl_deep_extend("force", opts.snippets or {}, {
        preset = "luasnip",
      })
    end,
  },
}
