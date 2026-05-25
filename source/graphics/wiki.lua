wiki = {
    data = {
        render = false,
        currentPage = nil,
    },
    buttons = {
        exit = {
            pos = {
                x = game.width - 50,
                y = 5,
                height = spw.getSprite("x_circle"):getHeight() * 1.3,
                width = spw.getSprite("x_circle"):getWidth() * 1.3,
                scalarX = 1.3,
                scalarY = 1.3
            },
            click = function ()
                wiki.data.render = false
            end,
            interactivityKey = 1,
            maxCooldown = 1,
            lastCooldown = 0
        }
    },
    f = {}
}

function wiki.f.renderer()
    UI.f.renderNineSquare(UI.nineSquareSpriteSheet.wiki, 5, 5, game.width - 10, game.height - 10, 11)
    local xBut = wiki.buttons.exit
    love.graphics.draw(spw.getSprite("x_circle"), xBut.pos.x, xBut.pos.y, 0, xBut.pos.scalarX, xBut.pos.scalarY)
    local mx, my = love.mouse.getPosition()
    for key, value in pairs(wiki.buttons) do
        value.lastCooldown = value.lastCooldown + love.timer.getDelta()
        if love.mouse.isDown(value.interactivityKey) and renderer.AABB(mx, my, 1, 1, value.pos.x, value.pos.y, value.pos.width, value.pos.height) and value.lastCooldown >= value.maxCooldown then
            value.click()
            value.lastCooldown = 0
            break
        end
    end

end

return wiki