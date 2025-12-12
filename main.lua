love = require("love")

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")

    player = require("source.game.player")
    map = require("source.world.map")
    REF = require("source.game.runEveryFrame")
    renderer = require("source.graphics.renderer")
    game = require("source.game.game")
    init = require("source.game.init")
    vectors = require("source.graphics.vectors")
    bit = require("source.workers.bit")

    bit.addBit({bit.BIT1, bit.BIT16, bit.BIT32})
    love.event.quit()

    init.initAll()
end

function love.draw()
    if game.state == "game" then
        renderer.gameStateRenderer()
    end
end

function love.update(dt)
    REF.everyFrameStart(dt)

    REF.everyFrameEnd(dt)
end