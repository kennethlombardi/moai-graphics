dofile("Pickle.lua")

layer1 = {
    type = "Layer",
    name = "BVHLayer.lua",
    visible = "true",
    propContainer = {},
    position = {x = 0, y = 0, z = 0},
    scripts = {"3DCameraMovement.lua"}
};

layers = {};
table.insert(layers, layer1);

local function pickleThis()
    layerCount = 0;
    for k,v in pairs(layers) do
        file = io.open(".\\generated\\BVHLayer"..".lua", "wt");
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
