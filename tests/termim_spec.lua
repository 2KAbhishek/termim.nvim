local termim = require('termim')

describe('termim', function()
    it('has the right functions defined', function()
        assert.is_function(termim.auto_close)
        assert.is_function(termim.keep_open)
        assert.is_function(termim.open)
    end)
end)
