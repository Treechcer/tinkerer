player = require("source.player.player")
spw = require("source.workers.spriteWorker")

run = {}

--if game.os ~= "PSP" then
--    run.functionsToRun = {
--        player.cursor.updatePos,
--        spw.changeFrames,
--        player.move,
--        inventory.functions.update,
--        inventory.functions.itemMove,
--
--        entitySpawner.func.spawn,
--
--        player.checkIfColided,
--        inventory.functions.coolDown,
--        --inventory.functions.click
--    }
--
--    run.functionsToRunEnd = {
--    
--    }
--else
--    run.functionsToRun = {
--        player.cursor.updatePos,
--        spw.changeFrames,
--        player.move,
--        inventory.functions.update,
--        inventory.functions.itemMove,
--
--        entitySpawner.func.spawn,
--
--        player.checkIfColided,
--        inventory.functions.coolDown,
--
--        player.scroll
--    }
--
--    run.functionsToRunEnd = {
--        
--    }
--end
--function run.everyFrameStart(dt) -- used to run on every frame when it starts
--    for _, func in pairs(run.functionsToRun) do
--        func(dt)
--    end
--end
--
--function run.everyFrameEnd(dt) -- used to run on every frame when it ends
--    for _, func in pairs(run.functionsToRunEnd) do
--        func(dt)
--    end
--end

function run.everyFrameStart(dt) -- used to run on every frame when it starts
    entities.updateAll(dt)
    player.cursor.updatePos(dt)
    spw.changeFrames(dt)
    player.move(dt)
    inventory.functions.changeItemByNumber()
    inventory.functions.update(dt)
    inventory.functions.itemMove(dt)

    entitySpawner.func.spawn(dt)

    player.checkIfColided(dt)
    inventory.functions.coolDown(dt)
    entityInteractivity.f.interact(settings.keys.entityInteract)

    entities.special()
    entityCleaner.f.update(dt)
    --inventory.functions.click()
end

function run.everyFrameEnd(dt) -- used to run on every frame when it ends

end

return run