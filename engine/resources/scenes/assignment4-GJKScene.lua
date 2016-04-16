local Scene = {}

local LayerManager = require("LayerManager");
local Factory = require("./Factory/Factory");
local Math = require("Math")
local UserDataManager = require("UserDataManager");
local GameVariables = require("GameVariables")

function Scene:update(dt)

end

local sceneObjs = {}

function Scene:free()
    MessageManager = nil;
    LayerManager = nil;
    Factory = nil;
    GameVariables = nil; 
end

function Scene.reset()
    sceneObjs = {}
end

local function removeLayers()
    LayerManager:removeAllLayers(); 
end

local function computeCSO(obj1, obj2)

end

local function addLayer(v)
    local layerKey = LayerManager:createLayerFromFile(v);
    local layer = LayerManager:getLayerByName(layerKey);

    -- add a bounding volume for each prop
    local allProps = layer:getAllProps();
    for index, prop in pairs(allProps) do 
        if prop.type == "Model" then
            prop:setLoc(300, 300, 300)
            local obj = Factory:create("Obj", {fileName = prop.fileName});
            obj.fileName = prop.fileName;
            obj.rotation = prop:getRot();
            obj.translation = prop:getLoc();
            obj.scale = prop:getScl();
            table.insert(sceneObjs, obj);
        end
    end
end

local function addLayers() 
    local layers = {}
    table.insert(layers, "bunnyLayer.lua");
    table.insert(layers, "horseLayer.lua");
    table.insert(layers, "GJKLayer.lua")

    -- for all layers
        -- for each prop in layer
            -- add an aabb to layer for prop
    for k, v in pairs(layers) do 
        addLayer(v);
    end

    local layer = LayerManager:getLayerByName("GJKLayer.lua")
    -- add the bounding volumes to the scene
    for k,obj in pairs(sceneObjs) do
        print("Creating an aabb for a scene obj")
        local newProp = Factory:create("AABB", {obj = obj, fileName = obj.fileName})
        newProp:setLoc(obj.translation.x, obj.translation.y, obj.translation.z);
        newProp:setScl(obj.scale.x, obj.scale.y, obj.scale.z);
        newProp:setRot(obj.rotation.z, obj.rotation.y, obj.rotation.z)
        layer:insertProp(newProp);
    end
end

function Scene:enter()
    addLayers();
    MOAIDebugLines.setStyle(MOAIDebugLines.PROP_MODEL_BOUNDS, 2, 1, 1, 1)
end

function Scene:exit()
    removeLayers();
end

return Scene