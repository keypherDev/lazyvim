-- ============================================================================
-- GITHUB COPILOT - Autocompletado con IA
-- ============================================================================
-- Configuración optimizada para integración con blink.cmp y LSP
-- Keymaps usando ALT para evitar conflictos con LSP y navegación

return {
  -- ========================================================================
  -- COPILOT.LUA - Motor principal de Copilot
  -- ========================================================================
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    cmd = "Copilot",
    build = ":Copilot auth",
    opts = {
      -- Panel deshabilitado (solo queremos autocompletado inline)
      panel = {
        enabled = false,
        auto_refresh = false,
      },

      -- Configuración de sugerencias inline
      suggestion = {
        enabled = true,
        auto_trigger = true, -- Mostrar sugerencias automáticamente
        debounce = 75, -- Tiempo de espera después de escribir (ms)
        keymap = {
          accept = "<M-l>", -- Alt + l: Aceptar sugerencia completa
          accept_word = "<M-w>", -- Alt + w: Aceptar solo la siguiente palabra
          accept_line = "<M-e>", -- Alt + e: Aceptar solo la línea actual
          next = "<M-.>", -- Alt + .: Siguiente sugerencia
          prev = "<M-,>", -- Alt + ,: Sugerencia anterior
          dismiss = "<M-/>", -- Alt + /: Descartar sugerencia
        },
      },

      -- Configuración de tipos de archivo (basado en tu LSP config)
      filetypes = {
        -- Lenguajes principales de tu configuración
        python = true, -- pyright
        lua = true, -- lua_ls
        javascript = true, -- ts_ls
        typescript = true, -- ts_ls
        javascriptreact = true, -- ts_ls
        typescriptreact = true, -- ts_ls
        vue = true, -- ts_ls con vue plugin
        php = true, -- intelephense
        html = true, -- html
        css = true, -- cssls
        scss = true,
        json = true, -- jsonls
        bash = true, -- bashls
        sh = true, -- bashls

        -- Lenguajes adicionales comunes
        go = true,
        rust = true,
        java = true,
        cpp = true,
        c = true,
        ruby = true,
        yaml = true,
        toml = true,
        markdown = true,
        sql = true,
        vim = true,
        dockerfile = true,

        -- Deshabilitar en archivos especiales
        gitcommit = false,
        gitrebase = false,
        ["."] = false,
        ["*"] = false, -- Deshabilitar por defecto en otros
      },

      -- Configuración del servidor Copilot
      copilot_node_command = "node",
      server_opts_overrides = {
        trace = "verbose",
        settings = {
          advanced = {
            listCount = 10, -- Número de sugerencias a generar
            inlineSuggestCount = 3,
          },
        },
      },
    },

    config = function(_, opts)
      local function is_node_supported(bin)
        if vim.fn.executable(bin) == 0 then
          return false, ("no se encontró el binario '%s'"):format(bin)
        end

        local version_output = vim.fn.system({ bin, "--version" }) or ""
        local major = tonumber((version_output:match("v?(%d+)") or "0"))
        if major > 0 and major < 18 then
          return false, ("se requiere Node >= 18 (detectado %s)"):format(vim.trim(version_output))
        end

        return true
      end

      local node_bin = opts.copilot_node_command or "node"
      local node_ok, node_error = is_node_supported(node_bin)
      if not node_ok then
        vim.notify(("🤖 Copilot deshabilitado: %s"):format(node_error), vim.log.levels.ERROR)
        return
      end

      require("copilot").setup(opts)

      -- ================================================================
      -- KEYMAPS ADICIONALES EN MODO NORMAL
      -- ================================================================
      -- Toggle Copilot on/off
      vim.keymap.set("n", "<leader>ct", function()
        local was_disabled = vim.g.__copilot_user_disabled == true
        if was_disabled then
          vim.g.__copilot_user_disabled = false
          vim.cmd("Copilot enable")
          vim.notify("🤖 Copilot habilitado", vim.log.levels.INFO)
          return
        end

        vim.g.__copilot_user_disabled = true
        vim.cmd("Copilot disable")
        local ok, suggestion = pcall(require, "copilot.suggestion")
        if ok and suggestion.is_visible() then
          suggestion.dismiss()
        end
        vim.notify("🤖 Copilot deshabilitado", vim.log.levels.WARN)
      end, { desc = "Copilot: Alternar" })

      -- Comando para verificar estado de Copilot
      vim.keymap.set("n", "<leader>cs", "<cmd>Copilot status<CR>", {
        desc = "Copilot: Mostrar estado",
      })

      -- Comando para panel de Copilot (si se habilita en el futuro)
      vim.keymap.set("n", "<leader>cp", function()
        if not (opts.panel and opts.panel.enabled) then
          vim.notify("Copilot panel está deshabilitado en la configuración", vim.log.levels.WARN)
          return
        end
        vim.cmd("Copilot panel")
      end, {
        desc = "Copilot: Abrir panel",
      })

      -- ================================================================
      -- AUTOCOMANDOS PARA MEJORAR LA EXPERIENCIA
      -- ================================================================
      -- Deshabilitar Copilot en archivos grandes (>100KB)
      vim.api.nvim_create_autocmd("BufReadPre", {
        pattern = "*",
        callback = function()
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(0))
          if ok and stats and stats.size > max_filesize then
            vim.b.copilot_enabled = false
            vim.notify("⚠️ Copilot deshabilitado: archivo muy grande", vim.log.levels.WARN)
          end
        end,
      })

      -- Mensaje de bienvenida al iniciar Copilot
      vim.api.nvim_create_autocmd("User", {
        pattern = "CopilotAttach",
        callback = function()
          vim.notify("🤖 GitHub Copilot activado", vim.log.levels.INFO, {
            title = "Copilot",
            timeout = 2000,
          })
        end,
      })
    end,
  },

  -- ========================================================================
  -- COPILOT INTEGRATION WITH BLINK.CMP
  -- ========================================================================
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = {
      { "giuxtaposition/blink-cmp-copilot" },
    },
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      opts.sources.default = opts.sources.default or { "lsp", "path", "snippets", "buffer" }

      if not vim.tbl_contains(opts.sources.default, "copilot") then
        table.insert(opts.sources.default, "copilot")
      end

      opts.sources.providers = opts.sources.providers or {}
      opts.sources.providers.copilot = {
        name = "Copilot",
        module = "blink-cmp-copilot",
        score_offset = 100,
        async = true,
      }
    end,
  },
}
