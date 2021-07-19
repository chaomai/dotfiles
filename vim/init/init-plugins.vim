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
" 默认情况下的分组，可以再前面覆盖之
"----------------------------------------------------------------------
if !exists("g:bundle_group")
    let g:bundle_group = ["basic", "enhanced"]
    let g:bundle_group += ["lightline", "vimautoformat"]
    let g:bundle_group += ["nvim_telescope", "nvim_diffview", "nvim_treesitter", "nvim_lsp", "nvim_compe", "nvim_autopairs"]
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
" 默认插件
"----------------------------------------------------------------------

" 全文快速移动，<leader><leader>f{char} 即可触发
Plug 'easymotion/vim-easymotion'

" 表格对齐，使用命令 Tabularize
" :<range>Tabularize \{characters}
Plug 'godlygeek/tabular', { 'on': 'Tabularize' }

" Diff 增强，支持 histogram / patience 等更科学的 diff 算法
Plug 'chrisbra/vim-diff-enhanced'


"----------------------------------------------------------------------
" 基础插件
"----------------------------------------------------------------------
if index(g:bundle_group, "basic") >= 0

    " 展示开始画面，显示最近编辑过的文件
    Plug 'mhinz/vim-startify'

    " 支持库，给其他插件用的函数库
    Plug 'xolox/vim-misc'

    " 用于在侧边符号栏显示 marks （ma-mz 记录的位置）
    Plug 'kshenoy/vim-signature'

    " 用于在侧边符号栏显示 git/svn 的 diff
    Plug 'mhinz/vim-signify'

    " 使用 ALT+e 会在不同窗口 / 标签上显示 A/B/C 等编号，然后字母直接跳转
    Plug 't9md/vim-choosewin'

    " Git 支持
    Plug 'tpope/vim-fugitive'

    " indentLine
    Plug 'Yggdroot/indentLine'

    " vim with tmux
    Plug 'christoomey/vim-tmux-navigator'

    "==================================================================
    " vim-choosewin
    " 使用 ALT+E 来选择窗口
    nmap <m-e> <Plug>(choosewin)

    "==================================================================
    " startify
    let g:startify_session_dir = expand("~/.vim/session")
    let g:startify_change_to_dir = 0

    "==================================================================
    " signify 调优
    let g:signify_vcs_list               = ["git", "svn"]
    let g:signify_sign_add               = "+"
    let g:signify_sign_delete            = "_"
    let g:signify_sign_delete_first_line = "‾"
    let g:signify_sign_change            = "~"
    let g:signify_sign_changedelete      = g:signify_sign_change

    " git 仓库使用 histogram 算法进行 diff
    let g:signify_vcs_cmds = {
                \ "git": "git diff --no-color --diff-algorithm=histogram --no-ext-diff -U0 -- %f"
                \}

    "==================================================================
    " indentLine 设置
    let g:indentLine_char_list = ["¦", "┆", "┊", "│"]

    "==================================================================
    " vim-tmux-navigator 设置
    let g:tmux_navigator_no_mappings = 1
    " update (write the current buffer, but only if changed)
    let g:tmux_navigator_save_on_switch = 1

    noremap <silent><m-H> :TmuxNavigateLeft<cr>
    noremap <silent><m-J> :TmuxNavigateDown<cr>
    noremap <silent><m-K> :TmuxNavigateUp<cr>
    noremap <silent><m-L> :TmuxNavigateRight<cr>
    inoremap <silent><m-H> <esc> <bar> :TmuxNavigateLeft<cr>
    inoremap <silent><m-J> <esc> <bar> :TmuxNavigateDown<cr>
    inoremap <silent><m-K> <esc> <bar> :TmuxNavigateUp<cr>
    inoremap <silent><m-L> <esc> <bar> :TmuxNavigateRight<cr>
endif


"----------------------------------------------------------------------
" 增强插件
"----------------------------------------------------------------------
if index(g:bundle_group, "enhanced") >= 0

    " 用 v 选中一个区域后，ALT_+/- 按分隔符扩大 / 缩小选区
    Plug 'terryma/vim-expand-region'

    " 使用 :CtrlSF 命令进行模仿 sublime 的 grep
    Plug 'dyng/ctrlsf.vim'

    " nerd commenter
    Plug 'scrooloose/nerdcommenter'

    " colorscheme
    Plug 'ayu-theme/ayu-vim'

    " file type icons
    Plug 'ryanoasis/vim-devicons'

    " pangu
    Plug 'hotoo/pangu.vim'

    " floaterm
    Plug 'voldikss/vim-floaterm'

    "==================================================================
    " vim expand region 设置
    " ALT_+/- 用于按分隔符扩大缩小 v 选区
    map <m-=> <Plug>(expand_region_expand)
    map <m--> <Plug>(expand_region_shrink)

    " ==================================================================
    " nerd commenter 设置
    let g:NERDSpaceDelims = 1
    let g:NERDCreateDefaultMappings = 0
    map <space>cl <Plug>NERDCommenterInvert
    map <space>cs <Plug>NERDCommenterSexy
    map <space>ct <Plug>NERDCommenterToggle
