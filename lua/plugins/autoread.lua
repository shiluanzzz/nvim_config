return {
  {
    "nvim-treesitter/nvim-treesitter", -- 顺便保留你之前的配置
    opts = function(_, opts)
      require("nvim-treesitter.install").prefer_git = true
    end,
  },
  -- ↓↓↓ 新增这个 autocmd 配置 ↓↓↓
  {
    "folke/lazy.nvim",
    opts = function()
      vim.o.autoread = true   -- 自动检测外部修改

      local group = vim.api.nvim_create_augroup("AutoReload", { clear = true })

      -- 这些事件触发时检查文件是否被外部改动
      vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
        group = group,
        command = "checktime",
      })

      -- 文件被外部修改时，弹出提示让用户选择
      vim.api.nvim_create_autocmd("FileChangedShell", {
        group = group,
        callback = function(args)
          vim.schedule(function()
            local choice = vim.fn.confirm(
              args.file .. " 被外部 AI 修改了，是否重新加载？",
              "&Yes\n&No\n&Diff",
              1,
              "Question"
            )
            if choice == 1 then
              vim.cmd("edit!")          -- 强制重新加载（丢弃本地修改）
            elseif choice == 3 then
              vim.cmd("vertical diffsplit " .. vim.fn.fnameescape(args.file))  -- 对比差异
            end
          end)
        end,
      })
    end,
  },
}
