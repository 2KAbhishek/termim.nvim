if vim.g.loaded_termim then
    return
end

vim.g.loaded_termim = true

vim.api.nvim_create_autocmd({ 'TermOpen' }, {
    group = vim.api.nvim_create_augroup('termim_open', { clear = true }),
    callback = function(event)
        vim.cmd('setlocal nonumber')
        vim.cmd('setlocal norelativenumber')
        vim.bo[event.buf].buflisted = false
        vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
    end,
})

vim.api.nvim_create_user_command('Fterm', function(input)
    require("termim").open(input.args)
end, { nargs = '*' })

vim.api.nvim_create_user_command('Fterm', function(input)
    require("termim").open(input.args, nil, true)
end, { nargs = '*' })

vim.api.nvim_create_user_command('Sterm', function(input)
    require("termim").open(input.args, 'split')
end, { nargs = '*' })

vim.api.nvim_create_user_command('STerm', function(input)
    require("termim").open(input.args, 'split', true)
end, { nargs = '*' })

vim.api.nvim_create_user_command('Vterm', function(input)
    require("termim").open(input.args, 'vsplit')
end, { nargs = '*' })

vim.api.nvim_create_user_command('VTerm', function(input)
    require("termim").open(input.args, 'vsplit', true)
end, { nargs = '*' })

vim.keymap.set('t', 'JJ', '<C-\\><C-n>', { buffer = true })
