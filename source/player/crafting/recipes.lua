recipes = {
    recipes = {
        hammer = {
            recipe = {{item = "pebble", count = 5}, {item = "stick", count = 5}},
            result = {item = "hammer", count = 1}
        },
        small_chair = {
            recipe = {{item = "log", count = 5}, {item = "stick", count = 4}},
            result = {item = "small_chair", count = 1}
        },
        --TEST RECIPE, USED FOR WIKI!!!
        --TODO REMOVE!!
        rock = {
            recipe = {{item = "rock", count = 5}, {item = "leaf", count = 4}},
            result = {item = "rock", count = 1}
        }
    },
    recipesInOrder = {
        "hammer", "small_chair", "rock"
    }
}

return recipes