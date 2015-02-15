
function! s:repeatableCall(...)
	let s:func=a:1
	let s:args=a:000[1:]
	call call(s:func, s:args)
	call repeat#set("\<Plug>VBGrepeat", v:count)
endfunction

function! s:VBGrepeat()
	call call(s:func, s:args)
endfunction

nmap <silent> <Plug>VBGrepeat :call <SID>VBGrepeat()<CR>

command! -nargs=1 VBGrawWrite call s:repeatableCall('vebugger#writeLine',<q-args>)
command! -nargs=0 VBGkill call vebugger#killDebugger()

command! -nargs=0 VBGstepIn call s:repeatableCall('vebugger#setWriteActionAndPerform','std','flow','stepin')
command! -nargs=0 VBGstepOver call s:repeatableCall('vebugger#setWriteActionAndPerform','std','flow','stepover')
command! -nargs=0 VBGstepOut call s:repeatableCall('vebugger#setWriteActionAndPerform','std','flow','stepout')
command! -nargs=0 VBGcontinue call s:repeatableCall('vebugger#setWriteActionAndPerform','std','flow','continue')

command! -nargs=0 VBGtoggleTerminalBuffer call vebugger#toggleTerminalBuffer()
command! -nargs=+ -complete=file VBGtoggleBreakpoint call vebugger#std#toggleBreakpoint(<f-args>)
command! -nargs=0 VBGtoggleBreakpointThisLine call s:repeatableCall('vebugger#std#toggleBreakpoint', expand('%:~:.'),line('.'))
command! -nargs=0 VBGclearBreakpints call vebugger#std#clearBreakpoints()

command! -nargs=1 VBGeval call s:repeatableCall('vebugger#std#eval',<q-args>)
command! -nargs=0 VBGevalWordUnderCursor call s:repeatableCall('vebugger#std#eval',expand('<cword>'))
command! -nargs=1 VBGexecute call s:repeatableCall('vebugger#std#execute',<q-args>)

command! -range -nargs=0 VBGevalSelectedText call s:repeatableCall('vebugger#std#eval',vebugger#util#get_visual_selection())
command! -range -nargs=0 VBGexecuteSelectedText call s:repeatableCall('vebugger#std#execute',vebugger#util#get_visual_selection())
command! -range -nargs=0 VBGrawWriteSelectedText call s:repeatableCall('vebugger#writeLine',vebugger#util#get_visual_selection())

command! -nargs=+ -complete=file VBGstartGDB call vebugger#gdb#start([<f-args>][0],{'args':[<f-args>][1:]})
command! -nargs=1 -complete=file VBGattachGDB call vebugger#gdb#searchAndAttach(<q-args>)
command! -nargs=+ -complete=file VBGstartRDebug call vebugger#rdebug#start([<f-args>][0],{'args':[<f-args>][1:]})
command! -nargs=+ -complete=file VBGstartPDB call vebugger#pdb#start([<f-args>][0],{'args':[<f-args>][1:]})
command! -nargs=+ -complete=file VBGstartPDB2 call vebugger#pdb#start([<f-args>][0],{'args':[<f-args>][1:],'version':'2'})
command! -nargs=+ -complete=file VBGstartPDB3 call vebugger#pdb#start([<f-args>][0],{'args':[<f-args>][1:],'version':'3'})
command! -nargs=+ -complete=file VBGstartGDBForD call vebugger#gdb#start([<f-args>][0],{'args':[<f-args>][1:],'entry':'_Dmain'})

if exists('g:vebugger_leader')
	if !empty(g:vebugger_leader)
		for s:mapping in items({
					\'i':'VBGstepIn',
					\'o':'VBGstepOver',
					\'O':'VBGstepOut',
					\'c':'VBGcontinue',
					\'t':'VBGtoggleTerminalBuffer',
					\'b':'VBGtoggleBreakpointThisLine',
					\'B':'VBGclearBreakpints',
					\'e':'VBGevalWordUnderCursor',
					\'E':'exe "VBGeval ".input("VBG-Eval> ")',
					\'x':'exe "VBGexecute ".getline(".")',
					\'X':'exe "VBGexecute ".input("VBG-Exec> ")',
					\'R':'exe "VBGrawWrite ".input("VBG> ")'})
			exe 'nnoremap '.g:vebugger_leader.s:mapping[0].' :'.s:mapping[1].'<Cr>'
		endfor
		for s:mapping in items({
					\'e':'VBGevalSelectedText',
					\'x':'VBGexecuteSelectedText',
					\'r':'VBGrawWriteSelectedText'})
			exe 'vnoremap '.g:vebugger_leader.s:mapping[0].' :'.s:mapping[1].'<Cr>'
		endfor
	endif
endif
