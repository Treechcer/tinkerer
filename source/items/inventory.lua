inventory = {
    hotBar = {
        maxItems = 4,
        --items = {},
        boxSize = 50, --pixels
        paddingBottom = 15,
        itemPad = 3,
        selectedItem = 1,
        lastTime = 0,
        coolDown = 0.2,
        numberPad = 2,
        moveVal = 0,
        moveItem = false,
        moving = false
    },
    inventoryBar = {
        inventory = {
            {{item = "rock", count = 5},{},{},{},{}},
            {{item = "rock", count = 5},{},{},{},{}},
            {{item = "rock", count = 5},{},{},{},{}},
            {
                { item = "hammer", count = 1 },
                { item = "rock", count = 5 }
            },
        }, --this is sectioned into 4 x 4 inventory parts, the last one is hotbar but it kinda supports getting different sizes yk
        maxItemsPerInventory = 5, --this is except hotbar btw
        blockSize = game.width / 10,
        pad = game.width / 200,
        padText = 5,
        render = false,
        openCooldown = 0.25,
        lastOpened = 0,
        indexOnCursor = {},
    },
    itemsOutsideOfInventory = {
        coins = 999999999999,
    },
    hitboxTable = {},
    functions = {}
}

function inventory.functions.fillHitBoxTable()
    --I'm lazy writing the vars so I made this fuction lmao
    local i = inventory.inventoryBar.inventory
    local barI = inventory.inventoryBar

    local rows = #i - 1
    local cols = barI.maxItemsPerInventory
    local totalW = cols * barI.blockSize
    local totalH = rows * barI.blockSize

    inventory.hitboxTable = {
        start = {
            x = (game.width / 2) - (totalW / 2) + (barI.pad / 2),
            y = (game.height / 2) - (totalH / 2) + (barI.pad / 2)
        },
    }

    inventory.hitboxTable.endPos = {
        x = inventory.hitboxTable.start.x + cols * barI.blockSize,
        y = inventory.hitboxTable.start.y + rows * barI.blockSize
    }

    inventory.hitboxTable.length = {
        x = cols * barI.blockSize,
        y = rows * barI.blockSize
    }
end

function inventory.functions.click(dt)
    --PC ONLY!!

    if not inventory.inventoryBar.render then
        return
    end

    if love.mouse.isDown(1) then
        local x, y = love.mouse.getPosition()
        local posHit = renderer.AABB(x, y, 1, 1, inventory.hitboxTable.start.x, inventory.hitboxTable.start.y, inventory.hitboxTable.length.x, inventory.hitboxTable.length.y)
        
        local itemCol = math.floor((x - inventory.hitboxTable.start.x) / (inventory.inventoryBar.blockSize)) + 1
        local itemRow = math.floor((y - inventory.hitboxTable.start.y) / (inventory.inventoryBar.blockSize)) + 1
        
        if (itemCol == inventory.inventoryBar.indexOnCursor.col) and (itemRow == inventory.inventoryBar.indexOnCursor.row) then
            return
        end

        if posHit and next(inventory.inventoryBar.indexOnCursor) == nil then
            local item = inventory.inventoryBar.inventory[itemRow][itemCol]

            if item ~= nil and next(item) ~= nil then
                inventory.inventoryBar.indexOnCursor = {
                    row = itemRow,
                    col = itemCol
                }
            end
        elseif posHit and next(inventory.inventoryBar.indexOnCursor) ~= nil then
            local item = inventory.inventoryBar.inventory[itemRow][itemCol]

            local ind = inventory.inventoryBar.indexOnCursor

            if item == nil or next(item) == nil then
                inventory.inventoryBar.inventory[itemRow][itemCol] = inventory.inventoryBar.inventory[ind.row][ind.col]
                inventory.inventoryBar.inventory[ind.row][ind.col] = {}
                inventory.inventoryBar.indexOnCursor = {}
            else
                if item.item == inventory.inventoryBar.inventory[ind.row][ind.col].item then
                    item.count = item.count + inventory.inventoryBar.inventory[ind.row][ind.col].count
                    inventory.inventoryBar.inventory[ind.row][ind.col] = {}
                    inventory.inventoryBar.indexOnCursor = {}
                end
            end
        end
    end
end

function inventory.functions.renderWholeInventory()
    local i = inventory.inventoryBar.inventory
    local barI = inventory.inventoryBar

    local rows = #i - 1
    local cols = barI.maxItemsPerInventory
    local totalW = cols * barI.blockSize
    local totalH = rows * barI.blockSize
    local font = UI.fonts.normal

    love.graphics.setFont(font)
    for inventroyIndex = 1, rows, 1 do
        for itemIndex = 1, cols, 1 do
            love.graphics.setColor(0.8, 0.8, 0.8)
            local bl = barI.blockSize - barI.pad
            local xP = (game.width / 2) + ((itemIndex - 1) * barI.blockSize) - (totalW / 2) + (barI.pad / 2)
            local yP = (game.height / 2) + ((inventroyIndex - 1) * barI.blockSize) - (totalH / 2) + (barI.pad / 2)
            love.graphics.rectangle("fill", xP, yP, bl, bl)
            local indexItem = i[inventroyIndex][itemIndex]
            if indexItem ~= nil and next(indexItem) ~= nil then
                local item = indexItem.item
                local spr = spw.sprites[item].sprs
                love.graphics.draw(spr,xP, yP, 0, bl / spr:getHeight(), bl / spr:getWidth())
                love.graphics.setColor(1,1,1)
                local w = font:getWidth(indexItem.count)
                local h = font:getHeight()
                love.graphics.print(indexItem.count, xP + bl - w - barI.padText, yP + bl - h - barI.padText)
            end
        end
    end
