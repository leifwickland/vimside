" ============================================================================
" prepare_refactor.vim
"
" File:          vimside#swank#rpc#prepare_refactor.vim
" Summary:       Vimside RPC prepare-refactor
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" 
" Initiate a refactoring. The server will respond with a summary of what the
" refactoring *would* do, were it executed.This call does not effect any 
" changes unless the 4th argument is nil.
"
" Arguments:
"   Int:A procedure id for this refactoring, uniquely generated by 
"   Symbol:The manner of refacoring we want to prepare. Currently, one of
"     rename, extractMethod, extractLocal, organizeImports, or addImport.
"     An association list of params of the form (sym1 val1 sym2 val2).
"     Contents of the params varies with the refactoring type:
"     rename: (newName String file String start Int end Int) 
"     extractMethod: (methodName String file String start Int end Int) 
"     extractLocal: (name String file String start Int end Int) 
"     inlineLocal: (file String start Int end Int) 
"     organizeImports: (file String) 
"     addImport: (qualifiedName String file String start Int end Int)
"   Bool:Should the refactoring require confirmation? If nil, the refactoring 
"     will be executed immediately. " 
"
" Return:
"   RefactorEffect| RefactorFailure
" 
" Example:
"
" (:swank-rpc (swank:prepare-refactor 6 rename (file "SwankProtocol.scala"
" start 39504 end 39508 newName "dude") t) 42)
"
" (:return 
" (:ok 
" (:procedure-id 6 :refactor-type rename :status success
" :changes ((:file "SwankProtocol.scala" :text "dude" :from 39504 :to
" 39508))
" )
" 42)
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" public API
function! vimside#swank#rpc#prepare_refactor#Run(...)
call s:LOG("prepare_refactor TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-prepare-refactor-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-prepare-refactor-caller')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  " call vimside#ensime#swank#dispatch(l:rr)

  let msg = "Not Implemented Yet:" . 'swank-rpc-prepare-refactor-handler'
  call s:ERROR(msg)
  echoerr msg

call s:LOG("prepare_refactor BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:PrepareRefactorCaller(args)
  let cmd = "swank:prepare-refactor"

  return '('. cmd .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:PrepareRefactorHandler()

  function! g:PrepareRefactorHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:PrepareRefactorHandler_Ok(dic, ...)
    let dic = a:dic
call s:LOG("PrepareRefactorHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']

    return 1
  endfunction

  return { 
    \ 'abort': function("g:PrepareRefactorHandler_Abort"),
    \ 'ok': function("g:PrepareRefactorHandler_Ok") 
    \ }
endfunction
