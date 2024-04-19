" Better Navigation
nnoremap <silent> <C-j> :call VSCodeNotify('workbench.action.navigateDown')<CR>
xnoremap <silent> <C-j> :call VSCodeNotify('workbench.action.navigateDown')<CR>
nnoremap <silent> <C-k> :call VSCodeNotify('workbench.action.navigateUp')<CR>
xnoremap <silent> <C-k> :call VSCodeNotify('workbench.action.navigateUp')<CR>
nnoremap <silent> <C-h> :call VSCodeNotify('workbench.action.navigateLeft')<CR>
xnoremap <silent> <C-h> :call VSCodeNotify('workbench.action.navigateLeft')<CR>
nnoremap <silent> <C-l> :call VSCodeNotify('workbench.action.navigateRight')<CR>
xnoremap <silent> <C-l> :call VSCodeNotify('workbench.action.navigateRight')<CR>

nnoremap <silent> <C-w>_ :<C-u>call VSCodeNotify('workbench.action.toggleEditorWidths')<CR>

nnoremap <silent> <Space> :call VSCodeNotify('whichkey.show')<CR>
xnoremap <silent> <Space> :call VSCodeNotify('whichkey.show')<CR>

" Normal mode non-recursive mappings
" Delete a line with <leader>d
nnoremap <leader>d dd

" Focus the terminal with <leader>i
nnoremap <leader>j :call VSCodeNotify('workbench.action.terminal.focus')<CR>

" Focus the active editor group with <leader>u
nnoremap <leader>u :call VSCodeNotify('workbench.action.focusActiveEditorGroup')<CR>

" Open the quick open panel with <leader>p and <leader>o
nnoremap <leader>p :call VSCodeNotify('workbench.action.quickOpen')<CR>
nnoremap <leader>o :call VSCodeNotify('workbench.action.quickOpen')<CR>

" Toggle the terminal with <leader>n
" nnoremap <leader>j :call VSCodeNotify('workbench.action.terminal.toggleTerminal')<CR>

" Split the editor with <leader>v
nnoremap <leader>v :call VSCodeNotify('workbench.action.splitEditor')<CR>

" Focus the first editor group with <leader>h
nnoremap <leader>h :call VSCodeNotify('workbench.action.focusFirstEditorGroup')<CR>

" Focus the second editor group with <leader>l
nnoremap <leader>l :call VSCodeNotify('workbench.action.focusSecondEditorGroup')<CR>

" Clear search highlighting with <C-n>
nnoremap <C-n> :call VSCodeNotify(':nohl')<CR>

" nnoremap <leader>e :call VSCodeNotify('workbench.veiw.explorer')<CR>
