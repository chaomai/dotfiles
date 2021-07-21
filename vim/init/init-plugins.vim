"======================================================================
"
" init-plugins.vim -
"
" Created by skywind on 2018/05/31
" Last Modified by chaomai
"
"======================================================================
" vim: set ts=4 sw=4 tw=78 noet :


"----------------------------------------------------------------------
" 默认情况下的分组
"----------------------------------------------------------------------
if !exists("g:bundle_group")
    let g:bundle_group = ["hop_nvim", "tabularize", "diffview_nvim", "vim_startify", "vim_choosewin", "indent-blankline_nvim", "vim_expand_region", "nerdcommenter", "pangu"]
    let g:bundle_group += ["ayu"]
endif


"----------------------------------------------------------------------
" 计算当前 vim-init 的子路径
"----------------------------------------------------------------------
let s:home = fnamemodify(resolve(expand("<sfile>:p")), ":h:h")

function! s:path(path)
    let path = expand(s:home . "/" . a:path )
    return substitute(path, "\\", "/", "g")
endfunc


"----------------------------------------------------------------------
" 在 ~/.vim/bundles 下安装插件
"----------------------------------------------------------------------
if has("nvim")
    call plug#begin(stdpath("data") . "/plugged")
else
    call plug#begin(get(g:, "bundle_home", "~/.vim/bundles"))
endif


"----------------------------------------------------------------------
" plugins
"----------------------------------------------------------------------
if index(g:bundle_group, "hop_nvim") >= 0
    Plug 'phaazon/hop.nvim'
endif


if index(g:bundle_group, "tabularize") >= 0
    " :<range>Tabularize \{characters}
    Plug 'godlygeek/tabular', { 'on': 'Tabularize' }
endif


if index(g:bundle_group, "diffview_nvim") >= 0
    Plug 'sindrets/diffview.nvim'
endif


if index(g:bundle_group, "vim_startify") >= 0
    Plug 'mhinz/vim-startify'

    let g:startify_session_dir = expand("~/.vim/session")
    let g:startify_change_to_dir = 0
endif


if index(g:bundle_group, "vim_choosewin") >= 0
    Plug 't9md/vim-choosewin'
    nmap <space>cw <Plug>(choosewin)
endif


if index(g:bundle_group, "indent-blankline_nvim") >= 0
    Plug 'lukas-reineke/indent-blankline.nvim'
    let g:indentLine_char_list = ["¦", "┆", "┊", "│"]
    let g:indent_blankline_use_treesitter = v:true
    let g:indent_blankline_show_current_context = v:true
endif


if index(g:bundle_group, "vim_expand_region") >= 0
    Plug 'terryma/vim-expand-region'
    " ALT_+/- 用于按分隔符扩大缩小 v 选区
    map <m-=> <Plug>(expand_region_expand)
    map <m--> <Plug>(expand_region_shrink)
endif


if index(g:bundle_group, "nerdcommenter") >= 0
    Plug 'scrooloose/nerdcommenter'
    let g:NERDSpaceDelims = 1
    let g:NERDCreateDefaultMappings = 0
    map <space>cl <Plug>NERDCommenterInvert
    map <space>cs <Plug>NERDCommenterSexy
    map <space>ct <Plug>NERDCommenterToggle
endif


if index(g:bundle_group, "pangu") >= 0
    Plug 'hotoo/pangu.vim'
endif


if index(g:bundle_group, "ayu") >= 0
    Plug 'ayu-theme/ayu-vim'
endif


"----------------------------------------------------------------------
" 结束插件安装
"----------------------------------------------------------------------
call plug#end()


"----------------------------------------------------------------------
" plugins setup
"----------------------------------------------------------------------
if index(g:bundle_group, "hop_nvim") >= 0
lua <<EOF
vim.api.nvim_set_keymap('n', '<space>hw', "<cmd>lua require'hop'.hint_words()<cr>", {})
vim.api.nvim_set_keymap('n', '<space>hl', "<cmd>lua require'hop'.hint_lines()<cr>", {})
EOF
endif


if index(g:bundle_group, "diffview_nvim") >= 0
lua <<EOF
local cb = require'diffview.config'.diffview_callback

