local Script = {
	name = "pauseButtonUpdate.lua",
};

local isPaused = false;
local function onPauseMenuClosed(payload)
    isPaused = false;
end

function Script.update(object, dt)  
    if require("InputManager"):isPausedTriggered() then 
        if not isPaused then
            require("MessageManager"):send("CLICKED_PAUSE_BUTTON");
        end
    end
end

require("MessageManager"):listen("PAUSE_LAYER_FINISHED_TRANSITION", onPauseMenuClosed);

return Script;