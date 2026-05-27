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
            textSize = 32,
            moveDownBy = 48,
            color = {1,1,1,1},
            underline = false,
            highLight = false,
            nextLine = true,
            linePage = false,
        },
        normalText = {
            textSize = 16,
            moveDownBy = 24,
            color = {1,1,1,1},
            underline = false,
            highLight = false,
            nextLine = false,
            linePage = false,
        },
        highLightedText = {
            textSize = 16,
            moveDownBy = 24,
            color = {1,1,1,1},
            underline = false,
            highLight = true,
            nextLine = false,
            linePage = false,
        },
        lineBreak = {
            textSize = 16,
            moveDownBy = function(lineIndex, pageObj) local a = pageObj.order[lineIndex-1]; local mv = wiki.textEnumType[a:gsub("%d*", "")].moveDownBy; if type(mv) == "function" then mv = mv(lineIndex-1, pageObj) end return mv end,
            color = {1,1,1,1},
            underline = false,
            highLight = false,
            nextLine = true,
            linePage = false,
        },
        lineRender = {
            textSize = 16,
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

    wiki.f.renderPage(wiki.f.generateText("rock"))
end

function wiki.f.renderPage(pageObj)
    local sheet = wiki.sheet
    love.graphics.setScissor(sheet.x, sheet.y, sheet.width, sheet.height)
    
    local pixelPosFromTop = 64
    for index, value_ in ipairs(pageObj.order) do
        local value = pageObj.page[value_]
        local typeOfText = value_:gsub("%d*", "")

        local mvby = wiki.textEnumType[typeOfText].moveDownBy
        if type(mvby) == "function" then
            mvby = mvby(index, pageObj)
        end

        if wiki.f[typeOfText] ~= nil then
            wiki.f[typeOfText](pageObj.page[value_], pixelPosFromTop)
        end

        pixelPosFromTop = pixelPosFromTop + mvby
        --print(pixelPosFromTop)
    end

    love.graphics.setScissor()
end

function wiki.f.header(headerText, pixelPosFromTop)
    local font = love.graphics.getFont()
    local w, h = font:getWidth(headerText), font:getHeight(headerText)

    love.graphics.print(headerText, (game.width/2) - (w/2), pixelPosFromTop)
end

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

        return itemDrops
    elseif typePage == "entity" then
        local ret = ""
        for key, value in pairs(entitiesIndex[pageName].drop) do
            ret = ret .. value.baseCount .. "x " .. value.item .. ", "
        end

        ret = ret:sub(1, #ret-2)
        ret = ret .. "."

        return ret
    end
end

function wiki.f.generateText(pageName)
    local upperPageName = pageName:sub(1,1):upper() .. pageName:sub(2, pageName:len())
    if entitiesIndex[pageName] ~= nil then

        local dropText = wiki.f.findUsage("entity", pageName)
        dropText = "has loot table of: " .. dropText

        str = {
            header1 = pageName,
            normalText1 = upperPageName .. " is and entity.",
            lineRender1 = "",
            header2 = "Usage",
            normalText2 = dropText
        }

        ord = {
            "header1", "normalText1", "lineRender1", "header2", "normalText2"
        }
    end

    return {page = str, order = ord}
end

return wiki