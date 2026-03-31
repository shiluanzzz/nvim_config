return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        jedi_language_server = {
          init_options = {
            workspace = {
              environmentPath = vim.fn.getcwd() .. "/.venv/bin/python",
            },
          },
        },
      },
    },
  },
}
