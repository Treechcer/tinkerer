map = require("game.map")
game = require("game.game")
uiData = require("UI.uiData")

player = {
    x = 0,
    y = 0,
    width = 32,
    height = 64,
    speed = 300,
    cursorPos = {
        x = 0,
        y = 0,
        screenSite = -1,
        moveTo = -1,
        isBeingMoved = false,
        width = 1,
        height = 1,

        screenX = 0,
        screenY = 0,

        chunkX = 0,
        chunkY = 0
    },

    attack = {

    },

    mine = {
        cooldown = 0.40,
        lastMined = 1,
        damage = 1
    },

    inventory = {
        itemSwitchCD = 0.25,
        lastItemSwitch = 0.25,
        inventoryIndex = 1,
        currentEquip = "hammer",
        items = {
            {name = "hammer", quantity = "non-quantifiable"},
            {name = "furnace", quantity = 1},
            {name = "", quantity = 0},
            {name = "", quantity = 0},
            {name = "", quantity = 0},
            {name = "", quantity = 0},
            {name = "", quantity = 0},
            {name = "", quantity = 0},
            {name = "", quantity = 0},
            {name = "", quantity = 0}
        },
        hotbar = {
            
        },
        maxSlots = 10,
        handRad = 0
    },

    animation = {
        time = 0,
        timeToChangeCoe = 0,
        animLength = 0,
        coeficient = 1,
        play = false
    }
}

