# ⚙️ Configuración personal de Neovim (LazyVim)

Este repositorio contiene mi configuración completa de Neovim basada en LazyVim y pensada para desarrollo web (Vue, Laravel/PHP, JS/TS), scripting y Go. Incluye formateadores configurados, servidores LSP asegurados y ajustes ergonómicos en español.

## Requisitos

- Neovim ≥ 0.10 con `git` disponible en PATH.
- `curl` y `make` (lazy.nvim los usa para descargar plugins).
- `cargo` para instalar `stylua` (`cargo install stylua`).
- Herramientas LSP/formateadores se descargan con Mason: `prettierd`, `php-cs-fixer`, `black`, `eslint-lsp`, `gopls`, etc.

## Instalación rápida

```bash
git clone git@github.com:keypherDev/lazyvim.git ~/.config/nvim
cd ~/.config/nvim
cargo install stylua # una sola vez
NVIM_APPNAME=nvim nvim --headless "+Lazy! sync" +qa
NVIM_APPNAME=nvim nvim --headless "+MasonInstall prettierd php-cs-fixer black eslint-lsp gopls" +qa
```

Abre Neovim normalmente (`nvim`) y deja que Lazy instale lo pendiente. Usa `:Mason` para verificar que todos los binarios estén instalados.

## Directorios relevantes

- `lua/config/` ajustes base (opciones, keymaps, autocmds, bootstrap de Lazy).
- `lua/plugins/` colecciones de plugins separados por temática (`conform.lua`, `lsp.lua`, `treesitter.lua`, `snippets.lua`).
- `plugin/after/` tweaks extra como transparencia global.
- `lazy-lock.json` fija las revisiones exactas de cada plugin.

## Plugins y características principales

- **LSP**: `nvim-lspconfig` + `mason.nvim` aseguran `tsserver`, `volar`, `html`, `cssls`, `tailwindcss`, `emmet_ls`, `jsonls`, `intelephense`, `pyright`, `gopls`, `sqlls`, `graphql`, `eslint`.
- **Formateo**: `conform.nvim` usa `prettierd`, `php-cs-fixer`, `black`. `gopls` y `eslint` formatean automáticamente al guardar; el resto se ejecuta manualmente (`<leader>cf`).
- **Autocompletado**: `blink.cmp` con snippets de `LuaSnip` + `friendly-snippets`.
- **Snippets**: puedes añadir ficheros propios en `snippets/` (ignorado por git).
- **Treesitter**: resaltado para `lua, javascript, query, typescript, php, go, python, html, css, vue, json, bash, dockerfile, yaml, toml, markdown` y sangría inteligente (excepto YAML).

## Flujo diario

1. Lanzar `nvim` → Lazy sincroniza automáticamente si hay cambios.
2. Usa `<leader>l` para abrir el panel de Lazy si deseas revisar instalaciones.
3. Ejecuta `:Mason` tras actualizar para asegurar nuevos binarios.
4. Formatea manualmente con `<leader>cf` (LazyVim) o `:ConformFormat` cuando no haya formato automático.
5. Para actualizar plugins/parsers:
   ```bash
   NVIM_APPNAME=nvim nvim --headless "+Lazy! sync" +qa
   NVIM_APPNAME=nvim nvim --headless "+TSUpdate" +qa
   ```

## Keymaps destacados

- `n` / `N`: búsqueda siguiente/anterior centrada (`nzzzv`).
- `<C-d>` / `<C-u>`: media página con reposicionamiento del cursor.
- `<leader>y`: copia al portapapeles del sistema, `<leader>d`: elimina sin modificar registers.
- `<A-j>` / `<A-k>` (visual): mover bloques arriba/abajo.
- `jj`, `jk`, `<C-c>`: salir de modo inserción rápidamente.
- `<leader>s`: buscar y reemplazar la palabra bajo el cursor en todo el archivo.
- `<leader>cf`: formateo manual vía Conform (LazyVim default).

## Estilo y formato

- `stylua` define el estilo para todo `.lua`. Ejecútalo con `stylua .` antes de commitear.
- `eslint-lsp` y `gopls` formatean al guardar; para otros lenguajes usa Conform.
- Diagnósticos personalizados: los signos de error/advertencia usan emojis (`❌`, `⚠️`, `💡`, `ℹ️`) para mejorar la visibilidad.

## Solución de problemas

- **Sin resaltado HTML/Vue**: ejecuta `:TSUpdate html vue css` o verifica `lua/plugins/treesitter.lua`.
- **LSP sin completar**: `:Mason` para revisar instalaciones, luego `:LspInfo` dentro del buffer.
- **Fmt no disponible**: confirma binarios con `:ConformInfo` y que `prettierd`/`php-cs-fixer` estén instalados.
- **Errores en plugins**: `:Lazy show` y revisa el log en `~/.local/state/nvim/lazy.log`.

## Scripts útiles

```bash
# Revisar salud general
NVIM_APPNAME=nvim nvim --headless "+checkhealth" +qa

# Ejecutar solo formateo en un archivo
stylua lua/plugins/lsp.lua

# Ver diagnósticos open buffers
NVIM_APPNAME=nvim nvim --headless "+Trouble diagnostics" +qa
```

## Licencia

Uso personal; si clonas el repo, adapta los formateadores y servidores a tus necesidades. Cualquier credencial o archivo sensible debe permanecer fuera del control de versiones (ver `.gitignore`).
