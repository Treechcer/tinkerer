building = {
    f = {},

}

function building.f.build()
    
end

function building.f.render(sprite, x, y, width, height)
    love.graphics.setColor(1,0.8,1,0.5)
    love.graphics.draw(sprite, x, y, 0, width /  sprite:getWidth(), height / sprite:getHeight())
    love.graphics.setColor(1,1,1,1)
end

return building