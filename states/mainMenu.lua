mainMenu = {}

local state = require 'libs/stateswitcher'
local animx = require 'libs/animx'
local gVar = require 'gVar'
local cron = require 'libs/cron'

gVar.curState = 'mainMenu'
love.window.setTitle("mainMenu state")


stinger = love.graphics.newImage("assets/images/mainMenu/stinger.png")

--[[ startn = animx.newAnimation('assets/images/mainMenu/startN.png'):loop()
startn:start()
starts = animx.newAnimation('assets/images/mainMenu/startS.png'):loop()
starts:start() ]]
menu1n = animx.newAnimation('assets/images/mainMenu/menu1N.png'):loop()
menu1n:start()
menu1s = animx.newAnimation('assets/images/mainMenu/menu1S.png'):loop()
menu1s:start()
menu2n = animx.newAnimation('assets/images/mainMenu/menu2N.png'):loop()
menu2n:start()
menu2s = animx.newAnimation('assets/images/mainMenu/menu2S.png'):loop()
menu2s:start()

startG = animx.newActor('assets/images/mainMenu/startTest.png'):switch('startN')
startG:loopAll()

cancelSound = love.audio.newSource('assets/sounds/cancelMenu.ogg','static')
confirmSound = love.audio.newSource("assets/sounds/confirmMenu.ogg","static")
scrollSound = love.audio.newSource("assets/sounds/scrollMenu.ogg","static")

curSelect = 1
local confirmSelect = false

function love.load()

end

function love.keypressed(key)
    if gVar.curState == 'mainMenu' then
        if key == 'escape' then
            cronBack = cron.after(2, function() state.switch('states/titleScreen') end)
            cancelSound:play()
        elseif key == 'down' and not confirmSelect then
            curSelect = curSelect + 1
            scrollSound:stop()
            scrollSound:play()
        elseif key == 'up' and not confirmSelect then
            curSelect = curSelect - 1
            scrollSound:stop()
            scrollSound:play()
        elseif key == 'return' then
            if curSelect == 1 then
                confirmSelect = true
                confirmSound:play()
                cronConfirm = cron.after(2, function() state.switch('states/inQuiz') end)
            end
        end
    end
end

function love.update(dt)
    --if gVar.curState == 'mainMenu' then
        animx.update(dt)
        if curSelect > 3 then
            curSelect = 1
        elseif curSelect < 1 then
            curSelect = 3
        end
        if cronBack then cronBack:update(dt) end
        if cronConfirm then cronConfirm:update(dt) end
    --end
end

function love.draw()
    love.graphics.setBackgroundColor(love.math.colorFromBytes(231,157,39))
    love.graphics.draw(stinger,665,-30)
    if curSelect == 1 and confirmSelect then
        startG:switch('startF')
        startG:draw(761,141)
    elseif curSelect == 1 then
        startG:switch('startS')
        startG:draw(761,141)
    else
        startG:switch('startN')
        startG:draw(784,155)
    end
    if curSelect == 2 then
        menu1s:draw(834,330)
    else
        menu1n:draw(863,357)
    end
    if curSelect == 3 then
        menu2s:draw(830,495)
    else
        menu2n:draw(854,517)
    end

    love.graphics.print("curSelect: ".. curSelect,0,20)
    love.graphics.print("FPS: ".. love.timer.getFPS(),0,0)
end

return mainMenu