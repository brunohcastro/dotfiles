import("typescript-tools", function(ts_tools)
	ts_tools.setup({
		settings = {
			tsserver_file_preferences = {
				includeInlayParameterNameHints = "all",
				includeCompletionsForModuleExports = true,
				allowRenameOfImportPath = true,
			},
		},
	})
end)
