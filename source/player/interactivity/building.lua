building = {
    f = {},

}

function building.f.build(tileX, tileY, width, height, enName)
    if entities.isEntityOnTile(tileX, tileY, width, height) ~= -1 then
        return false
    end

    local en = entitiesIndex[enName]

    --tables.writeTable(en)

    entities.makeNewOne(tileX, tileY, enName, en.HP, en.drop, en.width, en.height, en.xp)
    return true
end

function building.f.render(sprite, x, y, width, height, itemName)
    love.graphics.setColor(0.35,1,0.35,0.75)
    love.graphics.draw(sprite, x, y, 0, (width * itemIndex[itemName].width) / sprite:getWidth(), (height * itemIndex[itemName].height) / sprite:getHeight())
    love.graphics.setColor(1,1,1,1)
end

function building.f.renderIncorrect(sprite, x, y, width, height, itemName)
    love.graphics.setColor(1,0.35,0.35,0.75)
    love.graphics.draw(sprite, x, y, 0, (width * itemIndex[itemName].width) / sprite:getWidth(), (height * itemIndex[itemName].height) / sprite:getHeight())
    love.graphics.setColor(1,1,1,1)
end

function building.f.canBuild(itemName)
    local isItemOnGround = true
    
    for buildHeight = 0, itemIndex[itemName].height - 1 do
        for buildWidth = 0, itemIndex[itemName].width - 1 do
            isItemOnGround = map.f.accesibleTile(player.cursor.tileX + buildWidth, player.cursor.tileY + buildHeight)

            if not isItemOnGround then
                break
            end
        end

        if not isItemOnGround then
            break
        end
    end

    return isItemOnGround
end

function building.f.furnaceInteractivity(self)

    self.fuel = self.fuel or 0
    self.items = self.items or {item = "", count = 0}

    local i = inventory.inventoryBar.inventory
    local item = itemIndex[i[#i][inventory.hotBar.selectedItem].item]

    if item == nil then
        return
    end

    if item.burnable then
        self.fuel = self.fuel + item.burnStrength
        i[#i][inventory.hotBar.selectedItem] = {}
    elseif self.items.item == "" or self.items.item == nil then
        self.items.item = item.item
        i[#i][inventory.hotBar.selectedItem] = {}
    elseif self.items.item == i[#i][inventory.hotBar.selectedItem].item then
        self.items.item = self.items.item + i[#i][inventory.hotBar.selectedItem].item
        i[#i][inventory.hotBar.selectedItem] = {}
    end

    if self.fuel > 0 and self.items.item ~= "" then
        self.state = "burn"
    else
        self.state = ""
    end
end

return building