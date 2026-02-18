--[[
    Wrecc.nvim - A wreck of a Ricing.
    File         : build.lua
    Address      : C:\Users\(Redacted for my personal Saftey)\AppData\Local\nvim\lua
    Dependencies : None
--]]

local M = {}
local ns = vim.api.nvim_create_namespace('WreccDiagnostics')

-- ──────────────────────────────────────────────
-- Error Parser 
-- ──────────────────────────────────────────────

-- Java Parsing
local function parse_java_errors(output, bufnr)
    local diagnostics = {}
    for _, line in ipairs(output) do
        local file, lnum, msg = line:match("([^:]+):(%d+): [^:]+: (.+)")
        if file and lnum and msg then
            table.insert(diagnostics, {
                bufnr    = bufnr,
                lnum     = tonumber(lnum) - 1,
                col      = 0,
                severity = line:match("error")
                    and vim.diagnostic.severity.ERROR
                    or  vim.diagnostic.severity.WARN,
                message  = '| Line: ' .. lnum .. ' | ' .. (line:match("error") and "Error" or "Warning") .. ' | ' .. msg,
                source   = 'javac',
            })
        end
    end
    return diagnostics
end

-- Python Parsing
local function parse_python_errors(output, bufnr)
    local diagnostics = {}
    for _, line in ipairs(output) do
        local file, lnum, msg = line:match('File "([^"]+)", line (%d+)')
        if file and lnum then
            table.insert(diagnostics, {
                bufnr    = bufnr,
                lnum     = tonumber(lnum) - 1,
                col      = 0,
                severity = vim.diagnostic.severity.ERROR,
                message  = '| Line: ' .. lnum .. ' | Error | ' .. (msg or 'Syntax error'),
                source   = 'python',
            })
        end
    end
    return diagnostics
end

-- ──────────────────────────────────────────────
-- Build and Run
-- ──────────────────────────────────────────────

function M.run()
    local ft = vim.bo.filetype
    vim.cmd('w')
    local bufnr = vim.api.nvim_get_current_buf()
    vim.diagnostic.reset(ns, bufnr)

    -- Java Build and Run
    if ft == 'java' then
        local files = vim.fn.glob('*.java', false, true)
        local main_class = nil

        for _, file in ipairs(files) do
            local content = table.concat(vim.fn.readfile(file), ' ')
            if content:match('public%s+static%s+void%s+main') then
                local class_name = file:gsub('%.java$', '')
                local package = content:match('package%s+([^%s;]+)')
                main_class = package and (package .. '.' .. class_name) or class_name
                break
            end
        end

        if not main_class then
            vim.notify('No main method found!')
            return
        end

        local output = {}
        vim.fn.jobstart({ 'javac', unpack(files) }, {
            on_stderr = function(_, data)
                if data then
                    for _, line in ipairs(data) do
                        if line ~= '' then table.insert(output, line) end
                    end
                end
            end,
            on_exit = function()
                local diagnostics = parse_java_errors(output, bufnr)
                if #diagnostics > 0 then
                    vim.diagnostic.set(ns, bufnr, diagnostics)
                else
                    vim.cmd('split | resize 12 | term java ' .. main_class)
                    vim.cmd('startinsert')
                end
            end
        })

    -- Python Build and Run
    elseif ft == 'python' then
        vim.cmd('split | resize 12 | term python %')
        vim.cmd('startinsert')
    end
end

-- ──────────────────────────────────────────────
-- Error Checker
-- ──────────────────────────────────────────────

function M.ec()
    local ft = vim.bo.filetype
    vim.cmd('w')
    local bufnr = vim.api.nvim_get_current_buf()
    vim.diagnostic.reset(ns, bufnr)
    local output = {}

    -- Java Error
    if ft == 'java' then
        local files = vim.fn.glob('*.java', false, true)
        vim.fn.jobstart({ 'javac', unpack(files) }, {
            on_stderr = function(_, data)
                if data then
                    for _, line in ipairs(data) do
                        if line ~= '' then table.insert(output, line) end
                    end
                end
            end,
            on_exit = function()
                local diagnostics = parse_java_errors(output, bufnr)
                if #diagnostics > 0 then
                    vim.diagnostic.set(ns, bufnr, diagnostics)
                    vim.notify('Errors found: ' .. #diagnostics)
                else
                    vim.notify('No errors!')
                end
            end
        })

    -- Python Error
    elseif ft == 'python' then
        local file = vim.fn.expand('%')
        vim.fn.jobstart({ 'python', '-m', 'py_compile', file }, {
            on_stderr = function(_, data)
                if data then
                    for _, line in ipairs(data) do
                        if line ~= '' then table.insert(output, line) end
                    end
                end
            end,
            on_exit = function()
                local diagnostics = parse_python_errors(output, bufnr)
                if #diagnostics > 0 then
                    vim.diagnostic.set(ns, bufnr, diagnostics)
                    vim.notify('Errors found: ' .. #diagnostics)
                else
                    vim.notify('No errors!')
                end
            end
        })
    end
end

return M
