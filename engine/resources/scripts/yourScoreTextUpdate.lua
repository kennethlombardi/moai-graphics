local Script = {
	name = "yourScoreTextUpdate.lua",
};

gameVariables = require("GameVariables");

function Script.update(prop, dt)
    prop:setText(string.format('Your Score: %d', gameVariables:get("Score")));
end

return Script;