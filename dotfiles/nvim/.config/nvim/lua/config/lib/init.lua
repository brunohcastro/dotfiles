local ts_rename_file = require("config.lib.typescript_rename_file")
local buffer_search = require("config.lib.telescope_buffer_search_with_delete")

local function bootstrap()
	ts_rename_file.setup_commands()
	buffer_search.setup_commands()
end

bootstrap()
