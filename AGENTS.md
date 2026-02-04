# Agent Operations Playbook

## Working Assumptions
- This repo is a LazyVim-based Neovim configuration rooted at `~/.config/nvim` with Lua as the only authored language.
- `init.lua` simply bootstraps `config.lazy`, so most work happens in `lua/config` and `lua/plugins`.
- Plugin pinning lives in `lazy-lock.json`; keep it up to date only when intentionally syncing.
- Spanish section headers in `lua/config/*.lua` are intentional; respect the bilingual tone when editing those files.
- No Cursor or Copilot rule files exist right now, so this document acts as the canonical policy until one shows up.

## Directory Wayfinding
- `lua/config` holds core settings: `lazy.lua` for bootstrapping, `options.lua` for editor behavior, `keymaps.lua` for custom mappings, and `autocmds.lua` for hooks.
- `lua/plugins` contains plugin specs loaded automatically by lazy.nvim; each file returns a Lua table describing one or more specs.
- `plugin/after/transparency.lua` enforces borderless UI; touch it only when you understand highlight impacts across themes.
- `stylua.toml` governs formatting and should be treated as the source of truth for Lua style.
- `lazy-lock.json` is generated; never hand-edit beyond conflict resolution.

## Environment & Tooling
- Use a modern Neovim (≥0.10) with lazy.nvim (managed automatically by `config.lazy`).
- Ensure `git`, `curl`, and `make` are present because lazy.nvim may fetch dependencies with them.
- For Lua tooling install `stylua`, `luacheck` (optional), and `selene` only if you add static analysis; Mason ensures runtime tools like `shellcheck` and `shfmt` when configured in specs.
- Set `NVIM_APPNAME=nvim` (default) when running commands so this config directory is used.
- Keep `XDG_CONFIG_HOME` consistent if scripting; hard-coding other paths will confuse other agents.

## Command Quick Reference
- Full sync + compile health: `NVIM_APPNAME=nvim nvim --headless "+Lazy! sync" +qa`.
- Regenerate lazy cache: `NVIM_APPNAME=nvim nvim --headless "+Lazy! clean" +qa` to remove unused plugins after editing specs.
- Format entire repo: `stylua .` (relies on `stylua.toml`).
- Format single file: `stylua path/to/file.lua`.
- Check for Lua syntax errors without launching UI: `nvim --headless -c "luafile %" file.lua +qa` (or via `nvim --headless -c 'lua dofile("file.lua")' +qa`).
- Inspect plugin graph: `NVIM_APPNAME=nvim nvim --headless "+Lazy! show" +qa`.

## Running Tests or Targeted Checks
- There is no automated test suite here; validation equals "does Neovim boot cleanly and behave as intended".
- Smoke test the entire config with `NVIM_APPNAME=nvim nvim --headless "+Lazy! sync | lua print('OK')" +qa` and ensure exit code 0.
- For single-file verification, open Neovim with `nvim --headless +'luafile lua/plugins/<file>.lua' +qa`; Neovim aborts on Lua errors, giving you per-file confidence.
- When editing plugin specs, run `nvim --headless "+Lazy! reload <plugin-regexp>" +qa` to reload only affected specs.
- Manual UI checks (theme reloads, transparency, keymaps) still matter; document any manual scenarios in PR descriptions.

## Formatter & Static Analysis Rules
- `stylua.toml` enforces spaces, width 2, and a 120-column wrap; never mix tabs/spaces except when copying plugin documentation exactly.
- Run `stylua` before committing; there is no automatic Git hook in this repo.
- Keep table literals compact when short and multi-line when complex; rely on `stylua` to break long argument lists.
- Favor `---@class`/`---@param` annotations when the API benefits from type hints (see `plugins/example.lua`).
- When disabling formatter on intentionally odd blocks, use `-- stylua: ignore` directly above the lines you want untouched.

## Imports & Module Patterns
- Neovim modules are loaded through `require`; follow the convention `local xyz = require("module")` at the top for reused references.
- Use `vim.api`, `vim.fn`, `vim.o/opt`, and `vim.keymap` consistently; stray global helper functions should live in dedicated modules rather than `init.lua`.
- When referencing lazy core internals (e.g., `require("lazy.core.loader")` in `plugins/omarchy-theme-hotreload.lua`), guard them with `pcall` or `if plugin then` checks to avoid nil errors during bootstrap.
- Keep `require("lazyvim.util")` imports localized to the part of the spec that needs it to reduce load time.

