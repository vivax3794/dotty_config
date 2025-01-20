local function format_on_save()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
  if #clients > 0 then
    vim.lsp.buf.format()
  end
end

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = format_on_save,
})

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)

vim.diagnostic.config {
    update_in_insert = true,
    severity_sort = true,
}
vim.lsp.inlay_hint.enable(true)

local rust_attach = function(_, bufnr)
    -- Hover actions
    vim.keymap.set(
        "n",
        "<leader>a",
        function()
            vim.cmd.RustLsp("codeAction") -- supports rust-analyzer's grouping
            -- or vim.lsp.buf.codeAction() if you don't want grouping.
        end,
        {silent = true, buffer = bufnr}
    )
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
                                command = "clippy"
                            },
                            formatOnSave = {
                                enable = true
                            },
                            completion = {
                                autoClosingAngleBrackets = true
                            },
                            cargo = {
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
local lspconfig = require('lspconfig')

-- Custom command to run your LSP server
require('lspconfig.configs').surf = {
    default_config = {
        cmd = { "/home/viv/coding/ripple/target/release/surf" }, -- Command to start your LSP server
        filetypes = { "css" }, -- Filetypes your server will handle
        settings = {}, -- Additional server-specific settings
        root_dir = function(fname)
            return lspconfig.util.find_git_ancestor(fname)
        end;
    },
}

-- Enable your custom server
lspconfig.surf.setup({
    on_attach = function(client, bufnr)
        print("Surf LSP attached to buffer " .. bufnr)
    end,
})

        end
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {"hrsh7th/cmp-nvim-lsp", "SirVer/ultisnips", "quangnguyen30192/cmp-nvim-ultisnips"},
        lazy = false,
        config = function()
            local cmp = require("cmp")
            cmp.setup {
                snippet = {
                    expand = function(args)
                        vim.fn["UltiSnips#Anon"](args.body)
                    end,
                },
                sources = cmp.config.sources {
                    { name = "nvim_lsp" },
                    { name = 'ultisnips' }
                },
                mapping = cmp.mapping.preset.insert {
                    ["<CR>"] = cmp.mapping.confirm({ select = true})
                }
            }
        end
    },
}