function player.init()
    local camera = require("game.camera")
    local map = require("game.map")

    player.x = (map.blockSize * ((#map.chunks * 9) - 5)) / 2 + 15
    player.y = (map.blockSize * ((#map.chunks * 9) - 5)) / 2 + 15
    camera.x = player.x + (player.width / 2)
    camera.y = player.y + (player.height / 2)
end

function player.cursor(sprites)
    local camera = require("game.camera")
    local map = require("game.map")
    local game = require("game.game")

    local x, y = love.mouse.getPosition()
    local temp = player.cursorPos.screenSite
    if x >= game.width / 2 and player.cursorPos.moveTo ~= 1 then 
        player.cursorPos.moveTo = 1
        actionDelay.stopPrematurely("playerItemMove")
        player.cursorPos.isBeingMoved = false
    elseif x <= game.width / 2 and player.cursorPos.moveTo ~= -1 then
        player.cursorPos.moveTo = -1
        actionDelay.stopPrematurely("playerItemMove")
        player.cursorPos.isBeingMoved = false
    end

    if player.cursorPos.moveTo ~= player.cursorPos.screenSite and not player.cursorPos.isBeingMoved then
        player.cursorPos.lastPlace = player.cursorPos.screenSite
        actionDelay.addDelay("playerItemMove", "incremental", function (dt, jump, ending)
            player.cursorPos.screenSite = player.cursorPos.screenSite + (8 * dt * player.cursorPos.moveTo)
            if ending or (player.cursorPos.screenSite >= 1 or player.cursorPos.screenSite <= -1 )then
                player.cursorPos.isBeingMoved = false
                player.cursorPos.screenSite = player.cursorPos.moveTo
            end
        end, 0.25, 0)
        player.cursorPos.isBeingMoved = true
    end

    local blockX, blockY = map.screenPosToBlock(x, y)

    player.cursorPos.screenX = x
    player.cursorPos.screenY = y

    local frame = math.floor(love.timer.getTime() * 7.5) % #sprites.cursor + 1

    local obj = map.getChunkPosXY(x * map.blockSize, y * map.blockSize)

    if not map.isChunkOwned(player.cursorPos.x * map.blockSize, player.cursorPos.y * map.blockSize) then
        player.cursorPos.width = 9
        player.cursorPos.height = 9
        blockX = blockX - (blockX % (9 * map.blockSize))
        blockY = blockY - (blockY % (9 * map.blockSize))

        local adjPos = camera.calculateZoom(blockX + (4.5 * map.blockSize), blockY + (4.5 * map.blockSize), map.blockSize, map.blockSize)
        love.graphics.print("E", adjPos.x - ((love.graphics.getFont():getWidth("E") * adjPos.width / love.graphics.getFont():getWidth("E")) / 2), adjPos.y - ((love.graphics.getFont():getHeight("E") * adjPos.height / love.graphics.getFont():getHeight("E")) / 2), 0, adjPos.width / love.graphics.getFont():getWidth("E"), adjPos.height / love.graphics.getFont():getHeight("E"))
    else
        player.cursorPos.width = 1
        player.cursorPos.height = 1
    end

    player.cursorPos.x = math.floor(blockX / map.blockSize)
    player.cursorPos.y = math.floor(blockY / map.blockSize)

    print(blockX, blockY)

    local adjPos = camera.calculateZoom(blockX, blockY, map.blockSize, map.blockSize)

    love.graphics.setColor(1,1,1)
    love.graphics.draw(sprites.cursor[frame], adjPos.x, adjPos.y, 0, adjPos.width / sprites.cursor[frame]:getWidth() * player.cursorPos.width, adjPos.height / sprites.cursor[frame]:getHeight() * player.cursorPos.height)

    player.cursorPos.chunkX = obj.x
    player.cursorPos.chunkY = obj.y
end

function player.cooldown(dt)
    player.mine.lastMined = player.mine.lastMined + dt
    player.inventory.lastItemSwitch = player.inventory.lastItemSwitch + dt
end

function player.drawItem(sprites)
    local map = require("game.map")
    -- magic numbers here are just to move it so it looks better, they're random ngl
    adjPos = camera.calculateZoom((player.x + player.width / 2) + (player.width) * player.cursorPos.screenSite, player.y + (player.height / 3), map.blockSize - 10, map.blockSize - 10)

    local item = player.inventory.currentEquip

    if item == "" then
        item = "rock"
    end

    --[[love.graphics.draw(sprites[item], adjPos.x, adjPos.y, player.inventory.handRad,
        adjPos.height / sprites[item]:getWidth() * player.cursorPos.screenSite,
        adjPos.width / sprites[item]:getHeight(),
        sprites[item]:getWidth() / 2,
        sprites[item]:getHeight() / 2
    )]]

    x, y = love.mouse.getPosition()

    local switch

    if player.cursorPos.screenSite == -1 then
        switch = math.pi
    else
        switch = 0
    end

    love.graphics.draw(sprites[item], adjPos.x, adjPos.y,
        math.atan2(y - adjPos.y, x - adjPos.x) + switch + player.inventory.handRad,
        adjPos.height / sprites[item]:getWidth() * player.cursorPos.screenSite,
        adjPos.width / sprites[item]:getHeight(),
        sprites[item]:getWidth() / 2,
        sprites[item]:getHeight() / 2
    )
end

function player.itemAnimation(dt)

    -- not working will do later

    player.animation.time = player.animation.time + dt
    player.inventory.handRad = player.inventory.handRad + 5 * dt * player.animation.coeficient * player.cursorPos.screenSite
    if player.animation.timeToChangeCoe <= player.animation.time then
        player.animation.coeficient = -1
    end

    -- -0.05 so it looks smoother because it doens't go 50 / 50 but like 55 / 45, with this it goes closer to 50 / 50 so it doesn't jump much
    if player.animation.time - 0.05 >= player.animation.timeToChangeCoe * 2 then
        player.animation.time = 0
        player.animation.timeToChangeCoe = 0
        player.animation.animLength = 0
        player.animation.coeficient = 1
        player.animation.play = false
        player.inventory.handRad = 0
    end
end

function player.drawInventory(sprites)
    love.graphics.setLineWidth(uiData.playerInventory.lineSize)
    local count = #player.inventory.items
    local slot = uiData.playerInventory.size
    local space = uiData.playerInventory.space

    local totalWidth = count * slot + (count - 1) * space

    local startX = (game.width - totalWidth) / 2


    for i, item in ipairs(player.inventory.items) do
        love.graphics.setColor(1,1,1)
        if i == player.inventory.inventoryIndex then
            love.graphics.setColor(1,0,0)
        end
        love.graphics.rectangle("line", startX + (i - 1) * (slot + space), game.height - game.height / 10, slot, slot)
        if sprites[item.name] ~= nil then
            love.graphics.setColor(1,1,1)
            love.graphics.draw(sprites[item.name], startX + (i - 1) * (slot + space), game.height - game.height / 10, 0, (slot / sprites[item.name]:getWidth()), (slot / sprites[item.name]:getHeight()))
            if item.quantity ~= "non-quantifiable" then
                love.graphics.setColor(0,0,0)
                love.graphics.print(item.quantity, startX + (i - 1) * (slot + space), game.height - game.height / 10)
                if item.quantity <= 0 then
                    player.inventory.items[player.inventory.inventoryIndex] = {name = "", quantity = 0}
                    player.inventory.currentEquip = ""
                end
            end
        end
    end
end

function player.addItemToInventory(item, quantity)
    for key, value in pairs(player.inventory.items) do
        if value.name == item then
            if value.quantity + quantity > 128 then
               value.quantity = 128
               quantity = (value.quantity + quantity) % 128
            else
                value.quantity = value.quantity + quantity
                return
            end
        end
    end
    local i = 1
    for key, value in pairs(player.inventory.items) do
        if value.name == "" and value.quantity == 0 then
            player.inventory.items[i] = {name = item, quantity = quantity}
            return
        end
        i = i + 1
    end
end

function player.createNewInventoryItem(item, quantity)
    local i = 1
    for key, value in pairs(player.inventory.items) do
        if value.name == "" and value.quantity == 0 then
            player.inventory.items[i] = {name = item, quantity = quantity}
            return
        end
        i = i + 1
    end
end


return player
