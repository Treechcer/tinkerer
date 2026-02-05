UI = {
    fonts = {
        normal = love.graphics.newFont(13)
    },
    renderder = {
        furnaceUI = {

        },
        craftingUI = {

        },
        descriptions = {
            data = {
                defaultX = 50,
                defaultY = 20,
            },
            f = {

            }
        }
    }
}

function UI.renderder.descriptions.f.render(x,y,description)
    love.graphics.setColor(1,1,1)
    local objDesc = UI.renderder.descriptions

    local width, height = objDesc.data.defaultX, objDesc.data.defaultY

    local font = UI.fonts.normal

    local w = font:getWidth(tostring(description))
    local _, count = string.gsub(description, "\n", "")
    local h = font:getHeight() * (count + 1)

    local padX = font:getWidth(" ") / 2
    local padY = font:getHeight() / 2

    width = (w > width) and w or width
    height = (h > height) and h or height

    love.graphics.rectangle("fill", x - padX, y - padY, width + (padX * 2), height + (padY * 2))
    love.graphics.setColor(0,0,0)
    love.graphics.print(description, x,y)
    love.graphics.setColor(1,1,1)
end

return UI