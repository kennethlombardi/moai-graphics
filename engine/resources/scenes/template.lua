local Scene = {}

local MessageManager = require("MessageManager");
local LayerManager = require("LayerManager");
local Factory = require("Factory");
local UserDataManager = require("UserDataManager");
local GameVariables = require("GameVariables");

function Scene:update(dt)
    if require("InputManager"):isKeyTriggered(require("InputManager").Key["esc"]) then
        MessageManager:send("QUIT");
    end
end

function Scene:free()
    MessageManager = nil;
    LayerManager = nil;
    Factory = nil;
    GameVariables = nil; 
end

function Scene:enter()

end

function Scene:exit()
    
end

MessageManager:listen("SPLASH_SCREEN", Scene.onSplashStart);

return Scene