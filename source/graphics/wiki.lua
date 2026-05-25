wiki = {
    data = {
        render = false,
        currentPage = nil,
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
            color = {1,1,1,1},
            underline = false,
            highLight = false,
            nextLine = true,
            linePage = false,
        },
        nomalText = {
            textSize = 16,
            color = {1,1,1,1},
            underline = false,
            highLight = false,
            nextLine = false,
            linePage = false,
        },
        highLightedText = {
            textSize = 16,
            color = {1,1,1,1},
            underline = false,
            highLight = true,
            nextLine = false,
            linePage = false,
        },
        lineBreak = {
            textSize = 16,
            color = {1,1,1,1},
            underline = false,
            highLight = false,
            nextLine = true,
            linePage = false,
        },
        lineRender = {
            textSize = 16,
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
    UI.f.renderNineSquare(UI.nineSquareSpriteSheet.wiki, 5, 5, game.width - 10, game.height - 10, 11)
    local xBut = wiki.buttons.exit
    love.graphics.draw(spw.getSprite("x_circle"), xBut.pos.x, xBut.pos.y, 0, xBut.pos.scalarX, xBut.pos.scalarY)
    
    wiki.f.buttonCheck()

    tables.writeTable(wiki.f.generateText("rock"))
    love.event.quit()
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
    if typePage == "entity" then
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
    end
end

function wiki.f.generateText(pageName)
    local upperPageName = pageName:sub(1,1):upper() .. pageName:sub(2, pageName:len())
    if entitiesIndex[pageName] ~= nil then

        local dropsToText = wiki.f.findUsage("entity", pageName)
        local dropText = ""
        for index, value in ipairs(dropsToText) do
            dropText = dropText .. "drops from an entity '" .. value.source .. "' and drops in a base count of " .. value.count .. "\n"
        end

        str = {
            header1 = pageName,
            normalText1 = upperPageName .. " is and entity.",
            lineRender1 = "",
            header2 = "Usage",
            normalText2 = dropText
        }
    end

    return str
end

return wiki