## Plugin Spec Conventions
- Each `return { ... }` describes one or more plugin specs; prefer grouping related plugins in a single file (e.g., `all-themes.lua` only lists colorschemes).
- Disable features by setting `enabled = false` rather than removing specs; this documents intent (see `plugins/example.lua`).
- Options should be nested under `opts`; mutate defaults via function form (`opts = function(_, opts) ... end`) instead of deep copying.
- When adding dependencies, use `dependencies = { ... }` and keep each entry on its own line for clarity.
- Respect plugin priorities for colorschemes: set `priority = 1000` and `lazy = true` so they are available for hot reloaders.
- Use `event`, `cmd`, or `keys` to control lazy-loading; follow existing thresholds (e.g., `VeryLazy` for UI tweaks like lualine).

## Keymaps & Options Practices
- All custom mappings live in `lua/config/keymaps.lua`; keep sections separated with the existing banner comments to stay readable.
- Use `vim.keymap.set` with descriptive `desc` metadata; this powers which-key and fosters self-documenting behavior.
- Respect the `opts` table with `{ noremap = true, silent = true }` unless a mapping intentionally reuses existing mappings.
- Keep Spanish descriptions consistent (`"Buscar próximo y centrar"` style) when adding new ones to honor current tone.
- Editor options belong in `lua/config/options.lua`; align new settings with the categorized sections (visual, indent, búsqueda, etc.).

## Autocmds & Hooks
- Add new autocmds inside `lua/config/autocmds.lua`; use `vim.api.nvim_create_autocmd` with named groups prefixed by `lazyvim_` when touching defaults.
- Prefer `callback` over `command` for Lua autocmd logic.
- When removing LazyVim defaults, use `vim.api.nvim_del_augroup_by_name` with the documented group names; do not rely on numeric IDs.
- For per-plugin events, embed autocmds within the plugin `config` function (see the theme hot reload spec) so they load only when needed.

## Colorscheme & UI Guidance
- `lua/plugins/all-themes.lua` preloads many colorschemes but leaves activation to `plugins/theme` (hot reload handler). Keep new themes lazy and priority 1000.
- `plugin/after/transparency.lua` enforces `bg = "none"` on dozens of highlight groups; update it if you introduce plugins with custom highlight names to avoid mismatched backgrounds.
- `omarchy-theme-hotreload.lua` listens to the `LazyReload` user event. If you add similar functionality, reuse its module unloading approach with `lazy.core.util.walkmods` to avoid stale cache.
- After changing visual plugins, run `nvim --headless +'lua vim.cmd("redraw!")' +qa` to catch highlight issues early.

## Error Handling Expectations
- Wrap risky requires in `pcall` (see `theme_spec` loading); degrade gracefully when optional plugins are missing.
- When invoking `require("lazy.core.loader").colorscheme`, surround with `pcall` or check booleans so CI scripts do not fail on missing schemes.
- Use informative `vim.notify` or `vim.api.nvim_echo` messages when aborting (e.g., see bootstrap failure handling in `config/lazy.lua`).
- Avoid bare `print`; rely on Neovim logging facilities for clarity and log levels.

## Naming & Typing Conventions
- File names use kebab casing (e.g., `disable-news-alert.lua`) for plugin specs; keep following that pattern.
- Variables favor lower_snake_case; reserve UpperCamelCase for classes or modules provided by plugins.
- Keep leader mappings grouped by intent (navigation, edición, salida). New sections should follow the same comment slug style.
- Type annotations follow EmmyLua; place them immediately above the function they describe (`---@param` etc.).

## Commenting Style
- Use banner comments of the form `-- ==========================================================================` for large sections in config files to mirror the current structure.
- When documenting behavior for other agents, prefer concise Spanish or bilingual sentences, matching surrounding context.
- Avoid redundant comments describing obvious code; reserve notes for non-trivial tweaks (e.g., explaining why `Alt+j/k` was chosen over `<A-J>` conflicts).
- For plugin specs, inline comments should explain *why* a setting changes, not *what* the default is.

