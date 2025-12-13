inventory = {
    hotBar = {
        maxItems = 4,
        items = {
            { item = "hammer", count = 5 }
        },
        boxSize = 50, --pixels
        paddingBottom = 15,
        itemPad = 3,
        selectedItem = 1
    },
    functions = {}
}

function inventory.functions.renderHotbar()
    love.graphics.setColor(1, 1, 1)

    local hotbar = inventory.hotBar
    local totalWidth = hotbar.maxItems * hotbar.boxSize
    local startX = (game.width - totalWidth) / 2
    local y = game.height - hotbar.boxSize - hotbar.paddingBottom

    for i = 1, hotbar.maxItems do
        love.graphics.rectangle("line", startX + (i - 1) * hotbar.boxSize, y, hotbar.boxSize, hotbar.boxSize)
        if hotbar.items[i] ~= nil then
            local spr = spw.sprites[hotbar.items[i].item].sprs
            love.graphics.draw(spr, startX + (i - 1) * hotbar.boxSize + hotbar.itemPad, y + hotbar.itemPad, 0,
                (hotbar.boxSize - hotbar.itemPad * 2) / spr:getWidth(),
                (hotbar.boxSize - hotbar.itemPad * 2) / spr:getHeight())
        end
    end
end

return inventory