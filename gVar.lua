local love = require 'love'

gVar = {
    curState = 'main',
    titleSkip = false,
    bgMusicCurTime = 0
    


}

function love.update(dt)
    curTime = curTime + dt
    gVar[3] = curTime
end

return gVar