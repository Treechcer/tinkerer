spw = {
    sprites = {
        cursor = { -- to create animated thing you have to do this structure, table
            sprs = {
                love.graphics.newImage("source/assets/sprites/cursor00.png"),
                love.graphics.newImage("source/assets/sprites/cursor01.png"),
                love.graphics.newImage("source/assets/sprites/cursor02.png"),
                love.graphics.newImage("source/assets/sprites/cursor03.png")
            },
        timer = 0.15,
        lastChange = 0,
        index = 1
        }
    }
}

function spw.changeFrames(dt) -- this is for changing the frames it's in every n seconds
    for name, sprite in pairs(spw.sprites) do
        if type(sprite) == "table" then
            if sprite.lastChange >= sprite.timer then
                sprite.index = sprite.index + 1
                sprite.lastChange = 0

                if sprite.index > #sprite.sprs then
                    sprite.index = 1
                end
            else
                sprite.lastChange = sprite.lastChange + dt
            end
        end
        --sprite = spw[index]
        --if (sprite.type == "table") then
        --    if sprite.lastChange >= sprite.timer then
        --        index = index + 1
        --    else
        --        sprite.lastChange = sprite.lastChange + dt
        --    end
        --end
    end
end

return spw