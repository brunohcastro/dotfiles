import("typescript-tools", function(ts_tools)
	ts_tools.setup({
		settings = {
			separate_diagnostic_server = false,
			complete_function_calls = true,
			tsserver_file_preferences = {
				includeCompletionsForModuleExports = true,
				allowRenameOfImportPath = true,
			},
		},
	})
end)
