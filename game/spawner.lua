map = require("game.map")
camera = require("game.camera")
spriteLoader = require("sprites.spriteLoader")
itemIdex = require("game.itemIndex")
mathLib = require("libraries.mathLib")

spawner = {
    objects = {}-- tables of tables, every table will be like : {x, y, sprite, metadata, h, w} -> metadata is additional data, it can be blank ('nil') or have something in, 
                -- for example stone can have how much it gives XP when broken or how many stones drop etc.
                -- x and y are tiles, every chunk is 9x9 and there are 7x7 chunks, so its 63x63 map I think?
}

-- this is here because VS code was screaming at me (I should use this ngl)

---@param x integer
---@param y integer
---@param metadata table
---@param h integer?
---@param w integer?
function spawner.createObject(x, y, sprite, metadata, h, w)
    spriteS = spriteLoader[sprite]
    h = h or spriteS:getHeight() / 16
    w = w or spriteS:getWidth() / 16
    table.insert(spawner.objects, {x = x, y = y, sprite = sprite, metadata = metadata, h = h, w = w})
end

function spawner.drawObjs(sprites)
    love.graphics.setColor(1,1,1)
    for index, value in ipairs(spawner.objects) do
        adjPos = camera.calculateZoom(value.x * map.blockSize, value.y * map.blockSize, map.blockSize, map.blockSize)
        love.graphics.draw(sprites[value.sprite], adjPos.x, adjPos.y, 0, (3 * value.h) / camera.zoom, (3 * value.w) / camera.zoom)
    end
end

function spawner.checkCollision(x, y)
    for index, value in ipairs(spawner.objects) do
        if mathLib.AABBcol({x = x, y = y, width = player.cursorPos.width, height = player.cursorPos.height}, {x = value.x, y = value.y, height = value.h, width = value.w}) then
            return true
        end
    end

    return false
end

---@param x integer
---@param y integer
---@param damage integer?
function spawner.damgeObejct(x, y, damage)
    damage = damage or 1
    for index, value in ipairs(spawner.objects) do
        if mathLib.AABBcol({x = x, y = y, width = player.cursorPos.width, height = player.cursorPos.height}, {x = value.x, y = value.y, height = value.h, width = value.w}) then
            value.metadata.hp = value.metadata.hp - damage
            if value.metadata.hp <= 0 then
                spawner.breakStatus(spawner.objects[index])
                table.remove(spawner.objects, index)
            end
        end
    end
end

function spawner.breakStatus(object)
    if object.metadata.drop ~= nil then
        player.addItemToInventory(object.metadata.drop.item, math.ceil(object.metadata.drop.count * (itemIdex[player.inventory.currentEquip]["bonusDrop"])))
    end
end

function spawner.getObject(x, y)
    for index, value in ipairs(spawner.objects) do
        if mathLib.AABBcol({x = x, y = y, width = player.cursorPos.width, height = player.cursorPos.height}, {x = value.x, y = value.y, height = value.h, width = value.w}) then
            return spawner.objects[index]
        end
    end
end

function spawner.getDmgType(x, y)
    local item = spawner.getObject(x, y)

    if item == nil then
        return
    end

    return item.metadata.dmgType
end

function spawner.getDmgNum(x,y)
    local success, dmg = pcall(function()
        return itemIdex[player.inventory.currentEquip][spawner.getDmgType(x,y)]
    end)
    if success then
        return dmg
    else
        return 0
    end
end

return spawner