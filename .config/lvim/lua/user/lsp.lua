lvim.format_on_save = false
lvim.lsp.diagnostics.virtual_text = false

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "java",
}

vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "jdtls" })

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { command = "google_java_format", filetypes = { "java" } },
  { command = "stylua", filetypes = { "lua" } },
}

vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "html" })
local opts = {
  filetypes = { "html", "htmldjango" }
}
require("lvim.lsp.manager").setup("html", opts)

local opts = {
  root_dir = function (fname)
    print(fname)
    return require("lspconfig").util.root_pattern(".git")(fname) or require("lspconfig").util.path.dirname(fname)
  end,
  filetypes = { "html", "htmldjango" }
}
require("lvim.lsp.manager").setup("tailwindcss", opts)

-- lvim.lsp.on_attach_callback = function(client, bufnr)
-- end

-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup {
--   { command = "eslint_d", filetypes = { "javascript" } },
-- }
