player = require("source.game.player")
spw = require("source.workers.spriteWorker")

run = {}

if game.os ~= "PSP" then
    run.functionsToRun = {
        player.cursor.updatePos,
        spw.changeFrames,
        player.move,
        inventory.functions.update,
        inventory.functions.itemMove,

        entitySpawner.func.spawn,

        player.checkIfColided,
        inventory.functions.coolDown,
        inventory.functions.click
    }
else
    run.functionsToRun = {
        player.cursor.updatePos,
        spw.changeFrames,
        player.move,
        inventory.functions.update,
        inventory.functions.itemMove,

        entitySpawner.func.spawn,

        player.checkIfColided,
        inventory.functions.coolDown,

        player.scroll,
    }
end

function run.everyFrameStart(dt) -- used to run on every frame when it starts
    for _, func in pairs(run.functionsToRun) do
        func(dt)
    end
end

function run.everyFrameEnd(dt) -- used to run on every frame when it ends
    
end

return run