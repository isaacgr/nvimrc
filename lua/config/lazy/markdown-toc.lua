return {
    {
        "hedyhli/markdown-toc.nvim",
        config = function()
            require('mtoc').setup({
                cmd = {"Mtoc"},
                main="mtoc"
            })
        end
    }
}

