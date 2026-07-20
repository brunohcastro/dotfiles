vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/folke/snacks.nvim" },
	{ src = "https://github.com/coder/claudecode.nvim" },
	{ src = "https://github.com/olimorris/codecompanion.nvim" },
})

require("claudecode").setup()

-- Local-LLM chat via codecompanion → llama-swap (loads the 30B on first use).
require("codecompanion").setup({
	adapters = {
		http = {
			llama = function()
				return require("codecompanion.adapters").extend("openai_compatible", {
					env = {
						url = "http://localhost:8081",
						api_key = "ollama",
						chat_url = "/v1/chat/completions",
					},
					schema = {
						model = { default = "ornith-9b" },
					},
				})
			end,
		},
	},
	strategies = {
		chat = { adapter = "llama" },
		inline = { adapter = "llama" },
		cmd = { adapter = "llama" },
	},
})

local map = vim.keymap.set
map({ "n", "v" }, "<leader>at", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "CodeCompanion chat" })
map({ "n", "v" }, "<leader>ax", "<cmd>CodeCompanionActions<cr>", { desc = "CodeCompanion actions" })
map("n", "<leader>ac", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude" })
map("n", "<leader>af", "<cmd>ClaudeCodeFocus<cr>", { desc = "Focus Claude" })
map("n", "<leader>ar", "<cmd>ClaudeCode --resume<cr>", { desc = "Resume Claude" })
map("n", "<leader>aC", "<cmd>ClaudeCode --continue<cr>", { desc = "Continue Claude" })
map("n", "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", { desc = "Select Claude model" })
map("n", "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", { desc = "Add current buffer" })
map("v", "<leader>as", "<cmd>ClaudeCodeSend<cr>", { desc = "Send to Claude" })
map("n", "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "Accept diff" })
map("n", "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", { desc = "Deny diff" })
