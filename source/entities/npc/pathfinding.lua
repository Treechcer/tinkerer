pathfinding = {
    functions = {}
}

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