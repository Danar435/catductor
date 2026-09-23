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

-- TITLE
local titleImage = gfx.image.new("images/title")
local titleSprite = gfx.sprite.new(titleImage)

titleSprite:moveTo(250, 95)
titleSprite:setZIndex(100)
titleSprite:add()

Background.init()
Train.init()

-- GAME STATES
local gameStarted = false
local countdownActive = false

-- COUNTDOWN
local countdownNumber = 0
local countdownTimer = 0

local countdownDuration = 1000
local countdownGoDuration = 700

local function startCountdown()

    countdownActive = true
    countdownNumber = 3
    countdownTimer = pd.getCurrentTimeMilliseconds()

    titleSprite:setVisible(false)

    -- reset everything BEFORE countdown
    Train.reset()
    Obstacle.reset()

    -- Level 1 uses D-pad combos
    ComboSystem.setLevel(1)
    ComboSystem.resetGame()
    TripOverview.reset()
end   

local function startGame()
    gameStarted = true
    countdownActive = false
end

local function updateCountdown()

    local currentTime =
        pd.getCurrentTimeMilliseconds()

    local elapsed =
        currentTime - countdownTimer

    if countdownNumber > 0 then

        if elapsed >= countdownDuration then

            countdownTimer = currentTime
            countdownNumber -= 1
        end

    else

        -- GO!
        if elapsed >= countdownGoDuration then
            startGame()
        end
    end
end

function pd.update()

    gfx.sprite.update()

    -- START SCREEN
    if not gameStarted and not countdownActive then

        gfx.drawTextAligned(
            "Press A to Start",
            200,
            200,
            kTextAlignment.center
        )

        if pd.buttonJustPressed(pd.kButtonA) then
            startCountdown()
        end

        return
    end

    -- COUNTDOWN
    if countdownActive then

        updateCountdown()

        if countdownNumber > 0 then

            gfx.drawTextAligned(
                tostring(countdownNumber),
                200,
                200,
                kTextAlignment.center
            )

        else

            gfx.drawTextAligned(
                "GO!",
                200,
                200,
                kTextAlignment.center
            )

        end

        return
    end

    -- GAME
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
