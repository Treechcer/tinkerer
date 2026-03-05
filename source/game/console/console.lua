--THIS FILE MIGHT BE MOVED? I DIDN'T KNEW WHERE TO PUT IT!!!

console = {
    render = true,
    messages = {"test", "test", "test", "test", "test"},
    maxMessages = 20,
    height = 400, --(px)
    f = {},
    cooldownToOpen = 0.2,
    lastOpen = 0.2,
    currentType = ""
}

function console.f.render()
    if console.render then
        love.graphics.setColor(0.7,0.7,0.7,0.85)

        local messages = ""

        for index, value in ipairs(console.messages) do
            messages = messages .. value .. "\n"
        end

        local fHeight = UI.fonts.normal:getHeight(messages) * select(2, messages:gsub('\n', '\n'))

        love.graphics.rectangle("fill", 0, game.height - fHeight - 34 + (fHeight / #console.messages), game.width, game.height)
        love.graphics.setColor(1,1,1,1)
        love.graphics.print(messages, 0, game.height - fHeight - 17)
        love.graphics.print(console.currentType, 0, game.height - UI.fonts.normal:getHeight(console.currentType))
    end
end

return console