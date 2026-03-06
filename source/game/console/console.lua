--THIS FILE MIGHT BE MOVED? I DIDN'T KNEW WHERE TO PUT IT!!!

console = {
    render = false,
    messages = {},
    maxMessages = 5,
    height = 400, --(px)
    f = {},
    cooldownToOpen = 0.2,
    lastOpen = 0.2,
    currentType = "",
    commands = {
        print = function (...)
            console.f.addMessage("-> " .. ...)
        end,
        spawn = function (...)
            local args = {...}

            if select("#", ...) > 3 then
                console.commands.print("Too many arguments.")
                return
            end

            entities.makeNewOne(...)
        end,
        give = function (...)
            if select("#", ...) > 2 then
                console.commands.print("Too many arguments.")
                return
            end

            local args = {...}
            inventory.functions.addItem(args[1], tonumber(args[2]))
            --if itemIndex[args[1]] ~= nil and tonumber(args[2]) > 0 then
            --    if tonumber(args[2]) > itemIndex[args[1]].maxStackSize then
            --        --I thought addItem was making something like this? I'll have to look into it later
            --        local c = tonumber(args[2])
            --        while c > 0 do
            --            inventory.functions.addItem(args[1], math.min(itemIndex[args[1]].maxStackSize, c))
            --            c = c - itemIndex[args[1]].maxStackSize
            --            if c < 0 then
            --                c = 0
            --            end
            --        end
            --    else
            --        inventory.functions.addItem(args[1], tonumber(args[2]))
            --    end
            --else
            --    console.commands.print("\"" .. args[1] .. "\"" .. " doesn't exist.")
            --end
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

        --print(game.height - height)

        height = (#console.messages < 1) and height + 18 or height

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

function console.f.addMessage(message)
    if #console.messages < console.maxMessages then
        table.insert(console.messages, message)
    else
        table.remove(console.messages, 1)
        table.insert(console.messages, message)
    end
end

return console