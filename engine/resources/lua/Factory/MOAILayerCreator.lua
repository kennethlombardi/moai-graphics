local MOAILayerCreator = require("./Factory/Creator"):new();
local Factory = nil;

-- MOAILayerCreator
function MOAILayerCreator:create(properties)
    local layer = require "MOAILayerPrototype";
    local newLayer = layer:allocate();
    local newMoaiLayer = MOAILayer.new();
    local newMoaiPartition = MOAIPartition.new();
    newMoaiLayer:setPartition(newMoaiPartition);
    newLayer:setUnderlyingType(newMoaiLayer);
    local propContainer = Factory:create("PropContainer");

    newLayer:setPropContainer(propContainer);
    for k,v in pairs(properties.propContainer) do 
        local newProp = Factory:create(v.type, v);
        if v.type == "Model" then
            newProp.fileName = v.fileName;
        end
        
        newLayer:insertProp(newProp);
    end
    
    -- viewport
    local windowManager = require "WindowManager";
    local screenWidth = windowManager.screenWidth;
    local screenHeight = windowManager.screenHeight;
    local newViewport = MOAIViewport.new();
    newViewport:setSize(screenWidth, screenHeight);
    newViewport:setScale(screenWidth, screenHeight);

    -- camera
    local newCamera = MOAICamera.new();
    newCamera:setFarPlane(25000);

    -- initialize the layer
    newLayer:setViewport(newViewport);
    newLayer:setCamera(newCamera);
    newLayer:setName(properties.name);
    newLayer:setType(properties.type);  
    newLayer:setVisible(properties.visible == "true");
    newLayer:setLoc(properties.position.x, properties.position.y, properties.position.z);

    -- scripts
    for k,scriptName in pairs(properties.scripts) do
        newLayer:registerScript(Factory:createFromFile("Script", scriptName))
    end

    return newLayer;
end

function MOAILayerCreator:createFromFile(fileName)
    dofile "Pickle.lua";
    local newObject;
    local objectIndex = 1;
    function deserialize(className, properties)
        local cucumber = unpickle(properties);
        newObject = Factory:create(cucumber.type, cucumber)
        objectIndex = objectIndex + 1;
    end
    local path = "../layers/"..fileName;
    dofile (path)
    if objectIndex > 2 then print("MORE THAN ONE LAYER IN LAYER FILE: "..path) end;
    return newObject;
end
--

function MOAILayerCreator:init(factory)
    Factory = factory;
    return  MOAILayerCreator;
end

return MOAILayerCreator