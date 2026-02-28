--this is for item descriptions, there is also "description" in the itemIndex or it can be auto generated in a way

description = {
    f = {}
}
---@param item string
---@param bonus string?
function description.f.gen(item, bonus)
    local str = ""

    --tables.writeTable(itemIndex[item])
    --print(item)
    --print(itemIndex[item])
    str = str .. "Item: " .. item

    if itemIndex[item].typeI ~= nil then
       str = str .. "\n" .. "Type: " .. itemIndex[item].typeI
    end

    if itemIndex[item].descriptor ~= nil then
        if itemIndex[item].descriptor ~= "" then
            str = str .. "\n" .. "description: " .. itemIndex[item].descriptor
        end
    end

    return str
end

return description