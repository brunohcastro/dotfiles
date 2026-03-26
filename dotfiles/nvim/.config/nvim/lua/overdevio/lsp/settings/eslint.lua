local status, lspconfig_util = pcall(require, "lspconfig.util")

if not status then
	return
end

return {
	codeActionsOnSave = {
		enable = false,
	},
	format = false,
}
