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

function randPos(x, y, z)
  position = {};
  local randx = math.random (x, y);
  local angle = math.random(1, 360);
  position.x = randx * math.cos(angle);
  position.y = randx * math.sin(angle);
  position.z = z;
  return position;
end

scale = 1000;
--earth
prop = {
    type = "Sphere",
    name = "earth",    
    position = randPos(2000,3000,-10000),
    scale = {x = scale, y = scale, z = scale},
    scripts = {"earthSpinning.lua"},
    shaderName = "shader",
    textureName = "earthWrap.png",
    rotation = {x = 0, y = 0, z = math.random(1, 360)},
}
table.insert(layer1.propContainer, prop);

--moon
prop = {
    type = "Sphere",
    name = "moon",    
    position = randPos(800,1000,-20000),
    scale = {x = .27*scale, y = .27*scale, z = .27*scale},
    scripts = {"earthSpinning.lua"},
    shaderName = "shader",
    textureName = "moonWrap.jpg",
    rotation = {x = 0, y = 0, z = math.random(1, 360)},
}
table.insert(layer1.propContainer, prop);

-- mars
prop = {
    type = "Sphere",
    name = "mars",
    position = randPos(2000,3000,-40000),
    scale = {x = .532*scale, y = .532*scale, z = .532*scale},
    scripts = {"earthSpinning.lua"},
    shaderName = "shader",
    textureName = "marsWrap.png",
    rotation = {x = 0, y = 0, z = math.random(1, 360)},
}
table.insert(layer1.propContainer, prop);

-- jupiter
prop = {
    type = "Sphere",
    name = "jupiter",
    position = randPos(5500,8000,-60000),
    scale = {x = 11.1*scale, y = 11.1*scale, z = 11.1*scale},
    scripts = {"earthSpinning.lua"},
    shaderName = "shader",
    textureName = "jupiterWrap.jpg",
    rotation = {x = 0, y = 0, z = math.random(1, 360)},
}
table.insert(layer1.propContainer, prop);

-- saturn
prop = {
    type = "Sphere",
    name = "saturn",
    position = randPos(5000,7000,-80000),
    scale = {x = 9.41*scale, y = 9.41*scale, z = 9.41*scale},
    scripts = {"earthSpinning.lua"},
    shaderName = "shader",
    textureName = "saturnWrap.jpg",
    rotation = {x = 0, y = 0, z = math.random(1, 360)},
}
table.insert(layer1.propContainer, prop);

-- uranus
prop = {
    type = "Sphere",
    name = "uranus",
    position = randPos(2000,4000,-100000),
    scale = {x = 4*scale, y = 4*scale, z = 4*scale},
    scripts = {"earthSpinning.lua"},
    shaderName = "shader",
    textureName = "uranusWrap.jpg",
    rotation = {x = 0, y = 0, z = math.random(1, 360)},
}
table.insert(layer1.propContainer, prop);


-- neptune
prop = {
    type = "Sphere",
    name = "neptune",
    position = randPos(2000,4000,-120000),
    scale = {x = 3.88*scale, y = 3.88*scale, z = 3.88*scale},
    scripts = {"earthSpinning.lua"},
    shaderName = "shader",
    textureName = "neptuneWrap.jpg",
    rotation = {x = 0, y = 0, z = math.random(1, 360)},
}
table.insert(layer1.propContainer, prop);

-- pluto
prop = {
    type = "Sphere",
    name = "pluto",
    position = randPos(700,1000,-140000),
    scale = {x = .18*scale, y = .18*scale, z = .18*scale},
    scripts = {"earthSpinning.lua"},
    shaderName = "shader",
    textureName = "plutoWrap.jpg",
    rotation = {x = 0, y = 0, z = math.random(1, 360)},
}
table.insert(layer1.propContainer, prop);

layers = {};
table.insert(layers, layer1);

local function pickleThis()
	layerCount = 0;
	for k,v in pairs(layers) do
		file = io.open(".\\generated\\gameLayer"..".lua", "wt");
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
