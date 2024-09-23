titleScreen = {}

local state = require 'libs/stateswitcher'
local tween = require 'libs/tween'
local animx = require 'libs/animx'
local animtest = require 'libs/animtest'
local transitions = require 'libs/transitions'
local gVar = require 'gVar'
local camera = require 'libs/hump.camera'

gVar.curState = 'titleScreen'
skipIntro = gVar.titleSkip

love.window.setTitle("titleScreen state")

local curTime = gVar.bgMusicCurTime
local onPause = false
local curBeat = 0
local lastBeat = 0
local windowWidth = love.graphics.getWidth()
local windowHeight = love.graphics.getHeight()

flashA = {1}
flashTween = tween.new(1,flashA,{0})
flashFinish = false

zoom = {1.05}
camGame = camera(windowWidth/2,windowHeight/2,zoom[1])
zoomTween = tween.new(1.5,zoom,{1},'outExpo')

local confirmed = false
local confirmTimer = 0
local confirmTimerTarget = 2

local beatMul = 2

love.graphics.setBackgroundColor(0,0,0)

function love.load()
    
    --curTime = 0
    curBeat = 0
    lastBeat = 0
    --cover = love.graphics.rectangle('fill',0,0,windowWidth,windowHeight)
    fnf = love.graphics.newFont('assets/fonts/fnf-regular.otf',96)
    text1 = love.graphics.newText(fnf)
    text1:addf({{1,1,1},""},windowWidth,'center')

    confirmSound = love.audio.newSource("assets/sounds/confirmMenu.ogg","static")

    bgMusic = love.audio.newSource("assets/musics/girlfriendsRingtone.ogg","stream")
    bgMusicBPM = 160
    bgMusic:setVolume(0)
    bgMusic:setLooping(true)
    bgMusicVolume = {0}
    bgMusicTweenVolume = tween.new(4, bgMusicVolume, {1})
    --logoBumpinImg = love.graphics.newImage()
    --logoBumpinQuad = animx.newAnimationXML('assets/images/logoBumpin')
    logoBumpin = animx.newAnimation('assets/images/logoBumpin.png')
    bgMusic:play()
end

function onBeatHit(num)
    if curBeat == num then
        return true
    end
end

function onEveryBeat()
    if curBeat > lastBeat then
        return true
    end
end

function onEveryBeatNum()
    if curBeat > lastBeat then
        return curBeat
    else
        return 0
    end
end

function love.update(dt)
    curTime = curTime + dt
    --if currentState == 'titleScreen' then
    animx.update(dt)
    bgMusicTweenVolume:update(dt)
    zoomTween:update(dt)
    camGame:zoomTo(zoom[1])
    if skipIntro then
        flashTween:update(dt)
    end
    if curTime < 4 then
        bgMusic:setVolume(bgMusicVolume[1])
    end
    if 0 <= curTime % (60/bgMusicBPM) and curTime % (60/bgMusicBPM) < dt then
        curBeat = curBeat + 1
    end
    if onEveryBeat() then logoBumpin:start() end
    
    if onBeatHit(16*beatMul) then skipIntro = true end

    if confirmed then
        confirmTimer = confirmTimer + dt 
        if confirmTimer >= confirmTimerTarget then
            state.switch('states/mainMenu')
            currentState = 'mainMenu'
        end
    end
    if onEveryBeatNum() % 2 == 1 then zoomTween:reset() end

    lastBeat = curBeat
end

function love.draw()
    --if currentState == 'titleScreen' then
    --if curBeat > 15 or skipIntro then
        logoBumpin:draw(305,134)
    --end
        love.graphics.setColor(1,1,1,flashA[0001])
        love.graphics.rectangle('fill',0,0,windowWidth,windowHeight)

    -- intro layer
    camGame:attach()
    if curBeat < 16*beatMul and not skipIntro then
        love.graphics.setColor(0,0,0)
        love.graphics.rectangle('fill',0,0,windowWidth,windowHeight)
        
        love.graphics.setColor(1,1,1)
        love.graphics.draw(text1,0,150)
        if onBeatHit(1) then text1:setf("ALDORA",windowWidth,'center')
        elseif onBeatHit(3) then text1:setf("ALDORA\nPRESENT",windowWidth,'center')
        elseif onBeatHit(4) then text1:setf("",windowWidth,'center')
        elseif onBeatHit(5) then text1:setf("IN ASSOCIATION\nWITH",windowWidth,'center')
        elseif onBeatHit(7) then text1:setf("IN ASSOCIATION\nWITH\n\nIDK",windowWidth,'center') --bgMusic:setVolume(0)
        elseif onBeatHit(8) then text1:setf("",windowWidth,'center') --bgMusic:setVolume(1)
        elseif onBeatHit(9) then text1:setf("TOP TEXT",windowWidth,'center')
        elseif onBeatHit(11) then text1:setf("TOP TEXT\nBOTTOM TEXT",windowWidth,'center')
        elseif onBeatHit(12) then text1:setf("",windowWidth,'center')
        elseif onBeatHit(13) then text1:setf("DUDE",windowWidth,'center')
        elseif onBeatHit(15) then text1:setf("DUDE\nHELL NAH",windowWidth,'center')
        elseif onBeatHit(16) then text1:setf("",windowWidth,'center')
        elseif onBeatHit(17) then text1:setf("WTF",windowWidth,'center')
        elseif onBeatHit(19) then text1:setf("WTF\nIS THIS INTRO",windowWidth,'center')
        elseif onBeatHit(20) then text1:setf("",windowWidth,'center')
        elseif onBeatHit(21) then text1:setf("SKULL",windowWidth,'center')
        elseif onBeatHit(23) then text1:setf("SKULL\nSOB",windowWidth,'center')
        elseif onBeatHit(24) then text1:setf("",windowWidth,'center')
        elseif onBeatHit(25) then text1:setf("ELSEIF ONBEATHIT(25) THEN TEXT1:SETF('TEXT',WINDOWWIDTH,'CENTER')",windowWidth,'center')
        elseif onBeatHit(27) then text1:setf("ELSEIF ONBEATHIT(25) THEN TEXT1:SETF('TEXT',WINDOWWIDTH,'CENTER')\nWRONG COPY PASTE",windowWidth,'center')
        elseif onBeatHit(28) then text1:setf("",windowWidth,'center')
        elseif onBeatHit(29) then text1:setf("SUPERIOR",windowWidth,'center')
        elseif onBeatHit(30) then text1:setf("SUPERIOR\nENGLISH",windowWidth,'center')
        elseif onBeatHit(31) then text1:setf("SUPERIOR\nENGLISH\nANSWER",windowWidth,'center')
        elseif onBeatHit(32) then text1:clear()
        end
    end
    camGame:detach()
    

    -- debug layer
    love.graphics.setColor(1,1,1)
    love.graphics.print("curBeat|lastBeat: ".. curBeat..'|'..lastBeat,0,20)
    love.graphics.print("curTime: ".. curTime,0,40)
    --love.graphics.print("confirmed: ".. tostring(confirmed),0,60)
    
    --end
    love.graphics.print("FPS: ".. love.timer.getFPS(),0,0)
end

function love.keypressed(key, scancode , isrepeat)
    if gVar.curState == "titleScreen" then
    if key == 'return' then
        if skipIntro then
            confirmSound:play()
            confirmed = true
            flashTween:reset()
            --transitions.transTo('states/mainMenu;mainMenu')
        end
        skipIntro = true
        gVar.titleSkip = true
        bgMusic:setVolume(1)
    end
    end
end

return titleScreen