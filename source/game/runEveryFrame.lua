player = require("source.game.player")
spw = require("source.assets.sprites.spriteWorker")

run = {}

function run.everyFrameStart(dt)
    player.cursor.updatePos()
    spw.changeFrames(dt)
end

function run.everyFrameEnd(dt)
    
end

return run