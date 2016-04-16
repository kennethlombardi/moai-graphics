local Script = {
	name = "outOfTimeLayerTransitionOut.lua",
};

function Script.update(layer, dt)
	local outOfTimeText = layer:getPropByName("outOfTimeText");
    if outOfTimeText then
        local position = outOfTimeText:getLoc();
        outOfTimeText:setLoc(position.x + dt * 1500, position.y, position.z);
        local size = 1000;
        if position.x > require("WindowManager").screenWidth / 2 + size / 2 then
            require("MessageManager"):send("LAYER_FINISHED_TRANSITION", layer:getName());
            layer:clearAllScripts();
        end
    end
end

return Script;