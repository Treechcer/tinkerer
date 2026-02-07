crafting = {
    f = {},

}
function crafting.f.init()
    crafting.blockSize = 75
    crafting.x = inventory.hitboxTable.endPos.x + 25
    crafting.y = inventory.hitboxTable.endPos.y + 25 - (inventory.inventoryBar.blockSize * 2.5) - (crafting.blockSize / 3)
end

function crafting.f.render()
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("fill", crafting.x, crafting.y, crafting.blockSize, crafting.blockSize)
    local spr = spw.sprites.arrow.sprs
    love.graphics.draw(spr, crafting.x, crafting.y - (crafting.blockSize / 2.5), 0, crafting.blockSize / spr:getWidth())
    love.graphics.draw(spr, crafting.x + (spr:getWidth() * (crafting.blockSize / spr:getWidth()) / 2), crafting.y + crafting.blockSize * 1.3, math.pi, crafting.blockSize / spr:getWidth(), crafting.blockSize / spr:getWidth(), spr:getWidth() / 2, spr:getHeight() / 2)
end

return crafting