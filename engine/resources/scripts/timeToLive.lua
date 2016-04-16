local Script = {
	name = "timeToLive.lua",
};

function Script.update(object, dt)  
  local objectScl = object:getScl();
  local objectLoc = object:getLoc();
  object:setScl(objectScl.x*.95, objectScl.y*.95, objectScl.z*.95);
  object:setLoc(objectLoc.x, objectLoc.y + 100*dt, objectLoc.z);
  if objectScl.x < 10 then
    object:destroy();
    object:clearAllScripts();
  end
end

return Script;