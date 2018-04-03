syntax on
set expandtab
set number
set ruler

filetype plugin indent on
autocmd FileType javascript,coffee      setlocal et sw=2 sts=2 isk+=$
autocmd FileType html,xhtml,css,scss    setlocal et sw=2 sts=2
autocmd FileType eruby,yaml,ruby        setlocal et sw=2 sts=2
autocmd FileType cucumber               setlocal et sw=2 sts=2
autocmd FileType gitconfig              setlocal noet sw=8
autocmd FileType ruby                   setlocal comments=:#\  tw=79
autocmd FileType sh,csh,zsh             setlocal et sw=2 sts=2
autocmd FileType vim                    setlocal et sw=2 sts=2 keywordprg=:help

