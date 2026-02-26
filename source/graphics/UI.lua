UI = {
    fonts = {
        normal = love.graphics.newFont(13)
    },
    renderder = {
        furnaceUI = {
            buttons = {
                {
                    index = 1,
                    press = function (self)
                        --self.color = {0,1,0}
                        UI.f.checkItemSlot(self.index, 3)

                        --tables.writeTable(player.openedEntity)

                        UI.f.checkStateFurnace(self)
                    end
                },
                {
                    index = 2,
                    press = function (self)
                        local cursorItem = itemIndex[inventory.inventoryBar.itemOnCursor.item]

                        if cursorItem == nil and not UI.f.isSLotEmpty(self.index) then
                            return
                        elseif cursorItem == nil and UI.f.isSLotEmpty(self.index) then
                            UI.f.checkItemSlot(self.index, 3)
                            return
                        end

                        if cursorItem.burnStrength == 0 then
                            return
                        end

                        --self.color = {0,1,0}
                        UI.f.checkItemSlot(self.index, 3)

                        local currentItem = player.openedEntity[self.index]

                        player.openedEntity.burnTime = player.openedEntity.burnTime or 0

                        if currentItem.count > 0 and player.openedEntity.burnTime == 0 then
                            player.openedEntity.burnTime = itemIndex[currentItem.item].burnStrength
                            player.openedEntity.maxBurnSTR = itemIndex[currentItem.item].burnStrength
                            currentItem.count = currentItem.count - 1
                            
                            if currentItem.count < 0 then
                                player.openedEntity = {}
                            end
                        end

                        UI.f.checkStateFurnace(self)
                    end
                },
                {
                    index = 3,
                    press = function (self)
                        --self.color = {0,1,0}
                        --UI.f.checkItemSlot(self.index, 3)
                        

                        if next(inventory.inventoryBar.itemOnCursor) == nil and next(player.openedEntity[self.index] or {}) ~= nil then
                            inventory.inventoryBar.itemOnCursor = player.openedEntity[self.index]
                            player.openedEntity[self.index] = {}
                        --else
                        --    player.openedEntity[self.index] = {item = "rock", count = 5}
                        end
                    end
                }
            }
        },
        craftingUI = {

        },
        descriptions = {
            data = {
                defaultX = 50,
                defaultY = 20,
            },
            f = {

            }
        }
    },
    f = {}
}

function UI.f.checkStateFurnace(self)
    if next(player.openedEntity[1]) == nil then
        return
    end

    player.openedEntity.burnTime = player.openedEntity.burnTime or 0
    if pcall(function () local smeltsTo = itemIndex[player.openedEntity[1].item].smeltsTo.item end) then
        smeltsTo = itemIndex[player.openedEntity[1].item].smeltsTo.item
    else
        return
    end

    --tables.writeTable(itemIndex[player.openedEntity[1].item])

    print(smeltsTo .. player.openedEntity.burnTime)

    if smeltsTo ~= nil and player.openedEntity.burnTime > 0 then
        player.openedEntity.state = "burning"
    end
end

function UI.f.addItemIndexes(c)
    --print(c .. "c")
    if player.openedEntity == nil then
        player.openedEntity = {}
    end

    for i = 1, c do
        if type(player.openedEntity[i]) ~= "table" then
            player.openedEntity[i] = {}
        end
    end
end

function UI.f.isSLotEmpty(index)
    --tables.writeTable(player)

    if pcall(function () a = player.openedEntity[index].item ~= nil end) then
        --print(player.openedEntity[index].item ~= "" and player.openedEntity[index].item ~= nil)
        return player.openedEntity[index].item ~= "" and player.openedEntity[index].item ~= nil
    end

    return false
end

function UI.f.checkItemSlot(itemSlot, max)
    UI.f.addItemIndexes(max)

    if next(inventory.inventoryBar.itemOnCursor) ~= nil then
        if inventory.inventoryBar.itemOnCursor.item ~= player.openedEntity[itemSlot].item and not (player.openedEntity[itemSlot].item == nil or player.openedEntity[itemSlot].item == "") then
            player.openedEntity[itemSlot], inventory.inventoryBar.itemOnCursor = inventory.inventoryBar.itemOnCursor, player.openedEntity[itemSlot]
            return
        end

        player.openedEntity[itemSlot] = inventory.inventoryBar.itemOnCursor
        inventory.inventoryBar.itemOnCursor = {}
        return
    elseif next(inventory.inventoryBar.itemOnCursor) == nil then
        --print("?????")
        inventory.inventoryBar.itemOnCursor = player.openedEntity[itemSlot]
        player.openedEntity[itemSlot] = {}
        return
    --else
    --    --TODO REMOVE THIS TESTING CODE !!!
    --    player.openedEntity[itemSlot] = {item = "rock", count = 5}
    end
end

