specialDraws = {
    f = {}
}

--love.graphics.draw(drawable, x, y, r, sx, sy, ox, oy, kx, ky)

---comment
---@param r any?
---@param sx any?
---@param sy any?
---@param ox any?
---@param oy any?
---@param kx any?
---@param ky any?
---@param color table?
function specialDraws.f.outline(spr, x, y, r, sx, sy, ox, oy, kx, ky, color, outlineSizeW, outlineSizeH)
    --this doesn't work, I have to learn to write shades then ig :( I don't see any other way (or fi this code but why render twice something when I can use shaders, right?)
    r = r or 0
    sx = sx or 1
    sy = sy or 1
    ox = ox or 0
    oy = oy or 0
    kx = kx or 0
    ky = ky or 0
    color = color or {0,0,0}
    local drawableSpr = spw.sprites[spr].sprs
    outlineSizeW = outlineSizeW or (5 / drawableSpr:getWidth())
    outlineSizeH = outlineSizeH or (5 / drawableSpr:getHeight())

    love.graphics.setColor(color)

    love.graphics.draw(drawableSpr, x - (outlineSizeW * drawableSpr:getWidth() / 2), y - (outlineSizeH * drawableSpr:getHeight() / 2), r, sx + outlineSizeW, sy + outlineSizeH, ox, oy, kx, ky)

    love.graphics.setColor(1,1,1)
    love.graphics.draw(drawableSpr, x, y, r, sx, sy, ox, oy, kx, ky)
end

return specialDraws