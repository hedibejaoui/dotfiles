return {
    'numToStr/Comment.nvim',
    opts = {
        -- add any options here
    },
    lazy = false,
    config = function()
        local comment = require("Comment")
        comment.setup()
        vim.keymap.set("n", "<leader>/", 'gcc', { desc = "Comment a single line" })
        vim.keymap.set("v", "<leader>/", "<Plug>(comment_toggle_blockwise_visual)", { desc = "Comment multiple lines" })
    end,

}
