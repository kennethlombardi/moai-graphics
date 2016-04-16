dofile("Pickle.lua")

layer1 = {
    type = "Layer",
    name = "bunnyLayer.lua",
    visible = "true",
    propContainer = {},
    position = {x = 0, y = 0, z = 0},
    scripts = {"3DCameraMovement.lua"}
};

--bunny
scale = 1;
bunny = {
    type = "Model",
    fileName = "bunny.obj",
    name = "bunny",
    position = {x = -.5, y = 0, z = -1.5};
    scale = {x = scale, y = scale, z = scale},
    scripts = {"bunnyUpdate.lua"},
    shaderName = "shader",
    textureName = "earthWrap.png",
    rotation = {x = 0, y = 0, z = 0},
}

table.insert(layer1.propContainer, bunny);

layers = {};
table.insert(layers, layer1);


local function pickleThis()
    layerCount = 0;
    for k,v in pairs(layers) do
        file = io.open(".\\generated\\bunnyLayer"..".lua", "wt");
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
