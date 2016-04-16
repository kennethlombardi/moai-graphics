dofile("Pickle.lua")

layer1 = {
    type = "LayerDD",
    name = "OctreeHUDLayer.lua",
    visible = "true",
    propContainer = {},
    position = {x = 0, y = 0, z = 0},
    scripts = {"OctreeHUDLayerUpdate.lua"}
};

-- Notes:
local notesPosition = {x = 0, y = 0, z = 0}
table.insert(layer1.propContainer, {
    type = "TextBox",
    name = "NOTES",
    position = {x = notesPosition.x, y = notesPosition.y + 0, z = notesPosition.z};
    scale = {x = .5, y = .5, z = .5};
    rotation = {x = 0, y = 0, z = 0};
    rectangle = {x1 = -400, x2 = 400, y1 = -100, y2 = 300},
    scripts = {},
    shaderName = "none",
    textSize = 24,
    justification = "left_justify",
    string = "Note: Octree builds correctly but test grids migrate to one side.",
    fontName = "arial-rounded"
});

table.insert(layer1.propContainer, {
    type = "TextBox",
    name = "NOTES2",
    position = {x = notesPosition.x, y = notesPosition.y + -25, z = notesPosition.z};
    scale = {x = .5, y = .5, z = .5};
    rotation = {x = 0, y = 0, z = 0};
    rectangle = {x1 = -400, x2 = 400, y1 = -100, y2 = 300},
    scripts = {},
    shaderName = "none",
    textSize = 24,
    justification = "left_justify",
    string = "Note: When changing settings the scene will rebuild. This can take a moment or two...or three",
    fontName = "arial-rounded"
});

local controlsPosition = {x = -300, y = -100, z = 0};

table.insert(layer1.propContainer, {
    type = "TextBox",
    name = "SHOW_GRID_LINES_CONTROL",
    position = {x = controlsPosition.x, y = controlsPosition.y + 0, z = controlsPosition.z};
    scale = {x = .5, y = .5, z = .5};
    rotation = {x = 0, y = 0, z = 0};
    rectangle = {x1 = -300, x2 = 400, y1 = -100, y2 = 100},
    scripts = {},
    shaderName = "none",
    textSize = 24,
    justification = "left_justify",
    string = "'G' - Toggle split grid lines",
    fontName = "arial-rounded"
});

table.insert(layer1.propContainer, {
    type = "TextBox",
    name = "SHOW_SPLIT_FACES_CONTROL",
    position = {x = controlsPosition.x, y = controlsPosition.y + -25, z = controlsPosition.z};
    scale = {x = .5, y = .5, z = .5};
    rotation = {x = 0, y = 0, z = 0};
    rectangle = {x1 = -300, x2 = 400, y1 = -100, y2 = 100},
    scripts = {},
    shaderName = "none",
    textSize = 24,
    justification = "left_justify",
    string = "'F' - Toggle split faces",
    fontName = "arial-rounded"
});

table.insert(layer1.propContainer, {
    type = "TextBox",
    name = "LEAF_POLY_LIMIT_CONTROL",
    position = {x = controlsPosition.x, y = controlsPosition.y + -50, z = controlsPosition.z};
    scale = {x = .5, y = .5, z = .5};
    rotation = {x = 0, y = 0, z = 0};
    rectangle = {x1 = -300, x2 = 600, y1 = -100, y2 = 100},
    scripts = {},
    shaderName = "none",
    textSize = 24,
    justification = "left_justify",
    string = "'R/V' - increase/decrease leaf polygon limit",
    fontName = "arial-rounded"
});

table.insert(layer1.propContainer, {
    type = "TextBox",
    name = "CHOOSE_OCTREE_CONTROL",
    position = {x = controlsPosition.x, y = controlsPosition.y + -75, z = controlsPosition.z};
    scale = {x = .5, y = .5, z = .5};
    rotation = {x = 0, y = 0, z = 0};
    rectangle = {x1 = -300, x2 = 600, y1 = -100, y2 = 100},
    scripts = {},
    shaderName = "none",
    textSize = 24,
    justification = "left_justify",
    string = "'O' - Select 'O'ctree algorithm",
    fontName = "arial-rounded"
});

table.insert(layer1.propContainer, {
    type = "TextBox",
    name = "CHOOSE_BSP_TREE_CONTROL",
    position = {x = controlsPosition.x, y = controlsPosition.y + -100, z = controlsPosition.z};
    scale = {x = .5, y = .5, z = .5};
    rotation = {x = 0, y = 0, z = 0};
    rectangle = {x1 = -300, x2 = 600, y1 = -100, y2 = 100},
    scripts = {},
    shaderName = "none",
    textSize = 24,
    justification = "left_justify",
    string = "'B' - Select 'B'SP algorithm",
    fontName = "arial-rounded"
});

