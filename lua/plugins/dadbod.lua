-- ============================================================================
-- DB MANAGER - vim-dadbod + UI + completion
-- ============================================================================

return {
  {
    "tpope/vim-dadbod",
    cmd = { "DB", "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer", "DBUIRenameBuffer", "DBUILastQueryInfo" },
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = { "tpope/vim-dadbod" },
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer", "DBUIRenameBuffer", "DBUILastQueryInfo" },
    init = function()
      -- Conexiones persistentes (aparecen en DBUI)
      -- Por seguridad, cargamos conexiones desde un archivo local no versionado.
      pcall(require, "config.local_dbs")

      -- Guardar estado de la UI en un directorio persistente
      vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/dadbod_ui"
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_database_icon = 1
    end,
    config = function()
      vim.keymap.set("n", "<leader>Du", "<cmd>DBUIToggle<CR>", { desc = "DB: Alternar UI" })
      vim.keymap.set("n", "<leader>Df", "<cmd>DBUIFindBuffer<CR>", { desc = "DB: Encontrar buffer" })
      vim.keymap.set("n", "<leader>Dr", "<cmd>DBUIRenameBuffer<CR>", { desc = "DB: Renombrar buffer" })
      vim.keymap.set("n", "<leader>Da", "<cmd>DBUIAddConnection<CR>", { desc = "DB: Agregar conexion" })
    end,
  },
  {
    "kristijanhusak/vim-dadbod-completion",
    dependencies = { "tpope/vim-dadbod" },
    ft = { "sql", "mysql", "plsql" },
    init = function()
      -- Activar omni completion de Dadbod en buffers SQL.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql", "plsql" },
        callback = function(ev)
          vim.bo[ev.buf].omnifunc = "vim_dadbod_completion#omni"
        end,
      })
    end,
  },
}
