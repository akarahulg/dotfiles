return {
	"neovim/nvim-lspconfig",
	lazy = false,
	config = function()
		local lspconfig = require("lspconfig")

		lspconfig.pyright.setup {}
		lspconfig.ts_ls.setup {}
		lspconfig.cssls.setup {}
		lspconfig.html.setup {}
	end,
}
