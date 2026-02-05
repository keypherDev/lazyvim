local function append_unique(list, value)
  if not vim.tbl_contains(list, value) then
    table.insert(list, value)
  end
end

local diagnostic_signs = {
  Error = "❌ ",
  Warn = "⚠️ ",
  Hint = "💡 ",
  Info = "ℹ️ ",
}

local server_list = {
  tsserver = {},
  volar = {
    filetypes = { "vue", "typescript", "javascript", "javascriptreact", "typescriptreact" },
  },
  html = {},
  cssls = {},
  tailwindcss = {},
  emmet_ls = {},
  jsonls = {},
  intelephense = {},
  pyright = {},
  gopls = {},
  sqlls = {},
  graphql = {},
}

local mason_servers = {
  "typescript-language-server",
  "vue-language-server",
  "html-lsp",
  "css-lsp",
  "tailwindcss-language-server",
  "emmet-ls",
  "json-lsp",
  "intelephense",
  "pyright",
  "gopls",
  "sqlls",
  "graphql-language-service-cli",
}

return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = vim.tbl_deep_extend("force", opts.servers or {}, server_list)
      opts.diagnostics = vim.tbl_deep_extend("force", {
        virtual_text = {
          spacing = 2,
          prefix = "●",
        },
        severity_sort = true,
      }, opts.diagnostics or {})

      for severity, icon in pairs(diagnostic_signs) do
        local hl = "DiagnosticSign" .. severity
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      for _, pkg in ipairs(mason_servers) do
        append_unique(opts.ensure_installed, pkg)
      end
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      for server in pairs(server_list) do
        append_unique(opts.ensure_installed, server)
      end
    end,
  },
}
