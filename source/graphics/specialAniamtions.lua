--this is used for objects that are specially animated, for example moving animation I tought would look good can be made like this

specialAnimations = {
    functions = {},
    objects = {}
}

function specialAnimations.functions.jumpyMovement()
    --for now onlxy for player, later I'll add like movement for anything yk but for testiong of how it'll look and whatnot
    local dt = love.timer.getDelta()
    local x, y = renderer.getAbsolutePos(player.position.x, player.position.y)
    if player.vals.walking and player.vals.state == "walking" then
        dudeSpr = spw.sprites.dudeWalking.sprs[spw.sprites.dudeWalking.index]
        specialAnimations.functions.jumpMove(dt)
    elseif player.vals.state == "sitting" then
        dudeSpr = spw.sprites.dude_sitting.sprs
    else
        dudeSpr = spw.sprites.dude.sprs[1]
    end

    local yMV = dudeSpr:getHeight() * 1.2

    love.graphics.draw(dudeSpr,
        x + player.size.width / 2, --X
        y + player.size.height / 2 + yMV + 25 - player.position.jumpySpace, --Y
        player.position.rotateM, --angle
        (player.size.width / dudeSpr:getWidth()) * (player.cursor.screenSide), --scaleX
        player.size.height / dudeSpr:getHeight(), --scaleY
        dudeSpr:getWidth() / 2, --origin point X
        yMV --origin point Y
    )

    if not (player.position.jumpySpace >= 0 and player.position.jumpySpace <= 3) and not (player.vals.walking and player.vals.state == "walking") then
        specialAnimations.functions.jumpMove(dt)
    end

    --print(player.position.jumpySpace)
end

function specialAnimations.functions.jumpMove(dt)
    if player.position.jumpySpace <= 24 and not player.position.moveDown then
        player.position.jumpySpace = player.position.jumpySpace + (100 * dt)
    elseif player.position.jumpySpace >= 0 and player.position.moveDown then
        player.position.jumpySpace = player.position.jumpySpace - (100 * dt)
    end

    if player.position.jumpySpace >= 24 then
        player.position.moveDown = true
        player.position.moveLeft = not player.position.moveLeft
    elseif player.position.jumpySpace <= 1 then
        player.position.moveDown = false
    end

    if player.position.moveLeft then
        player.position.rotateM = player.position.rotateM + (0.5 * dt)
    else
        player.position.rotateM = player.position.rotateM - (0.5 * dt)
    end
end

return specialAnimations