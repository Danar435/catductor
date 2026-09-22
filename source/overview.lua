import "CoreLibs/graphics"

local pd <const> = playdate
local gfx <const> = pd.graphics

TripOverview = {}

local lineLength = 350
local lineYpos = 10
local lineXpos = (400 - lineLength)/2
local trainPos = lineXpos

function TripOverview.draw()

    local multiplier = Level1.distance / lineLength
    local obstaclePos = lineXpos

    -- Line
    gfx.drawLine(lineXpos, lineYpos, lineXpos + lineLength, lineYpos)

    -- Train
    trainPos += (Train.getSpeed() / multiplier) / 100
    gfx.fillCircleInRect(trainPos, 5, 10, 10)

    -- Obstacles
    for i, obstacleDistance in ipairs(Level1.obstacles) do
        obstaclePos += obstacleDistance / multiplier

        if (i >= Obstacle.getNextID()) then

            gfx.drawLine(obstaclePos, 3, obstaclePos, 16)
        
        end
    end
end

