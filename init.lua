-- init.lua

vim.wo.number = true
vim.wo.relativenumber = true

vim.opt.clipboard = "unnamedplus"

-- Set the runtime path to include Lazy.nvim
vim.opt.runtimepath:prepend("~/.local/share/nvim/site/pack/packer/start/lazy.nvim")

-- Load Lazy.nvim
require("lazy").setup({
    -- Add your plugins here
    { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },
    { "nvim-lua/plenary.nvim" },
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },  -- For buffer completions
    { "hrsh7th/cmp-path" },    -- For file path completions
    { "hrsh7th/cmp-cmdline" }, -- For command line completions
    { "neovim/nvim-lspconfig" },
    { "NLKNguyen/papercolor-theme" },
    { "L3MON4D3/LuaSnip" },     -- Snippet engine
    { "saadparwaiz1/cmp_luasnip" }, -- Snippet completions
    { "williamboman/nvim-lsp-installer" }, -- LSP installer
})

vim.cmd("colorscheme PaperColor")
-- Example of setting up a plugin
require('nvim-treesitter.configs').setup {
    highlight = {
        enable = true,
    },
}

-- Setup nvim-cmp
local cmp = require'cmp'
local luasnip = require'luasnip'

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    mapping = {

        ['<Tab>'] = function(fallback)

            if cmp.visible() then

                cmp.select_next_item() -- Navigate to next suggestion

            else

                fallback() -- Insert a tab character

            end

        end,

        ['<S-Tab>'] = function(fallback)

            if cmp.visible() then

                cmp.select_prev_item() -- Navigate to previous suggestion

            else

                fallback() -- Insert a tab character

            end

        end,

        ['<C-Space>'] = cmp.mapping.complete(),      -- Trigger completion

        ['<C-e>'] = cmp.mapping.close(),             -- Close completion menu

        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Confirm selection
	
	['<Up>'] = cmp.mapping.select_prev_item(), 

        ['<Down>'] = cmp.mapping.select_next_item(),

    },
    sources = {
        { name = 'nvim_lsp' }, -- LSP source
        { name = 'luasnip' },  -- Snippet source
        { name = 'buffer' },   -- Buffer completions
        { name = 'path' },     -- File path completions
    },
})

-- Setup LSP with nvim-lsp-installer
local lsp_installer = require("nvim-lsp-installer")

lsp_installer.on_server_ready(function(server)
    local opts = {}
    -- Customize the options for specific servers here
    if server.name == "tsserver" then
        opts.root_dir = function() return vim.loop.cwd() end
    end

    -- This setup function is called for each installed server
    server:setup(opts)
end)

-- You can install language servers using :LspInstall <server_name>
-- For example, to install TypeScript server, run:
-- :LspInstall ts_ls


vim.api.nvim_set_keymap('n', '<Tab>', ':bnext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-Tab>', ':bprevious<CR>', { noremap = true, silent = true })
