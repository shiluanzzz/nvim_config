return {
  {
    "codota/tabnine-nvim",
    build = "./dl_binaries.sh",
    config = function()
      require("tabnine").setup({
        disable_auto_common = true,
        accept_keymap = "<C-n>",
        dismiss_keymap = "<C-]",
      })
    end,
  },
}
