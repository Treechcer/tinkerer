--this is for item descriptions, there is also "description" in the itemIndex or it can be auto generated in a way

descption = {
    f = {}
}

function descption.f.gen(item)
    local str = ""

    --tables.writeTable(itemIndex)
    --print(item)

    str = str .. "Item: " .. item .. "\n"
    str = str .. "Type: " .. itemIndex[item].type

    return str
end

return descption