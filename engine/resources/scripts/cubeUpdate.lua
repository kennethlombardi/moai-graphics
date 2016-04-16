local Script = {
	name = "cubeUpdate.lua",
};

function Script.update(object, dt)
	local rotation = object:getRot();
	object:setRot(rotation.x, rotation.y + 0 * dt, rotation.z);
end

return Script;