player = require("source.game.player")
spw = require("source.assets.sprites.spriteWorker")

run = {}

function run.everyFrameStart(dt) -- used to run on every frame when it starts
    player.cursor.updatePos()
    spw.changeFrames(dt)
    player.move(dt)
end

function run.everyFrameEnd(dt) -- used to run on every frame when it ends
    
end

return run