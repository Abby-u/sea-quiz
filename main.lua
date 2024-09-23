local state = require 'libs/stateswitcher'
local gVar = require 'gVar'

love.window.setMode(1280,720)
love.window.setTitle("main state")

state.switch("states/titleScreen")