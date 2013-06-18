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
--[[
for i = 0, 100 do
	-- createOperation 함수를 호출하면 자동으로 operationQueue에 등록됩니다.
	-- function OperationQueue:createOperation(obj,run,cbFinished,isFinished) 
	-- 함께 넘겨줄 object., 작업할 함수, 종료시 호출될 함수(optional), 비동기 분할처리를 위한 종료조건 판별 함수(optional)
	op:createOperation({number = i},function(obj)
		print('number = '..i..' start..')
	end,
	function(obj)
		print('number = '..i..' finished..')
	end)
end

print('operationQueue start..')
-- operationQueue를 실행시킵니다. 인자로는 모든 작업이 완료되었을때 호출된 함수를 넘겨줍니다.(optional)
op:start(function()
	print('operationQueue finished..')
end)
--]]

local imgList = {'126844883596.png','126844883607.png','126844883623.png'
	,'126844883631.png','126844883648.png','126844883656.png','126844883665.png'
	,'12684488368.png','126844883688.png','126844883695.png','126844883702.png'
	,'126844883708.png','126844883722.png','126844883733.png','126844883742.png'
	,'126844883751.png','126844883763.png','126844883774.png','126844883782.png'
	,'126844883796.png','126844883808.png','126844883816.png','126844883824.png'
	,'126844883833.png','126844883839.png','126844883845.png','126844900586.png'
	,'126844900597.png','126844900605.png','126844900613.png','126844900621.png'
	,'126844900629.png','126844900637.png','126844900646.png','126844900652.png'
	,'12684490066.png','12684490067.png','126844900681.png','126844900691.png'
	,'126844900701.png','12684490071.png','126844900718.png','126844900728.png'
	,'126844900735.png','126844900744.png','126844900751.png','126844900857.png'
	,'126844900869.png','126844900881.png','126844900889.png','126844900901.png'
	,'126844900908.png','126844900917.png'}

--[[ -- 일반적인 다운로드 예제.
for k,v in ipairs(imgList) do
	network.download( 'http://ini.4men.kr/files/201003/13/'..v, "GET", function(event)
		if ( event.isError ) then
                print( "Network error - download failed" )
        elseif ( event.phase == "began" ) then
                print( "Progress Phase: began" )
        elseif ( event.phase == "ended" ) then
                print( "displaying response image file" )
                myImage = display.newImage( event.response.filename, event.response.baseDirectory, 60, 40 )
                myImage.alpha = 0
                transition.to( myImage, { alpha = 1.0 } )
        end
	end, v)
end
--]]
for k,v in ipairs(imgList) do
	op:createOperation({number = k, finish = false},function(obj)
		print('number = '..obj.number..' start..')
		network.download( 'http://ini.4men.kr/files/201003/13/'..v, "GET", function(event)
	        if ( event.phase == "ended" ) then
	        	obj.image = display.newImage( event.response.filename, event.response.baseDirectory, 0, 0 )                
	        	obj.finish = true
	        end
		end, v)
	end,
	function(obj)
		obj.image.alpha = 0
        transition.to( obj.image, { alpha = 1.0 } )
		print('number = '..obj.number..' finished..')
	end,
	function(obj)
		return obj.finish
	end)

	
end
print('operationQueue start..')
-- operationQueue를 실행시킵니다. 인자로는 모든 작업이 완료되었을때 호출된 함수를 넘겨줍니다.(optional)
op:start(function()
	print('operationQueue finished..')
end)