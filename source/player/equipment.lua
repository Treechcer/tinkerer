equipment = {
    vals = {
        blockSize = 75, -- temporary value maybe? depends how will it work with invenotory and stuff
        order = {"head", "chestplate", "backpack", "ring"}
    },
    slots = {
        head = {},
        chestplate = {},
        backpack = {},
        ring = {},
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
        local spr = spw.sprites[value]
        if spr ~= nil then
            love.graphics.draw(spr.sprs, slot.startX, slot.startY, 0, slot.scaleWidth, slot.scaleHeight)
        end
    end
end

return equipment