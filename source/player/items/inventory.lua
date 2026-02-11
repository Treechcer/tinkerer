local crafting = require("source.player.crafting.crafting")

inventory = {
    hotBar = {
        maxItems = 5,
        --items = {},
        boxSize = 50, --pixels
        paddingBottom = 15,
        itemPad = 3,
        selectedItem = 1,
        lastTime = 0,
        coolDown = 0.1,
        numberPad = 2,
        moveVal = 0,
        moveItem = false,
        moving = false,
    },
    inventoryBar = {
        inventory = {
            {{},{},{},{},{}},
            {{},{},{},{},{}},
            {{},{},{},{},{}},
            {
                { --[[item = "hammer", count = 1]] },
                { item = "pebble", count = 5 },
                { item = "stick", count = 5 },
                { item = "furnace", count = 5 },
                {}
            },
        }, --this is sectioned into 4 x 4 inventory parts, the last one is hotbar but it kinda supports getting different sizes yk
        maxItemsPerInventory = 5, --this is except hotbar btw
        blockSize = game.width / 10,
        pad = game.width / 200,
        padText = 5,
        render = false,
        openCooldown = 0.25,
        lastOpened = 0,
        itemOnCursor = {},
        controller = {
            pos = {
                x = 1,
                y = 1,
            },
            cd = {
                cd = 0.1,
                last = 0
            }
        },
        UI = nil,
        UIFunc = {crafting = crafting.f.render, furnace = building.f.furnaceUI}
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

    local rows = #i
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

---@diagnostic disable: duplicate-set-field
function inventory.functions.click(button)
    --PC ONLY!!

    if not inventory.inventoryBar.render then
        return false
    end

    local x, y = love.mouse.getPosition()
    local posHit = renderer.AABB(x, y, 1, 1, inventory.hitboxTable.start.x, inventory.hitboxTable.start.y, inventory.hitboxTable.length.x, inventory.hitboxTable.length.y)
    
    local itemCol = math.floor((x - inventory.hitboxTable.start.x) / (inventory.inventoryBar.blockSize)) + 1
    local itemRow = math.floor((y - inventory.hitboxTable.start.y) / (inventory.inventoryBar.blockSize)) + 1

    if button == 1 then
        --if (itemCol == inventory.inventoryBar.indexOnCursor.col) and (itemRow == inventory.inventoryBar.indexOnCursor.row) then
        --    return
        --end

        return inventory.functions.moveItems(itemRow, itemCol, 1, posHit)
    elseif button == 2 then
        return inventory.functions.split(itemRow, itemCol, 1, posHit)
    end

    return false
end

function inventory.functions.renderItemOnCursor(x, y)
    if inventory.inventoryBar.render and inventory.inventoryBar.itemOnCursor.item ~= nil then
        local spr = spriteWorker.sprites[inventory.inventoryBar.itemOnCursor.item].sprs
        local blockSize = inventory.inventoryBar.blockSize
        local item = itemIndex[inventory.inventoryBar.itemOnCursor.item]
        local w = spr:getWidth() * item.height
        local h = spr:getHeight() * item.width

        local scaleX = inventory.inventoryBar.blockSize / w
        local scaleY = inventory.inventoryBar.blockSize / h

        local realWidth = w * (blockSize / w)
        local realHeight = h * (blockSize / h)

        love.graphics.draw(spr, x, y, 0, scaleX, scaleY, spr:getWidth() / 2, spr:getHeight() / 2)
        love.graphics.setColor(1,1,1)
        love.graphics.print(inventory.inventoryBar.itemOnCursor.count, x + (realWidth / 3), y + (realHeight / 4)) -- 3 and 4 are random values, they work well ngl
    end
end

---@param posHit boolean?
function inventory.functions.moveItems(itemRow, itemCol, button, posHit)
    --button not used for now

    posHit = posHit or true

    --if itemRow == inventory.inventoryBar.itemOnCursor.row and itemCol == inventory.inventoryBar.itemOnCursor.col then
    --    return false
    --end

    if itemCol > #inventory.inventoryBar.inventory or itemRow > #inventory.inventoryBar.inventory[1] or itemRow < 1 or itemCol < 1 then
        return false
    end

    if posHit and next(inventory.inventoryBar.itemOnCursor) == nil then
        local item = inventory.inventoryBar.inventory[itemRow][itemCol]

        if item ~= nil and next(item) ~= nil then
            inventory.inventoryBar.itemOnCursor = {
                item = item.item,
                count = item.count,

                row = itemRow,
                col = itemCol
            }

            inventory.inventoryBar.inventory[itemRow][itemCol] = {}
        end

        return true
    elseif posHit and next(inventory.inventoryBar.itemOnCursor) ~= nil then
        local item = inventory.inventoryBar.inventory[itemRow][itemCol]

        local ind = inventory.inventoryBar.itemOnCursor

        if item == nil or next(item) == nil then
            inventory.inventoryBar.inventory[itemRow][itemCol] = {
                item = ind.item,
                count = ind.count,
            }

            inventory.inventoryBar.itemOnCursor = {}
        elseif item.item == ind.item then
            local tempC = item.count + ind.count
            local itemStackMax = itemIndex[item.item].maxStackSize
            if tempC <= itemStackMax then
                item.count = item.count + ind.count
                inventory.inventoryBar.itemOnCursor = {}                
            else
                if item.count == itemStackMax then
                    ind.count, item.count =  item.count, ind.count
                else
                    inventory.inventoryBar.itemOnCursor.count = inventory.inventoryBar.itemOnCursor.count - (itemStackMax - item.count)
                    item.count = itemStackMax
                end
            end
        end

        return true
    end
end

function inventory.functions.split(itemRow, itemCol, button, posHit)
    posHit = posHit or true
    if next(inventory.inventoryBar.itemOnCursor) == nil then
        return false
    end

    local item = inventory.inventoryBar.inventory[itemRow][itemCol]
    local itemCursor = inventory.inventoryBar.itemOnCursor

    if next(item) ~= nil then
        return false
    end

    if item.item ~= itemCursor.item and item.item ~= nil then
        return false
    end

    if next(item) == nil then
        if math.floor(itemCursor.count / 2) <= 0 then
            return false
        end

        item.item = itemCursor.item
        item.count = math.floor(itemCursor.count / 2)
        itemCursor.count = math.ceil(itemCursor.count / 2)

        return true
    end
end

function inventory.functions.renderWholeInventory()
    --inventory.functions.clean()
    if not inventory.inventoryBar.render then
        return
    end

    --crafting.f.render()
    --print(inventory.inventoryBar.UIFunc[inventory.inventoryBar.UI or "crafting"])
    --print(inventory.inventoryBar.UI or "crafting")
    inventory.inventoryBar.UIFunc[inventory.inventoryBar.UI or "crafting"]()

    local i = inventory.inventoryBar.inventory
    local barI = inventory.inventoryBar

    local rows = #i
    local cols = barI.maxItemsPerInventory
    local totalW = cols * barI.blockSize
    local totalH = rows * barI.blockSize
    local font = UI.fonts.normal

    love.graphics.setFont(font)
    for inventroyIndex = 1, rows, 1 do
        for itemIndexNum = 1, cols, 1 do
            love.graphics.setColor(0.8, 0.8, 0.8)
            local bl = barI.blockSize - barI.pad
            local xP = (game.width / 2) + ((itemIndexNum - 1) * barI.blockSize) - (totalW / 2) + (barI.pad / 2)
            local yP = (game.height / 2) + ((inventroyIndex - 1) * barI.blockSize) - (totalH / 2) + (barI.pad / 2)
            love.graphics.rectangle("fill", xP, yP, bl, bl)
            local indexItem = i[inventroyIndex][itemIndexNum]
            if indexItem ~= nil and next(indexItem) ~= nil then
                local item = indexItem.item
                local spr = spw.sprites[item].sprs
                local itemW = spr:getWidth()  * itemIndex[item].height
                local itemH = spr:getHeight() * itemIndex[item].width

                local scaleX = bl / itemW
                local scaleY = bl / itemH
                love.graphics.draw(spr,xP + bl / 2, yP + bl / 2, 0, scaleX, scaleY, spr:getWidth() / 2, spr:getHeight() / 2)
                love.graphics.setColor(1,1,1)
                local w = font:getWidth(indexItem.count)
                local h = font:getHeight()
                love.graphics.print(indexItem.count, xP + bl - w - barI.padText, yP + bl - h - barI.padText)
            end
        end
    end

    local x, y = love.mouse.getPosition()
    local itemCol = math.floor((x - inventory.hitboxTable.start.x) / (inventory.inventoryBar.blockSize)) + 1
    local itemRow = math.floor((y - inventory.hitboxTable.start.y) / (inventory.inventoryBar.blockSize)) + 1

    if (itemCol < 1 or itemRow < 1) or (itemCol > #i[1] or itemRow > #i) then
        return
    end

    local item = inventory.inventoryBar.inventory[itemRow][itemCol]

    if item == nil then
        return
    end

    if next(item) ~= nil then
        UI.renderder.descriptions.f.render(x, y, descption.f.gen(item.item))
    end

    --tables.writeTable(item)
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
            local item = itemIndex[inventoryHB[i].item]

            local itemWidth = (hotbar.boxSize - hotbar.itemPad * 2) / (spr:getWidth() * item.height)
            local itemHeight = (hotbar.boxSize - hotbar.itemPad * 2) / (spr:getHeight() * item.width)

            local scaleX = itemWidth
            local scaleY = itemHeight

            local sprW = spr:getWidth() * scaleX
            local sprH = spr:getHeight() * scaleY

            local centerX = blockX + hotbar.boxSize / 2
            local centerY = y + hotbar.boxSize / 2

            love.graphics.draw( spr, centerX - sprW / 2, centerY - sprH / 2, 0, scaleX, scaleY)

            love.graphics.setColor(1,1,1)

            local w = font:getWidth(tostring(inventoryHB[i].count))
            local h = font:getHeight()
            local textX = blockX + hotbar.boxSize - w - hotbar.numberPad
            local textY = y + hotbar.boxSize - h - hotbar.numberPad

            love.graphics.print(inventoryHB[i].count, textX, textY)
        end
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
    --print(item, count)

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
            elseif next(value) == nil then
                value.count = count
                value.item = item
                found = true
                break
            end
        end
        
        if found then
            break
        end
    end

    --if not found then
    --    inventory.functions.addNewItem(item, count)
    --end
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

function inventory.functions.AddNewItemIndex(item, maxStackSize, attack, weakness, strength, defaultHp, drop, speedAttackMultiplayer, attackRotation, buildable, burnable, burnStrength, typeI, smeltsTo, width, height)
    width = width or 1
    height = height or 1
    burnStrength = burnStrength or 0
    typeI = typeI or "Resource"
    itemIndex[item] = {
        type = typeI,
        maxStackSize = maxStackSize,
        attack = attack,
        weakness = weakness,
        strength = strength,
        defaultHp = defaultHp,
        drop = drop,
        speedAttackMultiplayer = speedAttackMultiplayer,
        attackRotation = attackRotation,
        buildable = buildable,
        width = width,
        height = height,
        burnable = burnable,
        burnStrength = burnStrength,
        smeltsTo = smeltsTo
    }
end

function inventory.functions.init()
    inventory.functions.fillHitBoxTable()

    --initialising ALL items that you can carry

    inventory.functions.AddNewItemIndex("leaf", 128, 1, 0, 0, 0, {}, 10, 1, false, true, 2)
    inventory.functions.AddNewItemIndex("log", 128, 1, 0, 0, 0, {}, 10, 1, false, true, 5)
    inventory.functions.AddNewItemIndex("stick", 128, 1, 0, 0, 0, {}, 10, 1, false, true, 2)
    inventory.functions.AddNewItemIndex("small_chair", 16, 0, 0, 0, 0, {}, 10, 1, true, true, 10, "Decoration")
    inventory.functions.AddNewItemIndex("table", 16, 0, 0, 0, 0, {}, 10, 1, true, true, 10, nil, 2, 1, "Decoration")
    inventory.functions.AddNewItemIndex("furnace", 16, 0, 0, 0, 0, {}, 10, 1, true, false, 0, "Crafting station")
    inventory.functions.AddNewItemIndex("flowers", 128, 0, 0, 0, 0, {}, 10, 1, true, true, 1)
    inventory.functions.AddNewItemIndex("pebble", 64, 1, bit.addBit({bit.BIT1, bit.BIT2}), 1, 0, {}, 7, 0.85, false, false, 0, "Tool")
end

function inventory.functions.changeItemByNumber()
    for i = 1, inventory.hotBar.maxItems do
        local key = i
        if i == 10 then
            key = 0
        end

        if love.keyboard.isDown(key) then
            inventory.hotBar.selectedItem = i
            break
        end
    end
end

function inventory.functions.howManyItemInInventory(item)
    local i = inventory.inventoryBar.inventory
    local count = 0
    for _, bar in ipairs(i) do
        for _0, slot in ipairs(bar) do
            if slot.item == item then
                count = slot.count
            end
        end
    end

    return count
end

function inventory.functions.removeSpecificAmmountOfItem(item, count)

    if inventory.functions.howManyItemInInventory(item) < count then
        return false
    end

    --I LÖVE (haha) using _ and _0 as variables, so good code this CAN'T end up backfiring

    local i = inventory.inventoryBar.inventory
    for _, bar in ipairs(i) do
        for _0, slot in ipairs(bar) do
            if slot.item == item then
                if slot.count > count then
                    slot.count = slot.count - count
                    return
                elseif slot.count == count then
                    inventory.inventoryBar.inventory[_][_0] = {}
                    return
                else
                    count = count - slot.count
                    inventory.inventoryBar.inventory[_][_0] = {}
                end
            end
        end
    end

    return true
end

return inventory