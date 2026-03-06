pathfinding = {}

function pathfinding.getTileValues(self)
    self.tileX, self.tileY = renderer.calculateTile(self.x, self.y)
    self.chunkX, self.chunkY = renderer.calculateChunk(self.tileX, self.tileY)
    
    local relevantTiles = {
        --{x = n, y = m, , absTileX = o, absTileY = p, distance = q}
        --tiles that are neighboring the tile the origin is standing on
    }

    local wholeChunk = map.map.chunks[self.chunkY][self.chunkX].chunkData
    local chunkXpos = self.tileX % map.chunkWidth + 1
    local chunkYpos = self.tileY % map.chunkHeight + 1


    for y = -1, 1 do
        for x = -1, 1 do
            if x == 0 and y == 0 then
                goto continue
            end
            
            if pcall(function (xL,yL)
                if wholeChunk[xL][yL] then
                    
                end
            end, chunkXpos + x, chunkYpos + y) then
                table.insert(relevantTiles, {x = chunkXpos + x, y = chunkYpos + y, distance = ((x == 0 or y == 0) and 1 or math.floor((2 ^ (1/2)) * 100) / 100), absTileX = self.chunkX * map.chunkWidth - (chunkXpos + x), absTileY = self.chunkY * map.chunkHeight - (chunkYpos + y)})
                --print(chunkXpos + x, chunkYpos + y, ((x == 0 or y == 0) and 1 or math.floor((2 ^ (1/2)) * 100) / 100))
            else
                --TODO LATER BECAUSE IT WON'T WORK ON BORDERS OF CHUNKS!!!
            end

            ::continue::
        end
    end

    self.relevantTiles = relevantTiles

    --tables.writeTable(map.map.chunks[self.chunkY][self.chunkX].chunkData[self.tileY % map.chunkHeight + 1][self.tileX % map.chunkWidth + 1])
end

function pathfinding.renderValues(self)
    local x, y = renderer.getAbsolutePos(self.x, self.y)

    love.graphics.setColor(1,0,0)
    love.graphics.rectangle("fill", x, y, map.tileSize, map.tileSize)

    for key, value in pairs(self.relevantTiles) do
        local x_, y_ = renderer.getAbsolutePos(value.absTileX * map.tileSize, value.absTileY * map.tileSize)
        love.graphics.print(value.distance, x_ + (map.tileSize / 2) - (UI.fonts.normal:getWidth(value.distance) / 2), y_ + (map.tileSize / 2) - (UI.fonts.normal:getHeight(value.distance) / 2))
    end

    love.graphics.setColor(1,1,1)
end

return pathfinding