vim.opt.scrolloff = 15
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.keymap.set("i", "<C-s>", "<Esc>:wa<CR>a", {silent = true, desc = "Save"})
vim.keymap.set("n", "<C-s>", ":wa<CR>", {silent = true, desc = "Save"})
vim.keymap.set("n", "<leader>q", ":wqa<CR>", {silent = true, desc = "Save and exit"})
vim.keymap.set("n", "<leader>h", ":noh<CR>", {silent = true, desc = "Remove Highlights"})
vim.keymap.set("n", "zz", "zt", {silent = true, desc = "Center"})

vim.keymap.set("n", "c", '"_c', {noremap = true})
vim.keymap.set("n", "C", '"_C', {noremap = true})
vim.keymap.set("n", "cc", '"_cc', {noremap = true})
vim.keymap.set("v", "c", '"_c', {noremap = true})

vim.keymap.set("n", "d", '"_d', {noremap = true})
vim.keymap.set("n", "D", '"_D', {noremap = true})
vim.keymap.set("n", "dd", '"_dd', {noremap = true})
vim.keymap.set("v", "d", '"_d', {noremap = true})

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false

vim.api.nvim_create_autocmd(
    "User",
    {
        pattern = "OilActionsPost",
        callback = function(event)
            if event.data.actions.type == "move" then
                Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
            end
        end
    }
)

return {
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true
    },
    {
        "m4xshen/hardtime.nvim",
        dependencies = {"MunifTanjim/nui.nvim"},
        event = "VeryLazy",
        opts = {
            disabled_keys = {
                ["<Left>"] = {},
                ["<Right>"] = {}
            }
        }
    },
    {
        "stevearc/oil.nvim",
        opts = {},
        dependencies = {{"echasnovski/mini.icons", opts = {}}},
        keys = {
            {"<leader>o", "<cmd>Oil --float<CR>", mode = {"n"}, desc = "Oil cwd"},
            {"<leader>O", "<cmd>Oil --float .<CR>", mode = {"n"}, desc = "Oil root"}
        }
    },
    {
        "mikesmithgh/kitty-scrollback.nvim",
        enabled = true,
        lazy = true,
        cmd = {
            "KittyScrollbackGenerateKittens",
            "KittyScrollbackCheckHealth",
            "KittyScrollbackGenerateCommandLineEditing"
        },
        event = {"User KittyScrollbackLaunch"},
        config = function()
            require("kitty-scrollback").setup()
        end
    },
    {
        "chrisgrieser/nvim-spider",
        keys = {
            {"w", "<cmd>lua require('spider').motion('w')<CR>", mode = {"n", "o", "x"}},
            {"e", "<cmd>lua require('spider').motion('e')<CR>", mode = {"n", "o", "x"}},
            {"b", "<cmd>lua require('spider').motion('b')<CR>", mode = {"n", "o", "x"}}
        }
    },
    {
        "folke/snacks.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            picker = {
                enable = true,
            },
            scroll = {enable = true},
            scope = {enable = true},
            dim = {
                scope = {
                    cursor = false,
                    treesitter = {
                        enabled = true,
                        blocks = {enabled = true}
                    }
                },
                enable = true
            },
            indent = {
                enabled = true,
                scope = {
                    enabled = true,
                    underline = true
                },
                chunk = {
                    enabled = true
                }
            }
        },
        keys = {
            {"<leader><space>", function()
                    Snacks.picker.files()
                end, desc = "Find files"},
            {
                "<leader>b",
                function()
                    Snacks.picker.buffers()
                end,
                desc = "Buffers"
            },
            {"<leader>g", function()
                    Snacks.picker.grep()
                end, desc = "Grep"},
            {"<leader>s", function()
                    Snacks.picker.lsp_workspace_symbols()
                end, desc = "LSP Workspace Symbols"},
            {"<leader>d", function()
                    Snacks.picker.diagnostics()
                end, desc = "Diagnostics"},
            {
                "<leader>f",
                function()
                    Snacks.dim.enable()
                    vim.cmd("normal! zt")
                end,
                desc = "Focus"
            },
            {
                "<leader>nd",
                function()
                    Snacks.dim.disable()
                end,
                desc = "Disable Dim"
            }
        }
    },
    {
    "folke/todo-comments.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      event = "BufRead",
      opts = {
          keywords = {
              CHANGE = {
                  icon="󰃣",
                  alt = {"REFACTOR", "CLEAN"}
              },
              MAYBE = {
                  icon="?",
                  alt = {"QUESTION", "UNSURE"}
              }
          }
      },
        keys = {
            { "<leader>t", function() Snacks.picker.todo_comments() end, desc = "Todo" },
        },
    }
}

