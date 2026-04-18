shaderWorker = {
    shaders = {}
}

--this is rough shaderWorker for now, I'm not planning on making many shaders for now, important is that for now (because I still haven't learned enough to use them)

shaderWorker.shaders.whiteOutVisible = love.graphics.newShader("assets/shaders/whiteOutVisible.glsl")
shaderWorker.shaders.lerpShader = love.graphics.newShader("assets/shaders/lerpShader.glsl")

return shaderWorker