-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local operationQueue = require'lib.operationQueue'
local op = operationQueue:new()

op.maxConcurrentCount = 3

for i = 0, 100 do
	op:createOperation({number = i},function(obj)
		print('number = '..i..' start..')
	end,
	function()
		print('number = '..i..' finished..')
	end)		
end

print('operationQueue start..')

op:start(function()
	print('operationQueue finished..')
end)
