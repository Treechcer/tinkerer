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
    itemInteraction = require("source.items.itemInteraction")
    itemIndex = require("source.items.itemIndex")
    entitySpawner = require("source.entities.entitySpawner")
    tables = require("source.workers.tableWorker")
    --bit.addBit({bit.BIT1, bit.BIT16, bit.BIT32})

    init.initAll()
end

function love.draw()

    love.graphics.print(player.position.chunkX, 10, 10)
    love.graphics.print(player.position.chunkY, 10, 25)
    love.graphics.print(#entities.ents, 10, 40)
    if game.state == "game" then
        renderer.gameStateRenderer()
    end
end

function love.update(dt)
    REF.everyFrameStart(dt)
    
    REF.everyFrameEnd(dt)
end

function love.wheelmoved(x, y)
    if y >= 1 and (inventory.hotBar.lastTime >= inventory.hotBar.coolDown) and not (inventory.hotBar.selectedItem >= inventory.hotBar.maxItems) then
        inventory.hotBar.selectedItem = inventory.hotBar.selectedItem + 1
        inventory.hotBar.lastTime = 0
    end
    if y <= -1 and (inventory.hotBar.lastTime >= inventory.hotBar.coolDown) and not (inventory.hotBar.selectedItem <= 1) then
        inventory.hotBar.selectedItem = inventory.hotBar.selectedItem - 1
        inventory.hotBar.lastTime = 0
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    itemInteraction.breakEntity()
end