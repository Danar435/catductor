local pd = playdate

local currentLevel = nil
local scores = pd.datastore.read()

-- Very easily modifiable very nice

Level = {
    [1] = {
        combo = { "A", "B" },
        obstacles = { 20, 30, 5, 5, 10, 10, 30, 5 },
        time = 90,
    },
    [2] = {
        combo = { "UP", "DOWN", "LEFT", "RIGHT" },
        obstacles = { 20, 10, 10, 20, 5, 5, 5, 10, 10, 30, 5, 10, 5 },
        time = 120,
    },
    [3] = {
        combo = { "A", "B", "UP", "DOWN", "LEFT", "RIGHT" },
        obstacles = { 20, 5, 5, 10, 10, 5, 10, 20, 10, 5, 10, 15, 15, 5, 5, 20, 10, 5 },
        time = 160,
    },
    [4] = {
        combo = { "A" },
        obstacles = { 20, 10, 5 },
        time = 30,
    }
}

-- Don't worry about this

if scores == nil then
    scores = {}
    pd.datastore.write(scores)
end

for i, level in ipairs(Level) do
    local sum = 0
    for j, obstacle in pairs(level.obstacles) do
        sum = sum + obstacle
    end
    level.distance = sum
    level.id = i
    level.score = scores[i]
end

-- Setters and getters

function Level.setLevel(n)
   currentLevel = n
end

function Level.current()
    return Level[currentLevel]
end

function Level.saveScore(time)
    Level[currentLevel].score = time
    scores[currentLevel] = time
    pd.datastore.write(scores)
end