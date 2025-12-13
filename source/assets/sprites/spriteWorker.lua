spw = {
    sprites = {
        --cursor = { -- to create animated thing you have to do this structure, table
        --    sprs = {
        --        love.graphics.newImage("source/assets/sprites/cursor00.png"),
        --        love.graphics.newImage("source/assets/sprites/cursor01.png"),
        --        love.graphics.newImage("source/assets/sprites/cursor02.png"),
        --        love.graphics.newImage("source/assets/sprites/cursor03.png")
        --    },
        --    timer = 0.15,
        --    lastChange = 0,
        --    index = 1
        --}
    }
}

function spw.init()
    spw.generateNewSprite("cursor",{love.graphics.newImage("source/assets/sprites/cursor00.png"), love.graphics.newImage("source/assets/sprites/cursor01.png"), love.graphics.newImage("source/assets/sprites/cursor02.png"), love.graphics.newImage("source/assets/sprites/cursor03.png")}, 0.25)
    spw.generateNewSprite("rock", love.graphics.newImage("source/assets/sprites/rock.png"))
    spw.generateNewSprite("hammer", love.graphics.newImage("source/assets/sprites/hammer.png"))
end

---@param timer number?
function spw.generateNewSprite(name, sprs, timer)
    if timer == nil then
        spw.sprites[name] = { sprs = sprs }
    else
        local lastChange = 0;
        local index = 1
        spw.sprites[name] = { sprs = sprs, timer = timer, lastChange = lastChange, index = index }
    end
end

function spw.changeFrames(dt) -- this is for changing the frames it's in every n seconds
    for name, sprite in pairs(spw.sprites) do
        if type(sprite.sprs) == "table" then
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