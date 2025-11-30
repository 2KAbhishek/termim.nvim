local termim = {}

termim.persistent_map = {
    float = { buf = nil, win = nil },
    split = { buf = nil, win = nil },
    vsplit = { buf = nil, win = nil },
    tabnew = { buf = nil, win = nil },
}

termim.is_persistent = function(buf)
    for _, term in pairs(termim.persistent_map) do
        if term.buf == buf then
            return true
        end
    end
    return false
end

termim.close_augroup = 'termim_auto_close'

termim.auto_close = function()
    vim.api.nvim_create_autocmd({ 'TermClose' }, {
        group = vim.api.nvim_create_augroup(termim.close_augroup, { clear = true }),
        callback = function(event)
            if termim.is_persistent(event.buf) then
                return
            end
            vim.schedule(function()
                if vim.api.nvim_buf_is_valid(event.buf) then
                    vim.api.nvim_buf_delete(event.buf, { force = true })
                end
            end)
        end,
    })
end

termim.keep_open = function()
    vim.api.nvim_command('augroup ' .. termim.close_augroup)
    vim.api.nvim_command('autocmd!')
    vim.api.nvim_command('augroup END')
end

local get_float_win = function()
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)
    return {
        relative = 'editor',
        width = width,
        height = height,
        row = row,
        col = col,
        style = 'minimal',
        border = 'single',
    }
end

local open_window = function(buf, split_dir)
    local win = nil
    if split_dir == 'float' then
        win = vim.api.nvim_open_win(buf, true, get_float_win())
    else
        vim.cmd(split_dir)
        win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_buf(win, buf)
    end
    return win
end

local create_terminal = function(buf, command, split_dir)
    local win = open_window(buf, split_dir)
    vim.cmd('terminal ' .. command)
    return buf, win
end

local toggle_persistent_terminal = function(command, split_dir)
    termim.keep_open()

    local persistent_term = termim.persistent_map[split_dir]

    if persistent_term.buf == nil or not vim.api.nvim_buf_is_valid(persistent_term.buf) then
        local buf = vim.api.nvim_create_buf(true, false)
        persistent_term.buf = buf
        local _, win = create_terminal(buf, command, split_dir)
        persistent_term.win = win
    elseif persistent_term.win ~= nil and vim.api.nvim_win_is_valid(persistent_term.win) then
        vim.api.nvim_win_close(persistent_term.win, true)
        persistent_term.win = nil
    else
        local win = open_window(persistent_term.buf, split_dir)
        persistent_term.win = win
        vim.cmd('startinsert!')
    end
end

local open_ephemeral_terminal = function(command, split_dir)
    termim.auto_close()
    local buf = vim.api.nvim_create_buf(false, true)
    create_terminal(buf, command, split_dir)
end

termim.open = function(command, split_dir, persistent)
    persistent = persistent or false

    if command == '' or command == nil then
        command = vim.o.shell
    end

    if split_dir == '' or split_dir == nil then
        split_dir = 'tabnew'
    end

    if persistent then
        toggle_persistent_terminal(command, split_dir)
    else
        open_ephemeral_terminal(command, split_dir)
    end
end

return termim
