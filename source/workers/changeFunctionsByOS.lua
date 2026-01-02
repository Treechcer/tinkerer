if game.os == "PSP" then
    ---@diagnostic disable: duplicate-set-field
    player.move = function (dt)
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

            local mvx = mvXc * player.atributes.speed * dt
            local mvy = mvYc * player.atributes.speed * dt

            player.camera.x = player.camera.x + mvx
            player.camera.y = player.camera.y + mvy

            player.position.tileX, player.position.tileY = renderer.calculateTile(player.position.x, player.position.y)

            player.position.chunkX = math.ceil((player.position.x + (player.size.width / 2)) / map.chunkWidth / map.tileSize)
            player.position.chunkY = math.ceil((player.position.y + (player.size.height / 2)) / map.chunkHeight / map.tileSize)

            player.cursor.x = player.cursor.x + mvx
            player.cursor.y = player.cursor.y + mvy
        end
    end

    ---@diagnostic disable: duplicate-set-field
    run.everyFrameStart = function (dt)
        player.cursor.updatePos()
        spw.changeFrames(dt)
        player.move(dt)
        inventory.functions.update(dt)
        inventory.functions.itemMove(dt)

        entitySpawner.func.spawn(dt)

        player.checkIfColided(dt)

        player.scroll = function ()
            if love.keyboard.isDown(settings.keys.scrollMinus) and (inventory.hotBar.lastTime >= inventory.hotBar.coolDown) and not (inventory.hotBar.selectedItem >= inventory.hotBar.maxItems) then
                inventory.hotBar.selectedItem = inventory.hotBar.selectedItem + 1
                inventory.hotBar.lastTime = 0
            end

            if love.keyboard.isDown(settings.keys.scrollPlus) and (inventory.hotBar.lastTime >= inventory.hotBar.coolDown) and not (inventory.hotBar.selectedItem <= 1) then
                inventory.hotBar.selectedItem = inventory.hotBar.selectedItem - 1
                inventory.hotBar.lastTime = 0
            end
        end

        player.cursor.consoles.last = player.cursor.consoles.last + dt
    end
end