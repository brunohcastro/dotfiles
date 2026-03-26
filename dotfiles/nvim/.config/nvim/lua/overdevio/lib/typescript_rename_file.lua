local async = require("typescript-tools.async")
local a = require("plenary.async")
local c = require("typescript-tools.protocol.constants")
local utils = require("typescript-tools.utils")

local M = {}

local get_typescript_client = utils.get_typescript_client

local function ts_rename_file(force_save)
	local source = vim.api.nvim_buf_get_name(0)
	local source_bufnr = vim.fn.bufadd(source)
	vim.fn.bufload(source_bufnr)

	local open_buffer_names = {}

	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		open_buffer_names[vim.api.nvim_buf_get_name(bufnr)] = true
	end

	a.void(function()
		local target = async.ui_input({ prompt = "New path: ", default = source })

		if not target then
			return
		end

		vim.fn.mkdir(vim.fn.fnamemodify(target, ":p:h"), "p")

		local err, result = async.buf_request_isomorphic(false, 0, c.LspMethods.WillRenameFiles, {
			files = {
				{
					oldUri = vim.uri_from_fname(source),
					newUri = vim.uri_from_fname(target),
				},
			},
		})

		local changes = result and result.changes
		if not err and changes then
			local fs_exist = vim.loop.fs_stat(target)
			if fs_exist then
				local status = vim.fn.confirm("File exists! Overwrite?", "&Yes\n&No")

				if status ~= 1 then
					vim.notify_once("Declined to overrwrite file; aborting", vim.log.levels.ERROR)
					return
				end
			end

			vim.lsp.util.apply_workspace_edit(result or {}, "utf-8")

			if vim.api.nvim_buf_get_option(source_bufnr, "modified") then
				vim.api.nvim_buf_call(source_bufnr, function()
					vim.cmd("w!")
				end)
			end

			local success = vim.uv.fs_rename(source, target)
			if not success then
				vim.notify("Failed to rename file", vim.log.levels.ERROR)
				return
			end

			local target_bufnr = vim.fn.bufadd(target)
			vim.api.nvim_buf_set_option(target_bufnr, "buflisted", true)
			vim.api.nvim_buf_call(target_bufnr, function()
				vim.cmd("e!")
			end)

			for _, win in ipairs(vim.api.nvim_list_wins()) do
				if vim.api.nvim_win_get_buf(win) == source_bufnr then
					vim.api.nvim_win_set_buf(win, target_bufnr)
				end
			end

			vim.schedule(function()
				for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
					if bufnr ~= target_bufnr and vim.api.nvim_buf_is_valid(bufnr) then
						local bufname = vim.api.nvim_buf_get_name(bufnr)

						if
							changes[vim.uri_from_fname(bufname)]
							and (not open_buffer_names[bufname] or bufname == source)
							and bufname ~= nil
							and bufname ~= ""
						then
							if force_save or bufname == source then
								if vim.api.nvim_buf_get_option(bufnr, "modified") then
									vim.api.nvim_buf_call(bufnr, function()
										vim.cmd("w!")
									end)
								end

								local ts_client = get_typescript_client(bufnr)

								if ts_client then
									vim.lsp.buf_detach_client(bufnr, ts_client.id)

									vim.lsp.buf_request_sync(
										bufnr,
										c.LspMethods.DidClose,
										{ textDocument = { uri = vim.uri_from_fname(bufname) } }
									)
								end

								vim.cmd.bwipeout({ count = bufnr, bang = true })
							end
						end
					end
				end
			end)
		end
	end)()
end

local function create_command(name, fn)
	local command_completion = {
		nargs = "?",
		complete = function()
			return { "force_save" }
		end,
	}
	vim.api.nvim_create_user_command(name, function(cmd)
		local words = cmd.fargs

		if #words == 1 and words[1] ~= "force_save" then
			vim.notify("No such command", vim.log.levels.ERROR)
			return
		end

		fn(#words == 1)
	end, command_completion)
end

function M.setup_commands()
	create_command("OverdevioTSRenameFile", function(force_save)
		ts_rename_file(force_save)
	end)
end

return M
