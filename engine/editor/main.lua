dofile("Pickle.lua")

layer1 = {
	type = "Layer",
	name = "Layer0",
	visible = "true",
	propContainer = {},
	position = {x = 0, y = 0, z = 0},
	scripts = {"LayerMovement.lua"}
};

width = 1280;
height = 720;
objectCount = 3;
for i = 1, objectCount do
	position = {x = math.random(-300, 300), y = math.random(-300, 300), z = -1000};
	scale = {x = 10, y = 10, z = 10};
	if i % 100 == 0 then 
		scale = {x = 100, y = 100, z = 100}
	end
	prop = {
		type = "PropCube",
		["name"] = "Prop"..i,
		position = position,
		scale = scale,
		scripts = {"PropMovement.lua"},
		shaderName = "shader",
		textureName = "rock.png",
	}
	table.insert(layer1.propContainer, prop);
end

objectCount = 1;
layer2 = {
	type = "LayerDD",
	name = "Layer1",
	visible = "true",
	propContainer = {},
	position = {x = 0, y = 0, z = 0},
	scripts = {"Hud.lua"},
};

for i = 1, objectCount do
	prop = {
		type = "TextBox",
		["name"] = "TextBox#"..i,
		position = {
			x = 0,
			y = 0,
			z = 0,
		},
		scale = {
			x = 1, 
			y = 1, 
			z = 1,
		},
		textSize = 24,
		rectangle = {x1 = -50, y1 = -100, x2 = 300, y2 = 100},
		string = "This is text in a level file",
		scripts = {"PerformanceCounter.lua"},
		shaderName = "ken"
	}
	table.insert(layer2.propContainer, prop);
end


layers = {};
table.insert(layers, layer1);
table.insert(layers, layer2);

local function pickleThis()
	layerCount = 0;
	for k,v in pairs(layers) do
		file = io.open(".\\generated\\pickleFile"..layerCount..".lua", "wt");
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

----------------------------------------------
-- unpickle
----------------------------------------------

function unpickleMe(s)
  local tables = s;
  
  for tnum = 1, table.getn(tables) do
    local t = tables[tnum]
    local tcopy = {}; for i, v in pairs(t) do tcopy[i] = v end
    for i, v in pairs(tcopy) do
      local ni, nv
      if type(i) == "table" then ni = tables[i[1]] else ni = i end
      if type(v) == "table" then nv = tables[v[1]] else nv = v end
      t[i] = nil
      t[ni] = nv
    end
  end
  return tables[1]
end

local function unpickleThis()
	local layerCount = 0;
	for k,v in pairs(layers) do
		function deserialize(arg1, pickle)
			print(arg1);
			up = unpickleMe( pickle );
			print(up.name);
			for k,prop in pairs(up.propContainer) do
				print(prop.name);
			end
		end
		dofile(".\\generated\\pickleFile"..layerCount..".lua");
		layerCount = layerCount + 1;
	end
end

pickleThis();
unpickleThis();