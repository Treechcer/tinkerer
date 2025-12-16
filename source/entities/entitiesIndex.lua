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
        drop = { item = "rock", count = 5 },
    }
}


---@param entityName string
---@param spwName string?
---@param HP integer
---@param weakness integer
---@param strenght integer
function entitiesIndex.f.addIndex(entityName, HP, weakness, strenght, spwName, drop)
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

    entitiesIndex[entityName] = {
        entityName = entityName,
        spwName = spwName,
        HP = HP,
        weakness = weakness,
        strengthMin =
    strenght, drop = drop }
end

function entitiesIndex.f.init()
    --entitiesIndex.f.addIndex("second", 1, 5, bit.addBit({ bit.BIT1, bit.BIT4 }))
    --entitiesIndex.f.addIndex("snow", 0, 0, 0)
end

return entitiesIndex