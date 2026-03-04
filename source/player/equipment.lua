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

    if item == nil then
        return false
    end


    --TODO: THIS IS TEMPORARY COMMENTED OUT BECAUSE I NEED TO TEST IT!!

    --[[
    local type = itemIndex[item.item].typeI

    if not (type == "head" or type == "chestplate" or type == "backpack" or type == "ring") then
        return false
    end
    ]]


    --renderer.AABB(x, y, 1, 1, inventory.hitboxTable.start.x, inventory.hitboxTable.start.y, inventory.hitboxTable.length.x, inventory.hitboxTable.length.y)
    --print("?")
    for key, value in pairs(equipment.slots) do
        --print("!")
        --tables.writeTable(value)
        if renderer.AABB(x, y, 1, 1, value.startX, value.startY, value.pixelWidth, value.pixelHeight) then
            if value.equipment == "" and item.item ~= nil then
                value.equipment = item.item
                value.equipmentCount = item.count
                inventory.inventoryBar.itemOnCursor = {}
            elseif value.equipment ~= "" and item.item == nil then
                inventory.inventoryBar.itemOnCursor = {item = value.equipment, count = value.equipmentCount}
                value.equipment = ""
            elseif value.equipment ~= "" and item.item ~= nil then
                local itemOBJ = {item = value.equipment, count = value.equipmentCount or 1}
                value.equipment = item.item
                value.equipmentCount = item.count
                inventory.inventoryBar.itemOnCursor = itemOBJ
            end

            return false
        end
    end

    return false
end

return equipment