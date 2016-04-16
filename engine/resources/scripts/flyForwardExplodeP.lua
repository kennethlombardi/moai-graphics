local Script = {
	name = "flyForwardExplodeP.lua",
};
function Script.update(object, dt)  
  local objectPos = object:getLoc();  
  objectPos.z = objectPos.z - 5000*dt;
  object:setLoc(objectPos.x, objectPos.y, objectPos.z);  
  local playPos = require("GameVariables"):get("Position");
  if math.abs(objectPos.z - playPos.z) >= 2000 then
    object:clearAllScripts();
    object:destroy();
    require("GameVariables"):add("Timer", 2);  
    require("GameVariables"):add("Rings", 1);  
    require("MessageManager"):send("ADD_TIMER", objectPos);
    --play explosion, show +1
  end    
    
end

return Script;