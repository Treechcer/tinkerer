equipment = {
    vals = {
        blockSize = 75 -- temporary value maybe? depends how will it work with invenotory and stuff
    },
    slots = {
        head = {},
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

    local y = inventory.hitboxTable.endPos.y + 25 - (inventory.inventoryBar.blockSize * 2.5) - (equipment.vals.blockSize / 3)

    equipment.slots["head"].startY = y - (equipment.vals.blockSize * 1.25)
    equipment.slots["backpack"].startY = y
    equipment.slots["ring"].startY = y + (equipment.vals.blockSize * 1.25)
end

function equipment.f.render()
    for key, value in pairs(equipment.slots) do
        --print(value.startY)
        love.graphics.rectangle("fill", value.startX, value.startY, value.pixelWidth, value.pixelHeight)
    end
end

return equipment