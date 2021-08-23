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
    let g:bundle_group = ["hop_nvim", "tabularize", "diffview_nvim", "vim_startify"]
    let g:bundle_group += ["vim_choosewin", "vim_expand_region", "nerdcommenter", "pangu", "tree_nvim"]
    let g:bundle_group += ["indent-blankline_nvim", "telescope_nvim", "git"]
    let g:bundle_group += ["colorscheme", "devicons"]
    let g:bundle_group += ["vimautoformat", "treesitter_nvim", "lsp_nvim", "compe_nvim", "autopairs_nvim"]
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
    nmap <m-e> <Plug>(choosewin)
endif


if index(g:bundle_group, "indent-blankline_nvim") >= 0
    Plug 'lukas-reineke/indent-blankline.nvim'
    let g:indentLine_char_list = ["¦", "┆", "┊", "│"]
    let g:indent_blankline_use_treesitter = v:false
    let g:indent_blankline_show_current_context = v:false
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
    nmap <m-;> <Plug>NERDCommenterInvert
endif


if index(g:bundle_group, "pangu") >= 0
    Plug 'hotoo/pangu.vim'
endif


if index(g:bundle_group, "tree_nvim") >= 0
    Plug 'kyazdani42/nvim-tree.lua'
endif


if index(g:bundle_group, "telescope_nvim") >= 0
    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
endif


if index(g:bundle_group, "git") >= 0
    Plug 'nvim-lua/plenary.nvim'
    Plug 'lewis6991/gitsigns.nvim'
endif


if index(g:bundle_group, "colorscheme") >= 0
    Plug 'ayu-theme/ayu-vim'
    Plug 'sonph/onehalf', { 'rtp': 'vim' }
    Plug 'kaicataldo/material.vim', { 'branch': 'main' }
endif


if index(g:bundle_group, "devicons") >= 0
    Plug 'kyazdani42/nvim-web-devicons'
endif


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


if index(g:bundle_group, "treesitter_nvim") >= 0
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
    Plug 'nvim-treesitter/nvim-treesitter-textobjects'
endif


if index(g:bundle_group, "lsp_nvim") >= 0
    Plug 'neovim/nvim-lspconfig'
endif


if index(g:bundle_group, "compe_nvim") >= 0
    Plug 'hrsh7th/nvim-compe'
    Plug 'L3MON4D3/LuaSnip'
    Plug 'rafamadriz/friendly-snippets'
endif


if index(g:bundle_group, "autopairs_nvim") >= 0
    Plug 'windwp/nvim-autopairs'
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
vim.api.nvim_set_keymap('n', '<m-w>', "<cmd>lua require'hop'.hint_words()<cr>", {})
vim.api.nvim_set_keymap('n', '<m-l>', "<cmd>lua require'hop'.hint_lines()<cr>", {})
EOF
endif


if index(g:bundle_group, "diffview_nvim") >= 0
lua <<EOF
local cb = require "diffview.config".diffview_callback

require "diffview".setup {
    diff_binaries = false, -- Show diffs for binaries
    file_panel = {
        width = 35,
        use_icons = true -- Requires nvim-web-devicons
    },
    key_bindings = {
        disable_defaults = false, -- Disable the default key bindings
        -- The `view` bindings are active in the diff buffers, only when the current
        -- tabpage is a Diffview.
        view = {
            ["<tab>"] = cb("select_next_entry"), -- Open the diff for the next file
            ["<s-tab>"] = cb("select_prev_entry"), -- Open the diff for the previous file
            ["<leader>e"] = cb("focus_files"), -- Bring focus to the files panel
            ["<leader>b"] = cb("toggle_files") -- Toggle the files panel.
        },
        file_panel = {
            ["j"] = cb("next_entry"), -- Bring the cursor to the next file entry
            ["<down>"] = cb("next_entry"),
            ["k"] = cb("prev_entry"), -- Bring the cursor to the previous file entry.
            ["<up>"] = cb("prev_entry"),
            ["<cr>"] = cb("select_entry"), -- Open the diff for the selected entry.
            ["o"] = cb("select_entry"),
            ["<2-LeftMouse>"] = cb("select_entry"),
            ["-"] = cb("toggle_stage_entry"), -- Stage / unstage the selected entry.
            ["S"] = cb("stage_all"), -- Stage all entries.
            ["U"] = cb("unstage_all"), -- Unstage all entries.
            ["R"] = cb("refresh_files"), -- Update stats and entries in the file list.
            ["<tab>"] = cb("select_next_entry"),
            ["<s-tab>"] = cb("select_prev_entry"),
            ["<leader>e"] = cb("focus_files"),
            ["<leader>b"] = cb("toggle_files")
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


if index(g:bundle_group, "tree_nvim") >= 0
    nnoremap <space>op :NvimTreeToggle<cr>
endif


if index(g:bundle_group, "telescope_nvim") >= 0
    " Using Lua functions
    nnoremap <m-p> <cmd>lua require('telescope.builtin').find_files()<cr>
    nnoremap <m-n> <cmd>lua require('telescope.builtin').live_grep()<cr>
    nnoremap <m-s> <cmd>lua require('telescope.builtin').grep_string()<cr>
    nnoremap <m-b> <cmd>lua require('telescope.builtin').buffers()<cr>

lua <<EOF
local actions = require("telescope.actions")

require("telescope").setup {
    defaults = {
        mappings = {
            i = {
                ["<esc>"] = actions.close
            }
        }
    }
}
EOF
endif


if index(g:bundle_group, "git") >= 0
lua <<EOF
require('gitsigns').setup()
EOF
endif


if index(g:bundle_group, "colorscheme") >= 0
    " let ayucolor="light"
    " colorscheme ayu

    colorscheme onehalflight

    " let g:material_theme_style = 'lighter'
    " colorscheme material
endif


if index(g:bundle_group, "devicons") >= 0
lua <<EOF
require "nvim-web-devicons".setup {
    -- globally enable default icons (default to false)
    -- will get overriden by `get_icons` option
    default = true
}
EOF
endif


if index(g:bundle_group, "treesitter_nvim") >= 0
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


if index(g:bundle_group, "lsp_nvim") >= 0
lua <<EOF
local lspconfig = require'lspconfig'
local util = require'lspconfig/util'

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    --Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap=true, silent=true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        'documentation',
        'detail',
        'additionalTextEdits',
    }
}

local ccls_path = vim.fn.expand("~/Documents/workspace/github/ccls/Release/ccls")

lspconfig.ccls.setup {
    capabilities = capabilities,
    on_attach = on_attach,

    flags = {
        debounce_text_changes = 500,
    };

    cmd = { ccls_path };
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
    };
}
EOF
endif


if index(g:bundle_group, "compe_nvim") >= 0
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

require("luasnip/loaders/from_vscode").lazy_load()
EOF
endif


if index(g:bundle_group, "autopairs_nvim") >= 0
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
