local function format_on_save()
    vim.lsp.buf.format()
end

vim.api.nvim_create_autocmd(
    "BufWritePre",
    {
        pattern = "*",
        callback = format_on_save
    }
)

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, {desc = "View Error under cursor"})

vim.diagnostic.config {
    virtual_lines = false,
    virtual_text = true,
    update_in_insert = true,
    severity_sort = true,
    underline = false,
}
vim.lsp.inlay_hint.enable(true)

vim.keymap.set("n", "<leader>E", function() 
    config = vim.diagnostic.config()
    vim.diagnostic.config {
        virtual_lines = not config.virtual_lines,
        virtual_text = not config.virtual_text,
    }
end)

local rust_attach = function(_, bufnr)
    -- Hover actions
    vim.keymap.set(
        "n",
        "<leader>a",
        function()
            vim.cmd.RustLsp("codeAction")
        end,
        {silent = true, buffer = bufnr}
    )
    vim.keymap.set("v", "<leader>a", vim.lsp.buf.code_action, {silent = true, buffer = bufnr})
    vim.keymap.set(
        "n",
        "K", -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
        function()
            vim.cmd.RustLsp({"hover", "actions"})
        end,
        {silent = true, buffer = bufnr}
    )
    vim.keymap.set("n", "<Leader>r", vim.lsp.buf.rename, {buffer = bufnr})

    vim.keymap.set("n", "<leader>md", ":RustLsp moveItem down", {silent = true, buffer = bufnr})
    vim.keymap.set("n", "<leader>mu", ":RustLsp moveItem up", {silent = true, buffer = bufnr})
end

return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = {"BufReadPre", "BufNewFile"},
        config = function()
            require("nvim-treesitter.configs").setup {
                ensure_installed = {"rust", "lua"},
                auto_install = true,
                ignore_install = {"kdl", "html"},
                highlight = {
                    enable = true,
                    disable = {"vimdoc", "help"}
                }
            }
        end
    },
    {
        "mrcjkb/rustaceanvim",
        version = "^5", -- Recommended
        lazy = false, -- This plugin is already lazy
        config = function()
            vim.g.rustaceanvim = {
                server = {
                    capabilities = {
                        experimental = {
                            snippetTextEdit = false
                        }
                    },
                    on_attach = rust_attach,
                    settings = {
                        ["rust-analyzer"] = {
                            checkOnSave = {
                                enable = true,
                                command = "clippy",
                                allFeatures = true
                            },
                            formatOnSave = {
                                enable = true
                            },
                            cargo = {
                                allFeatures = true,
                                allTargets = true,
                                buildScripts = {
                                    rebuildOnSave = false
                                },
                            }
                        }
                    }
                }
            }
        end
    },
    -- {
    --     "neovim/nvim-lspconfig",
    --     config = function()
    --         local lspconfig = require("lspconfig")
    --
    --         lspconfig.volar.setup {
    --             filetypes = {"typescript", "javascript", "javascriptreact", "typescriptreact", "vue"},
    --             capabilities = require("cmp_nvim_lsp").default_capabilities(),
    --             on_attach = function(client, bufnr)
    --                 client.server_capabilities.documentFormattingProvider = false
    --             end,
    --             init_options = {
    --                 vue = {
    --                     -- disable hybrid mode
    --                     hybridMode = false,
    --                 }
    --             }
    --         }
    --     end
    -- },
    -- {
    --     "nvimtools/none-ls.nvim",
    --     dependencies = {"nvimtools/none-ls-extras.nvim"},
    --     config = function()
    --         local null_ls = require("null-ls")
    --
    --         null_ls.setup(
    --             {
    --                 sources = {
    --                     null_ls.builtins.formatting.prettier,
    --                     require("none-ls.diagnostics.eslint")
    --                 }
    --             }
    --         )
    --     end
    -- },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {"hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip"},
        lazy = true,
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            require("luasnip.loaders.from_lua").lazy_load {
                paths = vim.fn.stdpath("config") .. "/snippets"
            }

            vim.keymap.set(
                {"i", "s"},
                "<C-J>",
                function()
                    luasnip.jump(1)
                end,
                {expr = true, silent = true}
            )
            vim.keymap.set(
                {"i", "s"},
                "<C-L>",
                function()
                    luasnip.jump(-1)
                end,
                {expr = true, silent = true}
            )

            cmp.setup {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body) -- This makes LSP snippets expand correctly
                    end
                },
                sources = cmp.config.sources {
                    {name = "nvim_lsp"},
                    {name = "luasnip"} -- Enables LSP snippet support
                },
                mapping = cmp.mapping.preset.insert {
                    ["<CR>"] = cmp.mapping.confirm({select = true})
                }
            }
        end
    }
}

