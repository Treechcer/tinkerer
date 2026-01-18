love = require("love")

function love.load()
    game = require("source.game.game")

    if game.os ~= "PSP" then
        love.graphics.setDefaultFilter("nearest", "nearest")
    elseif game.os == "PSP" then
        --idk the change, does like nothing
        love.graphics.setDefaultFilter(1)
    end
    math.randomseed(os.time())

    biomeData = require("source.world.biomeData")
    map = require("source.world.map")
    skills = require("source.player.skilling.skillMain")
    player = require("source.player.player")
    renderer = require("source.graphics.renderer")
    init = require("source.game.init")
    vectors = require("source.graphics.vectors")
    bit = require("source.workers.libs.bit")
    entities = require("source.entities.entities")
    entitiesIndex = require("source.entities.entitiesIndex")
    settings = require("source.game.settings")
    spriteWorker = require("source.workers.spriteWorker")
    inventory = require("source.player.items.inventory")
    itemInteraction = require("source.player.items.itemInteraction")
    itemIndex = require("source.player.items.itemIndex")
    entitySpawner = require("source.entities.entitySpawner")
    tables = require("source.workers.libs.tableWorker")
    UI = require("source.graphics.UI")
    --bit.addBit({bit.BIT1, bit.BIT16, bit.BIT32})

    init.initAll()

    require("source/workers/changeFunctionsByOS")
    REF = require("source.game.runEveryFrame")
end

function love.draw()
    love.graphics.setColor(1,1,1)
    if game.state == "game" then
        renderer.gameStateRenderer()
    end
    --love.graphics.print(player.position.chunkX, 10, 10)
    --love.graphics.print(player.position.chunkY, 10, 25)
    --love.graphics.print(#entities.ents, 10, 40)
    --love.graphics.print(love.timer.getFPS(), 50, 50)
    --love.graphics.print(player.cursor.screenSide, 10, 65)

    love.graphics.print(player.skills.walking.xp, 10, 10)
    love.graphics.print(player.skills.walking.xpForNextLvl, 10, 25)
    love.graphics.print(player.skills.walking.lvl, 10, 40)
    love.graphics.print(player.atributes.speed, 10, 65)
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
    if button == 1 then
        if inventory.functions.click(button) then
            return
        end
        
        if itemInteraction.breakEntity() ~= false then
            return
        end

        if map.f.buyIsland(player.cursor.chunkX, player.cursor.chunkY) then
            return
        end
    elseif button == 2 then
        if inventory.functions.click(button) then
            return
        end
    end
end