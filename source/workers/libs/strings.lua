--Ths is used for functions that manipulate with string

strings = {
    
}

function strings.split(str, splitBy)
    parts = {}
    
    for part in str:gmatch(splitBy) do
        table.insert(parts, part)
    end

    return parts
end

function strings.trim(str)
    return str:gsub("^%s", ""):gsub("%s$", "")
end

function string.trimBy(str, num)
    return str:sub(1, str:len()-num)
end

return strings