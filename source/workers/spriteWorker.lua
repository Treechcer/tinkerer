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
    spw.generateNewSprite("snow", love.graphics.newImage("source/assets/sprites/snow.png"))
    spw.generateNewSprite("grass", love.graphics.newImage("source/assets/sprites/grass.png"))
    spw.generateNewSprite("void", love.graphics.newImage("source/assets/sprites/void.png"))
    spw.generateNewSprite("hill", love.graphics.newImage("source/assets/sprites/hill.png"))
    spw.generateNewSprite("sand", love.graphics.newImage("source/assets/sprites/sand.png"))
    spw.generateNewSprite("cursorBuy",{ love.graphics.newImage("source/assets/sprites/cursor00.png"), love.graphics.newImage("source/assets/sprites/cursor01.png"), love.graphics.newImage("source/assets/sprites/cursor02.png"), love.graphics.newImage("source/assets/sprites/cursor03.png") }, 0.25)
    spw.generateNewSprite("dude", { love.graphics.newImage("source/assets/sprites/dude.png")})
    spw.generateNewSprite("dudeWalking", { love.graphics.newImage("source/assets/sprites/dude.png"), love.graphics.newImage("source/assets/sprites/dudeW1.png")}, 0.15, function () return player.vals.walking end)
end

---@param timer number?
function spw.generateNewSprite(name, sprs, timer, canMove)
    if timer == nil then
        spw.sprites[name] = { sprs = sprs }
    else
        local lastChange = 0;
        local index = 1
        canMove = canMove or function() return true end
        spw.sprites[name] = { sprs = sprs, timer = timer, lastChange = lastChange, index = index, canMove = canMove }
    end
end

function spw.changeFrames(dt) -- this is for changing the frames it's in every n seconds
    for name, sprite in pairs(spw.sprites) do
        if type(sprite.sprs) == "table" then
            if sprite.lastChange ~= nil and sprite.timer ~= nil then
                local res = sprite.canMove()

                if sprite.lastChange >= sprite.timer and res then
                    sprite.index = sprite.index + 1
                    sprite.lastChange = 0

                    if sprite.index > #sprite.sprs then
                        sprite.index = 1
                    end
                else
                    sprite.lastChange = sprite.lastChange + dt
                end

                if not res then
                    sprite.lastChange = 0
                    sprite.index = 1
                end
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