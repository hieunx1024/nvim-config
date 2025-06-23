-- Leader key
vim.g.mapleader = " "

-- Thêm Lazy.nvim vào runtimepath
vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/lazy/lazy.nvim")

-- Load plugin từ thư mục lua/plugins/
require("lazy").setup("plugins")

-- Tắt highlight khi nhấn Esc
vim.keymap.set("n", "<Esc>", "<Cmd>nohlsearch<CR>", { silent = true })

-- Load cấu hình chung nếu có
pcall(require, "config")

-- Tự động load cấu hình Java khi mở file .java
vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    local ok, err = pcall(require, "java")
    if not ok then
      vim.notify("Không thể load cấu hình Java (java.lua): " .. err, vim.log.levels.ERROR)
    end
  end,
})

