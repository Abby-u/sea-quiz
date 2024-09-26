local animx = require 'libs/animx'
local gVar = require 'gVar'

cardInfo = {}
cardInfo.N = {}
cardInfo.X = {}
cardInfo.Y = {}
cardInfo.W = {}
cardInfo.H = {}
cardInfo.Q = {}
cardInfo.A = {}
cardInfo.S = {}

function cardInfo:initInfo(cW,cH,marginLeft,marginUp,spacingLeft,spacingDown,scale)
    local i = 1
    for line in love.filesystem.lines('questionPacks/qna.txt') do
        local question,answer = string.match(line, "^(.-)%|(.*)$")
        cardInfo.Q[i] = question
        cardInfo.A[i] = answer
        cardInfo.X[i] = marginLeft + (cW * (i - 1)) + (spacingLeft * (i - 1))
        cardInfo.Y[i] = marginUp --+(cH*(i-1))+(spacingDown*(i-1))
        cardInfo.W[i] = marginLeft + (cW * i) + (spacingLeft * (i-1))
        cardInfo.H[i] = cH
        cardInfo.S[i] = scale

        i = i+1
    end
end

--[[ function cardInfo:loadGraphics()
    for i=1,#cardInfo.X do
        card+i = animx.newActor('assets/images/inQuiz/cardGrey.png'):switch('cardIdle'):loopAll()
    end
end ]]

function cardInfo:getPos(i)
    return cardInfo.X[i],cardInfo.Y[i],cardInfo.W[i],cardInfo.H[i]
end

function cardInfo:getDrawData(i)
    return cardInfo.X[i],cardInfo.Y[i]
end

return cardInfo