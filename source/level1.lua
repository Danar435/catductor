import "CoreLibs/graphics"

local pd <const> = playdate
local gfx <const> = pd.graphics

local obstacles = { 20, 10, 10, 20, 5, 5, 5, 10, 10, 30, 5, 10, 5, 10 }
local time = 100

local function sumDistance(obstacles)
    local sum = 0
    for  i, obstacle in ipairs(obstacles) do
        sum = sum + obstacle
    end
    return sum
end

Level1 = {
    
    obstacles = obstacles,
    distance = sumDistance(obstacles),
    time = time

}