endif


"----------------------------------------------------------------------
" lightline
"----------------------------------------------------------------------
if index(g:bundle_group, "lightline") >= 0
    Plug 'itchyny/lightline.vim'
    set noshowmode

    autocmd User CocDiagnosticChange call lightline#update()

    function! CocCurrentFunction()
        return get(b:, "coc_current_function", "")
    endfunction

    function! LightlineFilename()
        let filename = expand("%:t") !=# "" ? expand("%:t") : "[No Name]"
        let modified = &modified ? " +" : ""
        return filename . modified
    endfunction

    function! s:is_show()
        return &filetype !~# "\v(help|defx)"
    endfunction

    function! s:light_line_left() abort
        let left = [
                    \ [ "mode", "paste", "gitbranch" ],
                    \ [ "filename", "currentfunction" ],
                    \ ]

        if <SID>is_show()
            return left
        else
            return []
        endif
    endfunction

    function! s:light_line_right() abort
        let right = [
                    \ [ "lineinfo" ],
                    \ [ "percent" ],
                    \ [ "readonly", "fileformat", "fileencoding", "filetype", "cocstatus" ],
                    \ ]

        if <SID>is_show()
            return right
        else
            return []
        endif
    endfunction

    let g:lightline = {
                \     "colorscheme": "PaperColor_dark",
                \     "active": {
                \       "left": <SID>light_line_left(),
                \       "right": <SID>light_line_right(),
                \     },
                \     "component_function": {
                \       "filename": "LightlineFilename",
                \       "gitbranch": "FugitiveHead",
                \       "cocstatus": "coc#status",
                \       "currentfunction": "CocCurrentFunction"
                \     },
                \     'separator': { 'left': '', 'right': '' },
                \     'subseparator': { 'left': '│', 'right': '│' }
                \ }
endif


"----------------------------------------------------------------------
" vim-autoformat
"----------------------------------------------------------------------
if index(g:bundle_group, "vimautoformat") >= 0
    Plug 'Chiel92/vim-autoformat'

    nnoremap <space>af :Autoformat<cr>

    "==================================================================
    " cpp
    let s:configfile_def = "'clang-format -lines='.a:firstline.':'.a:lastline.' --assume-filename=\"'.expand('%:p').'\" -style=file'"

    if has("macunix")
        let g:formatdef_clang_format = "'clang-format --lines='.a:firstline.':'.a:lastline.' --assume-filename=\"'.expand('%:p').'\" --style=\"{BasedOnStyle: Google, IndentWidth: 4, AlignTrailingComments: true, SortIncludes: false, '.(&textwidth ? 'ColumnLimit: '.&textwidth.', ' : '').(&expandtab ? 'UseTab: Never, IndentWidth: '.shiftwidth() : 'UseTab: Always').'}\"'"
    else
        let g:formatdef_clang_format = "'clang-format-10 --lines='.a:firstline.':'.a:lastline.' --assume-filename=\"'.expand('%:p').'\" --style=\"{BasedOnStyle: Google, IndentWidth: 4, AlignTrailingComments: true, SortIncludes: false, '.(&textwidth ? 'ColumnLimit: '.&textwidth.', ' : '').(&expandtab ? 'UseTab: Never, IndentWidth: '.shiftwidth() : 'UseTab: Always').'}\"'"
    endif

    let g:formatters_objc = ["clang_format"]
    let g:formatters_cpp = ["clang_format"]
    let g:formatters_c = ["clang_format"]
    let g:formatters_h = ["clang_format"]

    "==================================================================
    " python
    " use default
    let g:formatters_python = ["black"]

    "==================================================================
    " haskell
    " use default
    let g:formatters_haskell = ["stylish_haskell"]
    autocmd FileType haskell let b:autoformat_autoindent=0
endif


"----------------------------------------------------------------------
" vimspector
"----------------------------------------------------------------------
if index(g:bundle_group, "vimspector") >= 0
    Plug 'puremourning/vimspector'

    " F3    Stop debugging.                                             vim spector#Stop()
    " F4    Restart debugging with the same configuration.              vim spector#Restart()
    " F5    When debugging, continue. Otherwise start debugging.        vim spector#Continue()
    " F6    Pause debugee.                                              vim spector#Pause()
    " F9    Toggle line breakpoint on the current line.                 vim spector#ToggleBreakpoint()
    " F8    Add a function breakpoint for the expression under cursor   vim spector#AddFunctionBreakpoint( "<cexpr>" )
    " F10   Step Over                                                   vim spector#StepOver()
    " F11   Step Into                                                   vim spector#StepInto()
    " F12   Step out of current function scope                          vim spector#StepOut()
    let g:vimspector_enable_mappings = "HUMAN"
