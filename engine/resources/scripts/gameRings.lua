local Script = {
	name = "gameRings.lua",
};

local t = 0;
function Script.update(object, dt)  
  object:setText(string.format('Rings: %d', require("GameVariables"):get("Rings")));  
end

return Script;