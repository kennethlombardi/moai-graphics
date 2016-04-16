local Script = {
	name = "mainMenu.lua",
};

function Script.update(object, dt)
  local Input = require("InputManager");	
  local pos = Input:getWindowPos();  
  if Input:isPressed() then
    local objects = object:pickForPoint(pos.x, pos.y);
    for k,v in pairs(objects) do
      if type(v) ~= "number" then
        if v.name == "playButton" then
          require("MessageManager"):send("CLICKED_PLAY_BUTTON");
        end
      end
    end
  end
end

return Script;