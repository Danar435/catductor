import "CoreLibs/graphics"

local pd = playdate
local gfx = pd.graphics

Menu = {}

local lvl = 1

function Menu.levelSelect()
    
    -- Logic
    if pd.buttonJustPressed(pd.kButtonLeft) then
        lvl -= 1
    end
    if pd.buttonJustPressed(pd.kButtonRight) then
        lvl += 1
    end
    if pd.buttonJustPressed(pd.kButtonA) then
        Level.setLevel(lvl)
    end

    lvl = ((lvl - 1) % #Level) + 1

    -- Drawing
    gfx.drawTextAligned(
            string.format("Level %d", lvl),
            200,
            205,
            kTextAlignment.center
        )

    -- More information but it looks a bit ugly :(
    --[[
    gfx.drawTextAligned(
            string.format("Distnace: %d km.", Level[Lvl].distance),
            10,
            195,
            kTextAlignment.left
        )
    gfx.drawTextAligned(
            string.format("Time: %d sec.", Level[Lvl].time),
            10,
            215,
            kTextAlignment.left
        )

    gfx.drawTextAligned(
            string.format("Record: %d sec.", Level[Lvl].distance),
            390,
            195,
            kTextAlignment.right
        )
    gfx.drawTextAligned(
            string.format("Misses: %d mice", Level[Lvl].time),
            390,
            215,
            kTextAlignment.right
        )
    ]]
    
end
