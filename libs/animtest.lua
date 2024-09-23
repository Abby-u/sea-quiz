animtest = {}
function animtest.createQuad(filename)
    local t = {}
    local i=1
    local sw,sh,file
    img = love.graphics.newImage(filename..".png")
    sw,sh = img:getDimensions()
    for line in love.filesystem.lines(filename..".xml") do
		if i>1 and line:match('%a') and not line:match('<!') and line~="</TextureAtlas>" then
			local _, frameNo = string.match(line, "name=([\"'])(.-)%1")
			frameNo=tonumber(frameNo)
			--Frames must start from 1!
			if not frameNo or frameNo<=0 then goto continue end

			assert(not t[frameNo],
				"animtest Error!! Duplicate Frames found for ("..frameNo..") for "..filename
			)
			local _, x = string.match(line, "x=([\"'])(.-)%1")
			local _, y = string.match(line, "y=([\"'])(.-)%1")
			local _, width = string.match(line, "width=([\"'])(.-)%1")
			local _, height = string.match(line, "height=([\"'])(.-)%1")
			
			t[frameNo]=love.graphics.newQuad(x,y,width,height,sw,sh)
			::continue::
		end
		i=i+1
	end
    return t
end

return animtest
