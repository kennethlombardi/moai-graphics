gen = {};
gen.spawned = 1;

local function returnEarly() return false end

function gen:spawnObject(x, y, z)
  if returnEarly() then return nil end
  local obj = math.random(0, 10);
  obj = obj - 3;
  properties = {};
  properties.scale = {x = 15, y = 15, z = 15};
  properties.position = {};
  properties.position.x = x or NormalRnd(- 300, 300);
  properties.position.y = y or NormalRnd(- 300, 300);
  properties.position.z = z;
  properties.rotation = {x = 0, y = 0, z = 0}
  properties.shaderName = "shader";
  properties.scripts = {};
  if obj >= 0 then
    return gen:spawnTorus(properties);
  else
    return gen:spawnSphere(properties);
  end
end

function gen:spawnCube(z) --speed lines
  if returnEarly() then return nil end
  properties = {};
  properties.scale = {x = 3, y = 3, z = 3};
  properties.position = {};
  local randx = math.random(600, 800);  
  properties.position.z = z;
  local angle = math.random(1, 360);
  properties.position.x = randx * math.cos(angle);
  properties.position.y = randx * math.sin(angle);
  properties.scripts = {};
  properties.rotation = {x = 0, y = 0, z = 0}
  properties.shaderName = "shader";
  
  properties.type = "PropCube";
  properties.name = "PropCube"..(gen.spawned);    
  table.insert(properties.scripts, "speedline.lua");
  properties.textureName = "whiteSquare.png";
  local newprop = require("Factory"):create("PropCube", properties); 
  gen.spawned = gen.spawned + 1;
  return newprop;
end

function gen:spawnTorus(properties)  
  if returnEarly() then return nil end
  properties.type = "Torus";
  properties.name = "Torus"..(gen.spawned);    
  properties.scale.y = 3;  
  properties.rotation.x = 90;  
  table.insert(properties.scripts,"ring.lua");  
  properties.textureName = "goldSquare.png";
  local newprop = require("Factory"):create("Torus", properties); 
  gen.spawned = gen.spawned + 1;
  return newprop;
end

function gen:spawnSphere(properties)
  if returnEarly() then return nil end
  properties.type = "Sphere";
  properties.name = "Sphere"..(gen.spawned);
  table.insert(properties.scripts,"obstacle.lua");
  properties.textureName = "rock.png";
  local newprop = require("Factory"):create("Sphere", properties);  
  gen.spawned = gen.spawned + 1;
  return newprop;
end

function NormalRnd(minVal, maxVal, count)
    if not count then
      count = 20;
    end
    local base = 0;
    for _ = 1, count do
        base = base + math.random(-200, 200);
    end;
    return base / count; --+ minVal;
end;

function gen:spawnPattern(x, y, z)
  local pattern = math.random(1, 3);
  
  local properties = {};
  properties.scale = {x = 15, y = 15, z = 15};
  properties.position = {};
  properties.position.x = x or NormalRnd(- 300, 300);
  properties.position.y = y or NormalRnd(- 300, 300);
  properties.position.z = z;
  properties.scripts = {};
  properties.rotation = {x = 0, y = 0, z = 0}
  properties.shaderName = "shader";
  
  if pattern == 1 then
    return gen:patternSpn(properties);
  elseif pattern == 2 then
    return gen:patternOsc(properties);
  elseif pattern == 3 then
    return gen:patternRow(properties);
  end
end

function gen:patternRow(properties)
  local objTable = {};
  
  for i = 1, 5 do    
    properties.scripts = {};
    local obj = math.random(0, 10);
    if obj >= 5 then
      table.insert(objTable, gen:spawnTorus(properties));
    else
      table.insert(objTable, gen:spawnSphere(properties));
    end
    properties.position.x = properties.position.x + NormalRnd(- 10, 10);
    properties.position.y = properties.position.y + NormalRnd(- 10, 10);
    properties.position.z = properties.position.z - 500;
  end
  return objTable;
end

function gen:patternOsc(properties)
  local objTable = {};
  
  for i = 1, 5 do  
    properties.scripts = {};
    table.insert(properties.scripts, "oscillate.lua");  
    properties.rotation.z = math.random(0,359);
    local obj = math.random(0, 10);
    if obj >= 5 then
      table.insert(objTable, gen:spawnTorus(properties));
    else
      table.insert(objTable, gen:spawnSphere(properties));
    end    
    properties.position.x = properties.position.x + NormalRnd(- 10, 10);
    properties.position.y = properties.position.y + NormalRnd(- 10, 10);
    properties.position.z = properties.position.z - 500;
  end
  return objTable;
end

function gen:patternSpn(properties)
  local objTable = {};
  
  local rndAngle = math.random(0,359);
  for i = 1, 5 do          
    properties.scripts = {};
    table.insert(properties.scripts, "spin.lua");  
    local obj = math.random(0, 10);
    if obj >= 5 then
      table.insert(objTable, gen:spawnTorus(properties));
    else
      table.insert(objTable, gen:spawnSphere(properties));
    end        
    properties.rotation.z = properties.rotation.z + 50; 
    properties.position.z = properties.position.z - 500;
  end
  return objTable;
end

return gen;