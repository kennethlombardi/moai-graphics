local Script = {
	name = "earthSpinning.lua",
};

function Script.update(object, dt)
	local rotation = object:getRot();
	object:setRot(rotation.x, rotation.y + 50 * dt, rotation.z);
  local position = object:getLoc();
  local gameVariables = require("GameVariables");  
  local playerPosition = gameVariables:get("Position");
  local diffz = position.z - playerPosition.z;  
  if diffz > -1 then
    object:clearAllScripts();
    position.x = playerPosition.x;
    position.y = playerPosition.y;
    require("MessageManager"):send("CHECKPOINT", position);
    object:destroy();
  end

end

return Script;