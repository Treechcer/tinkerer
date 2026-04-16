
--THIS JUST OVERRIDES FUNCTIONS OF LOVE2D!!


_old_love_graphics_print = love.graphics.print

function love.graphics.print(text, x, y, r, sx, sy, ox, oy, kx, ky)
    --r, sx, sy, ox, oy, kx, ky = r or 0, sx or 1, sy or 1, ox or 0, oy or 0, kx or 0, ky or 0
    text = UI.f.textTify(tostring(text))
    --print(text, x, y, r, sx, sy, ox, oy, kx, ky)
    _old_love_graphics_print(text, x, y, r, sx, sy, ox, oy, kx, ky)
end