## Workflow Checklist Before Opening PRs
- [ ] Run `stylua .` to enforce formatting.
- [ ] Run `NVIM_APPNAME=nvim nvim --headless "+Lazy! sync" +qa` to ensure plugins install and configs compile.
- [ ] If you touched highlights or themes, trigger `:Lazy reload` within Neovim or via `nvim --headless "+Lazy! reload theme" +qa`.
- [ ] Verify manual behaviors impacted (keymaps, transparency, scrolling) by opening Neovim interactively.
- [ ] Update documentation (this file or `README.md`) whenever workflow expectations change.

## Adding Dependencies Safely
- Prefer Mason-managed tools when possible; add them via the `ensure_installed` array in an existing Mason spec rather than creating duplicates.
- When referencing local directories (like the theme hot reload plugin), compute paths with `vim.fn.stdpath("config")` to support alternative `NVIM_APPNAME`s.
- Keep third-party plugin tables tidy: plugin string first, then config keys, with trailing commas for future diffs.
- Never hard-code absolute user paths.

## Cursor / Copilot Policies
- No `.cursor/rules` or `.github/copilot-instructions.md` files exist, so there are no extra AI-specific policies beyond this guide.
- If such files are added later, mirror their instructions here so future agents do not miss them.

## When Unsure
- Search existing plugin specs for patterns before inventing a new layout; reusing idioms eases maintenance.
- Default to LazyVim's documented approach when repo-specific guidance is silent.
- Document assumptions directly inside this manual or relevant files to keep tribal knowledge short-lived.

## Git & Workspace Hygiene
- Treat the working tree as potentially dirty; never undo user changes you did not author unless explicitly asked.
- Avoid destructive git commands (`reset --hard`, `checkout -- <file>`, forced pushes) unless the task demands them and you documented why.
- Inspect history before committing to mirror existing commit messages and keep scope tight.
- Stage only the files you touched; config repos often track local secrets, so double-check with `git status --short`.
- Prefer new commits over amending unless the previous commit was yours and unpushed.

## Documentation & Knowledge Sharing
- Update `AGENTS.md` anytime workflows, commands, or policies shift so future agents inherit the change.
- Use bilingual comments sparingly but consistently; if a section is Spanish-first, mirror that tone in new notes.
- When behavior deviates from LazyVim defaults, mention it in-line (e.g., why `Alt+j/k` handles movement) to prevent regressions.
- Reference files explicitly (`lua/plugins/snacks-animated-scrolling-off.lua`) when describing tweaks in PR descriptions.

## Performance Profiling & Debugging
- Use `:Lazy profile` (or `nvim --headless "+Lazy! profile" +qa`) if startup feels slow after large spec changes.
- `:checkhealth` helps confirm external tools (ripgrep, tree-sitter) are available; run it when diagnostics misbehave.
- For highlight glitches, temporarily disable `plugin/after/transparency.lua` and re-run `:colorscheme` to isolate issues.
- Log from Lua with `vim.notify` plus log levels; avoid `print` because it can block the UI after `LazyReload`.

## Troubleshooting Checklist
- Plugin fails to load: ensure it appears in `lazy-lock.json`; if missing, run `:Lazy sync` and check logs under `~/.local/share/nvim/lazy/log`.
- Keymap missing: verify duplicates in `lua/config/keymaps.lua` and check `which-key` output for conflicts.
- Theme reload stuck: confirm `LazyReload` User autocommand fired; run `:doautocmd User LazyReload` manually to retrigger.
- Transparency overlap: extend the highlight list inside `plugin/after/transparency.lua` for the affected group, then `:source` the file.
- Mason install errors: open `:Mason` and reinstall from there; ensure `git` is reachable if clones time out.

## Release & Versioning Notes
- `lazy-lock.json` pins plugin commits; regenerate with `:Lazy sync` only when you intend to update dependencies.
- Keep lockfile diffs separate from behavioral changes when possible to simplify reviews.
- Version tags of third-party plugins are rarely used (`version = false`); rely on upstream HEAD to stay current unless regressions occur.
- Document any manual pinning decisions (e.g., `opts.branch`) near the spec to justify why it deviates from default.

## Final Notes
- Keep this manual close to ~150 lines; expand cautiously.
- Treat every edit as something another agent must understand at a glance.
- Happy hacking!
