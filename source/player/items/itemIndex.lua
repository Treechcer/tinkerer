--HERE WILL BE ONLY ITEMS AS "JSON" FUNCTIONS FOR ITEMS WILL BE IN OTHER FILES

--This is temporary item, it shows how I want to store items later

items = {
    rock = {
        maxStackSize = 64,
        attack = 1,
        weakness = bit.addBit({ bit.BIT4 }),
        strength = 1,
        defaultHp = 5,
        drop = { item = "rock", count = 5 },
        speedAttackMultiplayer = 7, -- 5 = normal speed
        attackRotation = 1, --1.5 is normal rotation for most items, rock can attack faster, not like it's strong
        buildable = false,
        width = 1,
        height = 1,
        burnable = false,
        burnStrength = 0,
        smeltsTo = {item = "hammer", count = 1, needs = 1},
    },
    hammer = {
        maxStackSize = 1,
        attack = 1,
        weakness = bit.addBit({ bit.BIT1, bit.BIT4 }),
        strength = 1,
        defaultHp = nil,
        drop = nil,
        speedAttackMultiplayer = 5,
        attackRotation = 1.5,
        buildable = false,
        width = 1,
        height = 1,
        burnable = false,
        burnStrength = 0,
        smeltsTo = nil
    }
}



return items