game = {
    version = {
        code = "0.0.4", -- this is normal versiong for code 
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
    --height = 272,
    --width = 480, --this will be possible to change of course, but I have to have some basic info for beginning
    state = "game", -- this is to know what to render and what behaviour it neeeds to do, if menu, game etc...
}

game.os = love.system.getOS()

if game.os ~= "PSP" and game.os ~= "Vita" and game.os ~= "PS3" then
    game.width  = 800
    game.height = 600
elseif game.os == "PSP" then
    game.width  = 480
    game.height = 272

    temp = love.joystick.getJoysticks()
    game.leftJoy = temp[1]
end

love.window.setMode(game.width, game.height)

return game