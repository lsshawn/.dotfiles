"" Fold control
if exists("b:javascript_fold")
    syntax match   javaScriptFunction       /\<function\>/ nextgroup=javaScriptFuncName skipwhite
    syntax match   javaScriptOpAssign       /=\@<!=/ nextgroup=javaScriptFuncBlock skipwhite skipempty
    syntax region  javaScriptFuncName       contained matchgroup=javaScriptFuncName start=/\%(\$\|\w\)*\s*(/ end=/)/ contains=javaScriptLineComment,javaScriptComment nextgroup=javaScriptFuncBlock skipwhite skipempty
    syntax region  javaScriptFuncBlock      contained matchgroup=javaScriptFuncBlock start="{" end="}" contains=@javaScriptAll,javaScriptParensErrA,javaScriptParensErrB,javaScriptParen,javaScriptBracket,javaScriptBlock fold

    if &l:filetype=='javascript' && !&diff
      " Fold setting
      " Redefine the foldtext (to show a JS function outline) and foldlevel
      " only if the entire buffer is JavaScript, but not if JavaScript syntax
      " is embedded in another syntax (e.g. HTML).
      setlocal foldmethod=syntax
      setlocal foldlevel=4
    endif
else
    syntax keyword javaScriptFunction       function
    setlocal foldmethod<
    setlocal foldlevel<
endif
