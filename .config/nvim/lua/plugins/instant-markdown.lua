-- plugin/instant-markdown.lua

return {
	"instant-markdown/vim-instant-markdown",
	ft = "markdown", -- Load only for markdown files
	config = function()
		-- Optional global variables for configuration
		vim.g.instant_markdown_slow = 1
		vim.g.instant_markdown_autostart = 1
		vim.g.instant_markdown_open_to_the_world = 0
		vim.g.instant_markdown_allow_unsafe_content = 1
		vim.g.instant_markdown_port = 8888 -- Optional: fixed port

		-- Optional keymap for previewing markdown
		vim.keymap.set("n", "<leader>mp", ":InstantMarkdownPreview<CR>", { desc = "Markdown Preview" })
	end
}
