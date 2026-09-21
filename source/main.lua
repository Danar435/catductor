import "CoreLibs/graphics"
import "CoreLibs/sprites"

import "combo"

local pd = playdate
local gfx = pd.graphics


-- TRAIN
local trainX = 40
local trainY = 120

local trainImages = {
    gfx.image.new("images/train-placeholder-1"),
    gfx.image.new("images/train-placeholder-2"),
    gfx.image.new("images/train-placeholder-3"),
    gfx.image.new("images/train-placeholder-4"),
    gfx.image.new("images/train-placeholder-5")
}
local trainSprite = gfx.sprite.new(trainImages[1])

trainSprite:setCollideRect(10, 4, 125, 125)

trainSprite:moveTo(trainX, trainY)
trainSprite:add()


-- SPEED
local defaultSpeed = 3
local trainSpeed = defaultSpeed -- current 'train' speed

local minSpeed = 1
local maxSpeed = 10

local acceleration = 0.01 -- forward crank increases speed
local brake = 0.5 -- backward crank decreases speed

local slowdown = 0.05 -- how quickly speed naturally decreases


-- COLLISION PENALTY
local accelerationLockedUntil = 0 -- time when acceleration becomes available again
local accelerationLockDuration = 2000 -- collision penalty duration (2 seconds)


-- OBSTACLE
local obstacleImage = gfx.image.new("images/obstacle")
local obstacleSprite = gfx.sprite.new(obstacleImage)

obstacleSprite.collisionResponse = gfx.sprite.kCollisionTypeOverlap
obstacleSprite:setCollideRect(0, 0, 30, 100)

obstacleSprite:moveTo(450, trainY)
obstacleSprite:add()


-- ANIMATION
local animationTimer = 0
local animationFrame = 1
local animationDelay = 10


-- GAME STATE
local gameStarted = false


-- START GAME = reset all variables to their default values
local function startGame()

    gameStarted = true

    trainSpeed = defaultSpeed

    accelerationLockedUntil = 0

    trainSprite:moveTo(trainX, trainY)

    animationFrame = 1
    animationTimer = 0 

    trainSprite:setImage(trainImages[animationFrame])

    obstacleSprite:moveTo(450, trainY)

    -- Start combo system
    ComboSystem.resetGame()

end


-- DESTROY OBSTACLE by just moving it off-screen
local function destroyObstacle()

    obstacleSprite:moveTo(500, trainY)

end


-- UPDATE
function pd.update()

    gfx.sprite.update()


    -- START SCREEN
    if not gameStarted then

        gfx.drawTextAligned("Press A to Start", 200, 40, kTextAlignment.center)

        if pd.buttonJustPressed(pd.kButtonA) then
            startGame()
        end

        return
    end

    local currentTime = pd.getCurrentTimeMilliseconds()


    -- CRANK SPEED CONTROL
    local crankChange = pd.getCrankChange()

    if crankChange > 0 then
        -- crank forward = accelerate
        -- (only allow acceleration if there is no more collision penalty)
        if currentTime >= accelerationLockedUntil then
            trainSpeed += crankChange * acceleration
        end

    elseif crankChange < 0 then
        -- crank backward = brake
        trainSpeed += crankChange * brake

    end


    -- SPEED LOSS
    trainSpeed -= slowdown

    -- SPEED LIMITS
    if trainSpeed < minSpeed then
        trainSpeed = minSpeed
    end

    if trainSpeed > maxSpeed then
        trainSpeed = maxSpeed
    end



    -- TRAIN ANIMATION SPEED (higher speed = faster animation)
    animationDelay = math.floor(
        15 - trainSpeed
    )

    if animationDelay < 3 then
        animationDelay = 3
    end

    if animationDelay > 15 then
        animationDelay = 15
    end


    -- IDLE TRAIN ANIMATION
    animationTimer += 1

    if animationTimer >= animationDelay then

        animationTimer = 0
        animationFrame += 1

        if animationFrame > #trainImages then
            animationFrame = 1
        end

        trainSprite:setImage(trainImages[animationFrame])

    end


    -- MOVE OBSTACLE
    obstacleSprite:moveBy(-trainSpeed, 0)


    -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    -- this one should be changed by mini-game
    if ComboSystem.update() then

    destroyObstacle()

    ComboSystem.startWall()

end

    -- OBSTACLE PASSED TRAIN
    if obstacleSprite.x < -30 then

        obstacleSprite:moveTo(450, trainY)
        ComboSystem.failWall()
    end


    -- COLLISION
    local collisions = trainSprite:overlappingSprites()

    for i = 1, #collisions do

        if collisions[i] == obstacleSprite then

            trainSpeed = minSpeed -- extremely reduce speed
            accelerationLockedUntil = currentTime + accelerationLockDuration -- block acceleration for 2 seconds 
            destroyObstacle()
            ComboSystem.failWall()
            break

        end

    end


    -- SPEED DISPLAY
    gfx.drawTextAligned("Speed: " .. string.format("%.1f", trainSpeed), 10, 10, kTextAlignment.left)
    ComboSystem.draw()
    gfx.drawText("Walls: " .. ComboSystem.getWallsCleared(), 10, 30)
end