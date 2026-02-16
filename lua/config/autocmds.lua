-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)

local prettierd_cleanup = vim.api.nvim_create_augroup("local_prettierd_cleanup", { clear = true })

vim.api.nvim_create_autocmd("VimLeavePre", {
  group = prettierd_cleanup,
  callback = function()
    -- Cierra los procesos prettierd que no tienen clientes activos
    vim.fn.jobstart({ "pkill", "-f", "prettierd" }, { detach = true })
  end,
})
