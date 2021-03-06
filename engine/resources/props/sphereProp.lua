local scale = 1
local sphere = {
    type = "Model",
    fileName = "cubetest.obj",
    name = "sphere",
    position = {x = 0, y = 0, z = 0};
    scale = {x = 1 * scale, y = 1 * scale, z = 1 * scale},
    scripts = {"cubeUpdate.lua"},
    shaderName = "boundingVolume",
    textureName = "earthWrap.png",
    rotation = {x = 0, y = 0, z = 0},
}

return sphere;