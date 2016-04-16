local Script = {
	name = "highScoreTextUpdate.lua",
};

userData = require("UserDataManager");

function Script.update(prop, dt)
    prop:setText(string.format('High Score: %d', userData:get("highScore")));
end

return Script;