dofile("Pickle.lua")

layer1 = {
	type = "LayerDD",
	name = "pause.lua",
	visible = "true",
	propContainer = {},
	position = {x = 0, y = 0, z = 0},
	scripts = {"pauseLayerUpdate.lua"}
};

width = 1280;
height = 720;

-- Paused title
position = {x = 0, y = 200, z = 0};
scale = {x = .5, y = .5, z = .5};
rotation = {x = 0, y = 0, z = 0};
prop = {
	type = "Prop",
	name = "pausedTitle",
	position = position,
	scale = scale,
	scripts = {},
	shaderName = "basic2d",
	textureName = "pausedTitle.png",
	rotation = rotation,
}
table.insert(layer1.propContainer, prop);

-- Resume button
position = {x = 0, y = 100, z = 0};
scale = {x = .5, y = .5, z = .5};
rotation = {x = 0, y = 0, z = 0};
prop = {
	type = "Prop",
	name = "resumeButton",
	position = position,
	scale = scale,
	scripts = {},
	shaderName = "basic2d",
	textureName = "resumeOn.png",
	rotation = rotation,
}
table.insert(layer1.propContainer, prop);

-- Quit button
position = {x = 0, y = 0, z = 0};
scale = {x = .5, y = .5, z = .5};
rotation = {x = 0, y = 0, z = 0};
prop = {
	type = "Prop",
	name = "quitButton",
	position = position,
	scale = scale,
	scripts = {},
	shaderName = "basic2d",
	textureName = "quitOn.png",
	rotation = rotation,
}
table.insert(layer1.propContainer, prop);

-- Credits button
position = {x = 0, y = -100, z = 0};
scale = {x = .5, y = .5, z = .5};
rotation = {x = 0, y = 0, z = 0};
prop = {
	type = "Prop",
	name = "creditsButton",
	position = position,
	scale = scale,
	scripts = {},
	shaderName = "basic2d",
	textureName = "creditsOn.png",
	rotation = rotation,
}
table.insert(layer1.propContainer, prop);

-- Restart button
position = {x = 0, y = -200, z = 0};
scale = {x = .5, y = .5, z = .5};
rotation = {x = 0, y = 0, z = 0};
prop = {
	type = "Prop",
	name = "resetLevelButton",
	position = position,
	scale = scale,
	scripts = {},
	shaderName = "basic2d",
	textureName = "resetlevelOn.png",
	rotation = rotation,
}
table.insert(layer1.propContainer, prop);

layers = {};
table.insert(layers, layer1);

local function pickleThis()
	layerCount = 0;
	for k,v in pairs(layers) do
		file = io.open(".\\generated\\pause"..".lua", "wt");
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
