local Script = {
	name = "obstacle.lua",
};
function Script.update(object, dt)
  local gameVariables = require("GameVariables");  
  local objectPos = object:getLoc();  
  local playerPosition = gameVariables:get("Position");
  local diff = {};    
  
  diff.z = objectPos.z - playerPosition.z;
  diff.x = objectPos.x - playerPosition.x;
  diff.y = objectPos.y - playerPosition.y;
    

  -- ken hack to destroy all objects
  if 1 then 
    --object:clearAllScripts();
    --object:destroy();
    --return
  end


  if diff.z > -20 then --getting closer to object, let's go ahead and start checking collision
    --!!!!!!!!!!!!!!!!!!!!!!ONCE POSITION IS FIXED WITH MOVELOC, PUT THIS BACK IN----------------------------------
     if diff.z > 30 then --past object
      object:clearAllScripts();
      object:destroy(); 
      
      return;
     end
    local distSqrd = diff.x * diff.x + diff.y * diff.y + diff.z * diff.z;
    local objectRadius = 200;
    if distSqrd < objectRadius then   
      --require("GameVariables"):add("Timer", -5); 
      require("SoundManager"):play("crash.wav", false);      
      object:replaceAllScripts(require("Factory"):createFromFile("Script", "flyForwardExplodeM.lua"));    
      require("GameVariables"):set("ShakeCamera", true);
      -- object:moveLoc(0, 0, -5000, 1, nil);   
      -- object:setLoc(objectPos.x, objectPos.y, objectPos.z + 200);      
    end    
  end         
end

return Script;