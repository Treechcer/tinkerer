map = require("game.map")
game = require("game.game")
uiData = require("UI.uiData")

player = {
    x = 0,
    y = 0,
    width = 32,
    height = 64,
    speed = 400,
    cursorPos = {
        x = 0,
        y = 0,
        screenSite = -1,
        moveTo = -1,
        isBeingMoved = false
    },

    attack = {

    },

    mine = {
        cooldown = 0.40,
        lastMined = 1,
        damage = 1
    },

    inventory = {
        currentEquip = "hammer",
        items = {
            "hammer",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            ""
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

    local adjPos = camera.calculateZoom(blockX, blockY, map.blockSize, map.blockSize)

    local frame = math.floor(love.timer.getTime() * 7.5) % #sprites.cursor + 1

    player.cursorPos.x = math.floor(blockX / map.blockSize)
    player.cursorPos.y = math.floor(blockY / map.blockSize)

    love.graphics.setColor(1,1,1)
    love.graphics.draw(sprites.cursor[frame], adjPos.x, adjPos.y, 0, adjPos.width / sprites.cursor[frame]:getWidth(), adjPos.height / sprites.cursor[frame]:getHeight())
end

function player.cooldown(dt)
    player.mine.lastMined = player.mine.lastMined + dt
end

function player.drawItem(sprites)
    local map = require("game.map")
    -- magic numbers here are just to move it so it looks better, they're random ngl
    adjPos = camera.calculateZoom((player.x + player.width / 2) + (player.width) * player.cursorPos.screenSite, player.y + (player.height / 3), map.blockSize - 10, map.blockSize - 10)

    love.graphics.draw(sprites[player.inventory.currentEquip], adjPos.x, adjPos.y, player.inventory.handRad,
        adjPos.height / sprites[player.inventory.currentEquip]:getWidth() * player.cursorPos.screenSite,
        adjPos.width / sprites[player.inventory.currentEquip]:getHeight(),
        sprites[player.inventory.currentEquip]:getWidth() / 2,
        sprites[player.inventory.currentEquip]:getHeight() / 2
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
        love.graphics.rectangle("line", startX + (i - 1) * (slot + space), game.height - game.height / 10, slot, slot)
        if sprites[item] ~= nil then
            love.graphics.draw(sprites[item], startX + (i - 1) * (slot + space), game.height - game.height / 10, 0, (slot / sprites[item]:getWidth()), (slot / sprites[item]:getHeight()))
        end
    end
end

return player