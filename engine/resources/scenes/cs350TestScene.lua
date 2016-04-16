local Scene = {}

local MessageManager = require("MessageManager");
local LayerManager = require("LayerManager");
local Factory = require("Factory");
local UserDataManager = require("UserDataManager");
local GameVariables = require("GameVariables");

function Scene:update(dt)
	local InputManager = require("InputManager");
    if InputManager:isKeyTriggered(require("InputManager").Key["esc"]) then
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
    LayerManager:createLayerFromFile("cs350TestLayer.lua");
end

function Scene:exit()
end

return Scene