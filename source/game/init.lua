init = {}

function init.initAll() -- this fuctions for inits that have to start on the beggining (in love.load())
    --local player = require("source.game.player")
    player.init()

    --local spw = require("source.assets.sprites.spriteWorker")
    spw.init()

    biomeData.f.init()

    entitySpawner.func.init()

    entitiesIndex.f.init()

    map.f.init()

    inventory.functions.init()

    crafting.f.init()
end

return init