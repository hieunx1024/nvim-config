-- Tránh tạo lại terminal mỗi lần require
local java_term = nil

local status_ok, jdtls = pcall(require, "jdtls")
if not status_ok then
  vim.notify("jdtls không tồn tại", vim.log.levels.ERROR)
  return
end

local home = os.getenv("HOME")
local workspace_dir = home .. "/.local/share/jdtls-workspace/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

local capabilities = vim.tbl_deep_extend(
  "force",
  vim.lsp.protocol.make_client_capabilities(),
  require("cmp_nvim_lsp").default_capabilities() or {}
)

local config = {
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    "-jar", vim.fn.glob(home .. "/.local/share/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
    "-configuration", home .. "/.local/share/jdtls/config_linux",
    "-data", workspace_dir,
  },
  root_dir = require("jdtls.setup").find_root({ ".git", "pom.xml", "build.gradle" }),
  capabilities = capabilities,

  -- Bật tính năng format cho jdtls
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = true

    -- Optional: keymap format tay
    vim.keymap.set("n", "<leader>f", function()
      vim.lsp.buf.format({ async = true })
    end, { desc = "Format file", buffer = bufnr })
  end,
}

jdtls.start_or_attach(config)

-- Tạo terminal 1 lần duy nhất
if not java_term then
  local Terminal = require("toggleterm.terminal").Terminal
  java_term = Terminal:new({
    id = 99,
    direction = "horizontal",
    hidden = true,
    close_on_exit = false,
  })
end

-- Keymap chạy file Java hiện tại
vim.keymap.set("n", "<leader>cj", function()
  local filename = vim.fn.expand("%:t")
  local classname = filename:gsub("%.java$", "")
  local folder = vim.fn.expand("%:p:h")

  java_term:open()
  local cmd = string.format("cd '%s' && javac '%s' && java '%s'", folder, filename, classname)
  java_term:send("clear && " .. cmd .. "\n", false)
end, { desc = "Chạy file Java hiện tại", buffer = true })

