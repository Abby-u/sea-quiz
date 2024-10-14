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
local camGameZoom = 0.1

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

local cardHUDX = 0
local cardHUDY = 0
local cardHUDS = camGameZoom

local curCard = 0

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
local cardFlipX = 0
local cardFlipY = 0
local cardFlipTransform = love.math.newTransform(cardFlipX,cardFlipY)
local cardFlipSize = {1280,720}
local cardFlipShader = love.graphics.newShader(
[[// Angle in radians.
uniform float a;

// Transform that you want the image to be drawn with.
uniform mat4 image_tf;

// Image size in pixels.
uniform vec2 image_size;

vec4 position(mat4 transform_projection, vec4 vertex_position)
{
    float xc = image_size.x / 2.0;
    float yc = image_size.y / 2.0;
    mat4 origin_mat = mat4(1.0, 0.0, 0.0, 0.0,
                           0.0, 1.0, 0.0, 0.0,
                           0.0, 0.0, 1.0, 0.0,
                           -xc, -yc, 0.0, 1.0);

    mat4 rotate_y_mat = mat4( cos(a), 0.0, sin(a), 0.0,
                                 0.0, 1.0,    0.0, 0.0,
                             -sin(a), 0.0, cos(a), 0.0,
                                 0.0, 0.0,    0.0, 1.0);

    // Setting this to -1.0 will flip the direction of rotation.
    const float ROTATION_SIGN = -1.0;

    // A factor that controls the foreshortening (the perspective effect).
    // Suggested numbers: 500.0, 1000.0, 5000.0, 10000.0 etc.
    const float FORESHORTENING = 1000.0;

    // A large number to keep Z coordinates from clipping out of the screen.
    // Try setting this to like 10.0 to see why it's needed.
    const float Z_COMPRESSION = 10000.0;

    mat4 css_projection_mat = mat4(
    1.0, 0.0, 0.0, 0.0,
    0.0, 1.0, 0.0, 0.0,
    0.0, 0.0, 1.0 / Z_COMPRESSION, ROTATION_SIGN / FORESHORTENING,
    0.0, 0.0, 0.0, 1.0);

    mat4 restore_mat = mat4(1.0);
    restore_mat[3] = vec4(xc, yc, 0.0, 1.0);

    vec4 perspective_position = restore_mat * css_projection_mat * rotate_y_mat
                                * origin_mat * vertex_position;
    return transform_projection * image_tf * perspective_position;
}]]
)

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
            --cardFlipRot = lerp(cardFlipRot,0,0.01)
        end
        i=i+1
    end
end

function moveCardHUD()
    cardFlipX = lerp(cardFlipX,-200,0.03)
    cardFlipY = lerp(cardFlipY,10,0.03)
    cardFlipTransform = love.math.newTransform(cardFlipX,cardFlipY)
end

function getCurCard()
    local j = 0
    for i=1,#cardInfo.X do
        --curCard = 0
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
    text1:addf({{1,1,1},"Test"},windowWidth,'center')
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
        
    end ]]

    camGame:detach()

    love.graphics.setShader(cardFlipShader)
    cardFlipShader:send('a', math.rad(cardFlipRot))
    cardFlipShader:send('image_tf', cardFlipTransform)
    cardFlipShader:send('image_size', cardFlipSize)
    --cardTest:draw(640-cardTest:getWidth()/4,360-cardTest:getHeight()/4,cardTestR,cardInfo.S[1]*camGameZoom,cardInfo.S[1]*camGameZoom)
    cardhud:draw(640-cardhud:getWidth()/2,360-cardhud:getHeight()/2,0,cardHUDS,cardHUDS)
    love.graphics.setColor(0,0,0)
    love.graphics.draw(text1,0,150)
    love.graphics.setColor(1,1,1)
    love.graphics.setShader()



    love.graphics.draw(blackBars,-50,-64)
    logoBumpin2:draw(windowWidth/2-(logoBumpin2:getWidth()*0.35/2),0,0,0.35,0.35)

    love.graphics.print("FPS: ".. love.timer.getFPS(),0,0)
    love.graphics.print("curBeat|lastBeat: ".. curBeat..'|'..lastBeat,0,20)
    love.graphics.print("curTime: ".. curTime,0,40)
    love.graphics.print("mousePosX|mousePosY: ".. mouseCardX..' | '..mouseCardY,0,60)
    love.graphics.print("cardInfo.S[2]: ".. cardFlipX .. " " .. cardFlipY,0,80)
    
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
    --cardFlipRot = lerp(cardFlipRot,165,0.03)
    --cardHUDS = lerp(cardHUDS,1,0.03)
    --moveCardHUD()


    --[[ if cardFlipRot > 180 then
        cardFlipRot = 0
    else
        cardFlipRot = cardFlipRot + dt
    end ]]

    lastBeat = curBeat
end

function love.mousepressed(x, y, button, isTouch)
    if button == 1 then
        curCard = getCurCard()
        if curCard == 0 then 
        else
        --cardFlipX,cardFlipY = camGame:cameraCoords(cardInfo.X[curCard],cardInfo.Y[curCard])
        cardFlipX,cardFlipY = camGame:cameraCoords(cardInfo:getMiddle(curCard))
        --cardFlipTransform = love.math.newTransform(cardFlipX-cardhud:getWidth()/2*camGameZoom,cardFlipY-cardhud:getHeight()/2*camGameZoom)
        cardFlipTransform = love.math.newTransform(cardFlipX*camGameZoom,cardFlipY*camGameZoom)
        cardFlipRot = 0
        cardHUDS = camGameZoom
        end
    end
end

return inQuiz
