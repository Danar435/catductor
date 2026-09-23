import "CoreLibs/graphics"
import "CoreLibs/sprites"

import "train_speed"
import "train_animation"

local gfx = playdate.graphics

Train = {}

-- TRAIN
local trainX = 65
local trainY = 80

local trainSprite

-- SPEED IMAGE
local speedImages = {
    gfx.image.new("images/speed/speed1"),
    gfx.image.new("images/speed/speed2"),
    gfx.image.new("images/speed/speed3"),
    gfx.image.new("images/speed/speed4"),
    gfx.image.new("images/speed/speed5")
}

local speedSprite


-- INIT
function Train.init()

    -- TRAIN
    local trainImages = TrainAnimation.getTrainImages()

    trainSprite = gfx.sprite.new(trainImages[1])
    trainSprite:setCollideRect(10, 4, 125, 125)
    trainSprite:moveTo(trainX, trainY)
    trainSprite:add()

    -- SPEED IMAGE
    speedSprite = gfx.sprite.new(speedImages[1])
    speedSprite:setZIndex(10)
    speedSprite:moveTo(trainX, trainY)
    speedSprite:add()
end


-- RESET
function Train.reset()

    TrainSpeed.reset()
    TrainAnimation.reset(trainSprite)

    speedSprite:moveTo(trainX, trainY)
    speedSprite:setImage(speedImages[2])
end

-- SPEED IMAGE
local function updateSpeedImage()

    local speed = TrainSpeed.getSpeed()
    local speedImageIndex

    if speed < 3 then
        speedImageIndex = 1

    elseif speed < 6 then
        speedImageIndex = 2

    elseif speed < 9 then
        speedImageIndex = 3

    elseif speed < 12 then
        speedImageIndex = 4

    else
        speedImageIndex = 5
    end

    speedSprite:setImage(speedImages[speedImageIndex])
end


-- UPDATE
function Train.update()

    TrainSpeed.update()
    TrainAnimation.updateAnimation(trainSprite)
    updateSpeedImage()

    TrainAnimation.updateSteam(trainSprite)

    TrainAnimation.updateShake()

    speedSprite:moveTo(trainSprite.x, trainSprite.y)
end


-- COLLISION PENALTY
function Train.penalize()
    TrainSpeed.penalize()
    TrainAnimation.startShake()
end


function Train.getSprite()
    return trainSprite
end


function Train.getSpeed()
    return TrainSpeed.getSpeed()
end