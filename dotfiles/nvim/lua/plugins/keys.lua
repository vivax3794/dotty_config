vim.o.scrolloff = 10;
vim.opt.expandtab = true;
vim.opt.tabstop = 4;
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.keymap.set("i", "<C-s>", "<Esc>:wa<CR>a", {silent = true})
vim.keymap.set("n", "<C-s>", ":wa<CR>", {silent = true})
vim.keymap.set("n", "<leader>q", ":wqa<CR>", {silent = true})
vim.keymap.set("n", "<leader>h", ":noh<CR>", {silent = true})

vim.keymap.set('n', '<Left>', ':bp<CR>', { silent = true })
vim.keymap.set('n', '<Right>', ':bn<CR>', { silent = true })

vim.keymap.set('n', 'c', '"_c', { noremap = true })
vim.keymap.set('n', 'C', '"_C', { noremap = true })
vim.keymap.set('n', 'cc', '"_cc', { noremap = true })
vim.keymap.set('v', 'c', '"_c', { noremap = true })

vim.keymap.set('n', 'd', '"_d', { noremap = true })
vim.keymap.set('n', 'D', '"_D', { noremap = true })
vim.keymap.set('n', 'dd', '"_dd', { noremap = true })
vim.keymap.set('v', 'd', '"_d', { noremap = true })

vim.keymap.set('n', '<left>', '<Cmd>BufferPrevious<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<right>', '<Cmd>BufferNext<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader><left>', '<Cmd>BufferMovePrevious<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader><right>', '<Cmd>BufferMoveNext<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>c', '<Cmd>BufferClose<CR>', { noremap = true, silent = true })

return {
    {
        "karb94/neoscroll.nvim",
        lazy = false,
        opts = {}
    },
    {
        "Aasim-A/scrollEOF.nvim",
        lazy = false,
        opts = {}
    },
    {
        "nvim-telescope/telescope.nvim",
        keys = "<leader>f",
        config = function(_, _)
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
            vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
            vim.keymap.set("n", "<leader>fs", builtin.lsp_dynamic_workspace_symbols, {})
            vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { bufnr = nil })
        end
    },
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = {"nvim-telescope/telescope.nvim"},
        keys = "<leader>ft",
        config = function(_, _)
            require("telescope").load_extension "file_browser"
            local file_browser = require("telescope").extensions.file_browser.file_browser
            vim.keymap.set("n", "<leader>ft", file_browser, {})
        end
    },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
    },
    {
        "m4xshen/hardtime.nvim",
        dependencies = { "MunifTanjim/nui.nvim" },
        opts = {
            disabled_keys = {
                ["<Left>"] = {},
                ["<Right>"] = {}
            },
        }
    },
    { 'wakatime/vim-wakatime', lazy = false }
}
