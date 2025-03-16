local function format_on_save()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_active_clients({bufnr = bufnr})
    if #clients > 0 then
        vim.lsp.buf.format()
    end
end

vim.api.nvim_create_autocmd(
    "BufWritePre",
    {
        pattern = "*",
        callback = format_on_save
    }
)

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)

vim.diagnostic.config {
    update_in_insert = true,
    severity_sort = true
}
vim.lsp.inlay_hint.enable(true)

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
end

return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
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
                                -- allTargets = false
                            },
                            formatOnSave = {
                                enable = true
                            },
                            cachePriming = {
                                -- enable = false
                            },
                            procMacro = {
                                -- enable = false
                            },
                            cargo = {
                                -- loadOutDirsFromCheck = false,
                                -- allTargets = false
                            }
                        }
                    }
                }
            }
        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")

            -- No need to set `hybridMode` to `true` as it's the default value
            lspconfig.volar.setup {
                filetypes = {"typescript", "javascript", "javascriptreact", "typescriptreact", "vue"},
                capabilities = require("cmp_nvim_lsp").default_capabilities(),
                on_attach = function(client, bufnr)
                    client.server_capabilities.documentFormattingProvider = false
                end,
                init_options = {
                    vue = {
                        -- disable hybrid mode
                        hybridMode = false,
                    }
                }
            }
        end
    },
    {
        "nvimtools/none-ls.nvim",
        dependencies = {"nvimtools/none-ls-extras.nvim"},
        config = function()
            local null_ls = require("null-ls")

            null_ls.setup(
                {
                    sources = {
                        null_ls.builtins.formatting.prettier,
                        require("none-ls.diagnostics.eslint")
                    }
                }
            )
        end
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {"hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip"},
        lazy = false,
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

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
    },
    {
      'Exafunction/codeium.vim',
      event = 'BufEnter'
    }
}

