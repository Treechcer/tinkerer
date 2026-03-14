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

function pathfinding.functions.startMoving(entityID, startPoint, endPoint)
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
                    local node = pathfinding.functions.generateNode(mathWorker.positionDistance({x = 0, y = 0}, {x = x, y = y}),  mathWorker.positionDistance(pos, endPoint), pos, q)
                    table.insert(openList, node)
                end
            end
        end
    end
end

function pathfinding.functions.copyTable(t)
    local TABLE = {}

    for key, value in pairs(t) do
        if type(value) ~= "table" then
            TABLE[key] = value
        elseif type(value) == "table" then
            TABLE[key] = pathfinding.functions.copyTable(value)
        end
    end

    return TABLE
end

--TODO: REVISIT THIS LATER and make it work :(

--function pathfinding.nodeCreate(position, distance, priority, possibleDirections, self)
--    if self == nil then
--        self = {}
--    end
--    self.position = position
--    self.distance = distance
--    self.priority = priority
--    self.possibleDirections = possibleDirections
--
--    self.updatePriority = function (self, x, y)
--        self.priority = self.distance + mathWorker.tileDistance(self.position.tileX - x, self.position.tileY - y)
--    end
--
--    self.move = function (self, d)
--        if self.possibleDirections == 8 and d % 2 ~= 0 then
--            self.distance = self.distance + 14
--        else
--            self.distance = self.distance + 10
--        end
--    end
--
--    local metatable = {
--        __lt = function (a, b)
--            return a.priority < b.priority
--        end
--    }
--
--    setmetatable(self, metatable)
--
--    return self
--end
--
--function pathfinding.functions.chooseDirection(x, possibleDirections)
--    return (math.floor(x + possibleDirections / 2)) % possibleDirections
--end
--
--function pathfinding.functions.genPath(dirMap, xA, yA, x, y, dx, dy, possibleDirections)
--    dx = dx or {1,1,0,-1,-1,-1,0,1}
--    dy = dy or {0,1,1,1,0,-1,-1,-1}
--    possibleDirections = possibleDirections or 8
--    path = {}
--    while not (x == xA and y == yA) do
--        local j = dirMap[y][x]
--        local c = tostring(pathfinding.functions.chooseDirection(j, possibleDirections))
--        table.insert(path, c)
--        x = x + dx[j]
--        y = y + dy[j]
--    end
--
--    return path
--end

return pathfinding