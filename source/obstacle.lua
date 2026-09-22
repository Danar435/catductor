import "CoreLibs/graphics"
import "CoreLibs/sprites"

local gfx = playdate.graphics

Obstacle = {}


-- OBSTACLE
local obstacleImage =
    gfx.image.new("images/obstacle")

local obstacleSprite = {}
local obstacleY = 100
local obstacleNext = 1



-- INIT
function Obstacle.reset()

    obstacleSprite = {}
    local obstacleDistanceSum = 0

    for i, obstacleDistance in ipairs(Level1.obstacles) do

        obstacleDistanceSum += obstacleDistance * 100
        local obstacle = gfx.sprite.new(obstacleImage)

        obstacle.collisionResponse =
            gfx.sprite.kCollisionTypeOverlap
        obstacle:setCollideRect(
            0,
            0,
            30,
            100
        )
        obstacle:moveTo(
            obstacleDistanceSum,
            obstacleY
        )
        obstacle:add()

        obstacleSprite[i] = obstacle
    end

end

-- UPDATE
function Obstacle.update()

    local speed = Train.getSpeed()

    for i, obstacle in ipairs(obstacleSprite) do

        obstacle:moveBy(
            -speed,
            0
        )


        -- obstacle passed the train
        if obstacle.x < -30 then

            obstacle:remove()
            ComboSystem.failWall()

        end
    end

end


-- DESTROY
function Obstacle.destroy()

    obstacleSprite[obstacleNext]:remove()
    obstacleNext += 1

end


-- COLLISION
function Obstacle.checkCollision(
    trainSprite
)

    local collisions =
        trainSprite:overlappingSprites()

    for i, overlappingSprite in ipairs(collisions) do
        for j, obstacle in ipairs(obstacleSprite) do

            if overlappingSprite == obstacle then
                return true
            end

        end
    end

    return false

end