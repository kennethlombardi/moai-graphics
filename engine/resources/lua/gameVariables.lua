local GameVariables = {};
GameVariables.globals = {};

function GameVariables:get(variableName)
	local temp = GameVariables.globals[variableName];
	return temp;
end

function GameVariables:set(variableName, value)
	GameVariables.globals[variableName] = value;	
end

function GameVariables:add(variableName, value) --only needed for some things
	GameVariables.globals[variableName] = GameVariables.globals[variableName] + value;	
end
  
function GameVariables:shutdown()
	GameVariables.globals = nil;
	GameVariables = nil;
end

function GameVariables:register(variableName, value)
	GameVariables.globals[variableName] = value;
end	

function GameVariables:reset()
  self:set("Timer", 30);
  self:set("Rings", 0);
  self:set("Distance", 0);
  self:set("Score", 0);
end

GameVariables:register("Timer", 0);
GameVariables:register("Position", {x=0, y=0, z=0});
GameVariables:register("LastPosition", {x=0, y=0, z=0});
GameVariables:register("HighScore", 0);
GameVariables:register("Distance", 0);
GameVariables:register("Rings", 0);
GameVariables:register("Score", 0);
GameVariables:register("ShakeCamera", false);	

return GameVariables;
