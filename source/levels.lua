
local currentLevel = nil

-- Very easily modifiable very nice

Level = {
    [1] = {
        obstacles = { 20, 30, 5, 5, 10, 10, 30, 5 },
        time = 90,
    },
    [2] = {
        obstacles = { 20, 10, 10, 20, 5, 5, 5, 10, 10, 30, 5, 10, 5 },
        time = 120,
    },
    [3] = {
        obstacles = { 20, 5, 5, 10, 10, 5, 10, 20, 10, 5, 10, 15, 15, 5, 5, 20, 10, 5 },
        time = 160,
    }
}

-- Don't worry about this

for i, level in ipairs(Level) do
    local sum = 0
    for j, obstacle in pairs(level.obstacles) do
        sum = sum + obstacle
    end
    level.distance = sum
end

-- Setters and getters

function Level.setLevel(n)
   currentLevel = n
end

function Level.current()
    return Level[currentLevel]
end