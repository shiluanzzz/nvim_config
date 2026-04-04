local function get_jedi_init_options()
  local cwd = vim.fn.getcwd()
  local venv_dir = cwd .. "/.venv"

  if vim.fn.isdirectory(venv_dir) == 1 then
    return {
      workspace = {
        environmentPath = venv_dir,
      },
    }
  end

  local python = venv_dir .. "/bin/python"
  if vim.fn.executable(python) == 1 then
    return {
      workspace = {
        environmentPath = python,
      },
    }
  end
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        jedi_language_server = {
          init_options = get_jedi_init_options(),
        },
      },
    },
  },
}
