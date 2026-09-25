local pd = playdate
local snd = playdate.sound

Sound = {}

local comboFail = snd.fileplayer.new("sounds/combo-mistake")
local combo  = {
    snd.fileplayer.new("sounds/combo1"),
    snd.fileplayer.new("sounds/combo2"),
    snd.fileplayer.new("sounds/combo3"),
    snd.fileplayer.new("sounds/combo4"),
    snd.fileplayer.new("sounds/combo5")
}
local steam  = {
    snd.fileplayer.new("sounds/steam1"),
    snd.fileplayer.new("sounds/steam2"),
    snd.fileplayer.new("sounds/steam3"),
    snd.fileplayer.new("sounds/steam4"),
    snd.fileplayer.new("sounds/steam5"),
    snd.fileplayer.new("sounds/steam6")
} 
local click  = snd.fileplayer.new("sounds/click")
local bgm = snd.fileplayer.new("sounds/bgm")
local explosion = snd.fileplayer.new("sounds/explosion")
local explosionTrain= snd.fileplayer.new("sounds/explosion-train")


local steamIndex = 2
local steamIndexPrevious = 2

function Sound.update()

    local trainSpeed = TrainSpeed.getSpeed()

    -- Not my proudest code
    if trainSpeed < 3 and steamIndex ~= 1 then
        steamIndex = 1
    elseif trainSpeed > 3 and trainSpeed < 6 and steamIndex ~= 2 then
        steamIndex = 2
    elseif trainSpeed > 6 and trainSpeed < 9 and steamIndex ~= 3 then
        steamIndex = 3
    elseif trainSpeed > 9 and trainSpeed < 12 and steamIndex ~= 4 then
        steamIndex = 4
    elseif trainSpeed > 12 and steamIndex ~= 5 then
        steamIndex = 5
    end

    if steamIndexPrevious ~= steamIndex then
        steamIndexPrevious = steamIndex
        steam[steamIndex]:stop()
        steam[steamIndex]:play()
    end

    
    if Obstacle.getDistance() > 0 then

        if pd.buttonJustPressed(pd.kButtonA)
        or pd.buttonJustPressed(pd.kButtonB)
        or pd.buttonJustPressed(pd.kButtonUp)
        or pd.buttonJustPressed(pd.kButtonDown)
        or pd.buttonJustPressed(pd.kButtonLeft)
        or pd.buttonJustPressed(pd.kButtonRight)
        then
            click:stop()
            click:play()
        end
        
    end
end

function Sound.playBGM()
    bgm:stop()
    bgm:play(0)
end

function Sound.stopBGM()
    bgm:stop()
end

function Sound.playCombo(n)
    local index = math.min(n, #combo)
    combo[index]:stop()
    combo[index]:play()
end

function Sound.playComboFail()
    comboFail:stop()
    comboFail:play()
end

function Sound.playExplosion()
    explosion:play()
end

function Sound.playExplosionTrain()
    explosionTrain:play()
end

function Sound.playStart()
    snd.fileplayer.new("sounds/1-2-meaw"):play()
end

function Sound.playVictory()
    snd.fileplayer.new("sounds/victory-sound"):play()
end

function Sound.playDefeat()
    snd.fileplayer.new("sounds/defeat-sound"):play()
end