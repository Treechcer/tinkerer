vectors = {}

function vectors.normalise(x, y)
    local length = math.sqrt(x ^ 2 + y ^ 2)
    if length == 0 then
        return x, y
    end
    local xNormalsied = x / length
    local yNormalsied = y / length

    return xNormalsied, yNormalsied
end

return vectors