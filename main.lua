-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )
system.activate("multitouch")

-- include the Corona "storyboard" module
local storyboard = require "storyboard"
storyboard.purgeOnSceneChange = true

-- load menu screen
storyboard.gotoScene( "scene.menu" )
