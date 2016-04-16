local Script = {
	name = "LayerMovement.lua",
};
local zPressed = 1;
local zMax = 5;
local xRot = 0;
local yRot = 0;
local LayerManager = require("LayerManager");
local lastZSpawn = 0;
local spawnTimer2 = 0;
local shakeTimer = 0;

local function kenHack(object, dt) 
spawnTimer2 = spawnTimer2 + dt;
  local position = object:getLoc();
  
  
  
  
  

  
  local InputManager = require("InputManager");
  local gameVariables = require("GameVariables");    
  
  local move = InputManager:getMove();
  local scale = 10; 
  
  local newPos = {x = position.x + scale*move.x, y =  position.y + scale*move.y, z = position.z};

      zPressed = 10000;

  newPos.z = newPos.z - scale*zPressed;
  object:setRot(0, 0, zRot);
  object:setLoc(newPos.x, newPos.y, newPos.z);
  gameVariables:set("Position", newPos);
  gameVariables:set("Distance", -newPos.z);  
  local newProps = require("Generator"):spawnPattern(nil, nil, position.z - 3500);
  for k,v in pairs(newProps) do
    object:insertProp(v);
  end

end

function Script.update(object, dt)
  --kenHack(object, dt);
  --if 1 then return end

  spawnTimer2 = spawnTimer2 + dt;
  local position = object:getLoc();
  
  if math.abs(lastZSpawn - position.z) > 5000 then
    lastZSpawn = 0
    shakeTimer = 0;
  end
  
  if lastZSpawn - position.z > 500 then   
    if math.random(0, 10) > 1 then
      lastZSpawn = position.z -2000;
      local newprops = require("Generator"):spawnPattern(nil, nil, position.z - 3500);  
      if newprops ~= nil then
        for i = 1, #newprops do
          object:insertProp(newprops[i]);
        end
      end
    else     
      lastZSpawn = position.z - 1000;
      local newprop = require("Generator"):spawnObject(nil, nil, position.z - 3500);  
      object:insertProp(newprop);
    end
  end
  
  if spawnTimer2 > .2 then
    spawnTimer2 = 0;    
    local newprop = require("Generator"):spawnCube(position.z - 5000);  
    object:insertProp(newprop);
  end
  
  local InputManager = require("InputManager");
  local gameVariables = require("GameVariables");    
  
  if gameVariables:get("ShakeCamera") then
    shakeTimer = 3.141592654;
    gameVariables:set("ShakeCamera", false);
  end
  
  if InputManager.Android then
    if InputManager:isScreenTriggered(1) then
      InputManager:reCal();
    end	
  end
  
  local move = InputManager:getMove();
  local scale = 10; 
  
  local newPos = {x = position.x + scale*move.x, y =  position.y + scale*move.y, z = position.z};
  local limit = 500;
  scale = 10;
  -- yRot = yRot - move.x*scale*dt;
  -- xRot = xRot + move.y*scale*dt;  
  if shakeTimer > 0 then
    zRot = 3*math.cos(shakeTimer*180/3.14152654)
    shakeTimer = shakeTimer - 5*dt;
  else
    zRot = 0;
  end
  
  if newPos.x > limit then
    newPos.x = limit;
  elseif newPos.x < -limit then
    newPos.x = -limit;
  end
  
  if newPos.y > limit then
    newPos.y = limit;
  elseif newPos.y < -limit then
    newPos.y = -limit;
  end

  -- rotLimit = scale;
  -- if xRot > rotLimit then
    -- xRot = rotLimit;
  -- elseif xRot < -rotLimit then
    -- xRot = -rotLimit;
  -- end
  
  -- if yRot > rotLimit then
    -- yRot = rotLimit;
  -- elseif yRot < -rotLimit then
    -- yRot = -rotLimit;
  -- end

  
  if InputManager:isPressed() then
    if zPressed < zMax then
      zPressed = zPressed + 3*dt;            
    end
  elseif InputManager:isTriggered() then
    require("SoundManager"):play("woosh.wav", false); 
  else
    require("SoundManager"):stop("woosh.wav"); 
    if zPressed > 1 then
      zPressed = zPressed * .9;
    else
      zPressed = 1;
    end    
  end
  newPos.z = newPos.z - scale*zPressed;
  object:setRot(0, 0, zRot);
  object:setLoc(newPos.x, newPos.y, newPos.z);
  gameVariables:set("Position", newPos);
  gameVariables:set("Distance", -newPos.z); 
  
end

return Script;
