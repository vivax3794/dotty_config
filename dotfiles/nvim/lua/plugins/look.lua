vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "no"

vim.opt.cmdheight = 0
vim.opt.laststatus = 0

return {
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("tokyonight").setup(
                {
                    transparent = true,
                    on_highlights = function(highlights, colors)
                        highlights.LineNr = {fg = "#ff9e64"}
                        highlights.LineNrAbove = {fg = "#a1f291"}
                        highlights.LineNrBelow = {fg = "#a1f291"}
                    end
                }
            )
            vim.cmd [[colorscheme tokyonight-night]]
        end
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            notify = {
                enabled = true,
                timeout = 500
            },
        },
        dependencies = {
            "MunifTanjim/nui.nvim"
        }
    },
    {
        "romgrk/barbar.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons" -- OPTIONAL: for file icons
        },
        event = "BufAdd",
        init = function()
            vim.g.barbar_auto_setup = false
        end,
        keys = {
            {"<c-K>", "<Cmd>BufferPrevious<CR>", mode = "n", desc = "Prev tab"},
            {"<c-J>", "<Cmd>BufferNext<CR>", mode = "n", desc = "Next tab"},
            {"<leader>j", "<Cmd>BufferMoveNext<CR>", mode = "n", desc = "Move tab right"},
            {"<leader>k", "<Cmd>BufferMovePrevious<CR>", mode = "n", desc = "Move tab left"},
            {"<leader>c", "<Cmd>BufferClose<CR>", mode = "n", desc = "Close tab"},
            {"<leader>C", "<Cmd>BufferCloseAllButCurrent<CR>", mode = "n", desc = "Close All Other tabs"},
        },
        opts = {
            auto_hide = 1,
            icons = {
                button = ""
            }
        }
    },
    {
        "andweeb/presence.nvim",
        event = "VeryLazy",
        opts = {}
    }
}

