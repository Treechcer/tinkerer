init = {}

function init.initAll() -- this fuctions for inits that have to start on the beggining (in love.load())
    local player = require("source.game.player")
    player.init()

    local spw = require("source.assets.sprites.spriteWorker")
    spw.init()
end

return init