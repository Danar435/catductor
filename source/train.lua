import "CoreLibs/graphics"
import "CoreLibs/sprites"

local pd = playdate
local gfx = pd.graphics

Train = {}


-- TRAIN SPRITE
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

trainSprite:setCollideRect(
    10,
    4,
    125,
    125
)

trainSprite:moveTo(
    trainX,
    trainY
)
trainSprite:add()


-- SPEED
local defaultSpeed = 3
local trainSpeed = defaultSpeed

local minSpeed = 1
local maxSpeed = 10

local acceleration = 0.01
local brake = 0.5
local slowdown = 0.05


-- COLLISION PENALTY
local accelerationLockedUntil = 0
local accelerationLockDuration = 2000


-- ANIMATION
local animationTimer = 0
local animationFrame = 1
local animationDelay = 10


-- RESET
function Train.reset()

    trainSpeed = defaultSpeed

    accelerationLockedUntil = 0

    trainSprite:moveTo(
        trainX,
        trainY
    )

    animationFrame = 1
    animationTimer = 0

    trainSprite:setImage(
        trainImages[animationFrame]
    )

end


-- SPEED UPDATE
local function updateSpeed()

    local currentTime =
        pd.getCurrentTimeMilliseconds()

    local crankChange =
        pd.getCrankChange()


    -- Crank forward
    if crankChange > 0 then

        if currentTime >= accelerationLockedUntil then

            trainSpeed +=
                crankChange * acceleration

        end


    -- Crank backward
    elseif crankChange < 0 then

        trainSpeed +=
            crankChange * brake

    end


    -- Natural slowdown
    trainSpeed -= slowdown


    -- Speed limits
    if trainSpeed < minSpeed then
        trainSpeed = minSpeed
    end

    if trainSpeed > maxSpeed then
        trainSpeed = maxSpeed
    end

end



-- ANIMATION UPDATE
local function updateAnimation()

    -- Higher speed = faster animation

    animationDelay =
        math.floor(15 - trainSpeed)

    if animationDelay < 3 then
        animationDelay = 3
    end

    if animationDelay > 15 then
        animationDelay = 15
    end


    animationTimer += 1

    if animationTimer >= animationDelay then

        animationTimer = 0

        animationFrame += 1

        if animationFrame > #trainImages then
            animationFrame = 1
        end

        trainSprite:setImage(
            trainImages[animationFrame]
        )

    end

end


-- UPDATE
function Train.update()

    updateSpeed()
    updateAnimation()

end


-- COLLISION PENALTY
function Train.penalize()

    trainSpeed = minSpeed

    local currentTime =
        pd.getCurrentTimeMilliseconds()

    accelerationLockedUntil =
        currentTime + accelerationLockDuration

end



function Train.getSprite()

    return trainSprite

end


function Train.getSpeed()

    return trainSpeed

end