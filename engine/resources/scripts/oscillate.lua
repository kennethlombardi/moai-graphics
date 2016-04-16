local Script = {
	name = "oscillate.lua",
};
local t = 0;
function Script.update(object, dt)    
  local originalRot = object:getRot();
  local originalPos = object:getLoc();
  local rndAngle = math.random(0, 359);
  
  local radtodeg = 3.14/180;
  t = t + 5*dt;
  object:setLoc(100*math.cos(t*radtodeg)*math.cos(originalRot.z),  100*math.cos(t*radtodeg)*math.sin(originalRot.z), originalPos.z);             
end

return Script;