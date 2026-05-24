wiki = {
    data = {
        render = false,
        currentPage = nil,
    },
    f = {}
}

function wiki.f.renderer()
    UI.f.renderNineSquare(UI.nineSquareSpriteSheet.wiki, 5, 5, game.width - 10, game.height - 10, 10)
end

return wiki