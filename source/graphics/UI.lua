UI = {
    fonts = {
        normal = love.graphics.newFont(13)
    },
    renderder = {
        furnaceUI = {
            buttons = {
                b1 = {
                    press = function (self)
                        self.color = {0,1,0}
                        print(1)
                        --if next(inventory.inventoryBar.itemOnCursor) ~= nil then
                        --    love.event.quit()
                        --end

                        UI.f.checkItemSlot(1, 3)
                    end
                },
                b2 = {
                    press = function (self)
                        self.color = {0,1,0}
                        print(2)
                        --if next(inventory.inventoryBar.itemOnCursor) ~= nil then
                        --    love.event.quit()
                        --end

                        UI.f.checkItemSlot(2, 3)
                    end
                },
                b3 = {
                    press = function (self)
                        self.color = {0,1,0}
                        print(3)
                        --if next(inventory.inventoryBar.itemOnCursor) ~= nil then
                        --    love.event.quit()
                        --end

                        UI.f.checkItemSlot(3, 3)
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

function UI.f.addItemIndexes(c)
    print(c)
    for i = 1, c do
        if player.openedEntity[i] == nil or next(player.openedEntity[i]) == nil then
            player.openedEntity[i] = {}
        end
    end
end

function UI.f.checkItemSlot(itemSlot, max)
    UI.f.addItemIndexes(max)

    if inventory.inventoryBar.itemOnCursor ~= nil and next(inventory.inventoryBar.itemOnCursor) ~= nil then
        player.openedEntity[itemSlot] = inventory.inventoryBar.itemOnCursor
        inventory.inventoryBar.itemOnCursor = {}
    end
end

function UI.f.init()
    --local spr = spw.sprites.arrow.sprs

    UI.renderder.furnaceUI.blockSize = 75
    UI.renderder.furnaceUI.x = inventory.hitboxTable.endPos.x + 25
    UI.renderder.furnaceUI.y = inventory.hitboxTable.endPos.y + 25 - (inventory.inventoryBar.blockSize * 2.5) - (crafting.blockSize / 3)


    UI.renderder.furnaceUI.buttons.b1.startX = crafting.x
    UI.renderder.furnaceUI.buttons.b1.startY = crafting.y - (UI.renderder.furnaceUI.blockSize * 1.25)
    UI.renderder.furnaceUI.buttons.b1.rotation = 0
    UI.renderder.furnaceUI.buttons.b1.scaleWidth = crafting.blockSize / 16
    UI.renderder.furnaceUI.buttons.b1.scaleHeight = crafting.blockSize / 16
    UI.renderder.furnaceUI.buttons.b1.pixelWidth = 16 * crafting.buttons.b1.scaleWidth
    UI.renderder.furnaceUI.buttons.b1.pixelHeight = 16 * crafting.buttons.b1.scaleHeight
    UI.renderder.furnaceUI.buttons.b1.orginPointX = 0
    UI.renderder.furnaceUI.buttons.b1.orginPointY = 0

    UI.renderder.furnaceUI.buttons.b2.startX = crafting.x
    UI.renderder.furnaceUI.buttons.b2.startY = crafting.y
    UI.renderder.furnaceUI.buttons.b2.rotation = 0
    UI.renderder.furnaceUI.buttons.b2.scaleWidth = crafting.blockSize / 16
    UI.renderder.furnaceUI.buttons.b2.scaleHeight = crafting.blockSize / 16
    UI.renderder.furnaceUI.buttons.b2.pixelWidth = 16 * crafting.buttons.b3.scaleWidth
    UI.renderder.furnaceUI.buttons.b2.pixelHeight = 16 * crafting.buttons.b3.scaleHeight
    UI.renderder.furnaceUI.buttons.b2.orginPointX = 0
    UI.renderder.furnaceUI.buttons.b2.orginPointY = 0

    UI.renderder.furnaceUI.buttons.b3.startX = crafting.x
    UI.renderder.furnaceUI.buttons.b3.startY = crafting.y + (UI.renderder.furnaceUI.blockSize * 1.25)
    UI.renderder.furnaceUI.buttons.b3.rotation = 0
    UI.renderder.furnaceUI.buttons.b3.scaleWidth = crafting.blockSize / 16
    UI.renderder.furnaceUI.buttons.b3.scaleHeight = crafting.blockSize / 16
    UI.renderder.furnaceUI.buttons.b3.pixelWidth = 16 * crafting.buttons.b3.scaleWidth
    UI.renderder.furnaceUI.buttons.b3.pixelHeight = 16 * crafting.buttons.b3.scaleHeight
    UI.renderder.furnaceUI.buttons.b3.orginPointX = 0
    UI.renderder.furnaceUI.buttons.b3.orginPointY = 0
end

function UI.renderder.furnaceUI.render()
    game.activeUIButtons = UI.renderder.furnaceUI.buttons
    local c = 1
    for key, value in pairs(UI.renderder.furnaceUI.buttons) do
    --for i = 1, #UI.renderder.furnaceUI.buttons do
        --print(key)
        --local value = UI.renderder.furnaceUI.buttons[i]
        value.color = value.color or {1,1,1}
        love.graphics.setColor(value.color)
        love.graphics.rectangle("fill", value.startX, value.startY, UI.renderder.furnaceUI.blockSize, UI.renderder.furnaceUI.blockSize)

        if player.openedEntity ~= nil then

            if player.openedEntity[c] == nil then
                UI.f.addItemIndexes(c)
            end

            if player.openedEntity ~= nil or next(player.openedEntity) ~= nil then
                if player.openedEntity[c].item ~= nil then
                    --print(player.openedEntity["item" .. c].item)
                    local spr = spw.sprites[player.openedEntity[c].item].sprs
                    love.graphics.draw(spr, value.startX, value.startY, 0, UI.renderder.furnaceUI.blockSize / spr:getWidth(), UI.renderder.furnaceUI.blockSize / spr:getHeight())
                end
            end
        end

        c = c + 1
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