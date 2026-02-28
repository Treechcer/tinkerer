biomeData = {
    f = {},
    chunkNames = {"grass", "sand", "void", "snow", "hill"}
}

function biomeData.f.init()
    biomeData.grass = {
        spawns = { "rock", "tree", "pebble", "iron_ore" },
        sprite = spriteWorker.sprites.grass.sprs
    }

    biomeData.sand = {
        spawns = { "rock", "tree", },
        sprite = spriteWorker.sprites.sand.sprs
    }

    biomeData.void = {
        spawns = { "rock", "tree", },
        sprite = spriteWorker.sprites.void.sprs
    }

    biomeData.snow = {
        spawns = { "rock", "tree", },
        sprite = spriteWorker.sprites.snow.sprs
    }

    biomeData.hill = {
        spawns = { "rock", "tree", },
        sprite = spriteWorker.sprites.hill.sprs
    }
end

return biomeData