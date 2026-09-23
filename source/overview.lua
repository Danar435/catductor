import "CoreLibs/graphics"

local pd <const> = playdate
local gfx <const> = pd.graphics

TripOverview = {}

local lineLength = 350
local lineYpos = 15
local lineXpos = (400 - lineLength)/2
local trainPos = lineXpos

local catIcon = gfx.image.new("images/overview/cat-icon")
local mouseIcon = gfx.image.new("images/overview/mouse-icon")

function TripOverview.reset()

    trainPos = lineXpos

end

function TripOverview.draw()

    local multiplier = Level1.distance / lineLength
    local obstaclePos = lineXpos

    -- Line
    gfx.drawLine(lineXpos, lineYpos+7, lineXpos + lineLength, lineYpos+7)
    gfx.drawLine(lineXpos, lineYpos+9, lineXpos + lineLength, lineYpos+9)

    -- Obstacles
    for i, obstacleDistance in ipairs(Level1.obstacles) do
        obstaclePos += obstacleDistance / multiplier

        if (i >= Obstacle.getNextID()) then

            --gfx.drawLine(obstaclePos, 3, obstaclePos, 16)
            mouseIcon:draw(obstaclePos - mouseIcon.width / 2, lineYpos - mouseIcon.height / 2)
        
        end
    end

    -- Train
    trainPos += (Train.getSpeed() / multiplier) / 100
    --gfx.fillCircleInRect(trainPos, 5, 10, 10)
    catIcon:draw(trainPos - catIcon.width / 2, lineYpos - catIcon.height / 2)
end

