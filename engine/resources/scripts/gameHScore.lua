local Script = {
	name = "gameHScore.lua",
};

local t = 0;
function Script.update(object, dt)  
  local gv = require("GameVariables");
  if gv:get("Score") > gv:get("HighScore") then
    gv:set("HighScore", gv:get("Score"));
  end
  object:setText(string.format('High Score: %d', gv:get("HighScore")));  
end

return Script;