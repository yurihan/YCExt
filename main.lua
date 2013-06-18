-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local operationQueue = require'lib.operationQueue'
local op = operationQueue:new()

-- 최대 동시 실행 갯수.
op.maxConcurrentCount = 3

-- 작업 생성
for i = 0, 100 do
	-- createOperation 함수를 호출하면 자동으로 operationQueue에 등록됩니다.
	-- function OperationQueue:createOperation(obj,run,cbFinished,isFinished) 
	-- 함께 넘겨줄 object., 작업할 함수, 종료시 호출될 함수(optional), 비동기 분할처리를 위한 종료조건 판별 함수(optional)
	op:createOperation({number = i},function(obj)
		print('number = '..i..' start..')
	end,
	function()
		print('number = '..i..' finished..')
	end)		
end

print('operationQueue start..')
-- operationQueue를 실행시킵니다. 인자로는 모든 작업이 완료되었을때 호출된 함수를 넘겨줍니다.(optional)
op:start(function()
	print('operationQueue finished..')
end)
