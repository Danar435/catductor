import "CoreLibs/graphics"
import "CoreLibs/sprites"

local gfx = playdate.graphics

Obstacle = {}


-- OBSTACLE
local obstacleImage =
    gfx.image.new("images/obstacle")

local obstacleSprite =
    gfx.sprite.new(obstacleImage)

obstacleSprite.collisionResponse =
    gfx.sprite.kCollisionTypeOverlap

obstacleSprite:setCollideRect(
    0,
    0,
    30,
    100
)

obstacleSprite:moveTo(
    450,
    120
)

obstacleSprite:add()


-- RESET
function Obstacle.reset()

    obstacleSprite:moveTo(
        450,
        120
    )

end


-- UPDATE
function Obstacle.update()

    local speed = Train.getSpeed()

    obstacleSprite:moveBy(
        -speed,
        0
    )


    -- Obstacle passed the train
    if obstacleSprite.x < -30 then

        obstacleSprite:moveTo(
            450,
            120
        )

        ComboSystem.failWall()

    end

end


-- DESTROY
function Obstacle.destroy()

    obstacleSprite:moveTo(
        500,
        120
    )

end


-- COLLISION
function Obstacle.checkCollision(
    trainSprite
)

    local collisions =
        trainSprite:overlappingSprites()

    for i = 1, #collisions do

        if collisions[i] == obstacleSprite then
            return true
        end

    end

    return false

end