local Script = {
    name = "happyUpdate.lua",
};

function Script.update(object, dt)
    local rotation = object:getRot();
    object:setRot(rotation.x + 0 * dt, rotation.y + 0 * dt, rotation.z + 0 * dt);
end

return Script;