local Script = {
	name = "speedline.lua",
};
function Script.update(object, dt)  
  local objectScl = object:getScl();    
  local objectPos = object:getLoc();  
  Input = require("InputManager");
  local scale = 5;
  local limit = 5000;
  if Input:isPressed() then
    if objectScl.z < limit then
      object:setScl(objectScl.x, objectScl.y, objectScl.z*1.2);
      object:setLoc(objectPos.x, objectPos.y, objectPos.z - dt);
    end
  else
    if objectScl.z > scale then
      object:setScl(objectScl.x, objectScl.y, objectScl.z*.8);
    end
  end
  -- do a check to delete once they are flown by
  
  local playerPosition = require("GameVariables"):get("Position");
  local diff = {};    
  
  diff.z = objectPos.z - playerPosition.z;
    

  -- Ken hack to destroy the speedline immediately until fix is found for the diff.z all being negative
  --object:clearAllScripts();
  --object:destroy();
  --if 1 then return end

  -- Stephen: Something is wrong here. All diff.z are negative
  --          Also don't call methods on an object after you destroy it. Bad mojo.
  if diff.z > 30 then  --past object
    object:clearAllScripts();
    object:destroy();       
    --need to register message with layer to delete object, would be better
    --require("LayerManager"):getLayerByIndex(require("GameVariables"):GetLayer()):removeProp(object);
    --require("LayerManager"):getLayerByIndex(require("GameVariables"):GetLayer()):removePropPersistent(object);		         
    return;
  end
end

return Script;