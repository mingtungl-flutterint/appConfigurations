-- $Id lua/config/treesitter.lua
--
require'nvim-treesitter.install'.compilers = { "gcc", "clang", "cl" }
require'nvim-treesitter.configs'.setup {
        -- one of "all", "maintained" (parsers with maintainers), or a list of languages
        ensure_installed = "maintained",
        -- List of parsers to ignore installing
        ignore_install = { "dart", "php", "scss", "toml", "rst", "ruby", "fennel", "zig",
                           "vue", "beancount", "ocaml", "r", "svelte", "ocaml_interface", "query",
                           "sparql", "turtle", "clojure", "ql", "teal", "graphql", "kotlin",
                           "glimmer", "scala", "ledger", "julia", "rust"
    },
    indent = {
        enable = true
    },
    highlight = {
        enable = true,              -- false will disable the whole extension
        disable = { },              -- list of language that will be disabled
    },
    playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false -- Whether the query persists across vim sessions
    },
    rainbow = {
        enable = true
    }
}
