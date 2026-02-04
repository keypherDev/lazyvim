-- ============================================================================
-- CONFIGURACIÓN DE TECLAS GLOBALES
-- ============================================================================
-- NOTA: Las teclas líder se configuran en config/lazy.lua antes de cargar plugins

-- Opciones por defecto para keymaps
local opts = { noremap = true, silent = true }

-- ============================================================================
-- NAVEGACIÓN Y BÚSQUEDA MEJORADA
-- ============================================================================
-- Búsqueda centrada
vim.keymap.set("n", "n", "nzzzv", { desc = "Buscar próximo y centrar" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Buscar anterior y centrar" })

-- Navegación de página centrada
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Media página abajo + centrar" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Media página arriba + centrar" })

-- ============================================================================
-- COPIAR/PEGAR Y GESTIÓN DE REGISTROS
-- ============================================================================
-- Copiar al portapapeles del sistema
vim.keymap.set("v", "<leader>y", '"+y', opts, { desc = "Copiar al portapapeles" })
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Pegar sobre texto sin afectar registros" })
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Eliminar líneas sin afectar lo copiado" })

-- Atajos adicionales de edición
vim.keymap.set("n", "<C-x>", "dd", opts, { desc = "Cortar línea completa" })
vim.keymap.set("n", "<A-a>", "ggVG", opts, { desc = "Seleccionar todo el archivo" })

-- Mover líneas arriba/abajo en modo visual (Alt+j/k para evitar conflictos con LSP)
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Mover líneas hacia abajo" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Mover líneas hacia arriba" })

-- ============================================================================
-- TECLAS DE ESCAPE Y SALIDA
-- ============================================================================
-- Limpiar búsqueda con Escape en modo normal
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", opts, { desc = "Limpiar resaltado de búsqueda" })

-- Múltiples formas de salir del modo inserción (mantener todas como solicitado)
vim.keymap.set("i", "jj", "<ESC>", { noremap = false, desc = "Escape con jj" })
vim.keymap.set("i", "jk", "<ESC>", { noremap = false, desc = "Escape con jk" })
vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Escape con Ctrl+c" })

-- ============================================================================
-- EDICIÓN DE TEXTO
-- ============================================================================
-- Unir línea siguiente con la actual
vim.keymap.set("n", "J", "mzJz", { desc = "Unir línea siguiente con actual" })

-- Indentación mejorada (mantiene selección)
vim.keymap.set("v", "<", "<gv", { desc = "Indentar hacia la izquierda" })
vim.keymap.set("v", ">", ">gv", { desc = "Indentar hacia la derecha" })
-- Reemplazo inteligente de palabra bajo cursor
vim.keymap.set(
  "n",
  "<leader>s",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Buscar y reemplazar palabra bajo cursor" }
)
