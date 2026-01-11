local game = require("source.game.game")

player = {
    position = {
        x = 0,
        y = 0,

        tileX = 0,
        tileY = 0,

        chunkX = 0,
        chunkY = 0
    },
    size = {
        width = math.floor(map.tileSize),
        height = math.floor(map.tileSize * 2 - (map.tileSize / 1.5))
    },
    cursor = {
        x = 0,
        y = 0,

        tileX = 0,
        tileY = 0,

        frameNum = 0,
        screenSide = 1, -- 1 => right side of screen, -1 => left side of screen

        height = 1,
        width = 1,

        chunkX = 0,
        chunkY = 0,

        consoles = {
            cooldown = 0.1,
            last = 0
        }
    },
    camera = {
        x = 0,
        y = 0,
    },
    atributes = {
        speed = 250
    }
}

function player.init() -- initialises the position of player
    local xMove = (map.chunkWidthNum * map.tileSize * map.chunkWidth) / 2
    local yMove = (map.chunkHeightNum * map.tileSize * map.chunkHeight) / 2

    local midX = math.floor(game.width / 2 - player.size.width / 2)
    local midY = math.floor(game.height / 2 - player.size.height / 2)

    player.position.x = xMove
    player.position.y = yMove

    player.camera.x = player.camera.x + xMove - midX
    player.camera.y = player.camera.y + yMove - midY

    player.position.absX, player.position.absY = renderer.calculateTile(player.position.x, player.position.y)
    --print(player.position.absX, " ", player.position.absY)

    player.cursor.x = xMove
    player.cursor.y = yMove

    player.cursor.tileX, player.cursor.tileY = renderer.calculateTile(player.cursor.x, player.cursor.y)

end

---@diagnostic disable: duplicate-set-field
function player.move(dt)
    local mvXp = 0
    local mvYp = 0
    local mvXc = 0
    local mvYc = 0
    if love.keyboard.isDown(settings.keys.up) then
        mvYp = -1
        mvYc = -1
    elseif love.keyboard.isDown(settings.keys.down) then
        mvYp = 1
        mvYc = 1
    end

    if love.keyboard.isDown(settings.keys.left) then
        mvXp = -1
        mvXc = -1
    elseif love.keyboard.isDown(settings.keys.right) then
        mvXp = 1
        mvXc = 1
    end

    mvXp, mvYp = vectors.normalise(mvXp, mvYp)
    mvXc, mvYc = mvXp, mvYp

    local nextX = player.position.x + mvXp * player.atributes.speed * dt
    local nextY = player.position.y + mvYp * player.atributes.speed * dt

    --this sctrict movemt is temporary until I need to redo it, when I'll need to redo it it'll be redone
    --TODO make good movement that doesn't suck balls
    if renderer.checkCollsion(renderer.getWorldPos(renderer.calculateTile(nextX, nextY))) and
        renderer.checkCollsion(renderer.getWorldPos(renderer.calculateTile(nextX, nextY + player.size.height))) and
        renderer.checkCollsion(renderer.getWorldPos(renderer.calculateTile(nextX + player.size.width, nextY))) and
        renderer.checkCollsion(renderer.getWorldPos(renderer.calculateTile(nextX + player.size.width, nextY + player.size.height))) and
        renderer.checkCollsion(renderer.getWorldPos(renderer.calculateTile(nextX, nextY + (player.size.height / 2)))) and
        renderer.checkCollsion(renderer.getWorldPos(renderer.calculateTile(nextX + player.size.width, nextY + (player.size.height / 2)))) and 
        entities.isEntityOnTile(renderer.calculateTile(nextX + (map.tileSize / 2), nextY)) < 0 and
        entities.isEntityOnTile(renderer.calculateTile(nextX + (map.tileSize / 2), nextY + map.tileSize)) < 0 and
        entities.isEntityOnTile(renderer.calculateTile(nextX + (map.tileSize / 2), nextY + (2 * map.tileSize))) < 0 then
        player.position.x = nextX
        player.position.y = nextY

        player.camera.x = player.camera.x + mvXc * player.atributes.speed * dt
        player.camera.y = player.camera.y + mvYc * player.atributes.speed * dt

        player.position.tileX, player.position.tileY = renderer.calculateTile(player.position.x, player.position.y)

        player.position.chunkX = math.ceil((player.position.x + (player.size.width / 2)) / map.chunkWidth / map.tileSize)
        player.position.chunkY = math.ceil((player.position.y + (player.size.height / 2)) / map.chunkHeight / map.tileSize)
    end
end

function player.checkIfColided(dt)
    if not renderer.checkCollsion(renderer.getWorldPos(renderer.calculateTile(player.position.x, player.position.y))) then

        --this is temporary thingy, I would have to make my movement final yk

        local mov = (player.atributes.speed / 2) * dt
        player.position.x = player.position.x + mov
        player.camera.x = player.camera.x + mov
    end
end

function player.cursor.updatePos(dt) -- updates mouse position every frame - even calculates the tiles it's on

    --dt is ignored because I have to parse it here from runEveryFrame, it's easier than other solution

    player.cursor.x = love.mouse.getX() + player.camera.x
    player.cursor.y = love.mouse.getY() + player.camera.y

    player.cursor.tileX, player.cursor.tileY = renderer.calculateTile(player.cursor.x, player.cursor.y)

    --offset for it being better looking (if the width or height is > 2)

    player.cursor.tileX = player.cursor.tileX - (math.ceil(player.cursor.width / 2) - 1)
    player.cursor.tileY = player.cursor.tileY - (math.ceil(player.cursor.height / 2) - 1)

    player.cursor.screenSide = (game.width / 2 <= (player.cursor.x - player.camera.x)) and 1 or -1

    player.cursor.chunkX = math.floor((player.cursor.tileX - 1) / map.chunkWidth) + 1
    player.cursor.chunkY = math.floor((player.cursor.tileY - 1) / map.chunkHeight) + 1

    --player.cursor.pressing()
end

--function player.cursor.pressing()
--    local down = false
--
--    down = love.mouse.isDown(1)
--
--    if down then
--        if itemInteraction.breakEntity() ~= false then
--            return
--        end
--
--        if map.f.buyIsland(player.cursor.chunkX, player.cursor.chunkY) then
--            return
--        end
--    end
--end

return player