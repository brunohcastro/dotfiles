import("typescript-tools", function(ts_tools)
	ts_tools.setup({
		settings = {
			separate_diagnostic_server = false,
			expose_as_code_action = { "all" },
			complete_function_calls = true,
			tsserver_file_preferences = {
				includeCompletionsForModuleExports = true,
				allowRenameOfImportPath = true,
			},
		},
	})

	require("config.lib.typescript_rename_file").setup_commands()
end)
