--HERE WILL BE ONLY ITEMS AS "JSON" FUNCTIONS FOR ITEMS WILL BE IN OTHER FILES

--This is temporary item, it shows how I want to store items later

items = {
    ironOre = {
        maxStackSize = 64,
        attack = 1,
        weakness = bit.addBit({ bit.BIT1 }),
        strength = 1
    },
    hammer = {
        maxStackSize = 1,
        attack = 1,
        weakness = bit.addBit({ bit.BIT1, bit.BIT8 }),
        strength = 1
    }
}

return items