import "CoreLibs/graphics"

local pd <const> = playdate
local gfx <const> = pd.graphics


--------------------------------------------------
-- COMBO SYSTEM
--------------------------------------------------

ComboSystem = {}


--------------------------------------------------
-- BUTTON IMAGES
--------------------------------------------------

local buttonImages = {

    A = gfx.image.new(
        "images/placeholder-point-a"
    ),

    B = gfx.image.new(
        "images/placeholder-point-b"
    ),

    UP = gfx.image.new(
        "images/Arrow-up"
    ),

    DOWN = gfx.image.new(
        "images/Arrow-down"
    ),

    LEFT = gfx.image.new(
        "images/Arrow-left"
    ),

    RIGHT = gfx.image.new(
        "images/Arrow-right"
    )
}


--------------------------------------------------
-- AVAILABLE INPUTS
--------------------------------------------------

local possibleButtons = {
    "A",
    "B",
    "UP",
    "DOWN",
    "LEFT",
    "RIGHT"
}


--------------------------------------------------
-- DIFFICULTY
--------------------------------------------------

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


--------------------------------------------------
-- STATE
--------------------------------------------------

local currentCombo = {}

local comboProgress = 1

local wallsCleared = 0

local comboActive = false


--------------------------------------------------
-- GET CURRENT COMBO LENGTH
--------------------------------------------------

local function getComboLength()

    local comboLength =
        difficultyLevels[1].comboLength

    for _, level in ipairs(difficultyLevels) do

        if wallsCleared >= level.minWalls then

            comboLength =
                level.comboLength

        end
    end

    return comboLength
end


--------------------------------------------------
-- GENERATE COMBO
--------------------------------------------------

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
end


--------------------------------------------------
-- START A NEW WALL
--------------------------------------------------

function ComboSystem.startWall()

    generateCombo()

    comboActive = true

end


--------------------------------------------------
-- GET PLAYER INPUT
--------------------------------------------------

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


--------------------------------------------------
-- UPDATE COMBO
--
-- Returns TRUE when the player successfully
-- finishes the whole combo.
--------------------------------------------------

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


    --------------------------------------------------
    -- CORRECT INPUT
    --------------------------------------------------

    if input == expectedButton then

        comboProgress += 1


        --------------------------------------------------
        -- WHOLE COMBO COMPLETE
        --------------------------------------------------

        if comboProgress > #currentCombo then

            comboActive = false

            wallsCleared += 1

            return true
        end


    --------------------------------------------------
    -- WRONG INPUT
    --------------------------------------------------

    else

        comboProgress = 1

    end


    return false
end


--------------------------------------------------
-- WALL FAILED / COLLISION
--------------------------------------------------

function ComboSystem.failWall()

    -- Collision does NOT count as clearing a wall.
    -- Simply generate a new combo for the next wall.

    ComboSystem.startWall()

end


--------------------------------------------------
-- DRAW COMBO
--------------------------------------------------

function ComboSystem.draw()

    if not comboActive then
        return
    end


    local spacing = 8

    local totalWidth = 0


    --------------------------------------------------
    -- Calculate total width of REMAINING icons
    --------------------------------------------------

    for i = comboProgress, #currentCombo do

        local image =
            buttonImages[currentCombo[i]]

        if image then

            local width, height =
                image:getSize()

            totalWidth += width

            if i < #currentCombo then
                totalWidth += spacing
            end
        end
    end


    --------------------------------------------------
    -- Center combo on screen
    --------------------------------------------------

    local currentX =
        (400 - totalWidth) / 2

    local y = 215


    --------------------------------------------------
    -- Only draw inputs that haven't been completed
    --------------------------------------------------

    for i = comboProgress, #currentCombo do

        local image =
            buttonImages[currentCombo[i]]

        if image then

            local width, height =
                image:getSize()

            image:drawAnchored(
                currentX + width / 2,
                y,
                0.5,
                0.5
            )

            currentX +=
                width + spacing
        end
    end
end


--------------------------------------------------
-- OPTIONAL DEBUG INFO
--------------------------------------------------

function ComboSystem.getWallsCleared()

    return wallsCleared

end