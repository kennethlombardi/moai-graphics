local SceneManager = {
    activeScene = nil
}

local MessageManager = require("MessageManager");
local LayerManager = require("LayerManager");

function SceneManager:shutdown()
	MessageManager = nil;
	LayerManager = nil;
	Factory = nil;
    GameVariables = nil;
	self:removeAllScenes();
end

local keys = {
    "1", "2", "3", "4",
    "5", "6", "7", "8",
    "9", "b", "t", "e",
    "g", "f", "r", "v", "h",
    "SPACE", "o", "l", "u", "i", "u", "y", "p"}

function SceneManager:update(dt)
	self.activeScene:update(dt);
    local InputManager = require("InputManager");
    if InputManager:isKeyTriggered(InputManager.Key["esc"]) then
        MessageManager:send("QUIT");
    end

    -- check if any of the keys we care about are pressed
    for k, v in pairs(keys) do
        if InputManager:isKeyTriggered(InputManager.Key[v]) then
            MessageManager:send("KeyPressed_"..v, v);
        end
    end
end

function SceneManager:removeAllScenes()
end

function SceneManager:addSceneFromFile(filename)
    LayerManager:removeAllLayers();
    if(self.activeScene) then self.activeScene:exit(); end
    -- should use the resource manager
    self.activeScene = dofile("resources/scenes/" .. filename);
    self.activeScene:enter();
end

return SceneManager
