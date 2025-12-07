player = require("source.game.player")

run = {}

function run.everyFrameStart(dt)
    player.cursor.updatePos()
end

function run.everyFrameEnd(dt)
    
end

return run