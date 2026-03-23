pathfinding = {
    functions = {}
}

function pathfinding.functions.generateNode(g, h, pos, parentNode)
    local t = {
        g = g,
        h = h,
        f = g + h,
        pos = pos,
        parentNode = parentNode
    }
    
    return t
end

function pathfinding.functions.startMoving(startPoint, endPoint)
    --tables.writeTable(endPoint)
    if not map.f.accesibleTile(endPoint.x, endPoint.y) then
        return nil
    end
    local openList = {pathfinding.functions.generateNode(0,  mathWorker.positionDistance(startPoint, endPoint), startPoint, nil)}
    local closedList = {}

    while #openList > 0 do
        local min = openList[1].f
        local index = 1
        for index0, value in ipairs(openList) do
            if value.f < min then
                min = value.f
                index = index0
            end
        end

        local q = openList[index]
        table.remove(openList, index)
        table.insert(closedList, q)

        for y = -1, 1 do
            for x = -1, 1 do
                if x ~= 0 or y ~= 0 then
                    local pos = {x = q.pos.x + x, y = q.pos.y + y}
                    if q.pos.x + x == endPoint.x and q.pos.y + y == endPoint.y then
                        local path = {}
                        local node = q
                        table.insert(path, 1, endPoint)
                        while node ~= nil do
                            table.insert(path, 1, node.pos)
                            node = node.parentNode
                        end

                        return path
                    end

                    isSkip = false
                    for _, v in ipairs(openList) do
                        if v.pos.x == pos.x and v.pos.y == pos.y then
                            isSkip = true
                            break
                        end
                    end

                    for _, v in ipairs(closedList) do
                        if v.pos.x == pos.x and v.pos.y == pos.y then
                            isSkip = true
                            break
                        end
                    end

                    if not map.f.accesibleTile(pos.x, pos.y) then
                        isSkip = true
                    end

                    if not isSkip then
                        local node = pathfinding.functions.generateNode(q.g + mathWorker.positionDistance({x = 0, y = 0}, {x = x, y = y}), mathWorker.positionDistance(pos, endPoint), pos, q)
                        table.insert(openList, node)
                    end
                end
            end
        end
    end
end

function pathfinding.functions.visualisePath(path)
    love.graphics.setColor(0.5,0,0,0.75)
    --tables.writeTable(path)
    for key, value in pairs(path) do
        local x, y = renderer.getAbsolutePos(value.x * map.tileSize, value.y * map.tileSize)
        love.graphics.rectangle("fill", x, y, map.tileSize, map.tileSize)
    end
    love.graphics.setColor(1,1,1,1)
end

return pathfinding