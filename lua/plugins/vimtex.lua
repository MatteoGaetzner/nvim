return {
	"lervag/vimtex",
	init = function()
		vim.g.vimtex_compiler_latexmk = {
			build_dir = "./build",
			options = {
				"-outdir=build",
				"-pdf",
				-- "-pdflatex='pdflatex -synctex=1 -interaction=nonstopmode -file-line-error'",
				"-pdflatex='lualatex -synctex=1 -interaction=nonstopmode -file-line-error'",
				"-shell-escape",
			},
		}
		vim.opt_local.conceallevel = 0
		vim.g.tex_flavor = 'latex' -- Default tex file format
		vim.g.vimtex_view_method = 'skim' -- Choose which program to use to view PDF file
		vim.g.vimtex_view_skim_sync = 1 -- Value 1 allows forward search after every successful compilation
		vim.g.vimtex_view_skim_activate = 1 -- Value 1 allows change focus to skim after command `:VimtexView` is given
	end,
}
