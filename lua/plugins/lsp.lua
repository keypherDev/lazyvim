local function append_unique(list, value)
  if not vim.tbl_contains(list, value) then
    table.insert(list, value)
  end
end

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
