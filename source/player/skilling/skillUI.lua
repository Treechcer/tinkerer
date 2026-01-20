skillUI = {
    f = {},
    pad = 55,
    maxLength = 250,
    height = 12.5,
    render = false
}

function skillUI.f.render()
    if not skillUI.render then
        return
    end

    local index = 1
    local totalY = (#player.skillOrder - 1) * skillUI.pad + 10
    local startY = (game.height - totalY) / 2
    for key, value in pairs(player.skillOrder) do
        local y = startY + (index - 1) * skillUI.pad
        local skill = player.skills[value]
        local percent = skill.xp / skill.xpForNextLvl
        percent = (percent > 1) and 1 or percent
        love.graphics.setColor(0,0,0)
        love.graphics.rectangle("fill", game.width/2 - (skillUI.maxLength / 2), y, skillUI.maxLength, skillUI.height)
        love.graphics.setColor(mathWorker.lerp(0.7, 0.2, percent), mathWorker.lerp(0.2, 0.7, percent), 0)
        love.graphics.rectangle("fill", game.width/2 - (skillUI.maxLength / 2), y, skillUI.maxLength * percent, skillUI.height)
        love.graphics.setColor(1,1,1)
        love.graphics.print(value .. ": " .. skill.lvl, game.width/2 - (skillUI.maxLength / 2), y - (skillUI.height * 2))
        love.graphics.print(player.skills[value].canProgres and (math.floor(percent * 100) .. "%") or "MAX", game.width/2 - (skillUI.maxLength / 2) + skillUI.maxLength, y + (skillUI.height * 1.5))
        index = index + 1
    end

    love.graphics.setColor(1,1,1)
end

return skillUI