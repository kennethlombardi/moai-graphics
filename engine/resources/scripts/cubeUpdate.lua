local Script = {
	name = "cubeUpdate.lua",
};

function Script.update(object, dt)
	local rotation = object:getRot();
    local location = object:getLoc();
	object:setRot(rotation.x + 20 * dt, rotation.y + 20 * dt, rotation.z + 20 * dt);
    object:setLoc(location.x, location.y, location.z + 1 * -dt);
end

return Script;
