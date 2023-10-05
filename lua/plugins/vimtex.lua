return {
	"lervag/vimtex",
	init = function()
		-- Common settings
		vim.g.vimtex_compiler_latexmk = {
			out_dir = "build",
			aux_dir = "build",
			executable = "latexmk",
			options = {
				"-pdf",
				"-pdflatex='lualatex -synctex=1 -interaction=nonstopmode -file-line-error'",
				"-shell-escape",
				"-outdir=build",
				"-synctex=1",
			},
		}
		vim.opt_local.conceallevel = 0
		vim.g.tex_flavor = 'latex'
		vim.g.vimtex_quickfix_open_on_warning = 0

		-- Detect operating system and set OS-specific settings
		local os_name = vim.loop.os_uname().sysname

		if os_name == "Darwin" then -- MacOS
			vim.g.vimtex_view_method = 'skim'
			vim.g.vimtex_view_skim_sync = 1
			vim.g.vimtex_view_skim_activate = 1
		elseif os_name == "Linux" then
			vim.g.vimtex_synctex = 1
			vim.g.vimtex_view_general_viewer = 'okular'
			vim.g.vimtex_view_general_options = "--unique file:@pdf\\#src:@line@tex"
		else
			print("Error: Unsupported operating system for VimTeX.")
		end
	end,
}
