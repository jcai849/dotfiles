syntax enable
filetype plugin indent on
set clipboard=unnamedplus
set ic
set hls is
set autoindent
set number relativenumber
set nu rnu

augroup filetypedetect
    au BufRead,BufNewFile *.txt set filetype=asciidoc
augroup END
