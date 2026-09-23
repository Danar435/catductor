import "CoreLibs/graphics"
import "CoreLibs/sprites"

local pd = playdate
local gfx = pd.graphics

Train = {}

-- SCREEN SHAKE
local shakeTimer = 0
local shakeDuration = 300
local shakeStrength = 4

-- TRAIN SPRITE
local trainX = 65
local trainY = 80

local trainImages = {

    gfx.image.new("images/train1"),
    gfx.image.new("images/train2"),
    gfx.image.new("images/train3"),
    gfx.image.new("images/train4"),
    gfx.image.new("images/train5"),
    gfx.image.new("images/train6"),
    gfx.image.new("images/train7"),
    gfx.image.new("images/train8")
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


-- SPEED IMAGE
local speedImages = {
    gfx.image.new("images/speed1"),
    gfx.image.new("images/speed2"),
    gfx.image.new("images/speed3"),
    gfx.image.new("images/speed4"),
    gfx.image.new("images/speed5")
}

local speedSprite = gfx.sprite.new(speedImages[1])

speedSprite:setZIndex(10)
speedSprite:moveTo(
    trainX,
    trainY
)

speedSprite:add()

-- STEAM SPRITE
local steamImages = {
    gfx.image.new("images/steam1"),
    gfx.image.new("images/steam2"),
    gfx.image.new("images/steam3"),
    gfx.image.new("images/steam4"),
    gfx.image.new("images/steam5"),
    gfx.image.new("images/steam6")
}

local steamSprite = gfx.sprite.new(steamImages[1])

steamSprite:setZIndex(20)

steamSprite:moveTo(
    trainX,
    trainY
)

steamSprite:add()

steamSprite:setVisible(false) -- initially invisible

local steamFrame = 1
local steamTimer = 0
local steamAnimationDelay = 8

-- SPEED
local defaultSpeed = 3
local trainSpeed = defaultSpeed

local minSpeed = 1
local maxSpeed = 15

local acceleration = 0.005
local brake = 0.0025
local slowdown = 0.05


-- COLLISION PENALTY
local accelerationLockedUntil = 0
local accelerationLockDuration = 2000


-- ANIMATION
local animationTimer = 0
local animationFrame = 1
local animationDelay = 10

local trainBounceUp = false

-- RESET
function Train.reset()

    trainSpeed = defaultSpeed
    accelerationLockedUntil = 0

    trainSprite:moveTo(
        trainX,
        trainY
    )

    speedSprite:moveTo(
        trainX,
        trainY
    )

    steamSprite:moveTo(
        trainX,
        trainY
    )

    animationFrame = 1
    animationTimer = 0
    trainBounceUp = false

    trainSprite:setImage(
        trainImages[animationFrame]
    )

    speedSprite:setImage(
        speedImages[3]
    )

    steamSprite:setVisible(false)

    steamFrame = 1
    steamTimer = 0

    steamSprite:setImage(
        steamImages[1]
    )
end

-- SPEED IMAGE UPDATE
local function updateSpeedImage()

    local speedImageIndex

    if trainSpeed < 2 then
        speedImageIndex = 1

    elseif trainSpeed < 4 then
        speedImageIndex = 2

    elseif trainSpeed < 6 then
        speedImageIndex = 3

    elseif trainSpeed < 8 then
        speedImageIndex = 4

    else
        speedImageIndex = 5
    end

    speedSprite:setImage(
        speedImages[speedImageIndex]
    )
end

local function updateSteam(crankChange)

    local currentTime =
        pd.getCurrentTimeMilliseconds()

    -- Steam only when:
    -- - crank is moving forward
    -- - acceleration is not locked

    if crankChange > 0
        and currentTime >= accelerationLockedUntil then

        steamSprite:setVisible(true)

        steamTimer += 1

        if steamTimer >= steamAnimationDelay then

            steamTimer = 0

            steamFrame += 1

            if steamFrame > #steamImages then
                steamFrame = 1
            end

            steamSprite:setImage(
                steamImages[steamFrame]
            )
        end

    else

        steamSprite:setVisible(false)

        steamFrame = 1
        steamTimer = 0

        steamSprite:setImage(
            steamImages[1]
        )
    end
end

-- SPEED UPDATE
local function updateSpeed()

    local currentTime =
        pd.getCurrentTimeMilliseconds()

    local crankChange =
        pd.getCrankChange()


    -- crank forward
    if crankChange > 0 then

        if currentTime >= accelerationLockedUntil then

            -- the faster the train already goes = the easier it is to accelerate
            local accelerationFactor = 0.3 + (trainSpeed / maxSpeed) * 0.7

            trainSpeed += crankChange * acceleration * accelerationFactor
        end


    -- crank backward
    elseif crankChange < 0 then

        trainSpeed += crankChange * brake

    end


    -- natural slowdown
    trainSpeed -= slowdown


    -- speed limits
    if trainSpeed < minSpeed then
        trainSpeed = minSpeed
    end

    if trainSpeed > maxSpeed then
        trainSpeed = maxSpeed
    end

end



-- ANIMATION UPDATE
local function updateAnimation(crankChange)

    -- when turning the crank backwards = freeze the train animation
    if crankChange < 0 then
        return
    end

    animationDelay = math.floor(18 - trainSpeed * 1.1)

    if animationDelay < 1 then
        animationDelay = 1
    end

    if animationDelay > 18 then
        animationDelay = 18
    end

    animationTimer += 1

    if animationTimer >= animationDelay then

        animationTimer = 0

        -- next train animation frame
        animationFrame += 1

        if animationFrame > #trainImages then
            animationFrame = 1
        end

        trainSprite:setImage(
            trainImages[animationFrame]
        )

        -- train movement
        if trainBounceUp then
            trainSprite:moveTo(
                trainX,
                trainY
            )

            trainBounceUp = false
        else
            trainSprite:moveTo(
                trainX,
                trainY - 1
            )

            trainBounceUp = true
        end
    end
end


-- UPDATE
function Train.update()

    local crankChange = pd.getCrankChange()

    updateSpeed()
    updateAnimation(crankChange)
    updateSpeedImage()
    updateSteam(crankChange)

    speedSprite:moveTo(
        trainSprite.x,
        trainSprite.y
    )

    steamSprite:moveTo(
        trainSprite.x,
        trainSprite.y
    )

    -- SCREEN SHAKE
    if shakeTimer > 0 then
        local shakeX = math.random(
            -shakeStrength,
            shakeStrength
        )

        local shakeY = math.random(
            -shakeStrength,
            shakeStrength
        )

        gfx.setDrawOffset(
            shakeX,
            shakeY
        )

        shakeTimer -= 16

        if shakeTimer <= 0 then
            shakeTimer = 0
            gfx.setDrawOffset(0, 0)
        end
    else
        gfx.setDrawOffset(0, 0)
    end
end

function Train.startShake()
    shakeTimer = shakeDuration
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