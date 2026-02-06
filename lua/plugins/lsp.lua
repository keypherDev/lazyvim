local function append_unique(list, value)
  if not vim.tbl_contains(list, value) then
    table.insert(list, value)
  end
end

local function with_format_on_save(server_opts)
  local original_on_attach = server_opts.on_attach
  server_opts.on_attach = function(client, bufnr)
    if original_on_attach then
      original_on_attach(client, bufnr)
    end

    if client.supports_method("textDocument/formatting") then
      local group = vim.api.nvim_create_augroup("lsp-format-" .. bufnr, { clear = true })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = group,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr, async = false })
        end,
      })
    end
  end
end

local function trim_sign_text(text)
  if type(text) ~= "string" then
    return ""
  end
  local trimmed = text:gsub("^%s*(.-)%s*$", "%1")
  return trimmed
end

local function define_diagnostic_sign(severity, icon)
  local hl = "DiagnosticSign" .. severity
  local fallback = severity:sub(1, 1)
  local text = trim_sign_text(icon)
  if text == "" then
    text = fallback
  end

  local ok, err = pcall(vim.fn.sign_define, hl, { text = text, texthl = hl, numhl = hl })
  if ok then
    return
  end

  local notify = vim.notify_once or vim.notify
  if notify then
    notify(
      string.format("No se pudo aplicar el signo '%s' para %s. Se usará '%s'. Error: %s", text, hl, fallback, err),
      vim.log.levels.WARN
    )
  end

  vim.fn.sign_define(hl, { text = fallback, texthl = hl, numhl = hl })
end

local diagnostic_signs = {
  Error = "❌ ",
  Warn = "⚠️ ",
  Hint = "💡 ",
  Info = "ℹ️ ",
}

local server_list = {
  html = {},
  cssls = {},
  tailwindcss = {},
  emmet_ls = {},
  jsonls = {},
  intelephense = {},
  pyright = {},
  gopls = {},
  sqlls = {},
  ts_ls = {
    filetypes = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
    },
    -- Deshabilitar en archivos .vue para evitar conflictos
    on_attach = function(client, bufnr)
      if vim.bo[bufnr].filetype == "vue" then
        client.stop()
        return
      end
    end,
  },
  vue_ls = {
    filetypes = { "vue" },
    init_options = {
      typescript = {
        tsdk = vim.fn.expand(
          "$HOME/.local/share/nvim/mason/packages/typescript-language-server/node_modules/typescript/lib"
        ),
      },
    },
  },
  eslint = {
    filetypes = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "vue",
    },
    settings = {
      format = { enable = true },
      workingDirectory = { mode = "auto" },
    },
  },
}

with_format_on_save(server_list.gopls)
with_format_on_save(server_list.eslint)

local mason_servers = {
  "vue-language-server",
  "typescript-language-server",
  "html-lsp",
  "css-lsp",
  "emmet-ls",
  "json-lsp",
  "intelephense",
  "pyright",
  "gopls",
  "sqlls",
  "eslint-lsp",
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
        define_diagnostic_sign(severity, icon)
      end
    end,
  },
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      for _, pkg in ipairs(mason_servers) do
        append_unique(opts.ensure_installed, pkg)
      end
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      for server in pairs(server_list) do
        append_unique(opts.ensure_installed, server)
      end
    end,
  },
}
