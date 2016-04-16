dofile("Pickle.lua")

layer1 = {
    type = "Layer",
    name = "horseLayer.lua",
    visible = "true",
    propContainer = {},
    position = {x = 0, y = 0, z = 0},
    scripts = {"3DCameraMovement.lua"}
};

--horse
scale = 2.5;
for i = 1, 1, 1 do
    horse = {
        type = "Model",
        fileName = "horse_lowres_cleaned.obj",
        name = "horse",
        position = {x = -.25, y = 0, z = -1.5};
        scale = {x = scale, y = scale, z = scale},
        scripts = {"horseUpdate.lua"},
        shaderName = "shader",
        textureName = "earthWrap.png",
        rotation = {x = 0, y = 90, z = 0},
    }
    table.insert(layer1.propContainer, horse);
end

layers = {};
table.insert(layers, layer1);


local function pickleThis()
    layerCount = 0;
    for k,v in pairs(layers) do
        file = io.open(".\\generated\\horseLayer"..".lua", "wt");
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
