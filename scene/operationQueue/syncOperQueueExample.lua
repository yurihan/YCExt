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

	-- 작업 생성
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