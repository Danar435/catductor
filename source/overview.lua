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
local goalIcon = gfx.image.new("images/overview/goal-icon")
local clockIcon = gfx.image.new("images/overview/clock-icon")

function TripOverview.reset()

    trainPos = lineXpos

end

function TripOverview.draw()

    local multiplier = Level.current().distance / lineLength
    local obstaclePos = lineXpos

    -- Line
    gfx.setColor(gfx.kColorBlack)

    gfx.drawLine(lineXpos, lineYpos+7, lineXpos + lineLength, lineYpos+7)
    gfx.drawLine(lineXpos, lineYpos+9, lineXpos + lineLength, lineYpos+9)

    -- Obstacles
    for i, obstacleDistance in ipairs(Level.current().obstacles) do
        obstaclePos += obstacleDistance / multiplier

        -- Set last obstacle as goal instead
        if i == #Level.current().obstacles then

            goalIcon:draw(obstaclePos - goalIcon.width / 2, lineYpos - goalIcon.height / 2)
            
        -- Only draw alive mice
        elseif (i >= Obstacle.getNextID()) then

            mouseIcon:draw(obstaclePos - mouseIcon.width / 2, lineYpos - mouseIcon.height / 2)

        end
    end

    -- Train
    trainPos += (Train.getSpeed() / multiplier) / 100
    --gfx.fillCircleInRect(trainPos, 5, 10, 10)
    catIcon:draw(trainPos - catIcon.width / 2, lineYpos - catIcon.height / 2)
end

function TripOverview.getMouseIcon()
    return mouseIcon
end

function TripOverview.getClockIcon()
    return clockIcon
end