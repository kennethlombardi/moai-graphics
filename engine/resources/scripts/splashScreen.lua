local Script = {
	name = "splashScreen.lua",
};

local elapsedTime = 0;
local transition = 0;
local speedScl = 1;
function Script.update(layer, dt)
  elapsedTime = elapsedTime + dt;
	local allProps = layer:getAllProps();
  for k,v in pairs(allProps) do
    local position = v:getScl();
    if transition == 0 then
      v:setScl(position.x + speedScl * dt, position.y + speedScl * dt, position.z);
    elseif transition == 2 then
      v:setScl(position.x - speedScl * dt, position.y - speedScl * dt, position.z);
    end
  end

  if elapsedTime > 1.5 then
    elapsedTime = 0;
    transition = transition + 1;    
  end  
  
  if transition > 2 or require("InputManager"):isPressed() then
    layer:replaceAllScripts(require("Factory"):createFromFile("Script", ""));
    require("MessageManager"):send("LAYER_FINISHED_TRANSITION", layer:getName());
  end
    
end

return Script;