local termim = {}

termim.close_augroup = "termim_auto_close"

termim.auto_close = function()
    vim.api.nvim_create_autocmd({ 'TermClose' }, {
        group = vim.api.nvim_create_augroup(termim.close_augroup, { clear = true }),
        callback = function()
            vim.cmd('quit')
        end,
    })
end

termim.keep_open = function()
    vim.api.nvim_command("augroup " .. termim.close_augroup)
    vim.api.nvim_command("autocmd!")
    vim.api.nvim_command("augroup END")
end

termim.open = function(command, split_dir, keep_open)
    if command == '' or command == nil then
        command = vim.env.SHELL
    end

    if split_dir == '' or split_dir == nil then
        split_dir = 'tabnew'
    end

    if keep_open then
        termim.keep_open()
    else
        termim.auto_close()
    end

    vim.cmd(split_dir .. ' term://' .. command)
end

return termim
