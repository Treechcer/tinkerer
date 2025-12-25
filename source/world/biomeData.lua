biomeData = {
    f = {},
    chunkNames = {"grass", "sand", "void", "snow", "hill"}
}

function biomeData.f.init()
    biomeData.grass = {
        spawns = { "rock" },
        sprite = spriteWorker.sprites.grass.sprs
    }

    biomeData.sand = {
        spawns = { "rock" },
        sprite = spriteWorker.sprites.sand.sprs
    }

    biomeData.void = {
        spawns = { "rock" },
        sprite = spriteWorker.sprites.void.sprs
    }

    biomeData.snow = {
        spawns = { "rock" },
        sprite = spriteWorker.sprites.snow.sprs
    }

    biomeData.hill = {
        spawns = { "rock" },
        sprite = spriteWorker.sprites.hill.sprs
    }
end

return biomeData