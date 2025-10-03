actionDelay ={
    --[[
    it'll be table of tables that are like:
    {name = "some kind of name / identificator", type = "incremental" or "instant", functionCall = "someFunction",
        time = 5, jump (only for incemental -- it's percentage) = 5, timeFromStart = ...}
    ]]
    actions = { --this will sotre all the actions, it's here because I'll have function*s here so it wouldn't work properly... I think

    }
}

function actionDelay.addDelay(name, type, functionCall, time, jump)
    table.insert(actionDelay.actions, {name = name, type = type, functionCall = functionCall, time = time, jump = jump, timeFromStart = 0})
end

function actionDelay.delayCounter(dt)
    i = 1
    toDelete = {}
    for key, value in pairs(actionDelay.actions) do
        value.timeFromStart = value.timeFromStart + dt

        if value.timeFromStart >= value.time and value.type == "instant" then
            value.functionCall()
            table.insert(toDelete, i)
        else
            ending = false
            if value.timeFromStart >= value.time then
                table.insert(toDelete, i)
                ending = true
            end
            value.functionCall(dt, value.jump, ending)
        end

        i = i + 1
    end

    for i = #toDelete, 1, -1 do
        table.remove(actionDelay.actions, toDelete[i])
    end
end

function actionDelay.stopPrematurely(name)
    for index, value in ipairs(actionDelay.actions) do
        if value.name == name then
            table.remove(actionDelay.actions, index)
            break
        end
    end
end

return actionDelay