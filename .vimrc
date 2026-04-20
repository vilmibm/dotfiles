" This file assumes installation of:
" - FZF -- specifically, a clone of junegunn/fzf at ~/src/fzf as well as the fzf binary
" - ag -- silversearch-ag package on debian

" Environment overrides

let $FZF_DEFAULT_COMMAND = 'ag -l --ignore=vendor --ignore=__pycache__ -g ""'
"this failed idk why
"let $FZF_DEFAULT_COMMAND = 'rg -l --ignore ~/src/dotfiles/rg.ignore -g ""'

" Plugin setup

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plug')

" increase timeout for YCM
let g:plug_timeout = 300

set rtp+=~/src/fzf
let &rtp .= ',' . expand( '<sfile>:p:h' )

Plug '~/src/fzf'
Plug 'junegunn/fzf.vim'
Plug 'flazz/vim-colorschemes'
Plug 'arcticicestudio/nord-vim'
Plug 'vimwiki/vimwiki'
Plug 'tpope/vim-fugitive'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'arcticicestudio/nord-vim'
"Plug 'Valloric/YouCompleteMe', { 'do': './install.py --all' }
Plug 'rose-pine/vim'
Plug 'godlygeek/tabular'
Plug 'shaoran/vim-ruff'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'habamax/vim-godot'
" this thing made lists go wacky:
"Plug 'preservim/vim-markdown'
"Plug '~/src/vim-hy'

call plug#end()

" Settings

syntax on
filetype plugin indent on

" use soft wrapping
" https://vim.fandom.com/wiki/Word_wrap_without_line_breaks
set textwidth=0
set wrapmargin=0
set wrap
set linebreak

