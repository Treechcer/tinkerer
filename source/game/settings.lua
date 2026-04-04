settings = {
    graphic = {
        renderDistance = 11.5 --this lowers how far you can see
    },
    sound = {
        music = 10,
        sfx = 10,
        dialogue = 10,
        etc = 10
    },
    difficulty = 1, -- this is number that can range from 1 to 5 and makes the game harder the bigger it is
    keys = {}
}

if game.os ~= "PSP" then
    settings.keys.up = "w"
    settings.keys.down = "s"
    settings.keys.left = "a"
    settings.keys.right = "d"
    settings.keys.openInventory = "e"
    settings.keys.openConsole = "t"

    settings.keys.entityInteract = {"f"}
elseif game.os == "PSP" then
    settings.keys.up = "triangle"
    settings.keys.down = "cross"
    settings.keys.left = "square"
    settings.keys.right = "circle"

    settings.keys.openInventory = "left"
    settings.keys.closeInventory = "left"
    settings.keys.placeInventory = "right"
    settings.keys.splitInventory = "up"

    settings.keys.moveUpInventory = "up"
    settings.keys.moveDownInventory = "down"
    settings.keys.moveLeftInventory = "left"
    settings.keys.moveRightInventory = "right"

    settings.keys.scrollMinus = "l"
    settings.keys.scrollPlus = "r"
end

return settings