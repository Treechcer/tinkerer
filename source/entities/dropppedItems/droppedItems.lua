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
    --local itemIndexItem = itemIndex[item]
    entities.makeNewOne(tileX, tileY, item, 1, {}, 0.5, 0.5, nil)
    table.insert(droppedItems.items, {id = #entities.ents, item = {item = item, count = count}})
    entities.ents[#entities.ents].isDroppedItem = true
    entities.ents[#entities.ents].shadowIndex = nil
    shadows.shadows[#shadows.shadows] = nil
end

function droppedItems.f.delete(index)
    local DI = droppedItems.items[index]
    entities.moveByOneIndexAllSubClasses(droppedItems.items[index].id)
    inventory.functions.addItem(DI.item.item, DI.item.count)
    table.remove(entities.ents, DI.id)
    table.remove(droppedItems.items, index)
end

function droppedItems.f.collect()
    --console.f.callConsoleFunction("print", #droppedItems.items)
    for i = #droppedItems.items, 1, -1 do
        --console.f.callConsoleFunction("print", i)
        local value = droppedItems.items[i]
        local en = entities.ents[value.id]
        local cu = player.cursor
        --print(value.id, #entities.ents)
        if renderer.AABB(cu.tileX, cu.tileY, cu.width, cu.height, en.tileX, en.tileY, en.width, en.height) then
            droppedItems.f.delete(i)
        end
    end
end

return false