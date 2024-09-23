transitions = {}

local state = require "libs/stateswitcher"
local cron = require 'libs/cron'

local stateL
local curTime
local check = 0

function love.update(dt)
    if stateL then
        curTime = curTime + dt
        if curTime >= 2 then
            state.switch(stateL)
            check = 1
        end
    end
end

function love.draw()
    love.graphics.print('hi',100,0)
end

function transitions.transTo(url)
    stateL = url
    curTime = 0
end

return transitions