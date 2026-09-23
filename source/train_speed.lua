local pd = playdate

TrainSpeed = {}

local defaultSpeed = 3
local trainSpeed = defaultSpeed

local minSpeed = 1
local maxSpeed = 15

local acceleration = 0.005
local brake = 0.0025
local slowdown = 0.05

local accelerationLockedUntil = 0
local accelerationLockDuration = 2000


function TrainSpeed.reset()
    trainSpeed = defaultSpeed
    accelerationLockedUntil = 0
end


function TrainSpeed.update()
    local currentTime = pd.getCurrentTimeMilliseconds()
    local crankChange = pd.getCrankChange()

    -- CRANK FORWARD
    if crankChange > 0 then

        if currentTime >= accelerationLockedUntil then

            -- The faster the train already goes, the easier it is to accelerate.
            local accelerationFactor = 0.3 + (trainSpeed / maxSpeed) * 0.85

            trainSpeed += crankChange * acceleration * accelerationFactor
        end

    -- CRANK BACKWARD
    elseif crankChange < 0 then

        trainSpeed += crankChange * brake
    end


    -- NATURAL SLOWDOWN
    trainSpeed -= slowdown


    -- SPEED LIMITS
    if trainSpeed < minSpeed then
        trainSpeed = minSpeed
    end

    if trainSpeed > maxSpeed then
        trainSpeed = maxSpeed
    end
end


function TrainSpeed.penalize()

    trainSpeed = minSpeed

    local currentTime = pd.getCurrentTimeMilliseconds()

    accelerationLockedUntil = currentTime + accelerationLockDuration
end


function TrainSpeed.getSpeed()
    return trainSpeed
end


function TrainSpeed.isAccelerationLocked()

    local currentTime = pd.getCurrentTimeMilliseconds()

    return currentTime < accelerationLockedUntil
end