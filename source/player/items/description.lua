--this is for item descriptions, there is also "description" in the itemIndex or it can be auto generated in a way

description = {
    splitBy = 24,
    f = {}
}
---@param item string
---@param bonus string?
function description.f.gen(item, bonus)
    local str = ""

    --tables.writeTable(itemIndex[item])
    --print(item)
    --print(itemIndex[item])
    str = str .. "Item: " .. item:gsub("_"," ")

    if itemIndex[item].typeI ~= nil then
       str = str .. "\n" .. description.f.splitBy("Type: " .. itemIndex[item].typeI, description.splitBy)
    end

    if itemIndex[item].descriptor ~= nil then
        if itemIndex[item].descriptor ~= "" then
            str = str .. "\n" .. description.f.splitBy("description: " .. itemIndex[item].descriptor, description.splitBy)
        end
    end

    return str
end

function description.f.splitBy(str, num)
    local unchangednum = num
    if str:len() > num then
        for i = -5, 5, 1 do
            local res = str:sub(num + i, num + i)
            print(res)
            if res == " " then
                num = num + i
                break
            end
        end
        local nextStr = str:sub(1, num) .. "\n" .. description.f.splitBy(str:sub(num+1, str:len()), unchangednum)
        return nextStr
    end

    return str
end

return description