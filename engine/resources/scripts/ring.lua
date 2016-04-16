local Script = {
	name = "ring.lua",
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
      -- require("LayerManager"):getLayerByIndex(require("GameVariables"):GetLayer()):removeProp(object);
      -- require("LayerManager"):getLayerByIndex(require("GameVariables"):GetLayer()):removePropPersistent(object);		         
      return;
     end
    local distSqrd = diff.x * diff.x + diff.y * diff.y + diff.z * diff.z;
    local objectRadius = 200;
    if distSqrd < objectRadius then        --collided
      --require("GameVariables"):add("Timer", 2); 
      require("SoundManager"):play("chime.wav", false);            
      object:replaceAllScripts(require("Factory"):createFromFile("Script", "flyForwardExplodeP.lua"));
      --object:moveLoc(0, 0, -5000, 1, nil);   
      --object:setLoc(objectPos.x, objectPos.y, objectPos.z + 200);
      
    end
    --!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!ONCE POSITION IS FIXED WITH MOVELOC, PUT THIS BACK IN----------------------------------
  -- elseif diff.z < -3000 then            
    -- gameVariables:AddGameTimer(2);
    -- gameVariables:AddScore(100);
    -- require("LayerManager"):getLayerByIndex(require("GameVariables"):GetLayer()):removeProp(object);
    -- require("LayerManager"):getLayerByIndex(require("GameVariables"):GetLayer()):removePropPersistent(object);		
  end         
end

return Script;