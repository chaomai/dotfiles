"======================================================================
"
" init-keymaps.vim - 按键设置，按你喜欢更改
"
"   - 快速移动
"   - 标签切换
"   - 窗口切换
"   - 终端支持
"   - 编译运行
"
" Created by skywind on 2018/05/30
" Last Modified: 2018/05/30 17:59:31
"
"======================================================================
" vim: set ts=4 sw=4 tw=78 noet :


nnoremap <leader>w :w<cr>
nnoremap <leader>q :q<cr>

function! ToggleMovement(firstOp, thenOp)
    let pos = getpos(".")
    execute "normal! " . a:firstOp
    if pos == getpos(".")
        execute "normal! " . a:thenOp
    endif
endfunc

" the original carat 0 swap
nnoremap <silent>0 :call ToggleMovement("^", "0")<cr>

" H and L
nnoremap <silent>H :call ToggleMovement("H", "L")<cr>
nnoremap <silent>L :call ToggleMovement("L", "H")<cr>

" G and gg
nnoremap <silent>G :call ToggleMovement("G", "gg")<cr>
nnoremap <silent>gg :call ToggleMovement("gg", "G")<cr>

" wrap to next position when reaching begining or end of line
set whichwrap=<,>,h,l

nnoremap <leader>hl :nohlsearch<cr>

nnoremap <leader>pp :setlocal paste!<cr>
nnoremap <leader>wp :setlocal wrap!<cr>

nnoremap <leader>ll :set list!<cr>

func! TrimWhitespace()
  let l:winview=winsaveview()
  %s/\s\+$//e
  call winrestview(l:winview)
endfunc

nnoremap <leader>tw :call TrimWhitespace()<cr>
" autocmd bufwrite * :call TrimWhitespace()


"----------------------------------------------------------------------
" INSERT 模式下使用 EMACS 键位
"----------------------------------------------------------------------
inoremap <c-a> <home>
inoremap <c-e> <end>
inoremap <c-p> <up>
inoremap <c-n> <down>
inoremap <c-d> <del>
inoremap <c-_> <c-k>


"----------------------------------------------------------------------
" 设置 CTRL+HJKL 移动光标（INSERT 模式偶尔需要移动的方便些）
" 使用 SecureCRT/XShell 等终端软件需设置：Backspace sends delete
" 详见：http://www.skywind.me/blog/archives/2021
"----------------------------------------------------------------------
noremap <c-h> <left>
noremap <c-j> <down>
noremap <c-k> <up>
noremap <c-l> <right>
inoremap <c-h> <left>
inoremap <c-j> <down>
inoremap <c-k> <up>
inoremap <c-l> <right>


"----------------------------------------------------------------------
" 命令模式的快速移动
"----------------------------------------------------------------------
cnoremap <c-h> <left>
cnoremap <c-j> <down>
cnoremap <c-k> <up>
cnoremap <c-l> <right>
cnoremap <c-a> <home>
cnoremap <c-e> <end>
cnoremap <c-f> <c-d>
cnoremap <c-b> <left>
cnoremap <c-d> <del>
cnoremap <c-_> <c-k>


"----------------------------------------------------------------------
" <leader>+数字键 切换tab
"----------------------------------------------------------------------
noremap <silent><leader>1 1gt<cr>
noremap <silent><leader>2 2gt<cr>
noremap <silent><leader>3 3gt<cr>
noremap <silent><leader>4 4gt<cr>
noremap <silent><leader>5 5gt<cr>
noremap <silent><leader>6 6gt<cr>
noremap <silent><leader>7 7gt<cr>
noremap <silent><leader>8 8gt<cr>
noremap <silent><leader>9 9gt<cr>
noremap <silent><leader>0 10gt<cr>


"----------------------------------------------------------------------
" ALT+N 切换 tab
"----------------------------------------------------------------------
noremap <silent><m-1> :tabn 1<cr>
noremap <silent><m-2> :tabn 2<cr>
noremap <silent><m-3> :tabn 3<cr>
noremap <silent><m-4> :tabn 4<cr>
noremap <silent><m-5> :tabn 5<cr>
noremap <silent><m-6> :tabn 6<cr>
noremap <silent><m-7> :tabn 7<cr>
noremap <silent><m-8> :tabn 8<cr>
noremap <silent><m-9> :tabn 9<cr>
noremap <silent><m-0> :tabn 10<cr>
inoremap <silent><m-1> <ESC>:tabn 1<cr>
inoremap <silent><m-2> <ESC>:tabn 2<cr>
inoremap <silent><m-3> <ESC>:tabn 3<cr>
inoremap <silent><m-4> <ESC>:tabn 4<cr>
inoremap <silent><m-5> <ESC>:tabn 5<cr>
inoremap <silent><m-6> <ESC>:tabn 6<cr>
inoremap <silent><m-7> <ESC>:tabn 7<cr>
inoremap <silent><m-8> <ESC>:tabn 8<cr>
inoremap <silent><m-9> <ESC>:tabn 9<cr>
inoremap <silent><m-0> <ESC>:tabn 10<cr>


" MacVim 允许 CMD+数字键快速切换标签
if has("gui_macvim")
    set macmeta
    noremap <silent><d-1> :tabn 1<cr>
    noremap <silent><d-2> :tabn 2<cr>
    noremap <silent><d-3> :tabn 3<cr>
    noremap <silent><d-4> :tabn 4<cr>
    noremap <silent><d-5> :tabn 5<cr>
    noremap <silent><d-6> :tabn 6<cr>
    noremap <silent><d-7> :tabn 7<cr>
    noremap <silent><d-8> :tabn 8<cr>
    noremap <silent><d-9> :tabn 9<cr>
    noremap <silent><d-0> :tabn 10<cr>
    inoremap <silent><d-1> <ESC>:tabn 1<cr>
    inoremap <silent><d-2> <ESC>:tabn 2<cr>
    inoremap <silent><d-3> <ESC>:tabn 3<cr>
    inoremap <silent><d-4> <ESC>:tabn 4<cr>
    inoremap <silent><d-5> <ESC>:tabn 5<cr>
    inoremap <silent><d-6> <ESC>:tabn 6<cr>
    inoremap <silent><d-7> <ESC>:tabn 7<cr>
    inoremap <silent><d-8> <ESC>:tabn 8<cr>
    inoremap <silent><d-9> <ESC>:tabn 9<cr>
    inoremap <silent><d-0> <ESC>:tabn 10<cr>
endif


"----------------------------------------------------------------------
" TAB：创建，关闭，上一个，下一个，左移，右移
" 其实还可以用原生的 CTRL+PageUp, CTRL+PageDown 来切换标签
"----------------------------------------------------------------------
noremap <silent><leader>tc :tabnew<cr>
noremap <silent><leader>tq :tabclose<cr>
noremap <silent><leader>tn :tabnext<cr>
noremap <silent><leader>tp :tabprev<cr>
noremap <silent><leader>to :tabonly<cr>


" 左移 tab
function! Tab_MoveLeft()
    let l:tabnr = tabpagenr() - 2
    if l:tabnr >= 0
        exec "tabmove ".l:tabnr
    endif
endfunc

" 右移 tab
function! Tab_MoveRight()
    let l:tabnr = tabpagenr() + 1
    if l:tabnr <= tabpagenr("$")
        exec "tabmove ".l:tabnr
    endif
endfunc

noremap <silent><leader>tl :call Tab_MoveLeft()<cr>
noremap <silent><leader>tr :call Tab_MoveRight()<cr>
