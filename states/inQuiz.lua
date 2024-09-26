inQuiz = {}

local state = require 'libs/stateswitcher'
local cron = require 'libs/cron'
local gVar = require 'gVar'
local animx = require 'libs/animx'
local camera = require 'libs/hump.camera'
local cardInfo = require 'cardInfo'

gVar.curState = 'inQuiz'
love.window.setTitle("inQuiz state")
local windowWidth = love.graphics.getWidth()
local windowHeight = love.graphics.getHeight()

fontTest = love.graphics.newImageFont("assets/images/fonts/font1.png",' ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',-10)
cancelSound = love.audio.newSource('assets/sounds/cancelMenu.ogg','static')

seaBgText = love.graphics.newImage('assets/images/inQuiz/seaBgText.png')
blackBars = love.graphics.newImage('assets/images/inQuiz/blackBars.png')
cardTest = animx.newActor('assets/images/inQuiz/cardGrey.png'):switch('cardIdle'):loopAll()
cardHB = love.graphics.newImage('assets/images/inQuiz/cardHB.png')

local curTime = gVar.bgMusicCurTime
local curBeat = 0
local lastBeat = 0

local text1X = 0
local text2X = 0

local mouseX=love.mouse.getX()
local mouseY=love.mouse.getY()

local mouseCardX,mouseCardY=0,0

local camGameX = 0--windowWidth/2
local camGameY = 0--windowHeight/2

local camGame = camera(camGameX,camGameY,0.5)

function love.keypressed(key)
    if gVar.curState == 'inQuiz' then
        if key == 'escape' then
            cronBack = cron.after(2, function() state.switch('states/mainMenu') end)
            cancelSound:play()
        end
        testString = key
        
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

cards = {}

cardInfo:initInfo(cardTest:getWidth(),cardTest:getHeight(),marginL,marginU,marginR,marginD,cardTestS)

function drawCards()
    for i=1,#cardInfo.X do
        cardTest:draw(cardInfo.X[i]-cardInfo.Tx[i],cardInfo.Y[i]-cardInfo.Ty[i],cardTestR,cardInfo.S[i],cardInfo.S[i])
        i=i+1
    end
end

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
-- cards stuff end

--[[ function cardHoverEffect()
    local tempX = marginL
    local tempY = marginU
    if mouseCardX > cardTestX and mouseCardX < cardTestX + cardTest:getWidth() and mouseCardY > cardTestY and mouseCardY < cardTestY + cardTest:getHeight() then
        cardTestS = lerp(cardTestS,1.1,0.1)
        --cardTestX = lerp(cardTestX,tempX-cardTestW*1.1,0.1)
        --cardTestY = lerp(cardTestY,tempY-cardTestH*1.1,0.1)
    else
        cardTestS = lerp(cardTestS,1,0.1)
        --cardTestX = lerp(cardTestX,tempX,0.1)
        --cardTestY = lerp(cardTestY,tempY,0.1)
    end
end ]]



function love.load()
    
end

function love.draw()
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
    --cardTest:draw(cardTestX,cardTestY,cardTestR,cardTestS,cardTestS)
    drawCards()

    --[[ for i=1,#cardInfo.X do
        love.graphics.rectangle('line',cardInfo:getPos(i))
    end ]]

    camGame:detach()
    love.graphics.draw(blackBars,-50,-64)
    logoBumpin2:draw(windowWidth/2-(logoBumpin2:getWidth()*0.35/2),0,0,0.35,0.35)
    love.graphics.print("FPS: ".. love.timer.getFPS(),0,0)
    love.graphics.print("curBeat|lastBeat: ".. curBeat..'|'..lastBeat,0,20)
    love.graphics.print("curTime: ".. curTime,0,40)
    love.graphics.print("mousePosX|mousePosY: ".. mouseCardX..' | '..mouseCardY,0,60)
    love.graphics.print("cardInfo.S[2]: ".. cardInfo.W[2],0,80)
    
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
    camGame:lookAt(camGameX,camGameY)

    cardHoverEffect()

    lastBeat = curBeat
end

return inQuiz
