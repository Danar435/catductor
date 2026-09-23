import "CoreLibs/graphics"
import "CoreLibs/sprites"

local pd = playdate
local gfx = pd.graphics

TrainAnimation = {}


-- TRAIN ANIMATION
local trainX = 65
local trainY = 80

local trainImages = {
    gfx.image.new("images/train/train1"),
    gfx.image.new("images/train/train2"),
    gfx.image.new("images/train/train3"),
    gfx.image.new("images/train/train4"),
    gfx.image.new("images/train/train5"),
    gfx.image.new("images/train/train6"),
    gfx.image.new("images/train/train7"),
    gfx.image.new("images/train/train8")
}

local animationTimer = 0
local animationFrame = 1
local animationDelay = 10
local trainBounceUp = false


-- STEAM ANIMATION
local steamImages = {
    gfx.image.new("images/steam/steam1"),
    gfx.image.new("images/steam/steam2"),
    gfx.image.new("images/steam/steam3"),
    gfx.image.new("images/steam/steam4"),
    gfx.image.new("images/steam/steam5"),
    gfx.image.new("images/steam/steam6")
}

local steamSprite = gfx.sprite.new(steamImages[1])

steamSprite:setZIndex(20)
steamSprite:moveTo(trainX, trainY)
steamSprite:add()
steamSprite:setVisible(false)

local steamFrame = 1
local steamTimer = 0
local steamAnimationDelay = 8



-- SCREEN SHAKE
local shakeTimer = 0
local shakeDuration = 300
local shakeStrength = 4



-- RESET
function TrainAnimation.reset(trainSprite)

    -- TRAIN ANIMATION
    animationTimer = 0
    animationFrame = 1
    trainBounceUp = false

    trainSprite:setImage(trainImages[animationFrame])

    trainSprite:moveTo(trainX, trainY)


    -- STEAM
    steamFrame = 1
    steamTimer = 0

    steamSprite:setImage(steamImages[1])
    steamSprite:setVisible(false)


    -- SHAKE
    shakeTimer = 0

    gfx.setDrawOffset(0, 0)
end



-- TRAIN ANIMATION UPDATE
function TrainAnimation.updateAnimation(trainSprite)

    local crankChange = pd.getCrankChange()

    -- Turning backwards freezes animation
    if crankChange < 0 then
        return
    end


    local trainSpeed = TrainSpeed.getSpeed()


    animationDelay = math.floor(18 - trainSpeed * 1.5)


    if animationDelay < 1 then
        animationDelay = 1
    end

    if animationDelay > 18 then
        animationDelay = 18
    end


    animationTimer += 1


    if animationTimer >= animationDelay then

        animationTimer = 0


        -- NEXT FRAME
        animationFrame += 1


        if animationFrame > #trainImages then
            animationFrame = 1
        end


        trainSprite:setImage(trainImages[animationFrame])


        -- TRAIN BOUNCE
        if trainBounceUp then
            trainSprite:moveTo(trainX, trainY)
            trainBounceUp = false

        else
            trainSprite:moveTo(trainX, trainY - 1)
            trainBounceUp = true
        end
    end
end



-- STEAM UPDATE
function TrainAnimation.updateSteam(trainSprite)

    local crankChange = pd.getCrankChange()

    -- Steam only when:
    -- crank is moving forward
    -- acceleration is not locked
    if crankChange > 0 and not TrainSpeed.isAccelerationLocked() then

        steamSprite:setVisible(true)
        steamTimer += 1

        if steamTimer >= steamAnimationDelay then
            steamTimer = 0
            steamFrame += 1

            if steamFrame > #steamImages then
                steamFrame = 1
            end

            steamSprite:setImage(steamImages[steamFrame])
        end

    else

        steamSprite:setVisible(false)

        steamFrame = 1
        steamTimer = 0

        steamSprite:setImage(steamImages[1])
    end


    steamSprite:moveTo(trainSprite.x, trainSprite.y)
end


-- SCREEN SHAKE
function TrainAnimation.startShake()
    shakeTimer = shakeDuration
end


function TrainAnimation.updateShake()

    if shakeTimer > 0 then

        local shakeX = math.random(-shakeStrength, shakeStrength)
        local shakeY = math.random(-shakeStrength, shakeStrength)

        gfx.setDrawOffset(shakeX, shakeY)

        shakeTimer -= 16

        if shakeTimer <= 0 then
            shakeTimer = 0
            gfx.setDrawOffset(0, 0)
        end

    else

        gfx.setDrawOffset(0, 0)
    end
end


-- GET TRAIN IMAGES
function TrainAnimation.getTrainImages()
    return trainImages
end