local Script = {
	name = "gameScore.lua",
};

local t = 0;
function Script.update(object, dt)  
  object:setText(string.format('Distance: %d km', require("GameVariables"):get("Distance")));  
end

return Script;