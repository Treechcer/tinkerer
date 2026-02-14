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
                    end
                },
                {
                    index = 2,
                    press = function (self)
                        --self.color = {0,1,0}
                        UI.f.checkItemSlot(self.index, 3)
                    end
                },
                {
                    index = 3,
                    press = function (self)
                        --self.color = {0,1,0}
                        UI.f.checkItemSlot(self.index, 3)
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
    print(c .. "c")
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
    for c = 1, #UI.renderder.furnaceUI.buttons do
        local value = UI.renderder.furnaceUI.buttons[c]
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