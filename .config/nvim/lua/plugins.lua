-- bootstrap packer
----------------------------------------
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.api.nvim_command 'packadd packer.nvim'
end

-- don't throw error on first packer use
local ok, packer = pcall(require, "packer")
if not ok then return end

require("packer").startup(function()
    use "wbthomason/packer.nvim"        -- packer manages itself

    use "tpope/vim-commentary"          -- gcc Vgc
    use "tpope/vim-surround"            -- cs\""
    use "ggandor/leap.nvim"             -- s\w\w
    use "akinsho/toggleterm.nvim"
    use {
        "nvim-telescope/telescope.nvim",
        requires = { { "nvim-lua/plenary.nvim"} }
    }
    use "wellle/targets.vim"            -- ci) cin( cin' di. dia dib
    use "lukas-reineke/indent-blankline.nvim" -- show tabs
    use { "fatih/vim-go"}
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            require('nvim-treesitter.install').update({ with_sync = true })
        end,
    }
    use {
        "nvim-treesitter/nvim-treesitter-textobjects",
        after='nvim-treesitter'
    }
    if packer_bootstrap then
        require('packer').sync()
    end
end)
if packer_bootstrap then
    return
end

-- treesitter
----------------------------------------
require("nvim-treesitter.configs").setup {
    ensure_installed = {
        "bash",
        "c",
        "dockerfile",
        "go",
        "javascript",
        "json",
        "lua",
        "php",
        "python",
        "yaml", },
    highlight = {
        enable = true,
    },
    indent = {
        enable = true,
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                ['ac'] = '@comment.outer',
                ['ic'] = '@comment.inner',
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["aa"] = "@call.inner",
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                [']]'] = '@function.outer',
                [']m'] = '@class.outer',
            },
            goto_next_end = {
                [']['] = '@function.outer',
                [']M'] = '@class.outer',
            },
            goto_previous_start = {
                ['[['] = '@function.outer',
                ['[m'] = '@class.outer',
            },
            goto_previous_end = {
                ['[]'] = '@function.outer',
                ['[M'] = '@class.outer',
            },
        },
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<CR>',
            scope_incremental = '<CR>',
            node_incremental = '<TAB>',
            node_decremental = '<S-TAB>',
        },
    },
}

-- leap
----------------------------------------
local leap = require('leap')
leap.set_default_keymaps()
leap.init_highlight(true)
vim.cmd([[ hi LeapLabelPrimary ctermbg=251 ctermfg=0 ]])

-- toggleterm
----------------------------------------
require("toggleterm").setup{
    open_mapping = [[<leader>t]],
    shade_terminals = true,
    size = vim.o.lines * 0.4
}

-- blankline
----------------------------------------
vim.cmd([[ hi IndentBlanklineChar ctermfg=240 ]])
vim.cmd([[ hi IndentBlanklineContextChar ctermfg=7 ]])
require("indent_blankline").setup {
    show_current_context = true,
    show_current_context_start = true,
}

-- telescope
----------------------------------------
local telescope = require("telescope.builtin")
vim.keymap.set("n", "<leader>fb", telescope.buffers, {noremap = true, silent = true})
vim.keymap.set("n", "<leader>ff", telescope.find_files, {noremap = true, silent = true})
vim.keymap.set("n", "<leader>fg", telescope.git_files, {noremap = true, silent = true})
vim.keymap.set("n", "<leader>fv", telescope.command_history, {noremap = true, silent = true})
vim.keymap.set("n", "<leader><leader>", telescope.live_grep, {noremap = true, silent = true})
vim.keymap.set("n", "<leader>8", telescope.grep_string, {noremap = true, silent = true})
vim.keymap.set("n", "<leader>fd", telescope.lsp_definitions, {noremap = true, silent = true})
-- fix highlighting
vim.cmd([[ hi telescopeselection ctermfg=242 ctermbg=252 ]])

require("telescope").setup({
    defaults = {
        layout_strategy = "vertical",
        layout_config = { width = .90, },
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--hidden",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case"
        },
        mappings = {
            i = {
                ["<esc>"] = require("telescope.actions").close,
                ["<C-k>"] = require("telescope.actions").move_selection_previous,
                ["<C-j>"] = require("telescope.actions").move_selection_next,
            },
        },
    },
    pickers = {
        find_files = {
            hidden = true,
            find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden' }
        },
        git_files = {
            hidden = true,
            find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden' }
        },
    }
})
