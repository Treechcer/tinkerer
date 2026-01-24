entitiesIndex = {
    f = {
        --for functions needed for this "LUASON"
    },
    rock = {
        entityName = "rock", --this has to be same the name of the Index, it'll be used as "relations" from databases to save RAM (lookupTable)
        spwName = "rock",
        HP = 5,
        --weakness will work similarly to Linux permissions,
        --it's three bits for now, (pickaxe, axe, nothing)
        --if bit for something is set to 1, you can damage
        --it if the item in use has mask with one on the same place
        weakness = bit.addBit({bit.BIT4}),
        --every tool with every material will have strenght, the lowest
        --variant will have 1, after that it will be 2...
        strengthMin = 1,
        --you have to :
        --tool.strength >= entity.strengthMin and (tool.weakness && entity.weakness ~= 0)
        drop = { {item = "rock", baseCount = 3} },
        width = 1,
        height = 1,
        luck = "miningLuck",
        xp = {mining = 20}
    }
}

function entitiesIndex.f.getCount (luck, baseCount) -- luck => 1 - 10 (base skill lvl, maybe there can be added more?)
    local number = baseCount
    --print(luck, baseCount)
    for i = 0, luck, 1 do
        number = number + math.random(0,1)
    end

    return number
end

function entitiesIndex.f.getBaseCount(name)
    return entitiesIndex[name].baseCount
end

---@param entityName string
---@param spwName string?
---@param HP integer
---@param weakness integer
---@param strenght integer
----@param spawnable boolean?
---@param width integer?
---@param height integer?
function entitiesIndex.f.addIndex(entityName, walkable, HP, weakness, strenght, --[[spawnable,]] drop, width, height, luck, xp, interactivityKeys, spwName)

    --interactivyKeys => {key = function ...........} returns true / false, if it did something

    width = width or 1
    height = height or 1
    xp = xp or {}
    interactivityKeys = interactivityKeys or {}

    --this function adds a new thing into entitiesIndex
    if spwName == nil then
        spwName = entityName
    end

    if drop == nil then
        drop = {}
    end

    if type(weakness) == "table" then
        weakness = bit.addBit({weakness})
    end

    --[[if spawnable then
        table.insert(entitySpawner.possibleSpawns, entityName)
    end]]

    entitiesIndex[entityName] = {
        entityName = entityName,
        walkable = walkable,
        spwName = spwName,
        HP = HP,
        weakness = weakness,
        strengthMin =
        strenght,
        drop = drop,
        height = height,
        width = width,
        luck = luck,
        interactivityKeys = interactivityKeys
    }
end

function entitiesIndex.f.init()
    --entitiesIndex.f.addIndex("second", 1, 5, bit.addBit({ bit.BIT1, bit.BIT4 }))
    --entitiesIndex.f.addIndex("snow", 0, 0, 0, true)
    
    --correct tree, now there's not any axe
    --entitiesIndex.f.addIndex("tree", 5, bit.addBit({bit.BIT2}), 1, {item = "leaf", baseCount = 2}, 1, 2, "foragingLuck", {"foragingLuck"})

    --pickaxeble tree!!!
    entitiesIndex.f.addIndex("tree", false, 5, bit.addBit({bit.BIT4}), 1, {{item = "leaf", baseCount = 2}, {item = "log", baseCount = 3}, {item = "stick", baseCount = 2}}, 1, 2, "foragingLuck", {"foragingLuck"})
    entitiesIndex.f.addIndex("small_chair", true, 2, bit.addBit({bit.BIT4}), 1, {{item = "small_chair", baseCount = 1}}, 1, 1, "", {}, {f = function () player.moveToTile(player.cursor.tileX, player.cursor.tileY - 0.65) player.vals.state = "sitting" end})
    entitiesIndex.f.addIndex("table", true, 2, bit.addBit({bit.BIT4}), 1, {{item = "table", baseCount = 1}}, 2, 1, "", {}, {})
    entitiesIndex.f.addIndex("flowers", true, 2, bit.addBit({bit.BIT4}), 1, {{item = "flowers", baseCount = 1}}, 1, 1, "", {}, {})

end

return entitiesIndex