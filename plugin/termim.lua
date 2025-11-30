if vim.g.loaded_termim then
    return
end
vim.g.loaded_termim = true
local termim = require('termim')

vim.api.nvim_create_autocmd({ 'TermOpen' }, {
    group = vim.api.nvim_create_augroup('termim_open', { clear = true }),
    callback = function(event)
        vim.cmd('setlocal nonumber')
        vim.cmd('setlocal norelativenumber')
        vim.cmd('setlocal signcolumn=no')
        vim.cmd('startinsert!')
        vim.cmd('set cmdheight=1')
        vim.bo[event.buf].buflisted = false
        if not termim.is_persistent(event.buf) then
            vim.bo[event.buf].bufhidden = 'wipe'
        end
        vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
    end,
})

vim.api.nvim_create_user_command('Tterm', function(input)
    termim.open(input.args)
end, { nargs = '*' })

vim.api.nvim_create_user_command('TTerm', function(input)
    termim.open(input.args, nil, true)
end, { nargs = '*' })

vim.api.nvim_create_user_command('Fterm', function(input)
    termim.open(input.args, 'float')
end, { nargs = '*' })

vim.api.nvim_create_user_command('FTerm', function(input)
    termim.open(input.args, 'float', true)
end, { nargs = '*' })

vim.api.nvim_create_user_command('Sterm', function(input)
    termim.open(input.args, 'split')
end, { nargs = '*' })

vim.api.nvim_create_user_command('STerm', function(input)
    termim.open(input.args, 'split', true)
end, { nargs = '*' })

vim.api.nvim_create_user_command('Vterm', function(input)
    termim.open(input.args, 'vsplit')
end, { nargs = '*' })

vim.api.nvim_create_user_command('VTerm', function(input)
    termim.open(input.args, 'vsplit', true)
end, { nargs = '*' })

vim.keymap.set('t', 'JJ', '<C-\\><C-n>', { buffer = true })
