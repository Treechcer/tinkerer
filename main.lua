love = require("love")

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")

    player = require("source.game.player")
    map = require("source.world.map")
    REF = require("source.game.runEveryFrame")
    renderer = require("source.graphics.renderer")
    game = require("source.game.game")
    init = require("source.game.init")

    init.initAll()
end

function love.draw()
    if game.state == "game" then
        renderer.gameStateRenderer()
    end
end

function love.update(dt)
    REF.everyFrameStart(dt)

    --this is temp walking

    if love.keyboard.isDown("w") then
        player.camera.y = player.camera.y - player.atributes.speed * dt
        player.position.y = player.position.y - player.atributes.speed * dt
    elseif love.keyboard.isDown("s") then
        player.camera.y = player.camera.y + player.atributes.speed * dt
        player.position.y = player.position.y + player.atributes.speed * dt
    end

    if love.keyboard.isDown("a") then
        player.camera.x = player.camera.x - player.atributes.speed * dt
        player.position.x = player.position.x - player.atributes.speed * dt
    elseif love.keyboard.isDown("d") then
        player.camera.x = player.camera.x + player.atributes.speed * dt
        player.position.x = player.position.x + player.atributes.speed * dt
    end

    REF.everyFrameEnd(dt)
end