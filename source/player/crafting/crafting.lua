crafting = {
    f = {},
    buttons = {
        {
            press = function (self)
                --print(1)
                --print(crafting.selectedRecipe)
                if crafting.selectedRecipe < #recipes.recipesInOrder then
                    crafting.selectedRecipe = crafting.selectedRecipe + 1
                else
                    crafting.selectedRecipe = 1
                end
            end
        },
        {
            press = function (self)
                --print(2)
                --print(crafting.selectedRecipe)
                if crafting.selectedRecipe > 1 then
                    crafting.selectedRecipe = crafting.selectedRecipe - 1
                else
                    crafting.selectedRecipe = #recipes.recipesInOrder
                end
            end
        },
        {
            press = function (self)
                --print(3)
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

    crafting.buttons[1].startX = crafting.x
    crafting.buttons[1].startY = crafting.y - (crafting.blockSize / 2.5)
    crafting.buttons[1].rotation = 0
    crafting.buttons[1].scaleWidth = crafting.blockSize / spr:getWidth()
    crafting.buttons[1].scaleHeight = crafting.buttons[1].scaleWidth
    crafting.buttons[1].pixelWidth = spr:getWidth() * crafting.buttons[1].scaleWidth
    crafting.buttons[1].pixelHeight = spr:getHeight() * crafting.buttons[1].scaleHeight
    crafting.buttons[1].orginPointX = 0
    crafting.buttons[1].orginPointY = 0

    crafting.buttons[2].startX = crafting.x
    crafting.buttons[2].startY = crafting.y + (crafting.blockSize * 1.15)
    crafting.buttons[2].rotation = 0
    crafting.buttons[2].scaleWidth = crafting.blockSize / spr:getWidth()
    crafting.buttons[2].scaleHeight = crafting.buttons[1].scaleWidth
    crafting.buttons[2].pixelWidth = spr:getWidth() * crafting.buttons[1].scaleWidth
    crafting.buttons[2].pixelHeight = spr:getHeight() * crafting.buttons[1].scaleHeight
    crafting.buttons[2].orginPointX = 0
    crafting.buttons[2].orginPointY = 0

    crafting.buttons[3].startX = crafting.x
    crafting.buttons[3].startY = crafting.y
    crafting.buttons[3].rotation = 0
    crafting.buttons[3].scaleWidth = crafting.blockSize / spr:getWidth()
    crafting.buttons[3].scaleHeight = crafting.blockSize / spr:getHeight()
    crafting.buttons[3].pixelWidth = spr:getWidth() * crafting.buttons[3].scaleWidth
    crafting.buttons[3].pixelHeight = spr:getHeight() * crafting.buttons[3].scaleHeight
    crafting.buttons[3].orginPointX = 0
    crafting.buttons[3].orginPointY = 0
end

function crafting.f.render()
    game.activeUIButtons = crafting.buttons
    inventory.inventoryBar.UI = "crafting"

    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("fill", crafting.buttons[3].startX, crafting.buttons[3].startY, crafting.buttons[3].pixelWidth, crafting.buttons[3].pixelHeight)

    local recSpr = spw.sprites[recipes.recipesInOrder[crafting.selectedRecipe]].sprs
    love.graphics.draw(recSpr, crafting.x, crafting.y, 0, crafting.blockSize / recSpr:getWidth(), crafting.blockSize / recSpr:getHeight())

    local spr = spw.sprites.arrow.sprs
    love.graphics.draw(spr, crafting.buttons[1].startX, crafting.buttons[1].startY, crafting.buttons[1].rotation, crafting.buttons[1].scaleWidth, crafting.buttons[1].scaleHeight, crafting.buttons[1].orginPointX, crafting.buttons[1].orginPointY)
    love.graphics.draw(spr, crafting.buttons[2].startX, crafting.buttons[2].startY + crafting.buttons[2].pixelHeight, crafting.buttons[2].rotation, crafting.buttons[2].scaleWidth, -crafting.buttons[2].scaleHeight, crafting.buttons[2].orginPointX, crafting.buttons[2].orginPointY)
end

function crafting.f.checkIfOnButton(buttonObjects, x, y)

    if not inventory.inventoryBar.render then
        return false
    end

    for i, button in ipairs(buttonObjects) do
        if renderer.AABB(x, y, 1, 1, button.startX, button.startY, button.pixelWidth, button.pixelHeight) then
            button.press(button)
            return true
        end
    end

    return false
end

return crafting