local Script = {
	name = "PerformanceCounter.lua",
};

local t = 0;
local SimulationManager = require("SimulationManager");
function Script.update(object, dt)
	--object:setText(string.format('dt %f : FPS %f', SimulationManager:getStep(), SimulationManager:getPerformance()));
  object:setText(string.format('FPS %.0f', SimulationManager:getPerformance()));
end

return Script;