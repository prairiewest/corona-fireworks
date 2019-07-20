--
-- Fireworks effect demo
--
-- Copyright 2019 Todd Trann
-- 
-- https://github.com/prairiewest/corona-fireworks
--

display.setStatusBar( display.HiddenStatusBar )

local composer = require("composer")
composer.recycleOnSceneChange = true

local bgColour = {0.2,0.2,0.2}
display.setDefault("background", bgColour)

composer.gotoScene("fireworks", { effect = nil, time = 200 } )