npcIndex = {
    functions = {

    },
    data = {

    }
}

function npcIndex.functions.addIndex(npcName, sprite, hostility, move) -- later here will be more code
    table.insert(npcIndex.data, {npcName = npcName, sprite = sprite, hostility = hostility, move = move})
end

return npcIndex