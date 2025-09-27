map = require("game.map")
camera = require("game.camera")

spawner = {
    objects = {}-- tables of tables, every table will be like : {x, y, sprite, metadata, h, w} -> metadata is additional data, it can be blank ('nil') or have something in, 
                -- for example stone can have how much it gives XP when broken or how many stones drop etc.
                -- x and y are tiles, every chunk is 9x9 and there are 7x7 chunks, so its 63x63 map I think?
}

-- this is here because VS code was screaming at me (I should use this ngl)

---@param x integer
---@param y integer
---@param metadata table
---@param h integer?
---@param w integer?
function spawner.createObject(x, y, sprite, metadata, h, w)
    h = h or 1
    w = w or 1
    table.insert(spawner.objects, {x = x, y = y, sprite = sprite, metadata = metadata, h = h, w = w})
end

function spawner.drawObjs(sprites)
    love.graphics.setColor(1,1,1)
    for index, value in ipairs(spawner.objects) do
        adjPos = camera.calculateZoom(value.x * map.blockSize, value.y * map.blockSize, map.blockSize, map.blockSize)
        love.graphics.draw(sprites[value.sprite], adjPos.x, adjPos.y, 0, (3 * value.h) / camera.zoom, (3 * value.w) / camera.zoom)
    end
end

return spawner