end

function inventory.functions.renderHotbar()
    --TODO fix the number color and stuff not important rn
    local hotbar = inventory.hotBar
    local inv = inventory.inventoryBar.inventory
    local inventoryHB = inv[#inv]
    local totalWidth = hotbar.maxItems * hotbar.boxSize
    local startX = (game.width - totalWidth) / 2
    local y = game.height - hotbar.boxSize - hotbar.paddingBottom
    local font = UI.fonts.normal
    love.graphics.setFont(UI.fonts.normal)

    for i = 1, hotbar.maxItems do
        if (i == inventory.hotBar.selectedItem) then
            love.graphics.setColor(0.7, 0.5, 1)
        else
            love.graphics.setColor(0.8, 0.8, 0.8)
        end

        local blockX = startX + (i - 1) * hotbar.boxSize
        love.graphics.rectangle("fill", blockX, y, hotbar.boxSize, hotbar.boxSize)
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("line", blockX, y, hotbar.boxSize, hotbar.boxSize)
        if inventoryHB[i] ~= nil and next(inventoryHB[i]) ~= nil then
            love.graphics.setColor(1, 1, 1)
            local spr = spw.sprites[inventoryHB[i].item].sprs

            love.graphics.draw(spr, blockX + hotbar.itemPad, y + hotbar.itemPad, 0, (hotbar.boxSize - hotbar.itemPad * 2) / spr:getWidth(), (hotbar.boxSize - hotbar.itemPad * 2) / spr:getHeight())
            love.graphics.setColor(1,1,1)

            local w = font:getWidth(tostring(inventoryHB[i].count))
            local h = font:getHeight()
            local textX = blockX + hotbar.boxSize - w - hotbar.numberPad
            local textY = y + hotbar.boxSize - h - hotbar.numberPad

            love.graphics.print(inventoryHB[i].count, textX, textY)
        end
    end

    if inventory.inventoryBar.render then
        inventory.functions.renderWholeInventory()
    end

    love.graphics.setColor(1, 1, 1)
end

function inventory.functions.update(dt)
    inventory.hotBar.lastTime = inventory.hotBar.lastTime + dt
end

function inventory.functions.addNewItem(item, count)
    local i = inventory.inventoryBar.inventory
    if (inventory.hotBar.maxItems > #i[#i]) then
        if count <= itemIndex[item].maxStackSize then
            table.insert(i[#i], { item = item, count = count })
        else
            table.insert(i[#i], { item = item, count = itemIndex[item].maxStackSize })
            inventory.functions.addItem(item, count - itemIndex[item].maxStackSize)
        end
    end
end

function inventory.functions.addItem(item, count)
    print(item, count)

    if count <= 0 then
        return
    end

    local found = false
    local i = inventory.inventoryBar.inventory

    for inventroyIndex = #i, 1, -1 do
        for index, value in ipairs(i[inventroyIndex]) do
            if value.item == item and value.count < itemIndex[item].maxStackSize then
                if itemIndex[item].maxStackSize < value.count + count then
                    local overflow = (itemIndex[item].maxStackSize - (value.count + count)) * (-1)
                    value.count = itemIndex[item].maxStackSize
                    --print(itemIndex[item].maxStackSize)
                    --print(value.count)
                    --print(count)
                    inventory.functions.addNewItem(item, overflow)
                else
                    value.count = value.count + count
                end
                found = true
                break
            end
        end
    end

    if not found then
        inventory.functions.addNewItem(item, count)
    end
end

function inventory.functions.itemMove(dt)
    local i = inventory.inventoryBar.inventory

    if i[#i][inventory.hotBar.selectedItem] == nil then
        return
    end

    local item = itemIndex[i[#i][inventory.hotBar.selectedItem].item]

    if item == nil then
        return
    end

    if inventory.hotBar.moveVal >= item.attackRotation then
        inventory.hotBar.moveItem = false
    end

    if inventory.hotBar.moveItem then
        inventory.hotBar.moveVal = inventory.hotBar.moveVal + dt * item.speedAttackMultiplayer
        inventory.hotBar.moving = true
    elseif (not inventory.hotBar.moveItem) and (inventory.hotBar.moveVal >= 0) then
        inventory.hotBar.moveVal = inventory.hotBar.moveVal - dt * item.speedAttackMultiplayer
        inventory.hotBar.moving = true
    else
        inventory.hotBar.moving = false
    end
end

function inventory.functions.coolDown(dt)
    if inventory.inventoryBar.lastOpened >= inventory.inventoryBar.openCooldown and love.keyboard.isDown(settings.keys.openInventory) then
        inventory.inventoryBar.render = not inventory.inventoryBar.render
        inventory.inventoryBar.lastOpened = 0
    end

    inventory.inventoryBar.lastOpened = inventory.inventoryBar.lastOpened + dt
end

function inventory.functions.init()
    inventory.functions.fillHitBoxTable()
end

return inventory