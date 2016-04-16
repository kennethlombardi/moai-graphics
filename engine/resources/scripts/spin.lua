local Script = {
	name = "spin.lua",
};
local t = 0;
function Script.update(object, dt)    
  local originalRot = object:getRot();
  local originalPos = object:getLoc();
  
  local radtodeg = 3.14/180;
  t = t + 5*dt;
  object:setLoc(originalRot.z*math.cos(t*radtodeg),  originalRot.z*math.sin(t*radtodeg), originalPos.z);             
end

return Script;