table.insert(layer1.propContainer, {
    type = "TextBox",
    name = "CHOOSE_DEBUG_LINES_CONTROL",
    position = {x = controlsPosition.x, y = controlsPosition.y + -125, z = controlsPosition.z};
    scale = {x = .5, y = .5, z = .5};
    rotation = {x = 0, y = 0, z = 0};
    rectangle = {x1 = -300, x2 = 600, y1 = -100, y2 = 100},
    scripts = {},
    shaderName = "none",
    textSize = 24,
    justification = "left_justify",
    string = "'H' - Show debug lines",
    fontName = "arial-rounded"
});

table.insert(layer1.propContainer, {
    type = "TextBox",
    name = "SHOW_TEMPLE_CONTROL",
    position = {x = controlsPosition.x, y = controlsPosition.y + -150, z = controlsPosition.z};
    scale = {x = .5, y = .5, z = .5};
    rotation = {x = 0, y = 0, z = 0};
    rectangle = {x1 = -300, x2 = 600, y1 = -100, y2 = 100},
    scripts = {},
    shaderName = "none",
    textSize = 24,
    justification = "left_justify",
    string = "'Y' - Toggle temple",
    fontName = "arial-rounded"
});

table.insert(layer1.propContainer, {
    type = "TextBox",
    name = "SHOW_HAPPY_CONTROL",
    position = {x = controlsPosition.x, y = controlsPosition.y + -175, z = controlsPosition.z};
    scale = {x = .5, y = .5, z = .5};
    rotation = {x = 0, y = 0, z = 0};
    rectangle = {x1 = -300, x2 = 600, y1 = -100, y2 = 100},
    scripts = {},
    shaderName = "none",
    textSize = 24,
    justification = "left_justify",
    string = "'U' - Toggle happy",
    fontName = "arial-rounded"
});

table.insert(layer1.propContainer, {
    type = "TextBox",
    name = "SHOW_LUCY_CONTROL",
    position = {x = controlsPosition.x, y = controlsPosition.y + -200, z = controlsPosition.z};
    scale = {x = .5, y = .5, z = .5};
    rotation = {x = 0, y = 0, z = 0};
    rectangle = {x1 = -300, x2 = 600, y1 = -100, y2 = 100},
    scripts = {},
    shaderName = "none",
    textSize = 24,
    justification = "left_justify",
    string = "'L' - Toggle lucy",
    fontName = "arial-rounded"
});

table.insert(layer1.propContainer, {
    type = "TextBox",
    name = "SHOW_BUNNY_CONTROL",
    position = {x = controlsPosition.x, y = controlsPosition.y + -225, z = controlsPosition.z};
    scale = {x = .5, y = .5, z = .5};
    rotation = {x = 0, y = 0, z = 0};
    rectangle = {x1 = -300, x2 = 600, y1 = -100, y2 = 100},
    scripts = {},
    shaderName = "none",
    textSize = 24,
    justification = "left_justify",
    string = "'I' - Toggle bunny",
    fontName = "arial-rounded"
});

table.insert(layer1.propContainer, {
    type = "TextBox",
    name = "SHOW_DRAGON_CONTROL",
    position = {x = controlsPosition.x, y = controlsPosition.y + -250, z = controlsPosition.z};
    scale = {x = .5, y = .5, z = .5};
    rotation = {x = 0, y = 0, z = 0};
    rectangle = {x1 = -300, x2 = 600, y1 = -100, y2 = 100},
    scripts = {},
    shaderName = "none",
    textSize = 24,
    justification = "left_justify",
    string = "'P' - Toggle dragon",
    fontName = "arial-rounded"
});

local statusMenuPosition = {x = -300, y = 0, z = 0}
table.insert(layer1.propContainer, {
    type = "TextBox",
    name = "SHOW_ALGORITHM",
    position = {x = statusMenuPosition.x, y = statusMenuPosition.y + -0, z = statusMenuPosition.z};
    scale = {x = .5, y = .5, z = .5};
    rotation = {x = 0, y = 0, z = 0};
    rectangle = {x1 = -300, x2 = 600, y1 = -100, y2 = 100},
    scripts = {},
    shaderName = "none",
    textSize = 24,
    justification = "left_justify",
    string = "",
    fontName = "arial-rounded"
});

table.insert(layer1.propContainer, {
    type = "TextBox",
    name = "SHOW_LEAF_POLYGON_LIMIT",
    position = {x = statusMenuPosition.x, y = statusMenuPosition.y + -25, z = statusMenuPosition.z};
    scale = {x = .5, y = .5, z = .5};
    rotation = {x = 0, y = 0, z = 0};
    rectangle = {x1 = -300, x2 = 600, y1 = -100, y2 = 100},
    scripts = {},
    shaderName = "none",
    textSize = 24,
    justification = "left_justify",
    string = "",
    fontName = "arial-rounded"
});

local function pickleThis()
    file = io.open(".\\generated\\OctreeHUDLayer"..".lua", "wt");
    s = "deserialize (\"Layer\",\n";
    file:write(s);
    s = pickle(layer1);
    file:write(s);
    s = ")\n\n";
    file:write(s);
    file:close();

end

pickleThis();
