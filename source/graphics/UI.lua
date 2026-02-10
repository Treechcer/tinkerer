UI = {
    fonts = {
        normal = love.graphics.newFont(13)
    },
    renderder = {
        furnaceUI = {
            buttons = {
                b1 = {
                    press = function (self)
                        print(1)
                        --if next(inventory.inventoryBar.itemOnCursor) ~= nil then
                        --    love.event.quit()
                        --end


                    end
                },
                b2 = {
                    press = function (self)
                        print(2)
                        --if next(inventory.inventoryBar.itemOnCursor) ~= nil then
                        --    love.event.quit()
                        --end
                    end
                },
                b3 = {
                    press = function (self)
                        print(3)
                        --if next(inventory.inventoryBar.itemOnCursor) ~= nil then
                        --    love.event.quit()
                        --end
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
    for key, value in pairs(UI.renderder.furnaceUI.buttons) do
        --print(key)
        love.graphics.rectangle("fill", value.startX, value.startY, UI.renderder.furnaceUI.blockSize, UI.renderder.furnaceUI.blockSize)
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