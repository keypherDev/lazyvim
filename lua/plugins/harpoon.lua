-- ============================================================================
-- HARPOON - NAVEGACIÓN RÁPIDA ENTRE ARCHIVOS IMPORTANTES
-- ============================================================================

return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      {
        "[h",
        function()
          require("harpoon"):list():prev()
        end,
        desc = "Harpoon anterior",
      },
      {
        "]h",
        function()
          require("harpoon"):list():next()
        end,
        desc = "Harpoon siguiente",
      },
      {
        "<leader>ha",
        function()
          require("harpoon"):list():add()
        end,
        desc = "Harpoon: agregar archivo",
      },
      {
        "<leader>hh",
        function()
          require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
        end,
        desc = "Harpoon: menú rápido",
      },
      {
        "<leader>hl",
        function()
          require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
        end,
        desc = "Harpoon: lista",
      },
      {
        "<leader>hc",
        function()
          require("harpoon"):list():clear()
        end,
        desc = "Harpoon: limpiar lista",
      },
      {
        "<leader>hr",
        function()
          local buf = vim.api.nvim_buf_get_name(0)
          require("harpoon"):list():remove(buf)
        end,
        desc = "Harpoon: remover archivo",
      },
    },
    config = function()
      require("harpoon"):setup()
    end,
  },
  -- Desactivar bufferline (se reemplaza con Harpoon)
  { "akinsho/bufferline.nvim", enabled = false },
}
