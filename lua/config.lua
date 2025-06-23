-- Cài đặt cơ bản
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"
vim.opt.cursorline = true
vim.g.mapleader = " "

-- Tự động load file cấu hình khi mở file Java
vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    require("java")
  end,
})

-- Tải Lazy.nvim nếu chưa có
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- Danh sách plugin
require("lazy").setup({

  -- Giao diện
  { "ellisonleao/gruvbox.nvim", priority = 1000 },
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },

  -- Tìm kiếm
  { "nvim-telescope/telescope.nvim", tag = "0.1.5", dependencies = { "nvim-lua/plenary.nvim" } },

  -- Highlight cú pháp
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- Java LSP
  { "mfussenegger/nvim-jdtls", ft = { "java" } },
  { "neovim/nvim-lspconfig" },

  -- Gợi ý code (cmp + LSP + snippet)
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
})

-- Giao diện
vim.cmd.colorscheme("gruvbox")
require("lualine").setup()

-- Keymap tiện ích
vim.keymap.set("n", "<C-p>", ":Telescope find_files<CR>")
vim.keymap.set("n", "<C-f>", ":Telescope live_grep<CR>")

-- Di chuyển cửa sổ từ terminal mode (toggleterm)
-- Chuyển giữa các cửa sổ từ terminal mode
vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], { desc = "Window left" })
vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], { desc = "Window up" })
vim.keymap.set("t", "<A-j>", [[<C-\><C-n><C-w>j]], { desc = "Window down" }) -- Alt + j thay vì Ctrl + j
vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], { desc = "Window right" })


-- Treesitter cấu hình
require("nvim-treesitter.configs").setup({
  ensure_installed = { "java", "lua", "vim", "bash" },
  highlight = { enable = true },
})

