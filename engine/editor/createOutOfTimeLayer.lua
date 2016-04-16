dofile("Pickle.lua")

layer1 = {
	type = "LayerDD",
	name = "outOfTime.lua",
	visible = "true",
	propContainer = {},
	position = {x = 0, y = 0, z = 0},
	scripts = {"outOfTimeLayerUpdate.lua"}
};

width = 1280;
height = 720;


--[[
{--Entry Number: {5}
		["type"]="TextBox",
		["scale"]={6},
		["shaderName"]="none",
		["rectangle"]={7},
		["name"]="TextBox#1",
		["position"]={8},
		["scripts"]={9},
		["textSize"]=24,
		["string"]="Time Remaining",
	},
--]]
prop = {
	type = "TextBox",
	name = "outOfTimeText",
    position = {x = 0, y = 0, z = 0};
    scale = {x = 1, y = 1, z = 1};
    rotation = {x = 0, y = 0, z = 0};
    rectangle = {x1 = -300, x2 = 300, y1 = -100, y2 = 100},
	scripts = {},
	shaderName = "none",
    textSize = 72,
    string = "Out Of Time!!",
    justification = "center_justify",
}
table.insert(layer1.propContainer, prop);

local function pickleThis()

    file = io.open(".\\generated\\outOfTime"..".lua", "wt");
    s = "deserialize (\"Layer\",\n";
    file:write(s);
    s = pickle(layer1);
    file:write(s);
    s = ")\n\n";
    file:write(s);
    file:close();

end

pickleThis();
