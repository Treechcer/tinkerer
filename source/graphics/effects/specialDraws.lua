specialDraws = {
    f = {}
}

--love.graphics.draw(drawable, x, y, r, sx, sy, ox, oy, kx, ky)

function specialDraws.f.outline(spr, x, y, r, sx, sy, ox, oy, kx, ky, color, outlineSize)
    --this will be changed for shader when I'll learn how to use them, for now this will only be standart draw
    love.graphics.draw(spw.sprites[spr].sprs, x, y, r, sx, sy, ox, oy, kx, ky)
end

return specialDraws