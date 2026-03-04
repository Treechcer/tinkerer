equipment = {
    vals = {
        blockSize = 75, -- temporary value maybe? depends how will it work with invenotory and stuff
        order = {"head", "chestplate", "backpack", "ring"}
    },
    slots = {
        head = {
            equipment = ""
        },
        chestplate = {
            equipment = ""
        },
        backpack = {
            equipment = ""
        },
        ring = {
            equipment = ""
        },
        --necklace = {} --I think 3 is enough, but MAYBE necklace if 3 is too little?
    },
    f = {}
}

function equipment.f.init()
    for key, value in pairs(equipment.slots) do
        local button = equipment.slots[key]
        button.startX = inventory.hitboxTable.start.x - (equipment.vals.blockSize * 1.50)
        button.rotation = 0
        button.orginPointX = 0
        button.orginPointY = 0
        button.scaleWidth = equipment.vals.blockSize / 16
        button.scaleHeight = equipment.vals.blockSize / 16
        button.pixelWidth = 16 * button.scaleWidth
        button.pixelHeight = 16 * button.scaleHeight
    end

    local y = inventory.hitboxTable.start.y

    equipment.slots["head"].startY = y
    equipment.slots["chestplate"].startY = y + (equipment.vals.blockSize * 1.25)
    equipment.slots["backpack"].startY = equipment.slots["chestplate"].startY + (equipment.vals.blockSize * 1.25)
    equipment.slots["ring"].startY = equipment.slots["backpack"].startY + (equipment.vals.blockSize * 1.25)
end

function equipment.f.render()
    for key, value in pairs(equipment.vals.order) do
        --print(value.startY)
        local slot = equipment.slots[value]
        love.graphics.rectangle("fill", slot.startX, slot.startY, slot.pixelWidth, slot.pixelHeight)
        if slot.equipment == "" then
            local spr = spw.sprites[value]
            love.graphics.draw(spr.sprs, slot.startX, slot.startY, 0, slot.scaleWidth, slot.scaleHeight)
        else
            local spr = spw.sprites[slot.equipment]
            love.graphics.draw(spr.sprs, slot.startX, slot.startY, 0, slot.scaleWidth, slot.scaleHeight)
        end
    end
end

function equipment.f.checkClick(x,y,button)
    local item = inventory.inventoryBar.itemOnCursor

    local type = itemIndex[item.item]

    if type ~= nil then
        type = type.typeI

        if not (type == "head" or type == "chestplate" or type == "backpack" or type == "ring") then
            return false
        end
    end

    --renderer.AABB(x, y, 1, 1, inventory.hitboxTable.start.x, inventory.hitboxTable.start.y, inventory.hitboxTable.length.x, inventory.hitboxTable.length.y)
    --print("?")
    for key, value in pairs(equipment.slots) do
        --print("!")
        --tables.writeTable(value)
        if renderer.AABB(x, y, 1, 1, value.startX, value.startY, value.pixelWidth, value.pixelHeight) then
            if type ~= nil then
                if key ~= type then
                    return false
                end
            end
            
            local r = false
            if value.equipment == "" and item.item ~= nil then
                value.equipment = item.item
                value.equipmentCount = item.count
                inventory.inventoryBar.itemOnCursor = {}
                r = true
            elseif value.equipment ~= "" and item.item == nil then
                inventory.inventoryBar.itemOnCursor = {item = value.equipment, count = value.equipmentCount}
                value.equipment = ""
                r = true
            elseif value.equipment ~= "" and item.item ~= nil then
                local itemOBJ = {item = value.equipment, count = value.equipmentCount or 1}
                value.equipment = item.item
                value.equipmentCount = item.count
                inventory.inventoryBar.itemOnCursor = itemOBJ
                r = true
            end

            equipment.f.addStats()
            inventory.functions.expandInventory()

            return r
        end
    end

    return false
end

function equipment.f.addStats()
    equipment.f.makeDefaultStats()

    for key, value in pairs(equipment.slots) do
        --tables.writeTable(value)
        if value.equipment ~= "" then
            --print(value.equipment)
            for key0, value0 in pairs(itemIndex[value.equipment].equipmentStats) do
                --print("equipment.f[",key0,"]")
                equipment.f[key0](value0)
            end
        end
    end

    inventory.functions.fillHitBoxTable()
end

function equipment.f.makeDefaultStats()
    inventory.inventoryBar.maxItemsPerInventory = player.startingStats.maxItemsPerInventory
    inventory.inventoryBar.inventoryRows = player.startingStats.inventoryRows
    inventory.hotBar.maxItems = player.startingStats.maxItems

    inventory.functions.fillHitBoxTable()
    inventory.functions.expandInventory()
end

function equipment.f.maxItemsPerInventory(a)
    inventory.inventoryBar.maxItemsPerInventory = inventory.inventoryBar.maxItemsPerInventory + a
end

function equipment.f.maxItems(a)
    inventory.hotBar.maxItems = inventory.hotBar.maxItems + a
end

function equipment.f.inventoryRows(a)
    inventory.inventoryBar.inventoryRows = inventory.inventoryBar.inventoryRows + a
end


return equipment