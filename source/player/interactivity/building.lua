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
    if itemName == nil then
        return
    end

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
        self.items.item = i[#i][inventory.hotBar.selectedItem].item
        self.items.count = i[#i][inventory.hotBar.selectedItem].count
        i[#i][inventory.hotBar.selectedItem] = {}
    elseif self.items.item == i[#i][inventory.hotBar.selectedItem].item then
        self.items.item = i[#i][inventory.hotBar.selectedItem].item
        self.items.count = self.items.count + i[#i][inventory.hotBar.selectedItem].count
        i[#i][inventory.hotBar.selectedItem] = {}
    end

    --tables.writeTable(self.items)
    local itemFromIdex = itemIndex[self.items.item]
    if self.fuel > 0 and self.items.item ~= "" and not (self.items.count < itemFromIdex.smeltsTo.needs) then
        self.state = "burning"
    else
        self.state = ""
    end
end

--[[
    local itemFromIdex = itemIndex[self.items.item]
    inventory.functions.addItem(itemFromIdex.smeltsTo.item, itemFromIdex.smeltsTo.count)
    self.items.count = self.items.count - itemFromIdex.smeltsTo.needs
    self.progress = 0

    if self.items.count < itemFromIdex.smeltsTo.needs then
        self.state = nil
    end
]]

function building.f.furnaceState(self)
    --print(self.state)
    if self.state == "burning" then
        return spw.sprites.burning_furnace.sprs
    else
        return spw.sprites.furnace.sprs
    end
end

function building.f.furnaceWork (self, dt)
    if self.state ~= "burning" then
        return
    end

    self.progress = self.progress or 0

    if self.fuel > 0 and self.items ~= nil then
        self.progress = self.progress + dt
        --print(self.progress)
        if self.progress > 1 then
            --print(self.items.item, self.items.count)
            local itemFromIdex = itemIndex[self.items.item]
            inventory.functions.addItem(itemFromIdex.smeltsTo.item, itemFromIdex.smeltsTo.count)
            self.items.count = self.items.count - itemFromIdex.smeltsTo.needs
            self.progress = 0

            if self.items.count < itemFromIdex.smeltsTo.needs then
                self.state = nil
            end
        end
    end
end

function building.f.XSecondKillSwitch(self, dt)
    if self.killTime == nil then
        return
    end

    if self.time == nil then
        self["time"] = 0
    end

    self.time = self.time + dt
    --print(self.time)
    if self.time > self.killTime then
        self.time = 0
        return true
    end

    return false
end

function building.f.furnaceUI()
    love.graphics.setColor(1,1,1)
    UI.renderder.furnaceUI.render()
end

return building