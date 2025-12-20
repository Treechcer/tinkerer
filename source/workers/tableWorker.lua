--mostly for debug and special table work :)

tables = {}

function tables.writeTable(t, index)
    if index == nil then
        index = 1
    end

    local indent = string.rep(" ", (index * 2))
    local tableStart = (index > 1) and string.rep(" ", (index * 2) - 1) or ""

    print(tableStart .. "{")

    for key, value in pairs(t) do
        if type(value) == "table" then
            print(indent .. key .. " : ")
            tables.writeTable(value, index + 1)
        elseif type(value) == "function" then
            print(indent .. key .. " : " .. tostring(value) .. "()")
        else
            print(indent .. key .. " : " .. value)
        end
    end
    print(tableStart .. "}")
end

--tables.writeTable({1,2,3,54, {1,4,8,5,4,4,8,{1545,1,1,654,4564,5,1,1,}}, a = "b", c = "d"})

return tables