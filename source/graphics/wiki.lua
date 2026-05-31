wiki = {
    data = {
        render = false,
        currentPage = nil,
    },
    sheet = {
        x = 5,
        y = 5,
        width = game.width - 10,
        height = game.height - 10,
        scale = 11
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
    textEnumType = {
        header = {
            textSizeScale = 2,
            moveDownBy = 48,
            color = {1,1,1,1},
            underline = false,
            highLight = false,
            nextLine = true,
            linePage = false,
        },
        normalText = {
            textSizeScale = 1,
            moveDownBy = 24,
            color = {1,1,1,1},
            underline = false,
            highLight = false,
            nextLine = true,
            linePage = false,
        },
        highLightedText = {
            textSizeScale = 1,
            moveDownBy = 24,
            color = {1,1,1,1},
            underline = false,
            highLight = true,
            nextLine = false,
            linePage = false,
        },
        lineBreak = {
            textSizeScale = 1,
            moveDownBy = function(lineIndex, pageObj) local a = pageObj.order[lineIndex-1]; local mv = wiki.textEnumType[a:gsub("%d*", "")].moveDownBy; if type(mv) == "function" then mv = mv(lineIndex-1, pageObj) end return mv end,
            color = {1,1,1,1},
            underline = false,
            highLight = false,
            nextLine = true,
            linePage = false,
        },
        lineRender = {
            textSizeScale = 1,
            moveDownBy = function(lineIndex, pageObj) local a = pageObj.order[lineIndex-1]; local mv = wiki.textEnumType[a:gsub("%d*", "")].moveDownBy; if type(mv) == "function" then mv = mv(lineIndex-1, pageObj) end return mv * 3 end,
            color = {1,1,1,1},
            underline = false,
            highLight = false,
            nextLine = true,
            linePage = true,
        }
    },
    f = {}
}

function wiki.f.renderer()
    local sheet = wiki.sheet
    UI.f.renderNineSquare(UI.nineSquareSpriteSheet.wiki, sheet.x, sheet.y, sheet.width, sheet.height, sheet.scale)
    local xBut = wiki.buttons.exit
    love.graphics.draw(spw.getSprite("x_circle"), xBut.pos.x, xBut.pos.y, 0, xBut.pos.scalarX, xBut.pos.scalarY)
    
    wiki.f.buttonCheck()

    wiki.f.renderPage(wiki.f.generateText("in:rock"))
end

function wiki.f.renderPage(pageObj)
    local sheet = wiki.sheet
    love.graphics.setScissor(sheet.x, sheet.y, sheet.width, sheet.height)
    local pixelPosFromTop = 24
    local xmove = game.width/2 - love.graphics.getFont():getWidth(strings.trim(pageObj.page[pageObj.order[1]])) / 2
    for index, value_ in ipairs(pageObj.order) do
        local value = pageObj.page[value_]
        local typeOfText = value_:gsub("%d*", "")

        if wiki.f[typeOfText] ~= nil then
            
            local arr = strings.split(pageObj.page[value_], "[^\n]+")
            if #arr == 1 then
                xmove = wiki.f[typeOfText](pageObj.page[value_], pixelPosFromTop, wiki.textEnumType[typeOfText].textSizeScale, xmove)
            else
                for _key, _value in pairs(arr) do
                    xmove = game.width/2 - love.graphics.getFont():getWidth(strings.trim(_value)) / 2
                    xmove = wiki.f[typeOfText](_value, pixelPosFromTop, wiki.textEnumType[typeOfText].textSizeScale, xmove)
                    pixelPosFromTop = pixelPosFromTop + wiki.textEnumType[typeOfText].moveDownBy
                end
            end
        end

        if wiki.textEnumType[typeOfText].nextLine then

            if index+1 > #pageObj.order then
                break
            end

            ---@type integer | function
            local mvby = wiki.textEnumType[typeOfText].moveDownBy

            if type(mvby) == "function" then
                mvby = mvby(index, pageObj)
            end

            pixelPosFromTop = pixelPosFromTop + mvby
            xmove = game.width/2 - love.graphics.getFont():getWidth(strings.trim(pageObj.page[pageObj.order[index+1]])) / 2
        end
        --print(pixelPosFromTop)
    end

    love.graphics.setScissor()
end

function wiki.f.header(headerText, pixelPosFromTop, scale, xmove)
    local font = love.graphics.getFont()
    local w, h = font:getWidth(headerText) * scale, font:getHeight(headerText) * scale

    love.graphics.print(headerText, xmove - (w/2), pixelPosFromTop, 0, scale, scale)

    return xmove + w
end

function wiki.f.normalText(headerText, pixelPosFromTop, scale, xmove)
    local function drawTextPart(text, x, y)
        love.graphics.print(text, x, y, 0, scale, scale)
        return x + (love.graphics.getFont():getWidth(text) * scale)
    end

    local nonHighligtPart, highLightPart, nonHighligtPartRest = headerText:match("([^$]*)$([^$]*)$([^$]*)")
    
    if not nonHighligtPart then
        return drawTextPart(headerText, xmove, pixelPosFromTop)
    end

    xmove = drawTextPart(nonHighligtPart, xmove, pixelPosFromTop)
    love.graphics.setColor(1, 0.9, 0)
    xmove = drawTextPart(highLightPart, xmove, pixelPosFromTop)
    love.graphics.setColor(1, 1, 1)
    xmove = drawTextPart(nonHighligtPartRest, xmove, pixelPosFromTop)

    return xmove
end

--function wiki.f.highLightedText(headerText, pixelPosFromTop, scale, xmove)
--    love.graphics.setColor(1, 0.9, 0)
--    xmove = wiki.f.header(headerText, pixelPosFromTop, scale, xmove)
--    love.graphics.setColor(1, 1, 1)
--
--    return xmove
--end

function wiki.f.buttonCheck()
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

function wiki.f.findUsage(typePage, pageName)
    local ret = ""
    if typePage == "item" then
        local itemDrops = {}
        for key, value in pairs(entitiesIndex) do
            if key ~= "f" then
                for key_, value_ in pairs(value.drop) do
                    if value_.item == pageName then
                        table.insert(itemDrops, {item = value_.item, count = value_.baseCount, source = key})
                    end
                end
            end
        end

        for index, value in ipairs(itemDrops) do
            ret = ret .. value.source .. " (" .. value.count .. "x)"
            if index ~= #itemDrops then
                ret = ret .. ", "
            end
        end
    elseif typePage == "itemCraft" then
        local t = string.trimBy

        local crafting = false
        for key, value in pairs(recipes.recipes) do
            for key_, value_ in pairs(value.recipe) do
                if value_.item == pageName then
                    if not crafting then
                        ret = ret .. "Crafting: "
                        crafting = true
                    end

                    ret = ret .. key .. " uses " .. value_.count .. "x, "
                end
            end
        end

        if crafting then
            ret = t(ret, 2)
            ret = ret .. "\n"
        end

        local smelt = false
        for key, value in pairs(itemIndex) do
            if value.smeltsTo ~= nil then
                if not smelt then
                    ret = ret .. "Furnace: "
                    smelt = true
                end

                ret = ret .. key .. " uses " .. value.smeltsTo.count .. "x, "
            end
        end

        if smelt then
            ret = t(ret, 2)
        end

    elseif typePage == "entity" then
        for key, value in pairs(entitiesIndex[pageName].drop) do
            ret = ret .. value.baseCount .. "x " .. value.item .. ", "
        end

        ret = ret:sub(1, #ret-2)
        ret = ret .. "."
    end

    return ret:gsub("_", " ")
end

function wiki.f.generateText(pageName)

    local source, name = pageName:match("([a-zA-Z]*):([a-zA-Z]*)")

    local upperPageName = name:sub(1,1):upper() .. name:sub(2, name:len())
    if source == "en" then
        local dropText = "has loot table of: " .. wiki.f.findUsage("entity", name)

        str = {
            header1 = name,
            normalText1 = upperPageName .. " is an entity. $highlight$ bb",
            lineRender1 = "",
            header2 = "Usage",
            normalText2 = dropText
        }

        ord = {
            "header1", "normalText1", "lineRender1", "header2", "normalText2"
        }
    elseif source == "in" then
        local dropText = "Base drops from these entities: " .. wiki.f.findUsage("item", name)

        str = {
            header1 = name,
            normalText1 = upperPageName .. " is an material.",
            lineRender1 = "",
            header2 = "Obtaining",
            normalText2 = dropText,
            header3 = "Usage",
            normalText3 = wiki.f.findUsage("itemCraft", name)
        }

        ord = {
            "header1", "normalText1", "lineRender1", "header2", "normalText2", "header3", "normalText3"
        }
    end

    return {page = str, order = ord}
end

return wiki