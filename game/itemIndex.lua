itemIdex = {
    hammer = {
        type = "tool",
        stoneDMG = 2,
        woodDMG = 0,
        attackDMG = 2,
        width = 0, -- this is for building, so tools have 0
        height = 0
    },
    furnace = {
        type = "buildable",
        stoneDMG = 0,
        woodDMG = 0,
        attackDMG = 0,
        width = 2,
        height = 2
    }

}

function itemIdex.makeItemUsable(item)
    if itemIdex[item].type == "tool" then
        --for now pass, I don't feel good today
    end
end

return itemIdex