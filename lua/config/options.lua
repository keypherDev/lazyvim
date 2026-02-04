-- ============================================================================
-- CONFIGURACIÓN DE OPCIONES DE NEOVIM
-- ============================================================================

-- ============================================================================
-- INTERFAZ VISUAL
-- ============================================================================
vim.opt.number = true -- Muestra números de línea absolutos
vim.opt.relativenumber = true -- Muestra números relativos (útil para saltos)
vim.opt.cursorline = true -- Resalta la línea donde está el cursor
vim.opt.splitright = true -- Nuevas ventanas verticales se abren a la derecha
vim.opt.wrap = false -- Desactiva el ajuste de línea automático
vim.opt.signcolumn = "yes" -- Siempre muestra la columna de signos (diagnósticos, git, etc.)
vim.opt.termguicolors = true -- Habilita colores de 24 bits en terminal

-- ============================================================================
-- INDENTACIÓN Y TABULACIÓN
-- ============================================================================
vim.opt.shiftwidth = 4 -- Número de espacios para cada nivel de indentación
vim.opt.tabstop = 4 -- Número de espacios que representa un tab
vim.opt.softtabstop = 4 -- Número de espacios para tabs en modo inserción
vim.opt.expandtab = true -- Convierte tabs a espacios automáticamente

-- ============================================================================
-- COMPORTAMIENTO DEL CURSOR Y MOUSE
-- ============================================================================
--vim.opt.mouse = "" -- Mouse DESHABILITADO (sin soporte para interacción)
-- vim.opt.mousescroll = "ver:0,hor:0"  -- Scroll con mouse deshabilitado

-- ============================================================================
-- GESTIÓN DE ARCHIVOS Y RESPALDOS
-- ============================================================================
vim.opt.swapfile = false -- Desactiva archivos .swp (intercambio temporal)
vim.opt.backup = false -- No crea archivos de respaldo automáticamente

-- ============================================================================
-- CONFIGURACIONES ADICIONALES DE BÚSQUEDA Y COMPORTAMIENTO
-- ============================================================================
vim.opt.ignorecase = true -- Búsquedas insensibles a mayúsculas/minúsculas
vim.opt.smartcase = true -- Búsquedas sensibles si contienen mayúsculas
vim.opt.hlsearch = true -- Resalta todas las coincidencias de búsqueda
vim.opt.incsearch = true -- Búsqueda incremental mientras escribes

-- ============================================================================
-- CONFIGURACIÓN DE VENTANAS Y SPLITS
-- ============================================================================
vim.opt.splitbelow = true -- Nuevas ventanas horizontales se abren abajo
vim.opt.splitright = true -- Nuevas ventanas verticales se abren a la derecha

-- ============================================================================
-- CONFIGURACIÓN DE RENDIMIENTO
-- ============================================================================
vim.opt.updatetime = 250 -- Tiempo de espera para escribir al archivo swap (ms)
vim.opt.timeoutlen = 300 -- Tiempo de espera para secuencias de teclas (ms)
