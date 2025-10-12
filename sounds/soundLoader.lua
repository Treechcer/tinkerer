soundMaster = require("sounds.soundMaster")

soundLoader = {
    mainSounds = {

    },
    miscSounds = {
        hitSound = love.audio.newSource("sounds/hit.wav", "static")
    },
    dialogSounds = {

    },
    musicSounda = {

    }
}

function soundLoader.changeLoudness()
    for key, value in pairs(soundLoader.mainSounds) do
        value:setVolume(soundMaster.mainSounds)
    end

    for key, value in pairs(soundLoader.miscSounds) do
        value:setVolume(soundMaster.miscSounds)
    end

    for key, value in pairs(soundLoader.dialogSounds) do
        value:setVolume(soundMaster.dialogSounds)
    end

    for key, value in pairs(soundLoader.musicSounda) do
        value:setVolume(soundMaster.musicSounds)
    end
end

soundLoader.changeLoudness()

return soundLoader