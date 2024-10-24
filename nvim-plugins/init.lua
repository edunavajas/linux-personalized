return { 
    "nvim-lua/plenary.nvim", 
     
    { 
    "NvChad/base46", 
    build = function() 
    require("base46").load_all_highlights() 
    end, 
    }, 
     
    { 
    "NvChad/ui", 
    lazy = false, 
    }, 
     
    { 
    "nvim-tree/nvim-web-devicons", 
    opts = function() 
    dofile(vim.g.base46_cache .. "devicons") 
    return { override = require "nvchad.icons.devicons" } 
    end, 
    }, 
     
    { 
    "lukas-reineke/indent-blankline.nvim", 
    event = "User FilePost", 
    opts = { 
    indent = { char = "│", highlight = "IblChar" }, 
    scope = { char = "│", highlight = "IblScopeChar" }, 
    }, 
    config = function(, opts) 
    dofile(vim.g.base46_cache .. "blankline") 
     
    local hooks = require "ibl.hooks" 
    hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level) 
    require("ibl").setup(opts) 
     
    dofile(vim.g.base46_cache .. "blankline") 
    end, 
    }, 
     
    -- file managing , picker etc 
    { 
    "nvim-tree/nvim-tree.lua", 
    cmd = { "NvimTreeToggle", "NvimTreeFocus" }, 
    opts = function() 
    return require "nvchad.configs.nvimtree" 
    end, 
    }, 
     
    { 
    "folke/which-key.nvim", 
    keys = { "<leader>", "<c-r>", "<c-w>", '"', "'", "`", "c", "v", "g" }, 
    cmd = "WhichKey", 
    config = function(, opts) 
    dofile(vim.g.base46_cache .. "whichkey") 
    require("which-key").setup(opts) 
    end, 
    }, 
     
    -- formatting! 
    { 
    "stevearc/conform.nvim", 
    opts = { 
    formatters_by_ft = { 
    lua = { "stylua" }, 
    }, 
    }, 
    }, 
     
    -- git stuff 
    { 
    "lewis6991/gitsigns.nvim", 
    event = "User FilePost", 
    opts = function() 
    return require "nvchad.configs.gitsigns" 
    end, 
    }, 
     
    -- lsp stuff 
    { 
    "williamboman/mason.nvim", 
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" }, 
    opts = function() 
    return require "nvchad.configs.mason" 
    end, 
    }, 
     
    { 
    "neovim/nvim-lspconfig", 
    event = "User FilePost", 
    config = function() 
    require("nvchad.configs.lspconfig").defaults() 
    end, 
    }, 
     
    -- load luasnips + cmp related in insert mode only 
    { 
    "nvim-telescope/telescope.nvim", 
    dependencies = { "nvim-treesitter/nvim-treesitter" }, 
    cmd = "Telescope", 
    opts = function() 
    return require "nvchad.configs.telescope" 
    end, 
    config = function(, opts) 
    local telescope = require "telescope" 
    telescope.setup(opts) 
     
    -- load extensions 
    for , ext in ipairs(opts.extensions_list) do 
    telescope.load_extension(ext) 
    end 
    end, 
    }, 
     
    { 
    "NvChad/nvim-colorizer.lua", 
    event = "User FilePost", 
    opts = { 
    user_default_options = { names = false }, 
    filetypes = { 
    "*", 
    "!lazy", 
    }, 
    }, 
    config = function(, opts) 
    require("colorizer").setup(opts) 
     
    -- execute colorizer as soon as possible 
    vim.defer_fn(function() 
    require("colorizer").attach_to_buffer(0) 
    end, 0) 
    end, 
    }, 
     
    { 
    "nvim-treesitter/nvim-treesitter", 
    event = { "BufReadPost", "BufNewFile" }, 
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" }, 
    build = ":TSUpdate", 
    opts = function() 
    return require "nvchad.configs.treesitter" 
    end, 
    config = function(, opts) 
    require("nvim-treesitter.configs").setup(opts) 
    end, 
    }, 
    } 