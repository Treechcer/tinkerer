inventory = {
    hotBar = {
        maxItems = 4,
        items = {
            { item = "hammer", count = 1 },
            { item = "rock", count = 5 }
        },
        boxSize = 50, --pixels
        paddingBottom = 15,
        itemPad = 3,
        selectedItem = 1,
        lastTime = 0,
        coolDown = 0.2,
        numberPad = 15
    },
    inventoryBar = {

    },
    functions = {}
}

function inventory.functions.renderHotbar()
    love.graphics.setColor(1, 1, 1)
    local hotbar = inventory.hotBar
    local totalWidth = hotbar.maxItems * hotbar.boxSize
    local startX = (game.width - totalWidth) / 2
    local y = game.height - hotbar.boxSize - hotbar.paddingBottom

    for i = 1, hotbar.maxItems do
        love.graphics.rectangle("line", startX + (i - 1) * hotbar.boxSize, y, hotbar.boxSize, hotbar.boxSize)
        if hotbar.items[i] ~= nil then
            local spr = spw.sprites[hotbar.items[i].item].sprs
            love.graphics.draw(spr, startX + (i - 1) * hotbar.boxSize + hotbar.itemPad, y + hotbar.itemPad, 0,
                (hotbar.boxSize - hotbar.itemPad * 2) / spr:getWidth(),
                (hotbar.boxSize - hotbar.itemPad * 2) / spr:getHeight())
            love.graphics.print(math.floor(hotbar.items[i].count),
                startX + (i) * hotbar.boxSize - hotbar.numberPad,
                y + hotbar.boxSize - hotbar.numberPad)
        end
    end
end

function inventory.functions.update(dt)
    inventory.hotBar.lastTime = inventory.hotBar.lastTime + dt
end

function inventory.functions.addNewItem(item, count)
    if (inventory.hotBar.maxItems >= #inventory.hotBar.items) then
        table.insert(inventory.hotBar.items, {item = item, count = count})
    end
end

function inventory.functions.addItem(item, count)
    --print(item, count)
    for index, value in ipairs(inventory.hotBar.items) do
        if value.item == item then
            if itemIndex[item].maxStackSize < value.count + count then
                local overflow = (itemIndex[item].maxStackSize - (value.count + count)) * (-1)
                value.count = itemIndex[item].maxStackSize
                inventory.functions.addNewItem(item, overflow)
            else
                value.count = value.count + count
            end
            break
        end
    end
end

return inventory