local Script = {
	name = "gameLayerTransitionOut.lua",
};

function Script.update(layer, dt)
	local allProps = layer:getAllProps();
    for k,v in pairs(allProps) do
        local position = v:getLoc();
        v:setLoc(position.x, position.y, position.z - 10000 * dt);
        if v:getName() == "earth" then
            if v:getLoc().z < -10000 then
                require("MessageManager"):send("LAYER_FINISHED_TRANSITION", layer:getName());
                return;
            end
        end
    end
end

return Script;