mathLib = {

}

function mathLib.normaliseVec(x, y)
    local len = math.sqrt(y^2 + x^2)
    if len ~= 0 then
        local rX = x / len
        local rY = y / len

        return rX, rY
    end

    return x, y
end

function mathLib.AABBcol(rect1, rect2)
    if (rect1.x < rect2.x + rect2.width) and (rect1.x + rect1.width > rect2.x) and (rect1.y < rect2.y + rect2.height) and (rect1.y + rect1.height > rect2.y) then
        return true
    else
        return false
    end
end

return mathLib