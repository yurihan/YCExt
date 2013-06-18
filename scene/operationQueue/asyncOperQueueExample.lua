----------------------------------------------------------------------------------
--
-- scenetemplate.lua
--
----------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
-- include Corona's "widget" library
local widget = require "widget"

--------------------------------------------

-- forward declarations and other locals
local backBtn
----------------------------------------------------------------------------------
-- 
--	NOTE:
--	
--	Code outside of listener functions (below) will only be executed once,
--	unless storyboard.removeScene() is called.
-- 
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view
	backBtn = widget.newButton{
		label="Back",
		labelColor = { default={255}, over={128} },
		defaultFile="image/button.png",
		overFile="image/button-over.png",
		width=154, height=40,
		onRelease = function()	
			storyboard.gotoScene( "scene.menu", "fade", 500 )	
			return true
		end
	}
	backBtn:setReferencePoint( display.CenterReferencePoint )
	backBtn.x = display.contentWidth*0.5
	backBtn.y = display.contentHeight - 50

	group:insert( backBtn )
	
end

local op

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
		
	--	INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
	-----------------------------------------------------------------------------



	local operationQueue = require'lib.operationQueue'
	op = operationQueue:new()

	-- 최대 동시 실행 갯수.
	op.maxConcurrentCount = 3

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

	-- 작업 생성
	for k,v in ipairs(imgList) do
		-- createOperation 함수를 호출하면 자동으로 operationQueue에 등록됩니다.
		-- function OperationQueue:createOperation(obj,run,cbFinished,isFinished) 
		-- 함께 넘겨줄 object., 작업할 함수, 종료시 호출될 함수(optional), 비동기 분할처리를 위한 종료조건 판별 함수(optional)
		op:createOperation({number = k, finish = false,op = op},function(obj)
			print('number = '..obj.number..' start..')
			network.download( 'http://ini.4men.kr/files/201003/13/'..v, "GET", function(event)
				if ( event.phase == "ended" ) then					
					obj.image = display.newImage( event.response.filename, event.response.baseDirectory, 0, 0 )
					group:insert(obj.image)
					obj.finish = true
				end
			end, v)
		end,
		function(obj)
			if(obj.op.status == "stop") then
				return
			end			
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
	
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	op:stop()
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
	
	-----------------------------------------------------------------------------
	
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	local group = self.view
	
	if backBtn then
		backBtn:removeSelf()	-- widgets must be manually removed
		backBtn = nil
	end	
end


---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------

return scene