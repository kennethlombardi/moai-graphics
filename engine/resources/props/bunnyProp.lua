--bunny
local scale = 1;
local distance = 0;
local bunny = {
    type = "Model",
    fileName = "bunny.obj",
    name = "earth",
    position = {x = 0, y = 0, z = -distance};
    scale = {x = scale, y = scale, z = scale},
    scripts = {"bunnyUpdate.lua"},
    shaderName = "MESH_SHADER",
    textureName = "earthWrap.png",
    rotation = {x = 0, y = 0, z = 0},
}

return bunny