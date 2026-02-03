spw = {
    sprites = {
        --cursor = { -- to create animated thing you have to do this structure, table
        --    sprs = {
        --        love.graphics.newImage("assets/sprites/cursor00.png"),
        --        love.graphics.newImage("assets/sprites/cursor01.png"),
        --        love.graphics.newImage("assets/sprites/cursor02.png"),
        --        love.graphics.newImage("assets/sprites/cursor03.png")
        --    },
        --    timer = 0.15,
        --    lastChange = 0,
        --    index = 1
        --}
    }
}

function spw.init()
    spw.generateNewSprite("cursor",{love.graphics.newImage("assets/sprites/cursor00.png"), love.graphics.newImage("assets/sprites/cursor01.png"), love.graphics.newImage("assets/sprites/cursor02.png"), love.graphics.newImage("assets/sprites/cursor03.png")}, 0.25)
    spw.generateNewSprite("rock", love.graphics.newImage("assets/sprites/rock.png"))
    spw.generateNewSprite("hammer", love.graphics.newImage("assets/sprites/hammer.png"))
    spw.generateNewSprite("snow", love.graphics.newImage("assets/sprites/snow.png"))
    spw.generateNewSprite("grass", love.graphics.newImage("assets/sprites/grass.png"))
    spw.generateNewSprite("void", love.graphics.newImage("assets/sprites/void.png"))
    spw.generateNewSprite("hill", love.graphics.newImage("assets/sprites/hill.png"))
    spw.generateNewSprite("sand", love.graphics.newImage("assets/sprites/sand.png"))
    spw.generateNewSprite("cursorBuy",{ love.graphics.newImage("assets/sprites/cursor00.png"), love.graphics.newImage("assets/sprites/cursor01.png"), love.graphics.newImage("assets/sprites/cursor02.png"), love.graphics.newImage("assets/sprites/cursor03.png") }, 0.25)
    spw.generateNewSprite("dude", { love.graphics.newImage("assets/sprites/dude.png")})
    spw.generateNewSprite("dudeWalking", { love.graphics.newImage("assets/sprites/dude.png"), love.graphics.newImage("assets/sprites/dudeW1.png")}, 0.15, function () return player.vals.walking end)
    spw.generateNewSprite("leaf", love.graphics.newImage("assets/sprites/leaf.png"))
    spw.generateNewSprite("log", love.graphics.newImage("assets/sprites/log.png"))
    spw.generateNewSprite("stick", love.graphics.newImage("assets/sprites/stick.png"))
    spw.generateNewSprite("tree", love.graphics.newImage("assets/sprites/tree.png"))
    spw.generateNewSprite("small_chair", love.graphics.newImage("assets/sprites/small_chair.png"))
    spw.generateNewSprite("dude_sitting", love.graphics.newImage("assets/sprites/dude_sitting.png"))
    spw.generateNewSprite("table", love.graphics.newImage("assets/sprites/table.png"))
    spw.generateNewSprite("flowers", love.graphics.newImage("assets/sprites/flowers.png"))
    spw.generateNewSprite("furnace", love.graphics.newImage("assets/sprites/furnace.png"))
    spw.generateNewSprite("burning_furnace", love.graphics.newImage("assets/sprites/burning_furnace.png"))
    spw.generateNewSprite("fueled_furnace", love.graphics.newImage("assets/sprites/fueled_furnace.png"))
    spw.generateNewSprite("pebble", love.graphics.newImage("assets/sprites/pebble.png"))
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