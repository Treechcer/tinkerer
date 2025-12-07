game = {
    version = {
        code = "0.0.1", -- this is normal versiong for code 
        public = "25.12.0", --[[this is for major versions, it's year.month.patch - 
                                patch can be major or minor, this won't be really used outside of modding (if there will be modding*)
                                and for the technical people, for normal people will be used release, which will be like ALPHA 1, BETA 5... 
                            ]]
        release = "NON", -- just string for release, like pre-alpha etc. this will be used when released
    },
    settings = {
        sound = {
            music = 1,
            sfx = 1,
            dialogue = 1,
            etc = 1
        },
    },
    height = love.graphics.getHeight(),
    width = love.graphics.getWidth(), --this will be possible to change of course, but I have to have some basic info for beginning
    state = "game" -- this is to know what to render and what behaviour it neeeds to do, if menu, game etc...
}

return game