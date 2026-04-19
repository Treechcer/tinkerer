timer = {
    currentTime = 0,
    timers = {
        --{startTime, endTime, remaing, run, type (?instant ?linear ?lerp ...), progress (1 = 100%)}
    },
    f = {}
}

function timer.f.addTimer(length, run, type)
    table.insert(timer.timers, {starTime = timer.currentTime, endTime = timer.currentTime + length, remaing = 0, wholeTimer = length, run = run, type = type, progress = 0})
    --return #timer.timers
end

function timer.f.updateTimer(dt)
    timer.currentTime = timer.currentTime + dt
end

function timer.f.run(dt)
    local index = 1
    for key, value in pairs(timer.timers) do
        if value.type == "linear" then
            print(value.remaing, value.wholeTimer)
            local p = value.remaing / value.wholeTimer
            value.progress = p
            value.run(value)
        elseif value.type == "instant" then
            local p = value.remaing / value.wholeTimer
            value.progress = p
            if p >= 1 then
                value.run(value)
            end
        elseif value.type == "lerp" then
            local p = mathWorker.lerp(value.progress, dt, value.remaing / value.wholeTimer)
            value.progress = p
            if p >= 1 then
                value.run(value)
            end
        end

        value.remaing = value.remaing + dt
        if value.remaing >= value.wholeTimer then
            --hmm I can't really remove the timers, I have to think what shall I do with them... 
            --I can, because it's creates the timer and then the code shouldn't work with the timer!
            table.remove(timer.timers, index)
        end

        index = index + 1
    end
end

return timer