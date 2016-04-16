local Script = {
	name = "gameHudTransitionOut.lua",
};

function Script.update(layer, dt)
	local allProps = layer:getAllProps();
    local allFinished = true;
    for k,v in pairs(allProps) do
        local position = v:getLoc();
        v:setLoc(position.x + 1000 * dt, position.y, position.z);
        local fudge = 500;
        if position.x > require("WindowManager").screenWidth + fudge then
           allFinished = true;
        else
            allFinished = false;
        end
    end
    if allFinished == true then
        require("MessageManager"):send("LAYER_FINISHED_TRANSITION", layer:getName());
    end
end

return Script;