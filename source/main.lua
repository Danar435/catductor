import "CoreLibs/graphics"
import "CoreLibs/sprites"

import "background"
import "train"
import "obstacle"
import "combo"
import "level1"
import "overview"

local pd = playdate
local gfx = pd.graphics

Background.init()

local gameStarted = false

local function startGame()

    gameStarted = true

    Train.reset()
    Obstacle.reset()
    -- Level 1 uses D-pad combos
    ComboSystem.setLevel(1)
    ComboSystem.resetGame()
    TripOverview.reset()

end

function pd.update()

    gfx.sprite.update()

    -- START SCREEN
    if not gameStarted then

        gfx.drawTextAligned(
            "Press A to Start",
            200,
            200,
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

        if Obstacle.isLevelComplete() then
            gameStarted = false
            return

        end

        ComboSystem.startWall()

    end


    -- COLLISION
    if Obstacle.checkCollision(Train.getSprite()) then

        Train.penalize()
        Obstacle.destroy()

        if Obstacle.isLevelComplete() then

        gameStarted = false
        return

        end

        ComboSystem.failWall()

    end


    -- UI

    TripOverview.draw()

    local obstacleDistance =
    Obstacle.getDistance()

    if obstacleDistance and obstacleDistance > 0 then

        gfx.drawText(
            "Walls: " .. ComboSystem.getWallsCleared(),
            10,
            200
        )
        
        gfx.drawTextAligned(
            "Speed: " .. string.format("%.1f", Train.getSpeed()),
            200,
            200,
            kTextAlignment.center
        )

        gfx.drawTextAligned(
            string.format("%d", Obstacle.getDistance()),
            390,
            200,
            kTextAlignment.right
        )

    elseif obstacleDistance then
        
        ComboSystem.draw()
    
    end
end