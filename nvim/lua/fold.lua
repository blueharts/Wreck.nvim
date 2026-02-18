--[[
    Wrecc.nvim - A wreck of a Ricing.
    File         : fold.lua
    Address      : C:\Users\(Redacted for my personal Saftey)\AppData\Local\nvim\lua
    Dependencies : None
--]]


-- ──────────────────────────────────────────────
--  Comment Style Detection
-- ──────────────────────────────────────────────

local ft_open = {
    java   = "//> ",
    python = "#> ",
}

local ft_close = {
    java   = "//<",
    python = "#<",
}

local ft = vim.bo.filetype
local open_marker  = ft_open[ft]
local close_marker = ft_close[ft]

if not open_marker then return end



-- ──────────────────────────────────────────────
--  Fold Expression
-- ──────────────────────────────────────────────

function _G.WreccFoldExpr()
    local line = vim.fn.getline(vim.v.lnum)

    if line:match("^%s*" .. vim.pesc(open_marker)) then
        return "a1"
    end

    if line:match("^%s*" .. vim.pesc(close_marker) .. "%s*$") then
        return "s1"
    end

    return "="
end



-- ──────────────────────────────────────────────
--  Fold Text
-- ──────────────────────────────────────────────

function _G.WreccFoldText()
    local line     = vim.fn.getline(vim.v.foldstart)
    local indent   = string.rep(' ', vim.fn.indent(vim.v.foldstart))
    local lines    = vim.v.foldend - vim.v.foldstart + 1

    local title = line:match("^%s*" .. vim.pesc(open_marker) .. "%s*(.*)$")
    if not title or title == "" then
        title = "Untitled Region"
    end

    return indent .. '▸ ' .. title .. '  [' .. lines .. ' lines]'
end



-- ──────────────────────────────────────────────
--  Apply Fold Settings
-- ──────────────────────────────────────────────

vim.schedule(function()
    vim.opt_local.foldmethod = 'expr'
    vim.opt_local.foldexpr   = 'v:lua.WreccFoldExpr()'
    vim.opt_local.foldtext   = 'v:lua.WreccFoldText()'
    vim.opt_local.foldlevel  = 99
    vim.opt_local.foldcolumn = 'auto:4'
    vim.opt_local.fillchars:append({ foldopen = '▾', foldsep = '│', foldclose = '▸' })
end)
