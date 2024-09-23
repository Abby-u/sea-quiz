timer = {}

local startTime,targetTime
local curTime = 0

local yesorno = false

function timer.wait(num)
    startTime = curTime
    targetTime = num + curTime
    return yesorno
end

function love.update(dt)
    curTime = curTime + dt
    if curTime >= targetTime then
        yesorno = true
    end
end

return timer