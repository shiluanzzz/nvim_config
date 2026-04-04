-- 获取当前会话可用的 Git 根目录，优先使用当前文件所在目录，其次回退到当前工作目录。
local function get_git_root()
  local current_file = vim.api.nvim_buf_get_name(0)
  local start_path = current_file ~= "" and vim.fs.dirname(current_file) or vim.fn.getcwd()
  local git_dir = vim.fs.find(".git", { path = start_path, upward = true })[1]

  return git_dir and vim.fs.dirname(git_dir) or nil
end

-- 统一用 Git 根目录启动 Diffview，避免在 dashboard、终端或其它无文件 buffer 中误判仓库。
local function open_diffview()
  local git_root = get_git_root()
  if not git_root then
    vim.notify("当前窗口没有定位到 Git 仓库", vim.log.levels.ERROR)
    return
  end

  vim.cmd(("DiffviewOpen -C%s"):format(vim.fn.fnameescape(git_root)))
end

-- 业务决策点：当当前窗口不是实际文件时，自动退回到仓库历史，而不是继续传空的 `%` 给 Diffview。
local function open_file_history()
  local git_root = get_git_root()
  if not git_root then
    vim.notify("当前窗口没有定位到 Git 仓库", vim.log.levels.ERROR)
    return
  end

  local current_file = vim.api.nvim_buf_get_name(0)
  local is_real_file = current_file ~= "" and vim.bo.buftype == ""

  if not is_real_file then
    vim.cmd(("DiffviewFileHistory -C%s"):format(vim.fn.fnameescape(git_root)))
    return
  end

  local relative_path = vim.startswith(current_file, git_root .. "/")
      and current_file:sub(#git_root + 2)
    or current_file

  vim.cmd(
    ("DiffviewFileHistory -C%s -- %s"):format(
      vim.fn.fnameescape(git_root),
      vim.fn.fnameescape(relative_path)
    )
  )
end

return {
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", open_diffview, desc = "Git Diffview" },
      { "<leader>gh", open_file_history, desc = "Git File History" },
    },
    opts = {},
  },
}
