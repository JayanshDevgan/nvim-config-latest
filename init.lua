-- Enable line numbers
vim.wo.number = true
vim.wo.relativenumber = true

-- Set clipboard option
vim.opt.clipboard = "unnamedplus"

-- Set the runtime path to include Lazy.nvim
vim.opt.runtimepath:prepend("~/.local/share/nvim/site/pack/packer/start/lazy.nvim")

-- Load Lazy.nvim and set up plugins
require("lazy").setup({
  -- Web Devicons for bufferline and file tree (we'll disable icons in bufferline)
  { 
    'nvim-tree/nvim-web-devicons', 
    config = function()
      require'nvim-web-devicons'.setup()  -- Ensure this setup is there for icons (can be ignored if you prefer no icons)
    end
  },
  -- Bufferline plugin setup
  { 
    'akinsho/bufferline.nvim', 
    requires = 'nvim-tree/nvim-web-devicons', 
    config = function()
      require'bufferline'.setup {
        options = {
          numbers = "none",  -- Disable buffer numbers
          diagnostics = "nvim_lsp",  -- Show LSP diagnostics
          show_buffer_icons = false,  -- Disable icons
          separator_style = "thin",  -- Use thin separator lines
          always_show_bufferline = false, -- Always show the bufferline
        }
      }
    end
  },
  -- Treesitter and other plugins
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
  { "nvim-tree/nvim-tree.lua", 
    requires = { "nvim-tree/nvim-web-devicons" }, 
    config = function()
      require'nvim-tree'.setup {
        -- Disable icons for file tree
        renderer = {
          icons = {
            show = {
              file = false,
              folder = false,
              folder_arrow = false,
              git = false
            }
          }
        }
      }
    end
  },
})

-- Set colorscheme
vim.cmd("colorscheme PaperColor")

-- Example of setting up a plugin
require('nvim-treesitter.configs').setup {
  highlight = { enable = true },
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
    ['<C-Space>'] = cmp.mapping.complete(),  -- Trigger completion
    ['<C-e>'] = cmp.mapping.close(),         -- Close completion menu
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Confirm selection
    ['<Up>'] = cmp.mapping.select_prev_item(),
    ['<Down>'] = cmp.mapping.select_next_item(),
  },
  sources = {
    { name = 'nvim_lsp' },  -- LSP source
    { name = 'luasnip' },    -- Snippet source
    { name = 'buffer' },     -- Buffer completions
    { name = 'path' },       -- File path completions
  },
})

-- Setup LSP with nvim-lsp-installer
local lsp_installer = require("nvim-lsp-installer")

lsp_installer.on_server_ready(function(server)
  local opts = {}
  
  -- Use `ts_ls` instead of `tsserver`
  if server.name == "ts_ls" then
    opts.root_dir = function() return vim.loop.cwd() end
  end
  
  -- Setup server
  server:setup(opts)
end)

-- Key mappings
vim.api.nvim_set_keymap('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Tab>', ':BufferLineCycleNext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-Tab>', ':BufferLineCyclePrev<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-v>', '"+p', { noremap = true, silent = true })  -- Paste from clipboard
vim.api.nvim_set_keymap('n', 'qq', ':bd<CR>', { noremap = true, silent = true })  -- Close buffer

