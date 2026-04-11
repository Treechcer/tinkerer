love = require("love")

function love.load()
    video = ""
    game = require("source.game.game")
    settings = require("source.game.settings")

    if game.os ~= "PSP" then
        love.graphics.setDefaultFilter("nearest", "nearest")
    elseif game.os == "PSP" then
        --idk the change, does like nothing
        love.graphics.setDefaultFilter(1)
    end
    math.randomseed(os.time())

    tables = require("source.workers.libs.tableWorker")

    console = require("source.game.console.console")
    debug = require("source.game.console.debug")
    spriteWorker = require("source.workers.spriteWorker")
    sounds = require("source.workers.soundWorker")
    shadows = require("source.graphics.effects.shadows")
    mathWorker = require("source.workers.libs.mathWorker")
    biomeData = require("source.world.biomeData")
    map = require("source.world.map")
    skills = require("source.player.skilling.skillMain")
    skillsUI = require("source.player.skilling.skillUI")
    player = require("source.player.player")
    playerEntityInteractivity = require("source.player.interactivity.entityInteractivity")
    building = require("source.player.interactivity.building")
    renderer = require("source.graphics.renderer")
    init = require("source.game.init")
    bit = require("source.workers.libs.bit")
    entities = require("source.entities.entities")
    entitiesIndex = require("source.entities.entitiesIndex")
    itemIndex = require("source.player.items.itemIndex")
    description = require("source.player.items.description")
    inventory = require("source.player.items.inventory")
    itemInteraction = require("source.player.items.itemInteraction")
    entitySpawner = require("source.entities.entitySpawner")
    UI = require("source.graphics.UI")
    entityCleaner = require("source.entities.entityCleaner")
    recipes = require("source.player.crafting.recipes")
    crafting = require("source.player.crafting.crafting")
    equipment = require("source.player.equipment")
    pathfinding = require("source.entities.npc.pathfinding")
    specialAnimations = require("source.graphics.effects.specialAniamtions")
    npcs = require("source.entities.npc.npcs")
    npcIndex = require("source.entities.npc.npcIndex")
    specialDraws = require("source.graphics.effects.specialDraws")
    dropppedItems = require("source.entities.dropppedItems.droppedItems")
    --bit.addBit({bit.BIT1, bit.BIT16, bit.BIT32})

    init.initAll()

    require("source/workers/changeFunctionsByOS")
    REF = require("source.game.runEveryFrame")

    --tables.writeTable(map.map.chunks)
    require("source.workers.override")

    droppedItems.f.create(player.position.tileX, player.position.tileY, "rock", 5)
end

function love.draw()
    love.graphics.setBackgroundColor(28 / 255, 163 / 255, 236 / 255)

    love.graphics.setColor(1,1,1)
    if game.state == "game" then
        renderer.gameStateRenderer()
    end

    --for key, value in pairs(npcs.npcIndexes) do
    --    local path = entities.ents[value.index].path
    --    if path ~= nil and path ~= {} then
    --        pathfinding.functions.visualisePath(path)
    --    end
    --end

    --map.f.accesibleTile(player.cursor.tileX, player.cursor.tileY)

    --FONT TEST

    --love.graphics.print("the quick brown fox jumps over the lazy dog '", 10, 10)
    --love.graphics.print("THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG ✓⨻⨺", 10, 30)
    --love.graphics.print(mathWorker.getAngle(game.width / 2, game.height / 2, love.mouse.getPosition()), 10, 10)
end

function love.update(dt)
    REF.everyFrameStart(dt)

    REF.everyFrameEnd(dt)
end

function love.wheelmoved(x, y)
    if y >= 1 and (inventory.hotBar.lastTime >= inventory.hotBar.coolDown) and not (inventory.hotBar.selectedItem >= inventory.hotBar.maxItems) and not (inventory.hotBar.selectedItem > 9) then
        inventory.hotBar.selectedItem = inventory.hotBar.selectedItem + 1
        inventory.hotBar.lastTime = 0
    elseif y >= 1 and (inventory.hotBar.lastTime >= inventory.hotBar.coolDown) then
        inventory.hotBar.selectedItem = 1
        inventory.hotBar.lastTime = 0
    end
    if y <= -1 and (inventory.hotBar.lastTime >= inventory.hotBar.coolDown) and not (inventory.hotBar.selectedItem <= 1) then
        inventory.hotBar.selectedItem = inventory.hotBar.selectedItem - 1
        inventory.hotBar.lastTime = 0
    elseif y <= -1 and (inventory.hotBar.lastTime >= inventory.hotBar.coolDown) then
        inventory.hotBar.selectedItem = inventory.hotBar.maxItems
        inventory.hotBar.lastTime = 0
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        if crafting.f.checkIfOnButton(game.activeUIButtons, x, y) then
            return
        end

        if inventory.functions.click(button) ~= false then
            return
        end
        
        if itemInteraction.breakEntity() ~= false then
            return
        end

        if map.f.buyIsland(player.cursor.chunkX, player.cursor.chunkY) ~= false then
            return
        end
    elseif button == 2 then
        if inventory.functions.click(button) then
            return
        end

        if map.f.accesibleTile(player.cursor.tileX, player.cursor.tileX) and building.f.canBuild(inventory.inventoryBar.inventory[#inventory.inventoryBar.inventory][inventory.hotBar.selectedItem].item) then
            local i = inventory.inventoryBar.inventory
            local itemName = i[#i][inventory.hotBar.selectedItem].item
            if itemName ~= nil then
                if itemIndex[itemName].buildable then
                    local enData = entitiesIndex[itemName]
                    local res = building.f.build(player.cursor.tileX, player.cursor.tileY, enData.width, enData.height, itemName)

                    if res then
                        local it = i[#i][inventory.hotBar.selectedItem]
                        it.count = it.count - 1
                        if it.count <= 0 then
                            i[#i][inventory.hotBar.selectedItem] = {}
                        end

                        return
                    end
                end
            end
        end
    end
end

function love.keypressed(key, scancode, isrepeat)
    --print(key)
    if console.render then
        if key == "return" or key == "kpenter" then
            console.render = false
            if console.currentType == "" then
                return
            end
            console.f.addMessage(console.currentType)
            if string.sub(console.currentType, 1, 1) == "/" then
                console.f.runCommand(console.currentType)
            end
            console.currentType = ""
        elseif key == "escape" then
            console.currentType = ""
            console.render = false
        else
            if key == "space" then
                console.currentType = console.currentType .. " "
            elseif key == "backspace" then
                console.currentType = string.sub(console.currentType, 1, string.len(console.currentType) - 1)
            elseif key:match("kp") then --peak lua programming lol -- awful difference between gmatch and match
                --no way of telling if numlock is on / off in love 11.5., when 12.0. releases I'll instantly change it smh (it's the same with capslock)
                console.currentType = console.currentType .. key:gsub("kp", "")
            elseif string.len(key) > 1 then
                return
            else
                if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
                    key = key:upper()
                end
                console.currentType = console.currentType .. key
            end
        end
    end
end