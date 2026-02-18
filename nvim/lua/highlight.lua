--[[
    Wrecc.nvim - A wreck of a Ricing.
    File         : highlight.lua
    Address      : C:\Users\(Redacted for my personal saftey)\AppData\Local\nvim\lua
    Dependencies : None
--]]

local ft = vim.bo.filetype

-- ──────────────────────────────────────────────
--  Java
-- ──────────────────────────────────────────────
if ft == 'java' then
    vim.cmd('syntax on')
    vim.cmd([[syn match JMethodName "\<\w\+\>\ze\s*("]])
    vim.cmd([[syn match JClassName  "\<[A-Z]\w\+\>"]])
    vim.cmd([[syn match JVarName    "\<\w\+\>\s\+\zs\w\+\ze\s*[=;]"]])

    local JHighlights = {
        javaConditional  = { fg = "#d20f39" },
        javaStatement    = { fg = "#d20f39" },
        JMethodName      = { fg = "#1e66f5" },
        JClassName       = { fg = "#1e66f5" },
        javaType         = { fg = "#8839ef", italic = true },
        javaStorageClass = { fg = "#fe640b" },
        javaClassDecl    = { fg = "#fe640b", bold = true },
        JVarName         = { fg = "#4c4f69" },
        javaString       = { fg = "#40a02b" },
        javaNumber       = { fg = "#fe640b" },
        javaComment      = { fg = "#9ca0b0", italic = true },
    }

    for group, settings in pairs(JHighlights) do
        vim.api.nvim_set_hl(0, group, settings)
    end
end
