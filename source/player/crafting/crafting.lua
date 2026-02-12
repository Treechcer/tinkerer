crafting = {
    f = {},
    buttons = {
        b1 = {
            press = function ()
                print(1)
                --print(crafting.selectedRecipe)
                if crafting.selectedRecipe < #recipes.recipesInOrder then
                    crafting.selectedRecipe = crafting.selectedRecipe + 1
                else
                    crafting.selectedRecipe = 1
                end
            end
        },
        b2 = {
            press = function ()
                print(2)
                --print(crafting.selectedRecipe)
                if crafting.selectedRecipe > 1 then
                    crafting.selectedRecipe = crafting.selectedRecipe - 1
                else
                    crafting.selectedRecipe = #recipes.recipesInOrder
                end
            end
        },
        b3 = {
            press = function ()
                print(3)
                --print("----")
                --inventory.functions.howManyItemInInventory(item)
                local craftable = true
                local rec = recipes.recipes[recipes.recipesInOrder[crafting.selectedRecipe]].recipe
                for key, value in pairs(rec) do
                    --temp write out
                    --print(value.item)
                    --print(inventory.functions.howManyItemInInventory(value.item))

                    --actual function work or whatever

                    if inventory.functions.howManyItemInInventory(value.item) < value.count then
                        craftable = false
                    end
                end

                if not craftable then
                    return
                end

                for key, value in pairs(rec) do
                    inventory.functions.removeSpecificAmmountOfItem(value.item, value.count)
                end

                local resultItem = recipes.recipes[recipes.recipesInOrder[crafting.selectedRecipe]].result

                inventory.functions.addItem(resultItem.item, resultItem.count)
            end
        },
    },
    selectedRecipe = 1
}

function crafting.f.init()
    crafting.blockSize = 75
    crafting.x = inventory.hitboxTable.endPos.x + 25
    crafting.y = inventory.hitboxTable.endPos.y + 25 - (inventory.inventoryBar.blockSize * 2.5) - (crafting.blockSize / 3)

    local spr = spw.sprites.arrow.sprs

    crafting.buttons.b1.startX = crafting.x
    crafting.buttons.b1.startY = crafting.y - (crafting.blockSize / 2.5)
    crafting.buttons.b1.rotation = 0
    crafting.buttons.b1.scaleWidth = crafting.blockSize / spr:getWidth()
    crafting.buttons.b1.scaleHeight = crafting.buttons.b1.scaleWidth
    crafting.buttons.b1.pixelWidth = spr:getWidth() * crafting.buttons.b1.scaleWidth
    crafting.buttons.b1.pixelHeight = spr:getHeight() * crafting.buttons.b1.scaleHeight
    crafting.buttons.b1.orginPointX = 0
    crafting.buttons.b1.orginPointY = 0

    crafting.buttons.b2.startX = crafting.x
    crafting.buttons.b2.startY = crafting.y + (crafting.blockSize * 1.15)
    crafting.buttons.b2.rotation = 0
    crafting.buttons.b2.scaleWidth = crafting.blockSize / spr:getWidth()
    crafting.buttons.b2.scaleHeight = crafting.buttons.b1.scaleWidth
    crafting.buttons.b2.pixelWidth = spr:getWidth() * crafting.buttons.b1.scaleWidth
    crafting.buttons.b2.pixelHeight = spr:getHeight() * crafting.buttons.b1.scaleHeight
    crafting.buttons.b2.orginPointX = 0
    crafting.buttons.b2.orginPointY = 0

    crafting.buttons.b3.startX = crafting.x
    crafting.buttons.b3.startY = crafting.y
    crafting.buttons.b3.rotation = 0
    crafting.buttons.b3.scaleWidth = crafting.blockSize / spr:getWidth()
    crafting.buttons.b3.scaleHeight = crafting.blockSize / spr:getHeight()
    crafting.buttons.b3.pixelWidth = spr:getWidth() * crafting.buttons.b3.scaleWidth
    crafting.buttons.b3.pixelHeight = spr:getHeight() * crafting.buttons.b3.scaleHeight
    crafting.buttons.b3.orginPointX = 0
    crafting.buttons.b3.orginPointY = 0
end

function crafting.f.render()
    game.activeUIButtons = crafting.buttons
    inventory.inventoryBar.UI = "crafting"

    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("fill", crafting.buttons.b3.startX, crafting.buttons.b3.startY, crafting.buttons.b3.pixelWidth, crafting.buttons.b3.pixelHeight)

    local recSpr = spw.sprites[recipes.recipesInOrder[crafting.selectedRecipe]].sprs
    love.graphics.draw(recSpr, crafting.x, crafting.y, 0, crafting.blockSize / recSpr:getWidth(), crafting.blockSize / recSpr:getHeight())

    local spr = spw.sprites.arrow.sprs
    love.graphics.draw(spr, crafting.buttons.b1.startX, crafting.buttons.b1.startY, crafting.buttons.b1.rotation, crafting.buttons.b1.scaleWidth, crafting.buttons.b1.scaleHeight, crafting.buttons.b1.orginPointX, crafting.buttons.b1.orginPointY)
    love.graphics.draw(spr, crafting.buttons.b2.startX, crafting.buttons.b2.startY + crafting.buttons.b2.pixelHeight, crafting.buttons.b2.rotation, crafting.buttons.b2.scaleWidth, -crafting.buttons.b2.scaleHeight, crafting.buttons.b2.orginPointX, crafting.buttons.b2.orginPointY)
end

function crafting.f.checkIfOnButton(buttonObjects, x, y)

    if not inventory.inventoryBar.render then
        return false
    end

    for k, v in pairs(buttonObjects) do
        local button = buttonObjects[k]
        if renderer.AABB(x, y, 1, 1, button.startX, button.startY, button.pixelWidth, button.pixelHeight) then
            button.press()

            return true
        end
    end

    return false
end

return crafting