set shiftwidth=2
set tabstop=2
set backspace=indent,eol,start
autocmd BufRead,BufNewFile /home/vilmibm/src/tildemush/* setlocal ts=4 sw=4
autocmd BufRead,BufNewFile /home/vilmibm/src/tildetown/* setlocal ts=4 sw=4
autocmd BufRead,BufNewFile /home/vilmibm/src/github/* setlocal ts=2 sw=2
autocmd BufRead,BufNewFile *.md setlocal spell spelllang=en_us spellcapcheck=
autocmd BufRead,BufNewFile *.txt setlocal spell spelllang=en_us spellcapcheck=


set shiftround
set autoindent
set expandtab
set wildmode=longest,list
set number
set incsearch
"set list listchars=tab:>-,trail:.,extends:>

" Enable markdown folding
let g:markdown_folding = 1

" Disable parentheses matching depends on system. This way we should address all cases (?)
set noshowmatch

" NoMatchParen " This doesnt work as it belongs to a plugin, which is only loaded _after_ all files are.
" Trying disable MatchParen after loading all plugins
function! g:NoMoreMatchParen ()
    if exists(":NoMatchParen")
        :NoMatchParen
    endif
endfunction

augroup plugin_initialize
    autocmd!
    autocmd VimEnter * call NoMoreMatchParen()
augroup END

" STATUSLINE

set laststatus=2 " always show statusline
set statusline=
set statusline+=%#PmenuSel#
set statusline+=%{fugitive#statusline()}
set statusline+=%#LineNr#
set statusline+=\ %f
set statusline+=%m
set statusline+=%=
set statusline+=%#CursorColumn#
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %p%%
set statusline+=\ %l:%c
set statusline+=\

" BINDINGS
"
let mapleader = " "

nnoremap q <Esc>
noremap <F1> <Esc>
" preferred uparrow/downarrow with wrapped lines
nmap j gj
nmap k gk

nmap <Leader>f :Files<Return>
nmap <Leader><Tab> :b#<Return>
nmap <Leader>/ :Ag<Return>
nmap <Leader>b :Buffers<Return>
nmap <Leader>s :w<Return>
nmap <Leader>w <C-w>
nmap <Leader>wm <C-w>o
nmap <Leader>. :source%<Return>
nmap <Leader>ed :e~/.vimrc<Return>
nmap <Leader>tn :tabn<Return>
nmap <Leader>tp :tabp<Return>

imap <C-w>n <ESC>:tabn<Return>
imap <C-w>p :tabp<cr>

vnoremap <C-r> :terminal bash<CR>
vnoremap <Leader>sg y:spellgood <C-R>"<ENTER>

" Go
nmap <Leader>gr :!go run %<Return>
nmap <Leader>gt :GoTest<Return>
nmap <Leader>gi :GoImports<Return>
nmap <Leader>gb :wa<Return>:GoBuild<Return>
nmap <Leader>gR :wa<Return>:GoBuild<Return>:GoRename<Return>
nmap <C-g> :GoDecls<cr>
imap <C-g> <esc>:<C-u>GoDecls<cr>

" Love
nmap <Leader>lr :!love .<Return>

iab ife if err != nil {<CR>return err<CR>}
iab ifne if err != nil {<CR>return nil, err<CR>}
iab dbg fmt.Printf("DBG %#v\n",
iab rerf return fmt.Errorf("
iab tss tests := []struct {<CR>name string<CR>}{}<CR><CR>for _, tt := range tests {<CR>t.Run(tt.name, func(t *testing.T) {<CR>})<CR>}

nnoremap <leader>d "_d
xnoremap <leader>d "_d
xnoremap <leader>p "_dP
xnoremap <leader>Y :w !wl-copy<cr>

" this works but not when editing markdown :(
imap <C-i> <esc>>>$i
imap <C-u> <esc><<$i

" Mouse support
set balloonevalterm
" Styled and colored underline support
let &t_AU = "\e[58:5:%dm"
let &t_8u = "\e[58:2:%lu:%lu:%lum"
let &t_Us = "\e[4:2m"
let &t_Cs = "\e[4:3m"
let &t_ds = "\e[4:4m"
let &t_Ds = "\e[4:5m"
let &t_Ce = "\e[4:0m"
" Strikethrough
let &t_Ts = "\e[9m"
let &t_Te = "\e[29m"
" Truecolor support
let &t_8f = "\e[38:2:%lu:%lu:%lum"
let &t_8b = "\e[48:2:%lu:%lu:%lum"
let &t_RF = "\e]10;?\e\\"
let &t_RB = "\e]11;?\e\\"
" Bracketed paste
let &t_BE = "\e[?2004h"
let &t_BD = "\e[?2004l"
let &t_PS = "\e[200~"
let &t_PE = "\e[201~"
" Cursor control
" solid block in normal, solid i beam in insert
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
"let &t_RC = "\e[?12$p"
"let &t_SH = "\e[%d q"
"let &t_RS = "\eP$q q\e\\"
"let &t_SR = "\e[3 q"
"let &t_VS = "\e[?12l"
" Focus tracking
let &t_fe = "\e[?1004h"
let &t_fd = "\e[?1004l"
execute "set <FocusGained>=\<Esc>[I"
execute "set <FocusLost>=\<Esc>[O"
" Window title
let &t_ST = "\e[22;2t"
let &t_RT = "\e[23;2t"

set termguicolors

" vim hardcodes background color erase even if the terminfo file does
" not contain bce. This causes incorrect background rendering when
" using a color theme with a background color in terminals such as
" kitty that do not support background color erase.
let &t_ut=''

set t_Co=256

"set background=light
set background=dark
colorscheme shades-of-teal

"colorscheme minimal
"colorscheme monochrome
"colorscheme true-monochrome
"colorscheme arcadia
"neverness, nefertiti so close
"colorscheme mourning good but too dark
"colorscheme Atelier_LakesideDark
"colorscheme rosepine

" experimenting with vim-lsp
if executable('pylsp')
    " pip install python-lsp-server
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pylsp',
        \ 'cmd': {server_info->['pylsp']},
        \ 'allowlist': ['python'],
        \ })
endif

" had to disable bc hates django
"if executable('pylyzer')
"    " pip install pylyzer
"    au User lsp_setup call lsp#register_server({
"        \ 'name': 'pylyzer',
"        \ 'cmd': {server_info->['pylyzer', '--server']},
"        \ 'allowlist': ['python'],
"        \ })
"endif

if executable('ruff')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'ruff',
        \ 'cmd': {server_info->['ruff', 'server']},
        \ 'allowlist': ['python'],
        \ 'workspace_config': {},
        \ })
endif

if executable('gopls')
  au User lsp_setup call lsp#register_server({
    \   'name': 'gopls',
    \   'cmd': {server_info->['gopls']},
    \   'allowlist': ['go'],
    "\   'root_uri': {server_info->s:root_uri(['go.mod', '.git/'])},
    \   'initialization_options': {
    \     'diagnostics': v:true,
    \     'completeUnimported': v:true,
    \     'matcher': 'fuzzy'
    \   }
    \ })
endif

if executable('godot')
  au User lsp_setup call lsp#register_server({
    \ 'name': 'godot',
    \ 'tcp': {server_info->lsp_settings#get('godot', 'tcp', '127.0.0.1:6005')},
    \ 'root_uri':{server_info->lsp_settings#get('godot', 'root_uri', lsp_settings#root_uri('godot'))},
    \ 'initialization_options': lsp_settings#get('godot', 'initialization_options', v:null),
    \ 'allowlist': lsp_settings#get('godot', 'allowlist', ['gdscript3', 'gdscript', 'gd']),
    \ 'blocklist': lsp_settings#get('godot', 'blocklist', []),
    \ 'config': lsp_settings#get('godot', 'config', lsp_settings#server_config('godot')),
    \ 'workspace_config': lsp_settings#get('godot', 'workspace_config', {}),
    \ 'semantic_highlight': lsp_settings#get('godot', 'semantic_highlight', {}),
    \ })
endif

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gl <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    "nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
    "nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')

    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
