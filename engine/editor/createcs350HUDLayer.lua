dofile("resources/lua/Pickle.lua")

layer1 = {
    type = "LayerDD",
    name = "cs350HUDLayer.lua",
    visible = "true",
    propContainer = {},
    position = {x = 0, y = 0, z = 0},
    scripts = {"cs350HUDLayerUpdate.lua"}
};

-- your score text
yourScoreText = {
    type = "TextBox",
    name = "dist",
    position = {x = 0, y = 100, z = 0};
    scale = {x = .5, y = .5, z = .5};
    rotation = {x = 0, y = 0, z = 0};
    rectangle = {x1 = -150, x2 = 150, y1 = -50, y2 = 50},
    scripts = {"currentlySelectedBoundingVolumeAlgorithmUpdate.lua"},
    shaderName = "none",
    textSize = 30,
    justification = "center_justify",
    string = "",
    fontName = "arial-rounded"
}
table.insert(layer1.propContainer, yourScoreText);

local function pickleThis()
    -- file = io.open(".\\generated\\cs350HUDLayer"..".lua", "wt");
    file = io.open("editor/generated/cs350HUDLayer.lua", "wt");
    s = "deserialize (\"Layer\",\n";
    file:write(s);
    s = pickle(layer1);
    file:write(s);
    s = ")\n\n";
    file:write(s);
    file:close();

end

pickleThis();
