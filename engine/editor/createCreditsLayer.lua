dofile("Pickle.lua")

layer1 = {
	type = "LayerDD",
	name = "credits.lua",
	visible = "true",
	propContainer = {},
	position = {x = 0, y = 0, z = 0},
	scripts = {"creditsLayerUpdate.lua"}
};

-- Credits title
position = {x = 0, y = 200, z = 0};
scale = {x = .75, y = .75, z = 1};
rotation = {x = 0, y = 0, z = 0};
prop = {
	type = "Prop",
	name = "creditsTitle",
	position = position,
	scale = scale,
	scripts = {},
	shaderName = "basic2d",
	textureName = "creditsOn.png",
	rotation = rotation,
}
table.insert(layer1.propContainer, prop);

local creditsList = {};
table.insert(creditsList, 1, {propName = "claudeText", string = "Claude Comair: President"})
table.insert(creditsList, 2, {propName = "jamesText", string = "James Barnard: Instructor"})
table.insert(creditsList, 3, {propName = "vivekText", string = "Vivek Melwani: Instructor"})
table.insert(creditsList, 4, {propName = "kennethText", string = "Kenneth Lombardi: Programmer"})
table.insert(creditsList, 5, {propName = "stevenText", string = "Steven Peng: Programmer"})
table.insert(creditsList, 6, {propName = "copyrightText", string = "All content © 2012 DigiPen Institute of Technology Singapore, all rights reserved."})

local y = 0;
for i,v in ipairs(creditsList) do
	local verticalSpacing = 50;
	print(i,v,y)
	highScoreText = {
	    type = "TextBox",
	    name = creditsList[i].propName,
	    position = {x = 0, y = y, z = 0};
	    scale = {x = 1, y = 1, z = 1};
	    rotation = {x = 0, y = 0, z = 0};
	    rectangle = {x1 = -1000, x2 = 1000, y1 = -100, y2 = 100},
	    scripts = {},
	    shaderName = "none",
	    textSize = 24,
	    justification = "center_justify",
	    string = creditsList[i].string,
	}
	y = y - verticalSpacing;
	table.insert(layer1.propContainer, highScoreText);
end

position = {x = 0, y = -250, z = 0};
scale = {x = .5, y = .5, z = 1};
rotation = {x = 0, y = 0, z = 0};
prop = {
	type = "Prop",
	name = "backButton",
	position = position,
	scale = scale,
	scripts = {},
	shaderName = "basic2d",
	textureName = "backOnPoorQuality.png",
	rotation = rotation,
}
table.insert(layer1.propContainer, prop);

layers = {};
table.insert(layers, layer1);

local function pickleThis()
	layerCount = 0;
	for k,v in pairs(layers) do
		file = io.open(".\\generated\\credits"..".lua", "wt");
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
