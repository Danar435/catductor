import "CoreLibs/graphics"
import "CoreLibs/sprites"

import "background"
import "train"
import "obstacle"
import "combo"
import "level1"

local pd = playdate
local gfx = pd.graphics

Background.init()

local gameStarted = false


local function startGame()

    gameStarted = true

    Train.reset()
    Obstacle.reset()
    ComboSystem.resetGame()

end



function pd.update()

    gfx.sprite.update()

    -- START SCREEN
    if not gameStarted then

        gfx.drawTextAligned(
            "Press A to Start",
            200,
            40,
            kTextAlignment.center
        )

        if pd.buttonJustPressed(pd.kButtonA) then
            startGame()
        end

        return
    end

    Train.update()
    Background.update()
    Obstacle.update()

    if ComboSystem.update() then

        Obstacle.destroy()
        ComboSystem.startWall()

    end


    -- COLLISION
    if Obstacle.checkCollision(Train.getSprite()) then

        Train.penalize()
        Obstacle.destroy()
        ComboSystem.failWall()

    end


    -- UI
    gfx.drawTextAligned(
        "Speed: " .. string.format("%.1f", Train.getSpeed()),
        10,
        10,
        kTextAlignment.left
    )

    gfx.drawText(
        "Walls: " .. ComboSystem.getWallsCleared(),
        10,
        30
    )

    ComboSystem.draw()

end