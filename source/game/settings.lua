settings = {
    graphic = {
        renderDistance = 11.5 --this lowers how far you can see
    },
    keys = {}
}

if game.os ~= "PSP" then
    settings.keys.up = "w"
    settings.keys.down = "s"
    settings.keys.left = "a"
    settings.keys.right = "d"
    settings.keys.openInventory = "e"

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