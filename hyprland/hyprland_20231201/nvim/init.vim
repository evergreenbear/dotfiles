set number
set clipboard=unnamedplus
set mouse=n
set backupdir=/tmp//,.
set directory=/tmp//,.
set tabstop=4
set softtabstop=0 noexpandtab
syntax on

autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

