local Script = {
	name = "outOfTimeLayerUpdate.lua",
};

local timeElapsed = 0;
function Script.update(layer, dt)
	timeElapsed = timeElapsed + dt;
    if timeElapsed > 1 then
        layer:replaceAllScripts(require("Factory"):createFromFile("Script", "outOfTimeLayerTransitionOut.lua"));
        timeElapsed = 0;
        return;
    end
end

return Script;