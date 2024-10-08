import("lualine", function(lualine)
	local function getLsp()
		local msg = "No Active Lsp"
		local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
		local clients = vim.lsp.get_active_clients()
		if next(clients) == nil then
			return msg
		end
		for _, client in ipairs(clients) do
			local filetypes = client.config.filetypes
			if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
				return client.name
			end
		end
		return msg
	end

	local function isRecording()
		local reg = vim.fn.reg_recording()
		if reg == "" then
			return ""
		end
		return "REC @" .. reg
	end

	lualine.setup({
		options = {
			icons_enabled = true,
			globalstatus = true,
			component_separators = { left = "", right = "" },
			section_separators = { left = "", right = "" },
			disabled_filetypes = { "neo-tree-popup", "alpha", status_line = {}, winbar = {} },
			theme = "tokyonight",
			always_divide_middle = true,
		},
		sections = {
			lualine_a = { "mode", isRecording },
			lualine_b = { "branch", "diff" },
			lualine_c = { "filename" },
			lualine_x = { "diagnostics", getLsp, "encoding", "fileformat", "filetype" },
			lualine_y = { "progress" },
			lualine_z = { "location" },
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = { "filename" },
			lualine_x = { "location" },
			lualine_y = {},
			lualine_z = {},
		},
		inactive_winbar = {},
		extensions = { "neo-tree", "toggleterm", "fugitive" },
		tabline = {},
		winbar = {},
	})
end)
