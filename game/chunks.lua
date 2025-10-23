chunks = {
    --land = {
    --    1,1,1,1,1,1,1,1,1
    --},
    --noLand = {
    --    0,0,0,0,0,0,0,0,0
    --},

    prefabs = {
        --[[landd =]] {
            {1,1,1,1,1,1,1,1,1},
            {1,1,1,1,1,1,1,1,1},
            {1,1,1,1,1,1,1,1,1},
            {1,1,1,1,1,1,1,1,1},
            {1,1,1,1,0,1,1,1,1},
            {1,1,1,1,1,1,1,1,1},
            {1,1,1,1,1,1,1,1,1},
            {1,1,1,1,1,1,1,1,1},
            {1,1,1,1,1,1,1,1,1},
        },
        ----[[noLandd =]] {
        --    {0,0,0,0,0,0,0,0,0},
        --    {0,0,0,0,0,0,0,0,0},
        --    {0,0,0,0,0,0,0,0,0},
        --    {0,0,0,0,0,0,0,0,0},
        --    {0,0,0,0,0,0,0,0,0},
        --    {0,0,0,0,0,0,0,0,0},
        --    {0,0,0,0,0,0,0,0,0},
        --    {0,0,0,0,0,0,0,0,0},
        --    {0,0,0,0,0,0,0,0,0},
        --},
        ----[[special =]] {
        --    {0,0,0,0,1,0,0,0,0},
        --    {0,0,0,1,1,1,0,0,0},
        --    {0,0,1,1,0,1,1,0,0},
        --    {0,1,1,1,1,1,1,1,0},
        --    {1,1,0,1,0,1,0,1,1},
        --    {0,1,1,1,1,1,1,1,0},
        --    {0,0,1,1,0,1,1,0,0},
        --    {0,0,0,1,1,1,0,0,0},
        --    {0,0,0,0,1,0,0,0,0},
        --},
    },
    specialPrefabs = {
        starter = {
            {1,1,1,1,1,1,1,1,1},
            {1,1,1,1,1,1,1,1,1},
            {1,1,1,1,1,1,1,1,1},
            {1,1,1,1,1,1,1,1,1},
            {1,1,1,1,0,1,1,1,1},
            {1,1,1,1,1,1,1,1,1},
            {1,1,1,1,1,1,1,1,1},
            {1,1,1,1,1,1,1,1,1},
            {1,1,1,1,1,1,1,1,1}, 
        }
    },
    biomeData = { -- this is for now "test" it'll get more sophisticated later
        --not really used now
    },
    biomeCost = {

    }
}

function chunks.biomeCost.makeCost(x, y)
    starterX = 4
    starterY = 4

    distance = math.abs(((starterX - x)^ 2 + (starterY - y)^ 2) ^ (1/2))

    c = math.floor(((distance + 1) * 50) + (math.log(distance, 10) * 10))

    c = c + ((c * math.abs((math.abs(math.sin(x * y)) ^ math.abs(math.cos(x * y))) ^ (math.abs(x-y)))) * ((y - 1) * 7 + x))

    c = c * game.dificultyMultiplayer

    c = c + 10 - (c % 10)

    player.money = player.money + c
    return c
end

function chunks.countF()
    local i = 0
    for key, value in pairs(chunks.prefabs) do
        i = i + 1
    end

    return i
end

chunks.count = chunks.countF()

print(chunks.count)

return chunks