dofile("Pickle.lua")

layer1 = {
	type = "Layer",
	name = "gameLayer.lua",
	visible = "true",
	propContainer = {},
	position = {x = 0, y = 0, z = 0},
	scripts = {"LayerMovement.lua"}
};

width = 1280;
height = 720;

-- mars
prop = {
    type = "Sphere",
    name = "mars",
    position = {x = 0, y = 0, z = -5000},
    scale = {x = 1000, y = 1000, z = 1000},
    scripts = {"earthSpinning.lua"},
    shaderName = "shader",
    textureName = "marsWrap.png",
    rotation = {x = 0, y = 0, z = 0},
}
table.insert(layer1.propContainer, prop);

-- earth
prop = {
    type = "Sphere",
    name = "earth",
    position = {x = 3380, y = 2000, z = -8000},
    scale = {x = 1000, y = 1000, z = 1000},
    scripts = {"earthSpinning.lua"},
    shaderName = "shader",
    textureName = "earthWrap.png",
    rotation = {x = 0, y = 0, z = 20},
}
table.insert(layer1.propContainer, prop);

-- rock
prop = {
    type = "Sphere",
    name = "rock",
    position = {x = -3400, y = -1034, z = -9000},
    scale = {x = 1000, y = 1000, z = 1000},
    scripts = {"earthSpinning.lua"},
    shaderName = "shader",
    textureName = "rock.png",
    rotation = {x = 0, y = 0, z = 20},
}
table.insert(layer1.propContainer, prop);


layers = {};
table.insert(layers, layer1);

local function pickleThis()
	layerCount = 0;
	for k,v in pairs(layers) do
		file = io.open(".\\generated\\gameLayerTest"..".lua", "wt");
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
