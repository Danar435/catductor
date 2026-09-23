import "CoreLibs/graphics"
import "CoreLibs/sprites"

local gfx = playdate.graphics

Background = {}

local topImage = gfx.image.new("images/background/background-top")
local middleImage = gfx.image.new("images/background/background-middle")
local bottomImage = gfx.image.new("images/background/background-bottom")
local staticImage = gfx.image.new("images/background/background-static")

local topWidth, topHeight = topImage:getSize()
local middleWidth, middleHeight = middleImage:getSize()
local bottomWidth, bottomHeight = bottomImage:getSize()
local staticWidth, staticHeight = staticImage:getSize()

local topSprite1 = gfx.sprite.new(topImage)
local topSprite2 = gfx.sprite.new(topImage)

local middleSprite1 = gfx.sprite.new(middleImage)
local middleSprite2 = gfx.sprite.new(middleImage)

local bottomSprite1 = gfx.sprite.new(bottomImage)
local bottomSprite2 = gfx.sprite.new(bottomImage)

local staticSprite = gfx.sprite.new(staticImage)

staticSprite:setZIndex(-100)

topSprite1:setZIndex(-90)
topSprite2:setZIndex(-90)

middleSprite1:setZIndex(-80)
middleSprite2:setZIndex(-80)

bottomSprite1:setZIndex(80)
bottomSprite2:setZIndex(80)



local topY = 33
local middleY = 136
local bottomY = 136
local staticY = 110


function Background.init()
    topSprite1:moveTo(topWidth / 2, topY)
    topSprite2:moveTo(topWidth + topWidth / 2, topY)

    middleSprite1:moveTo(middleWidth / 2, middleY)
    middleSprite2:moveTo(middleWidth + middleWidth / 2, middleY)

    bottomSprite1:moveTo(bottomWidth / 2, bottomY)
    bottomSprite2:moveTo(bottomWidth + bottomWidth / 2, bottomY)

    staticSprite:moveTo(staticWidth / 2, staticY)

    topSprite1:add()
    topSprite2:add()

    middleSprite1:add()
    middleSprite2:add()

    bottomSprite1:add()
    bottomSprite2:add()

    staticSprite:add()
end


local function scrollLayer(sprite1, sprite2, width, speed)

    sprite1:moveBy(-speed, 0)
    sprite2:moveBy(-speed, 0)

    if sprite1.x + width / 2 < 0 then
        sprite1:moveTo(sprite2.x + width, sprite1.y)
    end

    if sprite2.x + width / 2 < 0 then
        sprite2:moveTo(sprite1.x + width, sprite2.y)
    end
end


function Background.update()

    local trainSpeed = Train.getSpeed()

    local topSpeed = trainSpeed * 0.25
    local middleSpeed = trainSpeed
    local bottomSpeed = trainSpeed * 0.5

    scrollLayer(
        topSprite1,
        topSprite2,
        topWidth,
        topSpeed
    )

    scrollLayer(
        middleSprite1,
        middleSprite2,
        middleWidth,
        middleSpeed
    )

    scrollLayer(
        bottomSprite1,
        bottomSprite2,
        bottomWidth,
        bottomSpeed
    )
end