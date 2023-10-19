return {
    "williamboman/mason.nvim",
    opts = {
        ensure_installed = {
            -- lua
            "stylua",
            -- bash
            "shellcheck",
            "shfmt",
        },
    },
}
