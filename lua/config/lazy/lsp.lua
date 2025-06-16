-- Simplified Neovim LSP configuration using mason and nvim-lspconfig

-- 1. Define project root markers for LSP
local root_files = {
    '.luarc.json',
    '.luarc.jsonc',
    '.luacheckrc',
    '.stylua.toml',
    'stylua.toml',
    'selene.toml',
    'selene.yml',
    '.git',
    '.tsconfig.json',
    'package.json'
}

return {
    "neovim/nvim-lspconfig",
    dependencies = {
        -- Formatter integration
        "stevearc/conform.nvim",
        -- Mason for installing LSP servers
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        -- Completion engine and LSP source
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp",
        -- Snippet support
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        -- UI for LSP progress
        "j-hui/fidget.nvim",
    },
    config = function()
        -- 2. Setup formatting via conform
        require("conform").setup({
            formatters_by_ft = {}, -- add filetype->formatter mappings here
        })

        -- 3. Configure nvim-cmp and merge capabilities with LSP defaults
        local cmp          = require('cmp')
        local cmp_lsp      = require('cmp_nvim_lsp')
        local capabilities = vim.tbl_deep_extend(
            'force',
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )

        -- 4. Show LSP progress with fidget
        require('fidget').setup({})

        -- 5. Bootstrap mason and mason-lspconfig
        local lspconfig = require('lspconfig')
        local util      = lspconfig.util

        require('mason').setup()
        require('mason-lspconfig').setup({
            ensure_installed = { 'lua_ls', 'gopls', 'ts_ls', 'pyright' },
            handlers = {
                -- Default handler for all servers:
                function(server_name)
                    lspconfig[server_name].setup {
                        root_dir     = util.root_pattern(unpack(root_files)),
                        capabilities = capabilities,
                    }
                end,

                -- Custom settings for Lua language server:
                ['lua_ls'] = function()
                    lspconfig.lua_ls.setup {
                        root_dir     = util.root_pattern(unpack(root_files)),
                        capabilities = capabilities,
                        settings     = {
                            Lua = {
                                format = {
                                    enable = true,
                                    defaultConfig = {
                                        indent_style = 'space',
                                        indent_size  = '2',
                                    },
                                },
                            },
                        },
                    }
                end,
                ['pyright'] = function()
                    lspconfig.pyright.setup {
                        capabilities = capabilities,
                        settings = {
                            python = {
                                analysis = {
                                    autoImportCompletions = true,
                                    diagnosticMode = "workspace",
                                    typeCheckingMode = "strict", 
                                    useLibraryCodeForTypes = true,
                                }
                            }
                        }
                    }
                end
            },
        })

        -- 6. Completion configuration
        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(),
                ['<C-n>'] = cmp.mapping.select_next_item(),
                ['<Tab>'] = cmp.mapping.confirm({ select = true }),
                ['<C-Space>'] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
            }, {
                { name = 'buffer' },
            }),
        })

        -- 7. Diagnostic display settings
        vim.diagnostic.config({
            float = {
                focusable = false,
                style     = 'minimal',
                border    = 'rounded',
                source    = 'always',
            },
        })
    end,
}
