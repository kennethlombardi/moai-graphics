dofile("Pickle.lua")

layer1 = {
    type = "Layer",
    name = "templeLayer.lua",
    visible = "true",
    propContainer = {},
    position = {x = 0, y = 0, z = 0},
    scripts = {"3DCameraMovement.lua"}
};

--happy
scale = .01;
happy = {
    type = "Model",
    fileName = "temple.obj",
    name = "happy",
    position = {x = 0, y = 0, z = -1.5};
    scale = {x = scale, y = scale, z = scale},
    scripts = {"happyUpdate.lua"},
    shaderName = "shader",
    textureName = "earthWrap.png",
    rotation = {x = 0, y = 0, z = 0},
}

table.insert(layer1.propContainer, happy);

layers = {};
table.insert(layers, layer1);


local function pickleThis()
    layerCount = 0;
    for k,v in pairs(layers) do
        file = io.open(".\\generated\\templeLayer"..".lua", "wt");
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
