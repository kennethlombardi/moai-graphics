dofile("Pickle.lua")

layer1 = {
    type = "LayerDD",
    name = "BVHHUDLayer.lua",
    visible = "true",
    propContainer = {},
    position = {x = 0, y = 0, z = 0},
    scripts = {"BVHHUDLayerUpdate.lua"}
};

-- your score text
yourScoreText = {
    type = "TextBox",
    name = "currentlySelectedBVHAlgorithm",
    position = {x = -400, y = -250, z = 0};
    scale = {x = 1, y = 1, z = 1};
    rotation = {x = 0, y = 0, z = 0};
    rectangle = {x1 = -300, x2 = 300, y1 = -100, y2 = 100},
    scripts = {"currentlySelectedBVHAlgorithmUpdate.lua"},
    shaderName = "none",
    textSize = 60,
    justification = "center_justify",
    string = "",
    fontName = "arial-rounded"
}
table.insert(layer1.propContainer, yourScoreText);

local function pickleThis()
    file = io.open(".\\generated\\BVHHUDLayer"..".lua", "wt");
    s = "deserialize (\"Layer\",\n";
    file:write(s);
    s = pickle(layer1);
    file:write(s);
    s = ")\n\n";
    file:write(s);
    file:close();

end

pickleThis();
