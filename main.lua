love = require("love")

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")

    player = require("source.game.player")
    map = require("source.world.map")
    REF = require("source.game.runEveryFrame")
    renderer = require("source.graphics.renderer")
    game = require("source.game.game")
    init = require("source.game.init")
    vectors = require("source.graphics.vectors")
    bit = require("source.workers.bit")
    entities = require("source.entities.entities")
    entitiesIndex = require("source.entities.entitiesIndex")
    settings = require("source.game.settings")
    spriteWorker = require("source.assets.sprites.spriteWorker")
    inventory = require("source.items.inventory")
    --bit.addBit({bit.BIT1, bit.BIT16, bit.BIT32})

    init.initAll()
end

function love.draw()

    love.graphics.print(player.position.tileX, 10, 10)
    love.graphics.print(player.position.tileY, 10, 25)
    if game.state == "game" then
        renderer.gameStateRenderer()
    end
end

function love.update(dt)
    REF.everyFrameStart(dt)

    REF.everyFrameEnd(dt)
end