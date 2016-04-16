dofile("Pickle.lua")

layer1 = {
    type = "Layer",
    name = "cs350TestLayer.lua",
    visible = "true",
    propContainer = {},
    position = {x = 0, y = 0, z = 0},
    scripts = {"3DCameraMovement.lua"}
};



--bunny
scale = 1000;
bunny = {
    type = "Model",
    fileName = "bunny.obj",
    name = "earth",
    position = {x = 0, y = 0, z = -500};
    scale = {x = scale, y = scale, z = scale},
    scripts = {"bunnyUpdate.lua"},
    shaderName = "MESH_SHADER",
    textureName = "earthWrap.png",
    rotation = {x = -30, y = 0, z = 0},
}

--cube
cube = {
    type = "Model",
    fileName = "cubetest.obj",
    name = "cube",
    position = {x = 0, y = 0, z = -2};
    scale = {x = 1, y = 1, z = 1},
    scripts = {"cubeUpdate.lua"},
    shaderName = "MESH_SHADER",
    textureName = "earthWrap.png",
    rotation = {x = 0, y = 0, z = 0},
}

-- table.insert(layer1.propContainer, cube);
table.insert(layer1.propContainer, bunny);

layers = {};
table.insert(layers, layer1);


local function pickleThis()
    layerCount = 0;
    for k,v in pairs(layers) do
        file = io.open(".\\generated\\cs350TestLayer"..".lua", "wt");
        s = "deserialize (\"Layer\",\n";
        file:write(s);
        s = pickle(v);
        file:write(s);
        s = ")\n\n";
        file:write(s);
        file:close();
        layerCount = layerCount + 1;
    end
end

pickleThis();
