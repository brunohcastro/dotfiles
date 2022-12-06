return {
	cmd = { "rustup", "run", "nightly", "rust-analyzer" },
	settings = {
		rust = {
			unstable_features = true,
			build_on_save = false,
			all_features = true,
		},
	},
}
