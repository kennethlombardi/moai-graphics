dofile("Pickle.lua")

layer1 = {
	type = "Layer",
	name = "skybox.lua",
	visible = "true",
	propContainer = {},
	position = {x = 0, y = 0, z = 0},
	scripts = {"skybox.lua"}
};

width = 1280;
height = 720;
objectCount = 1;
scale = 50000
for i = 1, objectCount do
	position = {x = 0, y = 0, z = 0};
	scale = {x = scale, y = scale, z = scale};

	prop = {
		type = "Sphere",
		name = "skybox"..i,
		position = position,
		scale = scale,
		scripts = {"skybox.lua"},
		shaderName = "shader",
		textureName = "space.png",
		rotation = {x = 0, y = 0, z = 0},
	}
	table.insert(layer1.propContainer, prop);
end

layers = {};
table.insert(layers, layer1);

local function pickleThis()
	layerCount = 0;
	for k,v in pairs(layers) do
		file = io.open(".\\generated\\skybox"..".lua", "wt");
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
