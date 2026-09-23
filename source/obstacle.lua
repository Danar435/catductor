import "CoreLibs/graphics"
import "CoreLibs/sprites"

local gfx = playdate.graphics

Obstacle = {}


-- OBSTACLE
local obstacleImages = {
    gfx.image.new("images/obstacle1"),
    gfx.image.new("images/obstacle2"),
    gfx.image.new("images/obstacle3"),
    gfx.image.new("images/obstacle4")
}

local obstacleSprite = {}
local obstacleNext = 1
local obstacleY = 100


-- OBSTACLE ANIMATION
local obstacleAnimationFrame = 1
local obstacleAnimationTimer = 0
local obstacleAnimationDelay = 6


-- EXPLOSION
local explosionImages = {
    gfx.image.new("images/explosion1"),
    gfx.image.new("images/explosion2"),
    gfx.image.new("images/explosion3"),
    gfx.image.new("images/explosion4"),
    gfx.image.new("images/explosion5"),
    gfx.image.new("images/explosion6"),
    gfx.image.new("images/explosion7"),
    gfx.image.new("images/explosion8"),
    gfx.image.new("images/explosion9"),
    gfx.image.new("images/explosion10"),
    gfx.image.new("images/explosion11"),
    gfx.image.new("images/explosion12")
}

local explosionSprite =
    gfx.sprite.new(explosionImages[1])

explosionSprite:setZIndex(30)
explosionSprite:setVisible(false)
explosionSprite:add()

local explosionFrame = 1
local explosionTimer = 0
local explosionAnimationDelay = 3
local explosionActive = false

-- RESET
function Obstacle.reset()

    obstacleNext = 1
    obstacleSprite = {}

    local obstacleDistanceSum = 0

    for i, obstacleDistance in ipairs(Level1.obstacles) do

        obstacleDistanceSum += obstacleDistance * 100

        local obstacle = gfx.sprite.new(
            obstacleImages[1]
        )

        obstacle.collisionResponse =
            gfx.sprite.kCollisionTypeOverlap

        obstacle:setCollideRect(
            30,
            0,
            40,
            100
        )

        obstacle:moveTo(
            obstacleDistanceSum,
            obstacleY
        )

        obstacle:add()

        obstacleSprite[i] = obstacle
    end

    -- reset obstacle animation
    obstacleAnimationFrame = 1
    obstacleAnimationTimer = 0

    -- reset explosion
    explosionActive = false
    explosionFrame = 1
    explosionTimer = 0

    explosionSprite:setImage(
        explosionImages[1]
    )

    explosionSprite:setVisible(false)
end

-- UPDATE
function Obstacle.update()

    local speed = Train.getSpeed()

    -- MOVE OBSTACLES
    for i, obstacle in ipairs(obstacleSprite) do

        obstacle:moveBy(
            -speed,
            0
        )
    end

    -- OBSTACLE ANIMATION
    obstacleAnimationTimer += 1

    if obstacleAnimationTimer >= obstacleAnimationDelay then

        obstacleAnimationTimer = 0
        obstacleAnimationFrame += 1

        if obstacleAnimationFrame > #obstacleImages then
            obstacleAnimationFrame = 1
        end

        for i, obstacle in ipairs(obstacleSprite) do

            obstacle:setImage(
                obstacleImages[obstacleAnimationFrame]
            )

        end
    end

    -- EXPLOSION ANIMATION
    if explosionActive then

        explosionTimer += 1

        if explosionTimer >= explosionAnimationDelay then

            explosionTimer = 0
            explosionFrame += 1

            if explosionFrame > #explosionImages then

                -- animation finished
                explosionActive = false
                explosionFrame = 1
                explosionTimer = 0

                explosionSprite:setVisible(false)

            else

                explosionSprite:setImage(
                    explosionImages[explosionFrame]
                )
            end
        end
    end
end

-- DESTROY
function Obstacle.destroy()

    local obstacle = obstacleSprite[obstacleNext]

    if obstacle then

        -- put explosion where the obstacle was
        local x, y =
            obstacle:getPosition()

        explosionSprite:moveTo(
            x,
            y
        )

        explosionFrame = 1
        explosionTimer = 0
        explosionActive = true

        explosionSprite:setImage(
            explosionImages[1]
        )

        explosionSprite:setVisible(true)

        obstacle:remove()

        obstacleNext += 1
    end
end

-- COLLISION
function Obstacle.checkCollision(
    trainSprite
)

    local collisions =
        trainSprite:overlappingSprites()

    for i, overlappingSprite in ipairs(collisions) do

        if overlappingSprite ==
            obstacleSprite[obstacleNext] then

            return true
        end
    end

    return false
end

-- DISTANCE
function Obstacle.getDistance()

     local obstacle =
        obstacleSprite[obstacleNext]

    if obstacle == nil then
        return nil
    end

    local x, y =
        obstacle:getPosition()

    return math.floor(x) - 400

end

-- LEVEL COMPLETE
function Obstacle.isLevelComplete()

    return obstacleNext > #obstacleSprite

end

function Obstacle.getNextID()

    return obstacleNext
end