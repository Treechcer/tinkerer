biomeData = {
    f = {},
    chunkNames = {"grass", "sand", "void", "snow", "hill"}
}

function biomeData.f.init()
    biomeData.grass = {
        spawns = { "rock", "tree", --[["smallRock"]] },
        sprite = spriteWorker.sprites.grass.sprs
    }

    biomeData.sand = {
        spawns = { "rock", "tree", --[["smallRock"]] },
        sprite = spriteWorker.sprites.sand.sprs
    }

    biomeData.void = {
        spawns = { "rock", "tree", --[["smallRock"]] },
        sprite = spriteWorker.sprites.void.sprs
    }

    biomeData.snow = {
        spawns = { "rock", "tree", --[["smallRock"]] },
        sprite = spriteWorker.sprites.snow.sprs
    }

    biomeData.hill = {
        spawns = { "rock", "tree", --[["smallRock"]] },
        sprite = spriteWorker.sprites.hill.sprs
    }
end

return biomeData