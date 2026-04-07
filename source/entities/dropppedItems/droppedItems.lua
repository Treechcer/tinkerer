droppedItems = {
    items = {
        --{id, item = {item, count}, ???}
    },
    f = {}
}

function droppedItems.f.changeIndexByOne(index)
    for i = 1, #droppedItems.items do
        if i > index then
            droppedItems.droppedItems[i].id = droppedItems.droppedItems[i].id- 1
        end
    end
end

function droppedItems.f.create(tileX, tileY, item, count)
    local itemIndexItem = itemIndex[item]
    entities.makeNewOne(tileX, tileY, item, 1, {}, itemIndexItem.width / 2, itemIndexItem.height / 2, nil)
    table.insert(droppedItems, {id = #entities.ents, item = {item = item, count = count}})
    entities.ents[#entities.ents].isDroppedItem = true
    entities.ents[#entities.ents].shadowIndex = nil
    shadows.shadows[#shadows.shadows] = nil
end

return false