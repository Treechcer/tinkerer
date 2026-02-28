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
    spw.generateNewSprite("rock")
    spw.generateNewSprite("hammer")
    spw.generateNewSprite("snow")
    spw.generateNewSprite("grass")
    spw.generateNewSprite("void")
    spw.generateNewSprite("hill")
    spw.generateNewSprite("sand")
    spw.generateNewSprite("cursorBuy",{ love.graphics.newImage("assets/sprites/cursor00.png"), love.graphics.newImage("assets/sprites/cursor01.png"), love.graphics.newImage("assets/sprites/cursor02.png"), love.graphics.newImage("assets/sprites/cursor03.png") }, 0.25)
    spw.generateNewSprite("dude", { love.graphics.newImage("assets/sprites/dude.png")})
    spw.generateNewSprite("dudeWalking", { love.graphics.newImage("assets/sprites/dude.png"), love.graphics.newImage("assets/sprites/dudeW1.png")}, 0.15, function () return player.vals.walking end)
    spw.generateNewSprite("leaf")
    spw.generateNewSprite("log")
    spw.generateNewSprite("stick")
    spw.generateNewSprite("tree")
    spw.generateNewSprite("small_chair")
    spw.generateNewSprite("dude_sitting")
    spw.generateNewSprite("table")
    spw.generateNewSprite("flowers")
    spw.generateNewSprite("furnace")
    spw.generateNewSprite("burning_furnace")
    spw.generateNewSprite("fueled_furnace")
    spw.generateNewSprite("pebble")
    spw.generateNewSprite("arrow")
    spw.generateNewSprite("chicken")
    spw.generateNewSprite("fire")
    spw.generateNewSprite("iron_ore")
end

---@param timer number?
function spw.generateNewSprite(name, sprs, timer, canMove)
    if sprs == nil then
        sprs = love.graphics.newImage("assets/sprites/" .. name .. ".png")
    end


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