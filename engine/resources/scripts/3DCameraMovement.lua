local Script = {
    name = "3DCameraMovement.lua",
};

local InputManager = require("InputManager");

function Script.update(object, dt)
    local position = object:getLoc();
    local rotation = object:getRot();
    local move = InputManager:getMove();
    local moveSpeed = 1 * dt;
    local lookSpeed = 50 * dt;
    local wPressed = InputManager:isKeyPressed(InputManager.Key["w"]);
    local aPressed = InputManager:isKeyPressed(InputManager.Key["a"]);
    local sPressed = InputManager:isKeyPressed(InputManager.Key["s"]);
    local dPressed = InputManager:isKeyPressed(InputManager.Key["d"]);

    -- weird mouse following bullshittery
    -- rotation.y = rotation.y - move.x  * lookSpeed;
    -- rotation.x = rotation.x + move.y * lookSpeed;

    if wPressed then
        position.z = position.z - math.cos((math.pi / 180) * rotation.y) * moveSpeed;
        position.y = position.y + math.sin((math.pi / 180) * rotation.x) * moveSpeed;
        position.x = position.x - math.sin((math.pi / 180) * rotation.y) * moveSpeed;
    end

    if aPressed then
        position.x = position.x - moveSpeed;
    end

    if sPressed then
        position.z = position.z + math.cos((math.pi / 180) * rotation.y) * moveSpeed;
        position.y = position.y - math.sin((math.pi / 180) * rotation.x) * moveSpeed;
        position.x = position.x + math.sin((math.pi / 180) * rotation.y) * moveSpeed;
    end

    if dPressed then
        position.x = position.x + moveSpeed;
    end

    object:setRot(rotation.x, rotation.y, 0);
    object:setLoc(position.x, position.y, position.z);
end

return Script;
