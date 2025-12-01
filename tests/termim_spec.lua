local termim = require('termim')

describe('termim', function()
    it('has the right functions defined', function()
        assert.is_function(termim.is_persistent)
        assert.is_function(termim.open)
    end)
end)
