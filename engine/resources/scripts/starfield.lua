local Script = {
	name = "starfield.lua",
};
local zPressed = 1;
local zMax = 5;
local spawnTimer = 0;

function Script.update(object, dt)
  spawnTimer = spawnTimer + dt;
	local position = object:getLoc();
	object:setLoc(position.x, position.y, position.z - dt * 300);
    if spawnTimer > .1 then    
      spawnTimer = 0;
      local newProp = require("Generator"):spawnCube(position.z - 3000);  
      object:insertProp(newProp);
      --newProp:destroy();
    end
end

return Script;