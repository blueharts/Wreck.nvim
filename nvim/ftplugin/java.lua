--[[
    Wrecc.nvim - A wreck of a Ricing.
    File         : java.lua
    Address      : C:\Users\(Redacted for my personal safety)\AppData\Local\nvim\ftplugin
    Dependencies : fold.lua, build.lua, highlight.lua
--]]

-- ──────────────────────────────────────────────
--  Dependencies
-- ──────────────────────────────────────────────
local build = require('build')
require('fold')
require('highlight')

-- Keymaps
vim.keymap.set('n', '<F5>', function() build.run() end, { buffer = true, desc = "Build and Run" })
vim.api.nvim_buf_create_user_command(0, 'Ec', function() build.ec() end, { desc = "Error Check" })

-- Diagnostics
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    float = {
        focusable = false,
        border = 'rounded',
        source = true,
    },
})
