local Script = {
	name = "pauseLayerTransitionOut.lua",
};

function Script.update(layer, dt)
    local props = layer:getAllProps();
    for k,v in pairs(props) do
        local position = v:getLoc();
        v:setLoc(position.x + 1000 * dt, position.y, position.z);
    end
    
    local pausedTitle = layer:getPropByName("pausedTitle");
    if pausedTitle and pausedTitle:getType() == "Prop" then
        local fudge = 0;
        if pausedTitle:getLoc().x > require("WindowManager").screenWidth / 2 + (pausedTitle:getSize().x * pausedTitle:getScl().x) / 2 + fudge then
            require("MessageManager"):send("LAYER_FINISHED_TRANSITION", layer:getName());
            layer:replaceAllScripts(require("Factory"):createFromFile("Script", "doNothing.lua"));
        end
    end
end

return Script;