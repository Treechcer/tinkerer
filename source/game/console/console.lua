--THIS FILE MIGHT BE MOVED? I DIDN'T KNEW WHERE TO PUT IT!!!

console = {
    render = true,
    messages = {},
    maxMessages = 20,
    height = 400, --(px)
    f = {},
    cooldownToOpen = 0.2,
    lastOpen = 0.2,
    currentType = "",
    commands = {
        greet = function (...)
            print(...)
            table.insert(console.messages, "Hello " .. ...)
        end
    }
}

function console.f.render()
    if console.render then
        love.graphics.setColor(0.7,0.7,0.7,0.85)

        local messages = ""

        for index, value in ipairs(console.messages) do
            messages = messages .. value .. "\n"
        end
        
        local fHeight = UI.fonts.normal:getHeight(messages) * select(2, messages:gsub('\n', '\n'))
        local devider = #console.messages > 0 and #console.messages or 1
        local height = game.height - fHeight - 34 + (fHeight / devider)

        print(height)

        love.graphics.rectangle("fill", 0, height, game.width, game.height)
        love.graphics.setColor(1,1,1,1)
        love.graphics.print(messages, 0, game.height - fHeight - 17)
        love.graphics.print(console.currentType, 0, game.height - UI.fonts.normal:getHeight(console.currentType))
    end
end

function console.f.runCommand(command)
    command = string.sub(command, 2, #command)
    --print(command)
    local subCommands = {}
    local last = 1
    for i = 1, string.len(command) do
        --print(command:sub(i, i))
        if command:sub(i, i) == " " then
            table.insert(subCommands, command:sub(last, i-1))
            last = i + 1
        elseif i == string.len(command) then
            table.insert(subCommands, command:sub(last, i+1))
        end
    end

    --tables.writeTable(subCommands)

    if console.commands[subCommands[1]] ~= nil then
        local input = ""
        for i = 2, #subCommands do
            if i == 2 then
                input = "'" .. subCommands[i] .. "'"
            elseif i <= #subCommands then
                input = input .. ", '" .. subCommands[i] .. "'"
            end
        end
        local cmd = "console.commands." .. subCommands[1] .. "(" .. input .. ")"
        local a = load(cmd)
        if a ~= nil then
           a() 
        end
    end
end

return console