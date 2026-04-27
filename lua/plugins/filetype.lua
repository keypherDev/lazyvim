return {
  {
    "LazyVim/LazyVim",
    lazy = false,
    init = function()
      vim.filetype.add({
        pattern = {
          [".*%.blade%.php"] = "blade",
        },
      })
    end,
  },
}
