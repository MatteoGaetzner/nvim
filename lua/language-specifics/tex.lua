-- Function to close Skim on macOS
function close_skim()
	os.execute("osascript -e 'tell application \"Skim\" to quit'")
end

-- Function to close the viewer on Linux using xdotool and Vimscript
function close_linux_viewer()
	vim.api.nvim_exec2([[
      if executable('xdotool') && exists('b:vimtex.viewer.xwin_id') && b:vimtex.viewer.xwin_id > 0
        call system('xdotool windowclose ' . b:vimtex.viewer.xwin_id)
      endif
    ]], false)
end

-- Check if the system is macOS or Linux and register the appropriate autocommand
local system_info = vim.loop.os_uname()
if system_info.sysname == "Darwin" then
	-- For macOS
	vim.cmd [[ autocmd User VimtexEventQuit lua close_skim() ]]
else
	-- For Linux
	vim.cmd [[ autocmd User VimtexEventQuit lua close_linux_viewer() ]]
end
