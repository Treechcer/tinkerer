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