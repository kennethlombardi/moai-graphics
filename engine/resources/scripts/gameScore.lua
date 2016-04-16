local Script = {
	name = "gameScore.lua",
};

local t = 0;
function Script.update(object, dt)  
  local gv = require("GameVariables");
  gv:set("Score", gv:get("Distance") * (gv:get("Rings")*.1 + 1));
  object:setText(string.format('Curr Score: %d', gv:get("Score")));  
end

return Script;