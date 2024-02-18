local simterm = {}

simterm.open = function(command, split_dir)
    if command == '' or command == nil then
        command = vim.env.SHELL
    end

    if split_dir == '' or split_dir == nil then
        split_dir = 'tabnew'
    end

    vim.cmd(split_dir .. ' term://' .. command)
end

return simterm
