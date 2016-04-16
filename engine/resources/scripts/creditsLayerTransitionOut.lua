local Script = {
	name = "creditsLayerTransitionOut.lua",
};

Input = require("InputManager");

local elapsedTime = 0;
function Script.update(layer, dt)
    elapsedTime = elapsedTime + dt;
    local allProps = layer:getAllProps();
    for k,v in pairs(allProps) do
        local position = v:getLoc();
        v:setLoc(position.x, position.y - 1000 * dt, position.z);
    end

    if elapsedTime > 1 then
        elapsedTime = 0;
        layer:replaceAllScripts(require("Factory"):createFromFile("Script", ""));
        require("MessageManager"):send("LAYER_FINISHED_TRANSITION", layer:getName());
    end
end

return Script;