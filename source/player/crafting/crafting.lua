crafting = {
    f = {},
    b1 = {
        press = function ()
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
    selectedRecipe = 1
}

function crafting.f.init()
    crafting.blockSize = 75
    crafting.x = inventory.hitboxTable.endPos.x + 25
    crafting.y = inventory.hitboxTable.endPos.y + 25 - (inventory.inventoryBar.blockSize * 2.5) - (crafting.blockSize / 3)

    local spr = spw.sprites.arrow.sprs

    crafting.b1.startX = crafting.x
    crafting.b1.startY = crafting.y - (crafting.blockSize / 2.5)
    crafting.b1.rotation = 0
    crafting.b1.scaleWidth  = crafting.blockSize / spr:getWidth()
    crafting.b1.scaleHeight = crafting.b1.scaleWidth
    crafting.b1.pixelHeight = spr:getHeight() * crafting.b1.scaleHeight
    crafting.b1.pixelWidth = crafting.blockSize
    crafting.b1.orginPointX = 0
    crafting.b1.orginPointY = 0


    crafting.b2.startX = crafting.x + crafting.blockSize / 2
    crafting.b2.startY = crafting.y + crafting.blockSize * 1.3
    crafting.b2.rotation = math.pi
    crafting.b2.scaleWidth  = crafting.blockSize / spr:getWidth()
    crafting.b2.scaleHeight = (crafting.blockSize / 4) / spr:getHeight()
    crafting.b2.pixelHeight = spr:getHeight() * crafting.b2.scaleHeight
    crafting.b2.pixelWidth = crafting.blockSize
    crafting.b2.orginPointX = spr:getWidth() / 2
    crafting.b2.orginPointY = spr:getHeight() / 2

    crafting.b3.startX = crafting.x
    crafting.b3.startY = crafting.y
    crafting.b3.rotation = 0
    crafting.b3.scaleWidth  = crafting.blockSize / spr:getWidth()
    crafting.b3.scaleHeight = crafting.blockSize / spr:getHeight()
    crafting.b3.pixelHeight = crafting.blockSize
    crafting.b3.pixelWidth = crafting.blockSize
    crafting.b3.orginPointX = 0
    crafting.b3.orginPointY = 0
end

function crafting.f.render()
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("fill", crafting.x, crafting.y, crafting.blockSize, crafting.blockSize)

    local recSpr = spw.sprites[recipes.recipesInOrder[crafting.selectedRecipe]].sprs
    love.graphics.draw(recSpr, crafting.x, crafting.y, 0, crafting.blockSize / recSpr:getWidth(), crafting.blockSize / recSpr:getHeight())
    
    local spr = spw.sprites.arrow.sprs
    love.graphics.draw(spr, crafting.b1.startX, crafting.b1.startY, crafting.b1.rotation, crafting.b1.scaleWidth, crafting.b1.scaleHeight, crafting.b1.orginPointX, crafting.b1.orginPointY)
    love.graphics.draw(spr, crafting.b2.startX, crafting.b2.startY, crafting.b2.rotation, crafting.b2.scaleWidth, crafting.b2.scaleHeight, crafting.b2.orginPointX, crafting.b2.orginPointY)
end

function crafting.f.checkIfOnButton(x, y)

    if not inventory.inventoryBar.render then
        return false
    end

    local obj = {"b1", "b2", "b3"}
    for i, v in ipairs(obj) do
        local button = crafting[v]
        if renderer.AABB(x, y, 1, 1, button.startX, button.startY, button.pixelWidth, button.pixelHeight) then
            button.press()

            return true
        end
    end

    return false
end

return crafting