import "CoreLibs/graphics"
import "CoreLibs/sprites"

import "background"
import "train"
import "obstacle"
import "combo"
import "levels"
import "overview"
import "sound"
import "ui"

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
local gameResult = nil

-- COUNTDOWN
local countdownNumber = 0
local countdownTimer = 0

local countdownDuration = 1000
local countdownGoDuration = 700

--LEVEL TIMER
local levelStartTime = 0
timeRemaining = 0 -- making this global for now, ideally should be a getter

--LEVEL FINISH
local function finishLevel(result)

    gameStarted = false
    countdownActive = false

    gameResult = result

end

local function startCountdown()

    countdownActive = true
    countdownNumber = 2
    countdownTimer = pd.getCurrentTimeMilliseconds()

    titleSprite:setVisible(false)

    -- reset everything BEFORE countdown
    Train.reset()
    Obstacle.reset()

    -- Level 1 uses D-pad combos
    ComboSystem.resetGame()
    TripOverview.reset()
    Sound.playStart()
    
    -- Reset level timer
    timeRemaining = Level.current().time
    
end   

local function startGame()
    gameStarted = true
    countdownActive = false
    Sound.playBGM()

    -- Timer starts AFTER countdown
    levelStartTime = pd.getCurrentTimeMilliseconds()
    timeRemaining = Level.current().time
    
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

-- UPDATE TIMER
local function updateLevelTimer()

    local currentTime = pd.getCurrentTimeMilliseconds()

    local elapsed = (currentTime - levelStartTime) / 1000

    timeRemaining = Level.current().time - elapsed

    if timeRemaining <= 0 then

        timeRemaining = 0

        finishLevel("lose")

        return false

    end

    return true

end

-- LEVEL COMPLETE
local function checkLevelComplete()
    if Obstacle.isLevelComplete() then

        if timeRemaining > 0 then
            finishLevel("win")
            Sound.stopBGM()
            Sound.playVictory()
        else
            -- never seem to reach this part
            finishLevel("lose")
            Sound.stopBGM()
            Sound.playDefeat()
        end

        return true

    end

    return false

end

function pd.update()

    gfx.sprite.update()

    --RESULT SCREEN - simple panel
    if gameResult ~= nil then

    gfx.setColor(gfx.kColorWhite)

    gfx.fillRect(
        40,
        60,
        320,
        120
    )

    gfx.setColor(gfx.kColorBlack)

    gfx.drawRect(
        40,
        60,
        320,
        120
    )

        if gameResult == "win" then

            gfx.drawTextAligned(
                "LEVEL COMPLETE!",
                200,
                90,
                kTextAlignment.center
            )

            gfx.drawTextAligned(
                "Time remaining: "
                .. string.format("%.1f", timeRemaining),
                200,
                120,
                kTextAlignment.center
            )

            gfx.drawTextAligned(
                "Press A to return",
                200,
                160,
                kTextAlignment.center
            )

            if Level.current().score == nil 
            or Level.current().score < timeRemaining then
                Level.saveScore(timeRemaining)
            end

            if pd.buttonJustPressed(pd.kButtonA) then

                gameResult = nil
                
                -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                -- Temporary behavior until Level 2
                titleSprite:setVisible(true)

            end


        elseif gameResult == "lose" then

            gfx.drawTextAligned(
                "TIME'S UP!",
                200,
                100,
                kTextAlignment.center
            )

            gfx.drawTextAligned(
                "Press A to retry",
                200,
                140,
                kTextAlignment.center
            )

            if pd.buttonJustPressed(pd.kButtonA) then

                gameResult = nil

                -- Restart current level
                startCountdown()

            end

        end

        return
    end

    -- START SCREEN
    if not gameStarted and not countdownActive then

        if Ui.levelSelect() then
            startCountdown()
        end
        return
    end

    -- COUNTDOWN
    if countdownActive then

        gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
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

        gfx.setImageDrawMode(gfx.kDrawModeCopy)

        return
    end

    -- LEVEL TIMER
    if not updateLevelTimer() then
        return
    end

    -- GAME
    Train.update()
    Background.update()
    Obstacle.update()
    Sound.update()

    if ComboSystem.update() then

        Sound.playExplosion()
        Obstacle.destroy()

        if checkLevelComplete() then
            return
        end

        ComboSystem.startWall()
    end

    -- COLLISION
    if Obstacle.checkCollision(Train.getSprite()) then

        Sound.playExplosionTrain()
        Train.penalize()
        Obstacle.destroy()

        if checkLevelComplete() then
            return
        end

        ComboSystem.failWall()
    end

    -- UI
    TripOverview.draw()
    Ui.inGame()

end