endif


"----------------------------------------------------------------------
" nvim_telescope
"----------------------------------------------------------------------
if index(g:bundle_group, "nvim_telescope") >= 0
    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
endif

"----------------------------------------------------------------------
" nvim_diffview
"----------------------------------------------------------------------
if index(g:bundle_group, "nvim_diffview") >= 0
    Plug 'sindrets/diffview.nvim', { 'branch': 'main' }
endif


"----------------------------------------------------------------------
" nvim_treesitter
"----------------------------------------------------------------------
if index(g:bundle_group, "nvim_treesitter") >= 0
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
    Plug 'nvim-treesitter/nvim-treesitter-textobjects'
endif


"----------------------------------------------------------------------
" nvim built-in lsp
"----------------------------------------------------------------------
if index(g:bundle_group, "nvim_lsp") >= 0
    Plug 'neovim/nvim-lspconfig'
endif


"----------------------------------------------------------------------
" nvim_compe
"----------------------------------------------------------------------
if index(g:bundle_group, "nvim_compe") >= 0
    Plug 'hrsh7th/nvim-compe'
    Plug 'L3MON4D3/LuaSnip'
endif


"----------------------------------------------------------------------
" nvim_autopairs
"----------------------------------------------------------------------
if index(g:bundle_group, "nvim_autopairs") >= 0
    Plug 'windwp/nvim-autopairs'
endif

"----------------------------------------------------------------------
" 结束插件安装
"----------------------------------------------------------------------
call plug#end()


"----------------------------------------------------------------------
" after plug
"----------------------------------------------------------------------


"----------------------------------------------------------------------
" nvim_telescope
"----------------------------------------------------------------------
if index(g:bundle_group, "nvim_telescope") >= 0
    " Using Lua functions
    nnoremap <m-p> <cmd>lua require('telescope.builtin').find_files()<cr>
    nnoremap <m-n> <cmd>lua require('telescope.builtin').live_grep()<cr>
    nnoremap <m-s> <cmd>lua require('telescope.builtin').grep_string()<cr>
    nnoremap <m-b> <cmd>lua require('telescope.builtin').buffers()<cr>
endif


"----------------------------------------------------------------------
" nvim_diffview
"----------------------------------------------------------------------
if index(g:bundle_group, "nvim_diffview") >= 0
lua <<EOF
local cb = require'diffview.config'.diffview_callback

require'diffview'.setup {
    diff_binaries = false,  
    file_panel = {
        width = 35,
        use_icons = true    
    },
    key_bindings = {
        disable_defaults = false,       
        view = {
            ["<tab>"]     = cb("select_next_entry"),  
            ["<s-tab>"]   = cb("select_prev_entry"),  
            ["<leader>e"] = cb("focus_files"),        
            ["<leader>b"] = cb("toggle_files"),       
        },
        file_panel = {
            ["j"]             = cb("next_entry"),         
            ["<down>"]        = cb("next_entry"),
            ["k"]             = cb("prev_entry"),        
            ["<up>"]          = cb("prev_entry"),
            ["<cr>"]          = cb("select_entry"),       
            ["o"]             = cb("select_entry"),
            ["<2-LeftMouse>"] = cb("select_entry"),
            ["-"]             = cb("toggle_stage_entry"), 
            ["S"]             = cb("stage_all"),          
            ["U"]             = cb("unstage_all"),        
            ["R"]             = cb("refresh_files"),      
            ["<tab>"]         = cb("select_next_entry"),
            ["<s-tab>"]       = cb("select_prev_entry"),
            ["<leader>e"]     = cb("focus_files"),
            ["<leader>b"]     = cb("toggle_files"),
        }
    }
}
EOF
endif


"----------------------------------------------------------------------
" nvim_treesitter
"----------------------------------------------------------------------
if index(g:bundle_group, "nvim_treesitter") >= 0
lua <<EOF
require'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
        disable = {},
    },
    indent = {
        enable = false,
        disable = {},
    },
    incremental_selection = {
        enable = false,
        keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
        }
    },
    ensure_installed = {
        "bash",
        "c",
        "cpp",
        "go",
        "html",
        "json",
        "python",
        "rust",
        "yaml",
    }
}
EOF
endif


"----------------------------------------------------------------------
" nvim_lsp
"----------------------------------------------------------------------
if index(g:bundle_group, "nvim_lsp") >= 0
lua <<EOF
local lspconfig = require'lspconfig'
local util = require'lspconfig/util'

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

