return {
  -- Lazy quản lý chính nó
  { "folke/lazy.nvim" },

  -- File explorer
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },

  -- Terminal
  { "akinsho/toggleterm.nvim" },

  -- LSP & Autocomplete
  { "neovim/nvim-lspconfig" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },

  -- Java LSP
  { "mfussenegger/nvim-jdtls" },

  -- Giao diện & tiện ích
  { "nvim-lualine/lualine.nvim" },
  { "ellisonleao/gruvbox.nvim" },

  -- Syntax highlight
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- Fuzzy finder
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
}

