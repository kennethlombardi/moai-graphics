local MOAILayerDDCreator = require("./Factory/Creator"):new();
local Factory = nil;

-- MOAILayerDDCreator
function MOAILayerDDCreator:create(properties)
    local layerdd = Factory:create("Layer", properties);
    layerdd:setCamera(MOAICamera2D.new());

    return layerdd;
end
--

return function(factory) 
    Factory = factory;
    return MOAILayerDDCreator;
end