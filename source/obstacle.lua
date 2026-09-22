import "CoreLibs/graphics"
import "CoreLibs/sprites"

local gfx = playdate.graphics

Obstacle = {}

-- OBSTACLE
local obstacleImage =
    gfx.image.new("images/obstacle")

local obstacleSprite = {}
local obstacleNext = 1
local obstacleY = 100

-- RESET
function Obstacle.reset()

    local obstacleDistanceSum = 0

    for i, obstacleDistance in ipairs(Level1.obstacles) do

        obstacleDistanceSum += obstacleDistance * 100

        local obstacle = gfx.sprite.new(obstacleImage)
        obstacle.collisionResponse = gfx.sprite.kCollisionTypeOverlap
        obstacle:setCollideRect(0, 0, 30, 100)
        obstacle:moveTo(obstacleDistanceSum, obstacleY)
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

        if overlappingSprite == obstacleSprite[obstacleNext] then
            return true

        end
    end

    return false

end

-- DISTANCE
function Obstacle.getDistance()
    local x, y = obstacleSprite[obstacleNext]:getPosition()
    return math.floor(x) - 400 
end