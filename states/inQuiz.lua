inQuiz = {}

local state = require 'libs/stateswitcher'
local cron = require 'libs/cron'
local gVar = require 'gVar'
local animx = require 'libs/animx'
local camera = require 'libs/hump.camera'
local cardInfo = require 'cardInfo'
local cardShader = love.filesystem.read('cardflipshader.txt')
--local blurshader = love.graphics.newShader(love.filesystem.read('blurshader.txt'))

gVar.curState = 'inQuiz'
love.window.setTitle("inQuiz state")
local windowWidth = love.graphics.getWidth()
local windowHeight = love.graphics.getHeight()

fontTest = love.graphics.newImageFont("assets/images/fonts/font1.png",' ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',-10)
cancelSound = love.audio.newSource('assets/sounds/cancelMenu.ogg','static')

seaBgText = love.graphics.newImage('assets/images/inQuiz/seaBgText.png')
blackBars = love.graphics.newImage('assets/images/inQuiz/blackBars.png')
cardTest = animx.newActor('assets/images/inQuiz/cardGrey.png'):switch('cardIdle'):loopAll()
cardhud = animx.newActor('assets/images/inQuiz/cardGrey.png'):switch('cardIdle'):loopAll()
cardHB = love.graphics.newImage('assets/images/inQuiz/cardHB.png')

local curTime = gVar.bgMusicCurTime
local curBeat = 0
local lastBeat = 0

local text1X = 0
local text2X = 0

local mouseX = love.mouse.getX()
local mouseY = love.mouse.getY()

local mouseCardX,mouseCardY=0,0

local camGameX = 0--windowWidth/2
local camGameY = 0--windowHeight/2
local camGameZoom = 0.5

local camGame = camera(camGameX,camGameY,camGameZoom)

function love.keypressed(key)
    if gVar.curState == 'inQuiz' then
        if key == 'escape' then
            cronBack = cron.after(2, function() state.switch('states/mainMenu') end)
            cancelSound:play()
        end
    end
end

local function lerp(a,b,t)
    return (1-t)*a + t*b
end

function onEveryBeat()
    if curBeat > lastBeat then
        return true
    end
end

bgMusicBPM = 113.850
logoBumpin2 = animx.newAnimation('assets/images/logoBumpin.png')

-- cards stuff pls dont give me errors

local marginL = 20
local marginR = 20
local marginU = 80
local marginD = 20

local cardTestX = marginL
local cardTestY = marginU
local cardTestW = cardTest:getWidth()*0.5
local cardTestH = cardTest:getHeight()*0.5
local cardTestR = 0
local cardTestS = 1

local cardHUDS = 1
local cardHUDSt = 1
local cardHUDX = windowWidth/2-(cardhud:getWidth()/2*cardHUDS)
local cardHUDY = windowHeight/2-(cardhud:getHeight()/2*cardHUDS)

local curCard = 1

cards = {}

cardInfo:initInfo(cardTest:getWidth(),cardTest:getHeight(),marginL,marginU,marginR,marginD,cardTestS)

function drawCards()
    for i=1,#cardInfo.X do
        if curCard == i then
            -- dont draw
        else
            cardTest:draw(cardInfo.X[i]-cardInfo.Tx[i],cardInfo.Y[i]-cardInfo.Ty[i],cardTestR,cardInfo.S[i],cardInfo.S[i])
        end
        i=i+1
    end
end

local cardFlipRot = 0
local cardFlipRotTarget = 165
local cardFlipX = 0
local cardFlipY = 0
local cardFlipXt = 50
local cardFlipYt = 150
local cardFlipTransform = love.math.newTransform(cardFlipX,cardFlipY)
local cardFlipSize = {1280,720}
local cardFlipShader = love.graphics.newShader(cardShader)

function cardHoverEffect()
    for i=1,#cardInfo.X do
        if mouseCardX > cardInfo.X[i] and mouseCardX < cardInfo.W[i] and mouseCardY > cardInfo.Y[i] and mouseCardY < cardInfo.H[i] then
            cardInfo.S[i] = lerp(cardInfo.S[i],1.1,0.1)
            cardInfo.Tx[i] = lerp(cardInfo.Tx[i],cardTestW*0.1,0.1)
            cardInfo.Ty[i] = lerp(cardInfo.Ty[i],cardTestH*0.1,0.1)
        else
            cardInfo.S[i] = lerp(cardInfo.S[i],1,0.1)
            cardInfo.Tx[i] = lerp(cardInfo.Tx[i],0,0.1)
            cardInfo.Ty[i] = lerp(cardInfo.Ty[i],0,0.1)
        end
        i=i+1
    end
end

function updateCardFlip()
    cardHUDX = windowWidth/2-(cardhud:getWidth()/2*cardHUDS)
    cardHUDY = windowHeight/2-(cardhud:getHeight()/2*cardHUDS)
end

function moveCardHUD()
    updateCardFlip()
    cardFlipX = lerp(cardFlipX,cardFlipXt,0.03)
    cardFlipY = lerp(cardFlipY,cardFlipYt,0.03)
    cardFlipTransform = love.math.newTransform(cardFlipX-cardHUDX,cardFlipY-cardHUDY)
end

function getCurCard()
    local j = 0
    for i=1,#cardInfo.X do
        if mouseCardX > cardInfo.X[i] and mouseCardX < cardInfo.W[i] and mouseCardY > cardInfo.Y[i] and mouseCardY < cardInfo.H[i] then
            j = i
            break
        end
        i=i+1
    end
    return j
