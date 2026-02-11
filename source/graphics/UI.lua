UI = {
    fonts = {
        normal = love.graphics.newFont(13)
    },
    renderder = {
        furnaceUI = {
            buttons = {
                b1 = {
                    press = function ()
                        print(1)
                        --if next(inventory.inventoryBar.itemOnCursor) ~= nil then
                        --    love.event.quit()
                        --end

                        UI.f.checkItemSlot("item1")
                    end
                },
                b2 = {
                    press = function ()
                        print(2)
                        --if next(inventory.inventoryBar.itemOnCursor) ~= nil then
                        --    love.event.quit()
                        --end

                        UI.f.checkItemSlot("item2")
                    end
                },
                b3 = {
                    press = function ()
                        print(3)
                        --if next(inventory.inventoryBar.itemOnCursor) ~= nil then
                        --    love.event.quit()
                        --end

                        --UI.f.checkItemSlot("item3")
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

function UI.f.addItemIndexes()
    local a = {"item1", "item2", "item3"}

    for index, value in ipairs(a) do
        if player.openedEntity[value] == nil or next(player.openedEntity[value]) == nil then
            player.openedEntity[value] = {}
        end
    end
end

function UI.f.checkItemSlot(itemSlot)
    UI.f.addItemIndexes()

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
        --print(key)
        love.graphics.rectangle("fill", value.startX, value.startY, UI.renderder.furnaceUI.blockSize, UI.renderder.furnaceUI.blockSize)

        if player.openedEntity ~= nil then

            if player.openedEntity["item" .. c] == nil then
                UI.f.addItemIndexes()
            end

            if player.openedEntity["item" .. c] ~= nil or next(player.openedEntity["item" .. c]) ~= nil then
                if player.openedEntity["item" .. c].item ~= nil then
                    --print(player.openedEntity["item" .. c].item)
                    local spr = spw.sprites[player.openedEntity["item" .. c].item].sprs
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