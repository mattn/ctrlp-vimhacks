if exists('g:loaded_ctrlp_vimhacks') && g:loaded_ctrlp_vimhacks
  finish
endif
let g:loaded_ctrlp_vimhacks = 1

let s:vimhacks_var = {
\  'init':   'ctrlp#vimhacks#init()',
\  'exit':   'ctrlp#vimhacks#exit()',
\  'accept': 'ctrlp#vimhacks#accept',
\  'lname':  'vimhacks',
\  'sname':  'vimhacks',
\  'type':   'path',
\  'sort':   0,
\  'nolim':   1,
\}

if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
  let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:vimhacks_var)
else
  let g:ctrlp_ext_vars = [s:vimhacks_var]
endif

function! ctrlp#vimhacks#init()
  let res = webapi#http#get("http://vim-jp.org/vim-users-jp/hack.json")
  let s:list = webapi#json#decode(res.content)
  return map(copy(s:list), 'v:val.title')
endfunc

function! ctrlp#vimhacks#accept(mode, str)
  let link = filter(copy(s:list), 'v:val.title ==# a:str')[0]["url"]
  call ctrlp#exit()
  redraw!
  try
		call openbrowser#open(link)
  finally
  endtry
endfunction

function! ctrlp#vimhacks#exit()
  if exists('s:list')
    unlet! s:list
  endif
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#vimhacks#id()
  return s:id
endfunction

" vim:fen:fdl=0:ts=2:sw=2:sts=2