lspconfig.ccls.setup {
    capabilities = capabilities,

    cmd = { "/Users/chaomai/Documents/workspace/github/ccls/Release/ccls" };
    filetypes = { "c", "cpp", "cuda", "objc", "objcpp" };
    root_dir = util.root_pattern("compile_commands.json", "compile_flags.txt", ".ccls-root", ".project", ".root", ".svn", ".git", ".projectile");
    init_options = {
        capabilities = {
            foldingRangeProvider = false;
        };
        cache = {
            directory = ".ccls-cache";
        };
        completion = {
            caseSensitivity = 0;
        };
        compilationDatabaseDirectory = "cmake-build";
        codeLens = {
            localVariables = false;
        };
        client = {
            snippetSupport = true;
        };
        diagnostics = {
            onChange = 100;
            onOpen = 100;
            onSave = 100;
        };
        highlight = {
            lsRanges = true;
        };
        index = {
            threads = 5;
        };
    }
}
EOF
endif


"----------------------------------------------------------------------
" nvim_compe
"----------------------------------------------------------------------
if index(g:bundle_group, "nvim_compe") >= 0

highlight link CompeDocumentation NormalFloat

lua <<EOF
vim.o.completeopt = "menuone,noselect"

require "compe".setup {
    enabled = true,
    autocomplete = true,
    debug = false,
    min_length = 1,
    preselect = "enable",
    throttle_time = 80,
    source_timeout = 200,
    resolve_timeout = 800,
    incomplete_delay = 400,
    max_abbr_width = 100,
    max_kind_width = 100,
    max_menu_width = 100,
    documentation = {
        border = {"", "", "", " ", "", "", "", " "}, -- the border option is the same as `|help nvim_open_win|`
        winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
        max_width = 120,
        min_width = 60,
        max_height = math.floor(vim.o.lines * 0.3),
        min_height = 1,
    },
    source = {
        path = true,
        buffer = true,
        nvim_lsp = true,
        luasnip = true,
        calc = false,
        nvim_lua = false,
        vsnip = false,
        ultisnips = false,
    }
}

-- Utility functions for compe and luasnip
local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col "." - 1
    if col == 0 or vim.fn.getline("."):sub(col, col):match "%s" then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menu
--- jump to prev/next snippet's placeholder
local luasnip = require "luasnip"

_G.tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return t "<C-n>"
    elseif luasnip.expand_or_jumpable() then
        return t "<Plug>luasnip-expand-or-jump"
    elseif check_back_space() then
        return t "<Tab>"
    else
        return vim.fn["compe#complete"]()
    end
end

_G.s_tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return t "<C-p>"
    elseif luasnip.jumpable(-1) then
        return t "<Plug>luasnip-jump-prev"
    else
        return t "<S-Tab>"
    end
end

-- Map tab to the above tab complete functions
vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

-- Map compe confirm and complete functions
vim.api.nvim_set_keymap("i", "<cr>", 'compe#confirm("<cr>")', {expr = true})
vim.api.nvim_set_keymap("i", "<c-space>", "compe#complete()", {expr = true})
EOF
endif


"----------------------------------------------------------------------
" nvim_autopairs
"----------------------------------------------------------------------
if index(g:bundle_group, "nvim_autopairs") >= 0
lua <<EOF
local npairs = require("nvim-autopairs")

npairs.setup({
    check_ts = true,
    ts_config = {
        lua = {'string'},-- it will not add pair on that treesitter node
        javascript = {'template_string'},
        java = false,-- don't check treesitter on java
    }
})

require('nvim-treesitter.configs').setup {
    autopairs = {enable = true}
}

local ts_conds = require('nvim-autopairs.ts-conds')
local Rule = require('nvim-autopairs.rule')

-- press % => %% is only inside comment or string
npairs.add_rules({
    Rule("%", "%", "lua")
        :with_pair(ts_conds.is_ts_node({'string','comment'})),
    Rule("$", "$", "lua")
        :with_pair(ts_conds.is_not_ts_node({'function'}))
})

require("nvim-autopairs.completion.compe").setup({
    map_cr = true, --  map <CR> on insert mode
    map_complete = true -- it will auto insert `(` after select function or method item
})
EOF
endif


"----------------------------------------------------------------------
" sytle related
"----------------------------------------------------------------------
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
if (has("termguicolors"))
    if (has("vim"))
        let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
        let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    endif

    set termguicolors
endif

hi Normal guibg=NONE ctermbg=NONE   

"==================================================================
let ayucolor="light"
colorscheme ayu

"==================================================================
" vim-devicons

if has("macunix")
    let g:WebDevIconsOS = "Darwin"
endif

" adding to vim-airline's tabline
let g:webdevicons_enable_airline_tabline = 0
" adding to vim-airline's statusline
let g:webdevicons_enable_airline_statusline = 0

" adding to vim-startify screen
let g:webdevicons_enable_startify = 0

"==================================================================
" startify
" let g:startify_custom_header = startify#pad(startify#fortune#quote())

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
