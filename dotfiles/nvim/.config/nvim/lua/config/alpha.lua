import({ "alpha", "alpha.themes.dashboard" }, function(modules)
	local alpha = modules.alpha
	local dashboard = modules["alpha.themes.dashboard"]

	dashboard.section.header.val = {
		[[                                                                                 ]],
		[[                                                                                 ]],
		[[                                                                                 ]],
		[[                                                                                 ]],
		[[                                                                ,,wuuuw,_        ]],
		[[                                                         _,gmR88888888888By      ]],
		[[           ,,gRRRRRRRBRRRWmmuw,,,._                _wmmB8888888@8RRRRRBRBR8Ru    ]],
		[[        ,m888888888888888888888888888B>        ,aRB88888888BP*`            `B    ]],
		[[      uPRRP"`    ``""**PRRRR88888888E`         y$88888RP"                        ]],
		[[                                 `               `""`                            ]],
		[[    _,,wummmRRRBRR8888RRBRRWmu,,_                   ,,ummRRBRR8888RBBRRRmmuuw,,, ]],
		[[   _88888RP"`              `""*PB@Rm,_        _,gRRBP^""`              `"YB88888B]],
		[[   `8888B                         `%888RBRRBR888B`                         %8888H]],
		[[    "088P                           %8888888888B                           !88R" ]],
		[[      $8L                            88@8888888H                           .88   ]],
		[[      _8P                            88"    "R8L                           !8B   ]],
		[[      '8B                           A8P      !8B                           ]8P   ]],
		[[       R8_                         ;8B        TBU                          88    ]],
		[[       `8B                        /8B          %8U                        88^    ]],
		[[        "8R_                    ,08P            *8B,                    .R8"     ]],
		[[          T8Bu,,,____     __,,mBRP                *RBWw,__     ____,,,gRRP       ]],
		[[            `**PPRRBBB888BRRP*"                      "*PRBR888RBRRRPP^"`         ]],
		[[                                                                                 ]],
		[[                                                                                 ]],
	}

	dashboard.section.buttons.val = {
		dashboard.button("f", "  Find file", "<cmd>lua require('telescope.builtin').find_files()<cr>"),
		dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
		dashboard.button("p", "  Find project", ":Telescope project <CR>"),
		dashboard.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
		dashboard.button("t", "  Find text", ":Telescope live_grep <CR>"),
		dashboard.button("c", "  Configuration", ":e ~/.config/nvim/init.lua <CR>"),
		dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
	}

	local function footer()
		return "“The ship of failure floats in a sea of excuses”"
	end

	dashboard.section.footer.val = footer()

	dashboard.section.footer.opts.hl = "Type"
	dashboard.section.header.opts.hl = "Include"
	dashboard.section.buttons.opts.hl = "Keyword"

	dashboard.opts.opts.noautocmd = true
	alpha.setup(dashboard.opts)
end)
