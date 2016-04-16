dofile("Pickle.lua")

layer1 = {
	type = "LayerDD",
	name = "results.lua",
	visible = "true",
	propContainer = {},
	position = {x = 0, y = 0, z = 0},
	scripts = {"resultsLayerUpdate.lua"}
};

width = 1280;
height = 720;


-- retry text
local yFudge = 250;
retryText = {
	type = "TextBox",
	name = "retryText",
    position = {x = 0, y = -yFudge, z = 0};
    scale = {x = 1, y = 1, z = 1};
    rotation = {x = 0, y = 0, z = 0};
    rectangle = {x1 = -300, x2 = 300, y1 = -100, y2 = 100},
	scripts = {},
	shaderName = "none",
    textSize = 72,
    justification = "center_justify",
    string = "Retry",
}
table.insert(layer1.propContainer, retryText);


-- retry button
prop = {
	type = "Prop",
	name = "retryButton",
	scripts = {},
	shaderName = "basic2d",
	textureName = "retryButtonHighlighted.png",
    position = {x = 0, y = -200, z = 0},
    scale = {x = .75, y = .75, z = 1},
    rotation = {x = 0, y = 0, z = 0},
}
table.insert(layer1.propContainer, prop);

-- high score text
highScoreText = {
    type = "TextBox",
    name = "highScoreText",
    position = {x = 0, y = 200, z = 0};
    scale = {x = 1, y = 1, z = 1};
    rotation = {x = 0, y = 0, z = 0};
    rectangle = {x1 = -1000, x2 = 1000, y1 = -100, y2 = 100},
    scripts = {"highScoreTextUpdate.lua"},
    shaderName = "none",
    textSize = 72,
    justification = "center_justify",
    string = "",
}
table.insert(layer1.propContainer, highScoreText);

-- your score text
yourScoreText = {
    type = "TextBox",
    name = "yourScoreText",
    position = {x = 0, y = 100, z = 0};
    scale = {x = 1, y = 1, z = 1};
    rotation = {x = 0, y = 0, z = 0};
    rectangle = {x1 = -1000, x2 = 1000, y1 = -100, y2 = 100},
    scripts = {"yourScoreTextUpdate.lua"},
    shaderName = "none",
    textSize = 72,
    justification = "center_justify",
    string = "",
}
table.insert(layer1.propContainer, yourScoreText);

-- your score text
yourScoreText = {
    type = "TextBox",
    name = "rings",
    position = {x = -300, y = 0, z = 0};
    scale = {x = 1, y = 1, z = 1};
    rotation = {x = 0, y = 0, z = 0};
    rectangle = {x1 = -300, x2 = 300, y1 = -100, y2 = 100},
    scripts = {"gameRings.lua"},
    shaderName = "none",
    textSize = 60,
    justification = "center_justify",
    string = "",
}
table.insert(layer1.propContainer, yourScoreText);

-- your score text
yourScoreText = {
    type = "TextBox",
    name = "dist",
    position = {x = 175, y = 0, z = 0};
    scale = {x = 1, y = 1, z = 1};
    rotation = {x = 0, y = 0, z = 0};
    rectangle = {x1 = -300, x2 = 300, y1 = -100, y2 = 100},
    scripts = {"gameDistance.lua"},
    shaderName = "none",
    textSize = 60,
    justification = "center_justify",
    string = "",
}
table.insert(layer1.propContainer, yourScoreText);

local function pickleThis()

    file = io.open(".\\generated\\results"..".lua", "wt");
    s = "deserialize (\"Layer\",\n";
    file:write(s);
    s = pickle(layer1);
    file:write(s);
    s = ")\n\n";
    file:write(s);
    file:close();

end

pickleThis();
