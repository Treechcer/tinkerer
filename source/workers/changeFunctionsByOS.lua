if game.os == "PSP" or game.os == "PS3" then
    ---@diagnostic disable: duplicate-set-field
    player.move = function (dt)

        if inventory.inventoryBar.render then
            return
        end

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

    player.scroll = function (dt)
            player.cursor.consoles.last = player.cursor.consoles.last + dt
            local leftTrigger = love.keyboard.isDown(settings.keys.scrollMinus)
            local rightTrigger = love.keyboard.isDown(settings.keys.scrollPlus)

            if leftTrigger and not rightTrigger and (inventory.hotBar.lastTime >= inventory.hotBar.coolDown) and not (inventory.hotBar.selectedItem >= inventory.hotBar.maxItems) then
                inventory.hotBar.selectedItem = inventory.hotBar.selectedItem + 1
                inventory.hotBar.lastTime = 0
            end

            if rightTrigger and not leftTrigger and (inventory.hotBar.lastTime >= inventory.hotBar.coolDown) and not (inventory.hotBar.selectedItem <= 1) then
                inventory.hotBar.selectedItem = inventory.hotBar.selectedItem - 1
                inventory.hotBar.lastTime = 0
            end
        end

    player.cursor.pressing = function ()
        local down = false

        down = love.keyboard.isDown(settings.keys.scrollMinus) and love.keyboard.isDown(settings.keys.scrollPlus)

        if down then
            if itemInteraction.breakEntity() ~= false then
                return
            end
        
            if map.f.buyIsland(player.cursor.chunkX, player.cursor.chunkY) then
                return
            end
        end
    end

    player.cursor.updatePos = function () -- updates mouse position every frame - even calculates the tiles it's on
        if inventory.inventoryBar.render then
            return
        end

        if (player.cursor.consoles.cooldown <= player.cursor.consoles.last) then
            --player.cursor.tileX, player.cursor.tileY = renderer.calculateTile(player.cursor.x, player.cursor.y)

            local moveByX = game.leftJoy:getGamepadAxis("leftx")
            local moveByY = game.leftJoy:getGamepadAxis("lefty")

            moveByX = moveByX > 0.2 and 1 or moveByX < -0.2 and -1 or 0
            moveByY = moveByY > 0.2 and 1 or moveByY < -0.2 and -1 or 0

            player.cursor.tileX = moveByX + player.cursor.tileX
            player.cursor.tileY = moveByY + player.cursor.tileY

            player.cursor.tileX = player.cursor.tileX - (math.ceil(player.cursor.width / 2) - 1)
            player.cursor.tileY = player.cursor.tileY - (math.ceil(player.cursor.height / 2) - 1)

            --TODO: Fix the screenSide because on PSP id doesn't switch? idk why

            player.cursor.x, player.cursor.y = renderer.getWorldPos(player.cursor.tileX, player.cursor.tileY)

            player.cursor.screenSide = (player.cursor.x - player.position.x) >= 0 and 1 or -1

            player.cursor.chunkX = math.floor((player.cursor.tileX - 1) / map.chunkWidth) + 1
            player.cursor.chunkY = math.floor((player.cursor.tileY - 1) / map.chunkHeight) + 1

            --some kinds of limits so it's harder to lose it yk

            local dx = player.cursor.tileX - player.position.tileX
            if math.abs(dx) > 6 then
                player.cursor.tileX = player.position.tileX + 7 * ((dx > 0) and 1 or -1)
            end

            local dy = player.cursor.tileY - player.position.tileY
            if math.abs(dy) > 3 then
                player.cursor.tileY = player.position.tileY + 4 * ((dy > 0) and 1 or -1)
            end

            player.cursor.consoles.last = (moveByX ~= 0 or moveByY ~= 0) and 0 or player.cursor.consoles.last
        end

        player.cursor.pressing()
    end

    ---@diagnostic disable: duplicate-set-field
    inventory.functions.click = function (dt)
        local cd = inventory.inventoryBar.controller.cd
        cd.last = cd.last + love.timer.getDelta()
        if not inventory.inventoryBar.render then
            return false
        end

        local xMV = love.keyboard.isDown(settings.keys.left) and -1 or love.keyboard.isDown(settings.keys.right) and 1 or 0
        local yMV = love.keyboard.isDown(settings.keys.up) and -1 or love.keyboard.isDown(settings.keys.down) and 1 or 0
        local tilePos = inventory.inventoryBar.controller.pos
        local inv = inventory.inventoryBar
        local bl = inv.blockSize - inv.pad
        local place = false
        local split = false

        if cd.last >= cd.cd then
           place = love.keyboard.isDown(settings.keys.placeInventory)
           split = love.keyboard.isDown(settings.keys.splitInventory)
        end

        love.graphics.setColor(1,0,0)
        love.graphics.rectangle("line", inventory.hitboxTable.start.x + ((tilePos.x - 1) * inv.blockSize), inventory.hitboxTable.start.y + ((tilePos.y - 1) * inv.blockSize), bl, bl)

        if cd.last <= cd.cd then
            return false
        end

        --tilePos.y = ((tilePos.y + yMV) >= 1 and (tilePos.y + yMV) <= #inv.inventory)            and tilePos.y + yMV or tilePos.y
        --tilePos.x = ((tilePos.x + xMV) >= 1 and (tilePos.x + xMV) <= #inv.inventory[tilePos.y]) and tilePos.x + xMV or tilePos.x

        local newY = tilePos.y + yMV
        if newY >= 1 and newY <= #inv.inventory and yMV ~= 0 then
            tilePos.y = newY
            cd.last = 0
        end

        local newX = tilePos.x + xMV
        if newX >= 1 and newX <= #inv.inventory[tilePos.y] and xMV ~= 0 then
            tilePos.x = newX
            cd.last = 0
        end

        local res = false
        
        if place then
            res = inventory.functions.moveItems(tilePos.y, tilePos.x, settings.keys.placeInventory)
            cd.last = 0
        elseif split then
            res = inventory.functions.split(tilePos.y, tilePos.x, settings.keys.placeInventory)
            cd.last = 0
        end

        local barI = inventory.inventoryBar
        local rows = #barI.inventory
        local cols = barI.maxItemsPerInventory
        local totalW = cols * barI.blockSize
        local totalH = rows * barI.blockSize
        local xP = (game.width / 2) + ((tilePos.x - 1) * barI.blockSize) - (totalW / 2) + (barI.pad / 2) + (barI.blockSize / 1.75)
        local yP = (game.height / 2) + ((tilePos.y - 1) * barI.blockSize) - (totalH / 2) + (barI.pad / 2) + (barI.blockSize / 1.75)

        inventory.functions.renderItemOnCursor(xP, yP)

        love.graphics.print(tilePos.x .. " " .. tilePos.y, 10, 50)

        return res
    end
end