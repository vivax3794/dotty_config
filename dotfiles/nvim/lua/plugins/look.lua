vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.cmdheight = 0

return {
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd [[colorscheme tokyonight-night]]
        end
    },
    "nvim-tree/nvim-web-devicons",
    {
        "shellRaining/hlchunk.nvim",
        event = {"BufReadPre", "BufNewFile"},
        config = function()
            require("hlchunk").setup(
                {
                    chunk = {
                        enable = true
                    },
                    indent = {
                        enable = true
                    }
                }
            )
        end
    },
    {
        {
            "folke/noice.nvim",
            event = "VeryLazy",
            opts = {},
            dependencies = {
                -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
                "MunifTanjim/nui.nvim",
                -- OPTIONAL:
                --   `nvim-notify` is only needed, if you want to use the notification view.
                --   If not available, we use `mini` as the fallback
                "rcarriga/nvim-notify"
            }
        },
        {
            "romgrk/barbar.nvim",
            dependencies = {
                "lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
                "nvim-tree/nvim-web-devicons" -- OPTIONAL: for file icons
            },
            init = function()
                vim.g.barbar_auto_setup = false
            end,
            opts = {}
        }
    }
}

