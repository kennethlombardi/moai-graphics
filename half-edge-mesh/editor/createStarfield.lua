dofile("Pickle.lua")

layer1 = {
	type = "Layer",
	name = "starfield.lua",
	visible = "true",
	propContainer = {},
	position = {x = 0, y = 0, z = 0},
	scripts = {"starfield.lua"}
};

width = 1280;
height = 720;
objectCount = 10;
for i = 1, objectCount do
	position = {};
	scale = {x = 3, y = 3, z = 3};
  local randx = math.random(600, 800);
  position.z = -1000
  local angle = math.random(1, 360);
  position.x = randx * math.cos(angle);
  position.y = randx * math.sin(angle);
	prop = {
		type = "PropCube",
		name = "Prop"..i,
		position = position,
		scale = scale,
		scripts = {"speedline.lua"},
		shaderName = "shader",
		textureName = "whiteSquare.png",
		rotation = {x = 0, y = 0, z = 0},
	}
	table.insert(layer1.propContainer, prop);
end

layers = {};
table.insert(layers, layer1);

local function pickleThis()
	layerCount = 0;
	for k,v in pairs(layers) do
		file = io.open(".\\generated\\starfield"..".lua", "wt");
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
