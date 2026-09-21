import "CoreLibs/graphics"

local pd <const> = playdate
local gfx <const> = pd.graphics

ComboSystem = {}

-- Button sprites

local buttonImages = {

    A =
        gfx.image.new(
            "images/placeholder-point-a"
        ),

    B =
        gfx.image.new(
            "images/placeholder-point-b"
        ),

    UP =
        gfx.image.new(
            "images/Arrow-up"
        ),

    DOWN =
        gfx.image.new(
            "images/Arrow-down"
        ),

    LEFT =
        gfx.image.new(
            "images/Arrow-left"
        ),

    RIGHT =
        gfx.image.new(
            "images/Arrow-right"
        )
}

-- Possible combo inputs

local possibleButtons = {
    "A",
    "B",
    "UP",
    "DOWN",
    "LEFT",
    "RIGHT"
}

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

        if wallsCleared >= level.minWalls then

            length =
                level.comboLength

        end

    end

    return length
end

-- Generate random combo

local function generateCombo()

    currentCombo = {}

    local comboLength =
        getComboLength()

    for i = 1, comboLength do

        local randomIndex =
            math.random(
                1,
                #possibleButtons
            )

        currentCombo[i] =
            possibleButtons[randomIndex]

    end

    comboProgress = 1

    comboActive = true

end

-- Reset combo system
function ComboSystem.resetGame()

    wallsCleared = 0

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

    if not comboActive then
        return false
    end

    local input =
        getPressedButton()

    if input == nil then
        return false
    end


    local expectedButton =
        currentCombo[comboProgress]

    -- CORRECT INPUT

    if input == expectedButton then

        comboProgress += 1

        -- COMBO COMPLETE

        if comboProgress > #currentCombo then

            comboActive = false

            wallsCleared += 1

            return true
        end

    -- WRONG INPUT

    else

        comboProgress = 1

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

    if not comboActive then
        return
    end


    local spacing = 50

    local remainingInputs =
        #currentCombo
        - comboProgress
        + 1


    local totalWidth =
        (remainingInputs - 1)
        * spacing


    local startX =
        200 - totalWidth / 2


    local drawIndex = 0

    -- Draw buttons that have not already been entered correctly.

    for i = comboProgress, #currentCombo do

        local button =
            currentCombo[i]

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

    return wallsCleared

end