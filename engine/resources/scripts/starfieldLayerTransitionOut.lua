local Script = {
	name = "starfieldLayerTransitionOut.lua",
};

function Script.update(object, dt)
	local position = object:getLoc();
	object:setLoc(position.x, position.y, position.z - 3000 * dt);
  local props = object:getAllProps();
	for k,v in pairs(props) do		
    local scale = v:getScl();
    v:setScl(scale.x, scale.y, scale.z*1.5);
	end
  
	if position.z > 3000 then
		require("MessageManager"):send("LAYER_FINISHED_TRANSITION", object:getName());
	end
end

return Script;