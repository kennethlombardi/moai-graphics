local Scene = {}

local LayerManager = require("LayerManager");
local Factory = require("./Factory/Factory");
local UserDataManager = require("UserDataManager");
local GameVariables = require("GameVariables");
print("scene setup BVAlgorithm", UserDataManager:get("BVAlgorithm"))
GameVariables:set("BVAlgorithm", UserDataManager:get("BVAlgorithm"));

local boundingMethods = {
    "AABB",
    "SphereCentroid",
    "SphereRitter",
    "SphereLarsson",
    "SpherePCA",
    "OBBPCA"
    -- "EllipsoidPCA",
};

local currentBoundingMethod = GameVariables:get("BVAlgorithm");

function Scene:update(dt)

end

function Scene:free()
    MessageManager = nil;
    LayerManager = nil;
    Factory = nil;
    GameVariables = nil; 
end

local function addLayer(v)
    local layerKey = LayerManager:createLayerFromFile(v);
    local layer = LayerManager:getLayerByName(layerKey);
    local allProps = layer:getAllProps();
    local newProps = {}
    for index, prop in pairs(allProps) do 
        if prop.type == "Model" then
            local obj = Factory:create("Obj", {fileName = prop.fileName});
            obj.fileName = prop.fileName;
            local newProp = Factory:create(currentBoundingMethod, {obj = obj});

            -- match position
            local propPosition = prop:getLoc();
            newProp:setLoc(propPosition.x, propPosition.y, propPosition.z);

            -- match scale
            local propScale = prop:getScl();
            newProp:setScl(propScale.x, propScale.y, propScale.z)

            -- match rotation
            local propRotation = prop:getRot();
            newProp:setRot(propRotation.x, propRotation.y, propRotation.z);

            table.insert(newProps, newProp);
        end
    end
    for k,v in pairs(newProps) do
        layer:insertProp(v);
    end
end

local function addLayers() 
    local layers = {}
    -- table.insert(layers, "bunnyLayer.lua");
    table.insert(layers, "horseLayer.lua");
    table.insert(layers, "cs350HUDLayer.lua");
    -- table.insert(layers, "dragonLayer.lua");

    -- for all layers
        -- for each prop in layer
            -- add an aabb to layer for prop
    for k, v in pairs(layers) do 
        addLayer(v);
    end
end

local function removeLayers()
    LayerManager:removeAllLayers(); 
end

local numberKeys = {"1", "2", "3", "4", "5", "6", "7", "8", "9"}

function Scene.keyPressed(key)
    key = tonumber(key);
    if key == 9 then
        addLayer("dragonLayer.lua")
    else
        if key <= 0 then key = 1 end
        if key > #boundingMethods then key = #boundingMethods end
        currentBoundingMethod = boundingMethods[key];
        removeLayers();
        addLayers();
        print("Switching to: ", currentBoundingMethod);
        GameVariables:set("BVAlgorithm", currentBoundingMethod);
        UserDataManager:set("BVAlgorithm", currentBoundingMethod);
    end
end

function Scene:enter()
    MOAIDebugLines.setStyle ( MOAIDebugLines.PROP_MODEL_BOUNDS, 2, 1, 1, 1 )
    MOAIDebugLines.setStyle ( MOAIDebugLines.PROP_WORLD_BOUNDS, 1, 0.5, 0.5, 0.5 )
    addLayers();
    for k, v in pairs(numberKeys) do 
        require("MessageManager"):listen("KeyPressed_"..v, Scene.keyPressed);
    end
end

function Scene:exit()
    removeLayers();
end

return Scene