end

-- cards stuff end

function love.load()
    fnf = love.graphics.newFont('assets/fonts/fnf-regular.otf',96)
    text1 = love.graphics.newText(fnf)
    text1:addf('cardInfo.Q[curCard]',640,'center')
    textRot = 0
end

function love.draw()
    --love.graphics.setShader(blurshader)
    -- background
    love.graphics.setBackgroundColor(love.math.colorFromBytes(231,157,39))
    love.graphics.draw(seaBgText,text1X + (seaBgText:getWidth()*0) ,0)
    love.graphics.draw(seaBgText,text1X + (seaBgText:getWidth()*1) ,0)
    love.graphics.draw(seaBgText,text1X + (seaBgText:getWidth()*2) ,0)
    love.graphics.draw(seaBgText,text1X + (seaBgText:getWidth()*0) ,seaBgText:getHeight())
    love.graphics.draw(seaBgText,text1X + (seaBgText:getWidth()*1) ,seaBgText:getHeight())
    love.graphics.draw(seaBgText,text1X + (seaBgText:getWidth()*2) ,seaBgText:getHeight())

    love.graphics.draw(seaBgText,text2X + (seaBgText:getWidth()*-1) ,65)
    love.graphics.draw(seaBgText,text2X + (seaBgText:getWidth()*0) ,65)
    love.graphics.draw(seaBgText,text2X + (seaBgText:getWidth()*1) ,65)
    love.graphics.draw(seaBgText,text2X + (seaBgText:getWidth()*-1) ,65 + seaBgText:getHeight())
    love.graphics.draw(seaBgText,text2X + (seaBgText:getWidth()*0) ,65 + seaBgText:getHeight())
    love.graphics.draw(seaBgText,text2X + (seaBgText:getWidth()*1) ,65 + seaBgText:getHeight())

    -- card n stuff
    camGame:attach()
    cardTest:switch('cardIdle')
    drawCards()

    camGame:detach()

    love.graphics.setShader(cardFlipShader)
    cardFlipShader:send('a', math.rad(cardFlipRot))
    cardFlipShader:send('image_tf', cardFlipTransform)
    cardFlipShader:send('image_size', cardFlipSize)
    cardFlipShader:send('ROTATION_SIGN', -1.0)
    if curCard ~= 0 then
    cardhud:draw(cardHUDX,cardHUDY,0,cardHUDS,cardHUDS)
    end
    cardFlipShader:send('a', math.rad(cardFlipRot-180))
    cardFlipShader:send('ROTATION_SIGN', 0)
    love.graphics.setColor(0,0,0) 
    if cardFlipRot > 90 then
        if curCard ~= 0 then
    text1:setf(cardInfo.Q[curCard],640,'center')
    love.graphics.draw(text1,windowWidth/4,windowHeight/2-text1:getHeight()/2,math.rad(0),1,1,40,0)
        end
    end
    love.graphics.setColor(1,1,1)
    love.graphics.setShader()
    
    love.graphics.draw(blackBars,-50,-64)
    logoBumpin2:draw(windowWidth/2-(logoBumpin2:getWidth()*0.35/2),0,0,0.35,0.35)

    love.graphics.print("FPS: ".. love.timer.getFPS(),0,0)
    love.graphics.print("curBeat|lastBeat: ".. curBeat..'|'..lastBeat,0,20)
    love.graphics.print("curTime: ".. curTime,0,40)
    love.graphics.print("mousePosX|mousePosY: ".. mouseCardX..' | '..mouseCardY,0,60)
    love.graphics.print("cardInfo.S[2]: " .. " " .. cardFlipRot,0,80)
    
end

function love.update(dt)
    curTime = curTime + dt
    animx.update(dt)
    if cronBack then cronBack:update(dt) end
    if 0 <= curTime % (60/bgMusicBPM) and curTime % (60/bgMusicBPM) < dt then
        curBeat = curBeat + 1
    end
    if onEveryBeat() then logoBumpin2:start() end
    if text1X < -seaBgText:getWidth() then
        text1X = 0
    else
        text1X = text1X + -80*dt
    end
    if text2X > seaBgText:getWidth() then
        text2X = 0
    else
        text2X = text2X + 80*dt
    end
    mouseCardX,mouseCardY=camGame:mousePosition()
    mouseX,mouseY=love.mouse.getPosition()
    camGameX = lerp(camGameX,mouseX,0.05)
    camGameY = lerp(camGameY,mouseY,0.05)
    camGame:lookAt(camGameX+900,camGameY-200)

    cardHoverEffect()
    cardFlipRot = lerp(cardFlipRot,cardFlipRotTarget,0.03)
    cardHUDS = lerp(cardHUDS,cardHUDSt,0.03)
    moveCardHUD()

    --textRot = textRot + dt
    
    lastBeat = curBeat
end

function love.mousepressed(x, y, button, isTouch)
    if button == 1 then
        curCard = getCurCard()
        if curCard == 0 then
            cardFlipRotTarget = 0
        else
        cardFlipX,cardFlipY = camGame:cameraCoords(cardInfo:getDrawData(curCard))
        cardFlipTransform = love.math.newTransform(cardFlipX-cardHUDX,cardFlipY-cardHUDY)
        cardFlipRot = 0
        cardFlipRotTarget = 165
        cardHUDS = camGameZoom*1.1
        cardHUDSt = 1
        end
    end
end

return inQuiz
