-- to prevent errors, all items have same values, 0 is mostl likely a value that wouldn't make sense on that item, 
-- but to prevent errors it has it as 0

itemIdex = {
    hammer = {
        type = "tool",
        stoneDMG = 2,
        woodDMG = 0,
        attackDMG = 2,
        width = 0, -- this is for building, so tools have 0
        height = 0,
        bonusDrop = (10 / 100) + 1, -- percentage
        hp = 0,
        dmgType = 0
    },
    furnace = {
        type = "buildable",
        stoneDMG = 0,
        woodDMG = 0,
        attackDMG = 0,
        width = 2,
        height = 2,
        bonusDrop = 0,
        hp = 5,
        dmgType = "stoneDMG"
    },
    rock = {
        type = "tool",
        stoneDMG = 1,
        woodDMG = 1,
        attackDMG = 1,
        width = 0,
        height = 0,
        bonusDrop = 1,
        hp = 0,
        dmgType = 0,
    }

}

function itemIdex.changeCursor(item)
    if itemIdex[item] == nil then
        return
    end

    if itemIdex[item].type == "buildable" then
        player.cursorPos.height = itemIdex[item].height
        player.cursorPos.width = itemIdex[item].width
    end
end

function itemIdex.makeItemUsable(item)
    if itemIdex[item] == nil then
        return
    end

    if itemIdex[item].type == "buildable" then
        spawner = require("game.spawner")

        for width = 0, itemIdex[item].width - 1 do
            for height = 0, itemIdex[item].height - 1 do
                print(player.cursorPos.x + width)
                if not map.isGround((player.cursorPos.x + width) * map.blockSize, (player.cursorPos.y + height) * map.blockSize) then
                    return
                end
            end
        end

        spawner.createObject(player.cursorPos.x, player.cursorPos.y, player.inventory.items[player.inventory.inventoryIndex].name, {hp = itemIdex[item].hp, dmgType = itemIdex[item].dmgType}, 2, 2)

        player.inventory.items[player.inventory.inventoryIndex].quantity = player.inventory.items[player.inventory.inventoryIndex].quantity - 1

        if player.inventory.items[player.inventory.inventoryIndex].quantity == 0 then
            player.cursorPos.height = 1
            player.cursorPos.width = 1
        end
    end
end

return itemIdex