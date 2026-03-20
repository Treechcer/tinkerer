--this is used for objects that are specially animated, for example moving animation I tought would look good can be made like this

specialAnimations = {
    functions = {},
    objects = {}
}

function specialAnimations.functions.jumpyMovement(obj, originalObject)
    obj.rotateM = obj.rotateM or 0
    obj.width = obj.width or 1
    obj.height = obj.height or 1
    obj.jumpySpace = obj.jumpySpace or 0
    obj.walking = obj.walking or true
    obj.screenSide = obj.screenSide or 1
    obj.moveDown = obj.moveDown or false
    obj.moveLeft = obj.moveLeft or true
    obj.xP = obj.xP or obj.x or obj.tileX
    obj.yP = obj.yP or obj.y or obj.tileY
    obj.spr = obj.spr or spw.sprites[obj.index].sprs

    local dt = love.timer.getDelta()
    --tables.writeTable(obj)
    local x, y = renderer.getAbsolutePos(obj.xP, obj.yP)
    if obj.walking then
        specialAnimations.functions.jumpMove(dt, obj)
    end

    local yMV = obj.spr:getHeight() * 1.2

    love.graphics.draw(obj.spr,
        x + obj.width / 2, --X
        y + obj.height / 2 + yMV + 25 - obj.jumpySpace, --Y
        obj.rotateM, --angle
        (obj.width / obj.spr:getWidth()) * (obj.screenSide), --scaleX
        obj.height / obj.spr:getHeight(), --scaleY
        obj.spr:getWidth() / 2, --origin point X
        yMV --origin point Y
    )

    if not (obj.jumpySpace >= 0 and obj.jumpySpace <= 3) and not (obj.walking and obj.state == "walking") then
        specialAnimations.functions.jumpMove(dt, obj)
    end

    if obj.update ~= nil then
        obj.update(obj, originalObject)
    else
        specialAnimations.functions.updateObj(obj, originalObject)
    end
    
    --print(player.position.jumpySpace)

    return originalObject
end

function specialAnimations.functions.jumpMove(dt, obj)
    if obj.jumpySpace <= 24 and not obj.moveDown then
        obj.jumpySpace = obj.jumpySpace + (100 * dt)
    elseif obj.jumpySpace >= 0 and obj.moveDown then
        obj.jumpySpace = obj.jumpySpace - (100 * dt)
    end

    if obj.jumpySpace >= 24 then
        obj.moveDown = true
        obj.moveLeft = not obj.moveLeft
    elseif obj.jumpySpace <= 1 then
        obj.moveDown = false
    end

    if obj.moveLeft then
        obj.rotateM = obj.rotateM + (0.5 * dt)
    else
        obj.rotateM = obj.rotateM - (0.5 * dt)
    end
end

function specialAnimations.functions.updateObj(obj, originalObject)
    originalObject.rotateM = obj.rotateM
    originalObject.x = obj.xP
    originalObject.y = obj.yP
    originalObject.state = obj.state
    originalObject.width = obj.width
    originalObject.height = obj.height
    originalObject.jumpySpace = obj.jumpySpace
    originalObject.walking = obj.walking
    originalObject.screenSide = obj.screenSide
    originalObject.moveDown = obj.moveDown
    originalObject.moveLeft = obj.moveLeft
end

return specialAnimations