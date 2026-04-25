UI = {
    fonts = {
        normal = love.graphics.newFont(13),
        big = love.graphics.newFont(25),
    },
    colors = {
        lightBrown = {255/255, 160/255, 112/255, 0.6},
        darkBrown = {197/255,105/255,76/255,1}
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
                            
                            if currentItem.count <= 0 then
                                player.openedEntity[2] = {}
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

--emojis use random ASCII escape characters noted in decimal, from it's look I can go from 1 - 31 (maybe even 0? but I haven't tested)

UI.fonts.possibleChars = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ :-/<>=▢✓⨻⨺.\1\2\3\4\5\6"
UI.fonts.UIfontBig = love.graphics.newImageFont("assets/fonts/font.png", UI.fonts.possibleChars)
UI.fonts.emojis = {
    [";neutraley;"] = "\1",
    [";smiley;"] = "\2",
    [";frowney;"] = "\3",
    [";neutral;"] = "\4",
    [";smile;"] = "\5",
    [";frown;"] = "\6"
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

    --print(smeltsTo .. player.openedEntity.burnTime)

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

    local sprs = {
        "furnace_up_all",
        "furnace_middle",
        "furnace_down_all",
    }

    for c = 1, #UI.renderder.furnaceUI.buttons do
        local value = UI.renderder.furnaceUI.buttons[c]
        value.color = value.color or {1,1,1}
        love.graphics.setColor(value.color)

        --love.graphics.rectangle("fill", value.startX, value.startY, UI.renderder.furnaceUI.blockSize, UI.renderder.furnaceUI.blockSize)

        local backspr = spw.sprites[sprs[(c - 1) % 3 + 1]].sprs
        love.graphics.draw(backspr, value.startX, value.startY, 0, UI.renderder.furnaceUI.blockSize / backspr:getWidth(), UI.renderder.furnaceUI.blockSize / backspr:getHeight())
        --self.progress

        if value.index == 2 then
            love.graphics.setColor(1, 0.647, 0, 0.55)
            player.openedEntity.burnTime = player.openedEntity.burnTime or 0
            player.openedEntity.maxBurnSTR = player.openedEntity.maxBurnSTR or 0
            if player.openedEntity.maxBurnSTR > 0 then
                local percent = 1 - (player.openedEntity.burnTime / player.openedEntity.maxBurnSTR)
                love.graphics.rectangle("fill", value.startX, value.startY + (percent * UI.renderder.furnaceUI.blockSize), UI.renderder.furnaceUI.blockSize, UI.renderder.furnaceUI.blockSize - (percent * UI.renderder.furnaceUI.blockSize))
            end
        elseif value.index == 3 then
            local percent = player.openedEntity.progress or 0
            percent = percent - 1 > 0 and 0 or percent - 1
            love.graphics.setColor(0.8, 0.8, 0.8, 0.55)
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

                        local f = UI.fonts.UIfontBig

                        local fontW = f:getWidth(player.openedEntity[c].count)
                        local fontH = f:getHeight(player.openedEntity[c].count)

                        --print(fontH, fontW)
                        --love.graphics.setColor(0,0,0)
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
    love.graphics.setColor(1,1,1,1)
    local objDesc = UI.renderder.descriptions

    local width, height = objDesc.data.defaultX, objDesc.data.defaultY

    --font has to be updated to support a-Z

    local font = UI.fonts.UIfontBig
    love.graphics.setFont(font)
    local w = font:getWidth(tostring(description))
    local _, count = string.gsub(description, "\n", "")
    local h = font:getHeight() * (count + 1)

    local padX = font:getWidth(" ") / 2
    local padY = font:getHeight() / 2

    width = (w > width) and w or width
    height = (h > height) and h or height

    --width = (width > game.width) and game.width - width or width
    x = (x + width + 15 > game.width) and x - width or x
    x = (width < 0) and 0 or x

    y = (y + height + 15 > game.height) and y - height or y
    y = (height < 0) and 0 or y

    --local spr = spw.sprites["description"].sprs
    --love.graphics.draw(spr, x - padX, y - padY, 0, (width + (padX * 2)) / spr:getWidth(), (height + (padY * 2)) / spr:getHeight())
    love.graphics.setColor(UI.colors.lightBrown)
    love.graphics.rectangle("fill", x - padX, y - padY, width + (padX * 2), height + (padY * 2))
    love.graphics.setColor(UI.colors.darkBrown)
    love.graphics.setLineWidth(4)
    love.graphics.rectangle("line", x - padX, y - padY, width + (padX * 2), height + (padY * 2))
    love.graphics.setColor(1,1,1,1)
    love.graphics.print(description, x, y)
    --love.graphics.setColor(1,1,1)
end

function UI.f.textTify(text)
    text = UI.f.format(text)

    local posibleChars = UI.fonts.possibleChars
    local tab = {}
    for i = 1, text:len() do
        tab[text:sub(i, i)] = 1
    end

    for i = 1, posibleChars:len() do
        tab[posibleChars:sub(i, i)] = 0
    end

    tab["\n"] = 0

    for key, value in pairs(tab) do
        if value == 1 then
            if key == "." or key == "(" or key == ")" or key == "%" or key == "+" or key == "-" or key == "*" or key == "?" or key == "[" or key == "^" or key == "$" then
                key = "%" .. key
            end
            text = text:gsub(key, "▢")
        end
    end

    return text
end

function UI.f.format(text)
    if text == "" or text  == nil then
        return ""
    end

    for key, value in pairs(UI.fonts.emojis) do
        text = text:gsub(key, value)
    end

    --print(text)

    return text
end

function UI.f.formatNumber(number)
    local constShorters = {"K", "M", "B", "T", "Q", "Qi", "S"}
    local stringNum = tostring(number)
    local index = math.min(math.floor(#stringNum / 3)-1, #constShorters)
    local numbers = #stringNum % 3 + 1
    local decNum = stringNum:sub(numbers+1, numbers+1)
    if decNum ~= "0" then
        return stringNum:sub(1, numbers) .. "." .. decNum .. constShorters[index]
    else
        return stringNum:sub(1, numbers) .. constShorters[index]
    end
end

--[[
sprSheet is table that has 9 things in itself (all the sprites should be same dimesions):
topLeft -- unchanging sprite
topMid -- changing sprite
topRight -- unchanging sprite
MidLeft -- chaging sprite
MidMid -- changing sprite
MidRight -- changing sprite
BottomLeft -- unchanging sprite
BottomMid -- changing sprite
BottomRight -- unchanging sprite
]]
function UI.f.renderNineSquare(sprSheet, xScreen, yScreen, width, height)
    --mindwidth = the width of the unchanging sprites in sprite
    local topWidth = width - sprSheet.topLeft:getWidth() - sprSheet.topRight:getWidth()
    local sideHeight = height - sprSheet.topLeft:getHeight() - sprSheet.bottomLeft:getHeight()
    local bottomHeight = height - sprSheet.topLeft:getHeight()

    topWidth = topWidth < 0 and 0 or topWidth
    sideHeight = sideHeight < 0 and 0 or sideHeight

    love.graphics.draw(sprSheet.topLeft, xScreen, yScreen)
    love.graphics.draw(sprSheet.topMid, xScreen + sprSheet.topLeft:getWidth(), yScreen, 0, topWidth / sprSheet.topMid:getWidth(), sprSheet.topLeft:getWidth() / sprSheet.topMid:getWidth())
    love.graphics.draw(sprSheet.topRight, xScreen + sprSheet.topLeft:getWidth() + topWidth, yScreen)

    love.graphics.draw(sprSheet.midLeft, xScreen, yScreen + sprSheet.topLeft:getHeight(), 0, sprSheet.topLeft:getWidth() / sprSheet.midLeft:getWidth(), (height - sprSheet.topLeft:getHeight() - sprSheet.bottomLeft:getHeight()) / sprSheet.midLeft:getHeight())
    love.graphics.draw(sprSheet.midMid, xScreen + sprSheet.topLeft:getWidth(), yScreen + sprSheet.topLeft:getHeight(), 0, (width - sprSheet.topLeft:getWidth() - sprSheet.bottomLeft:getWidth()) / sprSheet.midMid:getHeight(), (height - sprSheet.topLeft:getHeight() - sprSheet.bottomLeft:getHeight()) / sprSheet.midMid:getHeight())
    love.graphics.draw(sprSheet.midRight, xScreen + sprSheet.midRight:getWidth() + topWidth, yScreen + sprSheet.topLeft:getWidth(), 0, sprSheet.midRight:getWidth() / sprSheet.midRight:getWidth(), (height - sprSheet.topLeft:getHeight() - sprSheet.bottomLeft:getHeight()) / sprSheet.midRight:getHeight())

    love.graphics.draw(sprSheet.bottomLeft, xScreen, yScreen + bottomHeight)
    love.graphics.draw(sprSheet.bottomMid, xScreen + sprSheet.bottomLeft:getWidth(), yScreen + bottomHeight, 0, topWidth / sprSheet.topMid:getWidth(), sprSheet.topLeft:getWidth() / sprSheet.topMid:getWidth())
    love.graphics.draw(sprSheet.bottomRight, xScreen + sprSheet.bottomLeft:getWidth() + topWidth, yScreen + bottomHeight)
end

return UI