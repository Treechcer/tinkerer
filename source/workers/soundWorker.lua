sounds = {
    sounds = {

    },
    f = {

    }
}

local metatable = {
    __index = function (self, key)
        sounds.f.addSound(key, "sfx")
        return rawget(self, key)
    end
}

setmetatable(sounds.sounds, metatable)

function sounds.f.addSound(name, type, soundType)
    type = type or "sfx"
    soundType = soundType or "static"

    sounds.sounds[name] = {
        type = type,
        sound = love.audio.newSource("assets/sounds/" .. name .. ".wav", soundType)
    }

    sounds.sounds[name].sound:setVolume(settings.sound[type] / 100)
end

function sounds.f.playAudio(name) -- this automatically does everything needed, changes pitch etc.
    love.audio.play(sound.sounds[name].sound)
    sound.sounds[name].sound:setPitch(math.random(0.5, 1.5))
end

return sounds