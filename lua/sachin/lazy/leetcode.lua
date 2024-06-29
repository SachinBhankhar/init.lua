return {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html",
    dependencies = {
        "nvim-telescope/telescope.nvim",
        "nvim-lua/plenary.nvim", -- required by telescope
        "MunifTanjim/nui.nvim",

        -- optional
        "nvim-tree/nvim-web-devicons",
    },
    opts = {
        ---@type string
        arg = "leetcode.nvim",

        ---@type lc.lang
        lang = "python3",

    },
}
