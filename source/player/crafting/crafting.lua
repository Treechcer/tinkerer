crafting = {
    f = {},
    b1 = {
        press = function ()
            crafting.selectedRecipe = crafting.selectedRecipe + 1
        end
    },
    b2 = {
        press = function ()
            crafting.selectedRecipe = crafting.selectedRecipe - 1
        end
    },
    b3 = {
        press = function ()
            love.event.quit()
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
    crafting.b1.pixelHeight = spr:getWidth() * (crafting.blockSize / spr:getWidth())

    crafting.b2.startX = crafting.x + (spr:getWidth() * (crafting.blockSize / spr:getWidth()) / 2)
    crafting.b2.startY = crafting.y + crafting.blockSize * 1.3
    crafting.b1.pixelHeight = spr:getWidth() * (crafting.blockSize / spr:getWidth())

    crafting.b3.startX = crafting.x
    crafting.b3.startY = crafting.y
    crafting.b3.pixelHeight = crafting.blockSize
end

function crafting.f.render()
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("fill", crafting.x, crafting.y, crafting.blockSize, crafting.blockSize)
    local spr = spw.sprites.arrow.sprs
    love.graphics.draw(spr, crafting.b1.startX, crafting.b1.startY, 0, crafting.blockSize / spr:getWidth())
    love.graphics.draw(spr, crafting.b2.startX, crafting.b2.startY, math.pi, crafting.blockSize / spr:getWidth(), crafting.blockSize / spr:getWidth(), spr:getWidth() / 2, spr:getHeight() / 2)
end

function crafting.f.checkIfOnButton(x, y)

    if not inventory.inventoryBar.render then
        return false
    end

    local obj = {"b1", "b2", "b3"}
    for i, v in ipairs(obj) do
        if renderer.AABB(x, y, 1, 1, crafting[v].startX, crafting[v].startY, crafting.blockSize, crafting[v].pixelHeight) then
            crafting[v].press()

            return true
        end
    end

    return false
end

return crafting