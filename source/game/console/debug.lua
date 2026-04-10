--this is debug console commands mostly, this shouldn't be used in release

debug = {
    f = {
        
    }
}

function debug.f.init()
    local dbprnt = function (...)
        local tab = {...}
        severity = tab[1]
        if severity == "high" then
            severity = "⨻"
        elseif severity == "mild" then
            severity = "⨺"
        else
            severity = "✓"
        end
        tab[1] = severity
        console.commands.print(tab)
    end
    console.f.addCommand("debugPrint", dbprnt)
    --if severity == "high" then
    --    severity = "⨻"
    --elseif severity == "mild" then
    --    severity = "⨺"
    --else
    --    severity = "✓"
    --end
    --console.commands.print(severity, ...)
end

return debug