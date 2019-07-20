--
-- Fireworks effect demo
--
-- Copyright 2019 Todd Trann
-- 
-- https://github.com/prairiewest/corona-fireworks
--

local composer = require("composer")
local scene = composer.newScene()
local json = require("json")
local mRand = math.random

local _W = display.contentWidth
local _H = display.contentHeight
local emitterXmin = _W*0.2
local emitterXmax = _W*0.8
local emitterYmin = _H*0.2
local emitterYmax = _H*0.8

local emitterTimer
local lastEmitter = 3
local background, backImage
local screenGroup, backgroundGroup, emitterGroup, overGroup
local emitters = {}
local fireEmitter, emitterLoop
local font1 = "Galindo-Regular"
local bgColour = {0.2,0.2,0.2}

-- Show the popup
showOverlay = function()
    local popup1 = display.newImageRect(overGroup, "images/popup1.png", 600, 760 )
    popup1.x, popup1.y = _W*0.5, _H*0.5

    local gameoverSplash = display.newImageRect(overGroup, "images/elk.png", 200, 200 )
    gameoverSplash.x, gameoverSplash.y = popup1.x, popup1.y - 80
    
    local text_title = display.newText({parent=overGroup, text="Fireworks Demo", x=0, y=0, font=font1, fontSize=42})
    text_title.x = popup1.x
    text_title.y = popup1.y - 268
    text_title:setFillColor(1)

    local message = "Effects using three different emitters and random colors"
    local text1 = display.newText({parent=overGroup, text=message, x=0, y=0, font=font1, fontSize=42, width=400, align="center"})
    text1.x = popup1.x
    text1.y = popup1.y + 175
    text1:setFillColor(0)

    transition.to(overGroup, {time=250, y=0, transition=easing.outQuad})
end

-- Create a new emitter with random colors
fireEmitter = function(emitNum,x,y)
    local dominantColor = mRand(1,3)
    if dominantColor == 1 then
        emitters[emitNum]["startColorRed"] = mRand(60,100)/100
        emitters[emitNum]["startColorBlue"] = mRand(20,50)/100
        emitters[emitNum]["startColorGreen"] = mRand(20,50)/100
    elseif dominantColor == 2 then
        emitters[emitNum]["startColorRed"] = mRand(20,50)/100
        emitters[emitNum]["startColorBlue"] = mRand(60,100)/100
        emitters[emitNum]["startColorGreen"] = mRand(20,50)/100
    else
        emitters[emitNum]["startColorRed"] = mRand(60,100)/100
        emitters[emitNum]["startColorBlue"] = mRand(20,50)/100
        emitters[emitNum]["startColorGreen"] = mRand(60,100)/100
    end
    local emitter = display.newEmitter( emitters[emitNum] )
    emitter.x = x
    emitter.y = y
    emitterGroup:insert(emitter)
end

-- This loop calls iteself repeatedly to spawn new emitters
emitterLoop = function()
    local ex = mRand(emitterXmin, emitterXmax)
    local ey = mRand(emitterYmin, emitterYmax)
    local emitNum = mRand(1,lastEmitter)
    fireEmitter(emitNum,ex,ey)
    local nextTimer = mRand(300,1600)
    emitterTimer = timer.performWithDelay(nextTimer, emitterLoop)
end

function scene:create( event )
	screenGroup = self.view

    -- The various display groups used to layer objects
	backgroundGroup = display.newGroup()
	screenGroup:insert(backgroundGroup)
    overGroup = display.newGroup()
    screenGroup:insert(overGroup)
    emitterGroup = display.newGroup()
    screenGroup:insert(emitterGroup)
    
    -- Background
    background = display.newRect(backgroundGroup,_W*0.5,_H*0.5,_W,_H)
    background:setFillColor(unpack(bgColour))
    backImage = display.newImageRect(backgroundGroup,"images/background.jpg",640,1400)
    backImage.x = _W / 2
    backImage.y = _H / 2

    -- Read all emitters
    local i
    for i = 1, lastEmitter do
        local filePath = system.pathForFile( "emitters/" .. i ..".json" )
        local f = io.open( filePath, "r" )
        local emitterData = f:read( "*a" )
        f:close()
        emitters[i] = json.decode( emitterData )
    end
end

function scene:show( event )
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        showOverlay()
        emitterLoop()
    end
end


function scene:hide( event )
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen).
        if emitterTimer ~= nil then
            timer.cancel(emitterTimer)
        end
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
    end
end

function scene:destroy( event )
    -- Called prior to the removal of scene's view
end

-- Add the listeners
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene

