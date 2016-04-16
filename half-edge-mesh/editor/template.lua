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
objectCount = 300;
for i = 1, objectCount do
	position = {x = math.random(-300, 300), y = math.random(-300, 300), z = -1000};
	scale = {x = 10, y = 10, z = 10};

	prop = {
		type = "PropCube",
		name = "Prop"..i,
		position = position,
		scale = scale,
		scripts = {"PropMovement.lua"},
		shaderName = "shader",
		textureName = "rock.png",
		rotation = {x = 0, y = 0, z = 0},
	}
	table.insert(layer1.propContainer, prop);
end

local function pickleThis()
    file = io.open(".\\generated\\starfield"..".lua", "wt");
    s = "deserialize (\"Layer\",\n";
    file:write(s);
    s = pickle(layer1);
    file:write(s);
    s = ")\n\n";
    file:write(s);
    file:close();
end

pickleThis();
