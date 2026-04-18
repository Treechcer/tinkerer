specialMoves = {
    moves = {
        dash = {
            last = 2.5,
            next = 1,
            dashing = false,
            unlocked = true, -- idk if this will really be in the game later...
            keyBind = settings.keys.dash,
            run = function (dt)
                player.vals.cantMove = true
                player.vals.specialRender = true
                player.vals.walking = false
                player.vals.state = "dashing"
                player.vals.specialRenderFunc = function (spr)
                    local dash = specialMoves.moves.dash
                    x, y = renderer.getAbsolutePos(player.position.x, player.position.y)
                    love.graphics.draw(spr, x + player.size.width / 2, y + player.size.height / 2, dash.rotateValue, (player.size.width / spr:getWidth()) * (player.cursor.screenSide), player.size.height / spr:getHeight(), spr:getWidth() / 2, spr:getHeight() / 2)
                    dash.rotateValue = mathWorker.lerp(dash.rotateValue, dash.rotIncrease, dash.last / dash.next * dt)
                    --console.f.callConsoleFunction("print", tostring(dash.rotateValue) .. " " .. tostring(dash.last / dash.next))

                    if dash.last >= dash.next then
                        dash.rotateValue = 0
                        player.vals.cantMove = false
                        player.vals.specialRender = false
                        player.vals.walking = true
                        player.vals.state = "walking"
                        dash.running = false
                        player.vals.specialRenderFunc = nil

                        --console.f.callConsoleFunction("print", "end")
                    end
                end
            end,
            running = false,
            rotateValue = 0,
            rotIncrease = 15
        }
    },
    f = {}
}

--use this function to asighn binds to abilities back!
function specialMoves.f.asighnBinds()
    local m = specialMoves.moves

    m.dash.keyBind = settings.keys.dash
end

function specialMoves.f.init()
    specialMoves.f.asighnBinds()
end

function specialMoves.f.run(dt)
    local dash = specialMoves.moves.dash
    dash.last = dash.last + dt

    for key, value in pairs(specialMoves.moves) do
        local kp = (love.keyboard.isDown(value.keyBind) and value.last >= value.next)
        if kp and not value.isrunning then
            value.last = 0
        end

        if kp or value.isrunning then
            value.run(dt)
        end
    end
end

return specialMoves