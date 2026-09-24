import "CoreLibs/graphics"

local pd = playdate
local gfx = pd.graphics

Ui = {}

local lvl = 1

function Ui.levelSelect()

    -- Logic
    if pd.buttonJustPressed(pd.kButtonLeft) then
        lvl -= 1
    end
    if pd.buttonJustPressed(pd.kButtonRight) then
        lvl += 1
    end
    if pd.buttonJustPressed(pd.kButtonA) then
        Level.setLevel(lvl)
        return true
    end

    lvl = ((lvl - 1) % #Level) + 1

    -- Drawing

    gfx.setImageDrawMode(gfx.kDrawModeFillWhite)

    gfx.drawTextAligned(
            string.format("Level %d", lvl),
            200,
            205,
            kTextAlignment.center
        )

    gfx.drawTextAligned(
            string.format("%d km %d sec", Level[lvl].distance, Level[lvl].time),
            10,
            205,
            kTextAlignment.left
        )

    gfx.drawTextAligned(
            string.format("Best: %d sec", 10),
            390,
            205,
            kTextAlignment.right
        )
        
    gfx.setImageDrawMode(gfx.kDrawModeCopy)

    return false
end

function Ui.inGame()

    if Obstacle.getDistance() > 0 or Obstacle.isGoal() then

        TripOverview.getClockIcon():draw(10, 195)
        TripOverview.getMouseIcon():draw(358, 195)

        gfx.setImageDrawMode(gfx.kDrawModeFillWhite)

        gfx.drawTextAligned(
            string.format("%.1f sec", timeRemaining),
            48,
            205,
            kTextAlignment.left
        )

        gfx.drawTextAligned(
            "Speed: " .. string.format("%.1f", Train.getSpeed()),
            200,
            205,
            kTextAlignment.center
        )

        gfx.drawTextAligned(
            string.format("%d m", Obstacle.getDistance()),
            352,
            205,
            kTextAlignment.right
        )

        gfx.setImageDrawMode(gfx.kDrawModeCopy)

    else

        ComboSystem.draw()

    end
end
