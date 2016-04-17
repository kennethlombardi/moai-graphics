local Script = {
    name = "bunnyUpdate.lua"
};

function Script.update(object, dt)
    local rotation = object:getRot();
    -- local position = object:getLoc();
    object:setRot(rotation.x, rotation.y + 5 * dt, rotation.z + 5 * dt);
    -- object:setLoc(position.x, position.y, position.z + 2)
end

return Script;
