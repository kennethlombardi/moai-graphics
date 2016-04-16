local Script = {
	name = "PropMovement.lua",
};

local t = 0;
function Script.update(object, dt)
	local position = object:getLoc();
	local step = 32 * dt;
	--object:setLoc(position.x + step, position.y, position.z); 
end

return Script;