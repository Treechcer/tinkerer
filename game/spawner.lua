map = require("game.map")
camera = require("game.camera")
spriteLoader = require("sprites.spriteLoader")
itemIdex = require("game.itemIndex")
mathLib = require("libraries.mathLib")

spawner = {
    objects = {},-- tables of tables, every table will be like : {x, y, sprite, metadata, h, w} -> metadata is additional data, it can be blank ('nil') or have something in, 
                 -- for example stone can have how much it gives XP when broken or how many stones drop etc.
                 -- x and y are tiles, every chunk is 9x9 and there are 7x7 chunks, so its 63x63 map I think?
    possibleSpawns = {
        -- x and y are always determined in the spawner function
        --30, 32, "rock", {hp = 5, drop = {count = 5, item = "rock"}, dmgType = "stoneDMG"}, false, true, 1, 1
        {
            sprite = "rock",
            metadata = {
                hp = 5,
                drop = {count = 5, item = "rock"},
                dmgType = "stoneDMG"
            },
            isInteractable = false,
            isSolid = true,
            h = 1,
            w = 1
        },
    },
    delays = {
        lastSpawn = 0,
        timeCD = 0.2,
    }
}

-- this is here because VS code was screaming at me (I should use this ngl)

---@param x integer
---@param y integer
---@param metadata table
---@param h integer?
---@param w integer?
function spawner.createObject(x, y, sprite, metadata, isInteractable, isSolid, h, w)
    spriteS = spriteLoader[sprite]
    h = h or spriteS:getHeight() / 16
    w = w or spriteS:getWidth() / 16
    table.insert(spawner.objects, {x = x, y = y, sprite = sprite, metadata = metadata, h = h, w = w, isInteractable = isInteractable, isSolid = isSolid})
end

function spawner.drawObjs(sprites)
    love.graphics.setColor(1,1,1)
    for index, value in ipairs(spawner.objects) do
        adjPos = camera.calculateZoom(value.x * map.blockSize, value.y * map.blockSize, map.blockSize, map.blockSize)
        love.graphics.draw(sprites[value.sprite], adjPos.x, adjPos.y, 0, (3 * value.w) / camera.zoom, (3 * value.h) / camera.zoom)
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
            --print(value.metadata.hp, damage)
            if value.metadata.hp <= 0 then
                spawner.breakStatus(spawner.objects[index])
                table.remove(spawner.objects, index)
            end
            break
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

function spawner.objCol(x, y, w, h)
    for _, obj in ipairs(spawner.objects) do
        if obj.isSolid and mathLib.AABBcol({x = x, y = y, width = w, height = h}, {x = obj.x * map.blockSize, y = obj.y * map.blockSize, width = obj.w * map.blockSize, height = obj.h * map.blockSize}) then
            return true
        end
    end
    return false
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

function spawner.spawnRandomObject()
    local x = math.random(1,63) - 1
    local y = math.random(1,63) - 1
    local obj = spawner.possibleSpawns[math.random(1, #spawner.possibleSpawns)]

    if map.isGround(x * map.blockSize, y * map.blockSize) then
        local metadata = mathLib.deepCopy(obj.metadata)

        if metadata.hp ~= nil then
            metadata.hp = metadata.hp + (math.random(0,3) - 1)
        end
        if metadata.drop ~= nil then
            metadata.drop.count = metadata.drop.count + (math.random(0,2) - 1)
        end

        spawner.createObject(x, y, obj.sprite, metadata, obj.isInteractable, obj.isSolid, obj.h, obj.w)
    end
end

return spawner