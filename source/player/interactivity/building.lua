building = {
    f = {},
    data = {}
}

function building.f.radiansToDir(rad)
    print(rad)
    local rotIndex = {
        [math.rad(180)] = "right",
        [math.rad(0)] = "left",
        [math.rad(90)] = "up",
        [math.rad(270)] = "down"
    }

    return rotIndex[rad] or false
end

--special function, to make / add state for conveyor_belt, this is hacky way but whatever
function building.f.conveyor_belt(tileX, tileY, width, height, enName, rot, indexOfCurrentBuild)
    local indexOfConveyors = #building.data[enName].refs --this gave the current building in itself, meaning we have to think about it!
    indexOfCurrentBuild = indexOfCurrentBuild or #entities.ents
    local entObject = entities.ents[indexOfCurrentBuild]

    local rotIndex = {
        right = math.rad(180),
        left = math.rad(0),
        up = math.rad(90),
        down = math.rad(270)
    }

    local indexRots = {
        left = 1,
        up = 2,
        right = 3,
        down = 4
    }

    --print(indexOfConveyors)

    local whereIs = {}
    local conveyorEntIndexes = {}
    for i = 1, indexOfConveyors do
        if i ~= indexOfCurrentBuild then
            local ent = building.data[enName].refs[i]
            if ent.tileX + 1 == tileX and ent.tileY == tileY then
                whereIs[#whereIs+1] = "left"
                conveyorEntIndexes[#conveyorEntIndexes+1] = i
            elseif ent.tileX - 1 == tileX and ent.tileY == tileY then
                whereIs[#whereIs+1] = "right"
                conveyorEntIndexes[#conveyorEntIndexes+1] = i
            elseif ent.tileX == tileX and ent.tileY + 1 == tileY then
                whereIs[#whereIs+1] = "up"
                conveyorEntIndexes[#conveyorEntIndexes+1] = i
            elseif ent.tileX == tileX and ent.tileY - 1 == tileY then
                whereIs[#whereIs+1] = "down"
                conveyorEntIndexes[#conveyorEntIndexes+1] = i
            end 
        end
    end

    --print(#whereIs)

    local stateRet = "straight"

    if #whereIs == 2 then
        local w1, w2 = math.min(indexRots[whereIs[1]], indexRots[whereIs[2]]), math.max(indexRots[whereIs[1]], indexRots[whereIs[2]])
        --print(indexRots[whereIs[1]] % 4, indexRots[whereIs[2]] % 4)
        if w1 + 1 == w2 or w2 - 1 == w1 or math.floor(w2 / 4) == w1 then
            stateRet = "turn"
            local rotator = 0

            local obj = {
                [whereIs[1]] = true,
                [whereIs[2]] = true
            }

            --print(whereIs[1], whereIs[2])

            if obj.left and obj.down then
                rotator = math.rad(0)
            elseif obj.down and obj.right then
                rotator = math.rad(270)
            elseif obj.right and obj.up then
                rotator = math.rad(180)
            elseif obj.up and obj.left then
                rotator = math.rad(90)
            else
                console.f.callConsoleFunction("debugPrint", "rotate incorrect, coveyor_belt :(")
            end

            if indexOfCurrentBuild ~= -1 then
                entities.ents[indexOfCurrentBuild].state = "turn"
                entities.ents[indexOfCurrentBuild].rotate = rotator
            end
        else
            if entities.ents[conveyorEntIndexes[1]].rotate == entities.ents[conveyorEntIndexes[2]].rotate then
                entities.ents[indexOfCurrentBuild].rotate = entities.ents[conveyorEntIndexes[1]].rotate
            end
        end
    --TODO actually add merger or whatever, this code kinda sucks and kinda works at the same time, so I'll have to fix it, but I would love to make conveyors work to trasfer items and whatnot
    --[[elseif #whereIs == 3 then
        local canBuild = false
        local aim = 0
        local aimDir = nil

        for i = 1, #conveyorEntIndexes, 1 do
            print(player.vals.buildingRotate, entities.ents[conveyorEntIndexes[i] ].rotate)
            if player.vals.buildingRotate == entities.ents[conveyorEntIndexes[i] ].rotate then
                canBuild = true
                aim = entities.ents[conveyorEntIndexes[i] ].rotate
                aimDir = whereIs[i]
                break
            end
        end

        if canBuild then
            local obj = {
                [whereIs[1] ] = true,
                [whereIs[2] ] = true,
                [whereIs[3] ] = true
            }

            entities.ents[indexOfCurrentBuild].state = "merge3"
            entities.ents[indexOfCurrentBuild].rotate = aim

            entities.ents[indexOfCurrentBuild].scaleY = 1
            entities.ents[indexOfCurrentBuild].scaleX = 1

            if obj.up then
                entities.ents[indexOfCurrentBuild].scaleY = -1
            end

            if aim == rotIndex[aimDir] then
                entities.ents[indexOfCurrentBuild].scaleX = -1
            end

            if obj.up and obj.left then
                entities.ents[indexOfCurrentBuild].scaleY = 1
            elseif obj.up and obj.right then
                entities.ents[indexOfCurrentBuild].scaleY = -1
            end

            for key, value in pairs(conveyorEntIndexes) do
                local conv = entities.ents[value]
                print(building.f.radiansToDir(conv.rotate))
            end
        end]]
    end

    return stateRet
end

function building.f.conveyorBeltState(self, state)
    state = (self == nil) and state or self.state
    local rotate = (self == nil) and player.vals.buildingRotate or self.rotate

    if state == "straight" or state == nil then
        return spw.sprites["conveyor_belt"].sprs[spw.sprites["conveyor_belt"].index]
    elseif state == "turn" then
        if rotate ~= math.rad(180) and rotate ~= math.rad(90) then
            return spw.sprites["conveyor_turn"].sprs[spw.sprites["conveyor_turn"].index]
        else
            return spw.sprites["conveyor_turn"].sprs[math.abs(spw.sprites["conveyor_turn"].index - #spw.sprites["conveyor_turn"].sprs) + 1]
        end
    elseif state == "merge3" then
        return spw.sprites["conveyor_merge3"].sprs[spw.sprites["conveyor_merge3"].index]
    end
end

function building.f.build(tileX, tileY, width, height, enName, rot)
    rot = rot or 0
    --if entities.isEntityOnTile(tileX, tileY, width, height) ~= -1 then
    --    return false
    --end

    if not building.f.canBuildThere(tileX, tileY, enName) then
        return false
    end

    local en = entitiesIndex[enName]

    --tables.writeTable(en)

    entities.makeNewOne(tileX, tileY, enName, en.HP, en.drop, en.width, en.height, en.xp, false)
    if itemIndex[enName] ~= nil and itemIndex[enName].rotatable then
        entities.ents[#entities.ents].rotate = rot
    end

    if building.f[enName] ~= nil and type(building.f[enName]) == "function" then
        building.data[enName] = building.data[enName] or {}
        building.data[enName].refs = building.data[enName].refs or {}
        table.insert(building.data[enName].refs, entities.ents[#entities.ents])
        --building.f[enName](tileX, tileY, width, height, enName, rot)
        for i = 1, #building.data[enName].refs, 1 do
            local ent = building.data[enName].refs[i]
            building.f[enName](ent.tileX, ent.tileY, ent.width, ent.height, enName, ent.rot, i)
        end
    end

    return true
end

function building.f.canBuildThere(tileX, tileY, itemName)
    if entities.isEntityOnTile(tileX, tileY, itemIndex[itemName].width, itemIndex[itemName].height) == -1 and building.f.canBuild(itemName) then
        return true
    end
    return false
end

function building.f.render(sprite, x, y, width, height, itemName, rotate)
    rotate = rotate or 0
    love.graphics.setColor(0.35,1,0.35,0.75)
    love.graphics.draw(sprite, x + map.tileSize / 2, y + map.tileSize / 2, rotate, (width * itemIndex[itemName].width) / sprite:getWidth(), (height * itemIndex[itemName].height) / sprite:getHeight(), sprite:getWidth() / 2, sprite:getHeight() / 2)
    love.graphics.setColor(1,1,1,1)
end

function building.f.renderIncorrect(sprite, x, y, width, height, itemName, rotate)
    rotate = rotate or 0
    love.graphics.setColor(1,0.35,0.35,0.75)
    love.graphics.draw(sprite, x + map.tileSize / 2, y + map.tileSize / 2, rotate, (width * itemIndex[itemName].width) / sprite:getWidth(), (height * itemIndex[itemName].height) / sprite:getHeight(), sprite:getWidth() / 2, sprite:getHeight() / 2)
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

--TODO actually just remake part of the functions to suite it better, because this kinda blows ngl

function building.f.furnaceInteractivity(self)
    self.burnTime = self.burnTime or 0
    self.items = self.items or {item = "", count = 0}

    local i = inventory.inventoryBar.inventory
    local item = itemIndex[i[#i][inventory.hotBar.selectedItem].item]

    if item == nil then
        return
    end

    if item.burnable then
        self.burnTime = self.burnTime + item.burnStrength
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
    if self.burnTime > 0 and self.items.item ~= "" and not (self.items.count < itemFromIdex.smeltsTo.needs) then
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

    self[2].count = self[2].count or 0
    self.burnTime = self.burnTime or 0

    if self[2].count > 0 and self.burnTime == 0 then
        self.burnTime = itemIndex[self[2].item].burnStrength
        self.maxBurnSTR = itemIndex[self[2].item].burnStrength
        self[2].count = self[2].count - 1
        
        if self[2].count <= 0 then
            self[2] = {item = "", count = 0}
        end
    end

    self.progress = self.progress or 0
    --tables.writeTable(self)

    self.items = {item = self[1].item, count = self[1].count} --this is kinda... hacky work around but ot works lol

    if self.burnTime > 0 and self.items ~= nil then
        self.progress = self.progress + dt
        --print(self.progress)
        if self.progress > 1 then
            --print(self.items.item, self.items.count)
            local itemFromIdex = itemIndex[self.items.item]
            --inventory.functions.addItem(itemFromIdex.smeltsTo.item, itemFromIdex.smeltsTo.count)
            --tables.writeTable(self)
            if (self[3].item ~= nil) then
                if itemFromIdex.smeltsTo.item ~= self[3].item then
                    return
                end
            else
                self[3].item = ""
                self[3].count = 0
            end

            if self[3].count + itemFromIdex.smeltsTo.count > itemIndex[itemFromIdex.smeltsTo.item].maxStackSize then
                return
            end

            --self[3] = {item = itemFromIdex.smeltsTo.item, count = itemFromIdex.smeltsTo.count}
            self[3].item = itemFromIdex.smeltsTo.item
            self[3].count = self[3].count + itemFromIdex.smeltsTo.count
            self.items.count = self.items.count - itemFromIdex.smeltsTo.needs
            self.progress = 0
            self.burnTime = self.burnTime - 1

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
        self.time = 0
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