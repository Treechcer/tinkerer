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

return mathLib