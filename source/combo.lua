import "CoreLibs/graphics"

local pd <const> = playdate
local gfx <const> = pd.graphics

ComboSystem = {}

-- Button sprites

local buttonImages = {

    A =
        gfx.image.new(
            "images/button-a"
        ),

    B =
        gfx.image.new(
            "images/button-b"
        ),

    UP =
        gfx.image.new(
            "images/arrow-up"
        ),

    DOWN =
        gfx.image.new(
            "images/arrow-down"
        ),

    LEFT =
        gfx.image.new(
            "images/arrow-left"
        ),

    RIGHT =
        gfx.image.new(
            "images/arrow-right"
        )
}

-- Button POOLS FOR EACH LEVEL

local buttonPools = {

    -- Level 1: A/B only
    [1] = {
        "A",
        "B"
    },

    -- Level 2: D-pad only
    [2] = {
        "UP",
        "DOWN",
        "LEFT",
        "RIGHT"
    },

    -- Level 3: all buttons
    [3] = {
        "A",
        "B",
        "UP",
        "DOWN",
        "LEFT",
        "RIGHT"
    }

}


-- Current level
local currentLevel = 1


local possibleButtons = buttonPools[currentLevel]

-- Difficulty settings

local difficultyLevels = {

    {
        minWalls = 0,
        comboLength = 3
    },

    {
        minWalls = 4,
        comboLength = 4
    },

    {
        minWalls = 9,
        comboLength = 5
    }

}

-- Decide current combo length

local function getComboLength()

    local length =
        difficultyLevels[1].comboLength

    for _, level in ipairs(difficultyLevels) do

        if WallsCleared >= level.minWalls then

            length =
                level.comboLength

        end

    end

    return length
end

-- Generate random combo

local function generateCombo()

    CurrentCombo = {}

    local comboLength =
        getComboLength()

    -- Get the button pool for the current level
    local possibleButtons = buttonPools[currentLevel]

    if possibleButtons == nil then

        print("ERROR: No button pool for level " .. tostring(currentLevel))

        return
    end

    for i = 1, comboLength do

        local randomIndex =
            math.random(
                1,
                #possibleButtons
            )

        CurrentCombo[i] =
            possibleButtons[randomIndex]

    end

    ComboProgress = 1
    ComboActive = true

end

-- Set level

function ComboSystem.setLevel(level)

    if buttonPools[level] == nil then

        print("Invalid combo level: " .. tostring(level))

        return
    end

    currentLevel = level

end

-- Reset combo system
function ComboSystem.resetGame()

    WallsCleared = 0

    generateCombo()

end

-- Start combo for next wall

function ComboSystem.startWall()

    generateCombo()

end

-- Get button input

local function getPressedButton()

    if pd.buttonJustPressed(
        pd.kButtonA
    ) then

        return "A"

    end


    if pd.buttonJustPressed(
        pd.kButtonB
    ) then

        return "B"

    end


    if pd.buttonJustPressed(
        pd.kButtonUp
    ) then

        return "UP"

    end


    if pd.buttonJustPressed(
        pd.kButtonDown
    ) then

        return "DOWN"

    end


    if pd.buttonJustPressed(
        pd.kButtonLeft
    ) then

        return "LEFT"

    end


    if pd.buttonJustPressed(
        pd.kButtonRight
    ) then

        return "RIGHT"

    end


    return nil
end

-- UPDATE COMBO
-- Returns true when the entire combo has been completed successfully.

function ComboSystem.update()

    if not ComboActive or Obstacle.getDistance() > 0 then
        return false
    end

    local input =
        getPressedButton()

    if input == nil then
        return false
    end


    local expectedButton =
        CurrentCombo[ComboProgress]

    -- CORRECT INPUT

    if input == expectedButton then

        ComboProgress += 1

        -- COMBO COMPLETE

        if ComboProgress > #CurrentCombo then

            ComboActive = false

            WallsCleared += 1

            return true
        end

    -- WRONG INPUT

    else

        ComboProgress = 1

    end


    return false
end

-- FAILED

function ComboSystem.failWall()

    -- Does not increase wallsCleared.
    -- Simply gives the next wall a new combo.

    generateCombo()

end

-- Draw combo on screen

function ComboSystem.draw()

    if not ComboActive then
        return
    end


    local spacing = 50

    local remainingInputs =
        #CurrentCombo
        - ComboProgress
        + 1


    local totalWidth =
        (remainingInputs - 1)
        * spacing


    local startX =
        200 - totalWidth / 2


    local drawIndex = 0

    -- Draw buttons that have not already been entered correctly.

    for i = ComboProgress, #CurrentCombo do

        local button =
            CurrentCombo[i]

        local image =
            buttonImages[button]


        if image then

            local x =
                startX
                + drawIndex
                * spacing

            image:drawAnchored(
                x,
                210,
                0.5,
                0.5
            )

        end


        drawIndex += 1

    end
end


--------------------------------------------------
-- DEBUG / INFORMATION
--------------------------------------------------

function ComboSystem.getWallsCleared()

    return WallsCleared

end