require'diffview'.setup {
  diff_binaries = false,    -- Show diffs for binaries
  file_panel = {
    width = 35,
    use_icons = true        -- Requires nvim-web-devicons
  },
  key_bindings = {
    disable_defaults = false,                   -- Disable the default key bindings
    -- The `view` bindings are active in the diff buffers, only when the current
    -- tabpage is a Diffview.
    view = {
      ["<tab>"]     = cb("select_next_entry"),  -- Open the diff for the next file 
      ["<s-tab>"]   = cb("select_prev_entry"),  -- Open the diff for the previous file
      ["<leader>e"] = cb("focus_files"),        -- Bring focus to the files panel
      ["<leader>b"] = cb("toggle_files"),       -- Toggle the files panel.
    },
    file_panel = {
      ["j"]             = cb("next_entry"),         -- Bring the cursor to the next file entry
      ["<down>"]        = cb("next_entry"),
      ["k"]             = cb("prev_entry"),         -- Bring the cursor to the previous file entry.
      ["<up>"]          = cb("prev_entry"),
      ["<cr>"]          = cb("select_entry"),       -- Open the diff for the selected entry.
      ["o"]             = cb("select_entry"),
      ["<2-LeftMouse>"] = cb("select_entry"),
      ["-"]             = cb("toggle_stage_entry"), -- Stage / unstage the selected entry.
      ["S"]             = cb("stage_all"),          -- Stage all entries.
      ["U"]             = cb("unstage_all"),        -- Unstage all entries.
      ["R"]             = cb("refresh_files"),      -- Update stats and entries in the file list.
      ["<tab>"]         = cb("select_next_entry"),
      ["<s-tab>"]       = cb("select_prev_entry"),
      ["<leader>e"]     = cb("focus_files"),
      ["<leader>b"]     = cb("toggle_files"),
    }
  }
}
EOF
endif


if index(g:bundle_group, "vim_startify") >= 0
    let g:ascii = [
                \ '=================     ===============     ===============   ========  ======== ',
                \ '\\ . . . . . . .\\   //. . . . . . .\\   //. . . . . . .\\  \\. . .\\// . . // ',
                \ '||. . ._____. . .|| ||. . ._____. . .|| ||. . ._____. . .|| || . . .\/ . . .|| ',
                \ '|| . .||   ||. . || || . .||   ||. . || || . .||   ||. . || ||. . . . . . . || ',
                \ '||. . ||   || . .|| ||. . ||   || . .|| ||. . ||   || . .|| || . | . . . . .|| ',
                \ '|| . .||   ||. _-|| ||-_ .||   ||. . || || . .||   ||. _-|| ||-_.|\ . . . . || ',
                \ '||. . ||   ||-.  || ||  `-||   || . .|| ||. . ||   ||-.  || ||  `|\_ . .|. .|| ',
                \ '|| . _||   ||    || ||    ||   ||_ . || || . _||   ||    || ||   |\ `-_/| . || ',
                \ '||_-. ||  .|/    || ||    \|.  || `-_|| ||_-. ||  .|/    || ||   | \  / |-_.|| ',
                \ '||    ||_-.      || ||      `-_||    || ||    ||_-.      || ||   | \  / |  `|| ',
                \ '||    `.         || ||         `.    || ||    `.         || ||   | \  / |   || ',
                \ '||            .===. `===.         .===..`===.         .===. /==. |  \/  |   || ',
                \ '||         .==.   \_|-_ `===. .===.   _|_   `===. .===. _-|/   `==  \/  |   || ',
                \ '||      .==.    _-.    `-_  `=.    _-.   `-_    `=.  _-.   `-_  /|  \/  |   || ',
                \ '||   .==.    _-.          `-__\._-.         `-_./__-.         `. |. /|  |   || ',
                \ '||.==.    _-.                                                     `. |  /==.|| ',
                \ '==.    _-.                                                            \/   `== ',
                \ '\   _-.                                                                `-_   / ',
                \ ' `..                                                                      ``.  ',
                \ ]

    let g:startify_custom_header = startify#center(g:ascii + startify#fortune#boxed())
endif


if index(g:bundle_group, "ayu") >= 0
    let ayucolor="light"
    colorscheme ayu
endif