function UI.f.init()
    --local spr = spw.sprites.arrow.sprs

    UI.renderder.furnaceUI.blockSize = 75
    UI.renderder.furnaceUI.x = inventory.hitboxTable.endPos.x + 25
    UI.renderder.furnaceUI.y = inventory.hitboxTable.endPos.y + 25 - (inventory.inventoryBar.blockSize * 2.5) - (crafting.blockSize / 3)

    for i = 1, 3 do
        local button = UI.renderder.furnaceUI.buttons[i]
        button.startX = crafting.x
        button.rotation = 0
        button.orginPointX = 0
        button.orginPointY = 0
        button.scaleWidth = crafting.blockSize / 16
        button.scaleHeight = crafting.blockSize / 16
        button.pixelWidth = 16 * button.scaleWidth
        button.pixelHeight = 16 * button.scaleHeight
    end

    UI.renderder.furnaceUI.buttons[1].startY = crafting.y - (UI.renderder.furnaceUI.blockSize * 1.25)
    UI.renderder.furnaceUI.buttons[2].startY = crafting.y
    UI.renderder.furnaceUI.buttons[3].startY = crafting.y + (UI.renderder.furnaceUI.blockSize * 1.25)
end

function UI.renderder.furnaceUI.render()
    game.activeUIButtons = UI.renderder.furnaceUI.buttons

    if player.openedEntity == nil then
        UI.f.addItemIndexes(#UI.renderder.furnaceUI.buttons)
    end

    for c = 1, #UI.renderder.furnaceUI.buttons do
        local value = UI.renderder.furnaceUI.buttons[c]
        value.color = value.color or {1,1,1}
        love.graphics.setColor(value.color)

        love.graphics.rectangle("fill", value.startX, value.startY, UI.renderder.furnaceUI.blockSize, UI.renderder.furnaceUI.blockSize)
        
        --self.progress

        if value.index == 2 then
            love.graphics.setColor(1, 0.647, 0)
            player.openedEntity.burnTime = player.openedEntity.burnTime or 0
            player.openedEntity.maxBurnSTR = player.openedEntity.maxBurnSTR or 0
            if player.openedEntity.maxBurnSTR > 0 then
                local percent = 1 - (player.openedEntity.burnTime / player.openedEntity.maxBurnSTR)
                love.graphics.rectangle("fill", value.startX, value.startY + (percent * UI.renderder.furnaceUI.blockSize), UI.renderder.furnaceUI.blockSize, UI.renderder.furnaceUI.blockSize - (percent * UI.renderder.furnaceUI.blockSize))
            end
        elseif value.index == 3 then
            local percent = player.openedEntity.progress or 0
            percent = percent - 1 > 0 and 0 or percent - 1
            love.graphics.setColor(0.5, 0.5, 0.5)
            love.graphics.rectangle("fill", value.startX, value.startY - (percent * UI.renderder.furnaceUI.blockSize), UI.renderder.furnaceUI.blockSize, UI.renderder.furnaceUI.blockSize + (percent * UI.renderder.furnaceUI.blockSize))
        end

        if player.openedEntity ~= nil then
            if player.openedEntity ~= nil or next(player.openedEntity) ~= nil then
                pcall(function ()
                    if player.openedEntity[c].item ~= nil then
                        love.graphics.setColor(1,1,1)
                        --print(player.openedEntity["item" .. c].item)
                        local spr = spw.sprites[player.openedEntity[c].item].sprs
                        love.graphics.draw(spr, value.startX, value.startY, 0, UI.renderder.furnaceUI.blockSize / spr:getWidth(), UI.renderder.furnaceUI.blockSize / spr:getHeight())

                        local f = love.graphics.newFont(14)

                        local fontW = f:getWidth(player.openedEntity[c].count)
                        local fontH = f:getHeight(player.openedEntity[c].count)

                        --print(fontH, fontW)
                        love.graphics.setColor(0,0,0)
                        love.graphics.print(player.openedEntity[c].count, value.startX + UI.renderder.furnaceUI.blockSize - fontW, value.startY + UI.renderder.furnaceUI.blockSize - fontH)
                    end
                end)
            end
        end

        love.graphics.setColor(1,1,1)

        if value.index == 2 and not UI.f.isSLotEmpty(2) then
            local spr = spw.sprites["fire"].sprs
            love.graphics.draw(spr, value.startX, value.startY, 0, UI.renderder.furnaceUI.blockSize / spr:getWidth(), UI.renderder.furnaceUI.blockSize / spr:getHeight())
        end
    end
end

function UI.renderder.descriptions.f.render(x,y,description)
    love.graphics.setColor(1,1,1)
    local objDesc = UI.renderder.descriptions

    local width, height = objDesc.data.defaultX, objDesc.data.defaultY

    local font = UI.fonts.normal

    local w = font:getWidth(tostring(description))
    local _, count = string.gsub(description, "\n", "")
    local h = font:getHeight() * (count + 1)

    local padX = font:getWidth(" ") / 2
    local padY = font:getHeight() / 2

    width = (w > width) and w or width
    height = (h > height) and h or height

    love.graphics.rectangle("fill", x - padX, y - padY, width + (padX * 2), height + (padY * 2))
    love.graphics.setColor(0,0,0)
    love.graphics.print(description, x,y)
    love.graphics.setColor(1,1,1)
end

return UI