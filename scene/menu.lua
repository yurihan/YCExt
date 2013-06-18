-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require "widget"

--------------------------------------------

-- forward declarations and other locals
local asyncOperQueueBtn
local syncOperQueueBtn

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	-- display a background image
	local background = display.newImageRect( "image/background.jpg", display.contentWidth, display.contentHeight )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0	

	syncOperQueueBtn = widget.newButton{
		label="Sync OperQueue",
		labelColor = { default={255}, over={128} },
		defaultFile="image/button.png",
		overFile="image/button-over.png",
		width=210, height=40,
		onRelease = function()	
    		storyboard.gotoScene( "scene.operationQueue.syncOperQueueExample", "fade", 500 )	
			return true
		end
	}	
	syncOperQueueBtn:setReferencePoint( display.CenterReferencePoint )	
	syncOperQueueBtn.x = display.contentWidth*0.5	
	syncOperQueueBtn.y = display.contentHeight - 250

-- create a widget button (which will loads level1.lua on release)
	asyncOperQueueBtn = widget.newButton{
		label="Async OperQueue",
		labelColor = { default={255}, over={128} },
		defaultFile="image/button.png",
		overFile="image/button-over.png",
		width=210, height=40,
		onRelease = function()	
    		storyboard.gotoScene( "scene.operationQueue.asyncOperQueueExample", "fade", 500 )	
			return true
		end
	}
	asyncOperQueueBtn:setReferencePoint( display.CenterReferencePoint )
	asyncOperQueueBtn.x = display.contentWidth*0.5
	asyncOperQueueBtn.y = display.contentHeight - 200
	
	-- all display objects must be inserted into group
	group:insert( background )
	group:insert( asyncOperQueueBtn )
	group:insert( syncOperQueueBtn )
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
	if syncOperQueueBtn then
		syncOperQueueBtn:removeSelf()	-- widgets must be manually removed
		syncOperQueueBtn = nil
	end
	if asyncOperQueueBtn then
		asyncOperQueueBtn:removeSelf()	-- widgets must be manually removed
		asyncOperQueueBtn = nil
	end		
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene